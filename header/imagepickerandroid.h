#ifndef AndroidImgePicker_H
#define AndroidImgePicker_H

#include <QObject>
#include <QtAndroidExtras>

#include <QDebug>

class AndroidImgePicker : public QObject, public QAndroidActivityResultReceiver
{
    Q_OBJECT
    Q_PROPERTY(bool accepted READ isAccepted NOTIFY accepted)

public:
    AndroidImgePicker();

    virtual void handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject & data);

public slots:
    QString getPath();
    void open();
    bool isAccepted();
signals:
    void imagePathSignal(QString);
    void accepted();

private slots:
    void setImagePath(QString path);

private:
    QString imagePath;
    bool newchoice;
};

#endif // AndroidImgePicker_H
