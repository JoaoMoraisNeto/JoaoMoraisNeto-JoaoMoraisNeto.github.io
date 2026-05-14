import React, { Component } from 'react'

class Login extends Component {
    constructor(props){
        super(props)
        this.state = {
            logado: false
        }
    }

    render() {
        return (
            <div>
                {this.state.logado ? <h1>Bem vindo</h1> : <h1>Faça seu login</h1>}
                <button onClick = {() => this.setState({ logado: true })}>Login</button>
                <button onClick = {() => this.setState({ logado: false })}>Logout</button>
            </div>
        )
    }


}
export default Login
