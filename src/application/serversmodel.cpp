/*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU General Public License as published by  *
*   the Free Software Foundation version 2 of the License.                *
*                                                                         *
*   This program is distributed in the hope that it will be useful,       *
*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*   GNU General Public License for more details.                          *
*                                                                         *
*   You should have received a copy of the GNU General Public License     *
*   along with this program; if not, write to the                         *
*   Free Software Foundation, Inc.,                                       *
*   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.          *
***************************************************************************/

#include "serversmodel.h"

#include "setting.h"

#include <QJsonObject>

ServersModel::ServersModel(QObject *parent)
    :QAbstractListModel(parent)
{
}

ServersModel::~ServersModel()
{

}

int ServersModel::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return mServers.count();
    return 0;
}

QVariant ServersModel::data(const QModelIndex &index, int role) const
{
    QVariant retval;

    if (index.row() >= 0 && index.row() < mServers.size()) {
        AServer server = mServers.at(index.row());
        switch (role) {
        case nameRole:
            retval = server.name;
            break;

        case isoRole:
            retval = server.isoCode;
            break;

        case loadRole:
            retval = server.load;
            break;

        case portsRole:
            retval = server.ports;
            break;

        case xorPortsRole:
//            retval = server.xorPorts;
            break;

        case ipRole:
            retval = server.ip;
            break;

        case hostnameRole:
            retval = server.address;
            break;
        }
    }

    return retval;
}

QHash<int, QByteArray> ServersModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[nameRole] = "name";
    roles[isoRole] = "iso";
    roles[hostnameRole] = "hostname";
    roles[ipRole] = "ip";
    roles[portsRole] = "ports";
    roles[xorPortsRole] = "xorports";
    roles[favoriteRole] = "favorite";
    roles[loadRole] = "load";

    return roles;
}

void ServersModel::updateServers(const QJsonArray &servers)
{
    beginResetModel();

    QStringList tlsPortsList;
    QList<int> tlsPortNumbersList;

    QStringList xorPortsList;
    QList<int> xorPortNumbersList;

    Q_FOREACH(const QJsonValue &server, servers) {
        AServer newServer;
        newServer.ip = server.toObject().value("ip").toString();
        newServer.name = server.toObject().value("name").toString();
        newServer.address = server.toObject().value("hostname").toString();
        newServer.isoCode = server.toObject().value("iso_code").toString();
        QString portsString = server.toObject().value("ports").toString();
        QStringList portsList = portsString.split(", ");
        Q_FOREACH(const QString &port, portsList) {
            int portNumber = port.toInt();
            newServer.ports << portNumber;
            if (!tlsPortNumbersList.contains(portNumber)) {
                tlsPortsList << QString("TCP %1").arg(port) << QString("UDP %1").arg(port);
                tlsPortNumbersList << portNumber << portNumber;
            }
        }

        QString xorPortsString = server.toObject().value("ports_xor").toString();
        portsList = xorPortsString.split(", ");
        Q_FOREACH(const QString &port, portsList) {
            int portNumber = port.toInt();
            newServer.xorPorts << portNumber;
            if (!xorPortNumbersList.contains(portNumber)) {
                xorPortsList << QString("TCP %1").arg(port) << QString("UDP %1").arg(port);
                xorPortNumbersList << portNumber << portNumber;
            }
        }
        newServer.load = server.toObject().value("serverload").toString().toInt();
        // TODO: Load if this server is a favorite from settings
        newServer.favorite = false;
        mServers.append(newServer);
    }

    Setting::instance()->setEncryptionPorts(ENCRYPTION_TLSCRYPT, tlsPortsList, tlsPortNumbersList);
    Setting::instance()->setEncryptionPorts(ENCRYPTION_TLSCRYPT_XOR, xorPortsList, xorPortNumbersList);

    endResetModel();
}

AServer ServersModel::server(int index)
{
    if (index >= 0 && index < mServers.size())
        return mServers.at(index);

    return AServer();
}

int ServersModel::count()
{
    return mServers.count();
}