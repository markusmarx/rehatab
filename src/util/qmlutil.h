#ifndef QMLUTIL_H
#define QMLUTIL_H

#include <QObject>
#include <QDate>

class QmlUtil : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString timeFormat READ timeFormat WRITE setTimeFormat)
    Q_PROPERTY(QString dateFormat READ dateFormat WRITE setDateFormat)


public:
    explicit QmlUtil(QObject *parent = 0);

    Q_INVOKABLE QDate parseDate(QString dateStr);
    Q_INVOKABLE QString formatDate(QDate date);

    Q_INVOKABLE QTime parseTime(QString timeStr);
    Q_INVOKABLE QString formatTime(QTime time);

    void setTimeFormat(QString timeFormat);
    QString timeFormat() const;
    void setDateFormat(QString dateFormat);
    QString dateFormat() const;

private:
    QString m_dateFormat;
    QString m_timeFormat;
    
};

#endif // QMLUTIL_H
