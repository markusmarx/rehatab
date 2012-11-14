#include "qmlutil.h"
#include <QLocale>
#include "QsLog.h"
QmlUtil::QmlUtil(QObject *parent) :
    QObject(parent)
{

    QLocale loc = QLocale::system();
    QLOG_DEBUG() << "language is " << loc.languageToString(loc.language());
    m_dateFormat = "dd.MM.yyyy";//loc.dateFormat(QLocale::ShortFormat);
    m_timeFormat = "hh:mm"; //loc.timeFormat(QLocale::ShortFormat);
}

QDate QmlUtil::parseDate(QString dateStr)
{
    return QDate::fromString(dateStr, m_dateFormat);
}

QString QmlUtil::formatDate(QDate date)
{
    return date.toString(m_dateFormat);
}

QTime QmlUtil::parseTime(QString timeStr)
{
    return QTime::fromString(timeStr, m_timeFormat);
}

QString QmlUtil::formatTime(QTime time)
{
    return time.toString(m_timeFormat);
}


void QmlUtil::setTimeFormat(QString timeFormat)
{
    m_timeFormat = timeFormat;
}

QString QmlUtil::timeFormat() const
{
    return m_timeFormat;
}

void QmlUtil::setDateFormat(QString dateFormat)
{
    m_dateFormat = dateFormat;
}

QString QmlUtil::dateFormat() const
{
    return m_dateFormat;
}
