import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import SerialPort
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
      text: "1234567890"
    }

    LabelText {
      text: qsTr("Transform")
      font.bold: true
    }

    LabelText {
      text: qsTr("X: 1 m, Y: 2 m, Rotation: 3 rad/s")
    }

    LabelText {
      text: qsTr("Target Motors Velocity")
      font.bold: true
    }

    LabelText {
      text: qsTr("Motor 1: 4 m/s, Motor 2: 5 m/s")
    }

    LabelText {
      text: "Measured Motors Velocity"
      font.bold: true
    }

    LabelText {
      text: qsTr("Motor 1: 6 m/s, Motor 2: 7 m/s")
    }

    LabelText {
      text: qsTr("Battery 1 Status")
      font.bold: true
    }

    LabelText {
      text: qsTr("Voltage: 12.3 V, Current: 1.2 A, Power: 2.3 W")
    }

    LabelText {
      text: qsTr("Battery 2 Status")
      font.bold: true
    }

    LabelText {
      text: qsTr("Voltage: 12.3 V, Current: 1.2 A, Power: 2.3 W")
    }

    LabelText {
      text: qsTr("Software Emergency Stop")
      font.bold: true
    }

    LabelText {
      text: qsTr("Enabled")
    }

    LabelText {
      text: "Hardware Emergency Stop"
      font.bold: true
    }

    LabelText {
      text: qsTr("Enabled")
    }
  }
}