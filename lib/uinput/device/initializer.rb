require 'fcntl'

module Uinput
  class Device
    class Initializer
      def initialize(device, &block)
        @file = Uinput.open_file(Fcntl::O_RDWR | Fcntl::O_NONBLOCK)

        if Uinput.version == 5
          @device = UinputSetup.new

          @abs_x = UinputAbsSetup.new
          @abs_x[:code] = 0
          info = LinuxInput::InputAbsinfo.new
          info[:value] = 0
          info[:minimum] = 0
          info[:maximum] = 2048
          @abs_x[:absinfo] = info

          @abs_y = UinputAbsSetup.new
          @abs_y[:code] = 1
          info = LinuxInput::InputAbsinfo.new
          info[:value] = 0
          info[:minimum] = 0
          info[:maximum] = 2048
          @abs_y[:absinfo] = info

        else
          @device = UinputUserDev.new
        end

        self.name = "Virtual Ruby Device"
        self.type = LinuxInput::BUS_VIRTUAL
        self.vendor = 0
        self.product = 0
        self.version = 0

        instance_exec &block if block

        if Uinput.version >= 5
          @file.ioctl UI_DEV_SETUP, @device.pointer.read_bytes(@device.size)

          # IF ABS-
          @file.ioctl UI_ABS_SETUP, @abs_x.pointer.read_bytes(@abs_x.size)
          @file.ioctl UI_ABS_SETUP, @abs_y.pointer.read_bytes(@abs_y.size)

        else
          @file.syswrite @device.pointer.read_bytes(@device.size)
        end
      end

      def name=(name)
        @device[:name] = name[0,UINPUT_MAX_NAME_SIZE]
      end

      def type=(type)
        @device[:id][:bustype] = (type.is_a? Symbol) ? LinuxInput.const_get(type) : type
      end

      def vendor=(vendor)
        @device[:id][:vendor] = vendor
      end

      def product=(product)
        @device[:id][:product] = product
      end

      def version=(version)
        @device[:id][:version] = version
      end

      # def set_abs_min_max(min, max)
      #   @device[:absmin][0] = min
      #   @device[:absmax][0] = max
      # end

      def add_key(key)
        @file.ioctl(UI_SET_KEYBIT, (key.is_a? Symbol) ? LinuxInput.const_get(key) : key)
      end
      alias_method :add_button, :add_key

      def add_event(event)
        @file.ioctl(UI_SET_EVBIT, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      def add_rel_event(event)
        @file.ioctl(UI_SET_RELBIT, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      def add_abs_event(event)
        @file.ioctl(UI_SET_ABSBIT, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      def abs_setup(event, value)
        @file.ioctl(UI_ABS_SETUP, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      def set_prop(event)
        @file.ioctl(UI_SET_PROPBIT, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      def set_property(event)
        @file.ioctl(UI_SET_PROPBIT, (event.is_a? Symbol) ? LinuxInput.const_get(event) : event)
      end

      
      def create
        if @file.ioctl(UI_DEV_CREATE).zero?
          @file
        end
      end
    end
  end
end
