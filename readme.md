# My Garmin Forerunner 955 Watch Face

I've wanted to build a watch face for my garmin watch ever since I got one so I could pack more data onto the watch face.

## Dependencies

- Garmin Connect IQ 8.4.0 or later
- API level 5.2 Device or later (~~Garmin Venu 3~~ Garmin Forerunner 955)
- Java JRE 1.8.0 or later

## Compiling

- Install Java JRE from [Oracle](https://www.java.com/en/download/) (for compiling).
- Install [VSCode](https://code.visualstudio.com) or [VSCodium](https://vscodium.com) as your IDE.
- Install Garmin's `Monkey C` extension.
  - If you are using vscodium, go to [this website](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/Garmin/vsextensions/monkey-c/1.1.2/vspackage/). Modify the URL to increment the version number as required. The current version number can be checked [here](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c).  
- Grab the current SDK from [Garmin's website](https://developer.garmin.com/connect-iq/sdk/).  
  - Once you download the SDK manager and extract the zip, move the `.dll` files from `/bin/` to `/`.
  - Run the executable
  - Download the the current version of the SDK, and the device.
- `git clone` this repository.
- Run the program from anywhere within the repo.
  - On first run, you will be required to generate a private key for the resulting watch face. Ensure that this is stored outside of the repo for your convenience.
- Within this repo, navigate to `/bin/`. The resulting `.prg` file is the compiled watch face.
- Add the watch face to your watch.
  - Plug in your compatible Garmin wearable to your computer. If pin protected, enter the pin on the device to gain access to it's internal storage.
  - Navigate to `/GARMIN/Apps/`.
  - Drag and drop the watch face into this folder.
  - Eject the watch 

## Dev List

- [x] Add Fields
  - [ ] [?????] Last Activity?
- [ ] Allow changing settings
  - [ ] Configure the settings menu
- [x] Add Icons for Status
  - [x] Rearrange Layout for better placement
  - [x] Bluetooth Disconnected
  - [x] Alarm is Set
  - [x] Do Not Disturb is On
- [X] Add Icons for the Custom Fields
  - [x] Heart Rate
  - [x] Sun
  - [x] Weather
  - [x] Body Battery
  - [x] ~~Recovery Time?~~ Added Progress Bar
  - [x] Notifications Icon
- [ ] Add Face Flairs
  - [x] Color Highlight under Centre box
  - [x] Lines to split all sections
  - [x] ~~Custom Font for Current Time~~ <-- I'm happy with the font
  - [x] Add end caps to progress bars
  - [ ] At night, make the top progress bar represent some status about the moon (i.e. phase, visibility, luminance)
  - [ ] Create Application Icon
  - [x] Rearrange Fields as Necessary
  - [ ] Change weather behavior to update when moving from low to high power
  - [ ] Add Logic to choose between two hr gathering methods. Break HR gathering to seperate fn.
    - [ ] Activity.getActivityInfo().currentHeartRate
    - [ ] ActivityMonitor.getHeartRateHistory(1,true).next().heartRate
  - [ ] Add caching for GPS Location
- [ ] Face Interactions
  - [ ] Configure Long-Press Interactions
  - [ ] Configure tap interactions
    - [ ] Tap weathr to toggle to feels like
- [ ] Program Partial Updates
  - [x] Seconds
  - [x] HR
  - [ ] body battery
  - [ ] notifications

## References

I used and referenced code from this [medium article by Eric](https://medium.com/@ericbt/design-your-own-garmin-watch-face-21d004d38f99) as a starting and jumping-off point. The final product of his work is available on [GitHub](https://github.com/briquet9/garmin-watch-faces/tree/main) under an [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0.txt). Code was also referenced from this [Garmin Forum article](https://forums.garmin.com/developer/connect-iq/f/discussion/349473/simple-example-wf-that-shows-a-bunch-of-things) showing an example of many advanced features in Monkey C. I referenced code in this app to build my settings menu using `Menu2`.  

Generative AI was used in this project to assist with debugging and researching through the API and web for my approach for completing a given task. All code included in this project is not a direct output of a Generative AI model, nor does it include minor tweaks (i.e. changing variable names) to not be contradictory to the previous claim. All ideas on the watch face's design are my own.  
