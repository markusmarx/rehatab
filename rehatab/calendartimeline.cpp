#include "calendartimeline.h"
#include <QPainter>
#include <QDebug>
#include <QTime>
#include <QDeclarativeProperty>
#include <QDeclarativeEngine>
#include "logic/appointmentmodel.h"
#include "data/appointment.h"
#include "data/persongroup.h"
#include "data/personappointment.h"
#include "QDjangoQuerySet.h"

QHash<QObject*, CalendarTimeLineAttached*> CalendarTimeLineAttached::attached;

class CalendarTimeLinePrivate {
    CalendarTimeLinePrivate(CalendarTimeLine* parent);

    CalendarTimeLine * const q_ptr;
    Q_DECLARE_PUBLIC(CalendarTimeLine)

    bool m_renderTime;
    int m_gridWidth;
    int m_gridHeight;
    QRect m_textRect;
    QDate m_date;
    qreal m_y;
};


CalendarTimeLinePrivate::CalendarTimeLinePrivate(CalendarTimeLine *parent)
    :q_ptr(parent), m_y(0)
{


}


CalendarTimeLine::CalendarTimeLine(QDeclarativeItem *parent) :
    QDeclarativeItem(parent), d_ptr(new CalendarTimeLinePrivate(this))
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
}

void CalendarTimeLine::setRenderTime(bool showTime)
{
    Q_D(CalendarTimeLine);
    d->m_renderTime = showTime;

}

bool CalendarTimeLine::renderTime() const
{
    Q_D(const CalendarTimeLine);
    return d->m_renderTime;
}

void CalendarTimeLine::setGridWidth(int gridWidth)
{
    Q_D(CalendarTimeLine);
    d->m_gridWidth = gridWidth;
}

int CalendarTimeLine::gridWidth() const
{
    Q_D(const CalendarTimeLine);
    return d->m_gridWidth;
}

void CalendarTimeLine::setGridHeight(int gridHeight)
{
    Q_D(CalendarTimeLine);
    d->m_gridHeight = gridHeight;
}

int CalendarTimeLine::gridHeight() const
{
    Q_D(const CalendarTimeLine);
    return d->m_gridHeight;
}

void CalendarTimeLine::setDate(QDate date)
{
    Q_D(CalendarTimeLine);
    d->m_date = date;
    emit dateChanged();

}

QDate CalendarTimeLine::date() const
{
    Q_D(const CalendarTimeLine);
    return d->m_date;
}

void CalendarTimeLine::setAppointmentModel(QObject *appModel)
{
    m_appModel = qobject_cast<AppointmentModel*>(appModel);
    connect(m_appModel, SIGNAL(appointmentChanged(QDate)), this, SLOT(appointmentChanged(QDate)));
    connect(m_appModel, SIGNAL(appointmentUpdated(Appointment*)), this, SLOT(appointmentUpdated(Appointment*)));
}

QObject *CalendarTimeLine::appointmentModel() const
{
    return m_appModel;
}

void CalendarTimeLine::paint(QPainter *p, const QStyleOptionGraphicsItem *, QWidget *)
{
    Q_D(CalendarTimeLine);
    int y = 0;
    int y1 = d->m_gridHeight/2;
    int x1 = 0;
    int x2 = (d->m_renderTime)? d->m_textRect.width():0;
    int endX = width();
    QTime hour(0,0);
    p->save();
    p->setPen(QPen(Qt::black));
    for (int i = 1; i <= 24; i++) {
//        if (d->m_renderTime) {
//            p->drawText(QRect(x1,y,d->m_textRect.width(), d->m_textRect.height()), Qt::AlignTop| Qt::AlignRight, hour.toString("hh:mm"));
//            hour = hour.addSecs(3600);
//        }
        y += d->m_gridHeight;
//        p->drawLine(x1,y,endX, y);

    }
//    if (d->m_renderTime) {
//        p->drawLine(x2, 0, x2, height());
//    }
    //p->drawLine(endX-1, 0, endX-1, height());
    p->save();
    p->setPen(QPen(Qt::black, 1, Qt::DotLine));
//    for (int i = 0; i < 24; i++) {


//        p->drawLine(x2,y1,endX, y1);
//        y1 += d->m_gridHeight;



//    }
    p->restore();
    p->restore();
    // old vertical view
    //    int x = 0;
    //    int x1 = 87/2;
    //    int y1 = 0;
    //    int y2 = 0;
    //    int endY = height();

    //    QString t = "%1:00";
    //    QFontMetrics f = p->fontMetrics();
    //    QRect trect = f.boundingRect(t);
    //    y2 = trect.height();
    //    for (int i = 1; i <= 24; i++) {

    //        p->drawText(QRect(x,y1,87, trect.height()), Qt::AlignCenter| Qt::AlignHCenter, t.arg(i-1));
    //        x += 87;
    //        p->drawLine(x,y1,x, endY);


    //    }
    //    p->drawLine(0, trect.height(), width(), trect.height());
    //    p->save();
    //    p->setPen(QPen(Qt::black, 1, Qt::DotLine));
    //    for (int i = 0; i < 24; i++) {

    //        p->drawLine(x1,y2,x1, endY);
    //        x1 += 87;
    //    }
    //    p->restore();

}

QDeclarativeComponent *CalendarTimeLine::delegate() const
{
    return m_delegate;
}

void CalendarTimeLine::setDelegate(QDeclarativeComponent *delegate)
{
    m_delegate = delegate;

}

void CalendarTimeLine::componentComplete()
{
    Q_D(CalendarTimeLine);
    QFont font;
    QFontMetrics fm(font);
    d->m_textRect = fm.boundingRect("00:00");
    d->m_textRect.adjust(0,0,20,0);
    if (d->m_renderTime) {
        setWidth(d->m_gridWidth+d->m_textRect.width());
    } else {
        setWidth(d->m_gridWidth);
    }
    setHeight(1);



}



void CalendarTimeLine::classBegin()
{
}

void CalendarTimeLine::addAppointment(QTime from, QTime to, QString name, int id)
{
    Q_D(CalendarTimeLine);
    int hourDx = d->m_gridHeight;
    float startY = ((float)from.hour() + ((float)from.minute()/60))* hourDx;
    float endY = ((float)to.hour() + ((float)to.minute()/60))* hourDx;
    int startX = (d->m_renderTime)?d->m_textRect.width(): 0;
    int endX = width();

    QDeclarativeItem* item = m_items.value(id);

    if (!item) {
        QObject* obj = m_delegate->create(QDeclarativeEngine::contextForObject(this));
        item = qobject_cast<QDeclarativeItem*>(obj);
        m_items.insert(id, item);
    }
//    CalendarTimeLineAttached* att = qmlAttachedProperties(item);
//    att->setName(name);
//    att->setFrom(from);
//    att->setTo(to);

    item->setX(startX);
    item->setY(d->m_y);
    item->setWidth(endX-startX);
    item->setHeight(100);
    d->m_y+=110;
    setHeight(d->m_y);

    item->setParentItem(this);

    QDeclarativeProperty::write(item, "name", name);
    QDeclarativeProperty::write(item, "to", to);
    QDeclarativeProperty::write(item, "from", from);
    QDeclarativeProperty::write(item, "id", id);

}

void CalendarTimeLine::appointmentChanged(QDate adate)
{
    updateAppointments(m_appModel->appointments(date()));
}
void CalendarTimeLine::updateAppointments(QList<Appointment *> appointmentList)
{
    foreach(Appointment* app, appointmentList) {
        if (app->isGroupAppointment()) {
            addAppointment(app->time(), app->time().addSecs(60*app->minutes()), app->personGroup()->name(), app->id());
        } else {
            QDjangoQuerySet<PersonAppointment> qs;
            PersonAppointment* pa = qs.get(QDjangoWhere("id", QDjangoWhere::Equals, app->personAppointment()->id()));

            addAppointment(app->time(), app->time().addSecs(60*app->minutes()), pa->client()->name() + ", " + pa->client()->forename(), app->id());
        }
    }
}
void CalendarTimeLine::appointmentUpdated(Appointment *appointment) {
    Q_D(CalendarTimeLine);
    //qDebug() << appointment->fromDate() << ", " << d->m_date;
    if (appointment->date().date() == d->m_date) {
        addAppointment(appointment->time(), appointment->time().addSecs(60*appointment->minutes()), appointment->personGroup()->name(), appointment->id());
    }
}

CalendarTimeLineAttached *CalendarTimeLine::qmlAttachedProperties(QObject *object)
{
    qDebug() << Q_FUNC_INFO << ", value = " << object;
    return CalendarTimeLineAttached::properties(object);
}


QTime CalendarTimeLineAttached::from() const
{
    return m_from;
}

void CalendarTimeLineAttached::setFrom(QTime from)
{
    m_from = from;
    emit fromChanged();
}

QTime CalendarTimeLineAttached::to() const
{
    return m_to;
}

void CalendarTimeLineAttached::setTo(QTime to)
{
    m_to = to;
    emit toChanged();
}

QString CalendarTimeLineAttached::name() const
{
    //qDebug() << Q_FUNC_INFO << "value = " << m_name;
    return m_name;
}

void CalendarTimeLineAttached::setName(QString name)
{
    m_name = name;
    emit nameChanged();
}


CalendarTimeLineAttached::CalendarTimeLineAttached(QObject *parent): QObject(parent)
{
}
