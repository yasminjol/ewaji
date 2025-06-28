
import { useState } from "react";
import { Calendar, Clock, User, Phone, X, RotateCcw } from "lucide-react";
import { Button } from "@/components/ui/button";

const ClientAppointmentsScreen = () => {
  const [activeTab, setActiveTab] = useState("upcoming");

  const appointments = {
    upcoming: [
      {
        id: 1,
        service: "Balayage & Cut",
        provider: {
          name: "Sophia's Hair Studio",
          avatar: "https://images.unsplash.com/photo-1494790108755-2616c5e68b05?w=50&h=50&fit=crop&crop=face"
        },
        date: "Dec 28, 2024",
        time: "2:00 PM",
        status: "confirmed"
      },
      {
        id: 2,
        service: "Gel Manicure",
        provider: {
          name: "Glamour Nails",
          avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50&fit=crop&crop=face"
        },
        date: "Dec 30, 2024",
        time: "11:00 AM",
        status: "pending"
      }
    ],
    completed: [
      {
        id: 3,
        service: "Facial Treatment",
        provider: {
          name: "Bella Beauty",
          avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop&crop=face"
        },
        date: "Dec 20, 2024",
        time: "3:00 PM",
        status: "completed"
      }
    ],
    cancelled: [
      {
        id: 4,
        service: "Eyelash Extensions",
        provider: {
          name: "Elite Lashes",
          avatar: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=50&h=50&fit=crop&crop=face"
        },
        date: "Dec 15, 2024",
        time: "1:00 PM",
        status: "cancelled"
      }
    ]
  };

  const tabs = [
    { id: "upcoming", label: "Upcoming", color: "text-blue-600" },
    { id: "completed", label: "Completed", color: "text-green-600" },
    { id: "cancelled", label: "Cancelled", color: "text-red-600" }
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case "confirmed": return "text-blue-600 bg-blue-50";
      case "pending": return "text-yellow-600 bg-yellow-50";
      case "completed": return "text-green-600 bg-green-50";
      case "cancelled": return "text-red-600 bg-red-50";
      default: return "text-gray-600 bg-gray-50";
    }
  };

  return (
    <div className="bg-white min-h-screen">
      {/* Header */}
      <div className="p-4 border-b border-gray-100">
        <h1 className="text-2xl font-bold text-[#1C1C1E] text-center">Appointments</h1>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-gray-100">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`flex-1 py-4 px-2 text-sm font-medium transition-colors ${
              activeTab === tab.id
                ? "border-b-2 border-[#5E50A1] text-[#5E50A1]"
                : "text-[#6E6E73]"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Appointments List */}
      <div className="p-4 space-y-4">
        {appointments[activeTab as keyof typeof appointments].map((appointment) => (
          <div key={appointment.id} className="bg-white rounded-xl border border-gray-100 p-4 shadow-sm">
            {/* Status Badge */}
            <div className="flex justify-between items-start mb-3">
              <span className={`text-xs font-medium px-2 py-1 rounded-full ${getStatusColor(appointment.status)}`}>
                {appointment.status.charAt(0).toUpperCase() + appointment.status.slice(1)}
              </span>
            </div>

            {/* Service & Provider */}
            <div className="flex items-center mb-3">
              <img 
                src={appointment.provider.avatar} 
                alt={appointment.provider.name}
                className="w-12 h-12 rounded-full object-cover"
              />
              <div className="ml-3 flex-1">
                <h3 className="font-semibold text-[#1C1C1E]">{appointment.service}</h3>
                <p className="text-[#6E6E73] text-sm">{appointment.provider.name}</p>
              </div>
            </div>

            {/* Date & Time */}
            <div className="flex items-center space-x-4 mb-4">
              <div className="flex items-center text-[#6E6E73] text-sm">
                <Calendar size={16} className="mr-1" />
                {appointment.date}
              </div>
              <div className="flex items-center text-[#6E6E73] text-sm">
                <Clock size={16} className="mr-1" />
                {appointment.time}
              </div>
            </div>

            {/* Action Buttons */}
            {appointment.status === "upcoming" && (
              <div className="flex space-x-2">
                <Button
                  variant="outline"
                  size="sm"
                  className="flex-1 border-red-200 text-red-600 hover:bg-red-50"
                >
                  <X size={16} className="mr-1" />
                  Cancel
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  className="flex-1 border-gray-200 text-[#6E6E73] hover:bg-gray-50"
                >
                  <RotateCcw size={16} className="mr-1" />
                  Reschedule
                </Button>
                <Button
                  size="sm"
                  className="flex-1 bg-[#5E50A1] hover:bg-[#4F4391] text-white"
                >
                  <Phone size={16} className="mr-1" />
                  Contact
                </Button>
              </div>
            )}

            {appointment.status === "completed" && (
              <Button
                variant="outline"
                size="sm"
                className="w-full border-[#5E50A1] text-[#5E50A1] hover:bg-[#5E50A1] hover:text-white"
              >
                Book Again
              </Button>
            )}
          </div>
        ))}

        {appointments[activeTab as keyof typeof appointments].length === 0 && (
          <div className="text-center py-12">
            <Calendar size={48} className="mx-auto text-[#AFBCEB] mb-4" />
            <h3 className="text-lg font-medium text-[#1C1C1E] mb-2">No appointments</h3>
            <p className="text-[#6E6E73]">
              {activeTab === "upcoming" && "You don't have any upcoming appointments."}
              {activeTab === "completed" && "No completed appointments yet."}
              {activeTab === "cancelled" && "No cancelled appointments."}
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default ClientAppointmentsScreen;
