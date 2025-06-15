
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { X, ChevronLeft, ChevronRight, Calendar } from "lucide-react";
import {
  Sheet,
  SheetContent,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet";

const BookingsTab = () => {
  const [activeFilter, setActiveFilter] = useState("All");
  const [selectedDates, setSelectedDates] = useState<Set<string>>(new Set());
  const [currentDate, setCurrentDate] = useState(new Date());
  const [isYearPickerOpen, setIsYearPickerOpen] = useState(false);
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  
  const filters = ["All", "Upcoming", "Pending", "Completed", "Cancelled"];
  
  const bookings = [
    {
      id: 1,
      clientName: "Maya Johnson",
      avatar: "/placeholder.svg",
      service: "Protective Braids",
      date: "Dec 15",
      dateKey: "2024-12-15",
      time: "2:00 PM",
      status: "pending",
      statusColor: "bg-yellow-100 text-yellow-800"
    },
    {
      id: 2,
      clientName: "Zara Williams",
      avatar: "/placeholder.svg",
      service: "Natural Makeup",
      date: "Dec 16",
      dateKey: "2024-12-16",
      time: "10:30 AM",
      status: "confirmed",
      statusColor: "bg-green-100 text-green-800"
    },
    {
      id: 3,
      clientName: "Asha Davis",
      avatar: "/placeholder.svg",
      service: "Hair Color Treatment",
      date: "Dec 18",
      dateKey: "2024-12-18",
      time: "1:00 PM",
      status: "pending",
      statusColor: "bg-yellow-100 text-yellow-800"
    }
  ];

  // Generate calendar days based on current month
  const generateCalendarDays = () => {
    const days = [];
    const startOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const today = new Date();

    for (let i = 0; i < 28; i++) {
      const date = new Date(startOfMonth);
      date.setDate(startOfMonth.getDate() + i);
      
      const isPast = date < today && date.toDateString() !== today.toDateString();
      const weekday = date.toLocaleDateString('en', { weekday: 'short' });
      const dayNumber = date.getDate();
      const dateKey = date.toISOString().split('T')[0];
      
      days.push({
        weekday,
        dayNumber,
        dateKey,
        isPast,
        isSelected: selectedDates.has(dateKey)
      });
    }
    return days;
  };

  const calendarDays = generateCalendarDays();

  const handleDateSelect = (dateKey: string, isPast: boolean) => {
    if (isPast) return;

    setSelectedDates(prev => {
      const newSet = new Set(prev);
      if (newSet.has(dateKey)) {
        newSet.delete(dateKey);
      } else if (newSet.size < 4) {
        newSet.add(dateKey);
      } else {
        // Show toast for max 4 dates - for now just console log
        console.log("Select up to 4 dates.");
      }
      return newSet;
    });
  };

  const clearDates = () => {
    setSelectedDates(new Set());
  };

  const handleMonthChange = (direction: 'prev' | 'next') => {
    const newDate = new Date(currentDate);
    if (direction === 'prev') {
      newDate.setMonth(currentDate.getMonth() - 1);
    } else {
      newDate.setMonth(currentDate.getMonth() + 1);
    }
    setCurrentDate(newDate);
    setSelectedDates(new Set()); // Clear selected dates when changing month
  };

  const handleYearSave = () => {
    const newDate = new Date(selectedYear, 0, 1); // January 1st of selected year
    setCurrentDate(newDate);
    setSelectedDates(new Set()); // Clear selected dates when changing year
    setIsYearPickerOpen(false);
  };

  const generateYearOptions = () => {
    const currentYear = new Date().getFullYear();
    const years = [];
    for (let i = currentYear - 5; i <= currentYear + 5; i++) {
      years.push(i);
    }
    return years;
  };

  const monthYearLabel = currentDate.toLocaleDateString('en', { 
    month: 'short', 
    year: 'numeric' 
  });

  // Filter bookings based on selected dates and status
  const filteredBookings = bookings.filter(booking => {
    const statusMatch = activeFilter === "All" || booking.status === activeFilter.toLowerCase();
    const dateMatch = selectedDates.size === 0 || selectedDates.has(booking.dateKey);
    return statusMatch && dateMatch;
  });

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-4 py-4 shadow-sm">
        <h1 className="text-2xl font-bold text-gray-900">Bookings</h1>
      </div>
      
      {/* Month Switcher Row */}
      <div className="bg-white border-b border-gray-100 px-4 py-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <button
              onClick={() => handleMonthChange('prev')}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ChevronLeft size={24} className="text-[#5E50A1]" />
            </button>
            
            <button
              onClick={() => setIsYearPickerOpen(true)}
              className="text-base font-bold text-[#1C1C1E]"
            >
              {monthYearLabel}
            </button>
            
            <button
              onClick={() => handleMonthChange('next')}
              className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ChevronRight size={24} className="text-[#5E50A1]" />
            </button>
          </div>
          
          <button
            onClick={() => setIsYearPickerOpen(true)}
            className="flex items-center space-x-1 p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <Calendar size={20} className="text-[#5E50A1]" />
            <span className="text-[#5E50A1] text-sm">▾</span>
          </button>
        </div>
      </div>
      
      {/* Calendar Filter Strip */}
      <div className="bg-white border-b border-gray-100">
        <div className="h-[84px] px-4 py-2">
          <div className="flex items-center">
            <div className="flex space-x-3 overflow-x-auto flex-1 pb-2">
              {calendarDays.map((day, index) => (
                <button
                  key={index}
                  onClick={() => handleDateSelect(day.dateKey, day.isPast)}
                  disabled={day.isPast}
                  className={`flex-shrink-0 w-14 h-[72px] rounded-xl flex flex-col items-center justify-center transition-colors ${
                    day.isSelected
                      ? 'bg-[#5E50A1] text-white'
                      : day.isPast
                      ? 'text-gray-300 cursor-not-allowed'
                      : 'text-gray-900 hover:bg-gray-100'
                  }`}
                >
                  <span className="text-xs">{day.weekday}</span>
                  <span className="text-lg font-semibold">{day.dayNumber}</span>
                </button>
              ))}
            </div>
            {selectedDates.size > 0 && (
              <button
                onClick={clearDates}
                className="ml-2 p-2 text-gray-400 hover:text-gray-600"
              >
                <X size={20} />
              </button>
            )}
          </div>
        </div>
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
                  : "bg-white text-gray-600 border border-gray-200"
              }`}
            >
              {filter}
            </button>
          ))}
        </div>

        {/* Booking Cards */}
        <div className="space-y-4">
          {filteredBookings.map((booking) => (
            <div key={booking.id} className="bg-white rounded-xl p-4 shadow-sm">
              {/* Header Row */}
              <div className="flex items-center space-x-3 mb-3">
                <div className="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
                  <img src={booking.avatar} alt={booking.clientName} className="w-full h-full object-cover" />
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-gray-900">{booking.clientName}</h3>
                </div>
                <span className={`px-2 py-1 rounded-full text-xs font-medium ${booking.statusColor}`}>
                  {booking.status}
                </span>
              </div>
              
              {/* Service Info */}
              <div className="mb-3">
                <p className="font-medium text-gray-900">{booking.service}</p>
                <p className="text-sm text-gray-600">{booking.date} • {booking.time}</p>
              </div>
              
              {/* Action Buttons */}
              <div className="flex space-x-2">
                <Button size="sm" className="bg-green-600 hover:bg-green-700 text-white">
                  Accept
                </Button>
                <Button size="sm" variant="outline" className="border-red-200 text-red-600 hover:bg-red-50">
                  Cancel
                </Button>
                <Button size="sm" variant="outline" className="border-[#5E50A1] text-[#5E50A1] hover:bg-[#5E50A1] hover:text-white">
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
              <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <h3 className="text-lg font-medium text-gray-900 mb-2">
              {selectedDates.size > 0 ? "Nothing scheduled for these dates" : "No bookings yet"}
            </h3>
            <p className="text-gray-600">
              {selectedDates.size > 0 ? "Try selecting different dates or adjusting filters" : "Your upcoming appointments will appear here"}
            </p>
          </div>
        )}
      </div>

      {/* Year Picker Modal */}
      <Sheet open={isYearPickerOpen} onOpenChange={setIsYearPickerOpen}>
        <SheetContent side="bottom" className="h-[40%] rounded-t-xl">
          <SheetHeader className="pb-4">
            <div className="w-9 h-1 bg-gray-300 rounded-full mx-auto mb-4"></div>
            <SheetTitle className="text-lg font-bold text-center">Select Year</SheetTitle>
          </SheetHeader>
          
          <div className="flex-1 overflow-y-auto mb-4">
            <div className="space-y-2">
              {generateYearOptions().map((year) => (
                <button
                  key={year}
                  onClick={() => setSelectedYear(year)}
                  className={`w-full p-4 text-left rounded-lg transition-colors ${
                    selectedYear === year
                      ? 'bg-[#AFBCEB] text-[#5E50A1] font-semibold'
                      : 'hover:bg-gray-50'
                  }`}
                >
                  {year}
                </button>
              ))}
            </div>
          </div>
          
          <Button
            onClick={handleYearSave}
            className="w-full h-[52px] bg-[#5E50A1] hover:bg-[#5E50A1]/90 text-white rounded-xl"
          >
            Save
          </Button>
        </SheetContent>
      </Sheet>
    </div>
  );
};

export default BookingsTab;
