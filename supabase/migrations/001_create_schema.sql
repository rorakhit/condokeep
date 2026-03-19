-- CondoKeep Schema
-- Task categories for organizing maintenance tasks
CREATE TABLE public.categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  icon text,
  color text,
  created_at timestamptz DEFAULT now()
);

-- Master list of maintenance task templates
CREATE TABLE public.task_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES public.categories(id) ON DELETE SET NULL,
  name text NOT NULL,
  description text,
  frequency_days int NOT NULL,
  difficulty text CHECK (difficulty IN ('easy', 'medium', 'hard')) DEFAULT 'easy',
  estimated_minutes int,
  tips text,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Actual scheduled task instances (generated from templates)
CREATE TABLE public.task_instances (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id uuid REFERENCES public.task_templates(id) ON DELETE CASCADE NOT NULL,
  due_date date NOT NULL,
  completed_at timestamptz,
  snoozed_until date,
  status text CHECK (status IN ('upcoming', 'due', 'overdue', 'completed', 'snoozed')) DEFAULT 'upcoming',
  notes text,
  created_at timestamptz DEFAULT now()
);

-- User preferences for notifications
CREATE TABLE public.user_preferences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text,
  google_calendar_enabled boolean DEFAULT true,
  email_notifications_enabled boolean DEFAULT true,
  reminder_days_before int DEFAULT 3,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Log of reminders sent (prevents duplicates)
CREATE TABLE public.reminder_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  task_instance_id uuid REFERENCES public.task_instances(id) ON DELETE CASCADE NOT NULL,
  reminder_type text CHECK (reminder_type IN ('email', 'calendar')) NOT NULL,
  sent_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_task_instances_status ON public.task_instances(status);
CREATE INDEX idx_task_instances_due_date ON public.task_instances(due_date);
CREATE INDEX idx_task_instances_template ON public.task_instances(template_id);
