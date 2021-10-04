QT += widgets

HEADERS = button.h \
    calculator.h
SOURCES = button.cpp \
    calculator.cpp \
    main.cpp

# Single Application implementation
include(../../SingleInstance.pri)
