
import { useState } from "react";
import { ArrowLeft, MoreHorizontal, Paperclip, Send } from "lucide-react";
import { Button } from "@/components/ui/button";

const InboxTab = () => {
  const [selectedChat, setSelectedChat] = useState<number | null>(null);
  const [newMessage, setNewMessage] = useState("");
  
  const chats = [
    {
      id: 1,
      name: "Maya Johnson",
      avatar: "/placeholder.svg",
      lastMessage: "Thank you so much! The braids look amazing 💕",
      timestamp: "2m",
      unread: 0
    },
    {
      id: 2,
      name: "Zara Williams",
      avatar: "/placeholder.svg",
      lastMessage: "What time should I arrive tomorrow?",
      timestamp: "1h",
      unread: 2
    },
    {
      id: 3,
      name: "Asha Davis",
      avatar: "/placeholder.svg",
      lastMessage: "Could we reschedule for next week?",
      timestamp: "3h",
      unread: 1
    }
  ];

  const messages = [
    {
      id: 1,
      text: "Hi! I'm excited for my appointment tomorrow",
      sender: "client",
      timestamp: "10:30 AM"
    },
    {
      id: 2,
      text: "Hello! I'm excited too! Please arrive 10 minutes early so we can go over the style details",
      sender: "provider",
      timestamp: "10:32 AM"
    },
    {
      id: 3,
      text: "Perfect! What time should I arrive tomorrow?",
      sender: "client",
      timestamp: "1h"
    }
  ];

  const sendMessage = () => {
    if (newMessage.trim()) {
      setNewMessage("");
    }
  };

  if (selectedChat) {
    const chat = chats.find(c => c.id === selectedChat);
    
    return (
      <div className="flex flex-col h-screen">
        {/* Chat Header */}
        <div className="bg-white border-b border-gray-200 p-4 flex items-center space-x-3">
          <button
            onClick={() => setSelectedChat(null)}
            className="p-2 -ml-2 text-gray-600"
          >
            <ArrowLeft size={20} />
          </button>
          <div className="w-10 h-10 bg-gray-200 rounded-full overflow-hidden">
            <img src={chat?.avatar} alt={chat?.name} className="w-full h-full object-cover" />
          </div>
          <div className="flex-1">
            <h3 className="font-semibold text-gray-900">{chat?.name}</h3>
          </div>
          <button className="p-2 text-gray-600">
            <MoreHorizontal size={20} />
          </button>
        </div>

        {/* Messages */}
        <div className="flex-1 p-4 space-y-4 overflow-y-auto">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.sender === 'provider' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-xs px-4 py-2 rounded-2xl ${
                  message.sender === 'provider'
                    ? 'bg-[#5E50A1] text-white'
                    : 'bg-[#E6E5F5] text-gray-900'
                }`}
              >
                <p className="text-sm">{message.text}</p>
                <p className={`text-xs mt-1 ${
                  message.sender === 'provider' ? 'text-white/70' : 'text-gray-500'
                }`}>
                  {message.timestamp}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Input Bar */}
        <div className="bg-white border-t border-gray-200 p-4">
          <div className="flex items-center space-x-3">
            <div className="flex-1 flex items-center bg-gray-100 rounded-full px-4 py-2">
              <input
                type="text"
                value={newMessage}
                onChange={(e) => setNewMessage(e.target.value)}
                placeholder="Type a message..."
                className="flex-1 bg-transparent text-sm outline-none"
                onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
              />
              <button className="p-1 text-gray-500">
                <Paperclip size={16} />
              </button>
            </div>
            <button
              onClick={sendMessage}
              className="w-10 h-10 bg-[#5E50A1] text-white rounded-full flex items-center justify-center"
            >
              <Send size={16} />
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <h1 className="text-2xl font-bold text-gray-900">Inbox</h1>
      
      {/* Chat List */}
      <div className="space-y-2">
        {chats.map((chat) => (
          <button
            key={chat.id}
            onClick={() => setSelectedChat(chat.id)}
            className="w-full bg-white rounded-xl p-4 shadow-sm text-left hover:bg-gray-50 transition-colors"
          >
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gray-200 rounded-full overflow-hidden">
                <img src={chat.avatar} alt={chat.name} className="w-full h-full object-cover" />
              </div>
              <div className="flex-1 min-w-0">
                <h3 className="font-semibold text-gray-900">{chat.name}</h3>
                <p className="text-sm text-gray-600 truncate">{chat.lastMessage}</p>
              </div>
              <div className="flex flex-col items-end space-y-1">
                {chat.unread > 0 && (
                  <span className="bg-[#5E50A1] text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                    {chat.unread}
                  </span>
                )}
                <span className="text-xs text-gray-500">{chat.timestamp}</span>
              </div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
};

export default InboxTab;
