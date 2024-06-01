import { shallowMount } from '@vue/test-utils'
import ListPage from '@/components/layout/ListPage.vue'

jest.mock('axios')
jest.mock('vuejs-paginate-next')
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

describe('TabItem.vue', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(ListPage, {
      global: {
        stubs: ["router-link", "router-view"]
      }
    })
  })

  it('SnapShotテスト(合計1ページ)', () => {
    wrapper = shallowMount(ListPage, {
        props: {
            pageCount: 1
        }
    })

    expect(wrapper.element).toMatchSnapshot();
  })

  it('SnapShotテスト(合計10ページ)', () => {
    wrapper = shallowMount(ListPage, {
        props: {
            pageCount: 10
        }
    })

    expect(wrapper.element).toMatchSnapshot();
  })
})
