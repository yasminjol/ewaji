
import { useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { ArrowLeft, Heart, Star, MapPin, CheckCircle, Share2, Calendar, Clock, DollarSign } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";

const ClientProviderProfileScreen = () => {
  const navigate = useNavigate();
  const { providerId } = useParams();
  const [isSaved, setIsSaved] = useState(false);
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

  // Mock provider data - in real app this would come from API
  const provider = {
    id: 1,
    name: "Sophia's Braid Studio",
    tagline: "Expert in protective styles",
    rating: 4.9,
    reviewCount: 234,
    distance: "2.1 mi",
    tags: ["Verified", "Top Rated", "Quick Booking"],
    images: [
      "https://images.unsplash.com/photo-1560869713-7d0b29430803?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1487412947147-5cebf100ffc2?w=400&h=300&fit=crop",
      "https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=400&h=300&fit=crop"
    ],
    about: "Specializing in luxury protective styles. Offering hair-included services in a comfortable, private studio setting. 8+ years of experience creating beautiful, long-lasting braids.",
    services: {
      "Braids": [
        { name: "Fulani Braids", price: 95, duration: "2.5 hrs", description: "Traditional Fulani-style braids with beads" },
        { name: "Knotless Medium", price: 120, duration: "3 hrs", description: "Medium-sized knotless braids" },
        { name: "Box Braids", price: 85, duration: "2 hrs", description: "Classic box braids, various sizes" },
        { name: "Feed-in Braids", price: 110, duration: "2.5 hrs", description: "Natural-looking feed-in cornrows" }
      ],
      "Locs": [
        { name: "Retwist", price: 75, duration: "1.5 hrs", description: "Professional loc maintenance" },
        { name: "Starter Locs", price: 150, duration: "4 hrs", description: "Begin your loc journey" }
      ]
    },
    policies: [
      { label: "Hair Provided", value: "Yes" },
      { label: "Wash Included", value: "Yes" },
      { label: "Kids Accepted", value: "12+ years" },
      { label: "Reschedule Policy", value: "24 hrs minimum" },
      { label: "Late Fee", value: "$10 after 10 mins" }
    ],
    reviews: [
      { name: "Maya K.", rating: 5, text: "Amazing work! My braids lasted 8 weeks and looked perfect.", image: "https://images.unsplash.com/photo-1594736797933-d0601ba2fe65?w=100&h=100&fit=crop" },
      { name: "Zara M.", rating: 5, text: "Professional, clean space, and beautiful results every time.", image: "https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=100&h=100&fit=crop" },
      { name: "Asha T.", rating: 4, text: "Great experience, will definitely book again!", image: "https://images.unsplash.com/photo-1580618672591-eb180b1a973f?w=100&h=100&fit=crop" }
    ],
    location: {
      area: "Downtown Montreal",
      description: "Private entrance, well-lit, secure parking available"
    }
  };

  const ratingBreakdown = [
    { stars: 5, percentage: 78 },
    { stars: 4, percentage: 15 },
    { stars: 3, percentage: 5 },
    { stars: 2, percentage: 2 },
    { stars: 1, percentage: 0 }
  ];

  return (
    <div className="bg-white min-h-screen">
      {/* Sticky Header */}
      <div className="sticky top-0 z-20 bg-white border-b border-gray-100 px-4 py-3">
        <div className="flex items-center justify-between">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => navigate(-1)}
            className="hover:bg-gray-100"
          >
            <ArrowLeft size={20} className="text-[#1C1C1E]" />
          </Button>
          
          <h1 className="font-bold text-lg text-[#1C1C1E] text-center flex-1 mx-4 truncate">
            {provider.name}
          </h1>
          
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setIsSaved(!isSaved)}
            className="hover:bg-gray-100"
          >
            <Heart 
              size={20} 
              className={isSaved ? "text-red-500 fill-current" : "text-[#6E6E73]"} 
            />
          </Button>
        </div>
      </div>

      {/* Image Carousel */}
      <div className="relative">
        <div className="overflow-hidden">
          <div className="flex transition-transform duration-300" style={{ transform: `translateX(-${currentImageIndex * 100}%)` }}>
            {provider.images.map((image, index) => (
              <div key={index} className="w-full flex-shrink-0">
                <img 
                  src={image} 
                  alt={`${provider.name} work ${index + 1}`}
                  className="w-full h-64 object-cover"
                />
              </div>
            ))}
          </div>
        </div>
        
        {/* Image Pagination Dots */}
        <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2 flex space-x-2">
          {provider.images.map((_, index) => (
            <button
              key={index}
              onClick={() => setCurrentImageIndex(index)}
              className={`w-2 h-2 rounded-full transition-colors ${
                index === currentImageIndex ? "bg-white" : "bg-white/50"
              }`}
            />
          ))}
        </div>
      </div>

      {/* Content */}
      <div className="px-4 pb-24">
        {/* Provider Summary */}
        <div className="py-6 border-b border-gray-100">
          <div className="mb-3">
            <h2 className="text-xl font-bold text-[#1C1C1E] mb-1">{provider.name}</h2>
            <p className="text-[#6E6E73] text-sm">{provider.tagline}</p>
          </div>
          
          <div className="flex items-center mb-4">
            <div className="flex items-center mr-6">
              <Star size={16} className="text-yellow-400 fill-current mr-1" />
              <span className="font-semibold text-[#1C1C1E] mr-1">{provider.rating}</span>
              <span className="text-sm text-[#6E6E73]">({provider.reviewCount})</span>
            </div>
            
            <div className="flex items-center mr-6">
              <MapPin size={14} className="text-[#6E6E73] mr-1" />
              <span className="text-sm text-[#6E6E73]">{provider.distance}</span>
            </div>
            
            <CheckCircle size={16} className="text-green-500" />
          </div>
          
          <div className="flex flex-wrap gap-2 mb-4">
            {provider.tags.map((tag, index) => (
              <span key={index} className="px-3 py-1 bg-[#AFBCEB] bg-opacity-30 text-[#5E50A1] text-xs rounded-full font-medium">
                {tag}
              </span>
            ))}
          </div>
          
          <Button className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl">
            <Calendar size={18} className="mr-2" />
            View Availability
          </Button>
        </div>

        {/* Services Section */}
        <div className="py-6 border-b border-gray-100">
          <h3 className="text-lg font-bold text-[#1C1C1E] mb-4">Services</h3>
          
          <Accordion type="multiple" className="space-y-2">
            {Object.entries(provider.services).map(([category, services]) => (
              <AccordionItem key={category} value={category} className="border border-gray-100 rounded-xl">
                <AccordionTrigger className="px-4 py-3 hover:no-underline">
                  <span className="font-semibold text-[#1C1C1E]">{category}</span>
                </AccordionTrigger>
                <AccordionContent className="px-4 pb-4">
                  <div className="space-y-3">
                    {services.map((service, index) => (
                      <div key={index} className="flex justify-between items-start">
                        <div className="flex-1">
                          <h4 className="font-medium text-[#1C1C1E] mb-1">{service.name}</h4>
                          <p className="text-xs text-[#6E6E73] mb-2">{service.description}</p>
                          
                          <div className="flex items-center space-x-4 text-xs text-[#6E6E73]">
                            <div className="flex items-center">
                              <DollarSign size={12} className="mr-1" />
                              <span>${service.price}</span>
                            </div>
                            <div className="flex items-center">
                              <Clock size={12} className="mr-1" />
                              <span>{service.duration}</span>
                            </div>
                          </div>
                        </div>
                        
                        <Button size="sm" className="bg-[#5E50A1] hover:bg-[#4F4391] text-white text-xs px-4 py-2 rounded-lg ml-4">
                          Book Now
                        </Button>
                      </div>
                    ))}
                  </div>
                </AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>
        </div>

        {/* About Section */}
        <div className="py-6 border-b border-gray-100">
          <h3 className="text-lg font-bold text-[#1C1C1E] mb-3">About</h3>
          <p className="text-[#6E6E73] text-sm leading-relaxed">{provider.about}</p>
        </div>

        {/* Policies Section */}
        <div className="py-6 border-b border-gray-100">
          <h3 className="text-lg font-bold text-[#1C1C1E] mb-4">Policies</h3>
          <div className="space-y-3">
            {provider.policies.map((policy, index) => (
              <div key={index} className="flex justify-between items-center">
                <span className="text-sm text-[#6E6E73]">{policy.label}</span>
                <span className="text-sm font-medium text-[#1C1C1E]">{policy.value}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Reviews Section */}
        <div className="py-6 border-b border-gray-100">
          <h3 className="text-lg font-bold text-[#1C1C1E] mb-4">Reviews & Ratings</h3>
          
          {/* Rating Summary */}
          <div className="bg-gray-50 rounded-xl p-4 mb-4">
            <div className="flex items-center mb-3">
              <span className="text-2xl font-bold text-[#1C1C1E] mr-2">{provider.rating}</span>
              <div className="flex">
                {[1, 2, 3, 4, 5].map((star) => (
                  <Star key={star} size={16} className="text-yellow-400 fill-current" />
                ))}
              </div>
              <span className="text-sm text-[#6E6E73] ml-2">({provider.reviewCount} reviews)</span>
            </div>
            
            <div className="space-y-2">
              {ratingBreakdown.map((rating) => (
                <div key={rating.stars} className="flex items-center space-x-2">
                  <span className="text-xs text-[#6E6E73] w-8">{rating.stars}★</span>
                  <div className="flex-1 bg-gray-200 rounded-full h-2">
                    <div 
                      className="bg-yellow-400 h-2 rounded-full" 
                      style={{ width: `${rating.percentage}%` }}
                    />
                  </div>
                  <span className="text-xs text-[#6E6E73] w-8">{rating.percentage}%</span>
                </div>
              ))}
            </div>
          </div>
          
          {/* Review Images Carousel */}
          <div className="mb-4">
            <h4 className="text-sm font-semibold text-[#1C1C1E] mb-2">Client Photos</h4>
            <div className="flex overflow-x-auto space-x-3 pb-2">
              {provider.reviews.map((review, index) => (
                <div key={index} className="flex-shrink-0">
                  <img 
                    src={review.image} 
                    alt={`Review by ${review.name}`}
                    className="w-20 h-20 rounded-xl object-cover"
                  />
                </div>
              ))}
            </div>
          </div>
          
          {/* Recent Reviews */}
          <div className="space-y-4">
            {provider.reviews.slice(0, 3).map((review, index) => (
              <div key={index} className="border-l-2 border-[#5E50A1] pl-4">
                <div className="flex items-center mb-2">
                  <span className="font-medium text-[#1C1C1E] text-sm mr-2">{review.name}</span>
                  <div className="flex">
                    {[1, 2, 3, 4, 5].map((star) => (
                      <Star 
                        key={star} 
                        size={12} 
                        className={star <= review.rating ? "text-yellow-400 fill-current" : "text-gray-300"} 
                      />
                    ))}
                  </div>
                </div>
                <p className="text-sm text-[#6E6E73]">{review.text}</p>
              </div>
            ))}
          </div>
        </div>

        {/* Location Section */}
        <div className="py-6">
          <h3 className="text-lg font-bold text-[#1C1C1E] mb-3">Location</h3>
          
          <div className="bg-gray-100 rounded-xl h-32 mb-3 flex items-center justify-center">
            <div className="text-center">
              <MapPin size={24} className="text-[#6E6E73] mx-auto mb-2" />
              <span className="text-sm text-[#6E6E73]">Map Preview</span>
            </div>
          </div>
          
          <div>
            <p className="font-medium text-[#1C1C1E] text-sm mb-1">{provider.location.area}</p>
            <p className="text-xs text-[#6E6E73]">{provider.location.description}</p>
          </div>
        </div>
      </div>

      {/* Persistent Bottom Actions */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 px-4 py-3 z-10">
        <div className="flex space-x-3">
          <Button 
            variant="outline" 
            size="sm" 
            onClick={() => setIsSaved(!isSaved)}
            className="flex-shrink-0"
          >
            <Heart size={16} className={isSaved ? "text-red-500 fill-current" : ""} />
          </Button>
          
          <Button variant="outline" size="sm" className="flex-shrink-0">
            <Share2 size={16} />
          </Button>
          
          <Button className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl">
            Book Appointment
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ClientProviderProfileScreen;
