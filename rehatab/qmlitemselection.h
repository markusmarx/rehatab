#ifndef QMLITESELECTION_H
#define QMLITESELECTION_H

#include <QObject>

class QmlItemSelection : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool selected READ selected NOTIFY selectedChanged)

public:
    explicit QmlItemSelection(QObject *parent = 0);
    bool selected() const;
    void setSelected(bool selected);
Q_SIGNALS:
    void selectedChanged();
    
public slots:

private:
    bool m_selected;
    
};

#endif // QMLITESELECTION_H
