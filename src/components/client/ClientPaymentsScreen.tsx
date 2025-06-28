
import { ArrowLeft, Plus, CreditCard, Trash2 } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";

const ClientPaymentsScreen = () => {
  const navigate = useNavigate();

  const paymentMethods = [
    {
      id: 1,
      type: "Visa",
      last4: "4242",
      expiryMonth: "12",
      expiryYear: "25",
      isDefault: true
    },
    {
      id: 2,
      type: "Mastercard",
      last4: "8888",
      expiryMonth: "08",
      expiryYear: "26",
      isDefault: false
    }
  ];

  const getCardIcon = (type: string) => {
    return <CreditCard size={24} className="text-[#5E50A1]" />;
  };

  return (
    <div className="bg-white min-h-screen">
      {/* Header */}
      <div className="flex items-center p-4 border-b border-gray-100">
        <Button
          variant="ghost"
          size="icon"
          onClick={() => navigate("/client/profile")}
          className="mr-3"
        >
          <ArrowLeft size={20} className="text-[#5E50A1]" />
        </Button>
        <h1 className="text-xl font-semibold text-[#1C1C1E]">Payment Methods</h1>
      </div>

      {/* Payment Methods */}
      <div className="p-4 space-y-4">
        {paymentMethods.map((method) => (
          <div key={method.id} className="bg-white border border-gray-200 rounded-xl p-4">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center">
                {getCardIcon(method.type)}
                <div className="ml-3">
                  <p className="font-medium text-[#1C1C1E]">
                    {method.type} •••• {method.last4}
                  </p>
                  <p className="text-sm text-[#6E6E73]">
                    Expires {method.expiryMonth}/{method.expiryYear}
                  </p>
                </div>
              </div>
              <Button
                variant="ghost"
                size="icon"
                className="text-red-500 hover:text-red-600 hover:bg-red-50"
              >
                <Trash2 size={18} />
              </Button>
            </div>
            
            {method.isDefault && (
              <div className="inline-block px-2 py-1 bg-[#5E50A1]/10 text-[#5E50A1] text-xs font-medium rounded-full">
                Default
              </div>
            )}
            
            {!method.isDefault && (
              <Button
                variant="outline"
                size="sm"
                className="text-[#5E50A1] border-[#5E50A1] hover:bg-[#5E50A1] hover:text-white"
              >
                Set as Default
              </Button>
            )}
          </div>
        ))}

        {/* Add New Payment Method */}
        <button className="w-full p-6 border-2 border-dashed border-gray-200 rounded-xl flex flex-col items-center justify-center hover:border-[#5E50A1] hover:bg-[#5E50A1]/5 transition-colors">
          <div className="w-12 h-12 bg-[#5E50A1]/10 rounded-full flex items-center justify-center mb-3">
            <Plus size={24} className="text-[#5E50A1]" />
          </div>
          <p className="font-medium text-[#1C1C1E] mb-1">Add Payment Method</p>
          <p className="text-sm text-[#6E6E73]">Add a new card or payment option</p>
        </button>
      </div>

      {/* Security Notice */}
      <div className="p-4 m-4 bg-gray-50 rounded-xl">
        <p className="text-sm text-[#6E6E73] text-center">
          🔒 Your payment information is securely encrypted and protected
        </p>
      </div>
    </div>
  );
};

export default ClientPaymentsScreen;
