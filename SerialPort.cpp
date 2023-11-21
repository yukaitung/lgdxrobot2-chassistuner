#include "SerialPort.h"
#include <iostream>
SerialPort::SerialPort(QObject *parent) : QObject{parent}
{
    QObject::connect(&mSerial, &QSerialPort::readyRead, this, &SerialPort::read);
}

float SerialPort::uint32ToFloat(uint32_t n){
    return (float)(*(float*)&n);
}

uint32_t combineByte(uint32_t a, uint32_t b, uint32_t c, uint32_t d) {
    return a << 24 | b << 16 | c << 8 | d;
}

QObject *SerialPort::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    return new SerialPort;
}

void SerialPort::connect(QString portName)
{
    if(mSerial.isOpen()) {
        mSerial.close();
    }
    mSerial.setPortName(portName);
    mSerial.open(QIODevice::ReadWrite);
}

void SerialPort::read()
{
    QByteArray data = mSerial.readAll();
    if(data.size() > 2) {
        // Locate frame size
        if(data[0] == (char) 170) {
            mSerialFrameSize = (int) data[1] + 1;
            // The package is too small, wait for next pacakge
            if(data.size() < mSerialFrameSize) {
                mSerialBuffer += data;
                return;
            }
            // The package is too big, discard the data
        }
    }

    if(mSerialBuffer.size() + data.size() == mSerialFrameSize) {
        // Get data
        QByteArray frame = mSerialBuffer + data;
        int index = 2;
        for(int i = 0; i < 4; i++) {
            uint32_t temp = combineByte((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            mTargetWheelsVelocity[i] = uint32ToFloat(temp);
            index += 4;
        }
        for(int i = 0; i < 4; i++) {
            uint32_t temp = combineByte((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            mMeasuredWheelsVelocity[i] = uint32ToFloat(temp);
            index += 4;
        }
        for(int i = 0; i < 4; i++) {
            mPConstants[i] = combineByte((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            index += 4;
        }
        for(int i = 0; i < 4; i++) {
            mIConstants[i] = combineByte((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            index += 4;
        }
        for(int i = 0; i < 4; i++) {
            mDConstants[i] = combineByte((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            index += 4;
        }
        emit robotStatusChanged();
        mSerialBuffer.clear();
    }
}

void SerialPort::setWheelsVelocity(float x, float y, float w)
{
    uint32_t ux = floatToUint32(x);
    uint32_t uy = floatToUint32(y);
    uint32_t uw = floatToUint32(w);
    char ba[13];
    ba[0] = 'M';
    ba[1] = (ux & 4278190080) >> 24;
    ba[2] = (ux & 16711680) >> 16;
    ba[3] = (ux & 65280) >> 8;
    ba[4] = ux & 255;
    ba[5] = (uy & 4278190080) >> 24;
    ba[6] = (uy & 16711680) >> 16;
    ba[7] = (uy & 65280) >> 8;
    ba[8] = uy & 255;
    ba[9] = (uw & 4278190080) >> 24;
    ba[10] = (uw & 16711680) >> 16;
    ba[11] = (uw & 65280) >> 8;
    ba[12] = uw & 255;
    if(mSerial.isOpen()) {
        mSerial.write(ba, 13);
    }
    else {
        qDebug() << "Serial is closed.";
    }
}

void SerialPort::updateSerialDevices()
{
    mSerialDevicesName.clear();
    const auto serialPortInfos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &portInfo : serialPortInfos) {
        mSerialDevicesName.append(portInfo.portName());
    }
    emit serialDevicesNameChanged();
}
