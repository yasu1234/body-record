import { shallowMount } from '@vue/test-utils'
import axios from 'axios'
import Author from '@/components/layout/Author.vue'

jest.mock("axios")
jest.mock('js-cookie')
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

describe('Author', () => {
  let wrapper

  const mockAuthor = {
    id: 1,
    name: 'Test Author',
    image_url: {
      url: 'https://example.com/author.jpg'
    },
    isSupport: false
  }

  const mockUser = {
    id: 1,
    supportCount: 10
  }

  // onMounted内でaxios.getが呼ばれるため、このタイミングでモック設定
  axios.get.mockResolvedValue({ data: { user: mockUser } })

  beforeEach(() => {
    wrapper = shallowMount(Author, {
      global: {
        stubs: ["router-link", "router-view"]
      },
      props: {
        author: mockAuthor,
        userId: 1
      }
    })
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  it('SnapShotテスト(サポート済み)', () => {
    const mockAuthor = {
        id: 1,
        name: 'Test Author',
        image_url: {
            url: 'https://example.com/author.jpg'
        },
        isSupport: true
    }

    const mockUser = {
        id: 1,
        supportCount: 10
    }
    
    axios.get.mockResolvedValue({ data: { user: mockUser } })

    wrapper = shallowMount(Author, {
        global: {
          stubs: ["router-link", "router-view"]
        },
        props: {
          author: mockAuthor,
          userId: 1
        }
    })

    expect(wrapper.element).toMatchSnapshot();
  })

  it('SnapShotテスト(未サポート)', () => {
    expect(wrapper.element).toMatchSnapshot();
  })

  it('サポート件数が表示されている', () => {
    const supportCount = wrapper.findAll('p.author-name').at(1)
    expect(supportCount.text()).toBe('10')
    expect(wrapper.find('.author-thumbnail-image img').exists()).toBe(true)
  })

  it('応援登録後にレスポンスの値(応援数)が反映される', async () => {
    axios.get.mockResolvedValue({ data: { user: mockAuthor } })
    const supportAfter = {
        id: 1,
        supportCount: 11
    }

    axios.post.mockResolvedValue({ data: { user: supportAfter } })
    await wrapper.vm.supportOn()

    const supportCount = wrapper.findAll('p.author-name').at(1)
    expect(supportCount.text()).toBe('11')
  })

  it('応援登録解除後にレスポンスの値(応援数)が反映される', async () => {
    axios.get.mockResolvedValue({ data: { user: mockAuthor } })
    const supportAfter = {
        id: 1,
        supportCount: 9
    }

    axios.delete.mockResolvedValue({ data: { user: supportAfter } })
    await wrapper.vm.supportOff()

    const supportCount = wrapper.findAll('p.author-name').at(1)
    expect(supportCount.text()).toBe('9')
  })
})
