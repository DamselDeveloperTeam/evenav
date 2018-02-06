# EVE Online map application for iOS devices

A team project for the iOS Developer course by [Opiframe](http://opiframe.com). The code is in Swift 4. Xcode version is 9.2.

## Requirements

This application requires at least 2GB of RAM to work properly on a hardware device.

## Features

This application has the following features:

* Zoomable map of the EVE Online universe (can be reset)
  * Note that the zoom reset icon (R) appears only after zoom
* Search systems by name
* Route plotter from one system to another (requires internet connection)
* Displays systems, system details, connections to other systems, regions, and constellations

## Third party stuff used and other things

* [FMDB](https://github.com/ccgus/fmdb), a Cocoa / Objective-C wrapper around SQLite
* SQLite database used for storing parsed JSON data received from [EVE Swagger Interface](https://esi.tech.ccp.is/latest/)


## Links to example images

These images are screenshots taken while running an iPhone SE simulator.

* [Loading screen](docs/images/loadingscreen.png)
* [Default view](docs/images/defaultview.png)
* [Starting to search for a system](docs/images/searchsystem01.png)
* [Finished search, presenting the only available system candidate](docs/images/searchsystem02.png)
* [Detailed system information](docs/images/systemdetails.png)
* [Zoomed map view](docs/images/zoomedview.png)
* [Map zoomed out as far as it goes](docs/images/zoomedout.png)
* [Plotted route between two systems (yellow line)](docs/images/routeplotter.png)

## Known bugs

While everything works in various simulators, hardware is a different story, however. For example, fifth generation iPad and iPhone SE work, while iPhone 8 does not, due to insufficient memory. In order to get around this, the application needs refactoring. The source code is provided here for users to tinker and modify as much as they want.

## Licences and copyrights

The following licences, copyrights, and agreements apply to this application:

* [EVE Online Licence Agreement](https://developers.eveonline.com/resource/license-agreement)
* [GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html)
* Copyright 2018 DamselDeveloperTeam
* EVE Online and all related logos and other elements are trademarks of CCP
