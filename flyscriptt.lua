-- Advanced Flying Script with Directional Control
-- Made for Xeno executor

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Wait for character to fully load
if not character:FindFirstChild("HumanoidRootPart") then
    character:GetPropertyChangedSignal("Parent"):Wait()
end

-- Configuration
local flySpeed = 50
local flyMultiplier = 1
local isFlying = false
local bodyVelocity
local bodyGyro

-- Replace this with your actual Roblox image asset ID after uploading
local BACKGROUND_IMAGE_ID = "rbxassetid://125245558982515"

-- Stop limb movements and animations
local function stopAnimations()
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end
end

-- Create GUI with custom background
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Background image
local background = Instance.new("ImageLabel")
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.Image = BACKGROUND_IMAGE_ID
background.ScaleType = Enum.ScaleType.Crop
background.BackgroundTransparency = 1
background.Parent = frame

-- Dark overlay for better text visibility
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.Position = UDim2.new(0, 0, 0, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Advanced Fly Controls"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleButton.Position = UDim2.new(0.05, 0, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.BackgroundTransparency = 0.7
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Toggle Fly (F)"
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 16
toggleButton.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Speed: " .. flyMultiplier .. "x"
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 14
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = frame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0.9, 0, 0, 20)
speedSlider.Position = UDim2.new(0.05, 0, 0.8, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedSlider.BackgroundTransparency = 0.7
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.Text = "Change Speed (1-10)"
speedSlider.Font = Enum.Font.SourceSans
speedSlider.TextSize = 14
speedSlider.Parent = frame

-- Toggle fly function
local function toggleFly()
    isFlying = not isFlying
    
    if isFlying then
        stopAnimations()
        
        -- Create movement controls
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 10000
        bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        bodyGyro.Parent = character.HumanoidRootPart
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.P = 10000
        bodyVelocity.Parent = character.HumanoidRootPart
        
        humanoid.PlatformStand = true
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        toggleButton.Text = "Flying (F)"
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleButton.Text = "Toggle Fly (F)"
    end
end

-- Change speed multiplier
local function changeSpeed()
    flyMultiplier = (flyMultiplier % 10) + 1
    speedLabel.Text = "Speed: " .. flyMultiplier .. "x"
end

-- Input handling
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

speedSlider.MouseButton1Click:Connect(changeSpeed)
toggleButton.MouseButton1Click:Connect(toggleFly)

-- Fly movement with directional control
runService.Heartbeat:Connect(function()
    if isFlying and bodyVelocity and bodyGyro and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)
        
        -- Update gyro to match camera orientation
        bodyGyro.CFrame = camera.CFrame
        
        -- Get movement direction based on camera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        -- Movement controls
        if userInput:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + forward
        end
        if userInput:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - forward
        end
        if userInput:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - right
        end
        if userInput:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + right
        end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + up
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - up
        end
        
        -- Normalize and apply speed
        if direction.Magnitude > 0 then
            direction = direction.Unit * flySpeed * flyMultiplier
        end
        
        bodyVelocity.Velocity = direction
    end
end)

-- Clean up when character respawns
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    
    if isFlying then
        toggleFly() -- Turn off fly
        wait(0.1)
        toggleFly() -- Turn on fly for new character
    end
end)