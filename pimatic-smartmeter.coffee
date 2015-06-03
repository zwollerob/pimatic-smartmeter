# #Plugin pimatic-smartmeter

module.exports = (env) ->

  Promise = env.require 'bluebird'
  
#  assert = env.require 'cassert'

  class Smartmeter extends env.plugins.Plugin

    init: (app, @framework, @config) =>      

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("Smartmeterdevice", {
        configDef: deviceConfigDef.Smartmeterdevice,
        createCallback: (config) => new Smartmeterdevice(config)
      })      

  class Smartmeterdevice extends env.devices.Sensor

    attributes:
      actualusage:
        description: "Actual usage"
        type: "number"
        unit: ' Watt'
      counter:
        description: "Total energy count"
        type: "number"
        unit: ' kWh'

    actualusage: 0.0
    counter: 0.0

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @uuid = @config.uuid
      super()

      P1DataStream = require "./p1meterdata"
      p1datastream = new P1DataStream({portName: "/dev/ttyUSB0"})
      p1datastream.on 'data', (data) =>
        @emit "actualusage", Number data.currentUsage
        @emit "counter", Number data.rateOneTotalUsage


    getActualusage: -> Promise.resolve @actualusage
    getCounter: -> Promise.resolve @counter

  plugin = new Smartmeter
  return plugin
