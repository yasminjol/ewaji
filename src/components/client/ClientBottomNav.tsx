
import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Home, Search, Calendar, MessageCircle, User } from 'lucide-react';

const ClientBottomNav = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { id: 'home', label: 'Home', icon: Home, path: '/client' },
    { id: 'explore', label: 'Explore', icon: Search, path: '/client/explore' },
    { id: 'appointments', label: 'Appointments', icon: Calendar, path: '/client/appointments' },
    { id: 'inbox', label: 'Inbox', icon: MessageCircle, path: '/client/inbox' },
    { id: 'profile', label: 'Profile', icon: User, path: '/client/profile' },
  ];

  const isActive = (path: string) => {
    if (path === '/client') {
      return location.pathname === '/client/login' || location.pathname === '/client';
    }
    return location.pathname === path;
  };

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-2 py-2 z-50">
      <div className="flex justify-around items-center max-w-sm mx-auto">
        {navItems.map((item) => {
          const Icon = item.icon;
          const active = isActive(item.path);
          
          return (
            <button
              key={item.id}
              onClick={() => navigate(item.path)}
              className={`flex flex-col items-center justify-center p-2 rounded-lg transition-colors min-w-0 flex-1 ${
                active ? 'text-[#5E50A1]' : 'text-[#6E6E73]'
              }`}
            >
              <Icon size={24} className={`mb-1 ${active ? 'text-[#5E50A1]' : 'text-[#6E6E73]'}`} />
              <span className={`text-xs font-medium ${active ? 'text-[#5E50A1]' : 'text-[#6E6E73]'}`}>
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default ClientBottomNav;
