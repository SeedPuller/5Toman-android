#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "viewmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("AVID LTD.");
    app.setOrganizationDomain("SeedPuller.space");
    app.setApplicationName("5 Toman");
//    app.setWindowIcon(QIcon(":/pic/logo.png"));

    // add model to qml
//    qmlRegisterType<ViewModel>("Model.ViewModel", 1, 0, "ViewModel");
    QQmlApplicationEngine engine;

    // add model to qml
    ViewModel debtormodel("debtors");
    ViewModel creditormodel("creditors");
    engine.rootContext()->setContextProperty("DebtorModel", &debtormodel);
    engine.rootContext()->setContextProperty("CreditorModel", &creditormodel);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
