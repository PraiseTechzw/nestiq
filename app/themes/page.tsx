import { ThemeSwitcher } from "./theme-switcher"
import { ThemePreview } from "./theme-preview"

export default function ThemesPage() {
  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold">Nestiq Themes</h1>
        <ThemeSwitcher />
      </div>

      <ThemePreview />
    </div>
  )
}

