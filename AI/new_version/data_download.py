from roboflow import Roboflow
rf = Roboflow(api_key="pctPuQ7pVraznc2uVLQb")
project = rf.workspace("capmap").project("capmap-xcvcn")
version = project.version(1)
dataset = version.download("folder")
                