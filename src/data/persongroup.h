#ifndef GROUP_H
#define GROUP_H

#include <QObject>
#include "QDjangoModel.h"
#include <QDateTime>
#include <QDate>
#include <QTime>
#include "data/appointment.h"
class QObjectListModel;
class Appointment;
class PersonGroup : public QDjangoModel
{
    Q_OBJECT


    QString m_name;

    QDateTime m_validTo;

    QDateTime m_validFrom;

    QString m_iterationModel;

    QDateTime m_date;

    int m_minutes;

    QObjectListModel* m_personList;

    QHash<int, QVariantList> m_personData;

    //QByteArray m_data;

    int m_id;

public:
    explicit PersonGroup(QObject *parent = 0);
    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QDateTime date READ date WRITE setDate)
    Q_PROPERTY(QDateTime time READ time WRITE setTime)
    Q_PROPERTY(int minutes READ minutes WRITE setMinutes)
    Q_PROPERTY(QString iteration READ iteration WRITE setIteration)
    Q_PROPERTY(QDateTime validFrom READ validFrom WRITE setValidFrom)
    Q_PROPERTY(QDateTime validTo READ validTo WRITE setValidTo)
    //Q_PROPERTY(QByteArray data READ data WRITE setData)
    Q_PROPERTY(Appointment* appointment READ appointment WRITE setAppointment)

    Q_PROPERTY(QObjectListModel* personList READ personList)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=groupId")
    Q_CLASSINFO("name", "max_length=255")
    Q_CLASSINFO("appointment", "db_column=appointmentId")
    Q_CLASSINFO("personList","ignore_field=true")
    Q_CLASSINFO("time", "ignore_field=true")

    Q_INVOKABLE bool personData(int personId, QVariant value);
    Q_INVOKABLE void setPersonData(int personId, QString name, QVariant value);


    QString name() const
    {
        return m_name;
    }

    QDateTime validTo() const
    {
        return m_validTo;
    }
    QDateTime validFrom() const
    {
        return m_validFrom;
    }

    QString iteration() const
    {
        return m_iterationModel;
    }

    int minutes() const
    {
        return m_minutes;
    }

    QDateTime date() const
    {
        return m_date;
    }

    Appointment* appointment() const
    {
        return qobject_cast<Appointment*>(foreignKey("appointment"));
    }

    QDateTime time() const
    {
        return m_date;
    }

//    QByteArray data() const
//    {
//        return m_data;
//    }

    int id() const
    {
        return m_id;
    }

    QObjectListModel* personList() const;

    void setPersonDataHash(int personId, QVariantList hash);
    QVariantList personDataHash(int personId);

public slots:

    void setId(int arg)
    {
        m_id = arg;
    }
    void setName(QString arg)
    {
        m_name = arg;
    }
    void setValidTo(QDateTime arg)
    {
        m_validTo = arg;
    }
    void setValidFrom(QDateTime arg)
    {
        m_validFrom = arg;
    }
    void setIteration(QString arg)
    {
        m_iterationModel = arg;
    }
    void setMinutes(int arg)
    {
        m_minutes = arg;
    }

    void setDate(QDateTime arg)
    {
        m_date = arg;
    }

    void setPersonList(QList<QObject*> arg);
    void setAppointment(Appointment* arg)
    {
        setForeignKey("appointment", arg);
    }

    void setTime(QDateTime arg)
    {
        m_date.setTime(arg.time());
    }
//    void setData(QByteArray arg)
//    {
//        m_data = arg;
//    }
};

#endif // GROUP_H
