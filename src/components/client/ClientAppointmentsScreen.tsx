
import React, { useState } from 'react';
import { Calendar, Clock, MapPin, Phone, X, RotateCcw } from 'lucide-react';
import { Button } from '@/components/ui/button';

const ClientAppointmentsScreen = () => {
  const [activeTab, setActiveTab] = useState('upcoming');

  const appointments = {
    upcoming: [
      {
        id: 1,
        provider: {
          name: "Sarah Williams",
          avatar: "/placeholder.svg",
        },
        service: "Silk Press & Makeup",
        date: "Tomorrow",
        time: "2:00 PM",
        location: "Downtown Studio",
        status: "confirmed"
      },
      {
        id: 2,
        provider: {
          name: "Maya Johnson",
          avatar: "/placeholder.svg",
        },
        service: "Knotless Braids",
        date: "Dec 15",
        time: "10:00 AM",
        location: "Midtown Salon",
        status: "pending"
      },
    ],
    completed: [
      {
        id: 3,
        provider: {
          name: "Zara Adams",
          avatar: "/placeholder.svg",
        },
        service: "Gel-X Nails",
        date: "Dec 1",
        time: "3:00 PM",
        location: "Beauty Bar",
        status: "completed"
      },
    ],
    cancelled: [
      {
        id: 4,
        provider: {
          name: "Jade Chen",
          avatar: "/placeholder.svg",
        },
        service: "Lash Extensions",
        date: "Nov 28",
        time: "1:00 PM",
        location: "Lash Studio",
        status: "cancelled"
      },
    ]
  };

  const tabs = [
    { id: 'upcoming', label: 'Upcoming', count: appointments.upcoming.length },
    { id: 'completed', label: 'Completed', count: appointments.completed.length },
    { id: 'cancelled', label: 'Cancelled', count: appointments.cancelled.length },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-4 py-4 border-b border-gray-200">
        <h1 className="text-xl font-bold text-[#1C1C1E]">Appointments</h1>
      </div>

      {/* Tabs */}
      <div className="bg-white px-4 py-3 border-b border-gray-200">
        <div className="flex space-x-1">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 py-2 px-3 rounded-lg text-sm font-medium transition-colors ${
                activeTab === tab.id
                  ? 'bg-[#5E50A1] text-white'
                  : 'text-[#6E6E73] hover:bg-gray-100'
              }`}
            >
              {tab.label} ({tab.count})
            </button>
          ))}
        </div>
      </div>

      {/* Appointments List */}
      <div className="p-4 space-y-4">
        {appointments[activeTab as keyof typeof appointments].map((appointment) => (
          <div key={appointment.id} className="bg-white rounded-xl p-4 shadow-sm border border-gray-100">
            {/* Appointment Header */}
            <div className="flex items-center space-x-3 mb-3">
              <img
                src={appointment.provider.avatar}
                alt={appointment.provider.name}
                className="w-12 h-12 rounded-full object-cover"
              />
              <div className="flex-1">
                <h3 className="font-semibold text-[#1C1C1E]">{appointment.provider.name}</h3>
                <p className="text-sm text-[#6E6E73]">{appointment.service}</p>
              </div>
              <div className={`px-2 py-1 rounded-full text-xs font-medium ${
                appointment.status === 'confirmed' ? 'bg-green-100 text-green-800' :
                appointment.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                appointment.status === 'completed' ? 'bg-blue-100 text-blue-800' :
                'bg-red-100 text-red-800'
              }`}>
                {appointment.status}
              </div>
            </div>

            {/* Appointment Details */}
            <div className="space-y-2 mb-4">
              <div className="flex items-center space-x-2 text-sm text-[#6E6E73]">
                <Calendar size={16} />
                <span>{appointment.date}</span>
              </div>
              <div className="flex items-center space-x-2 text-sm text-[#6E6E73]">
                <Clock size={16} />
                <span>{appointment.time}</span>
              </div>
              <div className="flex items-center space-x-2 text-sm text-[#6E6E73]">
                <MapPin size={16} />
                <span>{appointment.location}</span>
              </div>
            </div>

            {/* Action Buttons */}
            {activeTab === 'upcoming' && (
              <div className="flex space-x-2">
                <Button size="sm" variant="outline" className="flex-1 border-[#5E50A1] text-[#5E50A1] hover:bg-[#5E50A1] hover:text-white">
                  <Phone size={16} className="mr-1" />
                  Contact
                </Button>
                <Button size="sm" variant="outline" className="flex-1 border-gray-300 text-[#6E6E73] hover:bg-gray-50">
                  <RotateCcw size={16} className="mr-1" />
                  Reschedule
                </Button>
                <Button size="sm" variant="outline" className="flex-1 border-red-300 text-red-600 hover:bg-red-50">
                  <X size={16} className="mr-1" />
                  Cancel
                </Button>
              </div>
            )}
          </div>
        ))}

        {appointments[activeTab as keyof typeof appointments].length === 0 && (
          <div className="text-center py-12">
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Calendar size={24} className="text-gray-400" />
            </div>
            <h3 className="text-lg font-medium text-[#1C1C1E] mb-2">No appointments</h3>
            <p className="text-[#6E6E73] mb-4">You don't have any {activeTab} appointments yet.</p>
            <Button className="bg-[#5E50A1] hover:bg-[#4F4391] text-white">
              Book Your First Service
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default ClientAppointmentsScreen;
