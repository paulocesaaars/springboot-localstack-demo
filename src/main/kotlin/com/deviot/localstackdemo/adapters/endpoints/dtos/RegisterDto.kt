package com.deviot.localstackdemo.adapters.endpoints.dtos

import com.deviot.localstackdemo.domain.entities.Register

 class RegisterDto(
    var id: String,
    var type:String) {

    companion object {
        fun to(value: RegisterDto) = Register(value.id, value.type)
    }

}