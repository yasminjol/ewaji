
import React from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Calendar, TrendingUp, Users, Star, BarChart3 } from 'lucide-react';

const HomeTab = () => {
  const handleNavigateToMetrics = () => {
    window.location.href = '/provider/metrics';
  };

  return (
    <div className="p-4 space-y-6">
      {/* Welcome Header */}
      <div className="text-center py-6">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Welcome back, Sarah!</h1>
        <p className="text-gray-600">Here's what's happening with your business</p>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-2 gap-4">
        <Card className="bg-[#5E50A1] text-white">
          <CardContent className="p-4 text-center">
            <TrendingUp size={24} className="mx-auto mb-2" />
            <div className="text-2xl font-bold">$1,240</div>
            <div className="text-sm opacity-90">This Month</div>
          </CardContent>
        </Card>
        
        <Card className="bg-[#AFBCEB] text-white">
          <CardContent className="p-4 text-center">
            <Calendar size={24} className="mx-auto mb-2" />
            <div className="text-2xl font-bold">32</div>
            <div className="text-sm opacity-90">Bookings</div>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions */}
      <div className="space-y-3">
        <h2 className="text-lg font-semibold text-gray-900">Quick Actions</h2>
        
        <Card className="shadow-sm">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 rounded-full bg-[#5E50A1] bg-opacity-10 flex items-center justify-center">
                  <BarChart3 size={20} className="text-[#5E50A1]" />
                </div>
                <div>
                  <div className="font-medium text-gray-900">View Analytics</div>
                  <div className="text-sm text-gray-600">See your business metrics</div>
                </div>
              </div>
              <Button 
                variant="ghost" 
                size="sm"
                onClick={handleNavigateToMetrics}
                className="text-[#5E50A1] hover:bg-[#5E50A1] hover:bg-opacity-10"
              >
                View
              </Button>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-sm">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 rounded-full bg-[#5E50A1] bg-opacity-10 flex items-center justify-center">
                  <Calendar size={20} className="text-[#5E50A1]" />
                </div>
                <div>
                  <div className="font-medium text-gray-900">Manage Bookings</div>
                  <div className="text-sm text-gray-600">View and update appointments</div>
                </div>
              </div>
              <Button variant="ghost" size="sm" className="text-[#5E50A1] hover:bg-[#5E50A1] hover:bg-opacity-10">
                Manage
              </Button>
            </div>
          </CardContent>
        </Card>

        <Card className="shadow-sm">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 rounded-full bg-[#5E50A1] bg-opacity-10 flex items-center justify-center">
                  <Users size={20} className="text-[#5E50A1]" />
                </div>
                <div>
                  <div className="font-medium text-gray-900">Client Messages</div>
                  <div className="text-sm text-gray-600">3 new messages</div>
                </div>
              </div>
              <Button variant="ghost" size="sm" className="text-[#5E50A1] hover:bg-[#5E50A1] hover:bg-opacity-10">
                View
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Recent Activity */}
      <div className="space-y-3">
        <h2 className="text-lg font-semibold text-gray-900">Recent Activity</h2>
        
        <Card className="shadow-sm">
          <CardContent className="p-4 space-y-3">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center">
                <Star size={16} className="text-green-600" />
              </div>
              <div className="flex-1">
                <div className="text-sm font-medium">New 5-star review from Maya</div>
                <div className="text-xs text-gray-600">2 hours ago</div>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center">
                <Calendar size={16} className="text-blue-600" />
              </div>
              <div className="flex-1">
                <div className="text-sm font-medium">Knotless braids booking confirmed</div>
                <div className="text-xs text-gray-600">5 hours ago</div>
              </div>
            </div>
            
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 rounded-full bg-purple-100 flex items-center justify-center">
                <TrendingUp size={16} className="text-purple-600" />
              </div>
              <div className="flex-1">
                <div className="text-sm font-medium">Weekly earnings: $340</div>
                <div className="text-xs text-gray-600">1 day ago</div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default HomeTab;
