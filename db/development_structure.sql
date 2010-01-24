CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `scrape_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `uri` text,
  `pdftotext_layout` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `scrape_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `response_code` int(11) DEFAULT NULL,
  `last_modified` varchar(255) DEFAULT NULL,
  `etag` varchar(255) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `content_length` int(11) DEFAULT NULL,
  `response_header` text,
  `uri` text,
  `file_path` text,
  `git_path` text,
  `scrape_job_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scrape_runs_on_scrape_job_id` (`scrape_job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `sluggable_id` int(11) DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT '1',
  `sluggable_type` varchar(40) DEFAULT NULL,
  `scope` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_slugs_on_n_s_s_and_s` (`name`,`sluggable_type`,`scope`,`sequence`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20100119231439');

INSERT INTO schema_migrations (version) VALUES ('20100120165520');

INSERT INTO schema_migrations (version) VALUES ('20100122145210');