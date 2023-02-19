export const regexp = {
  email: /^[A-Za-z0-9]{1}[A-Za-z0-9_.-]*@{1}[A-Za-z0-9_.-]+.[A-Za-z0-9]+$/,
  password: /^[a-zA-Z0-9!-/:-@¥[-`{-~]+$/,
  tel: /^0[0-9]{9,10}$/,
  number: /^[0-9]+(\.[0-9]+)?$/,
}

export const isNumber = (value: string) => {
  const numberRegexp = new RegExp(regexp.number)
  return numberRegexp.test(value)
}
