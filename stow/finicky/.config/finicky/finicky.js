// Finicky 4+ — set System Settings → Desktop & Dock → Default web browser → Finicky
// Docs: https://github.com/johnste/finicky/wiki/Configuration-(v4)
// ESM: https://github.com/johnste/finicky/wiki/Use-Modern-ECMAScript-Module-Syntax
//
// Picker UI: return "Finicky" as the browser. Always-on picker: defaultBrowser: "Finicky".

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
