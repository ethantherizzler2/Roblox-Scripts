local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Nyula 5.1",
    Text = "Nyula 5.1 loaded",
    Duration = 5
})

task.wait(0.5)
StarterGui:SetCore("SendNotification", {
    Title = "WHATTHEFUCK",
    Text = "Bobby is so cool",
    Duration = 5
})

loadstring(game:HttpGet("https://nyulalol.github.io/release/main.lua"))()

print("[Nyula 5.1] Script finished loading.")
