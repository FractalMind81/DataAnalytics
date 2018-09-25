import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify


#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite", connect_args={'check_same_thread': False}, echo=True)

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)


#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/start date %Y-%m-%d<br/>"
        f"/api/v1.0/start date %Y-%m-%d/end date %Y-%m-%d"
    )


@app.route("/api/v1.0/precipitation")
def precipitation():
    """Return a list of percipitation data"""

    # Query for the dates and temperature observations from the last year.
    results = session.query(Measurement.date,Measurement.prcp).filter(Measurement.date >= '2016-08-23').all()

    # Convert the query results to a Dictionary using date as the key and tobs as the value
    prcp_data = []
    for measurement in results:
        prcp_dict ={}
        prcp_dict[measurement.date] = measurement.prcp
        prcp_data.append(prcp_dict)

    print("Server received request for percipitation data")
    return jsonify(prcp_data)


@app.route("/api/v1.0/stations")
def stations():
    """Return a JSON list of stations from the dataset."""

    # Query all passengers
    results = session.query(Station.station).all()

    # Create a dictionary from the row data and append to a list of all_passengers
    stations = []
    for station in results:
        stations.append(station.station)

    print("Server received request for station data")
    return jsonify(stations)

@app.route("/api/v1.0/tobs")
def tobs():
    """Return a JSON list of Temperature Observations (tobs) for the previous year."""

    # Query all passengers
    results = session.query(Measurement.tobs).filter(Measurement.date >= '2016-08-23').all()

    # Create a dictionary from the row data and append to a list of all_passengers
    tobs_data = []
    for tob in results:
        tobs_data.append(tob.tobs)

    print("Server received request for tobs data")
    return jsonify(tobs_data)
    
@app.route("/api/v1.0/<start>")
def date_start(start):
    """Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start date"""

    # Query minimum temperature, the average temperature, and the max temperature
    results = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
    filter(Measurement.date >= start).all()

     # Create a dictionary from the row data and append to a list of all_passengers
    desc_temps_dict = {}
    desc_temps_dict["MIN"] = results[0][0]
    desc_temps_dict["AVG"] = results[0][1]
    desc_temps_dict["MAX"] = results[0][2]

    print("Server received request using start date")
    return jsonify(desc_temps_dict)

@app.route("/api/v1.0/<start>/<end>")
def date_start_end(start=None,end=None):
    """Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start date"""

    # Query minimum temperature, the average temperature, and the max temperature
    results = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
    filter(Measurement.date >= start).\
    filter(Measurement.date <= end).all()

     # Create a dictionary from the row data and append to a list of all_passengers
    desc_temps_dict = {}
    desc_temps_dict["MIN"] = results[0][0]
    desc_temps_dict["AVG"] = results[0][1]
    desc_temps_dict["MAX"] = results[0][2]

    print("Server received request using start and end date")
    return jsonify(desc_temps_dict)

if __name__ == '__main__':
    app.run(debug=False)
