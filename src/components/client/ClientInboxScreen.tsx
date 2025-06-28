
import React from 'react';
import { MessageCircle, Phone, Video } from 'lucide-react';

const ClientInboxScreen = () => {
  const conversations = [
    {
      id: 1,
      provider: {
        name: "Sarah Williams",
        avatar: "/placeholder.svg",
      },
      lastMessage: "Perfect! See you tomorrow at 2 PM ✨",
      timestamp: "2 min ago",
      unread: true,
    },
    {
      id: 2,
      provider: {
        name: "Maya Johnson",
        avatar: "/placeholder.svg",
      },
      lastMessage: "I have availability this weekend for the knotless braids",
      timestamp: "1 hour ago",
      unread: false,
    },
    {
      id: 3,
      provider: {
        name: "Zara Adams",
        avatar: "/placeholder.svg",
      },
      lastMessage: "Thank you for the amazing review! 💕",
      timestamp: "Yesterday",
      unread: false,
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white px-4 py-4 border-b border-gray-200">
        <h1 className="text-xl font-bold text-[#1C1C1E]">Inbox</h1>
      </div>

      {/* Conversations List */}
      <div className="bg-white">
        {conversations.map((conversation) => (
          <button
            key={conversation.id}
            className="w-full px-4 py-4 border-b border-gray-100 hover:bg-gray-50 transition-colors text-left"
          >
            <div className="flex items-center space-x-3">
              <div className="relative">
                <img
                  src={conversation.provider.avatar}
                  alt={conversation.provider.name}
                  className="w-12 h-12 rounded-full object-cover"
                />
                {conversation.unread && (
                  <div className="absolute -top-1 -right-1 w-4 h-4 bg-[#5E50A1] rounded-full"></div>
                )}
              </div>
              
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between mb-1">
                  <h3 className={`font-semibold text-[#1C1C1E] truncate ${
                    conversation.unread ? 'font-bold' : 'font-medium'
                  }`}>
                    {conversation.provider.name}
                  </h3>
                  <span className={`text-xs ${
                    conversation.unread ? 'text-[#5E50A1] font-medium' : 'text-[#6E6E73]'
                  }`}>
                    {conversation.timestamp}
                  </span>
                </div>
                <p className={`text-sm truncate ${
                  conversation.unread ? 'text-[#1C1C1E] font-medium' : 'text-[#6E6E73]'
                }`}>
                  {conversation.lastMessage}
                </p>
              </div>
            </div>
          </button>
        ))}
      </div>

      {/* Empty State */}
      {conversations.length === 0 && (
        <div className="text-center py-12">
          <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <MessageCircle size={24} className="text-gray-400" />
          </div>
          <h3 className="text-lg font-medium text-[#1C1C1E] mb-2">No messages yet</h3>
          <p className="text-[#6E6E73]">Start a conversation with a provider to see your messages here.</p>
        </div>
      )}
    </div>
  );
};

export default ClientInboxScreen;
