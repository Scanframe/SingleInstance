QT += core network
CONFIG += c++11

HEADERS += $$PWD/SingleInstance \
    $$PWD/SingleInstance.h \
    $$PWD/SingleInstance_p.h
SOURCES += $$PWD/SingleInstance.cpp \
    $$PWD/SingleInstance_p.cpp

INCLUDEPATH += $$PWD

win32 {
    msvc:LIBS += Advapi32.lib
    gcc:LIBS += -ladvapi32
}

DISTFILES += \
    $$PWD/README.md \
    $$PWD/CHANGELOG.md \
    $$PWD/Windows.md
