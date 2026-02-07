#ifndef SERIALPORT_H
#define SERIALPORT_H

#include <QObject>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QString>
#include <QVector>
#include <QTimer>
#include <QtCore/qcontainerfwd.h>
#include <QtCore/qtypes.h>

#include "RobotData.h"

class SerialPort: public QObject
{
	Q_OBJECT
	Q_PROPERTY(QVector<QString> deviceList MEMBER deviceList NOTIFY deviceListUpdated)
	Q_PROPERTY(bool isConnected MEMBER isConnected NOTIFY connectionStatusChanged)

	private:
		const quint16 kVid = 4617; // Vendor ID 1209H
		const quint16 kPid = 30345;// Product ID 7689H

		static SerialPort *instance;
		static RobotData *robotData;
		QSerialPort serial;

		QTimer processTimer;

		QVector<QString> deviceList;
		bool isConnected = false;
		QByteArray buffer;

		explicit SerialPort(QObject *parent = nullptr);

	private slots:
		void read();

	public:
		static SerialPort *getInstance();
		bool getIsConnected() { return isConnected; }

	public slots:
		void updateDeviceList();
		void connect(QString portName);
		void disconnect();

		void getSerialNumber();
		void getPid();
		void getMagCalibrationData();

		void setInverseKinematics(QString x, QString y, QString rotation);
		void setMotor(int motor, QString velocity);
		void setSoftEmergencyStop(bool enable);
		void setPidSpeed(QString level1, QString level2, QString level3);
		void setPid(int motor,int level, QString p, QString i, QString d);
		void setMotorMaximumSpeed(QString speed1, QString speed2, QString speed3, QString speed4);

		void resetMagCalibrationData();
		void setMagCalibrationData(QVector<float> &hardIronMax, QVector<float> &hardIronMin, QVector<float> &softIronMatrix);
		void setMagCalibrationDataCustom(float hardIronXMax, float hardIronYMax, float hardIronZMax,
			float hardIronXMin, float hardIronYMin, float hardIronZMin,
			float softIronMatrix0, float softIronMatrix1, float softIronMatrix2,
			float softIronMatrix3, float softIronMatrix4, float softIronMatrix5,
			float softIronMatrix6, float softIronMatrix7, float softIronMatrix8);
		
		void saveConfiguration();
		void resetTransform();

	signals:
		void deviceListUpdated();
		void connectionStatusChanged();
};

#endif // SERIALPORT_H