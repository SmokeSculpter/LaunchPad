import { Box } from "@mui/material";

const NavMenuItem = ({ children, page }: { children: React.ReactNode, page: boolean }) => {
    
    return (
        <Box className={`${page ? "text-(--purple) bg-(--purple)/15 justify-center" : "bg-gray-500/15"} flex-v-c p-2 w-full bg-(--purple)/15 rounded-md`}>
            {children}
        </Box>
     );
}
 
export default NavMenuItem;