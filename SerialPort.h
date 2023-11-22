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
        QVector<float> mPConstants = {0, 0, 0, 0};
        QVector<float> mIConstants = {0, 0, 0, 0};
        QVector<float> mDConstants = {0, 0, 0, 0};
        QVector<QString> mFirstPConstants = {0, 0, 0, 0}; // JavaScript
        QVector<QString> mFirstIConstants = {0, 0, 0, 0};
        QVector<QString> mFirstDConstants = {0, 0, 0, 0};
        QVector<int> mPwm = {0, 0, 0, 0};
        bool mDeviceReady = false;

        Q_PROPERTY(QVector<QString> serialDevicesName READ serialDevicesName NOTIFY serialDevicesNameChanged)
        Q_PROPERTY(QVector<float> targetWheelsVelocity READ targetWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> measuredWheelsVelocity READ measuredWheelsVelocity NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> pConstants READ pConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> iConstants READ iConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<float> dConstants READ dConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<QString> pFirstConstants READ pFirstConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<QString> iFirstConstants READ iFirstConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<QString> dFirstConstants READ dFirstConstants NOTIFY robotStatusChanged)
        Q_PROPERTY(QVector<int> pwm READ pwm NOTIFY robotStatusChanged)
        Q_PROPERTY(bool deviceReady READ deviceReady NOTIFY deviceReadyChanged)

        QSerialPort mSerial;
        QByteArray mSerialBuffer;
        int mSerialFrameSize = -1;

        explicit SerialPort(QObject *parent = nullptr);
        uint32_t floatToUint32(float n){ return (uint32_t)(*(uint32_t*)&n); }
        float uint32ToFloat(uint32_t n){ return (float)(*(float*)&n); }
        uint32_t combineBytes(uint32_t a, uint32_t b, uint32_t c, uint32_t d) {
            return a << 24 | b << 16 | c << 8 | d;
        }


    public:
        static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);
        QVector<QString> serialDevicesName() {return mSerialDevicesName;}
        QVector<float> targetWheelsVelocity() {return mTargetWheelsVelocity;}
        QVector<float> measuredWheelsVelocity() {return mMeasuredWheelsVelocity;}
        QVector<float> pConstants() {return mPConstants;}
        QVector<float> iConstants() {return mIConstants;}
        QVector<float> dConstants() {return mDConstants;}
        QVector<QString> pFirstConstants() {return mFirstPConstants;}
        QVector<QString> iFirstConstants() {return mFirstIConstants;}
        QVector<QString> dFirstConstants() {return mFirstDConstants;}
        QVector<int> pwm() {return mPwm;}
        bool deviceReady() {return mDeviceReady;}

    public slots:
        void updateSerialDevices();
        void connect(QString portName);
        void read();
        void setWheelsVelocity(float x, float y, float w);
        void setSingleWheelVelocity(int motor, float velocity);
        void setPID(int motor, float kp, float ki, float kd);

    signals:
        void serialDevicesNameChanged();
        void robotStatusChanged();
        void deviceReadyChanged();
};

#endif // SERIALPORT_H
