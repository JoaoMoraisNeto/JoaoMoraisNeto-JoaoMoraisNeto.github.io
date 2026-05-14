import React, { Component } from 'react'

class Relogio extends Component{

    constructor(props){
        super(props)
        this.state = {
            hora: ''
        }
    }

    componentDidMount() {
        setInterval(() => {
            this.setState({ hora: new Date().toLocaleTimeString() })
        },1000)
    }

    render() {
        return <h1>{this.state.hora}</h1>
    }

}

export default Relogio