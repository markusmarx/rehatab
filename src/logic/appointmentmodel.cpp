#include "appointmentmodel.h"
#include "data/appointment.h"
#include "QDjangoQuerySet.h"
#include "util/QsLog.h"
AppointmentModel::AppointmentModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

QVariant AppointmentModel::data(const QModelIndex &index, int role) const
{
    return QVariant();
}


QVariant AppointmentModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant();
}

QList<Appointment *> AppointmentModel::appointments(QDate date)
{
    QLOG_TRACE() << Q_FUNC_INFO;
    QList<Appointment*> appList;

    foreach (Appointment* app, m_appointments) {
        if (app->date().date() == date) {
            appList.append(app);
        }
    }
    QLOG_DEBUG() << "found " << appList.size() << " appointments for " << date;
    return appList;
}

void AppointmentModel::updateAppointment(Appointment *appointment)
{

    emit appointmentUpdated(appointment);
}

void AppointmentModel::setAppointments(QList<Appointment *> appList)
{
    m_appointments = appList;
    emit appointmentChanged(QDate::currentDate());
}

Appointment *AppointmentModel::getAppointment(int id) const
{
    Appointment *app = 0;
    foreach(Appointment* appointment, m_appointments) {
        if (appointment->id() == id) {
            app = appointment;
        }
    }
    return app;
}

int AppointmentModel::rowCount(const QModelIndex &parent) const
{
    return 0;
}

