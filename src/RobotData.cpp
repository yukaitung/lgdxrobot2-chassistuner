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

double RobotData::getAccelerometerData(int16_t value, uint8_t precision)
{
  switch (precision) 
	{
    case MCU_IMU_ACCEL_2G:
      return (double)value * (2 / 32768.0) * gToMs2;
    case MCU_IMU_ACCEL_4G:
      return (double)value * (4 / 32768.0) * gToMs2;
    case MCU_IMU_ACCEL_8G:
      return (double)value * (8 / 32768.0) * gToMs2;
    case MCU_IMU_ACCEL_16G:
      return (double)value * (16 / 32768.0) * gToMs2;
    default:
      return 0.0;
	}
}

double RobotData::getGyroscopeData(int16_t value, uint8_t precision)
{
	switch (precision) 
	{
    case MCU_IMU_GYRO_250_DPS:
      return (double)value * (250 / 32768.0) * degToRad;
    case MCU_IMU_GYRO_500_DPS:
      return (double)value * (500 / 32768.0) * degToRad;
    case MCU_IMU_GYRO_1000_DPS:
      return (double)value * (1000 / 32768.0) * degToRad;
    case MCU_IMU_GYRO_2000_DPS:
      return (double)value * (2000 / 32768.0) * degToRad;
    default:
      return 0.0;
	}
}

double RobotData::getMagnetometerData(int16_t value)
{
	return (double)value * 0.15;
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
	this->mcuData->accelerometer[0] = getAccelerometerData(mcuData.imu.accelerometer.x, mcuData.imu.accelerometer_precision) - this->imuAccelerometerBias[0];
	this->mcuData->accelerometer[1] = getAccelerometerData(mcuData.imu.accelerometer.y, mcuData.imu.accelerometer_precision) - this->imuAccelerometerBias[1];
	this->mcuData->accelerometer[2] = getAccelerometerData(mcuData.imu.accelerometer.z, mcuData.imu.accelerometer_precision) - this->imuAccelerometerBias[2];
	this->mcuData->gyroscope[0] = getGyroscopeData(mcuData.imu.gyroscope.x, mcuData.imu.gyroscope_precision) - this->imuGyroscopeBias[0];
	this->mcuData->gyroscope[1] = getGyroscopeData(mcuData.imu.gyroscope.y, mcuData.imu.gyroscope_precision) - this->imuGyroscopeBias[1];
	this->mcuData->gyroscope[2] = getGyroscopeData(mcuData.imu.gyroscope.z, mcuData.imu.gyroscope_precision) - this->imuGyroscopeBias[2];
	this->mcuData->magnetometer[0] = getMagnetometerData(mcuData.imu.magnetometer.x);
	this->mcuData->magnetometer[1] = getMagnetometerData(mcuData.imu.magnetometer.y);
	this->mcuData->magnetometer[2] = getMagnetometerData(mcuData.imu.magnetometer.z);
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

	if (this->imuCalibrating)
	{
		acculumatedAccelerometer[0] += getAccelerometerData(mcuData.imu.accelerometer.x, mcuData.imu.accelerometer_precision);
		acculumatedAccelerometer[1] += getAccelerometerData(mcuData.imu.accelerometer.y, mcuData.imu.accelerometer_precision);
		acculumatedAccelerometer[2] += getAccelerometerData(mcuData.imu.accelerometer.z, mcuData.imu.accelerometer_precision);
		acculumatedGyroscope[0] += getGyroscopeData(mcuData.imu.gyroscope.x, mcuData.imu.gyroscope_precision);
		acculumatedGyroscope[1] += getGyroscopeData(mcuData.imu.gyroscope.y, mcuData.imu.gyroscope_precision);
		acculumatedGyroscope[2] += getGyroscopeData(mcuData.imu.gyroscope.z, mcuData.imu.gyroscope_precision);
		imuCalibrationIterations++;
		if (imuCalibrationIterations >= kMaxImuCalibrationIterations)
		{
			this->imuCalibrating = false;
			imuAccelerometerBias[0] = acculumatedAccelerometer[0] / kMaxImuCalibrationIterations;
			imuAccelerometerBias[1] = acculumatedAccelerometer[1] / kMaxImuCalibrationIterations;
			imuAccelerometerBias[2] = acculumatedAccelerometer[2] / kMaxImuCalibrationIterations;
			imuAccelerometerBias[2] -= gToMs2;
			imuGyroscopeBias[0] = acculumatedGyroscope[0] / kMaxImuCalibrationIterations;
			imuGyroscopeBias[1] = acculumatedGyroscope[1] / kMaxImuCalibrationIterations;
			imuGyroscopeBias[2] = acculumatedGyroscope[2] / kMaxImuCalibrationIterations;
			emit imuCalibratingUpdated();
		}
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

void RobotData::calibrateImu()
{
	this->imuCalibrating = true;
	this->imuCalibrationIterations = 0;
	this->acculumatedAccelerometer[0] = 0.0;
	this->acculumatedAccelerometer[1] = 0.0;
	this->acculumatedAccelerometer[2] = 0.0;
	this->acculumatedGyroscope[0] = 0.0;
	this->acculumatedGyroscope[1] = 0.0;
	this->acculumatedGyroscope[2] = 0.0;
	emit imuCalibratingUpdated();
}

void RobotData::clearImuCalibration()
{
	this->imuCalibrating = false;
	this->imuCalibrationIterations = 0;
	this->acculumatedAccelerometer[0] = 0.0;
	this->acculumatedAccelerometer[1] = 0.0;
	this->acculumatedAccelerometer[2] = 0.0;
	this->acculumatedGyroscope[0] = 0.0;
	this->acculumatedGyroscope[1] = 0.0;
	this->acculumatedGyroscope[2] = 0.0;
	this->imuAccelerometerBias[0] = 0.0;
	this->imuAccelerometerBias[1] = 0.0;
	this->imuAccelerometerBias[2] = 0.0;
	this->imuGyroscopeBias[0] = 0.0;
	this->imuGyroscopeBias[1] = 0.0;
	this->imuGyroscopeBias[2] = 0.0;
	emit imuCalibratingUpdated();
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