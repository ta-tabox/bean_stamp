document.addEventListener("turbolinks:load", function () {
  const hamburgerBtn = document.getElementById("hamburger-btn");
  hamburgerBtn.onclick = function () {
    document.querySelector("body").classList.toggle("drawer-open");
    document.getElementById("drawer-open-btn").classList.toggle("hidden");
    document.getElementById("drawer-close-btn").classList.toggle("hidden");
  };
});
