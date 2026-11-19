# StudyBuddy shared Supabase database

StudyBuddy uses one centrally configured Supabase project for all students. Students do **not** need their own Supabase projects, dashboard accounts, Project URLs, or API keys.

## 1. Database setup (project owner)

1. Open the Supabase dashboard for the StudyBuddy project.
2. Open **SQL Editor**.
3. Run the complete contents of `supabase/schema.sql`.
4. In **Authentication → URL Configuration**, set the Site URL to the deployed StudyBuddy website address.
5. Add the deployed StudyBuddy website address to the allowed Redirect URLs.

The website's shared Project URL and browser-safe publishable key are configured in `index.html`. If the project is ever replaced, update those two constants there and commit the change.

## 2. How students use StudyBuddy

1. Open the deployed StudyBuddy website.
2. Go to **Student Profile** and save a student name.
3. Enter an email address and create a StudyBuddy sync account, or sign in to an existing account.
4. If Supabase email confirmation is enabled, confirm the email using the message sent by Supabase, then return to StudyBuddy and sign in.
5. Sign in with the same account on another device to access that account's cloud-synced profile, practice history, and planner tasks.

Every student uses the same Supabase project, but each account has its own authenticated user ID. StudyBuddy associates each student's database rows with that ID.

## 3. Security

- The website uses only the Supabase **publishable** key. A publishable key is designed to be included in browser code; it is not a password.
- Never put a Supabase **secret** key or legacy `service_role` key in website code, GitHub, or browser storage.
- Row Level Security (RLS) is enabled on the student-data tables. Policies require the authenticated user's ID to match the row owner.
- Students should use separate accounts and should not share their passwords.
- Supabase Auth handles account passwords.

## Tables

- `profiles`: one display name per authenticated account.
- `study_sessions`: study-time records.
- `practice_events`: submitted practice answers used by Progress Analytics.
- `planner_tasks`: custom study planner tasks and completion state.

## Troubleshooting

- **Database connection fails:** check that the shared Project URL and publishable key in `index.html` belong to the same Supabase project.
- **Missing table or permission error:** run the complete `supabase/schema.sql` script and confirm the RLS policies exist.
- **Sign-up asks for confirmation:** confirm the email first, then sign in.
- **Data does not appear on another device:** sign in using the same StudyBuddy account on both devices.
- **Email confirmation does not return to the site:** check the Site URL and allowed Redirect URLs under **Authentication → URL Configuration**.

Supabase JavaScript client reference: https://supabase.com/docs/reference/javascript/initializing
