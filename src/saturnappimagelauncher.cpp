/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#include "saturnappimagelauncher.h"
#include <KLocalizedString>
#include <filesystem>
#include <string>
#include <QDir>
#include <QObject>
#include <KActivities/ResourceInstance>
#include <KStartupInfo>
#include <KNotificationJobUiDelegate>
#include <KIO/ApplicationLauncherJob>

K_PLUGIN_CLASS_WITH_JSON(saturnappimagelauncher, "metadata.json")

saturnappimagelauncher::saturnappimagelauncher(QObject *parent, const QVariantList &args)
    : Plasma::Applet(parent, args)
{
    for (const std::filesystem::directory_entry& dir_entry : std::filesystem::directory_iterator{std::filesystem::path{std::string(getenv("HOME")) + std::string("/Applications/.entries")}}){
        QString path1 (QString::fromStdString(dir_entry.path().string()));
        if(dir_entry.path().extension() == ".desktop"){
                KDesktopFile dFile(path1);
                m_Entries.append(dFile.readName());
                m_Icons.insert(dFile.readName(), dFile.readIcon());
                m_Programs.insert(dFile.readName(), &dFile);
                m_Paths.insert(dFile.readName(), path1);
                qDebug() << dFile.readName();
        }
    }
}

saturnappimagelauncher::~saturnappimagelauncher()
{
}

QStringList saturnappimagelauncher::getEntries() const
{
    return m_Entries;
}

bool saturnappimagelauncher::runProgram()
{
        quint32 timeStamp = 0;
        #if HAVE_X11
                if (QX11Info::isPlatformX11()) {
                    timeStamp = QX11Info::appUserTime();
                }
        #endif
        KService::Ptr service =  KService::serviceByStorageId(m_Paths[currentProg]);
        auto *job = new KIO::ApplicationLauncherJob(service);
        job->setUiDelegate(new KNotificationJobUiDelegate(KJobUiDelegate::AutoHandlingEnabled));
        job->setRunFlags(KIO::ApplicationLauncherJob::DeleteTemporaryFiles);
        job->setStartupId(KStartupInfo::createNewStartupIdForTimestamp(timeStamp));
        job->start();
        KActivities::ResourceInstance::notifyAccessed(QUrl(QStringLiteral("applications:") + service->storageId()), QStringLiteral("io.github.tridentu.saturnappimagelauncher"));
        
        return true;
        
}



#include "saturnappimagelauncher.moc"
