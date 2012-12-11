#include <QApplication>
#include "qmlapplicationviewer.h"
#include <QDeclarativePropertyMap>
#include <QDeclarativeContext>
#include <QtDeclarative>
#include <QFont>
#include "QDjango.h"
#include "QDjangoQuerySet.h"

#include "data/person.h"
#include "data/personlist.h"
#include "data/qobjectlistmodel.h"
#include "data/qdjangodatabasemanager.h"
#include "data/appointment.h"
#include "data/contract.h"
#include "data/persongroup.h"
#include "data/personappointment.h"

#include "personcontroller.h"
#include "mystatemaschine.h"
#include "qmlselectionmodel.h"
#include "qmlitemselection.h"
#include "calendartimeline.h"
#include "calendarmodel.h"
#include "logic/appointmentmodel.h"

#include "logic/appointmentcontroller.h"
#include "logic/clientcontroller.h"
#include "logic/groupcontroller.h"

#include "util/qmlutil.h"
#include "util/QsDebugOutput.h"
#include "util/QsLog.h"
#include "util/QsLogDest.h"

#include <QDebug>
Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    app->addLibraryPath(app->applicationDirPath() + "/plugins");

    QSettings cfg(QSettings::IniFormat, QSettings::UserScope, "FoolSoft", "rehatab");
    QDir settingsDir = QFileInfo(cfg.fileName()).absoluteDir();

    if (!settingsDir.exists()) {
        if (!settingsDir.mkpath(".")) {
            QMessageBox msgBox;
            msgBox.setText(app->tr("Das Programm wurde nicht initialisiert."));
            msgBox.setInformativeText(app->tr("Kontaktieren sie den Support!"));
            msgBox.setStandardButtons(QMessageBox::Ok);
            msgBox.setDefaultButton(QMessageBox::Ok);
            msgBox.exec();
            return 1;
        }
    } else if (cfg.value("process").toBool()) {
        QMessageBox msgBox;
        msgBox.setText(app->tr("Das Programm ist abgestürtzt."));
        msgBox.setInformativeText(app->tr("Kontaktieren sie den Support!"));
        msgBox.setStandardButtons(QMessageBox::Yes | QMessageBox::No);
        msgBox.setDefaultButton(QMessageBox::Yes);
        msgBox.exec();
    }

    cfg.setValue("process", true);

    qDebug() << "load setting from " + QFileInfo(cfg.fileName()).absolutePath();
    QsLogging::Logger& logger = QsLogging::Logger::instance();
    logger.setLoggingLevel(QsLogging::TraceLevel);

    QsLogging::DestinationPtr debugDestination(
                QsLogging::DestinationFactory::MakeDebugOutputDestination());

    QsLogging::DestinationPtr fileDestination(
                QsLogging::DestinationFactory::MakeFileDestination(settingsDir.absolutePath() + "/logfile.log"));

    logger.addDestination(debugDestination.get());
    logger.addDestination(fileDestination.get());

    QDjangoDatabaseManager *dbm = new QDjangoDatabaseManager(DatabaseManager::SQLITE, "",
                                                             settingsDir.absolutePath()+ "/rehatab.db", "default");

    dbm->open("", "", false);

    qmlRegisterType<Person>("Rehatab", 1, 0, "Person");
    qmlRegisterType<Contract>("Rehatab", 1, 0, "Contract");
    qmlRegisterType<Appointment>("Rehatab", 1, 0, "Appointment");
    qmlRegisterType<PersonGroup>("Rehatab", 1, 0, "PersonGroup");
    qmlRegisterType<QObjectListModel>("Rehatab", 1, 0, "QObjectListModel");

    qmlRegisterType<QObjectListModel>();
    qmlRegisterType<PersonList>("Rehatab", 1, 0, "PersonList");
    qmlRegisterType<QmlSelectionModel>("Rehatab", 1, 0, "SelectionModel");
    qmlRegisterType<QmlItemSelection>("Rehatab", 1, 0, "ItemSelection");
    qmlRegisterType<CalendarTimeLine>("Rehatab", 1, 0, "CalendarTimeLine");
    qmlRegisterType<CalendarModel>("Rehatab", 1, 0, "CalendarModel");
    qmlRegisterType<CalendarTimeLineAttached>();
    qmlRegisterType<AppointmentModel>("Rehatab", 1, 0, "AppointmentModel");
    qmlRegisterType<PersonAppointment>("Rehatab", 1, 0, "PersonAppointment");


    QDeclarativePropertyMap *colorMap = new QDeclarativePropertyMap;
    colorMap->insert("buttonBg", QColor(0x9cd5e8));
    colorMap->insert("buttonBorder", QColor(0x2886a8));
    colorMap->insert("toolbar", QColor(0x983e01));
    colorMap->insert("body", QColor(0xd45500));

    QDeclarativePropertyMap *fontMap = new QDeclarativePropertyMap;
    fontMap->insert("label", QFont("Arial", 13));
    fontMap->insert("textinput", QFont("Arial", 14));

    QmlApplicationViewer viewer;
    PersonController* pc = new PersonController(app.data());
    AppointmentController* appc = new AppointmentController(app.data());

    viewer.addImportPath(qApp->applicationDirPath()+"/import");
    viewer.rootContext()->setContextProperty("myPalette", colorMap);
    viewer.rootContext()->setContextProperty("myFont", fontMap);
    viewer.rootContext()->setContextProperty("personController",
                                             pc);
    viewer.rootContext()->setContextProperty("appointmentController",
                                             appc);

    viewer.rootContext()->setContextProperty("stateMaschine", new MyStateMaschine(app.data()));
    viewer.rootContext()->setContextProperty("clientController", new ClientController(app.data()));
    viewer.rootContext()->setContextProperty("groupController", new GroupController(app.data()));
    viewer.rootContext()->setContextProperty("Util", new QmlUtil(app.data()));

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/rehatab/main.qml"));
    viewer.showExpanded();

    bool res = app->exec();
    cfg.setValue("process", false);

    return res;
}
