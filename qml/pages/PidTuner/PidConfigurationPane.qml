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

  Connections {
    target: RobotData
    function onMcuPidUpdated() {
      motorMaximumSpeed1Field.text = RobotData.pidData.motorMaximumSpeed[0]
      motorMaximumSpeed2Field.text = RobotData.pidData.motorMaximumSpeed[1]
      motorMaximumSpeed3Field.text = RobotData.pidData.motorMaximumSpeed[2]
      motorMaximumSpeed4Field.text = RobotData.pidData.motorMaximumSpeed[3]
      level1Field.text = RobotData.pidData.levelVelocity[0]
      level2Field.text = RobotData.pidData.levelVelocity[1]
      level3Field.text = RobotData.pidData.levelVelocity[2]
    }
  }
  
  Column {
    width: parent.width
    spacing: 8
    
    // 1. PID
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

    GridLayout {
      width: parent.width
      columns: 5

      LabelText {
        text: qsTr("Motor Maximum Speed (rad/s)")
        Layout.preferredWidth: 250
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 1")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 2")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 3")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 4")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.pidData.motorMaximumSpeed[0]
      }

      LabelText {
        text: RobotData.pidData.motorMaximumSpeed[1]
      }

      LabelText {
        text: RobotData.pidData.motorMaximumSpeed[2]
      }

      LabelText {
        text: RobotData.pidData.motorMaximumSpeed[3]
      }
    }

    // 2. Velocity setting
    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set Motor Maximum Speed")
        Layout.preferredWidth: 200
        font.bold: true
      }

      TextField {
        id: motorMaximumSpeed1Field
        placeholderText: qsTr("Motor 1")
        Layout.fillWidth: true
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: motorMaximumSpeed2Field
        placeholderText: qsTr("Motor 2")
        Layout.fillWidth: true
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: motorMaximumSpeed3Field
        placeholderText: qsTr("Motor 3")
        Layout.fillWidth: true
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: motorMaximumSpeed4Field
        placeholderText: qsTr("Motor 4")
        Layout.fillWidth: true
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
        enabled: SerialPort.isConnected
        onClicked: SerialPort.setMotorMaximumSpeed(0, motorMaximumSpeed1Field.text, motorMaximumSpeed2Field.text, motorMaximumSpeed3Field.text, motorMaximumSpeed4Field.text)
        Layout.preferredHeight: 48
      }
    }

    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set Level Velocity")
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
        onClicked: SerialPort.setLevelVelocity(0, level1Field.text, level2Field.text, level3Field.text)
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