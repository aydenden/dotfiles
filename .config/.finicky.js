module.exports = {
    defaultBrowser: "Google Chrome",
    handlers: [
        {
            match: [""],
            // https://github.com/johnste/finicky/wiki/Configuration#2-you-can-define-more-options-with-a-browser-object
            browser: {
                name: "Google Chrome",
                // ~/Library/Application Support/Google/Chrome/{Default/Profile 2/....}
                profile: "Profile 2",
            }
        }
    ]
};
