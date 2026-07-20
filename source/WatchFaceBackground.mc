import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    var CAN_BURN_IN = false;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        // Check if the device is an AMOLED. If no, then disable color behind the time for increased readability.
        // Code referenced from: https://forums.garmin.com/developer/connect-iq/f/discussion/407008/how-to-detect-if-a-watch-has-an-amoled-or-mip-display-in-monkey-c/1913737
        var systemSettings = System.getDeviceSettings();
        
        if(systemSettings has :requiresBurnInProtection) {
        	CAN_BURN_IN = systemSettings.requiresBurnInProtection;
        }

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_TRANSPARENT, Application.Properties.getValue("BackgroundColor") as Number);
        dc.clear();

        // ---------- Draw Time Background Shape ----------
        if (!CAN_BURN_IN){
            dc.setColor(Application.Properties.getValue("AccentTimeBGColor") as Number, Graphics.COLOR_TRANSPARENT);
            var WIDTH = dc.getWidth();
            var HEIGHT = dc.getHeight();
            var ARC_WIDTH = HEIGHT/55;
            var hOffset = 0.07;
            var vOffset = 0.36;
            dc.fillRectangle(WIDTH*hOffset, HEIGHT*vOffset, WIDTH*(1-hOffset*2), HEIGHT*(1-vOffset*2));
            dc.fillEllipse(WIDTH*hOffset+1, HEIGHT*0.5 -1, WIDTH*hOffset-2.5*ARC_WIDTH,HEIGHT*(1-2*vOffset)/2);
            dc.fillEllipse(WIDTH*(1-hOffset), HEIGHT*0.5 -1, WIDTH*hOffset-2.5*ARC_WIDTH,HEIGHT*(1-2*vOffset)/2);
        }
    }

}
