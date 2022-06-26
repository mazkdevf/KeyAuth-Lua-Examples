local private = {
    sessionid = "",
    apiLink = "https://keyauth.win/api/1.1";
}

local app_data = {
    numUsers = "",
    numOnlineUsers = "",
    numKeys = "",
    version = "",
    customerPanelLink = "",
}

local user_data = {
    username = "",
    ip = "",
    hwid = "",
    createdate = "",
    lastlogin = "",
}

local name = "";       -- Application Name
local ownerid = "";    -- Application Owner ID
local version = "1.0"; -- Application Version

function your_script()
    print("[KeyAuth] - Your script here");
    print("\n Userdata:")
    print(" Username: " .. user_data.username);
    print(" IP Address: " .. user_data.ip);
    print(" Createdate: " .. user_data.createdate);
    print(" Lastlogin: " .. user_data.lastlogin);
end

--[[
--> FiveM Console Colors <--
^1 - Light Green
^2 - Light Yellow
^3 - Dark Blue
^4 - Light Blue
^5 - Violet
^6 - White
^7 - Blood Red
^8 - Fuchsia
--]]

CreateThread(function()
	PerformHttpRequest(private.apiLink .. '?type=init&name=' .. name .. '&ownerid=' .. ownerid .. '&ver=' .. version, function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                private.sessionid = json.sessionid

                app_data.numUsers = json.appinfo.numUsers
                app_data.numOnlineUsers = json.appinfo.numOnlineUsers
                app_data.numKeys = json.appinfo.numKeys
                app_data.version = json.appinfo.version
                app_data.customerPanelLink = json.appinfo.customerPanelLink

                -- --> SCRIPT AUTHENTICATION < -- --
                --[[
                //* Login with existing account.
                Login("username", "password");
                
                //* Register a new user.
                Register("username", "password", "key");

                //* License Login.
                License("key");
                --]]


                License(Config.License);
                -- --> SCRIPT AUTHENTICATION < -- --

            else
                print("^1[KeyAuth]^7 - Error: " .. json.message)
                os.exit();
            end
        else 
            print("Error with code: " .. code)
            os.exit();
		end
	end, 'GET')
end)

function Login(username, password)
    PerformHttpRequest('?type=login&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&username=' .. username .. '&pass=' .. password, function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                user_data.username = json.info.username
                user_data.ip = json.info.ip
                user_data.hwid = json.info.hwid
                user_data.createdate = json.info.createdate
                user_data.lastlogin = json.info.lastlogin

                your_script()
            else
                print("^1[KeyAuth]^7 - Error: " .. json.message)
                os.exit();
            end
		end
	end, 'POST')
end

function Register(username, password, key)
    PerformHttpRequest(private.apiLink .. '?type=register&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&username=' .. username .. '&pass=' .. password .. '&key=' .. key, function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                user_data.username = json.info.username
                user_data.ip = json.info.ip
                user_data.hwid = json.info.hwid
                user_data.createdate = json.info.createdate
                user_data.lastlogin = json.info.lastlogin

                your_script()
            else
                print("^1[KeyAuth]^7 - Error: " .. json.message)
                os.exit();
            end
		end
	end, 'POST')
end

function License(key)
    PerformHttpRequest(private.apiLink .. '?type=license&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&key=' .. key, function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                user_data.username = json.info.username
                user_data.ip = json.info.ip
                user_data.hwid = json.info.hwid
                user_data.createdate = json.info.createdate
                user_data.lastlogin = json.info.lastlogin

                your_script()
            else
                print("^1[KeyAuth]^7 - Error: " .. json.message)
                os.exit();
            end
		end
	end, 'POST')
end

function Webhook(webID, params)
    PerformHttpRequest(private.apiLink .. '?type=webhook&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&webid=' .. webID, '&params=' .. params, function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                return json.response;
            else
                return "";
            end
		end
	end, 'POST')
end

function Variable(varID)
    PerformHttpRequest(private.apiLink .. '?type=var&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&varid=' .. varID, function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                return json.message;
            else
                return "";
            end
		end
	end, 'POST')
end

function CheckBlack()
    PerformHttpRequest(private.apiLink .. '?type=checkblacklist&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&hwid=' .. "FIVEM", function(code, res, headers)
		if code == 200 then
			local json = json.decode(res)
            if json.success then
                return true
            else
                return false
            end
		end
	end, 'POST')
end

function Log(message)
    PerformHttpRequest(private.apiLink .. '?type=log&name=' .. name .. '&ownerid=' .. ownerid .. '&sessionid=' .. private.sessionid .. '&pcname=' .. pcname .. '&message=' .. message, function(code, res, headers)
		if code == 200 then

		end
	end, 'POST')
end

--[[
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then 
        return;
    end
    print("^2[KeyAuth-FiveM-Example]:^7 Created by mazkdevf, https://keyauth.win/");
end)
--]]