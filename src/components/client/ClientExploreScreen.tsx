
import { useState } from "react";
import { Search, Filter, ArrowLeft, Star, Heart, MapPin } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const ClientExploreScreen = () => {
  const [searchQuery, setSearchQuery] = useState("");
  const [activeCategory, setActiveCategory] = useState("Braids");
  const [selectedSubcategories, setSelectedSubcategories] = useState<string[]>([]);
  const [showProviders, setShowProviders] = useState(false);

  const categories = [
    "Braids", "Locs", "Barber", "Wigs", "Nails", "Lashes"
  ];

  const subcategories: Record<string, any> = {
    "Braids": {
      "Twists": ["Passion Twists", "Senegalese Twists", "Marley Twists", "Kinky Twists"],
      "Boho Braids": ["Boho Knotless", "Boho Feed-in", "Boho Twists"],
      "Scalp Braids": ["Cornrows", "Lemonade Braids", "Fulani Braids", "Stitch Braids", "Feed-in Braids", "Tribal Braids"],
      "Individual Braids": ["Knotless Braids", "Box Braids", "Jumbo Braids", "Triangle Parts", "Waist-Length Braids", "Small/Medium/Large Braids"]
    },
    "Locs": {
      "Faux Locs": ["Butterfly Locs", "Goddess Locs", "Soft Locs", "Crochet Faux Locs"],
      "Starter Locs": ["Coil Method", "Two-Strand Twist", "Interlocking"],
      "Loc Maintenance": ["Retwist", "Style Only", "Loc Detox", "Loc Coloring"],
      "Permanent Locs": ["Microlocs", "Sisterlocks", "Freeform Locs"]
    },
    "Barber": {
      "Haircuts": ["Fade (Low, Mid, High)", "Taper", "Shape-Up / Line-Up", "Bald Cut", "Scissor Cut"],
      "Beard & Grooming": ["Beard Trim", "Hot Towel Shave", "Beard Sculpting"],
      "Kids Cuts": ["Basic Fade", "Design Cut", "Afro Trim"],
      "Add-ons": ["Hair Dye", "Wash + Style", "Designs (parting, patterns)"]
    },
    "Wigs": {
      "Install Services": ["Frontal Install", "Closure Install", "Glueless Install", "360 Wig Install"],
      "Wig Styling": ["Curling", "Straightening", "Layer Cutting", "Ponytail Style"],
      "Custom Wig Making": ["Sewing Custom Units", "Machine-Made Units", "Colored Units", "HD Lace Units"],
      "Maintenance": ["Wig Revamp", "Deep Wash & Condition", "Lace Replacement"]
    },
    "Nails": {
      "Acrylic Services": ["Full Set (Regular, Long, Short)", "Refill", "Acrylic Toes"],
      "Gel Services": ["Gel Overlay", "Gel Polish Only", "Gel Extensions"],
      "Natural Nail Care": ["Classic Manicure", "French Tips", "Cuticle Treatment"],
      "Add-ons & Art": ["Nail Art (simple, abstract, 3D)", "Chrome, Matte Finish", "Rhinestones", "Stickers / Press-ons"]
    },
    "Lashes": {
      "Lash Extensions": ["Classic", "Hybrid", "Volume", "Mega Volume"],
      "Lash Lift & Tint": ["Lash Lifting", "Lash Tinting", "Keratin Treatment"],
      "Lash Removal & Maintenance": ["Lash Removal", "Refill (2-3 weeks)", "Deep Cleanse"],
      "Brow Combo Services": ["Brow Tint", "Brow Shaping", "Brow Lamination"]
    }
  };

  const providers = [
    {
      id: 1,
      name: "Sophia's Braid Studio",
      image: "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=300&h=300&fit=crop",
      rating: 4.9,
      reviewCount: 234,
      startingPrice: 85,
      distance: "2.1 mi",
      tags: ["Verified", "Top Rated"],
      saved: false,
      tagline: "Expert in protective styles"
    },
    {
      id: 2,
      name: "Crown Braiding Co",
      image: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&h=300&fit=crop",
      rating: 4.8,
      reviewCount: 156,
      startingPrice: 95,
      distance: "1.8 mi",
      tags: ["Popular", "Quick Booking"],
      saved: true,
      tagline: "Traditional & modern braids"
    },
    {
      id: 3,
      name: "Natural Hair Haven",
      image: "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=300&h=300&fit=crop",
      rating: 4.7,
      reviewCount: 89,
      startingPrice: 75,
      distance: "3.2 mi",
      tags: ["Eco-Friendly"],
      saved: false,
      tagline: "Chemical-free hair care"
    },
    {
      id: 4,
      name: "Elite Lash Lounge",
      image: "https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=300&h=300&fit=crop",
      rating: 4.9,
      reviewCount: 312,
      startingPrice: 120,
      distance: "1.5 mi",
      tags: ["Luxury", "Certified"],
      saved: false,
      tagline: "Premium lash extensions"
    }
  ];

  const handleCategorySelect = (category: string) => {
    setActiveCategory(category);
    setSelectedSubcategories([]);
    setShowProviders(false);
  };

  const handleSubcategorySelect = (subcategory: string) => {
    const newPath = [...selectedSubcategories, subcategory];
    setSelectedSubcategories(newPath);
    
    // Check if this is a final subcategory (has no children)
    const currentLevel = getCurrentSubLevel();
    if (currentLevel && Array.isArray(currentLevel[subcategory])) {
      setShowProviders(true);
    }
  };

  const handleBack = () => {
    if (showProviders) {
      setShowProviders(false);
    } else if (selectedSubcategories.length > 0) {
      setSelectedSubcategories(prev => prev.slice(0, -1));
    }
  };

  const getCurrentSubLevel = () => {
    let current = subcategories[activeCategory];
    for (const sub of selectedSubcategories) {
      current = current?.[sub];
    }
    return current;
  };

  const getBreadcrumb = () => {
    return [activeCategory, ...selectedSubcategories].join(" > ");
  };

  const getSortOptions = () => [
    "Popular", "Recent", "Price (Low to High)", "Price (High to Low)"
  ];

  return (
    <div className="bg-white min-h-screen">
      {/* Sticky Search Bar */}
      <div className="sticky top-0 z-10 bg-white border-b border-gray-100 p-4">
        <div className="flex items-center space-x-3">
          <div className="flex-1 relative">
            <Search size={20} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-[#6E6E73]" />
            <Input
              type="text"
              placeholder="Search services or providers..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
            />
          </div>
          <Button
            variant="outline"
            size="icon"
            className="h-12 w-12 rounded-xl border-gray-200"
          >
            <Filter size={20} className="text-[#5E50A1]" />
          </Button>
        </div>
        
        {/* Horizontal Category Pills */}
        <div className="flex overflow-x-auto space-x-4 mt-4 pb-2 scrollbar-hide">
          {categories.map((category) => (
            <button
              key={category}
              onClick={() => handleCategorySelect(category)}
              className={`whitespace-nowrap px-6 py-3 text-sm font-medium rounded-full transition-all duration-200 ${
                activeCategory === category
                  ? "bg-[#5E50A1] text-white shadow-md"
                  : "bg-gray-100 text-[#6E6E73] hover:bg-gray-200"
              }`}
            >
              {category}
            </button>
          ))}
        </div>
      </div>

      {/* Navigation Header with Back Button and Breadcrumb */}
      {(selectedSubcategories.length > 0 || showProviders) && (
        <div className="flex items-center p-4 bg-gray-50 border-b border-gray-100">
          <Button
            variant="ghost"
            size="icon"
            onClick={handleBack}
            className="mr-3 hover:bg-white"
          >
            <ArrowLeft size={20} className="text-[#5E50A1]" />
          </Button>
          <span className="text-sm text-[#6E6E73] font-medium">{getBreadcrumb()}</span>
        </div>
      )}

      {/* Content Area */}
      <div className="p-4">
        {showProviders ? (
          /* Provider Results Grid */
          <div className="space-y-4">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-[#1C1C1E]">
                {selectedSubcategories[selectedSubcategories.length - 1]} Specialists
              </h2>
              <div className="flex space-x-2">
                <Button variant="outline" size="sm" className="text-xs px-3 py-2">
                  Sort: Popular
                </Button>
                <Button variant="outline" size="sm" className="text-xs px-3 py-2">
                  Filter
                </Button>
              </div>
            </div>
            
            <div className="grid grid-cols-1 gap-4">
              {providers.map((provider) => (
                <div key={provider.id} className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-200">
                  <div className="flex">
                    <div className="w-28 h-28 relative">
                      <img 
                        src={provider.image} 
                        alt={provider.name}
                        className="w-full h-full object-cover"
                      />
                    </div>
                    <div className="flex-1 p-4">
                      <div className="flex justify-between items-start mb-2">
                        <div>
                          <h3 className="font-bold text-[#1C1C1E] text-base mb-1">
                            {provider.name}
                          </h3>
                          <p className="text-xs text-[#6E6E73] mb-2">
                            {provider.tagline}
                          </p>
                        </div>
                        <button className="p-1">
                          <Heart size={18} className={provider.saved ? "text-red-500 fill-current" : "text-[#6E6E73]"} />
                        </button>
                      </div>
                      
                      <div className="flex items-center mb-3">
                        <Star size={14} className="text-yellow-400 fill-current" />
                        <span className="text-sm font-medium text-[#1C1C1E] ml-1">
                          {provider.rating}
                        </span>
                        <span className="text-xs text-[#6E6E73] ml-1">
                          ({provider.reviewCount})
                        </span>
                        <div className="flex items-center ml-4">
                          <MapPin size={12} className="text-[#6E6E73]" />
                          <span className="text-xs text-[#6E6E73] ml-1">
                            {provider.distance}
                          </span>
                        </div>
                      </div>
                      
                      <div className="flex flex-wrap gap-1 mb-3">
                        {provider.tags.map((tag, index) => (
                          <span key={index} className="px-2 py-1 bg-[#AFBCEB] bg-opacity-30 text-[#5E50A1] text-xs rounded-full font-medium">
                            {tag}
                          </span>
                        ))}
                      </div>
                      
                      <div className="flex justify-between items-center">
                        <span className="text-sm font-bold text-[#1C1C1E]">
                          Starting at ${provider.startingPrice}
                        </span>
                        <Button className="bg-[#5E50A1] hover:bg-[#4F4391] text-white text-sm py-2 px-4 rounded-xl">
                          Book Now
                        </Button>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : (
          /* Vertical Cascading Categories */
          <div className="space-y-3">
            {Object.keys(getCurrentSubLevel() || {}).map((item) => {
              const isArray = Array.isArray(getCurrentSubLevel()?.[item]);
              return (
                <button
                  key={item}
                  onClick={() => handleSubcategorySelect(item)}
                  className="w-full text-left p-5 bg-white rounded-2xl border border-gray-100 hover:border-[#5E50A1] hover:bg-gradient-to-r hover:from-[#5E50A1]/5 hover:to-transparent transition-all duration-300 transform hover:scale-[1.02] shadow-sm hover:shadow-md"
                >
                  <div className="flex justify-between items-center">
                    <div>
                      <span className="font-semibold text-[#1C1C1E] text-base block">{item}</span>
                      {isArray && (
                        <span className="text-xs text-[#6E6E73] mt-1 block">
                          {getCurrentSubLevel()?.[item]?.length} options available
                        </span>
                      )}
                    </div>
                    <div className="flex items-center">
                      <span className="text-[#5E50A1] text-lg font-bold">→</span>
                    </div>
                  </div>
                </button>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
};

export default ClientExploreScreen;
