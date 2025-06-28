
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Eye, EyeOff } from "lucide-react";

const ClientRegisterStep1Screen = () => {
  const navigate = useNavigate();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [formData, setFormData] = useState({
    email: "",
    password: "",
    confirmPassword: ""
  });

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleContinue = () => {
    // Add validation logic here
    navigate("/client/register-step2");
  };

  const handleSocialSignup = (provider: string) => {
    console.log(`Signing up with ${provider}`);
    // Add social signup logic here - would auto-fill name/email
    navigate("/client/register-step2");
  };

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            EWAJI
          </h1>
          <p className="text-xl font-semibold text-gray-800 mb-6">
            Create your free client account
          </p>
        </div>

        {/* Social Signup Options */}
        <div className="space-y-3 mb-6">
          <Button
            onClick={() => handleSocialSignup("Apple")}
            variant="outline"
            className="w-full h-12 rounded-xl border-gray-200 text-gray-700 hover:bg-gray-50 font-medium"
          >
            Continue with Apple
          </Button>
          <Button
            onClick={() => handleSocialSignup("Google")}
            variant="outline"
            className="w-full h-12 rounded-xl border-gray-200 text-gray-700 hover:bg-gray-50 font-medium"
          >
            Continue with Google
          </Button>
          <Button
            onClick={() => handleSocialSignup("Facebook")}
            variant="outline"
            className="w-full h-12 rounded-xl border-gray-200 text-gray-700 hover:bg-gray-50 font-medium"
          >
            Continue with Facebook
          </Button>
        </div>

        {/* Divider */}
        <div className="relative mb-6">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-gray-200" />
          </div>
          <div className="relative flex justify-center text-sm">
            <span className="px-4 bg-white text-gray-500">OR</span>
          </div>
        </div>

        {/* Manual Registration Form */}
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
                placeholder="Create a password"
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

          <div className="space-y-2">
            <Label htmlFor="confirmPassword" className="text-gray-700 font-medium">
              Confirm Password
            </Label>
            <div className="relative">
              <Input
                id="confirmPassword"
                type={showConfirmPassword ? "text" : "password"}
                value={formData.confirmPassword}
                onChange={(e) => handleInputChange("confirmPassword", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1] pr-12"
                placeholder="Confirm your password"
              />
              <button
                type="button"
                onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                {showConfirmPassword ? <EyeOff size={20} /> : <Eye size={20} />}
              </button>
            </div>
          </div>

          <Button
            onClick={handleContinue}
            className="w-full h-12 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
          >
            Continue
          </Button>

          <div className="text-center">
            <p className="text-gray-600">
              Already have an account?{" "}
              <button
                onClick={() => navigate("/client/login")}
                className="text-[#5E50A1] font-semibold hover:underline"
              >
                Log in
              </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ClientRegisterStep1Screen;
