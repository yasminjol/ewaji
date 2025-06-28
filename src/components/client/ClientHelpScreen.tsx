
import { ArrowLeft, HelpCircle, MessageSquare, Phone, Mail, ChevronRight } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";

const ClientHelpScreen = () => {
  const navigate = useNavigate();

  const faqItems = [
    {
      question: "How do I book an appointment?",
      answer: "Browse providers in the Explore tab, select a service, and choose your preferred time slot."
    },
    {
      question: "Can I cancel or reschedule my booking?",
      answer: "Yes, you can cancel or reschedule up to 24 hours before your appointment in the Appointments tab."
    },
    {
      question: "How do payments work?",
      answer: "Payments are processed securely through our platform. You can add payment methods in your profile."
    },
    {
      question: "What if I'm running late?",
      answer: "Contact your provider directly through the app's messaging feature to let them know."
    }
  ];

  const contactOptions = [
    {
      icon: MessageSquare,
      title: "Live Chat",
      description: "Chat with our support team",
      action: () => console.log("Open live chat")
    },
    {
      icon: Mail,
      title: "Email Support",
      description: "support@ewaji.com",
      action: () => console.log("Open email")
    },
    {
      icon: Phone,
      title: "Phone Support",
      description: "+1 (555) 123-EWAJI",
      action: () => console.log("Call support")
    }
  ];

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
        <h1 className="text-xl font-semibold text-[#1C1C1E]">Help & Support</h1>
      </div>

      {/* FAQ Section */}
      <div className="p-4">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-4">Frequently Asked Questions</h2>
        <div className="space-y-3">
          {faqItems.map((item, index) => (
            <div key={index} className="bg-gray-50 rounded-xl p-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center flex-1">
                  <HelpCircle size={20} className="text-[#5E50A1] mr-3 flex-shrink-0" />
                  <div className="flex-1">
                    <p className="font-medium text-[#1C1C1E] mb-2">{item.question}</p>
                    <p className="text-sm text-[#6E6E73]">{item.answer}</p>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Contact Support */}
      <div className="p-4">
        <h2 className="text-lg font-semibold text-[#1C1C1E] mb-4">Contact Support</h2>
        <div className="space-y-3">
          {contactOptions.map((option, index) => {
            const Icon = option.icon;
            return (
              <button
                key={index}
                onClick={option.action}
                className="w-full flex items-center p-4 bg-gray-50 rounded-xl hover:bg-gray-100 transition-colors text-left"
              >
                <div className="w-10 h-10 bg-[#5E50A1]/10 rounded-full flex items-center justify-center">
                  <Icon size={20} className="text-[#5E50A1]" />
                </div>
                <div className="ml-4 flex-1">
                  <p className="font-medium text-[#1C1C1E]">{option.title}</p>
                  <p className="text-sm text-[#6E6E73]">{option.description}</p>
                </div>
                <ChevronRight size={20} className="text-[#6E6E73]" />
              </button>
            );
          })}
        </div>
      </div>

      {/* App Info */}
      <div className="p-4 mt-8 border-t border-gray-100">
        <div className="text-center">
          <p className="text-sm text-[#6E6E73] mb-2">EWAJI Client App</p>
          <p className="text-xs text-[#6E6E73]">Version 1.0.0 • Terms • Privacy Policy</p>
        </div>
      </div>
    </div>
  );
};

export default ClientHelpScreen;
