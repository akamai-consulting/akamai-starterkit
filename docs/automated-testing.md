# Automated Testing
Getting automated testing integrated into CI can be a PAIN but it's worth it.  This repo ships with it OOTB.  You can see the work done to add the necessary [container dependencies here](https://github.com/akamai-consulting/akamai-starterkit/pull/38/files) and the jest test suite to use them [here](https://github.com/akamai-consulting/akamai-starterkit/pull/41).  

# Test Foundations
The container image ships with Chromium, Pupeteer, Jest, and NodeJS. Why Chromium and not Chrome?  Chromium ships with Arm Binaries and lets us more easily support the container on ARM64 or AMD64

# Why Jest?
 Given that EW are in JS we decided to bundle [Jest](https://jestjs.io/) as the test framework.  You might like something else.  No worries you can easily override jest with your own testing suite. 

# Adding tests
We have added a single test [here](https://github.com/akamai-consulting/akamai-starterkit/blob/main/js/hello-world.test.ts) that hits the deployment URL and vists the page `hello-world` and confirms it sees the text `hello` on the page. This is rediculously simple but it tells us that Terraform completed, Akamai properties, hostnames, DNS, SSL were all wired together.  EdgeWorkers were deployed and the propery can route traffic to it. This tests a LOT quickly!

You of course will write your own tests to validate your code is working as expected.
A few things to note:
- `const deploymentUrl = process.env.DEPLOYMENT_URL;`  - this is the URL that was deployed. It does not contain the HTTP/HTTPS protocol or path. 
-  You will need to copy the puppeteer settings as well since they tell it where chromium lives and maintain docker compatibility:  
   ```    browser = await puppeteer.launch({
      executablePath: __CHROMIUM_EXECUTABLE_PATH__, // Corrected usage
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-gpu',
        '--disable-dev-shm-usage'
      ]
    });
    page = await browser.newPage();
  });```
