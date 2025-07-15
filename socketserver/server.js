import { WebSocketServer } from "ws";
import http from "http";
import { generateFakeStock, readStocks } from "./utils.js";

async function main() {
  const baseStocks = await readStocks("./stocks.json");

  const server = http.createServer();

  const wws = new WebSocketServer({ server });

  wws.on("connection", (ws) => {
    console.log(`Client Connected`);

    const interval = setInterval(() => {
      const fakeStockList = baseStocks.map((baseStock) =>
        generateFakeStock(baseStock)
      );
      ws.send(JSON.stringify(fakeStockList));
    }, 1000);

    ws.on("close", () => {
      console.log("Client disconnected");
      clearInterval(interval);
    });
  });

  const PORT = 8080;
  server.listen(PORT, () => {
    console.log(`WebSocket server running on ws://localhost:${PORT}`);
  });
}

main();
