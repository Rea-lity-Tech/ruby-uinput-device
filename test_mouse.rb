require 'uinput/device'

device = Uinput::Device.new do
    self.name = "Virtual mouse device"
    self.type = LinuxInput::BUS_VIRTUAL
    # self.add_key(:KEY_A)

    self.add_event(:EV_REL)
    self.add_event(:EV_KEY)
    self.add_event(:EV_SYN)

    self.add_key(:BTN_LEFT)
    self.add_key(:BTN_RIGHT)
    self.add_rel_event(:REL_X)
    self.add_rel_event(:REL_Y)
end


10.times do 
  device.send_event(:EV_REL, :REL_X, 10)
  device.send_event(:EV_REL, :REL_Y, 10)
  device.send_event(:EV_SYN, :SYN_REPORT)
  sleep 0.2
end

device.destroy
