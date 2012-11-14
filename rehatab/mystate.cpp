#include "mystate.h"

MyState::MyState(QState *parent) :
    QState(parent), m_active(false)
{
}

MyState::~MyState()
{
}

bool MyState::isActive() const
{
    return m_active;
}


void MyState::onEntry(QEvent *event)
{
    m_active = true;
    emit isActiveChanged(true);
}

void MyState::onExit(QEvent *event)
{
    m_active = false;
    emit isActiveChanged(false);
}
