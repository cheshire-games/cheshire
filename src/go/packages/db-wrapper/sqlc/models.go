// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.25.0

package sqlc

import (
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type Community struct {
	CommunityID int32            `json:"community_id"`
	Name        string           `json:"name"`
	CreatedBy   string           `json:"created_by"`
	Description pgtype.Text      `json:"description"`
	CreatedAt   pgtype.Timestamp `json:"created_at"`
	UpdatedAt   pgtype.Timestamp `json:"updated_at"`
}

type CommunityMember struct {
	CommunityID int32  `json:"community_id"`
	Username    string `json:"username"`
	Role        string `json:"role"`
}

type OriginalPhoto struct {
	PhotoID    uuid.UUID        `json:"photo_id"`
	Username   string           `json:"username"`
	Path       string           `json:"path"`
	UploadedAt pgtype.Timestamp `json:"uploaded_at"`
	IsPublic   bool             `json:"is_public"`
	UpdatedAt  pgtype.Timestamp `json:"updated_at"`
}

type TransformedPhoto struct {
	PhotoID    uuid.UUID        `json:"photo_id"`
	Username   string           `json:"username"`
	OutputType string           `json:"output_type"`
	Path       string           `json:"path"`
	UploadedAt pgtype.Timestamp `json:"uploaded_at"`
}

type User struct {
	Username  string           `json:"username"`
	Email     string           `json:"email"`
	Nickname  string           `json:"nickname"`
	IsDeleted bool             `json:"is_deleted"`
	CreatedAt pgtype.Timestamp `json:"created_at"`
	UpdatedAt pgtype.Timestamp `json:"updated_at"`
}
