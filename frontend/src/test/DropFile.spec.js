import { shallowMount } from "@vue/test-utils";
import DropFile from "@/components/atom/DropFile.vue";

jest.mock("axios");
jest.mock("vue-router", () => {
  const router = {
    push: jest.fn(),
    pathname: "/",
    route: "",
    asPath: "",
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

jest.mock("primevue/usetoast", () => ({
  useToast: jest.fn(() => ({
    add: jest.fn(),
    removeAll: jest.fn(),
  })),
}));

describe("DropFile", () => {
  let wrapper;

  beforeEach(() => {
    global.URL.createObjectURL = jest.fn(() => 'mock-object-url');
    global.URL.revokeObjectURL = jest.fn();
    wrapper = shallowMount(DropFile, {
      props: {
        index: 0,
      },
      global: {
        stubs: ["router-link", "router-view"],
      },
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it("SnapShotテスト初期表示", () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("ファイルが選択された時に、changeイベントが正しく発行される", async () => {
    const file = new File(["hello"], "hello.jpg", { type: "img/jpg" });
    const input = wrapper.find('input[type="file"]');
    Object.defineProperty(input.element, "files", {
      value: [file],
      writable: false,
    });
    await input.trigger("change");
    expect(wrapper.emitted("change")[0]).toEqual([file, 0]);
  });

  it("ファイルがドロップされた時に、ファイルデータが正しく設定される", async () => {
    const file = new File(["hello"], "hello.txt", { type: "text/plain" });
    const dropzone = wrapper.find(".dropzone-container");
    await dropzone.trigger("drop", { dataTransfer: { files: [file] } });
    expect(wrapper.vm.file).toEqual(file);
  });

  it("削除ボタンがクリックされた時に、ファイルデータが正しくリセットされ、change イベントが正しく発行される", async () => {
    const file = new File(["hello"], "hello.txt", { type: "text/plain" });
    wrapper.vm.file = file;
    await wrapper.vm.$nextTick();
    const removeButton = wrapper.find("button");
    await removeButton.trigger("click");
    expect(wrapper.vm.file).toBeNull();
    expect(wrapper.emitted("change")[0]).toEqual([null, 0]);
  });
});
