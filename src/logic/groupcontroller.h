#ifndef GROUPCONTROLLER_H
#define GROUPCONTROLLER_H

#include <QObject>
#include <QDateTime>
#include "QDjangoQuerySet.h"
#include "data/group2person.h"
class PersonGroup;
class QObjectListModel;
class Person;
class PersonGroup;

class GroupController : public QObject
{
    Q_OBJECT
public:
    explicit GroupController(QObject *parent = 0);


    Q_INVOKABLE PersonGroup* createGroup();
    Q_INVOKABLE bool saveGroup(PersonGroup* group, QDateTime date = QDateTime());
    Q_INVOKABLE QObjectListModel* allGroups();
    Q_INVOKABLE bool addPersonToGroup(Person* person, PersonGroup* group, bool save = true);
    Q_INVOKABLE PersonGroup* loadGroup(PersonGroup* group, QDateTime date = QDateTime());
    Q_INVOKABLE PersonGroup* getGroup(int id);
    Q_INVOKABLE PersonGroup* findByAppointmentId(int id);
    Q_INVOKABLE bool removeGroup(PersonGroup* group);

signals:
    
public slots:

private:
    QObjectListModel* m_allGroups;

    QDjangoQuerySet<Group2Person> getCurrentGroup2Person(int id, QDateTime date);
    void updateListData(PersonGroup* group, int clientCount);
    
};

#endif // GROUPCONTROLLER_H
