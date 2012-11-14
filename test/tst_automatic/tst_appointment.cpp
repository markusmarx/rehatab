#include "tst_appointment.h"
#include "logic/appointmentcontroller.h"
#include "data/appointment.h"
#include "util/timeiteration.h"
#include <QTest>
#include <QDebug>

tst_Appointment::tst_Appointment(QObject *parent) :
    tst_Base(parent)
{
}

void tst_Appointment::initTestCase()
{
    openTestDb();
}

void tst_Appointment::cleanupTestCase()
{
}

void tst_Appointment::tst_appointmentCRUD()
{
    AppointmentController* appC = new AppointmentController;

    Appointment* app = appC->createAppointment();

//    app->setValidFrom(getDate("01.10.2012"));
//    app->setTime(QTime::currentTime());
//    app->setMinutes(45);
//    app->setName("test");
//    app->setDescription("test");
//    app->setItStart(app->validFrom());
//    app->setIteration("w 2 1");
//    appC->saveAppointment(app);

//    QVERIFY(app->appointmentSummary()->id() > 0);
//    QVERIFY(app->id() > 0);

//    QList<Appointment*> appList = appC->getAppointments(getDate("01.10.2012"), getDate("30.10.2012"));

//    QCOMPARE(3, appList.size());

//    Appointment* app1 = appList.at(1);
//    QCOMPARE(getDate("15.10.2012"), app1->validFrom());

//    appC->saveAppointment(app1);
//    appList = appC->getAppointments(getDate("01.10.2012"), getDate("30.10.2012"));
//    QCOMPARE(3, appList.size());

//    appList = appC->getAppointments(getDate("30.09.2012"), getDate("02.10.2012"));
//    QCOMPARE(1, appList.size());

//    appList = appC->getAppointments(getDate("01.10.2012"), getDate("01.10.2012"));
//    QCOMPARE(1, appList.size());

//    appList = appC->getAppointments(getDate("08.10.2012"), getDate("30.10.2012"));
//    QCOMPARE(2, appList.size());

//    appList = appC->getAppointments(getDate("08.10.2012"), getDate("30.10.2012"), false);
//    QCOMPARE(1, appList.size());

}
