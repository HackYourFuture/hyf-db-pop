'use strict';

let fs = require('fs');
let mysql = require('mysql');
let querystring = require('querystring');

module.exports.reset = (event, context, callback) => {

  validateUserAgent(event, 'slackbot')
  .then(requestBody => validateSlackTeam(requestBody, 'HackYourFuture'))
  .then(validatedRequestBody => extractUser(validatedRequestBody))
  .then(extractedUser => resetDB(extractedUser))
  .then(response => callback(null, response))
  .catch(error => callback(error));

}

function validateUserAgent(event, desiredUserAgent) {
  return new Promise(function(resolve, reject) {
    // Check the context for the Slack user agent. If not found, reject.
    const foundUserAgent = event.requestContext.identity.userAgent.toLowerCase();
    if (foundUserAgent.startsWith(desiredUserAgent.toLowerCase())) {
      resolve(querystring.parse(event.body));
    } else {
      reject(buildError(401, "This endpoint can only be accessed via the Slack app."));
    }
  });
}

function validateSlackTeam(requestBody, desiredTeam) {
  return new Promise(function(resolve, reject) {
    // Check the context for the HackYourFuture team name. If not found, throw error.
    if (!requestBody.team_domain || requestBody.team_domain.toLowerCase() !== desiredTeam.toLowerCase()) {
      reject(buildError(401, `This endpoint can only be accessed by ${desiredTeam} users.`));
    } else {
      resolve(requestBody);
    }
  });
}

function extractUser(requestBody) {
  return new Promise(function(resolve, reject) {
    // Check the context for the Slack user name. If not found, throw error.
    const requestingUser = requestBody.user_name;

    if (requestingUser) {
      resolve(requestingUser)
    } else {
      reject(buildError(401, "Slack user_name not in request. This error should never occur."));
    }
  });
}

function resetDB(database) {
  return new Promise(function(resolve, reject) {
    // Setup the MySQL connection
    const config = JSON.parse(fs.readFileSync("config-secret.json"));
    const connection = mysql.createConnection({
      host: config.host,
      user: config.user,
      password: config.password,
      port: config.port,
      multipleStatements: true
    });
    
    // Load in the reset script
    const resetScript = fs.readFileSync("resetdata.sql");

    // Truncate the database if it exists and execute the reset script
    connection.connect();

    let query = `DROP DATABASE ${database};`;
    query += `CREATE DATABASE ${database} DEFAULT CHARACTER SET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;`
    query += `USE ${database};`;
    query += `${resetScript}`;

    connection.query(query, function (error, results, fields) {
      connection.end();

      if (error) {
        console.error(error);
        reject(buildError(500, "A database error occured.\nPlease contact your teacher."));
      } else {
        console.log(`Database reset for user ${database} via Slack.`)
        resolve(buildResponse(`Hi, ${database}.\nYour database has been reset!`));      
      }
    });
  });
}

function buildResponse(body) {
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      text: body
    })
  };

  return response;
};

function buildError(statusCode, message) {
  const error = {
    statusCode: statusCode,
    body: JSON.stringify({
      error: message
    })
  };

  return error;
};