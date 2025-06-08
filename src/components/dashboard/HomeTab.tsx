
import { MoreHorizontal, Heart, Bookmark, Share, Plus, Camera } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { useState } from "react";

const HomeTab = () => {
  const [likedPosts, setLikedPosts] = useState<Set<number>>(new Set());
  const [savedPosts, setSavedPosts] = useState<Set<number>>(new Set());

  const posts = [
    { id: 1, image: "/placeholder.svg", caption: "Natural glow makeup for evening events ✨", timestamp: "2h", likes: 24 },
    { id: 2, image: "/placeholder.svg", caption: "Protective braided style perfect for summer", timestamp: "4h", likes: 18 },
    { id: 3, image: "/placeholder.svg", caption: "Bold evening glam look 💄", timestamp: "1d", likes: 31 },
    { id: 4, image: "/placeholder.svg", caption: "Soft curls with natural makeup", timestamp: "2d", likes: 15 },
    { id: 5, image: "/placeholder.svg", caption: "Color pop lips for the weekend", timestamp: "3d", likes: 22 },
  ];

  const aiStories = [
    { id: 1, image: "/placeholder.svg", name: "Soft Glam" },
    { id: 2, image: "/placeholder.svg", name: "Natural Curls" },
    { id: 3, image: "/placeholder.svg", name: "Bold Lips" },
    { id: 4, image: "/placeholder.svg", name: "Braided Crown" },
    { id: 5, image: "/placeholder.svg", name: "Smokey Eyes" },
  ];

  const toggleLike = (postId: number) => {
    setLikedPosts(prev => {
      const newSet = new Set(prev);
      if (newSet.has(postId)) {
        newSet.delete(postId);
      } else {
        newSet.add(postId);
      }
      return newSet;
    });
  };

  const toggleSave = (postId: number) => {
    setSavedPosts(prev => {
      const newSet = new Set(prev);
      if (newSet.has(postId)) {
        newSet.delete(postId);
      } else {
        newSet.add(postId);
      }
      return newSet;
    });
  };

  const renderFeedCard = (post: any) => (
    <div key={post.id} className="bg-white mb-6">
      {/* Card Header */}
      <div className="flex items-center justify-between p-3">
        <div className="flex items-center space-x-3">
          <Avatar className="w-8 h-8">
            <AvatarImage src="/placeholder.svg" alt="Sarah Williams" />
            <AvatarFallback>SW</AvatarFallback>
          </Avatar>
          <span className="font-semibold text-sm text-gray-900">Sarah Williams</span>
        </div>
        <button className="p-1 text-gray-400 hover:text-gray-600">
          <MoreHorizontal size={20} />
        </button>
      </div>

      {/* Media */}
      <div className="px-3">
        <div className="w-full aspect-square bg-gray-200 rounded-xl overflow-hidden">
          <img src={post.image} alt={post.caption} className="w-full h-full object-cover" />
        </div>
      </div>

      {/* Action Row */}
      <div className="p-3 space-y-2">
        <div className="flex items-center space-x-4">
          <button 
            onClick={() => toggleLike(post.id)}
            className={`p-1 ${likedPosts.has(post.id) ? 'text-red-500' : 'text-gray-600'} hover:text-red-500 transition-colors`}
          >
            <Heart size={24} fill={likedPosts.has(post.id) ? 'currentColor' : 'none'} />
          </button>
          <button 
            onClick={() => toggleSave(post.id)}
            className={`p-1 ${savedPosts.has(post.id) ? 'text-[#5E50A1]' : 'text-gray-600'} hover:text-[#5E50A1] transition-colors`}
          >
            <Bookmark size={24} fill={savedPosts.has(post.id) ? 'currentColor' : 'none'} />
          </button>
          <button className="p-1 text-gray-600 hover:text-[#5E50A1] transition-colors">
            <Share size={24} />
          </button>
        </div>

        {/* Caption */}
        <div className="space-y-1">
          <p className="text-sm text-gray-900 line-clamp-2">
            <span className="font-semibold">Sarah Williams</span> {post.caption}
          </p>
          <p className="text-xs text-gray-500">{post.timestamp}</p>
        </div>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top App Bar */}
      <div className="bg-white px-4 py-3 shadow-sm sticky top-0 z-10">
        <div className="flex items-center justify-between">
          <Avatar className="w-8 h-8">
            <AvatarImage src="/placeholder.svg" alt="Profile" />
            <AvatarFallback>SW</AvatarFallback>
          </Avatar>
          
          <h1 className="text-lg font-bold text-[#5E50A1]">EWAJI</h1>
          
          <button className="p-2 text-[#5E50A1] hover:bg-gray-100 rounded-full">
            <Plus size={24} />
          </button>
        </div>
      </div>

      {/* AI Discovery Stories Bar */}
      <div className="bg-white border-b border-gray-100">
        <div className="h-[100px] px-4 py-3">
          <div className="flex space-x-3 overflow-x-auto pb-2">
            {aiStories.map((story) => (
              <div key={story.id} className="flex-shrink-0 w-20 flex flex-col items-center">
                <div className="relative w-16 h-16 rounded-xl overflow-hidden bg-gray-200">
                  <img src={story.image} alt={story.name} className="w-full h-full object-cover" />
                  <div className="absolute bottom-1 right-1 w-4 h-4 bg-[#AFBCEB] rounded-full flex items-center justify-center">
                    <span className="text-[8px] font-bold text-[#1C1C1E]">AI</span>
                  </div>
                </div>
                <span className="text-xs text-center mt-1 text-gray-700 truncate w-full">{story.name}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Feed Content */}
      <div className="pb-20">
        {posts.length > 0 ? (
          <div className="pt-4">
            {posts.map((post) => renderFeedCard(post))}
          </div>
        ) : (
          /* Empty State */
          <div className="flex flex-col items-center justify-center min-h-[60vh] px-6">
            <div className="w-16 h-16 border-2 border-[#AFBCEB] rounded-full flex items-center justify-center mb-4">
              <Camera size={32} className="text-[#AFBCEB]" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-2">Share your first look</h3>
            <p className="text-gray-600 text-center mb-6">
              Upload photos or videos to showcase your work.
            </p>
            <Button className="bg-[#5E50A1] hover:bg-[#4F4391] text-white">
              Add Post
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default HomeTab;
