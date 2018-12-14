#!/bin/bash

#Colores
blanco="\033[1;37m"
gris="\033[0;37m"
magenta="\033[0;35m"
rojo="\033[1;31m"
verde="\033[1;32m"
amarillo="\033[1;33m"
azul="\033[1;34m"
rescolor="\e[0m"

echo -e ""$amarillo"#################################################"
echo -e ""$rojo"Script programado solo para IPV4"
echo -e ""$amarillo"#################################################"$blanco

echo -e ""$amarillo"[*] Activando IP_FORWARD"
sysctl -w net.ipv4.ip_forward=1
echo -e ""$rojo"ACTIVADO"

echo -e ""$azul"*********************"

echo -e ""$amarillo"[*] Desactivando la redirección ICMP"
sysctl -w net.ipv4.conf.all.send_redirects=0
echo -e ""$rojo"DESACTIVADO"

echo -e $azul"*********************" 

echo -e $amarillo"[*] Añadiendo las reglas de iptables"
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8080
echo -e $rojo"AÑADIDAS"

echo -e $azul"*********************" 

echo -e $rojo"Arrancando MITMProxy"
xterm -e "SSLKEYLOGFILE='$HOME/.mitmproxy/sslkeylogfile.txt' mitmproxy" &
echo -e $gris"El archivo 'sslkeylogfile.txt' está en la ruta ~/.mitmproxy/"
echo -e $gris"* Dicho archivo es necesario para el correcto descrifrado de los paquetes en Wireshark *"
echo -e $rojo"ARRANCADO"
echo -e $amarillo"*********************"

echo -e $rojo"Arrancando Wireshark"
##xterm -e "wireshark -i $1 -k -f (ip.src==$2 or ip.dest==2) and (http or http2)" 
xterm -e wireshark -i $1 -k &
echo -e $gris"* Recuerda incluir el fichero sslkeylogfile.txt como (pre)Master key para descifrar el tráfico"
echo -e $rojo"ARRANCADO"

echo -e $amarillo"*********************"
echo -e $amarillo"*********************"
