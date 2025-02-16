'use client'

import React from 'react'
import { View } from '@aws-amplify/ui-react'
import { UserInfoForm } from './UserInfoForm'

interface NavigationProps {
  onFormSubmit: (data: any) => void
}

export function Navigation({ onFormSubmit }: NavigationProps) {
  return (
    <View
      backgroundColor="white"
      width="300px"
      padding="1rem"
      borderRight="1px solid #eee"
      height="calc(100vh - 64px)" // ヘッダーの高さを引く
    >
      <UserInfoForm onSubmit={onFormSubmit} />
    </View>
  )
} 