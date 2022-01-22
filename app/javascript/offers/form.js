// オファー終了日の検証
document.getElementById("offer_ended_at").onchange = function () {
  const endedAt = document.getElementById("offer_ended_at");
  const roastedAt = document.getElementById("offer_roasted_at");
  const dateEndedAt = new Date(endedAt.value);
  const dateRoastedAt = new Date(roastedAt.value);

  if (dateRoastedAt <= dateEndedAt) {
    alert("オファー終了日は焙煎日より前を設定してください");
    endedAt.value = null;
  }
};

//焙煎日の検証
document.getElementById("offer_roasted_at").onchange = function () {
  const endedAt = document.getElementById("offer_ended_at");
  const roastedAt = document.getElementById("offer_roasted_at");
  const receiptStartedAt = document.getElementById("offer_receipt_started_at");
  const dateEndedAt = new Date(endedAt.value);
  const dateRoastedAt = new Date(roastedAt.value);
  const dateReceiptStartedAt = new Date(receiptStartedAt.value);

  if (dateRoastedAt <= dateEndedAt) {
    alert("焙煎日はオファー終了日より後を設定してください");
    roastedAt.value = null;
  } else if (dateReceiptStartedAt <= dateRoastedAt) {
    alert("焙煎日は受け取り開始日より前を設定してください");
    roastedAt.value = null;
  }
};

//受け取り開始日の検証
document.getElementById("offer_receipt_started_at").onchange = function () {
  const roastedAt = document.getElementById("offer_roasted_at");
  const receiptStartedAt = document.getElementById("offer_receipt_started_at");
  const receiptEndedAt = document.getElementById("offer_receipt_ended_at");
  const dateRoastedAt = new Date(roastedAt.value);
  const dateReceiptStartedAt = new Date(receiptStartedAt.value);
  const dateReceiptEndedAt = new Date(receiptEndedAt.value);

  if (dateReceiptStartedAt <= dateRoastedAt) {
    alert("受け取り開始日は焙煎日より後を設定してください");
    receiptStartedAt.value = null;
  } else if (dateReceiptEndedAt <= dateReceiptStartedAt) {
    alert("受け取り開始日は受け取り終了日より前を設定してください");
    receiptStartedAt.value = null;
  }
};

//受け取り終了日の検証
document.getElementById("offer_receipt_ended_at").onchange = function () {
  const receiptStartedAt = document.getElementById("offer_receipt_started_at");
  const receiptEndedAt = document.getElementById("offer_receipt_ended_at");
  const dateReceiptStartedAt = new Date(receiptStartedAt.value);
  const dateReceiptEndedAt = new Date(receiptEndedAt.value);

  if (dateReceiptEndedAt <= dateReceiptStartedAt) {
    alert("受け取り終了日は受け取り開始日より後を設定してください");
    receiptEndedAt.value = null;
  }
};
