CREATE DATABASE instagram_clone;

USE instagram_clone;

SELECT DATABASE();

CREATE TABLE users(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photos(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE comments(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    comment_text VARCHAR(255) NOT NULL,
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(photo_id) REFERENCES photos(id)
);


CREATE TABLE likes(
    user_id INT NOT NULL,
    photo_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    PRIMARY KEY(user_id, photo_id) 
);

CREATE TABLE follows(
    follower_id INT NOT NULL,
    followee_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(follower_id) REFERENCES users(id),
    FOREIGN KEY(followee_id) REFERENCES users(id),
    PRIMARY KEY(follower_id, followee_id)
);

CREATE TABLE tags(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags(
    photo_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY(photo_id) REFERENCES photos(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id),
    PRIMARY KEY(photo_id, tag_id)
);


SELECT * FROM users ORDER BY created_at LIMIT 5; 

SELECT username, DAYNAME(created_at) AS day, COUNT(*) AS total FROM users GROUP BY day ORDER BY total DESC LIMIT 1; 

SELECT username FROM users
LEFT JOIN photos  
ON users.id = photos.user_id
WHERE photos.user_id IS NULL;

SELECT username, image_url, COUNT(*) AS total_likes FROM photos
JOIN likes
ON photos.id = likes.photo_id
JOIN users
ON users.id = photos.user_id
GROUP BY likes.photo_id 
ORDER BY total_likes DESC LIMIT 1;


SELECT username, image_url, COUNT(*) AS total_likes FROM photos
JOIN likes
ON photos.id = likes.photo_id
JOIN users
ON users.id = photos.user_id
GROUP BY photos.id 
ORDER BY total_likes DESC LIMIT 1;

SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS asg;


SELECT tags.tag_name, COUNT(*) AS total FROM photo_tags
JOIN tags
ON photo_tags.tag_id = tags.id
GROUP BY tags.id 
ORDER BY total DESC LIMIT 5;

SELECT username, Count(*) AS num_likes FROM users
INNER JOIN likes 
ON users.id = likes.user_id 
GROUP  BY likes.user_id 
HAVING num_likes = (SELECT Count(*) FROM photos); 