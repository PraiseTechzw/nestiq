"use client"

import { useState } from "react"
import Link from "next/link"
import { Filter, MapPin, Search, SlidersHorizontal } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Separator } from "@/components/ui/separator"
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet"
import { Slider } from "@/components/ui/slider"

// Mock property data
const properties = Array.from({ length: 12 }).map((_, i) => ({
  id: i + 1,
  title: `Student Apartment ${i + 1}`,
  location: "Near University Campus",
  price: 500 + i * 25,
  roomType: i % 3 === 0 ? "Single" : i % 3 === 1 ? "Shared-2" : "Shared-3",
  amenities: [
    "WiFi",
    "Furnished",
    ...(i % 2 === 0 ? ["Kitchen"] : []),
    ...(i % 3 === 0 ? ["Laundry"] : []),
    ...(i % 4 === 0 ? ["Gym"] : []),
  ],
  verified: i % 5 !== 0,
  image: `/placeholder.svg?height=200&width=400&text=Property ${i + 1}`,
}))

export default function PropertiesPage() {
  const [showFilters, setShowFilters] = useState(false)
  const [priceRange, setPriceRange] = useState([400, 800])

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="bg-primary text-primary-foreground py-12">
        <div className="container mx-auto px-4">
          <h1 className="text-3xl font-bold mb-4">Find Your Perfect Student Home</h1>
          <div className="bg-card shadow-lg rounded-lg p-4 max-w-3xl">
            <div className="flex flex-col md:flex-row gap-4">
              <div className="flex-1 relative">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input placeholder="Search by location, university..." className="pl-9" />
              </div>
              <Sheet open={showFilters} onOpenChange={setShowFilters}>
                <SheetTrigger asChild>
                  <Button variant="outline" className="md:w-auto">
                    <Filter className="h-4 w-4 mr-2" />
                    Filters
                  </Button>
                </SheetTrigger>
                <SheetContent side="right" className="w-full sm:max-w-md overflow-auto">
                  <SheetHeader className="mb-4">
                    <SheetTitle>Filter Properties</SheetTitle>
                    <SheetDescription>Refine your search with specific criteria</SheetDescription>
                  </SheetHeader>

                  <div className="space-y-6">
                    <div>
                      <h3 className="text-sm font-medium mb-3">Price Range</h3>
                      <div className="space-y-4">
                        <Slider
                          defaultValue={[400, 800]}
                          min={200}
                          max={1200}
                          step={50}
                          value={priceRange}
                          onValueChange={setPriceRange}
                        />
                        <div className="flex items-center justify-between">
                          <span className="text-sm">${priceRange[0]}</span>
                          <span className="text-sm">${priceRange[1]}</span>
                        </div>
                      </div>
                    </div>

                    <Separator />

                    <div>
                      <h3 className="text-sm font-medium mb-3">Room Type</h3>
                      <RadioGroup defaultValue="all">
                        <div className="flex items-center space-x-2">
                          <RadioGroupItem value="all" id="all" />
                          <Label htmlFor="all">All Types</Label>
                        </div>
                        <div className="flex items-center space-x-2">
                          <RadioGroupItem value="single" id="single" />
                          <Label htmlFor="single">Single Room</Label>
                        </div>
                        <div className="flex items-center space-x-2">
                          <RadioGroupItem value="shared-2" id="shared-2" />
                          <Label htmlFor="shared-2">Shared (2 People)</Label>
                        </div>
                        <div className="flex items-center space-x-2">
                          <RadioGroupItem value="shared-3" id="shared-3" />
                          <Label htmlFor="shared-3">Shared (3+ People)</Label>
                        </div>
                      </RadioGroup>
                    </div>

                    <Separator />

                    <div>
                      <h3 className="text-sm font-medium mb-3">Amenities</h3>
                      <div className="grid grid-cols-2 gap-2">
                        {["WiFi", "Furnished", "Kitchen", "Laundry", "Gym", "Study Room", "Parking", "Security"].map(
                          (amenity) => (
                            <div key={amenity} className="flex items-center space-x-2">
                              <Checkbox id={amenity.toLowerCase()} />
                              <Label htmlFor={amenity.toLowerCase()}>{amenity}</Label>
                            </div>
                          ),
                        )}
                      </div>
                    </div>

                    <Separator />

                    <div>
                      <h3 className="text-sm font-medium mb-3">Property Status</h3>
                      <div className="flex items-center space-x-2">
                        <Checkbox id="verified" defaultChecked />
                        <Label htmlFor="verified">Verified Properties Only</Label>
                      </div>
                    </div>

                    <div className="flex gap-2 pt-4">
                      <Button variant="outline" className="flex-1">
                        Reset
                      </Button>
                      <Button className="flex-1" onClick={() => setShowFilters(false)}>
                        Apply Filters
                      </Button>
                    </div>
                  </div>
                </SheetContent>
              </Sheet>
              <Button>
                <Search className="h-4 w-4 mr-2" />
                Search
              </Button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
          <div>
            <h2 className="text-2xl font-bold">Available Properties</h2>
            <p className="text-muted-foreground">Showing {properties.length} properties</p>
          </div>

          <div className="flex flex-col sm:flex-row gap-4 w-full md:w-auto">
            <div className="flex items-center gap-2 w-full sm:w-auto">
              <SlidersHorizontal className="h-4 w-4 text-muted-foreground" />
              <Select defaultValue="recommended">
                <SelectTrigger className="w-full sm:w-[180px]">
                  <SelectValue placeholder="Sort by" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="recommended">Recommended</SelectItem>
                  <SelectItem value="price-low">Price: Low to High</SelectItem>
                  <SelectItem value="price-high">Price: High to Low</SelectItem>
                  <SelectItem value="newest">Newest First</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="hidden md:flex">
              <Button variant="outline" size="sm" className="md:hidden">
                <Filter className="h-4 w-4 mr-2" />
                Filters
              </Button>
            </div>
          </div>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {properties.map((property) => (
            <Card key={property.id} className="overflow-hidden">
              <div className="aspect-video relative">
                <img
                  src={property.image || "/placeholder.svg"}
                  alt={property.title}
                  className="object-cover w-full h-full"
                />
                {property.verified && (
                  <div className="absolute top-2 right-2 bg-primary text-primary-foreground text-xs font-medium px-2 py-1 rounded">
                    Verified
                  </div>
                )}
              </div>
              <CardHeader className="p-4 pb-2">
                <CardTitle className="text-lg">{property.title}</CardTitle>
                <div className="flex items-center text-muted-foreground text-sm">
                  <MapPin className="h-3 w-3 mr-1 flex-shrink-0" />
                  {property.location}
                </div>
              </CardHeader>
              <CardContent className="p-4 pt-0 pb-2">
                <div className="flex justify-between mb-2">
                  <span className="font-bold">${property.price}/month</span>
                  <span className="text-sm text-muted-foreground">{property.roomType}</span>
                </div>
                <div className="flex flex-wrap gap-1">
                  {property.amenities.map((amenity) => (
                    <span key={amenity} className="bg-muted text-xs px-2 py-0.5 rounded-full">
                      {amenity}
                    </span>
                  ))}
                </div>
              </CardContent>
              <CardFooter className="p-4 pt-2 flex gap-2">
                <Button variant="outline" size="sm" className="flex-1">
                  Save
                </Button>
                <Button size="sm" className="flex-1" asChild>
                  <Link href={`/properties/${property.id}`}>View</Link>
                </Button>
              </CardFooter>
            </Card>
          ))}
        </div>

        {/* Pagination */}
        <div className="flex justify-center mt-8">
          <div className="flex items-center gap-1">
            <Button variant="outline" size="sm" disabled>
              Previous
            </Button>
            <Button variant="outline" size="sm" className="bg-primary text-primary-foreground">
              1
            </Button>
            <Button variant="outline" size="sm">
              2
            </Button>
            <Button variant="outline" size="sm">
              3
            </Button>
            <Button variant="outline" size="sm">
              Next
            </Button>
          </div>
        </div>
      </main>
    </div>
  )
}

