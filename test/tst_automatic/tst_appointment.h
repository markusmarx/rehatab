#ifndef TST_APPOINTMENT_H
#define TST_APPOINTMENT_H
#include "tst_base.h"

class tst_Appointment : public tst_Base
{
    Q_OBJECT
public:
    explicit tst_Appointment(QObject *parent = 0);
    
signals:
    
private slots:
    void initTestCase();
    void cleanupTestCase();
    void tst_appointmentCRUD();
    
};

#endif // TST_APPOINTMENT_H
