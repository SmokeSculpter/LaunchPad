'use client'

import { UserButton } from "@clerk/nextjs";

import { 
    Box, 
    Container, 
    Typography, 
    TextField, 
    CircularProgress, 
    Divider, 
    Skeleton,
    InputAdornment,
    OutlinedInput
} from "@mui/material";

import {
    SpeedOutlined, 
    RocketLaunch, 
    Menu, 
    DeveloperBoardOutlined, 
    AssignmentIndOutlined, 
    AssignmentLateOutlined,
    DirectionsRunOutlined,
    PostAddOutlined,
    Search,
    RocketLaunchRounded
} from '@mui/icons-material';

import { RoleGate } from "../RoleGate";
import NavMenu from "./NavMenu";

import { usePathname } from "next/navigation";
import { useState } from "react";

const Nav = ({ children }: { children: React.ReactNode }) => {
    const [open, setOpen] = useState<boolean>(true);

    return (
        <>
            <header className="bg-white w-full">
                <div className=" h-14 p-4 py-8 flex-v-c max-[800px]:justify-between text-(--purple) relative">
                    <div className="hidden min-[800px]:flex items-center">
                        <RocketLaunchRounded className="mx-2" fontSize="large"/>
                        <Typography className="text-3xl font-bold">
                            LAUNCHPAD
                        </Typography>
                    </div>
                    <div 
                     onClick={() => setOpen(prev => !prev)}
                     className="rounded-md bg-(--purple)/15 p-0.75 relative min-[800px]:ml-2 min-[800px]:mr-6 group hover:bg-(--purple) transition-colors cursor-pointer">
                        <Menu className="group-hover:text-white transition-colors" fontSize="medium"/>
                    </div>
                    <Box className="flex-v-c">
                        <OutlinedInput
                         sx={{maxWidth: {xs: 200, md: 300, lg: 300}}}
                         size="small"
                         placeholder="Search"
                         startAdornment={
                            <InputAdornment position="start">
                                <Search/>
                            </InputAdornment>
                         }
                         endAdornment={
                            <Typography className="text-sm p-1 px-2 rounded-md bg-gray-300 hidden sm:flex">Ctrl+K</Typography>
                         }
                        />
                    </Box>
                    <div className="min-[800px]:absolute min-[800px]:right-6">
                        <UserButton fallback={<Skeleton variant="circular" width={30} height={30} />} appearance={{elements: {userButtonPopoverActionButton__manageAccount: { display: "none" }}}}/>
                    </div>
                </div>
            </header>
            <main className="bg-white px-4 pb-4 flex overflow-x-hidden relative">
                <NavMenu open={open}/>
                <div className={`bg-(--foreground) p-2 min-h-[calc(100dvh-5rem)] flex-1 min-w-0 rounded-md ${open ? "max-[800px]:opacity-0" : "max-[800px]:opacity-100"}`}>
                    {children}
                </div>
            </main>
        </>
    );
}
 
export default Nav;