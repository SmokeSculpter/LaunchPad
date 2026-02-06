import { useEffect, useRef, useState } from "react";
import { useAuth } from "@clerk/nextjs";
import { 
    HubConnection,
    HubConnectionBuilder,
    LogLevel,
    HubConnectionState
 } from "@microsoft/signalr";

export const useSocket = () => {
    const { getToken } = useAuth();
    const connectionRef = useRef<HubConnection | null>(null);
    const [connected, setConnected] = useState(false);

    useEffect(() => {
        const connection = new HubConnectionBuilder()
            .withUrl(`${process.env.NEXT_PUBLIC_API_URL}/data`, {
                accessTokenFactory: async () => {
                    const token = await getToken();
                    return token ?? "";
                }
            })
            .withAutomaticReconnect()
            .configureLogging(LogLevel.Information)
            .build();

            connectionRef.current = connection;

            connection.onreconnecting(() => {
                console.log("Reconnecting to socket...")
                setConnected(false);
            });

            connection.onreconnected(() => {
                console.log("Reconnected.");
                setConnected(true);
            })

            connection.onclose(() => {
                console.log("Disconnected from socket.");
                setConnected(false);
            });

            connection.start()
                .then(() => {
                    console.log("Connected to socket");
                    setConnected(true);
                })
                .catch(err => console.error("Failed to connect to socket", err));

            return () => {
                if (connection.state !== HubConnectionState.Disconnected) {
                    connection.stop();
                }
            }
    }, [getToken])

    return { connection: connectionRef.current, connected };
};