// ========================== ext/expand.js ========================== //
gantt.attachEvent("onTemplatesReady", function(){
    var fullScreenBth = document.createElement("DIV");
    fullScreenBth.className = "dhx_expand_icon";
    gantt.toggleIcon = fullScreenBth;
    gantt._obj.appendChild(fullScreenBth);
    fullScreenBth.onclick = function() {
        if (!gantt.expanded) {
            gantt.expand();
        }
        else {
            gantt.collapse();
        }
    };

    if(document.addEventListener) {
        document.addEventListener("webkitfullscreenchange", gantt._onFullScreenChange);
        document.addEventListener("mozfullscreenchange", gantt._onFullScreenChange);
        document.addEventListener("MSFullscreenChange", gantt._onFullScreenChange);
        //For IE on Win 10
        document.addEventListener("fullscreenChange", gantt._onFullScreenChange);
        document.addEventListener("fullscreenchange", gantt._onFullScreenChange);
    }
});

//For fullscreen closing via ESC button
gantt._onFullScreenChange = function() {
    if (gantt.expanded && (document.fullscreenElement === null ||
        document.mozFullScreenElement === null || document.webkitFullscreenElement === null ||
        document.msFullscreenElement === null)) {
        gantt.collapse();
    }
};

gantt.expand = function() {
    if(!gantt.callEvent("onBeforeExpand", []))
        return;
    var ganttBlock = gantt._obj;
    do {
        ganttBlock._position = ganttBlock.style.position || "";
        ganttBlock.style.position = "static";
    } while ((ganttBlock = ganttBlock.parentNode) && ganttBlock.style);
    ganttBlock = gantt._obj;
    ganttBlock.style.position = "absolute";
    ganttBlock._width = ganttBlock.style.width;
    ganttBlock._height = ganttBlock.style.height;
    ganttBlock.style.width = ganttBlock.style.height = "100%";
    ganttBlock.style.top = ganttBlock.style.left = "0px";

    var top = document.body;
    top.scrollTop = 0;

    top = top.parentNode;
    if (top)
        top.scrollTop = 0;
    document.body._overflow = document.body.style.overflow || "";
    document.body.style.overflow = "hidden";
    gantt._maximize();

    gantt._toggleFullScreen(true);
    gantt.callEvent("onExpand", []);
};

gantt.collapse = function() {
    if(!gantt.callEvent("onBeforeCollapse", []))
        return;
    var ganttBlock = gantt._obj;
    do {
        ganttBlock.style.position = ganttBlock._position;
    } while ((ganttBlock = ganttBlock.parentNode) && ganttBlock.style);
    ganttBlock = gantt._obj;
    ganttBlock.style.width = ganttBlock._width;
    ganttBlock.style.height = ganttBlock._height;
    document.body.style.overflow = document.body._overflow;
    gantt._maximize();

    gantt._toggleFullScreen(false);
    gantt.callEvent("onCollapse", []);
};

gantt._maximize = function() {
    this.expanded = !this.expanded;
    this.toggleIcon.style.backgroundPosition = "0 " + (this.expanded ? "0" : "18") + "px";
    this.render();
};

gantt._toggleFullScreen = function(on) {
    if (on || (!document.fullscreenElement &&    // alternative standard method
        !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement)) {  // current working methods
        if (document.documentElement.requestFullscreen) {
            document.documentElement.requestFullscreen();
        } else if (document.documentElement.msRequestFullscreen) {
            document.documentElement.msRequestFullscreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullscreen) {
            document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        }
    }
}