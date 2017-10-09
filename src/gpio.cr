require "./gpio/*"

module GPIO
  SYSFS_PATH = "/sys/class/gpio"
  OUTPUT     = "out"
  INPUT      = "in"
  HIGH       = 1
  LOW        = 0

  @@exported = {} of Int32 => IO

  private def self.export(pin : Int32)
    begin
      File.write "#{SYSFS_PATH}/export", pin
      @@exported[pin] = File.open "#{SYSFS_PATH}/gpio#{pin}/value", "r+"
    rescue
      raise "Failed to export pin #{pin}"
    end
  end

  def self.unexport(pin : Int32)
    @@exported.delete(pin).try &.close
    File.write "#{SYSFS_PATH}/unexport", pin
  end

  def self.pin_mode(pin : Int32, mode : String)
    export pin
    File.write "#{SYSFS_PATH}/gpio#{pin}/direction", mode
  end

  def self.write_pin(pin : Int32, value : Int32)
    if io = @@exported[pin]?
      io.pos = 0
      io << value
    else
      pin_mode pin, GPIO::OUTPUT
      write_pin pin, value
    end
  end

  def self.read_pin(pin : Int32) : Int32
    if io = @@exported[pin]?
      io.pos = 0
      io.gets_to_end.to_i32
    else
      pin_mode pin, GPIO::INPUT
      read_pin pin
    end
  end

  def self.read(pin : Int32)
    read_pin pin
  end

  def self.write(pin : Int32, value : Int32)
    write_pin pin, value
  end

  def self.clean_up
    @@exported.each_key do |key|
      unexport key
    end
  end

  class Chip(N)
    def self.base
      File.read "#{SYSFS_PATH}/gpiochip#{N}/base"
    end

    def self.label
      File.read "#{SYSFS_PATH}/gpiochip#{N}/label"
    end

    def self.ngpio
      File.read "#{SYSFS_PATH}/gpiochip#{N}/ngpio"
    end
  end
end
