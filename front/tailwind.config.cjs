/* @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx}'],

  purge: ['./src/**/*.tsx'],
  darkMode: false,
  theme: {
    extend: {
      fontFamily: {
        noto: ['Noto Sans JP'],
        notoserif: ['Noto Serif'],
      },
    },
  },
  variants: {
    extend: {
      backgroundColor: ['active', 'checked'],
      textColor: ['active', 'checked'],
      opacity: ['disabled'],
      cursor: ['disabled'],
      borderWidth: ['hover', 'focus'],
    },
  },
  plugins: [],
}
