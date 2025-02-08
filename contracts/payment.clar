;; Payment Contract

(define-map user-balances
  { user: principal }
  { balance: uint }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_INSUFFICIENT_BALANCE (err u402))

(define-public (deposit (amount uint))
  (let
    (
      (user tx-sender)
      (current-balance (default-to { balance: u0 } (map-get? user-balances { user: user })))
    )
    (try! (stx-transfer? amount user (as-contract tx-sender)))
    (map-set user-balances
      { user: user }
      { balance: (+ (get balance current-balance) amount) }
    )
    (ok true)
  )
)

(define-public (withdraw (amount uint))
  (let
    (
      (user tx-sender)
      (current-balance (default-to { balance: u0 } (map-get? user-balances { user: user })))
    )
    (asserts! (>= (get balance current-balance) amount) ERR_INSUFFICIENT_BALANCE)
    (try! (as-contract (stx-transfer? amount tx-sender user)))
    (map-set user-balances
      { user: user }
      { balance: (- (get balance current-balance) amount) }
    )
    (ok true)
  )
)

(define-public (pay-for-storage (amount uint) (storage-node principal))
  (let
    (
      (user tx-sender)
      (current-balance (default-to { balance: u0 } (map-get? user-balances { user: user })))
    )
    (asserts! (>= (get balance current-balance) amount) ERR_INSUFFICIENT_BALANCE)
    (try! (as-contract (stx-transfer? amount tx-sender storage-node)))
    (map-set user-balances
      { user: user }
      { balance: (- (get balance current-balance) amount) }
    )
    (ok true)
  )
)

(define-read-only (get-balance (user principal))
  (default-to { balance: u0 } (map-get? user-balances { user: user }))
)

