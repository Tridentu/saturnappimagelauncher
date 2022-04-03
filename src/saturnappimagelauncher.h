/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#ifndef SATURNAPPIMAGELAUNCHER_H
#define SATURNAPPIMAGELAUNCHER_H


#include <Plasma/Applet>

class saturnappimagelauncher : public Plasma::Applet
{
    Q_OBJECT
    Q_PROPERTY(QString nativeText READ nativeText CONSTANT)

public:
    saturnappimagelauncher( QObject *parent, const QVariantList &args );
    ~saturnappimagelauncher();

    QString nativeText() const;

private:
    QString m_nativeText;
};

#endif
