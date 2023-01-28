export const formattedToJaDate = (strDate: string): string => {
  const rowDate = new Date(strDate)
  const [year, month, date] = [rowDate.getFullYear(), rowDate.getMonth(), rowDate.getDate()]
  return `${year}年 ${month + 1}月 ${date}日`
}

const formattedDate = (date: Date) => {
  const formatted = date
    .toLocaleDateString('ja-JP', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    })
    .split('/')
    .join('-')
  return formatted
}

export const getToday = () => {
  const now = new Date()
  const formattedToday = formattedDate(now)
  return formattedToday
}

type GetNextMonthToDate = {
  next: number
}
export const getNextMonthToday = ({ next }: GetNextMonthToDate) => {
  const now = new Date()
  const nextMonthDate = new Date(now.getFullYear(), now.getMonth() + next, now.getDate())
  const formattedNextMonthDate = formattedDate(nextMonthDate)
  return formattedNextMonthDate
}
