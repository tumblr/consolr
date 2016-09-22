require 'consolr/runners/runner'

module Consolr
  module Runners
    class Ipmitool < Runner
      def initialize config
        @ipmitool = config.empty? ? 'ipmitool' : config
      end

      def can_run? node
        begin
          not (node.ipmi.address.empty? or node.ipmi.username.empty? or node.ipmi.password.empty?)
        rescue
          false
        end
      end

      def verify node
        Net::Ping::External.new(node.ipmi.address).ping?
      end

      def console node
        cmd 'sol activate', node
      end

      def kick node
        cmd 'sol deactivate', node
      end

      def identify node
        cmd 'chassis identify', node
      end

      def sdr node
        cmd 'sdr elist all', node
      end

      def log_list node
        cmd 'sel list', node
      end

      def log_clear node
        cmd 'sel clear', node
      end

      def on node
        cmd 'power on', node
      end

      def off node
        cmd 'power off', node
      end

      def soft_off node
        cmd 'power soft', node
      end

      def reboot node
        cmd 'power cycle', node
      end

      def soft_reboot node
        cmd 'power reset', node
      end

      def status node
        cmd 'power status', node
      end

      def sensors node
        cmd 'sensor list', node
      end

      def sol_info node
        cmd 'session info active', node
      end

      private
      def cmd action, node
        system("#{@ipmitool} -I lanplus -H #{node.ipmi.address} -U #{node.ipmi.username} -P #{node.ipmi.password} #{action}")
        return $?.exitstatus == 0 ? "SUCCESS" : "FAILED"
      end
    end
  end
end

