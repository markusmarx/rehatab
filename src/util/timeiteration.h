#ifndef TIMEITERATION_H
#define TIMEITERATION_H
#include <QDate>

/**
 * @brief The TimeIteration class
 *
 * Helperclass to find iterative dates from a reference date and a rule.
 * Weekly Rule:
 * w 2 1234567
 *
 *
 */

class ItCompiler;
class TimeIteration
{
public:
    TimeIteration(QString pattern, QDate startDate);
    /**
     * @brief findDates between from and to
     * @param from
     * @param to
     * @return
     */
    QList<QDate> findDates(QDate from, QDate to);

    /**
     * @brief next get next valid date
     * @return
     */
    QDate next();

    /**
     * @brief setStartDate set start of calculation.
     * @param startDate
     * \return QDate
     */
    QDate setStartDate(QDate startDate);
private:
    ItCompiler* m_compiler;
};

#endif // TIMEITERATION_H
