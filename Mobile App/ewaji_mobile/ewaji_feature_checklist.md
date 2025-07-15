

# ✅ **EWAJI Feature Checklist**

## 🌟 **CLIENT-SIDE FEATURES**

### 1. **Authentication & Onboarding**

* [ ] **Email, Phone, Google, Apple Authentication**
* [ ] Biometric (Face/Touch ID) Login
* [ ] Personalisation Wizard (optional)

  * [ ] Page 1: Desired services (multi-select, max 3: Braids, Locs, Barber, Wigs, Nails, Lashes)
  * [ ] Page 2: Budget selection (range slider: \$20–\$600)
  * [ ] Page 3: Distance preference (slider: 5–100 km or mi)
* [ ] Wizard skip option (defaults set: Budget = Any, Distance = 25 km, Services = None selected)

### 2. **Discovery & Personalisation**

* [ ] Personalised home feed (based on preferences or defaults)
* [ ] Service search (keyword, style, location)
* [ ] AI-driven hairstyle image-match search
* [ ] Browsable service categories & subcategories:

  * 🌀 **Braids**
  * 🔒 **Locs**
  * ✂️ **Barber**
  * 👩🏾‍🦱 **Wigs**
  * 💅🏽 **Nails**
  * 👁️ **Lashes**

### 3. **Provider Profiles & Listings**

* [ ] Service provider profiles (image/video carousel, verified badge)
* [ ] Service pricing (transparent breakdown)
* [ ] Service preparation checklists (pre-appointment requirements clearly listed)
* [ ] Real-time availability calendar integration
* [ ] Ratings and reviews (1–5⭐, with photo uploads, tags: neatness, vibe, speed)

### 4. **Booking & Payment**

* [ ] Instant booking & confirmation
* [ ] Secure deposits & escrow payments via Stripe
* [ ] Split-payment option (Pay-in-4 if eligible)
* [ ] Cancellation & reschedule policy enforcement
* [ ] Automated no-show handling & notifications
* [ ] Location-based dynamic ETA (optional)

### 5. **Notifications & Reminders**

* [ ] Push notifications (booking, prep-reminders 24h/2h before, review prompt)
* [ ] Email/SMS fallbacks

### 6. **Post-Service Experience**

* [ ] Photo-based reviews (before & after, optional)
* [ ] Review provider replies (one per review)

### 7. **Settings & Preferences**

* [ ] Edit personalisation preferences (service, budget, distance)
* [ ] Notification preferences (push, email, SMS)
* [ ] Dark mode & accessibility toggles

---

## 🎯 **PROVIDER-SIDE FEATURES**

### 1. **Provider Onboarding**

* [ ] Email & Phone verification
* [ ] Secure identity verification (KYC, ID upload)
* [ ] Service category selection (max 2 during onboarding; upgrade to add more later)

  * [ ] Initial selections limited strictly to two categories
  * [ ] Red notification badge on Dashboard "Upgrade" button
* [ ] Portfolio upload (photo/video examples)

### 2. **Dashboard & Schedule Management**

* [ ] Provider Dashboard with earning metrics, bookings overview
* [ ] Calendar integration (two-way sync: Google/Apple Calendar)
* [ ] Availability & gap-filler discounts (auto-discounts empty slots within 24h)

### 3. **Service Management**

* [ ] Activate/deactivate sub-services within selected primary categories
* [ ] Set price, duration, and additional prep information per sub-service
* [ ] Upgrade option to unlock additional primary categories beyond initial two

### 4. **Payments & Financials**

* [ ] Integrated payouts via Stripe Connect (next-day payouts)
* [ ] Automatic no-show compensation (GPS/manual check-in)
* [ ] Earnings and tax report generation (CSV/PDF exports)

### 5. **Client Management**

* [ ] Accept, decline, propose alternate booking times
* [ ] Auto-send service prep instructions upon confirmation
* [ ] Review management & single-time public replies per review
* [ ] Client rebooking & follow-up reminders

### 6. **Provider Marketing Toolkit**

* [ ] Promotional offers & discount codes
* [ ] "Boost" listings for higher visibility (paid add-on)
* [ ] SMS/email outreach to past clients

### 7. **Upgrade Flow**

* [ ] Visible upgrade button with persistent notification until additional categories added
* [ ] Guided flow to add more service categories (paywall logic implemented separately)

---

## ⚙️ **ADMIN & PLATFORM MANAGEMENT**

* [ ] Provider vetting console (approve/reject providers, document review)
* [ ] Dispute resolution workflow (chargebacks, refunds)
* [ ] Content management (FAQ, banners, policy updates)
* [ ] Analytics dashboard (GMV, client/provider retention, cohort analysis)
* [ ] Compliance & security (GDPR, PIPEDA, SOC-2 alignment)

---

## 🔧 **UNIVERSAL APP FEATURES & NFRs**

### **Cross-Functional Features**

* [ ] Real-time UI synchronization (Supabase Channels/Websockets)
* [ ] Internationalisation (EN/FR Canada, EN/ES US)
* [ ] Accessibility (VoiceOver/TalkBack compliance, dynamic scaling)
* [ ] Performance optimization (≤2s search latency, ≤5s booking confirmation)
* [ ] Security & data privacy (AES-256 encryption, secure storage, PCI SAQ-A compliance)

---

## 🛠️ **USER-FACING FILTERING OPTIONS (Universal)**

**Sort By**: Popular | Recent | Price: Low→High | Price: High→Low
**Filter By**:

* [ ] Ratings (4.5⭐+)
* [ ] Price range
* [ ] Availability (e.g., next 3 days, weekends)
* [ ] Distance radius
* [ ] Service duration
* [ ] Add-on compatibility

