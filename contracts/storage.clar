;; Storage Contract

(define-map files
  { file-id: uint }
  {
    owner: principal,
    size: uint,
    hash: (buff 32),
    storage-node: principal
  }
)

(define-map user-files
  { user: principal }
  (list 100 uint)
)

(define-data-var file-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u401))
(define-constant ERR_NOT_FOUND (err u404))

(define-public (upload-file (size uint) (hash (buff 32)) (storage-node principal))
  (let
    (
      (user tx-sender)
      (file-id (+ (var-get file-nonce) u1))
      (user-file-list (default-to (list) (map-get? user-files { user: user })))
    )
    (map-set files
      { file-id: file-id }
      {
        owner: user,
        size: size,
        hash: hash,
        storage-node: storage-node
      }
    )
    (map-set user-files
      { user: user }
      (unwrap! (as-max-len? (append user-file-list file-id) u100) ERR_UNAUTHORIZED)
    )
    (var-set file-nonce file-id)
    (ok file-id)
  )
)

(define-public (delete-file (file-id uint))
  (let
    (
      (user tx-sender)
      (file (unwrap! (map-get? files { file-id: file-id }) ERR_NOT_FOUND))
    )
    (asserts! (is-eq user (get owner file)) ERR_UNAUTHORIZED)
    (map-delete files { file-id: file-id })
    (ok true)
  )
)

(define-read-only (get-file (file-id uint))
  (map-get? files { file-id: file-id })
)

(define-read-only (get-user-files (user principal))
  (map-get? user-files { user: user })
)

