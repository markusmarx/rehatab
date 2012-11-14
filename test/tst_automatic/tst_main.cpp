#include <QString>
#include <QtTest>
#include <QFile>
#include "util/QsLog.h"
#include "util/QsLogDest.h"
#include "tst_person.h"
#include "tst_appointment.h"
#include "data/qdjangodatabasemanager.h"


int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);

    QsLogging::Logger& logger = QsLogging::Logger::instance();
    logger.setLoggingLevel(QsLogging::DebugLevel);

    QsLogging::DestinationPtr debugDestination(
        QsLogging::DestinationFactory::MakeDebugOutputDestination());

    logger.addDestination(debugDestination.get());

    QDjangoDatabaseManager *dbm = new QDjangoDatabaseManager(DatabaseManager::SQLITE, "", ":memory:", "default");
    dbm->open("", "", false);
    dbm->initDb(new QFile(":/conf/rehatab_v1_sqlite.sql"));

    QTest::qExec(new tst_Appointment, argc, argv);
    QTest::qExec(new tst_Person, argc, argv);


}
