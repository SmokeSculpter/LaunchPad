import './style.css'
import * as signalR from "@microsoft/signalr";


const connection = new signalR.HubConnectionBuilder()
  .withUrl("https://localhost:7196/testSocket")
  .build();

connection.on("UpdateUsers", (message) => {
  console.log(message);
})


connection.start().then(() => console.log("Connected!"))
  .catch(err => console.error(err));

