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
        QVector<int> mFirstPConstants = {0, 0, 0, 0};
        QVector<int> mFirstIConstants = {0, 0, 0, 0};
        QVector<int> mFirstDConstants = {0, 0, 0, 0};
        QVector<int> mPwm = {0, 0, 0, 0};
        bool mDeviceReady = false;

        Q_PROPERTY(QVector<QString> serialDevicesName READ serialDevicesName NOTIFY serialDevicesNameChanged)
        Q_PROPERTY(QVector<float> targetWheelsVelocity READ targetWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> measuredWheelsVelocity READ measuredWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> pConstants READ pConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> iConstants READ iConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> dConstants READ dConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> pFirstConstants READ pFirstConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> iFirstConstants READ iFirstConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> dFirstConstants READ dFirstConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> pwm READ pwm NOTIFY robotStatusChanged)
        Q_PROPERTY(bool deviceReady READ deviceReady NOTIFY deviceReadyChanged)

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
        QVector<int> pFirstConstants() {return mFirstPConstants;}
        QVector<int> iFirstConstants() {return mFirstIConstants;}
        QVector<int> dFirstConstants() {return mFirstDConstants;}
        QVector<int> pwm() {return mPwm;}
        bool deviceReady() {return mDeviceReady;}

    public slots:
        void updateSerialDevices();
        void connect(QString portName);
        void read();
        void setWheelsVelocity(float x, float y, float w);
        void setSingleWheelVelocity(int motor, float velocity);
        void setPID(int motor, int kp, int ki, int kd);

    signals:
        void serialDevicesNameChanged();
        void robotStatusChanged();
        void deviceReadyChanged();
};

#endif // SERIALPORT_H
