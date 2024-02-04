-- name: GetUser :one
SELECT username, nickname, created_at, updated_at
FROM users
WHERE username = $1
LIMIT 1;

-- name: GetUserCommunities :many
SELECT c.community_id, c.name AS community_name, cm.username, cm.role
FROM community_members cm
JOIN communities c
ON c.community_id = cm.community_id
WHERE cm.username = $1;

-- name: CreateUser :exec
INSERT INTO users (username, email, nickname, created_at)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: UpdateUser :exec
UPDATE users
SET nickname   = $2,
    updated_at = CURRENT_TIMESTAMP
WHERE username = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE
FROM users
WHERE username = $1
RETURNING username;