cmake_minimum_required(VERSION 3.16)

project(ChassisTuner VERSION 3.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Graphs SerialPort)

qt_standard_project_setup(REQUIRES 6.8)
set(CMAKE_AUTORCC ON)

set(SOURCES
	src/main.cpp
	src/RobotData.cpp
	src/SerialPort.cpp
	src/QmlRobotData.cpp
	application.qrc
)

# Setup the application icon
if (APPLE)
	set(MACOSX_BUNDLE_ICON_FILE mac.icns)
	set(MACOS_APP_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resources/mac.icns")
	set_source_files_properties(${MACOS_APP_ICON} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
	qt_add_executable(${PROJECT_NAME} MACOSX_BUNDLE ${SOURCES} ${MACOS_APP_ICON})
#! [appicon_macOS]
else()
	qt_add_executable(${PROJECT_NAME} ${SOURCES})
endif()

qt_add_qml_module(${PROJECT_NAME}
	URI LGDXRobot2ChassisTuner
	VERSION 1.0
	QML_FILES
		qml/global.js
		qml/Main.qml
		qml/pages/PidTuner/MotorsMaxSpeed.qml
		qml/pages/PidTuner/PidConfigurationPane.qml
		qml/pages/PidTuner/PidTestPane.qml
		qml/pages/PidTuner/PidTable.qml
		qml/pages/PidTuner/SavePidPane.qml
		qml/pages/RobotTesting/HardwareTestingPane.qml
		qml/pages/RobotTesting/RobotDataPane.qml
		qml/pages/PidTuner.qml
		qml/pages/RobotTesting.qml
		qml/shared/LabelHeading.qml
		qml/shared/LabelText.qml
		qml/shared/TextField.qml
)

set_target_properties(${PROJECT_NAME} PROPERTIES
	MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
	MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
	MACOSX_BUNDLE TRUE
	WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME}
	PRIVATE Qt6::Quick Qt6::Graphs Qt6::SerialPort
)

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
	BUNDLE DESTINATION .
	LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_generate_deploy_qml_app_script(
	TARGET ${PROJECT_NAME}
	OUTPUT_SCRIPT deploy_script
)
install(SCRIPT ${deploy_script})