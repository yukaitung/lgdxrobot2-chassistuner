#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QtGui/qicon.h>

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

	#ifndef Q_OS_MACOS
	QIcon icon(":/resources/icon.svg");
	app.setWindowIcon(icon);
	#endif

	QQmlApplicationEngine engine;
	qmlRegisterSingletonType<RobotData>("RobotData", 1, 0, "RobotData", RobotDataSingletonProvider);
	qmlRegisterSingletonType<SerialPort>("SerialPort", 1, 0, "SerialPort", SerialPortSingletonProvider);
	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreationFailed,
		&app,
		[]() { QCoreApplication::exit(-1); },
		Qt::QueuedConnection);
	engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
	if (engine.rootObjects().isEmpty())
		return -1;

	QObject::connect(&app, &QCoreApplication::aboutToQuit, []() {
		SerialPort *serialPort = SerialPort::getInstance();
		serialPort->disconnect();
	});

	return app.exec();
}
