import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import RobotData
import SerialPort
import "../../shared"

Pane {
  Material.elevation: 2
  width: parent.width

  Column {
    width: parent.width
    spacing: 8
    
    // 1. PID Tables
    PidTable {
      width: parent.width
      level: 0
    }

    PidTable {
      width: parent.width
      level: 1
    }

    PidTable {
      width: parent.width
      level: 2
    }

    // 2. PID Speed Configuration
    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set PID Speed")
        Layout.preferredWidth: 200
        font.bold: true
      }

      TextField {
        id: level1Field
        placeholderText: qsTr("Level 1")
        validator: DoubleValidator {}
        Layout.fillWidth: true
        enabled: SerialPort.isConnected
      }

      TextField {
        id: level2Field
        placeholderText: qsTr("Level 2")
        validator: DoubleValidator {}
        Layout.fillWidth: true
        enabled: SerialPort.isConnected
      }

      TextField {
        id: level3Field
        placeholderText: qsTr("Level 3")
        validator: DoubleValidator {}
        Layout.fillWidth: true
        enabled: SerialPort.isConnected
      }

      Item {
        Layout.fillWidth: true
      }

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
        enabled: SerialPort.isConnected
        onClicked: SerialPort.setPidSpeed(0, level1Field.text, level2Field.text, level3Field.text)
        Layout.preferredHeight: 48
      }
    }

    // 3. Refresh
    Button {
      text: qsTr("Refresh")
      Material.foreground: "white"
      Material.background: Material.accent
      Layout.alignment: Qt.AlignRight
      enabled: SerialPort.isConnected
      onClicked: SerialPort.getPid()
      Layout.preferredHeight: 48
    }
  }
}