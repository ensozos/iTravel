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

    //Save the whole model before closing the app. (Connect the "aboutToQuit" signal of the "app" with the "saveAll" function of "mediator")
    QObject::connect(&app,SIGNAL(aboutToQuit()),&mediator,SLOT(saveAll()));

    return app.exec();
}
