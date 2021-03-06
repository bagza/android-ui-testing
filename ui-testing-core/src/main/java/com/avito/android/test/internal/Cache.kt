package com.avito.android.test.internal

import android.content.Context
import com.avito.android.test.waitFor
import org.hamcrest.Matchers.`is`
import org.junit.Assert
import java.io.File
import java.util.*

internal class Cache(private val appContext: Context) {

    private val DELETE_FREQUENCY_MS = 500L
    private val DELETE_TIMEOUT_MS = 5000L

    fun clear() {
        val cacheDir = appContext.cacheDir
        if (cacheDir.list() != null) {
            waitFor(frequencyMs = DELETE_FREQUENCY_MS, timeoutMs = DELETE_TIMEOUT_MS) {
                Assert.assertThat("Can't delete ${cacheDir.path}", deleteRecursive(cacheDir), `is`(true))
            }
        }
    }

    private fun deleteRecursive(directory: File, vararg excludes: String): Boolean {
        if (excludes.isNotEmpty() && Arrays.asList(*excludes).contains(directory.name)) {
            return true
        }

        if (directory.isDirectory) {
            directory.list()?.forEach { content ->
                waitFor(frequencyMs = DELETE_FREQUENCY_MS, timeoutMs = DELETE_TIMEOUT_MS) {
                    Assert.assertThat(
                            "Can't delete file $content in ${directory.path}",
                            deleteRecursive(File(directory, content), *excludes),
                            `is`(true)
                    )
                }
            }
        }
        return directory.delete()
    }
}