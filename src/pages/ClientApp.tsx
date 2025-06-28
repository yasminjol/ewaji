
import React from 'react';
import { Routes, Route } from 'react-router-dom';
import ClientBottomNav from '@/components/client/ClientBottomNav';
import ClientHomeScreen from '@/components/client/ClientHomeScreen';
import ClientExploreScreen from '@/components/client/ClientExploreScreen';
import ClientAppointmentsScreen from '@/components/client/ClientAppointmentsScreen';
import ClientInboxScreen from '@/components/client/ClientInboxScreen';
import ClientProfileScreen from '@/components/client/ClientProfileScreen';

const ClientApp = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="pb-16"> {/* Space for bottom navigation */}
        <Routes>
          <Route path="/" element={<ClientHomeScreen />} />
          <Route path="/explore" element={<ClientExploreScreen />} />
          <Route path="/appointments" element={<ClientAppointmentsScreen />} />
          <Route path="/inbox" element={<ClientInboxScreen />} />
          <Route path="/profile" element={<ClientProfileScreen />} />
        </Routes>
      </div>
      <ClientBottomNav />
    </div>
  );
};

export default ClientApp;
