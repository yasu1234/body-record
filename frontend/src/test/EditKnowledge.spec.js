import { shallowMount } from "@vue/test-utils";
import EditKnowledge from "@/components/page/knowledge/EditKnowledge.vue";

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

describe("EditKnowledge", () => {
  let wrapper;
  let mockedAxiosInstance;

  const mockKnowledge = {
    id: 1,
    title: "Test Knowledge",
    content: "This is a test knowledge",
    image_urls: [
      { id: 1, url: "https://example.com/image1.jpg" },
      { id: 2, url: "https://example.com/image2.jpg" },
    ],
  };

  beforeEach(() => {
    jest.mock("@/js/axios.js", () => ({
      axiosInstance: {
        get: jest.fn(),
        post: jest.fn(),
        delete: jest.fn(),
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
    mockedAxiosInstance.get.mockResolvedValue({ data: { knowledge: mockKnowledge } });

    wrapper = shallowMount(EditKnowledge, {
      global: {
        stubs: ["router-link", "router-view"],
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示", () => {
    expect(wrapper.element).toMatchSnapshot();
  });
});
