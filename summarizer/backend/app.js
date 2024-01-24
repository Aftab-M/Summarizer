const {GoogleGenerativeAI, GenerativeModel} = require("@google/generative-ai")

const genAI = new GoogleGenerativeAI('AIzaSyA4yVrlA6QZDcmDiSOjpiidqDNTrW_Y6ps');

async function run(){

    const model = genAI.getGenerativeModel({model: 'gemini-pro'});
    const prompt = "Write a story about a magic backpack";

    const result = await model.generateContent(prompt);
    const resp = await result.response;

    console.log(resp.text());
}

run()


function sendback(abc){
    alert('Called'+abc);
}