import { spawnSync } from "node:child_process";
import { readFileSync } from "node:fs";

// Target fixed to this disposable local Docker stack; accepts no URL/remote argument.
const container = "supabase_db_rs-coffee-lab-test";
const pnpm = process.platform === "win32" ? "pnpm.cmd" : "pnpm";

function run(command, args, input) {
  const result = spawnSync(command, args, {
    input,
    encoding: "utf8",
    shell: process.platform === "win32" && command === pnpm,
    stdio: input ? ["pipe", "inherit", "inherit"] : "inherit",
  });
  if (result.error || result.status !== 0) {
    console.error("Local database verification failed; no remote database was targeted.");
    process.exit(result.status || 1);
  }
}

const seed = readFileSync("supabase/seed.sql", "utf8");
const tests = readFileSync("supabase/tests/database.sql", "utf8");
const psql = ["exec", "-i", container, "psql", "-X", "-U", "postgres", "-d", "postgres", "-v", "ON_ERROR_STOP=1"];

// Two complete migration rebuilds, each followed by two seed executions and SQL assertions.
for (let attempt = 1; attempt <= 2; attempt++) {
  console.log(`Local database reproducibility pass ${attempt}/2`);
  run(pnpm, ["exec", "supabase", "db", "reset", "--no-seed"]);
  run("docker", psql, `begin; set local app.environment = 'test';\n${seed}\n${seed}\ncommit;\n`);
  run("docker", psql, tests);
}
console.log("Database constraints, RLS, seed idempotence and rebuilds: PASS");
