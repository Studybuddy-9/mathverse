# Connect StudyBuddy to Supabase

StudyBuddy is a static GitHub Pages site. This integration uses the Supabase JavaScript client in the browser, Supabase Auth for student accounts, and Postgres tables protected by Row Level Security (RLS).

## 1. Create a Supabase project

1. Open the Supabase dashboard and create a project.
2. Open the project's SQL Editor.
3. Open `supabase/schema.sql` from this repository, copy the full contents, paste it into the SQL Editor, and run it.
4. In the project settings / Connect dialog, copy the **Project URL** and the **publishable key**. A legacy `anon` key is also accepted.
5. Open **Authentication → URL Configuration** and set the Site URL to your deployed StudyBuddy website address. Add that same address to the allowed Redirect URLs so confirmation links can return to your site.

## 2. Connect StudyBuddy

1. Open the deployed StudyBuddy site and go to **Student Profile**.
2. Expand **Enter Supabase project details**.
3. Paste the Project URL and publishable/anon key, then choose **Save and connect**.
4. Save your student name, then create a sync account or sign in.
5. Use the same account on another device to load the cloud-saved profile, practice history and planner tasks.

Supabase may require email confirmation depending on the project's Authentication settings. When confirmation is enabled, open the confirmation message and then return to StudyBuddy to sign in.

## 3. Security notes

- The browser uses only the project's publishable key (or legacy anon key). These keys are designed for client-side use when RLS is enabled.
- **Never put a Supabase secret key or legacy `service_role` key in this website, GitHub, or browser storage.** Those keys bypass the protections intended for browser clients.
- The SQL enables RLS on every table and limits each account to rows whose owner matches `auth.uid()`.
- Project URL and publishable/anon key are stored in this browser's local storage so the connection can be restored after a refresh. They are not authentication passwords.
- Your password is handled by Supabase Auth and is not saved in StudyBuddy's own profile fields.
- Until you connect a project and sign in, the app continues to use browser-local storage.

## Tables created

- `profiles`: one display name per authenticated account.
- `study_sessions`: study-time records, ready for session tracking.
- `practice_events`: submitted practice answers used by Progress Analytics.
- `planner_tasks`: custom study planner tasks and completion state.

## Troubleshooting

- **"Database not connected"**: check the Project URL and key, then reload the page.
- **"Could not sync" / missing table**: run the complete `supabase/schema.sql` script in the SQL Editor.
- **Sign-up asks for confirmation**: confirm the email first, then sign in.
- **Data stays on one device**: make sure you signed into the same account on both devices and that the database status says syncing is active.
- **Permission denied**: verify that the schema was run completely and that RLS policies and table grants were created.

Supabase JavaScript client reference: https://supabase.com/docs/reference/javascript/initializing
