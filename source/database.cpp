#include "header/database.h"

Database::Database(const QString& hostname, const QString& dbname, const QString& connectionname, QObject* parent)
    : QObject(parent), hostname(hostname), dbname(dbname), connectionname(connectionname)
{
    connectToDatabase();
    query = new QSqlQuery(this->db);

}

/*
 * connect to database and set if this is initial connection
 */
bool Database::connectToDatabase() {
    if(!QFile("./" + this->dbname).exists()) {
//        qDebug() << "db not exists.";
        this->db_exist_flag = true;
    }
    db = QSqlDatabase::addDatabase("QSQLITE", connectionname);
    db.setHostName(hostname);
    db.setDatabaseName("./" + this->dbname);
    if (db.open() && db.isValid()) {
        return true;
    }
    qDebug() << "error openning database";
    qDebug() << db.lastError().text();
    return false;
}

// execute sql statements with fetch capability. THIS FUNCTION WILL BE REMOVED in next versions.
bool Database::execute(const QString &querystr, const QStringList *params)
{
    if (params == nullptr) {
        return this->query->exec(querystr);
    }

    this->query->prepare(querystr);

    for (QString p: *params) {
        this->query->addBindValue(p);
    }

    return this->query->exec();
}

/*
 *  execute sql statements with fetch capability.
 *  params with no elements result in executing querystr directly.
 */
bool Database::execute(const QString &querystr, const QVariantList& params)
{
    if (params.size() == 0) {
        return this->query->exec(querystr);
    }
    this->query->prepare(querystr);
    for (QVariant p: params) {
        QVariant::Type type = p.type();
        if (type == QVariant::Int) {
            this->query->addBindValue(p.toInt());
        } else if (type == QVariant::Double) {
            this->query->addBindValue(p.toDouble());
        } else {
            this->query->addBindValue(p.toString());
        }
    }
    return this->query->exec();
}

/*
 * execute SQL statements without fetch capability.
 * params with no elements will result in executing querystr directly.
 */
bool Database::executeWithoutFetch(const QString &querystr, const QVariantList &params) const
{
    QSqlQuery query(this->db);
    bool result;
    if (params.size() == 0) {
        result = query.exec(querystr);
        if (!result) {
            qDebug() << query.lastError().text();
        }
        return result;
    }
    query.prepare(querystr);
    for (QVariant p: params) {
        QVariant::Type type = p.type();
        if (type == QVariant::Int) {
            query.addBindValue(p.toInt());
        } else if (type == QVariant::Double) {
            query.addBindValue(p.toDouble());
        } else {
            query.addBindValue(p.toString());
        }
    }
    result = query.exec();
    if (!result) {
        qDebug() << query.lastError().text();
    }
    return result;
}

/*
 * fetch rows that affected by last query execution with "execute" function.
 * returns number of new rows added to rows vector
 */
int Database::fetch(QList<QVariantList>& rows, int columncounter)
{
    QVariantList row;
    int vectorsize{rows.size()};
    if (columncounter < 1) {
        return 0;
    }
    while (this->query->next()) {
        for (int i{0}; i < columncounter; ++i) {
            row.append(this->query->value(i));
        }
        rows.append(row);
        row.clear();
    }
    return rows.size() - vectorsize;
}

// return last sql statement execution error
QString Database::getError() const
{
    return this->query->lastError().text();
}

// return if database exists already or not.
bool Database::isFirstInit() const
{
    return db_exist_flag;
}
