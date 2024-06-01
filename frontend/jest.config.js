module.exports = {
  testEnvironment: "jest-environment-jsdom",
  testEnvironmentOptions: {
    "customExportConditions": ["node", "node-addons"]
  },
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/src/$1",
    "^~/(.*)$": "<rootDir>/src/$1",
    "\\.(jpg|ico|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$": "<rootDir>/mock/fileMock.js",
    "\\.(css|less)$": "<rootDir>/mock/fileMock.js"
  },
  testRegex: ".spec.js$",
  moduleFileExtensions: [
        "js",
        "json",
        "vue"
      ],
      transform: {
        // vue-jest で *.vue ファイルを処理する
        '.*\\.(vue)$': '@vue/vue3-jest',
        '^.+\\.js?$': 'babel-jest'
      },
  }
