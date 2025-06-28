
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
      "Twists": ["Passion Twists", "Spring Twists", "Flat Twists"],
      "Boho Braids": ["Boho Knotless", "Boho Box Braids", "Boho Goddess"],
      "Scalp Braids": ["Cornrows", "Fulani Braids", "Lemonade Braids"],
      "Individual Braids": ["Box Braids", "Knotless Braids", "Micro Braids"]
    },
    "Locs": {
      "Starter Locs": ["Twist & Rip", "Backcombing", "Crochet Method"],
      "Loc Maintenance": ["Root Touch-up", "Palm Rolling", "Interlocking"],
      "Loc Styles": ["Loc Updos", "Loc Braids", "Colored Locs"]
    },
    "Nails": {
      "Manicure": ["Classic Manicure", "Gel Manicure", "French Manicure"],
      "Nail Art": ["Custom Designs", "3D Art", "Ombre Nails"],
      "Extensions": ["Acrylic", "Gel Extensions", "Dip Powder"]
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
      saved: false
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
      saved: true
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
      saved: false
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
    if (currentLevel && typeof currentLevel[subcategory] === 'undefined') {
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

  return (
    <div className="bg-white min-h-screen">
      {/* Sticky Search Bar */}
      <div className="sticky top-0 z-10 bg-white border-b border-gray-100 p-4">
        <div className="flex items-center space-x-3">
          <div className="flex-1 relative">
            <Search size={20} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-[#6E6E73]" />
            <Input
              type="text"
              placeholder="Search services (e.g., braids, nails, cornrows...)"
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
        
        {/* Horizontal Category Tabs */}
        <div className="flex overflow-x-auto space-x-4 mt-4 pb-2">
          {categories.map((category) => (
            <button
              key={category}
              onClick={() => handleCategorySelect(category)}
              className={`whitespace-nowrap px-4 py-2 text-sm font-medium border-b-2 transition-colors ${
                activeCategory === category
                  ? "border-[#5E50A1] text-[#5E50A1] font-bold"
                  : "border-transparent text-[#6E6E73] hover:text-[#5E50A1]"
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
            className="mr-3"
          >
            <ArrowLeft size={20} className="text-[#5E50A1]" />
          </Button>
          <span className="text-sm text-[#6E6E73]">{getBreadcrumb()}</span>
        </div>
      )}

      {/* Content Area */}
      <div className="p-4">
        {showProviders ? (
          /* Provider Results */
          <div className="space-y-4">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-bold text-[#1C1C1E]">
                {selectedSubcategories[selectedSubcategories.length - 1]} Specialists
              </h2>
              <div className="flex space-x-2">
                <Button variant="outline" size="sm" className="text-xs">
                  ⇅ Sort
                </Button>
                <Button variant="outline" size="sm" className="text-xs">
                  ☰ Filter
                </Button>
              </div>
            </div>
            
            {providers.map((provider) => (
              <div key={provider.id} className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                <div className="flex">
                  <img 
                    src={provider.image} 
                    alt={provider.name}
                    className="w-24 h-24 object-cover"
                  />
                  <div className="flex-1 p-4">
                    <div className="flex justify-between items-start mb-2">
                      <h3 className="font-semibold text-[#1C1C1E] text-sm">
                        {provider.name}
                      </h3>
                      <button className="p-1">
                        <Heart size={16} className={provider.saved ? "text-red-500 fill-current" : "text-[#6E6E73]"} />
                      </button>
                    </div>
                    
                    <div className="flex items-center mb-2">
                      <Star size={14} className="text-yellow-400 fill-current" />
                      <span className="text-xs font-medium text-[#1C1C1E] ml-1">
                        {provider.rating}
                      </span>
                      <span className="text-xs text-[#6E6E73] ml-1">
                        ({provider.reviewCount})
                      </span>
                      <div className="flex items-center ml-3">
                        <MapPin size={12} className="text-[#6E6E73]" />
                        <span className="text-xs text-[#6E6E73] ml-1">
                          {provider.distance}
                        </span>
                      </div>
                    </div>
                    
                    <div className="flex flex-wrap gap-1 mb-3">
                      {provider.tags.map((tag, index) => (
                        <span key={index} className="px-2 py-1 bg-[#AFBCEB] bg-opacity-20 text-[#5E50A1] text-xs rounded-full">
                          {tag}
                        </span>
                      ))}
                    </div>
                    
                    <div className="flex justify-between items-center">
                      <span className="text-sm font-bold text-[#1C1C1E]">
                        Starting at ${provider.startingPrice}
                      </span>
                      <Button className="bg-[#5E50A1] hover:bg-[#4F4391] text-white text-xs py-1 px-3 rounded-lg">
                        Book Now
                      </Button>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          /* Vertical Cascading Categories */
          <div className="space-y-3">
            {Object.keys(getCurrentSubLevel() || {}).map((item) => (
              <button
                key={item}
                onClick={() => handleSubcategorySelect(item)}
                className="w-full text-left p-4 bg-white rounded-xl border border-gray-100 hover:border-[#5E50A1] hover:bg-[#5E50A1] hover:bg-opacity-5 transition-all duration-200 transform hover:scale-[1.02]"
              >
                <div className="flex justify-between items-center">
                  <span className="font-medium text-[#1C1C1E]">{item}</span>
                  <span className="text-[#6E6E73] text-sm">→</span>
                </div>
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ClientExploreScreen;
