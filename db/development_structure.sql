CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text COLLATE utf8_unicode_ci,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scrape_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `response_code` int(11) DEFAULT NULL,
  `last_modified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `etag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_length` int(11) DEFAULT NULL,
  `response_header` text COLLATE utf8_unicode_ci,
  `uri` text COLLATE utf8_unicode_ci,
  `file_path` text COLLATE utf8_unicode_ci,
  `git_path` text COLLATE utf8_unicode_ci,
  `git_commit_sha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scraper_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scrape_runs_on_scraper_id` (`scraper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scrapers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uri` text COLLATE utf8_unicode_ci,
  `last_modified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `etag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pdftotext_layout` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sluggable_id` int(11) DEFAULT NULL,
  `sequence` int(11) NOT NULL DEFAULT '1',
  `sluggable_type` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_slugs_on_n_s_s_and_s` (`name`,`sluggable_type`,`scope`,`sequence`),
  KEY `index_slugs_on_sluggable_id` (`sluggable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100119231439');

INSERT INTO schema_migrations (version) VALUES ('20100120165520');

INSERT INTO schema_migrations (version) VALUES ('20100122145210');

INSERT INTO schema_migrations (version) VALUES ('20100123115650');