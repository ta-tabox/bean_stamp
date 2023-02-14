type Option<T> = {
  array: Array<T>
  selectCount?: number
}

export const randomSelectFromArray = <T>({ array, selectCount = 1 }: Option<T>) => {
  // NOTE array.spliceでエラーが出るため、引数で得たarrayを一度展開する Error: Cannot assign to read only property
  // 受け取ったarrayはreactのstateで管理しているためこのような挙動になると考えられる
  const rowArray = [...array]
  const selectedItems = []

  for (let i = 0; i < selectCount; i += 1) {
    const randomIndex = Math.floor(Math.random() * rowArray.length)
    if (typeof rowArray[randomIndex] !== 'undefined') {
      // selectedItemsにrowArrayから要素を取り出す
      selectedItems.push(rowArray[randomIndex])
      // 取り出した要素を削除する
      rowArray.splice(randomIndex, 1)
    }
  }

  return selectedItems
}
