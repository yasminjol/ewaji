
import { useState } from "react";
import { ArrowLeft, Camera, Image, Trash2, Edit } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";

interface FormData {
  firstName: string;
  lastName: string;
  displayName: string;
  pronouns: string;
  businessName: string;
  tagline: string;
  bio: string;
  email: string;
  phone: string;
  location: string;
}

const AccountInfoScreen = ({ onBack }: { onBack: () => void }) => {
  const { toast } = useToast();
  const [avatarPickerOpen, setAvatarPickerOpen] = useState(false);
  const [hasAvatar, setHasAvatar] = useState(true);
  const [hasChanges, setHasChanges] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});
  
  const [formData, setFormData] = useState<FormData>({
    firstName: "Sarah",
    lastName: "Williams",
    displayName: "Sarah Williams",
    pronouns: "She/Her",
    businessName: "Sarah's Beauty Studio",
    tagline: "Making you look and feel beautiful",
    bio: "Professional hair stylist and makeup artist with 8+ years of experience. Specializing in bridal, special events, and everyday glam.",
    email: "sarah@beautyestudio.com",
    phone: "+1 (555) 123-4567",
    location: "Los Angeles, CA"
  });

  const handleInputChange = (field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    setHasChanges(true);
    
    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: "" }));
    }
  };

  const validateForm = () => {
    const newErrors: Record<string, string> = {};
    
    if (!formData.firstName.trim()) {
      newErrors.firstName = "First name is required";
    }
    if (!formData.businessName.trim()) {
      newErrors.businessName = "Business name is required";
    }
    if (!formData.email.trim()) {
      newErrors.email = "Email is required";
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Please enter a valid email";
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSave = () => {
    if (validateForm()) {
      toast({
        title: "Profile updated ✅",
        description: "Your account information has been saved.",
      });
      setHasChanges(false);
    }
  };

  const avatarOptions = [
    { id: "camera", label: "Take Photo", icon: Camera },
    { id: "gallery", label: "Choose from Gallery", icon: Image },
    ...(hasAvatar ? [{ id: "remove", label: "Remove Photo", icon: Trash2, destructive: true }] : [])
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top Bar */}
      <div className="bg-white px-4 py-3 shadow-sm sticky top-0 z-10">
        <div className="flex items-center">
          <button 
            onClick={onBack}
            className="p-2 -ml-2 text-gray-700 hover:bg-gray-100 rounded-full"
          >
            <ArrowLeft size={24} />
          </button>
          <h1 className="text-xl font-bold text-gray-900 ml-2">Account Info</h1>
        </div>
      </div>

      {/* Content */}
      <div className="p-6 pb-32 space-y-6">
        {/* Avatar Block */}
        <div className="flex flex-col items-center space-y-6">
          <div className="relative">
            <div className="w-24 h-24 bg-gray-200 rounded-full overflow-hidden flex items-center justify-center">
              {hasAvatar ? (
                <img src="/placeholder.svg" alt="Profile" className="w-full h-full object-cover" />
              ) : (
                <Camera size={32} className="text-gray-400" />
              )}
            </div>
            <button
              onClick={() => setAvatarPickerOpen(true)}
              className="absolute -bottom-1 -right-1 w-6 h-6 bg-[#5E50A1] rounded-full flex items-center justify-center shadow-md"
            >
              <Edit size={12} className="text-white" />
            </button>
          </div>
        </div>

        {/* Personal Details */}
        <div className="space-y-4">
          <h2 className="text-lg font-semibold text-gray-900">Personal Details</h2>
          
          <div className="space-y-4">
            <div>
              <Label htmlFor="firstName" className="text-sm font-medium text-gray-700">
                First Name *
              </Label>
              <Input
                id="firstName"
                value={formData.firstName}
                onChange={(e) => handleInputChange("firstName", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="Enter your first name"
              />
              {errors.firstName && (
                <p className="text-xs text-red-500 mt-1">{errors.firstName}</p>
              )}
            </div>

            <div>
              <Label htmlFor="lastName" className="text-sm font-medium text-gray-700">
                Last Name
              </Label>
              <Input
                id="lastName"
                value={formData.lastName}
                onChange={(e) => handleInputChange("lastName", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="Enter your last name"
              />
            </div>

            <div>
              <Label htmlFor="displayName" className="text-sm font-medium text-gray-700">
                Display Name
              </Label>
              <Input
                id="displayName"
                value={formData.displayName}
                onChange={(e) => handleInputChange("displayName", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="Name shown to clients"
              />
            </div>

            <div>
              <Label htmlFor="pronouns" className="text-sm font-medium text-gray-700">
                Pronouns (optional)
              </Label>
              <select
                id="pronouns"
                value={formData.pronouns}
                onChange={(e) => handleInputChange("pronouns", e.target.value)}
                className="mt-1 w-full h-12 px-3 rounded-xl border border-gray-300 bg-white focus:outline-none focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
              >
                <option value="">Select pronouns</option>
                <option value="He/Him">He/Him</option>
                <option value="She/Her">She/Her</option>
                <option value="They/Them">They/Them</option>
              </select>
            </div>
          </div>
        </div>

        {/* Business Details */}
        <div className="space-y-4">
          <h2 className="text-lg font-semibold text-gray-900">Business Details</h2>
          
          <div className="space-y-4">
            <div>
              <Label htmlFor="businessName" className="text-sm font-medium text-gray-700">
                Business Name *
              </Label>
              <Input
                id="businessName"
                value={formData.businessName}
                onChange={(e) => handleInputChange("businessName", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="Your business or studio name"
              />
              {errors.businessName && (
                <p className="text-xs text-red-500 mt-1">{errors.businessName}</p>
              )}
            </div>

            <div>
              <Label htmlFor="tagline" className="text-sm font-medium text-gray-700">
                Tagline (optional)
              </Label>
              <Input
                id="tagline"
                value={formData.tagline}
                onChange={(e) => handleInputChange("tagline", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="Brief description of your services"
              />
            </div>

            <div>
              <Label htmlFor="bio" className="text-sm font-medium text-gray-700">
                Short Bio
              </Label>
              <Textarea
                id="bio"
                value={formData.bio}
                onChange={(e) => handleInputChange("bio", e.target.value)}
                className="mt-1 rounded-xl border-gray-300 resize-none"
                rows={3}
                placeholder="Tell clients about your experience and specialties"
              />
            </div>
          </div>
        </div>

        {/* Contact Details */}
        <div className="space-y-4">
          <h2 className="text-lg font-semibold text-gray-900">Contact Details</h2>
          
          <div className="space-y-4">
            <div>
              <Label htmlFor="email" className="text-sm font-medium text-gray-700">
                Email *
              </Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => handleInputChange("email", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="your@email.com"
              />
              {errors.email && (
                <p className="text-xs text-red-500 mt-1">{errors.email}</p>
              )}
            </div>

            <div>
              <Label htmlFor="phone" className="text-sm font-medium text-gray-700">
                Phone Number
              </Label>
              <Input
                id="phone"
                type="tel"
                value={formData.phone}
                onChange={(e) => handleInputChange("phone", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="+1 (555) 123-4567"
              />
            </div>

            <div>
              <Label htmlFor="location" className="text-sm font-medium text-gray-700">
                Location
              </Label>
              <Input
                id="location"
                value={formData.location}
                onChange={(e) => handleInputChange("location", e.target.value)}
                className="mt-1 h-12 rounded-xl border-gray-300"
                placeholder="City, State"
              />
            </div>
          </div>
        </div>
      </div>

      {/* Sticky Save Button */}
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-6 pb-8">
        <Button
          onClick={handleSave}
          disabled={!hasChanges}
          className={`w-full h-13 rounded-xl font-semibold ${
            hasChanges 
              ? "bg-[#5E50A1] hover:bg-[#4F4391] text-white" 
              : "bg-[#AFBCEB] text-white cursor-not-allowed"
          }`}
        >
          Save Changes
        </Button>
      </div>

      {/* Avatar Picker Modal */}
      <Dialog open={avatarPickerOpen} onOpenChange={setAvatarPickerOpen}>
        <DialogContent className="sm:max-w-md bottom-0 translate-y-0 rounded-t-xl rounded-b-none">
          <DialogHeader>
            <div className="w-9 h-1 bg-gray-300 rounded-full mx-auto mb-4" />
            <DialogTitle className="text-center">Change Profile Photo</DialogTitle>
          </DialogHeader>
          
          <div className="space-y-2">
            {avatarOptions.map((option) => {
              const Icon = option.icon;
              return (
                <button
                  key={option.id}
                  onClick={() => {
                    if (option.id === "remove") {
                      setHasAvatar(false);
                    }
                    setAvatarPickerOpen(false);
                    setHasChanges(true);
                  }}
                  className={`w-full flex items-center space-x-3 p-3 rounded-lg hover:bg-gray-50 transition-colors ${
                    option.destructive ? "text-red-500" : "text-gray-700"
                  }`}
                >
                  <Icon size={20} />
                  <span className="font-medium">{option.label}</span>
                </button>
              );
            })}
            
            <button
              onClick={() => setAvatarPickerOpen(false)}
              className="w-full p-3 mt-4 text-gray-500 font-medium border-t border-gray-200"
            >
              Cancel
            </button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default AccountInfoScreen;
