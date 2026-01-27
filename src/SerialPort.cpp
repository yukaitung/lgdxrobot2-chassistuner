#include "SerialPort.h"
#include "src/lgdxrobot2.h"

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

	int start = buffer.indexOf("\xAA\x55");
	if (start == -1)
	{
		// No frame start found, discard junk
		buffer.clear();
		return;
	}

	int next = buffer.indexOf("\xA5\x5A", start + 2);
	if (next == -1)
	{
		// No frame end found
		return;
	}

	int lastStart = start;
	bool mcuDataFound = false;
	// Handle frames unitl no complete frame is found
	while (start != -1 && next != -1)
	{
		QByteArray frame = buffer.mid(start, (next + 2 - start));
		if (frame.size() > 3)
		{
			switch (frame[2])
			{
				case MCU_DATA_TYPE:
					if (!mcuDataFound)
					{
						McuData mcuData;
						memcpy(&mcuData, frame.data(), sizeof(McuData));
						robotData->updateMcuData(mcuData);
						mcuDataFound = true;
					}
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

		lastStart = start;
		// Find next frame start
		start = buffer.indexOf("\xAA\x55", next + 2);
		next = buffer.indexOf("\xA5\x5A", start + 2);
	}

	// Remove processed data from buffer
	buffer.remove(0, lastStart);
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
	{
		if (info.vendorIdentifier() == kVid && info.productIdentifier() == kPid)
			deviceList.append(info.portName());
	}
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
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
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
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_GET_SERIAL_NUMBER_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuGetSerialNumberCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::getPid()
{
	if (serial.isOpen())
	{
		McuGetPidCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_GET_PID_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuGetPidCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::setInverseKinematics(QString x, QString y, QString rotation)
{
	if (serial.isOpen())
	{
		McuInverseKinematicsCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_INVERSE_KINEMATICS_COMMAND_TYPE;
		command.velocity.x = QString(x).toFloat();
		command.velocity.y = QString(y).toFloat();
		command.velocity.rotation = QString(rotation).toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuInverseKinematicsCommand));
		serial.write(ba);
		serial.waitForBytesWritten();

	}
}

void SerialPort::setMotor(int motor, QString velocity)
{
	if (serial.isOpen())
	{
		McuMotorCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_MOTOR_COMMAND_TYPE;
		command.motor = motor;
		command.velocity = QString(velocity).toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuMotorCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::setSoftEmergencyStop(bool enable)
{
	if (serial.isOpen())
	{
		McuSoftwareEmergencyStopCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_SOFTWARE_EMERGENCY_STOP_COMMAND_TYPE;
		command.enable = enable;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSoftwareEmergencyStopCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::setPidSpeed(QString level1, QString level2, QString level3)
{
	if (serial.isOpen())
	{
		McuSetPidSpeedCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_SET_PID_SPEED_COMMAND_TYPE;
		command.pid_speed[0] = level1.toFloat();
		command.pid_speed[1] = level2.toFloat();
		command.pid_speed[2] = level3.toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSetPidSpeedCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::setPid(int motor, int level, QString p, QString i, QString d)
{
	if (serial.isOpen())
	{
		McuSetPidCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_SET_PID_COMMAND_TYPE;
		command.motor = motor;
		command.level = level;
		command.p = p.toFloat();
		command.i = i.toFloat();
		command.d = d.toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSetPidCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::setMotorMaximumSpeed(QString speed1, QString speed2, QString speed3, QString speed4)
{
	if (serial.isOpen())
	{
		McuSetMotorMaximumSpeedCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_SET_MOTOR_MAXIMUM_SPEED_COMMAND_TYPE;
		command.speed[0] = speed1.toFloat();
		command.speed[1] = speed2.toFloat();
		command.speed[2] = speed3.toFloat();
		command.speed[3] = speed4.toFloat();
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSetMotorMaximumSpeedCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::savePid()
{
	if (serial.isOpen())
	{
		McuSavePidCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_SAVE_PID_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuSavePidCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}

void SerialPort::resetTransform()
{
	if (serial.isOpen())
	{
		McuResetTransformCommand command;
		command.header1 = MCU_HEADER1;
		command.header2 = MCU_HEADER2;
		command.command = MCU_RESET_TRANSFORM_COMMAND_TYPE;
		QByteArray ba(reinterpret_cast<const char*>(&command), sizeof(McuResetTransformCommand));
		serial.write(ba);
		serial.waitForBytesWritten();
	}
}