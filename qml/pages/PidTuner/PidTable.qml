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
      .arg(RobotData.pidData.levelVelocity[grid.level])
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
    text: RobotData.pidData.p[0][grid.level]
  }

  LabelText {
    text: RobotData.pidData.p[1][grid.level]
  }

  LabelText {
    text: RobotData.pidData.p[2][grid.level]
  }

  LabelText {
    text: RobotData.pidData.p[3][grid.level]
  }
  
  LabelText {
    text: qsTr("I")
    font.bold: true
  }

  LabelText {
    text: RobotData.pidData.i[0][grid.level]
  }

  LabelText {
    text: RobotData.pidData.i[1][grid.level]
  }

  LabelText {
    text: RobotData.pidData.i[2][grid.level]
  }

  LabelText {
    text: RobotData.pidData.i[3][grid.level]
  }

  LabelText {
    text: qsTr("D")
    font.bold: true
  }

  LabelText {
    text: RobotData.pidData.d[0][grid.level]
  }

  LabelText {
    text: RobotData.pidData.d[1][grid.level]
  }

  LabelText {
    text: RobotData.pidData.d[2][grid.level]
  }

  LabelText {
    text: RobotData.pidData.d[3][grid.level]
  }
}