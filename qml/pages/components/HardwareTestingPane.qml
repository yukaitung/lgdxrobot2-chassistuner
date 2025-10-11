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
    columns: 3
    rowSpacing: 8
    columnSpacing: 8

    LabelText {
      text: qsTr("Get Serial Number")
      font.bold: true
    }

    Button {
      text: qsTr("Get")
      Material.foreground: "white"
      Material.background: Material.accent
      Layout.columnSpan: 2
    }

    LabelText {
      text: qsTr("Inverse Kinematics")
      font.bold: true
    }

    Row {
      spacing: 8
      TextField {
        placeholderText: qsTr("X (m/s)")
        width: 100
        height: 48
      }

      TextField {
        placeholderText: qsTr("Y (m/s)")
        width: 100
        height: 48
      }

      TextField {
        placeholderText: qsTr("Rotation (rad/s)")
        width: 150
        height: 48
      }
    }

    Row {
      spacing: 8
      Layout.alignment: Qt.AlignRight

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
      }

      Button {
        text: qsTr("Stop")
        Material.foreground: "white"
        Material.background: Material.accent
      }
    }

    LabelText {
      text: qsTr("Single Motor Velocity")
      font.bold: true
    }

    Row {
      spacing: 8
      ComboBox {
        model: [qsTr("Motor 1"), qsTr("Motor 2"), qsTr("Motor 3"), qsTr("Motor 4")]
        width: 150
        height: 48
      }

      TextField {
        placeholderText: qsTr("Velocity (m/s)")
        width: 150
        height: 48
      }
    }

    Row {
      spacing: 8
      Layout.alignment: Qt.AlignRight

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
      }

      Button {
        text: qsTr("Stop")
        Material.foreground: "white"
        Material.background: Material.accent
      }
    }

    LabelText {
      text: qsTr("Software Emergency Stop")
      font.bold: true
    }

    Row {
      spacing: 8
      Layout.columnSpan: 2

      Button {
        text: qsTr("Enable")
        Material.foreground: "white"
        Material.background: Material.accent
      }

      Button {
        text: qsTr("Disable")
        Material.foreground: "white"
        Material.background: Material.accent
      }
    }
  }
}