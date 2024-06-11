import { shallowMount } from "@vue/test-utils";
import KnowledgeDetail from "@/components/page/KnowledgeDetail.vue";

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

jest.mock("@/const/axios.js", () => ({
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

  const mockComments = [
    { id: 1, content: "This is a test comment" },
    { id: 2, content: "This is another test comment" },
  ];

  beforeEach(() => {
    jest.mock("@/const/axios.js", () => ({
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
    const axiosModule = require("@/const/axios.js");
    mockedAxiosInstance = axiosModule.axiosInstance;
  
    // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
    mockedAxiosInstance.get.mockResolvedValue({
      data: { knowledge: mockKnowledge, comments: mockComments },
    });

    wrapper = shallowMount(KnowledgeDetail, {
      global: {
        stubs: ["router-link", "router-view"],
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示(コメントあり)", () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("SnapShotテスト初期表示(コメントなし)", () => {
    const mockKnowledge = {
      id: 1,
      title: "Test Knowledge",
      content: "This is a test knowledge",
      image_urls: [
        { id: 1, url: "https://example.com/image1.jpg" },
        { id: 2, url: "https://example.com/image2.jpg" },
      ],
    };

    const mockComments = [];

    jest.mock("@/const/axios.js", () => ({
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
    const axiosModule = require("@/const/axios.js");
    mockedAxiosInstance = axiosModule.axiosInstance;

    // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
    mockedAxiosInstance.get.mockResolvedValue({
      data: { knowledge: mockKnowledge, comments: mockComments },
    });
    expect(wrapper.element).toMatchSnapshot();
  });
});
