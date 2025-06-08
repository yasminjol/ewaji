
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";

const WelcomeScreen = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen ewaji-gradient flex flex-col items-center justify-center px-8">
      <div className="text-center space-y-8 max-w-sm w-full">
        {/* Logo/Title */}
        <div className="space-y-4">
          <h1 className="text-5xl font-bold text-white tracking-tight">
            EWAJI
          </h1>
          <p className="text-white text-lg font-medium">
            Book the Look. Elevate the Culture.
          </p>
        </div>

        {/* Action Buttons */}
        <div className="space-y-4 w-full pt-8">
          <Button
            onClick={() => navigate("/provider/login")}
            className="w-full h-14 rounded-xl text-lg font-semibold bg-[#AFBCEB] text-[#1C1C1E] hover:bg-[#9CAAE8] transition-colors"
          >
            I'm a Provider
          </Button>
          
          <Button
            onClick={() => navigate("/client/login")}
            className="w-full h-14 rounded-xl text-lg font-semibold bg-[#5E50A1] text-white hover:bg-[#4F4391] transition-colors"
          >
            I'm a Client
          </Button>
        </div>
      </div>
    </div>
  );
};

export default WelcomeScreen;
