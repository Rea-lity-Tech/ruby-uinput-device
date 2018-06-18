
#require 'uinput/device'
require_relative 'lib/uinput/device'

## may require
# modprobe uinput

device = Uinput::Device.new do
    self.name = "Virtual touch device"
    self.type = LinuxInput::BUS_VIRTUAL
    # self.add_key(:KEY_A)

    self.add_key(:BTN_TOUCH)
    
    # self.add_event(:EV_REL)
    self.add_event(:EV_ABS)
    self.add_event(:EV_SYN)

    self.add_event(:ABS_X)
    self.add_event(:ABS_Y)
        
    self.add_abs_event(:ABS_MT_TOUCH_MAJOR)
    self.add_abs_event(:ABS_MT_POSITION_X)
    self.add_abs_event(:ABS_MT_POSITION_Y)
    self.add_abs_event(:ABS_MT_TRACKING_ID)
    self.add_abs_event(:ABS_MT_SLOT)

    # self.add_abs_event(:ABS_MT_WIDTH_MAJOR)
    # self.add_abs_event(:ABS_MT_PRESSURE)

    ## How to do this ?
    # self.absmax = :ABS_MT_TOUCH_MAJOR] = 64
    # self.absmax[:ABS_MT_WIDTH_MAJOR] = 64
    # self.absmax[:ABS_MT_POSITION_X] = 1920
    # self.absmax[:ABS_MT_POSITION_Y] = 1080
    # self.absmax[:ABS_MT_TRACKING_ID] = 65535
    # self.absmax[:ABS_MT_SLOT] = 9
    # self.absmax[:ABS_MT_PRESSURE] = 64
end



x = [20, 30]
y = [50, 30]

device.send_event(:EV_ABS, :ABS_MT_POSITION_X , x[0])
device.send_event(:EV_ABS, :ABS_MT_POSITION_Y , y[0])
device.send_event(:EV_SYN, :SYN_MT_REPORT)
sleep(0.2)
device.send_event(:EV_ABS, :ABS_MT_POSITION_X , x[1])
device.send_event(:EV_ABS, :ABS_MT_POSITION_Y , y[1])
device.send_event(:EV_SYN, :SYN_MT_REPORT)
device.send_event(:EV_SYN, :SYN_REPORT)
sleep(0.2)

device.send_event(:EV_ABS, :ABS_MT_POSITION_X, x[1])
device.send_event(:EV_ABS, :ABS_MT_POSITION_Y, y[1])
device.send_event(:EV_SYN, :SYN_MT_REPORT)
device.send_event(:EV_SYN, :SYN_REPORT)
sleep(0.2)

device.send_event(:EV_SYN, :SYN_MT_REPORT)
device.send_event(:EV_SYN, :SYN_REPORT)
sleep(0.2)






device.destroy
