local terminal = "wezterm"
local menu = "rofi"
local browser = "firefox-devedition"
local scripts = os.getenv("HOME") .. "/.config/hypr/scripts"

local super = "SUPER"
local meta = "ALT"
local ctrl = "CTRL"
local shift = "SHIFT"
local space = "SPACE"

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 32")
	hl.exec_cmd("waybar")
	hl.exec_cmd("miru-daemon")
	hl.exec_cmd("swaync")
	hl.exec_cmd("waytrogen --restore")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd(scripts .. "/battery-warning.sh")
end)

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_SIZE", "32")

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:escape",
		kb_rules = "",

		repeat_delay = 300,
		repeat_rate = 50,

		numlock_by_default = true,

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 3,
		gaps_workspaces = 1,

		border_size = 3,
		resize_on_border = true,
		no_focus_fallback = true,
		allow_tearing = false,

		col = {
			active_border = "rgba(f4b8e4ee)",
			inactive_border = "rgba(737994aa)",
		},

		layout = "dwindle",
	},

	decoration = {
		active_opacity = 1.00,
		inactive_opacity = 1.00,
		fullscreen_opacity = 1.00,

		shadow = {
			enabled = false,
		},

		blur = {
			enabled = false,
		},
	},

	animations = {
		enabled = false,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "slave",
	},

	scrolling = {
		fullscreen_on_one_column = true,
	},

	layers = {
		layers_hog_keyboard_focus = true,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = -1,
		vrr = 1,

		background_color = "rgba(8,8,12,240)",
		focus_on_activate = true,
	},
})

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@120",
	position = "0x0",
	scale = 1,
	mirror = "eDP-1",
})

hl.bind(super .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(super .. " + Q", hl.dsp.window.close())
hl.bind(super .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(
	super .. " + " .. shift .. " + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(super .. " + " .. space, hl.dsp.exec_cmd(menu .. " -show drun"))
hl.bind(
	super .. " + " .. ctrl .. " + " .. space,
	hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy")
)
hl.bind(super .. " + " .. meta .. " + " .. space, hl.dsp.exec_cmd("rofimoji --selector rofi --action copy"))
hl.bind(super .. " + " .. shift .. " + ESCAPE", hl.dsp.exec_cmd("swaylock"))
hl.bind(super .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", toggle = true }))
hl.bind(
	super .. " + " .. shift .. " + F",
	hl.dsp.window.fullscreen({
		mode = "fullscreen",
		action = "toggle",
	})
)
hl.bind(super .. " + Z", hl.dsp.exec_cmd("miructl toggle"))
hl.bind(super .. " + " .. meta .. " + Z", hl.dsp.exec_cmd("miructl loupe"))
hl.bind(meta .. " + P", hl.dsp.exec_cmd("rofi-pass"))
hl.bind(meta .. " + T", hl.dsp.exec_cmd(scripts .. "/tmux-sessions.sh"))

hl.bind(
	meta .. " + S",
	hl.dsp.exec_cmd(
		"sh -c 'grim -t ppm -g \"$(slurp)\" - | satty --filename - --fullscreen --copy-command wl-copy --output-filename ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png'"
	)
)
hl.bind(
	meta .. " + " .. shift .. " + S",
	hl.dsp.exec_cmd(
		'sh -c \'if pgrep -x wl-screenrec > /dev/null; then pkill -SIGINT wl-screenrec && notify-send -u normal -t 4000 "🎬 Recording Saved" "✅ Video written to ~/Videos — ready to use!"; else FILE=~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4; REGION=$(slurp) && wl-screenrec --geometry "$REGION" -f "$FILE" & notify-send -u normal -t 3000 "🔴 Recording in Progress" "🎯 Region locked — press Shift+Print again to stop"; fi\''
	)
)

hl.bind(super .. " + " .. shift .. " + " .. space, hl.dsp.window.float({ action = "toggle" }))

hl.bind(super .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(super .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(super .. " + L", hl.dsp.focus({ direction = "right" }))

hl.bind(super .. " + " .. shift .. " + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(super .. " + " .. shift .. " + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(super .. " + " .. shift .. " + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(super .. " + " .. shift .. " + L", hl.dsp.window.swap({ direction = "right" }))

hl.bind(super .. " + " .. ctrl .. " + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }))
hl.bind(super .. " + " .. ctrl .. " + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }))
hl.bind(super .. " + " .. ctrl .. " + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }))
hl.bind(super .. " + " .. ctrl .. " + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(super .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(super .. " + " .. shift .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(super .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(super .. " + " .. shift .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(super .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(super .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(super .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(meta .. " + V", hl.dsp.exec_cmd(scripts .. "/media-keys.sh vol-up"), { locked = true, repeating = true })
hl.bind(
	meta .. " + " .. shift .. " + V",
	hl.dsp.exec_cmd(scripts .. "/media-keys.sh vol-down"),
	{ locked = true, repeating = true }
)
hl.bind(meta .. "+" .. ctrl .. "+V", hl.dsp.exec_cmd(scripts .. "/media-keys.sh vol-mute"), { locked = true })

hl.bind(meta .. " + B", hl.dsp.exec_cmd(scripts .. "/media-keys.sh bright-up"), { locked = true, repeating = true })
hl.bind(
	meta .. " + " .. shift .. " + B",
	hl.dsp.exec_cmd(scripts .. "/media-keys.sh bright-down"),
	{ locked = true, repeating = true }
)

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "firefox-workspace",
	match = { class = "^(firefox-devedition)$" },
	workspace = "2 silent",
})

hl.window_rule({
	name = "vscode-workspace",
	match = { class = "^(code)$" },
	workspace = "5 silent",
})

hl.window_rule({
	name = "vesktop-workspace",
	match = { class = "^(vesktop)$" },
	workspace = "8 silent",
})

hl.window_rule({
	name = "spotify-workspace",
	match = { class = "^(spotify)$" },
	workspace = "9 silent",
})

hl.window_rule({
	name = "blueman-floating",
	match = { class = "^(blueman-manager)$" },
	float = true,
	size = "1000 600",
	center = true,
})

hl.window_rule({
	name = "network-manager-floating",
	match = { class = "^(nm-connection-editor)$" },
	float = true,
	size = "1000 600",
	center = true,
})
