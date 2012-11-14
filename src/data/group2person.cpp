#include "group2person.h"
#include "person.h"
#include "contract.h"
#include "persongroup.h"

Group2Person::Group2Person(QObject *parent) :
    QDjangoModel(parent), m_id(-1)
{
    setForeignKey("client", new Person(this));
    setForeignKey("contract", new Contract(this));
    setForeignKey("personGroup", new PersonGroup(this));
}

int Group2Person::id() const
{
    return m_id;
}

void Group2Person::setId(int id)
{
    m_id = id;
}

Person *Group2Person::client() const
{
    return qobject_cast<Person*>(foreignKey("client"));
}

void Group2Person::setClient(Person *person)
{
    setForeignKey("client", person);
}

Contract *Group2Person::contract() const
{
    return qobject_cast<Contract*>(foreignKey("contract"));
}

void Group2Person::setContract(Contract *contract)
{
    setForeignKey("contract", contract);
}

PersonGroup *Group2Person::personGroup() const
{
    return qobject_cast<PersonGroup*>(foreignKey("personGroup"));
}

void Group2Person::setPersonGroup(PersonGroup *group)
{
    setForeignKey("personGroup", group);
}

QDateTime Group2Person::validFrom() const
{
    return m_validFrom;
}

void Group2Person::setValidFrom(QDateTime validFrom)
{
    m_validFrom = validFrom;
}

QDateTime Group2Person::validTo() const
{
    return m_validTo;
}

void Group2Person::setValidTo(QDateTime validTo)
{
    m_validTo = validTo;
}

