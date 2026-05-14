import React, { Component } from 'react'

class Equipe extends Component {
    render() {
        return(
            <div>
                <h1>Olá {this.props.nome}!</h1>
            </div>
        )
    }
}
export default Equipe