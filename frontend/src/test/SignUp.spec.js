import { shallowMount } from '@vue/test-utils'
import Signup from '@/components/page/Signup.vue'

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

describe('SignUp', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(Signup, {
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
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[0].text()).toBe('メールアドレスの形式で入力してください')
  })

  it('バリデーションエラー(メールアドレス入力なし)', async () => {
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[0].text()).toBe('この項目は必須です')
  })

  it('バリデーションエラー(パスワード入力なし)', async () => {
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[1].text()).toBe('この項目は必須です')
  })

  it('バリデーションエラー(パスワード文字数不足)', async () => {
    wrapper.vm.password = 'passw'
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[1].text()).toBe('6文字以上で入力してください')
  })

  it('バリデーションエラー(パスワード文字数オーバー)', async () => {
    wrapper.vm.password = 'passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword'
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[1].text()).toBe('128文字以下で入力してください')
  })

  it('バリデーションエラー(パスワード確認入力なし)', async () => {
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[2].text()).toBe('この項目は必須です')
  })

  it('バリデーションエラー(パスワード確認文字数不足)', async () => {
    wrapper.vm.passwordConfirm = 'passw'
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[2].text()).toBe('6文字以上で入力してください')
  })

  it('バリデーションエラー(パスワード確認文字数オーバー)', async () => {
    wrapper.vm.passwordConfirm = 'passwordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpasswordpassword'
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[2].text()).toBe('128文字以下で入力してください')
  })

  it('バリデーションエラー(名前入力なし)', async () => {
    await wrapper.vm.checkValidate()
    expect(wrapper.findAll('.validation-error-message')[3].text()).toBe('この項目は必須です')
  })
})
