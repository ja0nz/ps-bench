import React from 'react';
import { jsCounter as Counter } from "../output/PS.Components.Counter";
import logo from './logo.svg';
import './App.css';
const App = () => {
  return (
    <div className="App">
      <Counter label="Click me!" />
    </div>
  );
};

export default App;
