// Finicky 4+ — set System Settings → Desktop & Dock → Default web browser → Finicky
// Docs: https://github.com/johnste/finicky/wiki/Configuration-(v3)

module.exports = {
  defaultBrowser: "Safari",

  handlers: [
    {
      match: /youtube.com/,
      browser: ({ modifierKeys }) => {
        if (modifierKeys.shift) return "Finicky"; // force chooser
        return "Google Chrome";
      }
    },

    {
      match: () => true,
      browser: ({ modifierKeys }) => {
        if (modifierKeys.shift) return "Finicky"; // hold Shift → choose manually
        return "Safari";
      }
    }
  ]
};