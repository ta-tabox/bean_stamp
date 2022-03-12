import Swiper, { Navigation, Pagination } from "swiper";
// import "swiper/swiper-bundle.min.js";
import "swiper/swiper-bundle.min.css";

// Tubolinksと併用する場合のイベントバンドラ
document.addEventListener("turbolinks:load", function () {
  // document.addEventListener("DOMContentLoaded", function () {
  const swiper = new Swiper(".swiper", {
    // ナビゲーションとページネーション機能の読み込み
    modules: [Navigation, Pagination],
    // loop: true,

    // If we need pagination
    pagination: {
      el: ".swiper-pagination",
      dynamicBullets: true,
      clickable: true,
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
