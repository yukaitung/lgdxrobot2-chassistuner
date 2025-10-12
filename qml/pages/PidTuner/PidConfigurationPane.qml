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

    // 2. Velocity setting
    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set Level Velocity")
        font.bold: true
        Layout.fillWidth: true
      }

      TextField {
        id: level1Field
        placeholderText: qsTr("Level 1")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
        validator: DoubleValidator {}
      }

      TextField {
        id: level2Field
        placeholderText: qsTr("Level 2")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
        validator: DoubleValidator {}
      }

      TextField {
        id: level3Field
        placeholderText: qsTr("Level 3")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
        validator: DoubleValidator {}
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
    }
  }
}