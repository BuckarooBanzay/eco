local vehicles = {}

function building_lib_transport.register_vehicle(name, vehicle_def)
    vehicle_def.name = name
    vehicles[name] = vehicle_def
end

function building_lib_transport.get_vehicle(name)
    return vehicles[name]
end