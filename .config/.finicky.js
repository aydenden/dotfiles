module.exports = {
    defaultBrowser: "Google Chrome",
    handlers: [
        {
            match: [""],
            browser: "Google Chrome",
            // ~/Library/Application Support/Google/Chrome/{Default/Profile 2/....}
            profile: "Profile 2",
        }
    ]
};
