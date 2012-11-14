#include "personlist.h"
#include <QDate>
#include <QDebug>
#include "person.h"
PersonList::PersonList(QObject *parent) :
    QAbstractListModel(parent)
{
    QHash<int, QByteArray> names;
    names.insert(Qt::UserRole+100, "personId");
    names.insert(Qt::UserRole+101, "name");
    names.insert(Qt::UserRole+102, "forename");
    names.insert(Qt::UserRole+103, "birth");
    names.insert(Qt::UserRole+104, "age");
    setRoleNames(names);

}

QVariant PersonList::data(const QModelIndex &index, int role) const
{
    QVariant value;
    Person *person = m_personList.value(index.row());

    switch (role) {

    case Qt::UserRole+100:
        value = person->id();
        break;
    case Qt::UserRole+101:
        value = person->name();
        break;
    case Qt::UserRole+102:
        value = person->forename();
        break;
    case Qt::UserRole+104:
        value = person->age();
        break;
    }
    //qDebug() << "datachanged " << value;
    return value;
}

int PersonList::rowCount(const QModelIndex &parent) const
{
    return m_personList.count();
}

QVariant PersonList::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

Person* PersonList::findPerson(int id) {
    qDebug() <<"find person " << id;
    for (int i = 0; i < m_personList.size();i++) {
        if (m_personList.value(i)->id() == id) {
            return m_personList.value(i);

        }
    }
    return 0;
}

QModelIndex PersonList::indexFromPerson(Person* person) {
    int row;
    for (row = 0; row < m_personList.size();row++) {
        if (m_personList.value(row)->id() == person->id()) {
            break;
        }
    }
    return createIndex(row,0,person);
}

void PersonList::addPerson(Person* person) {
    int row = m_personList.size();
    beginInsertRows(QModelIndex(), row, row);
    m_personList.append(person);
    endInsertRows();

}

void PersonList::removePerson(Person *person)
{
    QModelIndex idx = indexFromPerson(person);
    beginRemoveRows(QModelIndex(), idx.row(), idx.row());
    person->remove();
    m_personList.removeOne(person);
    endRemoveRows();
}

void PersonList::reload()
{
    beginResetModel();
    m_personList.clear();
    QDjangoQuerySet<Person> pL;
    if (!m_filter.isEmpty()) {
        pL = pL.filter(QDjangoWhere("name", QDjangoWhere::StartsWith, m_filter) ||
                       QDjangoWhere("forename", QDjangoWhere::StartsWith, m_filter));
    }
    for (int i = 0; i < pL.count(); i++) {
        m_personList.append(pL.at(i));
    }
    endResetModel();
}

void PersonList::filter(QString filter)
{
    m_filter = filter;
    reload();

}





void PersonList::update(Person *person)
{
    Person* pp= findPerson(person->id());

    if (pp == 0) {

        pp = new Person();
        pp->setId(person->id());
        addPerson(pp);
    }

    QModelIndex idx = indexFromPerson(pp);

    pp->setName(person->name());
    pp->setForename(person->forename());
    pp->setBirth(person->birth());
    emit dataChanged(idx, idx);

}



