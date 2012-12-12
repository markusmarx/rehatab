#include "groupcontroller.h"
#include "data/persongroup.h"
#include "data/qobjectlistmodel.h"
#include "data/persongroup.h"
#include "data/person.h"
#include "data/contract.h"

#include "data/appointment.h"
#include "util/QsLog.h"
#include <data/personcontracthistory.h>
GroupController::GroupController(QObject *parent) :
    QObject(parent)
{
    QStringList names;
    names << "name" << "clientCount";
    m_allGroups = new QObjectListModel("id", names, QList<QObject*>(), this);
}

PersonGroup *GroupController::createGroup()
{
    qDebug() << Q_FUNC_INFO;
    return new PersonGroup();
}

bool GroupController::saveGroup(PersonGroup* group, QDateTime date)
{
    QLOG_TRACE() << Q_FUNC_INFO << group << date;
    Appointment *app;
    int clientCount = group->clientCount();
    bool isNew = false;

    if (group->id() < 0) {
        QLOG_DEBUG() << "create new appointment";
        group->setValidFrom(group->date());
        app = new Appointment(this);
        isNew = true;
    } else {
        QLOG_DEBUG() << "load appointment";
        app = group->appointment();

    }
    QLOG_DEBUG() << "appointment " << app;
    app->setDate(group->date());
    app->setName(group->name());
    app->setMinutes(group->minutes());
    app->setIteration(group->iteration());
    app->setValidFrom(group->date());
    app->setValidTo(group->validTo());

    if (isNew) {
        group->setAppointment(app);
        m_allGroups->append(group);
    }

    group->setValidFrom(group->date());
    group->save();
    if (isNew) {
        app->setPersonGroup(group);
    }
    app->save();

    //
    // remove clients from group that marked as deleted
    //
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

    clientCount -= pIds.size();

    //
    // update presence
    // TODO add new clients
    //
    QList<QObject*> personList = group->personList()->list();
    Person* person;
    foreach(QObject* obj, personList) {
        person = qobject_cast<Person*>(obj);
    }


    QDjangoQuerySet<Group2Person> qs2;
    qs2 = qs2.filter(QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id()) && (!QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant()) ||
                                                                                           QDjangoWhere("validTo", QDjangoWhere::GreaterOrEquals, QDateTime::currentDateTime())));

    QHash<int, int> person2Group;
    QStringList fields;
    fields << "id" << "client_id";
    foreach (QVariantMap v, qs2.values(fields)) {
        person2Group[v.value("client_id").toInt()] = v.value("id").toInt();
    }


    foreach(QObject* obj, group->personList()->list()) {
        Person* p = qobject_cast<Person*>(obj);

        if (!person2Group.contains(p->id())) {
            Contract *c = qobject_cast<Contract*>(p->contracts()->at(0));
            QDjangoQuerySet<Group2Person> qs3;
            Group2Person *gpp = qs3.get(QDjangoWhere("contract_id", QDjangoWhere::Equals, c->id()));
            QScopedPointer<Group2Person> gp(gpp?gpp:new Group2Person(this));
            gp->setClient(new Person(this, p->id()));
            gp->setPersonGroup(new PersonGroup(this, group->id()));
            gp->setValidFrom(c->validFrom());
            gp->setValidTo(QDateTime());
            gp->setContract(new Contract(this, c->id()));
            gp->save();
        }

        if (date.isValid()) {
            QDjangoQuerySet<PersonContractHistory> qsPresence;
            qsPresence = qsPresence.filter(QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id())
                    && QDjangoWhere("client_id", QDjangoWhere::Equals, p->id()) && QDjangoWhere("date", QDjangoWhere::Equals, date));
            Contract *c = qobject_cast<Contract*>(p->contracts()->at(0));
            if (qsPresence.count() > 0) {
                QVariantMap updateValues;
                updateValues["present"] = p->presence();
                qsPresence.update(updateValues);

            } else {
                QScopedPointer<PersonContractHistory> pgH(new PersonContractHistory());
                pgH->setPresent(p->presence()?1:0);
                pgH->setDate(date);
                pgH->setPersonGroup(group);
                pgH->setClient(p);
                pgH->setContract(new Contract(this, c->id()));
                pgH->save();
            }
            c->save();
        }

    }

    updateListData(group, clientCount);

    return true;
}

QObjectListModel *GroupController::allGroups()
{
    PersonGroup* group;

    if (m_allGroups->size() == 0) {
        QDjangoQuerySet<PersonGroup> qGroup;
        QDateTime date = QDateTime::currentDateTime();
        qGroup = qGroup.filter((QDjangoWhere("validFrom", QDjangoWhere::LessOrEquals, date)
                                        && (!QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant())
                                             || QDjangoWhere("validTo", QDjangoWhere::GreaterOrEquals, date))));
        QList<QObject*> list;
        for (int i = 0; i < qGroup.size(); i++) {
            group = qGroup.at(i);
            group->setClientCount(getCurrentGroup2Person(group->id(), QDateTime::currentDateTime()).count());
            list.append(group);
        }

        m_allGroups->setList(list);

    }
    return m_allGroups;
}

bool GroupController::addPersonToGroup(Person* person, PersonGroup* group, bool save)
{
    qDebug() << Q_FUNC_INFO << person << group;

    QDjangoQuerySet<Group2Person> qs;

    qs = qs.filter(QDjangoWhere("client_id", QDjangoWhere::Equals, person->id())
                   && QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id())
                   && !QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant()));
    if (qs.count() > 0) {
        return true;
    }

    if (person->contracts()->list().size() > 0) {
        foreach (QObject* obj, person->contracts()->list()) {
            Contract* c = qobject_cast<Contract*>(obj);
            if (c->valid()) {
                if (save) {
                    QDjangoQuerySet<Group2Person> qs2;
                    Group2Person *gpp = qs2.get(QDjangoWhere("contract_id", QDjangoWhere::Equals, c->id()));
                    QScopedPointer<Group2Person> gp(gpp?gpp:new Group2Person(this));
                    gp->setClient(new Person(this, person->id()));
                    gp->setPersonGroup(new PersonGroup(this, group->id()));
                    gp->setValidFrom(c->validFrom());
                    gp->setValidTo(QDateTime());
                    gp->setContract(c);
                    gp->save();
                    updateListData(group, group->clientCount()+1);
                } else {
                    QList<QObject*> cl;
                    cl.append(c);
                    person->setContracts(cl);
                    group->personList()->append(person);
                }
                break;
            }
        }
    }

    return true;
}


QDjangoQuerySet<Group2Person> GroupController::getCurrentGroup2Person(int id, QDateTime date)
{
    QDjangoQuerySet<Group2Person> qs;
    return qs.filter(QDjangoWhere("personGroup_id", QDjangoWhere::Equals, id)
                   && (QDjangoWhere("validFrom", QDjangoWhere::LessOrEquals, date)
                       && (!QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant())
                            || QDjangoWhere("validTo", QDjangoWhere::GreaterOrEquals, date))));
}

void GroupController::updateListData(PersonGroup *group, int clientCount)
{
    qDebug() << Q_FUNC_INFO << group << clientCount;
    allGroups()->findById(group->id())->setProperty("clientCount", clientCount);
    allGroups()->objIsChanged(group->id());
}

PersonGroup *GroupController::loadGroup(PersonGroup *group, QDateTime date)
{
    Q_ASSERT(group);
    qDebug() << Q_FUNC_INFO << group;
    QList<QObject*> personList;

    QDjangoQuerySet<Group2Person> qs;
    QDjangoQuerySet<PersonContractHistory> qsh;
    PersonContractHistory* pgH;
    if (!date.isValid()) {
        date = QDateTime::currentDateTime();
    }

    qs = getCurrentGroup2Person(group->id(), date);

    if (qs.count() > 0) {
        qs.selectRelated();
        qDebug() << "found " << qs.size() << " clients";
        for (int i = 0; i < qs.size(); i++) {
            Person* p = qs.at(i)->client();
            personList.append(p);
            QList<QObject*> cl;
            if (qs.at(i)->contract()->id() > 0) {
                cl.append(qs.at(i)->contract());
                p->setContracts(cl);
            }

            if (date.isValid()) {

                pgH = qsh.get(QDjangoWhere("personGroup_id", QDjangoWhere::Equals, group->id()) && QDjangoWhere("client_id", QDjangoWhere::Equals, p->id())
                              && QDjangoWhere("date", QDjangoWhere::Equals, date));
                if (pgH) {
                    qDebug() << pgH->present();
                    p->setPresence(pgH->present());
                } else {
                    p->setPresence(false);
                }
            }
        }

        group->setPersonList(personList);
    }

    return group;
}

PersonGroup *GroupController::getGroup(int id)
{
    QLOG_TRACE() << Q_FUNC_INFO << id;
    QDjangoQuerySet<PersonGroup> qs;
    QDjangoQuerySet<Appointment> qApp;
    PersonGroup* group = qs.get(QDjangoWhere("id", QDjangoWhere::Equals, id));
    group->setClientCount(getCurrentGroup2Person(group->id(), QDateTime::currentDateTime()).count());
    Appointment* app = qApp.get(QDjangoWhere("personGroup__id", QDjangoWhere::Equals, group->id()));
    //app->setParent(this);
    QLOG_DEBUG() << "load appointment " << app;
    group->setAppointment(app);
    return group;
}

PersonGroup *GroupController::findByAppointmentId(int id)
{
    QLOG_TRACE() << Q_FUNC_INFO << id;
    QDjangoQuerySet<Appointment> qs;
    Appointment* app = qs.get(QDjangoWhere("id", QDjangoWhere::Equals, id));
    PersonGroup* pg = app->personGroup();
    pg->setAppointment(app);
    return pg;
}

bool GroupController::removeGroup(PersonGroup *group)
{
    group->setValidTo(QDateTime::currentDateTime());
    group->save();

    group->appointment()->setValidTo(group->validTo());
    group->appointment()->save();
    m_allGroups->remove(group);
    return true;
}

