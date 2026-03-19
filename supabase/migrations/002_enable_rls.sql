-- Row Level Security policies
-- Single-user personal app: anon access is sufficient
-- Swap for Supabase Auth policies if making multi-user

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.task_instances ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reminder_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow read access" ON public.categories FOR SELECT TO anon USING (true);
CREATE POLICY "Allow read access" ON public.task_templates FOR SELECT TO anon USING (true);
CREATE POLICY "Allow all access" ON public.task_instances FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow read access" ON public.user_preferences FOR SELECT TO anon USING (true);
CREATE POLICY "Allow update access" ON public.user_preferences FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "Allow read access" ON public.reminder_log FOR SELECT TO anon USING (true);
