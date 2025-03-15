"use client"

import { useState } from "react"
import { PaperclipIcon as PaperClip, Search, Send, User } from "lucide-react"

import { DashboardLayout } from "@/components/dashboard-layout"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Separator } from "@/components/ui/separator"

// Mock conversation data
const conversations = [
  {
    id: 1,
    user: {
      name: "John Smith",
      role: "Landlord",
      avatar: "/placeholder.svg?height=40&width=40&text=JS",
      online: true,
    },
    lastMessage: {
      text: "Yes, the property is still available for viewing. When would you like to schedule a visit?",
      time: "10:30 AM",
      isRead: true,
    },
    unread: 0,
  },
  {
    id: 2,
    user: {
      name: "Emma Wilson",
      role: "Landlord",
      avatar: "/placeholder.svg?height=40&width=40&text=EW",
      online: false,
    },
    lastMessage: {
      text: "I've just uploaded new photos of the apartment. Let me know what you think!",
      time: "Yesterday",
      isRead: false,
    },
    unread: 2,
  },
  {
    id: 3,
    user: {
      name: "Michael Brown",
      role: "Landlord",
      avatar: "/placeholder.svg?height=40&width=40&text=MB",
      online: false,
    },
    lastMessage: {
      text: "The room comes fully furnished with a bed, desk, chair, and wardrobe.",
      time: "Yesterday",
      isRead: true,
    },
    unread: 0,
  },
  {
    id: 4,
    user: {
      name: "Sarah Johnson",
      role: "Landlord",
      avatar: "/placeholder.svg?height=40&width=40&text=SJ",
      online: true,
    },
    lastMessage: {
      text: "Great! I'll confirm your viewing for tomorrow at 3 PM. Looking forward to meeting you.",
      time: "Monday",
      isRead: true,
    },
    unread: 0,
  },
  {
    id: 5,
    user: {
      name: "David Lee",
      role: "Landlord",
      avatar: "/placeholder.svg?height=40&width=40&text=DL",
      online: false,
    },
    lastMessage: {
      text: "The apartment is a 10-minute walk from the university campus.",
      time: "Last week",
      isRead: true,
    },
    unread: 0,
  },
]

// Mock messages for the active conversation
const mockMessages = [
  {
    id: 1,
    sender: "user",
    text: "Hello, I'm interested in your student apartment listing. Is it still available?",
    time: "10:15 AM",
    status: "read",
  },
  {
    id: 2,
    sender: "other",
    text: "Hi there! Yes, the apartment is still available. Are you looking for the single room or shared accommodation?",
    time: "10:20 AM",
    status: "read",
  },
  {
    id: 3,
    sender: "user",
    text: "I'm interested in the single room. Could you tell me more about the amenities included?",
    time: "10:22 AM",
    status: "read",
  },
  {
    id: 4,
    sender: "other",
    text: "Of course! The single room comes with a comfortable bed, study desk, chair, and wardrobe. The apartment has shared kitchen and bathroom facilities. We also provide high-speed WiFi, laundry facilities, and 24/7 security.",
    time: "10:25 AM",
    status: "read",
  },
  {
    id: 5,
    sender: "user",
    text: "That sounds great. Is it possible to schedule a viewing of the property?",
    time: "10:28 AM",
    status: "read",
  },
  {
    id: 6,
    sender: "other",
    text: "Yes, the property is still available for viewing. When would you like to schedule a visit?",
    time: "10:30 AM",
    status: "read",
  },
]

export default function MessagesPage() {
  const [activeConversation, setActiveConversation] = useState(conversations[0])
  const [messages, setMessages] = useState(mockMessages)
  const [newMessage, setNewMessage] = useState("")

  const handleSendMessage = () => {
    if (!newMessage.trim()) return

    const message = {
      id: messages.length + 1,
      sender: "user",
      text: newMessage,
      time: "Just now",
      status: "sent",
    }

    setMessages([...messages, message])
    setNewMessage("")
  }

  return (
    <DashboardLayout role="student">
      <div className="flex flex-col h-[calc(100vh-9rem)]">
        <div className="mb-4">
          <h1 className="text-2xl font-bold">Messages</h1>
          <p className="text-muted-foreground">Communicate with landlords and property managers</p>
        </div>

        <div className="flex flex-1 overflow-hidden border rounded-lg">
          {/* Conversation List */}
          <div className="w-full md:w-1/3 border-r">
            <div className="p-3 border-b">
              <div className="relative">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input placeholder="Search conversations..." className="pl-8" />
              </div>
            </div>

            <ScrollArea className="h-[calc(100vh-14rem)]">
              {conversations.map((conversation) => (
                <div key={conversation.id}>
                  <button
                    className={`w-full text-left p-3 hover:bg-muted transition-colors ${
                      activeConversation.id === conversation.id ? "bg-muted" : ""
                    }`}
                    onClick={() => setActiveConversation(conversation)}
                  >
                    <div className="flex items-start gap-3">
                      <div className="relative">
                        <Avatar>
                          <AvatarImage src={conversation.user.avatar} alt={conversation.user.name} />
                          <AvatarFallback>{conversation.user.name.charAt(0)}</AvatarFallback>
                        </Avatar>
                        {conversation.user.online && (
                          <span className="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-background rounded-full" />
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between">
                          <p className="font-medium truncate">{conversation.user.name}</p>
                          <p className="text-xs text-muted-foreground">{conversation.lastMessage.time}</p>
                        </div>
                        <p className="text-sm text-muted-foreground truncate">{conversation.lastMessage.text}</p>
                      </div>
                      {conversation.unread > 0 && (
                        <div className="flex-shrink-0 w-5 h-5 bg-primary text-primary-foreground rounded-full flex items-center justify-center text-xs">
                          {conversation.unread}
                        </div>
                      )}
                    </div>
                  </button>
                  <Separator />
                </div>
              ))}
            </ScrollArea>
          </div>

          {/* Message Area */}
          <div className="hidden md:flex md:flex-1 flex-col">
            {activeConversation ? (
              <>
                {/* Conversation Header */}
                <div className="p-3 border-b flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <Avatar>
                      <AvatarImage src={activeConversation.user.avatar} alt={activeConversation.user.name} />
                      <AvatarFallback>{activeConversation.user.name.charAt(0)}</AvatarFallback>
                    </Avatar>
                    <div>
                      <p className="font-medium">{activeConversation.user.name}</p>
                      <div className="flex items-center text-sm text-muted-foreground">
                        <span>{activeConversation.user.role}</span>
                        {activeConversation.user.online && (
                          <span className="flex items-center ml-2">
                            <span className="w-2 h-2 bg-green-500 rounded-full mr-1"></span>
                            Online
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                  <div>
                    <Button variant="outline" size="sm">
                      View Profile
                    </Button>
                  </div>
                </div>

                {/* Messages */}
                <ScrollArea className="flex-1 p-4">
                  <div className="space-y-4">
                    {messages.map((message) => (
                      <div
                        key={message.id}
                        className={`flex ${message.sender === "user" ? "justify-end" : "justify-start"}`}
                      >
                        {message.sender !== "user" && (
                          <Avatar className="h-8 w-8 mr-2 mt-1">
                            <AvatarImage src={activeConversation.user.avatar} alt={activeConversation.user.name} />
                            <AvatarFallback>{activeConversation.user.name.charAt(0)}</AvatarFallback>
                          </Avatar>
                        )}
                        <div>
                          <div
                            className={`max-w-md rounded-lg p-3 ${
                              message.sender === "user" ? "bg-primary text-primary-foreground" : "bg-muted"
                            }`}
                          >
                            <p>{message.text}</p>
                          </div>
                          <div
                            className={`flex items-center mt-1 text-xs text-muted-foreground ${
                              message.sender === "user" ? "justify-end" : "justify-start"
                            }`}
                          >
                            <span>{message.time}</span>
                            {message.sender === "user" && (
                              <span className="ml-1">{message.status === "read" ? "Read" : "Delivered"}</span>
                            )}
                          </div>
                        </div>
                        {message.sender === "user" && (
                          <Avatar className="h-8 w-8 ml-2 mt-1">
                            <AvatarImage src="/placeholder.svg?height=40&width=40&text=ME" alt="Me" />
                            <AvatarFallback>
                              <User className="h-4 w-4" />
                            </AvatarFallback>
                          </Avatar>
                        )}
                      </div>
                    ))}
                  </div>
                </ScrollArea>

                {/* Message Input */}
                <div className="p-3 border-t">
                  <div className="flex items-center gap-2">
                    <Button variant="outline" size="icon" className="rounded-full">
                      <PaperClip className="h-4 w-4" />
                      <span className="sr-only">Attach file</span>
                    </Button>
                    <Input
                      placeholder="Type a message..."
                      value={newMessage}
                      onChange={(e) => setNewMessage(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === "Enter" && !e.shiftKey) {
                          e.preventDefault()
                          handleSendMessage()
                        }
                      }}
                      className="flex-1"
                    />
                    <Button size="icon" className="rounded-full" onClick={handleSendMessage}>
                      <Send className="h-4 w-4" />
                      <span className="sr-only">Send message</span>
                    </Button>
                  </div>
                </div>
              </>
            ) : (
              <div className="flex-1 flex items-center justify-center">
                <div className="text-center">
                  <h3 className="text-lg font-medium">No conversation selected</h3>
                  <p className="text-muted-foreground">Select a conversation from the list to start messaging</p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </DashboardLayout>
  )
}

