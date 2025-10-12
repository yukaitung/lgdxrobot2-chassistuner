import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtGraphs
import "../../shared"

Pane {
  id: pane
  Material.elevation: 2
  width: parent.width
  height: graphView.height + (pane.padding * 2)

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
      seriesColors: ["#821B1D", "#B94B46"]
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
      max: 5
      tickInterval: 1
      subTickCount: 5
      labelDecimals: 1
    }

    axisY: ValueAxis {
      max: 10
      tickInterval: 1
      subTickCount: 5
      labelDecimals: 1
    }

    LineSeries {
      id: lineSeries1
      width: 2
      XYPoint { x: 0; y: 0 }
      XYPoint { x: 1; y: 2.1 }
      XYPoint { x: 2; y: 3.3 }
      XYPoint { x: 3; y: 2.1 }
      XYPoint { x: 4; y: 4.9 }
      XYPoint { x: 5; y: 3.0 }
    }

    LineSeries {
      id: lineSeries2
      width: 2
      XYPoint { x: 0; y: 9.0 }
      XYPoint { x: 5; y: 9.0 }
    }
  }
}