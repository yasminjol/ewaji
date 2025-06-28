
import React from 'react';
import { 
  User, 
  CreditCard, 
  Clock, 
  Bell, 
  HelpCircle, 
  Settings,
  ChevronRight,
  Star,
  MapPin
} from 'lucide-react';
import { Button } from '@/components/ui/button';

const ClientProfileScreen = () => {
  const profileSections = [
    {
      id: 'personal',
      title: 'Personal Info',
      subtitle: 'Name, email, phone number',
      icon: User,
    },
    {
      id: 'payment',
      title: 'Payment Methods',
      subtitle: 'Cards, billing information',
      icon: CreditCard,
    },
    {
      id: 'history',
      title: 'Booking History',
      subtitle: 'Past appointments and reviews',
      icon: Clock,
    },
    {
      id: 'notifications',
      title: 'Notifications',
      subtitle: 'Alerts and preferences',
      icon: Bell,
    },
    {
      id: 'help',
      title: 'Help & Support',
      subtitle: 'FAQ, contact support',
      icon: HelpCircle,
    },
    {
      id: 'settings',
      title: 'Settings',
      subtitle: 'App preferences',
      icon: Settings,
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-4 py-4 border-b border-gray-200">
        <h1 className="text-xl font-bold text-[#1C1C1E]">Profile</h1>
      </div>

      {/* Profile Card */}
      <div className="bg-gradient-to-r from-[#AFBCEB] to-[#5E50A1] mx-4 mt-4 rounded-xl p-6 shadow-sm">
        <div className="flex items-center">
          <div className="w-16 h-16 bg-white bg-opacity-20 rounded-full overflow-hidden flex-shrink-0">
            <img src="/placeholder.svg" alt="Profile" className="w-full h-full object-cover" />
          </div>
          <div className="flex-1 ml-4">
            <h2 className="font-bold text-white text-lg">Jessica Smith</h2>
            <div className="flex items-center mt-1">
              <MapPin size={14} className="text-white text-opacity-70 mr-1" />
              <p className="text-white text-opacity-70 text-sm">Atlanta, GA</p>
            </div>
            <div className="flex items-center mt-1">
              <Star size={14} className="text-white text-opacity-70 mr-1" />
              <p className="text-white text-opacity-70 text-sm">Member since Jan 2024</p>
            </div>
          </div>
          <div className="flex-shrink-0">
            <div className="bg-white bg-opacity-20 rounded-lg px-3 py-1">
              <p className="text-white font-semibold text-sm">VIP</p>
            </div>
          </div>
        </div>
      </div>

      {/* Settings Sections */}
      <div className="mt-6 mx-4 space-y-4">
        {profileSections.map((section) => {
          const Icon = section.icon;
          return (
            <button
              key={section.id}
              className="w-full bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-shadow"
            >
              <div className="flex items-center">
                <div className="w-12 h-12 bg-[#AFBCEB] rounded-full flex items-center justify-center flex-shrink-0">
                  <Icon size={20} className="text-[#5E50A1]" />
                </div>
                <div className="flex-1 ml-4 text-left">
                  <h3 className="font-semibold text-[#1C1C1E]">{section.title}</h3>
                  <p className="text-sm text-[#6E6E73] mt-1">{section.subtitle}</p>
                </div>
                <ChevronRight size={20} className="text-[#6E6E73]" />
              </div>
            </button>
          );
        })}
      </div>

      {/* Sign Out Button */}
      <div className="mx-4 mt-8 mb-8">
        <Button
          variant="outline"
          className="w-full h-12 border-2 border-red-500 text-red-500 hover:bg-red-50 hover:border-red-600 rounded-xl font-semibold"
        >
          Sign Out
        </Button>
      </div>
    </div>
  );
};

export default ClientProfileScreen;
