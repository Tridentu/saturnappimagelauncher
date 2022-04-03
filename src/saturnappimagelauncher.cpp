/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#include "saturnappimagelauncher.h"
#include <KLocalizedString>

saturnappimagelauncher::saturnappimagelauncher(QObject *parent, const QVariantList &args)
    : Plasma::Applet(parent, args),
      m_nativeText(i18n("Text coming from C++ plugin"))
{
}

saturnappimagelauncher::~saturnappimagelauncher()
{
}

QString saturnappimagelauncher::nativeText() const
{
    return m_nativeText;
}

K_PLUGIN_CLASS_WITH_JSON(saturnappimagelauncher, "metadata.json")

#include "saturnappimagelauncher.moc"
