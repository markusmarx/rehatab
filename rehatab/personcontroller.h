#ifndef PERSONCONTROLLER_H
#define PERSONCONTROLLER_H
#include <QSharedPointer>
#include <QObject>
#include <QVariantList>
#include <QDate>

class Person;
class QObjectListModel;
class QmlSelectionModel;
class PersonController : public QObject
{
    Q_OBJECT

public:
    explicit PersonController(QObject *parent = 0);

    Q_INVOKABLE Person* loadPerson(int id);
    Q_INVOKABLE QObjectListModel
    * personList() const;
    Q_INVOKABLE Person *activePerson() const;
    Q_INVOKABLE void saveActivePerson(Person* person);
    Q_INVOKABLE Person* createPerson();
    Q_INVOKABLE void clearActivePerson();
    Q_INVOKABLE QDate toQDate(QString dateStr);
    Q_INVOKABLE void removePersons(QVariantList ids);


signals:
    
public slots:

private:
    Person* m_activePerson;
    QObjectListModel* m_personList;
    QList<int> m_selectedPersonIds;
};

#endif // PERSONCONTROLLER_H
