#include "tst_base.h"



tst_Base::tst_Base(QObject *parent) :
    QObject(parent)
{

}

void tst_Base::openTestDb()
{


}

QDate tst_Base::getDate(QString date) const
{
    return QDate::fromString(date, "dd.MM.yyyy");
}
