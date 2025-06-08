
import { useState } from "react";
import { Home, Calendar, Tag, MessageCircle, Settings } from "lucide-react";
import HomeTab from "../components/dashboard/HomeTab";
import BookingsTab from "../components/dashboard/BookingsTab";
import ServicePricingTab from "../components/dashboard/ServicePricingTab";
import InboxTab from "../components/dashboard/InboxTab";
import SettingsTab from "../components/dashboard/SettingsTab";

const ProviderDashboardTabs = () => {
  const [activeTab, setActiveTab] = useState("home");

  const tabs = [
    { id: "home", label: "Home", icon: Home, component: HomeTab },
    { id: "bookings", label: "Bookings", icon: Calendar, component: BookingsTab },
    { id: "services", label: "Service & Pricing", icon: Tag, component: ServicePricingTab },
    { id: "inbox", label: "Inbox", icon: MessageCircle, component: InboxTab },
    { id: "settings", label: "Settings", icon: Settings, component: SettingsTab }
  ];

  const ActiveComponent = tabs.find(tab => tab.id === activeTab)?.component || HomeTab;

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Main Content */}
      <div className="flex-1 pb-20">
        <ActiveComponent />
      </div>

      {/* Bottom Tab Bar */}
      <div className="fixed bottom-0 left-0 right-0 bg-white rounded-t-3xl border-t border-gray-200 px-2 py-2 shadow-lg">
        <div className="flex justify-around items-center max-w-md mx-auto h-16">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = activeTab === tab.id;
            
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex flex-col items-center py-2 px-3 rounded-lg transition-all transform active:scale-95 ${
                  isActive 
                    ? "text-[#5E50A1]" 
                    : "text-[#B0B0B8] hover:text-gray-700"
                }`}
              >
                <Icon size={24} />
                <span className="text-xs mt-1 font-medium">
                  {tab.label}
                </span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default ProviderDashboardTabs;
