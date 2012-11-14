#include "mystatemaschine.h"
#include "mystate.h"

MyStateMaschine::MyStateMaschine(QObject *parent) :
    QStateMachine(parent), m_modal(false)
{
    m_personMenuState = new MyState(this);
    m_calendarMenuState = new MyState(this);
    m_groupMenuState = new MyState(this);

    {
        m_personListViewState = new MyState(m_personMenuState);
        m_personListViewState->assignProperty(this, "modal", false);
        m_openPersonState = new MyState(m_personMenuState);
        m_openPersonState->assignProperty(this, "modal", true);
        m_newPersonState = new MyState(m_personMenuState);
        m_newPersonState->assignProperty(this, "modal", true);
        m_closePersonState = new MyState(m_personMenuState);
    }


    {
        m_personMenuState->addTransition(this, SIGNAL(calendarMenu()), m_calendarMenuState);
        m_personMenuState->addTransition(this, SIGNAL(calendarMenu()), m_calendarMenuState);
        m_personMenuState->addTransition(this, SIGNAL(groupMenu()), m_groupMenuState);
        m_calendarMenuState->addTransition(this, SIGNAL(personMenu()), m_personMenuState);
        m_calendarMenuState->addTransition(this, SIGNAL(groupMenu()), m_groupMenuState);
        m_groupMenuState->addTransition(this, SIGNAL(personMenu()), m_personMenuState);
        m_groupMenuState->addTransition(this, SIGNAL(calendarMenu()), m_calendarMenuState);


        m_personMenuState->setInitialState(m_personListViewState);
        m_personListViewState->addTransition(this, SIGNAL(openPerson()), m_openPersonState);
        m_personListViewState->addTransition(this, SIGNAL(newPerson()), m_newPersonState);
        m_openPersonState->addTransition(this, SIGNAL(closePerson()), m_personListViewState);
        m_openPersonState->addTransition(this, SIGNAL(openPerson()), m_openPersonState);
        m_newPersonState->addTransition(this, SIGNAL(closePerson()), m_personListViewState);
    }




    setInitialState(m_personMenuState);
    start();
}

QObject *MyStateMaschine::openPersonState() const
{
    return m_openPersonState;
}

QObject *MyStateMaschine::newPersonState() const
{
    return m_newPersonState;
}

QObject *MyStateMaschine::closePersonState() const
{
    return m_closePersonState;
}

QObject *MyStateMaschine::personListViewState() const
{
    return m_personListViewState;
}

QObject *MyStateMaschine::personMenuState() const
{
    return m_personMenuState;
}

QObject *MyStateMaschine::calendarMenuState() const
{
    return m_calendarMenuState;
}

QObject *MyStateMaschine::groupMenuState() const
{
    return m_groupMenuState;
}

bool MyStateMaschine::modal() const
{
    return m_modal;
}

void MyStateMaschine::setModal(bool modal)
{
    m_modal = modal;
    emit modalChanged();
}


