// Finicky — picks which browser opens each link. PUBLIC config: keep only
// generic rules here (no private domains/emails). Set Finicky as the default
// browser in System Settings > Desktop & Dock > Default web browser.
//
// Docs: https://github.com/johnste/finicky/wiki/Configuration
//
// defaultBrowser is Browserino (manual picker). Browserino is personal-only
// (Brewfile.personal) — trust the tap once, then `make brew`. On a work
// machine without Browserino, change this to "Safari" (or your work browser).

export default {
  defaultBrowser: "browserino",

  options: {
    hideIcon: false, // menu bar icon → open Finicky / logs / UI without clicking a link
    keepRunning: true, // stay resident so the chooser opens quickly
  },

  handlers: [
    {
      match: /youtube.com/,
      browser: () => {
        // if (finicky.getModifierKeys().shift) return "Finicky"; // force chooser
        return "Brave Browser";
      }
    },

    {
      match: () => true,
      browser: () => {
        return "browserino";
      }
    }
  ]
};
