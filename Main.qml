import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts

ApplicationWindow {
    id: window
    width: 1920
    height: 1080
    visible: true
    title: qsTr("LGDX Robot 2 Chassis Turner")

    ScrollView {
        anchors.fill: parent

        ColumnLayout {
            width: window.width - 32
            anchors.left: parent.left;
            anchors.leftMargin: 16

            spacing: 8

            Label {
                text: qsTr("LGDX Robot 2 Chassis Turner")
                font.pixelSize: 20
                Layout.topMargin: 16
            }

            RowLayout {
                spacing: 8

                Label {
                    text: qsTr("1. Select serial port device:")
                }

                ComboBox {
                    model: ["First", "Second", "Third"]
                }

                Button {
                    text: qsTr("Connect")
                }

                Button {
                    text: qsTr("Refresh")
                }
            }

            Label {
                text: qsTr("2. Robot status:")
            }

            RowLayout {
                spacing: 8

                Label {
                    text: qsTr("3. Test motor:")
                }

                TextField {
                    placeholderText: qsTr("X velocity")
                }

                TextField {
                    placeholderText: qsTr("Y velocity")
                }

                TextField {
                    placeholderText: qsTr("w velocity")
                }

                Button {
                    text: qsTr("Send")
                }

                Button {
                    text: qsTr("Stop")
                }
            }

            Label {
                text: qsTr("4. PID turner:")
            }

            GridLayout {
                columns: 4
                columnSpacing: 8
                rowSpacing: 8
                Layout.fillWidth: true

                Label {
                    text: qsTr("Motor 1")
                }

                Label {
                    text: qsTr("Motor 2")
                }

                Label {
                    text: qsTr("Motor 3")
                }

                Label {
                    text: qsTr("Motor 4")
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        name: "Line"
                        XYPoint { x: 0; y: 0 }
                        XYPoint { x: 1.1; y: 2.1 }
                        XYPoint { x: 1.9; y: 3.3 }
                        XYPoint { x: 2.1; y: 2.1 }
                        XYPoint { x: 2.9; y: 4.9 }
                        XYPoint { x: 3.4; y: 3.0 }
                        XYPoint { x: 4.1; y: 3.3 }
                    }
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        name: "Line"
                        XYPoint { x: 0; y: 0 }
                        XYPoint { x: 1.1; y: 2.1 }
                        XYPoint { x: 1.9; y: 3.3 }
                        XYPoint { x: 2.1; y: 2.1 }
                        XYPoint { x: 2.9; y: 4.9 }
                        XYPoint { x: 3.4; y: 3.0 }
                        XYPoint { x: 4.1; y: 3.3 }
                    }
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        name: "Line"
                        XYPoint { x: 0; y: 0 }
                        XYPoint { x: 1.1; y: 2.1 }
                        XYPoint { x: 1.9; y: 3.3 }
                        XYPoint { x: 2.1; y: 2.1 }
                        XYPoint { x: 2.9; y: 4.9 }
                        XYPoint { x: 3.4; y: 3.0 }
                        XYPoint { x: 4.1; y: 3.3 }
                    }
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        name: "Line"
                        XYPoint { x: 0; y: 0 }
                        XYPoint { x: 1.1; y: 2.1 }
                        XYPoint { x: 1.9; y: 3.3 }
                        XYPoint { x: 2.1; y: 2.1 }
                        XYPoint { x: 2.9; y: 4.9 }
                        XYPoint { x: 3.4; y: 3.0 }
                        XYPoint { x: 4.1; y: 3.3 }
                    }
                }

                Button {
                    text: qsTr("Reset Chart")
                }

                Button {
                    text: qsTr("Reset Chart")
                }

                Button {
                    text: qsTr("Reset Chart")
                }

                Button {
                    text: qsTr("Reset Chart")
                }

                Label {
                    text: qsTr("Test PID target velocity:")
                }

                Label {
                    text: qsTr("Test PID target velocity:")
                }

                Label {
                    text: qsTr("Test PID target velocity:")
                }

                Label {
                    text: qsTr("Test PID target velocity:")
                }

                TextField {
                }

                TextField {
                }

                TextField {
                }

                TextField {
                }

                Button {
                    text: qsTr("Test")
                }

                Button {
                    text: qsTr("Test")
                }

                Button {
                    text: qsTr("Test")
                }

                Button {
                    text: qsTr("Test")
                }

                Label {
                    text: qsTr("Set PID:")
                }

                Label {
                    text: qsTr("Set PID:")
                }

                Label {
                    text: qsTr("Set PID:")
                }

                Label {
                    text: qsTr("Set PID:")
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "D:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "D:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "D:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                RowLayout {
                    spacing: 8
                    Label {
                        text: "D:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {

                    }
                }

                Button {
                    text: qsTr("Update PID")
                }

                Button {
                    text: qsTr("Update PID")
                }

                Button {
                    text: qsTr("Update PID")
                }

                Button {
                    text: qsTr("Update PID")
                }

                Button {
                    text: qsTr("Reset PID")
                }

                Button {
                    text: qsTr("Reset PID")
                }

                Button {
                    text: qsTr("Reset PID")
                }

                Button {
                    text: qsTr("Reset PID")
                }
            }

            Label {

            }
        }
    }
}
