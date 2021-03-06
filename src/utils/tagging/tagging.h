/*
 *   Copyright 2018 Camilo Higuita <milo.h@aol.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

#ifndef TAGGING_H
#define TAGGING_H

#include <QObject>
#include <QtGlobal>
#include <sys/user.h>
#include "tagdb.h"

#ifndef STATIC_MAUIKIT
#include "mauikit_export.h"
#endif

#ifdef STATIC_MAUIKIT
class Tagging : public TAGDB
#else
class MAUIKIT_EXPORT Tagging : public TAGDB
#endif
{
    Q_OBJECT
public:
    static Tagging *getInstance(const QString &app, const QString &version, const QString &uri, const QString &comment = QString());
    static Tagging *getInstance();

    Q_INVOKABLE QVariantList get(const QString &query);

    Q_INVOKABLE bool tagExists(const QString &tag, const bool &strict = false);

    /* INSERTIIONS */

    Q_INVOKABLE bool tag(const QString &tag, const QString &color=QString(), const QString &comment=QString());
    Q_INVOKABLE bool tagUrl(const QString &url, const QString &tag, const QString &color=QString(), const QString &comment=QString());
    Q_INVOKABLE bool tagAbstract(const QString &tag, const QString &key, const QString &lot, const QString &color = QString(), const QString &comment=QString());

    /* UPDATES */

    Q_INVOKABLE bool updateUrlTags(const QString &url, const QStringList &tags);

    /* QUERIES */

    Q_INVOKABLE QVariantList getUrlsTags(const bool &strict = true);
    Q_INVOKABLE QVariantList getAbstractsTags(const bool &strict = true);
    Q_INVOKABLE QVariantList getAllTags(const bool &strict = true);
    Q_INVOKABLE QVariantList getUrls(const QString &tag, const bool &strict = true);
    Q_INVOKABLE QVariantList getUrlTags(const QString &url, const bool &strict = true);
    Q_INVOKABLE QVariantList getAbstractTags(const QString &key, const QString &lot, const bool &strict = true);

    /* DELETES */
    Q_INVOKABLE bool removeUrlTags(const QString &url);

    /*STATIC METHODS*/

    static QString mac();
    static QString device();
    static QString id();

private:
    Tagging(const QString &app, const QString &version, const QString &uri, const QString &comment = QString(), QObject *parent = nullptr);
    ~Tagging();
    static Tagging* instance;
    void setApp(const QString &app, const QString &uri, const QString &version, const QString &comment = QString());

    QString application = QString();
    QString version = QString();
    QString comment = QString();
    QString uri = QString();

    bool app();
    bool user();

protected:
    bool abstract(const QString &key, const QString &lot, const QString &comment);

signals:
    void urlTagged(const QString &url, const QString &tag);
    void abstractTagged(const QString &key, const QString &lot, const QString &tag);
    void tagged(const QString &tag);

public slots:
};

#endif // TAGGING_H
