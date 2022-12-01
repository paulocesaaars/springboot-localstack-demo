#!/bin/bash
set -e

COMMAND="$1"
blue=$'\e[1;34m]'
cyan=$'\e[1;36m]'
white=$'\e[0m'

APP_NAME=`grep 'appName' gradle.properties | cut -d'=' -f2-`
USER=$(whoami)

AWS_ACCESS_KEY="default_access_key"
AWS_SECRET_ACCESS="default_secret_key"
AWS_REGION="sa-east-1"
AWS_DEFAULT_OUTPUT="json"
DINAMODB_TABLE="registers"

#
#-------------------------------------------------------------------------------
## AWS Local configuration
#-------------------------------------------------------------------------------
aws_configure_values(){
    log_debug aws configure set aws_access_key_id $AWS_ACCESS_KEY
    log_debug aws configure set aws_secret_access_key_id $AWS_SECRET_ACCESS
    log_debug aws configure set default.region $AWS_REGION
    log_debug aws configure set default.output $AWS_DEFAULT_OUTPUT
}

#
#-------------------------------------------------------------------------------
## App Build and Startup
#-------------------------------------------------------------------------------
app_buid(){
    log_debug ./gradlew clean build
}

build_container_app(){
    echo "Building app $APP_NAME container..."
    log_debug docker-compose -f docker-compose-infra.yaml build --no-cache app
}

start_container_app(){
    echo "Startup app $APP_NAME container..."
    log_debug docker-compose -f docker-compose-infra.yaml up -d app
}

remove_container_app(){
    echo "Delete app $APP_NAME container..."
    if [ "$(docker ps -q -f name=app)"]; then
        log_debug docker stop app
        log_debug docker rm app
    else
        echo "Container app not exists"
    fi
}

#
#-------------------------------------------------------------------------------
## LOCALSTACK
#-------------------------------------------------------------------------------

remove_container_localstack(){
    echo "Delete localstack container..."
    if [ "$(docker ps -q -f name=localstack)"]; then
        log_debug docker stop localstack
        log_debug docker rm localstack
    else
        echo "Container localstack not exists"
    fi
}

start_container_localstack(){
    if [ ! "$(docker ps -q -f name=localstack)"]; then
        echo "Start localstack container..."
        log_debug docker-compose -f docker-compose-infra.yaml up -d localstack
        
        secs=$((15))
        while [$secs -gt 0]; do
            echo -ne "$secs\033[0K\r"
            sleep 1
            : $((secs--))
        done

    else
        echo "Container already exists. Will not be started."
    fi
}

delete_dynamodb(){
    if log_debug aws --endpoint-url=http://localhost:4566 dynamodb delete-table --table-name $DINAMODB_TABLE; then
        log_info "Table $DINAMODB_TABLE in dynamo deleted successfully"
    else
        echo "Table $DINAMODB_TABLE in dynamodb does not exists"
    fi
}

create_dynamodb(){
    echo "Creating table in dinamodb"
    if log_debug aws dynamodb --endpoint-url=http://localhost:4566 create-table --table-name $DINAMODB_TABLE --attribute-definitions \
        AttributeName=id,AttributeType=S \
        AttributeName=type,AttributeType=S \
        --key-schema AttributeName=id,KeyType=HASH AttributeName=type,KeyType=RANGE --provisioned-throughput ReadCapacityUnits=10,WriteCapacityUnits=5; then
            log_info "Table $DINAMODB_TABLE in dynamodb created successfully"
    else
        echo "Table $DINAMODB_TABLE in dinamodb creation failed"
    fi
}

#
#-----------------------------------------------------------------------------------
#
log_date(){
    echo $(date '+%Y-%m-%d %H:%M:%S') $@
}

log_debug(){
    log_date "DEBUG: " $cyan$@$white
    "$@"
}

log_info(){
    echo "------------------"
    log_date "INFO: " $blue$@$white
    echo "------------------"
}

#======================================================================================
## COMMANDS
#======================================================================================

init_command(){
    echo "#============================================================================"
    echo " Init $APP_NAME environment"
    echo "#============================================================================"

    #steps:
    aws_configure_values
    #remove_container_app
    #start_container_app
    remove_container_localstack
    start_container_localstack
    delete_dynamodb
    create_dynamodb

    log_info "Finished project initialization"
}

clean_command() {
    echo "#============================================================================"
    echo " Clean $APP_NAME environment"
    echo "#============================================================================"

    #steps:
    remove_container_app
    remove_container_localstack

    log_info "Finished project cleanup"
}

show_log(){
    unset CONTAINER_NAME
    CONTAINER_NAME=$1

    docker logs -f $CONTAINER_NAME
}

update_container(){
    unset CONTAINER_NAME
    CONTAINER_NAME=$1

    echo "Update image $CONTAINER_NAME"
    log_debug docker-compose -f docker-compose-infra.yaml build --no-cache $CONTAINER_NAME

    echo "Update image $CONTAINER_NAME"
    log_debug docker-compose -f docker-compose-infra.yaml up -d $CONTAINER_NAME
}

#======================================================================================
## INTERFACE
#======================================================================================

case "${COMMAND}" in
    init )
            init_command
            exit 0
            ;;
    initall )
            clean_command
            init_command
            exit 0
            ;;
    update )
            update_container $2
            exit 0
            ;;
    clean )
            clean_command
            exit 0
            ;;
    logapp )
            show_log app
            exit 0
            ;;
    log )
            show_log $2
            exit 0
            ;;
    *)
            echo $"Usage: $0 {init|initall|clean|log}"
            exit 1
esac
exit 0
