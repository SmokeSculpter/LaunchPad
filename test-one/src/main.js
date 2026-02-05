import './style.css'
import * as signalR from "@microsoft/signalr";


document.querySelector('#app').innerHTML = `
  <div>
    Page one
  </div>
`


const connection = new signalR.HubConnectionBuilder()
  .withUrl("https://localhost:7196/testSocket")
  .build();

connection.on("ReceiveMessage", (message) => {
  console.log(message);
})


connection.start().then(() => console.log("Connected!"))
  .catch(err => console.error(err));