#include "qdjangodatabasemanager.h"
#include "QDjango.h"
#include "person.h"
#include "appointment.h"
#include "contract.h"
#include "persongroup.h"
#include "group2person.h"
#include "persongrouphistory.h"
#include "personappointment.h"
#include "personappointmenthistory.h"

QDjangoDatabaseManager::QDjangoDatabaseManager(DatabaseManager::DBType dbtype, QString host, QString dbname, QString connName, QObject *parent) :
    DatabaseManager(dbtype, host, dbname, connName, parent)
{

}

bool QDjangoDatabaseManager::open(QString user, QString passwd, bool async)
{
    bool open = DatabaseManager::open(user, passwd, async);

    if (open) {
//        initDb(new QFile(":/conf/rehatab_v1_sqlite.sql", this));
        QDjango::registerModel<Person>();
        QDjango::registerModel<Contract>();
        QDjango::registerModel<Appointment>();
        QDjango::registerModel<PersonGroup>();
        QDjango::registerModel<Group2Person>();
        QDjango::registerModel<PersonGroupHistory>();
        QDjango::registerModel<PersonAppointment>();
        QDjango::registerModel<PersonAppointmentHistory>();
        QDjango::setDatabase(QSqlDatabase::database(m_connName));
        QDjango::setDebugEnabled(true);
        QDjango::createTables();
    }
    return open;
}
