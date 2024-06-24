import { shallowMount } from '@vue/test-utils'
import PasswordEdit from '@/components/page/account/PasswordEdit.vue'

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

describe('PasswordEdit.vue', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(PasswordEdit, {
      global: {
        stubs: ["router-link", "router-view"]
      }
    })
  })

  it('SnapShotテスト', () => {
    wrapper = shallowMount(PasswordEdit)

    expect(wrapper.element).toMatchSnapshot();
  })
})
