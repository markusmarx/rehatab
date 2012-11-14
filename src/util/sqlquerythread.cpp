/**
 *  Copyright (C) 2012  Markus Marx
 *  Contact: markus.marx@outlook.com
 *  This file is part of the Keepgoing application.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "sqlquerythread.h"
#include "util/QsLog.h"
#include <QDebug>
#include <QStringList>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariant>





SqlQueryWorker::SqlQueryWorker(QString databaseName, QObject* parent )
    : QObject( parent )
{
    // thread-specific connection, see db.h
    m_database = QSqlDatabase::database(databaseName);

    if ( !m_database.open() )
    {
        QLOG_FATAL() << "Unable to connect to database, giving up:" <<
        m_database.lastError().databaseText();
        return;
    }

}

SqlQueryWorker::~SqlQueryWorker()
{
}

void SqlQueryWorker::slotExecute( const QString& query, const QMap<QString,
                                                                   QVariant> &
                                  values)
{
    QList<QSqlRecord> recs;
    QSqlQuery sql = execute(query, values);
    if (sql.isValid()) {

    }
    while ( sql.next() )
    {
        recs.push_back( sql.record());
    }
    emit results( recs );
}

QSqlQuery SqlQueryWorker::execute( const QString& query, const QMap<QString,
                                                                    QVariant> &
                                   values)
{
    QSqlQuery sql(m_database);
    sql.prepare(query);
    QMapIterator<QString, QVariant> i(values);
    while (i.hasNext()) {
        i.next();
        if (!i.value().isValid()) {
            QLOG_WARN() << "sqlvalue " << i.key() << " is invalid.";
        }
        sql.bindValue(i.key(), i.value());
    }

    if (!sql.exec())
    {
        QLOG_FATAL() << "Unable to execute query " << sql.executedQuery() <<
        ": " << values << ", giving up:" <<  m_database.lastError().driverText();
        return sql;
    } else {
        QLOG_DEBUG() << "execute: " << sql.executedQuery();
        m_database.commit();
    }
    return sql;
}

////

SqlQueryThread::SqlQueryThread(QString dataBaseName, QObject *parent)
    : QThread(parent)
{
    m_databaseName = dataBaseName;
    m_workerSync = new SqlQueryWorker(m_databaseName);
}

SqlQueryThread::~SqlQueryThread()
{
    delete m_workerAsync;
}

void SqlQueryThread::executeAsynchron( const QString& query, const QMap<QString,
                                                                        QVariant>
                                       &values)
{
    if (isRunning()) {
        emit executefwd(query, values); // forwards to the worker
    } else {
        m_workerSync->slotExecute(query, values);
    }

}

QSqlQuery SqlQueryThread::executeSynchron(const QString &query,
                                          const QMap<QString,
                                                     QVariant> &values) {
    return m_workerSync->execute(query, values);
}


void SqlQueryThread::run()
{
    emit ready(false);
    emit progress( "QueryThread starting, one moment please..." );
    // Create worker object within the context of the new thread
    m_workerAsync = new SqlQueryWorker(m_databaseName);
    connect( this,
             SIGNAL( executefwd( const QString &,
                                 const QMap<QString, QVariant>&) ),
             m_workerAsync,
             SLOT( slotExecute( const QString &, const QMap<QString, QVariant>&) ) );

    // Critical: register new type so that this signal can be
    // dispatched across thread boundaries by Qt using the event
    // system
    qRegisterMetaType< QList<QSqlRecord> >( "QList<QSqlRecord>" );

    // forward final signal
    connect( m_workerAsync, SIGNAL( results( const QList<QSqlRecord>& ) ),
             this, SIGNAL( results( const QList<QSqlRecord>& ) ) );

    emit progress( "Thread is running!" );
    emit ready(true);

    exec();  // our event loop
}

