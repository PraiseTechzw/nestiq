import Link from "next/link"
import { Building, Calendar, DollarSign, Eye, Plus, Users } from "lucide-react"

import { DashboardLayout } from "@/components/dashboard-layout"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function LandlordDashboard() {
  return (
    <DashboardLayout role="landlord">
      <div className="flex flex-col gap-6">
        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold tracking-tight">Landlord Dashboard</h1>
          <p className="text-muted-foreground">Manage your properties and bookings.</p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Properties</CardTitle>
              <Building className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">8</div>
              <p className="text-xs text-muted-foreground">6 active, 2 pending verification</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Active Viewings</CardTitle>
              <Calendar className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">12</div>
              <p className="text-xs text-muted-foreground">+3 new requests this week</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">$4,250</div>
              <p className="text-xs text-muted-foreground">+$750 from last month</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Property Views</CardTitle>
              <Eye className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">1,024</div>
              <p className="text-xs text-muted-foreground">+128 from last week</p>
            </CardContent>
          </Card>
        </div>

        <Tabs defaultValue="properties">
          <div className="flex items-center justify-between">
            <TabsList>
              <TabsTrigger value="properties">My Properties</TabsTrigger>
              <TabsTrigger value="bookings">Booking Requests</TabsTrigger>
            </TabsList>
            <Button size="sm" asChild>
              <Link href="/dashboard/landlord/properties/new">
                <Plus className="mr-2 h-4 w-4" />
                Add Property
              </Link>
            </Button>
          </div>

          <TabsContent value="properties" className="mt-4">
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3].map((i) => (
                <Card key={i}>
                  <div className="aspect-video relative">
                    <img
                      src={`/placeholder.svg?height=200&width=400&text=Property ${i}`}
                      alt={`Property ${i}`}
                      className="object-cover w-full h-full rounded-t-lg"
                    />
                    <div className="absolute top-2 right-2 bg-primary text-white text-xs font-medium px-2 py-1 rounded">
                      Active
                    </div>
                  </div>
                  <CardHeader className="p-4 pb-2">
                    <CardTitle className="text-lg">Student Apartment {i}</CardTitle>
                    <CardDescription>Near University Campus</CardDescription>
                  </CardHeader>
                  <CardContent className="p-4 pt-0 pb-2">
                    <div className="flex justify-between text-sm">
                      <span>$600/month</span>
                      <span className="text-muted-foreground">3 rooms available</span>
                    </div>
                    <div className="flex items-center gap-1 mt-2">
                      <Eye className="h-3 w-3 text-muted-foreground" />
                      <span className="text-xs text-muted-foreground">128 views</span>
                      <Users className="h-3 w-3 text-muted-foreground ml-2" />
                      <span className="text-xs text-muted-foreground">5 bookings</span>
                    </div>
                  </CardContent>
                  <CardFooter className="p-4 pt-2 flex gap-2">
                    <Button variant="outline" size="sm" className="flex-1">
                      Edit
                    </Button>
                    <Button size="sm" className="flex-1">
                      Manage
                    </Button>
                  </CardFooter>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="bookings" className="mt-4">
            <Card>
              <CardHeader>
                <CardTitle>Recent Booking Requests</CardTitle>
                <CardDescription>Manage your property viewing requests</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-6">
                  {[1, 2, 3].map((i) => (
                    <div
                      key={i}
                      className="flex flex-col sm:flex-row sm:items-center gap-4 pb-4 border-b last:border-0 last:pb-0"
                    >
                      <Avatar className="hidden sm:flex">
                        <AvatarImage src={`/placeholder.svg?height=40&width=40&text=S${i}`} />
                        <AvatarFallback>S{i}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1 space-y-1">
                        <div className="flex items-center gap-2">
                          <Avatar className="h-6 w-6 sm:hidden">
                            <AvatarImage src={`/placeholder.svg?height=40&width=40&text=S${i}`} />
                            <AvatarFallback>S{i}</AvatarFallback>
                          </Avatar>
                          <p className="text-sm font-medium">Student {i}</p>
                        </div>
                        <p className="text-sm">
                          <span className="font-medium">Property:</span> Student Apartment {i}
                        </p>
                        <p className="text-sm">
                          <span className="font-medium">Date:</span> March {15 + i}, 2025
                        </p>
                        <p className="text-sm">
                          <span className="font-medium">Time:</span> {i + 1}:00 PM - {i + 2}:00 PM
                        </p>
                      </div>
                      <div className="flex gap-2 sm:flex-col md:flex-row">
                        <Button size="sm" variant="outline">
                          Decline
                        </Button>
                        <Button size="sm">Accept</Button>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
              <CardFooter>
                <Button variant="outline" className="w-full" asChild>
                  <Link href="/dashboard/landlord/bookings">View All Bookings</Link>
                </Button>
              </CardFooter>
            </Card>
          </TabsContent>
        </Tabs>

        <div className="grid gap-6 md:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle>Recent Messages</CardTitle>
              <CardDescription>Your latest conversations with students</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="flex items-center gap-4">
                    <Avatar>
                      <AvatarImage src={`/placeholder.svg?height=40&width=40&text=S${i}`} />
                      <AvatarFallback>S{i}</AvatarFallback>
                    </Avatar>
                    <div className="flex-1 space-y-1">
                      <div className="flex items-center justify-between">
                        <p className="text-sm font-medium">Student {i}</p>
                        <span className="text-xs text-muted-foreground">3h ago</span>
                      </div>
                      <p className="text-sm text-muted-foreground line-clamp-1">
                        Hello, I'm interested in viewing your property. Is it still available?
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
            <CardFooter>
              <Button variant="outline" className="w-full" asChild>
                <Link href="/dashboard/landlord/messages">View All Messages</Link>
              </Button>
            </CardFooter>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Analytics Overview</CardTitle>
              <CardDescription>Property performance metrics</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Total Views</p>
                    <p className="text-2xl font-bold">1,024</p>
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Booking Rate</p>
                    <p className="text-2xl font-bold">18.5%</p>
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm font-medium">Avg. Response</p>
                    <p className="text-2xl font-bold">2.4h</p>
                  </div>
                </div>

                <div className="pt-4 border-t">
                  <p className="text-sm font-medium mb-2">Most Viewed Properties</p>
                  <div className="space-y-2">
                    {[1, 2, 3].map((i) => (
                      <div key={i} className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <div className="w-8 h-8 bg-muted rounded flex items-center justify-center">
                            <Building className="h-4 w-4" />
                          </div>
                          <p className="text-sm">Student Apartment {i}</p>
                        </div>
                        <p className="text-sm font-medium">{400 - i * 100} views</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </CardContent>
            <CardFooter>
              <Button variant="outline" className="w-full" asChild>
                <Link href="/dashboard/landlord/analytics">View Detailed Analytics</Link>
              </Button>
            </CardFooter>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  )
}

