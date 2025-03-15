"use client"

import { useState } from "react"
import { FileText, Search } from "lucide-react"

import { DashboardLayout } from "@/components/dashboard-layout"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { useToast } from "@/hooks/use-toast"

// Mock verification requests
const verificationRequests = [
  {
    id: 1,
    type: "landlord",
    user: {
      name: "John Smith",
      email: "john.smith@example.com",
      phone: "+1 (555) 123-4567",
      avatar: "/placeholder.svg?height=40&width=40&text=JS",
      joinedDate: "March 10, 2025",
    },
    documents: [
      { name: "ID Verification", type: "id", url: "#" },
      { name: "Business License", type: "license", url: "#" },
    ],
    status: "pending",
    submittedDate: "March 12, 2025",
  },
  {
    id: 2,
    type: "property",
    user: {
      name: "Emma Wilson",
      email: "emma.wilson@example.com",
      phone: "+1 (555) 987-6543",
      avatar: "/placeholder.svg?height=40&width=40&text=EW",
      joinedDate: "February 28, 2025",
    },
    property: {
      title: "Student Apartment 1",
      address: "123 University Avenue",
      type: "Apartment",
      images: [
        "/placeholder.svg?height=200&width=400&text=Property 1",
        "/placeholder.svg?height=200&width=400&text=Property 1-2",
      ],
    },
    documents: [
      { name: "Property Deed", type: "deed", url: "#" },
      { name: "Tax Document", type: "tax", url: "#" },
    ],
    status: "pending",
    submittedDate: "March 11, 2025",
  },
  {
    id: 3,
    type: "landlord",
    user: {
      name: "Michael Brown",
      email: "michael.brown@example.com",
      phone: "+1 (555) 456-7890",
      avatar: "/placeholder.svg?height=40&width=40&text=MB",
      joinedDate: "March 5, 2025",
    },
    documents: [
      { name: "ID Verification", type: "id", url: "#" },
      { name: "Proof of Address", type: "address", url: "#" },
    ],
    status: "pending",
    submittedDate: "March 9, 2025",
  },
  {
    id: 4,
    type: "property",
    user: {
      name: "Sarah Johnson",
      email: "sarah.johnson@example.com",
      phone: "+1 (555) 789-0123",
      avatar: "/placeholder.svg?height=40&width=40&text=SJ",
      joinedDate: "February 20, 2025",
    },
    property: {
      title: "Student Apartment 2",
      address: "456 College Street",
      type: "House",
      images: [
        "/placeholder.svg?height=200&width=400&text=Property 2",
        "/placeholder.svg?height=200&width=400&text=Property 2-2",
      ],
    },
    documents: [
      { name: "Property Deed", type: "deed", url: "#" },
      { name: "Insurance Document", type: "insurance", url: "#" },
    ],
    status: "pending",
    submittedDate: "March 8, 2025",
  },
  {
    id: 5,
    type: "landlord",
    user: {
      name: "David Lee",
      email: "david.lee@example.com",
      phone: "+1 (555) 234-5678",
      avatar: "/placeholder.svg?height=40&width=40&text=DL",
      joinedDate: "March 1, 2025",
    },
    documents: [
      { name: "ID Verification", type: "id", url: "#" },
      { name: "Business Registration", type: "business", url: "#" },
    ],
    status: "pending",
    submittedDate: "March 7, 2025",
  },
]

export default function VerificationPage() {
  const { toast } = useToast()
  const [selectedRequest, setSelectedRequest] = useState<any>(null)
  const [viewDocument, setViewDocument] = useState<any>(null)
  const [isProcessing, setIsProcessing] = useState(false)
  const [filter, setFilter] = useState("all")
  const [searchQuery, setSearchQuery] = useState("")
  
  const filteredRequests = verificationRequests.filter((request) => {
    if (filter !== "all" && request.type !== filter) return false
    
    if (searchQuery) {
      const query = searchQuery.toLowerCase()
      return (
        request.user.name.toLowerCase().includes(query) ||
        (request.type === "property" && request.property.title.toLowerCase().includes(query))
      )
    }
    
    return true
  })
  
  const handleApprove = () => {
    setIsProcessing(true)
    
    // Simulate API call
    setTimeout(() => {
      setIsProcessing(false)
      setSelectedRequest(null)
      
      toast({
        title: "Verification approved",
        description: `The ${selectedRequest.type} verification has been approved.`,
      })
    }, 1500)
  }
  
  const handleReject = () => {
    setIsProcessing(true)
    
    // Simulate API call
    setTimeout(() => {
      setIsProcessing(false)
      setSelectedRequest(null)
      
      toast({
        title: "Verification rejected",
        description: `The ${selectedRequest.type} verification has been rejected.`,
      })
    }, 1500)
  }
  
  return (
    <DashboardLayout role="admin">
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Verification Requests</h1>
          <p className="text-muted-foreground">
            Review and process verification requests from landlords and properties
          </p>
        </div>
        
        <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
          <div className="w-full md:w-auto">
            <Tabs defaultValue="all" className="w-full" onValueChange={setFilter}>
              <TabsList className="grid w-full grid-cols-3">
                <TabsTrigger value="all">All Requests</TabsTrigger>
                <TabsTrigger value="landlord">Landlords</TabsTrigger>
                <TabsTrigger value="property">Properties</TabsTrigger>
              </TabsList>
            </Tabs>
          </div>
          
          <div className="w-full md:w-auto relative">
            <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Search requests..."
              className="pl-8 w-full md:w-[300px]"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
        </div>
        
        <div className="grid gap-4">
          {filteredRequests.length > 0 ? (
            filteredRequests.map((request) => (
              <Card key={request.id} className="overflow-hidden">
                <CardContent className="p-0">
                  <div className="flex flex-col md:flex-row">
                    <div className="p-6 flex-1">
                      <div className="flex items-start gap-4">
                        <Avatar className="h-10 w-10">
                          <AvatarImage src={request.user.avatar} alt={request.user.name} />
                          <AvatarFallback>{request.user.name.charAt(0)}</AvatarFallback>
                        </Avatar>
                        <div className="flex-1">
                          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                            <div>
                              <h3 className="font-medium">{request.user.name}</h3>
                              <p className="text-sm text-muted-foreground">{request.user.email}</p>
                            </div>
                            <div className="flex items-center">
                              <span className="text-xs bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full">
                                {request.type === "landlord" ? "Landlord Verification" : "Property Verification"}
                              </span>
                            </div>
                          </div>
                          
                          {request.type === "property" && (
                            <div className="mt-4">
                              <h4 className="text-sm font-medium">{request.property.title}</h4>
                              <p className="text-sm text-muted-foreground">{request.property.address}</p>
                            </div>
                          )}
                          
                          <div className="mt-4">
                            <h4 className="text-sm font-medium">Documents</h4>
                            <div className="flex flex-wrap gap-2 mt-2">
                              {request.documents.map((doc, index) => (
                                <Button 
                                  key={index} 
                                  variant="outline" 
                                  size="sm"
                                  className="text-xs"
                                  onClick={() => setViewDocument(doc)}
                                >
                                  <FileText className="h-3 w-3 mr-1" />
                                  {doc.name}
                                </Button>
                              ))}
                            </div>
                          </div>
                          
                          <div className="mt-4 text-xs text-muted-foreground">
                            Submitted on {request.submittedDate}
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    {request.type === "property" && (
                      <div className="md:w-[200px] bg-muted p-4 flex flex-row md:flex-col gap-2 overflow-x-auto md:overflow-y-auto">
                        {request.property.images.map((image, index) => (
                          <img 
                            key={index}
                            src={image || "/placeholder.svg"} 
                            alt={`Property image ${index + 1}`}
                            className="w-[150px] h-[100px] md:w-full md:h-auto object-cover rounded"
                          />
                \

