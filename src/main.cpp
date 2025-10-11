#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "SerialPort.h"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	qmlRegisterSingletonType<SerialPort>("SerialPort", 1, 0, "SerialPort", &SerialPort::getInstance);
	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreationFailed,
		&app,
		[]() { QCoreApplication::exit(-1); },
		Qt::QueuedConnection);
	engine.loadFromModule("LGDXRobot2ChassisTuner", "Main");

	return app.exec();
}
