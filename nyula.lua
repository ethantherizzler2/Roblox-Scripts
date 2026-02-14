local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Cleint",
    Text = "wait before i tickle yo feet",
    Duration = 5
})

task.wait(0.5)
StarterGui:SetCore("SendNotification", {
    Title = "Ethan",
    Text = "alright its loaded but ITS NEW SO SHUT TEH FEK Up",
    Duration = 5
})

loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/606b846e88998801018fae498b9b8a3c.lua"))()

print("Loaded!!!!")
