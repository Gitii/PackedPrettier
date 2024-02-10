import("npm:prettier/internal/cli.mjs")
  .then(cli => cli.run(Deno.args));
