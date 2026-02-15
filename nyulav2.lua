local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Cleint",
    Text = "MEAT EATER LETS GO",
    Duration = 5
})

task.wait(0.5)
StarterGui:SetCore("SendNotification", {
    Title = "Ethan",
    Text = "nyula is for dadddy lovers",
    Duration = 5
})

loadstring(game:HttpGet("https://nyulalol.github.io/release/main.lua"))()

print("Loaded!!!!")
