#include "SerialPort.h"
#include <QtSerialPort/qserialport.h>

SerialPort::SerialPort(QObject *parent) : QObject{parent}
{
	QObject::connect(&serial, &QSerialPort::readyRead, this, &SerialPort::read);
}

QObject *SerialPort::getInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(engine);
	Q_UNUSED(scriptEngine);

	return new SerialPort;
}

void SerialPort::updateDeviceList()
{
	deviceList.clear();
	for (const QSerialPortInfo &info : QSerialPortInfo::availablePorts())
		deviceList.append(info.portName());
	emit deviceListUpdated();
}

void SerialPort::connect(QString portName)
{
	if (portName.isEmpty())
		return;

	if (serial.isOpen())
		serial.close();
	serial.setPortName(portName); // STM32 VCP requires the port name only
	if (serial.open(QIODevice::ReadWrite))
	{
		isConnected = true;
		emit connectionStatusChanged();
	}
}

void SerialPort::disconnect()
{
	if (serial.isOpen())
		serial.close();
	isConnected = false;
	emit connectionStatusChanged();
}

void SerialPort::read()
{
	buffer.append(serial.readAll());

	// Find the frame start
	int start = buffer.indexOf("\xAA\x55");
	if (start != -1)
	{
		// Find for start of next frame
		int next = buffer.indexOf("\xAA\x55", start + 2);
		if (next != -1)
		{
			// Found a frame
			QByteArray packet = buffer.mid(start, next - start);
			qDebug().noquote() << "Packet:" << packet.toHex(' ').toUpper();
			buffer.remove(0, next );
		}
		else
		{
			// Next frame not found
			buffer.remove(0, start);
		}
	}
}