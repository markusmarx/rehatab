#ifndef APPOINTMENTCONTROLLER_H
#define APPOINTMENTCONTROLLER_H

#include <QObject>
#include <QDate>
class Appointment;
class AppointmentModel;
class QObjectListModel;
class AppointmentController : public QObject
{
    Q_OBJECT
public:
    explicit AppointmentController(QObject *parent = 0);

    /**
     * @brief createAppointment create a appointment
     * @return
     */
    Q_INVOKABLE Appointment* createAppointment() const;

    Q_INVOKABLE Appointment* retrieve(int id);

    Q_INVOKABLE bool remove(Appointment* appointment);

    Q_INVOKABLE bool update(Appointment* appointment);

    Q_INVOKABLE AppointmentModel* appointmentModel() const;

    /**
     * @brief saveAppointment saves the appointment and the underlying objects like clientappointment, appointmentsummary
     * @param appointment
     * @return
     */
    Q_INVOKABLE bool saveAppointment(Appointment* appointment);

    /**
     * @brief removeAppointment remove a single appointment without appointmentsummary
     * @param appointment
     * @return
     */
    Q_INVOKABLE bool removeAppointment(Appointment* appointment);

    /**
     * @brief getAppointments get light weight appointmentobjects between dates
     * @param from
     * @param to
     * @return
     */
    Q_INVOKABLE QList<Appointment*> getAppointments(QDate from, QDate to, bool expand = true);

    Q_INVOKABLE void loadAppointmentsToModel(QDate from, QDate to);

    /**
     * @brief loadAppointment load a full heavy weight appointment with clientappointments
     * @param appointment
     * @return
     */
    Q_INVOKABLE Appointment* loadAppointment(Appointment* appointment);

    /**
     * @brief removeAllAppointments remove a full appointmentstack.
     * @param appointment
     * @return
     */
    Q_INVOKABLE bool removeAllAppointments(Appointment* appointment);

signals:
    
private:
    AppointmentModel* m_appointmentModel;
    
};

#endif // APPOINTMENTCONTROLLER_H
