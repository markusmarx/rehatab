QDJANGO_LIBRARY_TYPE=staticlib
include(../../../qt.extern/qdjango/qdjango.pri)
INCLUDEPATH += $$QDJANGO_INCLUDEPATH

TARGET = rehatab
TEMPLATE = lib
CONFIG += staticlib
QMAKE_CXXFLAGS += -Wall
QT += sql

include(data/data.pri)
include(logic/logic.pri)
include(util/util.pri)
