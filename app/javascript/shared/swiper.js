import Swiper, { Navigation, Pagination } from "swiper";
import "swiper/swiper-bundle.min.js";
import "swiper/swiper-bundle.min.css";

// document.addEventListener("turbolinks:load", function () {
document.addEventListener("DOMContentLoaded", function () {
  const swiper = new Swiper(".mySwiper", {
    // ナビゲーションとページネーション機能の読み込み
    modules: [Navigation, Pagination],
    // Optional parameters

    loop: true,

    // If we need pagination
    pagination: {
      el: ".swiper-pagination",
      dynamicBullets: true,
    },

    // Navigation arrows
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev",
    },

    // And if we need scrollbar
    // scrollbar: {
    //   el: ".swiper-scrollbar",
    // },
  });
});
