module libinformer;

import std.socket;
import bmessage;
import std.json;
import std.string;
import std.stdio;

public final class BesterInformerClient
{
    /* The informer socket */
    private Socket informerSocket;

    this(string socketPath)
    {
        try
        {
            informerSocket = new Socket(AddressFamily.UNIX, SocketType.STREAM);
            informerSocket.connect(new UnixAddress(socketPath));
        }
        catch(AddressException e)
        {

        }
        catch(SocketException e)
        {

        }
    }

    public JSONValue getServerInfo()
    {
        /* The server info */
        JSONValue serverInfo;

        JSONValue message;

        JSONValue commandBlock;
        commandBlock["type"] = "serverInfo";

        message["command"] = commandBlock;

        sendMessage(informerSocket, message);

        JSONValue response;
        receiveMessage(informerSocket, response);

        serverInfo = response["data"];

        /* TODO: Implement me */
        return serverInfo;
    }

    public bool isClient(string username)
    {
        /* TODO: Implement me */
        return true;
    }

    public string[] getClients()
    {
        string[] clientList;

        JSONValue message;

        JSONValue commandBlock;
        commandBlock["type"] = "listClients";

        message["command"] = commandBlock;

        sendMessage(informerSocket, message);

        JSONValue response;
        receiveMessage(informerSocket, response);
        
        string statusCode = response["status"].str();

        if(cmp(statusCode, "0") == 0)
        {
            JSONValue[] clientListJSON = response["data"].array();
            for(ulong i = 0; i < clientListJSON.length; i++)
            {
                clientList ~= clientListJSON[i].str();
            }
        }
        else
        {
            /* error */
        }

        return clientList;
    }
}