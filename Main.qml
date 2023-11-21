import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts
import SerialPort

ApplicationWindow {
    id: window
    width: 1920
    height: 1080
    visible: true
    title: qsTr("LGDX Robot 2 Chassis Tuner")

    Component.onCompleted: {
        SerialPort.updateSerialDevices();
    }

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
                    id: serialDevicesCombo
                    Layout.preferredWidth: 300
                    model: SerialPort.serialDevicesName
                }

                Button {
                    text: qsTr("Connect")
                    onClicked: SerialPort.connect(serialDevicesCombo.currentText)
                }

                Button {
                    text: qsTr("Refresh")
                    onClicked: SerialPort.updateSerialDevices()
                }
            }

            Label {
                text: qsTr("2. Robot status:")
            }

            Label {
                text: qsTr("2.1. Target Wheels Velocity (rad/s): Wheel 1: %1, Wheel 2: %2, Wheel 3 %3, Wheel 4: %4")
                .arg(SerialPort.targetWheelsVelocity[0]).arg(SerialPort.targetWheelsVelocity[1]).arg(SerialPort.targetWheelsVelocity[2]).arg(SerialPort.targetWheelsVelocity[3])
            }

            Label {
                text: qsTr("2.2. Measured Wheels Velocity (rad/s): Wheel 1: %1, Wheel 2: %2, Wheel 3: %3, Wheel 4: %4")
                .arg(SerialPort.measuredWheelsVelocity[0]).arg(SerialPort.measuredWheelsVelocity[1]).arg(SerialPort.measuredWheelsVelocity[2]).arg(SerialPort.measuredWheelsVelocity[3])
            }

            Label {
                text: qsTr("2.3. PID (P, I, D): Wheel 1: (%1, %2, %3), Wheel 2: (%4, %5, %6), Wheel 3: (%7, %8, %9), Wheel 4: (%10, %11, %12)")
                .arg(SerialPort.pConstants[0]).arg(SerialPort.iConstants[0]).arg(SerialPort.dConstants[0])
                .arg(SerialPort.pConstants[1]).arg(SerialPort.iConstants[1]).arg(SerialPort.dConstants[1])
                .arg(SerialPort.pConstants[2]).arg(SerialPort.iConstants[2]).arg(SerialPort.dConstants[2])
                .arg(SerialPort.pConstants[3]).arg(SerialPort.iConstants[3]).arg(SerialPort.dConstants[3])
            }

            RowLayout {
                spacing: 8

                Label {
                    text: qsTr("3. Test motor:")
                }

                TextField {
                    id: xVelocityTextField
                    placeholderText: qsTr("X velocity")
                }

                TextField {
                    id: yVelocityTextField
                    placeholderText: qsTr("Y velocity")
                }

                TextField {
                    id: wVelocityTextField
                    placeholderText: qsTr("w velocity")
                }

                Button {
                    text: qsTr("Send")
                    onClicked: {
                        if(xVelocityTextField.text.length === 0)
                            xVelocityTextField.text = "0";
                        if(yVelocityTextField.text.length === 0)
                            yVelocityTextField.text = "0";
                        if(wVelocityTextField.text.length === 0)
                            wVelocityTextField.text = "0";
                        SerialPort.setWheelsVelocity(xVelocityTextField.text, yVelocityTextField.text, wVelocityTextField.text)
                    }
                }

                Button {
                    text: qsTr("Stop")
                    onClicked: SerialPort.setWheelsVelocity(0, 0, 0)
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

                Button {
                    text: qsTr("Stop")
                }

                Button {
                    text: qsTr("Stop")
                }

                Button {
                    text: qsTr("Stop")
                }

                Button {
                    text: qsTr("Stop")
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
                        id: wheel1Kp
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
                        id: wheel2Kp
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
                        id: wheel3Kp
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
                        id: wheel4Kp
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
                        id: wheel1Ki
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
                        id: wheel2Ki
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
                        id: wheel3Ki
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
                        id: wheel4Ki
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
                        id: wheel1Kd
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
                        id: wheel2Kd
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
                        id: wheel3Kd
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
                        id: wheel4Kd
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
