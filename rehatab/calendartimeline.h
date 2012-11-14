#ifndef CALENDARTIMELINE_H
#define CALENDARTIMELINE_H

#include <QDeclarativeItem>
#include <QDate>
class CalendarTimeLinePrivate;
class AppointmentModel;
class Appointment;
class CalendarTimeLineAttached: public QObject {

    Q_OBJECT
    Q_PROPERTY(QTime from READ from NOTIFY fromChanged)
    Q_PROPERTY(QTime to READ to NOTIFY toChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)

public:
    CalendarTimeLineAttached(QObject* parent);

    QTime from() const;
    void setFrom(QTime from);
    QTime to() const;
    void setTo(QTime to);
    QString name() const;
    void setName(QString name);

    static CalendarTimeLineAttached* properties(QObject* obj) {
        CalendarTimeLineAttached *rv = attached.value(obj);
        if (!rv) {
            rv = new CalendarTimeLineAttached(obj);
            attached.insert(obj, rv);
        }
        return rv;
    }

Q_SIGNALS:
    void nameChanged();
    void fromChanged();
    void toChanged();

private:
   QTime m_from;
   QTime m_to;
   QString m_name;

public:
   static QHash<QObject*, CalendarTimeLineAttached*> attached;



};

class CalendarTimeLine : public QDeclarativeItem {
    Q_OBJECT

    Q_PROPERTY(QDeclarativeComponent* delegate READ delegate WRITE setDelegate)
    Q_PROPERTY(bool renderTime READ renderTime WRITE setRenderTime)
    Q_PROPERTY(int gridWidth READ gridWidth WRITE setGridWidth)
    Q_PROPERTY(int gridHeight READ gridHeight WRITE setGridHeight)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QObject* appointmentModel READ appointmentModel WRITE setAppointmentModel)

public:
    explicit CalendarTimeLine(QDeclarativeItem *parent = 0);

    void setRenderTime(bool renderTime);
    bool renderTime() const;

    void setGridWidth(int gridWidth);
    int gridWidth() const;

    void setGridHeight(int gridHeight);
    int gridHeight() const;

    void setDate(QDate date);
    QDate date() const;

    void setAppointmentModel(QObject* appModel);
    QObject* appointmentModel() const;

    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget = 0);
    QDeclarativeComponent* delegate() const;
    void setDelegate(QDeclarativeComponent* delegate);
    void componentComplete();
    void classBegin();
    Q_INVOKABLE void addAppointment(QTime from, QTime to, QString name, int id);

    static CalendarTimeLineAttached *qmlAttachedProperties(QObject *);


signals:
    void dateChanged();

private slots:
    void appointmentChanged(QDate date);
    void appointmentUpdated(Appointment* appointment);
    
private:
    QDeclarativeComponent* m_delegate;
    AppointmentModel* m_appModel;
    bool m_showTime;
    QHash<int, QDeclarativeItem*> m_items;

    void updateAppointments(QList<Appointment*> appointmentList);

    CalendarTimeLinePrivate* const d_ptr;
    Q_DECLARE_PRIVATE(CalendarTimeLine)
};

 QML_DECLARE_TYPEINFO(CalendarTimeLine, QML_HAS_ATTACHED_PROPERTIES)

#endif // CALENDARTIMELINE_H
