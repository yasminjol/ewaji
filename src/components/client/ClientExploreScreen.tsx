
import React, { useState } from 'react';
import { Search, Filter, Star } from 'lucide-react';
import { Button } from '@/components/ui/button';

const ClientExploreScreen = () => {
  const [searchQuery, setSearchQuery] = useState('');

  const providers = [
    {
      id: 1,
      name: "Sarah Williams",
      image: "/placeholder.svg",
      service: "Hair & Makeup Artist",
      rating: 4.9,
      reviews: 156,
      location: "Atlanta, GA"
    },
    {
      id: 2,
      name: "Maya Johnson",
      image: "/placeholder.svg",
      service: "Braiding Specialist",
      rating: 4.8,
      reviews: 89,
      location: "Atlanta, GA"
    },
    {
      id: 3,
      name: "Zara Adams",
      image: "/placeholder.svg",
      service: "Nail Artist",
      rating: 5.0,
      reviews: 203,
      location: "Atlanta, GA"
    },
    {
      id: 4,
      name: "Jade Chen",
      image: "/placeholder.svg",
      service: "Lash Technician",
      rating: 4.7,
      reviews: 124,
      location: "Atlanta, GA"
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-4 py-4 border-b border-gray-200">
        <h1 className="text-xl font-bold text-[#1C1C1E] mb-4">Explore</h1>
        
        {/* Search Bar */}
        <div className="relative mb-4">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-5 w-5 text-gray-400" />
          </div>
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="block w-full pl-10 pr-12 py-3 border border-gray-300 rounded-xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
            placeholder="Search services or providers..."
          />
          <button className="absolute inset-y-0 right-0 pr-3 flex items-center">
            <Filter className="h-5 w-5 text-[#5E50A1]" />
          </button>
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
                className="w-full h-32 object-cover"
              />
              <div className="p-3">
                <h3 className="font-semibold text-[#1C1C1E] text-sm mb-1">{provider.name}</h3>
                <p className="text-xs text-[#6E6E73] mb-2">{provider.service}</p>
                <div className="flex items-center mb-2">
                  <Star size={12} className="text-yellow-400 fill-current" />
                  <span className="text-xs text-[#1C1C1E] ml-1 font-medium">{provider.rating}</span>
                  <span className="text-xs text-[#6E6E73] ml-1">({provider.reviews})</span>
                </div>
                <p className="text-xs text-[#6E6E73] mb-3">{provider.location}</p>
                <Button size="sm" className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white text-xs rounded-lg h-8">
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
