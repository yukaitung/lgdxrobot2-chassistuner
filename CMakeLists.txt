cmake_minimum_required(VERSION 3.16)

project(LGDXRobot2ChassisTuner VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Graphs SerialPort)

qt_standard_project_setup(REQUIRES 6.8)
set(CMAKE_AUTORCC ON)

qt_add_executable(appLGDXRobot2ChassisTuner
	application.qrc
	src/main.cpp
	src/RobotData.cpp
	src/SerialPort.cpp
	src/QmlRobotData.cpp
)

qt_add_qml_module(appLGDXRobot2ChassisTuner
	URI LGDXRobot2ChassisTuner
	VERSION 1.0
	QML_FILES
		qml/global.js
		qml/Main.qml
		qml/pages/PidTuner/PidConfigurationPane.qml
		qml/pages/PidTuner/PidTestPane.qml
		qml/pages/PidTuner/PidTable.qml
		qml/pages/PidTuner/SavePidPane.qml
		qml/pages/RobotData/HardwareTestingPane.qml
		qml/pages/RobotData/RobotDataPane.qml
		qml/pages/PidTuner.qml
		qml/pages/RobotData.qml
		qml/shared/LabelHeading.qml
		qml/shared/LabelText.qml
		qml/shared/TextField.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appLGDXRobot2ChassisTuner PROPERTIES
# MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appLGDXRobot2ChassisTuner
	MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
	MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
	MACOSX_BUNDLE TRUE
	WIN32_EXECUTABLE TRUE
)

target_link_libraries(appLGDXRobot2ChassisTuner
	PRIVATE Qt6::Quick Qt6::Graphs Qt6::SerialPort
)

include(GNUInstallDirs)
install(TARGETS appLGDXRobot2ChassisTuner
	BUNDLE DESTINATION .
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
