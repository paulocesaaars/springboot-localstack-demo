package com.deviot.localstackdemo.adapters.repositories

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper
import com.deviot.localstackdemo.adapters.repositories.dtos.RegisterDto
import com.deviot.localstackdemo.domain.entities.Register
import com.deviot.localstackdemo.domain.ports.out.repositories.RegisterRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository


@Repository
class RegisterRepositoryImpl: RegisterRepository {

    @Autowired
    private lateinit var dynamoDBMapper: DynamoDBMapper

    override fun save(register: Register) {
        val value = RegisterDto(register.id, register.type)
        dynamoDBMapper.save(value)
    }
}