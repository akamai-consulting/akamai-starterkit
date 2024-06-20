// jest.setup.ts
declare global {
  namespace NodeJS {
    interface Global {
      __CHROMIUM_EXECUTABLE_PATH__: string;
    }
  }
}

(global as any).__CHROMIUM_EXECUTABLE_PATH__ = '/usr/bin/chromium';

export {}; // Add this line to make the file a module