import fs from "node:fs/promises";

/**
 * Reads the contents of a JSON file and parses it.
 * @param {string} path - The path to the JSON file.
 * @returns {Promise<Object>} Parsed JSON content.
 */
async function readStocks(path) {
  try {
    const data = await fs.readFile(path.trim(), "utf-8");
    return JSON.parse(data);
  } catch (error) {
    console.error("Error reading stock file:", error);
  }
}

function generateFakeStock(baseStock) {
  const fluctuation = (Math.random() * 2 - 1) * 2; // -2 to +2
  const newBuyPrice = +(baseStock.buyPrice + fluctuation).toFixed(2);
  const newSellPrice = +(newBuyPrice + 0.01).toFixed(2);
  const change = +(newBuyPrice - baseStock.buyPrice).toFixed(2);
  const changePercent = +((change / baseStock.buyPrice) * 100).toFixed(2);

  return {
    symbol: baseStock.symbol,
    name: baseStock.name,
    expiry: baseStock.expiry,
    buyPrice: newBuyPrice,
    sellPrice: newSellPrice,
    change: change,
    changePercent: changePercent,
    high: Math.max(newBuyPrice, baseStock.high),
    low: Math.min(newBuyPrice, baseStock.low),
    timestamp: new Date().toISOString(),
  };
}

export { readStocks, generateFakeStock };
