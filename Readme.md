Write side:
-----------
BCs: 
-	Fullfillment:
	- Order: can be deliver or not
		- C:
			- create
			- deliver or abort
		- E:
			- order_created
			- delivered
			- delivery_failed
			- aborted
	- Process:
    - order_created: - P:authorize
    - P: authorization_succeded -> deliver or abort
    - P: authorization_failed -> abort(cause)
    - aborted -> P: release (cause)
    - delivery_failed -> P: release (cause)
    - P:release_failed: ???? : manual_investigate
    - P:release_succeded: - link
    - delivered -> P: capture
    - P: capture_succeded: - link
    - P: capture_failed: - link ???? : manual_investigate
    - ...
- Payment:
  - authorize: 
  	C:
	  - authorize: 
  	E:
  	- authorization_succeded
  	- authorization_failed
  - capture
  	C:
  	- capture(authorization)
  	E:
  	- capture_succeded
  	- capture_failed
  - release
  	C:
  	- release(authorization)
  	E:
  	- release_succeded
  	- release_failed

Read side:
----------
- Transactions:
	subscribe to:
	- authorization_succeded (order_id)
	- capture_succeded
	- release_succeded (order_id, cause: fullfillment abort or delivery failure)
