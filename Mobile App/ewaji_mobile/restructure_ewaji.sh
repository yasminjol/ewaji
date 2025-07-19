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

# ── 6. Helper function to skip missing paths ─────────────
move() { [ -e "$1" ] && git mv "$1" "$2" \
      && echo "moved $1 → $2" || echo "⚠️  skipped $1"; }

# ── 7. Relocate remaining client screens ─────────────────
# ----  Home screen  -------------------------------------------------
mkdir -p lib/features/home/presentation
move lib/features/client/client_home_screen.dart \
     lib/features/home/presentation/home_screen.dart

# ----  Inbox screen  ------------------------------------------------
mkdir -p lib/features/inbox/presentation
move lib/features/client/client_inbox_screen.dart \
     lib/features/inbox/presentation/inbox_screen.dart

# ----  Appointments  (booking management)  -------------------------
mkdir -p lib/features/booking_management/presentation
move lib/features/client/client_appointments_screen.dart \
     lib/features/booking_management/presentation/appointments_screen.dart

# ----  Profile  (settings)  ----------------------------------------
mkdir -p lib/features/settings/presentation
move lib/features/client/client_profile_screen.dart \
     lib/features/settings/presentation/profile_screen.dart

# ----  Explore screen  ---------------------------------------------
# If Explore == Discovery, just delete it; otherwise choose a proper feature.
rm lib/features/client/client_explore_screen.dart 2>/dev/null || true

# ----  Remove now-empty folder (ignore error if not empty) ----------
rmdir lib/features/client 2>/dev/null || echo "client folder not empty—check manually"

# ── 8. Update imports in affected files ──────────────────
# This will require manual updates to import statements

# ── 9. Commit the final structural refactor ──────────────
git add .
git commit -m "chore(structure): remove client folder & relocate screens"
