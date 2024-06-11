import axios from "axios";
import Cookies from "js-cookie";

const baseURL = import.meta.env.VITE_APP_API_BASE;

const axiosInstance = axios.create({
  baseURL,
  headers: {
    "Content-Type": "application/json",
  },
});

axiosInstance.interceptors.request.use((config) => {
  config.headers["access-token"] = Cookies.get("accessToken");
  config.headers["client"] = Cookies.get("client");
  config.headers["uid"] = Cookies.get("uid");

  return config;
});

const setupInterceptors = (router) => {
  axiosInstance.interceptors.response.use(
    response => response,
    error => {
      // 共通のエラー処理
      if (error.response.status === 404) {
        router.push({ name: 'NotFound' })
      }

      // エラーをキャッチしてreturnする
      return Promise.reject(error)
    }
  )
}

export { axiosInstance, setupInterceptors }
