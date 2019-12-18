package org.flame.coworker.main

import io.kungfury.coworker.CoworkerManager
import io.kungfury.coworker.StaticCoworkerConfigurationInput
import io.kungfury.coworker.WorkInserter
import io.kungfury.coworker.dbs.postgres.PgConnectionManager

import java.time.Duration

import kotlin.system.measureTimeMillis

fun main(args: Array<String>) {
    val env = System.getenv()

    var threads = 4
    if (env.containsKey("THREADS")) {
        threads = env["THREADS"]!!.toInt()
    }

    val url = env.getOrDefault("JDBC_URL", "jdbc:postgresql:coworker_development")

    val connManager = PgConnectionManager({ toConfigure ->
        toConfigure.jdbcUrl = url
        toConfigure
    }, null, null)

    val queueTime = measureTimeMillis {
        for (idx in 1..10) {
            WorkInserter.InsertBulkWork(connManager, "org.flame.coworker.jobs.EmptyJob", "", count = 10000)
        }
    }
    System.out.println("Took $queueTime ms. to insert 100,000 jobs in 10 batches of 10000.")

    System.out.println("Starting Coworker with: [ $threads ] Threads.")
    val manager = CoworkerManager(connManager, threads, null, null, StaticCoworkerConfigurationInput(Duration.parse("PT5M"), HashMap()))
    manager.Start()
}
