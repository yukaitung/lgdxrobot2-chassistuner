#include "SerialPort.h"
#include <QDateTime>

SerialPort::SerialPort(QObject *parent) : QObject{parent}
{
    QObject::connect(&mSerial, &QSerialPort::readyRead, this, &SerialPort::read);
}

QObject *SerialPort::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);

    return new SerialPort;
}

void SerialPort::connect(QString portName)
{
    deviceReady = false;
    emit deviceReadyChanged();
    if(mSerial.isOpen())
        mSerial.close();
    mSerial.setPortName(portName);
    mSerial.open(QIODevice::ReadWrite);
}

void SerialPort::read()
{
    QByteArray data = mSerial.readAll();
    if(data.size() > 2)
    {
        // Locate frame size
        if(data[0] == (char) 170)
        {
            mSerialFrameSize = data[2];
            dataPackageSize = mSerialFrameSize;
            // The package is too small, wait for next pacakge
            if(data.size() < mSerialFrameSize)
            {
                mSerialBuffer += data;
                return;
            }
            // The package is too big, discard the data
        }
        else if(data[0] == (char) 171)
        {
            QString sn = data.toHex().toUpper();
            serialNumber = sn.right(sn.length() - 2);
        }
    }

    if(mSerialBuffer.size() + data.size() == mSerialFrameSize)
    {
        qint64 currentTime = QDateTime::currentMSecsSinceEpoch();
        refreshTimeQt = currentTime - lastReceiveTime;
        lastReceiveTime = currentTime;
        // Get data
        QByteArray frame = mSerialBuffer + data;
        dataPackageVersion = frame[1];
        int index = 3;
        refreshTimeMcu = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1]);
        index += 2;
        for(int i = 0; i < 3; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            transform[i] = uint32ToFloat(temp);
            index += 4;
        }
        for(int i = 0; i < 3; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            forwardKinematic[i] = uint32ToFloat(temp);
            index += 4;
        }
        for(int i = 0; i < 4; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            targetWheelsVelocity[i] = uint32ToFloat(temp);
            index += 4;
        }
        for(int i = 0; i < 4; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            measuredWheelsVelocity[i] = uint32ToFloat(temp);
            index += 4;
        }
        for(int i = 0; i < 4; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            pConstants[i] = uint32ToFloat(temp);
            if(!deviceReady)
                firstPConstants[i] = QString::number(pConstants[i]);
            index += 4;
        }
        for(int i = 0; i < 4; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            iConstants[i] = uint32ToFloat(temp);
            if(!deviceReady)
                firstIConstants[i] = QString::number(iConstants[i]);
            index += 4;
        }
        for(int i = 0; i < 4; i++)
        {
            uint32_t temp = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1], (uint8_t) frame[index + 2], (uint8_t) frame[index + 3]);
            dConstants[i] = uint32ToFloat(temp);
            if(!deviceReady)
                firstDConstants[i] = QString::number(dConstants[i]);
            index += 4;
        }
        for(int i = 0; i < 2; i++)
        {
            ina219[i] = combineBytes((uint8_t) frame[index], (uint8_t) frame[index + 1]) * 0.004;
            index += 2;
        }
        uint8_t eStopByte = frame[index];
        int compare = 128;
        for(int i = 0; i < 2; i++)
        {
            eStop[i] = (eStopByte & compare) >> (7 - i);
            compare = compare >> 1;
        }
        if(!deviceReady)
        {
            deviceReady = true;
            emit deviceReadyChanged();
        }
        emit robotStatusChanged();
        mSerialBuffer.clear();
    }
}

void SerialPort::resetRobotTransform()
{
    char ba[1];
    ba[0] = 'T';
    if(mSerial.isOpen())
        mSerial.write(ba, 1);
    else
        qDebug() << "Serial is closed.";
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
    if(mSerial.isOpen())
        mSerial.write(ba, 13);
    else
        qDebug() << "Serial is closed.";
}

void SerialPort::setSingleWheelVelocity(int motor, float velocity)
{
    uint32_t v = floatToUint32(velocity);
    char ba[9];
    ba[0] = 'V';
    ba[1] = (motor & 4278190080) >> 24;
    ba[2] = (motor & 16711680) >> 16;
    ba[3] = (motor & 65280) >> 8;
    ba[4] = motor & 255;
    ba[5] = (v & 4278190080) >> 24;
    ba[6] = (v & 16711680) >> 16;
    ba[7] = (v & 65280) >> 8;
    ba[8] = v & 255;
    if(mSerial.isOpen())
        mSerial.write(ba, 9);
    else
        qDebug() << "Serial is closed.";
}

void SerialPort::setPID(int motor, float kp, float ki, float kd)
{
    uint32_t fp = floatToUint32(kp);
    uint32_t fi= floatToUint32(ki);
    uint32_t fd = floatToUint32(kd);
    char ba[17];
    ba[0] = 'P';
    ba[1] = (motor & 4278190080) >> 24;
    ba[2] = (motor & 16711680) >> 16;
    ba[3] = (motor & 65280) >> 8;
    ba[4] = motor & 255;
    ba[5] = (fp & 4278190080) >> 24;
    ba[6] = (fp & 16711680) >> 16;
    ba[7] = (fp & 65280) >> 8;
    ba[8] = fp & 255;
    ba[9] = (fi & 4278190080) >> 24;
    ba[10] = (fi & 16711680) >> 16;
    ba[11] = (fi & 65280) >> 8;
    ba[12] = fi & 255;
    ba[13] = (fd & 4278190080) >> 24;
    ba[14] = (fd & 16711680) >> 16;
    ba[15] = (fd & 65280) >> 8;
    ba[16] = fd & 255;
    if(mSerial.isOpen())
        mSerial.write(ba, 17);
    else
        qDebug() << "Serial is closed.";
}

void SerialPort::setSoftwareEStop(int enable)
{
    char ba[5];
    ba[0] = 'E';
    ba[1] = (enable & 4278190080) >> 24;
    ba[2] = (enable & 16711680) >> 16;
    ba[3] = (enable & 65280) >> 8;
    ba[4] = enable & 255;
    if(mSerial.isOpen())
        mSerial.write(ba, 5);
    else
        qDebug() << "Serial is closed.";
}

void SerialPort::getSerialNumber()
{
    char ba[1];
    ba[0] = 'S';
    if(mSerial.isOpen())
        mSerial.write(ba, 1);
    else
        qDebug() << "Serial is closed.";
}

void SerialPort::updateSerialDevices()
{
    serialDevicesName.clear();
    const auto serialPortInfos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &portInfo : serialPortInfos)
    {
        serialDevicesName.append(portInfo.portName());
    }
    emit serialDevicesNameChanged();
}
