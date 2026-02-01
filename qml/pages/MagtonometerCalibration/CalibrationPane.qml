import QtGraphs
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import SerialPort
import "../../shared"

Pane 
{
  Material.elevation: 2
  width: parent.width

  GraphsTheme {
    id: themeQt
    theme: GraphsTheme.Theme.QtGreen
    labelFont.pointSize: 40
  }

  ListModel {
    id: dataModel
    ListElement{ xPos: "2.754"; yPos: "1.455"; zPos: "3.362"; }
    ListElement{ xPos: "3.164"; yPos: "2.022"; zPos: "4.348"; }
    ListElement{ xPos: "4.564"; yPos: "1.865"; zPos: "1.346"; }
    ListElement{ xPos: "1.068"; yPos: "1.224"; zPos: "2.983"; }
    ListElement{ xPos: "2.323"; yPos: "2.502"; zPos: "3.133"; }
  }


}