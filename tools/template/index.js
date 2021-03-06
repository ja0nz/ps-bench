#!/usr/bin/env node

import { spawn } from "node:child_process";
import { dirname, join } from "node:path";

const [node, cwd, ...args] = process.argv;

const dir = dirname(cwd);
const idx = join(dir, "index.ts");

process.env.TS_NODE_PROJECT = join(dirname(dir), "tsconfig.json");
const p = spawn(node, ["--loader", "ts-node/esm", idx, ...args]);

p.stdout.pipe(process.stdout);
p.stderr.on('data', d => {
  const dStr = d.toString().trim();
  !dStr.includes("ExperimentalWarning") ? console.log(dStr) : "";
});
