# - Find MyGUI includes and library
#
# This module defines
# MYGUI_INCLUDE_DIRS
# MYGUI_LIBRARIES, the libraries to link against to use MYGUI.
# MYGUI_LIB_DIR, the location of the libraries
# MYGUI_FOUND, If false, do not try to use MYGUI
#
# Copyright © 2007, Matt Williams
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
CMAKE_POLICY(PUSH)
include(FindPkgMacros)

# IF (MYGUI_LIBRARIES AND MYGUI_INCLUDE_DIRS)
    # SET(MYGUI_FIND_QUIETLY TRUE)
# ENDIF (MYGUI_LIBRARIES AND MYGUI_INCLUDE_DIRS)

IF (WIN32) #Windows
    MESSAGE(STATUS "Looking for MyGUI")
    SET(MYGUISDK $ENV{MYGUI_HOME})
    IF (MYGUISDK)
        findpkg_begin ( "MYGUI" )
        MESSAGE(STATUS "Using MyGUI in MyGUI SDK")
        STRING(REGEX REPLACE "[\\]" "/" MYGUISDK "${MYGUISDK}" )

        find_path ( MYGUI_INCLUDE_DIRS
        MyGUI.h
        "${MYGUISDK}/MyGUIEngine/include"
        NO_DEFAULT_PATH )

        find_path ( MYGUI_PLATFORM_INCLUDE_DIRS
        MyGUI_OgrePlatform.h
        "${MYGUISDK}/Platforms/Ogre/OgrePlatform/include"
        NO_DEFAULT_PATH )

        SET ( MYGUI_LIB_DIR ${MYGUISDK}/lib ${MYGUISDK}/*/lib )

        find_library ( MYGUI_LIBRARIES_REL NAMES
        MyGUIEngine.lib
        MyGUI.OgrePlatform.lib
        HINTS
        ${MYGUI_LIB_DIR}
        PATH_SUFFIXES "" release relwithdebinfo minsizerel )

        find_library ( MYGUI_LIBRARIES_DBG NAMES
        MyGUIEngine_d.lib
        MyGUI.OgrePlatform_d.lib
        HINTS
        ${MYGUI_LIB_DIR}
        PATH_SUFFIXES "" debug )

        find_library ( MYGUI_PLATFORM_LIBRARIES_REL NAMES
        MyGUI.OgrePlatform.lib
        HINTS
        ${MYGUI_LIB_DIR}
        PATH_SUFFIXES "" release relwithdebinfo minsizerel )

        find_library ( MYGUI_PLATFORM_LIBRARIES_DBG NAMES
        MyGUI.OgrePlatform_d.lib
        HINTS
        ${MYGUI_LIB_DIR}
        PATH_SUFFIXES "" debug )

        make_library_set ( MYGUI_LIBRARIES )
        make_library_set ( MYGUI_PLATFORM_LIBRARIES )

        MESSAGE ("${MYGUI_LIBRARIES}")
        MESSAGE ("${MYGUI_PLATFORM_LIBRARIES}")

        #findpkg_finish ( "MYGUI" )
    ENDIF (MYGUISDK)

    IF (OGRESOURCE)
        MESSAGE(STATUS "Using MyGUI in OGRE dependencies")
        STRING(REGEX REPLACE "[\\]" "/" OGRESDK "${OGRESOURCE}" )
        SET(MYGUI_INCLUDE_DIRS ${OGRESOURCE}/OgreMain/include/MYGUI)
        SET(MYGUI_LIB_DIR ${OGRESOURCE}/lib)
        SET(MYGUI_LIBRARIES debug Debug/MyGUIEngine_d optimized Release/MyGUIEngine)
    ENDIF (OGRESOURCE)
ELSE (WIN32) #Unix
    CMAKE_MINIMUM_REQUIRED(VERSION 2.4.7 FATAL_ERROR)
    FIND_PACKAGE(PkgConfig)
    IF(MYGUI_STATIC)
        # don't use pkgconfig on OS X, find freetype & append it's libs to resulting MYGUI_LIBRARIES
        IF (NOT APPLE)
            PKG_SEARCH_MODULE(MYGUI MYGUIStatic MyGUIStatic)
            IF (MYGUI_INCLUDE_DIRS)
                SET(MYGUI_INCLUDE_DIRS ${MYGUI_INCLUDE_DIRS})
                SET(MYGUI_LIB_DIR ${MYGUI_LIBDIR})
                SET(MYGUI_LIBRARIES ${MYGUI_LIBRARIES} CACHE STRING "")
                SET(MYGUI_PLATFORM_LIBRARIES "MyGUI.OgrePlatform")
            ELSE (MYGUI_INCLUDE_DIRS)
                FIND_PATH(MYGUI_INCLUDE_DIRS MyGUI.h PATHS /usr/local/include /usr/include PATH_SUFFIXES MyGUI MYGUI)
                FIND_LIBRARY(MYGUI_LIBRARIES myguistatic PATHS /usr/lib /usr/local/lib)
                SET(MYGUI_PLATFORM_LIBRARIES "MyGUI.OgrePlatform")
                SET(MYGUI_LIB_DIR ${MYGUI_LIBRARIES})
                STRING(REGEX REPLACE "(.*)/.*" "\\1" MYGUI_LIB_DIR "${MYGUI_LIB_DIR}")
                STRING(REGEX REPLACE ".*/" "" MYGUI_LIBRARIES "${MYGUI_LIBRARIES}")
            ENDIF (MYGUI_INCLUDE_DIRS)
        ELSE (NOT APPLE)
            SET(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${MYGUI_DEPENDENCIES_DIR} ${OGRE_DEPENDENCIES_DIR})
            FIND_PACKAGE(freetype)
            FIND_PATH(MYGUI_INCLUDE_DIRS MyGUI.h PATHS /usr/local/include /usr/include PATH_SUFFIXES MyGUI MYGUI)
            FIND_LIBRARY(MYGUI_LIBRARIES MyGUIEngineStatic PATHS /usr/lib /usr/local/lib)
            SET(MYGUI_PLATFORM_LIBRARIES "MyGUI.OgrePlatform")
            SET(MYGUI_LIB_DIR ${MYGUI_LIBRARIES})
            STRING(REGEX REPLACE "(.*)/.*" "\\1" MYGUI_LIB_DIR "${MYGUI_LIB_DIR}")
            STRING(REGEX REPLACE ".*/" "" MYGUI_LIBRARIES "${MYGUI_LIBRARIES}")
        ENDIF (NOT APPLE)
    ELSE(MYGUI_STATIC)
        PKG_SEARCH_MODULE(MYGUI MYGUI MyGUI)
        IF (MYGUI_INCLUDE_DIRS)
            SET(MYGUI_INCLUDE_DIRS ${MYGUI_INCLUDE_DIRS})
            SET(MYGUI_LIB_DIR ${MYGUI_LIBDIR})
            SET(MYGUI_LIBRARIES ${MYGUI_LIBRARIES} CACHE STRING "")
            SET(MYGUI_PLATFORM_LIBRARIES "MyGUI.OgrePlatform")
        ELSE (MYGUI_INCLUDE_DIRS)
            FIND_PATH(MYGUI_INCLUDE_DIRS MyGUI.h PATHS /usr/local/include /usr/include PATH_SUFFIXES MyGUI MYGUI)
            FIND_LIBRARY(MYGUI_LIBRARIES mygui PATHS /usr/lib /usr/local/lib)
            SET(MYGUI_PLATFORM_LIBRARIES "MyGUI.OgrePlatform")
            SET(MYGUI_LIB_DIR ${MYGUI_LIBRARIES})
            STRING(REGEX REPLACE "(.*)/.*" "\\1" MYGUI_LIB_DIR "${MYGUI_LIB_DIR}")
            STRING(REGEX REPLACE ".*/" "" MYGUI_LIBRARIES "${MYGUI_LIBRARIES}")
        ENDIF (MYGUI_INCLUDE_DIRS)
    ENDIF(MYGUI_STATIC)
ENDIF (WIN32)

#Do some preparation
IF (NOT WIN32) # This does not work on Windows for paths with spaces in them
	SEPARATE_ARGUMENTS(MYGUI_INCLUDE_DIRS)
	SEPARATE_ARGUMENTS(MYGUI_LIBRARIES)
	SEPARATE_ARGUMENTS(MYGUI_PLATFORM_LIBRARIES)
ENDIF (NOT WIN32)

SET(MYGUI_LIBRARIES ${MYGUI_LIBRARIES} ${FREETYPE_LIBRARIES})

SET(MYGUI_INCLUDE_DIRS ${MYGUI_INCLUDE_DIRS} CACHE PATH "")
SET(MYGUI_LIBRARIES ${MYGUI_LIBRARIES} CACHE STRING "")
SET(MYGUI_PLATFORM_LIBRARIES ${MYGUI_PLATFORM_LIBRARIES} CACHE STRING "")
SET(MYGUI_LIB_DIR ${MYGUI_LIB_DIR} CACHE PATH "")

IF (NOT APPLE OR NOT MYGUI_STATIC) # we need explicit freetype libs only on OS X for static build, for other cases just make it TRUE
    SET(FREETYPE_LIBRARIES TRUE)
ENDIF (NOT APPLE OR NOT MYGUI_STATIC)

IF (MYGUI_INCLUDE_DIRS AND MYGUI_LIBRARIES AND FREETYPE_LIBRARIES)
    SET(MYGUI_FOUND TRUE)
ENDIF (MYGUI_INCLUDE_DIRS AND MYGUI_LIBRARIES AND FREETYPE_LIBRARIES)

IF (MYGUI_FOUND)
    MARK_AS_ADVANCED(MYGUI_LIB_DIR)
    IF (NOT MYGUI_FIND_QUIETLY)
        MESSAGE(STATUS " libraries : ${MYGUI_LIBRARIES} from ${MYGUI_LIB_DIR}")
        MESSAGE(STATUS " includes : ${MYGUI_INCLUDE_DIRS}")
    ENDIF (NOT MYGUI_FIND_QUIETLY)
ELSE (MYGUI_FOUND)
    IF (MYGUI_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Could not find MYGUI")
    ENDIF (MYGUI_FIND_REQUIRED)
ENDIF (MYGUI_FOUND)

CMAKE_POLICY(POP)

