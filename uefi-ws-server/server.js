const http = require("http");
const fs = require("fs");
const path = require("path");
const WebSocket = require("ws");

const PORT = process.env.PORT || 8080;

// servidor HTTP
const server = http.createServer((req, res) => {
  let filePath = path.join(__dirname, "public", req.url === "/" ? "test.html" : req.url);
  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(404);
      res.end("Arquivo não encontrado");
    } else {
      res.writeHead(200);
      res.end(content);
    }
  });
});

const wss = new WebSocket.Server({ noServer: true });

wss.on("connection", (ws, req) => {
  console.log("Novo cliente conectado:", req.socket.remoteAddress);

  ws.on("message", (message) => {
    console.log("Mensagem recebida:",  msg.toString("utf-8"));

    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(msg.toString());
      }
    });
  });

  ws.on("close", () => console.log("Cliente desconectado"));
});

server.on("upgrade", (request, socket, head) => {
  if (request.url === "/ws") {
    wss.handleUpgrade(request, socket, head, (ws) => {
      wss.emit("connection", ws, request);
    });
  } else {
    socket.destroy();
  }
});

server.listen(PORT, () => {
  console.log(`Servidor HTTP + WebSocket rodando na porta ${PORT}`);
});
