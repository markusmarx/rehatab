#-------------------------------------------------
#
# Project created by QtCreator 2012-10-01T08:20:16
#
#-------------------------------------------------

QT       += sql testlib

QT       -= gui

TARGET = tst_automatictest
CONFIG   += console test
CONFIG   -= app_bundle

TEMPLATE = app


SOURCES += \
    tst_main.cpp \
    tst_person.cpp \
    tst_base.cpp \
    tst_appointment.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"

RESOURCES += \
    ../../rehatab/resources.qrc

HEADERS += \
    tst_person.h \
    tst_base.h \
    tst_appointment.h

include(../../../../qt.extern/qdjango/qdjango.pri)
INCLUDEPATH += $$QDJANGO_INCLUDEPATH


win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../../src/release/ -lrehatab
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../../src/debug/ -lrehatab
else:unix:!macx:!symbian: LIBS += -L$$OUT_PWD/../../src/ -lrehatab

INCLUDEPATH += $$PWD/../../src
DEPENDPATH += $$PWD/../../src

win32:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../../src/release/librehatab.a
else:win32:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../../src/debug/librehatab.a
else:unix:!macx:!symbian: PRE_TARGETDEPS += $$OUT_PWD/../../src/librehatab.a



win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../../../qt.libs/ -lqdjango-db
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../../../qt.libs/ -lqdjango-db
else:unix:!macx: LIBS += -L$$PWD/../../../../qt.libs/ -lqdjango-db
