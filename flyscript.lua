local _=game local __=_.GetService local ___=__.Players(_) local ____=__.UserInputService(_) local _____=__.RunService(_) local ______=__.CoreGui(_) local a=___["LocalPlayer"] local b=a["Character"]or a["CharacterAdded"]:Wait() local c=b:WaitForChild("Humanoid") local d=b:FindFirstChild("HumanoidRootPart")or b:GetPropertyChangedSignal("Parent"):Wait() local e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v={},nil,false,nil,nil,50,1,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil local w=Instance x=w["new"] y=x("ScreenGui") y["Parent"]=______ y["Name"]="a" z=x("Frame") z["Size"]=UDim2["new"](0,200,0,120) z["Position"]=UDim2["new"](0.5,-100,0.5,-60) z["BackgroundTransparency"]=1 z["Active"]=true z["Draggable"]=true z["Parent"]=y A=x("ImageLabel") A["Image"]="rbxassetid://125245558982515" A["Size"]=UDim2["new"](1,0,1,0) A["BackgroundTransparency"]=1 A["Parent"]=z B=x("Frame") B["Size"]=UDim2["new"](1,0,1,0) B["BackgroundColor3"]=Color3["fromRGB"](0,0,0) B["BackgroundTransparency"]=0.5 B["Parent"]=z C=x("TextLabel") C["Size"]=UDim2["new"](1,0,0,30) C["Text"]="Advanced Fly Controls" C["Font"]=Enum.Font.SourceSansBold C["TextSize"]=18 C["TextColor3"]=Color3.fromRGB(255,255,255) C["BackgroundTransparency"]=1 C["Parent"]=z D=x("TextButton") D["Size"]=UDim2["new"](0.9,0,0,30) D["Position"]=UDim2["new"](0.05,0,0.3,0) D["Text"]="Toggle Fly (F)" D["TextSize"]=16 D["BackgroundColor3"]=Color3["fromRGB"](60,60,60) D["BackgroundTransparency"]=0.7 D["Font"]=Enum.Font.SourceSans D["TextColor3"]=Color3["fromRGB"](255,255,255) D["Parent"]=z E=x("TextLabel") E["Text"]="Speed: "..t.."x" E["Size"]=UDim2["new"](0.9,0,0,20) E["Position"]=UDim2["new"](0.05,0,0.6,0) E["TextSize"]=14 E["TextColor3"]=Color3.fromRGB(255,255,255) E["BackgroundTransparency"]=1 E["Font"]=Enum.Font.SourceSans E["TextXAlignment"]=Enum.TextXAlignment.Left E["Parent"]=z F=x("TextButton") F["Size"]=UDim2["new"](0.9,0,0,20) F["Text"]="Change Speed (1-10)" F["Position"]=UDim2["new"](0.05,0,0.8,0) F["TextSize"]=14 F["BackgroundColor3"]=Color3["fromRGB"](80,80,80) F["BackgroundTransparency"]=0.7 F["Font"]=Enum.Font.SourceSans F["TextColor3"]=Color3["fromRGB"](255,255,255) F["Parent"]=z

local G=function()
    if not g then
        c:ChangeState(Enum.HumanoidStateType.Physics)
        for _,H in pairs(c:GetPlayingAnimationTracks()) do H:Stop()end
        i=Instance.new("BodyGyro",b.HumanoidRootPart) i.P=10000 i.MaxTorque=Vector3.new(40000,40000,40000) i.CFrame=b.HumanoidRootPart.CFrame
        j=Instance.new("BodyVelocity",b.HumanoidRootPart) j.MaxForce=Vector3.new(40000,40000,40000) j.Velocity=Vector3.zero j.P=10000
        c.PlatformStand=true D.BackgroundColor3=Color3.fromRGB(0,120,0) D.Text="Flying (F)" g=true
    else
        if j then j:Destroy()end if i then i:Destroy()end c.PlatformStand=false c:ChangeState(Enum.HumanoidStateType.GettingUp) D.BackgroundColor3=Color3.fromRGB(60,60,60) D.Text="Toggle Fly (F)" g=false
    end
end

local I=function()t=(t%10)+1 E.Text="Speed: "..t.."x"end

____.InputBegan:Connect(function(J,K)if K then return end if J.KeyCode==Enum.KeyCode.F then G()end end)
F.MouseButton1Click:Connect(I) D.MouseButton1Click:Connect(G)

_____:Connect(function()
    if g and j and i and b:FindFirstChild("HumanoidRootPart")then
        local K=workspace.CurrentCamera local L=Vector3.new(0,0,0) i.CFrame=K.CFrame
        if ____.IsKeyDown(____,Enum.KeyCode.W) then L+=K.CFrame.LookVector end
        if ____.IsKeyDown(____,Enum.KeyCode.S) then L-=K.CFrame.LookVector end
        if ____.IsKeyDown(____,Enum.KeyCode.A) then L-=K.CFrame.RightVector end
        if ____.IsKeyDown(____,Enum.KeyCode.D) then L+=K.CFrame.RightVector end
        if ____.IsKeyDown(____,Enum.KeyCode.Space) then L+=Vector3.new(0,1,0) end
        if ____.IsKeyDown(____,Enum.KeyCode.LeftControl) then L-=Vector3.new(0,1,0) end
        if L.Magnitude>0 then L=L.Unit*s*t end
        j.Velocity=L
    end
end)

a.CharacterAdded:Connect(function(M)
    b=M c=b:WaitForChild("Humanoid")
    if g then G()wait(0.1)G()end
end)
