#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QFile>
#include <QStringList>
class SqlQueryThread;
class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(int dbtype, QString host, QString dbname, QString connName, QObject *parent = 0);

    bool open(QString user, QString passwd, bool async);
    bool isOpen() const;
    bool initDb(QFile *sqlFile);
    


signals:
    
public:
    enum DBType {
        SQLITE = 0
    };

protected:
    QString m_host;
    QString m_dbname;
    QString m_connName;
    int m_dbType;
    SqlQueryThread* m_sqlExec;

    QStringList DB_TYPES_MAP;



    
};

#endif // DATABASEMANAGER_H
