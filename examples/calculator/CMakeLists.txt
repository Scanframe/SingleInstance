cmake_minimum_required(VERSION 3.7.0)

project(calculator LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

# SingleApplication base class
#add_subdirectory(../.. SingleApplication)

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Widgets Gui REQUIRED)

add_executable(${PROJECT_NAME}
	button.h
	calculator.h
	button.cpp
	calculator.cpp
	main.cpp
	)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::Gui SingleInstance::SingleInstance)
