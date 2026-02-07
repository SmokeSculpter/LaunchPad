import type { Metadata } from 'next'

import { ClerkProvider } from '@clerk/nextjs'

import { UserProvider } from '@/contexts/UserContext'

import './globals.css'

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
      <html lang="en">
        <body className={``}>
              {children}
          </body>
        </html>
      </ClerkProvider>
      )
}