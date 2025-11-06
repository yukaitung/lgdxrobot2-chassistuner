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
  property int autoConfigMotorIndex: 0
  property list<string> motorTestMaxSpeed: ["0", "0", "0", "0"]

  Dialog {
    id: autoConfigDialog
    anchors.centerIn: Overlay.overlay
    title: qsTr("Auto Config Motors Maximum Speed")
    standardButtons: Dialog.Ok | Dialog.Cancel

    width: 600

    contentItem: LabelText {
      text: qsTr("This will test the maximum speed of the motors one by one and takes about 10 seconds. Pleas ensure that the robot is lifted and all emergency stop has been disabled.")
      wrapMode: Text.WordWrap
    }

    onAccepted: {
      autoConfigMotorIndex = 0;
      isAutoConfigRunning = true;
      autoConfig();
    }
  }

  Timer {
    id: autoConfigTimer
    interval: 2500; 
    repeat: false;
    onTriggered: autoConfig();
  }

  function autoConfig() {
    // Save Data for last motor
    if (autoConfigMotorIndex > 0)
    {
      motorTestMaxSpeed[autoConfigMotorIndex - 1] = RobotData.mcuData.motorsActualVelocity[autoConfigMotorIndex - 1].toString();
      SerialPort.setMotor(autoConfigMotorIndex - 1, "0");

      if (autoConfigMotorIndex >= 4)
      {
        SerialPort.setMotorMaximumSpeed(motorTestMaxSpeed[0], motorTestMaxSpeed[1], motorTestMaxSpeed[2], motorTestMaxSpeed[3]);
        SerialPort.getPid();
        isAutoConfigRunning = false;
        return;
      }
    }

    // Start motor
    SerialPort.setMotor(autoConfigMotorIndex, "999");
    
    // Send result to MCU
    autoConfigMotorIndex++;
    autoConfigTimer.restart();
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
        text: qsTr("Auto Config In Progress: Motor %1").arg(autoConfigMotorIndex)
        font.bold: true
        visible: isAutoConfigRunning
        verticalAlignment: Text.AlignVCenter
      }
    }
  }
}