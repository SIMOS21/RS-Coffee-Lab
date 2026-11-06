import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it } from "vitest";

import HomePage from "@/app/page";
import { metadata } from "@/app/layout";
import { cn } from "@/lib/utils";

describe("fondation avant lancement", () => {
  it("annonce la fermeture sans proposer de formulaire ni de lien de commande", () => {
    const html = renderToStaticMarkup(<HomePage />);
    expect(html).toContain("Les commandes en ligne sont fermées");
    expect(html).toMatch(/<button[^>]*disabled=""/);
    expect(html).not.toMatch(/<form|href=/);
  });

  it("empêche l'indexation de la page provisoire", () => {
    expect(metadata.robots).toEqual({ index: false, follow: false });
  });

  it("permet de surcharger les classes Tailwind des primitives", () => {
    expect(cn("px-4", false, undefined, "px-6")).toBe("px-6");
  });
});
