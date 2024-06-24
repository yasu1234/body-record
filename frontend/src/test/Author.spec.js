import { shallowMount } from "@vue/test-utils";
import Author from "@/components/layout/Author.vue";

jest.mock("axios");
jest.mock("js-cookie");
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
  };
});

describe("Author", () => {
  let wrapper;
  let mockedAxiosInstance;

  const mockAuthor = {
    id: 1,
    name: "Test Author",
    image_url: {
      url: "https://example.com/author.jpg",
    },
    is_support: false,
  };

  const mockUser = {
    id: 1,
    supporter_count: 10,
  };

  beforeEach(() => {    
    wrapper = shallowMount(Author, {
      global: {
        stubs: ["router-link", "router-view"],
      },
      props: {
        author: mockAuthor,
        support: mockUser
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト(サポート済み)", () => {
    const mockAuthor = {
      id: 1,
      name: "Test Author",
      image_url: {
        url: "https://example.com/author.jpg",
      },
      is_support: true,
    };

    const mockUser = {
      id: 1,
      supporter_count: 10,
    };

    wrapper = shallowMount(Author, {
      global: {
        stubs: ["router-link", "router-view"],
      },
      props: {
        author: mockAuthor,
        support: mockUser
      },
    });

    expect(wrapper.element).toMatchSnapshot();
  });

  it("SnapShotテスト(未サポート)", () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("サポート件数が表示されている", () => {
    const supportCount = wrapper.findAll("p").at(1);
    expect(supportCount.text()).toBe("10");
    expect(wrapper.find(".author-thumbnail-image img").exists()).toBe(true);
  });
});
