#ifndef __LGDXROBOT2_H
#define __LGDXROBOT2_H

#include <stdint.h>
#include <stdbool.h>

// Operation Configuration
#define PID_LEVEL 3
#define API_MOTOR_COUNT 4

#define MCU_HEADER1 0xAA
#define MCU_HEADER2 0x55

#define MCU_DATA_TYPE 'D'
#define MCU_SERIAL_NUMBER_TYPE 'S'
#define MCU_PID_TYPE 'P'

#define MCU_SOFTWARE_EMERGENCY_STOP_COMMAND_TYPE 'E'
#define MCU_INVERSE_KINEMATICS_COMMAND_TYPE 'I'
#define MCU_MOTOR_COMMAND_TYPE 'M'
#define MCU_SET_LEVEL_VELOCITY_COMMAND_TYPE 'L'
#define MCU_GET_PID_COMMAND_TYPE 'P'
#define MCU_SET_PID_COMMAND_TYPE 'Q'
#define MCU_SAVE_PID_COMMAND_TYPE 'R'
#define MCU_GET_SERIAL_NUMBER_COMMAND_TYPE 'S'
#define MCU_RESET_TRANSFORM_COMMAND_TYPE 'T'

#pragma pack(push, 1)

/*
 * MCU to PC communication
 */

typedef struct {
  float x;
  float y;
  float rotation;
} McuDof;

typedef struct {
  float voltage;
  float current;
} McuPower;

typedef struct {
  uint8_t header1;
  uint8_t header2;
  char type;
  McuDof transform;
  float motors_target_velocity[API_MOTOR_COUNT];
  float motors_actural_velocity[API_MOTOR_COUNT];
  McuPower battery1;
  McuPower battery2;
  bool software_emergency_stop_enabled;
  bool hardware_emergency_stop_enabled;
} McuData;

typedef struct {
  uint8_t header1;
  uint8_t header2;
  char type;
  uint32_t serial_number1;
  uint32_t serial_number2;
  uint32_t serial_number3;
} McuSerialNumber;

typedef struct {
  uint8_t header1;
  uint8_t header2;
  char type;
  float level_velocity[PID_LEVEL];
  float p[API_MOTOR_COUNT][PID_LEVEL];
  float i[API_MOTOR_COUNT][PID_LEVEL];
  float d[API_MOTOR_COUNT][PID_LEVEL];
} McuPid;

/*
 * PC to MCU communication
 */

// Emergency stop
typedef struct {
  char command;
  bool enable;
} McuSoftwareEmergencyStopCommand;

// Motor control
typedef struct {
  char command;
  McuDof velocity;
} McuInverseKinematicsCommand;

typedef struct {
  char command;
  uint8_t motor;
  float velocity;
} McuMotorCommand;

// PID control
typedef struct {
  char command;
  float level_velocity[PID_LEVEL];
} McuSetLevelVelocityCommand;

typedef struct {
  char command;
} McuGetPidCommand;

typedef struct {
  char command;
  uint8_t motor;
  uint8_t level;
  float p;
  float i;
  float d;
} McuSetPidCommand;

typedef struct {
  char command;
} McuSavePidCommand;

// Other
typedef struct {
  char command;
} McuGetSerialNumberCommand;

typedef struct {
  char command;
} McuResetTransformCommand;

#pragma pack(pop)

#endif