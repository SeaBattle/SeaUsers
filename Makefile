PROJECT = seausers

DEPS = eredis_cluster mongodb seaconfig email seautils pbkdf2
dep_eredis_cluster = git https://github.com/SeaBattle/eredis_cluster.git 0.5.8
dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git v1.1.2
dep_seaconfig = git https://github.com/SeaBattle/SeaConfig.git master
dep_email = git https://github.com/comtihon/email.git 0.1.5
dep_seautils = git https://github.com/SeaBattle/SeaUtils.git master
dep_pbkdf2 = git https://github.com/basho/erlang-pbkdf2.git 2.0.0


TEST_DEPS = meck gun
dep_meck = git https://github.com/eproxus/meck.git master

include erlang.mk
