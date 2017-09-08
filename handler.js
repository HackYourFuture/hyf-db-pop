'use strict';

let fs = require('fs');
let mysql = require('mysql');
let querystring = require('querystring');

module.exports.reset = (event, context, callback) => {
  // For debug use the following:
  // event = {
  //   body : "token=CYlFjb3d6SGunrnvttnRsaV2&team_id=T0EJTUQ87&team_domain=hackyourfuture&channel_id=D3Y3D1GQK&channel_name=directmessage&user_id=U3Y5DFFK4&user_name=rob&command=%2Fdbreset&text=&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT0EJTUQ87%2F236549126758%2F2blVWb1Otoj9aTngEqd0P2Yx&trigger_id=235659491954.14639976279.b65669854fcd863d48d9cc8bd79e20e2",
  //   requestContext : {
  //     userAgent : 'Slackbot'
  //   }
  // }

  // Check the context for the Slack user agent. If not found, reject.
  if (!event.requestContext.userAgent.toLowerCase().startsWith('slackbot')) {
    callback(buildError(401, "This endpoint can only be accessed via the Slack app."));
    return;
  }

  // Extract the Slack request body
  const requestBody = querystring.parse(event.body);
  
  // Check the context for the HackYourFuture team name. If not found, throw error.
  if (!requestBody.team_domain || requestBody.team_domain.toLowerCase() !== 'hackyourfuture') {
    callback(buildError(401, "This endpoint can only be accessed by HackYourFuture users."));
    return;
  }
  
  // Check the context for the Slack user name. If not found, throw error.
  const requestingUser = requestBody.user_name;

  if (!requestingUser) {
    callback(buildError(401, "Slack user_name not in request. This error should never occur."));
    return;
  }

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

  // Drop the database, recreate it, and execute the reset script
  connection.connect();

  const query = `
DROP DATABASE IF EXISTS ${requestingUser};
CREATE DATABASE IF NOT EXISTS ${requestingUser}
  DEFAULT CHARACTER SET=utf8mb4
  DEFAULT COLLATE=utf8mb4_unicode_ci;
USE ${requestingUser};
${resetScript}`;

  connection.query(query, function (error, results, fields) {
    connection.end();

    if (error) {
      callback(buildError(500, "A database error occured.\nPlease contact your teacher."));
      console.log(error);
    } else {
      callback(null, buildResponse(`Hi, ${requestingUser}.\nYour database has been reset!`));      
    }
  });
};

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