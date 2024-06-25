import { shallowMount } from "@vue/test-utils";
import MyPage from "@/components/page/user/MyPage.vue";

jest.mock("axios");
jest.mock("vue-router", () => {
  const router = {
    push: jest.fn(),
    pathname: "/",
    route: "",
    asPath: "",

    events: {
      on: jest.fn(),
      off: jest.fn(),
      emit: jest.fn(),
    },
    onBeforeRouteUpdate: jest.fn(),
  };
  return {
    useRouter: jest.fn().mockReturnValue(router),
    useRoute: jest.fn().mockReturnValue({
      params: {
      },
      query: {
      },
    }),
    onBeforeRouteUpdate: jest.fn(),
  };
});

jest.mock("primevue/usetoast", () => ({
  useToast: jest.fn(() => ({
    add: jest.fn(),
    removeAll: jest.fn(),
  })),
}));

jest.mock("@/js/axios.js", () => ({
  axiosInstance: {
    get: jest.fn(),
    interceptors: {
      request: { use: jest.fn() },
      response: { use: jest.fn() },
    },
  },
  setupInterceptors: jest.fn(),
}));

describe("MyPage", () => {
  let wrapper;
  let mockedAxiosInstance;

  beforeEach(() => {
    jest.mock("@/js/axios.js", () => ({
      axiosInstance: {
        get: jest.fn(),
        interceptors: {
          request: { use: jest.fn() },
          response: { use: jest.fn() },
        },
      },
      setupInterceptors: jest.fn(),
    }));

    // モックされたaxiosInstanceを取得
    const axiosModule = require("@/js/axios.js");
    mockedAxiosInstance = axiosModule.axiosInstance;

    // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
    mockedAxiosInstance.get.mockResolvedValue({
      data: {},
    });

    wrapper = shallowMount(MyPage, {
      global: {
        stubs: ["router-link", "router-view"],
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示(データなし)", () => {
    expect(wrapper.element).toMatchSnapshot();
  });
});

describe("MyPage", () => {
  let wrapper;
  let mockedAxiosInstance;

  beforeEach(() => {
    jest.mock("@/js/axios.js", () => ({
      axiosInstance: {
        get: jest.fn(),
        interceptors: {
          request: { use: jest.fn() },
          response: { use: jest.fn() },
        },
      },
      setupInterceptors: jest.fn(),
    }));

    // モックされたaxiosInstanceを取得
    const axiosModule = require("@/js/axios.js");
    mockedAxiosInstance = axiosModule.axiosInstance;

    // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
    mockedAxiosInstance.get.mockResolvedValue({
      data: {
        user: {
          id: 1,
          name: "TestUser",
        },
        knowledges: [
          { id: 1, title: "Test1", content: "TESTTEST1" },
          { id: 2, title: "Test2", content: "TESTTEST2" },
        ],
        records: [
            {id: 1, date: "2024-06-24", fat_percentage: 12.1},
            {id:2, name: "2024-06-25", weight: 65}
        ],
        is_more: true
      },
    });

    wrapper = shallowMount(MyPage, {
      global: {
        stubs: ["router-link", "router-view"],
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示(データあり)", () => {
    expect(wrapper.element).toMatchSnapshot();
  });
});
