config.bind("b", "set-cmd-text -s :buffer")
config.bind(",p", "spawn --userscript qutepocket")
config.bind(",P", "spawn --userscript password_fill")
config.bind(",y", "spawn --userscript youtube-dl.sh {url}")
config.bind(",Y", "hint links spawn --userscript youtube-dl.sh {hint-url}")
config.bind(",m", "spawn mpv {url}")
config.bind(",M", "hint links spawn mpv {hint-url}")
config.bind(",o", "spawn /home/shane/.scripts/link_handler.sh {url}")
config.bind(
    ",O", "hint links spawn /home/shane/.scripts/link_handler.sh {hint-url}"
)
config.bind(",g", "spawn --userscript gallery.sh {url}")
config.bind(",G", "hint links spawn --userscript gallery.sh {hint-url}")
config.bind(",b", "spawn --userscript qute-buku.py")
config.bind(",B", "set-cmd-text -s :spawn -u qute-buku.py ")
config.bind(",t", "config-cycle tabs.show never always")
config.bind("cm", "clear-messages")
config.bind("<return>", "follow-selected")
config.bind("<Alt-j>", "tab-move +")
config.bind("<Alt-k>", "tab-move -")
config.bind(",j", "config-cycle content.javascript.enabled false true")
config.bind(
    ",D",
    "config-cycle content.user_stylesheets stylesheets/nord-dark.css ''",
)
config.bind(",9", "open 9xbud.com/{url}")
