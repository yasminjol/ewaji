
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";

const ProviderSuccessScreen = () => {
  const navigate = useNavigate();

  const handleContinue = () => {
    navigate("/provider/dashboard");
  };

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-4 leading-tight">
            Yay! Your business is now official with EWAJI!
          </h1>
          <p className="text-gray-600 text-lg">
            Let's set up your profile
          </p>
        </div>

        {/* Continue Button */}
        <div className="pt-4">
          <Button
            onClick={handleContinue}
            className="w-full h-14 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
          >
            Continue
          </Button>
        </div>
      </div>
    </div>
  );
};

export default ProviderSuccessScreen;
