// 画像のプレビュー機能
document.addEventListener("turbolinks:load", function () {
  const inputImage = document.querySelector("#input-image");
  if (inputImage === null) {
    return false;
  }

  // <input>でファイルが選択されたときの処理
  inputImage.addEventListener("change", (e) => {
    const preview = document.getElementById("preview");

    while (preview.firstChild) {
      preview.removeChild(preview.firstChild);
    }
    const files = inputImage.files;

    // previewタイトルの表示
    const previewTitle = document.querySelector("#preview-title");
    if (previewTitle === null) {
      const previewTitle = document.createElement("h2");
      previewTitle.textContent = "〜 Preview 〜";
      previewTitle.id = "preview-title";
      previewTitle.classList = "e-font";
      preview.before(previewTitle);
    }

    //4枚以上の画像投稿をキャンセルする
    if (validateMaxImages(files, 4)) {
      inputImage.value = null;
      return false;
    }

    // 5MB以上の画像をキャンセルし、それ以下ならpreviewFileを実行する
    for (let i = 0; i < files.length; i++) {
      if (validateMaxFileSize(files[i], 5)) {
        inputImage.value = null;
        return false;
      }
      previewFile(files[i]);
    }
  });
});

//maxNum以上の画像投稿をキャンセルする
function validateMaxImages(files, maxNum) {
  if (files.length > maxNum) {
    alert(`画像は最大${maxNum}枚まで投稿できます`);
    return true;
  }
}

// ファイルサイズを制限する
function validateMaxFileSize(file, size_mb) {
  var size_in_megabytes = file.size / 1024 / 1024;
  if (size_in_megabytes > size_mb) {
    alert(
      `画像は最大5MBのサイズまで投稿できます. ${size_mb}MBより小さいファイルを選択してください.`
    );
    return true;
  }
}

// プレビューを表示する
function previewFile(file) {
  const preview = document.getElementById("preview");
  const reader = new FileReader();

  // ファイルが読み込まれたときpreview要素をセットする
  reader.onload = function (e) {
    const imageUrl = e.target.result;
    const img = document.createElement("img");
    img.src = imageUrl;
    img.classList.add("image-item");
    preview.appendChild(img);
  };

  reader.readAsDataURL(file);
}
