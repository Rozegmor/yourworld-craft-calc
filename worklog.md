# Craft Calculator Worklog

---
Task ID: 0
Agent: main
Task: Initial setup — read and understand the craft-calc HTML file

Work Log:
- Read the full HTML file (2500 lines)
- Identified structure: CSS (lines 10-645), HTML body (647-724), JS data+logic (725-2500)
- Current changelog: v1.0 (initial) and v1.1 (3 июня 2026)
- Key features: recipes database, craft calculator, inventory, HDD tracking, favorites, craft tree, multi-craft, theme toggle, easter egg, drag-drop, recent recipes, history with undo, export/import
- Categories: workbench, items, craft_resources, electronic, conserv, medicine, cases, weapons
- Version button shows "v1.1"

Stage Summary:
- File copied to /home/z/my-project/download/craft-calc.html
- Ready for modifications per user requests
- Changelog convention: one version per day, no repeating text

---
Task ID: 1
Agent: main
Task: Fix mobile bottom navigation not responding to taps

Work Log:
- Diagnosed root cause: `.inv-modal` element had `pointer-events:auto` always, even when invisible (opacity:0)
- On mobile screens (~375px wide), the modal (width:380px, position:fixed, bottom:20px, right:20px) overlapped the bottom navigation area
- Even though invisible, it captured all touch/click events, blocking the bottom nav buttons
- Fix 1: Changed `.inv-modal` from `pointer-events:auto` to `pointer-events:none` by default
- Fix 2: Added `pointer-events:auto` only when `.inv-modal-overlay.open .inv-modal` is active
- Fix 3: Added `max-width:calc(100vw - 40px)` to `.inv-modal` to prevent overflow on narrow screens
- Fix 4: Added `padding-bottom:env(safe-area-inset-bottom,0px)` to `.bottom-nav` for iPhone Home Indicator
- Fix 5: Added `env(safe-area-inset-bottom)` to `.left-panel` padding-bottom in mobile media query
- Updated version button from v1.1 to v1.2
- Added v1.2 changelog entry (4 июня 2026)

Stage Summary:
- Bug fixed: mobile bottom navigation now receives touch events properly
- Version bumped to v1.2
- File: /home/z/my-project/download/craft-calc.html

---
Task ID: 1
Agent: main
Task: Fix scrollbar - system scrollbar appearing on hover over custom Stalker scrollbar

Work Log:
- Analyzed custom scrollbar implementation (.cs-scroller, .cs-sb-v, .cs-sb-thumb)
- Found that system scrollbar was still visible because only scrollbar-width:thin was set globally, not hidden for cs-scroller elements
- Added CSS rules: .cs-scroller{scrollbar-width:none!important} and .cs-scroller::-webkit-scrollbar{display:none!important;width:0!important;height:0!important}
- This hides the system scrollbar for elements that have the custom Stalker scrollbar, while keeping system scrollbar for other elements

Stage Summary:
- System scrollbar no longer shows on elements with custom Stalker scrollbar
- Custom scrollbar remains the only visible scrollbar for .left-panel, .right-content, etc.

---
Task ID: 2
Agent: main
Task: Fix Stalker easter egg music not playing

Work Log:
- Verified archive.org URLs are accessible (HTTP 200, CORS allowed)
- Identified root cause: audio.play() was called immediately when clickCount reached 10, but audio might not have loaded yet (readyState < HAVE_FUTURE_DATA)
- Rewrote playMusic() to wait for 'canplaythrough' event before calling play()
- Simplified MUSIC_SRCS to single working URL (archive.org/download version)
- Simplified preloadMusic() - removed complex multi-source fallback logic
- Fixed error handler to reset isPreloaded flag instead of calling stopMusic() prematurely

Stage Summary:
- Music now waits for audio to be playable before attempting play()
- Cleaner code with single audio source URL
- Better error recovery - allows retry if audio fails to load

---
Task ID: 1-v2
Agent: main
Task: Fix scrollbar - deeper fix for system scrollbar appearing on #itemGrid

Work Log:
- Identified root cause: #itemGrid has overflow-y:auto and max-height, making it the actual scrolling container, NOT .left-panel
- Custom scrollbar was only initialized on .left-panel, not #itemGrid
- Added #itemGrid to CSS scrollbar hiding rules: #itemGrid{scrollbar-width:none!important} and #itemGrid::-webkit-scrollbar{display:none!important}
- Added #itemGrid to custom scrollbar initialization list in initAll() and MutationObserver
- Added if(window._initCSB)window._initCSB(el) calls after every el.innerHTML assignment in renderGrid() and favorites render
- Fixed onWheel handler to use stopPropagation only when actually scrolling (prevents nested scroll conflicts)
- Changed wheel handler: only calls preventDefault/stopPropagation when scrollTop actually changes, allows event to bubble when at scroll boundaries

Stage Summary:
- System scrollbar completely hidden for #itemGrid
- Custom Stalker-style scrollbar now initialized on #itemGrid
- Scrollbar re-initialized after every renderGrid() call (since innerHTML destroys the custom scrollbar element)
- Nested scroll conflict resolved with smart stopPropagation

---
Task ID: 2-v2
Agent: main
Task: Fix Stalker easter egg music - complete rewrite of audio logic

Work Log:
- Changed audio element from preload="none" to preload="auto" (allows browser to start loading immediately)
- Added CDN direct URL as primary source (dn720306.ca.archive.org), archive.org redirect URL as fallback
- Rewrote preloadMusic() with proper error handling and source fallback chain
- Added console.log/warn for debugging audio loading issues
- Added loadeddata event listener in addition to canplaythrough (some browsers fire loadeddata first)
- playMusic() now checks if preloadMusic was called and calls it if not
- Removed the global audio error handler that was resetting isPreloaded

Stage Summary:
- Audio should now load properly with preload="auto" and direct CDN URL
- Dual event listeners (canplaythrough + loadeddata) ensure play() is called as soon as possible
- Fallback to second URL if first fails
- Debug logging added to console for troubleshooting
