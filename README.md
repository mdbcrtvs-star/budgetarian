# Budgetarian

Budget every sahod: per-cutoff budgeting, spending tracking and bank reconciliation.

This folder is the stand-alone web app. Once it's on GitHub Pages and connected to Supabase,
anyone can open it in a browser, create an account, and add it to their home screen.

## Setup (all doable from a phone)

### A. Put the app online (GitHub Pages)
1. Go to **github.com** and create a free account.
2. Tap **+** (top right) > **New repository**. Name it `budgetarian`, set it to **Public**, tick **Add a README file**, then **Create repository**.
3. In the repository, tap **Add file > Upload files**. Upload every file and folder from this project
   (`index.html`, `config.js`, `manifest.webmanifest`, `sw.js`, `version.json`, `privacy.html`, `supabase.sql`, `README.md`, and the `icons` and `vendor` folders). Tap **Commit changes**.
   - If your phone can't upload folders, create them by uploading with the folder name in the file name box, e.g. `icons/icon-192.png`.
4. Tap **Settings > Pages**. Under **Branch**, choose `main` and `/ (root)`, then **Save**.
5. After a minute or two the page shows your link, like `https://YOUR-NAME.github.io/budgetarian/`. Keep it.

### B. Set up login and the database (Supabase)
1. Go to **supabase.com**, sign up (you can use your GitHub account), and tap **New project**.
   Name it `budgetarian`, set a database password (save it somewhere safe), pick the region **Southeast Asia (Singapore)**, and create it.
2. Open **SQL Editor > New query**. Paste everything from `supabase.sql`, then tap **Run**. You should see "Success".
3. Open **Authentication > URL Configuration**:
   - **Site URL:** your GitHub Pages link from step A5.
   - **Redirect URLs:** add the same link.
4. Open **Project Settings > API** (or the **Connect** button). Copy the **Project URL** and the **anon public** key.

### C. Connect the two
1. Back on GitHub, open `config.js`, tap the pencil (Edit), and paste the two values between the quotes.
2. Tap **Commit changes**. Wait a minute, then open your link.
3. Create your account, confirm the email, log in. Done!

### D. Accept payments (free to set up)
Premium is PHP 99 for the first month (already set in `config.js`; change the text anytime).
You only need ONE of these two options.

**Option 1: PayMongo payment link (looks professional, small fee per payment)**
1. Go to **paymongo.com** > **Sign up**. It's free, no monthly fee.
2. Choose business type **Individual (Unregistered)**. You'll need a valid ID, a selfie check,
   your bank account for payouts, and an active Facebook or Instagram page.
3. Once approved, open **Payment Links > Create link**. Amount: **99**. Description: `Budgetarian Premium - 1 month`.
4. Copy the link. On GitHub, edit `config.js` and paste it into `premiumPayUrl`. Commit.
   The **Upgrade to Premium** button in Settings now opens your link.
   People pay with GCash, Maya or any bank app through QR Ph (about 1.3% fee, roughly PHP 1.30 per 99).

**Option 2: Your own GCash QR (zero fees, more manual)**
1. In GCash, open **Profile > My QR code** and save the image.
2. On GitHub, upload it as `pay.png`. In `config.js` set `premiumPayUrl: "pay.png"`. Commit.
3. Set `premiumNote` to something like `Send your GCash reference number to (your FB page)`.

### E. Switch on Premium after someone pays
1. Check that the payment arrived (PayMongo dashboard or GCash history). Match the email they used.
2. In Supabase, open **Authentication > Users**, find that email, copy their **User UID**.
3. Open **Table Editor > entitlements > Insert row**: paste the UID into `user_id`, set `premium` to **true**,
   set `expires_at` to one month from today, and **Save**.
4. Tell them to tap **I've paid, check again** in Settings. It shows "Premium is active" and their budget starts syncing.
When the month ends, Premium stops on its own. If they pay again, move `expires_at` another month ahead.
Their budget always stays on their phone, Premium or not.

### F. Releasing a new version (people keep their data)
1. Upload the changed `index.html` (and any other changed files) to GitHub.
2. In `index.html` change `APP_VERSION="1.0.0"` to the new number, e.g. `1.0.1`.
3. Edit `version.json` to the SAME number: `{"version": "1.0.1"}`. Commit.
4. Within the hour (or when they reopen the app), users see a teal **"New version ready - Update now"** bar.
   They can also tap **Settings > About > Check for updates**. Updating never touches their budget data.

## Before inviting others
- Fill in the placeholders in `privacy.html` ([DATE], [YOUR FULL NAME], [YOUR CONTACT EMAIL]).
- Supabase's built-in email sender has a low hourly limit, fine for testing with a few friends.
  For more users, set up a custom email sender (Authentication > Emails > SMTP).

## Files
| File | What it is |
|---|---|
| `index.html` | The app |
| `config.js` | Your Supabase connection (the only file you edit) |
| `supabase.sql` | Database table and privacy rules, run once |
| `manifest.webmanifest`, `icons/` | Makes it installable on a home screen |
| `sw.js` | Lets the app open offline |
| `version.json` | Latest version number; the app checks it to offer updates |
| `privacy.html` | Privacy policy (needed for Google Play) |
| `vendor/` | Supabase and Excel libraries |
