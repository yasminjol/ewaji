
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";
import { Checkbox } from "@/components/ui/checkbox";

const categories = [
  { id: "braider", name: "Braider", icon: "💁‍♀️" },
  { id: "barber", name: "Barber", icon: "✂️" },  
  { id: "nail-tech", name: "Nail Tech", icon: "💅" },
  { id: "lash-tech", name: "Lash Tech", icon: "👁️" },
  { id: "colorist", name: "Colorist", icon: "🎨" },
  { id: "wig-maker", name: "Wig Maker", icon: "👩‍🦱" },
  { id: "loctician", name: "Loctician", icon: "🔗" },
  { id: "esthetician", name: "Esthetician", icon: "✨" }
];

const ProviderCategorySelectionScreen = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
  const [showUpgradeModal, setShowUpgradeModal] = useState(false);
  const [agreedToTerms, setAgreedToTerms] = useState(false);

  const handleCategoryToggle = (categoryId: string) => {
    if (selectedCategories.includes(categoryId)) {
      setSelectedCategories(selectedCategories.filter(id => id !== categoryId));
    } else if (selectedCategories.length < 2) {
      setSelectedCategories([...selectedCategories, categoryId]);
    } else {
      // Show upgrade modal when trying to select 3rd category
      setShowUpgradeModal(true);
    }
  };

  const handleContinue = () => {
    if (selectedCategories.length === 0) {
      toast({
        title: "Selection Required",
        description: "Please select at least one category to continue.",
        variant: "destructive"
      });
      return;
    }
    
    if (!agreedToTerms) {
      toast({
        title: "Agreement Required",
        description: "Please agree to the deposit terms to continue.",
        variant: "destructive"
      });
      return;
    }

    // Store selected categories in localStorage for now
    localStorage.setItem('selectedCategories', JSON.stringify(selectedCategories));
    navigate("/provider/phone-otp");
  };

  const canContinue = selectedCategories.length > 0 && agreedToTerms;

  return (
    <div className="min-h-screen ewaji-gradient flex items-center justify-center px-6">
      <div className="w-full max-w-sm bg-white rounded-2xl p-8 shadow-lg">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            Which services do you offer?
          </h1>
          <p className="text-gray-600 text-sm">
            Pick up to two categories to start. Need more? Upgrade later.
          </p>
        </div>

        {/* Categories Grid */}
        <div className="grid grid-cols-2 gap-3 mb-6">
          {categories.map((category) => {
            const isSelected = selectedCategories.includes(category.id);
            return (
              <button
                key={category.id}
                onClick={() => handleCategoryToggle(category.id)}
                className={`h-22 rounded-xl border-2 transition-all flex flex-col items-center justify-center p-4 ${
                  isSelected
                    ? "border-[#5E50A1] bg-[#5E50A1] text-white"
                    : "border-gray-200 bg-white text-gray-700 hover:border-gray-300"
                }`}
              >
                <span className="text-2xl mb-1">{category.icon}</span>
                <span className="text-xs font-medium text-center">{category.name}</span>
              </button>
            );
          })}
        </div>

        {/* Terms Agreement */}
        <div className="mb-6">
          <div className="flex items-start space-x-3 p-4 bg-gray-50 rounded-xl">
            <Checkbox
              id="terms"
              checked={agreedToTerms}
              onCheckedChange={(checked) => setAgreedToTerms(!!checked)}
              className="mt-0.5"
            />
            <label htmlFor="terms" className="text-sm text-gray-700 leading-relaxed">
              I agree EWAJI will apply a non-refundable 20% deposit to each booked service.
            </label>
          </div>
        </div>

        {/* Continue Button */}
        <Button
          onClick={handleContinue}
          disabled={!canContinue}
          className={`w-full h-14 rounded-xl text-lg font-semibold transition-colors ${
            canContinue
              ? "bg-[#5E50A1] text-white hover:bg-[#4F4391]"
              : "bg-gray-200 text-gray-400 cursor-not-allowed"
          }`}
        >
          Continue
        </Button>
      </div>

      {/* Upgrade Modal */}
      {showUpgradeModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl p-6 w-full max-w-sm">
            <h2 className="text-xl font-bold text-gray-900 mb-4 text-center">
              Upgrade to EWAJI Pro
            </h2>
            
            <div className="space-y-3 mb-6">
              <div className="flex items-center space-x-3">
                <div className="w-2 h-2 bg-[#5E50A1] rounded-full"></div>
                <span className="text-gray-700">Add unlimited categories</span>
              </div>
              <div className="flex items-center space-x-3">
                <div className="w-2 h-2 bg-[#5E50A1] rounded-full"></div>
                <span className="text-gray-700">Featured placement in AI feed</span>
              </div>
              <div className="flex items-center space-x-3">
                <div className="w-2 h-2 bg-[#5E50A1] rounded-full"></div>
                <span className="text-gray-700">Advanced analytics</span>
              </div>
            </div>
            
            <div className="flex flex-col space-y-3">
              <Button
                onClick={() => {
                  setShowUpgradeModal(false);
                  toast({
                    title: "Upgrade Coming Soon",
                    description: "Pro features will be available soon!"
                  });
                }}
                className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white"
              >
                Upgrade for $29/mo
              </Button>
              <Button
                onClick={() => setShowUpgradeModal(false)}
                variant="outline"
                className="w-full"
              >
                Maybe later
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ProviderCategorySelectionScreen;
