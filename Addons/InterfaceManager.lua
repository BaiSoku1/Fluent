local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
	InterfaceManager.Folder = "FluentSettings"
	InterfaceManager.AutoSave = true
	InterfaceManager.SaveDebounce = 0.5
	
	InterfaceManager.DefaultSettings = {
		Theme = "Azure",
		Acrylic = true,
		Transparency = true,
		Animated = true,
		MenuKeybind = "LeftControl",
		WindowSize = nil,
		WindowPosition = nil,
		CustomOptions = {}
	}
	
	InterfaceManager.Settings = table.clone(InterfaceManager.DefaultSettings)
	
	local saveQueued = false
	local saveThread = nil
	
	local function deepClone(t)
		if type(t) ~= "table" then return t end
		local clone = {}
		for k, v in pairs(t) do
			if type(v) == "table" then
				clone[k] = deepClone(v)
			else
				clone[k] = v
			end
		end
		return clone
	end
	
	local function mergeTables(target, source)
		for k, v in pairs(source) do
			if type(v) == "table" and type(target[k]) == "table" then
				mergeTables(target[k], v)
			else
				target[k] = v
			end
		end
		return target
	end
	
	function InterfaceManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
		return self
	end
	
	function InterfaceManager:BuildFolderTree()
		local paths = {}
		local parts = self.Folder:split("/")
		
		for i = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, i)
		end
		
		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/settings")
		table.insert(paths, self.Folder .. "/backups")
		
		for _, path in ipairs(paths) do
			if not isfolder(path) then
				makefolder(path)
			end
		end
	end
	
	function InterfaceManager:SetLibrary(library)
		self.Library = library
		return self
	end
	
	function InterfaceManager:GetLibrary()
		assert(self.Library, "Library not set. Use :SetLibrary() first")
		return self.Library
	end
	
	function InterfaceManager:ResetSettings()
		self.Settings = deepClone(self.DefaultSettings)
		self:SaveSettings(true)
		return self
	end
	
	function InterfaceManager:UpdateSettings(newSettings)
		self.Settings = mergeTables(self.Settings, newSettings)
		self:SaveSettings()
		return self
	end
	
	function InterfaceManager:GetSetting(key, defaultValue)
		local value = self.Settings[key]
		if value == nil and defaultValue ~= nil then
			return defaultValue
		end
		return value
	end
	
	function InterfaceManager:SetSetting(key, value, autoSave)
		self.Settings[key] = value
		if autoSave ~= false then
			self:SaveSettings()
		end
		return self
	end
	
	function InterfaceManager:SaveSettings(immediate)
		if not immediate and self.AutoSave then
			if not saveQueued then
				saveQueued = true
				
				if saveThread then
					task.cancel(saveThread)
				end
				
				saveThread = task.delay(self.SaveDebounce, function()
					saveQueued = false
					self:SaveSettings(true)
				end)
			end
			return
		end
		
		if saveThread then
			task.cancel(saveThread)
			saveThread = nil
			saveQueued = false
		end
		
		local success, err = pcall(function()
			local path = self.Folder .. "/settings/config.json"
			local backupPath = self.Folder .. "/backups/config_" .. os.time() .. ".json"
			
			if isfile(path) then
				writefile(backupPath, readfile(path))
			end
			
			local data = httpService:JSONEncode(self.Settings)
			writefile(path, data)
		end)
		
		if not success then
			warn("Failed to save settings:", err)
		end
	end
	
	function InterfaceManager:LoadSettings()
		local path = self.Folder .. "/settings/config.json"
		
		if isfile(path) then
			local success, decoded = pcall(function()
				return httpService:JSONDecode(readfile(path))
			end)
			
			if success and type(decoded) == "table" then
				self.Settings = mergeTables(self.DefaultSettings, decoded)
			end
		end
		
		return self
	end
	
	function InterfaceManager:ExportSettings()
		return httpService:JSONEncode(self.Settings)
	end
	
	function InterfaceManager:ImportSettings(jsonString)
		local success, decoded = pcall(function()
			return httpService:JSONDecode(jsonString)
		end)
		
		if success and type(decoded) == "table" then
			self.Settings = mergeTables(self.DefaultSettings, decoded)
			self:SaveSettings(true)
			return true
		end
		
		return false
	end
	
	function InterfaceManager:CreateBackup()
		local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
		local backupPath = self.Folder .. "/backups/config_" .. timestamp .. ".json"
		local currentPath = self.Folder .. "/settings/config.json"
		
		if isfile(currentPath) then
			writefile(backupPath, readfile(currentPath))
			return backupPath
		end
		
		return nil
	end
	
	function InterfaceManager:ListBackups()
		local backups = {}
		local backupFolder = self.Folder .. "/backups"
		
		if isfolder(backupFolder) then
			for _, file in ipairs(listfiles(backupFolder)) do
				if file:match("%.json$") then
					table.insert(backups, file)
				end
			end
		end
		
		table.sort(backups, function(a, b)
			return a > b
		end)
		
		return backups
	end
	
	function InterfaceManager:RestoreBackup(backupPath)
		if isfile(backupPath) then
			local success, decoded = pcall(function()
				return httpService:JSONDecode(readfile(backupPath))
			end)
			
			if success and type(decoded) == "table" then
				self.Settings = mergeTables(self.DefaultSettings, decoded)
				self:SaveSettings(true)
				return true
			end
		end
		
		return false
	end
	
	function InterfaceManager:CleanOldBackups(maxBackups)
		maxBackups = maxBackups or 10
		local backups = self:ListBackups()
		
		for i = maxBackups + 1, #backups do
			pcall(delfile, backups[i])
		end
	end
	
	function InterfaceManager:BuildInterfaceSection(tab)
		local Library = self:GetLibrary()
		local Settings = self.Settings
		
		self:LoadSettings()
		
		local section = tab:AddSection("Interface")
		
		local themeDropdown = section:AddDropdown("InterfaceTheme", {
			Title = "Theme",
			Description = "Change the interface color scheme",
			Values = Library.Themes,
			Default = Settings.Theme,
			Callback = function(value)
				Library:SetTheme(value)
				Settings.Theme = value
				self:SaveSettings()
			end
		})
		
		themeDropdown:SetValue(Settings.Theme)
		
		if Library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic Effect",
				Description = "Enable blurred background (requires graphics quality 8+)",
				Default = Settings.Acrylic,
				Callback = function(value)
					Library:ToggleAcrylic(value)
					Settings.Acrylic = value
					self:SaveSettings()
				end
			})
		end
		
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "Make the interface partially transparent",
			Default = Settings.Transparency,
			Callback = function(value)
				Library:ToggleTransparency(value)
				Settings.Transparency = value
				self:SaveSettings()
			end
		})
		
		section:AddToggle("AnimationToggle", {
			Title = "Animated Theme",
			Description = "Enable animated gradients and effects",
			Default = Settings.Animated,
			Callback = function(value)
				getgenv().ShineEnabled = value
				Settings.Animated = value
				self:SaveSettings()
			end
		})
		
		local keybind = section:AddKeybind("MenuKeybind", {
			Title = "Menu Keybind",
			Default = Settings.MenuKeybind,
			Mode = "Toggle"
		})
		
		keybind:OnChanged(function()
			Settings.MenuKeybind = keybind.Value
			self:SaveSettings()
		end)
		
		Library.MinimizeKeybind = keybind
		
		local settingsSection = tab:AddSection("Settings Management")
		
		settingsSection:AddButton({
			Title = "Reset Settings",
			Description = "Restore all settings to default",
			Callback = function()
				Library:Dialog({
					Title = "Reset Settings",
					Content = "Are you sure you want to reset all settings to default?",
					Buttons = {
						{
							Title = "Yes",
							Callback = function()
								self:ResetSettings()
								themeDropdown:SetValue(Settings.Theme)
								Library:Notify({
									Title = "Settings",
									Content = "Settings have been reset",
									Duration = 3
								})
							end
						},
						{
							Title = "No"
						}
					}
				})
			end
		})
		
		settingsSection:AddButton({
			Title = "Create Backup",
			Description = "Save a backup of current settings",
			Callback = function()
				local path = self:CreateBackup()
				if path then
					Library:Notify({
						Title = "Backup Created",
						Content = "Settings backup saved successfully",
						Duration = 3
					})
				end
			end
		})
		
		return section
	end
end

return InterfaceManager
