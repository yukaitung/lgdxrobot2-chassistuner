import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import "../../shared"

Pane {
  Material.elevation: 2
  width: parent.width
  
  Column {
    width: parent.width
    spacing: 8
    
    // 1. PID
    GridLayout {
      width: parent.width
      columns: 5
      rowSpacing: 4

      LabelText {
        text: ""
      }

      LabelText {
        text: qsTr("Motor 1")
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 2")
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 3")
        font.bold: true
      }

      LabelText {
        text: qsTr("Motor 4")
        font.bold: true
      }

      LabelText {
        text: qsTr("P")
        font.bold: true
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }
      
      LabelText {
        text: qsTr("I")
        font.bold: true
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: qsTr("D")
        font.bold: true
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }

      LabelText {
        text: "0.1"
      }
    }

    // 2. Level velocity setting
    GridLayout {
      width: parent.width
      columns: 4
      rowSpacing: 4

      LabelText {
        text: ""
      }

      LabelText {
        text: qsTr("Level 1")
        font.bold: true
      }

      LabelText {
        text: qsTr("Level 2")
        font.bold: true
      }

      LabelText {
        text: qsTr("Level 3")
        font.bold: true
      }

      LabelText {
        text: qsTr("Velocity (m/s)")
        font.bold: true
      }

      LabelText {
        text: "0.1"
      }
      
      LabelText {
        text: "0.1"
      }      
      
      LabelText {
        text: "0.1"
      }
    }

    // 3. Refresh
    Button {
      text: qsTr("Refresh")
      Material.foreground: "white"
      Material.background: Material.accent
      Layout.alignment: Qt.AlignRight
    }

    // 4. Velocity setting
    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set Level Velocity")
        font.bold: true
        Layout.fillWidth: true
      }

      TextField {
        placeholderText: qsTr("Level 1")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
      }

      TextField {
        placeholderText: qsTr("Level 2")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
      }

      TextField {
        placeholderText: qsTr("Level 3")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 48
      }

      Item {
        Layout.fillWidth: true
      }

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
      }
    }
  }
}