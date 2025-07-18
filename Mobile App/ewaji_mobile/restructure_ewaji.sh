# ── 1. Core layer folders ──────────────────────────────────
mkdir -p lib/core/realtime
mkdir -p lib/core/i18n
mkdir -p lib/core/accessibility

# ── 2. Shared layer moves ─────────────────────────────────
git mv lib/core/theme lib/shared/theme
git mv lib/core/constants lib/shared/constants

# ── 3. Extract / rename feature roots ─────────────────────
git mv lib/features/client/onboarding lib/features/onboarding
git mv lib/features/client/notifications lib/features/notifications
git mv lib/features/client/settings lib/features/settings
git mv lib/features/provider lib/features/provider_dashboard
git mv lib/features/auth/provider_onboarding lib/features/provider_onboarding

# ── 4. Create empty provider + admin feature shells ───────
for f in service_management payouts noshow_compensation booking_management marketing upgrade; do
  mkdir -p lib/features/$f/{bloc,presentation,data}
done

for f in admin_vetting admin_disputes admin_cms admin_analytics; do
  mkdir -p lib/features/$f/{bloc,presentation,data}
done

# ── 5. Commit the structural refactor ─────────────────────
git add .
git commit -m "chore(structure): align folders with ewaji_feature_map"
