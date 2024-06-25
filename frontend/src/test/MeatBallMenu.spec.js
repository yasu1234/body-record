import { shallowMount } from "@vue/test-utils";
import MeatBallMenu from "@/components/atom/MeatBallMenu.vue";

describe("MeatBallMenu", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(MeatBallMenu);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示", () => {
    expect(wrapper.element).toMatchSnapshot();
  });
});
