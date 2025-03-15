"use client"

import { useEffect, useState } from "react"
import { Check, ChevronDown } from "lucide-react"

import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"

// Define our clashing themes
export const clashingThemes = [
  {
    name: "Neon Clash",
    id: "neon-clash",
    colors: {
      primary: "#FF00FF", // Magenta
      secondary: "#00FFFF", // Cyan
      accent: "#FFFF00", // Yellow
      background: "#121212", // Dark background
    },
  },
  {
    name: "Retro Punch",
    id: "retro-punch",
    colors: {
      primary: "#FF6B35", // Orange
      secondary: "#004E89", // Deep Blue
      accent: "#FFD166", // Yellow
      background: "#EFEFEF", // Light Gray
    },
  },
  {
    name: "Digital Acid",
    id: "digital-acid",
    colors: {
      primary: "#39FF14", // Neon Green
      secondary: "#9933FF", // Purple
      accent: "#FF3131", // Red
      background: "#000000", // Black
    },
  },
  {
    name: "Pastel Clash",
    id: "pastel-clash",
    colors: {
      primary: "#FFB6C1", // Light Pink
      secondary: "#90EE90", // Light Green
      accent: "#87CEFA", // Light Blue
      background: "#FFFACD", // Light Yellow
    },
  },
  {
    name: "Brutalist",
    id: "brutalist",
    colors: {
      primary: "#FF0000", // Red
      secondary: "#000000", // Black
      accent: "#FFFFFF", // White
      background: "#CCCCCC", // Gray
    },
  },
]

export function ThemeSwitcher() {
  const [theme, setTheme] = useState<string>("default")

  // Apply theme when it changes
  useEffect(() => {
    if (theme === "default") {
      // Remove custom properties and reset to default theme
      document.documentElement.style.removeProperty("--primary")
      document.documentElement.style.removeProperty("--secondary")
      document.documentElement.style.removeProperty("--accent")
      document.documentElement.style.removeProperty("--background")
      document.documentElement.classList.remove(...clashingThemes.map((t) => t.id))
    } else {
      // Find the selected theme
      const selectedTheme = clashingThemes.find((t) => t.id === theme)
      if (selectedTheme) {
        // Apply the theme colors as CSS variables
        document.documentElement.style.setProperty("--primary", selectedTheme.colors.primary)
        document.documentElement.style.setProperty("--secondary", selectedTheme.colors.secondary)
        document.documentElement.style.setProperty("--accent", selectedTheme.colors.accent)
        document.documentElement.style.setProperty("--background", selectedTheme.colors.background)

        // Add theme class and remove other theme classes
        document.documentElement.classList.remove(...clashingThemes.map((t) => t.id))
        document.documentElement.classList.add(selectedTheme.id)
      }
    }

    // Save theme preference
    localStorage.setItem("nestiq-theme", theme)
  }, [theme])

  // Load saved theme on initial render
  useEffect(() => {
    const savedTheme = localStorage.getItem("nestiq-theme")
    if (savedTheme) {
      setTheme(savedTheme)
    }
  }, [])

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="outline" className="flex items-center gap-2">
          <span className="hidden sm:inline-block">Theme:</span>
          <span>{theme === "default" ? "Default" : clashingThemes.find((t) => t.id === theme)?.name}</span>
          <ChevronDown className="h-4 w-4" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem
          className={cn("flex items-center justify-between", theme === "default" && "font-medium")}
          onClick={() => setTheme("default")}
        >
          Default
          {theme === "default" && <Check className="h-4 w-4 ml-2" />}
        </DropdownMenuItem>

        {clashingThemes.map((themeOption) => (
          <DropdownMenuItem
            key={themeOption.id}
            className={cn("flex items-center justify-between", theme === themeOption.id && "font-medium")}
            onClick={() => setTheme(themeOption.id)}
          >
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded-full" style={{ backgroundColor: themeOption.colors.primary }} />
              {themeOption.name}
            </div>
            {theme === themeOption.id && <Check className="h-4 w-4 ml-2" />}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  )
}

