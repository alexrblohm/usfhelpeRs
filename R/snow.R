#' Snowflake Connector
#'
#' This function sets up a connection with Snowflake
#'
#' @param path_jar (str) Path to the snowflake .jar file.  Default set in docker container
#' @return The JDBC driver
#' @example driver <- SnowflakeConnector()
#' @export
SnowflakeConnector <- function(path_jar = "/home/rstudio/project/snowflake-jdbc-3.11.1.jar"){
  options(java.parameters = "-Xmx12072m")

  jdbcDriver <- dplyr.snowflakedb::JDBC(driverClass="com.snowflake.client.jdbc.SnowflakeDriver",
                                        classPath=path_jar)
  return(jdbcDriver)
}


#' Fetch Data
#'
#' This function uses the SnowflakeConnector to pull a data set.
#'
#' @param query (str) The SQL query to execute
#' @param jdbc_Driver The driver from the SnowflakeConnector
#' @param path_env (str) Path to .env file with credentials.  Default set in dockercontainer
#' @param snowflake_username (str) Username, default from .env
#' @param snowflake_password (str) password, default from .env
#' @param warehouse (str) warehouse, default "USER_ADHOC"
#' @param role (str) role, default "BUSINESS_ANALYTICS
#' @param database (str) database, default "GOLD"
#' @param schema (str) schema, defaul "XDMADM"
#' @return Data Frame
#' @example
#' driver <- SnowflakeConnector()
#' q <- "SELECT * FROM GOLD.MRKT_FRCST.STG_WEATHER LIMIT 5"
#' fetch_data(query = q)
#' @export
fetch_data <- function(query,
                       jdbc_Driver=jdbcDriver,
                       path_env = "/home/rstudio/project/.env",
                       snowflake_username=Sys.getenv('SNOWFLAKE_USER'),
                       snowflake_password=Sys.getenv('SNOWFLAKE_PASSWORD'),
                       warehouse="USER_ADHOC",
                       role="BUSINESS_ANALYTICS",
                       database="GOLD",
                       schema="XDMADM"){

  readRenviron(path_env)

  jdbcConnection <- dbConnect(jdbc_Driver,
                              "jdbc:snowflake://usfoods.snowflakecomputing.com",
                              snowflake_username,
                              snowflake_password)
  dbSendQuery(jdbcConnection, paste0("USE WAREHOUSE ", warehouse))
  dbSendQuery(jdbcConnection, paste0("USE ROLE ", role))
  dbSendQuery(jdbcConnection, paste0("USE DATABASE ", database))
  dbSendQuery(jdbcConnection, paste0("USE SCHEMA ", schema))
  return (dbGetQuery(jdbcConnection, query))
}

#R CMD javareconf
#https://github.com/snowflakedb/dplyr-snowflakedb

