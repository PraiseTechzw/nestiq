import Link from "next/link"
import { Building, Calendar, Clock, MessageSquare, Plus } from "lucide-react"

import { DashboardLayout } from "@/components/dashboard-layout"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function StudentDashboard() {
  return (
    <DashboardLayout role="student">
      <div className="flex flex-col gap-6">
        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold tracking-tight">Welcome back, Student</h1>
          <p className="text-muted-foreground">Here's what's happening with your housing search.</p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Saved Properties</CardTitle>
              <Building className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">12</div>
              <p className="text-xs text-muted-foreground">+2 since last week</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Upcoming Viewings</CardTitle>
              <Calendar className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">3</div>
              <p className="text-xs text-muted-foreground">Next viewing in 2 days</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">New Messages</CardTitle>
              <MessageSquare className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">5</div>
              <p className="text-xs text-muted-foreground">3 unread from landlords</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Profile Completion</CardTitle>
              <Clock className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">75%</div>
              <Progress value={75} className="mt-2" />
            </CardContent>
          </Card>
        </div>

        <Tabs defaultValue="upcoming">
          <div className="flex items-center justify-between">
            <TabsList>
              <TabsTrigger value="upcoming">Upcoming Viewings</TabsTrigger>
              <TabsTrigger value="recommended">Recommended</TabsTrigger>
              <TabsTrigger value="saved">Saved Properties</TabsTrigger>
            </TabsList>
            <Button size="sm" asChild>
              <Link href="/dashboard/student/properties">
                <Plus className="mr-2 h-4 w-4" />
                Browse More
              </Link>
            </Button>
          </div>

          <TabsContent value="upcoming" className="mt-4">
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[1, 2, 3].map((i) => (
                <Card key={i}>
                  <div className="aspect-video relative">
                    <img
                      src={`/placeholder.svg?height=200&width=400&text=Property ${i}`}
                      alt={`Property ${i}`}
                      className="object-cover w-full h-full rounded-t-lg"
                    />
                  </div>
                  <CardHeader className="p-4 pb-2">
                    <CardTitle className="text-lg">Student Apartment {i}</CardTitle>
                    <CardDescription>Viewing on March 18, 2025 at 2:00 PM</CardDescription>
                  </CardHeader>
                  <CardContent className="p-4 pt-0 pb-2">
                    <div className="flex justify-between text-sm">
                      <span>$600/month</span>
                      <span className="text-muted-foreground">Single Room</span>
                    </div>
                  </CardContent>
                  <CardFooter className="p-4 pt-2 flex gap-2">
                    <Button variant="outline" size="sm" className="flex-1">
                      Reschedule
                    </Button>
                    <Button size="sm" className="flex-1">
                      Details
                    </Button>
                  </CardFooter>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="recommended" className="mt-4">
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[4, 5, 6].map((i) => (
                <Card key={i}>
                  <div className="aspect-video relative">
                    <img
                      src={`/placeholder.svg?height=200&width=400&text=Property ${i}`}
                      alt={`Property ${i}`}
                      className="object-cover w-full h-full rounded-t-lg"
                    />
                    <div className="absolute top-2 right-2 bg-primary text-white text-xs font-medium px-2 py-1 rounded">
                      Recommended
                    </div>
                  </div>
                  <CardHeader className="p-4 pb-2">
                    <CardTitle className="text-lg">Student Apartment {i}</CardTitle>
                    <CardDescription>Near University Campus</CardDescription>
                  </CardHeader>
                  <CardContent className="p-4 pt-0 pb-2">
                    <div className="flex justify-between text-sm">
                      <span>$550/month</span>
                      <span className="text-muted-foreground">Shared Room</span>
                    </div>
                  </CardContent>
                  <CardFooter className="p-4 pt-2 flex gap-2">
                    <Button variant="outline" size="sm" className="flex-1">
                      Save
                    </Button>
                    <Button size="sm" className="flex-1">
                      View
                    </Button>
                  </CardFooter>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="saved" className="mt-4">
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {[7, 8, 9].map((i) => (
                <Card key={i}>
                  <div className="aspect-video relative">
                    <img
                      src={`/placeholder.svg?height=200&width=400&text=Property ${i}`}
                      alt={`Property ${i}`}
                      className="object-cover w-full h-full rounded-t-lg"
                    />
                    <div className="absolute top-2 right-2 bg-secondary text-secondary-foreground text-xs font-medium px-2 py-1 rounded">
                      Saved
                    </div>
                  </div>
                  <CardHeader className="p-4 pb-2">
                    <CardTitle className="text-lg">Student Apartment {i}</CardTitle>
                    <CardDescription>Near University Campus</CardDescription>
                  </CardHeader>
                  <CardContent className="p-4 pt-0 pb-2">
                    <div className="flex justify-between text-sm">
                      <span>$650/month</span>
                      <span className="text-muted-foreground">Single Room</span>
                    </div>
                  </CardContent>
                  <CardFooter className="p-4 pt-2 flex gap-2">
                    <Button variant="outline" size="sm" className="flex-1">
                      Schedule
                    </Button>
                    <Button size="sm" className="flex-1">
                      View
                    </Button>
                  </CardFooter>
                </Card>
              ))}
            </div>
          </TabsContent>
        </Tabs>

        <div className="grid gap-6 md:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle>Recent Messages</CardTitle>
              <CardDescription>Your latest conversations with landlords</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="flex items-center gap-4">
                    <Avatar>
                      <AvatarImage src={`/placeholder.svg?height=40&width=40&text=L${i}`} />
                      <AvatarFallback>L{i}</AvatarFallback>
                    </Avatar>
                    <div className="flex-1 space-y-1">
                      <div className="flex items-center justify-between">
                        <p className="text-sm font-medium">Landlord {i}</p>
                        <span className="text-xs text-muted-foreground">2h ago</span>
                      </div>
                      <p className="text-sm text-muted-foreground line-clamp-1">
                        Thanks for your interest in the property. Would you like to schedule a viewing?
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
            <CardFooter>
              <Button variant="outline" className="w-full" asChild>
                <Link href="/dashboard/student/messages">View All Messages</Link>
              </Button>
            </CardFooter>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Booking History</CardTitle>
              <CardDescription>Your recent property viewings</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="flex items-start gap-4">
                    <div className="min-w-10 text-center">
                      <p className="text-sm font-medium">Mar</p>
                      <p className="text-xl font-bold">{i + 10}</p>
                    </div>
                    <div className="flex-1 space-y-1">
                      <p className="text-sm font-medium">Student Apartment {i + 10}</p>
                      <p className="text-xs text-muted-foreground">2:00 PM - 3:00 PM</p>
                      <div className="flex items-center mt-1">
                        <span
                          className={`text-xs px-2 py-0.5 rounded-full ${
                            i === 1 ? "bg-yellow-100 text-yellow-800" : "bg-green-100 text-green-800"
                          }`}
                        >
                          {i === 1 ? "Pending" : "Completed"}
                        </span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
            <CardFooter>
              <Button variant="outline" className="w-full" asChild>
                <Link href="/dashboard/student/bookings">View All Bookings</Link>
              </Button>
            </CardFooter>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  )
}

