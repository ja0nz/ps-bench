import React from 'react';
import { jsCounter as Counter } from "../output/PS.Components.Counter.Interop";
import logo from './logo.svg';
import './App.css';
const App = () => {
  return (
    <div className="App">
      <Counter label="Click UP!" />
      <Counter label="Click CONSOLE" onClick={(n: Event) => console.log("clicked: ", n)} />
      <Counter counterType="decrementer" label="Click DOWN!" />
    </div>
  );
};

export default App;
