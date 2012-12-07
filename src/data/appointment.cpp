#include "appointment.h"
#include <QDebug>
#include "qobjectlistmodel.h"
#include "persongroup.h"
#include "personappointment.h"

Appointment::Appointment(QObject *parent) :
    QDjangoModel(parent), m_id(-1)
{
    setPersonGroup(new PersonGroup(this));
    setPersonAppointment(new PersonAppointment(this));
}

void Appointment::setValidFrom(QDateTime fromDate)
{
    m_validFrom = fromDate;
}

QDateTime Appointment::validFrom() const
{
    return m_validFrom;
}

void Appointment::setTime(QTime fromTime)
{
    m_date.setTime(fromTime);
}

QTime Appointment::time() const
{
    return m_date.time();
}

void Appointment::setMinutes(int minutes)
{
    m_minutes = minutes;
}

int Appointment::minutes() const
{
    return m_minutes;
}

void Appointment::setIteration(QString iteration)
{
    m_iteration = iteration;
}

QString Appointment::iteration() const
{
    return m_iteration;
}

void Appointment::setValidTo(QDateTime itEnd)
{
    m_validTo = itEnd;
}

QDateTime Appointment::validTo() const
{
    return m_validTo;
}

void Appointment::setPersonGroup(PersonGroup *personGroup)
{
    setForeignKey("personGroup", personGroup);
}

PersonGroup *Appointment::personGroup() const
{
    return qobject_cast<PersonGroup*>(foreignKey("personGroup"));
}

void Appointment::setPersonAppointment(PersonAppointment *personApp)
{
    setForeignKey("personAppointment", personApp);
}

PersonAppointment *Appointment::personAppointment() const
{
    return qobject_cast<PersonAppointment*>(foreignKey("personAppointment"));
}

bool Appointment::isGroupAppointment()
{
    if (personGroup()->id() > 0) return true;
    return false;
}

void Appointment::setName(QString name)
{
    m_name = name;
}

QString Appointment::name() const
{
    return m_name;
}

void Appointment::setDescription(QString description)
{
    m_description = description;
}

QString Appointment::description() const
{
    return m_description;
}

void Appointment::setDate(QDateTime date)
{
    m_date = date;
}

QDateTime Appointment::date() const
{
    return m_date;
}

void Appointment::setId(int id)
{
    m_id = id;
}

int Appointment::id() const
{
    return m_id;
}
