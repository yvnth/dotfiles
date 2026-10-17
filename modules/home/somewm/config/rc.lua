local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local ruled = require("ruled")
local menubar = require("menubar")

local super = "Mod4"
local shift = "Shift"
local ctrl = "Control"
local alt = "Mod1"
local terminal = "wezterm"

root.cursor_theme("Bibata-Modern-Classic")
root.cursor_size(32)

beautiful.bg_normal = "#303446"
beautiful.bg_focus = "#414559"
beautiful.bg_urgent = "#e78284"
beautiful.bg_minimize = "#292c3c"
beautiful.fg_normal = "#c6d0f5"
beautiful.fg_focus = "#f4b8e4"
beautiful.fg_urgent = "#232634"
beautiful.fg_minimize = "#a5adce"
beautiful.border_width = dpi(3)
beautiful.border_normal = "#414559"
beautiful.border_focus = "#f4b8e4"
beautiful.border_marked = "#e5c890"
beautiful.wibar_bg = "#292c3c"
beautiful.wibar_fg = "#f4b8e4"
beautiful.font = "PlemolJP Console NF 15"
beautiful.taglist_font = "PlemolJP Console NF 15"
beautiful.taglist_spacing = dpi(10)
beautiful.taglist_bg_focus = "#f4b8e4"
beautiful.taglist_fg_focus = "#232634"
beautiful.taglist_bg_occupied = "#414559"
beautiful.taglist_fg_occupied = "#c6d0f5"
beautiful.taglist_bg_empty = "#292c3c"
beautiful.taglist_fg_empty = "#838ba7"
beautiful.tasklist_bg_focus = "#414559"
beautiful.tasklist_fg_focus = "#f4b8e4"
beautiful.menu_bg = "#303446"
beautiful.menu_fg = "#c6d0f5"
beautiful.menu_border_color = "#f4b8e4"
beautiful.menu_border_width = dpi(2)
beautiful.titlebar_bg_focus = "#414559"
beautiful.titlebar_fg_focus = "#f4b8e4"
beautiful.titlebar_bg_normal = "#303446"
beautiful.titlebar_fg_normal = "#c6d0f5"
beautiful.useless_gap = dpi(3)

require("lockscreen").init()

awful.spawn.once("mako")
awful.spawn.once("wl-paste --type text --watch cliphist store")
awful.spawn.once("wl-paste --type image --watch cliphist store")
awful.spawn.once("waytrogen --restore")
awful.spawn.with_shell(
  "flock -n /tmp/somewm-battery-warning.lock " ..
  os.getenv("HOME") .. "/.config/somewm/scripts/battery-warning.sh"
)
awful.spawn.once("miru-daemon")
menubar.utils.terminal = terminal

awful.input.natural_scrolling = 0
awful.input.tap_to_click = 0
awful.input.rules = {
  {
    rule = { type = "touchpad" },
    properties = {
      natural_scrolling = 1,
      tap_to_click = 1,
      tap_and_drag = 1,
      drag_lock = 1
    }
  },
  {
    rule = { type = "pointer" },
    properties = { natural_scrolling = 0 }
  }
}

awful.input.xkb_layout = "us"
awful.input.xkb_options = ""
awful.input.keyboard_repeat_delay = 300
awful.input.keyboard_repeat_rate = 50

local function run(command)
  awful.spawn.with_shell(command)
end

local function focus_direction(direction)
  awful.client.focus.bydirection(direction)
end

local function swap_direction(direction)
  if client.focus then
    awful.client.swap.bydirection(direction)
  end
end

local function resize_focused(dx, dy)
  if not client.focus then return end

  local c = client.focus

  if c.floating then
    c:relative_move(0, 0, dx, dy)
  elseif dx ~= 0 then
    awful.tag.incmwfact(dx > 0 and 0.05 or -0.05)
  elseif dy ~= 0 then
    awful.client.incwfact(dy > 0 and -0.05 or 0.05)
  end
end

local function view_tag(index)
  local s = awful.screen.focused()
  local t = s.tags[index]
  if t then t:view_only() end
end

local function move_to_tag(index)
  if client.focus then
    local t = client.focus.screen.tags[index]
    if t then client.focus:move_to_tag(t) end
  end
end

local function screenshot_region()
  run(
    'mkdir -p "$HOME/Pictures/screenshots"; grim -t ppm -g "$(slurp)" - | satty --filename - --fullscreen --copy-command wl-copy --output-filename "$HOME/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"')
end

local function toggle_fullscreen()
  if client.focus then
    client.focus.fullscreen = not client.focus.fullscreen
    client.focus:raise()
  end
end

local function toggle_maximize()
  if client.focus then
    client.focus.maximized = not client.focus.maximized
    client.focus:raise()
  end
end

local function toggle_floating()
  if client.focus then client.focus.floating = not client.focus.floating end
end

local function toggle_clipboard()
  run("cliphist list | rofi -dmenu | cliphist decode | wl-copy")
end

local function kill_focused()
  if client.focus then client.focus:kill() end
end

local function toggle_minimized()
  if client.focus then client.focus.minimized = true end
end

tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.carousel,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    awful.layout.suit.spiral,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,

  })
end)

screen.connect_signal("request::wallpaper", function(s)
  if beautiful.wallpaper then
    awful.wallpaper({
      screen = s,
      widget = {
        image = beautiful.wallpaper,
        upscale = true,
        downscale = true,
        widget = wibox.widget.imagebox
      }
    })
  else
    awful.wallpaper({ screen = s, bg = beautiful.bg_normal or "#303446" })
  end
end)

local function make_status_widget(command, interval, prefix, fallback)
  local widget = wibox.widget.textbox()
  widget:set_markup(gears.string.xml_escape(prefix .. (fallback or "--")))
  awful.widget.watch(command, interval, function(w, stdout)
    local value = stdout:gsub("%s+$", "")
    if value == "" then value = fallback or "--" end
    w:set_markup(gears.string.xml_escape(prefix .. value))
  end, widget)
  return widget
end

local time_widget = wibox.widget.textbox()
local date_widget = wibox.widget.textbox()

local function update_time_widget()
  time_widget:set_markup('<span foreground="#f4b8e4">' .. os.date("%H:%M:%S") .. "</span>")
end

local function update_date_widget()
  date_widget:set_markup('<span foreground="#f4b8e4">' .. os.date("%d/%m/%Y") .. "</span>")
end

gears.timer {
  timeout = 1.0,
  autostart = true,
  call_now = true,
  callback = update_time_widget
}

gears.timer {
  timeout = 60.0,
  autostart = true,
  call_now = true,
  callback = update_date_widget
}

local cpu_widget = wibox.widget.textbox()
cpu_widget:set_markup('<span foreground="#f4b8e4">󰾆  --</span>')
local previous_cpu_total, previous_cpu_idle = nil, nil
gears.timer {
  timeout = 1.0,
  autostart = true,
  call_now = true,
  callback = function()
    local f = io.open("/proc/stat", "r")
    if not f then
      cpu_widget:set_markup('<span foreground="#f4b8e4">󰾆  --</span>'); return
    end
    local line = f:read("*l")
    f:close()
    local values = {}
    for value in (line or ""):gmatch("%d+") do values[#values + 1] = tonumber(value) end
    if #values < 4 then
      cpu_widget:set_markup('<span foreground="#f4b8e4">󰾆  --</span>'); return
    end
    local total = 0
    for _, value in ipairs(values) do total = total + value end
    local idle = values[4] + (values[5] or 0)
    if previous_cpu_total and total > previous_cpu_total then
      local total_delta = total - previous_cpu_total
      local idle_delta = idle - previous_cpu_idle
      local usage = math.floor((1 - idle_delta / total_delta) * 100 + 0.5)
      usage = math.max(0, math.min(100, usage))
      cpu_widget:set_markup(string.format('<span foreground="#f4b8e4">󰾆  %d%%</span>', usage))
    end
    previous_cpu_total, previous_cpu_idle = total, idle
  end
}

local ram_widget = make_status_widget(
  [[awk '/^MemTotal:/ {t=$2} /^MemAvailable:/ {a=$2} END {if (t>0 && a>=0) printf "󰍛  %.0f%%\n", (t-a)*100/t; else print "󰍛  --"}' /proc/meminfo]],
  2.0, "", "󰍛  --")

local battery_widget = make_status_widget(
  [[sh -c '
    capacity=""
    status=""

    for f in /sys/class/power_supply/BAT*/capacity; do
      if [ -r "$f" ]; then
        capacity=$(cat "$f")
        break
      fi
    done

    for f in /sys/class/power_supply/BAT*/status; do
      if [ -r "$f" ]; then
        status=$(cat "$f")
        break
      fi
    done

    case "$status" in
      Charging)  icon="󰂄" ;;
      Full)      icon="󰁹" ;;
      *)         icon="󰁹" ;;
    esac

    if [ -n "$capacity" ]; then
      printf "%s %s%%\n" "$icon" "$capacity"
    else
      printf "󰁹 --\n"
    fi
  ']],
  3.0, "", "󰁹 --")

local volume_widget = wibox.widget.textbox()
volume_widget:set_markup('<span foreground="#f4b8e4">  --</span>')
gears.timer {
  timeout = 1.0,
  autostart = true,
  call_now = true,
  callback = function()
    local pipe = io.popen("wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null")
    local output = pipe and pipe:read("*a") or ""
    if pipe then pipe:close() end
    local value = tonumber(output:match("Volume:%s*([%d%.]+)"))
    local muted = output:find("%[MUTED%]") ~= nil
    if muted then
      volume_widget:set_markup('<span foreground="#f4b8e4"></span>')
    elseif value then
      local icon = value < 0.34 and "" or (value < 0.67 and "" or "")
      volume_widget:set_markup(string.format('<span foreground="#f4b8e4">%s  %d%%</span>', icon,
        math.floor(value * 100 + 0.5)))
    else
      volume_widget:set_markup('<span foreground="#f4b8e4">   --</span>')
    end
  end
}

local brightness_widget = make_status_widget(
  [[sh -c 'v=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d "%"); case "$v" in ""|*[!0-9]*) echo "󰃠  --";; *) echo "󰃠  ${v}%";; esac']],
  2.0, "", "󰃠  --")

local wifi_widget = make_status_widget(
  [[sh -c 'v=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep "^yes:" | head -n1 | cut -d: -f2-); if [ -z "$v" ]; then v=$(iwgetid -r 2>/dev/null); fi; [ -n "$v" ] && printf "  %s\n" "$v" || echo "  --"']],
  5.0, "", "  --")

local function add_spacing(widget, left, right)
  return wibox.container.margin(widget, left or dpi(5), right or dpi(5), 0, 0)
end

screen.connect_signal("request::desktop_decoration", function(s)
  awful.tag({ "一", "二", "三", "四", "五", "六", "七", "八", "九" }, s, awful.layout.suit.spiral.dwindle)

  s.mylayoutbox = awful.widget.layoutbox({
    screen = s,
    buttons = {
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end)
    }
  })

  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = {
      awful.button({}, 1, function(t) t:view_only() end),
      awful.button({ super }, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
      end)
    }
  })

  local left_widgets = wibox.layout.fixed.horizontal()
  left_widgets:add(add_spacing(time_widget))
  left_widgets:add(add_spacing(date_widget))
  left_widgets:add(add_spacing(cpu_widget))
  left_widgets:add(add_spacing(ram_widget))

  local right_widgets = wibox.layout.fixed.horizontal()
  right_widgets:add(add_spacing(battery_widget))
  right_widgets:add(add_spacing(volume_widget))
  right_widgets:add(add_spacing(brightness_widget))
  right_widgets:add(add_spacing(wifi_widget))
  right_widgets:add(add_spacing(wibox.widget.systray(), dpi(8), dpi(8)))

  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(25),
    bg = "#292c3c",
    fg = "#f4b8e4",
    widget = {
      layout = wibox.layout.align.horizontal,
      left_widgets,
      wibox.container.place(
        wibox.widget {
          s.mytaglist,
          add_spacing(s.mylayoutbox, dpi(10), dpi(8)),
          layout = wibox.layout.fixed.horizontal
        },
        "center",
        "center"
      ),
      right_widgets
    }
  })
end)

awful.keyboard.append_global_keybindings({
  awful.key {
    modifiers = { super, shift },
    key = "r",
    on_press = awesome.restart,
    description = "reload config",
  },

  awful.key {
    modifiers = { super, shift },
    key = "q",
    on_press = awesome.quit,
    description = "quit",
  },

  awful.key {
    modifiers = { super, shift },
    key = "Escape",
    on_press = function() awesome.lock() end,
    description = "lock screen",
  },
})

awful.keyboard.append_global_keybindings({
  awful.key {
    modifiers = { super },
    key = "Return",
    on_press = function() awful.spawn(terminal) end,
    description = "terminal",
  },

  awful.key {
    modifiers = { super },
    key = "b",
    on_press = function() awful.spawn("firefox-devedition") end,
    description = "browser",
  },

  awful.key {
    modifiers = { super },
    key = "p",
    on_press = function() awful.spawn("rofi-pass") end,
    description = "password manager",
  },

  awful.key {
    modifiers = { super },
    key = "z",
    on_press = function() awful.spawn("miructl toggle") end,
    description = "toggle miru magnifier",
  },

  awful.key {
    modifiers = { super, alt },
    key = "z",
    on_press = function()
      awful.spawn("miructl loupe")
    end,
    description = "toggle miru loupe",
  },

  awful.key {
    modifiers = { super },
    key = "space",
    on_press = function() awful.spawn("rofi -show drun") end,
    description = "application launcher",
  },

  awful.key {
    modifiers = { super, ctrl },
    key = "space",
    on_press = toggle_clipboard,
    description = "clipboard history",
  },

  awful.key {
    modifiers = { super, alt },
    key = "space",
    on_press = function()
      awful.spawn("rofimoji --selector rofi --action copy")
    end,
    description = "emoji picker",
  },
})

awful.keyboard.append_global_keybindings({
  awful.key {
    modifiers = { super },
    key = "q",
    on_press = kill_focused,
    description = "close window",
  },

  awful.key {
    modifiers = { super },
    key = "f",
    on_press = toggle_maximize,
    description = "toggle maximize",
  },

  awful.key {
    modifiers = { super, shift },
    key = "f",
    on_press = toggle_fullscreen,
    description = "toggle fullscreen",
  },

  awful.key {
    modifiers = { super, shift },
    key = "space",
    on_press = toggle_floating,
    description = "toggle floating",
  },

  awful.key {
    modifiers = { super },
    key = "h",
    on_press = function() focus_direction("left") end,
    description = "focus left",
  },

  awful.key {
    modifiers = { super },
    key = "j",
    on_press = function() focus_direction("down") end,
    description = "focus down",
  },

  awful.key {
    modifiers = { super },
    key = "k",
    on_press = function() focus_direction("up") end,
    description = "focus up",
  },

  awful.key {
    modifiers = { super },
    key = "l",
    on_press = function() focus_direction("right") end,
    description = "focus right",
  },

  awful.key {
    modifiers = { super, alt },
    key = "l",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/layout-change.sh")
    end,
    description = "change layout",
  },

  awful.key {
    modifiers = { super, alt },
    key = "t",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/tmux-sessions.sh")
    end,
    description = "open tmux sessions",
  },

  awful.key {
    modifiers = { super, shift },
    key = "h",
    on_press = function() swap_direction("left") end,
    description = "move window left",
  },

  awful.key {
    modifiers = { super, shift },
    key = "j",
    on_press = function() swap_direction("down") end,
    description = "move window down",
  },

  awful.key {
    modifiers = { super, shift },
    key = "k",
    on_press = function() swap_direction("up") end,
    description = "move window up",
  },

  awful.key {
    modifiers = { super, shift },
    key = "l",
    on_press = function() swap_direction("right") end,
    description = "move window right",
  },

  awful.key {
    modifiers = { super, ctrl },
    key = "h",
    on_press = function() resize_focused(-40, 0) end,
    description = "shrink window width",
  },

  awful.key {
    modifiers = { super, ctrl },
    key = "l",
    on_press = function() resize_focused(40, 0) end,
    description = "grow window width",
  },

  awful.key {
    modifiers = { super, ctrl },
    key = "k",
    on_press = function() resize_focused(0, -40) end,
    description = "shrink window height",
  },

  awful.key {
    modifiers = { super, ctrl },
    key = "j",
    on_press = function() resize_focused(0, 40) end,
    description = "grow window height",
  },

  awful.key {
    modifiers = { super },
    key = "s",
    on_press = toggle_minimized,
    description = "minimize window",
  },

  awful.key {
    modifiers = { super, shift },
    key = "s",
    on_press = function()
      for _, c in ipairs(client.get()) do
        if c.minimized then
          c.minimized = false
          c:activate({ context = "key", raise = true })
          break
        end
      end
    end,
    description = "restore a minimized window",
  },
})

awful.keyboard.append_global_keybindings({
  awful.key {
    modifiers = {},
    key = "Print",
    on_press = screenshot_region,
    description = "region screenshot",
  },

  awful.key {
    modifiers = { shift },
    key = "Print",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/screen-record.sh")
    end,
    description = "screen recording",
  },
})

awful.keyboard.append_global_keybindings({
  awful.key {
    modifiers = {},
    key = "XF86AudioRaiseVolume",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/media-keys.sh vol-up")
    end,
    description = "volume up",
  },

  awful.key {
    modifiers = {},
    key = "XF86AudioLowerVolume",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/media-keys.sh vol-down")
    end,
    description = "volume down",
  },

  awful.key {
    modifiers = {},
    key = "XF86AudioMute",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/media-keys.sh vol-mute")
    end,
    description = "mute audio",
  },

  awful.key {
    modifiers = {},
    key = "XF86AudioMicMute",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/media-keys.sh mic-mute")
    end,
    description = "mute microphone",
  },

  awful.key {
    modifiers = {},
    key = "XF86MonBrightnessUp",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/media-keys.sh bright-up")
    end,
    description = "brightness up",
  },

  awful.key {
    modifiers = {},
    key = "XF86MonBrightnessDown",
    on_press = function()
      run(os.getenv("HOME") .. "/.config/somewm/scripts/media-keys.sh bright-down")
    end,
    description = "brightness down",
  },
})

for i = 1, 9 do
  awful.keyboard.append_global_keybindings({
    awful.key {
      modifiers = { super },
      key = "#" .. (i + 9),
      on_press = function() view_tag(i) end,
      description = "view tag " .. i,
    },

    awful.key {
      modifiers = { super, shift },
      key = "#" .. (i + 9),
      on_press = function() move_to_tag(i) end,
      description = "move window to tag " .. i,
    },
  })
end

client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({ super }, 1, function(c)
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ super }, 3, function(c)
      c:activate({ context = "mouse_click", action = "mouse_resize" })
    end)
  })
end)

ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      border_width = dpi(3),
      border_color = "#414559",
      raise = true,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  })

  ruled.client.append_rule({
    id = "firefox-tag",
    rule = { class = "firefox-devedition" },
    properties = { tag = "二", switchtotag = false }
  })
  ruled.client.append_rule({
    id = "vscode-tag",
    rule = { class = "code" },
    properties = { tag = "五", switchtotag = false }
  })
  ruled.client.append_rule({
    id = "vesktop-tag",
    rule = { class = "vesktop" },
    properties = { tag = "八", switchtotag = false }
  })
  ruled.client.append_rule({
    id = "spotify-tag",
    rule = { class = "spotify" },
    properties = { tag = "九", switchtotag = false }
  })
  ruled.client.append_rule({
    id = "blueman-floating",
    rule = { class = "blueman-manager" },
    properties = { floating = true, width = 1000, height = 600, placement = awful.placement.centered }
  })
  ruled.client.append_rule({
    id = "network-manager-floating",
    rule = { class = "nm-connection-editor" },
    properties = { floating = true, width = 1000, height = 600, placement = awful.placement.centered }
  })
  ruled.client.append_rule({
    id = "file-chooser-floating",
    rule = { class = "xdg-desktop-portal-gtk" },
    properties = { floating = true, width = 900, height = 650, placement = awful.placement.centered }
  })
  ruled.client.append_rule({
    id = "dialogs-floating",
    rule = { type = "dialog" },
    properties = { floating = true, placement = awful.placement.centered }
  })
end)

client.connect_signal("focus", function(c)
  c.border_width = dpi(3)
  c.border_color = "#f4b8e4"
end)

client.connect_signal("unfocus", function(c)
  c.border_width = dpi(3)
  c.border_color = "#414559"
end)

client.connect_signal("mouse::enter", function(c)
  c:activate({ context = "mouse_enter", raise = false })
end)

