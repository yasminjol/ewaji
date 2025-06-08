
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import WelcomeScreen from "./pages/WelcomeScreen";
import ProviderLoginScreen from "./pages/ProviderLoginScreen";
import ProviderRegisterStep1Screen from "./pages/ProviderRegisterStep1Screen";
import ProviderRegisterStep2Screen from "./pages/ProviderRegisterStep2Screen";
import ProviderPhoneOTPScreen from "./pages/ProviderPhoneOTPScreen";
import ProviderSuccessScreen from "./pages/ProviderSuccessScreen";
import ProviderDashboardTabs from "./pages/ProviderDashboardTabs";
import ClientLoginScreen from "./pages/ClientLoginScreen";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<WelcomeScreen />} />
          <Route path="/provider/login" element={<ProviderLoginScreen />} />
          <Route path="/provider/register-step1" element={<ProviderRegisterStep1Screen />} />
          <Route path="/provider/register-step2" element={<ProviderRegisterStep2Screen />} />
          <Route path="/provider/phone-otp" element={<ProviderPhoneOTPScreen />} />
          <Route path="/provider/success" element={<ProviderSuccessScreen />} />
          <Route path="/provider/dashboard" element={<ProviderDashboardTabs />} />
          <Route path="/client/login" element={<ClientLoginScreen />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
