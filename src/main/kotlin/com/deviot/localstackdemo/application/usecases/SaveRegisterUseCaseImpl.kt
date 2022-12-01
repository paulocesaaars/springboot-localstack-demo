package com.deviot.localstackdemo.application.usecases

import com.deviot.localstackdemo.domain.ports.out.usecases.SaveRegisterUseCase
import com.deviot.localstackdemo.domain.entities.Register
import com.deviot.localstackdemo.domain.ports.out.repositories.RegisterRepository
import org.springframework.stereotype.Service

@Service
class SaveRegisterUseCaseImpl(
    private val registerRepository: RegisterRepository
) : SaveRegisterUseCase {

    override fun execute(register: Register) {
        registerRepository.save(register)
    }
}