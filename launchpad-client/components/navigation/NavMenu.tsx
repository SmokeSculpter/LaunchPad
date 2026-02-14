import { Box, Stack, Typography, Skeleton } from "@mui/material";
import { SpeedOutlined, DeveloperBoardOutlined, AssignmentIndOutlined, AssignmentLateOutlined, DirectionsRunOutlined, PostAddOutlined } from "@mui/icons-material";

import NavMenuItem from "./NavItem";
import { RoleGate } from "../RoleGate";

import { usePathname } from "next/navigation";

const NavMenu = ({open}: {open: boolean}) => {
    const page = usePathname();

    return ( 
        <div
         className={`min-h-[calc(100dvh-5rem)] transition-all duration-500 shrink-0 ${open ? "max-[800px]:min-w-[calc(100dvw-2rem)] min-[800px]:w-68 p-2 mr-4" : "w-0 min-w-0 p-0 m-0 overflow-hidden"}`}>
            <Box className={`${open ? "delay-500" : "opacity-0"} duration-200 transition-opacity flex-v-c flex-col text-gray-600 w-full`}>
                <Stack spacing={2} className="w-full">
                    <NavMenuItem page={page == "/"}>
                        <SpeedOutlined className="mr-2 group-hover:text-white transition-colors" fontSize="medium"/>
                        <Typography className="group-hover:text-white transition-colors">Dashboard</Typography>
                    </NavMenuItem>
                    <NavMenuItem page={page == "scrum"}>
                        <DeveloperBoardOutlined className="mr-2 group-hover:text-white transition-colors" fontSize="medium"/>
                        <Typography className="group-hover:text-white transition-colors">Scrumboard</Typography>
                    </NavMenuItem>
                    <RoleGate allowed={["QA", "Developer"]} fallback={<Skeleton width={"100%"} height={"65px"}/>}>
                        <NavMenuItem page={page == "tickets"}>
                            <AssignmentIndOutlined className="mr-2 group-hover:text-white transition-colors" fontSize="medium"/>
                            <Typography className="group-hover:text-white transition-colors">Your Tickets</Typography>
                        </NavMenuItem>
                    </RoleGate>
                    <NavMenuItem page={page == "backlog"}>
                        <AssignmentLateOutlined className="mr-2 group-hover:text-white transition-colors" fontSize="medium"/>
                        <Typography className="group-hover:text-white transition-colors">Backlog</Typography>
                    </NavMenuItem>
                    <RoleGate allowed={"Scrum Leader"} fallback={<Skeleton width={"100%"} height={"65px"}/>}>
                        <NavMenuItem page={page == "sprint"}>
                            <DirectionsRunOutlined className="mr-2 group-hover:text-white transition-colors" fontSize="medium"/>
                            <Typography className="group-hover:text-white transition-colors">Create Sprint</Typography>
                        </NavMenuItem>
                    </RoleGate>
                    <RoleGate allowed={"Scrum Leader"} fallback={<Skeleton width={"100%"} height={"65px"}/>}>
                        <NavMenuItem page={page == "ticket"}>
                            <PostAddOutlined className="mr-2 group-hover:text-white transition-colors" fontSize="medium"/>
                            <Typography className="group-hover:text-white transition-colors">Create Ticket</Typography>
                        </NavMenuItem>
                    </RoleGate>
                </Stack>
            </Box>
        </div>
     );
}
 
export default NavMenu;