#include "persongrouphistory.h"

PersonGroupHistory::PersonGroupHistory(QObject *parent) :
    QDjangoModel(parent), m_id(-1)
{
    setForeignKey("group2Person", new Group2Person(this));
}
