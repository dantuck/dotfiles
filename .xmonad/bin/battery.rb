# Originally by Wael Nasreddine <wael@phoenixlinux.org>.
#
# Made a standalone script for usage with xmonad by Patrick Hof
# <patrickhof@web.de>
# Last Change: 2007-12-22

class Battery

  STATUSFILE = '/sys/class/power_supply/BAT1/status'
  CAPACITYFILE = '/sys/class/power_supply/BAT1/capacity'

  STATEFILE = '/proc/acpi/battery/BAT1/state'
  INFOFILE =  '/proc/acpi/battery/BAT1/info'
  LOW =  15
  LOW_ACTION = 'echo "Low battery" | xmessage -center -buttons quit:0 -default quit -file -'
  CRITICAL = 5
  CRITICAL_ACTION = 'echo "Critical battery" | xmessage -center -buttons quit:0 -default quit -file -'

  def initialize
    @warned_low = false
    @warned_critical = false
  end

  def battery
    status = IO.readlines(STATUSFILE)[0].chomp
    capacity = IO.readlines(CAPACITYFILE)[0].chomp.to_f
    battpresent = IO.readlines('/sys/class/power_supply/BAT1/present')[0].chomp
    if battpresent == "1"
      # Take action in case battery is low/critical
      if status == "Discharging" && capacity <= CRITICAL
        unless @warned_critical
          system("slock && systemctl hybrid-sleep")
          #system("ssid #{CRITICAL_ACTION} &")
          @warned_critical = true
        end
      elsif status == "Discharging" && capacity <= LOW
        unless @warned_low
          #system("ssid #{LOW_ACTION} &")
          @warned_low = true
        end
      else
        @warned_low = false
        @warned_critical = false
      end
      status = "=" if status == "Charged" || ( status == "Discharging" && capacity >= 97 )
      status = "^" if status == "Charging"
      status = "v" if status == "Discharging"
      text = "#{status} #{capacity}"
      return text
    else
      return "N/A"
    end
  end
end
