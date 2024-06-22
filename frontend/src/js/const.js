export const PasswordType = {
    password: 1,
    passwordConfirm: 2,
    newPassword: 3,
    newPasswordConfirm: 4
}

export const HeaderMenuList = [
    { id: 1, label: "会員登録・ログイン", status: 2 },
    { id: 2, label: "マイページ", status: 1 },
    { id: 3, label: "設定", status: 1 },
    { id: 4, label: "ログアウト", status: 1 },
    { id: 5, label: "問い合わせ", status: 3 }
];

export const AccountStatusType = {
    shouldLogin: 1,
    unLogin: 2,
    all: 3
}

export const CommentMenuList = [
    { id: 1, label: "編集する" },
    { id: 2, label: "削除" },
];
