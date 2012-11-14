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

bool PersonGroup::personData(int personId, QVariant variant)
{
    qDebug() << Q_FUNC_INFO << personId << variant;

    if (!m_personData.contains(personId)) {
        return false;
    }
    return m_personData.value(personId).contains(variant);
}

void PersonGroup::setPersonData(int personId, QString name, QVariant value)
{
    qDebug() << Q_FUNC_INFO << personId << name << value;
    if (!m_personData.contains(personId)) {
        m_personData[personId] = QVariantList();
    }
    if (!m_personData[personId].contains(value))
        m_personData[personId].append(value);
}

QObjectListModel *PersonGroup::personList() const
{
    return m_personList;
}

void PersonGroup::setPersonDataHash(int personId, QVariantList hash)
{
    m_personData[personId] = hash;
}

QVariantList PersonGroup::personDataHash(int personId)
{
    return m_personData[personId];
}

void PersonGroup::setPersonList(QList<QObject*> arg)
{
    m_personList->setList(arg);
}
