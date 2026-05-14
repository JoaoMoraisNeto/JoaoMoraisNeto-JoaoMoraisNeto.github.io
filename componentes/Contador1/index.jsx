import React, { useState } from 'react'

function Contador1() {
    const[contador,setContador] = useState(0)

    return(
        <div>
            <h1>{contador}</h1>
            <button onClick={() => setContador(contador + 1)}>+</button>
            <button onClick={() => setContador(contador - 1)}>-</button>
            <button onClick={() => setContador(0)}>Zerar</button>
        </div>
        
    )
}

export default Contador1
