# [Bean Stamp](https://www.bean-stamp.com/)

## 概要

Bean Stampはコーヒー豆とコーヒー愛好家のマッチングサービスです。
コーヒーロースターは焙煎する予定のコーヒー豆の情報をアプリ上に登録し、それをコーヒー愛好家に向け提案という形で購入者を募集（オファー機能）します。
その提案（オファー）に対してユーザーは購入する意思表示（ウォンツ）をすることで、焙煎豆の先行予約ができるサービスです。
コーヒーロースターにとっては焙煎する前に購入者を募集できるため焙煎豆の廃棄処分をするリスクを減らすことができます。
ユーザーにとっては確実に焙煎したてで鮮度のよい状態の焙煎豆を購入することができます。

### URL: <https://www.bean-stamp.com/>

## サービスのスクリーンショット画像 or GIFアニメ（デモ）

## 背景

私は加工食品メーカーで食品開発を仕事としています。
また、コーヒー好きが高じてコーヒー豆の品質を評価することができる国際資格を取りました。
普段から様々な人にコーヒーを淹れてあげたり紹介したりしている中で、コーヒー豆を買ってきても自分で美味しく淹れれないという意見を多く伺いました。
また、コーヒーロースター（生豆から焙煎豆を焼くお店）からは焙煎豆を大量に廃棄処分をしている話も伺いました。
あまり知られていませんがコーヒーはもともと木になるフルーツで、生豆から焙煎豆に加工した段階で急速に劣化が進みます。
ロースターにより考え方は異なりますが、焙煎豆の賞味期限（美味しく飲めると保証する期間）はおよそ1ヶ月です。
そこで①コーヒー愛好家の買ってきたコーヒーが美味しくない問題と、②ロースターの焙煎した豆を捨てないといけない問題の解決ができないかと考えまいた。

まずロースターはお客様に美味しいコーヒーを届けたいという気持ちと、原料ロスを減らし少しでも利益を上げたいという気持ちで葛藤しています。
美味しいコーヒーを届けるためには多少古くなった焙煎豆は廃棄しなければなりません（問題②）。
一方、利益を確保するために焙煎豆の在庫回転率を下げると消費者に古い豆が渡る可能性があります（問題①につながる）。
そこで焙煎する前の生豆の段階で購入希望者を募ることで、鮮度のよい焙煎豆を確実且つ効率よく消費者に届けることができるサービスを作りたいという考えに至りました。
また、焙煎豆とコーヒー愛好家をマッチングする上で、ロースターとコーヒー愛好家との繋がりも生まれます。
ロースターにとっては、お客様が家庭で美味しくコーヒーを飲めるためのサポートを行うプラットフォームとしても働くようなサービスになれればと考えています。

## 使用言語、環境、テクノロジー

### フロントエンド

* HTML / CSS
* Tailwind CSS
* JavaScript
* Node.js (16.11.1)
* Yarn (パッケージ管理)
* Prettier (コード解析ツール)

### バックエンド

* Ruby (3.0.4)
* Ruby on Rails (6.1.4)
* MySQL (8.0.26)
* RuboCop (テスト)
* Rspec (コード解析ツール)

### インフラ

* AWS [ ECS(Fargate), ECR, VPC, RDS, ALB, S3, ACM, Route53, Lambda, Cloud Front, Cloud Watch ]
* Docker
* Nginx (Webサーバー)
* Puma (アプリケーションサーバー)

### CI/CD

* CircleCI (自動テスト、自動ビルド、自動デプロイ)

### バージョン管理

* Git / GitHub

### 開発環境

* VSCode
* Docker / docker-compose

## ER図

![Beans_app-ER図ver 2](https://user-images.githubusercontent.com/67009309/181001760-297f35b8-0434-44dd-a683-0e58b9324cc7.png)

## インフラ構成図

![Bean Stamp インフラ構成図②](https://user-images.githubusercontent.com/67009309/181001775-c2c63a25-311d-4f10-83de-3607d7e60d3d.png)

## 機能一覧

### ユーザー

* 認証機能(devise)：新規登録、ログイン／ログアウト
* 簡単ログイン機能
* プロフィール編集、画像登録
* ロースターのフォロー機能(Ajax)／フォローしているロースターの一覧表示機能
* ロースターが作成したオファーへ購入希望表明機能 (ウォンツ機能)(Ajax)／ウォンツしているオファーの一覧表示 (オファーのステータスによる絞り込み可能)
* ロースターが作成したオファーのお気に入り登録(Ajax)／お気に入りしたオファーの一覧表示
* コーヒー豆の評価機能
  * コーヒー豆を受け取り、飲んだ後に評価をつけることができる(Ajax)→評価は今後のリコメンド内容に反映される

### ロースター

* ロースター登録機能
* 店舗情報編集、プロフィール画像登録
* ロースターをフォローしてくれているユーザーの一覧表示
* ロースターが登録したコーヒー豆の一覧表示
* ロースターのオファーの一覧表示 (オファーのステータスによる絞り込み可能)
* オファーにウォンツしているユーザーの一覧表示
* ロースターの検索機能 (ransack)

### コーヒー豆

* コーヒー豆の登録、詳細、編集、削除
* 画像登録、カルーセル表示 (swiper)
* 風味の点数登録とレーダーチャートでの表示 (chart.js)

### オファー

* コーヒー豆からオファーを作成、詳細、編集、削除
* オファーのステータス表示(オファー中、ロースト期間、準備中、受け取り期間、受け取り終了)
* オファーの検索機能

### リコメンド

* ユーザーに対してオファーをリコメンドする機能
  * 1段階目: ユーザーと同都道府県のロースターのオファーをリコメンド
  * 2段階目: ユーザーがコーヒー豆を3つ以上評価した後は以下3つの条件を全て満たすオファーをリコメンド
    1. ユーザーと同都道府県のロースター
    2. ユーザーが所属していないロースター
    3. ユーザーが好きな風味を持つコーヒー豆

### その他

* レスポンシブ対応
* ページネーション
* 管理者機能 (rails_admin)

## こだわりポイント

食品開発とコーヒーの資格取得で学んできた風味表現や評価方法を応用し、コーヒー豆のリコメンド機能を実装しました。
ユーザーがまだ言語化できていないような風味の好みを、お薦めとして伝えることで、ユーザーのコーヒーライフをより良いものにできたらと考えています。

## 今後の計画

* フロントエンド(React)とバックエンド(Rails)に分離しSPA化を取り組み中
