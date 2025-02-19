set(SF_COMMON_LIB_DIR "${CMAKE_SOURCE_DIR}/lib" CACHE INTERNAL "Location of common binary libraries to be unpacked into.")
set(SF_ARCHITECTURE "x86_64" CACHE INTERNAL "Determines the architecture of the build and is determined by the tool chain selection for the set compiler.")

##!
# Gets all sub directories which match the passed regex.
#
function(Sf_GetSubDirectories VarOut Directory MatchStr)
	file(GLOB _Children RELATIVE "${Directory}" "${Directory}/*")
	set(_List "")
	foreach (_Child ${_Children})
		if (IS_DIRECTORY "${Directory}/${_Child}")
			if ("${_Child}" MATCHES "${MatchStr}")
				list(APPEND _List "${_Child}")
			endif ()
		endif ()
	endforeach ()
	set(${VarOut} ${_List} PARENT_SCOPE)
endfunction()

##!
# Finds the Qt directory located a defined position for Linux and Windows.
# @param _VarOut Out: Found Qt version of the directory.
#
function(Sf_FindQtVersionDirectory _VarOut)
	set(_QtDir "")
	if (CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux" AND CMAKE_SYSTEM_NAME STREQUAL "Linux")
		set(_Locations "${SF_COMMON_LIB_DIR}/qt/lnx-${SF_ARCHITECTURE}")
	elseif (CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux" AND CMAKE_SYSTEM_NAME STREQUAL "Windows")
		set(_Locations "${SF_COMMON_LIB_DIR}/qt/win-${SF_ARCHITECTURE}")
	elseif (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows" AND CMAKE_SYSTEM_NAME STREQUAL "Windows")
		# Iterate through all the specified locations.
		set(_Locations
			"${SF_COMMON_LIB_DIR}/qt/w64-${SF_ARCHITECTURE}"
			"C:/Qt" "D:/Qt" "E:/Qt" "F:/Qt" "G:/Qt" "H:/Qt" "I:/Qt" "J:/Qt" "K:/Qt" "L:/Qt" "M:/Qt" "N:/Qt"
			"O:/Qt" "P:/Qt" "Q:/Qt" "R:/Qt" "S:/Qt" "T:/Qt" "U:/Qt" "V:/Qt" "W:/Qt" "X:/Qt" "Y:/Qt" "Z:/Qt"
		)
	endif ()
	# Iterate through the location and use the first one that matches.
	foreach (_Location ${_Locations})
		if (EXISTS "${_Location}")
			set(_QtDir "${_Location}")
			message(STATUS "Qt root library found in '${_QtDir}'!")
			break()
		endif ()
	endforeach ()
	if (_QtDir STREQUAL "")
		message(STATUS "${CMAKE_CURRENT_FUNCTION}(): Qt library for architecture '${SF_ARCHITECTURE}' not found!")
	endif ()
	Sf_GetSubDirectories(_SubDirs "${_QtDir}" "^[0-9]+\\.[0-9]+\\.[0-9]+$")
	list(LENGTH _SubDirs _Len)
	if (NOT ${_Len})
		message(STATUS "${CMAKE_CURRENT_FUNCTION}(): Qt versioned library not found in '${_QtDir}'!")
		set(${_VarOut} "" PARENT_SCOPE)
		return()
	endif ()
	list(SORT _SubDirs COMPARE NATURAL ORDER DESCENDING)
	list(GET _SubDirs 0 _QtVerDir)
	set(${_VarOut} "${_QtDir}/${_QtVerDir}" PARENT_SCOPE)
endfunction()

##!
# Gets the Qt directory located a defined position for Linux and Windows.
# @param _VarOut Out: Found Qt version of the directory.
#
function(Sf_GetQtVersionDirectory _VarOut)
	# Check if the environment variable has been set for a fixed Qt directory.
	if ("$ENV{QT_VER_DIR}" STREQUAL "")
		# Try finding a Qt directory in some possible locations.
		Sf_FindQtVersionDirectory(_QtVerDir)
		set(${_VarOut} "${_QtVerDir}" PARENT_SCOPE)
	else ()
		if (EXISTS "$ENV{QT_VER_DIR}")
			set(${_VarOut} "$ENV{QT_VER_DIR}" PARENT_SCOPE)
		else ()
			set(${_VarOut} "${_VarOut}-NOTFOUND" PARENT_SCOPE)
			message(SEND_ERROR "Environment QT_VER_DIR set to non existing directory: $ENV{QT_VER_DIR} !")
		endif ()
	endif ()
endfunction()

# Set the Qt Library location variable.
if (NOT DEFINED QT_DIRECTORY)
	Sf_GetQtVersionDirectory(QT_DIRECTORY)
	if (QT_DIRECTORY STREQUAL "")
		# When not found define it as empty.
		set(QT_DIRECTORY "")
	else()
		message(STATUS "Qt Version Directory: ${QT_DIRECTORY}")
		# When changing this CMAKE_PREFIX_PATH remove the 'cmake-build-xxxx' directory
		# since it weirdly keeps the previous selected CMAKE_PREFIX_PATH
		if (WIN32)
			if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
				set(QT_LIBS_SUBDIRECTORY "msvc2019_64")
			else ()
				set(QT_LIBS_SUBDIRECTORY "mingw_64")
			endif ()
			message(STATUS "Qt Libraries: ${QT_LIBS_SUBDIRECTORY}")
			list(PREPEND CMAKE_PREFIX_PATH "${QT_DIRECTORY}/${QT_LIBS_SUBDIRECTORY}")
			set(QT_INCLUDE_DIRECTORY "${QT_DIRECTORY}/${QT_LIBS_SUBDIRECTORY}/include")
		else ()
			list(PREPEND CMAKE_PREFIX_PATH "${QT_DIRECTORY}/gcc_64")
			set(QT_INCLUDE_DIRECTORY "${QT_DIRECTORY}/gcc_64/include")
		endif ()
	endif()
endif ()
