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

#ifndef RENDERTHREAD_H
#define RENDERTHREAD_H

#include <QList>
#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QSqlDatabase>
#include <QSqlRecord>
#include <QString>
#include <QMap>

class QSqlQuery;
/**
 * @brief The Worker class executes the sql statements.
 */
class SqlQueryWorker : public QObject
{
Q_OBJECT

public:
SqlQueryWorker(QString databaseName, QObject* parent = 0);
~SqlQueryWorker();
QSqlQuery execute( const QString& query, const QMap<QString, QVariant> &values);
public slots:
void slotExecute( const QString& query, const QMap<QString, QVariant> &values);



signals:
void results( const QList<QSqlRecord>& records );

private:
QSqlDatabase m_database;
};

class SqlQueryThread : public QThread
{
Q_OBJECT

public:
/**
 * @brief QueryThread
 * @param databaseName is the name that stored in the QSqlDatabase.
 * @param parent
 */
SqlQueryThread(QString databaseName, QObject *parent = 0);
~SqlQueryThread();

/**
 * @brief executeAsynchron emit the worker to execute the query in a thread.
 * @param query
 * @param values
 */
virtual void executeAsynchron( const QString& query, const QMap <QString,
                                                                 QVariant> &
                               values);

/**
 * @brief executeSynchron emit the worker to execute the query just in time.
 * @param query
 * @param values
 */
virtual QSqlQuery executeSynchron( const QString& query, const QMap <QString,
                                                                     QVariant>
                                   &values);

signals:
void progress( const QString& msg );
void ready(bool);
void results( const QList<QSqlRecord>& records );

protected:
void run();

signals:
void executefwd( const QString& query, const QMap<QString, QVariant > &values);

private:
SqlQueryWorker* m_workerAsync;
SqlQueryWorker* m_workerSync;
QString m_databaseName;
};

#endif
