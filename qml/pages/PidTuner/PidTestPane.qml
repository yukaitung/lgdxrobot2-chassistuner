import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../shared"

Pane {
  Material.elevation: 2
  width: parent.width

  GridLayout {
    width: parent.width
    columns: 2
    rowSpacing: 8

    // 1. Select motor, level
    LabelText {
      text: qsTr("Select Configuration")
      font.bold: true
    }
  
    RowLayout {
      spacing: 8

      ComboBox {
        model: [qsTr("Motor 1"), qsTr("Motor 2"), qsTr("Motor 3"), qsTr("Motor 4")]
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
      }

      ComboBox {
        model: [qsTr("Level 1"), qsTr("Level 2"), qsTr("Level 3")]
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
      }
    }

    // 2. PID Configuration
    LabelText {
      text: qsTr("PID Configuration")
      font.bold: true
    }

    RowLayout {
      spacing: 8

      TextField {
        placeholderText: qsTr("P")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
      }

      TextField {
        placeholderText: qsTr("I")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
      }

      TextField {
        placeholderText: qsTr("D")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
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
        Layout.preferredHeight: 48
      }
    }

    // 2. Custom velocity check box
    CheckBox {
      text: qsTr("Custom Velocity")
      font.bold: true
    }

    TextField {
      placeholderText: qsTr("Velocity (m/s)")
      Layout.preferredWidth: 150
      Layout.preferredHeight: 36
    }

    // 3. Direction check box
    CheckBox {
      Layout.columnSpan: 2
      text: qsTr("Reverse Direction")
      font.bold: true
    }

    // 4. Send button
    Row {
      width: parent.width
      spacing: 8
      Layout.columnSpan: 2

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        height: 48
      }

      Button {
        text: qsTr("Stop")
        Material.foreground: "white"
        Material.background: Material.accent
        height: 48
      }
    }
  }
}