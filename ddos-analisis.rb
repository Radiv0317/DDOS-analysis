require 'socket'
require 'colorize'
require 'json'
require 'date'

# Pengaturan konfigurasi
threshold = 100
duration = 60
requests = Hash.new { |hash, key| hash[key] = [] }

server = TCPServer.new('192.168.1.6', 80)
puts 'Server is listening on port 80...'.green

server_info = { cpu_load: 0.0, memory_usage: 0.0 }
activity_logs = []
log_mutex = Mutex.new

url_requests = Hash.new(0)

# Fungsi untuk menyimpan data aktivitas ke file
def save_activity_logs(logs, log_file)
  File.open(log_file, 'a') do |file|
    logs.each do |log|
      file.puts(log.to_json)
    end
  end
end

# Fungsi untuk melakukan analisis DDoS
def perform_ddos_analysis(url_requests, threshold, duration)
  suspicious_ips = []
  
  url_requests.each do |ip, requests|
    if requests.count > threshold
      # Jika permintaan melebihi ambang batas, tambahkan IP ke daftar mencurigakan
      suspicious_ips << ip
    end
  end

  if suspicious_ips.empty?
    'No DDoS attack detected'
  else
    "DDoS attack detected from IPs: #{suspicious_ips.join(', ')}"
  end
end

Thread.new do
  loop do
    begin
      client = server.accept
      request = client.gets
      client.close
      ip = client.peeraddr[3]

      requests[ip] << Time.now
      requests[ip].select! { |time| Time.now - time <= duration }

      if requests[ip].count > threshold
        log_mutex.synchronize do
          log_file = File.join('C:/Users/hp/Documents/DDOS-analysis/var/log/', 'activity.log')
          current_datetime = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
          activity_log = { timestamp: current_datetime, event: "DDoS attack detected from #{ip}" }
          activity_logs << activity_log
          save_activity_logs(activity_logs, log_file)
        end
        puts "DDoS attack detected from #{ip}!".red
        puts "Warning: Suspicious activity detected!".yellow
      else
        log_mutex.synchronize do
          log_file = File.join('C:/Users/hp/Documents/DDOS-analysis/var/log/', 'activity.log')
          current_datetime = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
          activity_log = { timestamp: current_datetime, event: "Request received from #{ip}" }
          activity_logs << activity_log
          save_activity_logs(activity_logs, log_file)
        end
        puts "Request from #{ip} has been received.".green
      end

      url = request.split(' ')[1]
      url_requests[url] += 1
    rescue StandardError => e
      puts "Error: #{e.message}".yellow
    end
  end
end

loop do
  sleep 10
  puts "DDoS analysis is in progress...".cyan

  most_requested_url, request_count = url_requests.max_by { |_, count| count }

  if most_requested_url
    puts "Most requested URL: #{most_requested_url} (requested #{request_count} times)".blue
  else
    puts "No recorded URL requests.".blue
  end

  server_info[:cpu_load] = rand(0.0..100.0)
  server_info[:memory_usage] = rand(0.0..100.0)
  puts "Server Monitoring - CPU Load: #{server_info[:cpu_load]}%, Memory Usage: #{server_info[:memory_usage]}%".blue

  current_datetime = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
  analysis_result = perform_ddos_analysis(requests, threshold, duration)

  log_mutex.synchronize do
    log_file = File.join('C:/Users/hp/Documents/DDOS-analysis/var/log/', 'activity.log')
    activity_log = { timestamp: current_datetime, event: analysis_result }
    activity_logs << activity_log
    save_activity_logs(activity_logs, log_file)
  end
end
