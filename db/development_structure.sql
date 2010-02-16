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

CREATE TABLE `parse_runs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scrape_run_uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scrape_commit_sha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scrape_git_path` text COLLATE utf8_unicode_ci,
  `commit_sha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `git_path` text COLLATE utf8_unicode_ci,
  `parser_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_parse_runs_on_parser_id` (`parser_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `parsers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uri_pattern` text COLLATE utf8_unicode_ci,
  `parser_file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_parsers_on_parser_file` (`parser_file`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scrape_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scraper_id` int(11) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scrape_results_on_scraper_id` (`scraper_id`)
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
  `web_resource_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scrape_runs_on_web_resource_id` (`web_resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scraped_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scrape_result_id` int(11) DEFAULT NULL,
  `web_resource_id` int(11) DEFAULT NULL,
  `git_path` text COLLATE utf8_unicode_ci,
  `git_commit_sha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scraped_resources_on_scrape_result_id` (`scrape_result_id`),
  KEY `index_scraped_resources_on_web_resource_id` (`web_resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `scrapers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `namespace` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scraper_file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_scrapers_on_scraper_file` (`scraper_file`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE `web_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uri` text COLLATE utf8_unicode_ci,
  `last_modified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `etag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_path` text COLLATE utf8_unicode_ci,
  `git_path` text COLLATE utf8_unicode_ci,
  `git_commit_sha` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pdftotext_layout` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20100119231439');

INSERT INTO schema_migrations (version) VALUES ('20100120165520');

INSERT INTO schema_migrations (version) VALUES ('20100122145210');

INSERT INTO schema_migrations (version) VALUES ('20100123115650');

INSERT INTO schema_migrations (version) VALUES ('20100126235108');

INSERT INTO schema_migrations (version) VALUES ('20100127005514');

INSERT INTO schema_migrations (version) VALUES ('20100203143831');

INSERT INTO schema_migrations (version) VALUES ('20100216122336');

INSERT INTO schema_migrations (version) VALUES ('20100216122550');