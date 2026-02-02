import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import SerialPort
import RobotData
import "../../shared"

Pane 
{
  id: pane
  Material.elevation: 2
  width: parent.width

  ColumnLayout {
    width: parent.width
    spacing: 8

    // Hard Iron Calibration Data
    GridLayout {
      width: parent.width
      columns: 4

      LabelText {
        text: qsTr("Hard Iron Calibration Data")
        Layout.preferredWidth: 250
        font.bold: true
      }

      LabelText {
        text: qsTr("X")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Y")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Z")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: "Maximum"
      }

      LabelText {
        text: RobotData.magCalibrationData.hardIronMax[0].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.hardIronMax[1].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.hardIronMax[2].toFixed(10)
      }

      LabelText {
        text: "Minimum"
      }

      LabelText {
        text: RobotData.magCalibrationData.hardIronMin[0].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.hardIronMin[1].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.hardIronMin[2].toFixed(10)
      }
    }

    LabelText {
      text: ""
    }

    // Soft Iron Calibration Data
    GridLayout {
      width: parent.width
      columns: 4

      LabelText {
        text: qsTr("Soft Iron Calibration Data")
        Layout.preferredWidth: 250
        font.bold: true
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[0].toFixed(10)
        Layout.fillWidth: true
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[1].toFixed(10)
        Layout.fillWidth: true
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[2].toFixed(10)
        Layout.fillWidth: true
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[3].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[4].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[5].toFixed(10)
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[6].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[7].toFixed(10)
      }

      LabelText {
        text: RobotData.magCalibrationData.softIronMatrix[8].toFixed(10)
      }
    }

    // Copy for testing
    Row {
      width: parent.width
      spacing: 16

      Button {
        text: qsTr("Refresh")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
        onClicked: {
          SerialPort.getMagCalibrationData();
        }
      }

      Button {
        text: qsTr("Reset Calibration Data")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
        onClicked: {
          SerialPort.resetMagCalibrationData();
        }
      }
    }
  }
}
