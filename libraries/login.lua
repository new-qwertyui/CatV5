if not shared.vape then
    repeat task.wait() until shared.vape
end
local license = ({...})[1] or {}

local vape = shared.vape
local httpService = game:GetService('HttpService')
local catauth = getgenv().CAK
local api = "https://catvape.vercel.app"

local success, res = pcall(function()
	local body = {
		username = getgenv().username,
		password = getgenv().password 
	}
	print(httpService:JSONEncode(body))
	local req = request({
		Url = api..'/login',
		Method = 'POST',
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = httpService:JSONEncode(body)
	})
	print(req.StatusCode)
	print(req.Body)
	if tostring(req.Body) == '404' or tostring(req.Body):find('502 Bad Gateway') then
		return 'Down'
	end
	local API
	local a2, v2 = pcall(function()
		API = httpService:JSONDecode(req.Body)
	end)
	if not a2 then
		return "Down"
	end
	table.foreach(API, print)
	local req2 = request({
		Url = api.."/user/userid",
		Method = "GET",
		Headers = {
			Authorization = "Bearer "..API.access_token
		}
	})
	getgenv().userid = httpService:JSONDecode(req2.Body).userid
	vape:CreateNotification('Cat', 'Logged in as '..getgenv().username.. ' (User '.. userid.. ')', 7)

	
	local label = Instance.new("TextLabel", vape.gui)
	label.Text = vape.Version.." - "..(shared.catvapedev and "Developer" or "Public").." | "..getgenv().username.." ("..getgenv().userid..")"
	label.Size = UDim2.fromScale(1, 0.037)
	label.Position = UDim2.fromScale(0, 0.961)
	label.BackgroundTransparency = 1
	label.TextScaled = true
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextXAlignment = Enum.TextXAlignment.Right
end)

if not success or success and res == 'Down' then
	getgenv().username = nil
	getgenv().password = nil
	if res == 'Down' then
		print('cat down')
	elseif not success then
		task.delay(7, function()
			vape:Uninject()
		end)
		task.spawn(warn, res)
		vape:CreateNotification('Cat', 'Invalid api result, Please report this problem to qwertyui or fuzzy.', 7, 'alert')
		error('CatVape | Invalid api result, Please report this problem to qwertyui or fuzzy.')
	end
end
task.spawn(function()
	local suc, err = pcall(function()
		--loadfile('newcatvape/libraries/whitelist.lua')()
	end)
	if not suc then
		if shared.catvapedev then task.spawn(error, 'Cat Whitelist | '.. err)
		vape:CreateNotification('Cat', 'Whitelist is currently down, Please report this problem to qwertyui or fuzzy.', 20, 'alert') end
	end
end)
