/********************************************************************************
** Form generated from reading UI file 'superviseurope.ui'
**
** Created by: Qt User Interface Compiler version 6.9.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_SUPERVISEUROPE_H
#define UI_SUPERVISEUROPE_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_SuperviseurOPE
{
public:
    QWidget *centralwidget;
    QPushButton *pushButton_calcule;
    QLineEdit *lineEdit_test;
    QLineEdit *lineEdit;
    QLineEdit *lineEdit_2;
    QLineEdit *lineEdit_3;
    QPushButton *pushButton_adresse;
    QPushButton *pushButton_minDist;
    QLabel *label_minDist;
    QMenuBar *menubar;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *SuperviseurOPE)
    {
        if (SuperviseurOPE->objectName().isEmpty())
            SuperviseurOPE->setObjectName("SuperviseurOPE");
        SuperviseurOPE->resize(800, 600);
        centralwidget = new QWidget(SuperviseurOPE);
        centralwidget->setObjectName("centralwidget");
        pushButton_calcule = new QPushButton(centralwidget);
        pushButton_calcule->setObjectName("pushButton_calcule");
        pushButton_calcule->setGeometry(QRect(610, 140, 80, 25));
        lineEdit_test = new QLineEdit(centralwidget);
        lineEdit_test->setObjectName("lineEdit_test");
        lineEdit_test->setGeometry(QRect(280, 130, 261, 25));
        lineEdit = new QLineEdit(centralwidget);
        lineEdit->setObjectName("lineEdit");
        lineEdit->setGeometry(QRect(80, 50, 161, 25));
        lineEdit_2 = new QLineEdit(centralwidget);
        lineEdit_2->setObjectName("lineEdit_2");
        lineEdit_2->setGeometry(QRect(80, 90, 161, 25));
        lineEdit_3 = new QLineEdit(centralwidget);
        lineEdit_3->setObjectName("lineEdit_3");
        lineEdit_3->setGeometry(QRect(80, 130, 161, 25));
        pushButton_adresse = new QPushButton(centralwidget);
        pushButton_adresse->setObjectName("pushButton_adresse");
        pushButton_adresse->setGeometry(QRect(610, 70, 80, 25));
        pushButton_minDist = new QPushButton(centralwidget);
        pushButton_minDist->setObjectName("pushButton_minDist");
        pushButton_minDist->setGeometry(QRect(510, 290, 80, 25));
        label_minDist = new QLabel(centralwidget);
        label_minDist->setObjectName("label_minDist");
        label_minDist->setGeometry(QRect(40, 290, 381, 141));
        SuperviseurOPE->setCentralWidget(centralwidget);
        menubar = new QMenuBar(SuperviseurOPE);
        menubar->setObjectName("menubar");
        menubar->setGeometry(QRect(0, 0, 800, 22));
        SuperviseurOPE->setMenuBar(menubar);
        statusbar = new QStatusBar(SuperviseurOPE);
        statusbar->setObjectName("statusbar");
        SuperviseurOPE->setStatusBar(statusbar);

        retranslateUi(SuperviseurOPE);

        QMetaObject::connectSlotsByName(SuperviseurOPE);
    } // setupUi

    void retranslateUi(QMainWindow *SuperviseurOPE)
    {
        SuperviseurOPE->setWindowTitle(QCoreApplication::translate("SuperviseurOPE", "SuperviseurOPE", nullptr));
        pushButton_calcule->setText(QCoreApplication::translate("SuperviseurOPE", "calcule", nullptr));
        lineEdit_test->setText(QCoreApplication::translate("SuperviseurOPE", "distance harversine", nullptr));
        lineEdit->setText(QCoreApplication::translate("SuperviseurOPE", "157", nullptr));
        lineEdit_2->setText(QCoreApplication::translate("SuperviseurOPE", "rue saint guirec", nullptr));
        lineEdit_3->setText(QCoreApplication::translate("SuperviseurOPE", "22700", nullptr));
        pushButton_adresse->setText(QCoreApplication::translate("SuperviseurOPE", "PushButton", nullptr));
        pushButton_minDist->setText(QCoreApplication::translate("SuperviseurOPE", "PushButton", nullptr));
        label_minDist->setText(QCoreApplication::translate("SuperviseurOPE", "TextLabel", nullptr));
    } // retranslateUi

};

namespace Ui {
    class SuperviseurOPE: public Ui_SuperviseurOPE {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_SUPERVISEUROPE_H
