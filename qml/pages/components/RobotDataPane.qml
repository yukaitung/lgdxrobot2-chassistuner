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
      text: RobotData.mcuSerialNumber
    }

    LabelText {
      text: qsTr("Transform")
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("X: %1 m").arg(RobotData.mcuData.transform[0].toFixed(4))
        width: parent.width / 3
      }

      LabelText {
        text: qsTr("Y: %1 m").arg(RobotData.mcuData.transform[1].toFixed(4))
        width: parent.width / 3
      }

      LabelText {
        text: qsTr("Rotation: %1 rad").arg(RobotData.mcuData.transform[2].toFixed(4))
        width: parent.width / 3
      }
    }

    LabelText {
      text: qsTr("Target Motors Velocity (rad/s)")
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("Motor 1: %1").arg(RobotData.mcuData.motorsTargetVelocity[0].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 2: %1").arg(RobotData.mcuData.motorsTargetVelocity[1].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 3: %1").arg(RobotData.mcuData.motorsTargetVelocity[2].toFixed(4))
        width: parent.width / 4
      }
      
      LabelText {
        text: qsTr("Motor 4: %1").arg(RobotData.mcuData.motorsTargetVelocity[3].toFixed(4))
        width: parent.width / 4
      }
    }

    LabelText {
      text: qsTr("Desired Motors Velocity (rad/s)")
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("Motor 1: %1").arg(RobotData.mcuData.motorsDesireVelocity[0].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 2: %1").arg(RobotData.mcuData.motorsDesireVelocity[1].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 3: %1").arg(RobotData.mcuData.motorsDesireVelocity[2].toFixed(4))
        width: parent.width / 4
      }
      
      LabelText {
        text: qsTr("Motor 4: %1").arg(RobotData.mcuData.motorsDesireVelocity[3].toFixed(4))
        width: parent.width / 4
      }
    }

    LabelText {
      text: "Measured Motors Velocity (rad/s)"
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("Motor 1: %1").arg(RobotData.mcuData.motorsActualVelocity[0].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 2: %1").arg(RobotData.mcuData.motorsActualVelocity[1].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 3: %1").arg(RobotData.mcuData.motorsActualVelocity[2].toFixed(4))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 4: %1").arg(RobotData.mcuData.motorsActualVelocity[3].toFixed(4))
        width: parent.width / 4
      }
    }

    LabelText {
      text: qsTr("Motor CCR")
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("Motor 1: %1").arg(RobotData.mcuData.motorsCcr[0])
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 2: %1").arg(RobotData.mcuData.motorsCcr[1])
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Motor 3: %1").arg(RobotData.mcuData.motorsCcr[2])
        width: parent.width / 4
      }
      
      LabelText {
        text: qsTr("Motor 4: %1").arg(RobotData.mcuData.motorsCcr[3])
        width: parent.width / 4
      }
    }

    LabelText {
      text: qsTr("Battery 1 Status")
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("Voltage: %1 V").arg(RobotData.mcuData.battery1[0].toFixed(2))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Current: %1 A").arg(RobotData.mcuData.battery1[1].toFixed(2))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Power: %1 W").arg((RobotData.mcuData.battery1[0] * RobotData.mcuData.battery1[1]).toFixed(2))
        width: parent.width / 4
      }
    }

    LabelText {
      text: qsTr("Battery 2 Status")
      font.bold: true
    }

    Row {
      Layout.fillWidth: true
      LabelText {
        text: qsTr("Voltage: %1 V").arg(RobotData.mcuData.battery2[0].toFixed(2))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Current: %1 A").arg(RobotData.mcuData.battery2[1].toFixed(2))
        width: parent.width / 4
      }

      LabelText {
        text: qsTr("Power: %1 W").arg((RobotData.mcuData.battery2[0] * RobotData.mcuData.battery2[1]).toFixed(2))
        width: parent.width / 4
      }
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