# HackYourFuture Database Populator
### Quickstart
Create the `hyf.cnf` file.

Run `populate.sh config` for instructions.

Run `populate.sh {step1|step2|step3}` according to your data needs.

### NB: This is destructive! It doesn't just truncate the tables, it drops them. ###

## Serverless Slack bot resetter
This repository now contains the [Serverless Framework](https://serverless.com) code that supports the HackYourFuture
Database Resetter bot.

### Using the bot
From within Slack type `/dbreset`.

### Testing the bot locally
`sls invoke local -f reset`

### Deploying a new version of the bot
`sls deploy`

## Todos
* Currently any HackYourFuture Slack user can invoke the bot and create a database for herself/himself. We could implement a check against a DynamoDB table so that only database students can invoke the bot.
* Add teacher functionality that allows teachers to reset students' databases by typing `/dbreset <user>`. 