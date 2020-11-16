const postmanToOpenApi = require('postman-to-openapi')

const postmanCollection = './foursquare.postman_collection.json'
const outputFile = './foursquare-openapi.yaml'

let fs = require('fs');
let postman = require('postman-to-openapi/lib/index');

convert();

async function convert() {
    const result = await postmanToOpenApi(postmanCollection, outputFile, {defaultTag: 'API'})
}
