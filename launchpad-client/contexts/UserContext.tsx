"use client"

import { createContext, useContext, useEffect, useState } from "react"
import { useApi } from "@/hooks/useApi"
import { useAuth, useUser } from "@clerk/nextjs";

type UserData = {
    userId: number,
    name: string,
    role: string
}

type UserContext = {
    userDb: UserData | null,
    loading: boolean
}

// Create user context that we wrap components in.
const UserContext = createContext<UserContext>({ userDb: null, loading: true });

export const UserProvider = ({ children }: { children: React.ReactNode }) => {
    const { isSignedIn } = useAuth();

    const [userDb, setUser] = useState<UserData | null>(null);
    const [loading, setLoading] = useState<boolean>(true);

    const { user } = useUser();

    const { fetchApi } = useApi();

    useEffect(() => {
        if (!isSignedIn || !user?.publicMetadata?.id) {
            return;
        }

        const fetchUser = async () => {
            try{
                const data = await fetchApi<UserData>(`user/${user.publicMetadata.id}`, "GET");
                setUser(data);
            }
            catch (err){
                console.error("Failed to fetch user:", err);
            }
            finally{
                setLoading(false);
            }
        }

        fetchUser();
    }, [isSignedIn, user]);

    return(
        <UserContext.Provider value={{ userDb, loading }}>
            {children}
        </UserContext.Provider>
    )
}

// How we access user data in children componenets.
export const useDbUser = () => useContext(UserContext);