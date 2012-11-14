#include "timeiteration.h"
#include "QsLog.h"
#include <QStringList>
#include <QString>

class ItCompiler {
public:
    ItCompiler(QString pattern, QDate refDate): m_pattern(pattern),
        m_refDate(refDate), m_itDate(refDate) {}
    virtual QDate next() = 0;
    virtual void reset() = 0;
    virtual QDate setStartDate(QDate startDate) = 0;
    QString m_pattern;

    QDate m_refDate;
    QDate m_itDate;
};

/**
 * @brief The WeekItCompiler class compiles a weekly iteration
 */
class WeekItCompiler: public ItCompiler {

    QDate m_currentDate;

public:
    WeekItCompiler(QString pattern, QDate refDate):ItCompiler(pattern,refDate.addDays(1-refDate.dayOfWeek())) {
        QStringList sl = pattern.split(" ", QString::SkipEmptyParts);
        QLOG_DEBUG() << "create WeekItCompiler with " << pattern << " refdate " << m_refDate;
        m_week = sl.at(1).toInt();
        QString days = sl.at(2);
        for (int i = 0; i < days.length();i++) {
            m_days.append(QString(days.at(i)).toInt());
        }
        m_currentDayIdx = 0;
    }

    virtual QDate next() {
        int day = m_days.at(m_currentDayIdx);

        QDate dd = m_itDate.addDays(day-1);

        m_currentDayIdx++;
        if (m_currentDayIdx == m_days.size()) {
            m_currentDayIdx = 0;
            m_itDate = m_itDate.addDays((m_week)*7);
        }
        m_currentDate  = dd;
        return dd;
    }

    virtual void reset() {
        m_itDate = m_refDate;
    }

    virtual QDate setStartDate(QDate startDate) {
        QDate origStartDate = startDate;
        startDate = startDate.addDays(1-startDate.dayOfWeek());
        int diffDays = m_refDate.daysTo(startDate);

        if (diffDays > 0) {
            diffDays = diffDays + (((diffDays/7)%m_week)) * 7;
        } else if (diffDays < 0) {
            diffDays = diffDays - ((diffDays/7)%m_week) * 7;
        } else {
            diffDays = 0;
        }
        m_itDate = m_refDate.addDays(diffDays);

        while (m_currentDate.daysTo(origStartDate) > 0) {
            QLOG_DEBUG() << m_itDate.daysTo(origStartDate);
            next();
        }
        return m_currentDate;
    }



private:
    int m_week;
    QList<int> m_days;
    int m_currentDayIdx;

};


TimeIteration::TimeIteration(QString pattern, QDate start)
{
    m_compiler = new WeekItCompiler(pattern, start);
}


QList<QDate> TimeIteration::findDates(QDate from, QDate to)
{
    QList<QDate> dList;
    QDate dd = m_compiler->setStartDate(from);
    while (dd <= to) {
        dList.append(dd);
        dd = m_compiler->next();
    }
    return dList;
}

QDate TimeIteration::next()
{
    return m_compiler->next();
}

QDate TimeIteration::setStartDate(QDate startDate)
{
    return m_compiler->setStartDate(startDate);
}
