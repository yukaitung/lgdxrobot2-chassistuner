import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import SerialPort
import RobotData
import "../../shared"

Pane {
  Material.elevation: 2
  width: parent.width
  
  GridLayout {
    width: parent.width
    columns: 2
    rowSpacing: 8
    columnSpacing: 8

    LabelText {
      text: qsTr("Connection Status")
      font.bold: true
    }

    LabelText {
      text: SerialPort.isConnected ? qsTr("Connected") : qsTr("Disconnected")
      color: SerialPort.isConnected ? "green" : "red"
    }

    LabelText {
      text: qsTr("Serial Number")
      font.bold: true
    }

    LabelText {
      text: RobotData.serialNumber
    }

    LabelText {
      text: qsTr("Transform")
      font.bold: true
    }

    LabelText {
      text: qsTr("X: %1 m, Y: %2 m, Rotation: %3 rad/s")
        .arg(RobotData.mcuData.transform[0].toFixed(4))
        .arg(RobotData.mcuData.transform[1].toFixed(4))
        .arg(RobotData.mcuData.transform[2].toFixed(4))
    }

    LabelText {
      text: qsTr("Target Motors Velocity")
      font.bold: true
    }

    LabelText {
      text: qsTr("Motor 1: %1 m/s, Motor 2: %2 m/s, Motor 3: %3 m/s, Motor 4: %4 m/s")
        .arg(RobotData.mcuData.motorsTargetVelocity[0].toFixed(4))
        .arg(RobotData.mcuData.motorsTargetVelocity[1].toFixed(4))
        .arg(RobotData.mcuData.motorsTargetVelocity[2].toFixed(4))
        .arg(RobotData.mcuData.motorsTargetVelocity[3].toFixed(4))
    }

    LabelText {
      text: "Measured Motors Velocity"
      font.bold: true
    }

    LabelText {
      text: qsTr("Motor 1: %1 m/s, Motor 2: %2 m/s, Motor 3: %3 m/s, Motor 4: %4 m/s")
        .arg(RobotData.mcuData.motorsActualVelocity[0].toFixed(4))
        .arg(RobotData.mcuData.motorsActualVelocity[1].toFixed(4))
        .arg(RobotData.mcuData.motorsActualVelocity[2].toFixed(4))
        .arg(RobotData.mcuData.motorsActualVelocity[3].toFixed(4))
    }

    LabelText {
      text: qsTr("Battery 1 Status")
      font.bold: true
    }

    LabelText {
      text: qsTr("Voltage: %1 V, Current: %2 A, Power: %3 W")
        .arg(RobotData.mcuData.battery1[0].toFixed(2))
        .arg(RobotData.mcuData.battery1[1].toFixed(2))
        .arg((RobotData.mcuData.battery1[0] * RobotData.mcuData.battery1[1]).toFixed(2))
    }

    LabelText {
      text: qsTr("Battery 2 Status")
      font.bold: true
    }

    LabelText {
      text: qsTr("Voltage: %1 V, Current: %2 A, Power: %3 W")
        .arg(RobotData.mcuData.battery2[0].toFixed(2))
        .arg(RobotData.mcuData.battery2[1].toFixed(2))
        .arg((RobotData.mcuData.battery2[0] * RobotData.mcuData.battery2[1]).toFixed(2))
    }

    LabelText {
      text: qsTr("Software Emergency Stop")
      font.bold: true
    }

    LabelText {
      text: RobotData.mcuData.softwareEmergencyStopEnabled ? qsTr("Enabled") : qsTr("Disabled")
    }

    LabelText {
      text: "Hardware Emergency Stop"
      font.bold: true
    }

    LabelText {
      text: RobotData.mcuData.hardwareEmergencyStopEnabled ? qsTr("Enabled") : qsTr("Disabled")
    }
  }
}