
if (SERVER) then
	resource.AddFile( "resource/fonts/VCR_OSD_MONO.ttf" ) 
	resource.AddFile( "resource/fonts/runescape_uf.ttf" ) 
end

if (CLIENT) then
	surface.CreateFont("VCR", {
		font = "RuneScape UF",  
		size = ScrW()*0.02, 
		weight = 10, 
		blursize = 0, 
		scanlines = 2.5, 
		antialias = false
	})
	
	surface.CreateFont("VCREntity", {
		font = "RuneScape UF",  
		size = ScrW()*0.02, 
		weight = 10, 
		blursize = 0, 
		antialias = false
	})
	
	surface.CreateFont("VCRBig", {
		font = "RuneScape UF",  
		size = ScrW()*0.1, 
		weight = 9000, 
		blursize = 0,
		scanlines = 2.5, 
		antialias = false
	})
	
	local W, H = ScrW(), ScrH()
	NTime, NFan, NDisk = CurTime(), CurTime(), CurTime() 	

	------------------
	-- PASSWORD BAR --
	------------------
	function LauchSecurity( ent, code , special)
		if not ent then return end
		PASSWORD, BarLength, ShowError = code.Password, "", false
		surface.PlaySound("bin/UI_Hacking_PassBad.wav")
		
		if Security then Security:Remove() end
	
		Security = vgui.Create( "DFrame" )
		Security:SetPos( 0, 0 )
		Security:SetSize( W, H )
		Security:SetTitle( "" )
		Security:ShowCloseButton(false)
		Security:SetDraggable( false )  
		Security:MakePopup()

		Security.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )
			draw.DrawText( "ENTER PASSWORD", "VCR", ScrW() * 0.5, ScrH() * 0.4, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )			
			draw.DrawText( "_______________", "VCR", ScrW() * 0.5, ScrH() * 0.41, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )
			draw.DrawText( "_______________", "VCR", ScrW() * 0.5, ScrH() * 0.37, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )
		
			if (ShowError) then
				draw.DrawText( "WRONG PASSWORD", "VCR", ScrW() * 0.5, ScrH() * 0.35, Color( 255, 0, 0, math.random(230,255) ), TEXT_ALIGN_CENTER )			
			end
		end
		
		Security.Think = function()
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end		

			if ent:GetNWBool("IsWorking") == false then
				Load:Remove()
				ErrorTerminal()
			end
			if (code.Message) then
				if ent:GetNWBool("CardInsert") == false then
					Load:Remove()
				end	
			end			
		end
		
		if (code) then
			if not code.Password then
				Security:Remove()
				LoadingBar( ent, code )
			end
		end

		local PasswordEntry = vgui.Create( "DTextEntry", Security ) 
		PasswordEntry:SetPos( W*0.35, H*0.46 )
		PasswordEntry:SetSize( W*0.3, H*0.05 )
		PasswordEntry:SetText( "" )
		PasswordEntry:SetDrawBorder(true)
		PasswordEntry:RequestFocus() 
		PasswordEntry.OnLoseFocus = function(PanelVar)
			PasswordEntry:RequestFocus() 
		end
		PasswordEntry.OnChange = function()
			surface.PlaySound("bin/char" .. math.random(1,5) .. ".wav")
		end
		PasswordEntry.Paint = function()
			draw.DrawText( "> " .. string.upper(PasswordEntry:GetValue()) .. " <", "VCR", ScrW() * 0.15, 0, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )
		end 
		
		PasswordEntry.OnEnter = function()
			surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav")
			if string.upper(PasswordEntry:GetValue()) == string.upper(PASSWORD) then
				surface.PlaySound("bin/passgood.wav")
				Security:Remove()
				if (special) then
					if special == 1 then
						WriteDisk( ent, code )
					elseif special == 2 then
						NameManage( ent, code )
					elseif special == 3 then
						PasswordManage( ent, code )
					end
				else
					LoadingBar( ent, code )
				end
			else
				surface.PlaySound("bin/passbad.wav")
				ShowError = true
				PasswordEntry:SetText( "" )
			end
		end
		
		local Close = vgui.Create( "DButton", Security )
		Close:SetPos( W*0.9, H*0.9 )
		Close:SetText( "CLOSE" )
		Close:SetFont( "VCR" )
		Close:SetDrawBorder( false )
		Close:SetDrawBackground( false )
		Close:SetTextColor( Color(255, 255, 255, 255) )
		Close:SetSize( W*0.1, H*0.1 )
		Close.DoClick = function()
			Security:Remove()
			ChoiceTerminal(ent, code)
		end	
		
	end

	------------------
	-- LOADING BAR --
	------------------
	function LoadingBar( ent, code )
		if not ent then return end
		LoadBase = CurTime()
		LoadPourcent = CurTime()
		surface.PlaySound("bin/load/"..math.random(1,3)..".wav")
		Pourcent = 0
	
		if Load then Load:Remove() end
	
		Load = vgui.Create( "DFrame" )
		Load:SetPos( 0, 0 )
		Load:SetSize( W, H )
		Load:SetTitle( "" )
		Load:ShowCloseButton(false)
		Load:SetDraggable( false )  
		Load:MakePopup()

		Load.Paint = function()
			LoadPourcent = ( CurTime() - LoadBase )
			if LoadPourcent <= 4 then
				if math.random(1,100) < 80 then
					Pourcent = LoadPourcent / 4 * W*0.6
				end
			elseif LoadPourcent > 4 then
				Pourcent = W*0.6
			end
			
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )

			draw.RoundedBox( 0, W*0.2, H*0.475, W*0.6, H*0.05, Color(50,50,50,255) ) 
			draw.RoundedBox( 0, W*0.2, H*0.475, Pourcent, H*0.05, Color(255 - (LoadPourcent / 4 * 255),LoadPourcent / 4 * 255,0,math.random(230,255)) ) 
				
			draw.DrawText( "DECODING IN PROGRESS (" .. math.Round(LoadPourcent / 4 * 100) .. ")%", "VCR", ScrW() * 0.5, ScrH() * 0.4, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )
			
			if (LoadPourcent / 4 * 100) > 100 then
				surface.PlaySound("bin/under/00002a00.wav")
				Load:Remove()
				if (code) then
					OpenTerminal( ent, code )
				else
					OpenTerminal( ent )
				end
			end			
		end
		
		Load.Think = function()
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end

			if ent:GetNWBool("IsWorking") == false then
				Load:Remove()
				ErrorTerminal()
			end
			
		end
		
	end

	----------------
	--- TERMINAL ---
	----------------
	function OpenTerminal( ent, code )
		if not ent then return end
		if Terminal then Terminal:Remove() end   
		
		if (not code.Author) or (not code.Message) or (not code.Size) then
			code = {}
			code.Author = "???" 
			code.Message = "Memory is corrupted, it is not possible to read the contents.\n(ERROR 0x01) Memory is empty or corrupt"
			code.Size = 10
		end
		Text = ""
		
		Terminal = vgui.Create( "DFrame" )
		Terminal:SetPos( 0, 0 )
		Terminal:SetSize( W, H )
		Terminal:SetTitle( "" )
		Terminal:SetDraggable( false )
		Terminal:ShowCloseButton(false)
		Terminal:MakePopup()

		Terminal.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )
			draw.DrawText( "PROGRAM: READING (" .. code.Author .. ")", "VCR", ScrW() * 0.5, ScrH() * 0.025, Color( 200, 220, 200, 255 ), TEXT_ALIGN_CENTER )
		end
		
		Terminal.Think = function()
			if CurTime() > NTime then
				if #Text < #code.Message then
					Text = Text .. code.Message[#Text + 1]
					TText:SetText(Text)
					surface.PlaySound("bin/beep.wav")
				end
				TText:SetTextColor( Color( 255, math.random(230,255), 255, 255 ) ) 
				NTime = CurTime() + 0.05
			end
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end
			
			if ent:GetNWBool("IsWorking") == false then
				Terminal:Remove()
				ErrorTerminal()
			end
			
			if (code.Message) then
				if ent:GetNWBool("CardInsert") == false then
					Terminal:Remove()
				end	
			end
		end
		TText = vgui.Create( "DLabel", Terminal )
		TText:SetPos( 40, H*0.1 )
		TText:SetSize( W - 80, H * 0.9 )
		TText:SetTextColor( Color( 255, 255, 255, 255 ) )
		TText:SetAutoStretchVertical( true )
		TText:SetFont( "VCR" )
		TText:SetText( "" )
		
		local Close = vgui.Create( "DButton", Terminal )
		Close:SetPos( W*0.9, H*0.9 )
		Close:SetText( "CLOSE" )
		Close:SetFont( "VCR" )
		Close:SetDrawBorder( false )
		Close:SetDrawBackground( false )
		Close:SetTextColor( Color(255, 255, 255, 255) )
		Close:SetSize( W*0.1, H*0.1 )
		Close.DoClick = function()
			Terminal:Remove()
			ChoiceTerminal(ent, code)
		end	
	end
	
	----------------------
	--- WRITE TERMINAL ---
	----------------------
	function WriteDisk( ent, code )
		if not ent then return end
		
		if WritePanel then WritePanel:Remove() end
	
		WritePanel = vgui.Create( "DFrame" )
		WritePanel:SetPos( 0, 0 )
		WritePanel:SetSize( W, H )
		WritePanel:SetTitle( "" )
		WritePanel:ShowCloseButton(false)
		WritePanel:SetDraggable( false )  
		WritePanel:MakePopup()

		WritePanel.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )
			draw.DrawText( "PROGRAM: WRITE ON DISC", "VCR", ScrW() * 0.5, ScrH() * 0, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )			
			draw.DrawText( "LIMIT SIZE : " .. code.Size, "VCR", ScrW(), ScrH() * 0, Color( 240, 240, 240, math.random(230,255) ), 2 )
			if #TextEntry:GetValue() <= code.Size then
				draw.DrawText( "THE SIZE : " .. #TextEntry:GetValue(), "VCR", ScrW(), ScrH() * 0.03, Color( 240, 240, 240, math.random(230,255) ), 2 )
			else
				draw.DrawText( "THE SIZE : " .. #TextEntry:GetValue(), "VCR", ScrW(), ScrH() * 0.03, Color( 255, 0, 0, math.random(230,255) ), 2 )
			end
		end
		
		WritePanel.Think = function()
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end

			if ent:GetNWBool("IsWorking") == false then
				WritePanel:Remove()
				ErrorTerminal()
			end

			if (code.Message) then
				if ent:GetNWBool("CardInsert") == false then
					WritePanel:Remove()
				end	
			end						
		end
		
		TextEntry = vgui.Create( "DTextEntry", WritePanel ) 
		TextEntry:SetPos( W*0.35, H*0.46 )
		TextEntry:SetSize( W*0.3, H*0.05 )
		TextEntry:SetText( "" )
		TextEntry:SetDrawBorder(true)
		TextEntry:SetEnterAllowed( true ) 
		TextEntry:SetMultiline(true)
		TextEntry:RequestFocus() 
		TextEntry.OnLoseFocus = function(PanelVar)
			TextEntry:RequestFocus() 
		end
		TextEntry.OnChange = function()
			surface.PlaySound("bin/char" .. math.random(1,5) .. ".wav")
			TText:SetText( TextEntry:GetValue() )
	
		end
		TextEntry.Paint = function()
		end 
		
		TextEntry.OnEnter = function()
			surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav")
		end
		
		TText = vgui.Create( "DLabel", WritePanel )
		TText:SetPos( 40, 40 )
		TText:SetSize( W - 80, H - 80 )
		TText:SetTextColor( Color( 240, 240, 240, 255 ) )
		TText:SetAutoStretchVertical( true )
		TText:SetFont( "VCR" )
		TText:SetText( "" )
		
		local Write = vgui.Create( "DButton", WritePanel )
			Write:SetPos( W*0.9, H*0.9 )
			Write:SetText( "COMPLETE" )
			Write:SetFont( "VCR" )
			Write:SetDrawBorder( false )
			Write:SetDrawBackground( false )
			Write:SetTextColor( Color(255, 255, 255, 255) )
			Write:SetSize( W*0.1, H*0.1 )
			Write.DoClick = function()
				if #TextEntry:GetValue() > code.Size then surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav") return end
				WritePanel:Remove()
				code.Message = TextEntry:GetValue()
				ChoiceTerminal(ent, code)
				surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav")
				local NTab = 
				{
					Index = "Message",
					Value = TextEntry:GetValue(),
				}
				net.Start("WriteValue")
					net.WriteEntity(ent)
					net.WriteTable(NTab)
				net.SendToServer()
				ChoiceTerminal(ent, code)
			end	
			
		local Close = vgui.Create( "DButton", WritePanel )
		Close:SetPos( W*0.9, H*0.7 )
		Close:SetText( "CANCEL" )
		Close:SetFont( "VCR" )
		Close:SetDrawBorder( false )
		Close:SetDrawBackground( false )
		Close:SetTextColor( Color(255, 255, 255, 255) )
		Close:SetSize( W*0.1, H*0.1 )
		Close.DoClick = function()
			WritePanel:Remove()
			ChoiceTerminal(ent, code)
		end	
	end
	
	
	--------------------
	-- PASSWORD PANEL --
	--------------------
	function PasswordManage( ent, code )
		if not ent then return end
		
		if PasswordPanel then PasswordPanel:Remove() end
	
		PasswordPanel = vgui.Create( "DFrame" )
		PasswordPanel:SetPos( 0, 0 )
		PasswordPanel:SetSize( W, H )
		PasswordPanel:SetTitle( "" )
		PasswordPanel:SetDraggable( false )
		PasswordPanel:ShowCloseButton(false)
		PasswordPanel:MakePopup()

		PasswordPanel.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )
			draw.DrawText( "PROGRAM: PASSWORD", "VCR", ScrW() * 0.5, ScrH() * 0, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )			
			draw.DrawText( "LIMIT SIZE : 12 ", "VCR", ScrW(), ScrH() * 0, Color( 240, 240, 240, math.random(230,255) ), 2 )
			if #PasswordEntry:GetValue() <= 12 then
				draw.DrawText( "THE SIZE : " .. #PasswordEntry:GetValue(), "VCR", ScrW(), ScrH() * 0.03, Color( 240, 240, 240, math.random(230,255) ), 2 )
			else
				draw.DrawText( "THE SIZE : " .. #PasswordEntry:GetValue(), "VCR", ScrW(), ScrH() * 0.03, Color( 255, 0, 0, math.random(230,255) ), 2 )
			end
			draw.DrawText( "> " .. string.upper(PasswordEntry:GetValue()) .. " <", "VCR", ScrW() * 0.5, ScrH() * 0.45, Color( 255, 255, 255, math.random(230,255) ), 1 )

		end
		
		PasswordPanel.Think = function()
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end	

			if ent:GetNWBool("IsWorking") == false then
				PasswordPanel:Remove()
				ErrorTerminal()
			end
			if (code.Message) then
				if ent:GetNWBool("CardInsert") == false then
					PasswordPanel:Remove()
				end	
			end			
		end
		
		PasswordEntry = vgui.Create( "DTextEntry", PasswordPanel ) 
		PasswordEntry:SetPos( W*0.35, H*0.46 )
		PasswordEntry:SetSize( W*0.3, H*0.05 )
		PasswordEntry:SetText( "" )
		PasswordEntry:SetDrawBorder(true)
		PasswordEntry:RequestFocus() 
		PasswordEntry.OnLoseFocus = function(PanelVar)
			PasswordEntry:RequestFocus() 
		end
		PasswordEntry.OnChange = function()
			surface.PlaySound("bin/char" .. math.random(1,5) .. ".wav")	
		end
		PasswordEntry.Paint = function()
		end 
		
		PasswordEntry.OnEnter = function()
			surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav")
			
			if #PasswordEntry:GetValue() > 12 then surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav") return end
			PasswordPanel:Remove()
			
			if PasswordEntry:GetValue() == "" then
				code.Password = nil
				local NTab = 
				{
					Index = "Password",
					Value = nil,
				}
				net.Start("WriteValue")
					net.WriteEntity(ent)
					net.WriteTable(NTab)
				net.SendToServer()
				ChoiceTerminal(ent, code)
			else
				code.Password = string.upper(PasswordEntry:GetValue())
				local NTab = 
				{
					Index = "Password",
					Value = string.upper(PasswordEntry:GetValue()),
				}
				net.Start("WriteValue")
					net.WriteEntity(ent)
					net.WriteTable(NTab)
				net.SendToServer()
				ChoiceTerminal(ent, code)
			end
		end
		
			local Close = vgui.Create( "DButton", PasswordPanel )
			Close:SetPos( W*0.9, H*0.9 )
			Close:SetText( "CLOSE" )
			Close:SetFont( "VCR" )
			Close:SetDrawBorder( false )
			Close:SetDrawBackground( false )
			Close:SetTextColor( Color(255, 255, 255, 255) )
			Close:SetSize( W*0.1, H*0.1 )
			Close.DoClick = function()
				PasswordPanel:Remove()
				ChoiceTerminal(ent, code)
			end	
		end
	
	---------------------
	--- NAME TERMINAL ---
	---------------------
	function NameManage( ent, code )
		if not ent then return end
		
		if NamePanel then NamePanel:Remove() end
	
		NamePanel = vgui.Create( "DFrame" )
		NamePanel:SetPos( 0, 0 )
		NamePanel:SetSize( W, H )
		NamePanel:SetTitle( "" )
		NamePanel:SetDraggable( false )
		NamePanel:ShowCloseButton(false)
		NamePanel:MakePopup()

		NamePanel.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )
			draw.DrawText( "PROGRAM: NAME", "VCR", ScrW() * 0.5, ScrH() * 0, Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )			
			draw.DrawText( "LIMIT SIZE : 35 ", "VCR", ScrW(), ScrH() * 0, Color( 240, 240, 240, math.random(230,255) ), 2 )
			if #NameEntry:GetValue() <= 35 then
				draw.DrawText( "THE SIZE : " .. #NameEntry:GetValue(), "VCR", ScrW(), ScrH() * 0.03, Color( 240, 240, 240, math.random(230,255) ), 2 )
			else
				draw.DrawText( "THE SIZE : " .. #NameEntry:GetValue(), "VCR", ScrW(), ScrH() * 0.03, Color( 255, 0, 0, math.random(230,255) ), 2 )
			end
			draw.DrawText( "> " .. NameEntry:GetValue() .. " <", "VCR", ScrW() * 0.5, ScrH() * 0.45, Color( 255, 255, 255, math.random(230,255) ), 1 )

		end
		
		NamePanel.Think = function()
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end	

			if ent:GetNWBool("IsWorking") == false then
				NamePanel:Remove()
				ErrorTerminal()
			end
			if (code.Message) then
				if ent:GetNWBool("CardInsert") == false then
					NamePanel:Remove()
				end	
			end			
		end
		
		NameEntry = vgui.Create( "DTextEntry", NamePanel ) 
		NameEntry:SetPos( W*0.35, H*0.46 )
		NameEntry:SetSize( W*0.3, H*0.05 )
		NameEntry:SetText( "" )
		NameEntry:SetDrawBorder(true)
		NameEntry:RequestFocus() 
		NameEntry.OnLoseFocus = function(PanelVar)
			NameEntry:RequestFocus() 
		end
		NameEntry.OnChange = function()
			surface.PlaySound("bin/char" .. math.random(1,5) .. ".wav")	
		end
		NameEntry.Paint = function()
		end 
		
		NameEntry.OnEnter = function()
			if #NameEntry:GetValue() > 16 then surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav") return end
			NamePanel:Remove()
			surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav")
			if NameEntry:GetValue() == "" then
				code.Author = "---"
				local NTab = 
				{
					Index = "Author",
					Value = "---",
				}
				net.Start("WriteValue")
					net.WriteEntity(ent)
					net.WriteTable(NTab)
				net.SendToServer()
				ChoiceTerminal(ent, code)
			else
				code.Author = NameEntry:GetValue()
				local NTab = 
				{
					Index = "Author",
					Value = NameEntry:GetValue(),
				}
				net.Start("WriteValue")
					net.WriteEntity(ent)
					net.WriteTable(NTab)
				net.SendToServer()
				ChoiceTerminal(ent, code)
			end
		end
		
			local Close = vgui.Create( "DButton", NamePanel )
			Close:SetPos( W*0.9, H*0.9 )
			Close:SetText( "CLOSE" )
			Close:SetFont( "VCR" )
			Close:SetDrawBorder( false )
			Close:SetDrawBackground( false )
			Close:SetTextColor( Color(255, 255, 255, 255) )
			Close:SetSize( W*0.1, H*0.1 )
			Close.DoClick = function()
				NamePanel:Remove()
				ChoiceTerminal(ent, code)
			end	
		end
	
	-----------------------
	--- CHOICE TERMINAL ---
	-----------------------
	function ChoiceTerminal( ent, code )
		if not ent then return end
		if Terminal then Terminal:Remove() end   
		
		Terminal = vgui.Create( "DFrame" )
		Terminal:SetPos( 0, 0 )
		Terminal:SetSize( W, H )
		Terminal:SetTitle( "" )
		Terminal:SetDraggable( false )
		Terminal:ShowCloseButton(false)
		Terminal:MakePopup()

		Terminal.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(8,59,84,255) )
			if code.Message == nil then
				draw.DrawText( "DISC NOT FOUND", "VCRBig", ScrW() * 0.5, ScrH() * 0.05, Color( 240, 0, 0, math.random(200,255) ), TEXT_ALIGN_CENTER )
				draw.DrawText( "INSERT DISC", "VCR", ScrW() * 0.5, ScrH() * 0.45, Color( 255, 255, 255, math.random(200,255) ), TEXT_ALIGN_CENTER )
			end
		end
		
		Terminal.Think = function()
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,3)
			end
			if ent:GetNWBool("IsWorking") == false then
				Terminal:Remove()
				ErrorTerminal()
			end
			if (code.Message) then
				if ent:GetNWBool("CardInsert") == false then
					Terminal:Remove()
				end	
			end
		end

		if (code.Message) then
			local Read = vgui.Create( "DButton", Terminal )
			Read:SetPos( W*0.4, H*0.35 )
			Read:SetText( "READ DISC" )
			Read:SetFont( "VCR" )
			Read:SetDrawBorder( false )
			Read:SetDrawBackground( false )
			Read:SetTextColor( Color(255, 255, 255, 255) )
			Read:SetSize( W*0.2, H*0.05 )
			Read.DoClick = function()
				Terminal:Remove()
				LauchSecurity(ent, code)
			end
			Read.OnCursorEntered = function()
				Read:SetTextColor( Color(0, 230, 0, 255) )
			end
			Read.OnCursorExited = function()
				Read:SetTextColor( Color(255, 255, 255, 255) )
			end
			
			local Write = vgui.Create( "DButton", Terminal )
			Write:SetPos( W*0.4, H*0.45 )
			Write:SetText( "RECORD TO DISC" )
			Write:SetFont( "VCR" )
			Write:SetDrawBorder( false )
			Write:SetDrawBackground( false )
			Write:SetTextColor( Color(255, 255, 255, 255) )
			Write:SetSize( W*0.2, H*0.05 )
			Write.DoClick = function()
				Terminal:Remove()
				if code.Password then
					LauchSecurity(ent, code, 1)
				else
					WriteDisk(ent, code)
				end
			end
			Write.OnCursorEntered = function()
				Write:SetTextColor( Color(0, 230, 0, 255) )
			end
			Write.OnCursorExited = function()
				Write:SetTextColor( Color(255, 255, 255, 255) )
			end	
			
			local Name = vgui.Create( "DButton", Terminal )
			Name:SetPos( W*0.4, H*0.4 )
			Name:SetText( "RENAME DISC" )
			Name:SetFont( "VCR" )
			Name:SetDrawBorder( false )
			Name:SetDrawBackground( false )
			Name:SetTextColor( Color(255, 255, 255, 255) )
			Name:SetSize( W*0.2, H*0.05 )
			Name.DoClick = function()
				Terminal:Remove()
				if code.Password then
					LauchSecurity(ent, code, 2)
				else
					NameManage(ent, code)
				end
			end
			Name.OnCursorEntered = function()
				Name:SetTextColor( Color(0, 230, 0, 255) )
			end
			Name.OnCursorExited = function()
				Name:SetTextColor( Color(255, 255, 255, 255) )
			end	
			
			local Protect = vgui.Create( "DButton", Terminal )
			Protect:SetPos( W*0.4, H*0.5 )
			Protect:SetText( "PROTECT DISC" )
			Protect:SetFont( "VCR" )
			Protect:SetDrawBorder( false )
			Protect:SetDrawBackground( false )
			Protect:SetTextColor( Color(255, 255, 255, 255) )
			Protect:SetSize( W*0.2, H*0.05 )
			Protect.DoClick = function()
				Terminal:Remove()
				if code.Password then
					LauchSecurity(ent, code, 3)
				else
					PasswordManage(ent, code)
				end
			end
			Protect.OnCursorEntered = function()
				Protect:SetTextColor( Color(0, 230, 0, 255) )
			end
			Protect.OnCursorExited = function()
				Protect:SetTextColor( Color(255, 255, 255, 255) )
			end
			
			local Eject = vgui.Create( "DButton", Terminal )
			Eject:SetPos( W*0.4, H*0.55 )
			Eject:SetText( "REMOVE DISC" )
			Eject:SetFont( "VCR" )
			Eject:SetDrawBorder( false )
			Eject:SetDrawBackground( false )
			Eject:SetTextColor( Color(255, 255, 255, 255) )
			Eject:SetSize( W*0.2, H*0.05 )
			Eject.DoClick = function()
				Terminal:Remove()
				net.Start("EjectDisk")
					net.WriteEntity(ent)
				net.SendToServer()

			end
			Eject.OnCursorEntered = function()
				Eject:SetTextColor( Color(0, 230, 0, 255) )
			end
			Eject.OnCursorExited = function()
				Eject:SetTextColor( Color(255, 255, 255, 255) )
			end
			
			local Close = vgui.Create( "DButton", Terminal )
			Close:SetPos( W*0.4, H*0.6 )
			Close:SetText( "CLOSE" )
			Close:SetFont( "VCR" )
			Close:SetDrawBorder( false )
			Close:SetDrawBackground( false )
			Close:SetTextColor( Color(255, 255, 255, 255) )
			Close:SetSize( W*0.2, H*0.05 )
			Close.DoClick = function()
				Terminal:Remove()
			end
			Close.OnCursorEntered = function()
				Close:SetTextColor( Color(0, 230, 0, 255) )
			end
			Close.OnCursorExited = function()
				Close:SetTextColor( Color(255, 255, 255, 255) )
			end
		else
			local Close = vgui.Create( "DButton", Terminal )
			Close:SetPos( W*0.4, H*0.95 )
			Close:SetText( "CLOSE" )
			Close:SetFont( "VCR" )
			Close:SetDrawBorder( false )
			Close:SetDrawBackground( false )
			Close:SetTextColor( Color(255, 255, 255, 255) )
			Close:SetSize( W*0.2, H*0.05 )
			Close.DoClick = function()
				Terminal:Remove()
			end
			Close.Think = function()
				if ent:GetNWBool("CardInsert") then
					Terminal:Remove()
				end
			end
		end
	end
	
	---------------------
	-- BROKEN TERMINAL --
	---------------------
	function ErrorTerminal( code )
		local NError, NErrorAlpha, LT = CurTime(), 255, CurTime()
		ERROR = vgui.Create( "DFrame" )
		ERROR:SetPos( 0, 0 )
		ERROR:SetSize( W, H )
		ERROR:SetTitle( "" )
		ERROR:ShowCloseButton(false)
		ERROR:SetDraggable( false )  
		ERROR:MakePopup()

		ERROR.Paint = function()
			draw.RoundedBox( 0, 0, 0, W, H, Color(math.random(0,8),math.random(0,59),math.random(0,84),255) )
			draw.DrawText( "DECODING IN PROGRESS (" .. math.Round(math.random(0,100)) .. ")%", "VCR", ScrW() * 0.5, ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), TEXT_ALIGN_CENTER )
			draw.DrawText( "(ERROR 0x00)", "VCR", math.random(0,10), ScrH() * (math.random(0,100)*0.01), Color( 240, 100, 100, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.7 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.62 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,1), "VCR", W * 0.22 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.38 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,1), "VCR", W * 0.9 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.35 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.98 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.8 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.73 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.27 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,1), "VCR", W * 0.1 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.05 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.11 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,1), "VCR", W * 0.75 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.8 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,1), "VCR", W * 0.2 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0.1 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( math.random(0,999), "VCR", W * 0 + math.random(0,50), ScrH() * (math.random(0,100)*0.01), Color( 240, 240, 240, math.random(230,255) ), 0 )
			draw.DrawText( "ERROR", "VCRBig", ScrW() * 0.5 + math.random(-5,5), ScrH() * 0.4 + math.random(-5,5), Color( 255, 0, 0, NErrorAlpha ), TEXT_ALIGN_CENTER )
		
			draw.RoundedBox( 0, 0, math.random(0,W), W, H*0.001, Color(255,255,255,math.random(0,255) ) )
			draw.RoundedBox( 0, 0, math.random(0,W), W, H*0.001, Color(255,255,255,math.random(0,255) ) )
			draw.RoundedBox( 0, 0, math.random(0,W), W, H*0.001, Color(255,255,255,math.random(0,255) ) )
			draw.RoundedBox( 0, 0, math.random(0,W), W, H*0.001, Color(255,255,255,math.random(0,255) ) )
			draw.RoundedBox( 0, 0, math.random(0,W), W, H*0.001, Color(255,255,255,math.random(0,255) ) )
		end
		
		ERROR.Think = function()
			local dt = CurTime() - LT
			if NErrorAlpha > 0 then
				NErrorAlpha = NErrorAlpha - 255 * dt
			end
			if CurTime() > NFan then
				surface.PlaySound("bin/fan3.wav")
				NFan = CurTime() + 1
			end
			if CurTime() > NDisk then
				surface.PlaySound("bin/disk/"..math.random(1,14)..".wav")
				NDisk = CurTime() + math.random(0,1)
			end
			if CurTime() > NError then
				surface.PlaySound("bin/passbad.wav")
				NError = CurTime() + 1
				NErrorAlpha = 255
			end
			LT = CurTime()
		end
		
		local Close = vgui.Create( "DButton", ERROR )
		Close:SetPos( 0, 0 )
		Close:SetText( "" )
		Close:SetDrawBorder( false )
		Close:SetDrawBackground( false )
		Close:SetTextColor( Color(255, 255, 255, 255) )
		Close:SetSize( W, H )
		Close.DoClick = function()
			ERROR:Remove()
		end
		
	end

	local Alpha, DN = 0, "???"
	hook.Add( "HUDPaint", "TerminalHUD", function()
		local tr = LocalPlayer():GetEyeTrace()
		if tr.Entity == NULL then return end
		if string.sub(tr.Entity:GetClass(),0 ,8) == "diskcard" then
			Alpha = math.Clamp(Alpha + 10, 0 , 255)
			DN = tr.Entity:GetNWString("DN")
		else
			Alpha = math.Clamp(Alpha - 10, 0 , 255)		
		end
		draw.DrawText( DN, "VCREntity", ScrW() * 0.5, ScrH() * 0.7, Color( 255, 255, 255, Alpha ), TEXT_ALIGN_CENTER )
	end )
	
	
	net.Receive("OpenTerminal", function()
		local code = net.ReadTable()
		local NEnt = net.ReadEntity()
		ChoiceTerminal( NEnt, code )
	end)

	net.Receive("OpenError", function()
		ErrorTerminal()
	end)
	
end
