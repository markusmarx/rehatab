#include "contract.h"
#include "person.h"

Contract::Contract(QObject *parent, int id) :
    QDjangoModel(parent), m_id(id)
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

QDateTime Contract::validFrom() const
{
    return m_validFrom;
}

void Contract::setValidFrom(QDateTime validFrom)
{
    m_validFrom = validFrom;
}

QDateTime Contract::validTo() const
{
    return m_validTo;
}

void Contract::setValidTo(QDateTime validTo)
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
    emit openValueChanged();
}

bool Contract::valid() const
{
    return QDate::currentDate().daysTo(validTo().date()) >= 0 && m_openValue > 0;
}

Person *Contract::client()
{
    return qobject_cast<Person*>(foreignKey("client"));
}

void Contract::setClient(Person *client)
{
    setForeignKey("client", client);
}

