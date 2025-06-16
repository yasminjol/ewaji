
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { X, ChevronLeft, ChevronRight, CalendarIcon, Phone, Mail, Check } from "lucide-react";
import { format, addMonths, subMonths, startOfMonth, endOfMonth, eachDayOfInterval, isSameDay } from "date-fns";

interface Booking {
  id: number;
  clientName: string;
  avatar: string;
  service: string;
  date: string;
  dateKey: string;
  time: string;
  duration: string;
  price: string;
  deposit: string;
  status: "pending" | "upcoming" | "completed" | "cancelled";
  clientPhone: string;
  clientEmail: string;
  policies: string[];
}

const BookingsTab = () => {
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(new Date());
  const [currentMonth, setCurrentMonth] = useState(new Date());
  const [activeFilter, setActiveFilter] = useState("All");
  const [selectedBooking, setSelectedBooking] = useState<Booking | null>(null);
  const [isDetailSheetOpen, setIsDetailSheetOpen] = useState(false);
  const [isYearPickerOpen, setIsYearPickerOpen] = useState(false);
  
  const filters = ["All", "Upcoming", "Pending", "Completed", "Cancelled"];
  
  const bookings: Booking[] = [
    {
      id: 1,
      clientName: "Maya Johnson",
      avatar: "/placeholder.svg",
      service: "Protective Braids",
      date: "Dec 15",
      dateKey: "2024-12-15",
      time: "2:00 PM",
      duration: "3 hours",
      price: "$120",
      deposit: "$40",
      status: "pending",
      clientPhone: "+1 (555) 123-4567",
      clientEmail: "maya.johnson@email.com",
      policies: ["Cancellation Policy", "Lateness Policy", "Refund Policy"]
    },
    {
      id: 2,
      clientName: "Zara Williams",
      avatar: "/placeholder.svg",
      service: "Natural Makeup",
      date: "Dec 16",
      dateKey: "2024-12-16",
      time: "10:30 AM",
      duration: "2 hours",
      price: "$85",
      deposit: "$25",
      status: "upcoming",
      clientPhone: "+1 (555) 234-5678",
      clientEmail: "zara.williams@email.com",
      policies: ["Cancellation Policy", "Lateness Policy"]
    },
    {
      id: 3,
      clientName: "Asha Davis",
      avatar: "/placeholder.svg",
      service: "Hair Color Treatment",
      date: "Dec 18",
      dateKey: "2024-12-18",
      time: "1:00 PM",
      duration: "4 hours",
      price: "$200",
      deposit: "$60",
      status: "completed",
      clientPhone: "+1 (555) 345-6789",
      clientEmail: "asha.davis@email.com",
      policies: ["Cancellation Policy", "Refund Policy"]
    }
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case "pending":
        return "bg-yellow-100 text-yellow-800";
      case "upcoming":
        return "bg-blue-100 text-blue-800";
      case "completed":
        return "bg-green-100 text-green-800";
      case "cancelled":
        return "bg-red-100 text-red-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const filteredBookings = bookings.filter(booking => {
    const statusMatch = activeFilter === "All" || booking.status === activeFilter.toLowerCase();
    const dateMatch = !selectedDate || booking.dateKey === format(selectedDate, "yyyy-MM-dd");
    return statusMatch && dateMatch;
  });

  const handlePrevMonth = () => {
    setCurrentMonth(subMonths(currentMonth, 1));
  };

  const handleNextMonth = () => {
    setCurrentMonth(addMonths(currentMonth, 1));
  };

  const handleYearChange = (year: number) => {
    setCurrentMonth(new Date(year, currentMonth.getMonth(), 1));
    setIsYearPickerOpen(false);
  };

  const openBookingDetails = (booking: Booking) => {
    setSelectedBooking(booking);
    setIsDetailSheetOpen(true);
  };

  const years = Array.from({ length: 11 }, (_, i) => new Date().getFullYear() - 5 + i);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-4 py-4 shadow-sm">
        <h1 className="text-2xl font-bold text-gray-900">Bookings</h1>
      </div>
      
      {/* Month Navigation */}
      <div className="bg-white border-b border-gray-100 px-4 py-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <button 
              onClick={handlePrevMonth}
              className="p-2 hover:bg-gray-100 rounded-lg"
            >
              <ChevronLeft size={24} className="text-[#5E50A1]" />
            </button>
            <h2 className="text-lg font-bold text-[#1C1C1E]">
              {format(currentMonth, "MMM yyyy")}
            </h2>
            <button 
              onClick={handleNextMonth}
              className="p-2 hover:bg-gray-100 rounded-lg"
            >
              <ChevronRight size={24} className="text-[#5E50A1]" />
            </button>
          </div>
          <button 
            onClick={() => setIsYearPickerOpen(true)}
            className="flex items-center space-x-1 p-2 hover:bg-gray-100 rounded-lg"
          >
            <CalendarIcon size={20} className="text-[#5E50A1]" />
            <span className="text-sm text-[#5E50A1]">Year</span>
          </button>
        </div>
      </div>

      {/* Calendar */}
      <div className="bg-white border-b border-gray-100 px-4 py-4">
        <Calendar
          mode="single"
          selected={selectedDate}
          onSelect={setSelectedDate}
          month={currentMonth}
          onMonthChange={setCurrentMonth}
          className="w-full"
          classNames={{
            day_selected: "bg-[#5E50A1] text-white hover:bg-[#5E50A1] hover:text-white focus:bg-[#5E50A1] focus:text-white",
            day_today: "bg-[#AFBCEB] text-[#5E50A1]"
          }}
        />
      </div>

      <div className="p-4 space-y-4">
        {/* Filter Chips */}
        <div className="flex space-x-2 overflow-x-auto pb-2">
          {filters.map((filter) => (
            <button
              key={filter}
              onClick={() => setActiveFilter(filter)}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
                activeFilter === filter
                  ? "bg-[#5E50A1] text-white"
                  : "bg-white text-[#1C1C1E] border border-[#E5E6EC]"
              }`}
            >
              {filter}
            </button>
          ))}
        </div>

        {/* Booking Cards */}
        <div className="space-y-3">
          {filteredBookings.map((booking) => (
            <div key={booking.id} className="bg-white rounded-xl p-4 shadow-sm">
              {/* Header Row */}
              <div className="flex items-center space-x-3 mb-3">
                <div className="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
                  <img src={booking.avatar} alt={booking.clientName} className="w-full h-full object-cover" />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-[#1C1C1E]">{booking.clientName}</h3>
                </div>
                <badge className={`px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(booking.status)}`}>
                  {booking.status}
                </badge>
              </div>
              
              {/* Service Info */}
              <div className="mb-3">
                <p className="font-medium text-[#1C1C1E]">{booking.service}</p>
                <p className="text-sm text-[#6E6E73]">{booking.date} • {booking.time}</p>
              </div>
              
              {/* Action Buttons */}
              <div className="flex space-x-2">
                {booking.status === "pending" && (
                  <Button size="sm" className="bg-green-600 hover:bg-green-700 text-white">
                    Accept
                  </Button>
                )}
                {(booking.status === "pending" || booking.status === "upcoming") && (
                  <Button size="sm" variant="outline" className="border-red-200 text-red-600 hover:bg-red-50">
                    Cancel
                  </Button>
                )}
                <Button 
                  size="sm" 
                  variant="outline" 
                  className="border-[#5E50A1] text-[#5E50A1] hover:bg-[#5E50A1] hover:text-white"
                  onClick={() => openBookingDetails(booking)}
                >
                  Details
                </Button>
              </div>
            </div>
          ))}
        </div>

        {/* Empty State */}
        {filteredBookings.length === 0 && (
          <div className="text-center py-12">
            <div className="w-24 h-24 bg-gray-100 rounded-full mx-auto mb-4 flex items-center justify-center">
              <CalendarIcon className="w-12 h-12 text-gray-400" />
            </div>
            <h3 className="text-lg font-medium text-[#1C1C1E] mb-2">No bookings found</h3>
            <p className="text-[#6E6E73]">
              No bookings match your current selection. Try adjusting your filters.
            </p>
          </div>
        )}
      </div>

      {/* Year Picker Sheet */}
      <Sheet open={isYearPickerOpen} onOpenChange={setIsYearPickerOpen}>
        <SheetContent side="bottom" className="h-[40%]">
          <SheetHeader>
            <SheetTitle>Select Year</SheetTitle>
            <SheetDescription>Choose a year to navigate to</SheetDescription>
          </SheetHeader>
          <div className="mt-6 space-y-2 max-h-64 overflow-y-auto">
            {years.map((year) => (
              <button
                key={year}
                onClick={() => handleYearChange(year)}
                className={`w-full p-3 text-left rounded-lg ${
                  year === currentMonth.getFullYear()
                    ? "bg-[#AFBCEB] text-[#5E50A1] font-medium"
                    : "hover:bg-gray-100"
                }`}
              >
                {year}
              </button>
            ))}
          </div>
          <div className="mt-6">
            <Button 
              onClick={() => setIsYearPickerOpen(false)}
              className="w-full h-12 bg-[#5E50A1] hover:bg-[#5E50A1]/90"
            >
              Close
            </Button>
          </div>
        </SheetContent>
      </Sheet>

      {/* Booking Details Sheet */}
      <Sheet open={isDetailSheetOpen} onOpenChange={setIsDetailSheetOpen}>
        <SheetContent side="bottom" className="h-[80%]">
          {selectedBooking && (
            <>
              <SheetHeader className="pb-4 border-b border-gray-100">
                <div className="flex items-center space-x-3">
                  <div className="w-12 h-12 bg-gray-200 rounded-full overflow-hidden">
                    <img src={selectedBooking.avatar} alt={selectedBooking.clientName} className="w-full h-full object-cover" />
                  </div>
                  <div>
                    <SheetTitle className="text-[#1C1C1E]">{selectedBooking.clientName}</SheetTitle>
                    <badge className={`inline-block px-2 py-1 rounded-full text-xs font-medium ${getStatusColor(selectedBooking.status)}`}>
                      {selectedBooking.status}
                    </badge>
                  </div>
                </div>
              </SheetHeader>

              <div className="py-4 space-y-4">
                {/* Service Details */}
                <div className="space-y-3">
                  <div className="flex justify-between">
                    <span className="text-[#6E6E73]">Service:</span>
                    <span className="font-medium text-[#1C1C1E]">{selectedBooking.service}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-[#6E6E73]">Date & Time:</span>
                    <span className="font-medium text-[#1C1C1E]">{selectedBooking.date} • {selectedBooking.time}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-[#6E6E73]">Duration:</span>
                    <span className="font-medium text-[#1C1C1E]">{selectedBooking.duration}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-[#6E6E73]">Price:</span>
                    <span className="font-medium text-[#1C1C1E]">{selectedBooking.price}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-[#6E6E73]">Deposit:</span>
                    <span className="font-medium text-[#1C1C1E]">{selectedBooking.deposit}</span>
                  </div>
                </div>

                {/* Contact Info */}
                <div className="border-t border-gray-100 pt-4 space-y-3">
                  <div className="flex items-center space-x-3">
                    <Phone size={20} className="text-[#5E50A1]" />
                    <span className="text-[#1C1C1E]">{selectedBooking.clientPhone}</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <Mail size={20} className="text-[#5E50A1]" />
                    <span className="text-[#1C1C1E]">{selectedBooking.clientEmail}</span>
                  </div>
                </div>

                {/* Policies */}
                <div className="border-t border-gray-100 pt-4">
                  <h4 className="font-medium text-[#1C1C1E] mb-3 flex items-center">
                    <Check size={20} className="text-green-600 mr-2" />
                    Policies Accepted
                  </h4>
                  <div className="space-y-2">
                    {selectedBooking.policies.map((policy, index) => (
                      <div key={index} className="flex items-center space-x-2">
                        <div className="w-1.5 h-1.5 bg-[#5E50A1] rounded-full"></div>
                        <span className="text-sm text-[#6E6E73]">{policy}</span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Action Buttons */}
                <div className="border-t border-gray-100 pt-4 space-y-3">
                  {selectedBooking.status === "pending" && (
                    <Button className="w-full bg-green-600 hover:bg-green-700 text-white h-12">
                      Confirm Booking
                    </Button>
                  )}
                  {(selectedBooking.status === "pending" || selectedBooking.status === "upcoming") && (
                    <>
                      <Button variant="outline" className="w-full border-[#5E50A1] text-[#5E50A1] hover:bg-[#5E50A1] hover:text-white h-12">
                        Reschedule
                      </Button>
                      <Button variant="outline" className="w-full border-red-200 text-red-600 hover:bg-red-50 h-12">
                        Cancel Booking
                      </Button>
                    </>
                  )}
                </div>
              </div>
            </>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
};

export default BookingsTab;
