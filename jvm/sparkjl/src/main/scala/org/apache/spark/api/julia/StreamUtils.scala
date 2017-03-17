package org.apache.spark.api.julia

import java.io.InputStream

import org.apache.spark.util.RedirectThread
import org.apache.spark._

object StreamUtils {

  /**
   * Redirect the given streams to our stderr in separate threads.
   */
  def redirectStreamsToStderr(stdout: InputStream, stderr: InputStream) {
    try {
      new RedirectThread(stdout, System.err, "stdout reader for julia").start()
      new RedirectThread(stderr, System.err, "stderr reader for julia").start()
    } catch {
      case e: Exception =>
        throw new SparkException("Exception in redirecting streams")
    }
  }

}
