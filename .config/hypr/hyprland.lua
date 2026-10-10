----------------
--- COLOURS ---
----------------

local colors = require("colors")

----------------
--- MONITORS ---
----------------

hl.monitor({
	output = "eDP-1",
	mode = "2880x1800@120",
	position = "auto-down",
	scale = 1.5,
	vrr = 1,
})

hl.monitor({
	output = "DP-1",
	mode = "2560x1440@165",
	position = "auto-up",
	scale = 1,
})

-------------------
--- WORKSPACES ---
-------------------

hl.workspace_rule({ workspace = "1", persistent = false, default_name = "1:Web" })
hl.workspace_rule({ workspace = "2", persistent = false, default_name = "2:Web" })
hl.workspace_rule({ workspace = "3", persistent = false, default_name = "3:Code" })
hl.workspace_rule({ workspace = "4", persistent = false, default_name = "4:Code" })
hl.workspace_rule({ workspace = "5", persistent = false, default_name = "5:Code" })
hl.workspace_rule({ workspace = "6", persistent = false, default_name = "6:Code" })
hl.workspace_rule({ workspace = "7", persistent = false, default_name = "7:Code" })
hl.workspace_rule({ workspace = "8", persistent = false, default_name = "8:Code" })
hl.workspace_rule({ workspace = "9", persistent = false, default_name = "9:Media" })
hl.workspace_rule({ workspace = "10", persistent = false, default_name = "10:Media" })

-------------------
--- MY PROGRAMS ---
-------------------

local tmux = [[alacritty -e "tmux"]]
local terminal = "ghostty"
local fileManager = "nautilus"
local menu = "wofi --show drun"

-----------------
--- AUTOSTART ---
-----------------

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	--hl.exec_cmd("mako")
	-- hl.exec_cmd("waybar")
	hl.exec_cmd("noctalia")
	--hl.exec_cmd("hyprwhenthen run")
	--hl.exec_cmd("nm-applet --indicator")
	-- hl.exec_cmd("hyprsunset")
	-- hl.exec_cmd("hyprpm reload -n")
	--hl.exec_cmd("wl-paste --watch cliphist store")
	--hl.exec_cmd("hyprpaper")
	--hl.exec_cmd("$HOME/.config/hypr/wallpaper-script.sh")
	--hl.exec_cmd("snappy-switcher --daemon")
	hl.exec_cmd("hypridle")
	--hl.exec_cmd("$HOME/.config/hypr/wallpaper-rotator.sh")
end)

-------------------------------
--- ENVIRONMENT VARIABLES ---
-------------------------------

hl.env("GTK_THEME", "Space-dark")
hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("GDK_SCALE", "1.5")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},

	cursor = {
		-- Lua API expects the current integer form.
		-- 1 = always disable hardware cursors.
		no_hardware_cursors = 1,
	},

	general = {
		gaps_in = 1, --1
		gaps_out = 2, --2
		border_size = 0, --3

		col = {
			active_border = {
				colors = {
					colors.blue,
					colors.mauve,
					--	"rgba(33ccffee)",
					--	"rgba(00ff99ee)",
				},
				angle = 45,
			},

			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,
		allow_tearing = true,
		layout = "dwindle",
	},

	decoration = {
		rounding = 5, --5,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
			size = 5,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_rate = 50,
		repeat_delay = 250,

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.2,
			tap_to_click = true,
			clickfinger_behavior = true,
		},
	},
})

------------------
--- ANIMATIONS ---
------------------

hl.curve("expressiveFastSpatial", {
	type = "bezier",
	points = {
		{ 0.42, 1.67 },
		{ 0.21, 0.90 },
	},
})

hl.curve("expressiveSlowSpatial", {
	type = "bezier",
	points = {
		{ 0.39, 1.29 },
		{ 0.35, 0.98 },
	},
})

hl.curve("expressiveDefaultSpatial", {
	type = "bezier",
	points = {
		{ 0.38, 1.21 },
		{ 0.22, 1.00 },
	},
})

hl.curve("emphasizedDecel", {
	type = "bezier",
	points = {
		{ 0.05, 0.7 },
		{ 0.1, 1 },
	},
})

hl.curve("emphasizedAccel", {
	type = "bezier",
	points = {
		{ 0.3, 0 },
		{ 0.8, 0.15 },
	},
})

hl.curve("standardDecel", {
	type = "bezier",
	points = {
		{ 0, 0 },
		{ 0, 1 },
	},
})

hl.curve("menu_decel", {
	type = "bezier",
	points = {
		{ 0.1, 1 },
		{ 0, 1 },
	},
})

hl.curve("menu_accel", {
	type = "bezier",
	points = {
		{ 0.52, 0.03 },
		{ 0.72, 0.08 },
	},
})

hl.curve("stall", {
	type = "bezier",
	points = {
		{ 1, -0.1 },
		{ 0.7, 0.85 },
	},
})

-- Windows

hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
	style = "popin 80%",
})

hl.animation({
	leaf = "fadeIn",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
})

hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 2,
	bezier = "emphasizedDecel",
	style = "popin 90%",
})

hl.animation({
	leaf = "fadeOut",
	enabled = true,
	speed = 2,
	bezier = "emphasizedDecel",
})

hl.animation({
	leaf = "windowsMove",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
	style = "slide",
})

hl.animation({
	leaf = "border",
	enabled = true,
	speed = 10,
	bezier = "emphasizedDecel",
})

-- Layers

hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 2.7,
	bezier = "emphasizedDecel",
	style = "popin 93%",
})

hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 2.4,
	bezier = "menu_accel",
	style = "popin 94%",
})

-- Fade

hl.animation({
	leaf = "fadeLayersIn",
	enabled = true,
	speed = 0.5,
	bezier = "menu_decel",
})

hl.animation({
	leaf = "fadeLayersOut",
	enabled = true,
	speed = 2.7,
	bezier = "stall",
})

-- Workspaces

hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 7,
	bezier = "menu_decel",
	style = "slide",
})

-- Special workspaces

hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 2.8,
	bezier = "emphasizedDecel",
	style = "slidevert",
})

hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 1.2,
	bezier = "emphasizedAccel",
	style = "slidevert",
})

-- Zoom

hl.animation({
	leaf = "zoomFactor",
	enabled = true,
	speed = 3,
	bezier = "standardDecel",
})

---------------
--- DEVICES ---
---------------

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

----------------
--- GESTURES ---
----------------

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-------------------
--- KEYBINDINGS ---
-------------------

local mainMod = "SUPER"

-- Notes

hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("noctalia msg panel-toggle noctalia/notes:panel"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("noctalia msg panel-toggle nightwatch75/todo:panel"))

-- Browser

hl.bind("CONTROL + SHIFT + 1", hl.dsp.exec_cmd("$HOME/.config/hypr/brave.sh Personal"))
hl.bind("CONTROL + SHIFT + 2", hl.dsp.exec_cmd("$HOME/.config/hypr/brave.sh Work"))
hl.bind("CONTROL + SHIFT + 3", hl.dsp.exec_cmd("$HOME/.config/hypr/brave.sh Professional"))

-- Terminal

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("alacritty"))

-- Window control

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
--hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("$HOME/.config/rofi/powermenu/type-2/powermenu.sh"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("$HOME/.config/hypr/rename-workspace.sh"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" }))

-- Application launchers

--hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))
-- hl.bind(
-- 	mainMod .. " + D",
-- 	hl.dsp.exec_cmd("rofi -no-lazy-grab -show drun -theme $HOME/.config/rofi/launchers/type-2/style-8.rasi")
-- )
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))

-- Focus movement

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
--hl.bind(mainMod .. " + E", hl.dsp.focus({ workspace = "e+1" }))
--hl.bind(mainMod .. " + Q", hl.dsp.focus({ workspace = "e-1" }))
--hl.bind(mainMod .. " + SHIFT + left", hl.dsp.focus({ workspace = "e-1" }))
--hl.bind(mainMod .. " + SHIFT + right", hl.dsp.focus({ workspace = "e+1" }))

-- Switch workspaces / move windows

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Split

hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Move windows

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Mouse window manipulation

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

---------------
--- CLIPBOARD ---
---------------

hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))

----------------
--- SCREENSHOT ---
----------------

hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"))

--------------------
--- AUDIO CONTROL ---
--------------------

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute 0 toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute 0 toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume 0 -5%"))

-- Media

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd("playerctl previous"))
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("playerctl next"))

---------------------
--- SCREEN CONTROL ---
---------------------

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10-%"))

------------------
--- BAR TOGGLE ---
-----------------

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("noctalia msg bar-toggle"))

-------------------
--- LID SWITCH ---
-------------------

--hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("$HOME/.config/hypr/lid.sh open"), { locked = true })
--hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("$HOME/.config/hypr/lid.sh close"), { locked = true })

--------------------
--- WINDOW RULES ---
--------------------

hl.window_rule({
	name = "Brave profile popup",
	match = {
		class = [[^(brave-.+-Profile_\d)$]],
	},
	float = true,
})

hl.window_rule({
	name = "Nautilus floating",
	match = {
		class = [[^(org.gnome.Nautilus)$]],
	},
	float = true,
})

hl.window_rule({
	name = "Save dialog",
	match = {
		title = [[^.*(wants.to.save)$]],
	},
	float = true,
	size = { 1200, 800 },
})

-- SSO popups open with a generic title and only later load the auth URL, so a
-- static title rule misses them. React to title changes instead.
local function float_auth_popup(w)
	if not w or not w.mapped or not w.title:find("signInViaPopup", 1, true) then
		return
	end
	hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))
	hl.dispatch(hl.dsp.window.resize({ x = 800, y = 800, exact = true, window = w }))
	hl.dispatch(hl.dsp.window.center({ window = w }))
end
hl.on("window.title", float_auth_popup)
hl.on("window.open", float_auth_popup)
