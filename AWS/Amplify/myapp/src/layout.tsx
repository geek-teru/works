'use client'

import React from 'react'
import { ThemeProvider } from '@aws-amplify/ui-react-core'
import '@aws-amplify/ui-react/styles.css'

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ja">
      <body>
        <ThemeProvider>{children}</ThemeProvider>
      </body>
    </html>
  )
}