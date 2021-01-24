use vk;

DROP TABLE IF EXISTS conversation;
CREATE TABLE conversation(
id serial,
created_at DATETIME DEFAULT NOW(),
name VARCHAR(150) UNIQUE,
admin_user_id BIGINT UNSIGNED NOT null,

foreign key (admin_user_id) references users(id)
);


DROP TABLE IF EXISTS users_conversation;
CREATE TABLE users_conversation(
	user_id BIGINT UNSIGNED NOT NULL,
	conversation_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, conversation_id), -- чтобы не было 2 записей о пользователе и беседе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (conversation_id) REFERENCES conversation(id)
);

DROP TABLE IF EXISTS community_types;
CREATE TABLE community_types(
id serial,
name VARCHAR(255)
);