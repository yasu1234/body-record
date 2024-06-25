import { shallowMount } from "@vue/test-utils";
import EditProfile from "@/components/page/user/EditProfile.vue";

jest.mock("axios");
jest.mock("vue-router", () => {
  const router = {
    push: jest.fn(),
    pathname: "/",
    route: "",
    asPath: "",
    query: {},
    events: {
      on: jest.fn(),
      off: jest.fn(),
      emit: jest.fn(),
    },
  };
  return {
    useRouter: jest.fn().mockReturnValue(router),
    useRoute: jest.fn().mockReturnValue({
      params: {
        id: 1,
      },
    }),
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

describe("Contact", () => {
  let wrapper;
  let mockedAxiosInstance;

  beforeEach(() => {
    wrapper = shallowMount(EditProfile, {
      global: {
        stubs: ["router-link", "router-view"],
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示(登録データなし)", () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("SnapShotテスト初期表示(登録データあり)", () => {
    const mockProfile = {
      profile: {
        profile: "よろしくお願いします",
        goal_weight: 66,
        goal_fat_percentage: 13,
      },
    };

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

    const axiosModule = require("@/js/axios.js");
    mockedAxiosInstance = axiosModule.axiosInstance;

    // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
    mockedAxiosInstance.get.mockResolvedValue({
      data: { user: mockProfile },
    });

    expect(wrapper.element).toMatchSnapshot();
  });
});
