{ pkgs, stdenv, system, dataDir ? "/opt/zigbee2mqtt/data", nixosTests }:
let
  package = (import ./node.nix { inherit pkgs system; }).package;
in
package.override rec {
  version = "1.14.4";
  reconstructLock = true;

  postInstall = ''
    sed -i '1s;^;#!/usr/bin/env node\n;' $out/lib/node_modules/zigbee2mqtt/index.js
    chmod +x $out/lib/node_modules/zigbee2mqtt/index.js
    mkdir $out/bin
    ln -s $out/lib/node_modules/zigbee2mqtt/index.js $out/bin/zigbee2mqtt

    rm -rf $out/lib/node_modules/zigbee2mqtt/data
    ln -s ${dataDir} $out/lib/node_modules/zigbee2mqtt/data
  '';

  src = pkgs.fetchFromGitHub {
    owner = "Koenkk";
    repo = "zigbee2mqtt";
    rev = version;
    sha256 = "1gyl4f7wh7796w4789pi0ix5y30677784miwylr8wrfqgb1hmddq";
  };

  passthru.tests.zigbee2mqtt = nixosTests.zigbee2mqtt;

  meta = with pkgs.stdenv.lib; {
    description = "Zigbee to MQTT bridge using zigbee-shepherd";
    license = licenses.gpl3;
    homepage = https://github.com/Koenkk/zigbee2mqtt;
    maintainers = with maintainers; [ sweber ];
    platforms = platforms.linux;
  };
}
