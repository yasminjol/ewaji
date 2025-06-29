
import { useState } from "react";
import { ArrowLeft, Heart, Star, MapPin, Clock, Check, ChevronDown, ChevronUp, Calendar } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { Carousel, CarouselContent, CarouselItem, CarouselNext, CarouselPrevious } from "@/components/ui/carousel";

const ClientProviderProfileScreen = () => {
  const [isSaved, setIsSaved] = useState(false);
  const [selectedImageIndex, setSelectedImageIndex] = useState(0);

  // Mock provider data
  const provider = {
    id: 1,
    name: "Sophia's Braid Studio",
    tagline: "Expert in protective styles",
    image: "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=400&fit=crop",
    rating: 4.9,
    reviewCount: 234,
    distance: "2.1 mi",
    startingPrice: 85,
    tags: ["Verified", "Top Rated", "Quick Booking"],
    bio: "Private studio in downtown. I offer gentle braiding and long-lasting styles with 8+ years of experience.",
    images: [
      "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=400&h=300&fit=crop"
    ],
    services: {
      "Braids": [
        { name: "Fulani Braids", price: 95, duration: "2.5 hrs", description: "Traditional Fulani-style braids with beads" },
        { name: "Knotless Medium", price: 120, duration: "3 hrs", description: "Medium-sized knotless box braids" },
        { name: "Feed-in Braids", price: 85, duration: "2 hrs", description: "Natural-looking cornrow style" }
      ],
      "Locs": [
        { name: "Retwist", price: 75, duration: "1.5 hrs", description: "Maintenance for existing locs" },
        { name: "Starter Locs", price: 150, duration: "4 hrs", description: "Begin your loc journey" }
      ]
    },
    amenities: [
      { icon: "✨", text: "Hair included" },
      { icon: "🚿", text: "Wash included" },
      { icon: "👶", text: "Kids accepted" },
      { icon: "♿", text: "Accessible" }
    ],
    reviews: [
      { name: "Maya K.", rating: 5, text: "Amazing work! My braids lasted 8 weeks and looked fresh the whole time.", image: "https://images.unsplash.com/photo-1494790108755-2616c96c1dd0?w=60&h=60&fit=crop&crop=face" },
      { name: "Jasmine R.", rating: 5, text: "So gentle and professional. Highly recommend!", image: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=60&h=60&fit=crop&crop=face" },
      { name: "Zara T.", rating: 4, text: "Great results, clean studio environment.", image: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=60&h=60&fit=crop&crop=face" }
    ]
  };

  const handleBack = () => {
    window.history.back();
  };

  const toggleSaved = () => {
    setIsSaved(!isSaved);
  };

  const handleBookNow = () => {
    console.log("Booking appointment with", provider.name);
  };

  return (
    <div className="bg-white min-h-screen">
      {/* Sticky Header */}
      <div className="sticky top-0 z-20 bg-white border-b border-gray-100 px-4 py-3">
        <div className="flex items-center justify-between">
          <Button
            variant="ghost"
            size="icon"
            onClick={handleBack}
            className="hover:bg-gray-100"
          >
            <ArrowLeft size={20} className="text-[#1C1C1E]" />
          </Button>
          <h1 className="text-lg font-bold text-[#1C1C1E] truncate mx-4 flex-1">
            {provider.name}
          </h1>
          <Button
            variant="ghost"
            size="icon"
            onClick={toggleSaved}
            className="hover:bg-gray-100"
          >
            <Heart size={20} className={isSaved ? "text-red-500 fill-current" : "text-[#6E6E73]"} />
          </Button>
        </div>
      </div>

      {/* Hero Section - Image Carousel */}
      <div className="relative">
        <Carousel className="w-full">
          <CarouselContent>
            {provider.images.map((image, index) => (
              <CarouselItem key={index}>
                <div className="h-64 relative">
                  <img
                    src={image}
                    alt={`${provider.name} work ${index + 1}`}
                    className="w-full h-full object-cover"
                  />
                </div>
              </CarouselItem>
            ))}
          </CarouselContent>
          <CarouselPrevious className="left-4" />
          <CarouselNext className="right-4" />
        </Carousel>
      </div>

      {/* Provider Summary */}
      <div className="p-4 border-b border-gray-100">
        <div className="mb-3">
          <h2 className="text-xl font-bold text-[#1C1C1E] mb-1">{provider.name}</h2>
          <p className="text-sm text-[#6E6E73]">{provider.tagline}</p>
        </div>

        <div className="flex items-center mb-3">
          <div className="flex items-center mr-4">
            <Star size={16} className="text-yellow-400 fill-current" />
            <span className="text-sm font-medium text-[#1C1C1E] ml-1">
              {provider.rating}
            </span>
            <span className="text-xs text-[#6E6E73] ml-1">
              ({provider.reviewCount})
            </span>
          </div>
          <div className="flex items-center">
            <MapPin size={14} className="text-[#6E6E73]" />
            <span className="text-sm text-[#6E6E73] ml-1">
              {provider.distance}
            </span>
          </div>
        </div>

        <div className="flex flex-wrap gap-2 mb-4">
          {provider.tags.map((tag, index) => (
            <span key={index} className="px-3 py-1 bg-[#AFBCEB] bg-opacity-30 text-[#5E50A1] text-xs rounded-full font-medium">
              {tag}
            </span>
          ))}
        </div>

        <div className="flex items-center justify-between">
          <span className="text-lg font-bold text-[#1C1C1E]">
            Starting at ${provider.startingPrice}
          </span>
          <Button 
            onClick={handleBookNow}
            className="bg-[#5E50A1] hover:bg-[#4F4391] text-white px-6 py-2 rounded-xl"
          >
            Book Now
          </Button>
        </div>
      </div>

      {/* Services Section */}
      <div className="p-4 border-b border-gray-100">
        <h3 className="text-lg font-bold text-[#1C1C1E] mb-4">Services</h3>
        <Accordion type="multiple" className="space-y-2">
          {Object.entries(provider.services).map(([category, services]) => (
            <AccordionItem key={category} value={category} className="border border-gray-200 rounded-xl">
              <AccordionTrigger className="px-4 py-3 hover:no-underline">
                <span className="font-semibold text-[#1C1C1E]">{category}</span>
              </AccordionTrigger>
              <AccordionContent className="px-4 pb-4">
                <div className="space-y-3">
                  {services.map((service, index) => (
                    <div key={index} className="border-b border-gray-100 last:border-b-0 pb-3 last:pb-0">
                      <div className="flex justify-between items-start mb-2">
                        <div className="flex-1">
                          <h4 className="font-medium text-[#1C1C1E]">{service.name}</h4>
                          <p className="text-sm text-[#6E6E73] mt-1">{service.description}</p>
                        </div>
                        <Button 
                          size="sm" 
                          className="bg-[#5E50A1] hover:bg-[#4F4391] text-white text-xs px-3 py-1 rounded-lg ml-3"
                        >
                          Book
                        </Button>
                      </div>
                      <div className="flex items-center text-sm text-[#6E6E73]">
                        <span className="font-medium">${service.price}</span>
                        <Clock size={12} className="mx-2" />
                        <span>{service.duration}</span>
                      </div>
                    </div>
                  ))}
                </div>
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
      </div>

      {/* Availability Section */}
      <div className="p-4 border-b border-gray-100">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-lg font-bold text-[#1C1C1E]">Availability</h3>
          <Button 
            variant="outline" 
            size="sm"
            className="text-[#5E50A1] border-[#5E50A1]"
          >
            <Calendar size={16} className="mr-2" />
            View Calendar
          </Button>
        </div>
        <div className="bg-green-50 border border-green-200 rounded-xl p-3">
          <div className="flex items-center">
            <Check size={16} className="text-green-600 mr-2" />
            <span className="text-sm text-green-700 font-medium">
              Next available: Today at 3:00 PM
            </span>
          </div>
        </div>
      </div>

      {/* About Provider */}
      <div className="p-4 border-b border-gray-100">
        <h3 className="text-lg font-bold text-[#1C1C1E] mb-3">About</h3>
        <p className="text-sm text-[#6E6E73] mb-4">{provider.bio}</p>
        
        <div className="grid grid-cols-2 gap-3">
          {provider.amenities.map((amenity, index) => (
            <div key={index} className="flex items-center">
              <span className="text-lg mr-2">{amenity.icon}</span>
              <span className="text-sm text-[#6E6E73]">{amenity.text}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Reviews Section */}
      <div className="p-4 border-b border-gray-100">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-bold text-[#1C1C1E]">Reviews</h3>
          <Button variant="ghost" size="sm" className="text-[#5E50A1]">
            See All
          </Button>
        </div>
        
        <div className="space-y-4">
          {provider.reviews.map((review, index) => (
            <div key={index} className="flex space-x-3">
              <img
                src={review.image}
                alt={review.name}
                className="w-10 h-10 rounded-full object-cover"
              />
              <div className="flex-1">
                <div className="flex items-center mb-1">
                  <span className="font-medium text-[#1C1C1E] text-sm mr-2">{review.name}</span>
                  <div className="flex">
                    {[...Array(review.rating)].map((_, i) => (
                      <Star key={i} size={12} className="text-yellow-400 fill-current" />
                    ))}
                  </div>
                </div>
                <p className="text-sm text-[#6E6E73]">{review.text}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Location Preview */}
      <div className="p-4 border-b border-gray-100">
        <h3 className="text-lg font-bold text-[#1C1C1E] mb-3">Location</h3>
        <div className="bg-gray-100 rounded-xl h-32 flex items-center justify-center mb-3">
          <div className="text-center">
            <MapPin size={24} className="text-[#6E6E73] mx-auto mb-2" />
            <span className="text-sm text-[#6E6E73]">Map Preview</span>
          </div>
        </div>
        <p className="text-sm text-[#6E6E73]">
          Private suite, street parking available
        </p>
      </div>

      {/* Bottom Spacing for Sticky CTA */}
      <div className="h-20"></div>

      {/* Persistent Bottom CTA */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 z-10">
        <Button 
          onClick={handleBookNow}
          className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white py-3 rounded-xl font-semibold"
        >
          Book Appointment
        </Button>
      </div>
    </div>
  );
};

export default ClientProviderProfileScreen;
