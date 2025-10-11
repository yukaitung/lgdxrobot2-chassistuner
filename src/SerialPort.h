#ifndef SERIALPORT_H
#define SERIALPORT_H

#include <QObject>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QVector>
#include <QtCore/qstringview.h>

#include "lgdxrobot2.h"

class SerialPort: public QObject
{
	Q_OBJECT
	Q_PROPERTY(QVector<QString> deviceList MEMBER deviceList NOTIFY deviceListUpdated)
	Q_PROPERTY(bool isConnected MEMBER isConnected NOTIFY connectionStatusChanged)

	private:
		QSerialPort serial;

		bool isConnected = false;
		QByteArray buffer;

		QVector<QString> deviceList;

		explicit SerialPort(QObject *parent = nullptr);

	private slots:
		void read();

	public:
		static QObject *getInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

	public slots:
		void updateDeviceList();
		void connect(QString portName);
		void disconnect();

	signals:
		void deviceListUpdated();
		void connectionStatusChanged();
};

#endif // SERIALPORT_H