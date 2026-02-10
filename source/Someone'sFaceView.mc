import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Position;

class Someone_sFaceView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        // ---------- Update Variables ----------

        // General Variables
        var location = Position.getInfo();
        //var settings = System.getDeviceSettings();
        var now = Time.now();

        // Get the current time and format it correctly

        var clockTime = System.getClockTime();
        var timeString = convertTime(clockTime.hour, clockTime.min);

        /*
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var mins = clockTime.min;

        if (!Application.Properties.getValue("TimeColon")) {
            timeFormat = "$1$$2$";
        }

        if (!settings.is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            } else if (hours == 0) {
                hours = 12;
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, mins.format("%02d")]);
        */

        // Get UTC information
        var secs = clockTime.sec;
        var offset = clockTime.timeZoneOffset;

        var utcSecs = (clockTime.hour * 3600) + (clockTime.min * 60) + secs - offset;

        // Get and format Weekday and Date
        var dayInfo = Gregorian.info(now, Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [
            dayInfo.day_of_week.toUpper(),
            dayInfo.day
        ]);

        // Get Heart Rate Info
        var hrData = Toybox.ActivityMonitor.getHeartRateHistory(1,true).next().heartRate;

        // Get Sun Status (Sunrise or Sundown, whichever is next)
        var sunRise = Weather.getSunrise(location.position, now);
        var sunSet = Weather.getSunset(location.position, now);
        var sun = [null as Boolean, null as Integer, null as Integer]; // Var 1 is the next sun event (False for rise, True for set, null for not available), Var 2 is the time in seconds that the sun event occurs at.
        var nextSunEvent = null;
        /* 
        var sunRise = null;
        var sunSet = null;

        if (location.accuracy >= Position.QUALITY_LAST_KNOWN){
            sunRise = Weather.getSunrise(location.position, now);
            sunSet = Weather.getSunset(location.position, now);
        } */
        if (sunRise != null && sunSet != null) {
            if (now.value() > sunRise.value()) {
                if (now.value() > sunSet.value()){
                    var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
                    var tomorrow = now.add(oneDay);
                    nextSunEvent = Weather.getSunrise(location.position, tomorrow);
                    sun[0] = false;
                }else{
                    nextSunEvent = sunSet;
                    sun[0] = true;
                }
            }else{
                nextSunEvent = sunRise;
                sun[0] = false;
            }
            if(sun[0] != null && nextSunEvent instanceof Moment){
                nextSunEvent = Gregorian.localMoment(location.position, nextSunEvent);
                if (nextSunEvent != null){
                    nextSunEvent = Gregorian.info(nextSunEvent, Time.FORMAT_SHORT);
                    sun[1] = nextSunEvent.hour;
                    sun[2] = nextSunEvent.min;
                }
                
            }
        }


        // ---------- Update the Watch Face ----------

        // Update the time
        var time = View.findDrawableById("TimeLabel") as Text;
        //time.setColor(Application.Properties.getValue("TimeColor") as Number);
        time.setText(timeString);

        //Update the Seconds
        var seconds = View.findDrawableById("seconds") as Text;
        //seconds.setColor(Application.Properties.getValue("TimeColor") as Number);
        seconds.setText(secs.format("%02d"));

        // Update UTC
        var utcText = View.findDrawableById("utc") as Text;
        //time.setColor(Application.Properties.getValue("??????") as Number);
        utcText.setText((utcSecs/3600 % 24).format("%02d"));

        // Update Day of Week and Day
        var text1Label = View.findDrawableById("dateString") as Text;
        //text1Label.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        text1Label.setText(dateString);

        // Update Heart Rate Data
        var hr = View.findDrawableById("heartRate") as Text;
        //hr.setColor(Application.Properties.getValue("TimeColor") as Number);
        if (hrData == null or hrData == ActivityMonitor.INVALID_HR_SAMPLE){
            hr.setText("--");
        }else{
            hr.setText(hrData.format("%d"));
        }
        
        // Update Sun Status
        var sunData = View.findDrawableById("sun") as Text;
        //sun.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (sun[0] != null){
            sunData.setText(convertTime(sun[1], sun[2]));
                
                //Lang.format("$1$:$2$", [sun[1].hour, sun[1].minute]));
        }else{
            if (Application.Properties.getValue("TimeColon")){
                sunData.setText("--:--");
            }else{
                sunData.setText("----");
            }
        }
        

        // ---------- Update Non-Regular Information ----------

        // Print +30 Min timezone notice
        offset %= 3600;
        if (offset != 0) { // (true)
            var utcNewfoundland = View.findDrawableById("newfoundland") as Text;
            utcNewfoundland.setText((offset/60).format("%02d"));
            //utcNewfoundland.setText("-30");
        }

        // ---------- Send the Updates ----------

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // ---------- Dev Tools ----------
        //drawReferenceLines(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    // Convert time into the correct format per settings
    function convertTime(hours as Integer, mins as Integer) as String{
        var timeFormat = "$1$:$2$";
        var settings = System.getDeviceSettings();

        if (!Application.Properties.getValue("TimeColon")) {
            timeFormat = "$1$$2$";
        }
        if (!settings.is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            } else if (hours == 0) {
                hours = 12;
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                hours = hours.format("%02d");
            }
        }
        return Lang.format(timeFormat, [hours, mins.format("%02d")]);
    }


    // DEV
    function drawReferenceLines(dc as Dc) as Void {
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();

        dc.setPenWidth(1);

        var MAIN_COLOR = Graphics.COLOR_DK_GRAY;//COLOR_WHITE;
        var ACCENT_COLOR_1 = Graphics.COLOR_DK_BLUE;
        var ACCENT_COLOR_2 = Graphics.COLOR_DK_RED;
        var TRANSPARENT = Graphics.COLOR_TRANSPARENT;

        dc.setColor(MAIN_COLOR, TRANSPARENT);
        dc.drawRectangle(0.2 * WIDTH, 0.1 * HEIGHT, 0.6 * WIDTH, 0.8 * HEIGHT);
        dc.drawRectangle(0.15 * WIDTH, 0.15 * HEIGHT, 0.7 * WIDTH, 0.7 * HEIGHT);
        dc.setColor(ACCENT_COLOR_1, TRANSPARENT);
        dc.drawRectangle(0.1 * WIDTH, 0.2 * HEIGHT, 0.8 * WIDTH, 0.6 * HEIGHT);
        dc.drawRectangle(0.05 * WIDTH, 0.3 * HEIGHT, 0.9 * WIDTH, 0.4 * HEIGHT);

        dc.setColor(MAIN_COLOR, TRANSPARENT);
        dc.fillRectangle(0, 0.25 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0, 0.5 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0, 0.75 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0.25 * WIDTH, 0, 1, HEIGHT);

        dc.fillRectangle(0.1 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.9 * WIDTH, 0, 1, HEIGHT);

        dc.fillRectangle(0.5 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.75 * WIDTH, 0, 1, HEIGHT);

        dc.setColor(ACCENT_COLOR_2, TRANSPARENT);
        dc.fillRectangle(0.3333 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.6666 * WIDTH, 0, 1, HEIGHT);
    }

}
