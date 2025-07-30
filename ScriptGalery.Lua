
-- ScriptGalleryV1
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ScriptGalleryV1"
gui.ResetOnSpawn = false
 
local darkMode = true
 
-- Función para crear esquinas redondeadas fácil
local function roundCorners(parent, radius)
    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, radius)
    uc.Parent = parent
    return uc
end
 
-- Main frame (ventana)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 700, 0, 450)
main.Position = UDim2.new(0.5, -350, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
roundCorners(main, 12)
main.Active = true
main.Draggable = true
 
-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(45,45,45)
roundCorners(header, 12)
 
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Script Gallery V1"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
 
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,0.3,0.3)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundTransparency = 1
closeBtn.AutoButtonColor = true
 
-- Container for scripts gallery (ScrollingFrame with grid)
local gallery = Instance.new("ScrollingFrame", main)
gallery.Position = UDim2.new(0, 15, 0, 50)
gallery.Size = UDim2.new(0.55, -20, 1, -60)
gallery.BackgroundTransparency = 1
gallery.ScrollBarThickness = 6
gallery.CanvasSize = UDim2.new(0, 0, 0, 0)
gallery.AutomaticCanvasSize = Enum.AutomaticSize.Y
gallery.ScrollingDirection = Enum.ScrollingDirection.Y
 
local gridLayout = Instance.new("UIGridLayout", gallery)
gridLayout.CellSize = UDim2.new(0, 100, 0, 120)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 12)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
 
-- Panel derecho para crear script
local rightPanel = Instance.new("Frame", main)
rightPanel.Position = UDim2.new(0.56, 10, 0, 50)
rightPanel.Size = UDim2.new(0.44, -25, 1, -60)
rightPanel.BackgroundColor3 = Color3.fromRGB(45,45,45)
roundCorners(rightPanel, 10)
 
local panelTitle = Instance.new("TextLabel", rightPanel)
panelTitle.Size = UDim2.new(1, 0, 0, 30)
panelTitle.BackgroundTransparency = 1
panelTitle.Text = "Crear Nuevo Script"
panelTitle.TextColor3 = Color3.new(1,1,1)
panelTitle.Font = Enum.Font.GothamBold
panelTitle.TextSize = 14
 
local nameBox = Instance.new("TextBox", rightPanel)
nameBox.PlaceholderText = "Nombre del Script..."
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Position = UDim2.new(0, 10, 0, 40)
nameBox.TextSize = 12
nameBox.ClearTextOnFocus = false
roundCorners(nameBox, 6)
 
local contentBox = Instance.new("TextBox", rightPanel)
contentBox.PlaceholderText = "Escribe el contenido del script aquí..."
contentBox.Size = UDim2.new(1, -20, 0, 250)
contentBox.Position = UDim2.new(0, 10, 0, 80)
contentBox.TextSize = 12
contentBox.ClearTextOnFocus = false
contentBox.MultiLine = true
contentBox.TextWrapped = true
roundCorners(contentBox, 6)
 
local saveScriptBtn = Instance.new("TextButton", rightPanel)
saveScriptBtn.Text = "Guardar Script"
saveScriptBtn.Size = UDim2.new(1, -20, 0, 35)
saveScriptBtn.Position = UDim2.new(0, 10, 1, -45)
saveScriptBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
saveScriptBtn.TextColor3 = Color3.new(1,1,1)
saveScriptBtn.Font = Enum.Font.GothamBold
saveScriptBtn.TextSize = 14
roundCorners(saveScriptBtn, 8)
 
-- Función para crear un item de script en la galería
local function createScriptItem(name, content)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 120)
    frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    roundCorners(frame, 8)
 
    local icon = Instance.new("ImageButton", frame)  
    icon.Size = UDim2.new(0, 80, 0, 80)  
    icon.Position = UDim2.new(0.5, -40, 0, 8)  
    icon.BackgroundTransparency = 1  
    icon.Image = "rbxassetid://87989858762802" -- Por ahora icono default, se puede mejorar detectando tipo  
    icon.AutoButtonColor = false  
 
    local label = Instance.new("TextLabel", frame)  
    label.Size = UDim2.new(1, -10, 0, 30)  
    label.Position = UDim2.new(0, 5, 1, -35)  
    label.BackgroundTransparency = 1  
    label.TextColor3 = Color3.new(1,1,1)  
    label.Font = Enum.Font.Gotham  
    label.TextSize = 12  
    label.TextWrapped = true  
    label.Text = name  
 
    -- Click para abrir el script en el panel derecho  
    icon.MouseButton1Click:Connect(function()  
        nameBox.Text = name  
        contentBox.Text = content  
    end)  
 
    return frame
 
end
 
-- Lista para guardar scripts en memoria (tabla)
local scriptsList = {}
 
-- Guardar script en la lista y en galería
saveScriptBtn.MouseButton1Click:Connect(function()
    local name = nameBox.Text:match("^%s*(.-)%s*$") -- Trim
    local content = contentBox.Text
    if name == "" then
        warn("❌ El nombre del script no puede estar vacío")
        return
    end
    -- Crear nuevo script en tabla
    scriptsList[name] = content
 
    -- Limpiar inputs  
    nameBox.Text = ""  
    contentBox.Text = ""  
 
    -- Crear y agregar item a galería  
    local newItem = createScriptItem(name, content)  
    newItem.Parent = gallery  
 
    -- Actualizar CanvasSize para Scroll  
    wait()  
    gallery.CanvasSize = UDim2.new(0, 0, 0, gridLayout.AbsoluteContentSize.Y)
 
end)
 
-- Cerrar GUI
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
 
-- Tema (oscuro/claro) - opción sencilla para la demo
local function aplicarTema()
    local bgMain = darkMode and Color3.fromRGB(30,30,30) or Color3.fromRGB(240,240,240)
    local bgPanel = darkMode and Color3.fromRGB(45,45,45) or Color3.fromRGB(220,220,220)
    local textColor = darkMode and Color3.new(1,1,1) or Color3.new(0,0,0)
    local btnColor = darkMode and Color3.fromRGB(70,130,90) or Color3.fromRGB(100,180,120)
 
    main.BackgroundColor3 = bgMain  
    header.BackgroundColor3 = bgPanel  
    title.TextColor3 = textColor  
    closeBtn.TextColor3 = darkMode and Color3.fromRGB(255,100,100) or Color3.fromRGB(180,60,60)  
    gallery.BackgroundTransparency = 1  
    rightPanel.BackgroundColor3 = bgPanel  
    panelTitle.TextColor3 = textColor  
    nameBox.TextColor3 = textColor  
    nameBox.BackgroundColor3 = darkMode and Color3.fromRGB(60,60,60) or Color3.fromRGB(230,230,230)  
    contentBox.TextColor3 = textColor  
    contentBox.BackgroundColor3 = darkMode and Color3.fromRGB(60,60,60) or Color3.fromRGB(230,230,230)  
    saveScriptBtn.BackgroundColor3 = btnColor  
    saveScriptBtn.TextColor3 = Color3.new(1,1,1)
 
end
 
aplicarTema()
