/**
 *  Copyright (C) 2012  Markus Marx (markus.taubert@gmail.com)
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
#ifndef DBUPDATER_H
#define DBUPDATER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlError>

/**
 * @brief The DBUpdater class checks the pragma user_version of sqlite db and excecutes
 * the update sqls if the user_version is lesser.
 */
class DBUpdater : public QObject
{
Q_OBJECT

/**
 * @brief The UpdateResult struct contains information about the execution result.
 */
struct UpdateResult {
    /**
     * @brief state true = success, false = error
     */
    bool success;

    /**
     * @brief errorSql from sqlquery.
     */
    QSqlError sqlError;

};
public:

/**
 * @brief DBUpdater
 * @param db database to update
 * @param updateScript ordered list of updatefiles. Every script is one version step.
 * @param parent
 */
explicit DBUpdater(QSqlDatabase db, QList<QString> updateScripts,
                   QObject *parent = 0);

void start();
UpdateResult result();

signals:

public slots:

private:
QSqlDatabase m_db;
QList<QString> m_updateScripts;
UpdateResult m_updateResult;

};

#endif // DBUPDATER_H
