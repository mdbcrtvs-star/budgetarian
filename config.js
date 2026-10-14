// Budgetarian settings. Paste your two Supabase values between the quotes.
// Supabase dashboard > Project Settings > API (or "Connect"):
//   supabaseUrl     = the "Project URL", e.g. https://abcdxyz.supabase.co
//   supabaseAnonKey = the "anon public" key (a long text starting with eyJ...)
// The anon key is meant to be public; your data is protected by the database rules in supabase.sql.
window.BUDGETARIAN_CONFIG = {
  supabaseUrl: "https://caozflkjmobifbvujybf.supabase.co",
  supabaseAnonKey: "sb_publishable_DKi6Edz6eYsE1jPTbrVNmA_H52PAxOe",

  // Premium payment (optional). Paste your payment link, e.g. a PayMongo payment link (GCash, Maya, cards).
  // Leave premiumPayUrl empty to show "Premium is coming soon" instead of the Upgrade button.
  premiumPayUrl: "",
  premiumPrice: "PHP 99 for your first month",   // shown on the button area, e.g. "PHP 49 per month"
  premiumNote: "Activation within 24 hours"     // optional extra line, e.g. "Activation within 24 hours"
};
