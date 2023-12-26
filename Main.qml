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

    property double chartMaxMs: 5000
    property bool wheel1ChartRun: false
    property double wheel1ChartTarget: 0
    property double wheel1ChartStartTimeMs: 0
    property bool wheel2ChartRun: false
    property double wheel2ChartTarget: 0
    property double wheel2ChartStartTimeMs: 0
    property bool wheel3ChartRun: false
    property double wheel3ChartTarget: 0
    property double wheel3ChartStartTimeMs: 0
    property bool wheel4ChartRun: false
    property double wheel4ChartTarget: 0
    property double wheel4ChartStartTimeMs: 0

    Connections {
        target: SerialPort
        function onDeviceReadyChanged() {
            if(SerialPort.deviceReady) {
                wheel1Kp.text = SerialPort.pFirstConstants[0];
                wheel2Kp.text = SerialPort.pFirstConstants[1];
                wheel3Kp.text = SerialPort.pFirstConstants[2];
                wheel4Kp.text = SerialPort.pFirstConstants[3];
                wheel1Ki.text = SerialPort.iFirstConstants[0];
                wheel2Ki.text = SerialPort.iFirstConstants[1];
                wheel3Ki.text = SerialPort.iFirstConstants[2];
                wheel4Ki.text = SerialPort.iFirstConstants[3];
                wheel1Kd.text = SerialPort.dFirstConstants[0];
                wheel2Kd.text = SerialPort.dFirstConstants[1];
                wheel3Kd.text = SerialPort.dFirstConstants[2];
                wheel4Kd.text = SerialPort.dFirstConstants[3];
            }
        }
        function onRobotStatusChanged() {
            if(wheel1ChartRun === true) {
                let timeNow = Date.now() - wheel1ChartStartTimeMs;
                wheel1ChartLine1.append(timeNow, SerialPort.measuredWheelsVelocity[0]);
                wheel1ChartLine2.append(timeNow, wheel1ChartTarget);
                wheel1ChartAxisX.max = timeNow;
                wheel1ChartAxisX.min = timeNow - chartMaxMs > 0 ? timeNow - chartMaxMs : 0
            }
            if(wheel2ChartRun === true) {
                let timeNow = Date.now() - wheel2ChartStartTimeMs;
                wheel2ChartLine1.append(timeNow, SerialPort.measuredWheelsVelocity[1]);
                wheel2ChartLine2.append(timeNow, wheel2ChartTarget);
                wheel2ChartAxisX.max = timeNow;
                wheel2ChartAxisX.min = timeNow - chartMaxMs > 0 ? timeNow - chartMaxMs : 0
            }
            if(wheel3ChartRun === true) {
                let timeNow = Date.now() - wheel3ChartStartTimeMs;
                wheel3ChartLine1.append(timeNow, SerialPort.measuredWheelsVelocity[2]);
                wheel3ChartLine2.append(timeNow, wheel3ChartTarget);
                wheel3ChartAxisX.max = timeNow;
                wheel3ChartAxisX.min = timeNow - chartMaxMs > 0 ? timeNow - chartMaxMs : 0
            }
            if(wheel4ChartRun === true) {
                let timeNow = Date.now() - wheel4ChartStartTimeMs;
                wheel4ChartLine1.append(timeNow, SerialPort.measuredWheelsVelocity[3]);
                wheel4ChartLine2.append(timeNow, wheel4ChartTarget);
                wheel4ChartAxisX.max = timeNow;
                wheel4ChartAxisX.min = timeNow - chartMaxMs > 0 ? timeNow - chartMaxMs : 0
            }
        }
    }

    ScrollView {
        anchors.fill: parent

        ColumnLayout {
            width: window.width - 32
            anchors.left: parent.left;
            anchors.leftMargin: 16

            spacing: 8

            Label {
                text: qsTr("LGDX Robot 2 Chassis Tuner")
                font.bold: true
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

            RowLayout {
                Label {
                    text: qsTr("2. Robot status: ")
                }
                Label {
                    text: qsTr("Connected")
                    color: "Green"
                    visible: SerialPort.deviceReady
                }
                Label {
                    text: qsTr("Disconnected")
                    color: "Red"
                    visible: !SerialPort.deviceReady
                }
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

            Label {
                text: qsTr("2.4. PWM (Out of 71999): Wheel 1: %1, Wheel 2: %2, Wheel 3: %3, Wheel 4: %4")
                .arg(SerialPort.pwm[0]).arg(SerialPort.pwm[1]).arg(SerialPort.pwm[2]).arg(SerialPort.pwm[3])
            }

            Label {
                text: qsTr("2.5. Voltage (V): V1: %1, V2: %2")
                //.arg(Number(SerialPort.ina219[0]/100000).toFixed(2)).arg(Number(SerialPort.ina219[1]/100000).toFixed(2))
                .arg(Number(SerialPort.ina219[0] * 0.004).toFixed(2)).arg(Number(SerialPort.ina219[1] * 0.004).toFixed(2))
            }

            RowLayout {
                spacing: 8

                Label {
                    text: qsTr("3. Test motor (m/s) before IK:")
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
                text: qsTr("4. PID tuner:")
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
                        id: wheel1ChartLine1
                        color: "red"
                        axisX: ValueAxis {
                            id: wheel1ChartAxisX
                            min: 0
                            max: 1
                        }
                        axisY: ValueAxis {
                            id: wheel1ChartAxisY
                            min: 0
                            max: 1
                        }
                    }

                    LineSeries {
                        id: wheel1ChartLine2
                    }
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        id: wheel2ChartLine1
                        color: "red"
                        axisX: ValueAxis {
                            id: wheel2ChartAxisX
                            min: 0
                            max: 1
                        }
                        axisY: ValueAxis {
                            id: wheel2ChartAxisY
                            min: 0
                            max: 1
                        }
                    }

                    LineSeries {
                        id: wheel2ChartLine2
                    }
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        id: wheel3ChartLine1
                        color: "red"
                        axisX: ValueAxis {
                            id: wheel3ChartAxisX
                            min: 0
                            max: 1
                        }
                        axisY: ValueAxis {
                            id: wheel3ChartAxisY
                            min: 0
                            max: 1
                        }
                    }

                    LineSeries {
                        id: wheel3ChartLine2
                    }
                }

                ChartView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 500
                    antialiasing: true
                    legend.visible: false

                    LineSeries {
                        id: wheel4ChartLine1
                        color: "red"
                        axisX: ValueAxis {
                            id: wheel4ChartAxisX
                            min: 0
                            max: 1
                        }
                        axisY: ValueAxis {
                            id: wheel4ChartAxisY
                            min: 0
                            max: 1
                        }
                    }

                    LineSeries {
                        id: wheel4ChartLine2
                    }
                }

                Label {
                    text: qsTr("Test PID target velocity (rad/s) after IK:")
                }

                Label {
                    text: qsTr("Test PID target velocity (rad/s) after IK:")
                }

                Label {
                    text: qsTr("Test PID target velocity (rad/s) after IK:")
                }

                Label {
                    text: qsTr("Test PID target velocity (rad/s) after IK:")
                }

                TextField {
                    id: wheel1Target
                }

                TextField {
                    id: wheel2Target
                }

                TextField {
                    id: wheel3Target
                }

                TextField {
                    id: wheel4Target
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Test")
                        onClicked: {
                            if(wheel1Target.text.length === 0)
                                wheel1Target.text = "0";
                            if(!wheel1ChartRun) {
                                wheel1ChartLine1.clear();
                                wheel1ChartLine2.clear();
                                wheel1ChartAxisX.max = 1;
                                wheel1ChartStartTimeMs = Date.now();
                                wheel1ChartRun = true;
                            }
                            wheel1ChartAxisY.max = parseFloat(wheel1Target.text) + 2;
                            wheel1ChartTarget = parseFloat(wheel1Target.text);
                            SerialPort.setSingleWheelVelocity(0, wheel1Target.text);
                        }
                    }

                    Button {
                        text: qsTr("Stop")
                        onClicked: {
                            SerialPort.setSingleWheelVelocity(0, 0)
                            wheel1ChartRun = false;
                        }
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Test")
                        onClicked: {
                            if(wheel2Target.text.length === 0)
                                wheel2Target.text = "0";
                            if(!wheel2ChartRun) {
                                wheel2ChartLine1.clear();
                                wheel2ChartLine2.clear();
                                wheel2ChartAxisX.max = 1;
                                wheel2ChartStartTimeMs = Date.now();
                                wheel2ChartRun = true;
                            }
                            wheel2ChartAxisY.max = parseFloat(wheel2Target.text) + 2;
                            wheel2ChartTarget = parseFloat(wheel2Target.text);
                            SerialPort.setSingleWheelVelocity(1, wheel2Target.text);
                        }
                    }

                    Button {
                        text: qsTr("Stop")
                        onClicked: {
                            SerialPort.setSingleWheelVelocity(1, 0)
                            wheel2ChartRun = false;
                        }
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Test")
                        onClicked: {
                            if(wheel3Target.text.length === 0)
                                wheel3Target.text = "0";
                            if(!wheel3ChartRun) {
                                wheel3ChartLine1.clear();
                                wheel3ChartLine2.clear();
                                wheel3ChartAxisX.max = 1;
                                wheel3ChartStartTimeMs = Date.now();
                                wheel3ChartRun = true;
                            }
                            wheel3ChartAxisY.max = parseFloat(wheel3Target.text) + 2;
                            wheel3ChartTarget = parseFloat(wheel3Target.text);
                            SerialPort.setSingleWheelVelocity(2, wheel3Target.text);
                        }
                    }

                    Button {
                        text: qsTr("Stop")
                        onClicked: {
                            SerialPort.setSingleWheelVelocity(2, 0)
                            wheel3ChartRun = false;
                        }
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Test")
                        onClicked: {
                            if(wheel4Target.text.length === 0)
                                wheel4Target.text = "0";
                            if(!wheel4ChartRun) {
                                wheel4ChartLine1.clear();
                                wheel4ChartLine2.clear();
                                wheel4ChartAxisX.max = 1;
                                wheel4ChartStartTimeMs = Date.now();
                                wheel4ChartRun = true;
                            }
                            wheel4ChartAxisY.max = parseFloat(wheel4Target.text) + 2;
                            wheel4ChartTarget = parseFloat(wheel4Target.text);
                            SerialPort.setSingleWheelVelocity(3, wheel4Target.text);
                        }
                    }

                    Button {
                        text: qsTr("Stop")
                        onClicked: {
                            SerialPort.setSingleWheelVelocity(3, 0)
                            wheel4ChartRun = false;
                        }
                    }
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
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel1Ki
                    }
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
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel2Kp
                    }
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel2Ki
                    }
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
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel3Kp
                    }
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel3Ki
                    }
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
                        text: "P:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel4Kp
                    }
                    Label {
                        text: "I:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel4Ki
                    }
                    Label {
                        text: "D:"
                        Layout.preferredWidth: 10
                        verticalAlignment: Text.AlignVCenter
                    }
                    TextField {
                        id: wheel4Kd
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Update PID")
                        onClicked: {
                            if(wheel1Kp.text.length === 0)
                                wheel1Kp.text = "0";
                            if(wheel1Ki.text.length === 0)
                                wheel1Ki.text = "0";
                            if(wheel1Kd.text.length === 0)
                                wheel1Kd.text = "0";
                            SerialPort.setPID(0, wheel1Kp.text, wheel1Ki.text, wheel1Kd.text);
                        }
                    }

                    Button {
                        text: qsTr("Reset PID")
                        onClicked: {
                            wheel1Kp.text = SerialPort.pFirstConstants[0];
                            wheel1Ki.text = SerialPort.iFirstConstants[0];
                            wheel1Kd.text = SerialPort.dFirstConstants[0];
                            SerialPort.setPID(0, wheel1Kp.text, wheel1Ki.text, wheel1Kd.text);
                        }
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Update PID")
                        onClicked: {
                            if(wheel2Kp.text.length === 0)
                                wheel2Kp.text = "0";
                            if(wheel2Ki.text.length === 0)
                                wheel2Ki.text = "0";
                            if(wheel2Kd.text.length === 0)
                                wheel2Kd.text = "0";
                            SerialPort.setPID(1, wheel2Kp.text, wheel2Ki.text, wheel2Kd.text);
                        }
                    }

                    Button {
                        text: qsTr("Reset PID")
                        onClicked: {
                            wheel2Kp.text = SerialPort.pFirstConstants[1];
                            wheel2Ki.text = SerialPort.iFirstConstants[1];
                            wheel2Kd.text = SerialPort.dFirstConstants[1];
                            SerialPort.setPID(1, wheel2Kp.text, wheel2Ki.text, wheel2Kd.text);
                        }
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Update PID")
                        onClicked: {
                            if(wheel3Kp.text.length === 0)
                                wheel3Kp.text = "0";
                            if(wheel3Ki.text.length === 0)
                                wheel3Ki.text = "0";
                            if(wheel3Kd.text.length === 0)
                                wheel3Kd.text = "0";
                            SerialPort.setPID(2, wheel3Kp.text, wheel3Ki.text, wheel3Kd.text);
                        }
                    }

                    Button {
                        text: qsTr("Reset PID")
                        onClicked: {
                            wheel3Kp.text = SerialPort.pFirstConstants[2];
                            wheel3Ki.text = SerialPort.iFirstConstants[2];
                            wheel3Kd.text = SerialPort.dFirstConstants[2];
                            SerialPort.setPID(2, wheel3Kp.text, wheel3Ki.text, wheel3Kd.text);
                        }
                    }
                }

                RowLayout {
                    spacing: 8

                    Button {
                        text: qsTr("Update PID")
                        onClicked: {
                            if(wheel4Kp.text.length === 0)
                                wheel4Kp.text = "0";
                            if(wheel4Ki.text.length === 0)
                                wheel4Ki.text = "0";
                            if(wheel4Kd.text.length === 0)
                                wheel4Kd.text = "0";
                            SerialPort.setPID(3, wheel4Kp.text, wheel4Ki.text, wheel4Kd.text);
                        }
                    }

                    Button {
                        text: qsTr("Reset PID")
                        onClicked: {
                            wheel4Kp.text = SerialPort.pFirstConstants[3];
                            wheel4Ki.text = SerialPort.iFirstConstants[3];
                            wheel4Kd.text = SerialPort.dFirstConstants[3];
                            SerialPort.setPID(3, wheel4Kp.text, wheel4Ki.text, wheel4Kd.text);
                        }
                    }
                }
            }

            Label {
                // Empty
            }
        }
    }
}
