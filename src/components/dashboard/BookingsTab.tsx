
import { useState } from "react";
import { Button } from "@/components/ui/button";

const BookingsTab = () => {
  const [activeFilter, setActiveFilter] = useState("All");
  
  const filters = ["All", "Upcoming", "Pending", "Completed", "Cancelled"];
  
  const bookings = [
    {
      id: 1,
      clientName: "Maya Johnson",
      avatar: "/placeholder.svg",
      service: "Protective Braids",
      date: "Dec 15",
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
      time: "1:00 PM",
      status: "pending",
      statusColor: "bg-yellow-100 text-yellow-800"
    }
  ];

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <h1 className="text-2xl font-bold text-gray-900">Bookings</h1>
      
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
        {bookings.map((booking) => (
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

      {/* Empty State (if no bookings) */}
      {bookings.length === 0 && (
        <div className="text-center py-12">
          <div className="w-24 h-24 bg-gray-100 rounded-full mx-auto mb-4 flex items-center justify-center">
            <svg className="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
            </svg>
          </div>
          <h3 className="text-lg font-medium text-gray-900 mb-2">No bookings yet</h3>
          <p className="text-gray-600">Your upcoming appointments will appear here</p>
        </div>
      )}
    </div>
  );
};

export default BookingsTab;
