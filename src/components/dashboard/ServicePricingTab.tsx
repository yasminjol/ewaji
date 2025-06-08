
import { useState } from "react";
import { Plus, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";

const ServicePricingTab = () => {
  const [showModal, setShowModal] = useState(false);
  const [services, setServices] = useState([
    {
      id: 1,
      name: "Protective Braids",
      duration: "3 hours",
      price: 85,
      deposit: 25,
      active: true
    },
    {
      id: 2,
      name: "Natural Makeup",
      duration: "1 hour",
      price: 65,
      deposit: 20,
      active: true
    },
    {
      id: 3,
      name: "Hair Color Treatment",
      duration: "4 hours",
      price: 120,
      deposit: 40,
      active: false
    }
  ]);

  const toggleService = (id: number) => {
    setServices(services.map(service => 
      service.id === id ? { ...service, active: !service.active } : service
    ));
  };

  const deleteService = (id: number) => {
    setServices(services.filter(service => service.id !== id));
  };

  return (
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

      {/* Service List */}
      <div className="space-y-3">
        {services.map((service) => (
          <div key={service.id} className="bg-white rounded-xl p-4 shadow-sm">
            <div className="flex items-center justify-between">
              <div className="flex-1">
                <div className="flex items-center justify-between mb-1">
                  <h3 className="font-semibold text-gray-900">{service.name}</h3>
                  <span className="text-lg font-bold text-gray-900">${service.price}</span>
                </div>
                <p className="text-sm text-gray-600">
                  {service.duration} • ${service.deposit} deposit
                </p>
              </div>
            </div>
            
            <div className="flex items-center justify-between mt-3">
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
        ))}
      </div>

      {/* New Service Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl p-6 w-full max-w-sm">
            <h2 className="text-xl font-bold text-gray-900 mb-4">New Service</h2>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Service Name
                </label>
                <input
                  type="text"
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
                  placeholder="Enter service name"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Duration
                </label>
                <select className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent">
                  <option>30 minutes</option>
                  <option>1 hour</option>
                  <option>2 hours</option>
                  <option>3 hours</option>
                  <option>4+ hours</option>
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Price
                </label>
                <input
                  type="number"
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
                  placeholder="0"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Deposit (Optional)
                </label>
                <input
                  type="number"
                  className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
                  placeholder="0"
                />
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
                onClick={() => setShowModal(false)}
                className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white"
              >
                Save
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ServicePricingTab;
