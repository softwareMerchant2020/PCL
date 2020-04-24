//
//  Constants.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/16/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

let baseURL = "https://pclwebapi.azurewebsites.net/api/"
let totalSpecimens = "admin/GetTotalSpecimensCollected"
let addCustomerURL = "Customer/AddCustomer"
let getCustomerURL = "Customer/GetCustomer"
let updateCustomer = "Customer/UpdateCustomer"
let addDriver = "driver/AddDriver"
let getDriver = "driver/GetDriver"
let updateDriver = "driver/UpdateDriver"
let deleteDriverAPI = "driver/DeleteDriver?DriverId="
let driverLogin = "driver/DriverLogin"
let driverSignUp = "driver/DriverSignUp"
let addDriverLocation = "driver/AddDriverLocation"
let addRoute = "Route/AddRoute"
let getRoute = "Route/GetRoute"
let getLatestRouteNumber = "Route/GetLatestRouteNumber"
let getRouteDetail = "Route/GetRouteDetail"
let editRoute = "Route/EditRoute"
let getVehicle = "vehicle/GetVehicle"
let addVehicleAPI = "vehicle/AddVehicle"
let updateVehicleAPI = "vehicle/UpdateVehicle"
let deleteVehicleAPI = "vehicle/DeleteVehicle?VehicleId="
let getAvailableCustomer = "Customer/GetAvailableCustomer"
let getAvailableDriver = "driver/GetAvailableDriver"
let getAvailableVehicle = "vehicle/GetAvailableVehicle"
let addUpdateTransactionStatus = "admin/AddUpdateTransactionStatus"
let getAdminDetails = "admin/GetDetailForAdmin"
let getTotalSpecimensCollected = "admin/GetTotalSpecimensCollected"
let CollectionStatus = ["notCollected","collected","rescheduled","missed","closed","other"]
let getDriverLocation = "driver/GetDriverLocation"

let DistanceMatrixAPIkey = "AIzaSyC9oRMEOqcpKDilX9mrEpLeywbxRLK5B-8"
let DistanceMatrixAPIuptoOriginURL = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="
let DistanceMatrixAPIdestinationURL = "&destinations="
let DistanceMatrixAPIkeyURL = "&key="
