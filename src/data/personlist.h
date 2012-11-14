#ifndef PERSONLIST_H
#define PERSONLIST_H

#include <QAbstractListModel>
#include "QDjangoQuerySet.h"
class Person;
class PersonList : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit PersonList(QObject *parent = 0);
    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    void update(Person* person);

    Person *findPerson(int id);
    QModelIndex indexFromPerson(Person *person);
    void addPerson(Person *person);
    void removePerson(Person *person);

    Q_INVOKABLE void reload();

    Q_INVOKABLE void filter(QString name);

signals:
    
public slots:

private:
    QList<Person*> m_personList;
    QString m_filter;
    
};

#endif // PERSONLIST_H
