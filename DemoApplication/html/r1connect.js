var R1ConnectBridgePlatforms = {
    UNKNOWN: 0,
    IOS: 1,
    ANDROID: 2
};

window.R1Connect = {
    iosBridgeScheme: "r1connectbridge://",

    platform: R1ConnectBridgePlatforms.UNKNOWN,

    iosURLQueue: [],
    iosInProgress: false,

    buildIOSUrl: function(eventName, parameters) {
        var url = this.iosBridgeScheme + 'emit/?event=' + eventName;

        if (parameters)
            url += '&params='+JSON.stringify(parameters);

        return url;
    },

    sendURLInFrame: function(url) {
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", encodeURI(url));
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);

        iframe = null;
    },

    emitEvent: function(eventName, parameters) {
        if (this.platform == R1ConnectBridgePlatforms.UNKNOWN) {
            if (window.R1ConnectJSInterface && window.R1ConnectJSInterface.emit)
                this.platform = R1ConnectBridgePlatforms.ANDROID;
            else
                this.platform = R1ConnectBridgePlatforms.IOS;
        }

        if (this.platform == R1ConnectBridgePlatforms.ANDROID) {
            window.R1ConnectJSInterface.emit(eventName, parameters ? JSON.stringify(parameters) : '');
            return;
        }

        var iosURL = this.buildIOSUrl(eventName, parameters);

        if (this.iosInProgress) {
            this.iosURLQueue.push(iosURL);
            return;
        }

        this.iosInProgress = true;
        this.sendURLInFrame(iosURL);
    },

    iosURLReceived: function() {
        setTimeout(function() {
            window.R1Connect._iosURLReceived();
        }, 0);
    },

    _iosURLReceived: function() {
        if (this.iosURLQueue.length == 0) {
            this.iosInProgress = false;
            return;
        }

        var iosURL = this.iosURLQueue.shift();
        this.sendURLInFrame(iosURL);    
    },
};