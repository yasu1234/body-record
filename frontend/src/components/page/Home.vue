<template>
  <Header />
  <TabMenu :currentId="1" />
  <div class="mx-2.5 pb-8">
    <img
      src="../../assets/image/not_found.png"
      alt="ユーザー"
      class="not-found-image"
    />
    <div class="top-explanation mt-5">
      <p class="emphasize-message">In-Body.comへようこそ</p>
      <p class="mt-5">簡単に使い方を説明します</p>
      <p>
        In-Body.comでは<span class="underline-text">記録と共有</span
        >が目的になります
      </p>
    </div>
    <div class="record-add-explanation mt-5">
      <p class="font-bold text-2xl">①まずは自分の体重などの記録を登録します</p>
      <p>メニューの「My記録」から記録を追加ボタンで登録欄が表示されます</p>
      <p>
        対象の日付やその日の体重、体脂肪率、メモと関連する画像を登録できます
      </p>
      <p>対象の日付は登録必須で、それ以外はオプションです</p>
      <p class="mt-2.5">
        体重、体脂肪率を登録した場合にはマイページでグラフとして推移を見ることができます
      </p>
      <p class="mt-2.5">
        公開したくない場合には非公開記録として他のユーザーに公表しないようにできますので、ご安心ください
      </p>
    </div>
    <div class="record-add-explanation mt-5">
      <p class="font-bold text-2xl">②他のユーザーの記録を見る</p>
      <p>
        メニューの「みんなの記録」から他のユーザーの公開されている記録を確認することができます
      </p>
      <p>
        メニューのみんなの記録を選択すると、ユーザーを絞り込めます。<br />対象のユーザーを選択すると、そのユーザーの記録の一覧が表示されます
      </p>
      <p>
        ユーザー名のリンクをクリックすることでユーザーのページを見ることができます
      </p>
      <p class="mt-2.5">
        ユーザーの記録やメモなどを見て、応援したい場合にはサポート機能があります。
      </p>
      <p class="mt-2.5">
        SNSのいいね機能のようなものなので、多くのユーザーを応援しましょう
      </p>
    </div>
    <div class="record-add-explanation mt-5">
      <p class="font-bold text-2xl">③記事を投稿する</p>
      <p>
        健康やフィットネス、筋トレなどボディメーク関連の記事を投稿することができます
      </p>
      <p>
        メニューの「健康・フィットネス記事」を選択すると、登録欄が表示されます
      </p>
      <p>タイトルとコンテンツ、関連画像が登録できます</p>
      <p class="mt-2.5">
        登録された記事にはコメントやブックマークができますので活用してください
      </p>
      <div class="mt-2.5">
        マークダウンを一部使用できます。詳しくは<a
          href="https://kumaapp.amebaownd.com/posts/54283163"
          target="_blank"
          rel="noopener noreferrer"
          class="info-link"
          >こちら</a
        >をご覧ください。<br />
        特に複数行の改行は使うことが多いと思うので必ずご確認ください
      </div>
    </div>
  </div>
</template>

<script setup>
import TabMenu from "../layout/TabMenu.vue";
import Header from "../layout/Header.vue";
</script>

<style scoped>
.not-found-image {
  height: 200px;
  margin: 0px auto;
}
.underline-text {
  text-decoration: underline;
  text-decoration-color: #f58505; /* 下線の色を黒に設定 */
  text-decoration-thickness: 3px; /* 下線の太さを1pxに設定 */
}
.top-explanation {
  text-align: center;
}
.emphasize-message {
  font-weight: bold;
  font-size: 40px;
}
.record-add-explanation {
  text-align: center;
}
.record-add-explanation p {
  line-height: 2;
}
.info-link {
  color: #ffa500;
  text-decoration: underline;
  cursor: pointer;
}
.info-link:hover {
  color: #ffa500;
}
</style>
