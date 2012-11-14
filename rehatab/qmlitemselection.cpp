#include "qmlitemselection.h"
#include <QDebug>
QmlItemSelection::QmlItemSelection(QObject *parent) :
    QObject(parent)
{
}

bool QmlItemSelection::selected() const
{
//    qDebug() << Q_FUNC_INFO << ", return " << m_selected;
    return m_selected;
}

void QmlItemSelection::setSelected(bool selected)
{   //qDebug() << Q_FUNC_INFO << ", selected = " << selected;
    m_selected = selected;

    emit selectedChanged();
}
