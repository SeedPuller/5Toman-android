#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QFile>
#include <QDebug>


class Database : public QObject {
    Q_OBJECT
public:
    explicit Database(const QString& hostname, const QString& dbname, const QString& connectionname = QLatin1String("defaultconnection"), QObject* parent = nullptr);
    ~Database() = default;

    bool execute(const QString& query, const QStringList* params = nullptr);
    bool execute(const QString &querystr, const QVariantList &params);
    bool executeWithoutFetch(const QString &querystr, const QVariantList &params) const;
    int fetch(QList<QVariantList>& rows, int columncounter);
    QString getError() const;
    bool isFirstInit() const;
private:
    QSqlDatabase db;
    QSqlQuery* query;
    QString hostname;
    QString dbname;
    QString connectionname;
    bool db_exist_flag{false};

    bool connectToDatabase();
};

#endif // DATABASE_H
