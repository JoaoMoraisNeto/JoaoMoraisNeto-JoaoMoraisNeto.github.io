import React, { Component } from 'react'

class Contador extends Component {
    constructor(props) {
        super(props)
        this.state = {
            contador: 0
        }
    }


    render() {
        return (
            <div>
                <h1>{this.state.contador}</h1>
                <button onClick={() => this.setState({ contador: this.state.contador + 1 })}>+</button>
                <button onClick={() => this.setState({ contador: this.state.contador - 1 })}>-</button>
                <button onClick={() => this.setState({ contador: this.state.contador = 0 })}>Zerar</button>
            </div>
        )
    }

}

export default Contador 