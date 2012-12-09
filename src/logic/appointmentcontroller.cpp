#include "appointmentcontroller.h"
#include "data/appointment.h"
#include "appointmentmodel.h"
#include "QDjangoQuerySet.h"
#include "data/qobjectlistmodel.h"
#include "util/timeiteration.h"
#include "util/QsLog.h"
#include "data/persongroup.h"
#include "data/personappointment.h"
#include "data/personcontracthistory.h"

AppointmentController::AppointmentController(QObject *parent) :
    QObject(parent), m_appointmentModel(new AppointmentModel(this))
{
}

Appointment *AppointmentController::createAppointment() const
{
    Appointment* app = new Appointment;

    return app;
}

Appointment *AppointmentController::getAppointment(int id)
{
    QDjangoQuerySet<Appointment> appoSet;
    Appointment* appo;
    appo = appoSet.get(QDjangoWhere("id", QDjangoWhere::Equals, id));
    return appo;
}

bool AppointmentController::remove(Appointment *appointment)
{
    return appointment->remove();
}

bool AppointmentController::update(Appointment *appointment)
{
//    appointmentModel()->updateAppointment(appointment);
//    bool success = appointment->save();
//    QList<QObject*> pList = appointment->member()->list();
//    if (success) {
//        QDjangoQuerySet<Appointment2Person> app2Mem;
//        app2Mem = app2Mem.filter(QDjangoWhere("appointment_id", QDjangoWhere::Equals, appointment->id()));
//        app2Mem.remove();

//        foreach(QObject* obj, pList) {
//            Appointment2Person* app2Mem = new Appointment2Person(appointment);
//            app2Mem->setAppointment(appointment);
//            app2Mem->setPerson(qobject_cast<Person*>(obj));
//            app2Mem->setPresent(appointment->isPresent(qobject_cast<Person*>(obj)->id()));
//            app2Mem->save();
//        }



//    }

    return true;

}


AppointmentModel *AppointmentController::appointmentModel() const
{
    return m_appointmentModel;
}

bool AppointmentController::saveAppointment(Appointment *appointment)
{
//    AppointmentSummary* appSum = appointment->appointmentSummary();

//    //bool appIsNew = appointment->id() < 0;
//    bool appSumIsNew = appSum->id() < 0;

//    if (appSumIsNew) {
//        appSum = new AppointmentSummary;
//    }

//    appSum->setDescription(appointment->description());
//    appSum->setName(appointment->name());
//    appSum->setFromTime(appointment->time());
//    appSum->setMinutes(appointment->minutes());
//    appSum->setItStart(appointment->itStart());
//    appSum->setItEnd(appointment->validTo());
//    appSum->setItModel(appointment->iteration());
//    appSum->save();
//    if (appSumIsNew)
//        appointment->setAppointmentSummary(appSum);

//    appointment->save();

//    return true;
}

bool AppointmentController::removeAppointment(Appointment *appointment)
{
    return true;
}


QList<Appointment *> AppointmentController::getAppointments(QDate from, QDate to, bool expand)
{
    qDebug() << Q_FUNC_INFO << from << to << expand;
    QDjangoQuerySet<Appointment> appSQs;

    appSQs = appSQs.filter(
                (QDjangoWhere("validFrom", QDjangoWhere::GreaterOrEquals, from) && QDjangoWhere("validFrom", QDjangoWhere::LessOrEquals, to)) ||
                (QDjangoWhere("validTo", QDjangoWhere::GreaterOrEquals, from) && QDjangoWhere("validTo", QDjangoWhere::LessOrEquals, to)) ||
                (QDjangoWhere("validFrom", QDjangoWhere::LessThan, from) &&
                    (QDjangoWhere("validTo", QDjangoWhere::GreaterThan, to) || !QDjangoWhere("validTo", QDjangoWhere::IsNull, QVariant())))
                );

    QList<Appointment*> appList;
    Appointment* app;
    Appointment* newApp;
    QList<QDate> dates;

    QLOG_DEBUG() << "found " << appSQs.size() << " appointments between " << from << " and " << to;

    for(int i = 0; i < appSQs.size(); i++) {

        app = appSQs.at(i);

        if (!app->iteration().isEmpty() && expand) {
            TimeIteration t = TimeIteration(app->iteration(), app->date().date());
            dates = t.findDates(from.daysTo(app->date().date()) > 0? app->date().date(): from, to);
        } else {
            dates << app->date().date();
        }

        foreach(QDate d, dates) {
            newApp = new Appointment;
            newApp->setId(app->id());
            newApp->setName(app->name());
            newApp->setDescription(app->description());
            newApp->setDate(QDateTime(d));
            newApp->setTime(app->date().time());
            newApp->setValidFrom(app->validFrom());
            newApp->setValidTo(app->validTo());
            newApp->setIteration(app->iteration());
            newApp->setMinutes(app->minutes());
            newApp->setPersonGroup(app->personGroup());
            newApp->setPersonAppointment(app->personAppointment());
            appList.append(newApp);
        }
        dates.clear();
    }

    return appList;
}

void AppointmentController::loadAppointmentsToModel(QDate from, QDate to)
{
    qDebug() << Q_FUNC_INFO << from << to;
    m_appointmentModel->setAppointments(getAppointments(from, to, true));

}

Appointment *AppointmentController::loadAppointment(Appointment *appointment)
{
    return new Appointment;
}

bool AppointmentController::removeAllAppointments(Appointment *appointment)
{
    return true;
}

PersonAppointment *AppointmentController::loadPersonAppointment(Appointment *app, QDateTime date)
{
    QDjangoQuerySet<PersonAppointment> appQs;
    QDjangoQuerySet<PersonContractHistory> pchQs;

    PersonAppointment* pApp = appQs.get(QDjangoWhere("id", QDjangoWhere::Equals, app->personAppointment()->id()));
    PersonContractHistory* pCH = pchQs.get(QDjangoWhere("personAppointment_id", QDjangoWhere::Equals, app->personAppointment()->id()) && QDjangoWhere("date", QDjangoWhere::Equals, date));

    if (pCH) {
        pApp->client()->setPresence(pCH->present());
    } else {
        pApp->client()->setPresence(false);
    }
    return pApp;
}
