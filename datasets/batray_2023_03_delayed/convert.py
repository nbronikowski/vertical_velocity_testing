
import echopype as ep
from echopype import open_raw

ed = open_raw('Data.ad2cp', sonar_model='AD2CP')
ed.to_netcdf(save_path='./')