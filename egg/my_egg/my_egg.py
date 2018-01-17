from pyspark.sql.types import *

def my_scalar_func(input):
    return input

from pyspark.sql.functions import udf

# This is the line that causes the whole thing to hang. Uncomment it to reproduce the issue
# udf_my_scalar_func = udf(my_scalar_func, StringType())

def my_map_func(row):
    return row

class MyClass(object):
    def __init__(self, sqlContext):
        self.sqlContext = sqlContext
        self.raw_data = [{"id": 1, "name": "first"}]
        self.schema = StructType([StructField("id", IntegerType(), False), StructField("name", StringType(), False)])

    def do_map(self):
        print "Creating data frame"
        self.df = self.sqlContext.createDataFrame(self.raw_data, self.schema)
        print "Data frame: {0}".format(self.df.collect())
        self.rdd = self.df.rdd.map(my_map_func)
        # The collect() call hangs if the UDF line above is uncommented
        print "Mapped RDD: {0}".format(self.rdd.collect())
