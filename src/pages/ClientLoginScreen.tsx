
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Eye, EyeOff } from "lucide-react";

const ClientLoginScreen = () => {
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);
  const [formData, setFormData] = useState({
    email: "",
    password: "",
    rememberMe: false
  });

  const handleInputChange = (field: string, value: string | boolean) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleLogin = () => {
    // Add login logic here
    navigate("/client/home");
  };

  const handleSocialLogin = (provider: string) => {
    console.log(`Logging in with ${provider}`);
    // Add social login logic here
    navigate("/client/home");
  };

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-6">
            EWAJI
          </h1>
        </div>

        {/* Form */}
        <div className="space-y-6">
          <div className="space-y-2">
            <Label htmlFor="email" className="text-gray-700 font-medium">
              Email
            </Label>
            <Input
              id="email"
              type="email"
              value={formData.email}
              onChange={(e) => handleInputChange("email", e.target.value)}
              className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
              placeholder="Enter your email"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="password" className="text-gray-700 font-medium">
              Password
            </Label>
            <div className="relative">
              <Input
                id="password"
                type={showPassword ? "text" : "password"}
                value={formData.password}
                onChange={(e) => handleInputChange("password", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1] pr-12"
                placeholder="Enter your password"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
              </button>
            </div>
          </div>

          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <Checkbox
                id="remember"
                checked={formData.rememberMe}
                onCheckedChange={(checked) => handleInputChange("rememberMe", checked as boolean)}
              />
              <Label htmlFor="remember" className="text-gray-600 text-sm">
                Remember me
              </Label>
            </div>
            <button className="text-[#5E50A1] text-sm font-medium hover:underline">
              Forgot Password?
            </button>
          </div>

          <Button
            onClick={handleLogin}
            className="w-full h-12 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
          >
            Log In
          </Button>

          {/* Divider */}
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-gray-200" />
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-4 bg-white text-gray-500">OR</span>
            </div>
          </div>

          {/* Social Login */}
          <div className="space-y-3">
            <Button
              onClick={() => handleSocialLogin("Apple")}
              variant="outline"
              className="w-full h-12 rounded-xl border-gray-200 text-gray-700 hover:bg-gray-50"
            >
              Continue with Apple
            </Button>
            <Button
              onClick={() => handleSocialLogin("Google")}
              variant="outline"
              className="w-full h-12 rounded-xl border-gray-200 text-gray-700 hover:bg-gray-50"
            >
              Continue with Google
            </Button>
            <Button
              onClick={() => handleSocialLogin("Facebook")}
              variant="outline"
              className="w-full h-12 rounded-xl border-gray-200 text-gray-700 hover:bg-gray-50"
            >
              Continue with Facebook
            </Button>
          </div>

          <div className="text-center">
            <p className="text-gray-600">
              Don't have an account?{" "}
              <button
                onClick={() => navigate("/client/register-step1")}
                className="text-[#5E50A1] font-semibold hover:underline"
              >
                Register
              </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ClientLoginScreen;
