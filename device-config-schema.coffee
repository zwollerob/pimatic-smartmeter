module.exports = {
  title: "pimatic-smartmeter device config schemas"
  Smartmeterdevice: {
    title: "Smartmeter config options"
    type: "object"
    properties:
      serialport:
        description: "Serialport name (e.g. /dev/ttyUSB0)"
        format: String
        default: "/dev/ttyUSB0"

  }
} 
