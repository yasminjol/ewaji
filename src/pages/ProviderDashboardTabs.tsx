
import { useState } from "react";
import { Home, Calendar, Settings, Inbox } from "lucide-react";

const ProviderDashboardTabs = () => {
  const [activeTab, setActiveTab] = useState("home");

  const tabs = [
    { id: "home", label: "Home", icon: Home },
    { id: "bookings", label: "Bookings", icon: Calendar },
    { id: "services", label: "Service & Pricing", icon: Settings },
    { id: "inbox", label: "Inbox", icon: Inbox },
    { id: "settings", label: "Settings", icon: Settings }
  ];

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Main Content */}
      <div className="flex-1 p-6">
        <div className="max-w-md mx-auto bg-white rounded-2xl p-8 shadow-sm text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            Provider Dashboard
          </h1>
          <p className="text-gray-600 text-lg">
            Coming Soon
          </p>
          <p className="text-gray-500 text-sm mt-2">
            Your {tabs.find(tab => tab.id === activeTab)?.label} section will be available here.
          </p>
        </div>
      </div>

      {/* Bottom Tab Bar */}
      <div className="bg-white border-t border-gray-200 px-2 py-2">
        <div className="flex justify-around items-center max-w-md mx-auto">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = activeTab === tab.id;
            
            return (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex flex-col items-center py-2 px-3 rounded-lg transition-colors ${
                  isActive 
                    ? "text-[#5E50A1] bg-[#F3F4F6]" 
                    : "text-gray-500 hover:text-gray-700"
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
