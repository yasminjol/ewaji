# ── 1. Core layer folders (DONE) ──────────────────────────
# mkdir -p lib/core/realtime
# mkdir -p lib/core/i18n
# mkdir -p lib/core/accessibility

# ── 2. Extract actual client features ─────────────────────
# Extract personalisation from client to onboarding
mkdir -p lib/features/onboarding
git mv lib/features/client/cubit lib/features/onboarding/cubit
git mv lib/features/client/models lib/features/onboarding/models
git mv lib/features/client/screens/personalisation_* lib/features/onboarding/screens/
git mv lib/features/client/widgets lib/features/onboarding/widgets

# Extract settings from client
mkdir -p lib/features/settings
mkdir -p lib/features/settings/presentation

# Move notification service from core to features
mkdir -p lib/features/notifications
git mv lib/core/services/notification_service.dart lib/features/notifications/
git mv lib/core/utils/notification_permissions.dart lib/features/notifications/

# ── 3. Extract provider onboarding from auth ─────────────
mkdir -p lib/features/provider_onboarding
git mv lib/features/auth/screens/provider_* lib/features/provider_onboarding/screens/
git mv lib/features/auth/provider_login_screen*.dart lib/features/provider_onboarding/

# ── 4. Feature shells already created (DONE) ──────────────
# for f in service_management payouts noshow_compensation booking_management marketing upgrade; do
#   mkdir -p lib/features/$f/{bloc,presentation,data}
# done

# for f in admin_vetting admin_disputes admin_cms admin_analytics; do
#   mkdir -p lib/features/$f/{bloc,presentation,data}
# done

# ── 5. Create barrel files and indexes ───────────────────
echo "export 'cubit/personalisation_cubit.dart';" > lib/features/onboarding/onboarding.dart
echo "export 'models/user_preferences.dart';" >> lib/features/onboarding/onboarding.dart

echo "export 'notification_service.dart';" > lib/features/notifications/notifications.dart

echo "export 'screens/provider_category_selection_screen_step2.dart';" > lib/features/provider_onboarding/provider_onboarding.dart

# ── 6. Update imports in affected files ──────────────────
# This will require manual updates to import statements

# ── 7. Commit the corrected structural refactor ──────────
git add .
git commit -m "chore(structure): align folders with ewaji_feature_map"
