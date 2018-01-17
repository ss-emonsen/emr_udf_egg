# Pyspark udf() issue in EMR
## Issue Overview

From Pyspark in an EMR cluster, calling udf() from within an egg causes Spark processing within the cluster to hang.

## Issue Repro

### 1. Create EMR cluster
1. Create a VPC with a single subnet and make note of the subnet ID.
1. Create an EC2 keypair and make note of the name.
1. From a command line, run ```cd emr_cluster; ./create_emr_cluster.sh -s SUBNET_ID -k KEYPAIR_NAME```

### 2. Build egg and upload to a bucket
Make note of the S3 path where you will store the egg. You'll need to add it to the zeppelin notebook in the next step.

1. ```cd egg```
1. ```python setup.py bdist_egg ```
1. ```aws s3 cp dist/my_egg-0.1-py2.7.egg s3://your_s3_path/```

### 3. Connect to Zeppelin notebook
1. From the EMR console page for your cluster, click "Enable Web Connection" and follow the instructions
1. Refresh the page, and click on Zeppelin to go to your cluster's Zeppelin installation.
1. Create a new Zeppelin note.
1. In the first "paragraph", paste the contents of ```zeppelin_notebook.txt```
1. Replace the S3 path in line 2 with the full S3 path of my_egg-0.1-py2.7.egg
1. Execute the cell.
1. The execution should complete quickly and print output ending with ```Mapped RDD: [Row(id=1, name=u'first')]```

### 4. Reproduce the issue
1. Open egg/my_egg/my_egg.py in your favorite text/code editor.
1. Uncomment the line starting with ```udf_my_scalar_func = udf(...```
1. Rebuild the egg and upload the new copy according to step 2 above.
1. In order to load the new egg file, you need to clear out the old one by restarting the Zeppelin's Pyspark interpreter: In the upper right, click on "anonymous", then "Interpreter". Find "spark" and click "restart". Confirm the restart.
1. Go back to the notebook and execute the cell.
1. The execution "hangs" and never completes.

### Notes & Debugging
* Spark processing hangs even when the defined udf is never used, as is the case in this repro.
* Remember - restart interpreter if you want to change/reload the egg code

