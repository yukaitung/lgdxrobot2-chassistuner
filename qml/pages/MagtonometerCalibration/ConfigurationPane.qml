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
        text: RobotData.mcuData.hardIronMax[0].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.hardIronMax[1].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.hardIronMax[2].toFixed(10)
      }

      LabelText {
        text: "Minimum"
      }

      LabelText {
        text: RobotData.mcuData.hardIronMin[0].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.hardIronMin[1].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.hardIronMin[2].toFixed(10)
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
        text: RobotData.mcuData.softIronMatrix[0].toFixed(10)
        Layout.fillWidth: true
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[1].toFixed(10)
        Layout.fillWidth: true
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[2].toFixed(10)
        Layout.fillWidth: true
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[3].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[4].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[5].toFixed(10)
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[6].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[7].toFixed(10)
      }

      LabelText {
        text: RobotData.mcuData.softIronMatrix[8].toFixed(10)
      }
    }

    // Copy for testing
    Button {
      text: qsTr("Copy for Testing")
      Material.foreground: "white"
      Material.background: Material.accent
      enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
      onClicked: {
        RobotData.copyMcuMagDataForTesting();
      }
    }
  }
}
