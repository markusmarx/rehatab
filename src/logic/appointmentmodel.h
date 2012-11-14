#ifndef APPOINTMENTMODEL_H
#define APPOINTMENTMODEL_H

#include <QAbstractListModel>
#include <QDate>
class Appointment;
class AppointmentModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit AppointmentModel(QObject *parent = 0);

    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent) const;
    QVariant headerData(int section, Qt::Orientation orientation, int role) const;

    Q_INVOKABLE QList<Appointment*> appointments(QDate date);


    void updateAppointment(Appointment* appointment);

    /**
     * \fn void setAppointments(QList<Appointment*> appList);
     * Sets the appointmentlist that stores all Appointments.
     */
    void setAppointments(QList<Appointment*> appList);

    /**
     * \fn Q_INVOKABLE Appointment* getAppointment(int id) const;
     * gets an appointment by id from the appointmentlist.
     *
     */
    Q_INVOKABLE Appointment* getAppointment(int id) const;

signals:
    void appointmentChanged(QDate date);
    void appointmentUpdated(Appointment* appointment);
    
private:
    QList<Appointment*> m_appointments;
    
};

#endif // APPOINTMENTMODEL_H
