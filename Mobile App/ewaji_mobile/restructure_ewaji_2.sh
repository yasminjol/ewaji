# In repo root
move() { [ -e "$1" ] && git mv "$1" "$2" || echo "⚠️  Skipped $1 (not found)"; }

# Home
mkdir -p lib/features/home/presentation
move lib/features/client/client_home_screen.dart \
     lib/features/home/presentation/home_screen.dart

# Inbox
mkdir -p lib/features/inbox/presentation
move lib/features/client/client_inbox_screen.dart \
     lib/features/inbox/presentation/inbox_screen.dart

# Appointments
mkdir -p lib/features/booking_management/presentation
move lib/features/client/client_appointments_screen.dart \
     lib/features/booking_management/presentation/appointments_screen.dart

# Profile → Settings
move lib/features/client/client_profile_screen.dart \
     lib/features/settings/presentation/profile_screen.dart

# Explore screens usually duplicate Discovery; delete if redundant
# rm lib/features/client/client_explore_screen.dart

# Remove empty client folder if nothing left
rmdir lib/features/client 2>/dev/null || true

# Stage & commit
git add .
git commit -m "chore(structure): final client-folder extraction"
git push
