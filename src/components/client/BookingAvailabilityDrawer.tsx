
import { useState } from "react";
import { format, addDays, startOfWeek, addWeeks, subWeeks } from "date-fns";
import { Calendar, ChevronLeft, ChevronRight, Clock, CreditCard, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Drawer, DrawerContent, DrawerHeader, DrawerTitle, DrawerClose } from "@/components/ui/drawer";
import { useToast } from "@/hooks/use-toast";

interface BookingAvailabilityDrawerProps {
  isOpen: boolean;
  onClose: () => void;
  provider: {
    name: string;
    id: number;
  };
  selectedService?: {
    name: string;
    price: number;
    duration: string;
  };
}

type BookingStep = "date" | "time" | "payment";

interface TimeSlot {
  time: string;
  available: boolean;
  capacity: "many" | "few" | "full";
}

const BookingAvailabilityDrawer = ({ isOpen, onClose, provider, selectedService }: BookingAvailabilityDrawerProps) => {
  const [currentStep, setCurrentStep] = useState<BookingStep>("date");
  const [selectedDate, setSelectedDate] = useState<Date | null>(null);
  const [selectedTime, setSelectedTime] = useState<string | null>(null);
  const [currentWeek, setCurrentWeek] = useState(new Date());
  const { toast } = useToast();

  // Mock availability data - in real app this would come from API
  const getDateAvailability = (date: Date) => {
    const day = date.getDay();
    if (day === 0 || day === 6) return "full"; // Weekends full
    const random = Math.random();
    if (random > 0.7) return "many";
    if (random > 0.3) return "few";
    return "full";
  };

  const getTimeSlots = (date: Date): { morning: TimeSlot[], afternoon: TimeSlot[], evening: TimeSlot[] } => {
    return {
      morning: [
        { time: "9:00 AM", available: true, capacity: "many" },
        { time: "9:30 AM", available: true, capacity: "many" },
        { time: "10:00 AM", available: true, capacity: "few" },
        { time: "11:00 AM", available: false, capacity: "full" },
      ],
      afternoon: [
        { time: "1:00 PM", available: true, capacity: "many" },
        { time: "2:30 PM", available: true, capacity: "few" },
        { time: "4:00 PM", available: true, capacity: "many" },
      ],
      evening: [
        { time: "6:00 PM", available: false, capacity: "full" },
        { time: "7:00 PM", available: false, capacity: "full" },
      ]
    };
  };

  const handleDateSelect = (date: Date) => {
    setSelectedDate(date);
  };

  const handleTimeSelect = (time: string) => {
    setSelectedTime(time);
  };

  const handleContinueFromDate = () => {
    if (selectedDate) {
      setCurrentStep("time");
    }
  };

  const handleContinueFromTime = () => {
    if (selectedTime) {
      setCurrentStep("payment");
    }
  };

  const handleBackToDate = () => {
    setCurrentStep("date");
  };

  const handleBackToTime = () => {
    setCurrentStep("time");
  };

  const handlePayment = () => {
    toast({
      title: "Booking Confirmed!",
      description: `Your appointment with ${provider.name} has been booked for ${format(selectedDate!, "EEE, MMM d")} at ${selectedTime}`,
    });
    onClose();
    // Reset state
    setCurrentStep("date");
    setSelectedDate(null);
    setSelectedTime(null);
  };

  const resetAndClose = () => {
    setCurrentStep("date");
    setSelectedDate(null);
    setSelectedTime(null);
    onClose();
  };

  const weekDays = Array.from({ length: 7 }, (_, i) => addDays(startOfWeek(currentWeek), i));
  const timeSlots = selectedDate ? getTimeSlots(selectedDate) : null;
  const depositAmount = selectedService ? Math.round(selectedService.price * 0.2) : 0;

  const getCapacityIndicator = (capacity: string) => {
    switch (capacity) {
      case "many": return "🟢";
      case "few": return "🟡";
      case "full": return "—";
      default: return "—";
    }
  };

  const getCapacityText = (capacity: string) => {
    switch (capacity) {
      case "many": return "";
      case "few": return "(few)";
      case "full": return "";
      default: return "";
    }
  };

  return (
    <Drawer open={isOpen} onOpenChange={resetAndClose}>
      <DrawerContent className="h-[90vh] flex flex-col">
        <DrawerHeader className="border-b border-gray-100">
          <div className="flex items-center justify-between">
            <DrawerTitle className="text-lg font-bold text-[#1C1C1E]">
              {currentStep === "date" && "Provider Availability"}
              {currentStep === "time" && selectedDate && format(selectedDate, "d MMM yyyy (EEE)")}
              {currentStep === "payment" && "Confirm Your Appointment"}
            </DrawerTitle>
            <DrawerClose>
              <X size={20} className="text-[#6E6E73]" />
            </DrawerClose>
          </div>
        </DrawerHeader>

        <div className="flex-1 overflow-y-auto p-4">
          {/* Step 1: Date Selection */}
          {currentStep === "date" && (
            <div className="space-y-6">
              {/* Week Navigation */}
              <div className="flex items-center justify-between">
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => setCurrentWeek(subWeeks(currentWeek, 1))}
                  className="hover:bg-gray-100"
                >
                  <ChevronLeft size={20} />
                </Button>
                <div className="flex items-center space-x-4">
                  <span className="text-sm font-medium text-[#1C1C1E]">
                    {format(currentWeek, "MMMM yyyy")}
                  </span>
                  <Button variant="outline" size="sm" className="text-xs">
                    Today » 7 Days
                  </Button>
                </div>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => setCurrentWeek(addWeeks(currentWeek, 1))}
                  className="hover:bg-gray-100"
                >
                  <ChevronRight size={20} />
                </Button>
              </div>

              {/* Week Calendar */}
              <div className="grid grid-cols-7 gap-2">
                {weekDays.map((day, index) => {
                  const availability = getDateAvailability(day);
                  const isSelected = selectedDate && format(day, "yyyy-MM-dd") === format(selectedDate, "yyyy-MM-dd");
                  const isDisabled = availability === "full";
                  
                  return (
                    <div key={index} className="text-center">
                      <div className="text-xs text-[#6E6E73] mb-2">
                        {format(day, "EEE")}
                      </div>
                      <button
                        onClick={() => !isDisabled && handleDateSelect(day)}
                        disabled={isDisabled}
                        className={`w-12 h-12 rounded-xl text-sm font-medium transition-all ${
                          isSelected
                            ? "bg-[#5E50A1] text-white"
                            : isDisabled
                            ? "bg-gray-100 text-gray-400 cursor-not-allowed"
                            : "bg-gray-50 text-[#1C1C1E] hover:bg-gray-100 active:scale-95"
                        }`}
                      >
                        <div>{format(day, "d")}</div>
                        <div className="text-xs">
                          {getCapacityIndicator(availability)}
                        </div>
                      </button>
                    </div>
                  );
                })}
              </div>

              {/* Legend */}
              <div className="bg-gray-50 rounded-xl p-4">
                <div className="text-xs text-[#6E6E73] space-x-4">
                  <span>🟢 many slots</span>
                  <span>🟡 few slots</span>
                  <span>— full</span>
                </div>
                <div className="text-xs text-[#6E6E73] mt-2">
                  Times shown in your time-zone (EDT)
                </div>
              </div>

              <Button
                onClick={handleContinueFromDate}
                disabled={!selectedDate}
                className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Continue
              </Button>
            </div>
          )}

          {/* Step 2: Time Selection */}
          {currentStep === "time" && timeSlots && (
            <div className="space-y-6">
              {/* Morning Slots */}
              <div>
                <h3 className="text-sm font-semibold text-[#1C1C1E] mb-3">Morning</h3>
                <div className="grid grid-cols-2 gap-3">
                  {timeSlots.morning.map((slot) => (
                    <button
                      key={slot.time}
                      onClick={() => slot.available && handleTimeSelect(slot.time)}
                      disabled={!slot.available}
                      className={`h-12 rounded-xl text-sm font-medium transition-all ${
                        selectedTime === slot.time
                          ? "bg-[#5E50A1] text-white"
                          : slot.available
                          ? "bg-gray-50 text-[#1C1C1E] hover:bg-gray-100 active:scale-95"
                          : "bg-gray-100 text-gray-400 cursor-not-allowed opacity-30"
                      }`}
                    >
                      <div>{slot.time}</div>
                      {slot.available && slot.capacity === "few" && (
                        <div className="text-xs opacity-70">few</div>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Afternoon Slots */}
              <div>
                <h3 className="text-sm font-semibold text-[#1C1C1E] mb-3">Afternoon</h3>
                <div className="grid grid-cols-2 gap-3">
                  {timeSlots.afternoon.map((slot) => (
                    <button
                      key={slot.time}
                      onClick={() => slot.available && handleTimeSelect(slot.time)}
                      disabled={!slot.available}
                      className={`h-12 rounded-xl text-sm font-medium transition-all ${
                        selectedTime === slot.time
                          ? "bg-[#5E50A1] text-white"
                          : slot.available
                          ? "bg-gray-50 text-[#1C1C1E] hover:bg-gray-100 active:scale-95"
                          : "bg-gray-100 text-gray-400 cursor-not-allowed opacity-30"
                      }`}
                    >
                      <div>{slot.time}</div>
                      {slot.available && slot.capacity === "few" && (
                        <div className="text-xs opacity-70">few</div>
                      )}
                    </button>
                  ))}
                </div>
              </div>

              {/* Evening Slots */}
              <div>
                <h3 className="text-sm font-semibold text-[#1C1C1E] mb-3">Evening</h3>
                {timeSlots.evening.every(slot => !slot.available) ? (
                  <div className="text-sm text-[#6E6E73] text-center py-8">
                    — No evening slots available —
                  </div>
                ) : (
                  <div className="grid grid-cols-2 gap-3">
                    {timeSlots.evening.map((slot) => (
                      <button
                        key={slot.time}
                        onClick={() => slot.available && handleTimeSelect(slot.time)}
                        disabled={!slot.available}
                        className={`h-12 rounded-xl text-sm font-medium transition-all ${
                          selectedTime === slot.time
                            ? "bg-[#5E50A1] text-white"
                            : slot.available
                            ? "bg-gray-50 text-[#1C1C1E] hover:bg-gray-100 active:scale-95"
                            : "bg-gray-100 text-gray-400 cursor-not-allowed opacity-30"
                        }`}
                      >
                        <div>{slot.time}</div>
                        {slot.available && slot.capacity === "few" && (
                          <div className="text-xs opacity-70">few</div>
                        )}
                      </button>
                    ))}
                  </div>
                )}
              </div>

              <div className="flex space-x-3">
                <Button
                  onClick={handleBackToDate}
                  variant="outline"
                  className="flex-1 py-3 rounded-xl"
                >
                  Back
                </Button>
                <Button
                  onClick={handleContinueFromTime}
                  disabled={!selectedTime}
                  className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl disabled:opacity-50"
                >
                  Continue →
                </Button>
              </div>
            </div>
          )}

          {/* Step 3: Payment Confirmation */}
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
                    <span className="text-sm font-medium text-[#1C1C1E]">−${depositAmount} (held by EWAJI)</span>
                  </div>
                </div>
              </div>

              {/* Payment Info */}
              <div className="text-center space-y-2">
                <p className="text-sm text-[#1C1C1E]">You'll pay ${selectedService.price} now.</p>
                <p className="text-xs text-[#6E6E73]">
                  ${depositAmount} is held; ${selectedService.price - depositAmount} released at check-in.
                </p>
              </div>

              {/* Payment Methods */}
              <div className="space-y-3">
                <div className="flex justify-center space-x-4">
                  <Button variant="outline" size="sm" className="flex items-center space-x-2">
                    <span>🍎</span>
                    <span>Apple Pay</span>
                  </Button>
                  <Button variant="outline" size="sm" className="flex items-center space-x-2">
                    <span>📱</span>
                    <span>Google Pay</span>
                  </Button>
                  <Button variant="outline" size="sm" className="flex items-center space-x-2">
                    <CreditCard size={16} />
                    <span>Card</span>
                  </Button>
                </div>
              </div>

              {/* Policy Link */}
              <div className="text-center">
                <button className="text-xs text-[#5E50A1] underline">
                  Cancellation &lt; 24h → deposit retained by provider
                </button>
              </div>

              <div className="flex space-x-3">
                <Button
                  onClick={handleBackToTime}
                  variant="outline"
                  className="flex-1 py-3 rounded-xl"
                >
                  Back
                </Button>
                <Button
                  onClick={handlePayment}
                  className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white font-semibold py-3 rounded-xl active:scale-95 transition-transform"
                >
                  Pay & Book
                </Button>
              </div>
            </div>
          )}
        </div>
      </DrawerContent>
    </Drawer>
  );
};

export default BookingAvailabilityDrawer;
