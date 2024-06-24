import { shallowMount } from "@vue/test-utils";
import UserList from "@/components/page/user/UserList.vue";

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
        id: 1,
      },
      query: {
        keyword: "",
        onlySupport: false,
        page:1
      }
    }),
    onBeforeRouteUpdate: jest.fn()
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

describe("UserList", () => {
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
      data: { users: [{id: 1, name: "AAA"}, {id:2, name: "BBB"}] , total_page: 2}
    });

    wrapper = shallowMount(UserList, {
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

describe("UserList", () => {
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
        data: { }
      });
  
      wrapper = shallowMount(UserList, {
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
