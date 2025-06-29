import { useState, useEffect } from "react";
import { Search, Heart, MessageCircle, Bookmark, Share2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import QuickBookingDrawer from "@/components/client/QuickBookingDrawer";

const ClientHomeScreen = () => {
  const [currentSlide, setCurrentSlide] = useState(0);
  const [bookingDrawerOpen, setBookingDrawerOpen] = useState(false);
  const [selectedProvider, setSelectedProvider] = useState<{name: string; id: number; avatar?: string} | null>(null);

  const aiPicks = [
    {
      id: 1,
      image: "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=250&fit=crop",
      providerName: "Sophia's Hair Studio",
      service: "Balayage & Cut"
    },
    {
      id: 2,
      image: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=250&fit=crop",
      providerName: "Glamour Nails",
      service: "Gel Manicure"
    },
    {
      id: 3,
      image: "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=400&h=250&fit=crop",
      providerName: "Bella Beauty",
      service: "Facial Treatment"
    }
  ];

  const feedPosts = [
    {
      id: 1,
      provider: {
        name: "Sophia's Hair Studio",
        avatar: "https://images.unsplash.com/photo-1494790108755-2616c5e68b05?w=50&h=50&fit=crop&crop=face"
      },
      image: "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=400&fit=crop",
      likes: 234,
      caption: "Fresh balayage transformation ✨"
    },
    {
      id: 2,
      provider: {
        name: "Glamour Nails",
        avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50&fit=crop&crop=face"
      },
      image: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=400&fit=crop",
      likes: 156,
      caption: "Gorgeous gel manicure design 💅"
    }
  ];

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % aiPicks.length);
    }, 4000);

    return () => clearInterval(interval);
  }, [aiPicks.length]);

  const handleBookNow = (providerName: string, providerId: number) => {
    setSelectedProvider({
      name: providerName,
      id: providerId,
      avatar: "/placeholder.svg"
    });
    setBookingDrawerOpen(true);
  };

  return (
    <div className="bg-white min-h-screen">
      {/* Top Bar */}
      <div className="flex items-center justify-between p-4 border-b border-gray-100">
        <div></div>
        <h1 className="text-2xl font-bold text-[#1C1C1E]">EWAJI</h1>
        <Search size={24} className="text-[#5E50A1]" />
      </div>

      {/* AI Picks Carousel */}
      <div className="p-4">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-3">AI Picks For You</h2>
        <div className="relative overflow-hidden rounded-xl">
          <div 
            className="flex transition-transform duration-300 ease-in-out"
            style={{ transform: `translateX(-${currentSlide * 100}%)` }}
          >
            {aiPicks.map((pick) => (
              <div key={pick.id} className="w-full flex-shrink-0 relative">
                <img 
                  src={pick.image} 
                  alt={pick.service}
                  className="w-full h-48 object-cover"
                />
                <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/60 to-transparent p-4">
                  <h3 className="text-white font-semibold">{pick.providerName}</h3>
                  <p className="text-white/90 text-sm">{pick.service}</p>
                  <Button 
                    onClick={() => handleBookNow(pick.providerName, pick.id)}
                    className="mt-2 bg-[#5E50A1] hover:bg-[#4F4391] text-white text-sm px-4 py-2 rounded-lg"
                  >
                    Book Now
                  </Button>
                </div>
              </div>
            ))}
          </div>
          
          {/* Pagination Dots */}
          <div className="flex justify-center space-x-2 mt-3">
            {aiPicks.map((_, index) => (
              <button
                key={index}
                onClick={() => setCurrentSlide(index)}
                className={`w-2 h-2 rounded-full transition-colors ${
                  index === currentSlide ? 'bg-[#5E50A1]' : 'bg-gray-300'
                }`}
              />
            ))}
          </div>
        </div>
      </div>

      {/* Main Feed */}
      <div className="space-y-6">
        {feedPosts.map((post) => (
          <div key={post.id} className="bg-white">
            {/* Post Header */}
            <div className="flex items-center px-4 py-3">
              <img 
                src={post.provider.avatar} 
                alt={post.provider.name}
                className="w-10 h-10 rounded-full object-cover"
              />
              <span className="ml-3 font-medium text-[#1C1C1E]">{post.provider.name}</span>
            </div>

            {/* Post Image */}
            <img 
              src={post.image} 
              alt="Post"
              className="w-full h-80 object-cover"
            />

            {/* Post Actions */}
            <div className="px-4 py-3">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center space-x-4">
                  <Heart size={24} className="text-[#6E6E73] hover:text-red-500 transition-colors" />
                  <MessageCircle size={24} className="text-[#6E6E73]" />
                  <Share2 size={24} className="text-[#6E6E73]" />
                </div>
                <Bookmark size={24} className="text-[#6E6E73]" />
              </div>
              
              <p className="font-medium text-[#1C1C1E] mb-1">{post.likes} likes</p>
              <p className="text-[#1C1C1E]">
                <span className="font-medium">{post.provider.name}</span> {post.caption}
              </p>
              
              <Button 
                onClick={() => handleBookNow(post.provider.name, post.id)}
                className="mt-3 w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white rounded-lg"
              >
                Book Now
              </Button>
            </div>
          </div>
        ))}
      </div>

      {/* Quick Booking Drawer */}
      {selectedProvider && (
        <QuickBookingDrawer
          isOpen={bookingDrawerOpen}
          onClose={() => setBookingDrawerOpen(false)}
          provider={selectedProvider}
        />
      )}
    </div>
  );
};

export default ClientHomeScreen;
