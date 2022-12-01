package com.deviot.localstackdemo.adapters.endpoints

import com.deviot.localstackdemo.adapters.endpoints.dtos.RegisterDto
import com.deviot.localstackdemo.domain.ports.out.usecases.SaveRegisterUseCase
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/v1/register")
class RegisterController(private val saveRegisterUseCase: SaveRegisterUseCase) {

    @GetMapping
    fun get() = "Hello word"

    @PostMapping
    fun post(@RequestBody request: RegisterDto) {
        val register = RegisterDto.to(request)
        saveRegisterUseCase.execute(register)
    }


}