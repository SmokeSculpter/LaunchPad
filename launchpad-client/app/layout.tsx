import type { Metadata } from 'next'

import { ClerkProvider } from '@clerk/nextjs'
import { UserProvider } from '@/contexts/UserContext'

import './globals.css'

import { AppRouterCacheProvider } from '@mui/material-nextjs/v16-appRouter';

import { Roboto } from 'next/font/google';
import { ThemeProvider } from '@mui/material/styles';
import theme from '../theme';

const roboto = Roboto({
  weight: ['300', '400', '500', '700'],
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-roboto',
});

export const metadata: Metadata = {
  title: 'LaunchPad',
  description: 'A project management application',
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <ClerkProvider>
      <html lang="en" className={roboto.variable}>
        <body className={``}>
          <AppRouterCacheProvider options={{ enableCssLayer: true }}>
            <ThemeProvider theme={theme}>
              <UserProvider>
              {children}
              </UserProvider>
            </ThemeProvider>
          </AppRouterCacheProvider>
          </body>
        </html>
      </ClerkProvider>
      )
}