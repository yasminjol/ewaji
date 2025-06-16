
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Check } from "lucide-react";

const ProviderRegisterStep2Screen = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    businessName: "",
    streetAddress: "",
    city: "",
    postalCode: "",
    phoneNumber: ""
  });

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleContinue = () => {
    navigate("/provider/categories");
  };

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-xl font-bold text-gray-900 mb-2 leading-tight">
            Make your business official and secure with us!
          </h1>
        </div>

        {/* Form */}
        <div className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="businessName" className="text-gray-700 font-medium">
              Business Name
            </Label>
            <Input
              id="businessName"
              type="text"
              value={formData.businessName}
              onChange={(e) => handleInputChange("businessName", e.target.value)}
              className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
              placeholder="Enter business name"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="streetAddress" className="text-gray-700 font-medium">
              Street Address
            </Label>
            <Input
              id="streetAddress"
              type="text"
              value={formData.streetAddress}
              onChange={(e) => handleInputChange("streetAddress", e.target.value)}
              className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
              placeholder="Enter street address"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="city" className="text-gray-700 font-medium">
                City
              </Label>
              <Input
                id="city"
                type="text"
                value={formData.city}
                onChange={(e) => handleInputChange("city", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
                placeholder="City"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="postalCode" className="text-gray-700 font-medium">
                Postal Code
              </Label>
              <Input
                id="postalCode"
                type="text"
                value={formData.postalCode}
                onChange={(e) => handleInputChange("postalCode", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
                placeholder="Code"
              />
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="phoneNumber" className="text-gray-700 font-medium">
              Phone Number
            </Label>
            <div className="relative">
              <Input
                id="phoneNumber"
                type="tel"
                value={formData.phoneNumber}
                onChange={(e) => handleInputChange("phoneNumber", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1] pr-12"
                placeholder="+1 (555) 123-4567"
              />
              <div className="absolute right-3 top-1/2 transform -translate-y-1/2">
                <Check size={20} className="text-green-500" />
              </div>
            </div>
          </div>

          <div className="pt-4">
            <Button
              onClick={handleContinue}
              className="w-full h-14 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
            >
              Continue
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProviderRegisterStep2Screen;
