import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtGraphs
import RobotData
import "../../shared"

Pane {
  id: pane
  Material.elevation: 2
  width: parent.width
  height: graphView.height + (pane.padding * 2)

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
      if (velocity > axisY.max)
      {
        axisY.max = velocity + 1;
      }
      if (velocity < axisY.min)
      {
        axisY.min = velocity - 1;
      }
      targetSeries.clear();
      targetSeries.append(0, velocity);
      targetSeries.append(axisX.max, velocity);
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

  GraphsView {
    id: graphView
    height: 600
    width: 600
    anchors.centerIn: parent

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