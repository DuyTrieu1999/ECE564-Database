#! /usr/bin/env bash

pkill swift
cd .build/release
./NewstandsServer
cd -
