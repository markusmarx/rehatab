#ifndef TST_PERSON_H
#define TST_PERSON_H

#include "tst_base.h"

class tst_Person : public tst_Base
{
    Q_OBJECT
public:
    explicit tst_Person(QObject *parent = 0);
    
signals:
    
private slots:

    void initTestCase();
    void cleanupTestCase();

    void tst_PersonCRUD();
    
};

#endif // TST_PERSON_H
