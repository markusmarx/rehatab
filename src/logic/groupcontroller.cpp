#include "groupcontroller.h"
#include "data/persongroup.h"
#include "data/qobjectlistmodel.h"
#include "data/persongroup.h"
#include "data/group2person.h"
#include "data/person.h"

#include "QDjangoQuerySet.h"
#include "data/appointment.h"
#include <QDebug>
GroupController::GroupController(QObject *parent) :
    QObject(parent)
{
    QStringList names;
    names << "name" << "date" << "startTime" << "endTime";
    m_allGroups = new QObjectListModel("id", names, QList<QObject*>(), this);
}

PersonGroup *GroupController::createGroup()
{
    qDebug() << Q_FUNC_INFO;
    return new PersonGroup();
}

bool GroupController::saveGroup(PersonGroup* group)
{
    Appointment *app;
    bool isNew = false;
    if (group->id() < 0) {
        group->setValidFrom(group->date());
        app = new Appointment(this);
        isNew = true;
    } else {
        app = group->appointment();
    }
    app->setDate(group->date());
    app->setName(group->name());
    app->setMinutes(group->minutes());
    app->setIteration(group->iteration());
    app->setValidFrom(group->date());
    app->setValidTo(group->validTo());
    app->save();

    if (isNew) {
        group->setAppointment(app);
        m_allGroups->append(group);
    }
    group->setValidFrom(group->date());
    group->save();


    QList<QObject*> removedList = group->personList()->removedObjects();

    QVariantList pIds;

    while(!removedList.isEmpty()) {
        Person *p = qobject_cast<Person*>(removedList.first());
        pIds.append(p->id());
        removedList.removeOne(p);
        p->deleteLater();
    }

    QDjangoQuerySet<Group2Person> qs;
    qs = qs.filter(QDjangoWhere("client_id", QDjangoWhere::IsIn, pIds)
                   && QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id())
                   && !QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant()));
    QVariantMap map;
    map["validTo"] = QDateTime::currentDateTime();
    qs.update(map);

    return true;
}

QObjectListModel *GroupController::allGroups()
{
    if (m_allGroups->size() == 0) {
        QDjangoQuerySet<PersonGroup> qGroup;
        qGroup = qGroup.all();
        qGroup.selectRelated();
        QList<QObject*> list;

        for (int i = 0; i < qGroup.size(); i++) {
            list.append(qGroup.at(i));
        }

        m_allGroups->setList(list);

    }
    return m_allGroups;
}

bool GroupController::addPersonToGroup(Person* person, PersonGroup* group)
{
    qDebug() << Q_FUNC_INFO << person << group;

    QDjangoQuerySet<Group2Person> qs;

    qs = qs.filter(QDjangoWhere("client_id", QDjangoWhere::Equals, person->id())
                   && QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id())
                   && !QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant()));
    if (qs.count() > 0) {
        return true;
    }

    QScopedPointer<Group2Person> gp(new Group2Person(this));
    QDjangoQuerySet<Person> pqs;
    QDjangoQuerySet<PersonGroup> pgqs;
    gp->setClient(pqs.get(QDjangoWhere("id", QDjangoWhere::Equals, person->id())));
    gp->setPersonGroup(pgqs.get(QDjangoWhere("id", QDjangoWhere::Equals, group->id())));
    gp->setValidFrom(QDateTime::currentDateTime());
    gp->save();
    return true;
}

PersonGroup *GroupController::loadGroup(PersonGroup* group)
{
    Q_ASSERT(group);
    qDebug() << Q_FUNC_INFO << group;
    QList<QObject*> personList;

    QDjangoQuerySet<Group2Person> qs;

    qs = qs.filter(QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id()) && (!QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant()) ||
                                                                                   QDjangoWhere("validTo", QDjangoWhere::GreaterOrEquals, QDateTime::currentDateTime())));
    if (qs.count() > 0) {
        qs.selectRelated();
        qDebug() << "found " << qs.size() << " clients";
        for (int i = 0; i < qs.size(); i++) {
            personList.append(qs.at(i)->client());
        }

        group->setPersonList(personList);
    }

    return group;
}

PersonGroup *GroupController::findByAppointmentId(int id)
{
    QDjangoQuerySet<PersonGroup> qs;
    return qs.get(QDjangoWhere("appointment_id", QDjangoWhere::Equals, id));
}
