-- name: GetUserPhotos :many
SELECT o.photo_id, o.path as original_path, t.path as transformed_path
FROM original_photos o
JOIN transformed_photos t
ON o.photo_id = t.photo_id
WHERE o.username = $1
  AND t.output_type = $2
  AND o.uploaded_at >= $3
  AND t.uploaded_at >= $3;

-- name: UploadOriginalPhotos :copyfrom
INSERT INTO original_photos (username, path)
VALUES ($1, $2);

-- name: UploadTransformedPhotos :copyfrom
INSERT INTO transformed_photos (photo_id, output_type, path)
VALUES ($1, $2, $3);

-- name: SetPhotosPrivacy :exec
DELETE
FROM original_photos
WHERE username = $1
  AND is_public = $2
  AND photo_id = ANY($3::uuid[]);

-- name: DeleteOriginalPhotos :exec
DELETE
FROM original_photos
WHERE username = $1
  AND photo_id = ANY($2::uuid[]);

-- name: DeleteTransformedPhotos :exec
DELETE
FROM transformed_photos
WHERE username = $1
  AND photo_id = ANY($2::uuid[]);
