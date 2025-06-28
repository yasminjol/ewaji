
import { useState } from "react";
import { Search, ArrowLeft, Send, Paperclip, Camera } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";

const ClientInboxScreen = () => {
  const [selectedChat, setSelectedChat] = useState<number | null>(null);
  const [message, setMessage] = useState("");

  const chats = [
    {
      id: 1,
      provider: {
        name: "Sophia's Hair Studio",
        avatar: "https://images.unsplash.com/photo-1494790108755-2616c5e68b05?w=50&h=50&fit=crop&crop=face"
      },
      lastMessage: "Your appointment is confirmed for tomorrow at 2 PM!",
      timestamp: "2m ago",
      unread: true
    },
    {
      id: 2,
      provider: {
        name: "Glamour Nails",
        avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=50&h=50&fit=crop&crop=face"
      },
      lastMessage: "Thank you for choosing our service! 💅",
      timestamp: "1h ago",
      unread: false
    },
    {
      id: 3,
      provider: {
        name: "Bella Beauty",
        avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop&crop=face"
      },
      lastMessage: "How was your facial treatment experience?",
      timestamp: "2d ago",
      unread: false
    }
  ];

  const chatMessages = [
    { id: 1, text: "Hi! I'd like to book an appointment for tomorrow.", sender: "client", timestamp: "10:30 AM" },
    { id: 2, text: "Hello! I have availability at 2 PM tomorrow. Would that work for you?", sender: "provider", timestamp: "10:32 AM" },
    { id: 3, text: "Perfect! That works great for me.", sender: "client", timestamp: "10:33 AM" },
    { id: 4, text: "Wonderful! Your appointment is confirmed for tomorrow at 2 PM. Looking forward to seeing you! ✨", sender: "provider", timestamp: "10:35 AM" }
  ];

  const handleSendMessage = () => {
    if (message.trim()) {
      // Handle send message logic
      setMessage("");
    }
  };

  if (selectedChat) {
    const chat = chats.find(c => c.id === selectedChat);
    
    return (
      <div className="bg-white min-h-screen flex flex-col">
        {/* Chat Header */}
        <div className="flex items-center p-4 border-b border-gray-100">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setSelectedChat(null)}
            className="mr-3"
          >
            <ArrowLeft size={20} className="text-[#5E50A1]" />
          </Button>
          <img 
            src={chat?.provider.avatar} 
            alt={chat?.provider.name}
            className="w-10 h-10 rounded-full object-cover"
          />
          <div className="ml-3">
            <h2 className="font-semibold text-[#1C1C1E]">{chat?.provider.name}</h2>
            <p className="text-xs text-[#6E6E73]">Online</p>
          </div>
        </div>

        {/* Messages */}
        <div className="flex-1 p-4 space-y-4 overflow-y-auto">
          {chatMessages.map((msg) => (
            <div key={msg.id} className={`flex ${msg.sender === 'client' ? 'justify-end' : 'justify-start'}`}>
              <div className={`max-w-xs lg:max-w-md px-4 py-2 rounded-2xl ${
                msg.sender === 'client' 
                  ? 'bg-[#5E50A1] text-white' 
                  : 'bg-gray-100 text-[#1C1C1E]'
              }`}>
                <p className="text-sm">{msg.text}</p>
                <p className={`text-xs mt-1 ${
                  msg.sender === 'client' ? 'text-white/70' : 'text-[#6E6E73]'
                }`}>
                  {msg.timestamp}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Message Input */}
        <div className="p-4 border-t border-gray-100">
          <div className="flex items-center space-x-2">
            <Button variant="ghost" size="icon" className="text-[#6E6E73]">
              <Paperclip size={20} />
            </Button>
            <Button variant="ghost" size="icon" className="text-[#6E6E73]">
              <Camera size={20} />
            </Button>
            <Input
              type="text"
              placeholder="Type a message..."
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
              className="flex-1 rounded-full border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
            />
            <Button
              onClick={handleSendMessage}
              size="icon"
              className="bg-[#5E50A1] hover:bg-[#4F4391] text-white rounded-full"
            >
              <Send size={16} />
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white min-h-screen">
      {/* Header */}
      <div className="p-4 border-b border-gray-100">
        <h1 className="text-2xl font-bold text-[#1C1C1E] text-center mb-4">Messages</h1>
        <div className="relative">
          <Search size={20} className="absolute left-3 top-1/2 transform -translate-y-1/2 text-[#6E6E73]" />
          <Input
            type="text"
            placeholder="Search messages..."
            className="pl-10 h-10 rounded-xl border-gray-200 focus:border-[#5E50A1] focus:ring-[#5E50A1]"
          />
        </div>
      </div>

      {/* Chat List */}
      <div className="divide-y divide-gray-100">
        {chats.map((chat) => (
          <button
            key={chat.id}
            onClick={() => setSelectedChat(chat.id)}
            className="w-full p-4 flex items-center hover:bg-gray-50 transition-colors text-left"
          >
            <img 
              src={chat.provider.avatar} 
              alt={chat.provider.name}
              className="w-12 h-12 rounded-full object-cover"
            />
            <div className="ml-3 flex-1 min-w-0">
              <div className="flex items-center justify-between mb-1">
                <h3 className="font-medium text-[#1C1C1E] truncate">{chat.provider.name}</h3>
                <span className="text-xs text-[#6E6E73]">{chat.timestamp}</span>
              </div>
              <p className="text-sm text-[#6E6E73] truncate">{chat.lastMessage}</p>
            </div>
            {chat.unread && (
              <div className="w-3 h-3 bg-[#5E50A1] rounded-full ml-2"></div>
            )}
          </button>
        ))}
      </div>

      {chats.length === 0 && (
        <div className="text-center py-12">
          <Search size={48} className="mx-auto text-[#AFBCEB] mb-4" />
          <h3 className="text-lg font-medium text-[#1C1C1E] mb-2">No messages yet</h3>
          <p className="text-[#6E6E73]">Start conversations with your beauty providers.</p>
        </div>
      )}
    </div>
  );
};

export default ClientInboxScreen;
