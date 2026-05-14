import React, { useState,useEffect } from 'react'
import axios from 'axios'

function Axios() {
    const [cursos,setCursos] = useState([])

    useEffect(() => {
        axios.get('https://fake-api.dev/courses')
        .then(response => {
            setCursos(response.data)
        })
    }, [])

    return(
        <div>
            {cursos.map((item) => (
            <div key={item.id}>
                <h1>{item.name}</h1>
                <h2>{item.category}</h2>
            </div>
            ))}
        </div>
    )
}
export default Axios