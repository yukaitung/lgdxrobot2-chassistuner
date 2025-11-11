import QtGraphs
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
    function onPidChartClear() 
    {
      targetSeries.clear();
      measurementSeries.clear();
      axisX.min = 0;
      axisX.max = 1;
      axisY.min = 0;
      axisY.max = 1;
    }

    function onPidChartSetTargetVelocity(velocity) 
    {
      if (velocity >= axisY.max)
      {
        axisY.max = velocity + 1;
      }
      if (velocity <= axisY.min)
      {
        axisY.min = velocity - 1;
      }
    }

    function onPidChartUpdated(time, velocity, targetVelocity)
    {
      measurementSeries.append(time, velocity)
      axisX.max = time;
      targetSeries.clear();
      targetSeries.append(0, targetVelocity);
      targetSeries.append(axisX.max, targetVelocity);
    }
  }

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
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: iTextField
        placeholderText: qsTr("I")
        validator: DoubleValidator {}
        enabled: SerialPort.isConnected
      }

      TextField {
        id: dTextField
        placeholderText: qsTr("D")
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

    // 3. Custom velocity check box
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
        enabled: customVelocityCheckBox.checked
      }

      LabelText {
        text: qsTr("Using velocity of %1 rad/s from level %2")
          .arg(RobotData.pidData.pidSpeed[levelComboBox.currentIndex])
          .arg(levelComboBox.currentIndex + 1)
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        visible: !customVelocityCheckBox.checked
        font.bold: true
      }
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
          var velocity = RobotData.pidData.pidSpeed[levelComboBox.currentIndex].toString();
          if (customVelocityCheckBox.checked)
            velocity = customVelocityTextField.text;
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

    // 6. Chart
    LabelText {
      text: qsTr("PID Chart, X-axis: Time (ms), Y-axis: Velocity (rad/s)")
      font.bold: true
      Layout.columnSpan: 2
      Layout.alignment: Qt.AlignHCenter
    }

    GraphsView {
      id: graphView
      Layout.fillWidth: true
      Layout.preferredHeight: 600
      Layout.columnSpan: 2
      Layout.alignment: Qt.AlignHCenter

      theme: GraphsTheme {
        readonly property color c1: "#1E1F24"
        readonly property color c2: "#EFF0F3"
        readonly property color c3: "#E0E1E6"
        colorScheme: GraphsTheme.ColorScheme.Light
        seriesColors: ["#821B1D", "green"]
        grid.mainColor: c3
        grid.subColor: c2
        axisX.mainColor: c3
        axisY.mainColor: c3
        axisX.subColor: c2
        axisY.subColor: c2
        axisX.labelTextColor: c1
        axisY.labelTextColor: c1
      }

      // Axis
      axisX: ValueAxis {
        id: axisX
        max: 1
        min: 0
      }

      axisY: ValueAxis {
        id: axisY
        max: 1
        min: 0
      }

      LineSeries {
        id: measurementSeries
        width: 2
      }

      LineSeries {
        id: targetSeries
        width: 2
      }
    }
  }
}