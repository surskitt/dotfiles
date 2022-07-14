# Autogenerated config.py
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

import os

config.load_autoconfig(False)

config.source("colors.py")
config.source("completion.py")
config.source("content.py")
config.source("downloads.py")
config.source("fonts.py")
config.source("hints.py")
config.source("input.py")
config.source("keyhint.py")
config.source("prompt.py")
config.source("qt.py")
config.source("scrolling.py")
config.source("search.py")
config.source("statusbar.py")
config.source("tabs.py")
config.source("url.py")
config.source("window.py")
config.source("zoom.py")

config.source("bindings.py")

c.auto_save.session = True
c.editor.command = [
    "st",
    "-e",
    "vim",
    "-f",
    "{file}",
    "-c",
    "normal {line}G{column0}l",
]
c.messages.timeout = 5000

c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
]

#  c.fileselect.handler = "external"
#  picker_command = [
#      "floater.sh",
#      "st",
#      "-g",
#      "180x50",
#      "-e",
#      "lfpick.sh",
#      "{}",
#  ]
#  c.fileselect.single_file.command = picker_command
#  c.fileselect.multiple_files.command = picker_command

#  from qutebrowser.api import interceptor

#  # Youtube adblock
#  def filter_yt(info: interceptor.Request):
#      """Block the given request if necessary."""
#      url = info.request_url
#      if (
#          url.host() == "www.youtube.com"
#          and url.path() == "/get_video_info"
#          and "&adformat=" in url.query()
#      ):
#          info.block()


#  interceptor.register(filter_yt)
