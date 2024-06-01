import { shallowMount } from '@vue/test-utils'
import axios from 'axios'
import AddKnowledge from '@/components/page/AddKnowledge.vue'

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
      useRoute: jest.fn().mockReturnValue({
        params: {
          id: 1
        }
      })
    };
  });

  jest.mock('primevue/usetoast', () => ({
    useToast: jest.fn(() => ({
      add: jest.fn(),
      removeAll: jest.fn()
    }))
  }))

describe('AddKnowledge', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(AddKnowledge, {
        global: {
          stubs: ["router-link", "router-view"]
        }
    })
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  it('SnapShotテスト初期表示', () => {
    expect(wrapper.element).toMatchSnapshot();
  })
})
