
import { useState } from "react";
import { Routes, Route } from "react-router-dom";
import ClientBottomNav from "@/components/client/ClientBottomNav";
import ClientHomeScreen from "@/components/client/ClientHomeScreen";
import ClientExploreScreen from "@/components/client/ClientExploreScreen";
import ClientAppointmentsScreen from "@/components/client/ClientAppointmentsScreen";
import ClientInboxScreen from "@/components/client/ClientInboxScreen";
import ClientProfileScreen from "@/components/client/ClientProfileScreen";
import ClientPaymentsScreen from "@/components/client/ClientPaymentsScreen";
import ClientSettingsScreen from "@/components/client/ClientSettingsScreen";
import ClientHelpScreen from "@/components/client/ClientHelpScreen";

const ClientApp = () => {
  return (
    <div className="min-h-screen bg-white flex flex-col">
      <div className="flex-1 overflow-auto pb-20">
        <Routes>
          <Route path="/home" element={<ClientHomeScreen />} />
          <Route path="/explore" element={<ClientExploreScreen />} />
          <Route path="/appointments" element={<ClientAppointmentsScreen />} />
          <Route path="/inbox" element={<ClientInboxScreen />} />
          <Route path="/profile" element={<ClientProfileScreen />} />
          <Route path="/profile/payments" element={<ClientPaymentsScreen />} />
          <Route path="/profile/settings" element={<ClientSettingsScreen />} />
          <Route path="/profile/help" element={<ClientHelpScreen />} />
        </Routes>
      </div>
      <ClientBottomNav />
    </div>
  );
};

export default ClientApp;
