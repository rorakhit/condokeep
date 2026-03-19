-- CondoKeep seed data
-- Condo-specific maintenance tasks (no yard, no balcony, baseboard heat + window AC)

INSERT INTO public.categories (name, icon, color) VALUES
  ('Appliance Maintenance', '🔧', '#3B82F6'),
  ('Deep Cleaning', '✨', '#8B5CF6'),
  ('Seasonal Prep', '🌡️', '#F59E0B');

-- APPLIANCE MAINTENANCE
INSERT INTO public.task_templates (category_id, name, description, frequency_days, difficulty, estimated_minutes, tips) VALUES
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Clean dishwasher filter', 'Remove and rinse the filter trap at the bottom of the dishwasher', 30, 'easy', 10,
   'Pull out the bottom rack, twist the filter counterclockwise, rinse under hot water. Run an empty cycle with vinegar after.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Descale coffee maker', 'Run a descaling solution or white vinegar through your coffee maker', 90, 'easy', 20,
   'Fill reservoir with equal parts white vinegar and water. Run a brew cycle, then run 2-3 cycles with plain water to rinse.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Clean washing machine', 'Run a cleaning cycle and wipe the gasket/drum', 30, 'easy', 15,
   'Run an empty hot cycle with 2 cups of white vinegar. Wipe the rubber gasket and detergent dispenser. Leave door open to air dry.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Clean dryer lint trap and vent', 'Deep clean the lint trap and check the vent hose', 90, 'easy', 15,
   'Wash the lint screen with soap and water (it gets coated with dryer sheet residue). Check the vent hose connection for lint buildup.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Clean range hood filter', 'Degrease and clean the range hood mesh filter', 60, 'easy', 20,
   'Soak the filter in hot water with dish soap and baking soda for 15 min. Scrub gently, rinse, and air dry.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Check smoke and CO detectors', 'Test all smoke and carbon monoxide detectors, replace batteries if needed', 180, 'easy', 10,
   'Press the test button on each unit. Replace batteries annually. Most units expire after 10 years — check the manufacture date on the back.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Clean refrigerator coils', 'Vacuum or brush the condenser coils on the back/bottom of the fridge', 180, 'medium', 20,
   'Unplug the fridge. Use a coil brush or vacuum with a crevice attachment. Dusty coils make your fridge work harder and use more energy.'),
  ((SELECT id FROM public.categories WHERE name = 'Appliance Maintenance'),
   'Flush garbage disposal', 'Deep clean and deodorize the garbage disposal', 30, 'easy', 5,
   'Drop in a few ice cubes and coarse salt, run the disposal. Follow with half a lemon. Finish with baking soda and vinegar.');

-- DEEP CLEANING
INSERT INTO public.task_templates (category_id, name, description, frequency_days, difficulty, estimated_minutes, tips) VALUES
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Deep clean oven', 'Run self-clean cycle or manually clean oven interior', 90, 'medium', 45,
   'If using self-clean: remove racks first, open windows. If manual: make a paste of baking soda and water, coat interior, leave overnight, wipe and spray with vinegar.'),
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Clean behind and under refrigerator', 'Pull fridge out and clean the floor and wall behind it', 180, 'medium', 30,
   'Unplug first. Pull out carefully (put cardboard under feet to protect flooring). Vacuum and mop the floor. Wipe down the back of the fridge.'),
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Wash curtains and window treatments', 'Launder or steam clean all curtains and blinds', 180, 'medium', 60,
   'Check care labels — most curtains can go in the washer on gentle/cold. For blinds, wipe each slat with a damp cloth or use the bathtub soak method.'),
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Deep clean bathroom grout', 'Scrub tile grout in bathroom(s)', 90, 'medium', 45,
   'Make a paste of baking soda and hydrogen peroxide. Apply to grout lines, let sit 10 min, scrub with an old toothbrush. Rinse well.'),
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Clean and organize under sinks', 'Clear out, wipe down, and reorganize under kitchen and bathroom sinks', 90, 'easy', 30,
   'Check for leaks while everything is out. Wipe down surfaces. Toss expired products. Consider shelf organizers to maximize space.'),
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Vacuum mattress and flip/rotate', 'Vacuum your mattress surface and rotate it 180 degrees', 90, 'easy', 15,
   'Vacuum with upholstery attachment to remove dust mites. Sprinkle baking soda, let sit 30 min, vacuum again. Rotate head-to-foot.'),
  ((SELECT id FROM public.categories WHERE name = 'Deep Cleaning'),
   'Clean all light fixtures and ceiling fans', 'Dust and wipe down light fixtures, lampshades, and ceiling fans', 90, 'easy', 30,
   'Use a damp microfiber cloth. For ceiling fan blades, slide a pillowcase over each blade to catch dust. Clean glass fixtures with vinegar solution.');

-- SEASONAL PREP
INSERT INTO public.task_templates (category_id, name, description, frequency_days, difficulty, estimated_minutes, tips) VALUES
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Install window AC units', 'Install and set up window AC units for summer', 365, 'hard', 45,
   'Clean the filters before installing. Check the window seal/foam for gaps. Make sure the unit tilts slightly outward for drainage. Use brackets for safety.'),
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Remove and store window AC units', 'Remove AC units and store for winter', 365, 'hard', 45,
   'Drain any water first. Clean filters and let dry completely before storing. Cover the unit. Seal the window properly for winter.'),
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Clean window AC filters', 'Remove and wash the air filters on your window AC units', 30, 'easy', 10,
   'Pull out the filter panel. Wash with warm soapy water. Let dry completely before reinstalling. Do this monthly during AC season.'),
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Bleed baseboard radiators', 'Release trapped air from baseboard heaters before heating season', 365, 'easy', 20,
   'Use a radiator key to open the bleed valve slightly. Hold a cloth underneath. Close when water starts coming out steadily (no more air sputtering).'),
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Check window seals and weatherstripping', 'Inspect all windows for drafts and worn seals', 365, 'easy', 30,
   'Hold a lit candle near window edges on a windy day — flickering means drafts. Replace adhesive weatherstripping as needed. Caulk any gaps.'),
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Vacuum baseboard heaters', 'Remove covers and vacuum dust from baseboard heating elements', 180, 'easy', 30,
   'Turn off heat first and let cool. Remove the front covers. Vacuum fins carefully with a brush attachment. Dusty fins = less efficient heating.'),
  ((SELECT id FROM public.categories WHERE name = 'Seasonal Prep'),
   'Deep clean window tracks and screens', 'Clean window tracks, screens, and glass inside and out (where accessible)', 180, 'medium', 45,
   'Vacuum tracks first, then scrub with an old toothbrush and soapy water. Remove screens and hose them down. Clean glass with vinegar solution.');

-- Generate initial task instances
INSERT INTO public.task_instances (template_id, due_date, status)
SELECT id, CURRENT_DATE + (frequency_days * INTERVAL '1 day'), 'upcoming'
FROM public.task_templates WHERE is_active = true;

-- Set some tasks as due sooner (things you probably haven't done recently)
UPDATE public.task_instances
SET due_date = CURRENT_DATE + INTERVAL '7 days'
WHERE template_id IN (
  SELECT id FROM public.task_templates
  WHERE name IN ('Clean dishwasher filter', 'Clean washing machine', 'Flush garbage disposal')
);

UPDATE public.task_instances
SET due_date = CURRENT_DATE + INTERVAL '14 days'
WHERE template_id IN (
  SELECT id FROM public.task_templates WHERE name = 'Check smoke and CO detectors'
);

-- Default user preferences (update email as needed)
INSERT INTO public.user_preferences (email, google_calendar_enabled, email_notifications_enabled, reminder_days_before)
VALUES ('your-email@example.com', true, true, 3);
