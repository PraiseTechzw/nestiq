"use client"

import { type ReactNode, useState } from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import {
  Bell,
  Building,
  Calendar,
  ChevronDown,
  Home,
  LogOut,
  Menu,
  MessageSquare,
  PieChart,
  Search,
  Settings,
  User,
  Users,
} from "lucide-react"

import { cn } from "@/lib/utils"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Input } from "@/components/ui/input"
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet"
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarProvider,
  SidebarSeparator,
  SidebarTrigger,
} from "@/components/ui/sidebar"
import { ThemeSwitcher } from "@/app/themes/theme-switcher"

type UserRole = "student" | "landlord" | "admin"

interface DashboardLayoutProps {
  children: ReactNode
  role: UserRole
}

export function DashboardLayout({ children, role }: DashboardLayoutProps) {
  const pathname = usePathname()
  const [open, setOpen] = useState(true)

  // Navigation items based on user role
  const getNavItems = (role: UserRole) => {
    const commonItems = [
      {
        title: "Messages",
        href: `/dashboard/${role}/messages`,
        icon: MessageSquare,
      },
      {
        title: "Settings",
        href: `/dashboard/${role}/settings`,
        icon: Settings,
      },
      {
        title: "Themes",
        href: "/themes",
        icon: PieChart,
      },
    ]

    if (role === "student") {
      return [
        {
          title: "Dashboard",
          href: `/dashboard/${role}`,
          icon: Home,
        },
        {
          title: "Browse Properties",
          href: `/dashboard/${role}/properties`,
          icon: Building,
        },
        {
          title: "My Bookings",
          href: `/dashboard/${role}/bookings`,
          icon: Calendar,
        },
        ...commonItems,
      ]
    } else if (role === "landlord") {
      return [
        {
          title: "Dashboard",
          href: `/dashboard/${role}`,
          icon: Home,
        },
        {
          title: "My Properties",
          href: `/dashboard/${role}/properties`,
          icon: Building,
        },
        {
          title: "Booking Requests",
          href: `/dashboard/${role}/bookings`,
          icon: Calendar,
        },
        {
          title: "Analytics",
          href: `/dashboard/${role}/analytics`,
          icon: PieChart,
        },
        ...commonItems,
      ]
    } else if (role === "admin") {
      return [
        {
          title: "Dashboard",
          href: `/dashboard/${role}`,
          icon: Home,
        },
        {
          title: "Properties",
          href: `/dashboard/${role}/properties`,
          icon: Building,
        },
        {
          title: "Users",
          href: `/dashboard/${role}/users`,
          icon: Users,
        },
        {
          title: "Analytics",
          href: `/dashboard/${role}/analytics`,
          icon: PieChart,
        },
        {
          title: "Verification",
          href: `/dashboard/${role}/verification`,
          icon: Bell,
        },
        ...commonItems,
      ]
    }

    return []
  }

  const navItems = getNavItems(role)

  return (
    <SidebarProvider defaultOpen={open} onOpenChange={setOpen}>
      <div className="flex min-h-screen">
        {/* Desktop Sidebar */}
        <Sidebar className="hidden md:flex">
          <SidebarHeader>
            <div className="flex items-center px-2">
              <Link href="/" className="flex items-center gap-2 font-bold text-xl text-primary py-4">
                Nestiq
              </Link>
              <SidebarTrigger className="ml-auto" />
            </div>
          </SidebarHeader>
          <SidebarContent>
            <SidebarGroup>
              <SidebarGroupContent>
                <SidebarMenu>
                  {navItems.map((item) => (
                    <SidebarMenuItem key={item.href}>
                      <SidebarMenuButton asChild isActive={pathname === item.href}>
                        <Link href={item.href}>
                          <item.icon className="h-4 w-4" />
                          <span>{item.title}</span>
                        </Link>
                      </SidebarMenuButton>
                    </SidebarMenuItem>
                  ))}
                </SidebarMenu>
              </SidebarGroupContent>
            </SidebarGroup>

            <SidebarSeparator />

            <SidebarGroup>
              <SidebarGroupLabel>Help & Support</SidebarGroupLabel>
              <SidebarGroupContent>
                <SidebarMenu>
                  <SidebarMenuItem>
                    <SidebarMenuButton asChild>
                      <Link href="/help">
                        <span>Help Center</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                  <SidebarMenuItem>
                    <SidebarMenuButton asChild>
                      <Link href="/contact">
                        <span>Contact Support</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                </SidebarMenu>
              </SidebarGroupContent>
            </SidebarGroup>
          </SidebarContent>
          <SidebarFooter>
            <SidebarMenu>
              <SidebarMenuItem>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <SidebarMenuButton>
                      <Avatar className="h-6 w-6">
                        <AvatarImage src="/placeholder.svg?height=32&width=32" alt="User" />
                        <AvatarFallback>U</AvatarFallback>
                      </Avatar>
                      <span>User Profile</span>
                      <ChevronDown className="ml-auto h-4 w-4" />
                    </SidebarMenuButton>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="start" className="w-56">
                    <DropdownMenuLabel>My Account</DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem asChild>
                      <Link href={`/dashboard/${role}/profile`}>
                        <User className="mr-2 h-4 w-4" />
                        <span>Profile</span>
                      </Link>
                    </DropdownMenuItem>
                    <DropdownMenuItem asChild>
                      <Link href={`/dashboard/${role}/settings`}>
                        <Settings className="mr-2 h-4 w-4" />
                        <span>Settings</span>
                      </Link>
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem asChild>
                      <Link href="/auth/logout">
                        <LogOut className="mr-2 h-4 w-4" />
                        <span>Log out</span>
                      </Link>
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </SidebarMenuItem>
            </SidebarMenu>
          </SidebarFooter>
        </Sidebar>

        {/* Mobile Header */}
        <div className="flex flex-col flex-1">
          <header className="sticky top-0 z-30 flex h-16 items-center gap-4 border-b bg-background px-4 md:px-6">
            <Sheet>
              <SheetTrigger asChild>
                <Button variant="outline" size="icon" className="md:hidden">
                  <Menu className="h-5 w-5" />
                  <span className="sr-only">Toggle Menu</span>
                </Button>
              </SheetTrigger>
              <SheetContent side="left" className="w-[300px] sm:w-[400px] pr-0">
                <nav className="flex flex-col gap-4 h-full">
                  <Link href="/" className="flex items-center gap-2 font-bold text-xl text-primary py-4">
                    Nestiq
                  </Link>
                  <div className="flex flex-col gap-2">
                    {navItems.map((item) => (
                      <Link
                        key={item.href}
                        href={item.href}
                        className={cn(
                          "flex items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium",
                          pathname === item.href ? "bg-primary text-primary-foreground" : "hover:bg-muted",
                        )}
                      >
                        <item.icon className="h-5 w-5" />
                        {item.title}
                      </Link>
                    ))}
                  </div>
                  <div className="mt-auto">
                    <div className="flex items-center gap-2 rounded-lg px-3 py-2">
                      <Avatar>
                        <AvatarImage src="/placeholder.svg?height=32&width=32" alt="User" />
                        <AvatarFallback>U</AvatarFallback>
                      </Avatar>
                      <div className="flex flex-col">
                        <span className="text-sm font-medium">User Name</span>
                        <span className="text-xs text-muted-foreground">user@example.com</span>
                      </div>
                    </div>
                  </div>
                </nav>
              </SheetContent>
            </Sheet>
            <Link href="/" className="flex items-center gap-2 font-bold text-xl text-primary md:hidden">
              Nestiq
            </Link>
            <div className="relative flex-1 md:grow-0 md:w-80">
              <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
              <Input
                type="search"
                placeholder="Search..."
                className="w-full rounded-lg bg-background pl-8 md:w-[320px] lg:w-[440px]"
              />
            </div>
            <div className="ml-auto flex items-center gap-2">
              <ThemeSwitcher />
              <Button variant="outline" size="icon" className="relative">
                <Bell className="h-4 w-4" />
                <span className="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-primary text-[10px] font-medium text-primary-foreground">
                  3
                </span>
                <span className="sr-only">Notifications</span>
              </Button>
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <Button variant="outline" size="icon" className="rounded-full">
                    <Avatar className="h-8 w-8">
                      <AvatarImage src="/placeholder.svg?height=32&width=32" alt="User" />
                      <AvatarFallback>U</AvatarFallback>
                    </Avatar>
                  </Button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuLabel>My Account</DropdownMenuLabel>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem asChild>
                    <Link href={`/dashboard/${role}/profile`}>
                      <User className="mr-2 h-4 w-4" />
                      <span>Profile</span>
                    </Link>
                  </DropdownMenuItem>
                  <DropdownMenuItem asChild>
                    <Link href={`/dashboard/${role}/settings`}>
                      <Settings className="mr-2 h-4 w-4" />
                      <span>Settings</span>
                    </Link>
                  </DropdownMenuItem>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem asChild>
                    <Link href="/auth/logout">
                      <LogOut className="mr-2 h-4 w-4" />
                      <span>Log out</span>
                    </Link>
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          </header>

          {/* Main Content */}
          <main className="flex-1 p-4 md:p-6">{children}</main>
        </div>
      </div>
    </SidebarProvider>
  )
}

