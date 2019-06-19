-- TODO:

-- report inc keybidning doesnt work
-- reset location command
-- make toggle show hide


-- CONFIG START

local ABReport_ReportTime = 1.5; -- delay in seconds before message is posted

-- CONFIG END

SLASH_AR1= "/AR";

--[[

doesnt work

BINDING_HEADER_ABREPORT_HEADER = "ABReport";
BINDING_NAME_ABREPORT = "Report Incoming";
BINDING_NAME_ABSAFE = "Report Safe";

Bindings.xml:

<Bindings>
    <Binding name="ABREPORT" description="Default description" header="ABREPORT_HEADER">
	ABReport_Count();
	</Binding>
	<Binding name="ABSAFE" description="Default description">
	ABReport_DoSafe();
	</Binding>
</Bindings>

]]

local ABReport_LastClickTime = 0;
local ABReport_Enemies = 0;
local ABReport_DoReport = false;
local selectedLocation = false;

SlashCmdList["AR"] = function(args)
	ABReport_Count(nil);
end;

function ABReport_Count(location)
	print(location);
	print(ABReport_Location);

	if location == ABReport_Location then
		ABReport_Enemies = ABReport_Enemies + 1;
	else
		ABReport_Enemies = 1;
	end

	print("ABReport_Enemies: "..ABReport_Enemies);
	ABReport_Location = location
	ABReport_LastClickTime = time();
	ABReport_DoReport = true;
end

function ABReport_DoSafe()
	SendChatMessage("[ABr] "..GetSubZoneText().." is currently safe!", "INSTANCE_CHAT");
	ABReport_DoReport = false;
end

function ABReport_OnUpdate()

counterText(ABReport_Enemies);

	if not ABReport_Location then
		ABReport_Enemies = 0;
		ABReport_DoReport = false;

	elseif ABReport_DoReport and ABReport_LastClickTime + ABReport_ReportTime <= time()
	then
		if ABReport_Location == nil then
			SendChatMessage("[ABr] Reporting "..ABReport_Enemies.." enemies at "..GetSubZoneText().."!", "INSTANCE_CHAT");
		else
			SendChatMessage("[ABr] Reporting "..ABReport_Enemies.." enemies at "..ABReport_Location.."!", "INSTANCE_CHAT");
		end
		ABReport_Enemies = 0;
		ABReport_DoReport = false;
		ABReport_Location = nil;
		disableSafe();
	end

end

function ABReport_OnEvent()
	
end

ABReport_functionFrame = CreateFrame("FRAME", "ABReport_functionFrame");
ABReport_functionFrame:SetScript("OnUpdate", function() ABReport_OnUpdate() end);
ABReport_functionFrame:SetScript("OnEvent", function() ABReport_OnEvent(event, arg1, arg2, arg3, arg4) end);
ABReport_functionFrame:RegisterEvent("ADDON_LOADED");

---------------------------------
-- Frame
---------------------------------

local ABReport_frame = CreateFrame("Frame", "ABRFrame", UIParent, "BasicFrameTemplateWithInset");
ABReport_frame:SetSize(100, 120);
ABReport_frame:SetPoint("CENTER", UIParent, "CENTER");
ABReport_frame:SetMovable(true);
ABReport_frame:EnableMouse(true);
ABReport_frame:RegisterForDrag("LeftButton");
ABReport_frame:SetScript("OnDragStart", ABReport_frame.StartMoving);
ABReport_frame:SetScript("OnDragStop", ABReport_frame.StopMovingOrSizing);




ABReport_frame.title = ABReport_frame:CreateFontString(nil, "OVERLAY");
ABReport_frame.title:SetFontObject("GameFontHighlight");
ABReport_frame.title:SetPoint("LEFT", ABReport_frame.TitleBg, "LEFT", 5, 0);
ABReport_frame.title:SetText("ABReport");

ABReport_frame.counterText = ABReport_frame:CreateFontString(nil, "OVERLAY");
ABReport_frame.counterText:SetFontObject("GameFontHighlight");
ABReport_frame.counterText:SetPoint("TOP", ABReport_frame, "TOP", 1, -74);
function counterText(number)
	ABReport_frame.counterText:SetText(number);
end
---------------------------------
-- Buttons
---------------------------------

-- Stable Button:
ABReport_frame.stableBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.stableBtn:SetPoint("TOPLEFT", ABReport_frame, "TOPLEFT", 10, -30);
ABReport_frame.stableBtn:SetSize(30, 20);
ABReport_frame.stableBtn:SetText("S");
ABReport_frame.stableBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.stableBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.stableBtn:SetScript("OnClick", function()
	ABReport_Count("Stable")
	selectedLocation = "Stable";
	ABReport_frame.safeBtn:Enable();
end)

-- Mine Button:

ABReport_frame.mineBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.mineBtn:SetPoint("TOPRIGHT", ABReport_frame, "TOPRIGHT", -10, -30);
ABReport_frame.mineBtn:SetSize(30, 20);
ABReport_frame.mineBtn:SetText("M");
ABReport_frame.mineBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.mineBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.mineBtn:SetScript("OnClick", function()
	ABReport_Count("Mine")
	selectedLocation = "Mine";
	ABReport_frame.safeBtn:Enable();
end)

-- Blacksmith Button:

ABReport_frame.blacksmithBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.blacksmithBtn:SetPoint("TOP", ABReport_frame, "TOP", 0, -50);
ABReport_frame.blacksmithBtn:SetSize(30, 20);
ABReport_frame.blacksmithBtn:SetText("BS");
ABReport_frame.blacksmithBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.blacksmithBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.blacksmithBtn:SetScript("OnClick", function()
	ABReport_Count("Blacksmith")
	selectedLocation = "Blacksmith";
	ABReport_frame.safeBtn:Enable();
end)

-- Lumber mill Button:

ABReport_frame.lumbermillBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.lumbermillBtn:SetPoint("TOPLEFT", ABReport_frame, "TOPLEFT", 10, -70);
ABReport_frame.lumbermillBtn:SetSize(30, 20);
ABReport_frame.lumbermillBtn:SetText("LM");
ABReport_frame.lumbermillBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.lumbermillBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.lumbermillBtn:SetScript("OnClick", function()
	ABReport_Count("Lumber Mill")
	selectedLocation = "Lumber Mill";
	ABReport_frame.safeBtn:Enable();
end)

-- Farm Button:

ABReport_frame.farmBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.farmBtn:SetPoint("TOPRIGHT", ABReport_frame, "TOPRIGHT", -10, -70);
ABReport_frame.farmBtn:SetSize(30, 20);
ABReport_frame.farmBtn:SetText("F");
ABReport_frame.farmBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.farmBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.farmBtn:SetScript("OnClick", function()
	ABReport_Count("Farm")
	selectedLocation = "Farm";
	ABReport_frame.safeBtn:Enable();
end)

-- CANCEL

ABReport_frame.cancelBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.cancelBtn:SetPoint("BOTTOMLEFT", ABReport_frame, "BOTTOMLEFT", 10, 10);
ABReport_frame.cancelBtn:SetSize(40, 20);
ABReport_frame.cancelBtn:SetText("Cancel");
ABReport_frame.cancelBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.cancelBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.cancelBtn:SetScript("OnClick", function()
	ABReport_Count(false)
	disableSafe();
end)

-- SAFE

ABReport_frame.safeBtn = CreateFrame("Button", nil, ABReport_frame, "GameMenuButtonTemplate");
ABReport_frame.safeBtn:SetPoint("BOTTOMRIGHT", ABReport_frame, "BOTTOMRIGHT", -10, 10);
ABReport_frame.safeBtn:SetSize(40, 20);
ABReport_frame.safeBtn:SetText("Safe");
ABReport_frame.safeBtn:SetNormalFontObject("GameFontNormalSmall");
ABReport_frame.safeBtn:SetHighlightFontObject("GameFontHighlightLarge");
ABReport_frame.safeBtn:Disable();
ABReport_frame.safeBtn:SetScript("OnClick", function()
	
	if selectedLocation == false then
		SendChatMessage("[ABr] "..GetSubZoneText().." is currently safe!", "INSTANCE_CHAT")
	else
		SendChatMessage("[ABr] "..selectedLocation.." is currently safe!", "INSTANCE_CHAT")
	end
	selectedLocation = false;
	ABReport_Enemies = 0;
	ABReport_DoReport = false;
	disableSafe();
end)

function disableSafe()
	ABReport_frame.safeBtn:Disable();
end