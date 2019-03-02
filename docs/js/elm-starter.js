(function(w) {
    let color = {
        default: "background: #fffbb2; color: brown; font-family: monospace",
        red: "background: red; color: #fffbb2",
        blue: "background: #77d7ef; color: white",
    };
    console.info('%c Made with %c ❤ %c and %c Elm %c in Rakuten ', color.default, color.red, color.default, color.blue, color.default);
    let headerHeight = 10;
    let pageInTopArea = pageYOffset <= headerHeight;
    let node = w.document.createElement('div');
    let storageKey = "store";
    let ls = JSON.parse(localStorage.getItem(storageKey)) || {};
    flags = {
        nightMode : typeof ls.nightMode == "boolean" ? ls.nightMode : false,
        width : window.innerWidth,
    };

    w.document.body.appendChild(node);
    let app = Elm.Internal.Main.init({
        flags: flags,
        node: node
    });

    app.ports.elmToLocalStorage.subscribe(function(val) {
        console.log("elmToLocalStorage", typeof val, val);
        if (val === null) {
            localStorage.removeItem(storageKey);
        } else {
            localStorage.setItem(storageKey, val);
        }
        setTimeout(function() {
            app.ports.onStoreChange.send(val);
        }, 0);
    });

    window.addEventListener("storage", function(event) {
        if (event.storageArea === localStorage && event.key === storageKey) {
            app.ports.onStoreChange.send(event.newValue);
        }
    }, false);

    window.addEventListener('scroll', function() {
        if (!pageInTopArea && pageYOffset > headerHeight) {
            return;
        }
        if (pageInTopArea && pageYOffset <= headerHeight) {
            return;
        }
        pageInTopArea = !pageInTopArea;
        app.ports.pageInTopArea.send(pageInTopArea);
    }, false);


    window.app = app;
})(window || {});
