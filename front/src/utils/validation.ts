import { regexp } from '@/utils/regexp'

export const validation = {
  required: '値を入力してください',
  minLength: (minLength: number) => ({ value: minLength, message: `${minLength}文字以上入力してください` }),
  maxLength: (maxLength: number) => ({ value: maxLength, message: `最大${maxLength}文字以下入力できます` }),
  max: (max: number) => ({ value: max, message: `最大${max}以下まで入力できます` }),
  min: (min: number) => ({ value: min, message: `最大${min}以上から入力できます` }),
  pattern: {
    email: { value: regexp.email, message: 'メールアドレスの形式が正しくありません' },
    password: { value: regexp.password, message: '半角英数記号を入力してください' },
    tel: { value: regexp.tel, message: '電話番号の形式が正しくありません。ハイフンなしの半角数字を入力してください' },
  },
  validate: {
    confirm: (targetValue: unknown, value: unknown, name?: string) =>
      targetValue === value || `${name || '値'}が一致しません`,
    shouldBeAfterDate: (minDate: string, value: unknown, name?: string) => {
      const targetMinDate = new Date(minDate)
      const valueDate = new Date(value as string)
      if (targetMinDate >= valueDate) {
        return `${name || ''}より後の日程を入力してください`
      }
      return true
    },
    shouldBeBeforeDate: (maxDate: string, value: unknown, name?: string) => {
      const targetMaxDate = new Date(maxDate)
      const valueDate = new Date(value as string)
      if (targetMaxDate <= valueDate) {
        return `${name || ''}より前の日程を入力してください`
      }
      return true
    },
  },
}
