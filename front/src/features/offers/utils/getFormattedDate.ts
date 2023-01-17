export const getFormattedDate = (strDate: string): string => {
  const rowDate = new Date(strDate)
  const [year, month, date] = [rowDate.getFullYear(), rowDate.getMonth(), rowDate.getDate()]
  return `${year}年 ${month + 1}月 ${date}日`
}
