// app/dashboard/page.tsx
"use client";

import { useDbUser } from "@/contexts/UserContext";
import { useApi } from "@/hooks/useApi";
import { RoleGate } from "@/components/RoleGate";
import { UserButton } from "@clerk/nextjs";

export default function DashboardPage() {
  const { userDb, loading } = useDbUser();

  if (loading) return <p>Loading...</p>;

  return (
    <div>
      <RoleGate allowed="Scrum Leader">
        <section>
          <h2>Sprint Management</h2>
          <h3>{userDb?.name}</h3>
        </section>
      </RoleGate>

      <RoleGate allowed="Developer">
        <section>
          <h2>My Tickets</h2>
        </section>
      </RoleGate>

      <RoleGate allowed="QA">
        <section>
          <h2>Testing Queue</h2>
        </section>
      </RoleGate>

      <RoleGate allowed={["Scrum Leader", "Developer"]}>
        <section>
          <h2>Code Reviews</h2>
        </section>
      </RoleGate>
    </div>
  );
}
