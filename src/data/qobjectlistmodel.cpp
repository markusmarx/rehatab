#include "qobjectlistmodel.h"

QObjectListModel::QObjectListModel(QString id, QStringList names, QList<QObject*> list, QObject *parent) :
    QAbstractListModel(parent), m_id(id)
{



    m_id = id;
    if (!names.contains(id)) {
        names.insert(0, id);
    }
    setNames(names);

    setList(list);
}

void QObjectListModel::setList(QList<QObject *> list)
{
    beginResetModel();
    m_list = list;
    endResetModel();
}

QList<QObject *> QObjectListModel::list() const
{
    return m_list;
}

void QObjectListModel::setNames(QStringList names)
{
    int i = Qt::UserRole + 100;
    QHash<int, QByteArray> roles;
    foreach (QString name, names) {
        roles.insert(i++, name.toAscii());
    }
    setRoleNames(roles);
}


QVariant QObjectListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

int QObjectListModel::rowCount(const QModelIndex &parent) const
{
    return m_list.size();
}

QVariant QObjectListModel::data(const QModelIndex &index, int role) const
{
    QByteArray nameArr = roleNames().value(role);

//    QString nameStr = QString(nameArr);

//    if (nameStr.contains('.')) {
//        return QVariant();
//    } else {

//    }
     return m_list.at(index.row())->property(nameArr);
}

void QObjectListModel::append(QObject *obj)
{
    beginInsertRows(QModelIndex(), m_list.size(), m_list.size());
    m_list.append(obj);
    endInsertRows();
}

void QObjectListModel::insert(int idx, QObject *obj)
{
    beginInsertRows(QModelIndex(), idx, idx);
    m_list.insert(idx, obj);
    endInsertRows();
}

void QObjectListModel::remove(QObject *obj)
{
    remove(obj->property(m_id.toAscii()));
}

void QObjectListModel::remove(QVariant id)
{
    QByteArray idName = m_id.toAscii();
    QObject* lObj;
    for (int i = 0; i < m_list.size(); i++) {
        lObj = m_list.at(i);
        if (lObj->property(idName) == id) {
            beginRemoveRows(QModelIndex(), i, i);
            m_list.removeAt(i);
            m_removedList.append(lObj);
            endRemoveRows();
            break;
        }
    }
}

QObject *QObjectListModel::find(QString name, QVariant value)
{
    QObject* res = 0;
    QByteArray b = name.toAscii();
    foreach(QObject* obj, m_list) {
        if (obj->property(b) == value)     {
            res = obj;
            break;
        }
    }
    return res;
}

QObject *QObjectListModel::findById(QVariant id)
{
    return find(m_id, id);
}

void QObjectListModel::update(QObject *obj)
{
    QByteArray id = m_id.toAscii();
    QVariant idProp = obj->property(id);
    QObject* lObj;
    for (int i = 0; i < m_list.size(); i++) {
        lObj = m_list.at(i);
        if (lObj->property(id) == idProp) {
            if (lObj != obj) {
                m_list.removeAt(i);
                m_list.insert(i, obj);
            }
            emit dataChanged(createIndex(i,0), createIndex(i,0));
            break;
        }
    }
}

int QObjectListModel::size()
{
    return m_list.size();
}

QList<QObject *> QObjectListModel::removedObjects()
{
    return m_removedList;
}


QObject* QObjectListModel::at(int i)
{
    return m_list.at(i);
}


QObjectListModel::QObjectListModel(QObject *parent):QAbstractListModel(parent)
{

}



