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

	private:
		static RobotData *instance;
		QmlMcuData *mcuData;
		QString mcuSerialNumber;

		explicit RobotData(QObject *parent = nullptr);
		~RobotData();

	public:
		static RobotData *getInstance();

		void updateMcuData(const McuData &mcuData);
		void updateMcuSerialNumber(const McuSerialNumber &mcuSerialNumber);

	signals:
		void mcuDataUpdated();
		void mcuSerialNumberUpdated();
};

#endif // ROBOTDATA_H