import React from 'react'

function Perfil(props){
    return(
        <div>
            <h1>meu nome é {props.nome} e tenho {props.idade} anos</h1>
        </div>
    )
}

function Contato(props){
    return(
        <div>
            <h3>email: {props.email}</h3>
            <h3>telefone: {props.telefone}</h3>
        </div>
    )
}

function Usuario(props){
    return(
        <div>
            <Perfil nome = {props.nome} idade = {props.idade} />
            <Contato email = {props.email} telefone = {props.telefone} />
        </div>
    )
}

export default Usuario
