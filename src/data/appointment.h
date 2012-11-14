#ifndef APPOINTMENT_H
#define APPOINTMENT_H

#include <QObject>
#include <QDate>
#include <QTime>
#include "QDjangoModel.h"
#include "person.h"

class QObjectListModel;
class Appointment : public QDjangoModel
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QString name READ name WRITE setName)
    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(QDateTime date READ date WRITE setDate)
    Q_PROPERTY(QTime time READ time WRITE setTime)
    Q_PROPERTY(int minutes READ minutes WRITE setMinutes)
    Q_PROPERTY(QString iteration READ iteration WRITE setIteration)
    Q_PROPERTY(QDateTime validFrom READ validFrom WRITE setValidFrom)
    Q_PROPERTY(QDateTime validTo READ validTo WRITE setValidTo)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=appointmentId")
    Q_CLASSINFO("name", "max_length=255")
    Q_CLASSINFO("description", "max_length=1000 null=true")
    Q_CLASSINFO("time", "ignore_field=true")
public:
    explicit Appointment(QObject *parent = 0);

    void setId(int id);
    int id() const;

    void setName(QString name);
    QString name() const;

    void setDescription(QString description);
    QString description() const;

    void setDate(QDateTime date);
    QDateTime date() const;

    void setTime(QTime time);
    QTime time() const;

    void setMinutes(int minutes);
    int minutes() const;

    void setIteration(QString iteration);
    QString iteration() const;

    void setValidFrom(QDateTime validFrom);
    QDateTime validFrom() const;

    void setValidTo(QDateTime validTo);
    QDateTime validTo() const;

signals:

public slots:

private:
    QDateTime m_date;
    QDateTime m_validFrom;
    int m_minutes;
    QString m_name;
    QString m_description;
    int m_id;
    QString m_iteration;
    QDateTime m_validTo;
};

#endif // APPOINTMENT_H
