
import { 
  User, 
  CreditCard, 
  Share2, 
  FileText, 
  BarChart3, 
  HelpCircle,
  Search,
  LogOut
} from "lucide-react";
import { Button } from "@/components/ui/button";

const SettingsTab = () => {
  const settingsCards = [
    {
      id: 1,
      title: "Account Info",
      caption: "Profile, personal details",
      icon: User,
      color: "bg-blue-500"
    },
    {
      id: 2,
      title: "Payments",
      caption: "Banking, payouts, taxes",
      icon: CreditCard,
      color: "bg-green-500"
    },
    {
      id: 3,
      title: "Social Media",
      caption: "Connect your accounts",
      icon: Share2,
      color: "bg-purple-500"
    },
    {
      id: 4,
      title: "Policies",
      caption: "Terms, cancellation rules",
      icon: FileText,
      color: "bg-orange-500"
    },
    {
      id: 5,
      title: "Metrics",
      caption: "Performance analytics",
      icon: BarChart3,
      color: "bg-pink-500"
    },
    {
      id: 6,
      title: "Help & Support",
      caption: "FAQ, contact support",
      icon: HelpCircle,
      color: "bg-indigo-500"
    }
  ];

  return (
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
          className="block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-xl leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-2 focus:ring-[#5E50A1] focus:border-transparent"
          placeholder="Search settings..."
        />
      </div>

      {/* Settings Grid */}
      <div className="grid grid-cols-2 gap-4">
        {settingsCards.map((setting) => {
          const Icon = setting.icon;
          return (
            <button
              key={setting.id}
              className="bg-white rounded-xl p-4 shadow-sm text-left hover:shadow-md transition-shadow"
            >
              <div className="space-y-3">
                <div className={`w-10 h-10 ${setting.color} rounded-full flex items-center justify-center`}>
                  <Icon size={20} className="text-white" />
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
      <div className="bg-gradient-to-r from-[#D8DBF6] to-[#AFBCEB] rounded-xl p-4">
        <div className="flex items-center space-x-3">
          <div className="w-12 h-12 bg-white rounded-full overflow-hidden">
            <img src="/placeholder.svg" alt="Profile" className="w-full h-full object-cover" />
          </div>
          <div className="flex-1">
            <h3 className="font-semibold text-gray-900">Sarah Williams</h3>
            <p className="text-sm text-gray-600">Hair & Makeup Artist</p>
            <p className="text-xs text-gray-500">Member since Dec 2023</p>
          </div>
          <div className="text-right">
            <p className="text-lg font-bold text-[#5E50A1]">4.9★</p>
            <p className="text-xs text-gray-600">156 reviews</p>
          </div>
        </div>
      </div>

      {/* Log Out Button */}
      <div className="pt-4">
        <Button
          variant="outline"
          className="w-full border-red-200 text-red-600 hover:bg-red-50 hover:border-red-300"
        >
          <LogOut size={16} className="mr-2" />
          Log Out
        </Button>
      </div>
    </div>
  );
};

export default SettingsTab;
