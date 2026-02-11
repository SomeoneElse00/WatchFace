# My Garmin Venu 3 Watch Face

[to be added]

## Dependencies

- Garmin Connect IQ 8.4.0 or later
- API level 5.2 Device or later (Garmin Venu 3)
- Java JRE 1.8.0 or later

## Compiling

- Install Java JRE from [Oracle](https://www.java.com/en/download/) (for compiling).
- Install [VSCode](https://code.visualstudio.com) or [VSCodium](https://vscodium.com) as your IDE.
- Install Garmin's `Monkey C` extension.
  - If you are using vscodium, go to [this website](https://marketplace.visualstudio.com/_apis/public/gallery/publishers/Garmin/vsextensions/garmin.monkey-c/1.1.2/vspackage?targetPlatform=win32-x64). Modify the URL to increment the version number as required. The current version number can be checked [here](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c).  
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

- [x] Set up Face
  - [x] Add Time
  - [x] Add Seconds
  - [x] Add Leading 0 Support
  - [x] Add Remove Colon Support
  - [x] Manage Colors through settings, use manually set for now
- [ ] Add Fields
  - [x] Heart Rate
  - [x] Sunrise and Sundown in same field
  - [x] Current Weather
  - [x] Weekday and Date
  - [x] UTC Time
    - [x] Icon on UTC Time to account for time zones outside of 1hr jumps
  - [x] Body Battery
  - [ ] Recovery Time?
  - [ ] Current Stress Level?
  - [ ] Total Number of Notifications
  - [ ] Sleep Score --> Sleep Need
  - [ ] Last Activity?
- [ ] Add Progress Bars
  - [x] Sunrise, Sundown, and Sun is not up
  - [x] Intensity Minutes Progress
  - [x] Battery Life
    - [x] switch battery life bar to other side (right)
  - [ ] Custom Bar #4
    - [x] Added
    - [ ] Allocate Feature
- [ ] Add Icons for Status
  - [ ] Bluetooth Disconnected
  - [ ] Alarm is Set
  - [ ] Do Not Disturb is On
- [ ] Add Icons for the Custom Fields
  - [ ] Heart Rate
  - [ ] Sun
  - [ ] Weather
  - [ ] Body Battery
  - [ ] Recovery Time?
  - [ ] Notifications Icon
- [ ] Add Face Flairs
  - [ ] Color Highlight under Centre box
  - [ ] Lines to split all sections
  - [ ] Custom Font for Current Time
  - [ ] Add end caps to progress bars
- [ ] Face Interactions
  - [ ] Configure Long-Press Interactions
  - [ ] Configure tap interactions
    - [ ] Tap weathr to toggle to feels like

## References

I used and referenced code from this [medium article by Eric](https://medium.com/@ericbt/design-your-own-garmin-watch-face-21d004d38f99) as a starting and jumping-off point. The final product of his work is available on [GitHub](https://github.com/briquet9/garmin-watch-faces/tree/main) under an [Apache 2.0 License](https://www.apache.org/licenses/LICENSE-2.0.txt).  

Generative AI was used in this project to assist with debugging and researching through the API and web for my approach for completing a given task. All code included in this project that was written by me is not a direct output of a Generative AI model, nor does it include minor tweaks (i.e. changing variable names) to not be contradictory to the previous claim. All ideas on the watch face's design are my own.  
