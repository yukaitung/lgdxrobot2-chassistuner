# LGDX Robot 2 ChassisTuner

LGDX Robot 2 is a DIY universal mecanum wheel chassis project. The LGDX Robot 2 ChassisTuner tests the communication all functionalities in the MCU.

### Links

*   [LGDXRobot2-MCU](https://gitlab.com/yukaitung/lgdxrobot2-mcu)
*   [LGDXRobot2-ChassisTuner](https://gitlab.com/yukaitung/lgdxrobot2-chassistuner)

# How it works

This software is developed with Qt 6. Using QML for user interface, Qt Serial Port to communicate with MCU and Qt Chart to display PID charts.

### Functionality

* Test connection to the MCU
* Display all status from MCU (Refer [LGDXRobot2-MCU](https://gitlab.com/yukaitung/lgdxrobot2-mcu) for detail)
* Test motors and E-stop
* PID tune for every wheel, as well as a chart showing the result for PID setting

## Screenshots

# Getting started

### Prerequisite

This project requires Qt 6.5.1 and Qt Charts. Install all packages using Qt Maintenance Tool.

### Build & Run

Using Qt Creator to open the project and press "Run".
