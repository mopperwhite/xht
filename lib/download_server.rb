$download_server_start_queue = Queue.new
module DownloadServer
  module_function
  def start
    @stop_flag = false
    @fiber = nil
    @all_task_finished = false
    @thread = Thread.new do |thread|
      # thread.abort_on_exception = true
      $logger.debug 'Download Server Started'
      until @stop_flag
        until $download_server_start_queue.empty?
          downloader = $download_server_start_queue.pop
          downloader.init_meta()
          $logger.debug "Initialize Task #{downloader.task.url}"
          _emit_message("Initialize Task #{downloader.task.url}")
          _update()
        end
        if @fiber.nil?
          if Downloader.has_task?
            $logger.debug 'Proc New Task'
            @downloader = Downloader.start_top_task!(true)
            @fiber = @downloader.fiber
            $logger.debug @downloader
            _update()
            _emit_message("Started: #{@downloader.doujinshi.url}")
          else
            unless @all_task_finished
              $logger.debug 'No More Task'
              @all_task_finished = true
            end
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
        @all_task_finished = false
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

  def add_task(downloader)
    $download_server_start_queue.push(downloader)
  end
end