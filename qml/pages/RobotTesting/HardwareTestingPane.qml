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
      Layout.preferredHeight: 48
      onClicked: SerialPort.getSerialNumber()
      enabled: SerialPort.isConnected
    }

    LabelText {
      text: qsTr("Reset Transform")
      font.bold: true
    }

    Button {
      text: qsTr("Reset")
      Material.foreground: "white"
      Material.background: Material.accent
      Layout.columnSpan: 2
      Layout.preferredHeight: 48
      onClicked: SerialPort.resetTransform()
      enabled: SerialPort.isConnected
    }

    LabelText {
      text: qsTr("Inverse Kinematics")
      font.bold: true
    }

    Row {
      spacing: 8
      TextField {
        id: ikXTextField
        placeholderText: qsTr("X (m/s)")
        width: 100
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: ikYTextField
        placeholderText: qsTr("Y (m/s)")
        width: 100
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: ikRotationTextField
        placeholderText: qsTr("Rotation (rad/s)")
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }
    }

    Row {
      spacing: 8
      Layout.alignment: Qt.AlignRight

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        height: 48
        onClicked: SerialPort.setInverseKinematics(ikXTextField.text, ikYTextField.text, ikRotationTextField.text)
        enabled: SerialPort.isConnected
      }

      Button {
        text: qsTr("Stop")
        Material.foreground: "white"
        Material.background: Material.accent
        height: 48
        onClicked: SerialPort.setInverseKinematics(0, 0, 0)
        enabled: SerialPort.isConnected
      }
    }

    LabelText {
      text: qsTr("Single Motor Velocity")
      font.bold: true
    }

    Row {
      spacing: 8
      ComboBox {
        id: motorComboBox
        model: [qsTr("Motor 1"), qsTr("Motor 2"), qsTr("Motor 3"), qsTr("Motor 4")]
        width: 150
        height: 36
        enabled: SerialPort.isConnected
      }

      TextField {
        id: motorVelocityTextField
        placeholderText: qsTr("Velocity (rad/s)")
        enabled: SerialPort.isConnected
      }
    }

    Row {
      spacing: 8
      Layout.alignment: Qt.AlignRight

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        onClicked: SerialPort.setMotor(motorComboBox.currentIndex, motorVelocityTextField.text)
        enabled: SerialPort.isConnected
        height: 48
      }

      Button {
        text: qsTr("Stop")
        Material.foreground: "white"
        Material.background: Material.accent
        onClicked: SerialPort.setInverseKinematics(0, 0, 0)
        enabled: SerialPort.isConnected
        height: 48
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
        onClicked: SerialPort.setSoftEmergencyStop(true)
        enabled: SerialPort.isConnected
        height: 48
      }

      Button {
        text: qsTr("Disable")
        Material.foreground: "white"
        Material.background: Material.accent
        onClicked: SerialPort.setSoftEmergencyStop(false)
        enabled: SerialPort.isConnected
        height: 48
      }
    }
  }
}