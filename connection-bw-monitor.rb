#!/usr/bin/ruby1.8

require 'http-access2'
require 'pp'

#BIGFILE_URL = "http://gordons.ginandtonic.no/~kms/1KiB.zero"
#BIGFILE_URL = "http://gordons.ginandtonic.no/~kms/512KiB.zero"
BIGFILE_URL = "http://gordons.ginandtonic.no/~kms/1MiB.zero"
#BIGFILE_URL = "http://gordons.ginandtonic.no/~kms/2MiB.zero"

THRESHOLD = 5500.0

MAIL_FROM = "ringading@vice-chairman.net"
MAIL_SMTP_HOST = "smtp.online.no"
MAIL_SMTP_PORT = 25
MAIL_TO = ["andreas.henden@uloba.no", "kms@skontorp.net"]
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
