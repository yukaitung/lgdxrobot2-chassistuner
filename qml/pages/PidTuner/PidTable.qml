import QtQuick
import QtQuick.Layouts
import RobotData
import "../../shared"

GridLayout {
  id: grid
  columns: 5
  rowSpacing: 4
  property int level: 0

  LabelText {
    text: qsTr("Level %1, %2 rad/s")
      .arg(grid.level + 1)
      .arg(RobotData.pidData.levelVelocity[grid.level].toFixed(2))
    font.bold: true
    Layout.preferredWidth: 150
  }

  LabelText {
    text: qsTr("Motor 1")
    font.bold: true
    Layout.fillWidth: true
  }

  LabelText {
    text: qsTr("Motor 2")
    font.bold: true
    Layout.fillWidth: true
  }

  LabelText {
    text: qsTr("Motor 3")
    font.bold: true
    Layout.fillWidth: true
  }

  LabelText {
    text: qsTr("Motor 4")
    font.bold: true
    Layout.fillWidth: true
  }

  LabelText {
    text: qsTr("P")
    font.bold: true
  }

  LabelText {
    text: RobotData.pidData.p[grid.level][0]
  }

  LabelText {
    text: RobotData.pidData.p[grid.level][1]
  }

  LabelText {
    text: RobotData.pidData.p[grid.level][2]
  }

  LabelText {
    text: RobotData.pidData.p[grid.level][3]
  }
  
  LabelText {
    text: qsTr("I")
    font.bold: true
  }

  LabelText {
    text: RobotData.pidData.i[grid.level][0]
  }

  LabelText {
    text: RobotData.pidData.i[grid.level][1]
  }

  LabelText {
    text: RobotData.pidData.i[grid.level][2]
  }

  LabelText {
    text: RobotData.pidData.i[grid.level][3]
  }

  LabelText {
    text: qsTr("D")
    font.bold: true
  }

  LabelText {
    text: RobotData.pidData.d[grid.level][0]
  }

  LabelText {
    text: RobotData.pidData.d[grid.level][1]
  }

  LabelText {
    text: RobotData.pidData.d[grid.level][2]
  }

  LabelText {
    text: RobotData.pidData.d[grid.level][3]
  }
}