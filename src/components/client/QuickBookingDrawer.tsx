
import { useState } from "react";
import { format, addDays, startOfWeek, addWeeks, subWeeks } from "date-fns";
import { ChevronLeft, ChevronRight, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Drawer, DrawerContent, DrawerHeader, DrawerTitle, DrawerClose } from "@/components/ui/drawer";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { useToast } from "@/hooks/use-toast";

interface QuickBookingDrawerProps {
  isOpen: boolean;
  onClose: () => void;
  provider: {
    name: string;
    id: number;
    avatar?: string;
  };
}

type QuickBookingStep = "service" | "datetime" | "payment";

interface Service {
  id: number;
  name: string;
  price: number;
  duration: string;
  popular?: boolean;
}

interface TimeSlot {
  time: string;
  available: boolean;
}

const QuickBookingDrawer = ({ isOpen, onClose, provider }: QuickBookingDrawerProps) => {
  const [currentStep, setCurrentStep] = useState<QuickBookingStep>("service");
  const [selectedService, setSelectedService] = useState<Service | null>(null);
  const [selectedDate, setSelectedDate] = useState<Date | null>(null);
  const [selectedTime, setSelectedTime] = useState<string | null>(null);
  const [currentWeek, setCurrentWeek] = useState(new Date());
  const { toast } = useToast();

  // Mock services data - in real app this would come from API
  const services: Service[] = [
    { id: 1, name: "Knotless Braids", price: 120, duration: "4h 00m", popular: true },
    { id: 2, name: "Box Braids", price: 100, duration: "3h 30m" },
    { id: 3, name: "Twist Out", price: 80, duration: "2h 00m" },
    { id: 4, name: "Silk Press", price: 95, duration: "2h 30m" },
  ];

  // Preselect most popular service
  useState(() => {
    const popularService = services.find(s => s.popular) || services[0];
    setSelectedService(popularService);
  });

  const getTimeSlots = (): { morning: TimeSlot[], afternoon: TimeSlot[], evening: TimeSlot[] } => {
    return {
      morning: [
        { time: "9:00 AM", available: true },
        { time: "9:30 AM", available: true },
        { time: "10:00 AM", available: false },
        { time: "11:00 AM", available: true },
      ],
      afternoon: [
        { time: "1:00 PM", available: true },
        { time: "2:30 PM", available: true },
        { time: "4:00 PM", available: false },
      ],
      evening: [
        { time: "6:00 PM", available: true },
        { time: "7:00 PM", available: false },
      ]
    };
  };

  const handleServiceSelect = (service: Service) => {
    setSelectedService(service);
  };

  const handleDateSelect = (date: Date) => {
    setSelectedDate(date);
  };

  const handleTimeSelect = (time: string) => {
    setSelectedTime(time);
  };

  const handleNextToDateTime = () => {
    if (selectedService) {
      setCurrentStep("datetime");
    }
  };

  const handleNextToPayment = () => {
    if (selectedDate && selectedTime) {
      setCurrentStep("payment");
    }
  };

  const handleBackToService = () => {
    setCurrentStep("service");
  };

  const handleBackToDateTime = () => {
    setCurrentStep("datetime");
  };

  const handleConfirmBooking = () => {
    toast({
      title: "Booking Confirmed!",
      description: `Your appointment with ${provider.name} has been booked for ${format(selectedDate!, "EEE, MMM d")} at ${selectedTime}`,
    });
    onClose();
    // Reset state
    setCurrentStep("service");
    setSelectedDate(null);
    setSelectedTime(null);
    // In real app, navigate to /client/appointments?state=upcoming
  };

  const resetAndClose = () => {
    setCurrentStep("service");
    setSelectedDate(null);
    setSelectedTime(null);
    onClose();
  };

  const weekDays = Array.from({ length: 7 }, (_, i) => addDays(startOfWeek(currentWeek), i));
  const timeSlots = getTimeSlots();
  const depositAmount = selectedService ? Math.round(selectedService.price * 0.2) : 0;

  return (
    <Drawer open={isOpen} onOpenChange={resetAndClose}>
      <DrawerContent className="h-[85vh] flex flex-col">
        <DrawerHeader className="border-b border-gray-100">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Avatar className="w-10 h-10">
                <AvatarImage src={provider.avatar || "/placeholder.svg"} alt={provider.name} />
                <AvatarFallback>{provider.name.split(' ').map(n => n[0]).join('')}</AvatarFallback>
              </Avatar>
              <DrawerTitle className="text-lg font-bold text-[#1C1C1E]">
                {currentStep === "service" && "Select Service"}
                {currentStep === "datetime" && "Choose Date & Time"}
                {currentStep === "payment" && "Confirm & Pay"}
              </DrawerTitle>
            </div>
            <DrawerClose>
              <X size={20} className="text-[#6E6E73]" />
            </DrawerClose>
          </div>
        </DrawerHeader>

        <div className="flex-1 overflow-y-auto p-4">
          {/* Step 1: Service Selection */}
          {currentStep === "service" && (
            <div className="space-y-6">
              <div>
                <h3 className="text-sm font-semibold text-[#1C1C1E] mb-3">Available Services</h3>
                <div className="flex space-x-3 overflow-x-auto pb-2">
                  {services.map((service) => (
                    <button
                      key={service.id}
                      onClick={() => handleServiceSelect(service)}
                      className={`flex-shrink-0 px-4 py-2 rounded-full text-sm font-medium transition-all ${
                        selectedService?.id === service.id
                          ? "bg-[#5E50A1] text-white"
                          : "border border-[#AFBCEB] text-[#6E6E73] hover:border-[#5E50A1]"
                      }`}
                    >
                      {service.name}
                      {service.popular && (
                        <span className="ml-2 text-xs">⭐</span>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {selectedService && (
                <div className="bg-gray-50 rounded-xl p-4 space-y-3">
                  <h4 className="font-semibold text-[#1C1C1E]">{selectedService.name}</h4>
                  <div className="space-y-2">
                    <div className="flex justify-between">
                      <span className="text-sm text-[#6E6E73]">Duration</span>
                      <span className="text-sm font-medium text-[#1C1C1E]">{selectedService.duration}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-sm text-[#6E6E73]">Total Cost</span>
                      <span className="text-sm font-bold text-[#1C1C1E]">${selectedService.price}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-xs text-[#6E6E73]">Deposit (20%)</span>
                      <span className="text-xs text-[#6E6E73]">${Math.round(selectedService.price * 0.2)} (held securely by EWAJI)</span>
                    </div>
                  </div>
                </div>
              )}

              <Button
                onClick={handleNextToDateTime}
                disabled={!selectedService}
                className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl disabled:opacity-50"
              >
                Next: Choose Date & Time
              </Button>
            </div>
          )}

          {/* Step 2: Date & Time Selection */}
          {currentStep === "datetime" && (
            <div className="space-y-6">
              {/* Date Selection */}
              <div>
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-sm font-semibold text-[#1C1C1E]">Select Date</h3>
                  <div className="flex items-center space-x-2">
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => setCurrentWeek(subWeeks(currentWeek, 1))}
                      className="w-8 h-8"
                    >
                      <ChevronLeft size={16} />
                    </Button>
                    <span className="text-xs text-[#6E6E73]">{format(currentWeek, "MMM yyyy")}</span>
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => setCurrentWeek(addWeeks(currentWeek, 1))}
                      className="w-8 h-8"
                    >
                      <ChevronRight size={16} />
                    </Button>
                  </div>
                </div>

                <div className="grid grid-cols-7 gap-2">
                  {weekDays.map((day, index) => {
                    const isSelected = selectedDate && format(day, "yyyy-MM-dd") === format(selectedDate, "yyyy-MM-dd");
                    const isDisabled = day.getDay() === 0; // Disable Sundays for example
                    
                    return (
                      <div key={index} className="text-center">
                        <div className="text-xs text-[#6E6E73] mb-1">
                          {format(day, "EEE")}
                        </div>
                        <button
                          onClick={() => !isDisabled && handleDateSelect(day)}
                          disabled={isDisabled}
                          className={`w-10 h-10 rounded-lg text-sm font-medium transition-all ${
                            isSelected
                              ? "bg-[#5E50A1] text-white"
                              : isDisabled
                              ? "bg-gray-100 text-gray-400 cursor-not-allowed"
                              : "bg-gray-50 text-[#1C1C1E] hover:bg-gray-100"
                          }`}
                        >
                          {format(day, "d")}
                        </button>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Time Selection */}
              {selectedDate && (
                <div className="space-y-4">
                  <h3 className="text-sm font-semibold text-[#1C1C1E]">Select Time</h3>
                  
                  <div className="space-y-4">
                    {/* Morning */}
                    <div>
                      <h4 className="text-xs font-medium text-[#6E6E73] mb-2">Morning</h4>
                      <div className="grid grid-cols-3 gap-2">
                        {timeSlots.morning.map((slot) => (
                          <button
                            key={slot.time}
                            onClick={() => slot.available && handleTimeSelect(slot.time)}
                            disabled={!slot.available}
                            className={`h-10 rounded-lg text-sm font-medium transition-all ${
                              selectedTime === slot.time
                                ? "bg-[#5E50A1] text-white"
                                : slot.available
                                ? "border border-gray-300 text-[#1C1C1E] hover:border-[#5E50A1]"
                                : "bg-gray-100 text-gray-400 cursor-not-allowed"
                            }`}
                          >
                            {slot.time}
                          </button>
                        ))}
                      </div>
                    </div>

                    {/* Afternoon */}
                    <div>
                      <h4 className="text-xs font-medium text-[#6E6E73] mb-2">Afternoon</h4>
                      <div className="grid grid-cols-3 gap-2">
                        {timeSlots.afternoon.map((slot) => (
                          <button
                            key={slot.time}
                            onClick={() => slot.available && handleTimeSelect(slot.time)}
                            disabled={!slot.available}
                            className={`h-10 rounded-lg text-sm font-medium transition-all ${
                              selectedTime === slot.time
                                ? "bg-[#5E50A1] text-white"
                                : slot.available
                                ? "border border-gray-300 text-[#1C1C1E] hover:border-[#5E50A1]"
                                : "bg-gray-100 text-gray-400 cursor-not-allowed"
                            }`}
                          >
                            {slot.time}
                          </button>
                        ))}
                      </div>
                    </div>

                    {/* Evening */}
                    <div>
                      <h4 className="text-xs font-medium text-[#6E6E73] mb-2">Evening</h4>
                      <div className="grid grid-cols-3 gap-2">
                        {timeSlots.evening.map((slot) => (
                          <button
                            key={slot.time}
                            onClick={() => slot.available && handleTimeSelect(slot.time)}
                            disabled={!slot.available}
                            className={`h-10 rounded-lg text-sm font-medium transition-all ${
                              selectedTime === slot.time
                                ? "bg-[#5E50A1] text-white"
                                : slot.available
                                ? "border border-gray-300 text-[#1C1C1E] hover:border-[#5E50A1]"
                                : "bg-gray-100 text-gray-400 cursor-not-allowed"
                            }`}
                          >
                            {slot.time}
                          </button>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              )}

              <div className="flex space-x-3">
                <Button
                  onClick={handleBackToService}
                  variant="outline"
                  className="flex-1 py-3 rounded-xl"
                >
                  Back
                </Button>
                <Button
                  onClick={handleNextToPayment}
                  disabled={!selectedDate || !selectedTime}
                  className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl disabled:opacity-50"
                >
                  Next: Confirm & Pay
                </Button>
              </div>
            </div>
          )}

          {/* Step 3: Payment & Confirmation */}
          {currentStep === "payment" && selectedService && selectedDate && selectedTime && (
            <div className="space-y-6">
              {/* Booking Summary */}
              <div className="bg-gray-50 rounded-xl p-4 space-y-3">
                <div className="flex justify-between">
                  <span className="text-sm text-[#6E6E73]">Provider</span>
                  <span className="text-sm font-medium text-[#1C1C1E]">{provider.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-[#6E6E73]">Service</span>
                  <span className="text-sm font-medium text-[#1C1C1E]">{selectedService.name}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-[#6E6E73]">Date & Time</span>
                  <span className="text-sm font-medium text-[#1C1C1E]">
                    {format(selectedDate, "EEE • d MMM • ")} {selectedTime}
                  </span>
                </div>
                <div className="border-t border-gray-200 pt-3">
                  <div className="flex justify-between">
                    <span className="text-sm text-[#6E6E73]">Total</span>
                    <span className="text-sm font-bold text-[#1C1C1E]">${selectedService.price}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-[#6E6E73]">Deposit (20%)</span>
                    <span className="text-sm font-medium text-[#1C1C1E]">−${depositAmount} (secured by EWAJI)</span>
                  </div>
                </div>
              </div>

              {/* Payment Methods */}
              <div className="space-y-3">
                <h3 className="text-sm font-semibold text-[#1C1C1E]">Payment Method</h3>
                <div className="flex justify-center space-x-3">
                  <Button variant="outline" size="sm" className="flex items-center space-x-2">
                    <span>🍎</span>
                    <span>Apple Pay</span>
                  </Button>
                  <Button variant="outline" size="sm" className="flex items-center space-x-2">
                    <span>📱</span>
                    <span>Google Pay</span>
                  </Button>
                  <Button variant="outline" size="sm" className="flex items-center space-x-2">
                    <span>💳</span>
                    <span>Card</span>
                  </Button>
                </div>
              </div>

              <div className="flex space-x-3">
                <Button
                  onClick={handleBackToDateTime}
                  variant="outline"
                  className="flex-1 py-3 rounded-xl"
                >
                  Back
                </Button>
                <Button
                  onClick={handleConfirmBooking}
                  className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl active:scale-95 transition-transform"
                >
                  Pay Deposit & Confirm Booking
                </Button>
              </div>
            </div>
          )}
        </div>
      </DrawerContent>
    </Drawer>
  );
};

export default QuickBookingDrawer;
