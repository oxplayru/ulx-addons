function ulx.disable_spray( calling_ply, target_plys, t, spray )
	local players = player.GetAll()
	if (t == 0) then
		bantime = 32503680000 -- 1/1/3000 Futurama
	else
		bantime = os.time() + t * 60;
	end

	for i=1, #target_plys do
		local v = target_plys[ i ]
		if (!spray) then
			v:SetPData( "sprayoff", bantime )
		else
			v:RemovePData( "sprayoff" )
		end

	end

	if not spray then
		ulx.fancyLogAdmin( calling_ply, "#A отключил возможность ставить спрэи игроку #T до " .. os.date( "%X - %d/%m/%Y" , bantime ) , target_plys )
	else
		ulx.fancyLogAdmin( calling_ply, "#A включил возможность ставить спрэи игроку #T", target_plys )
	end
	
end

local function sprayHook( ply )
	if !ply:GetPData("sprayoff") then return end
	if !ply.infoCooldown then ply.infoCooldown = 0 end
	if (tonumber(ply:GetPData("sprayoff")) > os.time())  then
		if(ply.infoCooldown < CurTime()) then
			ply:ChatPrint( "Вам запрещено ставить спрэи ( Дата окончания " ..  os.date( "%X - %d/%m/%Y" , tonumber(ply:GetPData("sprayoff")) ) .. ")."  )
			ply.infoCooldown = CurTime() + 2
		end
		
		return true
	end
end


local spray = ulx.command( "Prop Hunt", "ulx sprayoff", ulx.disable_spray, "!sprayoff" )
spray:addParam{ type=ULib.cmds.PlayersArg }
spray:addParam{ type=ULib.cmds.NumArg, min=0, default=1440, hint="minutes", ULib.cmds.allowTimeString, ULib.cmds.optional }
spray:addParam{ type=ULib.cmds.BoolArg, invisible=true, default = false }
spray:defaultAccess( ULib.ACCESS_ADMIN )
spray:help( "Выключает спрэи." )
spray:setOpposite( "ulx sprayon", {_, _, _, true}, "!sprayon" )

hook.Add( "PlayerSpray", "DisablePlayerSpray", sprayHook )