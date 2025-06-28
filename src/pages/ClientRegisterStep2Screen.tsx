
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { InputOTP, InputOTPGroup, InputOTPSlot } from "@/components/ui/input-otp";
import { Camera, Upload } from "lucide-react";

const ClientRegisterStep2Screen = () => {
  const navigate = useNavigate();
  const [showOTP, setShowOTP] = useState(false);
  const [otpValue, setOtpValue] = useState("");
  const [formData, setFormData] = useState({
    fullName: "",
    phoneNumber: "",
    gender: "",
    address: "",
    profilePicture: null as File | null
  });

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleSendOTP = () => {
    setShowOTP(true);
    // Add OTP sending logic here
  };

  const handleVerifyOTP = () => {
    if (otpValue.length === 6) {
      // Add OTP verification logic here
      navigate("/client/home");
    }
  };

  const handleFileUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target?.files?.[0];
    if (file) {
      setFormData(prev => ({ ...prev, profilePicture: file }));
    }
  };

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6 py-8">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            Tell us more about you
          </h1>
          <p className="text-gray-600">
            Complete your profile to start booking
          </p>
        </div>

        {!showOTP ? (
          /* Profile Form */
          <div className="space-y-6">
            <div className="space-y-2">
              <Label htmlFor="fullName" className="text-gray-700 font-medium">
                Full Name
              </Label>
              <Input
                id="fullName"
                type="text"
                value={formData.fullName}
                onChange={(e) => handleInputChange("fullName", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
                placeholder="Enter your full name"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="phoneNumber" className="text-gray-700 font-medium">
                Phone Number
              </Label>
              <Input
                id="phoneNumber"
                type="tel"
                value={formData.phoneNumber}
                onChange={(e) => handleInputChange("phoneNumber", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
                placeholder="+1 (555) 123-4567"
              />
            </div>

            <div className="space-y-2">
              <Label className="text-gray-700 font-medium">
                Gender (Optional)
              </Label>
              <Select onValueChange={(value) => handleInputChange("gender", value)}>
                <SelectTrigger className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]">
                  <SelectValue placeholder="Select gender" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="female">Female</SelectItem>
                  <SelectItem value="male">Male</SelectItem>
                  <SelectItem value="non-binary">Non-binary</SelectItem>
                  <SelectItem value="prefer-not-to-say">Prefer not to say</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="address" className="text-gray-700 font-medium">
                Address
              </Label>
              <Input
                id="address"
                type="text"
                value={formData.address}
                onChange={(e) => handleInputChange("address", e.target.value)}
                className="h-12 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
                placeholder="Enter your address"
              />
            </div>

            <div className="space-y-2">
              <Label className="text-gray-700 font-medium">
                Profile Picture (Optional)
              </Label>
              <div className="flex items-center space-x-4">
                {formData.profilePicture ? (
                  <div className="w-16 h-16 rounded-full bg-gray-200 flex items-center justify-center">
                    <Camera size={24} className="text-gray-500" />
                  </div>
                ) : (
                  <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center">
                    <Camera size={24} className="text-gray-400" />
                  </div>
                )}
                <label className="cursor-pointer">
                  <input
                    type="file"
                    accept="image/*"
                    onChange={handleFileUpload}
                    className="hidden"
                  />
                  <div className="flex items-center space-x-2 px-4 py-2 border border-gray-200 rounded-lg hover:bg-gray-50">
                    <Upload size={16} />
                    <span className="text-sm text-gray-600">Upload Photo</span>
                  </div>
                </label>
              </div>
            </div>

            <Button
              onClick={handleSendOTP}
              className="w-full h-12 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
            >
              Send Verification Code
            </Button>
          </div>
        ) : (
          /* OTP Verification */
          <div className="space-y-6">
            <div className="text-center">
              <p className="text-gray-600 mb-6">
                We've sent a 6-digit code to your phone number. Please enter it below to verify your account.
              </p>
            </div>

            <div className="flex justify-center">
              <InputOTP
                maxLength={6}
                value={otpValue}
                onChange={setOtpValue}
              >
                <InputOTPGroup>
                  <InputOTPSlot index={0} />
                  <InputOTPSlot index={1} />
                  <InputOTPSlot index={2} />
                  <InputOTPSlot index={3} />
                  <InputOTPSlot index={4} />
                  <InputOTPSlot index={5} />
                </InputOTPGroup>
              </InputOTP>
            </div>

            <div className="text-center">
              <p className="text-gray-600 text-sm mb-4">
                Didn't receive the code?
              </p>
              <button
                onClick={handleSendOTP}
                className="text-[#5E50A1] font-medium hover:underline"
              >
                Resend Code
              </button>
            </div>

            <Button
              onClick={handleVerifyOTP}
              disabled={otpValue.length !== 6}
              className="w-full h-12 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Finish & Start Booking
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default ClientRegisterStep2Screen;
