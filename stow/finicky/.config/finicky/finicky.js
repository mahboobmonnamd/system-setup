// Finicky — picks which browser opens each link. PUBLIC config: keep only
// generic rules here (no private domains/emails). Set Finicky as the default
// browser in System Settings > Desktop & Dock > Default web browser.
//
// Docs: https://github.com/johnste/finicky/wiki/Configuration
//
// This starter routes everything to Brave, with two example rule types you
// can copy. For machine-specific/private routing, add rules referencing your
// own domains here on your machine, or keep them minimal for the public repo.

export default {
  defaultBrowser: "Brave Browser",

  handlers: [
    // Open links from chat/mail apps in the default browser (example of
    // matching by the app that opened the link).
    // {
    //   match: ({ opener }) => ["Slack", "Mail"].includes(opener.name),
    //   browser: "Brave Browser",
    // },

    // Send a specific set of sites to a different browser (example of matching
    // by URL host — replace with your own).
    // {
    //   match: ["*.figma.com/*", "meet.google.com/*"],
    //   browser: "Google Chrome",
    // },
  ],
};
