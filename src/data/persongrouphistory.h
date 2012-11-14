#ifndef PERSONGROUPHISTORY_H
#define PERSONGROUPHISTORY_H

#include "QDjangoModel.h"
#include "group2person.h"
class PersonGroupHistory : public QDjangoModel
{
    Q_OBJECT
    int m_id;

    QDateTime m_date;

    bool m_present;

    Group2Person* m_group2person;

public:
    explicit PersonGroupHistory(QObject *parent = 0);

    Q_PROPERTY(int id READ id WRITE setId)
    Q_PROPERTY(QDateTime date READ date WRITE setDate)
    Q_PROPERTY(bool present READ present WRITE present)
    Q_PROPERTY(Group2Person* group2Person READ group2Person WRITE setGroup2Person)

    Q_CLASSINFO("id", "primary_key=true auto_increment=true db_column=personGroupHistoryId")
    Q_CLASSINFO("group2Person", "db_column=group2PersonId")


    int id() const
    {
        return m_id;
    }

    QDateTime date() const
    {
        return m_date;
    }

    bool present() const
    {
        return m_present;
    }

    Group2Person* group2Person() const
    {
        return m_group2person;
    }

signals:
    
public slots:

    void setId(int arg)
    {
        m_id = arg;
    }
    void setDate(QDateTime arg)
    {
        m_date = arg;
    }
    void present(bool arg)
    {
        m_present = arg;
    }
    void setGroup2Person(Group2Person* arg)
    {
        m_group2person = arg;
    }
};

#endif // PERSONGROUPHISTORY_H
