#include "qmlselectionmodel.h"
#include <QDebug>
#include <QDeclarativeItem>
#include "qmlitemselection.h"
QmlSelectionModel::QmlSelectionModel(QObject *parent) :
    QObject(parent)
{
}

void QmlSelectionModel::select(int id, QmlSelectionModel::SelectionFlags cmd)
{
//    qDebug() << Q_FUNC_INFO;

    if (cmd.testFlag(Clear)) {
        foreach (int idKey, m_selectedIds.keys())
            deselectItem(idKey);
    }
    if (cmd.testFlag(Select)) {
        if (!isSelected(id)) {
            selectItem(id);
        }
    }
    if (cmd.testFlag(Deselect)) {
        if (isSelected(id)) {
            deselectItem(id);
        }
    }
    if (cmd.testFlag(Toggle)) {
        if (isSelected(id)) {
            deselectItem(id);
        } else {
            selectItem(id);
        }
    }
}

void QmlSelectionModel::select(int id)
{
    select(id, m_currentSelectionFlag);
}


QVariantList QmlSelectionModel::selectedIds() const
{
    //qDebug() << Q_FUNC_INFO << ", ids = " << m_selectedIds.keys();
    QVariantList selectedIds;

    foreach(int key, m_selectedIds.keys()) {
        if (m_selectedIds.value(key)->selected()) {
            selectedIds<<key;
        }
    }

    return selectedIds;
}

int QmlSelectionModel::selectCount() const
{
    return m_selectedIds.size();
}

void QmlSelectionModel::setCurrentSelectionFlag(QmlSelectionModel::SelectionFlags cmd)
{
//    qDebug() << Q_FUNC_INFO;
    m_currentSelectionFlag = cmd;
}

QmlSelectionModel::SelectionFlags QmlSelectionModel::currentSelectionFlag() const
{
    return m_currentSelectionFlag;
}

QmlItemSelection *QmlSelectionModel::itemSelection(int id)
{
//    qDebug() << Q_FUNC_INFO << ", id = " << id;
    QmlItemSelection* sItem;
    if (!m_selectedIds.contains(id)) {
        //qDebug() << "create itemselection for id " << id;
        sItem = new QmlItemSelection();
        sItem->setSelected(false);
        m_selectedIds.insert(id, sItem);
    } else {
        sItem = m_selectedIds.value(id);
    }

    return sItem;

}

void QmlSelectionModel::selectItem(int id)
{
//    qDebug() << Q_FUNC_INFO << ", id = " << id;
    itemSelection(id)->setSelected(true);
}

void QmlSelectionModel::deselectItem(int id)
{
//    qDebug() << Q_FUNC_INFO << ", id = " << id;
    itemSelection(id)->setSelected(false);
}

bool QmlSelectionModel::isSelected(int id)
{
    return itemSelection(id)->selected();
}
