
import React, { useState } from 'react';
import { ArrowLeft, Share2, Calendar, DollarSign, Eye, Star } from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { ChartContainer, ChartTooltip, ChartTooltipContent } from '@/components/ui/chart';
import { LineChart, Line, XAxis, YAxis, ResponsiveContainer, BarChart, Bar, PieChart, Pie, Cell } from 'recharts';

type DateRange = 'week' | 'month' | 'year' | 'custom';

interface KPIData {
  earnings: number;
  bookings: number;
  rating: number;
  reviews: number;
  profileViews: number;
}

interface EarningsData {
  date: string;
  amount: number;
}

interface BookingsData {
  date: string;
  confirmed: number;
  pending: number;
  cancelled: number;
}

interface TopService {
  id: string;
  name: string;
  thumbnail: string;
  bookings: number;
}

const MetricsScreen = () => {
  const [selectedRange, setSelectedRange] = useState<DateRange>('month');
  const [showCustomPicker, setShowCustomPicker] = useState(false);

  // Mock data - replace with real API calls
  const kpiData: KPIData = {
    earnings: 1240,
    bookings: 32,
    rating: 4.9,
    reviews: 156,
    profileViews: 650
  };

  const earningsData: EarningsData[] = [
    { date: 'Week 1', amount: 280 },
    { date: 'Week 2', amount: 340 },
    { date: 'Week 3', amount: 410 },
    { date: 'Week 4', amount: 210 },
  ];

  const bookingsData: BookingsData[] = [
    { date: 'Week 1', confirmed: 8, pending: 2, cancelled: 1 },
    { date: 'Week 2', confirmed: 10, pending: 1, cancelled: 0 },
    { date: 'Week 3', confirmed: 9, pending: 3, cancelled: 1 },
    { date: 'Week 4', confirmed: 5, pending: 1, cancelled: 0 },
  ];

  const topServices: TopService[] = [
    { id: '1', name: 'Box Braids', thumbnail: '/placeholder.svg', bookings: 18 },
    { id: '2', name: 'Knotless Braids', thumbnail: '/placeholder.svg', bookings: 14 },
    { id: '3', name: 'Fulani Braids', thumbnail: '/placeholder.svg', bookings: 8 },
    { id: '4', name: 'Boho Twists', thumbnail: '/placeholder.svg', bookings: 6 },
  ];

  const depositData = [
    { name: 'Deposits Held', value: 20, color: '#AFBCEB' },
    { name: 'Released', value: 80, color: '#5E50A1' },
  ];

  const hasData = kpiData.bookings > 0;

  const handleShare = () => {
    // Implement native share functionality
    if (navigator.share) {
      navigator.share({
        title: 'My EWAJI Metrics',
        text: `Earnings: $${kpiData.earnings} | Bookings: ${kpiData.bookings}`,
      });
    }
  };

  const handleBack = () => {
    window.history.back();
  };

  if (!hasData) {
    return (
      <div className="min-h-screen bg-gray-50 flex flex-col">
        {/* Header */}
        <div className="bg-white shadow-sm px-4 py-4 flex items-center justify-between">
          <button onClick={handleBack} className="p-2">
            <ArrowLeft size={24} className="text-gray-600" />
          </button>
          <h1 className="text-xl font-bold text-[#1C1C1E]">Metrics</h1>
          <button onClick={handleShare} className="p-2">
            <Share2 size={24} className="text-gray-600" />
          </button>
        </div>

        {/* Empty State */}
        <div className="flex-1 flex flex-col items-center justify-center px-6">
          <div className="w-24 h-24 rounded-full bg-[#AFBCEB] bg-opacity-20 flex items-center justify-center mb-6">
            <div className="w-12 h-12 text-[#AFBCEB]">
              📊
            </div>
          </div>
          <h2 className="text-2xl font-bold text-gray-900 mb-2">No data yet</h2>
          <p className="text-gray-600 text-center mb-8">
            Start accepting bookings to see your metrics.
          </p>
          <Button 
            className="bg-[#5E50A1] hover:bg-[#5E50A1]/90 text-white px-8 py-3"
            onClick={() => window.location.href = '/provider/dashboard'}
          >
            View Service & Pricing
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm px-4 py-4 flex items-center justify-between sticky top-0 z-10">
        <button onClick={handleBack} className="p-2">
          <ArrowLeft size={24} className="text-gray-600" />
        </button>
        <h1 className="text-xl font-bold text-[#1C1C1E]">Metrics</h1>
        <button onClick={handleShare} className="p-2">
          <Share2 size={24} className="text-gray-600" />
        </button>
      </div>

      <div className="p-4 space-y-6 pb-24">
        {/* Date Range Switcher */}
        <div className="flex space-x-2">
          {(['week', 'month', 'year'] as DateRange[]).map((range) => (
            <button
              key={range}
              onClick={() => setSelectedRange(range)}
              className={`px-4 py-2 rounded-full text-sm font-medium capitalize transition-colors ${
                selectedRange === range
                  ? 'bg-[#5E50A1] text-white'
                  : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
              }`}
            >
              {range}
            </button>
          ))}
          <button
            onClick={() => setShowCustomPicker(true)}
            className={`px-4 py-2 rounded-full text-sm font-medium flex items-center space-x-1 transition-colors ${
              selectedRange === 'custom'
                ? 'bg-[#5E50A1] text-white'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            }`}
          >
            <span>Custom</span>
            <Calendar size={14} />
          </button>
        </div>

        {/* KPI Cards Carousel */}
        <div className="flex space-x-4 overflow-x-auto pb-2">
          <Card className="min-w-[140px] h-[116px] shadow-sm">
            <CardContent className="p-4 flex flex-col items-center text-center">
              <div className="w-10 h-10 rounded-full bg-[#AFBCEB] bg-opacity-20 flex items-center justify-center mb-2">
                <DollarSign size={20} className="text-[#5E50A1]" />
              </div>
              <div className="text-2xl font-bold text-gray-900">${kpiData.earnings.toLocaleString()}</div>
              <div className="text-xs text-gray-600">earned this range</div>
            </CardContent>
          </Card>

          <Card className="min-w-[140px] h-[116px] shadow-sm">
            <CardContent className="p-4 flex flex-col items-center text-center">
              <div className="w-10 h-10 rounded-full bg-[#AFBCEB] bg-opacity-20 flex items-center justify-center mb-2">
                <Calendar size={20} className="text-[#5E50A1]" />
              </div>
              <div className="text-2xl font-bold text-gray-900">{kpiData.bookings}</div>
              <div className="text-xs text-gray-600">total bookings</div>
            </CardContent>
          </Card>

          <Card className="min-w-[140px] h-[116px] shadow-sm">
            <CardContent className="p-4 flex flex-col items-center text-center">
              <div className="w-10 h-10 rounded-full bg-[#AFBCEB] bg-opacity-20 flex items-center justify-center mb-2">
                <Star size={20} className="text-[#5E50A1]" />
              </div>
              <div className="text-2xl font-bold text-gray-900">{kpiData.rating}</div>
              <div className="text-xs text-gray-600">({kpiData.reviews} reviews)</div>
            </CardContent>
          </Card>

          <Card className="min-w-[140px] h-[116px] shadow-sm">
            <CardContent className="p-4 flex flex-col items-center text-center">
              <div className="w-10 h-10 rounded-full bg-[#AFBCEB] bg-opacity-20 flex items-center justify-center mb-2">
                <Eye size={20} className="text-[#5E50A1]" />
              </div>
              <div className="text-2xl font-bold text-gray-900">{kpiData.profileViews}</div>
              <div className="text-xs text-gray-600">profile views</div>
            </CardContent>
          </Card>
        </div>

        {/* Earnings Trend Chart */}
        <Card className="shadow-sm">
          <CardHeader>
            <CardTitle className="text-lg font-semibold">Earnings Trend</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[220px]">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={earningsData}>
                  <XAxis dataKey="date" axisLine={false} tickLine={false} />
                  <YAxis hide />
                  <ChartTooltip content={<ChartTooltipContent />} />
                  <Line 
                    type="monotone" 
                    dataKey="amount" 
                    stroke="url(#gradient)" 
                    strokeWidth={2}
                    dot={{ fill: '#5E50A1', strokeWidth: 2, r: 4 }}
                  />
                  <defs>
                    <linearGradient id="gradient" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="0%" stopColor="#AFBCEB" />
                      <stop offset="100%" stopColor="#5E50A1" />
                    </linearGradient>
                  </defs>
                </LineChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Bookings Breakdown */}
        <Card className="shadow-sm">
          <CardHeader>
            <CardTitle className="text-lg font-semibold">Bookings Breakdown</CardTitle>
            <div className="flex space-x-4 text-sm">
              <div className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded bg-[#5E50A1]"></div>
                <span>Confirmed</span>
              </div>
              <div className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded bg-[#FFCC00]"></div>
                <span>Pending</span>
              </div>
              <div className="flex items-center space-x-2">
                <div className="w-3 h-3 rounded bg-[#FF3B30]"></div>
                <span>Cancelled</span>
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <div className="h-[200px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={bookingsData}>
                  <XAxis dataKey="date" axisLine={false} tickLine={false} />
                  <YAxis hide />
                  <ChartTooltip content={<ChartTooltipContent />} />
                  <Bar dataKey="confirmed" stackId="a" fill="#5E50A1" />
                  <Bar dataKey="pending" stackId="a" fill="#FFCC00" />
                  <Bar dataKey="cancelled" stackId="a" fill="#FF3B30" />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Top Services */}
        <Card className="shadow-sm">
          <CardHeader>
            <CardTitle className="text-lg font-semibold">Top Services</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {topServices.map((service) => (
              <div key={service.id} className="flex items-center space-x-3">
                <img 
                  src={service.thumbnail} 
                  alt={service.name}
                  className="w-12 h-12 rounded-lg object-cover"
                />
                <div className="flex-1">
                  <div className="font-medium text-gray-900">{service.name}</div>
                </div>
                <Badge 
                  variant="secondary" 
                  className="bg-[#AFBCEB] bg-opacity-20 text-[#5E50A1] hover:bg-[#AFBCEB] hover:bg-opacity-30"
                >
                  {service.bookings} bookings
                </Badge>
              </div>
            ))}
          </CardContent>
        </Card>

        {/* Deposit vs Payout Pie Chart */}
        <Card className="shadow-sm">
          <CardHeader>
            <CardTitle className="text-lg font-semibold">Deposit vs. Final Payout</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-center">
              <div className="w-[140px] h-[140px]">
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={depositData}
                      cx="50%"
                      cy="50%"
                      innerRadius={35}
                      outerRadius={70}
                      paddingAngle={2}
                      dataKey="value"
                    >
                      {depositData.map((entry, index) => (
                        <Cell key={`cell-${index}`} fill={entry.color} />
                      ))}
                    </Pie>
                    <ChartTooltip content={<ChartTooltipContent />} />
                  </PieChart>
                </ResponsiveContainer>
              </div>
              <div className="ml-6 space-y-2">
                {depositData.map((entry, index) => (
                  <div key={index} className="flex items-center space-x-2 text-sm">
                    <div className="w-3 h-3 rounded" style={{ backgroundColor: entry.color }}></div>
                    <span>{entry.name} ({entry.value}%)</span>
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
