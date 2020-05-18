#include "header/imagepickerandroid.h"

AndroidImgePicker::AndroidImgePicker()
{
    connect(this, &AndroidImgePicker::imagePathSignal, this, &AndroidImgePicker::setImagePath);
}

void AndroidImgePicker::open()
{
    QAndroidJniObject ACTION_PICK = QAndroidJniObject::getStaticObjectField("android/content/Intent", "ACTION_PICK", "Ljava/lang/String;");
    QAndroidJniObject EXTERNAL_CONTENT_URI = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$Images$Media", "EXTERNAL_CONTENT_URI", "Landroid/net/Uri;");

    QAndroidJniObject intent=QAndroidJniObject("android/content/Intent", "(Ljava/lang/String;Landroid/net/Uri;)V", ACTION_PICK.object<jstring>(), EXTERNAL_CONTENT_URI.object<jobject>());

    if (ACTION_PICK.isValid() && intent.isValid())
    {
        intent.callObjectMethod("setType", "(Ljava/lang/String;)Landroid/content/Intent;", QAndroidJniObject::fromString("image/*").object<jstring>());
        QtAndroid::startActivity(intent.object<jobject>(), 101, this);
    }
    else
    {
        qDebug() << "ERROR";
    }
}

bool AndroidImgePicker::isAccepted()
{
    return newchoice;
}

void AndroidImgePicker::setImagePath(QString path)
{
    if (path == imagePath || path.isNull()) {
        newchoice = false;
        return;
    }
    newchoice = true;
    imagePath = path;
    emit accepted();
}

void AndroidImgePicker::handleActivityResult(int receiverRequestCode, int resultCode, const QAndroidJniObject &data)
{
    jint RESULT_OK = QAndroidJniObject::getStaticField<jint>("android/app/Activity", "RESULT_OK");
    if (receiverRequestCode == 101 && resultCode == RESULT_OK)
    {
        QAndroidJniObject uri = data.callObjectMethod("getData", "()Landroid/net/Uri;");
        QAndroidJniObject androidData = QAndroidJniObject::getStaticObjectField("android/provider/MediaStore$MediaColumns", "DATA", "Ljava/lang/String;");
        QAndroidJniEnvironment env;
        jobjectArray projection = (jobjectArray)env->NewObjectArray(1, env->FindClass("java/lang/String"), NULL);
        jobject androidDataProjection = env->NewStringUTF(androidData.toString().toStdString().c_str());
        env->SetObjectArrayElement(projection, 0, androidDataProjection);
        QAndroidJniObject contentResolver = QtAndroid::androidActivity().callObjectMethod("getContentResolver", "()Landroid/content/ContentResolver;");
        QAndroidJniObject cursor = contentResolver.callObjectMethod("query", "(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;", uri.object<jobject>(), projection, NULL, NULL, NULL);
        jint columnIndex = cursor.callMethod<jint>("getColumnIndex", "(Ljava/lang/String;)I", androidData.object<jstring>());
        cursor.callMethod<jboolean>("moveToFirst", "()Z");
        QAndroidJniObject result = cursor.callObjectMethod("getString", "(I)Ljava/lang/String;", columnIndex);
        QString tempImagePath = "file://" + result.toString();
        emit imagePathSignal(tempImagePath);
    }
//    else
//    {
//        emit imagePathSignal(QString());
//        qDebug() << "wrong";
//    }
}

QString AndroidImgePicker::getPath()
{
    return imagePath;
}
