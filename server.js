'use strict';

const express = require('express');

// Constants
const PORT = 9000;
const HOST = 9000;

// App
const app = express();
app.get('/', (req, res) => {
  res.send('<h1 style="color:green;">Java Home App - version-10!!</h1> \n');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
