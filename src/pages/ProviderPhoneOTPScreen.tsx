
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

const ProviderPhoneOTPScreen = () => {
  const navigate = useNavigate();
  const [otpCode, setOtpCode] = useState(["", "", "", "", "", ""]);

  const handleCodeChange = (index: number, value: string) => {
    if (value.length <= 1) {
      const newCode = [...otpCode];
      newCode[index] = value;
      setOtpCode(newCode);
      
      // Auto-focus next input
      if (value && index < 5) {
        const nextInput = document.getElementById(`otp-${index + 1}`);
        nextInput?.focus();
      }
    }
  };

  const handleVerify = () => {
    navigate("/provider/success");
  };

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            Enter code
          </h1>
          <p className="text-gray-600 text-sm leading-relaxed">
            We've sent an SMS with an activation code to +1 555 123 4567
          </p>
        </div>

        {/* OTP Input */}
        <div className="space-y-6">
          <div className="flex justify-center space-x-3">
            {otpCode.map((digit, index) => (
              <Input
                key={index}
                id={`otp-${index}`}
                type="text"
                inputMode="numeric"
                value={digit}
                onChange={(e) => handleCodeChange(index, e.target.value)}
                className="w-12 h-12 text-center text-lg font-semibold rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
                maxLength={1}
              />
            ))}
          </div>

          <div className="text-center">
            <button className="text-gray-500 text-sm hover:text-gray-700">
              Send code again 00:20
            </button>
          </div>

          <Button
            onClick={handleVerify}
            className="w-full h-14 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
          >
            Verify
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ProviderPhoneOTPScreen;
