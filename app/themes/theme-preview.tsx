import { clashingThemes } from "./theme-switcher"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"

export function ThemePreview() {
  return (
    <div className="space-y-8">
      <h1 className="text-3xl font-bold">Clashing Theme Previews</h1>
      <p className="text-muted-foreground">
        These themes use bold, contrasting colors that create visual interest for your student housing platform.
      </p>

      <div className="grid gap-8 md:grid-cols-2">
        {clashingThemes.map((theme) => (
          <div key={theme.id} className="space-y-4">
            <h2 className="text-xl font-semibold">{theme.name}</h2>
            <div className="rounded-lg p-6" style={{ backgroundColor: theme.colors.background }}>
              <div className="grid gap-4">
                <div className="flex gap-2">
                  <div
                    className="w-12 h-12 rounded-md flex items-center justify-center text-white font-bold"
                    style={{ backgroundColor: theme.colors.primary }}
                  >
                    P
                  </div>
                  <div
                    className="w-12 h-12 rounded-md flex items-center justify-center text-white font-bold"
                    style={{ backgroundColor: theme.colors.secondary }}
                  >
                    S
                  </div>
                  <div
                    className="w-12 h-12 rounded-md flex items-center justify-center text-black font-bold"
                    style={{ backgroundColor: theme.colors.accent }}
                  >
                    A
                  </div>
                </div>

                <Card
                  style={{
                    backgroundColor: theme.colors.background,
                    borderColor: theme.colors.primary,
                    color: theme.colors.primary === "#000000" ? "#FFFFFF" : "#000000",
                  }}
                >
                  <CardHeader>
                    <CardTitle style={{ color: theme.colors.primary }}>Card Title</CardTitle>
                    <CardDescription style={{ color: theme.colors.secondary }}>Card description text</CardDescription>
                  </CardHeader>
                  <CardContent>
                    <p style={{ color: theme.colors.primary === "#000000" ? "#FFFFFF" : "#000000" }}>
                      This is how content would look with this theme.
                    </p>
                  </CardContent>
                  <CardFooter className="flex gap-2">
                    <Button
                      style={{
                        backgroundColor: theme.colors.primary,
                        color: "#FFFFFF",
                      }}
                    >
                      Primary
                    </Button>
                    <Button
                      style={{
                        backgroundColor: theme.colors.secondary,
                        color: "#FFFFFF",
                      }}
                    >
                      Secondary
                    </Button>
                  </CardFooter>
                </Card>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

