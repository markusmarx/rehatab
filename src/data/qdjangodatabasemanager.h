#ifndef QDJANGODATABASEMANAGER_H
#define QDJANGODATABASEMANAGER_H

#include "util/databasemanager.h"

class QDjangoDatabaseManager : public DatabaseManager
{
    Q_OBJECT
public:
    explicit QDjangoDatabaseManager(DatabaseManager::DBType dbtype, QString host, QString dbname, QString connName, QObject* parent = 0);
    bool open(QString user, QString passwd, bool async);

signals:
    
public slots:
    
};

#endif // QDJANGODATABASEMANAGER_H
