/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        poppins: ['Poppins', 'sans-serif'],
        bangers: ['"Bangers"', 'cursive'],
        windsong: ['"WindSong"', 'cursive'],
      },
      colors: {
        Black: '#1E1F22',
        LightGray: '#A7AAAD',
        MediumGray: '#313338',
        InputBgGray: '#2E3035',
        InputBgGray2: '#4e5159',
        bgButtonGray: '#2B2D31',
        whiteBg: '#1B2C3C',
        bluePurple: '#546FFF',   
        bluePurpleHover: '#425ADB',
        Line: '#464646',   
      }
    },
  },
  plugins: [],
}