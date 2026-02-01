import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import SerialPort
import RobotData
import "../../shared"

Pane 
{
  id: pane
  Material.elevation: 2
  width: parent.width

  ColumnLayout {
    width: parent.width
    spacing: 8

    // Hard Iron Calibration Data
    GridLayout {
      width: parent.width
      columns: 4

      LabelText {
        text: qsTr("Hard Iron Calibration Data")
        Layout.preferredWidth: 250
        font.bold: true
      }

      LabelText {
        text: qsTr("X")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Y")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: qsTr("Z")
        Layout.fillWidth: true
        font.bold: true
      }

      LabelText {
        text: "Maximum"
        verticalAlignment: Text.AlignVCenter
        font.bold: true
      }

      TextField {
        id: hardIronXMaxTextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: hardIronYMaxTextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: hardIronZMaxTextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      LabelText {
        text: "Minimum"
        verticalAlignment: Text.AlignVCenter
        font.bold: true
      }

      TextField {
        id: hardIronXMinTextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: hardIronYMinTextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: hardIronZMinTextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }
    }

    LabelText {
      text: ""
    }

    // Soft Iron Calibration Data
    GridLayout {
      width: parent.width
      columns: 4

      LabelText {
        text: qsTr("Soft Iron Calibration Data")
        Layout.preferredWidth: 250
        font.bold: true
      }

      TextField {
        id: softIronMatrix0TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: softIronMatrix1TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: softIronMatrix2TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      LabelText {
        text: ""
        Layout.preferredWidth: 250
      }

      TextField {
        id: softIronMatrix3TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: softIronMatrix4TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: softIronMatrix5TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      LabelText {
        text: ""
        Layout.preferredWidth: 250
      }

      TextField {
        id: softIronMatrix6TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: softIronMatrix7TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }

      TextField {
        id: softIronMatrix8TextField
        enabled: SerialPort.isConnected
        Layout.fillWidth: true
      }
    }

    // Copy for testing
    Row {
      width: parent.width
      spacing: 16

      Button {
        text: qsTr("Copy for Testing")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
        onClicked: {
          RobotData.copyCustomMagDataForTesting(hardIronXMaxTextField.text, hardIronYMaxTextField.text, hardIronZMaxTextField.text, 
            hardIronXMinTextField.text, hardIronYMinTextField.text, hardIronZMinTextField.text, 
            softIronMatrix0TextField.text, softIronMatrix1TextField.text, softIronMatrix2TextField.text, 
            softIronMatrix3TextField.text, softIronMatrix4TextField.text, softIronMatrix5TextField.text, 
            softIronMatrix6TextField.text, softIronMatrix7TextField.text, softIronMatrix8TextField.text);
        }
      }

      Button {
        text: qsTr("Send")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
        onClicked: {
          SerialPort.setMagCalibrationDataCustom(hardIronXMaxTextField.text, hardIronYMaxTextField.text, hardIronZMaxTextField.text, 
            hardIronXMinTextField.text, hardIronYMinTextField.text, hardIronZMinTextField.text, 
            softIronMatrix0TextField.text, softIronMatrix1TextField.text, softIronMatrix2TextField.text, 
            softIronMatrix3TextField.text, softIronMatrix4TextField.text, softIronMatrix5TextField.text, 
            softIronMatrix6TextField.text, softIronMatrix7TextField.text, softIronMatrix8TextField.text);
        }
      }
    }
  }
}
