import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_TRANSPARENT, Application.Properties.getValue("BackgroundColor") as Number);
        dc.clear();

        // ---------- Draw Time Background Shape ----------
        dc.setColor(Application.Properties.getValue("AccentTimeBGColor") as Number, Graphics.COLOR_TRANSPARENT);
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();
        var ARC_WIDTH = HEIGHT/55;
        var hOffset = 0.07;
        var vOffset = 0.36;
        dc.fillRectangle(WIDTH*hOffset, HEIGHT*vOffset, WIDTH*(1-hOffset*2), HEIGHT*(1-vOffset*2));
        dc.fillEllipse(WIDTH*hOffset, HEIGHT*0.5, WIDTH*hOffset-2.5*ARC_WIDTH,HEIGHT*(1-2*vOffset)/2);
        dc.fillEllipse(WIDTH*(1-hOffset), HEIGHT*0.5, WIDTH*hOffset-2.5*ARC_WIDTH,HEIGHT*(1-2*vOffset)/2);
    }

}
