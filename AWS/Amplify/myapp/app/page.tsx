'use client'

import React from 'react'
import { Authenticator, View } from '@aws-amplify/ui-react'
import '@aws-amplify/ui-react/styles.css'
import { Amplify } from 'aws-amplify'
import { Header } from './components/Header'
import { Navigation } from './components/Navigation'
import { API } from 'aws-amplify'
import { Auth } from 'aws-amplify'

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

// API呼び出し例
const callApi = async () => {
  try {
    const response = await API.get('MyApi', '/path', {
      headers: {
        Authorization: `Bearer ${(await Auth.currentSession()).getIdToken().getJwtToken()}`
      }
    })
    console.log(response)
  } catch (error) {
    console.error('Error calling API:', error)
  }
}

export default function Home() {
  const handleFormSubmit = (formData: any) => {
    console.log('Form data:', formData)
  }

  return (
    <Authenticator>
      {({ signOut, user }) => (
        <View>
          <Header 
            username={user?.username}
            onSignOut={signOut}
          />
          <View 
            display="flex"
            paddingTop="64px"
          >
            <Navigation onFormSubmit={handleFormSubmit} />
            <View 
              flex="1"
              padding="2rem"
              backgroundColor="#f5f5f5"
              height="calc(100vh - 64px)"
            >
              {/* メインコンテンツはここに追加 */}
            </View>
          </View>
        </View>
      )}
    </Authenticator>
  )
}