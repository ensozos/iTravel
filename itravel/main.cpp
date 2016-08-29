#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include "iostream"
#include "mediator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Mediator mediator;

    engine.rootContext()->setContextProperty("mediator",&mediator);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QQmlComponent component(&engine,QUrl::fromLocalFile("qrc:/MainForm.qml"));
    QObject *object = component.create();

    /*QList<QObject*> children = engine.rootObjects();
    QList<QObject*>::iterator i;
    for (i = children.begin(); i != children.end(); ++i)
        cout << (*i)->objectName().toStdString() << endl;*/

    //Save the whole model before closing the app. (Connect the "aboutToQuit" signal of the "app" with the "saveAll" function of "mediator")
    QObject::connect(&app,SIGNAL(aboutToQuit()),&mediator,SLOT(saveAll()));

    //Emit score signal from C++
    QObject::connect(&mediator,SIGNAL(scoreSignal()),object->findChild<QObject *>("mainForm"),SLOT(handleScoreSignal()));

    return app.exec();
}
