--------------------------------------------------------------------------------------------------------
--          _____                    _____                    _____                    _____          --
--         /\    \                  /\    \                  /\    \                  /\    \         --
--        /::\    \                /::\____\                /::\____\                /::\    \        --
--       /::::\    \              /::::|   |               /::::|   |               /::::\    \       --
--      /::::::\    \            /:::::|   |              /:::::|   |              /::::::\    \      --
--     /:::/\:::\    \          /::::::|   |             /::::::|   |             /:::/\:::\    \     --
--    /:::/  \:::\    \        /:::/|::|   |            /:::/|::|   |            /:::/__\:::\    \    --
--   /:::/    \:::\    \      /:::/ |::|   |           /:::/ |::|   |           /::::\   \:::\    \   --
--  /:::/    / \:::\    \    /:::/  |::|___|______    /:::/  |::|___|______    /::::::\   \:::\    \  --
-- /:::/    /   \:::\ ___\  /:::/   |::::::::\    \  /:::/   |::::::::\    \  /:::/\:::\   \:::\____\ --
--/:::/____/  ___\:::|    |/:::/    |:::::::::\____\/:::/    |:::::::::\____\/:::/  \:::\   \:::|    |--
--\:::\    \ /\  /:::|____|\::/    / ~~~~~/:::/    /\::/    / ~~~~~/:::/    /\::/    \:::\  /:::|____|--
-- \:::\    /::\ \::/    /  \/____/      /:::/    /  \/____/      /:::/    /  \/_____/\:::\/:::/    / --
--  \:::\   \:::\ \/____/               /:::/    /               /:::/    /            \::::::/    /  --
--   \:::\   \:::\____\                /:::/    /               /:::/    /              \::::/    /   --
--    \:::\  /:::/    /               /:::/    /               /:::/    /                \::/____/    --
--     \:::\/:::/    /               /:::/    /               /:::/    /                  ~~          --
--      \::::::/    /               /:::/    /               /:::/    /                               --
--       \::::/    /               /:::/    /               /:::/    /                                --
--        \::/____/                \::/    /                \::/    /                                 --
--                                  \/____/                  \/____/                                  --
--------------------------------------------------------------------------------------------------------

hook.Add("OnPlayerChat", "ChatOpenAdminMenu", function(ply, text, teamChat, isDead)
    if ply ~= LocalPlayer() then return end  -- Только для своего клиента
    if not ply:IsAdmin() then return end     -- Только админы могут открыть

    text = string.lower(text)

    if text == "/music" then
        ToggleMenu()  -- Функция, которая уже у тебя есть
        return ""     -- Убирает текст из чата
    end
end)

fltSongTime = 0
ShouldBeStopped = true
TogKeyReceived = false
GlobalPassReceived = false
DoResReceived = false

local function StopSongLocal()
if PlayingSong and PlayingSong:IsValid() then
	PlayingSong:Stop()
	end
	ShouldBeStopped = true
end

function InitMenu() --Building the menu

	MainPanel = vgui.Create( "DFrame" )
	MainPanel:SetPos( ScrW()/2 - 275, ScrH()/2 - 300 ) --Centre
	MainPanel:SetSize( 550, 650 )
	MainPanel:SetTitle( "Garry's Mod Music Player v3.7" )
	MainPanel:SetVisible( false ) --Build happens on load
	MainPanel:SetDraggable( true ) --Can be moved around the screen
	MainPanel:ShowCloseButton( true )
	MainPanel:MakePopup() --Gives the menu control of the mouse
	MainPanel:SetDeleteOnClose( false ) --The menu will be hidden on close
		
		
	TabSheet = vgui.Create( "DPropertySheet", MainPanel ) --This is for having tabs
	TabSheet:SetSize( 500, 600 )
	TabSheet:SetPos( 25 , 30 ) 
		
		
	HomeTab = vgui.Create( "DPanel" )
	HomeTab:SetSize( 500, 600 )
	HomeTab.Paint = function()
		surface.SetDrawColor( 255, 255, 255, 0 ) --Transparent background
	end
		
		
	SettingsTab = vgui.Create( "DPanel" )
	SettingsTab:SetSize( 500, 600 )
	SettingsTab.Paint = function()
		surface.SetDrawColor( 255, 255, 255, 0 ) --Transparent background
	end
		
		
	btnStop = vgui.Create( "DImageButton", HomeTab ) --Creating a button on the HomeTab
	btnStop:SetImage( "vgui/gmmp/stop.png" )
	btnStop:SetPos( 75, 448 )
	btnStop:SetSize( 128, 128 )
	btnStop.OnMousePressed = function()
		btnStop:SetImage( "vgui/gmmp/stop_clicked.png" )
	end


		
	btnStop.OnMouseReleased = function()
		StopSongLocal()
		btnStop:SetImage("vgui/gmmp/stop.png")

		net.Start("GMMP_StopAll")
		net.SendToServer()
	end

	net.Receive("GMMP_StopAll", function()
		StopSongLocal()
	end)
				
		
	FunctionCalled = true
		
		
	btnPlay = vgui.Create( "DImageButton", HomeTab )
	btnPlay:SetImage( "vgui/gmmp/play.png" )
	btnPlay:SetPos( 297, 448 )
	btnPlay:SetSize( 128, 128 )
	btnPlay.OnMousePressed = function()
		btnPlay:SetImage( "vgui/gmmp/play_clicked.png" )
	end
		
	btnPlay.OnMouseReleased = function()
		if !(SelectedList():GetSelectedLine()) then --No line selected
			chat.AddText("Make a song selection please")
				
		elseif !FunctionCalled then
			RunConsoleCommand( "stopsound" )
			--timer.Destroy( "GMMPAutoPlay" )
			chat.AddText("Something went terribly wrong with the last song. Everything is fixed now and you can play songs again") --Error
			FunctionCalled = true
			ShouldBeStopped = true
				
		else
			StopSongLocal()
			ShouldBeStopped = true
				
			local intIndex = SelectedList():GetSelectedLine() --Gets the index value of the currently selected line
			local strFile = SelectedListFilePaths()[intIndex] --Gets the filepath
				
			if string.find(strFile, " .", 1, true) or string.find(strFile, ". ", 1, true) then
				chat.AddText("ERROR: Song names with a period and a space beside eachother will not work. Please remove the period from the song name. (Blame Garry)")
			elseif string.find(strFile, "  ", 1, true) then
				chat.AddText("ERROR: Song names with a double space will not work. Please remove one of the spaces from the song name. (Blame Garry)")
			elseif PlayGlobal:GetInt() >= 1 and !(game.SinglePlayer()) then --Play to everyone
				blnSendingAdmin = true
				
				net.Start( "PlayGlobal" )
					net.WriteString( PlayGlobalPass:GetString() )
					net.WriteString( strFile )
				net.SendToServer()
			else
				PlaySong( strFile, true )

				chat.AddText("Now Playing: ", FilePathToSongName( strFile ) ) --Song name
			end
		end
			
		btnPlay:SetImage( "vgui/gmmp/play.png" )
	end
	
	lblScrubbingBar = vgui.Create( "DLabel", HomeTab )
	lblScrubbingBar:SetPos( 50, 360 )
	lblScrubbingBar:SetText( "_________________________________________________________________" )
	lblScrubbingBar:SizeToContents()

	sldScrubbing = vgui.Create( "DSlider", HomeTab )
	sldScrubbing:SetPos( 50, 360 )
	sldScrubbing:SetSize( 390, 20 )
	sldScrubbing:SetSlideX( 0 )
	sldScrubbing.OnValueChanged = function() 
		if sldScrubbing:IsEditing() and PlayingSong:IsValid() then
			PlayingSong:SetTime( PlayingSong:GetLength() * sldScrubbing:GetSlideX() )
		end
	end
	
	lblScrubbingCurTime = vgui.Create ( "DLabel", HomeTab )
	lblScrubbingCurTime:SetPos( 15, 360 )
	lblScrubbingCurTime:SetText( "00:00" )
	lblScrubbingCurTime:SizeToContents()
	
	lblScrubbingTotTime = vgui.Create ( "DLabel", HomeTab )
	lblScrubbingTotTime:SetPos( 450, 360 )
	lblScrubbingTotTime:SetText( "00:00" )
	lblScrubbingTotTime:SizeToContents()
		
	sldVolume = vgui.Create( "DNumSlider", HomeTab )
	sldVolume:SetPos( -110, 432 )
	sldVolume:SetWide( 400 )
	sldVolume:SetMin( 0 )
	sldVolume:SetMax( 100 )
	sldVolume:SetDecimals( 0 ) --Whole numbers
	sldVolume:SetConVar( "gmmp_volume" )
	if Volume:GetFloat() == Volume:GetInt() then --Checking if already an integer because rounding has broken decimal spaces
		sldVolume:SetValue( Volume:GetInt() )
	else
		sldVolume:SetValue( math.Round( Volume:GetFloat() ) ) --Have it take the previous value for volume that was saved. rounding because floats have inaccuracies and make huge decimals
	end
	
	lblVolume = vgui.Create( "DLabel", HomeTab )
	lblVolume:SetPos( 15, 440 )
	lblVolume:SetText( "Volume" )
	lblVolume:SizeToContents()
	
		
	chkAutoPlay = vgui.Create( "DCheckBoxLabel", HomeTab )
	chkAutoPlay:SetPos( 330, 440 )
	chkAutoPlay:SetText( "Auto Play" )
	chkAutoPlay:SetConVar( "gmmp_autoplay" )
	chkAutoPlay:SetValue( AutoPlay:GetInt() ) --Have it take the saved value
	chkAutoPlay:SizeToContents()
		
		
	FullSongList = vgui.Create( "DListView", HomeTab )
	FullSongList:SetPos( 100, 45 )
	FullSongList:SetSize( 300, 300 )
	FullSongList:SetMultiSelect( false )
	FullSongList:AddColumn( "Songs" )
	FullSongList.DoDoubleClick = function()
		
		FavouritesSelected:SetInt( 0 )
		btnToggleList:SetText( "Play from Favourites" )
		btnPlay.OnMouseReleased()
	end
		
	FavouritesList = vgui.Create( "DListView", HomeTab )
	FavouritesList:SetPos( 255, 45 )
	FavouritesList:SetSize( 220, 300 )
	FavouritesList:SetMultiSelect( false )
	FavouritesList:AddColumn( "Favourites" )
	FavouritesList.DoDoubleClick = function()
	
		FavouritesSelected:SetInt( 1 )
		btnToggleList:SetText( "Play from Song List" )
		btnPlay.OnMouseReleased()
	end

		
	btnToggleList = vgui.Create( "DButton", HomeTab )
	btnToggleList:SetPos( 175, 15 )
	btnToggleList:SetSize( 150, 25 )
	if FavouritesList == SelectedList() then
		btnToggleList:SetText( "Play from Song List" )
	else
		btnToggleList:SetText( "Play from Favourites" )
	end
		
	btnToggleList.DoClick = function()
		if FavouritesList == SelectedList() then --Change which list is selected
			FavouritesSelected:SetInt( 0 )
			btnToggleList:SetText( "Play from Favourites" )
		else
			FavouritesSelected:SetInt( 1 )
			btnToggleList:SetText( "Play from Song List" )
		end
	end

		
	btnAddToFav = vgui.Create( "DButton", HomeTab )
	btnAddToFav:SetText( "Add to Favourites >>" )
	btnAddToFav:SetPos( 25, 15 )
	btnAddToFav:SetSize( 150, 25 )
	btnAddToFav.DoClick = function()
		
		local intIndex = FullSongList:GetSelectedLine()
			
		if intIndex then --If a song is selected
			local strFilePath =  SongFilePaths[intIndex] --Gets filepath from the parallel table
			local strSongName = FullSongList:GetLine(intIndex):GetValue(1) --Gets the Song Name from the FullSongList
			
			table.insert( FavouritesFilePaths, strFilePath )
			FavouritesList:AddLine( strSongName )
			
		else
			chat.AddText("Make a song selection please")
		end
		
		SaveFavouritesList()
	end
		
		
	btnRemoveFromFav = vgui.Create( "DButton", HomeTab )
	btnRemoveFromFav:SetText( "<< Remove from Favourites" )
	btnRemoveFromFav:SetPos( 325, 15 )
	btnRemoveFromFav:SetSize( 150, 25 )
	btnRemoveFromFav.DoClick = function()
		
		local intIndex = FavouritesList:GetSelectedLine() --Index
			
		if intIndex then --If a song is selected
				
			FavouritesList:RemoveLine( intIndex )
			table.remove( FavouritesFilePaths, intIndex )
			
			--Removing a line will leave a gap in the indexing. eg. remove line 3 and line 4 will not take on line 3's numeric position. This will fix that
			local tblFixIndexing = {}
				
			for key, v in pairs( FavouritesList:GetLines() ) do
				table.insert( tblFixIndexing, v:GetValue(1) ) --Put every song into a table so the indexing is sorted
			end
				
			FavouritesList:Clear()
				
			for key, v in pairs( tblFixIndexing ) do 
				FavouritesList:AddLine( v ) --Put all the songs back in
			end
				
		else
			chat.AddText("Make a song selection please")
		end
			
		SaveFavouritesList() --Call the function to save the favourites list
	end

		
	btnShuffle = vgui.Create( "DButton", HomeTab )
	btnShuffle:SetText( "Shuffle" )
	btnShuffle:SetPos( 225, 395 )
	btnShuffle:SetSize( 50, 34 )
	btnShuffle.DoClick = function()
		local TempTable = table.Copy(SelectedListFilePaths())
			
		table.Empty( SelectedListFilePaths() )
		SelectedList():Clear()
			
		while( table.Count(TempTable) > 0 ) do
			
			local SongIndex = math.random( 1, table.Count( TempTable ) ) --Pick a random song
				
			table.insert(SelectedListFilePaths(), TempTable[SongIndex])
			SelectedList():AddLine( FilePathToSongName( TempTable[SongIndex] ) )
			
			table.remove( TempTable, SongIndex ) --Remove the song so it isn't selected again

		end
			
		ChangeSong( 1, false ) --Play the first song
	end
	
		
	btnNext = vgui.Create( "DImageButton", HomeTab )
	btnNext:SetImage( "vgui/gmmp/next.png" )
	btnNext:SetPos( 300, 395 )
	btnNext:SetSize( 32, 34 )
	btnNext.OnMouseReleased = function()
		ChangeSong( 1, true ) --Move to the next song in the list
		btnNext:SetImage( "vgui/gmmp/next.png" )
	end
		
	btnNext.OnMousePressed = function()
		btnNext:SetImage( "vgui/gmmp/next_clicked.png" )
	end
		
		
	btnPrev = vgui.Create( "DImageButton", HomeTab )
	btnPrev:SetImage( "vgui/gmmp/prev.png" )
	btnPrev:SetPos( 168, 395 )
	btnPrev:SetSize( 32, 34 )
	btnPrev.OnMouseReleased = function()
		if !PlayingSong:IsValid() or PlayingSong:GetTime() < 5 then
			ChangeSong( -1, true ) --Move back one song in the list
		else
			PlayingSong:SetTime( 0 )
		end
		btnPrev:SetImage( "vgui/gmmp/prev.png" )
	end
		
	btnPrev.OnMousePressed = function()
		btnPrev:SetImage( "vgui/gmmp/prev_clicked.png" )
	end
	
		
	AlterHomeTab() --Call the function that will hide or show the favourites list
		
	PopulateFullSongList() --Call the function to put the songs in the FullSongList
	PopulateFavouritesList() --Call the function to put the songs in the FavouritesList
	
	chkMountedSongs = vgui.Create( "DCheckBoxLabel", SettingsTab )
	chkMountedSongs:SetPos( 10, 30 )
	chkMountedSongs:SetText( "Show all mounted music" )
	chkMountedSongs:SetConVar( "gmmp_showmountedsongs" )
	chkMountedSongs:SetValue( ShowMountedSongs:GetInt() )
	chkMountedSongs:SizeToContents()
	
	--chkIncludedSongs = vgui.Create( "DCheckBoxLabel", SettingsTab )
	--chkIncludedSongs:SetPos( 10, 130 )
	--chkIncludedSongs:SetText( "Show included songs" )
	--chkIncludedSongs:SetConVar( "gmmp_showincludedsongs" )
	--chkIncludedSongs:SetValue( ShowIncludedSongs:GetInt() )
	--chkIncludedSongs:SizeToContents()
		
	chkMuteAll = vgui.Create( "DCheckBoxLabel", SettingsTab )
	chkMuteAll:SetPos( 10, 105 )
	chkMuteAll:SetText( "Mute all players" )
	chkMuteAll:SetConVar( "gmmp_muteall" )
	chkMuteAll:SetValue( MuteAll:GetInt() )
	chkMuteAll:SizeToContents()
		
	chkAllowOther = vgui.Create( "DCheckBoxLabel", SettingsTab )
	chkAllowOther:SetPos( 10, 55 )
	chkAllowOther:SetText( "Allow others to play songs" )
	chkAllowOther:SetConVar( "gmmp_allowother" )
	chkAllowOther:SetValue( AllowOther:GetInt() )
	chkAllowOther:SizeToContents()	
		
	chkFavourites = vgui.Create( "DCheckBoxLabel", SettingsTab )
	chkFavourites:SetPos( 10, 80 )
	chkFavourites:SetText( "Show favourites list" )
	chkFavourites:SetConVar( "gmmp_showfavourites" )
	chkFavourites:SetValue( ShowFavourites:GetInt() )
	chkFavourites:SizeToContents()
	
	chkGlobal = vgui.Create( "DCheckBoxLabel", SettingsTab )
	chkGlobal:SetPos( 10, 130 )
	chkGlobal:SetText( "Play to everyone" )
	chkGlobal:SetConVar( "gmmp_global" )
	chkGlobal:SetValue( PlayGlobal:GetInt() )
	chkGlobal:SizeToContents()
	
	txtClntGlobalPass = vgui.Create( "DTextEntry", SettingsTab )
	txtClntGlobalPass:SetSize( 75, 15 )
	txtClntGlobalPass:SetPos( 150, 155 )
	txtClntGlobalPass:SetConVar( "gmmp_clientglobalpass" )
	txtClntGlobalPass:SetText( PlayGlobal:GetString() )
	
	lblClntGlobalPass = vgui.Create( "DLabel", SettingsTab )
	lblClntGlobalPass:SetPos( 10, 155 )
	lblClntGlobalPass:SetText( "Play to everyone password:" )
	lblClntGlobalPass:SizeToContents()
			
			
	if game.SinglePlayer() then
		chkGlobal:SetDisabled( true )
		chkAllowOther:SetDisabled( true )
		chkMuteAll:SetDisabled( true )
		txtClntGlobalPass:SetDisabled( true )
	end
		
	TabSheet:AddSheet( "Home", HomeTab, "icon16/sound.png" )
	TabSheet:AddSheet( "Settings", SettingsTab, "icon16/wrench.png" )
		
	if LocalPlayer():IsSuperAdmin() then
		
		AdminTab = vgui.Create( "DPanel" )
		AdminTab:SetSize( 500, 600 )
		AdminTab.Paint = function()
			surface.SetDrawColor( 255, 255, 255, 0 )
		end
	
			
			
		net.Start( "RequestDoRes" )
		net.SendToServer()
		
		net.Start( "RequestTogKey" )
		net.SendToServer()
		
		net.Start( "RequestGlobalPass" )
		net.SendToServer()
			
		chkDoRes = vgui.Create( "DCheckBoxLabel", AdminTab )
		chkDoRes:SetPos( 10, 30 )
		chkDoRes:SetText( "Automatically add songs to the resource list" )
		chkDoRes:SetConVar( "gmmp_autoresource" )
		chkDoRes:SizeToContents()
		
		lblTogKey = vgui.Create( "DLabel", AdminTab )
		lblTogKey:SetPos( 10, 58 )
		lblTogKey:SetText( "Key to open the menu" )
		lblTogKey:SizeToContents()
		
		cbTogKey = vgui.Create( "DComboBox", AdminTab )
		cbTogKey:SetPos( 120, 55 )
		cbTogKey:SetSize( 50, 20 )
		cbTogKey:AddChoice( "F1" )
		cbTogKey:AddChoice( "F2" )
		cbTogKey:AddChoice( "F3" )
		cbTogKey:AddChoice( "F4" )
		function cbTogKey:OnSelect( index, value, data )
			RunConsoleCommand( "gmmp_menukey", value )
		end
		
		txtGlobalPass = vgui.Create( "DTextEntry", AdminTab )
		txtGlobalPass:SetSize( 75, 15 )
		txtGlobalPass:SetPos( 185, 85 )
		txtGlobalPass:SetConVar( "gmmp_globalpass" )
		txtGlobalPass:SetText( PlayGlobal:GetString() )

		lblGlobalPass = vgui.Create( "DLabel", AdminTab )
		lblGlobalPass:SetPos( 10, 85 )
		lblGlobalPass:SetText( "Play to everyone server password:" )
		lblGlobalPass:SizeToContents()
		
		TabSheet:AddSheet( "SuperAdmin", AdminTab, "icon16/shield.png" )
		
		if game.SinglePlayer() then
				chkDoRes:SetDisabled( true )
				txtGlobalPass:SetDisabled( true )
		end
	end
		
	--Creating console commands
	concommand.Add( "gmmp_next", function() btnNext.OnMouseReleased() end )
	concommand.Add( "gmmp_prev", function() btnPrev.OnMouseReleased() end )
	concommand.Add( "gmmp_shuffle", function() btnShuffle.DoClick() end )
	concommand.Add( "gmmp_stop", function() btnStop.OnMouseReleased() end )
	concommand.Add( "gmmp_play", function( ply, cmd, args, fullstring) 
		local arg = args[1] --Song Name
			
		if arg then
			for key, v in pairs( SongFilePaths ) do
				if FilePathToSongName(v) == arg then
					ChangeSong( key, false )
				end
			end
		else
			btnPlay.OnMouseReleased()
		end
	end, 
			
	function( cmd, arg ) --Called each time a a character is typed
		local PossibleValues = {}
		local text = string.upper(string.Trim( arg ))
			
		for k, v in pairs( SongFilePaths ) do
			if string.find( string.upper( FilePathToSongName(v) ), text ) then 
				table.insert( PossibleValues, 'gmmp_play "' .. FilePathToSongName(v) .. '"' )
			end
		end

		return PossibleValues
	end )
		
	print( "GMMP v3.7.1 loaded -- Made by Declivity http://steamcommunity.com/profiles/76561198024690138/" )
	print( "Enter gmmp_menu in console to open the menu" )
end
	
hook.Add("InitPostEntity", "MenuLoad", function() InitMenu() end)
	
function ToggleMenu()
	MainPanel:SetVisible( !(MainPanel:IsVisible()) ) --Somewhat useless for closing as you cant use the chat or key binds when the menu is open
end
	
function SelectedList()
	if FavouritesSelected:GetInt() >= 1 and ShowFavourites:GetInt() >= 1 then
		return FavouritesList
	else				
		return FullSongList
	end
end
	
function SelectedListFilePaths()
	if FavouritesSelected:GetInt() >= 1 and ShowFavourites:GetInt() >= 1 then
		return FavouritesFilePaths
	else				
		return SongFilePaths
	end
end
	
function FilePathToSongName( strFilePath )
	local tblExplodedFile = string.Explode( ".", table.GetLastValue( string.Explode( "/", strFilePath ) ) )
		
	table.remove( tblExplodedFile, table.Count( tblExplodedFile ) )
	return string.Implode( ".", tblExplodedFile)
end
	
function AlterHomeTab() --This function hides or shows the objects for favourites list depending on the user's settings
	if ShowFavourites:GetInt() >= 1 then
		FullSongList:SetSize( 220, 300 )
		FullSongList:SetPos( 25, 45 )
			
		FavouritesList:SetVisible( true )
		btnToggleList:SetVisible( true )
		btnAddToFav:SetVisible( true )
		btnRemoveFromFav:SetVisible( true )
	else
		FullSongList:SetSize( 300, 300 )
		FullSongList:SetPos( 100, 45 )
			
		FavouritesList:SetVisible( false )
		btnToggleList:SetVisible( false )
		btnAddToFav:SetVisible( false )
		btnRemoveFromFav:SetVisible( false )
	end
end

function AddAllSongs( path )
	local songs, folders = file.Find( "sound/" .. path .. "/*", "GAME" )
	local validTypes = {"mp3", "wav", "aiff", "dct", "ogg", "gsm", "flac", "au", "vox", "raw", "m4a", "wma"}
		
	for k, v in pairs( songs ) do
		
	
		if table.HasValue( validTypes, string.lower(table.GetLastValue( string.Explode(".", v) )) ) then
			table.insert( SongFilePaths, "sound/" .. path .. "/" .. v ) --Add in the file path from the sound/ directory 
		end
	end
	
	for k, v in pairs( folders ) do
		AddAllSongs( path .. "/" .. v )
	end	 
end
	
	
function PopulateFullSongList()
	
	SongFilePaths = {}
	FullSongList:Clear()
		
	if ShowMountedSongs:GetInt() >= 1 then --If the user has selected to have the sounds in the game listed too
		AddAllSongs( "music" )
	end
	
	AddAllSongs( "gmmp" )
	
	if !(ShowIncludedSongs:GetInt() >= 1) then
		table.RemoveByValue( SongFilePaths, "sound/gmmp/zirconmusic.com - across the ocean.mp3" )
	end
	
	for key, v in pairs( SongFilePaths ) do
		FullSongList:AddLine( FilePathToSongName(v) )
	end
end
	
function PopulateFavouritesList() --Function that will get the filepaths from a text files saved on the client a build a list
	if !(file.Exists( "favouriteslist.txt", "DATA" )) then
		file.Write( "favouriteslist.txt", "" )
	end
		
	local strFileContents = file.Read( "favouriteslist.txt", "DATA" )
		
	FavouritesFilePaths = util.JSONToTable( strFileContents ) --Convert string to table
		
	if !FavouritesFilePaths or !FavouritesFilePaths[1] or !(FavouritesFilePaths[1][2] == "o") then --Blank the table if it is the old matrix
		FavouritesFilePaths = {}
	end
	
	local trash = {}
	
	for k, v in pairs( FavouritesFilePaths ) do
		
		if file.Exists( v, "GAME" ) and !(v == "") then --If the song still exists
			FavouritesList:AddLine( FilePathToSongName(v) ) --Add the song name to the list
		else
			table.insert( trash, k )
		end
	end	
	
	for k, v in pairs( trash ) do
		table.remove( FavouritesFilePaths, v-k+1 ) --Remove the non-existent song's filepath
	end
end
	
function SaveFavouritesList() --Convert table to string and save as text file
	file.Write( "favouriteslist.txt", util.TableToJSON( FavouritesFilePaths ) )
end
	
function ChangeSong( LinesToMove, UseCurSelection )
	
	local CurSelection = SelectedList():GetSelectedLine() --Index value
		
	if SelectedList():GetLine(CurSelection) and (!(LinesToMove == CurSelection) or UseCurSelection) then ---Don't de-select if there is no selection already made or the selection will be the same song
		SelectedList():GetLine(CurSelection):SetSelected( false ) --Deselect last item
	end
		
	if !(SelectedList():GetLine(CurSelection)) then --If there is no selection make the index 0
		CurSelection = 0
	end
		
	--if the new selection will go off the list loop back to the other side
	if CurSelection + LinesToMove < 1 then 
		CurSelection = table.Count( SelectedListFilePaths() ) - LinesToMove
		
	elseif CurSelection + LinesToMove > table.Count( SelectedListFilePaths() ) then
		CurSelection = 0
	end
		
	if UseCurSelection then --If we are moving based on what the current selection is
		SelectedList():SelectItem( SelectedList():GetLine((CurSelection + LinesToMove)) ) --Select next item
	else
		SelectedList():SelectItem( SelectedList():GetLine(LinesToMove) ) --Select next item
	end
		
	btnPlay.OnMouseReleased() --Play the new selection
end
	
function PlayFromAdmin( song, player )
	if file.Exists( song, "GAME" ) and AllowOther:GetInt() >= 1 then
		PlaySong( song, false )
			
	elseif !file.Exists( song, "GAME" ) and AllowOther:GetInt() >= 1 then
		chat.AddText( "Blocked globally played song: File is not on client computer" )
	end
end
	
function PlaySong( song, blnAllowAutoPlay )
	FunctionCalled = false
	StopSongLocal()
	
	sound.PlayFile( song, "noblock", function( CurrentSong, ErrorID, ErrorName ) --If the game is paused this won't call
			
		PlayingSong = CurrentSong --Make it global
		CurrentSong:SetVolume( Volume:GetFloat() / 100, 0 )
		lblScrubbingTotTime:SetText( math.floor(CurrentSong:GetLength()/60) .. ":" .. string.format("%02d", math.floor(CurrentSong:GetLength() % 60) ) )
		if LastSong == song and sldScrubbing:GetSlideX() != 1 then
			PlayingSong:SetTime( PlayingSong:GetLength() * sldScrubbing:GetSlideX() )
		end
		LastSong = song
		FunctionCalled = true
		ShouldBeStopped = false
		fltSongTime = 0
			
		--if blnAllowAutoPlay or blnSendingAdmin then
			--timer.Create( "GMMPAutoPlay", CurrentSong:GetLength(), 1, function() --Setting the timer to start another song after this one ends
				--if AutoPlay:GetInt() >= 1 then
					--ChangeSong( 1, true )
				--end
			--end)
			--blnSendingAdmin = false
		--end
	end )
end

PlayGlobal = CreateClientConVar("gmmp_global", "0", false)
PlayGlobalPass =  CreateClientConVar("gmmp_clientglobalpass", "", true)
AllowOther = CreateClientConVar("gmmp_allowother", "1", true)
ShowMountedSongs = CreateClientConVar("gmmp_showmountedsongs", "0", true)
ShowIncludedSongs = CreateClientConVar( "gmmp_showincludedsongs", "1", true)
ShowFavourites = CreateClientConVar("gmmp_showfavourites", "0", true) 
Volume = CreateClientConVar("gmmp_volume", "80", true)
FavouritesSelected = CreateClientConVar("gmmp_favouritesselected", "0", true)
MuteAll = CreateClientConVar( "gmmp_muteall", "0", false )
AutoPlay = CreateClientConVar( "gmmp_autoplay", "1", true )

DoRes = CreateClientConVar( "gmmp_autoresource", "1", true )
TogKey = CreateClientConVar( "gmmp_menukey", "F4", true )
SvGlobalPass = CreateClientConVar( "gmmp_globalpass", "", true )


concommand.Add("gmmp_menu", function() ToggleMenu() end) --If gmmp_menu is typed in console the menu will open, this is useful for key binds
	
function SendNewDoRes()
	if DoResReceived then
		net.Start( "DoResChange" )
			net.WriteString( tostring( DoRes:GetInt() ) )
		net.SendToServer()
	end
end
	
net.Receive( "SendDoRes", function( length, sender )
	chkDoRes:SetValue( net.ReadString() ) --Set the client's DoRes setting
	DoResReceived = true
end )

function SendNewTogKey()
	if TogKeyReceived then
		net.Start( "TogKeyChange" )
			net.WriteString( TogKey:GetString() )
		net.SendToServer()
	end
end

function SendNewGlobalPass()
	if GlobalPassReceived then
		net.Start( "GlobalPassChange" )
			net.WriteString( GlobalPass:GetString() )
		net.SendToServer()
	end
end
	
net.Receive( "SendTogKey", function( length, sender )
	cbTogKey:SetValue( net.ReadString() ) --Set the client's TogKey setting
	TogKeyReceived = true
end )

net.Receive( "SendGlobalPass", function( length, sender )
	txtGlobalPass:SetText( net.ReadString() ) --Set the client's GlobalPass setting
	GlobalPassReceived = true
end )
	
net.Receive( "BroadcastSong", function( length, sender )
	PlayFromAdmin( net.ReadString(), net.ReadEntity() )
end )
	
hook.Add( "OnPlayerChat", "ChatOpenMenu", function( ply, text ) --Chat command to open menu
	if ply == LocalPlayer() and (string.sub(string.upper(text), 1, 5) == "!GMMP") then
		ToggleMenu()
	end
end)
	
timer.Create( "GMMPEverySecond", 1, 0, function() --Mute all players or continue playing song every second
	
	if PlayingSong and !ShouldBeStopped then

		fltSongTime = PlayingSong:GetTime()
		lblScrubbingCurTime:SetText( math.floor(fltSongTime/60) .. ":" .. string.format("%02d", math.floor(fltSongTime % 60) ) )
		if !sldScrubbing:IsEditing() then
			sldScrubbing:SetSlideX( fltSongTime / PlayingSong:GetLength() )
		end
		
		if PlayingSong:GetState() == 0 and PlayingSong:GetLength() > fltSongTime then
			PlayingSong:SetTime( fltSongTime )
			PlayingSong:Play()
		end
		
		if fltSongTime >= PlayingSong:GetLength() and AutoPlay:GetInt() >= 1 then
			ChangeSong( 1, true )
		end
		
	end
	
	if MuteAll:GetInt() >= 1 then
		for k, v in pairs( player.GetAll() ) do
			if !(v:IsMuted()) then
				v:SetMuted()
			end
		end
	else
		for k, v in pairs( player.GetAll() ) do
			if v:IsMuted() then
				v:SetMuted()
			end
		end
	end
end )
		

cvars.AddChangeCallback( "gmmp_autoresource", function() SendNewDoRes() end )
cvars.AddChangeCallback( "gmmp_menukey", function() SendNewTogKey() end )	
cvars.AddChangeCallback( "gmmp_globalpass", function() SendNewGlobalPass() end )	
	
cvars.AddChangeCallback( "gmmp_showfavourites", function() AlterHomeTab() end )
cvars.AddChangeCallback( "gmmp_showmountedsongs", function() PopulateFullSongList() end )
cvars.AddChangeCallback( "gmmp_showincludedsongs", function() PopulateFullSongList() end )
cvars.AddChangeCallback( "gmmp_favouritesselected", function() 
	if FavouritesList == SelectedList() then
		btnToggleList:SetText( "Play from Song List" )
	else
		btnToggleList:SetText( "Play from Favourites" )
	end
end )
	
cvars.AddChangeCallback( "gmmp_volume", function() 
	if PlayingSong and PlayingSong:IsValid() then --No song played yet. error prevention
		PlayingSong:SetVolume( Volume:GetFloat() / 100, 0 ) --Change the volume
	end
end )