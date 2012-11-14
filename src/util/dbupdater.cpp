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

#include "dbupdater.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QVariant>
#include <QStringList>
#include <QDebug>

DBUpdater::DBUpdater(QSqlDatabase db, QList<QString> updateScripts,
                     QObject *parent) :
    QObject(parent), m_db(db), m_updateScripts(updateScripts) {
}

void DBUpdater::start() {
    QStringList scriptLine;
    int dbversion;

    QSqlQuery sQuery(m_db);

    m_updateResult.success = true;

    if (!sQuery.exec("pragma user_version")) {
        m_updateResult.success = false;
        m_updateResult.sqlError = sQuery.lastError();

        return;
    }

    sQuery.next();
    dbversion = sQuery.value(0).toInt();

    if (dbversion == m_updateScripts.size()) {
        return;
    }


    for( int i = dbversion; i < m_updateScripts.size(); i++) {
        m_db.transaction();
        QString updateScript = m_updateScripts.at(i);
        scriptLine = updateScript.split(';', QString::SkipEmptyParts);
        foreach(QString script, scriptLine) {
            qDebug() << script.simplified();
            if (!sQuery.exec(script.simplified())) {
                m_updateResult.success = false;
                m_updateResult.sqlError = sQuery.lastError();
                if (!sQuery.lastError().databaseText().contains("already exist"))
                    return;
            }

        }

        if (!sQuery.exec(QString("pragma user_version = %1").arg(QString::
                                                                 number(i+
                                                                        1)))) {
            m_updateResult.success = false;
            m_updateResult.sqlError = sQuery.lastError();
            return;
        }

        m_db.commit();

    }

}

DBUpdater::UpdateResult DBUpdater::result(){
    return m_updateResult;
}
