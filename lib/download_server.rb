module DownloadServer
  module_function
  def start
    @stop_flag = false
    @fiber = nil
    @thread = Thread.new do
      $logger.debug 'Download Server Started'
      until @stop_flag
        if @fiber.nil?
          if Downloader.has_task?
            $logger.debug 'Proc New Task'
            @downloader = Downloader.start_top_task!
            $logger.debug @downloader
            @fiber = @downloader.fiber
            _update()
            _emit_message("Started: #{@downloader.doujinshi.url}")
          else
            # $logger.debug 'No More Task'
            sleep 2
            next
          end
        elsif @fiber.alive?
          $logger.debug 'Resuming Fiber'
          @fiber.resume
          until @downloader.messages.empty?
            msg = @downloader.messages.pop
            # $logger.debug "Fiber MSG: #{msg}"
            _emit_message(msg)
          end
        else
          $logger.debug 'Task Finished'
          _emit_message("Finished: #{@downloader.doujinshi.url}")
          _update()
          @fiber = nil
        end
      end
      $logger.debug 'Download Server Stopped'
    end
  end
  
  def stop
    @stop_flag = true
  end

  def _emit_message(msg)
    $logger.debug "D MSG: #{msg}"
    $download_server_messager&.call(msg)
    $logger.debug "D MSG SUBMITTED"
  end

  def _update()
    $download_server_status_update_messager&.call()
  end

  def on_message(&block)
    $download_server_messager = block
  end

  def on_update(&block)
    $download_server_status_update_messager = block
  end
end