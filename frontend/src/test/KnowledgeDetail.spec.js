import { shallowMount, flushPromises } from '@vue/test-utils'
import axios from 'axios'
import KnowledgeDetail from '@/components/page/KnowledgeDetail.vue'

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

describe('EditKnowledge', () => {
  let wrapper

  const mockKnowledge = {
    id: 1,
    title: 'Test Knowledge',
    content: 'This is a test knowledge',
    image_urls: [
      { id: 1, url: 'https://example.com/image1.jpg' },
      { id: 2, url: 'https://example.com/image2.jpg' }
    ]
  }

  const mockComments = [
    { id: 1, content: 'This is a test comment' },
    { id: 2, content: 'This is another test comment' }
  ] 

  // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
  axios.get.mockResolvedValue({ data: { knowledge: mockKnowledge, comments: mockComments } })

  beforeEach(() => {
    wrapper = shallowMount(KnowledgeDetail, {
        global: {
          stubs: ["router-link", "router-view"]
        }
    })
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  it('SnapShotテスト初期表示(コメントあり)', () => {
    expect(wrapper.element).toMatchSnapshot();
  })

  it('SnapShotテスト初期表示(コメントなし)', () => {
    const mockKnowledge = {
        id: 1,
        title: 'Test Knowledge',
        content: 'This is a test knowledge',
        image_urls: [
          { id: 1, url: 'https://example.com/image1.jpg' },
          { id: 2, url: 'https://example.com/image2.jpg' }
        ]
      }
    
      const mockComments = [] 
    
      // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
      axios.get.mockResolvedValue({ data: { knowledge: mockKnowledge, comments: mockComments } })
    expect(wrapper.element).toMatchSnapshot();
  })
})
