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
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();
        var ARC_WIDTH = HEIGHT/55;
        var hOffset = 0.07;
        var vOffset = 0.365;
        if (CAN_BURN_IN){//Allow colors for OLEDs/AMOLEDs due to higher range
            dc.setColor(Application.Properties.getValue("AccentTimeBGColor") as Number, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(WIDTH*hOffset, HEIGHT*vOffset, WIDTH*(1-hOffset*2), HEIGHT*(1-vOffset*2));
            dc.fillEllipse(WIDTH*hOffset+1, HEIGHT*0.5 -1, WIDTH*hOffset-2.5*ARC_WIDTH,HEIGHT*(1-2*vOffset)/2);
            dc.fillEllipse(WIDTH*(1-hOffset), HEIGHT*0.5 -1, WIDTH*hOffset-2.5*ARC_WIDTH,HEIGHT*(1-2*vOffset)/2);
        }else{//Disable colors for MIP due for accessibility and Readability
            dc.setColor(Application.Properties.getValue("AccentLinesColor") as Number, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(WIDTH*hOffset, HEIGHT*vOffset, 
                    WIDTH*(1-hOffset), HEIGHT*vOffset);//Top clock line
            dc.drawLine(WIDTH*hOffset, HEIGHT*(1-vOffset), 
                    WIDTH*(1-hOffset), HEIGHT*(1-vOffset));//Bottom clock line
        }
    }

}
