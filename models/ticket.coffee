mongoose = require 'mongoose'

ticketSchema = mongoose.Schema
  case: mongoose.Schema.Types.Mixed

Ticket = mongoose.model 'Ticket', ticketSchema

module.exports = Ticket