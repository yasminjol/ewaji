
import React, { useState } from "react";
import { 
  ArrowLeft, 
  Share2, 
  DollarSign, 
  Calendar, 
  Star, 
  Eye,
  ChevronDown
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from "@/components/ui/chart";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
} from "recharts";

interface MetricsScreenProps {
  onBack: () => void;
}

const MetricsScreen = ({ onBack }: MetricsScreenProps) => {
  const [selectedPeriod, setSelectedPeriod] = useState("Week");

  // Mock data
  const kpiData = [
    { icon: DollarSign, value: "$1,240", label: "earned", bgColor: "#AFBCEB" },
    { icon: Calendar, value: "32", label: "total bookings", bgColor: "#AFBCEB" },
    { icon: Star, value: "4.9", label: "(156 reviews)", bgColor: "#AFBCEB" },
    { icon: Eye, value: "650", label: "profile views", bgColor: "#AFBCEB" },
  ];

  const earningsData = [
    { day: "Mon", earnings: 180 },
    { day: "Tue", earnings: 240 },
    { day: "Wed", earnings: 160 },
    { day: "Thu", earnings: 300 },
    { day: "Fri", earnings: 220 },
    { day: "Sat", earnings: 280 },
    { day: "Sun", earnings: 200 },
  ];

  const bookingsData = [
    { day: "Mon", confirmed: 8, pending: 2, cancelled: 1 },
    { day: "Tue", confirmed: 12, pending: 3, cancelled: 0 },
    { day: "Wed", confirmed: 6, pending: 1, cancelled: 2 },
    { day: "Thu", confirmed: 15, pending: 4, cancelled: 1 },
    { day: "Fri", confirmed: 10, pending: 2, cancelled: 0 },
    { day: "Sat", confirmed: 14, pending: 3, cancelled: 1 },
    { day: "Sun", confirmed: 9, pending: 1, cancelled: 1 },
  ];

  const topServices = [
    { name: "Box Braids", bookings: 18, image: "/placeholder.svg" },
    { name: "Knotless Braids", bookings: 15, image: "/placeholder.svg" },
    { name: "Gel-X Nails", bookings: 12, image: "/placeholder.svg" },
    { name: "Fulani Braids", bookings: 8, image: "/placeholder.svg" },
    { name: "Acrylics", bookings: 6, image: "/placeholder.svg" },
  ];

  const depositData = [
    { name: "Deposits Held", value: 20, color: "#AFBCEB" },
    { name: "Released", value: 80, color: "#5E50A1" },
  ];

  const periods = ["Week", "Month", "Year", "Custom"];

  const handleExport = () => {
    // Mock export functionality
    console.log("Exporting metrics data...");
  };

  const chartConfig = {
    earnings: {
      label: "Earnings",
      color: "#5E50A1",
    },
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      {/* Header */}
      <div className="bg-white shadow-sm border-b border-gray-200 px-4 py-4">
        <div className="flex items-center justify-between">
          <button onClick={onBack} className="p-2 -ml-2">
            <ArrowLeft size={24} className="text-gray-700" />
          </button>
          <h1 className="text-xl font-bold text-[#1C1C1E]">Metrics</h1>
          <button onClick={handleExport} className="p-2 -mr-2">
            <Share2 size={24} className="text-[#5E50A1]" />
          </button>
        </div>
      </div>

      {/* Date Range Switcher */}
      <div className="sticky top-0 bg-white border-b border-gray-200 px-4 py-3 z-10">
        <div className="flex space-x-2">
          {periods.map((period) => (
            <button
              key={period}
              onClick={() => setSelectedPeriod(period)}
              className={`flex items-center px-4 py-2 rounded-full text-sm font-medium transition-colors ${
                selectedPeriod === period
                  ? "bg-[#5E50A1] text-white"
                  : "bg-gray-100 text-gray-700 hover:bg-gray-200"
              }`}
            >
              {period}
              {period === "Custom" && <ChevronDown size={16} className="ml-1" />}
            </button>
          ))}
        </div>
      </div>

      <div className="p-4 space-y-6">
        {/* KPI Carousel */}
        <div className="flex space-x-4 overflow-x-auto pb-2">
          {kpiData.map((kpi, index) => {
            const Icon = kpi.icon;
            return (
              <Card key={index} className="min-w-[140px] w-[140px] h-[116px] shadow-sm">
                <CardContent className="p-4 h-full flex flex-col justify-between">
                  <div className="w-10 h-10 rounded-full flex items-center justify-center" 
                       style={{ backgroundColor: kpi.bgColor }}>
                    <Icon size={20} className="text-[#5E50A1]" />
                  </div>
                  <div>
                    <div className="text-2xl font-bold text-gray-900">{kpi.value}</div>
                    <div className="text-sm text-gray-600">{kpi.label}</div>
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Earnings Trend */}
        <Card className="shadow-sm">
          <CardContent className="p-6">
            <h3 className="text-lg font-semibold mb-4">Earnings Trend</h3>
            <div className="h-[220px]">
              <ChartContainer config={chartConfig}>
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={earningsData}>
                    <defs>
                      <linearGradient id="earningsGradient" x1="0" y1="0" x2="1" y2="0">
                        <stop offset="0%" stopColor="#AFBCEB" />
                        <stop offset="100%" stopColor="#5E50A1" />
                      </linearGradient>
                    </defs>
                    <XAxis 
                      dataKey="day" 
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12, fill: '#666' }}
                    />
                    <YAxis hide />
                    <ChartTooltip content={<ChartTooltipContent />} />
                    <Line
                      type="monotone"
                      dataKey="earnings"
                      stroke="url(#earningsGradient)"
                      strokeWidth={2}
                      dot={{ fill: "#5E50A1", strokeWidth: 0, r: 4 }}
                      activeDot={{ r: 6, fill: "#5E50A1" }}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </ChartContainer>
            </div>
          </CardContent>
        </Card>

        {/* Bookings Breakdown */}
        <Card className="shadow-sm">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold">Bookings by Status</h3>
              <div className="flex items-center space-x-4 text-sm">
                <div className="flex items-center">
                  <div className="w-3 h-3 rounded-full bg-[#5E50A1] mr-2"></div>
                  <span>Confirmed</span>
                </div>
                <div className="flex items-center">
                  <div className="w-3 h-3 rounded-full bg-[#FFCC00] mr-2"></div>
                  <span>Pending</span>
                </div>
                <div className="flex items-center">
                  <div className="w-3 h-3 rounded-full bg-[#FF3B30] mr-2"></div>
                  <span>Cancelled</span>
                </div>
              </div>
            </div>
            <div className="h-[200px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={bookingsData}>
                  <XAxis 
                    dataKey="day" 
                    axisLine={false}
                    tickLine={false}
                    tick={{ fontSize: 12, fill: '#666' }}
                  />
                  <YAxis hide />
                  <ChartTooltip />
                  <Bar dataKey="confirmed" stackId="a" fill="#5E50A1" radius={[0, 0, 4, 4]} />
                  <Bar dataKey="pending" stackId="a" fill="#FFCC00" />
                  <Bar dataKey="cancelled" stackId="a" fill="#FF3B30" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Top Services */}
        <Card className="shadow-sm">
          <CardContent className="p-6">
            <h3 className="text-lg font-semibold mb-4">Top Services</h3>
            <div className="space-y-3">
              {topServices.map((service, index) => (
                <div key={index} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <img
                      src={service.image}
                      alt={service.name}
                      className="w-12 h-12 rounded-lg object-cover"
                    />
                    <span className="font-medium">{service.name}</span>
                  </div>
                  <div className="bg-[#AFBCEB] text-[#5E50A1] px-3 py-1 rounded-full text-sm font-medium">
                    {service.bookings} bookings
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Deposit vs Released Funds */}
        <Card className="shadow-sm">
          <CardContent className="p-6">
            <h3 className="text-lg font-semibold mb-4">Deposit vs Released Funds</h3>
            <div className="flex items-center justify-center">
              <div className="relative">
                <ResponsiveContainer width={140} height={140}>
                  <PieChart>
                    <Pie
                      data={depositData}
                      cx={70}
                      cy={70}
                      innerRadius={40}
                      outerRadius={70}
                      dataKey="value"
                    >
                      {depositData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                  </PieChart>
                </ResponsiveContainer>
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="text-center">
                    <div className="text-lg font-bold">$1,240</div>
                    <div className="text-xs text-gray-600">Total</div>
                  </div>
                </div>
              </div>
              <div className="ml-8 space-y-2">
                {depositData.map((item, index) => (
                  <div key={index} className="flex items-center space-x-2">
                    <div 
                      className="w-3 h-3 rounded-full" 
                      style={{ backgroundColor: item.color }}
                    ></div>
                    <span className="text-sm">{item.name}</span>
                    <span className="text-sm font-medium">{item.value}%</span>
                  </div>
                ))}
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default MetricsScreen;
