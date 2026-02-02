#include "RobotData.h"
#include "src/SerialPort.h"
#include "src/lgdxrobot2.h"
#include "ellipsoid/fit.h"
#include <algorithm>

RobotData* RobotData::instance = nullptr;

RobotData::RobotData(QObject *parent) : QObject{parent}
{
	this->mcuData = new QmlMcuData;
	this->pidData = new QmlPidData;
	this->magCalibrationData = new QmlMagCalibrationData;
}

RobotData::~RobotData()
{
	delete this->mcuData;
	delete this->pidData;
	delete this->magCalibrationData;
}

float RobotData::getMagnetometerDistance(float x1, float y1, float z1, float x2, float y2, float z2)
{
	return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2) + pow(z1 - z2, 2));
}

int RobotData::roundToNearest5(float value)
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
	this->mcuData->accelerometer[0] = mcuData.imu.accelerometer.x;
	this->mcuData->accelerometer[1] = mcuData.imu.accelerometer.y;
	this->mcuData->accelerometer[2] = mcuData.imu.accelerometer.z;
	this->mcuData->accelerometerCovariance[0] = mcuData.imu.accelerometer_covariance.x;
	this->mcuData->accelerometerCovariance[1] = mcuData.imu.accelerometer_covariance.y;
	this->mcuData->accelerometerCovariance[2] = mcuData.imu.accelerometer_covariance.z;
	this->mcuData->gyroscope[0] = mcuData.imu.gyroscope.x;
	this->mcuData->gyroscope[1] = mcuData.imu.gyroscope.y;
	this->mcuData->gyroscope[2] = mcuData.imu.gyroscope.z;
	this->mcuData->gyroscopeCovariance[0] = mcuData.imu.gyroscope_covariance.x;
	this->mcuData->gyroscopeCovariance[1] = mcuData.imu.gyroscope_covariance.y;
	this->mcuData->gyroscopeCovariance[2] = mcuData.imu.gyroscope_covariance.z;
	this->mcuData->magnetometer[0] = mcuData.imu.magnetometer.x;
	this->mcuData->magnetometer[1] = mcuData.imu.magnetometer.y;
	this->mcuData->magnetometer[2] = mcuData.imu.magnetometer.z;
	this->mcuData->magnetometerCovariance[0] = mcuData.imu.magnetometer_covariance.x;
	this->mcuData->magnetometerCovariance[1] = mcuData.imu.magnetometer_covariance.y;
	this->mcuData->magnetometerCovariance[2] = mcuData.imu.magnetometer_covariance.z;
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
		emit magCalChartUpdated(this->mcuData->magnetometer[0], this->mcuData->magnetometer[1], this->mcuData->magnetometer[2]);
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

void RobotData::updateMcuMagCalibrationData(const McuMagCalibrationData &mcuMagData)
{
	for (int i = 0; i < 3; i++)
	{
		this->magCalibrationData->hardIronMax[i] = mcuMagData.hard_iron_max[i];
		this->magCalibrationData->hardIronMin[i] = mcuMagData.hard_iron_min[i];
	}
	for (int i = 0; i < 9; i++)
	{
		this->magCalibrationData->softIronMatrix[i] = mcuMagData.soft_iron_matrix[i];
	}
	emit mcuMagCalibrationDataUpdated();
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
		QVector <float> softIronMatrix = {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
		serialPort->setMagCalibrationData(this->hardIronMax, this->hardIronMin, softIronMatrix);
	}
}

void RobotData::copyMcuMagDataForTesting()
{
	for (int i = 0; i < 3; i++)
	{
		this->hardIronMax[i] = this->magCalibrationData->hardIronMax[i];
		this->hardIronMin[i] = this->magCalibrationData->hardIronMin[i];
	}
	for (int i = 0; i < 9; i++)
	{
		this->softIronMatrix[i] = this->magCalibrationData->softIronMatrix[i];
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
	this->hardIronMax[0] = hardIronXMax.toFloat();
	this->hardIronMax[1] = hardIronYMax.toFloat();
	this->hardIronMax[2] = hardIronZMax.toFloat();
	this->hardIronMin[0] = hardIronXMin.toFloat();
	this->hardIronMin[1] = hardIronYMin.toFloat();
	this->hardIronMin[2] = hardIronZMin.toFloat();
	this->softIronMatrix[0] = softIronMatrix0.toFloat();
	this->softIronMatrix[1] = softIronMatrix1.toFloat();
	this->softIronMatrix[2] = softIronMatrix2.toFloat();
	this->softIronMatrix[3] = softIronMatrix3.toFloat();
	this->softIronMatrix[4] = softIronMatrix4.toFloat();
	this->softIronMatrix[5] = softIronMatrix5.toFloat();
	this->softIronMatrix[6] = softIronMatrix6.toFloat();
	this->softIronMatrix[7] = softIronMatrix7.toFloat();
	this->softIronMatrix[8] = softIronMatrix8.toFloat();
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