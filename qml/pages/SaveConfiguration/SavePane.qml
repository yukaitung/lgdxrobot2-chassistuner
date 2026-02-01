import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import SerialPort
import "../../shared"

Pane 
{
  Material.elevation: 2
  width: parent.width

  Timer {
    id: timer
    interval: 5000; 
    onTriggered: label.visible = false
  }

  Row {
    width: parent.width
    spacing: 16

    Button {
      text: qsTr("Save Configuration")
      Material.foreground: "white"
      Material.background: Material.accent
      enabled: SerialPort.isConnected
      onClicked: {
        SerialPort.saveConfiguration();
        label.visible = true;
        timer.start();
      }
    }

    LabelText {
      id: label
      height: parent.height
      text: qsTr("Resquest sent")
      color: "green"
      font.bold: true
      visible: false
      verticalAlignment: Text.AlignVCenter
    }
  }
}