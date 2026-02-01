import QtGraphs
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

  property double axisXMin: 0.0
  property double axisXMax: 1.0
  property double axisYMin: 0.0
  property double axisYMax: 1.0

  Connections {
    target: RobotData
    function onMagCalChartClear()
    {
      xyScatterSeries.clear();
      yzScatterSeries.clear();
      xzScatterSeries.clear();
      pane.axisXMin = 0.0;
      pane.axisXMax = 1.0;
      pane.axisYMin = 0.0;
      pane.axisYMax = 1.0;
    }

    function onMagCalChartUpdated(x, y, z)
    {
      let xmax = Math.max(Math.max(x, y));
      let xmin = Math.min(Math.min(x, y));
      pane.axisXMin = Math.min(pane.axisXMin, xmin);
      pane.axisXMax = Math.max(pane.axisXMax, xmax);
      let ymax = Math.max(Math.max(y, z));
      let ymin = Math.min(Math.min(y, z));
      pane.axisYMin = Math.min(pane.axisYMin, ymin);
      pane.axisYMax = Math.max(pane.axisYMax, ymax);
      xyScatterSeries.append(x, y);
      yzScatterSeries.append(y, z);
      xzScatterSeries.append(x, z);
    }
  }

  ColumnLayout {
    width: parent.width
    spacing: 8

    // Control Buttons
    Row {
      spacing: 16

      Button {
        text: qsTr("Start Calibration")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
        onClicked: {
          RobotData.startMagCal();
        }
      }

      Button {
        text: qsTr("Stop Calibration")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && RobotData.magCalbrating && !RobotData.magTesting
        onClicked: {
          RobotData.stopMagCal();
        }
      }

      Button {
        text: qsTr("Start Testing")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && !RobotData.magTesting && !RobotData.magCalbrating
        onClicked: {
          RobotData.startMagTesting();
        }
      }

      Button {
        text: qsTr("Stop Testing")
        Material.foreground: "white"
        Material.background: Material.accent
        enabled: SerialPort.isConnected && RobotData.magTesting && !RobotData.magCalbrating
        onClicked: {
          RobotData.stopMagTesting();
        }
      }
    }

    // Magtonometer Calibration Graph
    LabelText {
      text: qsTr("Magtonometer Calibration, Red: XY, Green: YZ, Blue: XZ")
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
        seriesColors: ["red", "green", "blue"]
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
        max: pane.axisXMax
        min: pane.axisXMin
      }

      axisY: ValueAxis {
        id: axisY
        max: pane.axisYMax
        min: pane.axisYMin
      }

      ScatterSeries {
        id : xyScatterSeries
      }

      ScatterSeries {
        id : yzScatterSeries
      }

      ScatterSeries {
        id: xzScatterSeries
      }
    }

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
      }

      LabelText {
        text: RobotData.hardIronMax[0].toFixed(6)
      }

      LabelText {
        text: RobotData.hardIronMax[1].toFixed(6)
      }

      LabelText {
        text: RobotData.hardIronMax[2].toFixed(6)
      }

      LabelText {
        text: "Minimum"
      }

      LabelText {
        text: RobotData.hardIronMin[0].toFixed(6)
      }

      LabelText {
        text: RobotData.hardIronMin[1].toFixed(6)
      }

      LabelText {
        text: RobotData.hardIronMin[2].toFixed(6)
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

      LabelText {
        text: RobotData.softIronMatrix[0].toFixed(6)
        Layout.fillWidth: true
      }

      LabelText {
        text: RobotData.softIronMatrix[1].toFixed(6)
        Layout.fillWidth: true
      }

      LabelText {
        text: RobotData.softIronMatrix[2].toFixed(6)
        Layout.fillWidth: true
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.softIronMatrix[3].toFixed(6)
      }

      LabelText {
        text: RobotData.softIronMatrix[4].toFixed(6)
      }

      LabelText {
        text: RobotData.softIronMatrix[5].toFixed(6)
      }

      LabelText {
        text: ""
      }

      LabelText {
        text: RobotData.softIronMatrix[6].toFixed(6)
      }

      LabelText {
        text: RobotData.softIronMatrix[7].toFixed(6)
      }

      LabelText {
        text: RobotData.softIronMatrix[8].toFixed(6)
      }
    }

    // Send
    Button {
      text: qsTr("Send")
      Material.foreground: "white"
      Material.background: Material.accent
      enabled: SerialPort.isConnected && !RobotData.magCalbrating && !RobotData.magTesting
      onClicked: {
        RobotData.sendMagCalData();
      }
    }
  }
}