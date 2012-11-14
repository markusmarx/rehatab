#ifndef QMLSELECTIONMODEL_H
#define QMLSELECTIONMODEL_H

#include <QObject>
#include <QVariant>
#include <QVariantList>

class QDeclarativeItem;
class QmlItemSelection;
class QmlSelectionModel : public QObject
{
    Q_OBJECT
    Q_ENUMS(SelectionFlag)
    Q_PROPERTY(QmlSelectionModel::SelectionFlags currentSelectionFlag READ currentSelectionFlag WRITE setCurrentSelectionFlag)

public:

    enum SelectionFlag {
        NoUpdate = 0x0000,
        Clear  = 0x0001,
        Select  = 0x0002,
        Deselect  = 0x0004,
        Toggle  = 0x0008,
        Current = 0x0010,
        Rows= 0x0020,
        Columns = 0x0040,
        SelectCurrent = Select | Current,
        ToggleCurrent = Toggle | Current,
        ClearAndSelect = Clear | Select
    };

    Q_DECLARE_FLAGS(SelectionFlags, SelectionFlag)
    Q_FLAGS(SelectionFlag SelectionFlags)

    explicit QmlSelectionModel(QObject *parent = 0);


    Q_INVOKABLE void select(int id, QmlSelectionModel::SelectionFlags cmd);
    Q_INVOKABLE void select(int id);
    Q_INVOKABLE QVariantList selectedIds() const;
    Q_INVOKABLE int selectCount() const;
    Q_INVOKABLE bool isSelected(int id);
    void setCurrentSelectionFlag(QmlSelectionModel::SelectionFlags cmd);
    QmlSelectionModel::SelectionFlags currentSelectionFlag() const;
    Q_INVOKABLE QmlItemSelection* itemSelection(int id);
signals:
    
public slots:

private:

    QMap<int, QmlItemSelection*> m_selectedIds;
    SelectionFlags m_currentSelectionFlag;

    void selectItem(int id);
    void deselectItem(int id);

    
};

#endif // QMLSELECTIONMODEL_H
