import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Position;
import Toybox.SensorHistory;

class WatchFaceView extends WatchUi.WatchFace {
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
        var currentLocation = Position.getInfo();
        var systemSettings = System.getDeviceSettings();
        var now = Time.now();

        // Get the current time and format it correctly
        var currentTime = System.getClockTime();
        var timeString = convertTime(currentTime.hour, currentTime.min);

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
        var secs = currentTime.sec;
        var offset = currentTime.timeZoneOffset;

        var utcSecs = (currentTime.hour * 3600) + (currentTime.min * 60) + secs - offset;

        // Get and format Weekday and Date
        var dayInfo = Gregorian.info(now, Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [
            dayInfo.day_of_week.toUpper(),
            dayInfo.day
        ]);

        // Get Heart Rate Info
        var hrData = Toybox.ActivityMonitor.getHeartRateHistory(1,true).next().heartRate;

        // Get Sun Status (Sunrise or Sundown, whichever is next)
        var todaySunRise = Weather.getSunrise(currentLocation.position, now);
        var todaySunSet = Weather.getSunset(currentLocation.position, now);
        var nextSun = [null as Boolean, null as Integer, null as Integer]; // Var 1 is the next sun event (False for rise, True for set, null for not available), Var 2 is the time in seconds that the sun event occurs at.
        var nextSunEvent = null;

        if (todaySunRise != null && todaySunSet != null) {
            if (now.value() > todaySunRise.value()) {
                if (now.value() > todaySunSet.value()){
                    var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
                    var tomorrow = now.add(oneDay);
                    nextSunEvent = Weather.getSunrise(currentLocation.position, tomorrow);
                    nextSun[0] = false;
                }else{
                    nextSunEvent = todaySunSet;
                    nextSun[0] = true;
                }
            }else{
                nextSunEvent = todaySunRise;
                nextSun[0] = false;
            }
            if(nextSun[0] != null && nextSunEvent instanceof Moment){
                nextSunEvent = Gregorian.localMoment(currentLocation.position, nextSunEvent);
                if (nextSunEvent != null){
                    nextSunEvent = Gregorian.info(nextSunEvent, Time.FORMAT_SHORT);
                    nextSun[1] = nextSunEvent.hour;
                    nextSun[2] = nextSunEvent.min;
                }
                
            }
        }

        // Get Current Weather
        var currentWeather = Weather.getCurrentConditions();
        var currentTemperature = null;
        if (currentWeather != null){
            currentTemperature = currentWeather.temperature;
        }

        // Get Body Battery
        var currentBodyBattery = null;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)){
            var bodyBatteryOptions = {
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            };
            //currentBodyBattery = Toybox.SensorHistory.getBodyBatteryHistory(bodyBatteryOptions);//({});
            var bodyBatteryIterator = Toybox.SensorHistory.getBodyBatteryHistory(bodyBatteryOptions);
            currentBodyBattery = bodyBatteryIterator.next();
            if (currentBodyBattery != null){
                var tenSecs = new Time.Duration(10);
                if (tenSecs.lessThan(now.subtract(currentBodyBattery.when))){
                    currentBodyBattery = null;
                }
            }
        }

        //Get Watch Battery
        var batteryStatus = System.getSystemStats().battery;
        var batteryDays = System.getSystemStats().batteryInDays;

        //Get Intensity Minutes
        var intensityStatus = ActivityMonitor.getInfo().activeMinutesWeek.total;
        var intensityGoal = ActivityMonitor.getInfo().activeMinutesWeekGoal;
        var intensityGoalProgress = null;
        if (intensityStatus != null && intensityGoal != null){
            intensityGoalProgress = intensityStatus*1.0/ ActivityMonitor.getInfo().activeMinutesWeekGoal;
        }
        

        // ---------- Update the Watch Face ----------

        // Update the time
        var fieldTime = View.findDrawableById("TimeLabel") as Text;
        //time.setColor(Application.Properties.getValue("TimeColor") as Number);
        fieldTime.setText(timeString);
        if(!systemSettings.is24Hour or !Application.Properties.getValue("TimeColon")){
            fieldTime.locX = dc.getWidth() * 0.825;
            fieldTime.setJustification(Graphics.TEXT_JUSTIFY_RIGHT);
        }

        //Update the Seconds
        var fieldSecondsDigit = View.findDrawableById("seconds") as Text;
        //seconds.setColor(Application.Properties.getValue("TimeColor") as Number);
        fieldSecondsDigit.setText(secs.format("%02d"));

        // Update Day of Week and Day
        var fieldDateString = View.findDrawableById("dateString") as Text;
        //text1Label.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        fieldDateString.setText(dateString);

        // Update Heart Rate Data
        var fieldHR = View.findDrawableById("heartRate") as Text;
        //hr.setColor(Application.Properties.getValue("TimeColor") as Number);
        if (hrData == null or hrData == ActivityMonitor.INVALID_HR_SAMPLE){
            fieldHR.setText("--");
        }else{
            fieldHR.setText(hrData.format("%d"));
        }
        
        // Update Sun Status
        var fieldSunData = View.findDrawableById("sun") as Text;
        //sun.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (nextSun[0] != null){
            fieldSunData.setText(convertTime(nextSun[1], nextSun[2]));
            //Lang.format("$1$:$2$", [sun[1].hour, sun[1].minute]));
        }else{
            if (Application.Properties.getValue("TimeColon")){
                fieldSunData.setText("--:--");
            }else{
                fieldSunData.setText("----");
            }
        }

        // Update Temperature
        var fieldTempData = View.findDrawableById("weather") as Text;
        if (currentTemperature != null){
            fieldTempData.setText(currentTemperature.format("%d"));
        }

        // Update Body Battery
        var bodyBateryField = View.findDrawableById("bodyBattery") as Text;

        if (currentBodyBattery != null){
            bodyBateryField.setText(currentBodyBattery.data.format("%d"));
        }else{
            bodyBateryField.setText("");
        }
        

        // ---------- Update UTC Information ----------
        
        // Check the setting
        var utcText = View.findDrawableById("utc") as Text;
        if (Application.Properties.getValue("ShowUTC")){

            // Update UTC
            // time.setColor(Application.Properties.getValue("??????") as Number);
            utcText.setText((utcSecs/3600 % 24).format("%02d"));

            // Print +30 Min timezone notice
            offset %= 3600;
            if (offset != 0) { // (true)
                var utcNewfoundland = View.findDrawableById("newfoundland") as Text;
                utcNewfoundland.setText((offset/60).format("%02d"));
                //utcNewfoundland.setText("-30");
            }
        }else{
            utcText.setText("");
        }

        // ---------- Send the Updates ----------

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // ---------- Draw Progress Bars ----------
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();
        var ARC_WIDTH = 6;
        var ARC_LENGTH = 60;
        var colorTransparent = Graphics.COLOR_TRANSPARENT;
        dc.setPenWidth(ARC_WIDTH);

        // ----- Battery Progress Bar -----
        var colorBatteryCharged = Graphics.COLOR_GREEN;
        var colorBatteryDischarged = Graphics.COLOR_DK_GRAY;

        dc.setColor(colorBatteryDischarged, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH/2, Graphics.ARC_CLOCKWISE, ARC_LENGTH/2, -ARC_LENGTH / 2);
        if (System.getSystemStats().charging) {
            colorBatteryCharged = Graphics.COLOR_BLUE;
            colorBatteryDischarged = colorBatteryCharged;
        } else if(batteryDays < 3){
            colorBatteryCharged = Graphics.COLOR_RED;
            colorBatteryDischarged = colorBatteryCharged;
        }else if (batteryDays <= 5){
            colorBatteryCharged = Graphics.COLOR_YELLOW;
        }else if (batteryDays > 10){
            colorBatteryDischarged = colorBatteryCharged;
        }
        dc.setColor(colorBatteryCharged, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH / 2, Graphics.ARC_COUNTER_CLOCKWISE,  -ARC_LENGTH / 2 , ARC_LENGTH * batteryStatus/100 - ARC_LENGTH / 2);

        // charged portion
        dc.setColor(colorBatteryCharged, colorTransparent);
        dc.fillCircle(WIDTH*0.5 + WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.745, ARC_WIDTH);

        // discharged portion
        dc.setColor(colorBatteryDischarged, colorTransparent);
        dc.fillCircle(WIDTH*0.5 + WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.255, ARC_WIDTH);
        
        // ----- Sunrise Sundown Bar -----
        var colorSunPast = Graphics.COLOR_DK_BLUE;
        var colorSunRemaining = Graphics.COLOR_YELLOW;
        var colorSunDown = Graphics.COLOR_DK_GRAY;

        if (nextSun[0] == null or !nextSun[0]){
            dc.setColor(colorSunDown, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH/2, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90-ARC_LENGTH / 2);
            dc.fillCircle(WIDTH * 0.255, HEIGHT*0.5 - HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
            dc.fillCircle(WIDTH * 0.745, HEIGHT*0.5 - HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
        } else {
            var percentDaylight = now.subtract(todaySunRise).value()*1.0 / todaySunSet.subtract(todaySunRise).value();
            
            // Sun gone bar
            dc.setColor(colorSunRemaining, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH/2, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90-ARC_LENGTH / 2);

            // Sun remaining bar
            dc.setColor(colorSunPast, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH/2, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90 + ARC_LENGTH / 2 - ARC_LENGTH*percentDaylight);

            // Circle Caps
            dc.fillCircle(WIDTH * 0.255, HEIGHT*0.5 - HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
            dc.setColor(colorSunRemaining, colorTransparent);
            dc.fillCircle(WIDTH * 0.745, HEIGHT*0.5 - HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
        }

        // ----- Active Hours Bar -----
        var colorActiveCompleted = Graphics.COLOR_ORANGE;
        var colorActiveGoal = Graphics.COLOR_DK_GRAY;

        dc.setColor(colorActiveGoal, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH/2, Graphics.ARC_CLOCKWISE, ARC_LENGTH/2 - 90, -90-ARC_LENGTH / 2);
        
        dc.setColor(colorActiveCompleted, colorTransparent);
        if (intensityGoalProgress != null){
            if (intensityGoalProgress >= 1){
                intensityGoalProgress = 1;
            }
            if (intensityGoalProgress > 0){
                dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH / 2, Graphics.ARC_COUNTER_CLOCKWISE, -90 -ARC_LENGTH / 2 , -90 -ARC_LENGTH / 2 + ARC_LENGTH * intensityGoalProgress);
            }
        }
        if (intensityStatus == 0 or intensityStatus == null){
            dc.setColor(colorActiveGoal, colorTransparent);
        }
        dc.fillCircle(WIDTH * 0.255, HEIGHT*0.5 + HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);

        dc.setColor(colorActiveGoal, colorTransparent);
        
        if (intensityGoalProgress == 1){
            dc.setColor(colorActiveCompleted, colorTransparent);
        }
        dc.fillCircle(WIDTH * 0.745, HEIGHT*0.5 + HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);

        // ----- Progress Bar 4 ----- NEED TO ALLOCATE -----
        var colorBar4On = Graphics.COLOR_GREEN;
        var colorBar4Off = Graphics.COLOR_DK_GRAY;
        
        dc.setColor(colorBar4Off, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH/2, Graphics.ARC_CLOCKWISE, 180 + ARC_LENGTH/2, 180 - ARC_LENGTH / 2);

        dc.setColor(colorBar4On, colorTransparent);
        //dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.495 - ARC_WIDTH / 2, Graphics.ARC_CLOCKWISE,  180 + ARC_LENGTH / 2 , 180 + ARC_LENGTH / 2 - ARC_LENGTH * **METRIC**/100);

        // charged portion
        dc.setColor(colorBar4On, colorTransparent);
        dc.fillCircle(WIDTH*0.5 - WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.745, ARC_WIDTH);

        // discharged portion
        dc.setColor(colorBar4Off, colorTransparent);
        dc.fillCircle(WIDTH*0.5 - WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.255, ARC_WIDTH);


        // ----- all border rings -----
        dc.setColor(Application.Properties.getValue("BackgroundColor"), colorTransparent);
        dc.setPenWidth((ARC_WIDTH)/2);
        dc.drawCircle(WIDTH*0.5 + WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.745, ARC_WIDTH);
        dc.drawCircle(WIDTH*0.5 + WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.255, ARC_WIDTH);
        dc.drawCircle(WIDTH*0.5 - WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.745, ARC_WIDTH);
        dc.drawCircle(WIDTH*0.5 - WIDTH*0.485*Math.sqrt(3)/2, HEIGHT * 0.255, ARC_WIDTH);
        dc.drawCircle(WIDTH * 0.255, HEIGHT*0.5 - HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
        dc.drawCircle(WIDTH * 0.745, HEIGHT*0.5 - HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
        dc.drawCircle(WIDTH * 0.255, HEIGHT*0.5 + HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
        dc.drawCircle(WIDTH * 0.745, HEIGHT*0.5 + HEIGHT*0.485*Math.sqrt(3)/2, ARC_WIDTH);
                
        // ---------- Dev Tools ----------
        // drawReferenceLines(dc);
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
