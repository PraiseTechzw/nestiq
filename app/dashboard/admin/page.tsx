import Link from "next/link"
import { Building, Check, DollarSign, FileCheck, LineChart, Users } from "lucide-react"

import { DashboardLayout } from "@/components/dashboard-layout"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function AdminDashboard() {
  return (
    <DashboardLayout role="admin">
      <div className="flex flex-col gap-6">
        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold tracking-tight">Admin Dashboard</h1>
          <p className="text-muted-foreground">Platform overview and management.</p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Properties</CardTitle>
              <Building className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">156</div>
              <p className="text-xs text-muted-foreground">+12 this month</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Users</CardTitle>
              <Users className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">2,456</div>
              <p className="text-xs text-muted-foreground">+85 this month</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Platform Revenue</CardTitle>
              <DollarSign className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">$24,350</div>
              <p className="text-xs text-muted-foreground">+$3,250 from last month</p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Pending Verifications</CardTitle>
              <FileCheck className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">18</div>
              <p className="text-xs text-muted-foreground">12 properties, 6 landlords</p>
            </CardContent>
          </Card>
        </div>

        <Tabs defaultValue="verification">
          <div className="flex items-center">
            <TabsList>
              <TabsTrigger value="verification">Pending Verification</TabsTrigger>
              <TabsTrigger value="users">Recent Users</TabsTrigger>
              <TabsTrigger value="properties">Recent Properties</TabsTrigger>
            </TabsList>
          </div>

          <TabsContent value="verification" className="mt-4">
            <Card>
              <CardHeader>
                <CardTitle>Verification Requests</CardTitle>
                <CardDescription>Pending verification requests from landlords and properties</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-6">
                  {[1, 2, 3].map((i) => (
                    <div
                      key={i}
                      className="flex flex-col sm:flex-row sm:items-center gap-4 pb-4 border-b last:border-0 last:pb-0"
                    >
                      <Avatar className="hidden sm:flex">
                        <AvatarImage src={`/placeholder.svg?height=40&width=40&text=L${i}`} />
                        <AvatarFallback>L{i}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1 space-y-1">
                        <div className="flex items-center gap-2">
                          <Avatar className="h-6 w-6 sm:hidden">
                            <AvatarImage src={`/placeholder.svg?height=40&width=40&text=L${i}`} />
                            <AvatarFallback>L{i}</AvatarFallback>
                          </Avatar>
                          <p className="text-sm font-medium">Landlord {i}</p>
                          <span className="bg-yellow-100 text-yellow-800 text-xs px-2 py-0.5 rounded-full">
                            {i % 2 === 0 ? "Property Verification" : "Landlord Verification"}
                          </span>
                        </div>
                        {i % 2 === 0 ? (
                          <p className="text-sm">
                            <span className="font-medium">Property:</span> Student Apartment {i}
                          </p>
                        ) : (
                          <p className="text-sm">
                            <span className="font-medium">Documents:</span> ID, Business License
                          </p>
                        )}
                        <p className="text-sm">
                          <span className="font-medium">Submitted:</span> March {10 + i}, 2025
                        </p>
                      </div>
                      <div className="flex gap-2 sm:flex-col md:flex-row">
                        <Button size="sm" variant="outline">
                          Reject
                        </Button>
                        <Button size="sm">Verify</Button>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
              <CardFooter>
                <Button variant="outline" className="w-full" asChild>
                  <Link href="/dashboard/admin/verification">View All Verification Requests</Link>
                </Button>
              </CardFooter>
            </Card>
          </TabsContent>

          <TabsContent value="users" className="mt-4">
            <Card>
              <CardHeader>
                <CardTitle>Recent Users</CardTitle>
                <CardDescription>New users who joined the platform</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {[1, 2, 3, 4, 5].map((i) => (
                    <div key={i} className="flex items-center gap-4">
                      <Avatar>
                        <AvatarImage src={`/placeholder.svg?height=40&width=40&text=${i % 2 === 0 ? "S" : "L"}${i}`} />
                        <AvatarFallback>
                          {i % 2 === 0 ? "S" : "L"}
                          {i}
                        </AvatarFallback>
                      </Avatar>
                      <div className="flex-1 space-y-1">
                        <div className="flex items-center justify-between">
                          <p className="text-sm font-medium">
                            {i % 2 === 0 ? "Student" : "Landlord"} {i}
                          </p>
                          <span className="text-xs text-muted-foreground">Joined {i} days ago</span>
                        </div>
                        <p className="text-sm text-muted-foreground">user{i}@example.com</p>
                      </div>
                      <div className="flex items-center">
                        <span
                          className={`text-xs px-2 py-0.5 rounded-full ${
                            i % 3 === 0 ? "bg-yellow-100 text-yellow-800" : "bg-green-100 text-green-800"
                          }`}
                        >
                          {i % 3 === 0 ? "Pending" : "Verified"}
                        </span>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
              <CardFooter>
                <Button variant="outline" className="w-full" asChild>
                  <Link href="/dashboard/admin/users">View All Users</Link>
                </Button>
              </CardFooter>
            </Card>
          </TabsContent>

          <TabsContent value="properties" className="mt-4">
            <Card>
              <CardHeader>
                <CardTitle>Recent Properties</CardTitle>
                <CardDescription>Recently added properties on the platform</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {[1, 2, 3, 4, 5].map((i) => (
                    <div key={i} className="flex items-start gap-4">
                      <div className="w-12 h-12 rounded bg-muted flex items-center justify-center">
                        <Building className="h-6 w-6 text-muted-foreground" />
                      </div>
                      <div className="flex-1 space-y-1">
                        <div className="flex items-center justify-between">
                          <p className="text-sm font-medium">Student Apartment {i}</p>
                          <span className="text-xs text-muted-foreground">Added {i} days ago</span>
                        </div>
                        <p className="text-sm text-muted-foreground">Near University Campus • ${500 + i * 50}/month</p>
                        <div className="flex items-center mt-1">
                          <span
                            className={`text-xs px-2 py-0.5 rounded-full ${
                              i % 3 === 0 ? "bg-yellow-100 text-yellow-800" : "bg-green-100 text-green-800"
                            }`}
                          >
                            {i % 3 === 0 ? "Pending Verification" : "Verified"}
                          </span>
                        </div>
                      </div>
                      {i % 3 === 0 && (
                        <Button size="sm" variant="outline">
                          <Check className="h-4 w-4 mr-1" /> Verify
                        </Button>
                      )}
                    </div>
                  ))}
                </div>
              </CardContent>
              <CardFooter>
                <Button variant="outline" className="w-full" asChild>
                  <Link href="/dashboard/admin/properties">View All Properties</Link>
                </Button>
              </CardFooter>
            </Card>
          </TabsContent>
        </Tabs>

        <div className="grid gap-6 md:grid-cols-2">
          <Card>
            <CardHeader>
              <CardTitle>Revenue Overview</CardTitle>
              <CardDescription>Monthly revenue breakdown</CardDescription>
            </CardHeader>
            <CardContent className="h-80 flex items-center justify-center">
              <div className="flex items-center justify-center w-full h-full">
                <LineChart className="h-16 w-16 text-muted-foreground" />
                <p className="text-muted-foreground ml-4">Revenue chart will be displayed here</p>
              </div>
            </CardContent>
            <CardFooter>
              <Button variant="outline" className="w-full" asChild>
                <Link href="/dashboard/admin/analytics">View Detailed Analytics</Link>
              </Button>
            </CardFooter>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Platform Statistics</CardTitle>
              <CardDescription>Key metrics and performance indicators</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1">
                    <p className="text-sm text-muted-foreground">Total Students</p>
                    <p className="text-2xl font-bold">1,845</p>
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm text-muted-foreground">Total Landlords</p>
                    <p className="text-2xl font-bold">611</p>
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm text-muted-foreground">Active Bookings</p>
                    <p className="text-2xl font-bold">324</p>
                  </div>
                  <div className="space-y-1">
                    <p className="text-sm text-muted-foreground">Avg. Response Time</p>
                    <p className="text-2xl font-bold">3.2h</p>
                  </div>
                </div>

                <div className="pt-4 border-t">
                  <p className="text-sm font-medium mb-2">Top Performing Areas</p>
                  <div className="space-y-2">
                    {[1, 2, 3].map((i) => (
                      <div key={i} className="flex items-center justify-between">
                        <p className="text-sm">University District {i}</p>
                        <p className="text-sm font-medium">{85 - i * 15}% occupancy</p>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </CardContent>
            <CardFooter>
              <Button variant="outline" className="w-full" asChild>
                <Link href="/dashboard/admin/statistics">View All Statistics</Link>
              </Button>
            </CardFooter>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  )
}

