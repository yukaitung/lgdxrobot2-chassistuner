#ifndef SERIALPORT_H
#define SERIALPORT_H

#include <QObject>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QString>
#include <QVector>
#include <QtCore/qobject.h>

#include "RobotData.h"

class SerialPort: public QObject
{
	Q_OBJECT
	Q_PROPERTY(QVector<QString> deviceList MEMBER deviceList NOTIFY deviceListUpdated)
	Q_PROPERTY(bool isConnected MEMBER isConnected NOTIFY connectionStatusChanged)

	private:
		static SerialPort *instance;
		static RobotData *robotData;
		QSerialPort serial;

		QVector<QString> deviceList;
		bool isConnected = false;
		QByteArray buffer;

		explicit SerialPort(QObject *parent = nullptr);

	private slots:
		void read();

	public:
		static SerialPort *getInstance();

	public slots:
		void updateDeviceList();
		void connect(QString portName);
		void disconnect();

		void getSerialNumber();
		void setInverseKinematics(QString x, QString y, QString rotation);
		void setMotor(int motor, QString velocity);
		void setSoftEmergencyStop(bool enable);

	signals:
		void deviceListUpdated();
		void connectionStatusChanged();
};

#endif // SERIALPORT_H