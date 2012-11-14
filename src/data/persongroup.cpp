#include "persongroup.h"
#include "qobjectlistmodel.h"
#include "appointment.h"
#include <QDebug>
PersonGroup::PersonGroup(QObject *parent) :
    QDjangoModel(parent), m_id(-1)
{

    QStringList pnames;
    pnames << "name" << "forename";
    m_personList = new QObjectListModel("id", pnames, QList<QObject*>(), this);
    setForeignKey("appointment", new Appointment(this));
}

QVariant PersonGroup::personData(int personId, QString name)
{
    qDebug() << Q_FUNC_INFO << personId << name;
    return true;
}

void PersonGroup::setPersonData(int personId, QString name, QVariant value)
{
    qDebug() << Q_FUNC_INFO << personId << name << value;
}

QObjectListModel *PersonGroup::personList() const
{
    return m_personList;
}

void PersonGroup::setPersonList(QList<QObject*> arg)
{
    m_personList->setList(arg);
}
