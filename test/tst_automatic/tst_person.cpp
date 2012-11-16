#include "tst_person.h"
#include <QTest>
#include "data/qdjangodatabasemanager.h"
#include <QFile>
#include "data/person.h"
#include "data/contract.h"
#include "QDjangoQuerySet.h"
#include "util/QsLog.h"
#include "logic/clientcontroller.h"
#include "logic/appointmentcontroller.h"
#include "data/qobjectlistmodel.h"

tst_Person::tst_Person(QObject *parent) :
    tst_Base(parent)
{
}

void tst_Person::initTestCase()
{
    openTestDb();
}

void tst_Person::cleanupTestCase()
{
}

void tst_Person::tst_PersonCRUD()
{
    ClientController* clC = new ClientController;
    AppointmentController* appC = new AppointmentController;
    Person *p = clC->createPerson();
    p->setName("testname");
    p->setForename("foreneme");
    p->setBirth(getDate("15.03.1976"));
    p->setValidFrom(QDateTime::currentDateTime());
//    p->setDeleted(QDateTime::currentDateTime());
//    p->setUpdated(QDateTime::currentDateTime());
    clC->savePerson(p);

    QDjangoQuerySet<Person> qs;
    Person* p2 = qs.get(QDjangoWhere("id", QDjangoWhere::Equals, p->id()));

    QCOMPARE(p->name(), p2->name());

    Contract* contract =clC->createContract();
    contract->setValidFrom(QDateTime(getDate("01.10.2012")));
    contract->setValidTo(QDateTime(getDate("01.10.2013")));
    contract->setType(0);
    contract->setValue(50);
    clC->saveContract(contract, p);

    QList<QObject*> contractList = clC->getContracts(p);
    QCOMPARE(contractList.size(), 1);
    Contract* c2 = qobject_cast<Contract*>(contractList.at(0));

    QCOMPARE(contract->validFrom(), c2->validFrom());
    QCOMPARE(contract->value(), c2->openValue());

    QList<Appointment*> appList = appC->getAppointments(getDate("01.10.2012"), getDate("10.10.2012"));
    QCOMPARE(appList.size(), 1);

    contractList = clC->getContracts(p);
    QCOMPARE(contractList.size(), 1);
    c2 = qobject_cast<Contract*>(contractList.at(0));

    QCOMPARE(contract->validFrom(), c2->validFrom());
    QCOMPARE(49, c2->openValue());

}
