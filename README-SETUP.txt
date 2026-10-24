SHRINIVAS MEDICAL AND GENERAL STORE — WEBSITE STARTER
=====================================================

FILES
-----
index.html              Customer-facing product listing
admin.html              Admin login and product management page
supabase-config.js      Your Supabase Project URL and publishable key
supabase-setup.sql      Reference setup script (do not rerun on an already configured DB)
README-SETUP.txt        This guide

IMPORTANT: THIS IS A STARTER
----------------------------
This starter provides a product catalogue and an admin dashboard for adding,
editing, and deleting products. It does not process payments or customer orders.
For a pharmacy/medical store, do not publish prescription medicines for sale
or provide medical advice through this simple starter without the appropriate
legal, licensing, privacy, and operational review.

1. CONFIGURE SUPABASE
---------------------
Open supabase-config.js in a text editor.

Replace:
  YOUR_SUPABASE_PROJECT_URL
  YOUR_SUPABASE_PUBLISHABLE_KEY

with the Project URL and publishable key from your NEW Mumbai Supabase project.
Keep the quotation marks. Do NOT use a service_role key or secret key in browser
code or in GitHub.

2. DATABASE
-----------
You said you already ran the SQL setup script in your new Mumbai project and
verified the products and store_admins tables. If so, do not run the SQL script
again unless you have reviewed the existing schema and policies.

3. ADMIN USER
-------------
Create the user in Supabase Dashboard > Authentication > Users.
Then add that user's UUID to store_admins, using SQL:

  INSERT INTO public.store_admins (user_id)
  VALUES ('YOUR_NEW_AUTH_USER_UUID');

Use the UUID from the NEW Mumbai project, not the old Japan project.

4. TEST LOCALLY
---------------
For a quick test, open index.html in a browser after setting up the config.
Some browser configurations restrict local scripts; if it fails, deploy to a
static host or use a local web server. Test admin.html using your admin account.

5. UPLOAD TO GITHUB
------------------
Extract this ZIP. In your GitHub repository, choose Add file > Upload files.
Upload index.html, admin.html, supabase-config.js, supabase-setup.sql, and this
README at the repository root (not the ZIP file itself). Commit the changes.

6. DEPLOYMENT
-------------
GitHub Pages can host static files, but this is a starter, not a full commerce
platform. Confirm authentication, RLS policies, and admin CRUD are working
before sharing the site publicly. Keep secret keys and database passwords out
of the repository.

7. SECURITY CHECKS
------------------
- Never put service_role/secret keys in frontend files.
- Ensure Row Level Security is enabled for products and store_admins.
- Verify anonymous users can read only active products and cannot write.
- Verify a signed-in non-admin cannot add/edit/delete products.
- Use strong unique passwords and enable suitable account security.
