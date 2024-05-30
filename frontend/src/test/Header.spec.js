import { shallowMount } from '@vue/test-utils'
import { useRouter } from "vue-router";
import Header from '@/components/layout/Header.vue'
import axios from 'axios'
import Cookies from 'js-cookie'

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

describe('Header.vue', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Header, {
      global: {
        stubs: ["router-link", "router-view"]
      }
    })
  })

  it('SnapShotテスト', () => {
    expect(wrapper.element).toMatchSnapshot();
  })

  it('未ログインの場合には会員登録・ログインボタンが表示される', async () => {
    axios.get.mockResolvedValueOnce({ data: { user: null } })

    expect(wrapper.find('.account-introducton-button').exists()).toBe(true)
  })

  it('ログイン済みの場合には会員登録・ログインボタンが表示されない', async () => {
    const user = { id: 1 }
    axios.get.mockResolvedValue({ data: { user: user } })

    expect(wrapper.find('.user-button').exists()).toBe(true)
  })

  it('ログイン済みの場合にはドロップダウンメニューが4つ表示される', async () => {
    const user = { id: 1 }

    axios.get.mockResolvedValue({ data: { user: user } })

    await wrapper.vm.checkLogin()
    await wrapper.find('.user-button').trigger('click')

    const menuItems = wrapper.findAll('.menu-item')
    expect(menuItems.length).toBe(4)
    expect(wrapper.find('.dropdown-menu').exists()).toBe(true)
  })

  it('ログアウトするとCookieのトークン情報がなくなる', async () => {
    const user = { id: 1 }
    axios.get.mockResolvedValueOnce({ data: { user: user } })
    
    await wrapper.vm.checkLogin()
    await wrapper.find('.user-button').trigger('click')
  
    const menuItems = wrapper.findAll('.menu-item')
    expect(menuItems.length).toBeGreaterThan(3)
  
    await menuItems.at(3).trigger('click')

    axios.delete.mockResolvedValueOnce({})
  
    expect(Cookies.get('accessToken')).toBeUndefined()
    expect(Cookies.get('client')).toBeUndefined()
    expect(Cookies.get('uid')).toBeUndefined()
  })
})
