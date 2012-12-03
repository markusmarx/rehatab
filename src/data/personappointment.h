#ifndef PERSONAPPOINTMENT_H
#define PERSONAPPOINTMENT_H

#include "QDjangoModel.h"
#include "data/person.h"
#include "data/contract.h"
#include "data/appointment.h"

class PersonAppointment : public QDjangoModel
{
    Q_OBJECT

    int m_id;
    Appointment* m_appointment;

public:
    explicit PersonAppointment(QObject *parent = 0);

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(Person* client READ client WRITE setClient)
    Q_PROPERTY(Contract* contract READ contract WRITE setContract)
    Q_PROPERTY(Appointment* appointment READ appointment WRITE setAppointment)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=personAppointmentId")
    Q_CLASSINFO("contract", "db_column=contractId")
    Q_CLASSINFO("client", "db_column=clientId")
    Q_CLASSINFO("appointment", "db_column=appointmentId")

    Person* client() const
    {
        return qobject_cast<Person*>(foreignKey("client"));
    }

    Contract* contract() const
    {
        return qobject_cast<Contract*>(foreignKey("contract"));;
    }

    Appointment* appointment() const
    {
        return m_appointment;
    }

    int id() const
    {
        return m_id;
    }

signals:
    
public slots:

    void setClient(Person* arg)
    {
        setForeignKey("client", arg);
    }
    void setContract(Contract* arg)
    {
        setForeignKey("contract", arg);
    }
    void setAppointment(Appointment* arg)
    {
        m_appointment = arg;
    }
    void setId(int arg)
    {
        m_id = arg;
    }
};

#endif // PERSONAPPOINTMENT_H
