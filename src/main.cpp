#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore/qobject.h>

#include "RobotData.h"
#include "SerialPort.h"

static QObject *RobotDataSingletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(engine)
	Q_UNUSED(scriptEngine)

	return (QObject*) RobotData::getInstance();
}

static QObject *SerialPortSingletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(engine)
	Q_UNUSED(scriptEngine)

	return (QObject*) SerialPort::getInstance();
}

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	qmlRegisterSingletonType<RobotData>("RobotData", 1, 0, "RobotData", RobotDataSingletonProvider);
	qmlRegisterSingletonType<SerialPort>("SerialPort", 1, 0, "SerialPort", SerialPortSingletonProvider);
	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreationFailed,
		&app,
		[]() { QCoreApplication::exit(-1); },
		Qt::QueuedConnection);
	engine.loadFromModule("LGDXRobot2ChassisTuner", "Main");

	return app.exec();
}
