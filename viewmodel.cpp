#include "viewmodel.h"
#include <QDebug>
ViewModel::ViewModel(const char* tablename, QObject *parent)
    : QAbstractListModel(parent), lastid{-1}, tablename(tablename), db{QString(DB_HOSTNAME), QString(DB_NAME), QString(tablename)}
{
    createDbTable();
    select(this->columns, "id", false);
    updateTotalValue();
//    foreach (QVariantList var, vlist) {
//        qDebug() << var[0].toInt() << "\t" << var[1].toString();
    //    }
}


int ViewModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return vlist.size();
}

QVariant ViewModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || vlist.size() <= 0)
        return QVariant();

    QVariantList temp = vlist.at(index.row());
    int column{role - idRole};
    switch (role) {
        case idRole:
            return temp[column];
        case fnameRole:
            return temp[column];
        case lnameRole:
            return temp[column];
        case valueRole:
            return temp[column];
        case picRole:
            return temp[column];
    }
    return QVariant();
}


bool ViewModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    int indexrow = index.row();
    int column{role - idRole};
    if (data(index, role) != value && vlist.size() > indexrow) {

        switch (role) {

            case fnameRole:
                vlist[indexrow][column] = value.toString();
            break;
            case lnameRole:
                vlist[indexrow][column] = value.toString();
            break;
            case valueRole:
                vlist[indexrow][column] = value.toString();
            break;
            case picRole:
                vlist[indexrow][column] = value.toString();
            break;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags ViewModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> ViewModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    int column_number{0};
    for (int i{idRole}; i != ROLE_END; ++i, ++column_number) {
        roles.insert(i, this->columns[column_number]);
    }
    return roles;
}

QString ViewModel::getTableName() const
{
    return this->tablename;
}

void ViewModel::setTableName(const QString &tablename)
{
    this->tablename = tablename;
}

bool ViewModel::insertFirst(const QString& fname, const QString& lname, const QString& debt, const QString& picurl, const QModelIndex &parent)
{
    int rowsaffected{0};
    bool insertresult{false};
    beginInsertRows(parent, 0, 0);
    insertresult = insertRow(fname, lname, debt, picurl);
    if (lastid == -1) {
        if (!insertresult) {
            //qDebug() << "insertFirst not ok";
            return false;
        }
        QList<QVariantList> result;
        db.execute("SELECT id FROM " + getTableName() + " ORDER BY id DESC LIMIT 1");
        rowsaffected = db.fetch(result, 1);
        if (rowsaffected <= 0) {
            qDebug() << db.getError();
        }else {
            lastid = result[0][0].toInt();
        }
    } else {
        ++lastid;
    }

    QVariantList temp;
    temp.append(lastid);
    temp.append(fname);
    temp.append(lname);
    temp.append(debt);
    temp.append(picurl);
    vlist.push_front(temp);
    endInsertRows();
    return true;
}


bool ViewModel::remove(int index, const QModelIndex& parent) {
        beginRemoveRows(parent, index, index);
        if (!removeRow(vlist[index][0].toInt())) {
            qDebug() << db.getError();
        }
        vlist.removeAt(index);
        updateTotalValue();
        endRemoveRows();
        return true;
}

/*
 * an utility for SELECT statements in sql.
 * "columns" is a list of columns need to fetch
 * "order" is an element which used to change the fetch ordering by.
 * returns number of fetched rows. and -1 if fails.
 */
int ViewModel::select(const QList<QByteArray>& columns,
                       const QByteArray& order,
                       bool ascend,
                       bool limit
                      )
{
    int numberofrows{0};
    QString querystr = "SELECT " + columns.join(",") + " FROM " + getTableName();

    if (order != nullptr) {
        querystr += " ORDER BY " + order;
        if (ascend) {
            querystr += " ASC";
        } else {
            querystr += " DESC";
        }
    }

    if (limit) {
        querystr += " LIMIT " + QString(limit);
    }

    if (!db.execute(querystr)) {
        qDebug() << "select failed";
        qDebug() << db.getError();
        return -1;
    }

    numberofrows = db.fetch(vlist, columns.size());

    return numberofrows;
}

bool ViewModel::createDbTable() const
{
    QString query{"CREATE TABLE IF NOT EXISTS " + getTableName() + " ("
                          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                          "firstname VARCHAR(255), "
                          "lastname VARCHAR(255), "
                          "value VARCHAR(255) NOT NULL,"
                          "picurl VARCHAR(255) NOT NULL"
                          ")"
                        };
    if (db.executeWithoutFetch(query, QVariantList())) {
        return true;
    }
    qDebug() << "error creating table: " + getTableName();
    return false;
}

bool ViewModel::removeRow(const int id)
{
    QVariantList params;
    params.append(id);
    QString query{"DELETE FROM " + getTableName() + " WHERE id = ?"};
    if (db.executeWithoutFetch(query, params)) {
//        qDebug() << "removed: " << id;
        return true;
    }
    qDebug() << "error deleting id: " << id;
    qDebug() << db.getError();
    return false;
}

bool ViewModel::insertRow(const QVariantList& data) {
    QString query{"INSERT INTO " + getTableName() + " VALUES (NULL, ?, ?, ?, ?)"};
    if (db.executeWithoutFetch(query, data)) {
//        qDebug() << "added to db successfully";
        return true;
    }
    qDebug() << "Error inserting to " + getTableName();
    qDebug() << db.getError();
    return false;
}

/*
 * insert a row in database. this function just create a QVariantList and call another insertRow function.
 */
bool ViewModel::insertRow(const QString& fname, const QString& lname, const QString& debt, const QString& picurl) {
    QVariantList data;
    data.append(fname);
    data.append(lname);
    data.append(debt);
    data.append(picurl);
    if (this->insertRow(data)) {
        return true;
    }
    return false;
}

bool ViewModel::updateDB(int index)
{
    QVariantList valuelist = vlist[index];
    bool changerowresult{this->changeRow(valuelist)};
    bool totalvalueresult{this->updateTotalValue()};
    if (changerowresult && totalvalueresult) {
        return true;
    }
    return false;
}

bool ViewModel::changeRow(QVariantList params)
{
    QString query{"UPDATE " + getTableName() + " SET "};
    int columnid{1};

    for (; columnid != this->columns.size() - 1; ++columnid) {
        query += this->columns[columnid] + " = ?, ";
    }

    // last column(cuz there is a "," in the loop) and id
    query += this->columns[columnid] + " = ? WHERE id = ?";
    // reorder parameters location
    params.append(params[0]);
    params.pop_front();
    if (db.executeWithoutFetch(query, params)) {
        return true;
    }
    return false;
}

QVariantList ViewModel::getIndexData(int index) const
{
    if (index < 0) {
        return QVariantList();
    }
    return vlist.at(index);
}

bool ViewModel::setData(int index, const QVariant &value, int column)
{
    QModelIndex indexmodel = QAbstractItemModel::createIndex(index, 0);
    return setData(indexmodel, value, idRole + column);
}

bool ViewModel::updateTotalValue()
{
    QList<QVariantList> result;
    bool exeresult;
    QString query{"SELECT SUM(" + this->columns[valueRole - idRole] + ") FROM " + getTableName()};
    exeresult = db.execute(query, QVariantList());
    if (!exeresult) {
        qDebug() << db.getError();
        return false;
    }
    db.fetch(result, 1);

    if (result.size() < 1) {
        this->totalvalue = 0;
        return false;
    }
    setTotalvalue(result.at(0).at(0).toInt());
    return true;
}

int ViewModel::getTotalvalue() const
{
    return totalvalue;
}

void ViewModel::setTotalvalue(int value)
{
    totalvalue = value;
    emit totalValueChanged(value);
}
