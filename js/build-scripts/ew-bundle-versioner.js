const fs = require('fs').promises;

async function updateEdgeworkerVersion() {
  const deploymentName = process.env.DEPLOYMENT_NAME;
  const commitHash = process.env.COMMIT_HASH;

  if (!deploymentName || !commitHash) {
    console.error(`DEPLOYMENT_NAME (${deploymentName}) and COMMIT_HASH (${commitHash}) environment variables are required`);
    process.exit(1);
  }

  try {
    // Step 2: Read the bundle.json file
    const filePath = '../edge-worker/bundle.json';
    const data = await fs.readFile(filePath, 'utf8');
    
    // Step 3: Parse the JSON
    const json = JSON.parse(data);
    
    // Step 4: Update the edgeworker-version value
    json['edgeworker-version'] = `${deploymentName}-${commitHash}`;
    
    // Step 5: Write the updated JSON back to the file
    await fs.writeFile(filePath, JSON.stringify(json, null, 2), 'utf8');
    console.log('Updated edgeworker-version successfully.');
  } catch (error) {
    console.error('Failed to update edgeworker-version:', error);
  }
}

updateEdgeworkerVersion();