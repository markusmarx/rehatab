#ifndef MYSTATE_H
#define MYSTATE_H

#include <QState>

class MyState : public QState
{
    Q_OBJECT

    Q_PROPERTY(bool isActive READ isActive NOTIFY isActiveChanged)

public:
    explicit MyState(QState *parent = 0);
    ~MyState();

    bool isActive() const;

    
Q_SIGNALS:
    void isActiveChanged(bool active);
    
protected:
    void onEntry(QEvent *event);
    void onExit(QEvent *event);
private:
    bool m_active;
    
};

#endif // MYSTATE_H
