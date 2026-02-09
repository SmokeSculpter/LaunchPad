'use client'

import { SignOutButton, useAuth, UserButton } from "@clerk/nextjs";

import { Box, TextField, CircularProgress, Divider, Skeleton } from "@mui/material";
import {
    SpeedOutlined, 
    RocketLaunch, 
    Menu, 
    DeveloperBoardOutlined, 
    AssignmentIndOutlined, 
    AssignmentLateOutlined,
    DirectionsRunOutlined,
    PostAddOutlined
} from '@mui/icons-material';

import { RoleGate } from "./RoleGate";

import NavItem from "./NavItem";
import { usePathname } from "next/navigation";
import { useState } from "react";

export default function Nav({ children }: { children: React.ReactNode }) {
    const page = usePathname();
    const [menu, setMenu] = useState(true);

  return (
    <>
        <header>
            <div className="bg-white w-full flex-v-c">
                <Box className=" h-20 p-4 flex-v-c">
                    <RocketLaunch fontSize="large" className="text-(--purple)"/>
                    <h1 className="mx-2 text-2xl font-bold">LAUNCH PAD</h1>
                </Box>
                <div onClick={() => setMenu(prev => !prev)} className="p-1 group rounded-md bg-(--purple)/15 hover:bg-(--purple)/70 transition-colors cursor-pointer">
                    <Menu fontSize="medium" className="group-hover:text-white text-(--purple) transition-colors"/>
                </div>
                <Box className="mx-2.5 flex-v-c justify-between relative">
                    <TextField variant="outlined" label="Search" />
                    <div className="flex-v-c fixed right-4">
                        <UserButton fallback={<CircularProgress/>} appearance={{elements: {userButtonPopoverActionButton__manageAccount: { display: "none" }}}}/>
                    </div>
                </Box>
            </div>
        </header>
        <main className="bg-white w-full h-[calc(100dvh-5rem)] flex relative">
            <div className={`h-full bg-white w-1/8 p-4 pr-0 fixed transition-all ${menu ? "" : "-left-full"}`}>
                <h2 className="text-md text-gray-600 font-medium mb-2">Dashboard</h2>
                <NavItem page={page == "/"} href="/" Icon={SpeedOutlined}>
                    Dashboard
                </NavItem>
                <Divider className="my-4"/>
                <h2 className="text-md text-gray-600 font-medium mb-2">Pages</h2>
                <Divider className="my-4"/>
                <NavItem page={page == "scrum"} href="/" Icon={DeveloperBoardOutlined}>
                    Scrumboard
                </NavItem>
                <RoleGate fallback={<Skeleton width={"100%"} height={"60px"}/>} allowed={["QA", "Developer"]}>
                    <NavItem page={page == "scrum"} href="/" Icon={AssignmentIndOutlined}>
                        Your Tickets
                    </NavItem>
                </RoleGate>
                <NavItem page={page == "scrum"} href="/" Icon={AssignmentLateOutlined}>
                    Backlog
                </NavItem>
                <RoleGate fallback={<Skeleton width={"100%"} height={"60px"}/>} allowed={"Scrum Leader"}>
                    <NavItem page={page == "scrum"} href="/" Icon={DirectionsRunOutlined}>
                        Create Sprint
                    </NavItem>
                </RoleGate>
                <RoleGate fallback={<Skeleton width={"100%"} height={"60px"}/>} allowed={"Scrum Leader"}>
                    <NavItem page={page == "scrum"} href="/" Icon={PostAddOutlined}>
                        Create Ticket
                    </NavItem>
                </RoleGate>
            </div>
            <div className={`p-6 pt-4 rounded-md bg-white h-full absolute ${menu ? "w-7/8 left-1/8" : "w-full"}`}>
                <div className="w-full p-4 rounded-md h-full bg-(--foreground)">
                    { children }
                </div>
            </div>
        </main>
    </>
  );
}
