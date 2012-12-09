#ifndef PERSONGROUPHISTORY_H
#define PERSONGROUPHISTORY_H

#include "QDjangoModel.h"
#include "persongroup.h"
#include "contract.h"
#include "personappointment.h"

class PersonContractHistory : public QDjangoModel
{
    Q_OBJECT
    int m_id;

    QDateTime m_date;

    bool m_present;

public:
    explicit PersonContractHistory(QObject *parent = 0);

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QDateTime date READ date WRITE setDate)
    Q_PROPERTY(bool present READ present WRITE setPresent)
    Q_PROPERTY(PersonGroup* personGroup READ personGroup WRITE setPersonGroup)
    Q_PROPERTY(Person* client READ client WRITE setClient)
    Q_PROPERTY(Contract* contract READ contract WRITE setContract)
    Q_PROPERTY(PersonAppointment* personAppointment READ personAppointemnt WRITE setPersonAppointment)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=personGroupHistoryId")
    Q_CLASSINFO("personGroup", "db_column=personGroupId null=true")
    Q_CLASSINFO("client", "db_column=clientId")
    Q_CLASSINFO("contract", "db_column=contractId")
    Q_CLASSINFO("personAppointment", "db_column=personAppointmentId null=true")

    int id() const
    {
        return m_id;
    }

    QDateTime date() const
    {
        return m_date;
    }

    bool present() const
    {
        return m_present;
    }

    PersonGroup* personGroup() const
    {
        return qobject_cast<PersonGroup*>(foreignKey("personGroup"));
    }

    Person* client() const
    {
        return qobject_cast<Person*>(foreignKey("client"));
    }

    Contract* contract() const
    {
        return qobject_cast<Contract*>(foreignKey("contract"));
    }

    PersonAppointment* personAppointemnt() const
    {
        return qobject_cast<PersonAppointment*>(foreignKey("personAppointment"));
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

    void setPersonGroup(PersonGroup* arg)
    {
        setForeignKey("personGroup", arg);
    }
    void setPresent(bool arg)
    {
        m_present = arg;
    }
    void setClient(Person* arg)
    {
        setForeignKey("client", arg);
    }
    void setContract(Contract* arg)
    {
        setForeignKey("contract", arg);
    }
    void setPersonAppointment(PersonAppointment* arg)
    {
        setForeignKey("personAppointment", arg);
    }
};

#endif // PERSONGROUPHISTORY_H
