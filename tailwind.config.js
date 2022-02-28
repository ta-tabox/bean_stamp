module.exports = {
  purge: ["./app/**/*.html.erb"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      backgroundColor: ["active", "checked"],
      textColor: ["active", "checked"],
      // backgroundColor: ["checked"],
      // textColor: ["checked"],
      opacity: ["disabled"],
    },
  },
  plugins: [],
};
