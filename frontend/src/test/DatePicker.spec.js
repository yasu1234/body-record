import { shallowMount } from '@vue/test-utils'
import { useRouter } from "vue-router";
import DatePicker from '@/components/atom/DatePicker.vue'

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
    wrapper = shallowMount(DatePicker, {
      global: {
        stubs: ["router-link", "router-view"]
      }
    })
  })

  it('SnapShotテスト', () => {
    expect(wrapper.element).toMatchSnapshot();
  })

  it('emitsで指定した日付が渡る', async () => {
    const datePicker = wrapper.findComponent(DatePicker)
    await datePicker.vm.$emit('update:model-value', new Date(2023, 4, 15))
    expect(wrapper.emitted('update:date')).toBeTruthy()
    expect(wrapper.emitted('update:date')[0]).toEqual(['2023/5/15'])
  })

  it('emitsでnullを渡した時には空文字が渡る', async () => {
    const datePicker = wrapper.findComponent(DatePicker)
    await datePicker.vm.$emit('update:model-value', null)
    expect(wrapper.emitted('update:date')).toBeTruthy()
    expect(wrapper.emitted('update:date')[0]).toEqual([''])
  })

  it('propsが更新されたら更新した日づけに変更される', async () => {
    wrapper = shallowMount(DatePicker, {
      props: {
        date: '2023/4/1'
      }
    })
    expect(wrapper.props().date).toBe('2023/4/1')
    await wrapper.setProps({ date: '2023/5/15' })
    expect(wrapper.props().date).toBe('2023/5/15')
  })
})
