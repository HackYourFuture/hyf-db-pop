# HackYourFuture Database Populator

## Docker image

Build the docker container if necessary. Then run with:  
`docker run --name=hyf-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=testpass -e HYF_DB_NAME=class6 jasongwartz/hyf-mysql`

Populate the data with this docker command:  
`docker exec -it hyf-mysql bash /populate.sh step3`

To get a shell inside the container, either use:  
`docker exec -it hyf-mysql mysql -u root -p`  
Or follow the guides at: https://hub.docker.com/_/mysql/

## Without docker

Run `populate.sh config` for instructions.

Run `populate.sh {step1|step2|step3}` according to your data needs.

### NB: This is destructive! It doesn't just truncate the tables, it drops them. ###
