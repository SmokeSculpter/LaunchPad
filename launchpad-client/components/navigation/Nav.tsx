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
    Search
} from '@mui/icons-material';

import { RoleGate } from "../RoleGate";
import NavMenu from "./NavMenu";

import ExampleItem from "../ExampleItem";
import { usePathname } from "next/navigation";
import { useState } from "react";

const Nav = ({ children }: { children: React.ReactNode }) => {
    const [open, setOpen] = useState<boolean>(true);

    return (
        <>
            <header className="bg-white w-full flex-v-c">
                <Container className=" h-14 p-4 py-8 flex-v-c  justify-between text-(--purple) relative">
                    <div 
                     onClick={() => setOpen(prev => !prev)}
                     className="rounded-md bg-(--purple)/15 p-0.75">
                        <Menu fontSize="medium"/>
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
                            <Typography className="text-sm p-1 px-2 rounded-md bg-gray-300 hidden sm:flex">Ctrl+K </Typography>
                         }
                        />
                    </Box>
                    <UserButton fallback={<Skeleton variant="circular" width={30} height={30} />} appearance={{elements: {userButtonPopoverActionButton__manageAccount: { display: "none" }}}}/>
                </Container>
            </header>
            <main className="bg-white px-4 pb-4 flex-v-c overflow-x-hidden relative">
                <NavMenu open={open}/>
                <Container className="bg-(--foreground) p-2 min-h-[calc(100dvh-5rem)] min-w-[calc(100dvw-2rem)] rounded-md">
                    {children}
                </Container>
            </main>
        </>
    );
}
 
export default Nav;