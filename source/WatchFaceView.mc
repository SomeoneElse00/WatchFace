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

    // ----- Bitmap References -----
    var bitmapHR;
    var bitmapBodyBattery;
    var bitmapWeather;

    // ----- Watch Dimension Constants -----
    var WIDTH;
    var HEIGHT;
    var ARC_WIDTH;
    var ARC_LENGTH;
    var ARC_SIN;
    var ARC_COS;

    // ----- Time Constants -----
    var oneDay;
    var fifteenMins;

    // ----- Debug Switch -----
    var initCalcs;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        // ---------- Initialize General & Static Vars ----------

        WIDTH = dc.getWidth();
        HEIGHT = dc.getHeight();
        ARC_WIDTH = HEIGHT/75 + 58.5/(HEIGHT/55+14);//caling goal is for a 454 pixel display to have a width of approximateley 8, and for a 220 pixel display to have a width of approximateley 6
        ARC_LENGTH = 70;
        ARC_SIN = Math.sin(Math.toRadians((ARC_LENGTH+5)/2));
        ARC_COS = Math.cos(Math.toRadians((ARC_LENGTH+5)/2));
        oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
        fifteenMins = new Time.Duration(60*15);
        initCalcs = true;
    }

    function getWeatherBitmap (condition as Weather.Condition or Null, isWeatherDay as Boolean) as WatchUi.BitmapResource {
        //var wr = Weather.getCurrentConditions().precipitationChance;
        switch (condition) {
            case Weather.CONDITION_CLEAR:
                if (isWeatherDay){
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherClearNight);
                }

            case Weather.CONDITION_PARTLY_CLOUDY:
                if (isWeatherDay){
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherPartlyDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherPartlyNight);
                }

            case Weather.CONDITION_MOSTLY_CLOUDY:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherCloud);

            case Weather.CONDITION_RAIN:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherRain);

            case Weather.CONDITION_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherSnow);

            case Weather.CONDITION_WINDY:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWindy);

            case Weather.CONDITION_THUNDERSTORMS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherStorm);
                
            case Weather.CONDITION_WINTRY_MIX:
                if (isWeatherDay) {
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWintryDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWintryNight);
                }

            case Weather.CONDITION_FOG:
                if (isWeatherDay) {
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherFogDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherFogNight);
                }

            case Weather.CONDITION_HAZY:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHaze);

            case Weather.CONDITION_HAIL:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHailExtreme);

            case Weather.CONDITION_SCATTERED_SHOWERS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherRain);

            case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherStorm);

            case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherRain);

            case Weather.CONDITION_LIGHT_RAIN:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherLightRain);

            case Weather.CONDITION_HEAVY_RAIN:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHeavyRain);

            case Weather.CONDITION_LIGHT_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherSnow);

            case Weather.CONDITION_HEAVY_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherSnow);

            case Weather.CONDITION_LIGHT_RAIN_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHail);

            case Weather.CONDITION_HEAVY_RAIN_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHailExtreme);

            case Weather.CONDITION_CLOUDY:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherCloud);

            case Weather.CONDITION_RAIN_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHail);

            case Weather.CONDITION_PARTLY_CLEAR:
                if (isWeatherDay){
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherPartlyDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherPartlyNight);
                }

            case Weather.CONDITION_MOSTLY_CLEAR:
                if (isWeatherDay){
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherClearNight);
                }

            case Weather.CONDITION_LIGHT_SHOWERS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherLightRain);

            case Weather.CONDITION_SHOWERS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherRain);

            case Weather.CONDITION_HEAVY_SHOWERS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHeavyRain);

            case Weather.CONDITION_CHANCE_OF_SHOWERS:
                /*if (Weather.getCurrentConditions().precipitationChance > 40){
                    return getWeatherBitmap (Weather.condition, isWeatherDay); 
                }*/
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherRain);//unassigned

            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherStorm);//unassigned

            case Weather.CONDITION_MIST:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherLightRain);

            case Weather.CONDITION_DUST:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWindy);

            case Weather.CONDITION_DRIZZLE:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherLightRain);

            case Weather.CONDITION_TORNADO:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherTornado);

            case Weather.CONDITION_SMOKE:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHaze);

            case Weather.CONDITION_ICE:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherIce);

            case Weather.CONDITION_SAND:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWindSock);

            case Weather.CONDITION_SQUALL:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherTornado);

            case Weather.CONDITION_SANDSTORM:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherTornado);

            case Weather.CONDITION_VOLCANIC_ASH:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWindSock);

            case Weather.CONDITION_HAZE:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHaze);

            case Weather.CONDITION_FAIR:
                if (isWeatherDay){
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherClearNight);
                }

            case Weather.CONDITION_HURRICANE:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherTornado);

            case Weather.CONDITION_TROPICAL_STORM:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherTornado);

            case Weather.CONDITION_CHANCE_OF_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHail);

            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHail);

            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherRain);

            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                if (isWeatherDay) {
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWintryDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWintryNight);
                }

            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHail);
                /*if (isWeatherDay) {
                    return WatchUi.loadResource(Rez.Drawables.bitmapQuestion);//unassigned
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapQuestion);//unassigned
                }*/

            case Weather.CONDITION_FLURRIES:
                if (isWeatherDay) {
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWintryDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherWintryNight);
                }

            case Weather.CONDITION_FREEZING_RAIN:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherIce);

            case Weather.CONDITION_SLEET:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHailExtreme);

            case Weather.CONDITION_ICE_SNOW:
                return WatchUi.loadResource(Rez.Drawables.bitmapWeatherHailExtreme);

            case Weather.CONDITION_THIN_CLOUDS:
                if (isWeatherDay){
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherPartlyDay);
                }else{
                    return WatchUi.loadResource(Rez.Drawables.bitmapWeatherPartlyNight);
                }

            default:
                return WatchUi.loadResource(Rez.Drawables.bitmapQuestion);

        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {

        // ---------- Initialize Bitmaps ----------
        /*bitmapHR = new WatchUi.Bitmap({
            :rezID => Rez.Drawables.bitmapHR,
            :locX => WIDTH*0.3,
            :locy => HEIGHT*0.2
        });*/
        bitmapHR = WatchUi.loadResource(Rez.Drawables.bitmapHR);
        bitmapBodyBattery = WatchUi.loadResource(Rez.Drawables.bitmapBodyBattery);

        // Get relative sun
        var isDay = false;
        var currentLoc = Position.getInfo();
        var rise = null;
        var fall = null;
        if (currentLoc != null && currentLoc.position != null){
            rise = Weather.getSunrise(currentLoc.position, Time.now());
            fall = Weather.getSunset(currentLoc.position, Time.now());
        }
        
        if (rise != null && fall != null) {
            if (rise.value() < Time.now().value() && fall.value() > Time.now().value()) {
                isDay = true;
            }
        }

        // load bitmap for weather
        if (Weather.getCurrentConditions() != null){
            bitmapWeather = getWeatherBitmap(Weather.getCurrentConditions().condition, isDay);
        }else{
            bitmapWeather = getWeatherBitmap(Weather.CONDITION_UNKNOWN, isDay);
        }

        WatchUi.requestUpdate();
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        bitmapHR = null;
        bitmapWeather = null;
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

        // Get UTC information
        var secs = currentTime.sec;
        var offset = currentTime.timeZoneOffset;
        var utcSecs = (currentTime.hour * 3600) + (currentTime.min * 60) + secs - offset;

        // Get and format Weekday and Date
        var dayInfo = Gregorian.info(now, Time.FORMAT_MEDIUM);

        // Get Heart Rate Info
        var hrData = Toybox.ActivityMonitor.getHeartRateHistory(null,true).next().heartRate;

        // Confirm position for Sunrise Calculation exists, or pull from memory
        //using Toybox.Application.Storage;
        // CANNOT STORE LOCATION.POSITION: STORE AS INDIVIDUAL NUMBERS, AND KEEP A BOOLEAN TO TRACK SETUP.
        var cachePosition = Storage.getValue("cachePosition");

        if ((currentLocation == null || currentLocation.position == null) && cachePosition != null) {
            currentLocation = cachePosition;
        } else {
            if ((cachePosition == null || currentLocation.position != cachePosition) && currentLocation.position != null) {
                Storage.setValue("cachePosition", currentLocation.position);
            }
            currentLocation = currentLocation.position;
        }


        // Get Sun Status (Sunrise or Sundown, whichever is next)
        var todaySunRise = null;
        var todaySunSet = null;
        if (currentLocation != null) {
            todaySunRise = Weather.getSunrise(currentLocation, now);
            todaySunSet = Weather.getSunset(currentLocation, now);
        }
        var nextSun = [null as Boolean, null as Integer, null as Integer]; // Var 1 is the next sun event (False for rise, True for set, null for not available), Var 2 is the time in seconds that the sun event occurs at.
        var nextSunEvent = null;

        if (todaySunRise != null && todaySunSet != null) {
            if (now.value() > todaySunRise.value()) {
                //the sun has risen today
                if (now.value() > todaySunSet.value()){
                    //it is after sunset
                    var tomorrow = now.add(oneDay);
                    nextSunEvent = Weather.getSunrise(currentLocation, tomorrow);
                    nextSun[0] = false;
                }else{
                    //it is after sunrise and before sunset
                    nextSunEvent = todaySunSet;
                    nextSun[0] = true;
                }
            }else{
                //it is before sunrise
                nextSunEvent = todaySunRise;
                nextSun[0] = false;
            }
            if(nextSun[0] != null && nextSunEvent instanceof Moment){
                nextSunEvent = Gregorian.localMoment(currentLocation, nextSunEvent);
                if (nextSunEvent != null){
                    nextSunEvent = Gregorian.info(nextSunEvent, Time.FORMAT_SHORT);
                    nextSun[1] = nextSunEvent.hour;
                    nextSun[2] = nextSunEvent.min;
                }
                
            }
        }

        // Get Current Weather
        var currentWeather = Weather.getCurrentConditions();

        // Get Body Battery
        var currentBodyBattery = null;
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)){
            var bodyBatteryOptions = {
                :period => fifteenMins,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            };
            //currentBodyBattery = Toybox.SensorHistory.getBodyBatteryHistory(bodyBatteryOptions);//({});
            var bodyBatteryIterator = Toybox.SensorHistory.getBodyBatteryHistory(bodyBatteryOptions);
            currentBodyBattery = bodyBatteryIterator.next();
            /*if (currentBodyBattery != null){
                if (fifteenMins.lessThan(now.subtract(currentBodyBattery.when))){
                    currentBodyBattery = null;
                }
            }*/
        }

        //Get Watch Battery
        var batteryStats = System.getSystemStats();

        //Get Intensity Minutes
        var activityInfo = ActivityMonitor.getInfo();
        var intensityGoalProgress = null;
        if (activityInfo.activeMinutesWeek.total != null && activityInfo.activeMinutesWeekGoal != null){
            intensityGoalProgress = activityInfo.activeMinutesWeek.total*1.0/ activityInfo.activeMinutesWeekGoal;
        }

        //Get Recovery Time
        var recoveryTime = activityInfo.timeToRecovery;
        
        //Get Notification Count
        var notifs = systemSettings.notificationCount;

        // ---------- Update the Watch Face ----------

        // Update the time
        var fieldTime = View.findDrawableById("TimeLabel") as Text;
        fieldTime.setColor(Application.Properties.getValue("TimeColor") as Number);
        fieldTime.setText(convertTime(currentTime.hour, currentTime.min));
        if(!systemSettings.is24Hour or !Application.Properties.getValue("TimeColon")){
            fieldTime.locX = dc.getWidth() * 0.825;
            fieldTime.setJustification(Graphics.TEXT_JUSTIFY_RIGHT);
        }

        //Update the Seconds
        var fieldSecondsDigit = View.findDrawableById("seconds") as Text;
        fieldSecondsDigit.setColor(Application.Properties.getValue("TimeColor") as Number);
        fieldSecondsDigit.setText(secs.format("%02d"));

        // Update Day of Week and Day
        var fieldDateString = View.findDrawableById("dateString") as Text;
        fieldDateString.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        fieldDateString.setText(Lang.format("$1$ $2$", [dayInfo.day_of_week.toUpper(), dayInfo.day]));

        // Update Heart Rate Data
        var fieldHR = View.findDrawableById("heartRate") as Text;
        fieldHR.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (hrData == null or hrData == ActivityMonitor.INVALID_HR_SAMPLE){
            fieldHR.setText("--");
        }else{
            fieldHR.setText(hrData.format("%d"));
        }
        
        // Update Sun Status
        var fieldSunData = View.findDrawableById("sun") as Text;
        fieldSunData.setColor(Application.Properties.getValue("ForegroundColor") as Number);
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
        fieldTempData.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (currentWeather != null && currentWeather.temperature != null){
            fieldTempData.setText(Lang.format("$1$$2$", [currentWeather.temperature.format("%d"), "°C"]));
        }

        // Update Body Battery
        var bodyBateryField = View.findDrawableById("bodyBattery") as Text;
        bodyBateryField.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (currentBodyBattery != null){
            bodyBateryField.setText(currentBodyBattery.data.format("%d"));
        }else{
            bodyBateryField.setText("--");
        }
        

        // ---------- Update UTC Information ----------
        
        // Check the setting
        var utcText = View.findDrawableById("utc") as Text;
        if (Application.Properties.getValue("ShowUTC")){

            // Update UTC
            utcText.setText((utcSecs/3600 % 24).format("%02d"));
            utcText.setColor(Application.Properties.getValue("TimeColor") as Number);

            // Print +30 Min timezone notice
            offset %= 3600;
            if (offset != 0) { // (true)
                var utcNewfoundland = View.findDrawableById("newfoundland") as Text;
                utcNewfoundland.setText((utcSecs/60%60).format("%02d"));
                utcNewfoundland.setColor(Application.Properties.getValue("TimeColor") as Number);
            }
        }else{
            utcText.setText("");
        }

        // ---------- Update Notifications Info ----------
        var fieldNotifs = View.findDrawableById("notifs") as Text;
        fieldNotifs.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (!systemSettings.phoneConnected){
            fieldNotifs.setText("");
        }else if (notifs >= 20){
            fieldNotifs.setText("20+");
        }else{
            fieldNotifs.setText(notifs.format("%d"));
        }

        // ---------- Send the Updates ----------

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // ---------- Draw Progress Bars ----------
        var colorTransparent = Graphics.COLOR_TRANSPARENT;
        dc.setPenWidth(ARC_WIDTH);

        // ----- Battery Progress Bar -----
        var colorBatteryCharged = Graphics.COLOR_GREEN;
        var colorBatteryDischarged = Graphics.COLOR_DK_GRAY;

        dc.setColor(colorBatteryDischarged, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, ARC_LENGTH/2, -ARC_LENGTH / 2);
        if (Activity.getActivityInfo() != null){
            if (System.getSystemStats().charging) {
                colorBatteryCharged = Graphics.COLOR_BLUE;
                colorBatteryDischarged = colorBatteryCharged;
            } else if(batteryStats.batteryInDays < 3){
                colorBatteryCharged = Graphics.COLOR_RED;
                colorBatteryDischarged = colorBatteryCharged;
            }else if (batteryStats.batteryInDays <= 5){
                colorBatteryCharged = Graphics.COLOR_YELLOW;
            }else if (batteryStats.batteryInDays > 10){
                colorBatteryDischarged = colorBatteryCharged;
            }
        }else{
            if (System.getSystemStats().charging) {
                colorBatteryCharged = Graphics.COLOR_BLUE;
                colorBatteryDischarged = colorBatteryCharged;
            } else if(batteryStats.battery < 15){
                colorBatteryCharged = Graphics.COLOR_RED;
                colorBatteryDischarged = colorBatteryCharged;
            }else if (batteryStats.battery <= 30){
                colorBatteryCharged = Graphics.COLOR_YELLOW;
            }else if (batteryStats.batteryInDays > 85){
                colorBatteryDischarged = colorBatteryCharged;
            }
        }
        dc.setColor(colorBatteryCharged, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_COUNTER_CLOCKWISE,  -ARC_LENGTH / 2 , ARC_LENGTH * batteryStats.battery/100 - ARC_LENGTH / 2);

        // charged portion
        dc.setColor(colorBatteryCharged, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 + ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // discharged portion
        dc.setColor(colorBatteryDischarged, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 + ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        
        // ----- Sunrise Sundown Bar -----
        var colorSunPast = Graphics.COLOR_BLUE;
        var colorSunRemaining = Graphics.COLOR_YELLOW;
        var colorSunDown = Graphics.COLOR_DK_GRAY;

        if (nextSun[0] == null or !nextSun[0]){
            //next sun event is unknown or sunrise
            dc.setColor(colorSunDown, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90-ARC_LENGTH / 2);
            dc.fillCircle(
                WIDTH * 0.5 - ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
                HEIGHT * 0.5 - ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
            dc.fillCircle(
                WIDTH * 0.5 + ARC_SIN * (WIDTH*0.5- ARC_WIDTH),
                HEIGHT * 0.5 - ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
        } else {
            //next sun event is sunset
            var percentDaylight = now.subtract(todaySunRise).value()*1.0 / todaySunSet.subtract(todaySunRise).value();
            
            // Sun gone bar
            dc.setColor(colorSunRemaining, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90-ARC_LENGTH / 2);

            // Sun remaining bar
            dc.setColor(colorSunPast, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90 + ARC_LENGTH / 2 - ARC_LENGTH*percentDaylight);

            // Circle Caps
            dc.fillCircle(
                WIDTH * 0.5 - ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
                HEIGHT * 0.5 - ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
            dc.setColor(colorSunRemaining, colorTransparent);
            dc.fillCircle(
                WIDTH * 0.5 + ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
                HEIGHT * 0.5 - ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
        }

        // ----- Active Hours Bar -----
        var colorActiveCompleted = Graphics.COLOR_ORANGE;
        var colorActiveIncomplete = Graphics.COLOR_DK_GRAY;

        dc.setColor(colorActiveIncomplete, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, ARC_LENGTH/2 - 90, -90-ARC_LENGTH / 2);
        
        dc.setColor(colorActiveCompleted, colorTransparent);
        if (intensityGoalProgress != null){
            if (intensityGoalProgress >= 1){
                intensityGoalProgress = 1;
            }
            if (intensityGoalProgress > 0){
                dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_COUNTER_CLOCKWISE, -90 -ARC_LENGTH / 2 , -90 -ARC_LENGTH / 2 + ARC_LENGTH * intensityGoalProgress);
            }
        }
        if (activityInfo.activeMinutesWeek.total == 0 or activityInfo.activeMinutesWeek.total == null){
            dc.setColor(colorActiveIncomplete, colorTransparent);
        }
        dc.fillCircle(
            WIDTH * 0.5 - ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        
        dc.setColor(colorActiveIncomplete, colorTransparent);
        
        if (intensityGoalProgress == 1){
            dc.setColor(colorActiveCompleted, colorTransparent);
        }
        dc.fillCircle(
            WIDTH * 0.5 + ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // ----- Recovery Time Bar -----
        var colorRecoverRemaining = Graphics.COLOR_DK_GRAY;
        var colorRecoveryCompleted = Graphics.COLOR_DK_GRAY;
        
        dc.setColor(colorRecoveryCompleted, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 180 + ARC_LENGTH/2, 180 - ARC_LENGTH / 2);

        if (recoveryTime != null){
            if (recoveryTime == 0){
                colorRecoverRemaining = Graphics.COLOR_DK_GRAY;
            }else if (recoveryTime <= 24){
                colorRecoverRemaining = Graphics.COLOR_DK_GREEN;
            }else if (recoveryTime <= 48) {
                colorRecoverRemaining = Graphics.COLOR_YELLOW;
            }else {
                colorRecoverRemaining = Graphics.COLOR_DK_RED;
            }
            if (recoveryTime >= 72){//4 days is the coded maximum of recovery time. Catch all
                colorRecoveryCompleted = colorRecoverRemaining;
                recoveryTime = 72;
            }
            dc.setColor(colorRecoverRemaining, colorTransparent);
            var degRemaining = 180 + ARC_LENGTH / 2 - ARC_LENGTH * recoveryTime/72;
            var degInit = 180 + ARC_LENGTH / 2;
            if (degRemaining<degInit){
                dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE,  degInit , degRemaining);
            }
        }

        // low portion
        dc.setColor(colorRecoverRemaining, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 - ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // high portion
        dc.setColor(colorRecoveryCompleted, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 - ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // ----- all border rings -----
        dc.setColor(Application.Properties.getValue("BackgroundColor"), colorTransparent);
        dc.setPenWidth((ARC_WIDTH)/2);
        dc.drawCircle(//bottom bar, right side
            WIDTH * 0.5 + ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//top bar, right side
            WIDTH * 0.5 + ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//bottom bar, left side
            WIDTH * 0.5 - ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//top bar, left side
            WIDTH * 0.5 - ARC_SIN * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - ARC_COS * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//right bar, bottom side
            WIDTH * 0.5 + ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//right bar, top side
            WIDTH * 0.5 + ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//left bar, bottom side
            WIDTH * 0.5 - ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//left bar, top side
            WIDTH * 0.5 - ARC_COS * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - ARC_SIN * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // ---------- Draw Shapes ----------
        //Icon Top Left
        if (bitmapWeather != null){
            dc.drawScaledBitmap(WIDTH*0.08, HEIGHT*0.21, WIDTH*0.16, HEIGHT*0.16, bitmapWeather);
        }
        dc.drawBitmap(WIDTH*0.12, HEIGHT*0.665, bitmapHR); //Icon Bottom Left
        dc.drawBitmap(WIDTH*0.78, HEIGHT*0.673, bitmapBodyBattery); //Icon Bottom Right

        //Icon Top Right
        var bitmapNotif = WatchUi.loadResource(Rez.Drawables.bitmapNotif);
        dc.drawBitmap(WIDTH*0.78, HEIGHT*0.235, bitmapNotif);
        if (systemSettings has :doNotDisturb && systemSettings.doNotDisturb){
            var bitmapNotifDND = WatchUi.loadResource(Rez.Drawables.bitmapNotifDND);
            dc.drawBitmap(WIDTH*0.78, HEIGHT*0.235, bitmapNotifDND);
        }
        if (systemSettings.alarmCount > 0){
            var bitmapAlarm = WatchUi.loadResource(Rez.Drawables.bitmapNotifAlarm);
            dc.drawBitmap(WIDTH*0.78, HEIGHT*0.235, bitmapAlarm);
        }

        // ---------- Draw Phone Disconnected Icon ----------
        if (!systemSettings.phoneConnected){
            var bitmapDisconnected = WatchUi.loadResource(Rez.Drawables.bitmapDisconnected);
            dc.drawBitmap(WIDTH*0.595, HEIGHT*0.235, bitmapDisconnected);//must rework to fit
        }

        // ---------- Draw Border Lines ----------
        dc.setPenWidth(1);
        dc.setColor(Application.Properties.getValue("AccentLinesColor") as Number, colorTransparent);
        dc.drawLine(WIDTH*0.17, HEIGHT*0.20, 
                    WIDTH*0.83, HEIGHT*0.20);//Top horizontal line
        dc.drawLine(WIDTH*0.17, HEIGHT*0.80, 
                    WIDTH*0.83, HEIGHT*0.80);//bottom horizontal line
        dc.drawLine(WIDTH*0.5, HEIGHT*0.23,
                    WIDTH*0.5, HEIGHT*0.33);//Top vertical line
        dc.drawLine(WIDTH*0.5, HEIGHT*0.77,
                    WIDTH*0.5, HEIGHT*0.67);//bottom vertical line

        // ---------- Dev Tools ----------
        //drawReferenceLines(dc);
        /*if (initCalcs){
            debugCalculateRings();
            initCalcs = false;
        }*/
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        WatchUi.requestUpdate();
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


    function onPartialUpdate(dc as Dc){
        dc.setColor(Application.Properties.getValue("TimeColor") as Number, Application.Properties.getValue("AccentTimeBGColor") as Number);
        dc.setClip(WIDTH*0.835, HEIGHT*0.5, WIDTH*0.11, HEIGHT*0.11);
        dc.clear();
        //dc.drawRectangle(WIDTH*0.835, HEIGHT*0.5, WIDTH*0.11, HEIGHT*0.11);
        // ---------Update Seconds---------
        var fieldSecondsDigit = View.findDrawableById("seconds") as Text;
        fieldSecondsDigit.setColor(Application.Properties.getValue("TimeColor") as Number);
        fieldSecondsDigit.setText(System.getClockTime().sec.format("%02d"));
        fieldSecondsDigit.draw(dc);
        dc.clearClip();


        dc.setColor(Application.Properties.getValue("ForegroundColor") as Number, Application.Properties.getValue("BackgroundColor") as Number);
        dc.setClip(WIDTH*0.23, HEIGHT*0.655, WIDTH*0.25, HEIGHT*0.14);
        dc.clear();
        // ---------Update Heart Rate Info---------
        var hrData = Toybox.ActivityMonitor.getHeartRateHistory(1,true).next().heartRate;
        var fieldHR = View.findDrawableById("heartRate") as Text;
        fieldHR.setColor(Application.Properties.getValue("ForegroundColor") as Number);
        if (hrData == null or hrData == ActivityMonitor.INVALID_HR_SAMPLE){
            fieldHR.setText("--");
        }else{
            fieldHR.setText(hrData.format("%d"));
        }
        fieldHR.draw(dc);
        dc.clearClip();
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

    function debugCalculateRings (){
        var ARC_WIDTH = HEIGHT/55;//scaling goal is for a 454 pixel display to have a width of approximateley 8.
        var ARC_LENGTH = 70;
        System.println(Lang.format("Active Mins - Right: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.sin(Math.toRadians(ARC_LENGTH/2)),
            Math.cos(Math.toRadians(ARC_LENGTH/2))]
        ));
        System.println(Lang.format("Sun - Right: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.sin(Math.toRadians(ARC_LENGTH/2)),
            Math.cos(Math.toRadians(ARC_LENGTH/2))])
        );
        System.println(Lang.format("Active Mins - Left: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.sin(Math.toRadians(ARC_LENGTH/2)),
            Math.cos(Math.toRadians(ARC_LENGTH/2))])
        );
        System.println(Lang.format("Sun - Left: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.sin(Math.toRadians(ARC_LENGTH/2)),
            Math.cos(Math.toRadians(ARC_LENGTH/2))])
        );
        System.println(Lang.format("Battery - Bottom: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.cos(Math.toRadians(ARC_LENGTH/2)),
            Math.sin(Math.toRadians(ARC_LENGTH/2))])
        );
        System.println(Lang.format("Battery - Top: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.cos(Math.toRadians(ARC_LENGTH/2)),
            Math.sin(Math.toRadians(ARC_LENGTH/2))])
        );
        System.println(Lang.format("Bar 4 - Bottom: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.cos(Math.toRadians(ARC_LENGTH/2)),
            Math.sin(Math.toRadians(ARC_LENGTH/2))])
        );
        System.println(Lang.format("Bar 4 - Top: ($1$, $2$) | xmult=$3$ | ymult=$4$", [
            WIDTH * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            Math.cos(Math.toRadians(ARC_LENGTH/2)),
            Math.sin(Math.toRadians(ARC_LENGTH/2))])
        );
    }

}
