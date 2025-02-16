'use client'

import React, { useState } from 'react'
import { SelectField, TextField } from '@aws-amplify/ui-react'

interface UserFormData {
  name: string
  gender: string
  age: string
  prefecture: string
}

interface UserInfoFormProps {
  onSubmit: (data: UserFormData) => void
}

export function UserInfoForm({ onSubmit }: UserInfoFormProps) {
  const [formData, setFormData] = useState<UserFormData>({
    name: '',
    gender: '',
    age: '',
    prefecture: ''
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} style={{ maxWidth: '400px', margin: '20px' }}>
      <TextField
        label="名前"
        value={formData.name}
        onChange={e => setFormData({...formData, name: e.target.value})}
        required
      />
      <SelectField
        label="性別"
        value={formData.gender}
        onChange={e => setFormData({...formData, gender: e.target.value})}
        required
      >
        <option value="">選択してください</option>
        <option value="male">男性</option>
        <option value="female">女性</option>
        <option value="other">その他</option>
      </SelectField>
      <TextField
        label="年齢"
        type="number"
        value={formData.age}
        onChange={e => setFormData({...formData, age: e.target.value})}
        required
      />
      <SelectField
        label="都道府県"
        value={formData.prefecture}
        onChange={e => setFormData({...formData, prefecture: e.target.value})}
        required
      >
        <option value="">選択してください</option>
        <option value="tokyo">東京都</option>
        <option value="osaka">大阪府</option>
        <option value="hokkaido">北海道</option>
      </SelectField>
      <button type="submit" style={{ marginTop: '20px' }}>送信</button>
    </form>
  )
} 