package com.deviot.localstackdemo.domain.ports.out.repositories

import com.deviot.localstackdemo.domain.entities.Register

interface RegisterRepository {
    fun save(register: Register)
}