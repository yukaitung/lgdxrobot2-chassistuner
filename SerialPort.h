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
        QVector<QString> mSerialDevicesName;
        QVector<float> mTargetWheelsVelocity = {0.0, 0.0, 0.0, 0.0};
        QVector<float> mMeasuredWheelsVelocity = {0.0, 0.0, 0.0, 0.0};
        QVector<int> mPConstants = {0, 0, 0, 0};
        QVector<int> mIConstants = {0, 0, 0, 0};
        QVector<int> mDConstants = {0, 0, 0, 0};

        Q_PROPERTY(QVector<QString> serialDevicesName READ serialDevicesName NOTIFY serialDevicesNameChanged)
        Q_PROPERTY(QVector<float> targetWheelsVelocity READ targetWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> measuredWheelsVelocity READ measuredWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> pConstants READ pConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> iConstants READ iConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> dConstants READ dConstants NOTIFY robotStatusChanged)

        QSerialPort mSerial;
        QByteArray mSerialBuffer;
        int mSerialFrameSize = -1;

        explicit SerialPort(QObject *parent = nullptr);
        uint32_t floatToUint32(float n){ return (uint32_t)(*(uint32_t*)&n); }
        float uint32ToFloat(uint32_t f);

    public:
        static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
        QVector<QString> serialDevicesName() {return mSerialDevicesName;}
        QVector<float> targetWheelsVelocity() {return mTargetWheelsVelocity;}
        QVector<float> measuredWheelsVelocity() {return mMeasuredWheelsVelocity;}
        QVector<int> pConstants() {return mPConstants;}
        QVector<int> iConstants() {return mIConstants;}
        QVector<int> dConstants() {return mDConstants;}

    public slots:
        void updateSerialDevices();
        void connect(QString portName);
        void read();
        void setWheelsVelocity(float x, float y, float w);

    signals:
        void serialDevicesNameChanged();
        void robotStatusChanged();
};

#endif // SERIALPORT_H
