(function (factory) {
    if (typeof define === "function" && define.amd) {
        define(["jquery"], factory);
    } else if (typeof exports === "object") {
        module.exports = factory;
    } else {
        factory(jQuery);
    }
})(function ($) {

    var toFix = ["wheel", "mousewheel", "DOMMouseScroll", "MozMousePixelScroll"],
        toBind = ("onwheel" in window.document || window.document.documentMode >= 9) ?
            ["wheel"] : ["mousewheel", "DomMouseScroll", "MozMousePixelScroll"],
        slice = Array.prototype.slice;

    if ($.event.fixHooks) {
        for (var i = toFix.length; i;) {
            $.event.fixHooks[toFix[--i]] = $.event.mouseHooks;
        }
    }

    var special = $.event.special.mousewheel = {
        version: "3.1.12",

        setup: function () {
            if (this.addEventListener) {
                for (var i = toBind.length; i;) {
                    this.addEventListener(toBind[--i], handler, false);
                }
            } else {
                this.onmousewheel = handler;
            }
        },

        teardown: function () {
            if (this.removeEventListener) {
                for (var i = toBind.length; i;) {
                    this.removeEventListener(toBind[--i], handler, false);
                }
            } else {
                this.onmousewheel = null;
            }
        }
    };

    $.fn.extend({
        mousewheel: function (fn) {
            return fn ? this.on("mousewheel", fn) : this.trigger("mousewheel");
        },

        unmousewheel: function (fn) {
            return this.off("mousewheel", fn);
        }
    });

    function handler(event) {
        var orgEvent = event || window.event,
            args = slice.call(arguments, 1),
            delta = 0,
            deltaX = 0,
            deltaY = 0;

        event = $.event.fix(orgEvent);
        event.type = "mousewheel";

        if ("detail" in orgEvent) {
            deltaY = orgEvent.detail * -1;
        }
        if ("wheelDelta" in orgEvent) {
            deltaY = orgEvent.wheelDelta;
        }
        if ("wheelDeltaY" in orgEvent) {
            deltaY = orgEvent.wheelDeltaY;
        }
        if ("wheelDeltaX" in orgEvent) {
            deltaX = orgEvent.wheelDeltaX * -1;
        }

        if ("axis" in orgEvent && orgEvent.axis === orgEvent.HORIZONTAL_AXIS) {
            deltaX = deltaY * -1;
            deltaY = 0;
        }

        delta = deltaY === 0 ? deltaX : deltaY;

        if ("deltaY" in orgEvent) {
            deltaY = orgEvent.deltaY * -1;
            delta = deltaY;
        }
        if ("deltaX" in orgEvent) {
            deltaX = orgEvent.deltaX;
            if (deltaY === 0) {
                delta = deltaX * -1;
            }
        }

        if (deltaY === 0 && deltaX === 0) {
            return;
        }

        event.deltaX = deltaX;
        event.deltaY = deltaY;

        args.unshift(event, delta, deltaX, deltaY);

        return ($.event.dispatch || $.event.handle).apply(this, args);
    }
});

$(document).ready(function () {
    $('.main__header__items, .battlepass-append').on('mousewheel', function (e) {
        e.preventDefault();

        const scrollSpeed = 250; // Adjust speed for smooth scrolling
        const scrollAmount = e.originalEvent.deltaY < 0 ? -scrollSpeed : scrollSpeed;

        // Avoid delays by using a combination of requestAnimationFrame and immediate updates
        const targetScroll = $(this).scrollLeft() + scrollAmount;

        const smoothScroll = () => {
            const currentScroll = $(this).scrollLeft();
            const distance = targetScroll - currentScroll;
            if (Math.abs(distance) > 1) {
                $(this).scrollLeft(currentScroll + distance * 0.25); // Smooth easing
                requestAnimationFrame(smoothScroll);
            } else {
                $(this).scrollLeft(targetScroll); // Snap to the target
            }
        };

        requestAnimationFrame(smoothScroll);
    });
});