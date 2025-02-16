'use client'

import React from 'react'
import { Authenticator } from '@aws-amplify/ui-react'
import '@aws-amplify/ui-react/styles.css'
import { Amplify } from 'aws-amplify'
import { UserInfoForm } from './components/UserInfoForm'

// Cognitoの設定
Amplify.configure({
  Auth: {
    Cognito: {
      userPoolId: 'ap-northeast-1_ijuswjeBV',
      userPoolClientId: '74l4cdlth071eso5cqh4vvdroa',
      loginWith: {
        oauth: {
          domain: 'example-app-domain.auth.ap-northeast-1.amazoncognito.com',
          scopes: ['email', 'openid', 'profile'],
          redirectSignIn: ['http://localhost:3000/'],
          redirectSignOut: ['http://localhost:3000/'],
          responseType: 'code'
        }
      }
    }
  }
})

export default function Home() {
  const handleFormSubmit = (formData: any) => {
    console.log('Form data:', formData)
  }

  return (
    <Authenticator>
      {({ signOut, user }) => (
        <div>
          <h1>MyApp {user?.username}</h1>
          <UserInfoForm onSubmit={handleFormSubmit} />
          <button onClick={signOut}>サインアウト</button>
          
          {/* ここにTodoリストなどのメインコンテンツを追加 */}
        </div>
      )}
    </Authenticator>
  )
}