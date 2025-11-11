#ifndef QMLROBOTDATA_H
#define QMLROBOTDATA_H

#include <QObject>
#include <QMetaType>
#include <QVector>
#include <QtCore/qcontainerfwd.h>

class QmlMcuData : public QObject
{
  Q_OBJECT
  Q_PROPERTY(int responseTime MEMBER responseTime NOTIFY updated)
  Q_PROPERTY(QVector<float> transform MEMBER transform NOTIFY updated)
  Q_PROPERTY(QVector<float> forwardKinematic MEMBER forwardKinematic NOTIFY updated)
  Q_PROPERTY(QVector<float> motorsTargetVelocity MEMBER motorsTargetVelocity NOTIFY updated)
  Q_PROPERTY(QVector<float> motorsDesireVelocity MEMBER motorsDesireVelocity NOTIFY updated)
  Q_PROPERTY(QVector<float> motorsActualVelocity MEMBER motorsActualVelocity NOTIFY updated)
  Q_PROPERTY(QVector<int> motorsCcr MEMBER motorsCcr NOTIFY updated)
  Q_PROPERTY(QVector<float> battery1 MEMBER battery1 NOTIFY updated)
  Q_PROPERTY(QVector<float> battery2 MEMBER battery2 NOTIFY updated)
  Q_PROPERTY(bool softwareEmergencyStopEnabled MEMBER softwareEmergencyStopEnabled NOTIFY updated)
  Q_PROPERTY(bool hardwareEmergencyStopEnabled MEMBER hardwareEmergencyStopEnabled NOTIFY updated)
  Q_PROPERTY(bool betteryLowEmergencyStopEnabled MEMBER betteryLowEmergencyStopEnabled NOTIFY updated)

  public:
    explicit QmlMcuData(QObject *parent = nullptr);
    int responseTime = 0;
    QVector<float> transform = {0.0f, 0.0f, 0.0f}; // x, y, rotation
    QVector<float> forwardKinematic = {0.0f, 0.0f, 0.0f}; // x, y, rotation
    QVector<float> motorsTargetVelocity = {0.0f, 0.0f, 0.0f, 0.0f}; // motor 1, motor 2, motor 3, motor 4
    QVector<float> motorsDesireVelocity = {0.0f, 0.0f, 0.0f, 0.0f}; // motor 1, motor 2, motor 3, motor 4
    QVector<float> motorsActualVelocity = {0.0f, 0.0f, 0.0f, 0.0f}; // motor 1, motor 2, motor 3, motor 4
    QVector<int> motorsCcr = {0, 0, 0, 0}; // motor 1, motor 2, motor 3, motor 4
    QVector<float> battery1 = {0.0f, 0.0f}; // voltage, current
    QVector<float> battery2 = {0.0f, 0.0f}; // voltage, current
    bool softwareEmergencyStopEnabled = false;
    bool hardwareEmergencyStopEnabled = false;
    bool betteryLowEmergencyStopEnabled = false;

  signals:
    void updated();
};

class QmlPidData : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QVector<QString> pidSpeed MEMBER pidSpeed NOTIFY updated)
  Q_PROPERTY(QVector<QVector<QString>> p MEMBER p NOTIFY updated)
  Q_PROPERTY(QVector<QVector<QString>> i MEMBER i NOTIFY updated)
  Q_PROPERTY(QVector<QVector<QString>> d MEMBER d NOTIFY updated)
  Q_PROPERTY(QVector<QString> motorMaximumSpeed MEMBER motorMaximumSpeed NOTIFY updated)

  public:
    explicit QmlPidData(QObject *parent = nullptr);
    QVector<QString> pidSpeed = {"-", "-", "-"}; // level 1, level 2, level 3
    QVector<QVector<QString>> p = { {"-", "-", "-", "-"}, {"-", "-", "-", "-"}, {"-", "-", "-", "-"} };
    QVector<QVector<QString>> i = { {"-", "-", "-", "-"}, {"-", "-", "-", "-"}, {"-", "-", "-", "-"} };
    QVector<QVector<QString>> d = { {"-", "-", "-", "-"}, {"-", "-", "-", "-"}, {"-", "-", "-", "-"} };
    QVector<QString> motorMaximumSpeed = {"-", "-", "-", "-"};
  signals:
    void updated();
};

#endif // ROBOTD_H

