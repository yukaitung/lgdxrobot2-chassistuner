#include "SerialPort.h"
#include "src/lgdxrobot2.h"
#include <QtSerialPort/qserialport.h>

RobotData* SerialPort::robotData = nullptr;
SerialPort* SerialPort::instance = nullptr; 

SerialPort::SerialPort(QObject *parent) : QObject{parent}
{
	QObject::connect(&serial, &QSerialPort::readyRead, this, &SerialPort::read);
	robotData = RobotData::getInstance();
}

SerialPort *SerialPort::getInstance()
{
	if (instance == nullptr)
		instance = new SerialPort;

	return instance;
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
			QByteArray frame = buffer.mid(start, next - start);
			if (frame.size() > 3)
			{
				switch (frame[2])
				{
					case MCU_DATA_TYPE:
						McuData mcuData;
						memcpy(&mcuData, frame.data(), sizeof(McuData));
						robotData->updateMcuData(mcuData);
					case MCU_SERIAL_NUMBER_TYPE:
						McuSerialNumber mcuSerialNumber;
						memcpy(&mcuSerialNumber, frame.data(), sizeof(McuSerialNumber));
						robotData->updateMcuSerialNumber(mcuSerialNumber);
						break;
					default:
						break;
				}
			}
			buffer.remove(0, next );
		}
		else
		{
			// Next frame not found
			buffer.remove(0, start);
		}
	}
}