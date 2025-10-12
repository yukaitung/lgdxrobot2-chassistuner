#include "RobotData.h"
#include <QtCore/qobject.h>

RobotData* RobotData::instance = nullptr;

RobotData::RobotData(QObject *parent) : QObject{parent}
{
	this->mcuData = new QmlMcuData;
}

RobotData::~RobotData()
{
	delete this->mcuData;
}

RobotData *RobotData::getInstance()
{
	if (instance == nullptr)
		instance = new RobotData;

	return instance;
}

void RobotData::updateMcuData(const McuData &mcuData)
{
	this->mcuData->transform[0] = mcuData.transform.x;
	this->mcuData->transform[1] = mcuData.transform.y;
	this->mcuData->transform[2] = mcuData.transform.rotation;
	this->mcuData->motorsTargetVelocity[0] = mcuData.motors_target_velocity[0];
	this->mcuData->motorsTargetVelocity[1] = mcuData.motors_target_velocity[1];
	this->mcuData->motorsTargetVelocity[2] = mcuData.motors_target_velocity[2];
	this->mcuData->motorsTargetVelocity[3] = mcuData.motors_target_velocity[3];
	this->mcuData->motorsDesireVelocity[0] = mcuData.motors_desire_velocity[0];
	this->mcuData->motorsDesireVelocity[1] = mcuData.motors_desire_velocity[1];
	this->mcuData->motorsDesireVelocity[2] = mcuData.motors_desire_velocity[2];
	this->mcuData->motorsDesireVelocity[3] = mcuData.motors_desire_velocity[3];
	this->mcuData->motorsActualVelocity[0] = mcuData.motors_actual_velocity[0];
	this->mcuData->motorsActualVelocity[1] = mcuData.motors_actual_velocity[1];
	this->mcuData->motorsActualVelocity[2] = mcuData.motors_actual_velocity[2];
	this->mcuData->motorsActualVelocity[3] = mcuData.motors_actual_velocity[3];
	this->mcuData->battery1[0] = mcuData.battery1.voltage;
	this->mcuData->battery1[1] = mcuData.battery1.current;
	this->mcuData->battery2[0] = mcuData.battery2.voltage;
	this->mcuData->battery2[1] = mcuData.battery2.current;
	this->mcuData->motorsCcr[0] = mcuData.motors_ccr[0];
	this->mcuData->motorsCcr[1] = mcuData.motors_ccr[1];
	this->mcuData->motorsCcr[2] = mcuData.motors_ccr[2];
	this->mcuData->motorsCcr[3] = mcuData.motors_ccr[3];
	this->mcuData->softwareEmergencyStopEnabled = mcuData.software_emergency_stop_enabled;
	this->mcuData->hardwareEmergencyStopEnabled = mcuData.hardware_emergency_stop_enabled;	
	this->mcuData->betteryLowEmergencyStopEnabled = mcuData.bettery_low_emergency_stop_enabled;
	emit mcuDataUpdated();
}

void RobotData::updateMcuSerialNumber(const McuSerialNumber &mcuSerialNumber)
{
	QString serialNumber = QString("%1%2%3")
		.arg(mcuSerialNumber.serial_number1, 8, 16, QLatin1Char('0'))
		.arg(mcuSerialNumber.serial_number2, 8, 16, QLatin1Char('0'))
		.arg(mcuSerialNumber.serial_number3, 8, 16, QLatin1Char('0'))
		.toUpper();
	this->mcuSerialNumber = serialNumber;
	emit mcuSerialNumberUpdated();
}