# README
========
Run:
- env DRES_API_KEY=bazinga DRES_URL=http://<url>/res_events foreman start

example:
- env DRES_API_KEY=bazinga DRES_URL=http://localhost:5000/res_events foreman start

What it does:
=============
- serves as a web ui for these domains:
  - payment transaction read objects
  - acts as a remote mcroservice to consume the payment transaction related events.

TODO:
-----
- Add the DResource reader app to the Consumer rails app! DONE
- Add transaction migration specific migration: DONE
- Add dress specific migrations: DONE
- Subscribe to the payment events to update the transaction read model DONE
- remove transaction from the producer Rails app
- remove the transaction read mode specific code from the producer application.