
import { useState, useEffect } from "react";
import { Plus, Trash2, Info } from "lucide-react";
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
}

const serviceTemplates = {
  braider: [
    { name: "Box Braids", duration: "4 hours", defaultPrice: 120 },
    { name: "Knotless Braids", duration: "5 hours", defaultPrice: 150 },
    { name: "Fulani Braids", duration: "3 hours", defaultPrice: 100 },
    { name: "Boho Twists", duration: "3 hours", defaultPrice: 110 }
  ],
  "nail-tech": [
    { name: "Acrylics", duration: "2 hours", defaultPrice: 65 },
    { name: "Gel-X", duration: "1.5 hours", defaultPrice: 55 },
    { name: "Shellac", duration: "1 hour", defaultPrice: 45 }
  ],
  barber: [
    { name: "Haircut & Style", duration: "1 hour", defaultPrice: 35 },
    { name: "Beard Trim", duration: "30 minutes", defaultPrice: 20 },
    { name: "Hot Towel Shave", duration: "45 minutes", defaultPrice: 30 }
  ],
  "lash-tech": [
    { name: "Classic Lashes", duration: "2 hours", defaultPrice: 80 },
    { name: "Volume Lashes", duration: "2.5 hours", defaultPrice: 120 },
    { name: "Lash Fill", duration: "1.5 hours", defaultPrice: 60 }
  ],
  colorist: [
    { name: "Full Color", duration: "3 hours", defaultPrice: 140 },
    { name: "Highlights", duration: "4 hours", defaultPrice: 180 },
    { name: "Root Touch-up", duration: "2 hours", defaultPrice: 90 }
  ],
  "wig-maker": [
    { name: "Custom Wig Install", duration: "3 hours", defaultPrice: 200 },
    { name: "Wig Styling", duration: "2 hours", defaultPrice: 85 },
    { name: "Wig Maintenance", duration: "1 hour", defaultPrice: 50 }
  ],
  loctician: [
    { name: "Starter Locs", duration: "4 hours", defaultPrice: 150 },
    { name: "Loc Retwist", duration: "2 hours", defaultPrice: 80 },
    { name: "Loc Maintenance", duration: "1.5 hours", defaultPrice: 65 }
  ],
  esthetician: [
    { name: "Deep Cleansing Facial", duration: "1.5 hours", defaultPrice: 85 },
    { name: "Anti-Aging Treatment", duration: "2 hours", defaultPrice: 120 },
    { name: "Acne Treatment", duration: "1 hour", defaultPrice: 70 }
  ]
};

const ServicePricingTab = () => {
  const { toast } = useToast();
  const [showModal, setShowModal] = useState(false);
  const [showUpgradeBanner, setShowUpgradeBanner] = useState(true);
  const [services, setServices] = useState<Service[]>([]);
  const [newService, setNewService] = useState({
    name: "",
    duration: "",
    price: 0
  });

  useEffect(() => {
    // Get selected categories from localStorage and generate initial services
    const selectedCategories = JSON.parse(localStorage.getItem('selectedCategories') || '[]');
    
    if (selectedCategories.length > 0) {
      const generatedServices: Service[] = [];
      let serviceId = 1;

      selectedCategories.forEach((categoryId: string) => {
        const templates = serviceTemplates[categoryId as keyof typeof serviceTemplates];
        if (templates) {
          templates.forEach((template) => {
            generatedServices.push({
              id: serviceId++,
              name: template.name,
              duration: template.duration,
              price: template.defaultPrice,
              deposit: Math.round(template.defaultPrice * 0.2), // 20% deposit
              active: false, // Start with services OFF
              category: categoryId
            });
          });
        }
      });

      setServices(generatedServices);
    }
  }, []);

  const toggleService = (id: number) => {
    setServices(services.map(service => 
      service.id === id ? { ...service, active: !service.active } : service
    ));
  };

  const deleteService = (id: number) => {
    setServices(services.filter(service => service.id !== id));
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

    setServices(services.map(service => 
      service.id === id ? { 
        ...service, 
        price: newPrice,
        deposit: Math.round(newPrice * 0.2) // Auto-update 20% deposit
      } : service
    ));
  };

  const updateServiceDuration = (id: number, newDuration: string) => {
    setServices(services.map(service => 
      service.id === id ? { ...service, duration: newDuration } : service
    ));
  };

  const handleAddService = () => {
    if (!newService.name || !newService.duration || newService.price < 1) {
      toast({
        title: "Invalid Service",
        description: "Please fill all fields with valid values (price ≥ $1.00)",
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
      category: "custom"
    };

    setServices([...services, service]);
    setNewService({ name: "", duration: "", price: 0 });
    setShowModal(false);
    
    toast({
      title: "Service Added",
      description: "Your new service has been added successfully."
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
                  onClick={() => {
                    toast({
                      title: "Upgrade Coming Soon",
                      description: "Pro features will be available soon!"
                    });
                  }}
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
              <h2 className="text-lg font-semibold text-gray-900 border-b border-gray-200 pb-2">
                {getCategoryDisplayName(categoryId)}
              </h2>
              
              {categoryServices.map((service) => (
                <div key={service.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
                  <div className="space-y-4">
                    {/* Service Header */}
                    <div className="flex items-center justify-between">
                      <div className="flex-1">
                        <h3 className="font-semibold text-gray-900">{service.name}</h3>
                        <div className="flex items-center space-x-4 mt-2">
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
                              </SelectContent>
                            </Select>
                          </div>
                        </div>
                      </div>
                      
                      <div className="flex items-center space-x-2">
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
                      </div>
                    </div>
                    
                    {/* Service Controls */}
                    <div className="flex items-center justify-between pt-2 border-t border-gray-100">
                      <div className="flex items-center space-x-2">
                        <span className="text-sm text-gray-600">Active</span>
                        <button
                          onClick={() => toggleService(service.id)}
                          className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
                            service.active ? 'bg-[#5E50A1]' : 'bg-gray-300'
                          }`}
                        >
                          <span
                            className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                              service.active ? 'translate-x-6' : 'translate-x-1'
                            }`}
                          />
                        </button>
                      </div>
                      
                      <button
                        onClick={() => deleteService(service.id)}
                        className="p-2 text-red-500 hover:bg-red-50 rounded-lg"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          ))}
        </div>

        {/* New Service Modal */}
        {showModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl p-6 w-full max-w-sm">
              <h2 className="text-xl font-bold text-gray-900 mb-4">New Service</h2>
              
              <div className="space-y-4">
                <div>
                  <Label className="block text-sm font-medium text-gray-700 mb-1">
                    Service Name
                  </Label>
                  <Input
                    type="text"
                    value={newService.name}
                    onChange={(e) => setNewService({...newService, name: e.target.value})}
                    className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
                    placeholder="Enter service name"
                  />
                </div>
                
                <div>
                  <Label className="block text-sm font-medium text-gray-700 mb-1">
                    Duration
                  </Label>
                  <Select
                    value={newService.duration}
                    onValueChange={(value) => setNewService({...newService, duration: value})}
                  >
                    <SelectTrigger className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent">
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
                    </SelectContent>
                  </Select>
                </div>
                
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
                      className="w-full pl-8 px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
                      placeholder="0.00"
                      min="1"
                      step="0.01"
                    />
                  </div>
                  {newService.price > 0 && (
                    <p className="text-sm text-gray-500 mt-1">
                      Deposit: ${Math.round(newService.price * 0.2)} (20%)
                    </p>
                  )}
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
      </div>
    </TooltipProvider>
  );
};

export default ServicePricingTab;
