-- 创建数据库
CREATE DATABASE swift_fluent_test DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE swift_fluent_test;

-- 创建user表
CREATE TABLE user (
	id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(255) NOT NULL COMMENT '用户名',
	PRIMARY KEY(id)
);

-- 创建article表
CREATE TABLE article (
	id INT NOT NULL AUTO_INCREMENT,
	title VARCHAR(255) NOT NULL	COMMENT '标题',
	content LONGTEXT NOT NULL	COMMENT '正文',
	authorId INT NOT NULL	COMMENT '作者Id',
	cover VARCHAR(255) NULL COMMENT '封面',
	PRIMARY KEY(id)
);
