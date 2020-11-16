module.exports = {
    defaultBrowser: "Google Chrome Canary",
    handlers: [
        {
            // Open apple.com and example.org urls in Safari
            match: ["sentry.io*", "wiki.mrblue.com*", "jira.mrblue.com*", "gw.mrblue.com*"],
            browser: "Google Chrome"
        }
    ]
};
