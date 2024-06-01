import { shallowMount, flushPromises } from '@vue/test-utils'
import axios from 'axios'
import Login from '@/components/page/Login.vue'

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

  jest.mock('primevue/usetoast', () => ({
    useToast: jest.fn(() => ({
      add: jest.fn(),
      removeAll: jest.fn()
    }))
  }))

describe('SearchPage', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Login, {
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

  it('バリデーションエラー(メールアドレス形式違い)', async () => {
    await wrapper.find('#email').setValue('invalid-email')
    await wrapper.vm.handleSubmit()
    expect(wrapper.findAll('.validation-error-message')[0].text()).toBe('メールアドレスの形式で入力してください')
  })

  it('バリデーションエラー(メールアドレス入力なし)', async () => {
    await wrapper.vm.handleSubmit()
    expect(wrapper.findAll('.validation-error-message')[0].text()).toBe('この項目は必須です')
  })

  it('バリデーションエラー(パスワード入力なし)', async () => {
    await wrapper.vm.handleSubmit()
    expect(wrapper.findAll('.validation-error-message')[1].text()).toBe('この項目は必須です')
  })

  it('バリデーションエラー(パスワード文字数不足)', async () => {
    wrapper.vm.password = 'passw'
    await wrapper.vm.handleSubmit()
    expect(wrapper.findAll('.validation-error-message')[1].text()).toBe('6文字以上で入力してください')
  })

  it('バリデーションエラー(パスワード文字数オーバー)', async () => {
    wrapper.vm.password = 'passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword'
    await wrapper.vm.handleSubmit()
    expect(wrapper.findAll('.validation-error-message')[1].text()).toBe('128文字以下で入力してください')
  })
})
