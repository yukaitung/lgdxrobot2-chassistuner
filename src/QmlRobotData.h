#ifndef QMLROBOTDATA_H
#define QMLROBOTDATA_H

#include <QObject>
#include <QMetaType>
#include <QVector>

class QmlMcuData : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QVector<float> transform MEMBER transform NOTIFY updated)
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
    QVector<float> transform = {0.0f, 0.0f, 0.0f}; // x, y, rotation
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
  Q_PROPERTY(QVector<float> levelVelocity MEMBER levelVelocity NOTIFY updated)
  Q_PROPERTY(QVector<QVector<float>> p MEMBER p NOTIFY updated)
  Q_PROPERTY(QVector<QVector<float>> i MEMBER i NOTIFY updated)
  Q_PROPERTY(QVector<QVector<float>> d MEMBER d NOTIFY updated)

  public:
    explicit QmlPidData(QObject *parent = nullptr);
    QVector<float> levelVelocity = {0.0f, 0.0f, 0.0f}; // level 1, level 2, level 3
    QVector<QVector<float>> p = { {0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f} };
    QVector<QVector<float>> i = { {0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f} };
    QVector<QVector<float>> d = { {0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f}, {0.0f, 0.0f, 0.0f, 0.0f} };

  signals:
    void updated();
};

#endif // ROBOTD_H

