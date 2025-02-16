'use client'

import React from 'react'
import { View, Text, Button } from '@aws-amplify/ui-react'

interface HeaderProps {
  username?: string
  onSignOut?: () => void
}

export function Header({ username, onSignOut }: HeaderProps) {
  return (
    <View
      backgroundColor="white"
      padding="1rem"
      boxShadow="0 2px 4px rgba(0,0,0,0.1)"
      position="fixed"
      width="100%"
      zIndex={100}
    >
      <View
        display="flex"
        justifyContent="space-between"
        alignItems="center"
        width="100%"
      >
        <Text
          fontSize="1.5rem"
          fontWeight="bold"
          marginLeft="1rem"
        >
          MyApp
        </Text>
        <View 
          display="flex" 
          alignItems="center" 
          gap="1rem"
          marginRight="2rem"
        >
          <Text>ようこそ {username} さん</Text>
          {onSignOut && (
            <Button onClick={onSignOut}>
              サインアウト
            </Button>
          )}
        </View>
      </View>
    </View>
  )
} 