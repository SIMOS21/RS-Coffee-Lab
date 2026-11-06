import { describe, expect, it } from "vitest";

// Script Node autonome également exécuté avant l'installation des dépendances en CI.
import { findEnvironmentViolations } from "../../scripts/check-env.mjs";

describe("protection des fichiers d'environnement", () => {
  it("accepte l'exemple commenté et les fichiers applicatifs", () => {
    expect(findEnvironmentViolations([".env.example", "src/app/page.tsx"], "# Aucun secret\n\n")).toEqual([]);
  });

  it.each([".env", ".env.local", ".env.test", ".env.production", "nested/.env.example", "private.pem", "private.key"])(
    "refuse le fichier versionnable %s",
    (file) => {
      expect(findEnvironmentViolations([file], "# Exemple")).toEqual([file]);
    },
  );

  it("refuse une valeur dans l'exemple sans la divulguer", () => {
    const violations = findEnvironmentViolations([".env.example"], "API_KEY=synthetic-test-value");
    expect(violations).toHaveLength(1);
    expect(violations.join()).not.toContain("synthetic-test-value");
  });
});
