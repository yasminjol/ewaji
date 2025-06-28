
import { useLocation, useNavigate } from "react-router-dom";
import { Home, Search, Calendar, MessageSquare, User } from "lucide-react";

const ClientBottomNav = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const tabs = [
    { id: 'home', label: 'Home', icon: Home, path: '/client/home' },
    { id: 'explore', label: 'Explore', icon: Search, path: '/client/explore' },
    { id: 'appointments', label: 'Appointments', icon: Calendar, path: '/client/appointments' },
    { id: 'inbox', label: 'Inbox', icon: MessageSquare, path: '/client/inbox' },
    { id: 'profile', label: 'Profile', icon: User, path: '/client/profile' },
  ];

  const isActive = (path: string) => {
    if (path === '/client/profile') {
      return location.pathname.startsWith('/client/profile');
    }
    return location.pathname === path;
  };

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-4 py-2 z-50">
      <div className="flex items-center justify-around">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const active = isActive(tab.path);
          
          return (
            <button
              key={tab.id}
              onClick={() => navigate(tab.path)}
              className="flex flex-col items-center p-2 min-w-0 transition-colors"
            >
              <Icon 
                size={24} 
                className={active ? "text-[#5E50A1]" : "text-[#6E6E73]"}
              />
              <span 
                className={`text-xs mt-1 ${
                  active ? "text-[#5E50A1] font-medium" : "text-[#6E6E73]"
                }`}
              >
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default ClientBottomNav;
