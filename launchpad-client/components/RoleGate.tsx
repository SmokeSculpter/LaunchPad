"use client";

import { useDbUser } from "@/contexts/UserContext";

type RoleGateProps = {
    allowed: string | string[];
    fallback?: React.ReactNode;
    children: React.ReactNode;
}

// Renders children based on roles. We can specify multiple roles based on component.
export function RoleGate({ allowed, fallback = null, children }: RoleGateProps) {
    const { userDb, loading } = useDbUser();

    if (loading) return null;

    const roles = Array.isArray(allowed) ? allowed : [allowed];

    if (!userDb?.role || !roles.includes(userDb?.role)) return <>{fallback}</>;

    return <>{children}</>
}