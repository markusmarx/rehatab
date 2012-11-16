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
    Q_PROPERTY(int age READ age CONSTANT)
    Q_PROPERTY(int sex READ sex WRITE setSex)
    Q_PROPERTY(QDateTime validFrom READ validFrom WRITE setValidFrom)
    Q_PROPERTY(QDateTime validTo READ validTo WRITE setValidTo)
    Q_PROPERTY(QObjectListModel* appointments READ appointments)
    Q_PROPERTY(QObjectListModel* contracts READ contracts)
    Q_PROPERTY(bool presence READ presence WRITE setPresence)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=personId")
    Q_CLASSINFO("name", "max_length=255")
    Q_CLASSINFO("forename", "max_length=255")
    Q_CLASSINFO("birth", "ignore_field=false")
    Q_CLASSINFO("age", "ignore_field=true")
    Q_CLASSINFO("validFrom", "null=false")
    Q_CLASSINFO("validTo", "null=true")
    Q_CLASSINFO("contracts", "ignore_field=true")
    Q_CLASSINFO("appointments", "ignore_field=true")
    Q_CLASSINFO("presence", "ignore_field=true")
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

    int sex() const;
    void setSex(int sex);

    QDateTime updated() const;
    void setUpdated(QDateTime updated);
    QDateTime validFrom() const;
    void setValidFrom(QDateTime validFrom);
    QDateTime validTo() const;
    void setValidTo(QDateTime validTo);

    void setAppointments(QList<QObject*> appointments);
    void setContracts(QList<QObject*> contracts);

    QObjectListModel* contracts() const;
    QObjectListModel* appointments() const;

    void setPresence(bool precence);
    bool presence() const;


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
    bool m_presence;
    int m_sex;
    
};


#endif // PERSON_H
