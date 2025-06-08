
import { MoreHorizontal, Info, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";

const HomeTab = () => {
  const posts = [
    { id: 1, image: "/placeholder.svg", title: "Natural Glow Makeup" },
    { id: 2, image: "/placeholder.svg", title: "Braided Protective Style" },
    { id: 3, image: "/placeholder.svg", title: "Evening Glam Look" }
  ];

  const aiStyles = [
    { id: 1, image: "/placeholder.svg", name: "Soft Glam", trending: true },
    { id: 2, image: "/placeholder.svg", name: "Natural Curls", trending: false },
    { id: 3, image: "/placeholder.svg", name: "Bold Lips", trending: true }
  ];

  const inDemandStyles = [
    { name: "Protective Styles", bookings: 45 },
    { name: "Natural Makeup", bookings: 32 },
    { name: "Hair Color", bookings: 28 }
  ];

  return (
    <div className="p-6 space-y-8">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-xl font-bold text-gray-900">
            Welcome back, Sarah
          </h1>
          <div className="mt-2 inline-flex items-center px-3 py-1 rounded-full bg-green-100 text-green-800 text-sm font-medium">
            $420 today
          </div>
        </div>
      </div>

      {/* MY POSTS Section */}
      <div className="space-y-4">
        <h2 className="text-lg font-semibold text-gray-900">MY POSTS</h2>
        <div className="space-y-3">
          {posts.map((post) => (
            <div key={post.id} className="bg-white rounded-xl p-4 shadow-sm">
              <div className="flex items-center space-x-3">
                <div className="w-16 h-16 bg-gray-200 rounded-lg overflow-hidden">
                  <img src={post.image} alt={post.title} className="w-full h-full object-cover" />
                </div>
                <div className="flex-1">
                  <h3 className="font-medium text-gray-900">{post.title}</h3>
                </div>
                <button className="p-2 text-gray-400 hover:text-gray-600">
                  <MoreHorizontal size={20} />
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* AI STYLE RADAR Section */}
      <div className="space-y-4">
        <div className="flex items-center space-x-2">
          <h2 className="text-lg font-semibold text-gray-900">AI Style Radar</h2>
          <Info size={16} className="text-gray-400" />
        </div>
        <div className="flex space-x-4 overflow-x-auto pb-2">
          {aiStyles.map((style) => (
            <div key={style.id} className="min-w-[220px] bg-white rounded-xl p-4 shadow-sm">
              <div className="w-full h-32 bg-gray-200 rounded-lg mb-3 overflow-hidden">
                <img src={style.image} alt={style.name} className="w-full h-full object-cover" />
              </div>
              <h3 className="font-medium text-gray-900 mb-2">{style.name}</h3>
              <Button size="sm" className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white">
                <Plus size={16} className="mr-1" />
                Add Service
              </Button>
            </div>
          ))}
        </div>
      </div>

      {/* IN-DEMAND NOW Section */}
      <div className="space-y-4">
        <h2 className="text-lg font-semibold text-gray-900">IN-DEMAND NOW</h2>
        <div className="bg-white rounded-xl p-4 shadow-sm space-y-3">
          {inDemandStyles.map((style, index) => (
            <div key={style.name} className="flex items-center justify-between">
              <div className="flex items-center space-x-3">
                <div className="w-8 h-4 bg-[#5E50A1] rounded" style={{
                  width: `${Math.max(20, (style.bookings / 50) * 100)}px`
                }}></div>
                <span className="font-medium text-gray-900">{style.name}</span>
              </div>
              <span className="bg-[#AFBCEB] text-[#5E50A1] px-2 py-1 rounded-full text-xs font-medium">
                {style.bookings}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default HomeTab;
