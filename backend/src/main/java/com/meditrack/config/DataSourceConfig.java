package com.meditrack.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;

import jakarta.annotation.PostConstruct;
import javax.sql.DataSource;
import java.net.URI;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Configuration class to handle database connection string conversion.
 * 
 * Automatically converts PostgreSQL connection strings from Render's format
 * (postgresql://user:pass@host/db) to JDBC format
 * (jdbc:postgresql://host:port/db)
 * 
 * This allows Render's standard PostgreSQL connection string to work without
 * manual conversion to JDBC format.
 */
@Slf4j
@Configuration
public class DataSourceConfig {

	private static final Pattern POSTGRESQL_URL_PATTERN = Pattern
			.compile("^postgresql://([^:]+):([^@]+)@([^:/]+)(?::(\\d+))?/(.+)$");

	private final Environment environment;

	public DataSourceConfig(Environment environment) {
		this.environment = environment;
	}

	/**
	 * Convert DB_URL environment variable to JDBC format if needed.
	 * This runs early in the Spring lifecycle to ensure the converted value
	 * is available when Spring Boot reads the datasource configuration.
	 */
	@PostConstruct
	public void convertDatabaseUrl() {
		String dbUrl = System.getenv("DB_URL");
		if (dbUrl != null && !dbUrl.startsWith("jdbc:")) {
			String[] converted = convertConnectionString(dbUrl);
			if (converted[0] != null) {
				// Set the converted JDBC URL back to the environment
				System.setProperty("DB_URL", converted[0]);

				// Also set username and password if they were extracted and not already set
				if (converted[1] != null && System.getenv("DB_USERNAME") == null) {
					System.setProperty("DB_USERNAME", converted[1]);
				}
				if (converted[2] != null && System.getenv("DB_PASSWORD") == null) {
					System.setProperty("DB_PASSWORD", converted[2]);
				}

				log.info("Converted DB_URL from PostgreSQL format to JDBC format");
			}
		}
	}

	/**
	 * Converts PostgreSQL connection string to JDBC format and extracts
	 * credentials.
	 * 
	 * @param dbUrl The database URL (can be JDBC format or PostgreSQL format)
	 * @return Array containing [jdbcUrl, username, password]
	 */
	private String[] convertConnectionString(String dbUrl) {
		if (dbUrl == null || dbUrl.isEmpty()) {
			return new String[] { null, null, null };
		}

		// If already in JDBC format, return as-is
		if (dbUrl.startsWith("jdbc:postgresql://")) {
			log.info("DB_URL is already in JDBC format");
			return new String[] { dbUrl, null, null };
		}

		// Try to parse PostgreSQL format: postgresql://user:pass@host:port/db
		Matcher matcher = POSTGRESQL_URL_PATTERN.matcher(dbUrl);
		if (matcher.matches()) {
			String username = matcher.group(1);
			String password = matcher.group(2);
			String host = matcher.group(3);
			String port = matcher.group(4);
			String database = matcher.group(5);

			// Default port is 5432 if not specified
			if (port == null || port.isEmpty()) {
				port = "5432";
			}

			String jdbcUrl = String.format("jdbc:postgresql://%s:%s/%s?connectTimeout=10&socketTimeout=10",
					host, port, database);

			log.info("Converted PostgreSQL connection string to JDBC format");
			log.debug("Host: {}, Port: {}, Database: {}", host, port, database);

			return new String[] { jdbcUrl, username, password };
		}

		// Try URI parsing as fallback
		try {
			URI uri = new URI(dbUrl.replace("postgresql://", "http://"));
			String host = uri.getHost();
			int port = uri.getPort() == -1 ? 5432 : uri.getPort();
			String path = uri.getPath();
			String database = path.startsWith("/") ? path.substring(1) : path;

			// Extract username and password from userInfo
			String userInfo = uri.getUserInfo();
			String username = null;
			String password = null;
			if (userInfo != null && userInfo.contains(":")) {
				String[] credentials = userInfo.split(":", 2);
				username = credentials[0];
				password = credentials[1];
			}

			String jdbcUrl = String.format("jdbc:postgresql://%s:%d/%s?connectTimeout=10&socketTimeout=10",
					host, port, database);

			log.info("Converted PostgreSQL connection string to JDBC format (via URI parsing)");
			log.debug("Host: {}, Port: {}, Database: {}", host, port, database);

			return new String[] { jdbcUrl, username, password };
		} catch (Exception e) {
			log.warn("Could not parse connection string, using as-is: {}", e.getMessage());
			return new String[] { dbUrl, null, null };
		}
	}

	/**
	 * Creates DataSourceProperties bean to configure Spring Boot's DataSource.
	 * This ensures Flyway uses the converted connection string.
	 */
	@Bean
	@Primary
	@ConfigurationProperties("spring.datasource")
	public DataSourceProperties dataSourceProperties() {
		DataSourceProperties properties = new DataSourceProperties();

		String dbUrl = environment.getProperty("DB_URL");
		String dbUsername = environment.getProperty("DB_USERNAME");
		String dbPassword = environment.getProperty("DB_PASSWORD");

		// Convert connection string if needed
		String[] converted = convertConnectionString(dbUrl);
		String jdbcUrl = converted[0];
		String extractedUsername = converted[1];
		String extractedPassword = converted[2];

		// Use extracted credentials if DB_USERNAME/DB_PASSWORD are not set
		if (jdbcUrl != null) {
			properties.setUrl(jdbcUrl);

			if (dbUsername == null || dbUsername.isEmpty()) {
				dbUsername = extractedUsername;
			}
			if (dbPassword == null || dbPassword.isEmpty()) {
				dbPassword = extractedPassword;
			}
		} else if (dbUrl != null) {
			// Fallback: use as-is if conversion failed
			properties.setUrl(dbUrl);
		}

		// Set username and password
		if (dbUsername != null && !dbUsername.isEmpty()) {
			properties.setUsername(dbUsername);
		}
		if (dbPassword != null && !dbPassword.isEmpty()) {
			properties.setPassword(dbPassword);
		}

		log.info("Configured DataSourceProperties with URL: {}",
				properties.getUrl() != null ? properties.getUrl().replaceAll(":[^:@]+@", ":****@") : "null");

		return properties;
	}

	/**
	 * Creates and configures the DataSource bean using the converted properties.
	 * Flyway will automatically use this DataSource.
	 */
	@Bean
	@Primary
	public DataSource dataSource(DataSourceProperties properties) {
		return properties.initializeDataSourceBuilder()
				.driverClassName("org.postgresql.Driver")
				.build();
	}
}
