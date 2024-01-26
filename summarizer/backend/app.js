const {GoogleGenerativeAI, GenerativeModel} = require("@google/generative-ai")
const express = require('express')
const app = express()
const cors = require('cors')
const genAI = new GoogleGenerativeAI('AIzaSyA4yVrlA6QZDcmDiSOjpiidqDNTrW_Y6ps');
const port = 3000
app.use(cors())
app.use(express.json())


const fs = require('fs')
const pdf = require('pdf-parse')
const axios = require('axios')


app.get('/', (req, res)=>{
    res.send('Hello from the other siiiiiiiiiide !')
})





app.listen(port, ()=>{
    console.log('Server is running...')
})

app.post('/question', async (req, res)=>{run(req, res)})


async function run(req, res){
    var ques = req.body.ques;
    var context = req.body.context;
    console.log(ques)
    console.log(context)



    const model = genAI.getGenerativeModel({model: 'gemini-pro'});
    const prompt = `Answer in 50 words, the question : ${ques}, in context of the following text : ${context}, and if the question is not realted to the context, follow your general answers in short.`;

    const result = await model.generateContent(prompt);
    const resp = await result.response;
    console.log('Response generated !')
    res.send(resp.text());

    console.log(resp.text());

}

// run()


app.post('/parse', async(req, res)=>{
    var text = (await getPdfFromUrl(req.body.url)).toString();
    res.send(text);
})




async function getPdfFromUrl(url){
    // var url = "https://firebasestorage.googleapis.com/v0/b/chatapp-846fc.appspot.com/o/pdfs%2FViewResult1%20(2)%20(1).pdf?alt=media&token=5d8aef4b-c4d8-450c-96e3-49acd6746834";
    // const dataBuffer = fs.readFileSync(url);
    // const data = await pdf(dataBuffer);
    // const text = data.text;
    // console.log('PDF Text is : ')
    // console.log(text)

    try{
        const resp = await axios.get(url, {responseType:'arraybuffer'})

        const data = await pdf(resp.data);
        const text = data.text;
        console.log(text);
        return text;
    }catch(e){console.log(e)}
    
    return "ERR";


}

// getPdfFromUrl()




// 