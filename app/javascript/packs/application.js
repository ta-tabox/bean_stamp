// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import Chart from "chart.js/auto";
import "channels";
// JavaScriptファイルの読み込み
import "../shared/input_image_preview";
import "../shared/pagy.js.erb";
import "../shared/swiper";
import "../shared/tab";
import "../shared/hamburger";
import "rails_admin/src/rails_admin/base";
// cssファイルの読み込み
import "../stylesheets/rails_admin";
import "../css/application.css";
const images = require.context("../images", true);
const imagePath = (name) => images(name, true);

Rails.start();
Turbolinks.start();
ActiveStorage.start();
global.Chart = Chart;
