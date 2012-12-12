#include "statisticcontroller.h"
#include "data/qobjectlistmodel.h"
#include "data/contract.h"
#include "data/person.h"
#include "QDjangoQuerySet.h"

#include "util/QsLog.h"

StatisticController::StatisticController(QObject *parent) :
    QObject(parent)
{
    QStringList names;
    names << "validFrom" << "validTo" << "value" << "openValue";

    m_warningContracts = new QObjectListModel("id", names, QList<QObject*>(), this);
}

QObjectListModel *StatisticController::getWarningContracts()
{
    QLOG_TRACE() << Q_FUNC_INFO;

    m_warningContracts->clear();

    QDjangoQuerySet<Contract> qs;

    QDateTime now = QDateTime::currentDateTime();
    now.setTime(QTime(0,0));

    QDateTime then = now;
    then = then.addMonths(2);
    then.setTime(QTime(23,59,59));

    qs = qs.filter(QDjangoWhere("openValue", QDjangoWhere::LessOrEquals, 8)
                   || (QDjangoWhere("validTo", QDjangoWhere::GreaterOrEquals, now)
                   && QDjangoWhere("validTo", QDjangoWhere::LessOrEquals, then)));

    QLOG_DEBUG() << "found warning contracts: " << qs.size();

    QList<QObject*> contractList;

    for (int i = 0; i < qs.size(); i++) {
        contractList.append(qs.at(i));
    }

    m_warningContracts->setList(contractList);

    return m_warningContracts;
}
