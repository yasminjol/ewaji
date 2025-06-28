
import { useState } from "react";
import { Search, Filter, Star } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const ClientExploreScreen = () => {
  const [searchQuery, setSearchQuery] = useState("");

  const providers = [
    {
      id: 1,
      name: "Sophia's Hair Studio",
      image: "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=300&h=300&fit=crop",
      rating: 4.9,
      reviewCount: 234,
      service: "Hair Styling"
    },
    {
      id: 2,
      name: "Glamour Nails",
      image: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&h=300&fit=crop",
      rating: 4.8,
      reviewCount: 156,
      service: "Nail Art"
    },
    {
      id: 3,
      name: "Bella Beauty",
      image: "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=300&h=300&fit=crop",
      rating: 4.7,
      reviewCount: 89,
      service: "Facial Care"
    },
    {
      id: 4,
      name: "Elite Lashes",
      image: "https://images.unsplash.com/photo-1516975080664-ed2fc6a32937?w=300&h=300&fit=crop",
      rating: 4.9,
      reviewCount: 178,
      service: "Eyelash Extensions"
    },
    {
      id: 5,
      name: "Perfect Brows",
      image: "https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=300&h=300&fit=crop",
      rating: 4.6,
      reviewCount: 92,
      service: "Eyebrow Shaping"
    },
    {
      id: 6,
      name: "Glow Spa",
      image: "https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=300&h=300&fit=crop",
      rating: 4.8,
      reviewCount: 145,
      service: "Spa Treatments"
    }
  ];

  return (
    <div className="bg-white min-h-screen">
      {/* Search Header */}
      <div className="p-4 border-b border-gray-100">
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
      </div>

      {/* Results Grid */}
      <div className="p-4">
        <div className="grid grid-cols-2 gap-4">
          {providers.map((provider) => (
            <div key={provider.id} className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
              <img 
                src={provider.image} 
                alt={provider.name}
                className="w-full h-40 object-cover"
              />
              <div className="p-3">
                <h3 className="font-semibold text-[#1C1C1E] text-sm mb-1 truncate">
                  {provider.name}
                </h3>
                <p className="text-xs text-[#6E6E73] mb-2">{provider.service}</p>
                
                <div className="flex items-center mb-3">
                  <Star size={14} className="text-yellow-400 fill-current" />
                  <span className="text-xs font-medium text-[#1C1C1E] ml-1">
                    {provider.rating}
                  </span>
                  <span className="text-xs text-[#6E6E73] ml-1">
                    ({provider.reviewCount})
                  </span>
                </div>
                
                <Button className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white text-xs py-2 rounded-lg">
                  Book Now
                </Button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default ClientExploreScreen;
