import { Box } from "@mui/material";

import Link from 'next/link'

export default function NavItem({ children, Icon, href, page }: { children: React.ReactNode, Icon: any, href: string, page: boolean }) {
    return (
        <Link className={`my-3 group flex-v-c p-2.5 transition-colors w-full rounded ${page ? "bg-(--purple)/15" : "hover:bg-(--purple)/15"}`} href={href}>
            {<Icon className={`transition-colors ${page ? "text-(--purple)" : "text-gray-600 group-hover:text-(--purple)"}`} fontSize="small"/>}
            <p className={`text-sm ml-2 transition-colors font-medium ${page ? "text-(--purple)" : "text-gray-600 group-hover:text-(--purple)"}`}>{children}</p>
        </Link>
    )
};