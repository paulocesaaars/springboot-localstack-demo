package com.deviot.localstackdemo.domain.ports.out.usecases

import com.deviot.localstackdemo.domain.entities.Register

interface SaveRegisterUseCase {
    fun execute(register: Register)
}