const express = require('express')
const app = express()
const port = 8080

require('dotenv').config();

app.get('/', (req, res) => res.send('Hello World:'+ process.env.TARGET == "" ? "Not Specified"
 : process.env.TARGET))

app.listen(port, () => console.log(`knative-node-app listening on port ${port}!`))
