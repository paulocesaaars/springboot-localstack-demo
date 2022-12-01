package com.deviot.localstackdemo.adapters.repositories.dtos

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBRangeKey
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable

@DynamoDBTable(tableName = "registers")
class RegisterDto(
    @field:DynamoDBHashKey
    @field:DynamoDBAttribute(attributeName = "id")
    var id: String,

    @field:DynamoDBRangeKey
    @field:DynamoDBAttribute(attributeName = "type")
    var type: String
) {

}