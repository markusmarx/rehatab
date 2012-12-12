#ifndef MYSTATEMASCHINE_H
#define MYSTATEMASCHINE_H

#include <QStateMachine>
class MyState;
class MyStateMaschine : public QStateMachine
{
    Q_OBJECT

    Q_PROPERTY(QObject* openPersonState READ openPersonState CONSTANT)
    Q_PROPERTY(QObject* newPersonState READ newPersonState CONSTANT)
    Q_PROPERTY(QObject* closePersonState READ closePersonState CONSTANT)
    Q_PROPERTY(QObject* personListViewState READ personListViewState CONSTANT)
    Q_PROPERTY(QObject* personMenuState READ personMenuState CONSTANT)
    Q_PROPERTY(QObject* calendarMenuState READ calendarMenuState CONSTANT)
    Q_PROPERTY(QObject* groupMenuState READ groupMenuState CONSTANT)
    Q_PROPERTY(QObject* statisticMenuState READ statisticMenuState CONSTANT)

    Q_PROPERTY(bool modal READ modal WRITE setModal NOTIFY modalChanged)

public:
    explicit MyStateMaschine(QObject *parent = 0);

    QObject* openPersonState() const;
    QObject* newPersonState() const;
    QObject* closePersonState() const;
    QObject* personListViewState() const;
    QObject* personMenuState() const;
    QObject* calendarMenuState() const;
    QObject* groupMenuState() const;
    QObject* statisticMenuState() const;
    bool modal() const;
    void setModal(bool modal);

Q_SIGNALS:
    void personMenu();
    void calendarMenu();
    void groupMenu();
    void statisticMenu();

    void openPerson();
    void newPerson();
    void closePerson();
    void personListView();
    void modalChanged();


private:
    MyState* m_openPersonState;
    MyState* m_newPersonState;
    MyState* m_closePersonState;
    MyState* m_personListViewState;
    MyState* m_personMenuState;
    MyState* m_calendarMenuState;
    MyState* m_groupMenuState;
    MyState* m_statisticMenuState;

    bool m_modal;

    void initNavigation(MyState* state);
};

#endif // MYSTATEMASCHINE_H
