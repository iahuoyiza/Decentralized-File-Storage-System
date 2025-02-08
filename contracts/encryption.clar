;; Encryption Contract

(define-map file-access-keys
  { file-id: uint }
  {
    encrypted-key: (buff 128),
    allowed-users: (list 20 principal)
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))

(define-public (set-file-access-key (file-id uint) (encrypted-key (buff 128)))
  (let
    (
      (user tx-sender)
      (file (unwrap! (contract-call? .storage get-file file-id) ERR_NOT_FOUND))
    )
    (asserts! (is-eq user (get owner file)) ERR_UNAUTHORIZED)
    (map-set file-access-keys
      { file-id: file-id }
      {
        encrypted-key: encrypted-key,
        allowed-users: (list user)
      }
    )
    (ok true)
  )
)

(define-public (grant-access (file-id uint) (grantee principal))
  (let
    (
      (user tx-sender)
      (access-key (unwrap! (map-get? file-access-keys { file-id: file-id }) ERR_NOT_FOUND))
      (file (unwrap! (contract-call? .storage get-file file-id) ERR_NOT_FOUND))
    )
    (asserts! (is-eq user (get owner file)) ERR_UNAUTHORIZED)
    (map-set file-access-keys
      { file-id: file-id }
      (merge access-key
        { allowed-users: (unwrap! (as-max-len? (append (get allowed-users access-key) grantee) u20) ERR_UNAUTHORIZED) }
      )
    )
    (ok true)
  )
)

(define-read-only (get-file-access-key (file-id uint) (user principal))
  (let
    (
      (access-key (unwrap! (map-get? file-access-keys { file-id: file-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-some (index-of (get allowed-users access-key) user)) ERR_UNAUTHORIZED)
    (ok (get encrypted-key access-key))
  )
)

