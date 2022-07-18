module.exports = {
  purge: ["./app/**/*.html.erb"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      fontFamily: {
        noto: ["Noto Sans JP"],
        notoserif: ["Noto Serif"],
      },
    },
  },
  variants: {
    extend: {
      backgroundColor: ["active", "checked"],
      textColor: ["active", "checked"],
      // backgroundColor: ["checked"],
      // textColor: ["checked"],
      opacity: ["disabled"],
      cursor: ["disabled"],
      borderWidth: ["hover", "focus"],
    },
  },
  plugins: [],
};