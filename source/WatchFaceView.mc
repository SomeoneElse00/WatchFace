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

    var bitmapHR;
    var bitmapSunrise;
    var bitmapBodyBattery;
    var bitmapWeather;
    var WIDTH;
    var HEIGHT;
    var oneDay;
    var fifteenMins;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

        // ---------- Initialize General & Static Vars ----------

        WIDTH = dc.getWidth();
        HEIGHT = dc.getHeight();
        oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
        fifteenMins = new Time.Duration(60*15);
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
        bitmapSunrise = WatchUi.loadResource(Rez.Drawables.bitmapSunrise);
        bitmapBodyBattery = WatchUi.loadResource(Rez.Drawables.bitmapBodyBattery);

        // load bitmap for weather

        switch (Weather.getCurrentConditions().condition) {
            case Weather.CONDITION_CLEAR:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);
                break;
            case Weather.CONDITION_PARTLY_CLOUDY:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_MOSTLY_CLOUDY:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_RAIN:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_WINDY:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_THUNDERSTORMS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_WINTRY_MIX:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_FOG:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HAZY:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HAIL:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SCATTERED_SHOWERS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_UNKNOWN_PRECIPITATION:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_LIGHT_RAIN:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HEAVY_RAIN:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_LIGHT_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HEAVY_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_LIGHT_RAIN_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HEAVY_RAIN_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CLOUDY:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_RAIN_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_PARTLY_CLEAR:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_MOSTLY_CLEAR:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_LIGHT_SHOWERS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SHOWERS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HEAVY_SHOWERS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CHANCE_OF_SHOWERS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_MIST:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_DUST:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_DRIZZLE:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_TORNADO:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SMOKE:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_ICE:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SAND:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SQUALL:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SANDSTORM:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_VOLCANIC_ASH:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HAZE:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_FAIR:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_HURRICANE:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_TROPICAL_STORM:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CHANCE_OF_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_FLURRIES:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_FREEZING_RAIN:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_SLEET:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_ICE_SNOW:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            case Weather.CONDITION_THIN_CLOUDS:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapWeatherSunny);//unassigned
                break;
            default:
                bitmapWeather = WatchUi.loadResource(Rez.Drawables.bitmapQuestion);//unassigned
                break;
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        bitmapHR = null;
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
        var hrData = Toybox.ActivityMonitor.getHeartRateHistory(1,true).next().heartRate;

        // Get Sun Status (Sunrise or Sundown, whichever is next)
        var todaySunRise = Weather.getSunrise(currentLocation.position, now);
        var todaySunSet = Weather.getSunset(currentLocation.position, now);
        var nextSun = [null as Boolean, null as Integer, null as Integer]; // Var 1 is the next sun event (False for rise, True for set, null for not available), Var 2 is the time in seconds that the sun event occurs at.
        var nextSunEvent = null;

        if (todaySunRise != null && todaySunSet != null) {
            if (now.value() > todaySunRise.value()) {
                if (now.value() > todaySunSet.value()){
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
            // time.setColor(Application.Properties.getValue("??????") as Number);
            utcText.setText((utcSecs/3600 % 24).format("%02d"));
            utcText.setColor(Application.Properties.getValue("ForegroundColor") as Number);

            // Print +30 Min timezone notice
            offset %= 3600;
            if (offset != 0) { // (true)
                var utcNewfoundland = View.findDrawableById("newfoundland") as Text;
                utcNewfoundland.setText((offset/60).format("%02d"));
                utcNewfoundland.setColor(Application.Properties.getValue("ForegroundColor") as Number);
                //utcNewfoundland.setText("-30");
            }
        }else{
            utcText.setText("");
        }

        // ---------- Send the Updates ----------

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // ---------- Draw Progress Bars ----------
        var ARC_WIDTH = HEIGHT/55;//scaling goal is for a 454 pixel display to have a width of approximateley 8.
        var ARC_LENGTH = 70;
        var colorTransparent = Graphics.COLOR_TRANSPARENT;
        dc.setPenWidth(ARC_WIDTH);

        // ----- Battery Progress Bar -----
        var colorBatteryCharged = Graphics.COLOR_GREEN;
        var colorBatteryDischarged = Graphics.COLOR_DK_GRAY;

        dc.setColor(colorBatteryDischarged, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, ARC_LENGTH/2, -ARC_LENGTH / 2);
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
        dc.setColor(colorBatteryCharged, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_COUNTER_CLOCKWISE,  -ARC_LENGTH / 2 , ARC_LENGTH * batteryStats.battery/100 - ARC_LENGTH / 2);

        // charged portion
        dc.setColor(colorBatteryCharged, colorTransparent);

        dc.fillCircle(
            WIDTH * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // discharged portion
        dc.setColor(colorBatteryDischarged, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        
        // ----- Sunrise Sundown Bar -----
        var colorSunPast = Graphics.COLOR_DK_BLUE;
        var colorSunRemaining = Graphics.COLOR_YELLOW;
        var colorSunDown = Graphics.COLOR_DK_GRAY;

        if (nextSun[0] == null or !nextSun[0]){
            dc.setColor(colorSunDown, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90-ARC_LENGTH / 2);
            dc.fillCircle(
                WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
                HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
            dc.fillCircle(
                WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5- ARC_WIDTH),
                HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
            //Sunrise Icon
            dc.drawBitmap(WIDTH*0.80, HEIGHT*0.20, bitmapSunrise);
        } else {
            var percentDaylight = now.subtract(todaySunRise).value()*1.0 / todaySunSet.subtract(todaySunRise).value();
            
            // Sun gone bar
            dc.setColor(colorSunRemaining, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90-ARC_LENGTH / 2);

            // Sun remaining bar
            dc.setColor(colorSunPast, colorTransparent);
            dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 90 + ARC_LENGTH/2, 90 + ARC_LENGTH / 2 - ARC_LENGTH*percentDaylight);

            // Circle Caps
            dc.fillCircle(
                WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
                HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );
            dc.setColor(colorSunRemaining, colorTransparent);
            dc.fillCircle(
                WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
                HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
                ARC_WIDTH
            );

            //Sunrise Icon
            dc.drawBitmap(WIDTH*0.8, HEIGHT*0.20, bitmapSunrise);
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
            WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        
        dc.setColor(colorActiveIncomplete, colorTransparent);
        
        if (intensityGoalProgress == 1){
            dc.setColor(colorActiveCompleted, colorTransparent);
        }
        dc.fillCircle(
            WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // ----- Progress Bar 4 ----- NEED TO ALLOCATE -----
        var colorBar4On = Graphics.COLOR_GREEN;
        var colorBar4Off = Graphics.COLOR_DK_GRAY;
        
        dc.setColor(colorBar4Off, colorTransparent);
        dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE, 180 + ARC_LENGTH/2, 180 - ARC_LENGTH / 2);

        dc.setColor(colorBar4On, colorTransparent);
        //dc.drawArc(WIDTH/2, HEIGHT/2, HEIGHT*0.5 - ARC_WIDTH, Graphics.ARC_CLOCKWISE,  180 + ARC_LENGTH / 2 , 180 + ARC_LENGTH / 2 - ARC_LENGTH * **METRIC**/100);

        // charged portion
        dc.setColor(colorBar4On, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // discharged portion
        dc.setColor(colorBar4Off, colorTransparent);
        dc.fillCircle(
            WIDTH * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // ----- all border rings -----
        dc.setColor(Application.Properties.getValue("BackgroundColor"), colorTransparent);
        dc.setPenWidth((ARC_WIDTH)/2);
        dc.drawCircle(//bottom bar, right side
            WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//top bar, right side
            WIDTH * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//bottom bar, left side
            WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//top bar, left side
            WIDTH * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//right bar, bottom side
            WIDTH * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//right bar, top side
            WIDTH * 0.5 + Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//left bar, bottom side
            WIDTH * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 + Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );
        dc.drawCircle(//left bar, top side
            WIDTH * 0.5 - Math.cos(Math.toRadians(ARC_LENGTH/2)) * (WIDTH*0.5 - ARC_WIDTH),
            HEIGHT * 0.5 - Math.sin(Math.toRadians(ARC_LENGTH/2)) * (HEIGHT*0.5 - ARC_WIDTH),
            ARC_WIDTH
        );

        // ---------- Draw Shapes ----------

        dc.drawBitmap(WIDTH*0.10, HEIGHT*0.18, bitmapWeather); //Icon Top Left
        //dc.drawBitmap(WIDTH*??, HEIGHT*??, bitmapSunrise); //Drawn Earlier. Icon Top Right
        dc.drawBitmap(WIDTH*0.12, HEIGHT*0.69, bitmapHR); //Icon Bottom Left
        dc.drawBitmap(WIDTH*0.78, HEIGHT*0.70, bitmapBodyBattery); //Icon Bottom Right

        //bitmapHR.draw(dc);

        // ---------- Dev Tools ----------
        // drawReferenceLines(dc);
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
