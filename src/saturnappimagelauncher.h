/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

#pragma once
#include <Plasma/Applet>
#include <QList>
#include <KDesktopFile>
#include <QObject>
class saturnappimagelauncher : public Plasma::Applet
{
    Q_OBJECT
    

public:
    Q_PROPERTY(QStringList entries READ getEntries)
    Q_PROPERTY(QStringList icons READ getAllIcons)
    Q_PROPERTY(QString currentProgram READ getProgram WRITE setProgram)
    saturnappimagelauncher( QObject *parent, const QVariantList &args );
    ~saturnappimagelauncher();
    QString getProgram() const {
        return currentProg;
    }
    void setProgram(QString newProgram) {
        currentProg = newProgram;   
    }
    QStringList getEntries() const;
    QStringList getAllIcons() const {
        QStringList list;
        for (auto& entry: m_Entries) {
            list.append(m_Icons[entry]);
        }
        return list;
    }
    Q_INVOKABLE bool runProgram();
private:
     QString readIcon(QString progName) {
        return m_Icons[progName];
    }
    QStringList m_Entries;
    QMap<QString, QString> m_Icons;
    QMap<QString, KDesktopFile*> m_Programs;
    QMap<QString, QString> m_Paths;

    QString currentProg;

};

