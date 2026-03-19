import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

/**
 * CondoKeep Daily Reminders
 *
 * This Edge Function runs daily (via cron) to:
 * 1. Update task statuses (upcoming → due → overdue)
 * 2. Send email reminders for tasks due soon
 * 3. Create Google Calendar events for upcoming tasks
 *
 * Environment variables required:
 * - SUPABASE_URL (auto-set)
 * - SUPABASE_SERVICE_ROLE_KEY (auto-set)
 * - RESEND_API_KEY (for email, sign up at resend.com)
 * - GOOGLE_CALENDAR_API_KEY (optional, for calendar integration)
 */

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

Deno.serve(async (req: Request) => {
  try {
    const today = new Date().toISOString().split("T")[0];

    // 1. Update statuses based on due dates
    // Mark overdue tasks
    const { error: overdueError } = await supabase
      .from("task_instances")
      .update({ status: "overdue" })
      .lt("due_date", today)
      .in("status", ["upcoming", "due"]);

    if (overdueError) console.error("Error updating overdue:", overdueError);

    // Mark tasks due within 3 days
    const threeDaysFromNow = new Date();
    threeDaysFromNow.setDate(threeDaysFromNow.getDate() + 3);
    const threeDaysStr = threeDaysFromNow.toISOString().split("T")[0];

    const { error: dueError } = await supabase
      .from("task_instances")
      .update({ status: "due" })
      .gte("due_date", today)
      .lte("due_date", threeDaysStr)
      .eq("status", "upcoming");

    if (dueError) console.error("Error updating due:", dueError);

    // Un-snooze tasks whose snooze period has passed
    const { error: snoozeError } = await supabase
      .from("task_instances")
      .update({ status: "upcoming", snoozed_until: null })
      .eq("status", "snoozed")
      .lte("snoozed_until", today);

    if (snoozeError) console.error("Error un-snoozing:", snoozeError);

    // 2. Get tasks that need reminders
    const { data: prefs } = await supabase
      .from("user_preferences")
      .select("*")
      .limit(1)
      .single();

    if (!prefs) {
      return new Response(JSON.stringify({ message: "No user preferences found" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    const reminderDate = new Date();
    reminderDate.setDate(reminderDate.getDate() + (prefs.reminder_days_before || 3));
    const reminderDateStr = reminderDate.toISOString().split("T")[0];

    // Get tasks due within the reminder window that haven't been reminded
    const { data: dueTasks } = await supabase
      .from("task_instances")
      .select("*, template:task_templates(name, description, estimated_minutes, category:categories(name, icon))")
      .in("status", ["due", "overdue", "upcoming"])
      .lte("due_date", reminderDateStr)
      .neq("status", "completed");

    // Filter out already-reminded tasks
    const { data: sentReminders } = await supabase
      .from("reminder_log")
      .select("task_instance_id")
      .gte("sent_at", new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString());

    const remindedIds = new Set((sentReminders || []).map((r) => r.task_instance_id));
    const tasksToRemind = (dueTasks || []).filter((t) => !remindedIds.has(t.id));

    let emailsSent = 0;

    // 3. Send email reminders via Resend
    if (prefs.email_notifications_enabled && prefs.email && tasksToRemind.length > 0) {
      const resendKey = Deno.env.get("RESEND_API_KEY");
      if (resendKey) {
        const taskList = tasksToRemind
          .map((t) => {
            const icon = t.template?.category?.icon || "📋";
            const name = t.template?.name || "Task";
            const mins = t.template?.estimated_minutes ? ` (${t.template.estimated_minutes} min)` : "";
            return `${icon} ${name}${mins} — due ${t.due_date}`;
          })
          .join("\n");

        const emailBody = `
Hey! You have ${tasksToRemind.length} condo maintenance task${tasksToRemind.length > 1 ? "s" : ""} coming up:

${taskList}

Open CondoKeep to manage your tasks.
        `.trim();

        try {
          const emailRes = await fetch("https://api.resend.com/emails", {
            method: "POST",
            headers: {
              Authorization: `Bearer ${resendKey}`,
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              from: "CondoKeep <onboarding@resend.dev>",
              to: prefs.email,
              subject: `🏢 CondoKeep: ${tasksToRemind.length} task${tasksToRemind.length > 1 ? "s" : ""} due soon`,
              text: emailBody,
            }),
          });

          if (emailRes.ok) {
            emailsSent = tasksToRemind.length;
            // Log the reminders
            const logs = tasksToRemind.map((t) => ({
              task_instance_id: t.id,
              reminder_type: "email",
            }));
            await supabase.from("reminder_log").insert(logs);
          } else {
            console.error("Resend error:", await emailRes.text());
          }
        } catch (e) {
          console.error("Email send failed:", e);
        }
      }
    }

    return new Response(
      JSON.stringify({
        message: "Daily maintenance check complete",
        updated: { overdue: !overdueError, due: !dueError, unsnoozed: !snoozeError },
        reminders: { tasksFound: tasksToRemind.length, emailsSent },
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
