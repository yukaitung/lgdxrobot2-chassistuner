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

  property bool isAutoConfigRunning: false

  Dialog {
    id: autoConfigDialog
    anchors.centerIn: Overlay.overlay
    title: qsTr("Auto Config Motors Maximum Speed")
    standardButtons: Dialog.Ok | Dialog.Cancel

    width: 600

    contentItem: LabelText {
      text: qsTr("This will test the maximum speed of the motors and takes about 3 seconds. Please ensure that the robot is lifted and that all emergency stops have been disabled.")
      wrapMode: Text.WordWrap
    }

    onAccepted: {
      isAutoConfigRunning = true;
      SerialPort.setInverseKinematics("99.0", "0.0", "0.0");
      autoConfigTimer.restart();
    }
  }

  Timer {
    id: autoConfigTimer
    interval: 3000; 
    repeat: false;
    onTriggered: {
      SerialPort.setMotorMaximumSpeed(RobotData.mcuData.motorsActualVelocity[0].toString(), RobotData.mcuData.motorsActualVelocity[1].toString(), RobotData.mcuData.motorsActualVelocity[2].toString(), RobotData.mcuData.motorsActualVelocity[3].toString());
      isAutoConfigRunning = false;
    }
  }

  Column {
    width: parent.width
    spacing: 8
    
    // 1. Motor Maximum Speed
    GridLayout {
      width: parent.width
      columns: 5

      LabelText {
        text: qsTr("Motors Maximum Speed (rad/s)")
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

    // 2. Set Motor Maximum Speed
    RowLayout {
      width: parent.width
      spacing: 8

      LabelText {
        text: qsTr("Set Motors Maximum Speed")
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
        onClicked: SerialPort.setMotorMaximumSpeed(motorMaximumSpeed1Field.text, motorMaximumSpeed2Field.text, motorMaximumSpeed3Field.text, motorMaximumSpeed4Field.text)
        Layout.preferredHeight: 48
      }
    }

    // 3. Refresh
    Row {
      spacing: 8

      Button {
        text: qsTr("Refresh")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
        enabled: SerialPort.isConnected
        onClicked: SerialPort.getPid()
        height: 48
      }

      Button {
        text: qsTr("Auto Config")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
        onClicked: autoConfigDialog.open()
        enabled: SerialPort.isConnected && !isAutoConfigRunning
        height: 48
      }

      LabelText {
        height: parent.height
        text: qsTr("Auto Config In Progress")
        font.bold: true
        visible: isAutoConfigRunning
        verticalAlignment: Text.AlignVCenter
      }
    }
  }
}