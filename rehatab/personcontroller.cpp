#include "personcontroller.h"
#include "QDjangoQuerySet.h"
#include "data/person.h"
#include "data/qobjectlistmodel.h"
#include <QDebug>
#include "qmlselectionmodel.h"
PersonController::PersonController(QObject *parent) :
    QObject(parent)
{

    QStringList names;
    names << "name" << "forename" << "birth" << "age";
    m_personList = new QObjectListModel("id", names, QList<QObject*>(), this);

    QDjangoQuerySet<Person> pL;
    QList<QObject*> personList;
    for (int i = 0; i < pL.count(); i++) {
        personList.append(pL.at(i));
    }
    m_personList->setList(personList);
}

Person *PersonController::loadPerson(int id)
{
    QDjangoQuerySet<Person> someUsers;
    m_activePerson = someUsers.get(QDjangoWhere("id", QDjangoWhere::Equals, id));

    return m_activePerson;
}

QObjectListModel *PersonController::personList() const
{
    return m_personList;
}

Person* PersonController::activePerson() const {
    return m_activePerson;
}

void PersonController::saveActivePerson(Person* person)
{
    person->setValidFrom(QDateTime::currentDateTime());
    person->save();
    m_personList->update(person);

}

Person* PersonController::createPerson()
{
    m_activePerson = new Person;
    return m_activePerson;
}

void PersonController::clearActivePerson()
{
    m_activePerson->deleteLater();
    m_activePerson = 0;
}

QDate PersonController::toQDate(QString dateStr)
{
    return QDate::fromString(dateStr, "dd.MM.yyyy");

}

void PersonController::removePersons(QVariantList ids)
{
    foreach(QVariant id, ids) {
        //m_personList->remove(m_personList->findPerson(id.toInt()));
    }
}
