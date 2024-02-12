CREATE TABLE users
(
    username   VARCHAR(100) PRIMARY KEY,
    email      VARCHAR(100) UNIQUE NOT NULL,
    nickname   VARCHAR(255)        NOT NULL,
    is_deleted BOOLEAN             NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE communities
(
    community_id SERIAL PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    created_by   VARCHAR(100) NOT NULL,
    description  TEXT,
    created_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE community_members
(
    community_id INT          NOT NULL,
    username     VARCHAR(100) NOT NULL,
    role         VARCHAR(15)  NOT NULL,
    PRIMARY KEY (username, community_id),
    FOREIGN KEY (community_id) REFERENCES communities (community_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES users (username) ON DELETE CASCADE
);

CREATE TABLE original_photos
(
    photo_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username    VARCHAR(100) NOT NULL,
    path        VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_public   BOOLEAN      NOT NULL,
    updated_at  TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (username) REFERENCES users (username) ON DELETE CASCADE
);

CREATE TABLE transformed_photos
(
    photo_id    UUID         NOT NULL,
    username    VARCHAR(100) NOT NULL,
    output_type VARCHAR(20)  NOT NULL,
    path        VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (photo_id, output_type),
    FOREIGN KEY (photo_id) REFERENCES original_photos (photo_id) ON DELETE CASCADE
);

