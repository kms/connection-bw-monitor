#!/usr/bin/ruby1.8
# connection-bw-monitor
# Monitor download bandwidth.
#
# (c) Karl-Martin Skontorp <kms@skontorp.net> ~ http://22pf.org/
# Licensed under the GNU GPL 2.0 or later.

require 'http-access2'
require 'pp'

BIGFILE_URL = "..."

THRESHOLD = 5500.0

MAIL_FROM = "..."
MAIL_SMTP_HOST = "..."
MAIL_SMTP_PORT = 25
MAIL_TO = ["...", "..."]
MAIL_SUBJECT = "Ringa-ding-dingeli-dong!"

startt = Time.new
client = HTTPAccess2::Client.new()
size = client.get(BIGFILE_URL).content.size
endt = Time.new

if size == 0 
    puts ":("
    exit 1
end

speed = ((size / 1000.0) * 8.0 / (endt.to_f - startt.to_f))

if (ARGV[0] == '--mail') 
    if (speed < THRESHOLD)
        msg = "Subject: %s\n\n" % MAIL_SUBJECT
        msg += "Threshold: %.2f\nMeasured: %.2f\n" % [THRESHOLD, speed]

        require 'net/smtp'
        Net::SMTP.start(MAIL_SMTP_HOST, MAIL_SMTP_PORT) do |smtp|
            smtp.send_message msg, MAIL_FROM, MAIL_TO
        end
    end
else 
    puts "%.2f kb/s" % speed
end
