
import React from 'react';
import { Search, Heart, MessageCircle, Bookmark, Share2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Carousel, CarouselContent, CarouselItem } from '@/components/ui/carousel';

const ClientHomeScreen = () => {
  const aiPicks = [
    {
      id: 1,
      providerName: "Sarah Williams",
      image: "/placeholder.svg",
      service: "Hair & Makeup",
      rating: 4.9,
    },
    {
      id: 2,
      providerName: "Maya Johnson",
      image: "/placeholder.svg",
      service: "Braiding Specialist",
      rating: 4.8,
    },
    {
      id: 3,
      providerName: "Zara Adams",
      image: "/placeholder.svg",
      service: "Nail Artist",
      rating: 5.0,
    },
  ];

  const feedPosts = [
    {
      id: 1,
      provider: {
        name: "Sarah Williams",
        avatar: "/placeholder.svg",
      },
      image: "/placeholder.svg",
      caption: "Fresh silk press and face beat ✨ Book your appointment today!",
      likes: 234,
      comments: 18,
      service: "Hair & Makeup"
    },
    {
      id: 2,
      provider: {
        name: "Maya Johnson",
        avatar: "/placeholder.svg",
      },
      image: "/placeholder.svg",
      caption: "Knotless braids with curly ends 💫 Weekend availability open!",
      likes: 156,
      comments: 12,
      service: "Braiding"
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top Bar */}
      <div className="bg-white px-4 py-4 border-b border-gray-200">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-[#1C1C1E] tracking-tight">EWAJI</h1>
          <button className="p-2 rounded-full hover:bg-gray-100">
            <Search size={24} className="text-[#6E6E73]" />
          </button>
        </div>
      </div>

      {/* AI Picks Carousel */}
      <div className="bg-white px-4 py-6 border-b border-gray-200">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-4">AI Picks For You</h2>
        <Carousel className="w-full">
          <CarouselContent className="-ml-2">
            {aiPicks.map((pick) => (
              <CarouselItem key={pick.id} className="pl-2 basis-4/5">
                <div className="bg-gradient-to-br from-[#F7F8FF] to-white rounded-xl p-4 shadow-sm border border-gray-100">
                  <div className="flex items-center space-x-3 mb-3">
                    <img
                      src={pick.image}
                      alt={pick.providerName}
                      className="w-12 h-12 rounded-full object-cover"
                    />
                    <div className="flex-1">
                      <h3 className="font-semibold text-[#1C1C1E]">{pick.providerName}</h3>
                      <p className="text-sm text-[#6E6E73]">{pick.service}</p>
                      <div className="flex items-center mt-1">
                        <span className="text-sm font-medium text-[#5E50A1]">★ {pick.rating}</span>
                      </div>
                    </div>
                  </div>
                  <Button className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white rounded-lg">
                    Book Now
                  </Button>
                </div>
              </CarouselItem>
            ))}
          </CarouselContent>
        </Carousel>
      </div>

      {/* Main Feed */}
      <div className="px-4 py-6 space-y-6">
        {feedPosts.map((post) => (
          <div key={post.id} className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            {/* Post Header */}
            <div className="flex items-center justify-between p-4">
              <div className="flex items-center space-x-3">
                <img
                  src={post.provider.avatar}
                  alt={post.provider.name}
                  className="w-10 h-10 rounded-full object-cover"
                />
                <div>
                  <h3 className="font-semibold text-[#1C1C1E]">{post.provider.name}</h3>
                  <p className="text-sm text-[#6E6E73]">{post.service}</p>
                </div>
              </div>
            </div>

            {/* Post Image */}
            <img
              src={post.image}
              alt="Service showcase"
              className="w-full h-80 object-cover"
            />

            {/* Post Actions */}
            <div className="p-4">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center space-x-4">
                  <button className="flex items-center space-x-1 text-[#6E6E73] hover:text-[#5E50A1] transition-colors">
                    <Heart size={20} />
                    <span className="text-sm">{post.likes}</span>
                  </button>
                  <button className="flex items-center space-x-1 text-[#6E6E73] hover:text-[#5E50A1] transition-colors">
                    <MessageCircle size={20} />
                    <span className="text-sm">{post.comments}</span>
                  </button>
                  <button className="text-[#6E6E73] hover:text-[#5E50A1] transition-colors">
                    <Share2 size={20} />
                  </button>
                </div>
                <button className="text-[#6E6E73] hover:text-[#5E50A1] transition-colors">
                  <Bookmark size={20} />
                </button>
              </div>

              {/* Caption */}
              <p className="text-[#1C1C1E] mb-4">{post.caption}</p>

              {/* Book Now Button */}
              <Button className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white rounded-lg">
                Book Now
              </Button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default ClientHomeScreen;
