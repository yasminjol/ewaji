lib/
├── core/                       # universal, app-wide services & helpers
│   ├── models/
│   ├── services/
│   ├── realtime/
│   ├── i18n/
│   └── accessibility/
├── shared/                     # design-system widgets, theme, constants
│   ├── widgets/
│   ├── theme/
│   └── constants.dart
└── features/                   # one sub-folder per business feature
    ├── auth/                  # C-01-A/B  (email/phone/OAuth, biometric)
    ├── onboarding/            # C-01-C  Personalisation Wizard
    ├── discovery/             # C-02-A/B  Feed, search, AI image match
    ├── service_detail/        # C-03-A/B/C  Provider profile, pricing
    ├── booking/               # C-04-A/B/C  Booking + payment + no-show
    ├── notifications/         # C-05-A  Push/SMS/email hub
    ├── reviews/               # C-06-A  Photo reviews & replies
    ├── settings/              # C-07-A  Client settings & prefs
    │
    ├── provider_onboarding/   # P-01-A/B/C  Reg, KYC, 2-category pick
    ├── provider_dashboard/    # P-02-A/B/C  Calendar + gap-filler
    ├── service_management/    # P-03-A  Price & duration editor
    ├── payouts/               # P-04-A  Stripe Connect payouts
    ├── noshow_compensation/   # P-04-B  GPS check-in & payout trigger
    ├── booking_management/    # P-05-A  Accept/decline/reschedule
    ├── marketing/             # P-06-A  Promo codes, boosts
    ├── upgrade/               # P-07-A  Add 3rd+ category flow
    │
    ├── admin_vetting/         # A-01-A  Provider vetting console
    ├── admin_disputes/        # A-02-A  Chargeback & refunds
    ├── admin_cms/             # A-03-A  FAQ / banner CMS
    └── admin_analytics/       # A-04-A  GMV & retention dashboards
