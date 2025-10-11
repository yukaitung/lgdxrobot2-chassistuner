import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import "pages"
import "shared"
import "global.js" as Global

ApplicationWindow {
	id: window
	width: 1280
	height: 720
	visible: true
	title: qsTr("LGDXRobot2 ChassisTuner")

	header: ToolBar {
		id: toolBar

		RowLayout {
			spacing: 0
			width: parent.width - 32
			height: parent.height
			anchors.centerIn: parent

			Image {
				source: Qt.resolvedUrl("qrc:/qml/img/logo.png")
				fillMode: Image.PreserveAspectFit
				horizontalAlignment: Image.AlignLeft
				Layout.fillWidth: true
				Layout.preferredHeight: 32
			}

			ToolButton {
				icon.source: Qt.resolvedUrl("qrc:/qml/img/refresh.svg")
				icon.color: "white"
			}

			ComboBox {
				Layout.preferredHeight: 32
				Layout.preferredWidth: 300
				model: ["First", "Second", "Third"]
				background: Rectangle {
						color: "white"
						border.color: "white"
						radius: 4
				}
			}

			ToolButton {
				icon.source: Qt.resolvedUrl("qrc:/qml/img/connect.svg")
				icon.color: "white"
			}
		}
	}

	TabBar {
		id: tabBar
		width: Math.min(parent.width, Global.maxWidth)
		anchors.horizontalCenter: parent.horizontalCenter
		spacing: 0
		
		TabButton {
			text: qsTr("Robot Data")
		}

		TabButton {
			text: qsTr("PID Tuner")
		}
	}

	StackLayout {
		anchors.top: tabBar.bottom
		anchors.bottom: parent.bottom
		width: parent.width
		currentIndex: tabBar.currentIndex

		RobotData {
			anchors.fill: parent
		}

		PidTuner {
			anchors.fill: parent
		}
	}
}
