import { S3Client, ListObjectsV2Command } from '@aws-sdk/client-s3';

const client = new S3Client({});

/**
 * A simple example includes a HTTP get method to get one item by id from a DynamoDB table.
 */
export const listHandler = async (event) => {
  if (event.httpMethod !== 'GET') {

    throw new Error(`getMethod only accept GET method, you tried: ${event.httpMethod}`);
  }

client.sendRequest

  const command = new ListObjectsV2Command({
    Bucket: "activity-timer-frontend"
  });
  
  let contents = [];
  try {
    let isTruncated = true;

    while (isTruncated) {
      const { Contents, IsTruncated, NextContinuationToken } = await client.send(command);
      const contentsList = Contents.map((c) => `${c.Key}`);
      contents.push(...contentsList);
      isTruncated = IsTruncated;
      command.input.ContinuationToken = NextContinuationToken;
    }
  } catch (err) {
    console.error(err);
    throw new Error(`${err}`);
  }

  const response = {
    statusCode: 200,
    body: JSON.stringify(contents),
    headers: { "Content-Type": "application/json"}
  };
 
  // All log statements are written to CloudWatch
  console.info(`response from: ${event.path} statusCode: ${response.statusCode}`);
  return response;
}
