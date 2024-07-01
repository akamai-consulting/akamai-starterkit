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

  it('should contain the correct <h1> and <h2> content', async () => {
    const deploymentName = process.env.DEPLOYMENT_NAME;
    const deploymentUrl = process.env.DEPLOYMENT_URL;
    const testUrl = `https://${deploymentUrl}/hello-world`;

    await page.goto(testUrl);
    const h1Content = await page.$eval('h1', element => element.innerHTML);
    const h2Content = await page.$eval('h2', element => element.innerHTML);
  
    expect(h1Content).toBe(`Hello World From Akamai EdgeWorkers:`);
    expect(h2Content).toBe(`Deployment: ${deploymentName}`);
  });

});
