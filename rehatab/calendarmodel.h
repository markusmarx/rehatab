#ifndef CALENDARMODEL_H
#define CALENDARMODEL_H
#include <QObject>
#include <QAbstractListModel>
#include <QDate>
class CalendarModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QDate lastDate READ lastDate)
    Q_PROPERTY(QDate firstDate READ firstDate)

public:

    enum ModelMode {
        Day = 0x0000,
        Week  = 0x0001,
        FourDays  = 0x0002,
        Month  = 0x0004,
        Year  = 0x0008,
        Year2 = 0x0010,
        Year3 = 0x0020

    };

    explicit CalendarModel(QObject *parent = 0);

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;
    Q_INVOKABLE void addWeek(int week);
    void resetDatemodel();

    void setMode(ModelMode mode);

    QDate lastDate() const;
    QDate firstDate() const;
    
signals:
    void modeChanged();
    void dateRangeChanged(QDate from, QDate to);

private:
    ModelMode m_mode;
    QList<QDate> m_dateList;
    QDate m_refDate;
};

#endif // CALENDARMODEL_H
