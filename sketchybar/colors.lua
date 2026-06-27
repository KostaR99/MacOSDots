local M = {}

local with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

local theme = {
  base = 0xff10140f,
  surface = 0xff171f15,
  overlay = 0xff20291d,
  muted = 0xff6f7d63,
  subtle = 0xffaeb99f,
  text = 0xffdce7c8,
  matcha = 0xff9fbd7a,
  moss = 0xff5f7f56,
  cream = 0xfffff7d6,
  gold = 0xffe7be67,
  clay = 0xffc8755a,
}

M.sections = {
  bar = {
    bg = with_alpha(theme.base, 0.72),
    border = with_alpha(theme.moss, 0.45),
  },
  item = {
    bg = with_alpha(theme.surface, 0.88),
    border = with_alpha(theme.moss, 0.35),
    text = theme.text,
  },
  apple = theme.text,
  spaces = {
    icon = {
      color = theme.subtle,
      highlight = theme.matcha,
    },
    label = {
      color = theme.muted,
      highlight = theme.cream,
    },
    indicator = theme.matcha,
  },
  media = {
    label = theme.matcha,
  },
  widgets = {
    battery = {
      low = theme.clay,
      mid = theme.gold,
      high = theme.matcha,
    },
    wifi = { icon = theme.matcha },
    volume = {
      icon = theme.subtle,
      bg1 = theme.overlay,
      popup = {
        item = theme.subtle,
        highlight = theme.text,
      },
      slider = {
        highlight = theme.matcha,
        bg = theme.overlay,
        border = theme.moss,
      },
    },
    messages = { icon = theme.clay },
  },
  calendar = {
    label = theme.subtle,
  },
}

return M
