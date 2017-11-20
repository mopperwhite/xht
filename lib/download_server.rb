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
          else
            # $logger.debug 'No More Task'
            sleep 1
            next
          end
        elsif @fiber.alive?
          $logger.debug 'Resuming Fiber'
          @fiber.resume
        else
          $logger.debug 'Task Finished'
          @fiber = nil
        end
      end
      $logger.debug 'Download Server Stopped'
    end
  end
  
  def stop
    @stop_flag = true
  end
end