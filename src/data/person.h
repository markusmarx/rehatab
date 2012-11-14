#ifndef PERSON_H
#define PERSON_H

#include <QObject>
#include "QDjangoModel.h"
#include <QDate>
class QObjectListModel;
class Person : public QDjangoModel
{
    Q_OBJECT

public:
    explicit Person(QObject *parent = 0);

    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QString forename READ forename WRITE setForename)
    Q_PROPERTY(QDate birth READ birth WRITE setBirth)
    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(int age READ age)
    Q_PROPERTY(QDateTime updated READ updated WRITE setUpdated)
    Q_PROPERTY(QDateTime created READ created WRITE setCreated)
    Q_PROPERTY(QDateTime deleted READ deleted WRITE setDeleted)
    Q_PROPERTY(QObjectListModel* appointments READ appointments)
    Q_PROPERTY(QObjectListModel* contracts READ contracts)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=personId")
    Q_CLASSINFO("name", "max_length=255")
    Q_CLASSINFO("forename", "max_length=255")
    Q_CLASSINFO("birth", "ignore_field=false")
    Q_CLASSINFO("age", "ignore_field=true")
    Q_CLASSINFO("updated", "null=true")
    Q_CLASSINFO("deleted", "null=true")
    Q_CLASSINFO("contracts", "ignore_field=true")
    Q_CLASSINFO("appointments", "ignore_field=true")
public:
    QString name() const;
    void setName(const QString &name);

    QString forename() const;
    void setForename(const QString &forename);

    QDate birth() const;
    void setBirth(QDate birth);

    int id() const;
    void setId(int id);

    int age() const;

    QDateTime updated() const;
    void setUpdated(QDateTime updated);
    QDateTime created() const;
    void setCreated(QDateTime created);
    QDateTime deleted() const;
    void setDeleted(QDateTime deleted);

    void setAppointments(QList<QObject*> appointments);
    void setContracts(QList<QObject*> contracts);

    QObjectListModel* contracts() const;
    QObjectListModel* appointments() const;


private:
    QString m_name;
    QString m_forename;
    QDate m_birth;
    int m_id;
    int m_age;
    QDateTime m_created;
    QDateTime m_updated;
    QDateTime m_deleted;
    QObjectListModel *m_contracts;
    QObjectListModel *m_appointments;
    
};


#endif // PERSON_H
