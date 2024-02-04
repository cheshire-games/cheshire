// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.25.0
// source: photos.sql

package raw

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

const deleteOriginalPhotos = `-- name: DeleteOriginalPhotos :exec
DELETE
FROM original_photos
WHERE username = $1
  AND photo_id = ANY($2::uuid[])
`

type DeleteOriginalPhotosParams struct {
	Username string
	Column2  []uuid.UUID
}

func (q *Queries) DeleteOriginalPhotos(ctx context.Context, arg DeleteOriginalPhotosParams) error {
	_, err := q.db.Exec(ctx, deleteOriginalPhotos, arg.Username, arg.Column2)
	return err
}

const deleteTransformedPhotos = `-- name: DeleteTransformedPhotos :exec
DELETE
FROM transformed_photos
WHERE username = $1
  AND photo_id = ANY($2::uuid[])
`

type DeleteTransformedPhotosParams struct {
	Username string
	Column2  []uuid.UUID
}

func (q *Queries) DeleteTransformedPhotos(ctx context.Context, arg DeleteTransformedPhotosParams) error {
	_, err := q.db.Exec(ctx, deleteTransformedPhotos, arg.Username, arg.Column2)
	return err
}

const getUserPhotos = `-- name: GetUserPhotos :many
SELECT o.photo_id, o.path as original_path, t.path as transformed_path
FROM original_photos o
JOIN transformed_photos t
ON o.photo_id = t.photo_id
WHERE o.username = $1
  AND t.output_type = $2
  AND o.uploaded_at >= $3
  AND t.uploaded_at >= $3
`

type GetUserPhotosParams struct {
	Username   string
	OutputType string
	UploadedAt pgtype.Timestamp
}

type GetUserPhotosRow struct {
	PhotoID         uuid.UUID
	OriginalPath    string
	TransformedPath string
}

func (q *Queries) GetUserPhotos(ctx context.Context, arg GetUserPhotosParams) ([]GetUserPhotosRow, error) {
	rows, err := q.db.Query(ctx, getUserPhotos, arg.Username, arg.OutputType, arg.UploadedAt)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GetUserPhotosRow
	for rows.Next() {
		var i GetUserPhotosRow
		if err := rows.Scan(&i.PhotoID, &i.OriginalPath, &i.TransformedPath); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

const setPhotosPrivacy = `-- name: SetPhotosPrivacy :exec
DELETE
FROM original_photos
WHERE username = $1
  AND is_public = $2
  AND photo_id = ANY($3::uuid[])
`

type SetPhotosPrivacyParams struct {
	Username string
	IsPublic bool
	Column3  []uuid.UUID
}

func (q *Queries) SetPhotosPrivacy(ctx context.Context, arg SetPhotosPrivacyParams) error {
	_, err := q.db.Exec(ctx, setPhotosPrivacy, arg.Username, arg.IsPublic, arg.Column3)
	return err
}

type UploadOriginalPhotosParams struct {
	Username string
	Path     string
}

type UploadTransformedPhotosParams struct {
	PhotoID    uuid.UUID
	OutputType string
	Path       string
}
