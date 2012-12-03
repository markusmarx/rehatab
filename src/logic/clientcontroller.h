#ifndef CLIENTCONTROLLER_H
#define CLIENTCONTROLLER_H

#include <QObject>
#include <QDate>

class Person;
class Contract;
class Appointment;
class ClientAppointmentSummary;
class ClientAppointment;
class QObjectListModel;
class PersonAppointment;
class ClientController : public QObject
{
    Q_OBJECT
public:
    explicit ClientController(QObject *parent = 0);

    /**
     * \brief
     * \return
     **/
    Q_INVOKABLE QObjectListModel* personList() const;

    /**
     * @brief createPerson factory for new person
     * @return
     */
    Q_INVOKABLE Person* createPerson();

    /**
     * @brief savePerson store a person object.
     * @param person
     * @return
     */
    Q_INVOKABLE bool savePerson(Person* person);

    /**
     * @brief loadPerson load person details such as appointments and contracts
     * @param person a person hull
     * @return the given person reference.
     **/
    Q_INVOKABLE Person* loadPerson(Person* person);

    /**
     * \brief getPerson get a person by id
     * \p personId
     * \return loaded person
     */
    Q_INVOKABLE Person* getPerson(int personId);

    /**
     * @brief removePerson set a person as deleted.
     * @param person
     * @return
     */
    Q_INVOKABLE bool removePerson(Person* person);

    /**
     * @brief createContract factory for new contract.
     * @return
     */
    Q_INVOKABLE Contract* createContract();

    /**
     * @brief saveContract save a contract object.
     * @param contract
     * @param person
     * @return
     */
    Q_INVOKABLE bool saveContract(Contract* contract, Person* person);


    /**
     * @brief removeContract set a contract as deleted.
     * @param contract
     * @return
     */
    Q_INVOKABLE bool removeContract(Contract* contract);



    /**
     * @brief getContracts load person by Contract
     * @param person
     * @return
     */
    Q_INVOKABLE QList<QObject*> getContracts(Person* person);

    /**
     * @brief getContracts load person by Contract
     * @param personId
     * @return
     */
    Q_INVOKABLE QList<QObject*> getContracts(int personId);


    /**
     *
     * \brief load contract details
     */
    Q_INVOKABLE Contract* loadContract(Contract* contract);

    /**
     * \brief factory method for personappointment
     */
    Q_INVOKABLE PersonAppointment* createPersonAppointment();

    /**
     * \brief save a personappointment, if not exist create one
     *
     * \return true if success else false.
     */
    Q_INVOKABLE bool savePersonAppointment(PersonAppointment* personApp, Person* p, Contract* c);

signals:
    
public slots:

private:
    QObjectListModel* m_personList;

    /**
     * @brief getPersonAppointments return all personappointmentobjects to a person
     * @param person
     * @return
     */
    QList<PersonAppointment*> getPersonAppointments(Person* person);
    
};

#endif // CLIENTCONTROLLER_H
