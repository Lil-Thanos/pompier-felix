/****************************************************************************
** Meta object code from reading C++ file 'superviseurope.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/superviseurope.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'superviseurope.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN14SuperviseurOPEE_t {};
} // unnamed namespace

template <> constexpr inline auto SuperviseurOPE::qt_create_metaobjectdata<qt_meta_tag_ZN14SuperviseurOPEE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SuperviseurOPE",
        "distanceMinCalculee",
        "",
        "distance",
        "messageInfo",
        "message",
        "getLonLatGeocoding",
        "lat",
        "lon",
        "code_postal",
        "calculerDistanceMin",
        "getAdresse",
        "rue",
        "recalculerDistance"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'distanceMinCalculee'
        QtMocHelpers::SignalData<void(QString)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 },
        }}),
        // Signal 'messageInfo'
        QtMocHelpers::SignalData<void(QString)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 5 },
        }}),
        // Slot 'getLonLatGeocoding'
        QtMocHelpers::SlotData<void(double, double, QString)>(6, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Double, 7 }, { QMetaType::Double, 8 }, { QMetaType::QString, 9 },
        }}),
        // Slot 'calculerDistanceMin'
        QtMocHelpers::SlotData<void()>(10, 2, QMC::AccessPrivate, QMetaType::Void),
        // Method 'getAdresse'
        QtMocHelpers::MethodData<void(QString)>(11, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 12 },
        }}),
        // Method 'recalculerDistance'
        QtMocHelpers::MethodData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<SuperviseurOPE, qt_meta_tag_ZN14SuperviseurOPEE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject SuperviseurOPE::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14SuperviseurOPEE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14SuperviseurOPEE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14SuperviseurOPEE_t>.metaTypes,
    nullptr
} };

void SuperviseurOPE::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SuperviseurOPE *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->distanceMinCalculee((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 1: _t->messageInfo((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 2: _t->getLonLatGeocoding((*reinterpret_cast< std::add_pointer_t<double>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<double>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[3]))); break;
        case 3: _t->calculerDistanceMin(); break;
        case 4: _t->getAdresse((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 5: _t->recalculerDistance(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SuperviseurOPE::*)(QString )>(_a, &SuperviseurOPE::distanceMinCalculee, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SuperviseurOPE::*)(QString )>(_a, &SuperviseurOPE::messageInfo, 1))
            return;
    }
}

const QMetaObject *SuperviseurOPE::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SuperviseurOPE::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14SuperviseurOPEE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SuperviseurOPE::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void SuperviseurOPE::distanceMinCalculee(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void SuperviseurOPE::messageInfo(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}
QT_WARNING_POP
