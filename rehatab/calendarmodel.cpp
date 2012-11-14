#include "calendarmodel.h"
#include <QDebug>

CalendarModel::CalendarModel(QObject *parent) :
    QAbstractListModel(parent), m_refDate(QDate::currentDate())
{
    QHash<int, QByteArray> roles;
    roles.insert(1001, "date");
    setRoleNames(roles);
    resetDatemodel();
}

QVariant CalendarModel::data(const QModelIndex &index, int role) const
{
  //  qDebug() << Q_FUNC_INFO;
    return m_dateList.value(index.row());
}

int CalendarModel::rowCount(const QModelIndex &parent) const
{
//    qDebug() << Q_FUNC_INFO;
    return m_dateList.size();
}

QVariant CalendarModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

void CalendarModel::addWeek(int week)
{
    qDebug() << Q_FUNC_INFO;
    m_refDate = m_refDate.addDays(7*week);
    resetDatemodel();
}

void CalendarModel::resetDatemodel()
{
    beginResetModel();
    m_dateList.clear();
    QDate dd = m_refDate.addDays(1-m_refDate.dayOfWeek());

    for (int i = 0; i < 7; i++) {
        m_dateList.append(dd);
        dd = dd.addDays(1);
    }
    endResetModel();
    emit dateRangeChanged(m_dateList.first(), m_dateList.last());
    emit layoutChanged();
}

void CalendarModel::setMode(CalendarModel::ModelMode mode)
{
    m_mode = mode;
    emit modeChanged();
}

QDate CalendarModel::lastDate() const
{
    return !m_dateList.isEmpty()? m_dateList.last(): m_refDate;
}

QDate CalendarModel::firstDate() const
{
    return !m_dateList.isEmpty()? m_dateList.first(): m_refDate;
}
