#ifndef OBJECTLISTMODEL_H
#define OBJECTLISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QStringList>

class QObjectListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QList<QObject*> list READ list WRITE setList)
    Q_PROPERTY(QStringList names WRITE setNames)

public:
    QObjectListModel(QObject *parent= 0);
    explicit QObjectListModel(QString id, QStringList names, QList<QObject*> list = QList<QObject*>(), QObject *parent = 0);
    void setList(QList<QObject*> list);
    QList<QObject*> list() const;
    void setNames(QStringList names);
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;

    Q_INVOKABLE void append(QObject* obj);
    Q_INVOKABLE void insert(int idx, QObject* obj);
    Q_INVOKABLE void remove(QObject* obj);
    Q_INVOKABLE void remove(QVariant id);
    Q_INVOKABLE QObject* find(QString name, QVariant value);
    Q_INVOKABLE QObject* findById(QVariant id);
    Q_INVOKABLE void update(QObject* obj);
    Q_INVOKABLE int size();

    QList<QObject*> removedObjects();

    Q_INVOKABLE QObject* at(int i);


signals:

    
private:
    QList<QObject*> m_list;
    QList<QObject*> m_removedList;
    QString m_id;
    
};

#endif // OBJECTLISTMODEL_H
