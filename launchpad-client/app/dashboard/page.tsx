// app/dashboard/page.tsx
"use client";

import { useDbUser } from "@/contexts/UserContext";
import { useApi } from "@/hooks/useApi";
import { useSocket } from "@/hooks/useSocket";
import { RoleGate } from "@/components/RoleGate";
import { UserButton } from "@clerk/nextjs";

import { useEffect, useState } from "react";

export default function DashboardPage() {
  const { connection, connected } = useSocket();

  const [users, setUsers] = useState({});

  useEffect(() => {
    if (!connection) return;

    connection.on("UserData", (data) => {
      console.log(data);
      setUsers(data);
    });
  }, [connection]);

  return (
    <div>
      <h1>Hello</h1>
      <RoleGate allowed="Scrum Leader">
        <section>
          <h2>Sprint Management</h2>
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
