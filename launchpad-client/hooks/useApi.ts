'use client'

import { useAuth } from "@clerk/nextjs";

// Custom hook that returns a fetch function with Clerk auth token attached.
export function useApi() {
    const { getToken } = useAuth();

    async function fetchApi<T>(endpoint: string, method: "GET" | "PUT" | "POST", body?: Record<string, unknown>): Promise<T> {
        const token = await getToken();

        const response = await fetch(
            `${process.env.NEXT_PUBLIC_API_URL}/api/${endpoint}`,
            {
                method: method,
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json"
                },
                body: body ? JSON.stringify(body) : undefined
            });

        if (response.status != 200) {
            console.log(`${process.env.BACK_END_API_REST}/${endpoint}`);
            throw new Error("Authorization failed!");
        }

        return response.json();
    }

    return { fetchApi };
}