#include "myclass.h"


MyClass::MyClass()
{
    filedialog = new AndroidFileDialog();
    qDebug() << this->iii;

}

void MyClass::test()
{
       bool success = filedialog->provideExistingFileName();
       if (!success) {
           qDebug() << "Problem with JNI or sth like that...";
           disconnect(filedialog, SIGNAL(existingFileNameReady(QString)), this, SLOT(openFileNameReady(QString)));
           //or just delete fileDialog instead of disconnect
       }
}

