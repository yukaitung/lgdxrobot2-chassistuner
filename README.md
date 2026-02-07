# LGDXRobot2 ChassisTuner

## Overview

![img](img.png)
![demo](demo.gif)

> LGDXRobot2 fully uses GitLab CI/CD for builds.<br />[![pipeline status](https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner/badges/main/pipeline.svg)](https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner/-/commits/main) [![Latest Release](https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner/-/badges/release.svg)](https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner/-/releases)

LGDXRobot2 ChassisTuner is a GUI tool written in Qt, designed for testing and fine-tuning LGDXRobot2 hardware. It allows you to validate your setup and optimise performance.

* [Homepage](https://lgdxrobot.bristolgram.uk/lgdxrobot2/)

### Getting Help

* [Documentation](https://docs.lgdxrobot.bristolgram.uk/lgdxrobot2/)
* Issue boards on both GitLab and GitHub

### LGDXRobot2 All Repositories

* Design files for both the chassis body and the controller board: ([GitLab](https://gitlab.com/lgdxrobotics/lgdxrobot2-design) | [GitHub](https://github.com/yukaitung/lgdxrobot2-design))
* Firmware for the controller board: ([GitLab](https://gitlab.com/lgdxrobotics/lgdxrobot2-mcu) | [GitHub](https://github.com/yukaitung/lgdxrobot2-mcu))
* A GUI tool for hardware testing: ([GitLab](https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner) | [GitHub](https://github.com/yukaitung/lgdxrobot2-chassistuner))
* LGDXRobot2 ROS 2 integration: ([GitLab](https://gitlab.com/lgdxrobotics/lgdxrobot2-ros2) | [GitHub](https://github.com/yukaitung/lgdxrobot2-ros2))

## Features

* Test the communication between the robot and the PC.
* Fine-tune the PID parameters for the motors using a graph.

## Installation

The following instructions assume that you are using Ubuntu 24.04.

1. Install the following packages:

```bash
sudo apt install libxkbcommon-x11-0 libxcb-cursor0 libxcb-icccm4 libxcb-keysyms1
```

2. Download the binary from the [Releases](https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner/-/releases) page.
3. Extract the downloaded archive.
4. Launch the program from `bin/ChassisTuner`.


## Compling

1. Download the [Qt Installer](https://www.qt.io/download-qt-installer) and install the following packages:

* Qt 6.10
* Qt Serial Port
* Qt Graphs

2. Clone the [lgdxrobot2-chassistuner](https://gitlab.com/yukaitung/lgdxrobot2-chassistuner) repository.

```bash
git clone --recurse-submodules https://gitlab.com/lgdxrobotics/lgdxrobot2-chassistuner
```

3. Open the project in Qt Creator.
4. Press **Run** to build and launch the application.