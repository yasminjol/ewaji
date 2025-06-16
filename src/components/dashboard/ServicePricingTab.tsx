
import { useState, useEffect } from "react";
import { Plus, Info, Upload, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useToast } from "@/hooks/use-toast";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";

interface Service {
  id: number;
  name: string;
  duration: string;
  price: number;
  deposit: number;
  active: boolean;
  category: string;
  media: string[];
}

const predefinedServices = {
  braider: [
    "Box Braids",
    "Knotless Braids", 
    "Fulani Braids",
    "Boho Twists",
    "Cornrows",
    "Ghana Braids"
  ],
  "nail-tech": [
    "Acrylics",
    "Gel-X",
    "Shellac",
    "Dip Powder",
    "Manicure",
    "Pedicure"
  ],
  barber: [
    "Fade Cut",
    "Line-Up", 
    "Beard Trim",
    "Buzz Cut",
    "Taper Cut",
    "Shape Up"
  ],
  "lash-tech": [
    "Classic Lashes",
    "Volume Lashes",
    "Hybrid Lashes",
    "Lash Fill",
    "Lash Removal"
  ],
  colorist: [
    "Full Color",
    "Highlights",
    "Root Touch-up",
    "Balayage",
    "Color Correction"
  ],
  "wig-maker": [
    "Custom Wig Install",
    "Wig Styling",
    "Wig Maintenance",
    "Lace Frontal Install",
    "360 Lace Install"
  ],
  loctician: [
    "Starter Locs",
    "Loc Retwist",
    "Loc Maintenance",
    "Loc Repair",
    "Loc Extensions"
  ],
  esthetician: [
    "Deep Cleansing Facial",
    "Anti-Aging Treatment",
    "Acne Treatment",
    "Chemical Peel",
    "Microdermabrasion"
  ]
};

const ServicePricingTab = () => {
  const { toast } = useToast();
  const [showModal, setShowModal] = useState(false);
  const [showUpgradeBanner, setShowUpgradeBanner] = useState(true);
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [services, setServices] = useState<Service[]>([]);
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
  const [newService, setNewService] = useState({
    category: "",
    name: "",
    duration: "",
    price: 0,
    media: [] as string[]
  });

  useEffect(() => {
    // Get selected categories from localStorage
    const categories = JSON.parse(localStorage.getItem('selectedCategories') || '[]');
    setSelectedCategories(categories);
    
    // Load existing services or create empty state
    const existingServices = JSON.parse(localStorage.getItem('providerServices') || '[]');
    setServices(existingServices);
  }, []);

  const toggleService = (id: number) => {
    const updatedServices = services.map(service => {
      if (service.id === id) {
        const newActiveState = !service.active;
        toast({
          title: newActiveState ? "Service activated" : "Service deactivated",
          description: newActiveState ? "Service is now visible to clients" : "Service is now hidden from clients"
        });
        return { ...service, active: newActiveState };
      }
      return service;
    });
    
    setServices(updatedServices);
    localStorage.setItem('providerServices', JSON.stringify(updatedServices));
  };

  const updateServicePrice = (id: number, newPrice: number) => {
    if (newPrice < 1) {
      toast({
        title: "Invalid Price",
        description: "Price must be at least $1.00",
        variant: "destructive"
      });
      return;
    }

    const updatedServices = services.map(service => 
      service.id === id ? { 
        ...service, 
        price: newPrice,
        deposit: Math.round(newPrice * 0.2)
      } : service
    );
    
    setServices(updatedServices);
    localStorage.setItem('providerServices', JSON.stringify(updatedServices));
  };

  const updateServiceDuration = (id: number, newDuration: string) => {
    const updatedServices = services.map(service => 
      service.id === id ? { ...service, duration: newDuration } : service
    );
    
    setServices(updatedServices);
    localStorage.setItem('providerServices', JSON.stringify(updatedServices));
  };

  const handleAddService = () => {
    // Check if trying to add service from a third category on free plan
    const serviceCategory = newService.category;
    const usedCategories = [...new Set(services.map(s => s.category))];
    
    if (!selectedCategories.includes(serviceCategory) && selectedCategories.length >= 2) {
      setShowUpgradeModal(true);
      return;
    }

    if (!newService.category || !newService.name || !newService.duration || newService.price < 1) {
      toast({
        title: "Invalid Service",
        description: "Please fill all fields with valid values (price ≥ $1.00)",
        variant: "destructive"
      });
      return;
    }

    // Check if service already exists
    const existingService = services.find(s => 
      s.name === newService.name && s.category === newService.category
    );
    
    if (existingService) {
      toast({
        title: "Service Already Exists",
        description: "This service is already in your list",
        variant: "destructive"
      });
      return;
    }

    const service: Service = {
      id: Math.max(...services.map(s => s.id), 0) + 1,
      name: newService.name,
      duration: newService.duration,
      price: newService.price,
      deposit: Math.round(newService.price * 0.2),
      active: false,
      category: newService.category,
      media: newService.media
    };

    const updatedServices = [...services, service];
    setServices(updatedServices);
    localStorage.setItem('providerServices', JSON.stringify(updatedServices));
    
    setNewService({ category: "", name: "", duration: "", price: 0, media: [] });
    setShowModal(false);
    
    toast({
      title: "Service Added",
      description: "Your new service has been added successfully."
    });
  };

  const removeMedia = (index: number) => {
    setNewService({
      ...newService,
      media: newService.media.filter((_, i) => i !== index)
    });
  };

  const addMedia = () => {
    if (newService.media.length >= 3) {
      toast({
        title: "Media Limit Reached",
        description: "You can add up to 3 media files per service",
        variant: "destructive"
      });
      return;
    }
    
    // Simulate adding media (in real app, this would open file picker)
    const newMediaUrl = `media-${Date.now()}.jpg`;
    setNewService({
      ...newService,
      media: [...newService.media, newMediaUrl]
    });
  };

  // Group services by category
  const groupedServices = services.reduce((acc, service) => {
    if (!acc[service.category]) {
      acc[service.category] = [];
    }
    acc[service.category].push(service);
    return acc;
  }, {} as Record<string, Service[]>);

  const getCategoryDisplayName = (categoryId: string) => {
    const names: Record<string, string> = {
      braider: "Braids",
      "nail-tech": "Nails", 
      barber: "Barber Services",
      "lash-tech": "Lashes",
      colorist: "Color Services",
      "wig-maker": "Wig Services",
      loctician: "Loc Services",
      esthetician: "Facial Services",
      custom: "Custom Services"
    };
    return names[categoryId] || categoryId;
  };

  const getAvailableServices = (category: string) => {
    const predefined = predefinedServices[category as keyof typeof predefinedServices] || [];
    const existing = services.filter(s => s.category === category).map(s => s.name);
    return predefined.filter(service => !existing.includes(service));
  };

  return (
    <TooltipProvider>
      <div className="p-6 space-y-6">
        {/* Header */}
        <div className="flex justify-between items-center">
          <h1 className="text-2xl font-bold text-gray-900">Service & Pricing</h1>
          <Button 
            onClick={() => setShowModal(true)}
            className="bg-[#5E50A1] hover:bg-[#4F4391] text-white rounded-full w-12 h-12 p-0"
          >
            <Plus size={24} />
          </Button>
        </div>

        {/* Upgrade Banner */}
        {showUpgradeBanner && (
          <div className="bg-[#F1F2FF] rounded-xl p-4 border border-[#AFBCEB]">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-900 mb-1">
                  Upgrade to add more categories and unlock Pro analytics
                </p>
              </div>
              <div className="flex items-center space-x-2">
                <Button
                  onClick={() => setShowUpgradeModal(true)}
                  className="bg-[#5E50A1] hover:bg-[#4F4391] text-white text-sm px-4 py-2"
                >
                  Upgrade for $29/mo
                </Button>
                <Button
                  onClick={() => setShowUpgradeBanner(false)}
                  variant="ghost"
                  size="sm"
                  className="text-gray-500"
                >
                  ×
                </Button>
              </div>
            </div>
          </div>
        )}

        {/* Services List */}
        <div className="space-y-6">
          {Object.entries(groupedServices).map(([categoryId, categoryServices]) => (
            <div key={categoryId} className="space-y-3">
              <div className="bg-[#F1F2FF] rounded-lg px-4 py-2 border border-[#AFBCEB]">
                <h2 className="text-lg font-semibold text-[#5E50A1]">
                  {getCategoryDisplayName(categoryId)}
                </h2>
              </div>
              
              {categoryServices.map((service) => (
                <div key={service.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                  <div className="space-y-4">
                    {/* Service Header */}
                    <div className="flex items-center justify-between">
                      <h3 className="font-semibold text-gray-900 text-lg">{service.name}</h3>
                      <div className="flex items-center space-x-2">
                        <span className="text-sm text-gray-600">Active</span>
                        <button
                          onClick={() => toggleService(service.id)}
                          className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
                            service.active ? 'bg-[#5E50A1]' : 'bg-[#D9D9DE]'
                          }`}
                        >
                          <span
                            className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                              service.active ? 'translate-x-6' : 'translate-x-1'
                            }`}
                          />
                        </button>
                      </div>
                    </div>
                    
                    {/* Service Details */}
                    <div className="grid grid-cols-2 gap-4">
                      <div className="flex items-center space-x-2">
                        <Label htmlFor={`price-${service.id}`} className="text-sm text-gray-600">Price:</Label>
                        <div className="relative">
                          <span className="absolute left-2 top-1/2 transform -translate-y-1/2 text-gray-500">$</span>
                          <Input
                            id={`price-${service.id}`}
                            type="number"
                            value={service.price}
                            onChange={(e) => updateServicePrice(service.id, parseFloat(e.target.value) || 0)}
                            className="w-20 h-8 pl-6 text-sm"
                            min="1"
                            step="0.01"
                          />
                        </div>
                      </div>
                      
                      <div className="flex items-center space-x-2">
                        <Label className="text-sm text-gray-600">Duration:</Label>
                        <Select
                          value={service.duration}
                          onValueChange={(value) => updateServiceDuration(service.id, value)}
                        >
                          <SelectTrigger className="w-28 h-8 text-sm">
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="30 minutes">30 min</SelectItem>
                            <SelectItem value="1 hour">1 hour</SelectItem>
                            <SelectItem value="1.5 hours">1.5 hours</SelectItem>
                            <SelectItem value="2 hours">2 hours</SelectItem>
                            <SelectItem value="2.5 hours">2.5 hours</SelectItem>
                            <SelectItem value="3 hours">3 hours</SelectItem>
                            <SelectItem value="4 hours">4 hours</SelectItem>
                            <SelectItem value="5 hours">5 hours</SelectItem>
                            <SelectItem value="6 hours">6 hours</SelectItem>
                            <SelectItem value="7 hours">7 hours</SelectItem>
                            <SelectItem value="8 hours">8 hours</SelectItem>
                          </SelectContent>
                        </Select>
                      </div>
                    </div>

                    {/* Deposit & Media */}
                    <div className="flex items-center justify-between">
                      <div className="flex items-center bg-[rgba(95,80,161,0.15)] text-[#5E50A1] px-3 py-1 rounded-full text-sm font-medium">
                        <span>Deposit 20% = ${service.deposit}</span>
                        <Tooltip>
                          <TooltipTrigger asChild>
                            <Info size={14} className="ml-1 cursor-help" />
                          </TooltipTrigger>
                          <TooltipContent>
                            <p>20% deposit is auto-charged to clients and held by EWAJI.</p>
                          </TooltipContent>
                        </Tooltip>
                      </div>
                      
                      <div className="flex items-center space-x-2">
                        <span className="text-sm text-gray-600">Media:</span>
                        <div className="flex space-x-1">
                          {service.media.map((_, index) => (
                            <div key={index} className="w-8 h-8 bg-gray-200 rounded border"></div>
                          ))}
                          {service.media.length < 3 && (
                            <div className="w-8 h-8 bg-gray-100 rounded border border-dashed border-gray-300 flex items-center justify-center">
                              <Plus size={12} className="text-gray-400" />
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ))}
        </div>

        {/* Add Service Modal */}
        {showModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl p-6 w-full max-w-md max-h-[90vh] overflow-y-auto">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Add a Service</h2>
              
              <div className="space-y-4">
                <div>
                  <Label className="block text-sm font-medium text-gray-700 mb-1">
                    Select Category
                  </Label>
                  <Select
                    value={newService.category}
                    onValueChange={(value) => setNewService({...newService, category: value, name: ""})}
                  >
                    <SelectTrigger className="w-full">
                      <SelectValue placeholder="Choose category" />
                    </SelectTrigger>
                    <SelectContent>
                      {selectedCategories.map((category) => (
                        <SelectItem key={category} value={category}>
                          {getCategoryDisplayName(category)}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                {newService.category && (
                  <div>
                    <Label className="block text-sm font-medium text-gray-700 mb-1">
                      Select Service
                    </Label>
                    <Select
                      value={newService.name}
                      onValueChange={(value) => setNewService({...newService, name: value})}
                    >
                      <SelectTrigger className="w-full">
                        <SelectValue placeholder="Choose service" />
                      </SelectTrigger>
                      <SelectContent>
                        {getAvailableServices(newService.category).map((service) => (
                          <SelectItem key={service} value={service}>
                            {service}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                )}
                
                <div>
                  <Label className="block text-sm font-medium text-gray-700 mb-1">
                    Price
                  </Label>
                  <div className="relative">
                    <span className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-500">$</span>
                    <Input
                      type="number"
                      value={newService.price || ''}
                      onChange={(e) => setNewService({...newService, price: parseFloat(e.target.value) || 0})}
                      className="w-full pl-8"
                      placeholder="0.00"
                      min="1"
                      step="0.01"
                    />
                  </div>
                  {newService.price > 0 && (
                    <p className="text-sm text-[#5E50A1] mt-1">
                      Deposit 20% = ${Math.round(newService.price * 0.2)}
                    </p>
                  )}
                </div>
                
                <div>
                  <Label className="block text-sm font-medium text-gray-700 mb-1">
                    Duration
                  </Label>
                  <Select
                    value={newService.duration}
                    onValueChange={(value) => setNewService({...newService, duration: value})}
                  >
                    <SelectTrigger className="w-full">
                      <SelectValue placeholder="Select duration" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="30 minutes">30 minutes</SelectItem>
                      <SelectItem value="1 hour">1 hour</SelectItem>
                      <SelectItem value="1.5 hours">1.5 hours</SelectItem>
                      <SelectItem value="2 hours">2 hours</SelectItem>
                      <SelectItem value="2.5 hours">2.5 hours</SelectItem>
                      <SelectItem value="3 hours">3 hours</SelectItem>
                      <SelectItem value="4 hours">4 hours</SelectItem>
                      <SelectItem value="5 hours">5 hours</SelectItem>
                      <SelectItem value="6 hours">6 hours</SelectItem>
                      <SelectItem value="7 hours">7 hours</SelectItem>
                      <SelectItem value="8 hours">8 hours</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div>
                  <Label className="block text-sm font-medium text-gray-700 mb-1">
                    Upload Media (max 3)
                  </Label>
                  <div className="flex items-center space-x-2">
                    {newService.media.map((media, index) => (
                      <div key={index} className="relative w-16 h-16 bg-gray-200 rounded border">
                        <button
                          onClick={() => removeMedia(index)}
                          className="absolute -top-1 -right-1 w-4 h-4 bg-red-500 text-white rounded-full flex items-center justify-center text-xs"
                        >
                          <X size={10} />
                        </button>
                      </div>
                    ))}
                    {newService.media.length < 3 && (
                      <button
                        onClick={addMedia}
                        className="w-16 h-16 bg-gray-100 rounded border border-dashed border-gray-300 flex items-center justify-center"
                      >
                        <Upload size={20} className="text-gray-400" />
                      </button>
                    )}
                  </div>
                </div>
              </div>
              
              <div className="flex space-x-3 mt-6">
                <Button
                  onClick={() => setShowModal(false)}
                  variant="outline"
                  className="flex-1"
                >
                  Cancel
                </Button>
                <Button
                  onClick={handleAddService}
                  className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white"
                >
                  Save
                </Button>
              </div>
            </div>
          </div>
        )}

        {/* Upgrade Modal */}
        {showUpgradeModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl p-6 w-full max-w-sm text-center">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Upgrade to EWAJI Pro</h2>
              <div className="space-y-2 mb-6">
                <p className="text-gray-600">• Add unlimited categories</p>
                <p className="text-gray-600">• Featured placement in AI feed</p>
                <p className="text-gray-600">• Advanced analytics</p>
              </div>
              <div className="space-y-3">
                <Button
                  onClick={() => {
                    toast({
                      title: "Upgrade Coming Soon",
                      description: "Pro features will be available soon!"
                    });
                    setShowUpgradeModal(false);
                  }}
                  className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white"
                >
                  Upgrade for $29/mo
                </Button>
                <Button
                  onClick={() => setShowUpgradeModal(false)}
                  variant="outline"
                  className="w-full"
                >
                  Maybe later
                </Button>
              </div>
            </div>
          </div>
        )}
      </div>
    </TooltipProvider>
  );
};

export default ServicePricingTab;
