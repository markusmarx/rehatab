#include "personappointment.h"

PersonAppointment::PersonAppointment(QObject *parent) :
    QDjangoModel(parent), m_id(-1)
{
    setClient(new Person((this)));
    setContract(new Contract(this));
    //setAppointment(new Appointment(this));
}
