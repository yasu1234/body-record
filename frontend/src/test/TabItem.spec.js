import { shallowMount } from '@vue/test-utils'
import TabItem from '@/components/atom/TabItem.vue'

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
    wrapper = shallowMount(TabItem, {
      global: {
        stubs: ["router-link", "router-view"]
      }
    })
  })

  it('SnapShotテスト(activeになる)', () => {
    wrapper = shallowMount(TabItem, {
        props: {
          menuTitle: 'Home',
          menuId: 1,
          currentId: 1
        }
    })
    expect(wrapper.element).toMatchSnapshot();
  })

  it('SnapShotテスト(activeではない)', () => {
    wrapper = shallowMount(TabItem, {
        props: {
          menuTitle: 'Home',
          menuId: 1,
          currentId: 2
        }
    })
    expect(wrapper.element).toMatchSnapshot();
  })

  it('menuIdとcurrentIdが一致していたらactiveが適用される', async () => {
    wrapper = shallowMount(TabItem, {
      props: {
        menuTitle: 'Home',
        menuId: 1,
        currentId: 1
      }
    })
    const button = wrapper.find('button')
    expect(button.classes()).toContain('active')
  })
 
  it('menuIdとcurrentIdが一致していない場合にはactiveが適用されない', async () => {
    wrapper = shallowMount(TabItem, {
      props: {
        menuTitle: 'Home',
        menuId: 1,
        currentId: 2
      }
    })
    const button = wrapper.find('button')
    expect(button.classes()).not.toContain('active')
  })
 
  it('メニューボタンをタップしたときにmenuIdがemitで渡されていること', async () => {
    wrapper = shallowMount(TabItem, {
      props: {
        menuTitle: 'Home',
        menuId: 1,
        currentId: 1
      }
    })
    const button = wrapper.find('button')
    await button.trigger('click')
    expect(wrapper.emitted('menuTapped')).toBeTruthy()
    expect(wrapper.emitted('menuTapped')[0]).toEqual([1])
  })
})

