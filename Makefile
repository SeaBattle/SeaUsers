PROJECT = seausers

DEPS = eredis_cluster pgapp seaconfig email seautils pbkdf2 cowboy jsone
dep_eredis_cluster = git https://github.com/SeaBattle/eredis_cluster.git 0.5.8
dep_pgapp = git https://github.com/epgsql/epgsql.git master
dep_seaconfig = git https://github.com/SeaBattle/SeaConfig.git master
dep_email = git https://github.com/comtihon/email.git 0.1.5
dep_seautils = git https://github.com/SeaBattle/SeaUtils.git master
dep_pbkdf2 = git https://github.com/basho/erlang-pbkdf2.git 2.0.0
dep_cowboy =  git https://github.com/ninenines/cowboy.git 2.0.0-pre.3
dep_jsone = git https://github.com/sile/jsone.git v0.3.3-hipe

TEST_DEPS = meck
dep_meck = git https://github.com/eproxus/meck.git master

include erlang.mk
