#include "RobotData.h"
#include "src/SerialPort.h"
#include "src/lgdxrobot2.h"
#include "ellipsoid/fit.h"
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

double RobotData::getMagnetometerCalibrated(double value, int axis)
{
	double hardX = value - (this->hardIronMax[0] + this->hardIronMin[0]) / 2.0;
	double hardY = value - (this->hardIronMax[1] + this->hardIronMin[1]) / 2.0;
	double hardZ = value - (this->hardIronMax[2] + this->hardIronMin[2]) / 2.0;
	if (axis == 0)
	{
		return softIronMatrix[0] * hardX + softIronMatrix[1] * hardY + softIronMatrix[2] * hardZ;
	}
	else if (axis == 1)
	{
		return softIronMatrix[3] * hardX + softIronMatrix[4] * hardY + softIronMatrix[5] * hardZ;
	}
	else if (axis == 2)
	{
		return softIronMatrix[6] * hardX + softIronMatrix[7] * hardY + softIronMatrix[8] * hardZ;
	}
	return 0.0;
}

double RobotData::getMagnetometerDistance(double x1, double y1, double z1, double x2, double y2, double z2)
{
	return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2) + pow(z1 - z2, 2));
}

int RobotData::roundToNearest5(double value)
{
	return round(value / 5.0) * 5.0;
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
	for (int i = 0; i < 3; i++)
	{
		this->mcuData->hardIronMax[i] = mcuData.imu.magnetometer_hard_iron_max[i];
		this->mcuData->hardIronMin[i] = mcuData.imu.magnetometer_hard_iron_min[i];
	}
	for (int i = 0; i < 9; i++)
	{
		this->mcuData->softIronMatrix[i] = mcuData.imu.magnetometer_soft_iron_matrix[i];
	}
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

	if (this->magCalbrating)
	{
		// Update Soft Iron
		double distance = getMagnetometerDistance(this->mcuData->magnetometer[0], this->mcuData->magnetometer[1], this->mcuData->magnetometer[2],
			magLastReading[0], magLastReading[1], magLastReading[2]);
		if (distance >= kMinDistance && distance <= kMaxDistance)
		{
			// Update Chart
			emit magCalChartUpdated(this->mcuData->magnetometer[0], this->mcuData->magnetometer[1], this->mcuData->magnetometer[2]);
			
			// Update Hard Iron
			this->hardIronMax[0] = std::max(this->hardIronMax[0], this->mcuData->magnetometer[0]);
			this->hardIronMax[1] = std::max(this->hardIronMax[1], this->mcuData->magnetometer[1]);
			this->hardIronMax[2] = std::max(this->hardIronMax[2], this->mcuData->magnetometer[2]);
			this->hardIronMin[0] = std::min(this->hardIronMin[0], this->mcuData->magnetometer[0]);
			this->hardIronMin[1] = std::min(this->hardIronMin[1], this->mcuData->magnetometer[1]);
			this->hardIronMin[2] = std::min(this->hardIronMin[2], this->mcuData->magnetometer[2]);

			QString key = QString("%1,%2,%3")
				.arg(roundToNearest5(this->mcuData->magnetometer[0]))
				.arg(roundToNearest5(this->mcuData->magnetometer[1]))
				.arg(roundToNearest5(this->mcuData->magnetometer[2]));
			if (!magHasData.contains(key))
			{
				magHasData.insert(key, true);
				Eigen::Vector3d point;
				point.x() = this->mcuData->magnetometer[0];
				point.y() = this->mcuData->magnetometer[1];
				point.z() = this->mcuData->magnetometer[2];
				this->softIronPoints.row(magDataCount) = point.transpose();
				magDataCount++;
				if (magDataCount >= this->softIronPoints.rows())
				{
					this->softIronPoints.conservativeResize(magDataCount * 2, 3);
				}
				if (magDataCount % kFitPoints == 0)
				{
					// Calculate the shape matrix for every kFitPoints points
					ellipsoid::fit(this->softIronPoints, &softIronCofficients, ellipsoid::EllipsoidType::Arbitrary);
					// Update the shape matrix
					// Output: Ax^2 + By^2 + Cz^2 + 2Dxy + 2Exz + 2Fyz + 2Gx + 2Hy + 2Iz + J = 0
					// Matrix: A F E
					//				 F B D
					//         E D C
					softIronMatrix[0] = softIronCofficients[0];
					softIronMatrix[1] = softIronCofficients[5];
					softIronMatrix[2] = softIronCofficients[4];
					softIronMatrix[3] = softIronCofficients[5];
					softIronMatrix[4] = softIronCofficients[1];
					softIronMatrix[5] = softIronCofficients[3];
					softIronMatrix[6] = softIronCofficients[4];
					softIronMatrix[7] = softIronCofficients[3];
					softIronMatrix[8] = softIronCofficients[2];
					emit magSoftIronMatrixUpdated();
				}
			}
			emit magDataUpdated();
		}
		magLastReading[0] = this->mcuData->magnetometer[0];
		magLastReading[1] = this->mcuData->magnetometer[1];
		magLastReading[2] = this->mcuData->magnetometer[2];
	}

	if (this->magTesting)
	{
		emit magCalChartUpdated(getMagnetometerCalibrated(this->mcuData->magnetometer[0], 0), 
			getMagnetometerCalibrated(this->mcuData->magnetometer[1], 1), 
			getMagnetometerCalibrated(this->mcuData->magnetometer[2], 2));
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
	for (int i = 0; i < 3; i++)
	{
		this->acculumatedAccelerometer[i] = 0.0;
		this->acculumatedGyroscope[i] = 0.0;
	}
	emit imuCalibratingUpdated();
}

void RobotData::clearImuCalibration()
{
	this->imuCalibrating = false;
	this->imuCalibrationIterations = 0;
	for (int i = 0; i < 3; i++)
	{
		this->acculumatedAccelerometer[i] = 0.0;
		this->acculumatedGyroscope[i] = 0.0;
		this->imuAccelerometerBias[i] = 0.0;
		this->imuGyroscopeBias[i] = 0.0;
	}
	emit imuCalibratingUpdated();
}

void RobotData::startMagCal()
{
	this->magCalbrating = true;
	magHasData.clear();
	for (int i = 0; i < 3; i++)
	{
		hardIronMax[i] = -kSensorMax;
		hardIronMin[i] = kSensorMax;
	}
	magDataCount = 0;
	softIronPoints.resize(0, 3);
	softIronPoints.resize(1,3);
	for (int i = 0; i < 9; i++)
	{
		softIronMatrix[i] = 0.0;
	}
	emit magDataUpdated();
	emit magCalChartClear();
	emit magCalibratingUpdated();
}

void RobotData::stopMagCal()
{
	this->magCalbrating = false;
	emit magCalibratingUpdated();
}

void RobotData::startMagTesting()
{
	this->magTesting = true;
	emit magCalChartClear();
	emit magTestingUpdated();
}

void RobotData::stopMagTesting()
{
	this->magTesting = false;
	emit magTestingUpdated();
}

void RobotData::sendMagCalData()
{
	SerialPort *serialPort = SerialPort::getInstance();
	if (serialPort != nullptr && serialPort->getIsConnected())
	{
		serialPort->setMagCalibrationData(this->hardIronMax, this->hardIronMin, this->softIronMatrix);	
	}
}

void RobotData::sendHardIronOnly()
{
	SerialPort *serialPort = SerialPort::getInstance();
	if (serialPort != nullptr && serialPort->getIsConnected())
	{
		QVector <double> softIronMatrix = {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
		serialPort->setMagCalibrationData(this->hardIronMax, this->hardIronMin, softIronMatrix);
	}
}

void RobotData::copyMcuMagDataForTesting()
{
	for (int i = 0; i < 3; i++)
	{
		this->hardIronMax[i] = this->mcuData->hardIronMax[i];
		this->hardIronMin[i] = this->mcuData->hardIronMin[i];
	}
	for (int i = 0; i < 9; i++)
	{
		this->softIronMatrix[i] = this->mcuData->softIronMatrix[i];
	}
	emit magSoftIronMatrixUpdated();
	emit magDataUpdated();
}

void RobotData::copyCustomMagDataForTesting(QString hardIronXMax, QString hardIronYMax, QString hardIronZMax, 
			QString hardIronXMin, QString hardIronYMin, QString hardIronZMin, 
			QString softIronMatrix0, QString softIronMatrix1, QString softIronMatrix2, 
			QString softIronMatrix3, QString softIronMatrix4, QString softIronMatrix5, 
			QString softIronMatrix6, QString softIronMatrix7, QString softIronMatrix8)
{
	this->hardIronMax[0] = hardIronXMax.toDouble();
	this->hardIronMax[1] = hardIronYMax.toDouble();
	this->hardIronMax[2] = hardIronZMax.toDouble();
	this->hardIronMin[0] = hardIronXMin.toDouble();
	this->hardIronMin[1] = hardIronYMin.toDouble();
	this->hardIronMin[2] = hardIronZMin.toDouble();
	this->softIronMatrix[0] = softIronMatrix0.toDouble();
	this->softIronMatrix[1] = softIronMatrix1.toDouble();
	this->softIronMatrix[2] = softIronMatrix2.toDouble();
	this->softIronMatrix[3] = softIronMatrix3.toDouble();
	this->softIronMatrix[4] = softIronMatrix4.toDouble();
	this->softIronMatrix[5] = softIronMatrix5.toDouble();
	this->softIronMatrix[6] = softIronMatrix6.toDouble();
	this->softIronMatrix[7] = softIronMatrix7.toDouble();
	this->softIronMatrix[8] = softIronMatrix8.toDouble();
	emit magSoftIronMatrixUpdated();
	emit magDataUpdated();
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