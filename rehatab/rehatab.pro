include(../../../qt.extern/qdjango/qdjango.pri)
INCLUDEPATH += $$QDJANGO_INCLUDEPATH
DEPENDPATH += $$QDJANGO_INCLUDEPATH

# Add more folders to ship with the application, here
folder_01.source = qml/rehatab
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:TARGET.UID3 = 0xE8D5D272

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
# CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
QT += sql script
SOURCES += main.cpp \
    personcontroller.cpp \
    mystatemaschine.cpp \
    mystate.cpp \
    qmlselectionmodel.cpp \
    qmlitemselection.cpp \
    calendartimeline.cpp \
    calendarmodel.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

HEADERS += \
    personcontroller.h \
    mystatemaschine.h \
    mystate.h \
    qmlselectionmodel.h \
    qmlitemselection.h \
    calendartimeline.h \
    calendarmodel.h


win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../../../qt.libs/ -lqdjango-db
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../../qt.libs/ -lqdjango-db
else:unix:!macx:!symbian: LIBS += -L$$PWD/../../../qt.libs/ -lqdjango-db

#
# rehatab
#

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../src/release/ -lrehatab
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../src/debug/ -lrehatab
else:unix:!macx: LIBS += -L$$OUT_PWD/../src/ -lrehatab

INCLUDEPATH += $$PWD/../src
DEPENDPATH += $$PWD/../src

win32:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../src/release/librehatab.a
else:win32:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../src/debug/librehatab.a
else:unix:!macx: PRE_TARGETDEPS += $$OUT_PWD/../src/librehatab.a

RESOURCES += \
    resources.qrc

OTHER_FILES +=

