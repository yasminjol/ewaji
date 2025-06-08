
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

  const aiSuggestions = [
    { id: 101, image: "/placeholder.svg", name: "Soft Glam", trending: true },
    { id: 102, image: "/placeholder.svg", name: "Natural Curls", trending: false },
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

  const renderFeedCard = (post: any, index: number) => (
    <div key={post.id} className="bg-white mb-4">
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

      {/* Footer Actions */}
      <div className="p-3 space-y-2">
        <div className="flex items-center justify-between">
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

  const renderAISuggestionCard = (suggestion: any, index: number) => (
    <div key={`ai-${suggestion.id}`} className="bg-white mb-4">
      {/* Card Header */}
      <div className="flex items-center justify-between p-3">
        <div className="flex items-center space-x-2">
          <div className="w-6 h-6 bg-gradient-to-r from-[#5E50A1] to-[#AFBCEB] rounded-full flex items-center justify-center">
            <span className="text-white text-xs font-bold">AI</span>
          </div>
          <span className="font-semibold text-sm text-[#5E50A1]">AI Style Radar</span>
        </div>
      </div>

      {/* Media */}
      <div className="px-3">
        <div className="w-full aspect-square bg-gray-200 rounded-xl overflow-hidden">
          <img src={suggestion.image} alt={suggestion.name} className="w-full h-full object-cover" />
        </div>
      </div>

      {/* Footer */}
      <div className="p-3 space-y-3">
        <div>
          <h3 className="font-semibold text-gray-900">{suggestion.name}</h3>
          <p className="text-sm text-gray-600">Trending style in your area</p>
        </div>
        <Button className="w-full bg-[#5E50A1] hover:bg-[#4F4391] text-white h-9">
          <Plus size={16} className="mr-1" />
          Add Service
        </Button>
      </div>
    </div>
  );

  // Combine posts with AI suggestions every 5th post
  const feedItems = [];
  let aiIndex = 0;
  
  posts.forEach((post, index) => {
    feedItems.push({ type: 'post', data: post, index });
    if ((index + 1) % 5 === 0 && aiIndex < aiSuggestions.length) {
      feedItems.push({ type: 'ai', data: aiSuggestions[aiIndex], index: aiIndex });
      aiIndex++;
    }
  });

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Top App Bar */}
      <div className="bg-white px-4 py-3 shadow-sm sticky top-0 z-10">
        <div className="flex items-center justify-between">
          <Avatar className="w-8 h-8">
            <AvatarImage src="/placeholder.svg" alt="Profile" />
            <AvatarFallback>SW</AvatarFallback>
          </Avatar>
          
          <h1 className="text-xl font-bold text-[#5E50A1]">EWAJI</h1>
          
          <button className="p-2 text-[#5E50A1] hover:bg-gray-100 rounded-full">
            <Plus size={24} />
          </button>
        </div>
      </div>

      {/* Feed Content */}
      <div className="pb-20">
        {feedItems.length > 0 ? (
          <div className="space-y-0">
            {feedItems.map((item, index) => 
              item.type === 'post' 
                ? renderFeedCard(item.data, item.index)
                : renderAISuggestionCard(item.data, item.index)
            )}
          </div>
        ) : (
          /* Empty State */
          <div className="flex flex-col items-center justify-center min-h-[60vh] px-6">
            <div className="w-16 h-16 bg-[#AFBCEB] rounded-full flex items-center justify-center mb-4">
              <Camera size={32} className="text-white" />
            </div>
            <h3 className="text-xl font-semibold text-gray-900 mb-2">Share your first look</h3>
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
