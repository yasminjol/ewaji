
import { ArrowLeft, Bell, Shield, Globe, Moon, Smartphone } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";

const ClientSettingsScreen = () => {
  const navigate = useNavigate();

  return (
    <div className="bg-white min-h-screen">
      {/* Header */}
      <div className="flex items-center p-4 border-b border-gray-100">
        <Button
          variant="ghost"
          size="icon"
          onClick={() => navigate("/client/profile")}
          className="mr-3"
        >
          <ArrowLeft size={20} className="text-[#5E50A1]" />
        </Button>
        <h1 className="text-xl font-semibold text-[#1C1C1E]">Settings</h1>
      </div>

      {/* Notifications Section */}
      <div className="p-4">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-4">Notifications</h2>
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
            <div className="flex items-center">
              <Bell size={20} className="text-[#5E50A1] mr-3" />
              <div>
                <p className="font-medium text-[#1C1C1E]">Push Notifications</p>
                <p className="text-sm text-[#6E6E73]">Receive booking updates and reminders</p>
              </div>
            </div>
            <Switch defaultChecked />
          </div>

          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
            <div className="flex items-center">
              <Smartphone size={20} className="text-[#5E50A1] mr-3" />
              <div>
                <p className="font-medium text-[#1C1C1E]">SMS Notifications</p>
                <p className="text-sm text-[#6E6E73]">Get text reminders for appointments</p>
              </div>
            </div>
            <Switch />
          </div>
        </div>
      </div>

      {/* Privacy Section */}
      <div className="p-4">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-4">Privacy</h2>
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
            <div className="flex items-center">
              <Shield size={20} className="text-[#5E50A1] mr-3" />
              <div>
                <p className="font-medium text-[#1C1C1E]">Profile Visibility</p>
                <p className="text-sm text-[#6E6E73]">Show your profile to providers</p>
              </div>
            </div>
            <Switch defaultChecked />
          </div>

          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
            <div className="flex items-center">
              <Globe size={20} className="text-[#5E50A1] mr-3" />
              <div>
                <p className="font-medium text-[#1C1C1E]">Location Services</p>
                <p className="text-sm text-[#6E6E73]">Find nearby beauty providers</p>
              </div>
            </div>
            <Switch defaultChecked />
          </div>
        </div>
      </div>

      {/* Appearance Section */}
      <div className="p-4">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-4">Appearance</h2>
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-xl">
            <div className="flex items-center">
              <Moon size={20} className="text-[#5E50A1] mr-3" />
              <div>
                <p className="font-medium text-[#1C1C1E]">Dark Mode</p>
                <p className="text-sm text-[#6E6E73]">Switch to dark theme</p>
              </div>
            </div>
            <Switch />
          </div>
        </div>
      </div>

      {/* Account Actions */}
      <div className="p-4 mt-8">
        <div className="space-y-3">
          <Button
            variant="outline"
            className="w-full text-[#5E50A1] border-[#5E50A1] hover:bg-[#5E50A1] hover:text-white"
          >
            Sign Out
          </Button>
          <Button
            variant="outline"
            className="w-full text-red-600 border-red-200 hover:bg-red-50"
          >
            Delete Account
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ClientSettingsScreen;
