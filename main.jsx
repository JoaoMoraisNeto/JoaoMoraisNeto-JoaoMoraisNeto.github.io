import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import React, { Component } from 'react'
import Usuario from './componentes/Social'
import Equipe from './componentes/Equipe'
import Contador from './componentes/Contador'
import Relogio from './componentes/Relogio'
import Login from './componentes/Login'
import Lista from './componentes/Lista'
import Contador1 from './componentes/Contador1'


createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Contador1 />
  </StrictMode>,
)
