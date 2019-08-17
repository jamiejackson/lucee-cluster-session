component {
	
	this.name = "session_test_app";
	
	param name="persistSessions" value=(
		(  structKeyExists(server.system.environment, "PERSIST_SESSIONS")
			&& server.system.environment.PERSIST_SESSIONS
		) == true
	);
	
	if (persistSessions) {
		this.cache.connections["session"] = {
			  class: 'lucee.extension.io.cache.redis.RedisCache'
			, storage: true
			, custom: {
				/* Jedis is a client library in Java for Redis. JedisPool creates a pool of connections to Redis 
				* to reuse on demand, a pool that is thread safe and reliable as long as the resource is returned 
				* to the pool when you are done with it. The settings below are configurations for managing the connection pool. 
				* 
				* http://www.baeldung.com/jedis-java-redis-client-library
				* https://commons.apache.org/proper/commons-pool/apidocs/org/apache/commons/pool2/impl/BaseGenericObjectPool.html
				
				/* the minimum number of idle connections to maintain in the pool */
				"setMinIdle":"16", 
				/* whether connection will be validated when they are returned to the pool. 
				* Returning connections that fail validation are destroyed rather then being returned the pool. */
				"setTestOnReturn":"true", 
				/* the minimum amount of time a connections may sit idle in the pool before it is eligible 
				* for eviction */
				"setMinEvictableIdleTimeMillis":"60000", 
				/* the maximum number of connections to test during each run of the idle object evictor thread */
				"setNumTestsPerEvictionRun":"3", 
				/* whether connections sitting idle in the pool will be validated.
				* If the connections fails to validate, it will be removed from the pool and destroyed. */
				"setTestWhileIdle":"true",
				/* the number of milliseconds to sleep between runs of the idle object evictor thread */
				"setTimeBetweenEvictionRunsMillis":"30000",
				/* the maximum number of connections that can be allocated by the pool */
				"setMaxTotal":"128",
				/* whether to block the caller when the pool is exhausted */
				"setBlockWhenExhausted":"true",
				"hosts":"redis:6379",
				/* whether objects borrowed from the pool will be validated. If the object fails to validate, 
				* it will be removed from the pool and destroyed, and a new attempt will be made to borrow 
				* a connection from the pool.*/
				"setTestOnBorrow":"true",
				"namespace":"lucee:session",
				/* the cap on the number of "idle" connections in the pool */
				"setMaxIdle":"128"
			}
			, default: 'object'
		};
		this.sessionStorage = 'session';
		// https://rorylaitila.gitbooks.io/lucee/content/clustering.html#thissessioncluster
		//  true is only needed for round-robin
		this.sessionCluster = true;
	}
		
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	// sets cfid/cftoken
	this.setClientCookies = true;

	function onApplicationStart() {}
	
	function onRequestStart() {
		if (structKeyExists(url, "reload")) {
			onApplicationStart();
			onSessionStart();
		}
		request.persistSessions=persistSessions;
	}
	function onSessionStart() {
		session.onSessionStartLastTriggered=now();
	}
}