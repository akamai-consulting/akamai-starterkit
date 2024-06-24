import * as puppeteer from 'puppeteer';

describe('Deployment URL Test', () => {
  let browser: puppeteer.Browser; // Explicitly type the browser variable
  let page: puppeteer.Page; // Also, explicitly type the page variable

  beforeAll(async () => {
    browser = await puppeteer.launch({
      executablePath: __CHROMIUM_EXECUTABLE_PATH__, // Corrected usage
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-gpu',
        '--disable-dev-shm-usage'
      ]
    });
    page = await browser.newPage();
  });

  afterAll(async () => {
    await browser.close();
  });

  it('should contain the text "Hello"', async () => {
    const deploymentUrl = process.env.DEPLOYMENT_URL;
    expect(deploymentUrl).toBeTruthy(); // Ensure the DEPLOYMENT_URL is set

    if (deploymentUrl) {
      // Updated to visit /hello-world path
      const testUrl = `https://${deploymentUrl}/hello-world`;

      
      console.log(`Navigating to URL: ${testUrl}`);
      await page.goto(testUrl, { waitUntil: 'domcontentloaded' });
  
    } else {
      throw new Error('Deployment URL is undefined');
    }
    const bodyText = await page.evaluate(() => document.body.innerText);
    expect(bodyText).toContain('Hello World From Akamai EdgeWorkers');
 

  });
});
