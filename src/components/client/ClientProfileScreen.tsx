
import { ChevronRight, User, CreditCard, Clock, Bell, HelpCircle, Settings, Camera } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";

const ClientProfileScreen = () => {
  const navigate = useNavigate();

  const menuItems = [
    {
      icon: User,
      label: "Personal Info",
      description: "Manage your profile details",
      action: () => navigate("/client/profile/personal")
    },
    {
      icon: CreditCard,
      label: "Payment Methods",
      description: "Cards and payment options",
      action: () => navigate("/client/profile/payments")
    },
    {
      icon: Clock,
      label: "Booking History",
      description: "View all your past appointments",
      action: () => navigate("/client/profile/history")
    },
    {
      icon: Bell,
      label: "Notifications",
      description: "Manage your notification preferences",
      action: () => navigate("/client/profile/settings")
    },
    {
      icon: HelpCircle,
      label: "Help & Support",
      description: "Get help and contact support",
      action: () => navigate("/client/profile/help")
    }
  ];

  return (
    <div className="bg-white min-h-screen">
      {/* Header */}
      <div className="p-4 border-b border-gray-100">
        <h1 className="text-2xl font-bold text-[#1C1C1E] text-center">Profile</h1>
      </div>

      {/* Profile Card */}
      <div className="p-6 border-b border-gray-100">
        <div className="flex items-center">
          <div className="relative">
            <img 
              src="https://images.unsplash.com/photo-1494790108755-2616c5e68b05?w=80&h=80&fit=crop&crop=face" 
              alt="Profile"
              className="w-20 h-20 rounded-full object-cover"
            />
            <button className="absolute -bottom-1 -right-1 w-8 h-8 bg-[#5E50A1] rounded-full flex items-center justify-center">
              <Camera size={16} className="text-white" />
            </button>
          </div>
          <div className="ml-4 flex-1">
            <h2 className="text-xl font-semibold text-[#1C1C1E]">Sarah Johnson</h2>
            <p className="text-[#6E6E73]">sarah.johnson@email.com</p>
            <p className="text-[#6E6E73]">+1 (555) 123-4567</p>
          </div>
        </div>
        <Button 
          variant="outline" 
          className="w-full mt-4 border-[#5E50A1] text-[#5E50A1] hover:bg-[#5E50A1] hover:text-white"
        >
          Edit Profile
        </Button>
      </div>

      {/* Menu Items */}
      <div className="p-4 space-y-1">
        {menuItems.map((item, index) => {
          const Icon = item.icon;
          return (
            <button
              key={index}
              onClick={item.action}
              className="w-full flex items-center p-4 rounded-xl hover:bg-gray-50 transition-colors text-left"
            >
              <div className="w-10 h-10 bg-[#AFBCEB]/20 rounded-full flex items-center justify-center">
                <Icon size={20} className="text-[#5E50A1]" />
              </div>
              <div className="ml-4 flex-1">
                <h3 className="font-medium text-[#1C1C1E]">{item.label}</h3>
                <p className="text-sm text-[#6E6E73]">{item.description}</p>
              </div>
              <ChevronRight size={20} className="text-[#6E6E73]" />
            </button>
          );
        })}
      </div>

      {/* App Info */}
      <div className="p-4 mt-6 border-t border-gray-100">
        <div className="text-center">
          <p className="text-sm text-[#6E6E73] mb-2">EWAJI Client App</p>
          <p className="text-xs text-[#6E6E73]">Version 1.0.0</p>
        </div>
      </div>
    </div>
  );
};

export default ClientProfileScreen;
