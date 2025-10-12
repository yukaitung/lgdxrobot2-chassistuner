import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import SerialPort
import RobotData
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
        id: motorComboBox
        model: [qsTr("Motor 1"), qsTr("Motor 2"), qsTr("Motor 3"), qsTr("Motor 4")]
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
        enabled: (SerialPort.isConnected && !RobotData.pidChartEnabled)
      }

      ComboBox {
        id: levelComboBox
        model: [qsTr("Level 1"), qsTr("Level 2"), qsTr("Level 3")]
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
        enabled: SerialPort.isConnected
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
        id: pTextField
        placeholderText: qsTr("P")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: iTextField
        placeholderText: qsTr("I")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: dTextField
        placeholderText: qsTr("D")
        Layout.preferredWidth: 150
        Layout.preferredHeight: 36
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      Item {
        Layout.fillWidth: true
      }

      Button {
        text: qsTr("Update")
        Material.foreground: "white"
        Material.background: Material.accent
        Layout.alignment: Qt.AlignRight
        enabled: SerialPort.isConnected
        Layout.preferredHeight: 48
        onClicked: SerialPort.setPid(motorComboBox.currentIndex, levelComboBox.currentIndex, pTextField.text, iTextField.text, dTextField.text)
      }
    }

    // 2. Custom velocity check box
    CheckBox {
      id: customVelocityCheckBox
      text: qsTr("Custom Velocity")
      font.bold: true
      enabled: SerialPort.isConnected
    }

    Row {
      spacing: 16
      Layout.fillWidth: true

      TextField {
        id: customVelocityTextField
        placeholderText: qsTr("Velocity (rad/s)")
        width: 150
        height: 36
        enabled: customVelocityCheckBox.checked
      }

      LabelText {
        text: qsTr("Using velocity of %1 rad/s from level %2")
          .arg(RobotData.pidData.levelVelocity[levelComboBox.currentIndex])
          .arg(levelComboBox.currentIndex + 1)
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        visible: !customVelocityCheckBox.checked
        font.bold: true
      }
    }
    
    // 3. Direction check box
    CheckBox {
      id: reverseDirectionCheckBox
      Layout.columnSpan: 2
      text: qsTr("Reverse Direction")
      font.bold: true
      enabled: SerialPort.isConnected
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
        enabled: SerialPort.isConnected
        onClicked: {
          var velocity = RobotData.pidData.levelVelocity[levelComboBox.currentIndex].toString();
          if (customVelocityCheckBox.checked)
            velocity = customVelocityTextField.text;
          if (reverseDirectionCheckBox.checked)
            velocity = "-" + velocity;
          SerialPort.setMotor(motorComboBox.currentIndex, velocity);
          RobotData.startPidChart(motorComboBox.currentIndex, velocity);
        }
      }

      Button {
        text: qsTr("Stop")
        Material.foreground: "white"
        Material.background: Material.accent
        height: 48
        enabled: SerialPort.isConnected
        onClicked: {
          SerialPort.setInverseKinematics(0, 0, 0);
          RobotData.stopPidChart();
        }
      }
    }
  }
}