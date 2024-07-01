const fs = require('fs').promises;

async function helloWorldInjector() {
  const deploymentName = process.env.DEPLOYMENT_NAME;
  const commitHash = process.env.COMMIT_HASH; // This is read but not used in this script, based on your instructions.

  if (!deploymentName) {
    console.error('DEPLOYMENT_NAME environment variable is required');
    process.exit(1);
  }

  try {
    // Step 2: Read the main.js file
    const filePath = '../edge-worker/main.js';
    let fileContent = await fs.readFile(filePath, 'utf8');
    
    // Step 3: Update the <h1> content
    fileContent = fileContent.replace(
      /<h1>Hello World From Akamai EdgeWorkers<\/h1>/,
      `<h1>Hello World From Akamai EdgeWorkers:</h1><h2>Deployment: ${deploymentName}</h2>`
    );
    
    // Step 4: Write the updated content back to main.js
    await fs.writeFile(filePath, fileContent, 'utf8');
    console.log('Updated <h1> content successfully.');
  } catch (error) {
    console.error('Failed to update <h1> content:', error);
  }
}

helloWorldInjector();