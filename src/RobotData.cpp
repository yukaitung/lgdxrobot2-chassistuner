#include "RobotData.h"
#include "src/lgdxrobot2.h"
#include <QtCore/qlogging.h>

RobotData* RobotData::instance = nullptr;

RobotData::RobotData(QObject *parent) : QObject{parent}
{
	this->mcuData = new QmlMcuData;
	this->pidData = new QmlPidData;
}

RobotData::~RobotData()
{
	delete this->mcuData;
	delete this->pidData;
}

RobotData *RobotData::getInstance()
{
	if (instance == nullptr)
		instance = new RobotData;

	return instance;
}

void RobotData::updateMcuData(const McuData &mcuData)
{
	this->mcuData->responseTime = mcuData.response_time;
	this->mcuData->transform[0] = mcuData.transform.x;
	this->mcuData->transform[1] = mcuData.transform.y;
	this->mcuData->transform[2] = mcuData.transform.rotation;
	this->mcuData->forwardKinematic[0] = mcuData.forward_kinematic.x;
	this->mcuData->forwardKinematic[1] = mcuData.forward_kinematic.y;
	this->mcuData->forwardKinematic[2] = mcuData.forward_kinematic.rotation;
	for (int i = 0; i < API_MOTOR_COUNT; i++)
	{
		this->mcuData->motorsTargetVelocity[i] = mcuData.motors_target_velocity[i];
		this->mcuData->motorsDesireVelocity[i] = mcuData.motors_desire_velocity[i];
		this->mcuData->motorsActualVelocity[i] = mcuData.motors_actual_velocity[i];
		this->mcuData->motorsCcr[i] = mcuData.motors_ccr[i];
	}
	this->mcuData->battery1[0] = mcuData.battery1.voltage;
	this->mcuData->battery1[1] = mcuData.battery1.current;
	this->mcuData->battery2[0] = mcuData.battery2.voltage;
	this->mcuData->battery2[1] = mcuData.battery2.current;
	this->mcuData->softwareEmergencyStopEnabled = mcuData.software_emergency_stop_enabled;
	this->mcuData->hardwareEmergencyStopEnabled = mcuData.hardware_emergency_stop_enabled;	
	this->mcuData->betteryLowEmergencyStopEnabled = mcuData.bettery_low_emergency_stop_enabled;
	emit mcuDataUpdated();
	
	if (this->pidChartEnabled)
	{
		QTime now = QTime::currentTime();
		float timeDiff = pidChartStartTime.msecsTo(now);
		emit pidChartUpdated(timeDiff, mcuData.motors_actual_velocity[currentMotor], pidChartTargetVelocity);
	}
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

void RobotData::updateMcuPid(const McuPid &mcuPid)
{
	for (int i = 0; i < PID_LEVEL; i++)
	{
		this->pidData->pidSpeed[i] = QString::number(mcuPid.pid_speed[i]);
		for (int j = 0; j < API_MOTOR_COUNT; j++)
		{
			this->pidData->p[i][j] = QString::number(mcuPid.p[i][j]);
			this->pidData->i[i][j] = QString::number(mcuPid.i[i][j]);
			this->pidData->d[i][j] = QString::number(mcuPid.d[i][j]);
		}
	}
	for (int i = 0; i < API_MOTOR_COUNT; i++)
	{
		this->pidData->motorMaximumSpeed[i] = QString::number(mcuPid.motors_maximum_speed[i]);
	}
	emit mcuPidUpdated();
}

void RobotData::startPidChart(int motor, QString targetVelocity)
{
	if (!this->pidChartEnabled)
	{
		this->currentMotor = motor;
		this->pidChartEnabled = true;
		this->pidChartStartTime = QTime::currentTime();
		emit pidChartClear();
		emit pidChartEnabledUpdated();
	}
	this->pidChartTargetVelocity = targetVelocity.toFloat();
	emit pidChartSetTargetVelocity(targetVelocity.toFloat());
}

void RobotData::stopPidChart()
{
	this->pidChartEnabled = false;
	emit pidChartEnabledUpdated();
}