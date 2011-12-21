require "logger"

class SimpleLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    begin
      # "#{timestamp.to_formatted_s(:db)} rails[#{$PID}]  #{severity}: #{msg2str(msg).gsub(/\n/, '').lstrip}\n"
      "#{timestamp.to_formatted_s(:db)} rails[#{$PID}]  #{severity}: #{msg2str(msg).lstrip}\n"
    rescue
      "#{timestamp.to_formatted_s(:db)} rails[#{$PID}]  #{severity}: #{msg}\n" 
    end
  end
  
  private

  def hostname
    @parsed_hostname ||= Socket.gethostname.split('.').first
  end

  def msg2str(msg)
    case msg
    when ::String
      msg
    when ::Exception
      "#{ msg.message } (#{ msg.class }): " <<
      # (msg.backtrace || []).join(" | ")
      (msg.backtrace || []).join("\r\n")
    else
      msg.inspect
    end
  end
  

end