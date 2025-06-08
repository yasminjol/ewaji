
import { 
  User, 
  CreditCard, 
  Share2, 
  FileText, 
  BarChart3, 
  HelpCircle,
  Search,
  ArrowRightFromLine
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { useState } from "react";
import AccountInfoScreen from "./AccountInfoScreen";

const SettingsTab = () => {
  const [searchQuery, setSearchQuery] = useState("");
  const [currentScreen, setCurrentScreen] = useState<string>("main");

  const settingsCards = [
    {
      id: 1,
      title: "Account Info",
      caption: "Profile, personal details",
      icon: User,
      action: () => setCurrentScreen("account-info")
    },
    {
      id: 2,
      title: "Payments",
      caption: "Banking, payouts, taxes",
      icon: CreditCard,
      action: () => console.log("Navigate to Payments")
    },
    {
      id: 3,
      title: "Social Media",
      caption: "Connect your accounts",
      icon: Share2,
      action: () => console.log("Navigate to Social Media")
    },
    {
      id: 4,
      title: "Policies",
      caption: "Terms, cancellation rules",
      icon: FileText,
      action: () => console.log("Navigate to Policies")
    },
    {
      id: 5,
      title: "Metrics",
      caption: "Performance analytics",
      icon: BarChart3,
      action: () => console.log("Navigate to Metrics")
    },
    {
      id: 6,
      title: "Help & Support",
      caption: "FAQ, contact support",
      icon: HelpCircle,
      action: () => console.log("Navigate to Help")
    }
  ];

  if (currentScreen === "account-info") {
    return <AccountInfoScreen onBack={() => setCurrentScreen("main")} />;
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      <div className="p-6 space-y-6">
        {/* Header */}
        <h1 className="text-2xl font-bold text-gray-900">Settings</h1>
        
        {/* Search Bar */}
        <div className="relative">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-5 w-5 text-gray-400" />
          </div>
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent shadow-sm"
            placeholder="Search settings..."
          />
        </div>

        {/* Settings Grid */}
        <div className="grid grid-cols-2 gap-5">
          {settingsCards.map((setting) => {
            const Icon = setting.icon;
            return (
              <button
                key={setting.id}
                onClick={setting.action}
                className="bg-gradient-to-br from-[#F7F8FF] to-white rounded-xl p-4 shadow-sm text-left hover:shadow-md transition-all duration-200"
              >
                <div className="space-y-3">
                  <div className="w-12 h-12 bg-[#AFBCEB] rounded-full flex items-center justify-center">
                    <Icon size={20} className="text-[#5E50A1]" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900 text-sm">{setting.title}</h3>
                    <p className="text-xs text-gray-600 mt-1">{setting.caption}</p>
                  </div>
                </div>
              </button>
            );
          })}
        </div>

        {/* Profile Summary Card */}
        <div className="bg-gradient-to-r from-[#AFBCEB] to-[#5E50A1] rounded-xl p-4 h-[120px] shadow-sm">
          <div className="flex items-center h-full">
            <div className="w-16 h-16 bg-white bg-opacity-20 rounded-full overflow-hidden flex-shrink-0">
              <img src="/placeholder.svg" alt="Profile" className="w-full h-full object-cover" />
            </div>
            <div className="flex-1 ml-4">
              <h3 className="font-bold text-white text-lg">Sarah Williams</h3>
              <p className="text-white text-opacity-70 text-sm">Hair & Makeup Artist</p>
              <p className="text-white text-opacity-70 text-xs mt-1">Member since Dec 2023</p>
            </div>
            <div className="flex-shrink-0">
              <div className="bg-white bg-opacity-20 rounded-lg px-3 py-1">
                <p className="text-white font-semibold text-sm">4.9★</p>
              </div>
            </div>
          </div>
        </div>

        {/* Log Out Button */}
        <div className="pt-4 pb-8">
          <Button
            variant="outline"
            className="w-full h-12 border-2 border-red-500 text-red-500 hover:bg-red-50 hover:border-red-600 rounded-xl font-semibold shadow-sm"
          >
            <ArrowRightFromLine size={20} className="mr-2" />
            Log Out
          </Button>
        </div>
      </div>
    </div>
  );
};

export default SettingsTab;
