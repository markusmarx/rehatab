#ifndef STATISTICCONTROLLER_H
#define STATISTICCONTROLLER_H

#include <QObject>
class QObjectListModel;
class StatisticController : public QObject
{
    Q_OBJECT
public:
    explicit StatisticController(QObject *parent = 0);

    Q_INVOKABLE QObjectListModel* getWarningContracts();

    
signals:
    
public slots:

private:
    QObjectListModel* m_warningContracts;
    
};

#endif // STATISTICCONTROLLER_H
