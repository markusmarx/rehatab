#ifndef PERSONAPPOINTMENTHISTORY_H
#define PERSONAPPOINTMENTHISTORY_H

#include <QDateTime>

#include "QDjangoModel.h"
#include "personappointmenthistory.h"
#include "personappointment.h"

class PersonAppointmentHistory : public QDjangoModel
{
    Q_OBJECT
    int m_id;

    QDateTime m_date;

    bool m_present;

public:
    explicit PersonAppointmentHistory(QObject *parent = 0);

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QDateTime date READ date WRITE setDate)
    Q_PROPERTY(PersonAppointment* personAppointment READ personAppointment WRITE setPersonAppointment)
    Q_PROPERTY(bool present READ present WRITE setPresent)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=personAppointmentHistoryId")
    Q_CLASSINFO("personAppointment", "db_column=personAppointmentId")

    int id() const
    {
        return m_id;
    }

    QDateTime date() const
    {
        return m_date;
    }

    PersonAppointment* personAppointment() const
    {
        return qobject_cast<PersonAppointment*>(foreignKey("personAppointment"));
    }

    bool present() const
    {
        return m_present;
    }

signals:
    
public slots:

    void setId(int arg)
    {
        m_id = arg;
    }
    void setDate(QDateTime arg)
    {
        m_date = arg;
    }
    void setPersonAppointment(PersonAppointment* arg)
    {
        setForeignKey("personAppointment", arg);
    }
    void setPresent(bool arg)
    {
        m_present = arg;
    }
};

#endif // PERSONAPPOINTMENTHISTORY_H
