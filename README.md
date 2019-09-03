# SIMPLE CAN Bus Voltage Dataset

Instructions about the SIMPLE CAN Bus Voltage Dataset for our paper:

```
@inproceedings{foruhandeh19_simple,
	title= {SIMPLE: Single-Frame based Physical Layer Identification
		for Intrusion Detection and Prevention on In-Vehicle Networks},
	booktitle= {Proceedings of the 35th Annual Computer Security Applications
		Conference},
	author= {Mahsa Foruhandeh, Yanmao Man, Ryan Gerdes, Ming Li,
		Thidapat Chantem},
	year= {2019},
}
```

## Download the dataset

<!---
The dataset is hosted on [Academic
Torrents](https://academictorrents.com/details/6144686c209ed81dd9622eaaac656e3ceb78f4df).
Or simply use the Magnet link:
```
magnet:?xt=urn:btih:6144686c209ed81dd9622eaaac656e3ceb78f4df&tr=http%3A%2F%2Facademictorrents.com%2Fannounce.php&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969
```
-->

The in-vehicle data is available at [here](http://www2.engr.arizona.edu/~yman/simple/dataset/in-vehicle.tar.gz).

Extract the data:
```
$ tar xvf in-vehicle.tar.gz
```

There will be 11 rounds of data, collected from two vehicles. Each round of
data are placed in a directory named `vehicle_datetime`.  For example,
`can_bus_voltage/sentra_02181733/` contains the data collected from the Nissan
Sentra 2016 at 5:33 PM on Feb. 18-th.

In each round of data, there are `.mat` files. One `.mat` file stores a
record of CAN Bus voltage samples. A record may consist of multiple CAN frames.

## Extract CAN frames from a record

First, clone the repository
```
$ git clone https://github.com/Harry1993/simple-dataset.git
```

In MATLAB, call
```
>> cd /path/to/simple-dataset/
>> record_to_frames('/path/to/can_bus_voltage/sentra_06111000/trace02600.mat');
```

In this example, there will be four CAN frames being extracted and stored in
four separated files (`0.mat`, `1.mat`, etc.) under the current directory
`/path/to/simple_dataset/`.

In each frame `.mat` file, there are 6 properties:
  * `ch`: CAN High voltage samples
  * `cl`: CAN Low voltage samples
  * `t`:  Timeslot
  * `s`: Sample rate
  * `bin`: Decoded bits
  * `id`: Message ID
