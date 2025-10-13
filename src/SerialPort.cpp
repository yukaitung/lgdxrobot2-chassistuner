#include "SerialPort.h"
#include "src/lgdxrobot2.h"
#include <QtCore/qlogging.h>

RobotData* SerialPort::robotData = nullptr;
SerialPort* SerialPort::instance = nullptr; 

SerialPort::SerialPort(QObject *parent) : QObject{parent}
{
	QObject::connect(&serial, &QSerialPort::readyRead, this, &SerialPort::read);
	robotData = RobotData::getInstance();
}

void SerialPort::read()
{
	buffer.append(serial.readAll());

	// Find the frame start
	int start = buffer.indexOf("\xAA\x55");
	if (start != -1)
	{
		// Find for start of end of frame
		int next = buffer.indexOf("\xA5\x5A", start + 2);
		if (next != -1)
		{
			// Found a frame
			QByteArray frame = buffer.mid(start, (next - start) + 2);
			if (frame.size() > 3)
			{
				switch (frame[2])
				{
					case MCU_DATA_TYPE:
						McuData mcuData;
						memcpy(&mcuData, frame.data(), sizeof(McuData));
						robotData->updateMcuData(mcuData);
						break;
					case MCU_SERIAL_NUMBER_TYPE:
						McuSerialNumber mcuSerialNumber;
						memcpy(&mcuSerialNumber, frame.data(), sizeof(McuSerialNumber));
						robotData->updateMcuSerialNumber(mcuSerialNumber);
						break;
					case MCU_PID_TYPE:
						McuPid mcuPid;
						memcpy(&mcuPid, frame.data(), sizeof(McuPid));
						robotData->updateMcuPid(mcuPid);
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
		getPid();
	}
}

void SerialPort::disconnect()
{
	if (serial.isOpen())
	{
		McuInverseKinematicsCommand command;
		command.command = MCU_INVERSE_KINEMATICS_COMMAND_TYPE;
		command.velocity.x = 0;
		command.velocity.y = 0;
		command.velocity.rotation = 0;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuInverseKinematicsCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
		serial.close();
	}
		
	isConnected = false;
	emit connectionStatusChanged();
}

void SerialPort::getSerialNumber()
{
	if (serial.isOpen())
	{
		McuGetSerialNumberCommand command;
		command.command = MCU_GET_SERIAL_NUMBER_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuGetSerialNumberCommand));
		serial.write(ba);
	}
}

void SerialPort::getPid()
{
	if (serial.isOpen())
	{
		McuGetPidCommand command;
		command.command = MCU_GET_PID_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuGetPidCommand));
		serial.write(ba);
	}
}

void SerialPort::setInverseKinematics(QString x, QString y, QString rotation)
{
	if (serial.isOpen())
	{
		McuInverseKinematicsCommand command;
		command.command = MCU_INVERSE_KINEMATICS_COMMAND_TYPE;
		command.velocity.x = QString(x).toFloat();
		command.velocity.y = QString(y).toFloat();
		command.velocity.rotation = QString(rotation).toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuInverseKinematicsCommand));
		serial.write(ba);
	}
}

void SerialPort::setMotor(int motor, QString velocity)
{
	if (serial.isOpen())
	{
		McuMotorCommand command;
		command.command = MCU_MOTOR_COMMAND_TYPE;
		command.motor = motor;
		command.velocity = QString(velocity).toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuMotorCommand));
		serial.write(ba);
	}
}

void SerialPort::setSoftEmergencyStop(bool enable)
{
	if (serial.isOpen())
	{
		McuSoftwareEmergencyStopCommand command;
		command.command = MCU_SOFTWARE_EMERGENCY_STOP_COMMAND_TYPE;
		command.enable = enable;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSoftwareEmergencyStopCommand));
		serial.write(ba);
	}
}

void SerialPort::setLevelVelocity(int level, QString level1, QString level2, QString level3)
{
	if (serial.isOpen())
	{
		McuSetLevelVelocityCommand command;
		command.command = MCU_SET_LEVEL_VELOCITY_COMMAND_TYPE;
		command.level_velocity[0] = level1.toFloat();
		command.level_velocity[1] = level2.toFloat();
		command.level_velocity[2] = level3.toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSetLevelVelocityCommand));
		serial.write(ba);
	}
}

void SerialPort::setPid(int motor, int level, QString p, QString i, QString d)
{
	if (serial.isOpen())
	{
		McuSetPidCommand command;
		command.command = MCU_SET_PID_COMMAND_TYPE;
		command.motor = motor;
		command.level = level;
		command.p = p.toFloat();
		command.i = i.toFloat();
		command.d = d.toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSetPidCommand));
		serial.write(ba);
	}
}

void SerialPort::resetTransform()
{
	if (serial.isOpen())
	{
		McuResetTransformCommand command;
		command.command = MCU_RESET_TRANSFORM_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuResetTransformCommand));
		serial.write(ba);
	}
}