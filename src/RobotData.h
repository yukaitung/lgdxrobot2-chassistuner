#ifndef ROBOTDATA_H
#define ROBOTDATA_H

#include <QObject>
#include <QQmlEngine>
#include <QString>

#include "QmlRobotData.h"
#include "lgdxrobot2.h"

class RobotData : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QmlMcuData* mcuData MEMBER mcuData NOTIFY mcuDataUpdated)
	Q_PROPERTY(QString mcuSerialNumber MEMBER mcuSerialNumber NOTIFY mcuSerialNumberUpdated)
	Q_PROPERTY(QmlPidData* pidData MEMBER pidData NOTIFY mcuPidUpdated)
	Q_PROPERTY(bool pidChartEnabled MEMBER pidChartEnabled NOTIFY pidChartEnabledUpdated)

	private:
		static RobotData *instance;
		QmlMcuData *mcuData;
		QmlPidData *pidData;
		QString mcuSerialNumber;

		// Constants
		double gToMs2 = 9.80665;
		double degToRad = 0.017453292519943295;
		double toUt = 0.15;

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

	public:
		static RobotData *getInstance();

		void updateMcuData(const McuData &mcuData);
		void updateMcuSerialNumber(const McuSerialNumber &mcuSerialNumber);
		void updateMcuPid(const McuPid &mcuPid);

	public slots:
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
};

#endif // ROBOTDATA_H