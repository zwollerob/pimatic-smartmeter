module.exports = {
  title: "pimatic-smartmeter device config schemas"
  Smartmeterdevice: {
    title: "Smartmeter config options"
    type: "object"
    #properties:
      ###ip:
        description: "Smartmeter IP-ddress"
        format: String
        default: "10.0.0.0"
      timeout:
        description: "Timeout between requests"
        format: Number
        default: "60000"###
  }
} 
