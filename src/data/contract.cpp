#include "contract.h"
#include "person.h"

Contract::Contract(QObject *parent) :
    QDjangoModel(parent), m_id(-1)
{
    setForeignKey("client", new Person);

}

int Contract::id() const
{
    return m_id;
}

void Contract::setId(int id)
{
    m_id = id;
}

QDate Contract::validFrom() const
{
    return m_validFrom;
}

void Contract::setValidFrom(QDate validFrom)
{
    m_validFrom = validFrom;
}

QDate Contract::validTo() const
{
    return m_validTo;
}

void Contract::setValidTo(QDate validTo)
{
    m_validTo = validTo;
}

int Contract::value() const
{
    return m_value;
}

void Contract::setValue(int value)
{
    m_value = value;
}

int Contract::type() const
{
    return m_type;
}

void Contract::setType(int type)
{
    m_type = type;
}

int Contract::openValue() const
{
    return m_openValue;
}

void Contract::setOpenValue(int openValue)
{
    m_openValue = openValue;
}

QDateTime Contract::deleted() const
{
    return m_deleted;
}

void Contract::setDeleted(QDateTime deleted)
{
    m_deleted = deleted;
}

Person *Contract::client()
{
    return qobject_cast<Person*>(foreignKey("client"));
}

void Contract::setClient(Person *client)
{
    setForeignKey("client", client);
}

