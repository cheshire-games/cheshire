-- name: GetCommunity :one
SELECT community_id, name, description, created_at, updated_at
FROM communities
WHERE community_id = $1;

-- name: GetCommunityMembers :many
SELECT c.community_id, c.name as community_name, cm.username, cm.role
FROM communities c
JOIN community_members cm
ON c.community_id = cm.community_id
WHERE c.community_id = $1
ORDER BY cm.role, cm.username;

-- name: CreateCommunity :exec
INSERT INTO communities (name, description)
VALUES ($1, $2)
RETURNING *;

-- name: UpdateCommunity :exec
UPDATE communities
SET name        = $2,
    description = $3,
    updated_at  = CURRENT_TIMESTAMP
WHERE community_id = $1
RETURNING *;

-- name: DeleteCommunity :exec
DELETE
FROM communities
WHERE community_id = $1
RETURNING community_id;

-- name: AddCommunityMembers :copyfrom
INSERT INTO community_members (community_id, username, role)
VALUES ($1, $2, $3);

-- name: DeleteCommunityMembers :batchexec
DELETE
FROM community_members
WHERE community_id = $1
  AND username = ANY($2::varchar[]);
