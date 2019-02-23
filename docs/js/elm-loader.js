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
    w.document.body.appendChild(node);
    let app = Elm.Internal.Main.init({
        flags: {
            width: w.innerWidth
        },
        node: node
    });
    (function(headerHeight, pageInTopArea, app) {
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
    })(headerHeight, pageInTopArea, app);
    window.app = app;
})(window || {});
