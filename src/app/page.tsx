import { Button } from "@/components/ui/button";

export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-dvh max-w-xl flex-col justify-center gap-6 px-6 py-16">
      <p className="text-sm text-muted-foreground">Nom de travail : RS Coffee Lab</p>
      <h1 className="text-3xl font-semibold tracking-tight">Le site est en préparation</h1>
      <p>Les commandes en ligne sont fermées pour le moment.</p>
      <Button disabled className="self-start">Commandes fermées</Button>
    </main>
  );
}
