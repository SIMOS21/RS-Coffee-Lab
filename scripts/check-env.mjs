import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

// Contrôle des fichiers versionnables, sans lire ni journaliser les secrets locaux ignorés.
export function findEnvironmentViolations(files, example) {
  const violations = files.filter((file) => {
    const name = file.split("/").at(-1);
    return (
      (name.startsWith(".env") && file !== ".env.example") ||
      /\.(?:pem|key)$/i.test(name)
    );
  });

  if (example.split(/\r?\n/).some((line) => line.trim() && !line.trim().startsWith("#"))) {
    violations.push(".env.example doit rester sans valeur tant qu'aucune variable applicative n'est requise");
  }
  return violations;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    const files = execFileSync(
      "git",
      ["ls-files", "--cached", "--others", "--exclude-standard", "-z"],
      { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] },
    ).split("\0").filter(Boolean);
    const violations = findEnvironmentViolations(files, readFileSync(".env.example", "utf8"));
    if (violations.length) {
      console.error("Fichiers d'environnement non conformes (aucune valeur affichée) :\n" + violations.join("\n"));
      process.exitCode = 1;
    } else {
      console.log("Environment files: OK (no application variables required).");
    }
  } catch {
    console.error("Impossible de vérifier les fichiers d'environnement ; exécuter depuis la racine du dépôt Git.");
    process.exitCode = 1;
  }
}
