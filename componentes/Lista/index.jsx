import React, { Component } from 'react'

class Lista extends Component {
    constructor(props){
        super(props)
        this.state = {
            feed: [
                {id:1,nome:'João',curtidas:389},
                {id:2,nome:'Marisa',curtidas:450},
                {id:3,nome:'Jorge',curtidas:700},
            ]
        }
    }

    render() {
        return(
            <div>
                {this.state.feed.map((item) => (
                    <div key={item.id}>
                        <h2>{item.nome}</h2>
                        <h3>{item.curtidas} curtidas</h3>
                    <hr />
                    </div>
                ))}
            </div>
        )
    }
}
export default Lista