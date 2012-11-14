#include "databasemanager.h"
#include <QSqlDatabase>
#include <QSqlError>
#include <QFile>
#include "QsLog.h"
#include "dbupdater.h"
#include "sqlquerythread.h"


DatabaseManager::DatabaseManager(int dbtype, QString host, QString dbname, QString connName, QObject *parent) :
    QObject(parent), m_dbType(dbtype), m_host(host), m_dbname(dbname), m_connName(connName)
{
    DB_TYPES_MAP << "QSQLITE";
}

bool DatabaseManager::open(QString user, QString passwd, bool async)
{

    QSqlDatabase db = QSqlDatabase::addDatabase(DB_TYPES_MAP.at(m_dbType),
                                                m_connName); // named connection
    db.setDatabaseName(m_dbname);
    db.setHostName(m_host);
    db.setUserName(user);
    db.setPassword(passwd);

    if (db.open()) {
        QLOG_TRACE() << "open Database " << m_dbname;
        m_sqlExec = new SqlQueryThread(m_connName, this);
        if (async)
            m_sqlExec->start();
        return true;
    } else {
        QLOG_TRACE() << "error open Database " << db.lastError().driverText();
        return false;
    }
}

bool DatabaseManager::isOpen() const
{
    return QSqlDatabase::database(m_connName).isOpen();
}

bool DatabaseManager::initDb(QFile* sqlFile)
{

    QString sql;

    if (!sqlFile->open(QIODevice::ReadOnly | QIODevice::Text))
        return false;

    QTextStream in(sqlFile);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (!line.startsWith("--"))
            sql.append(line);
    }
    QStringList sqlList;
    QLOG_DEBUG() << sql;
    sqlList << sql;

    DBUpdater dbUpdater(QSqlDatabase::database(m_connName), sqlList);

    dbUpdater.start();
    if (!dbUpdater.result().success) {

        QLOG_FATAL() << "could not init Database " << dbUpdater.result().sqlError.databaseText();
        return false;
    }

    return true;
}


