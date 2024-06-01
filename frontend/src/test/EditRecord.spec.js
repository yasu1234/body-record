import { shallowMount, flushPromises } from '@vue/test-utils'
import axios from 'axios'
import EditRecord from '@/components/page/EditRecord.vue'

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

describe('EditRecord', () => {
  let wrapper

  const mockRecord = {
    id: 1,
    title: 'Test',
    image_url: [
      { id: 1, url: 'https://example.com/image1.jpg' },
      { id: 2, url: 'https://example.com/image2.jpg' }
    ]
  } 

  // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
  axios.get.mockResolvedValue({ data: { record: mockRecord } })

  beforeEach(() => {
    wrapper = shallowMount(EditRecord, {
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
