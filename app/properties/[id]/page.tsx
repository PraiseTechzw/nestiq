"use client"

import { useState } from "react"
import Link from "next/link"
import { ArrowLeft, Building, Check, Heart, MapPin, MessageSquare, Share, Star, Wifi } from "lucide-react"

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Separator } from "@/components/ui/separator"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Textarea } from "@/components/ui/textarea"

export default function PropertyDetailPage({ params }: { params: { id: string } }) {
  const [saved, setSaved] = useState(false)

  // Mock property data
  const property = {
    id: params.id,
    title: `Student Apartment ${params.id}`,
    location: "123 University Avenue, Near Campus",
    price: 600,
    roomTypes: [
      { type: "Single Room", price: 600, available: 2 },
      { type: "Shared Room (2 People)", price: 450, available: 3 },
      { type: "Shared Room (3 People)", price: 350, available: 1 },
    ],
    amenities: [
      { name: "WiFi", icon: Wifi },
      { name: "Furnished", icon: Check },
      { name: "Kitchen", icon: Building },
      { name: "Laundry", icon: Check },
      { name: "Security", icon: Check },
    ],
    description:
      "This modern student apartment offers comfortable living spaces perfect for students. Located just minutes from the university campus, it provides convenient access to academic buildings, libraries, and student facilities. The property features a range of amenities designed to enhance student life and create a conducive environment for both studying and relaxation.",
    features: [
      "24/7 security and surveillance",
      "High-speed internet throughout the building",
      "Fully furnished rooms with study desks",
      "Communal kitchen with modern appliances",
      "Laundry facilities on each floor",
      "Common study areas and lounges",
      "Bicycle storage",
      "Close proximity to public transportation",
    ],
    landlord: {
      name: "John Smith",
      rating: 4.8,
      responseTime: "Usually responds within 2 hours",
      image: "/placeholder.svg?height=50&width=50&text=JS",
    },
    reviews: [
      {
        id: 1,
        user: "Sarah L.",
        rating: 5,
        date: "February 15, 2025",
        comment: "Great location and amenities. The landlord was very responsive and helpful throughout my stay.",
        image: "/placeholder.svg?height=40&width=40&text=SL",
      },
      {
        id: 2,
        user: "Michael T.",
        rating: 4,
        date: "January 28, 2025",
        comment:
          "Clean and comfortable accommodation. Good value for the price. The WiFi could be a bit faster during peak hours.",
        image: "/placeholder.svg?height=40&width=40&text=MT",
      },
      {
        id: 3,
        user: "Jessica K.",
        rating: 5,
        date: "December 10, 2024",
        comment:
          "I've lived here for a semester and it's been a great experience. The location is perfect for students.",
        image: "/placeholder.svg?height=40&width=40&text=JK",
      },
    ],
    images: Array.from({ length: 6 }).map(
      (_, i) => `/placeholder.svg?height=300&width=500&text=Property Image ${i + 1}`,
    ),
  }

  const [selectedRoomType, setSelectedRoomType] = useState(property.roomTypes[0].type)

  return (
    <div className="min-h-screen bg-background">
      {/* Property Images */}
      <div className="bg-muted">
        <div className="container mx-auto px-4 py-6">
          <div className="flex items-center mb-4">
            <Button variant="ghost" size="sm" asChild className="mr-auto">
              <Link href="/properties">
                <ArrowLeft className="h-4 w-4 mr-2" />
                Back to Properties
              </Link>
            </Button>
            <Button variant="outline" size="sm" onClick={() => setSaved(!saved)}>
              <Heart className={`h-4 w-4 mr-2 ${saved ? "fill-primary text-primary" : ""}`} />
              {saved ? "Saved" : "Save"}
            </Button>
            <Button variant="outline" size="sm" className="ml-2">
              <Share className="h-4 w-4 mr-2" />
              Share
            </Button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div className="md:col-span-2">
              <img
                src={property.images[0] || "/placeholder.svg"}
                alt={property.title}
                className="w-full h-[400px] object-cover rounded-lg"
              />
            </div>
            <div className="hidden md:grid grid-cols-2 gap-4">
              {property.images.slice(1, 5).map((image, i) => (
                <img
                  key={i}
                  src={image || "/placeholder.svg"}
                  alt={`${property.title} - Image ${i + 2}`}
                  className="w-full h-[192px] object-cover rounded-lg"
                />
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Property Details */}
      <main className="container mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Left Column - Property Info */}
          <div className="lg:col-span-2">
            <div className="flex flex-col gap-6">
              <div>
                <div className="flex items-start justify-between">
                  <div>
                    <h1 className="text-3xl font-bold">{property.title}</h1>
                    <div className="flex items-center mt-2 text-muted-foreground">
                      <MapPin className="h-4 w-4 mr-1" />
                      <span>{property.location}</span>
                    </div>
                  </div>
                  <div className="bg-primary/10 text-primary px-3 py-1 rounded-full text-sm font-medium">Verified</div>
                </div>

                <div className="flex flex-wrap gap-2 mt-4">
                  {property.amenities.map((amenity) => (
                    <div key={amenity.name} className="flex items-center bg-muted px-3 py-1 rounded-full text-sm">
                      <amenity.icon className="h-3 w-3 mr-1" />
                      {amenity.name}
                    </div>
                  ))}
                </div>
              </div>

              <Separator />

              <Tabs defaultValue="details">
                <TabsList className="grid w-full grid-cols-4">
                  <TabsTrigger value="details">Details</TabsTrigger>
                  <TabsTrigger value="features">Features</TabsTrigger>
                  <TabsTrigger value="location">Location</TabsTrigger>
                  <TabsTrigger value="reviews">Reviews</TabsTrigger>
                </TabsList>

                <TabsContent value="details" className="mt-6">
                  <div className="space-y-4">
                    <h3 className="text-xl font-semibold">About this property</h3>
                    <p className="text-muted-foreground">{property.description}</p>

                    <h3 className="text-xl font-semibold mt-6">Room Types & Pricing</h3>
                    <div className="space-y-4">
                      {property.roomTypes.map((room) => (
                        <Card key={room.type}>
                          <CardHeader className="p-4 pb-2">
                            <CardTitle className="text-lg">{room.type}</CardTitle>
                            <CardDescription>{room.available} available</CardDescription>
                          </CardHeader>
                          <CardContent className="p-4 pt-0 pb-2">
                            <div className="flex justify-between">
                              <span className="font-bold text-lg">${room.price}/month</span>
                            </div>
                          </CardContent>
                          <CardFooter className="p-4 pt-2">
                            <Dialog>
                              <DialogTrigger asChild>
                                <Button className="w-full">Book Viewing</Button>
                              </DialogTrigger>
                              <DialogContent>
                                <DialogHeader>
                                  <DialogTitle>Schedule a Viewing</DialogTitle>
                                  <DialogDescription>
                                    Select your preferred date and time to view this property.
                                  </DialogDescription>
                                </DialogHeader>
                                <div className="grid gap-4 py-4">
                                  <div className="space-y-2">
                                    <Label htmlFor="room-type">Room Type</Label>
                                    <Input id="room-type" value={room.type} readOnly />
                                  </div>
                                  <div className="space-y-2">
                                    <Label htmlFor="date">Preferred Date</Label>
                                    <Input id="date" type="date" />
                                  </div>
                                  <div className="space-y-2">
                                    <Label htmlFor="time">Preferred Time</Label>
                                    <RadioGroup defaultValue="morning">
                                      <div className="flex items-center space-x-2">
                                        <RadioGroupItem value="morning" id="morning" />
                                        <Label htmlFor="morning">Morning (9AM - 12PM)</Label>
                                      </div>
                                      <div className="flex items-center space-x-2">
                                        <RadioGroupItem value="afternoon" id="afternoon" />
                                        <Label htmlFor="afternoon">Afternoon (1PM - 5PM)</Label>
                                      </div>
                                      <div className="flex items-center space-x-2">
                                        <RadioGroupItem value="evening" id="evening" />
                                        <Label htmlFor="evening">Evening (6PM - 8PM)</Label>
                                      </div>
                                    </RadioGroup>
                                  </div>
                                  <div className="space-y-2">
                                    <Label htmlFor="notes">Additional Notes (Optional)</Label>
                                    <Textarea id="notes" placeholder="Any specific questions or requirements..." />
                                  </div>
                                </div>
                                <DialogFooter>
                                  <Button type="submit">Request Viewing</Button>
                                </DialogFooter>
                              </DialogContent>
                            </Dialog>
                          </CardFooter>
                        </Card>
                      ))}
                    </div>
                  </div>
                </TabsContent>

                <TabsContent value="features" className="mt-6">
                  <div className="space-y-4">
                    <h3 className="text-xl font-semibold">Property Features</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      {property.features.map((feature, index) => (
                        <div key={index} className="flex items-start">
                          <Check className="h-5 w-5 text-primary mr-2 mt-0.5" />
                          <span>{feature}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </TabsContent>

                <TabsContent value="location" className="mt-6">
                  <div className="space-y-4">
                    <h3 className="text-xl font-semibold">Location</h3>
                    <div className="aspect-video bg-muted rounded-lg flex items-center justify-center">
                      <MapPin className="h-8 w-8 text-muted-foreground" />
                      <span className="ml-2 text-muted-foreground">Map will be displayed here</span>
                    </div>

                    <div className="mt-4">
                      <h4 className="font-medium mb-2">Nearby</h4>
                      <ul className="space-y-2">
                        <li className="flex items-center">
                          <Building className="h-4 w-4 mr-2 text-muted-foreground" />
                          <span>University Campus - 5 min walk</span>
                        </li>
                        <li className="flex items-center">
                          <Building className="h-4 w-4 mr-2 text-muted-foreground" />
                          <span>Grocery Store - 7 min walk</span>
                        </li>
                        <li className="flex items-center">
                          <Building className="h-4 w-4 mr-2 text-muted-foreground" />
                          <span>Bus Stop - 3 min walk</span>
                        </li>
                        <li className="flex items-center">
                          <Building className="h-4 w-4 mr-2 text-muted-foreground" />
                          <span>Student Center - 10 min walk</span>
                        </li>
                      </ul>
                    </div>
                  </div>
                </TabsContent>

                <TabsContent value="reviews" className="mt-6">
                  <div className="space-y-6">
                    <div className="flex items-center justify-between">
                      <h3 className="text-xl font-semibold">Reviews</h3>
                      <div className="flex items-center">
                        <Star className="h-5 w-5 text-yellow-500 mr-1" />
                        <span className="font-bold">4.7</span>
                        <span className="text-muted-foreground ml-1">({property.reviews.length} reviews)</span>
                      </div>
                    </div>

                    <div className="space-y-6">
                      {property.reviews.map((review) => (
                        <div key={review.id} className="border-b pb-6 last:border-0">
                          <div className="flex items-start">
                            <Avatar className="h-10 w-10">
                              <AvatarImage src={review.image} alt={review.user} />
                              <AvatarFallback>{review.user.split(" ")[0][0]}</AvatarFallback>
                            </Avatar>
                            <div className="ml-4">
                              <div className="flex items-center">
                                <h4 className="font-medium">{review.user}</h4>
                                <span className="text-muted-foreground text-sm ml-2">{review.date}</span>
                              </div>
                              <div className="flex items-center mt-1">
                                {Array.from({ length: 5 }).map((_, i) => (
                                  <Star
                                    key={i}
                                    className={`h-4 w-4 ${i < review.rating ? "text-yellow-500 fill-yellow-500" : "text-muted"}`}
                                  />
                                ))}
                              </div>
                              <p className="mt-2 text-muted-foreground">{review.comment}</p>
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </TabsContent>
              </Tabs>
            </div>
          </div>

          {/* Right Column - Contact & Booking */}
          <div>
            <div className="sticky top-6">
              <Card>
                <CardHeader>
                  <CardTitle>Book a Viewing</CardTitle>
                  <CardDescription>Select room type and schedule a visit</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="space-y-2">
                    <Label htmlFor="room-type-select">Room Type</Label>
                    <RadioGroup value={selectedRoomType} onValueChange={setSelectedRoomType}>
                      {property.roomTypes.map((room) => (
                        <div
                          key={room.type}
                          className="flex items-center justify-between space-x-2 border p-3 rounded-md"
                        >
                          <div className="flex items-center space-x-2">
                            <RadioGroupItem value={room.type} id={room.type} />
                            <Label htmlFor={room.type} className="font-normal">
                              {room.type}
                            </Label>
                          </div>
                          <span className="font-bold">${room.price}</span>
                        </div>
                      ))}
                    </RadioGroup>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="date">Select Date</Label>
                    <Input id="date" type="date" />
                  </div>

                  <div className="pt-4">
                    <Button className="w-full">Schedule Viewing</Button>
                    <Button variant="outline" className="w-full mt-2">
                      <MessageSquare className="h-4 w-4 mr-2" />
                      Message Landlord
                    </Button>
                  </div>
                </CardContent>
                <CardFooter className="flex flex-col items-start">
                  <div className="flex items-center mb-2">
                    <Avatar className="h-10 w-10">
                      <AvatarImage src={property.landlord.image} alt={property.landlord.name} />
                      <AvatarFallback>{property.landlord.name.split(" ")[0][0]}</AvatarFallback>
                    </Avatar>
                    <div className="ml-3">
                      <p className="text-sm font-medium">{property.landlord.name}</p>
                      <div className="flex items-center">
                        <Star className="h-3 w-3 text-yellow-500 mr-1" />
                        <span className="text-xs">{property.landlord.rating}</span>
                      </div>
                    </div>
                  </div>
                  <p className="text-xs text-muted-foreground">{property.landlord.responseTime}</p>
                </CardFooter>
              </Card>

              <Card className="mt-6">
                <CardHeader>
                  <CardTitle>Similar Properties</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  {[1, 2].map((i) => (
                    <div key={i} className="flex gap-3">
                      <img
                        src={`/placeholder.svg?height=80&width=80&text=Similar ${i}`}
                        alt={`Similar Property ${i}`}
                        className="w-20 h-20 object-cover rounded"
                      />
                      <div>
                        <h4 className="font-medium text-sm">Student Apartment {Number(property.id) + i}</h4>
                        <p className="text-xs text-muted-foreground">Near University Campus</p>
                        <p className="text-sm font-bold mt-1">${Number(property.price) - i * 50}/month</p>
                      </div>
                    </div>
                  ))}
                </CardContent>
                <CardFooter>
                  <Button variant="outline" size="sm" className="w-full" asChild>
                    <Link href="/properties">View More Properties</Link>
                  </Button>
                </CardFooter>
              </Card>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}

