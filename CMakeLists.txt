cmake_minimum_required(VERSION 3.14)

project("SingleInstance" LANGUAGES CXX)

# Only include when this is the main project.
if ("${CMAKE_PROJECT_NAME}" STREQUAL "${CMAKE_PROJECT_NAME}")
	include("${CMAKE_CURRENT_LIST_DIR}/cmake/qt-location.cmake")
else ()
	# My own way to configure compiler and the latest Qt library installed on the current system
	if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/../cmake")
		list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake")
		# My packages to find
		find_package(SfBuildCheck CONFIG REQUIRED)
		find_package(SfMacros CONFIG REQUIRED)
		find_package(SfCompiler CONFIG REQUIRED)
	endif ()
endif ()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core REQUIRED)

set(CMAKE_AUTOMOC ON)

add_library(${PROJECT_NAME} STATIC
	SingleInstance.cpp SingleInstance.h
	SingleInstance_p.cpp SingleInstance_p.h
	SingleGuiApplication.cpp SingleGuiApplication.h
)
add_library(${PROJECT_NAME}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})

# Find dependencies
set(QT_COMPONENTS Core Network)
set(QT_LIBRARIES Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Network)

find_package(Qt${QT_VERSION_MAJOR} COMPONENTS ${QT_COMPONENTS} REQUIRED)

target_link_libraries(${PROJECT_NAME} PUBLIC ${QT_LIBRARIES})

if (WIN32)
	target_link_libraries(${PROJECT_NAME} PRIVATE advapi32)
endif ()

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# Only include examples when this file is the main project file.
if (PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
	add_subdirectory(examples)
endif ()