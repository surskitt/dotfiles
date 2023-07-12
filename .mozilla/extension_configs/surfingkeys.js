// todo
// add a b shortcut to open bookmarks in omnibar
// add a B shortcut to open bookmarks in new tab in omnibar
// make youtube shortcuts work
// add 9xbud shortcut (9xbud.com/https://www.youtube.com/watch?v=KMU0tzLwhbE)

// settings.omnibarPosition = 'bottom';
settings.defaultSearchEngine = 'l';
settings.focusFirstCandidate = false;
settings.focusAfterClosed = 'left';
settings.tabsThreshold = 0;

// open url in current tab
api.map('o', 'go');
api.map('O', 't');

// open hint in new tab
api.map('F', 'C');

// history back/forward
api.map('H', 'S');
api.map('L', 'D');

api.map('B', 'b');

// choosse a buffer/tab
api.map('b', 'T');

// Scroll Page Down/Up
api.map('w', 'e');
api.map('s', 'd');

// Tab Next/Prev
api.map('J', 'R');
api.map('K', 'E');

// Move current tab up and down
api.map('<Alt-j>', '>>');
api.map('<Alt-k>', '<<');

// close current tab
api.map('d', 'x');

// undo close tab
api.map('u', 'X');

api.map('+', 'zi');
api.map('-', 'zo');
api.map('=', 'zr');

api.cmap('<Ctrl-j>', '<Ctrl-n>');
api.cmap('<Ctrl-k>', '<Ctrl-p>');

api.mapkey('ym', "#7Copy current page's url in markdown format", () => {
    api.Clipboard.write( '[' + document.title + '](' + window.location.href + ')');
});

// api.mapkey('on', '#3Open newtab', function () {
//     tabOpenLink("www.google.com");
// });

api.removeSearchAlias('b', 's');
api.removeSearchAlias('h', 's');
api.removeSearchAlias('r', 's');
api.removeSearchAlias('w', 's');

api.addSearchAlias('a', 'amazon', 'https://www.amazon.co.uk/s?k=', 's');
api.addSearchAlias('aw', 'arch wiki', 'https://wiki.archlinux.org/index.php?title=Special:Search&search=', 's');
api.addSearchAlias('dl',  'ddg lucky', 'https://duckduckgo.com/?q=\\', 's');
api.addSearchAlias('eb', 'ebay', 'https://www.ebay.co.uk/sch/i.html?_from=R40&_trksid=m570.l1313&_nkw=', 's'); 
api.addSearchAlias('gh', 'github', 'https://github.com/search?q=', 's');
api.addSearchAlias('i', 'google images', 'https://www.google.com/search?tbm=isch&q=d', 's');
api.addSearchAlias('l', 'Im feeling lucky', 'https://www.google.com/search?btnI=1&q=', 's');
api.addSearchAlias('m', 'google maps', 'https://www.google.com/maps?q=', 's');
api.addSearchAlias('r', 'reddit', 'https://www.reddit.com/search/?q=', 's');
api.addSearchAlias('wk', 'wikipedia', 'https://en.wikipedia.org/wiki/Special:Search/', 's');

// Nord hints
api.Hints.style('border: solid 2px #4C566A; color:#A3BE8C; background: initial; background-color: #3B4252; font-size: 11pt;');
api.Hints.style("border: solid 2px #4C566A !important; padding: 1px !important; color: #E5E9F0 !important; background: #3B4252 !important;", "text");
api.Visual.style('marks', 'background-color: #A3BE8C99;');
api.Visual.style('cursor', 'background-color: #88C0D0;');

settings.theme = `
/* Edit these variables for easy theme making */
:root {
  /* Font */
  --font: 'SauceCodePro Nerd Font Mono', Ubuntu, sans;
  --font-size: 14;
  --font-weight: bold;

  --fg: #E5E9F0;
  --bg: #3B4252;
  --bg-dark: #2E3440;
  --border: #4C566A;
  --main-fg: #88C0D0;
  --accent-fg: #A3BE8C;
  --info-fg: #5E81AC;
  --select: #4C566A;

  /* Unused Alternate Colors */
  /* --orange: #D08770; */
  /* --red: #BF616A; */
  /* --yellow: #EBCB8B; */
}

/* ---------- Generic ---------- */
.sk_theme {
background: var(--bg);
color: var(--fg);
  background-color: var(--bg);
  border-color: var(--border);
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
}

input {
  font-family: var(--font);
  font-weight: var(--font-weight);
}

.sk_theme tbody {
  color: var(--fg);
}

.sk_theme input {
  color: var(--fg);
}

/* Hints */
#sk_hints .begin {
  color: var(--accent-fg) !important;
}

#sk_tabs .sk_tab {
  background: var(--bg-dark);
  border: 1px solid var(--border);
}

#sk_tabs .sk_tab_title {
  color: var(--fg);
}

#sk_tabs .sk_tab_url {
  color: var(--main-fg);
}

#sk_tabs .sk_tab_hint {
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--accent-fg);
}

.sk_theme #sk_frame {
  background: var(--bg);
  opacity: 0.2;
  color: var(--accent-fg);
}

/* ---------- Omnibar ---------- */
/* Uncomment this and use settings.omnibarPosition = 'bottom' for Pentadactyl/Tridactyl style bottom bar */
/* .sk_theme#sk_omnibar {
  width: 100%;
  left: 0;
} */

.sk_theme .title {
  color: var(--accent-fg);
}

.sk_theme .url {
  color: var(--main-fg);
}

.sk_theme .annotation {
  color: var(--accent-fg);
}

.sk_theme .omnibar_highlight {
  color: var(--accent-fg);
}

.sk_theme .omnibar_timestamp {
  color: var(--info-fg);
}

.sk_theme .omnibar_visitcount {
  color: var(--accent-fg);
}

.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
  background: var(--bg-dark);
}

.sk_theme #sk_omnibarSearchResult ul li.focused {
  background: var(--border);
}

.sk_theme #sk_omnibarSearchArea {
  border-top-color: var(--border);
  border-bottom-color: var(--border);
}

.sk_theme #sk_omnibarSearchArea input,
.sk_theme #sk_omnibarSearchArea span {
  font-size: var(--font-size);
}

.sk_theme .separator {
  color: var(--accent-fg);
}

/* ---------- Popup Notification Banner ---------- */
#sk_banner {
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
  background: var(--bg);
  border-color: var(--border);
  color: var(--fg);
  opacity: 0.9;
}

/* ---------- Popup Keys ---------- */
#sk_keystroke {
  background-color: var(--bg);
}

.sk_theme kbd .candidates {
  color: var(--info-fg);
}

.sk_theme span.annotation {
  color: var(--accent-fg);
}

/* ---------- Popup Translation Bubble ---------- */
#sk_bubble {
  background-color: var(--bg) !important;
  color: var(--fg) !important;
  border-color: var(--border) !important;
}

#sk_bubble * {
  color: var(--fg) !important;
}

#sk_bubble div.sk_arrow div:nth-of-type(1) {
  border-top-color: var(--border) !important;
  border-bottom-color: var(--border) !important;
}

#sk_bubble div.sk_arrow div:nth-of-type(2) {
  border-top-color: var(--bg) !important;
  border-bottom-color: var(--bg) !important;
}

/* ---------- Search ---------- */
#sk_status,
#sk_find {
  font-size: var(--font-size);
  border-color: var(--border);
}

.sk_theme kbd {
  background: var(--bg-dark);
  border-color: var(--border);
  box-shadow: none;
  color: var(--fg);
}

.sk_theme .feature_name span {
  color: var(--main-fg);
}

/* ---------- ACE Editor ---------- */
#sk_editor {
  background: var(--bg-dark) !important;
  height: 50% !important;
  /* Remove this to restore the default editor size */
}

.ace_dialog-bottom {
  border-top: 1px solid var(--bg) !important;
}

.ace-chrome .ace_print-margin,
.ace_gutter,
.ace_gutter-cell,
.ace_dialog {
  background: var(--bg) !important;
}

.ace-chrome {
  color: var(--fg) !important;
}

.ace_gutter,
.ace_dialog {
  color: var(--fg) !important;
}

.ace_cursor {
  color: var(--fg) !important;
}

.normal-mode .ace_cursor {
  background-color: var(--fg) !important;
  border: var(--fg) !important;
  opacity: 0.7 !important;
}

.ace_marker-layer .ace_selection {
  background: var(--select) !important;
}

.ace_editor,
.ace_dialog span,
.ace_dialog input {
  font-family: var(--font);
  font-size: var(--font-size);
  font-weight: var(--font-weight);
}
`;
