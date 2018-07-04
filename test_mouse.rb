# require 'uinput/device'
require_relative 'lib/uinput/device'

device = Uinput::Device.new do
    self.name = "Virtual mouse device"
    self.type = LinuxInput::BUS_VIRTUAL
    # self.add_key(:KEY_A)

    self.add_event(:EV_REL)
    self.add_event(:EV_KEY)
    self.add_event(:EV_SYN)

    ## Test with ABS
    self.add_event(:EV_ABS)
    self.add_event(:ABS_X)
    self.add_event(:ABS_Y)
    
    self.add_key(:BTN_LEFT)
    self.add_key(:BTN_RIGHT)

    self.add_rel_event(:REL_X)
    self.add_rel_event(:REL_Y)
end


device.send_event(:EV_ABS, :ABS_X, 10)
device.send_event(:EV_ABS, :ABS_Y, 10)
device.send_event(:EV_SYN, :SYN_REPORT)



10.times do 
  device.send_event(:EV_REL, :REL_X, 10)
  device.send_event(:EV_REL, :REL_Y, 10)
  device.send_event(:EV_SYN, :SYN_REPORT)
  sleep 0.2
end

device.destroy
