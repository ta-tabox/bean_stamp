// プレビューを表示する
function previewFile(file) {
  const preview = document.getElementById("preview");
  const reader = new FileReader();

  // ファイルが読み込まれたときpreview要素をセットする
  reader.onload = function (e) {
    const imageUrl = e.target.result;
    const img = document.createElement("img");
    img.src = imageUrl;
    preview.appendChild(img);
  };

  reader.readAsDataURL(file);
}

// <input>でファイルが選択されたときの処理
document.addEventListener("turbolinks:load", function () {
  const inputImage = document.querySelector("#input-image");
  if (inputImage != null) {
    inputImage.addEventListener("change", (e) => {
      const preview = document.getElementById("preview");
      while (preview.firstChild) {
        preview.removeChild(preview.firstChild);
      }

      //4枚以上の画像投稿をキャンセルする
      if (inputImage.files.length > 4) {
        alert("画像は最大4枚まで投稿できます");
        inputImage.value = null;
        return false;
      }

      const files = inputImage.files;

      // 5MB以上の画像をキャンセルし、それ以下ならpreviewFileを実行する
      for (let i = 0; i < files.length; i++) {
        var size_in_megabytes = files[i].size / 1024 / 1024;
        if (size_in_megabytes > 5) {
          alert(
            "画像は最大5MBのサイズまで投稿できます. ５MBより小さいファイルを選択してください."
          );
          inputImage.value = null;
          return false;
        }
        previewFile(files[i]);
      }
    });
  }
});
