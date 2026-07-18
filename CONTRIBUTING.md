# Contributing

This repository is primarily a personal systems configuration, but focused
improvements and fixes are welcome.

## Development workflow

1. Create a branch from `main`.
2. Enter the pinned environment with `nix develop`.
3. Keep host-specific policy under `hosts/` and reusable configuration under
   the appropriate `modules/` directory.
4. Run `just test`.
5. Use a [Conventional Commit](https://www.conventionalcommits.org/) message.

Keep changes scoped and explain any operational trade-offs in the pull request.
Do not commit generated hardware configuration, decrypted secrets, credentials,
or machine-local `.env` files.

Configuration changes must evaluate for every declared host. A successful
evaluation does not replace testing on the affected machine, so note any
deployment validation that remains.
