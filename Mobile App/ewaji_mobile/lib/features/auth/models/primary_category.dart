/// Primary service categories for provider onboarding
enum PrimaryCategory {
  braids,  // 🌀 Braids
  locs,    // 🔒 Locs
  barber,  // ✂️ Barber
  wigs,    // 👩🏾‍🦱 Wigs
  nails,   // 💅🏽 Nails
  lashes,  // 👁️ Lashes
}

/// Extension to provide display properties for each category
extension PrimaryCategoryExtension on PrimaryCategory {
  String get emoji {
    switch (this) {
      case PrimaryCategory.braids:
        return '🌀';
      case PrimaryCategory.locs:
        return '🔒';
      case PrimaryCategory.barber:
        return '✂️';
      case PrimaryCategory.wigs:
        return '👩🏾‍🦱';
      case PrimaryCategory.nails:
        return '💅🏽';
      case PrimaryCategory.lashes:
        return '👁️';
    }
  }

  String get label {
    switch (this) {
      case PrimaryCategory.braids:
        return 'Braids';
      case PrimaryCategory.locs:
        return 'Locs';
      case PrimaryCategory.barber:
        return 'Barber';
      case PrimaryCategory.wigs:
        return 'Wigs';
      case PrimaryCategory.nails:
        return 'Nails';
      case PrimaryCategory.lashes:
        return 'Lashes';
    }
  }

  String get displayName => '$emoji $label';
}

/// Full hierarchical service tree (depth ≤ 3) — *not rendered in category selector*.
/// Used for later service activation in dashboard.
const Map<PrimaryCategory, Map<String, List<String>>> kServiceTree = {
  PrimaryCategory.braids: {
    'Twists': [
      'Passion Twists',
      'Senegalese Twists',
      'Marley Twists',
      'Kinky Twists'
    ],
    'Boho Braids': ['Boho Knotless', 'Boho Feed-in', 'Boho Twists'],
    'Scalp Braids': [
      'Cornrows',
      'Lemonade Braids',
      'Fulani Braids',
      'Stitch Braids',
      'Feed-in Braids',
      'Tribal Braids'
    ],
    'Individual Braids': [
      'Knotless Braids',
      'Box Braids',
      'Jumbo Braids',
      'Triangle Parts',
      'Waist-Length Braids',
      'Small/Medium/Large Braids'
    ],
  },
  PrimaryCategory.locs: {
    'Faux Locs': [
      'Butterfly Locs',
      'Goddess Locs',
      'Soft Locs',
      'Crochet Faux Locs'
    ],
    'Starter Locs': ['Coil Method', 'Two-Strand Twist', 'Interlocking'],
    'Loc Maintenance': [
      'Retwist',
      'Style Only',
      'Loc Detox',
      'Loc Coloring'
    ],
    'Permanent Locs': [
      'Microlocs',
      'Sisterlocks',
      'Freeform Locs'
    ],
  },
  PrimaryCategory.barber: {
    'Haircuts': [
      'Fade (Low, Mid, High)',
      'Taper',
      'Shape-Up / Line-Up',
      'Bald Cut',
      'Scissor Cut'
    ],
    'Beard & Grooming': [
      'Beard Trim',
      'Hot Towel Shave',
      'Beard Sculpting'
    ],
    'Kids Cuts': ['Basic Fade', 'Design Cut', 'Afro Trim'],
    'Add-ons': [
      'Hair Dye',
      'Wash + Style',
      'Designs (parting, patterns)'
    ],
  },
  PrimaryCategory.wigs: {
    'Install Services': [
      'Frontal Install',
      'Closure Install',
      'Glueless Install',
      '360 Wig Install'
    ],
    'Wig Styling': [
      'Curling',
      'Straightening',
      'Layer Cutting',
      'Ponytail Style'
    ],
    'Custom Wig Making': [
      'Sewing Custom Units',
      'Machine-Made Units',
      'Colored Units',
      'HD Lace Units'
    ],
    'Maintenance': [
      'Wig Revamp',
      'Deep Wash & Condition',
      'Lace Replacement'
    ],
  },
  PrimaryCategory.nails: {
    'Acrylic Services': [
      'Full Set (Regular, Long, Short)',
      'Refill',
      'Acrylic Toes'
    ],
    'Gel Services': ['Gel Overlay', 'Gel Polish Only', 'Gel Extensions'],
    'Natural Nail Care': [
      'Classic Manicure',
      'French Tips',
      'Cuticle Treatment'
    ],
    'Add-ons & Art': [
      'Nail Art (simple, abstract, 3D)',
      'Chrome Finish',
      'Matte Finish',
      'Rhinestones',
      'Stickers / Press-ons'
    ],
  },
  PrimaryCategory.lashes: {
    'Lash Extensions': ['Classic', 'Hybrid', 'Volume', 'Mega Volume'],
    'Lash Lift & Tint': [
      'Lash Lifting',
      'Lash Tinting',
      'Keratin Treatment'
    ],
    'Lash Removal & Maint': [
      'Lash Removal',
      'Refill (2-3 weeks)',
      'Deep Cleanse'
    ],
    'Brow Combo Services': [
      'Brow Tint',
      'Brow Shaping',
      'Brow Lamination'
    ],
  },
};
