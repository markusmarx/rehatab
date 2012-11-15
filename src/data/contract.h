#ifndef CONTRACT_H
#define CONTRACT_H

#include <QObject>
#include "QDjangoModel.h"
#include <QDate>
class Person;
class Contract : public QDjangoModel
{
    Q_OBJECT

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QDate validFrom READ validFrom WRITE setValidFrom)
    Q_PROPERTY(QDate validTo READ validTo WRITE setValidTo)
    Q_PROPERTY(int value READ value WRITE setValue)
    Q_PROPERTY(int type READ type WRITE setType)
    Q_PROPERTY(Person* client READ client WRITE setClient)
    Q_PROPERTY(QDateTime deleted READ deleted WRITE setDeleted)
    Q_PROPERTY(int openValue READ openValue WRITE setOpenValue NOTIFY openValueChanged)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=contractId")
    Q_CLASSINFO("client", "db_column=clientId")
    Q_CLASSINFO("openValue", "ignore_field=true")

public:
    explicit Contract(QObject *parent = 0);

    int id() const;
    void setId(int id);
    QDate validFrom() const;
    void setValidFrom(QDate validFrom);
    QDate validTo() const;
    void setValidTo(QDate validTo);
    int value() const;
    void setValue(int value);
    int type() const;
    void setType(int type);
    int openValue() const;
    void setOpenValue(int openValue);

    QDateTime deleted() const;
    void setDeleted(QDateTime deleted);

    Person* client();
    void setClient(Person* client);
    
signals:
    void openValueChanged();
    
private:
    int m_id;
    QDate m_validFrom;
    QDate m_validTo;

    int m_value;
    int m_type;
    int m_openValue;
    QDateTime m_deleted;

};

#endif // CONTRACT_H
