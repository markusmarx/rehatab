#include "clientcontroller.h"
#include "data/person.h"
#include "data/contract.h"
#include "data/appointment.h"
#include "data/qobjectlistmodel.h"
#include "QDjangoQuerySet.h"

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
        person->setCreated(QDateTime::currentDateTime());
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
    person->setDeleted(QDateTime::currentDateTime());
    return person->save();
}

bool ClientController::saveContract(Contract *contract, Person* person)
{
    contract->setClient(person);
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

QList<QObject *> ClientController::getContracts(int personId)
{
    QList<QObject*> contractList;
    QDjangoQuerySet<Contract> contractQs;
    Contract* contract;
//    ClientAppointment* clApp;
//    int usedValue;
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


//        QDjangoQuerySet<ClientAppointment> clAppQs;
//        clAppQs = clAppQs.filter(QDjangoWhere("client_id", QDjangoWhere::Equals, contract->id()));
//        if (contract->type() == 0) {
//            usedValue = clAppQs.count();
//        } else {
//            clAppQs.selectRelated();

//            for (int j = 0; j < clAppQs.size(); j++) {
//                clApp = clAppQs.at(i);
//                usedValue += clApp->appointment()->minutes();
//            }
//        }
        //contract->setOpenValue(contract->value()-usedValue);
        contractList.append(contract);
    }
    return contractList;
}

bool ClientController::removeContract(Contract *contract)
{
    contract->setDeleted(QDateTime::currentDateTime());
    contract->save();
    return true;
}



