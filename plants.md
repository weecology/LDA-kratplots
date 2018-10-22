Plants
================
Renata Diaz
10/22/2018

Plants timeseries
=================

    ## Loading in data version 1.60.0

    ## # A tibble: 6 x 5
    ##   date          season treatment richness standardized_n
    ##   <S3: yearmon> <chr>  <chr>        <int>          <int>
    ## 1 Jul 1981      summer control         14           2360
    ## 2 Jul 1981      summer exclosure       17           1949
    ## 3 Apr 1982      winter control         13          10328
    ## 4 Apr 1982      winter exclosure       16           9284
    ## 5 Sep 1982      summer control         12           1786
    ## 6 Sep 1982      summer exclosure       10           2276

    ##    Mean_date Median_date Lower_date Upper_date   SD MCMCerr   AC10
    ## 1 1984-04-29  1984-04-29 1983-11-12 1985-03-16 5.77  0.0183 0.5012
    ## 2 1990-07-21  1990-04-24 1990-01-06 1992-04-04 7.89  0.0250 0.6355
    ## 3 1999-07-02  1999-07-02 1998-12-22 1999-11-06 3.56  0.0113 0.4108
    ## 4 2010-01-16  2009-12-12 2009-05-23 2011-01-05 5.43  0.0172 0.3887
    ##        ESS
    ## 1 2722.659
    ## 2 1747.415
    ## 3 3019.237
    ## 4 4556.069

    ## [1] "Apr 1984" "Jul 1990" "Jul 1999" "Jan 2010"

    ## [[1]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](plants_files/figure-markdown_github/plot%20plant%20timeseries-1.png)

    ## 
    ## [[2]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

![](plants_files/figure-markdown_github/plot%20plant%20timeseries-2.png)

    ## 
    ## [[3]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](plants_files/figure-markdown_github/plot%20plant%20timeseries-3.png)

    ## 
    ## [[4]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

![](plants_files/figure-markdown_github/plot%20plant%20timeseries-4.png)

Zooming in on 1985-1995:

    ## [[1]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

![](plants_files/figure-markdown_github/1990s%20plant%20plots-1.png)

    ## 
    ## [[2]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

![](plants_files/figure-markdown_github/1990s%20plant%20plots-2.png)

    ## 
    ## [[3]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

![](plants_files/figure-markdown_github/1990s%20plant%20plots-3.png)

    ## 
    ## [[4]]

    ## Don't know how to automatically pick scale for object of type yearmon. Defaulting to continuous.

![](plants_files/figure-markdown_github/1990s%20plant%20plots-4.png)

    ## # A tibble: 16 x 5
    ##    date          season treatment richness standardized_n
    ##    <S3: yearmon> <chr>  <chr>        <int>          <int>
    ##  1 Sep 1988      summer control         24           2224
    ##  2 Sep 1988      summer exclosure       22           2496
    ##  3 Mar 1989      winter control         28          20490
    ##  4 Mar 1989      winter exclosure       30          21102
    ##  5 Sep 1989      summer control         49          15519
    ##  6 Sep 1989      summer exclosure       49          19783
    ##  7 Apr 1990      winter control         23            708
    ##  8 Apr 1990      winter exclosure       31            893
    ##  9 Aug 1990      summer control         41          33537
    ## 10 Aug 1990      summer exclosure       52          24967
    ## 11 Apr 1991      winter control         43            850
    ## 12 Apr 1991      winter exclosure       43           1037
    ## 13 Aug 1991      summer control         32           3758
    ## 14 Aug 1991      summer exclosure       35           6329
    ## 15 Apr 1992      winter control         44          13812
    ## 16 Apr 1992      winter exclosure       44          12859
