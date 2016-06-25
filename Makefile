PROJECT = seausers

DEPS = eredis_cluster mongodb seaconfig
dep_eredis_cluster = git https://github.com/SeaBattle/eredis_cluster.git 0.5.8
dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git v1.1.2
dep_seaconfig = git https://github.com/SeaBattle/SeaConfig.git master



TEST_DEPS = meck gun
dep_meck = git https://github.com/eproxus/meck.git master

include erlang.mk
