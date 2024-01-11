#ifndef SERIALPORT_H
#define SERIALPORT_H

#include <QObject>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>

class SerialPort : public QObject
{
    Q_OBJECT

    private:
        QVector<QString> serialDevicesName;
        QVector<float> transform = {0.0, 0.0, 0.0};
        QVector<float> forwardKinematic = {0.0, 0.0, 0.0};
        QVector<float> targetWheelsVelocity = {0.0, 0.0, 0.0, 0.0};
        QVector<float> measuredWheelsVelocity = {0.0, 0.0, 0.0, 0.0};
        QVector<float> pConstants = {0, 0, 0, 0};
        QVector<float> iConstants = {0, 0, 0, 0};
        QVector<float> dConstants = {0, 0, 0, 0};
        QVector<QString> firstPConstants = {0, 0, 0, 0}; // JavaScript
        QVector<QString> firstIConstants = {0, 0, 0, 0};
        QVector<QString> firstDConstants = {0, 0, 0, 0};
        QVector<int> ina219 = {0, 0};
        QVector<int> eStop = {0, 0};
        qint64 lastReceiveTime = 0, receiveTimeWait = 0;
        bool deviceReady = false;

        Q_PROPERTY(QVector<QString> serialDevicesName MEMBER serialDevicesName NOTIFY serialDevicesNameChanged)
        Q_PROPERTY(QVector<float> transform MEMBER transform NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> forwardKinematic MEMBER forwardKinematic NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> targetWheelsVelocity MEMBER targetWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> measuredWheelsVelocity MEMBER measuredWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> pConstants MEMBER pConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> iConstants MEMBER iConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> dConstants MEMBER dConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<QString> pFirstConstants MEMBER firstPConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<QString> iFirstConstants MEMBER firstIConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<QString> dFirstConstants MEMBER firstDConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> ina219 MEMBER ina219 NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> eStop MEMBER eStop NOTIFY robotStatusChanged)
        Q_PROPERTY(qint64 receiveTimeWait MEMBER receiveTimeWait NOTIFY robotStatusChanged)
        Q_PROPERTY(bool deviceReady MEMBER deviceReady NOTIFY deviceReadyChanged)

        QSerialPort mSerial;
        QByteArray mSerialBuffer;
        int mSerialFrameSize = -1;

        explicit SerialPort(QObject *parent = nullptr);
        uint32_t floatToUint32(float n){ return (uint32_t)(*(uint32_t*)&n); }
        float uint32ToFloat(uint32_t n){ return (float)(*(float*)&n); }
        uint32_t combineBytes(uint32_t a, uint32_t b, uint32_t c, uint32_t d) { return a << 24 | b << 16 | c << 8 | d; }
        uint16_t combineBytes(uint16_t a, uint16_t b) { return a << 8 | b; }

    public:
        static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    public slots:
        void updateSerialDevices();
        void connect(QString portName);
        void read();
        void resetRobotTransform();
        void setWheelsVelocity(float x, float y, float w);
        void setSingleWheelVelocity(int motor, float velocity);
        void setPID(int motor, float kp, float ki, float kd);
        void setSoftwareEStop(int enable);

    signals:
        void serialDevicesNameChanged();
        void robotStatusChanged();
        void deviceReadyChanged();
};

#endif // SERIALPORT_H
