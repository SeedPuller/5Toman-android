#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtAndroid>
#include "header/viewmodel.h"
#include "header/imagepickerandroid.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName("AVID LTD.");
    app.setOrganizationDomain("SeedPuller.space");
    app.setApplicationName("5 Toman");
    auto result = QtAndroid::checkPermission(QString("android.permission.READ_EXTERNAL_STORAGE"));
    auto result2 = QtAndroid::checkPermission(QString("android.permission.WRITE_EXTERNAL_STORAGE"));
    if(result == QtAndroid::PermissionResult::Denied || result2 == QtAndroid::PermissionResult::Denied){
        QtAndroid::PermissionResultMap resulthash = QtAndroid::requestPermissionsSync(QStringList({"android.permission.READ_EXTERNAL_STORAGE", "android.permission.WRITE_EXTERNAL_STORAGE"}));
        if (resulthash["android.permission.READ_EXTERNAL_STORAGE"] == QtAndroid::PermissionResult::Denied
                || resulthash["android.permission.WRITE_EXTERNAL_STORAGE"] == QtAndroid::PermissionResult::Denied) {
            return 0;
        }
    }

    QQmlApplicationEngine engine;

    // add model to qml
    ViewModel debtormodel("debtors");
    ViewModel creditormodel("creditors");
    engine.rootContext()->setContextProperty("DebtorModel", &debtormodel);
    engine.rootContext()->setContextProperty("CreditorModel", &creditormodel);
    // add image picker to qml
    qmlRegisterType<AndroidImgePicker>("Android.ImagePicker", 1, 0, "ImagePicker");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
