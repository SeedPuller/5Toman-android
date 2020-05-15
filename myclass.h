#ifndef MYCLASS_H
#define MYCLASS_H
#include <QObject>
#include "androidfiledialog.h"

class MyClass : QObject{
public:
    explicit MyClass();
    ~MyClass() = default;
public:
    void test();

//public slots:
//    void openFileNameReady(QString fileName);

private:
    AndroidFileDialog* filedialog;
    int iii{4545};
};

#endif // MYCLASS_H
