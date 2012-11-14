#ifndef TST_BASE_H
#define TST_BASE_H

#include <QObject>
#include <QDate>

class tst_Base : public QObject
{
    Q_OBJECT
public:
    explicit tst_Base(QObject *parent = 0);
    
protected:
    void openTestDb();
    QDate getDate(QString date) const;

    
};

#endif // TST_BASE_H
