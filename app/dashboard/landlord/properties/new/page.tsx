"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { ImagePlus, Loader2, Plus, Trash2, Upload } from "lucide-react"

import { DashboardLayout } from "@/components/dashboard-layout"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Checkbox } from "@/components/ui/checkbox"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Textarea } from "@/components/ui/textarea"
import { useToast } from "@/hooks/use-toast"

// List of amenities for the property
const amenities = [
  { id: "wifi", label: "WiFi" },
  { id: "furnished", label: "Furnished" },
  { id: "kitchen", label: "Kitchen" },
  { id: "laundry", label: "Laundry" },
  { id: "gym", label: "Gym" },
  { id: "study-room", label: "Study Room" },
  { id: "parking", label: "Parking" },
  { id: "security", label: "Security" },
  { id: "air-conditioning", label: "Air Conditioning" },
  { id: "heating", label: "Heating" },
  { id: "tv", label: "TV" },
  { id: "balcony", label: "Balcony" },
]

export default function NewPropertyPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [images, setImages] = useState<string[]>([])
  const [roomTypes, setRoomTypes] = useState([{ type: "single", price: "", available: "1" }])

  const handleAddImage = () => {
    // In a real app, this would handle file uploads
    // For demo purposes, we'll add a placeholder
    setImages([...images, `/placeholder.svg?height=200&width=400&text=Image ${images.length + 1}`])
  }

  const handleRemoveImage = (index: number) => {
    const newImages = [...images]
    newImages.splice(index, 1)
    setImages(newImages)
  }

  const handleAddRoomType = () => {
    setRoomTypes([...roomTypes, { type: "single", price: "", available: "1" }])
  }

  const handleRemoveRoomType = (index: number) => {
    if (roomTypes.length === 1) return
    const newRoomTypes = [...roomTypes]
    newRoomTypes.splice(index, 1)
    setRoomTypes(newRoomTypes)
  }

  const handleRoomTypeChange = (index: number, field: string, value: string) => {
    const newRoomTypes = [...roomTypes]
    newRoomTypes[index] = { ...newRoomTypes[index], [field]: value }
    setRoomTypes(newRoomTypes)
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setIsSubmitting(true)

    // Simulate form submission
    setTimeout(() => {
      setIsSubmitting(false)
      toast({
        title: "Property submitted",
        description: "Your property has been submitted for verification.",
      })
      router.push("/dashboard/landlord/properties")
    }, 2000)
  }

  return (
    <DashboardLayout role="landlord">
      <div className="space-y-6">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Add New Property</h1>
          <p className="text-muted-foreground">List your property for students to discover and book</p>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="grid gap-6">
            {/* Basic Information */}
            <Card>
              <CardHeader>
                <CardTitle>Basic Information</CardTitle>
                <CardDescription>Provide the essential details about your property</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="title">Property Title</Label>
                  <Input id="title" placeholder="e.g. Modern Student Apartment Near Campus" required />
                </div>

                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="property-type">Property Type</Label>
                    <Select defaultValue="apartment">
                      <SelectTrigger id="property-type">
                        <SelectValue placeholder="Select property type" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="apartment">Apartment</SelectItem>
                        <SelectItem value="house">House</SelectItem>
                        <SelectItem value="studio">Studio</SelectItem>
                        <SelectItem value="dormitory">Dormitory</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="university">Nearest University/College</Label>
                    <Input id="university" placeholder="e.g. State University" required />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="description">Description</Label>
                  <Textarea
                    id="description"
                    placeholder="Describe your property in detail..."
                    className="min-h-[120px]"
                    required
                  />
                </div>
              </CardContent>
            </Card>

            {/* Location */}
            <Card>
              <CardHeader>
                <CardTitle>Location</CardTitle>
                <CardDescription>Provide the address and location details</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="address">Street Address</Label>
                  <Input id="address" placeholder="e.g. 123 University Avenue" required />
                </div>

                <div className="grid gap-4 sm:grid-cols-3">
                  <div className="space-y-2">
                    <Label htmlFor="city">City</Label>
                    <Input id="city" placeholder="e.g. College Town" required />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="state">State/Province</Label>
                    <Input id="state" placeholder="e.g. California" required />
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="zip">Postal/Zip Code</Label>
                    <Input id="zip" placeholder="e.g. 12345" required />
                  </div>
                </div>

                <div className="space-y-2">
                  <Label>Distance to Campus</Label>
                  <RadioGroup defaultValue="walking">
                    <div className="flex flex-wrap gap-4">
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="walking" id="walking" />
                        <Label htmlFor="walking">Walking Distance (0-15 min)</Label>
                      </div>
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="biking" id="biking" />
                        <Label htmlFor="biking">Biking Distance (15-30 min)</Label>
                      </div>
                      <div className="flex items-center space-x-2">
                        <RadioGroupItem value="transit" id="transit" />
                        <Label htmlFor="transit">Transit Required (30+ min)</Label>
                      </div>
                    </div>
                  </RadioGroup>
                </div>
              </CardContent>
            </Card>

            {/* Room Types & Pricing */}
            <Card>
              <CardHeader>
                <div className="flex justify-between items-center">
                  <div>
                    <CardTitle>Room Types & Pricing</CardTitle>
                    <CardDescription>Add the different room types available in your property</CardDescription>
                  </div>
                  <Button type="button" variant="outline" size="sm" onClick={handleAddRoomType}>
                    <Plus className="h-4 w-4 mr-2" />
                    Add Room Type
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="space-y-6">
                {roomTypes.map((room, index) => (
                  <div key={index} className="p-4 border rounded-lg space-y-4">
                    <div className="flex justify-between items-center">
                      <h4 className="font-medium">Room Type {index + 1}</h4>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => handleRemoveRoomType(index)}
                        disabled={roomTypes.length === 1}
                      >
                        <Trash2 className="h-4 w-4 text-destructive" />
                        <span className="sr-only">Remove room type</span>
                      </Button>
                    </div>

                    <div className="grid gap-4 sm:grid-cols-3">
                      <div className="space-y-2">
                        <Label htmlFor={`room-type-${index}`}>Type</Label>
                        <Select value={room.type} onValueChange={(value) => handleRoomTypeChange(index, "type", value)}>
                          <SelectTrigger id={`room-type-${index}`}>
                            <SelectValue placeholder="Select room type" />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="single">Single Room</SelectItem>
                            <SelectItem value="shared-2">Shared Room (2 People)</SelectItem>
                            <SelectItem value="shared-3">Shared Room (3+ People)</SelectItem>
                            <SelectItem value="studio">Studio</SelectItem>
                          </SelectContent>
                        </Select>
                      </div>

                      <div className="space-y-2">
                        <Label htmlFor={`price-${index}`}>Monthly Price ($)</Label>
                        <Input
                          id={`price-${index}`}
                          type="number"
                          placeholder="e.g. 500"
                          value={room.price}
                          onChange={(e) => handleRoomTypeChange(index, "price", e.target.value)}
                          required
                        />
                      </div>

                      <div className="space-y-2">
                        <Label htmlFor={`available-${index}`}>Available Units</Label>
                        <Input
                          id={`available-${index}`}
                          type="number"
                          placeholder="e.g. 3"
                          value={room.available}
                          onChange={(e) => handleRoomTypeChange(index, "available", e.target.value)}
                          required
                        />
                      </div>
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>

            {/* Amenities */}
            <Card>
              <CardHeader>
                <CardTitle>Amenities</CardTitle>
                <CardDescription>Select the amenities available in your property</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                  {amenities.map((amenity) => (
                    <div key={amenity.id} className="flex items-center space-x-2">
                      <Checkbox id={amenity.id} />
                      <Label htmlFor={amenity.id}>{amenity.label}</Label>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Images */}
            <Card>
              <CardHeader>
                <CardTitle>Property Images</CardTitle>
                <CardDescription>Upload high-quality images of your property (minimum 3 images)</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                  {images.map((image, index) => (
                    <div key={index} className="relative aspect-video bg-muted rounded-md overflow-hidden">
                      <img
                        src={image || "/placeholder.svg"}
                        alt={`Property image ${index + 1}`}
                        className="object-cover w-full h-full"
                      />
                      <Button
                        type="button"
                        variant="destructive"
                        size="icon"
                        className="absolute top-2 right-2 h-6 w-6"
                        onClick={() => handleRemoveImage(index)}
                      >
                        <Trash2 className="h-3 w-3" />
                        <span className="sr-only">Remove image</span>
                      </Button>
                    </div>
                  ))}

                  <button
                    type="button"
                    className="aspect-video flex flex-col items-center justify-center gap-2 border-2 border-dashed rounded-md hover:bg-muted/50 transition-colors"
                    onClick={handleAddImage}
                  >
                    <ImagePlus className="h-8 w-8 text-muted-foreground" />
                    <span className="text-sm text-muted-foreground">Add Image</span>
                  </button>
                </div>

                {images.length < 3 && (
                  <p className="text-sm text-destructive">Please add at least 3 images of your property</p>
                )}
              </CardContent>
            </Card>

            {/* Verification Documents */}
            <Card>
              <CardHeader>
                <CardTitle>Verification Documents</CardTitle>
                <CardDescription>Upload documents to verify your property ownership</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="property-document">Property Ownership Document</Label>
                  <div className="flex items-center gap-2">
                    <Input id="property-document" type="file" className="hidden" />
                    <Button
                      type="button"
                      variant="outline"
                      className="w-full"
                      onClick={() => document.getElementById("property-document")?.click()}
                    >
                      <Upload className="h-4 w-4 mr-2" />
                      Upload Document
                    </Button>
                  </div>
                  <p className="text-xs text-muted-foreground">Accepted formats: PDF, JPG, PNG (Max size: 5MB)</p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="id-document">ID Verification</Label>
                  <div className="flex items-center gap-2">
                    <Input id="id-document" type="file" className="hidden" />
                    <Button
                      type="button"
                      variant="outline"
                      className="w-full"
                      onClick={() => document.getElementById("id-document")?.click()}
                    >
                      <Upload className="h-4 w-4 mr-2" />
                      Upload ID
                    </Button>
                  </div>
                  <p className="text-xs text-muted-foreground">Government-issued ID for verification purposes</p>
                </div>
              </CardContent>
            </Card>

            {/* Terms & Submission */}
            <Card>
              <CardHeader>
                <CardTitle>Terms & Submission</CardTitle>
                <CardDescription>Review and agree to our terms before submitting</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-start space-x-2">
                  <Checkbox id="terms" required />
                  <div className="grid gap-1.5 leading-none">
                    <Label
                      htmlFor="terms"
                      className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                    >
                      I agree to the terms and conditions
                    </Label>
                    <p className="text-sm text-muted-foreground">
                      By submitting this property, I confirm that all information provided is accurate and I have the
                      legal right to list this property.
                    </p>
                  </div>
                </div>

                <div className="flex items-start space-x-2">
                  <Checkbox id="verification" required />
                  <div className="grid gap-1.5 leading-none">
                    <Label
                      htmlFor="verification"
                      className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
                    >
                      I understand the verification process
                    </Label>
                    <p className="text-sm text-muted-foreground">
                      I understand that my property listing will be reviewed by the Nestiq team before being published
                      on the platform.
                    </p>
                  </div>
                </div>
              </CardContent>
              <CardFooter className="flex flex-col sm:flex-row gap-2">
                <Button variant="outline" type="button" className="w-full sm:w-auto" onClick={() => router.back()}>
                  Cancel
                </Button>
                <Button type="submit" className="w-full sm:w-auto" disabled={isSubmitting || images.length < 3}>
                  {isSubmitting ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Submitting...
                    </>
                  ) : (
                    "Submit Property"
                  )}
                </Button>
              </CardFooter>
            </Card>
          </div>
        </form>
      </div>
    </DashboardLayout>
  )
}

