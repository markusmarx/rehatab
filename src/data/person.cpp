#include "person.h"
#include "qobjectlistmodel.h"

#include "QDjangoQuerySet.h"
#include <QDebug>
Person::Person(QObject *parent) :
    QDjangoModel(parent), m_id(-1),
    m_age(-1)
{
    QStringList cnames;
    cnames << "validFrom" << "validTo" << "openValue";
    m_contracts = new QObjectListModel("id", cnames, QList<QObject*>(), this);

    QStringList anames;
    anames << "appointmentSummary" << "validFrom" << "validTo";
    m_appointments = new QObjectListModel("id", anames, QList<QObject*>(), this);

}

QString Person::name() const
{
    return m_name;
}

void Person::setName(const QString &name)
{
    m_name = name;
}

QString Person::forename() const
{
    return m_forename;
}

void Person::setForename(const QString &forename)
{
    m_forename = forename;
}

QDate Person::birth() const
{
    return m_birth;
}

void Person::setBirth(QDate birth)
{
    m_birth = birth;
    m_age = QDate::currentDate().year() - birth.year();

}

int Person::id() const
{
    return m_id;
}

void Person::setId(int id)
{
    m_id = id;
}

int Person::age() const
{
    return m_age;
}

QDateTime Person::updated() const
{
    return m_updated;
}

void Person::setUpdated(QDateTime updated)
{
    m_updated = updated;
}

QDateTime Person::created() const
{
    return m_created;
}

void Person::setCreated(QDateTime created)
{
    m_created = created;
}

QDateTime Person::deleted() const
{
    return m_deleted;
}

void Person::setDeleted(QDateTime deleted)
{
    m_deleted = deleted;
}

void Person::setAppointments(QList<QObject *> appointments)
{
    m_appointments->setList(appointments);
}

void Person::setContracts(QList<QObject *> contracts)
{
    m_contracts->setList(contracts);
}

QObjectListModel *Person::contracts() const
{
    return m_contracts;
}

QObjectListModel *Person::appointments() const
{
    return m_appointments;
}

void Person::setPresence(bool precence)
{
    m_presence = precence;
}

bool Person::presence() const
{
    return m_presence;
}

Q_DECLARE_METATYPE(Person*)




