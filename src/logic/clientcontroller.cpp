#include "clientcontroller.h"
#include "data/person.h"
#include "data/contract.h"
#include "data/appointment.h"
#include "data/qobjectlistmodel.h"
#include "QDjangoQuerySet.h"
#include <data/group2person.h>
#include <data/persongrouphistory.h>

ClientController::ClientController(QObject *parent) :
    QObject(parent)
{
    QStringList names;
    names << "name" << "forename" << "birth" << "age";
    m_personList = new QObjectListModel("id", names, QList<QObject*>(), this);

    QDjangoQuerySet<Person> pL;
    QList<QObject*> personList;
    for (int i = 0; i < pL.count(); i++) {
        personList.append(pL.at(i));
    }
    m_personList->setList(personList);
}

QObjectListModel *ClientController::personList() const
{
    return m_personList;
}

Person *ClientController::createPerson()
{
    return new Person();
}

Contract *ClientController::createContract()
{
    Contract* c = new Contract;
    return c;
}


bool ClientController::savePerson(Person *person)
{
    bool isNew = false;
    if (person->id() <0 ) {
        person->setValidFrom(QDateTime::currentDateTime());
        isNew = true;
    }
    bool res = person->save();
    Contract* contract;
    ClientAppointmentSummary* clAppSum;
    foreach(QObject* cObj, person->contracts()->list()) {

        contract = qobject_cast<Contract*>(cObj);

        if (contract->id() < 0) {
            contract->setClient(person);
        }
        contract->save();
    }

    if (isNew) {
        m_personList->append(person);
    }
}

Person *ClientController::loadPerson(Person *person)
{
    person->setContracts(getContracts(person));
    return person;
}

Person *ClientController::getPerson(int personId)
{
    QDjangoQuerySet<Person> someUsers;
    Person* person = someUsers.get(QDjangoWhere("id", QDjangoWhere::Equals, personId));

    return person;

}

bool ClientController::removePerson(Person *person)
{
    person->setValidTo(QDateTime::currentDateTime());
    return person->save();
}

bool ClientController::saveContract(Contract *contract, Person* person)
{
    contract->setClient(person);
    QDateTime d = contract->validTo();
    d.setTime(QTime(23, 59, 59));
    contract->setValidTo(d);
    if (contract->id() < 0) {
        person->contracts()->append(contract);
    }

    return contract->save();
}

QList<QObject *> ClientController::getContracts(Person *person)
{
    if (person == 0) {
        return QList<QObject*>();
    }

    return getContracts(person->id());
}

Contract* ClientController::loadContract(Contract* contract)
{
    QStringList fields;
    fields << "id";
    QDjangoQuerySet<Group2Person> group2PersonQuery;
    QDjangoQuerySet<PersonGroupHistory> pgHistoryQuery;
    int openValue = contract->value();

    QList<QVariantMap> mapList = group2PersonQuery.filter(QDjangoWhere("contract_id", QDjangoWhere::Equals, contract->id())).values(fields);
    foreach(QVariantMap map, mapList) {
        int count = pgHistoryQuery.filter(QDjangoWhere("group2Person_id", QDjangoWhere::Equals, map["id"].toInt())
                     && QDjangoWhere("present", QDjangoWhere::Equals, true)).count();
        openValue -= count;
    }
    contract->setOpenValue(openValue);
    return contract;
}

QList<QObject *> ClientController::getContracts(int personId)
{
    QList<QObject*> contractList;
    QDjangoQuerySet<Contract> contractQs;
    Contract* contract;
    QStringList orderby;
    orderby << "validFrom" << "validTo";
    contractQs = contractQs
            .filter(QDjangoWhere("client_id", QDjangoWhere::Equals, personId))
            .orderBy(orderby);

    //
    // calculate openvalues for contract
    //



    for (int i = contractQs.size()-1; i >=0 ; i--) {
        contract = contractQs.at(i);
        loadContract(contract);

        //contract->setOpenValue(contract->value()-usedValue);
        contractList.append(contract);
    }
    return contractList;
}

bool ClientController::removeContract(Contract *contract)
{
    contract->remove();
    return true;
}



