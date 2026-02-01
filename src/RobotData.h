#ifndef ROBOTDATA_H
#define ROBOTDATA_H

#include <Eigen/Core>
#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <QtCore/qcontainerfwd.h>
#include <QtCore/qtmetamacros.h>
#include <QScatterSeries>

#include "QmlRobotData.h"
#include "lgdxrobot2.h"

class RobotData : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QmlMcuData* mcuData MEMBER mcuData NOTIFY mcuDataUpdated)
	Q_PROPERTY(QString mcuSerialNumber MEMBER mcuSerialNumber NOTIFY mcuSerialNumberUpdated)
	Q_PROPERTY(QmlPidData* pidData MEMBER pidData NOTIFY mcuPidUpdated)
	Q_PROPERTY(bool pidChartEnabled MEMBER pidChartEnabled NOTIFY pidChartEnabledUpdated)
	Q_PROPERTY(bool imuCalibrating MEMBER imuCalibrating NOTIFY imuCalibratingUpdated)
	Q_PROPERTY(bool magCalbrating MEMBER magCalbrating NOTIFY magCalibratingUpdated)
	Q_PROPERTY(bool magTesting MEMBER magTesting NOTIFY magTestingUpdated)
	Q_PROPERTY(QVector<double> hardIronMax MEMBER hardIronMax NOTIFY magDataUpdated)
	Q_PROPERTY(QVector<double> hardIronMin MEMBER hardIronMin NOTIFY magDataUpdated)
	Q_PROPERTY(QVector<double> softIronMatrix MEMBER softIronMatrix NOTIFY magSoftIronMatrixUpdated)

	private:
		static RobotData *instance;
		QmlMcuData *mcuData;
		QmlPidData *pidData;
		QString mcuSerialNumber;

		const int kMaxImuCalibrationIterations = 300;
		int imuCalibrationIterations = 0;
		bool imuCalibrating = false;
		QVector<double> acculumatedAccelerometer = {0.0, 0.0, 0.0}; // x, y, z
		QVector<double> acculumatedGyroscope = {0.0, 0.0, 0.0}; // x, y, z
		QVector<double> imuAccelerometerBias = {0.0, 0.0, 0.0}; // x, y, z
		QVector<double> imuGyroscopeBias = {0.0, 0.0, 0.0}; // x, y, z

		const int kFitPoints = 10;
		const double kSensorMax = 1000.0;
		const double kMinDistance = 3.0;
		const double kMaxDistance = 10.0;
		bool magCalbrating = false;
		bool magTesting = false;
		int magDataCount = 0;
		QHash<QString, bool> magHasData;
		QVector<double> hardIronMax = {0.0, 0.0, 0.0}; // x, y, z,
		QVector<double> hardIronMin = {0.0, 0.0, 0.0}; // x, y, z,
		QVector<double> magLastReading = {0.0, 0.0, 0.0}; // x, y, z,
		Eigen::Matrix<double, Eigen::Dynamic, 3> softIronPoints;
		Eigen::Matrix<double, 10, 1> softIronCofficients;
		QVector<double> softIronMatrix = {0.0, 0.0, 0.0,
			0.0, 0.0, 0.0, 
			0.0, 0.0, 0.0}; // Following the shape matrix

		// Constants
		const double gToMs2 = 9.80665;
		const double degToRad = 0.017453292519943295;
		const double toUt = 0.15;

		// Pid tuning
		bool pidChartEnabled = false;
		int currentMotor = 0;
		QTime pidChartStartTime;
		float pidChartTargetVelocity;

		explicit RobotData(QObject *parent = nullptr);
		~RobotData();

		double getAccelerometerData(int16_t value, uint8_t precision);
		double getGyroscopeData(int16_t value, uint8_t precision);
		double getMagnetometerData(int16_t value);
		double getMagnetometerCalibrated(double value, int axis);
		double getMagnetometerDistance(double x1, double y1, double z1, double x2, double y2, double z2);
		int roundToNearest5(double value);

	public:
		static RobotData *getInstance();

		void updateMcuData(const McuData &mcuData);
		void updateMcuSerialNumber(const McuSerialNumber &mcuSerialNumber);
		void updateMcuPid(const McuPid &mcuPid);

	public slots:
		void calibrateImu();
		void clearImuCalibration();

		void startMagCal();
		void stopMagCal();
		void startMagTesting();
		void stopMagTesting();
		void sendMagCalData();
		void copyMcuMagDataForTesting();
		void copyCustomMagDataForTesting(QString hardIronXMax, QString hardIronYMax, QString hardIronZMax, 
			QString hardIronXMin, QString hardIronYMin, QString hardIronZMin, 
			QString softIronMatrix0, QString softIronMatrix1, QString softIronMatrix2, 
			QString softIronMatrix3, QString softIronMatrix4, QString softIronMatrix5, 
			QString softIronMatrix6, QString softIronMatrix7, QString softIronMatrix8);

		void startPidChart(int motor, QString targetVelocity);
		void stopPidChart();

	signals:
		void mcuDataUpdated();
		void mcuSerialNumberUpdated();
		void mcuPidUpdated();

		void pidChartClear();
		void pidChartSetTargetVelocity(float velocity);
		void pidChartUpdated(float time, float velocity, float targetVelocity);
		void pidChartEnabledUpdated();

		void magCalChartClear();
		void magCalChartUpdated(double x, double y, double z);
		void magDataUpdated();
		void magCalibratingUpdated();
		void magTestingUpdated();
		void magSoftIronMatrixUpdated();

		void imuCalibratingUpdated();
};

#endif // ROBOTDATA_H