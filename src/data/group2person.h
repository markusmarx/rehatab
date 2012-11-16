#ifndef GROUP2PERSON_H
#define GROUP2PERSON_H

#include <QObject>
#include <QDateTime>
#include "QDjangoModel.h"

class Person;
class PersonGroup;
class Contract;

class Group2Person : public QDjangoModel
{
    Q_OBJECT

    QDateTime m_validFrom;
    QDateTime m_validTo;
    int m_id;

public:
    explicit Group2Person(QObject *parent = 0);

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QDateTime validFrom READ validFrom WRITE setValidFrom)
    Q_PROPERTY(QDateTime validTo READ validTo WRITE setValidTo)
    Q_PROPERTY(Person* client READ client WRITE setClient)
    Q_PROPERTY(Contract* contract READ contract WRITE setContract)
    Q_PROPERTY(PersonGroup* personGroup READ personGroup WRITE setPersonGroup)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=group2PersonId")
    Q_CLASSINFO("client", "db_column=clientId")
    Q_CLASSINFO("contract", "db_column=contractId")
    Q_CLASSINFO("personGroup", "db_column=groupId")
    Q_CLASSINFO("validTo", "null=true")

    int id() const;
    void setId(int id);

    Person* client() const;
    void setClient(Person* client);

    Contract* contract() const;
    void setContract(Contract* contract);

    PersonGroup* personGroup() const;
    void setPersonGroup(PersonGroup* personGroup);

    QDateTime validFrom() const;
    void setValidFrom(QDateTime validFrom);

    QDateTime validTo() const;
    void setValidTo(QDateTime validTo);

signals:
    
public slots:
    
};

#endif // GROUP2PERSON_H
