import { shallowMount } from '@vue/test-utils'
import SettingSideMenu from '@/components/layout/SettingSideMenu.vue'
import axios from 'axios'

jest.mock('axios')
jest.mock('vue-router', () => {
  const router = {
    push: jest.fn(),
    pathname: '/',
    route: '',
    asPath: '',
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

describe('TabItem.vue', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(SettingSideMenu, {
      global: {
        stubs: ["router-link", "router-view"]
      }
    })
  })

  it('SnapShotテスト', () => {
    wrapper = shallowMount(SettingSideMenu, {
        props: {
            currentIndex: 1
        }
    })

    const user = { id: 1 }
    axios.get.mockResolvedValue({ data: { user: user, isLogin: true } })
    expect(wrapper.element).toMatchSnapshot();
  })
})
