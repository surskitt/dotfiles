import os
import json

with open(os.path.expanduser('~/.cache/wal/colors.json')) as f:
    colors = json.load(f)

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = colors['special']['background']

# Bottom border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.bottom = colors['special']['background']

# Top border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.top = colors['special']['background']

# Foreground color of completion widget category headers.
# Type: QtColor
c.colors.completion.category.fg = colors['special']['foreground']

# Background color of the completion widget for even rows.
# Type: QssColor
c.colors.completion.even.bg = colors['special']['background']

# Text color of the completion widget.
# Type: QtColor
c.colors.completion.fg = colors['special']['foreground']

# Background color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.bg = colors['colors']['color8']

# Bottom border color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.border.bottom = colors['colors']['color8']

# Top border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.item.selected.border.top = colors['colors']['color8']

# Foreground color of the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.fg = colors['special']['foreground']

# Foreground color of the matched text in the completion.
# Type: QssColor
c.colors.completion.match.fg = colors['colors']['color2']

# Background color of the completion widget for odd rows.
# Type: QssColor
c.colors.completion.odd.bg = colors['special']['background']

# Color of the scrollbar in completion view
# Type: QssColor
c.colors.completion.scrollbar.bg = colors['special']['foreground']

# Color of the scrollbar handle in completion view.
# Type: QssColor
c.colors.completion.scrollbar.fg = colors['special']['foreground']

# Background color for the download bar.
# Type: QssColor
c.colors.downloads.bar.bg = colors['special']['background']

# Background color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.bg = colors['colors']['color1']

# Foreground color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.fg = colors['special']['foreground']

# Color gradient start for download backgrounds.
# Type: QtColor
c.colors.downloads.start.bg = colors['colors']['color4']

# Color gradient start for download text.
# Type: QtColor
c.colors.downloads.start.fg = colors['special']['background']

# Color gradient stop for download backgrounds.
# Type: QtColor
c.colors.downloads.stop.bg = colors['colors']['color2']

# Color gradient end for download text.
# Type: QtColor
c.colors.downloads.stop.fg = colors['special']['background']

# Color gradient interpolation system for download backgrounds.
# Type: ColorSystem
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
c.colors.downloads.system.bg = 'none'

# Color gradient interpolation system for download text.
# Type: ColorSystem
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
c.colors.downloads.system.fg = 'none'

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
# Type: QssColor
c.colors.hints.bg = colors['special']['background']

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = colors['special']['foreground']

# Font color for the matched part of hints.
# Type: QssColor
c.colors.hints.match.fg = colors['special']['foreground']

# Background color of the keyhint widget.
# Type: QssColor
# c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'

# Text color for the keyhint widget.
# Type: QssColor
c.colors.keyhint.fg = colors['special']['foreground']

# Highlight color for keys to complete the current keychain.
# Type: QssColor
c.colors.keyhint.suffix.fg = colors['colors']['color3']

# Background color of an error message.
# Type: QssColor
c.colors.messages.error.bg = colors['colors']['color1']

# Border color of an error message.
# Type: QssColor
c.colors.messages.error.border = colors['colors']['color1']

# Foreground color of an error message.
# Type: QssColor
c.colors.messages.error.fg = colors['special']['foreground']

# Background color of an info message.
# Type: QssColor
c.colors.messages.info.bg = colors['special']['background']

# Border color of an info message.
# Type: QssColor
c.colors.messages.info.border = colors['special']['background']

# Foreground color an info message.
# Type: QssColor
c.colors.messages.info.fg = colors['special']['foreground']

# Background color of a warning message.
# Type: QssColor
c.colors.messages.warning.bg = colors['colors']['color3']

# Border color of a warning message.
# Type: QssColor
c.colors.messages.warning.border = colors['colors']['color3']

# Foreground color a warning message.
# Type: QssColor
c.colors.messages.warning.fg = colors['special']['background']

# Background color for prompts.
# Type: QssColor
c.colors.prompts.bg = colors['special']['background']

# Border used around UI elements in prompts.
# Type: String
c.colors.prompts.border = '1px solid ' + colors['special']['foreground']

# Foreground color for prompts.
# Type: QssColor
c.colors.prompts.fg = colors['special']['foreground']

# Background color for the selected item in filename prompts.
# Type: QssColor
c.colors.prompts.selected.bg = colors['colors']['color0']

# Background color of the statusbar in caret mode.
# Type: QssColor
c.colors.statusbar.caret.bg = colors['colors']['color4']

# Foreground color of the statusbar in caret mode.
# Type: QssColor
c.colors.statusbar.caret.fg = colors['special']['foreground']

# Background color of the statusbar in caret mode with a selection.
# Type: QssColor
c.colors.statusbar.caret.selection.bg = colors['colors']['color0']

# Foreground color of the statusbar in caret mode with a selection.
# Type: QssColor
c.colors.statusbar.caret.selection.fg = colors['special']['foreground']

# Background color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.bg = colors['special']['background']

# Foreground color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.fg = colors['special']['foreground']

# Background color of the statusbar in private browsing + command mode.
# Type: QssColor
c.colors.statusbar.command.private.bg = colors['colors']['color0']

# Foreground color of the statusbar in private browsing + command mode.
# Type: QssColor
c.colors.statusbar.command.private.fg = colors['special']['foreground']

# Background color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.bg = colors['special']['foreground']

# Foreground color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.fg = colors['special']['background']

# Background color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.bg = colors['special']['background']

# Foreground color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.fg = colors['special']['foreground']

# Background color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.bg = colors['special']['background']

# Foreground color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.fg = colors['special']['foreground']

# Background color of the statusbar in private browsing mode.
# Type: QssColor
c.colors.statusbar.private.bg = colors['colors']['color0']

# Foreground color of the statusbar in private browsing mode.
# Type: QssColor
c.colors.statusbar.private.fg = colors['special']['foreground']

# Background color of the progress bar.
# Type: QssColor
c.colors.statusbar.progress.bg = colors['special']['foreground']

# Foreground color of the URL in the statusbar on error.
# Type: QssColor
c.colors.statusbar.url.error.fg = colors['colors']['color1']

# Default foreground color of the URL in the statusbar.
# Type: QssColor
c.colors.statusbar.url.fg = colors['special']['foreground']

# Foreground color of the URL in the statusbar for hovered links.
# Type: QssColor
c.colors.statusbar.url.hover.fg = colors['special']['foreground']

# Foreground color of the URL in the statusbar on successful load
# (http).
# Type: QssColor
c.colors.statusbar.url.success.http.fg = colors['special']['foreground']

# Foreground color of the URL in the statusbar on successful load
# (https).
# Type: QssColor
c.colors.statusbar.url.success.https.fg = colors['special']['foreground']

# Foreground color of the URL in the statusbar when there's a warning.
# Type: QssColor
c.colors.statusbar.url.warn.fg = colors['colors']['color3']

# Background color of the tab bar.
# Type: QtColor
# c.colors.tabs.bar.bg = '#555555'

# Background color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.bg = colors['special']['background']

# Foreground color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.fg = colors['special']['foreground']

# Color for the tab indicator on errors.
# Type: QtColor
c.colors.tabs.indicator.error = colors['colors']['color1']

# Color gradient start for the tab indicator.
# Type: QtColor
c.colors.tabs.indicator.start = colors['colors']['color0']

# Color gradient end for the tab indicator.
# Type: QtColor
c.colors.tabs.indicator.stop = colors['colors']['color3']

# Color gradient interpolation system for the tab indicator.
# Type: ColorSystem
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
# c.colors.tabs.indicator.system = 'rgb'

# Background color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.bg = colors['special']['background']

# Foreground color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.fg = colors['special']['foreground']

# Background color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.bg = colors['special']['foreground']

# Foreground color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.fg = colors['special']['background']

# Background color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.bg = colors['special']['foreground']

# Foreground color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.fg = colors['special']['background']

c.colors.tabs.bar.bg = colors['colors']['color8']

# Background color for webpages if unset (or empty to use the theme's
# color)
# Type: QtColor
# c.colors.webpage.bg = 'fg'

# CSS border value for hints.
# Type: String
# c.hints.border = '1px solid #E3BE23'
