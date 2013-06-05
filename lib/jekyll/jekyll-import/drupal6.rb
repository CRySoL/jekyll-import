# -*- coding: utf-8 -*-
require 'rubygems'
require 'sequel'
require 'fileutils'
require 'safe_yaml'

# NOTE: This converter requires Sequel and the MySQL gems.
# The MySQL gem can be difficult to install on OS X. Once you have MySQL
# installed, running the following commands should work:
# $ sudo gem install sequel
# $ sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

module JekyllImport
  module Drupal6
    # Reads a MySQL database via Sequel and creates a post file for each story
    # and blog node in table node.
    QUERY = "SELECT n.nid, \
                    n.title, \
                    nr.body, \
                    n.created, \
                    n.status \
             FROM node AS n, \
                  node_revisions AS nr \
             WHERE (n.type = 'blog' OR n.type = 'story') \
             AND n.vid = nr.vid AND n.nid = 4"

    def self.process(dbname, user, pass, host = 'localhost', prefix = '')
      db = Sequel.mysql(dbname, :user => user, :password => pass, :host => host, :encoding => 'utf8')

      if prefix != ''
        QUERY[" node "] = " " + prefix + "node "
        QUERY[" node_revisions "] = " " + prefix + "node_revisions "
      end

      FileUtils.mkdir_p "_posts"
      FileUtils.mkdir_p "_drafts"

      # Create the refresh layout
      # Change the refresh url if you customized your permalink config
      File.open("_layouts/refresh.html", "w") do |f|
        f.puts <<EOF
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="refresh" content="0;url={{ page.refresh_to_post_id }}.html" />
</head>
</html>
EOF
      end

#-    4 | Cómo escribir una receta                                                                                      |
#+    6 | SSH y SCP para acceder a equipos remotos sin escribir la clave (public key authentication)                    |
#+   19 | Arrancar como root sin conocer la clave (usando GRUB)                                                         |
#+  127 | En Nautilus también tenemos "Abrir terminal aquí"!                                                            |
#-   11 | Acabo de registrarme en el Portal                                                                             |
#-   13 | Instalación local de Mambo / Joomla bajo GNU/Linux                                                            |
#+   12 | Buenas a tod@s!                                                                                               |
#-   14 | Acceso a Red C@mpus con Firefox y Greasemonkey                                                                |
#-  218 | El santísimo credo del informático                                                                            |
#+   15 | Saluditos                                                                                                     |
#+   17 | Cómo escribir una receta... de cocina                                                                         |
#+   79 | El gestor de arranque GRUB                                                                                    |
#+   26 | Grabar CDs y DVDs fácilmente desde consola                                                                    |
#+  128 | no dejes en el equipo tus contraseñas                                                                         |
#+  129 | Synergy: una consola para dominarlas todas                                                                    |
#-   81 | Problemillas con Xorg                                                                                         |
#+   43 | Mini tutorial de Python                                                                                       |
#+   33 | Configuración manual de una conexión de red en GNU/Linux (con net-tools)                                      |
#+   32 | Túneles, canales y puertos con SSH                                                                            |
#+   28 | Netcat, la navaja suiza de TCP/IP                                                                             |
#+   25 | ddclient, cliente de DNS dinámico para todos                                                                  |
#+   29 | Una curiosidad (huevo de pascua)                                                                              |
#+   34 | Adios al spam con spamassassin y sylpheed-claws                                                               |
#+   35 | Descargar las ISO de los DVD de Debian, con jigdo                                                             |
#+  118 | Recuperar GRUB después de instalar Windows                                                                    |
#+   38 | Instalación de eDonkey2000                                                                                    |
#+  119 | Ejecutar programas X en otra máquina viéndolos en local                                                       |
#+   40 | Cienes y cienes de cosas (como diría aquel)                                                                   |
#+  126 | Ndiswrapper: tarjetas wifi no soportadas en Linux                                                             |
#+   42 | Conectar por SSH a través de un proxy HTTP                                                                    |
#-   47 | Algunos que otros problemillas con la web de Cisco                                                            |
#+   46 | Cambiar la dirección MAC de una tarjeta de red                                                                |
#+   49 | Recuperar fotos y videos borrados de una cámara digital                                                       |
#+   50 | ¡Usuarios Ubuntu!, ¿quereis Howto's?                                                                          |
#+   51 | Arreglar fuentes pequeñas en aplicaciones GTK                                                                 |
#+   52 | Java Blackdown en Debian                                                                                      |
#-   53 | ATI y libGL.so.1                                                                                              |
#-  725 | eduroam 1.0: Conectar a la nueva WiFi de la universidad                                                       |
#-   57 | ¿Servidor de RDP o algo parecido para GNU/Linux?                                                              |
#-   58 | Configuracion wifi de la UCLM  en Ubuntu 5.10                                                                 |
#+   59 | apt-get y dpkg                                                                                                |
#+  120 | Abrir una sesión X en otra máquina                                                                            |
#+   64 | Compartir ficheros con NFS                                                                                    |
#+   65 | Programación de microcontroladores PIC en GNU/Linux                                                           |
#+  637 | Cintas de backup y cargadores: mt y mtx                                                                       |
#+   67 | Instalar programas con STOW                                                                                   |
#+  121 | Instalar el driver privativo de nVidia en Debian GNU/Linux                                                    |
#+  122 | Generar un certificado SSL para apache                                                                        |
#+  483 | Streaming multimedia con Flumotion                                                                            |
#+   70 | GRUB perdido                                                                                                  |
#+  123 | Ver ficheros fuente coloreados en consola                                                                     |
#+   73 | Crema de calabacín                                                                                            |
#-   74 | Para los que tengan Amd64 ...                                                                                 |
#+   75 | Tarta de manzana                                                                                              |
#+   78 | CRySoL install party                                                                                          |
#+   80 | GRUB protegido con contraseña                                                                                 |
#+   82 | Configuración y disfrute de un SAI: NUT en Debian                                                             |
#+  124 | Un 10 para la Install party                                                                                   |
#+   83 | Averigua tu IP externa (pública)                                                                              |
#+   84 | La Tierra como fondo de escritorio en gnome, con Xplanet                                                      |
#+   85 | Guacamole "Top"                                                                                               |
#+   86 | Mezclador de audio por software, con ALSA                                                                     |
#+   87 | Midi por software                                                                                             |
#+  145 | Un día triste para los usuarios de Intel... AIRPORT EXTREME EN GNU/LINUX                                      |
#+ 1523 | CRySoL en baquia tv                                                                                           |
#+  195 | "El reto del mes", 1ª edición                                                                                 |
#+  196 | Papá, ¿de donde vienen las placas base?                                                                       |
#+   92 | instalar emacs                                                                                                |
#-   93 | Animo chicos                                                                                                  |
#+   94 | Comprar un portátil                                                                                           |
#+   95 | Aprender a escribir en la web                                                                                 |
#+   96 | Compartir la conexión a Internet (router doméstico) con GNU/Linux                                             |
#+   98 | Manipulación de ficheros PDF                                                                                  |
#+   99 | Compartir ficheros con SSHfs                                                                                  |
#+  100 | Compartir ficheros con SHFS                                                                                   |
#+  102 | Redes inalámbricas multisalto en GNU/Linux                                                                    |
#+  169 | Autenticación de paquetes para repositorios Debian                                                            |
#+  103 | Configurar Eclipse                                                                                            |
#+  140 | Arroz con pollo al curry                                                                                      |
#+  106 | Dashboard Process: ayuda para PSP                                                                             |
#+ 1376 | Instalación y puesta en marcha de HYDRA desde repo                                                            |
#+  108 | "BookCrossing" ¿también en Ciudad Real?                                                                       |
#+  109 | Empezar en Zope (Plone)                                                                                       |
#-  175 | Subir Gnesis a www.espaciolinux.com                                                                           |
#+  116 | Hacer paquetes.deb a partir de .rpm y .tar.gz                                                                 |
#+  111 | Consulta sobre distro                                                                                         |
#+  117 | Instalar Debian SARGE en un portátil                                                                          |
#+  280 | Edición de imágenes en consola, con ImageMagick                                                               |
#+  112 | Presumiendo de aceleración 3D en GNU/Linux, con 3ddesktop                                                     |
#+  113 | Crear .deb a partir de tar.gz                                                                                 |
#+  114 | Instalando HURD                                                                                               |
#+  115 | ¿Es la programación un arte?                                                                                  |
#+  130 | Conexiones WiFi que también pueden ser libres...                                                              |
#+  131 | Problemas con particiones                                                                                     |
#+  132 | Sobre la Web                                                                                                  |
#-  136 | Error de pmount en Ubuntu 5.10                                                                                |
#+  135 | Generar libros para devhelp                                                                                   |
#+  134 | Proponiendo actividades                                                                                       |
#+  137 | En mi tintero personal                                                                                        |
#+  138 | GNU/Linux y nuestra amada PSP                                                                                 |
#+  139 | Optimizar Firefox                                                                                             |
#+  158 | Escuchar los 40 principales por internet con mplayer                                                          |
#+  141 | Berenjenas rellenas                                                                                           |
#+  142 | Pollo a la cebolla                                                                                            |
#+  143 | Problemas en Debian                                                                                           |
#+  144 | Mantener limpia tu Debian                                                                                     |
#+  147 | Para reir un poco                                                                                             |
#+  148 | Haciendo funcionar la Airport Extreme con GNU/Linux                                                           |
#+  149 | Mapa conceptual del Software Libre                                                                            |
#+  489 | Configurar el superservidor inetd                                                                             |
#+  490 | Control del puerto paralelo con ppdev                                                                         |
#+  150 | ¿Flash con Firefox?                                                                                           |
#+  152 | Merry Chrismas and a happy GNU year!!!                                                                        |
#+  153 | La página                                                                                                     |
#+  154 | Prohiben el SOFTWARE LIBRE en Francia!!!                                                                      |
#+  155 | ¿Diferencia de sabores?                                                                                       |
#+  156 | Bilo y Nano te necesitan                                                                                      |
#+  157 | Ha salido Molinux 2.0                                                                                         |
#+  919 | Mercurial, por favor                                                                                          |
#+  160 | Increíble, pero cierto.                                                                                       |
#+  161 | ¿Propietarios de ideas? Nos toman el pelo                                                                     |
#+  162 | Servir un repositorio subversion con Apache-2.0                                                               |
#+  163 | SQL básico                                                                                                    |
#+  164 | Ubuntu: menos tonterías y más seriedad, ¡¡por favor!!                                                         |
#+  166 | ¿Linux en un smartphone?                                                                                      |
#+  168 | Usabilidad que no entiendo.                                                                                   |
#+  170 | Debian en cualquier parte con un CD y un disco USB?                                                           |
#+  171 | Duke Nukem 3D en GNU/Linux, Come get some!!                                                                   |
#+  172 | Sistema Híbrido: Paquetes de distintas "releases" con apt                                                     |
#+  173 | Tonterías de la propiedad intelectual.                                                                        |
#+  174 | Una razón más para utilizar software libre                                                                    |
#+  176 | Magnatuneasy vuelve a la vida                                                                                 |
#+  177 | Creación de paquetes Debian binarios                                                                          |
#-  178 | WiFi de la UCLM bajo GNU/Linux                                                                                |
#+  180 | Instalación de NINO en Debian GNU/Linux                                                                       |
#+  181 | Usar un repositorio subversion                                                                                |
#+  182 | Configurar, parchear, cacharrear y compilar un Linux FÁCILMENTE                                               |
#+  183 | ¿GNU/Linux "Media Center"?                                                                                    |
#+  184 | Propuesta ("Proponiendo actividades" 2ª parte)                                                                |
#?  185 | Acer                                                                                                          |
#+  920 | "Fallito" de seguridad en Debian.                                                                             |
#+  187 | Microsoft patenta el FAT                                                                                      |
#+  188 | Compartir la conexión mediante un módem ADSL Comtrend CT-351                                                  |
#+  189 | Módem Comtrend CT-351 con ADSL de Telefónica en Debian GNU/Linux                                              |
#+  190 | Cuenta módem RTC de telefónica                                                                                |
#+  191 | "El reto de la semana", 1ª edición                                                                            |
#+  192 | Arranque remoto de un ordenador con Debian, usando Wake On LAN                                                |
#+  193 | "El reto de la semana", 2ª edición                                                                            |
#+  194 | Como funciona lo del vmware que esta instalado en los equipos de la ESI                                       |
#+  197 | Bluetooth en GNU/Linux                                                                                        |
#+  386 | Imprímelo todo con GNU a2ps                                                                                   |
#+  198 | Crear un sitio web SSL con Apache2                                                                            |
#+  199 | 3 meses de estadísticas                                                                                       |
#+  200 | Stallman en la ESI?                                                                                           |
#+  201 | Virtualización fácil con Xen3                                                                                 |
#+  202 | Arranque desde red sin disco duro                                                                             |
#+  338 | Compartir ficheros con Samba/CIFS                                                                             |
#+  868 | Creación ultra rápida de librerías para kicad                                                                 |
#+  207 | Para los del RETO de la semana                                                                                |
#+  208 | A todos los autores de recetas                                                                                |
#+  203 | Aplicaciones multilingües: gettext                                                                            |
#+  204 | Visita virtual al Hospital General de Ciudad Real                                                             |
#+  209 | Microsoft aprieta el culo...                                                                                  |
#+  211 | Sobre el Copyleft                                                                                             |
#+  212 | Wormux: el Worms para GNU/Linux                                                                               |
#+  213 | Caducidad de las claves GPG de los repositorios debian                                                        |
#+  214 | WiFi RT2500 de Ralink en GNU/Linux                                                                            |
#+  933 | Entornos chroot con cdebootstrap en Debian                                                                    |
#+  269 | Pena de muerte para los delitos contra la Propiedad Intelectual                                               |
#+  226 | Usar un repositorio CVS                                                                                       |
#+  228 | Gaim 2.0                                                                                                      |
#+  215 | ¡Advertencia desde el futuro!                                                                                 |
#+  216 | Kit de desarrollo completo para PSP. ACTUALIZADO.                                                             |
#+  220 | Firefox y flash                                                                                               |
#-  217 | RedCampus desde GNU/Linux!!                                                                                   |
#+  219 | Salvar (y recuperar) una base de datos MySQL                                                                  |
#+  221 | Respuesta de M$ a los portátiles a 100$ para el tercer munndo                                                 |
#+  222 | Sin palabras, otra vez la SGAE                                                                                |
#+  278 | Recuperar la clave de administrador de Drupal                                                                 |
#+  314 | "El reto de la semana", 3ª edición                                                                            |
#+  227 | Curiosidades                                                                                                  |
#+  223 | El porqué del cracking                                                                                        |
#+  224 | Simulador ns2. Principios básicos.                                                                            |
#+  229 | ¿Por qué no me va el compilador de c gcc en Debian?                                                           |
#+  230 | GNU/Linux - Venezuela                                                                                         |
#+  231 | Van a cambiar los escritorios 3D la manera de usar el ordenador?                                              |
#+  471 | Enviar correo no-ASCII desde un programa Python                                                               |
#+  233 | La ESI organizará la Party Quijote 2006                                                                       |
#+  234 | Navegación anónima mediante Tor y Privoxy.                                                                    |
#+  235 | Gnesis 2.0 RC1 disponible para descarga                                                                       |
#+  236 | Manipulación de ficheros AVI                                                                                  |
#+  237 | Grabar CD y DVD más rápido                                                                                    |
#+  238 | Reiniciar linux tocando el directorio /proc                                                                   |
#+  239 | Pegatinas de linux                                                                                            |
#+  240 | XGL en Ubuntu Dapper con Nvidia                                                                               |
#+  246 | Plugin Opacity en Xgl/Compiz                                                                                  |
#+  241 | Cansado de amd64                                                                                              |
#+  242 | La in-justicia francesa...                                                                                    |
#+  243 | La que nos espera...                                                                                          |
#-  244 | Hoy no hay party                                                                                              |
#+  245 | Por lo menos hay alguno...                                                                                    |
#-  247 | ¿Quieres consultar Redcampus?                                                                                 |
#+  248 | Manipulación de DVD Video                                                                                     |
#+  249 | Nautilus con samba                                                                                            |
#+  250 | Gestión de los UPS                                                                                            |
#+  251 | Ripeando con transcode                                                                                        |
#+  252 | El reto de la semana (3)                                                                                      |
#+  253 | La docencia en secundaría no será una salida profesional para los titulados universitarios en informática.    |
#+  254 | Módem Comtrend CT-350 en GNU/Linux, con el driver ueagle-atm                                                  |
#+  256 | Redimensionar una partición con Gparted Live CD                                                               |
#+  255 | Configurar TV en ubuntu                                                                                       |
#+  257 | Convertir subtítulos de DVD a formato .srt                                                                    |
#+  258 | Correr programas DOS en Molinux con Dosemu                                                                    |
#+  259 | ¿Posible cambio de número en las versiones de Ubuntu?                                                         |
#-  260 | EL HAITIANO EN CUBA                                                                                           |
#- 261 | HAITIANOS ABORIGENES                                                                                          |
#+  262 | Objetivos de la web                                                                                           |
#+  263 | Intel Core Duo ... 34 fallos                                                                                  |
#+  264 | Descargar videos de YouTube para verlos 'offline'                                                             |
#+  265 | Hacer backup de tu correo en Gmail                                                                            |
#+  266 | Manos libres Bluetooth con GNU/Linux                                                                          |
#+  267 | Depurar un programa (C, C++, ...)                                                                             |
#+  271 | Usuario de Evolution harto de spam.                                                                           |
#+  270 | Restringir secuencias "Control+Alt+..." en el servidor X                                                      |
#+  272 | ATI Radeon 9600 en Debian GNU/Linux, con el driver privativo fglrx                                            |
#+  639 | GNU Emacs: Ocultar password de root en el modo shell                                                          |
#+  273 | Ejecutar un comando como si fueras otro usuario: sudo                                                         |
#+  276 | Neutralidad Tecnológica                                                                                       |
#+  277 | Nueva web contra el canon digital                                                                             |
#+  275 | Comunicación entre tu calculadora HP4x y GNU/Linux                                                            |
#+  279 | GNU Emacs: Todos los comandos que necesitas y nunca recuerdas                                                 |
#+  281 | Script para escuchar emisoras de radio por internet                                                           |
#+  282 | El sistema operativo "Núcleo 2.6.12"?                                                                         |
#+  283 | Microsoft paga por publicitarse bajo la palabra "linux"                                                       |
#+  284 | Cómo hacer una metadistro USB                                                                                 |
#+  285 | Adaptador WiFi USB Zyair en GNU/linux                                                                         |
#+  286 | LinuxAlbacete organiza las "II Jornadas de Software Libre"                                                    |
#+  287 | Molinux Nomada, una molinux en tu USB                                                                         |
#+  288 | OpenOffice Writer gana batalla a Microsoft Word                                                               |
#+  289 | Televisión digital terrestre (TDT) en GNU/Linux                                                               |
#+  290 | Añadir soporte multimedia en OpenOffice.org                                                                   |
#+  291 | Tu GNU/Linux siempre en hora (y con tiempo contínuo) con NTP                                                  |
#+  292 | Arreglar Emacs sin fuentes                                                                                    |
#+  293 | Linux es el cáncer de América                                                                                 |
#+  294 | dijexcr GNU/Linux para la PYME                                                                                |
#+  295 | Personalizar los plugins de búsqueda de Firefox                                                               |
#+  296 | Plugin de búsqueda para CRySoL                                                                                |
#+  297 | Instalar Debian GNU/Linux en Sony Vaio VGN-TX27TP                                                             |
#+  298 | Petición de talleres y actividades para la Party Quijote 2006                                                 |
#+  299 | Mini referencia de SQL con MySQL                                                                              |
#+  302 | Gráficas con gnuplot                                                                                          |
#+  305 | Canon IXUS 55 con gphoto2 en Debian GNU/Linux                                                                 |
#+  304 | MEGABOX - Linux Media Center                                                                                  |
#+  306 | Convertir ficheros APE a formato WAV en GNU/Linux                                                             |
#+  307 | 25 de mayo dia del orgullo friki                                                                              |
#+  308 | Hacer un «latiguillo» Ethernet - cable cruzado - cross over                                                   |
#+  310 | Creación de librerías en GNU/Linux                                                                            |
#+  311 | Creación de plugins en GNU/Linux                                                                              |
#+  312 | Mini tutorial de GNU Make                                                                                     |
#+  313 | Mini tutorial de GNU GDB                                                                                      |
#+  315 | Mini Tutorial sobre la Recursividad                                                                           |
#+  429 | Sacando jugo a EXIF, en consola (y en nautilus)                                                               |
#+  553 | TES: Emacs Code Browser (ecb)                                                                                 |
#+  322 | Ver DVDs en Ubuntu o Debian GNU/Linux                                                                         |
#+  321 | twisted, controlando varios equipos con synergy                                                               |
#+  319 | GNU/Linux como espantapájaros                                                                                 |
#+  323 | Windows Vista, ideal si tu portátil va sobrado de batería                                                     |
#+  325 | Empaquetar un script Python para Debian (y mantenerlo)                                                        |
#+  326 | El día de la bestia.                                                                                          |
#+  327 | Defectuoso por diseño                                                                                         |
#+  328 | Inhabilitar touchpad synaptics mientras escribes                                                              |
#+  330 | Máster en Tecnologías de la Información y las Comunicaciones (MTIC)                                           |
#+  331 | Backup para móviles Siemens                                                                                   |
#+  329 | pluin de tomcat en eclipse                                                                                    |
#+  332 | Radio por internet                                                                                            |
#+  333 | Programación de microcontroladores AVR en GNU/Linux                                                           |
#+  334 | Afina tus discos con hdparm                                                                                   |
#+  335 | El formato de Word es bueno (pero no para ti)                                                                 |
#+  336 | Bill Gates se retira. ¡¡ Oh, que pena más grande !!                                                           |
#+  337 | La UCLM llega a UBUNTU.                                                                                       |
#  342 | error para entrar a la sesion de ubuntu 5.10                                                                  |
#  339 | La enésima receta de iptables                                                                                 |
#  341 | Usando gphoto2 desde consola                                                                                  |
#  343 | Iptables en FC5                                                                                               |
#  347 | Introducción al Proceso Software Personal (Humphrey)                                                          |
#  349 | Gstreamer + Python = tu propio reproductor multimedia en minutos                                              |
#  350 | Primeros pasos con MySQL                                                                                      |
#  351 | instalar Drupal en Debian GNU/Linux                                                                           |
#  352 | Debian Xen 3.0 en 5 minutos                                                                                   |
#  353 | Tutorial para montar un hub de Direct Connect                                                                 |
#  354 | Guía del aspirante a mal programador                                                                          |
#  942 | Auctex para torpes                                                                                            |
#  356 | ¿Quién dice que no hay arte en la programación?                                                               |
#  357 | Debian Plone en 5 minutos                                                                                     |
#  358 | Convertir a comic                                                                                             |
#  742 | Software para electrónicos: kicad                                                                             |
#  456 | Instalador de Gnesis 3.0 en su versión 0.0.1 Alfa-Beta-Gamma "archi-experimental"                             |
#  360 | Arreglar gnome-terminal que no muestra tildes ni eñes                                                         |
#  361 | Recordar fechas y cumpleaños con 'birthday'                                                                   |
#  362 | La SDAE desarrolló el mp3 cuando los modem iban a 9.600 voltios!                                              |
#  363 | Usuario de Yafray, necesitamos tu ayuda!!                                                                     |
#  364 | Crear un instalador auto-extraible para GNU/Linux                                                             |
#  365 | Reconocimiento de voz en Windows Vista                                                                        |
#  366 | Publicar los "homes" con Apache2                                                                              |
#  506 | Montar un repositorio trivial de paquetes Debian                                                              |
#  367 | Configura el "termómetro" de tu PC, con lm-sensors                                                            |
#  368 | GNU Emacs como editor XML (o DocBook), con psgml                                                              |
#  369 | La ESI de Ciudad Real distribuirá GNESIS a sus alumnos                                                        |
#  382 | M$ "invita" a Firefox a sus instalaciones                                                                     |
#  370 | Experimentando con Active Directory y OpenLDAP                                                                |
#  371 | El diccionario de la RAE siempre a mano                                                                       |
#  372 | Concurso Universitario de Software Libre                                                                      |
#  373 | "El reto de la semana", 5ª edición                                                                            |
#  375 | Arreglar subtítulos SRT desincronizados                                                                       |
#  385 | Hasta nunca ATI!                                                                                              |
#  377 | Solucionar sincronización audio/video de flash                                                                |
#  420 | Lasaña a la boloñesa                                                                                          |
#  378 | Linux Vserver en 5 minutos                                                                                    |
#  381 | El fin del Ethereal!                                                                                          |
#  383 | Preguntas que cambiarán el mundo.                                                                             |
#  380 | Microsoft somos todos                                                                                         |
#  384 | Motorola V3 y Debian GNU/Linux                                                                                |
#  387 | Aire fresco en el entretenimiento                                                                             |
#  388 | Wallpaper GNU/Linux                                                                                           |
#  389 | Compilación de paquetes Debian con svn-buildpackage                                                           |
#  390 | Sobre Frikis en General                                                                                       |
#  391 | Comparar ficheros                                                                                             |
#  393 | Resucitando PentiumII                                                                                         |
#  394 | Comprar un portátil                                                                                           |
#  395 | Me presento                                                                                                   |
#  396 | ¿El fin del la paginación?                                                                                    |
#  397 | Sensor de movimiento del iBook/PowerBook G4 bajo GNU/Linux                                                    |
#  398 | Poner una imagen de fondo en GRUB                                                                             |
#  399 | XGL y Beryl en Ubuntu Dapper                                                                                  |
#  400 | Instalar un sistema Bacula en GNU                                                                             |
#  401 | depurar                                                                                                       |
#  402 | Cambia el aspecto de Google                                                                                   |
#  403 | novato en linux                                                                                               |
#  404 | Renombrar múltiples ficheros usando mmv                                                                       |
#  405 | TinyOS 2.0, un sistema operativo libre para dispositivos empotrados                                           |
#  407 | Cumpleaños feliz                                                                                              |
#  406 | Xplanet como salvapantallas con gnome-screensaver                                                             |
#  408 | GNU/Windows vs. GNU/Linux                                                                                     |
#  409 | Gracias desde muy lejos.                                                                                      |
#  410 | Comienza el desarrollo de Gnesis 3.0                                                                          |
#  411 | Creación de un LOAP                                                                                           |
#  412 | Grupo de usuarios de GNU/Linux de Boston USA.                                                                 |
#  413 | Macarrones enfadados                                                                                          |
#  428 | Lasaña con champiñones y berenjena                                                                            |
#  414 | Migración cutre de una instalación a un disco duro nuevo                                                      |
#  621 | Manejo básico de señales en GNU/Linux                                                                         |
#  416 | Ayuda con MONO                                                                                                |
#  418 | Teclas multimedia en portátiles Apple con GNU/Linux                                                           |
#  421 | ¿Redes neuronales? ¿Eso es todo?                                                                              |
#  430 | Cherokee y HTTPS                                                                                              |
#  433 | Alternativas a parse_launch()                                                                                 |
#  431 | Propuesta: CRySoL en Podcast                                                                                  |
#  432 | Instalar Debian GNU/Linux en un Compaq tc 1100                                                                |
#  434 | Cómo ser un "Gnesis Maintainer"                                                                               |
#  435 | Averiguar la IP de un 'chisme', que la consigue por DHCP                                                      |
#  438 | Monitorización de los Sensores de tu PC                                                                       |
#  437 |  error al abrir algunas paginas webs                                                                          |
#  441 | Enviando correo «a golpe de protocolo»                                                                        |
#  442 | about:mozilla                                                                                                 |
#  443 | Sun libera Java                                                                                               |
# 1373 | Desnudando a la NDS Lite                                                                                      |
#  445 | Aceleración de video por hardware en PowerPC                                                                  |
#  446 | Acerca de Novell y Microsoft                                                                                  |
#  447 | Widows Vista RTM Leaked y activado ...                                                                        |
#  448 | TROLL: El mafioso                                                                                             |
#  449 | Autocompletado programable con GNU Bash                                                                       |
#  450 | Ensalada de queso de cabra con anchoas                                                                        |
#  451 | ¿Edición de video con GPL? Sí - LIVES                                                                         |
#  452 | "¿Cree que la administración debería usar software libre en vez de programas comerciales?"                    |
#  453 | Introducción a Unicode y UTF-8                                                                                |
#  455 | Nuevas Beryl 0.1.3                                                                                            |
#  457 | Amenazas y extorsiones                                                                                        |
#  458 | Ser "linuxero" está de moda                                                                                   |
#  454 | Unicode/UTF-8 con Python                                                                                      |
#  459 | Convertir subtítulos de DVD a formato VobSub                                                                  |
#  460 | La Informática dejará de ser una Ingeniería                                                                   |
#  462 | Tontuna sobre Gates...                                                                                        |
#  465 | GLib IO Channels con Python                                                                                   |
#  466 | Cómo indicar a X.org qué tarjeta de vídeo tienes                                                              |
#  467 | GNU/Linux y la banda ancha móvil                                                                              |
#  468 | Video Streaming en Flash con Software Libre                                                                   |
#  469 | Lo nuevo de emacs22                                                                                           |
#  470 | convertidor de video                                                                                          |
#  472 | Samsung SyncMaster 203b con GNU/Linux                                                                         |
#  473 | Restart your system!                                                                                          |
#  478 | Richard Stallman, socio del Betis (broma del 28-diciembre?)                                                   |
#  476 | Módem Comtrend CT-350 con el driver ueagle-atm (remake)                                                       |
#  477 | HP Deskjet 720 en Debian GNU/Linux                                                                            |
#  482 | Poner etiquetas a los discos en GNU/Linux                                                                     |
#  479 | CV de la ANECA en SQL para OpenOffice                                                                         |
#  475 | Dibujemos matrices fácilmente con LaTeX!                                                                      |
#  481 | Compartir una impresora CUPS automágicamente                                                                  |
#  484 | Slax, qemu y cintas de video...                                                                               |
#  505 | Programando una MICA2                                                                                         |
#  541 | WebDAV con Apache2 en Debian GNU/Linux                                                                        |
#  497 | Puertos en el PIC16F690                                                                                       |
#  491 | OpenOffice.org scripting                                                                                      |
#  492 | Servidor TFTP con inetd en Debian                                                                             |
#  493 | Hacking serio básico: Introducción a los "shellcodes" (I)                                                     |
#  494 | Apache2 como frontal "seguro" para Zope/Plone                                                                 |
#  495 | Papanatas del software propietario                                                                            |
#  496 | GP2X, primer contacto                                                                                         |
#  498 | Oscilador interno del PIC16F690                                                                               |
#  500 | Imprimir en una 'winprinter' compartida por un MS Windows                                                     |
#  501 | 3 PadreNuestro's y 5 Ave Maria's ...                                                                          |
#  502 | Comandos imprescindibles de LDAP                                                                              |
#  503 | Subversion server side scripting (hooks)                                                                      |
#  504 | Introducción a GNU PG                                                                                         |
#  507 | sincronizar una PDA en GNU/Linux                                                                              |
#  568 | Migrar el directorio home                                                                                     |
#  509 | afbackup                                                                                                      |
#  510 |  Dashboard Process: ayuda para PSP                                                                            |
#  511 | Uso de la herramienta XMLBASEDSRS                                                                             |
#  512 | WINCVS                                                                                                        |
#  513 | Filtrar spam con Sylpheed y Bogofilter                                                                        |
#  514 | Crear y editar huellas para componentes con PCB                                                               |
#  515 | Aceleración 3D con DRI en GNU/Linux                                                                           |
#  516 | Mantener ficheros de configuración con Subversion                                                             |
#  534 | Montar un repositorio estándar de paquetes Debian                                                             |
#  517 | Router NAT proxy firewall                                                                                     |
#  518 | Impresora HP LaserJet 1000 USB                                                                                |
#  519 |  Trucos de impresión                                                                                          |
#  520 | Como configurar la impresora en Debian                                                                        |
#  521 | Configurar múltiples interfaces de red                                                                        |
#  522 | Usar la librería libxml2                                                                                      |
#  523 |  Cursores de ratón personalizados en XFree86 4.3                                                              |
#  524 | Configurar el portatil para la red de casa y de la oficina                                                    |
#  525 |  Usos avanzados de OpenOffice.org                                                                             |
#  526 |  Usos interesantes de wget                                                                                    |
#  527 | Acceder a UCLM WiFi con GNU/Linux                                                                             |
#  528 | WuMing, la guerrilla cultural                                                                                 |
#  529 | GNU Emacs: Elegir el encoding                                                                                 |
#  530 | Soporte para AT90USB1287 y otros AVR nuevos con GCC                                                           |
#  531 | Sacando el jugo a las tarjetas Atheros (madwifi)                                                              |
#  532 | Lantronix XPORT                                                                                               |
#  533 | Creación de Plugins para Freevo                                                                               |
#  535 | Migración de repositorios subversion                                                                          |
#  536 | Software libre, copyleft y canon digital                                                                      |
#  537 | Reconfigurando el XPORT "al vuelo"                                                                            |
#  538 | Yago, un robotillo libre basado en AVR                                                                        |
#  539 | PyGTK y Glade, GUIs instantáneas                                                                              |
#  540 | Magia negra con scapy                                                                                         |
#  542 | Eth2_rename: el problema de udev ...                                                                          |
#  543 | Código fuente y esquemas de Yago                                                                              |
#  544 | Aprende "Linux" con el Ministerio                                                                             |
#  556 | Cuando el gestor de claves de GNOME se pone pesadito                                                          |
#  546 | Programación de USB en GNU/Linux                                                                              |
#  548 | Arte "linuxero"...                                                                                            |
#  549 | Configurando backups en Bacula                                                                                |
#  550 | Fallos en el repositorio de Mesa (a día 9 de Febrero de 2007) DRM_VBLANK_SECONDARY                            |
#  554 | TES: Emacs con pestañas                                                                                       |
#  552 | Preguntas Inteligentes (lectura obligatoria)                                                                  |
#  558 | Instalar un servidor jabber en Debian                                                                         |
#  559 | El nuevo tema de crysol                                                                                       |
#  560 | Instalación de Moin Wiki en Debian                                                                            |
#  561 | ¡¡Estamos en obras!!                                                                                          |
#  562 | Aprende punteros con Binky                                                                                    |
#  661 | ¡Ayuda! Audio en gnu/linux                                                                                    |
#  666 | Fluendo busca gente                                                                                           |
#  566 | Crear nuevos elementos para Gstreamer                                                                         |
#  570 | unos tests de logo...                                                                                         |
#  571 | III Jornadas de Software Libre en Albacete                                                                    |
#  572 | TES: Emacs bonito                                                                                             |
#  574 | Tabletas Wacom en X.Org                                                                                       |
#  575 | Sobre los gtk.RadioButton                                                                                     |
#  726 | Dos monitores (dual-head) con xrandr                                                                          |
#  727 | Buscar ficheros en el repositorio Debian: apt-file                                                            |
#  578 | Avances en GNESIS 3.0                                                                                         |
#  579 | LG L204-WT en Debian                                                                                          |
#  580 | Firefox file types xmms                                                                                       |
#  581 | Patentes: esta vez paga Micro$oft (1.5 millones de millones de dólares)                                       |
#  582 | Peras en reducción de vino                                                                                    |
#  583 | GNU/Linux en el Vaticano                                                                                      |
#  584 | GNU IS NOT LINUX                                                                                              |
#  585 | Wallpaper GNESIS 3.0                                                                                          |
#  586 | Lentejas libres                                                                                               |
#  589 | TES: Eliminar ficheros basura generados por Emacs                                                             |
#  590 | Armonizando                                                                                                   |
#  591 | + ARTE                                                                                                        |
#  592 | GSTreamer: What's new?                                                                                        |
#  593 | Access Denied (+ arte)                                                                                        |
#  594 | NexentaOS: esto es GNU, no Linux                                                                              |
#  595 | Firemacs: el iceweasel intuitivo                                                                              |
#  596 | Buscar fácilmente en el histórico de GNU Bash                                                                 |
#  597 | ¡¡¡Gnesis 3.0 "fRincon" minimal pre-release LIBERADA!!!                                                       |
#  598 | Instalar GNESIS en un USB, desde GNU/Linux                                                                    |
#  599 | Búsqueda Recursiva con Python                                                                                 |
#  600 | Ahí va la virgen! Metaclases! (con Python)                                                                    |
#  611 | generate_m3u                                                                                                  |
#  665 | ¿se puede hacer dinero con el software libre?                                                                 |
#  602 | Instalar Beryl desde repositorio                                                                              |
#  603 | CUPS (o dónde está mi cola)                                                                                   |
#  604 | TES: Emacs Server                                                                                             |
#  605 | Energía en ns2                                                                                                |
#  606 | ¡¡Que te cambies ya!! Coñiiio                                                                                 |
#  607 | Imagen para el término "cocina"                                                                               |
#  608 | ReadyBoost: destroza tu pendrive con Windows Vista                                                            |
#  609 | I Jornadas sobre Piratería en la UCLM                                                                         |
#  610 | GNU Emacs: Ortografía «al vuelo» con flyspell                                                                 |
#  612 | ¿Conoces FON?                                                                                                 |
#  613 | Dot Net Club  (don't set club)                                                                                |
#  615 | Prueba de logo                                                                                                |
#  616 | Nueva camisetilla...                                                                                          |
#  772 | Micro servidor DNS con scapy                                                                                  |
#  618 | Port-knocking: "llama antes de entrar"                                                                        |
#  619 | Empezar con ZeroC Ice en Debian                                                                               |
#  620 | Mantener un paquete Debian con svn-buildpackage                                                               |
#  622 | GNU/Linux y Nintendo DS                                                                                       |
#  623 | Propuesta de creación de SL.                                                                                  |
#  624 | SVN Externals: dependencias entre repos subversion                                                            |
#  625 | Recuperación de un sistema completo: Mondo y Bacula                                                           |
#  626 | Plataforma anti soporte gratuito a microsoft                                                                  |
#  627 | GNU Emacs: Edición «rectangular» (selección vertical)                                                         |
#  628 | Pysoya: menú de ejemplo                                                                                       |
#  629 | Nueva GNESIS 3.0 "fRincón" Pre-Release2                                                                       |
#  630 | Cruzar el atlántico a nado... No tiene precio.                                                                |
#  631 | FreeBand: guitarra y batería ¡más arcade que nunca!                                                           |
#  632 | NO COMPRAR: Computadoras HP                                                                                   |
#  633 | Instalar GNESIS en un USB, desde Windows (con perdón)                                                         |
#  634 | El síndrome del "Amigo Informático"                                                                           |
#  635 | Utilizar un mando Wii con tu GNU/Linux                                                                        |
#  636 | Wii-Mando con Libwiimote en GNU/Linux (Incluye video-demo ;-P)                                                |
#  638 | Mi sistema operativo se llama GNU                                                                             |
#  640 | Gaim cambia de nombre                                                                                         |
#  641 | Escribir en chino en GNU/Linux                                                                                |
#  642 | Nueva versión de Debian                                                                                       |
#  643 | GNU Emacs: Acelerando el arranque, con .Xresources                                                            |
#  645 | GLib IO Channels con C                                                                                        |
#  646 | SWIG: donde C y Python se dan la mano                                                                         |
#  647 | VideoLAN Streaming                                                                                            |
#  648 | ¿Soy un albañil?                                                                                              |
#  649 | Instalar Debian GNU/Linux en el Sony VAIO VGN-SZ4XN                                                           |
#  662 | 10.000 visitas!                                                                                               |
#  651 | Bogoutil: completa bogofilter                                                                                 |
#  652 | El software es un producto?                                                                                   |
#  653 | Emule y torrents en GNU/Linux                                                                                 |
#  654 | Reproductores GStreamer                                                                                       |
#  655 | Streaming RTP usando GStreamer                                                                                |
#  656 | Nintendo Wii y GNU/Linux                                                                                      |
#  659 | Capturar vídeo DV en Debian                                                                                   |
#  658 | TRENDnet TEW-429UF en Linux                                                                                   |
#  667 | sudoers (o cómo evitar que sudo te pida contraseña)                                                           |
#  668 | Reproducir Flash con Gnash en PowerPC (y en otras) en GNU/Linux                                               |
#  669 | Nueva versión de UCLM-WiFi                                                                                    |
#  673 | Soy famoso!                                                                                                   |
#  671 | Presentación del club.net                                                                                     |
#  672 | 10 razones para no usar "Linux"                                                                               |
#  674 | Libremeeting en Miraflores de la Sierra (Madrid)                                                              |
#  675 | Libro de pegatinas sobre Software Libre                                                                       |
#  676 | Rabietas de patio de colegio                                                                                  |
#  677 | Creación de módulos e interfaces en nesC para TinyOS 2                                                        |
#  679 | Otra de Linus                                                                                                 |
#  681 | Webcams USB y Linux                                                                                           |
#  682 | Un millón de gracias                                                                                          |
#  683 | GNU Emacs: Mejorando Tabbar                                                                                   |
#  684 | Hacer y aplicar parches                                                                                       |
#  685 | Traffic shaping y QoS en GNU/Linux                                                                            |
#  686 | "Conferencia sobre Software Libre"                                                                            |
#  687 | Ajustes al tinyOS 2                                                                                           |
#  689 | RS232 en el PIC: UART por software                                                                            |
#  688 | Cairo: tutorial en castellano                                                                                 |
#  690 | La consola de la fonera: DS275                                                                                |
#  691 | Acelerando SSH                                                                                                |
#  692 | Marcar y clasificar tráfico con iptables y tc                                                                 |
#  693 | Hasta luego HD-DVD                                                                                            |
#  694 | ¿Cómo realizar búsquedas con el emule, descargar... desde otro ordenador?                                     |
#  695 | Quijote Información                                                                                           |
#  696 | Sincroniza tus ficheros con Unison                                                                            |
#  697 | Recuperar un disco duro con dd_rhelp (o intentarlo al menos)                                                  |
#  698 | Ice en la fonera: Ice-E en OpenWRT                                                                            |
#  699 | apt-build: cuando Debian huele a Gentoo                                                                       |
#  700 | Kolofonium, activando SSH en "la fonera"                                                                      |
#  701 | Nueva versión de uclmwifi: 1.5.5                                                                              |
#  702 | Kerberos5, LDAP y errores frecuentes                                                                          |
#  703 | Gráficas con Python y GNUPlot                                                                                 |
#  704 | Estadísticas CRySoL                                                                                           |
#  705 | Humor Informático                                                                                             |
#  707 | admin :: dummy                                                                                                |
#  708 | Trucos y cosas: Gnome y cambio de ventanas                                                                    |
#  709 | crysol.org                                                                                                    |
#  710 | Instalación de TinyOS 1.x en Debian                                                                           |
#  711 | Uf... más política...                                                                                         |
#  712 | Ejemplo sencillo de Glacier2 con C++                                                                          |
#  713 | Plugin Guifications en Pidgin                                                                                 |
#  714 | Recuperar Grub                                                                                                |
#  715 | Nuevo sistema WiFi en la UCLM                                                                                 |
#  717 | Ethernet Bridging en GNU/Linux                                                                                |
#  719 | Conectar a la nueva WiFi de la UCLM (aka. eduroam) con network-manager                                        |
#  720 | Programación de la PSP: intros multimedia                                                                     |
#  722 | Foros de Ubuntu-es                                                                                            |
#  728 | GNU Emacs: puesta a punto                                                                                     |
#  729 | Solución al fallo de GLX en tarjetas Nvidia antiguas (legacy)                                                 |
#  730 | Tcpstat, estadísticas de la red                                                                               |
#  731 | Los titulados españoles son los que menos cobran de Europa                                                    |
#  732 | Los descriptores de Python                                                                                    |
#  733 | SAI "MGE Pulsar Ellipse 600" en Debian con NUT                                                                |
#  734 | Instalar Debian GNU/Hurd bajo QEMU                                                                            |
#  735 | Ayuda con Visión por computador                                                                               |
#  736 | Jugando con el servidor X                                                                                     |
#  737 | Instalar driver privativo de Nvidia con kernel Linux >= 2.6.20                                                |
#  738 | LIRC con la WinFast TV  2000 en Debian                                                                        |
#  739 | Instalar GNU/Linux+Cell SDK 2.1 en PlayStation 3                                                              |
#  740 | Python + LIRC                                                                                                 |
#  743 | En busca de la solución definitiva para la autenticación                                                      |
#  744 | Linus Tolvards: eres "mu" tonto (tontismo).                                                                   |
#  745 | Intro PSP (pseudo demoscene) (a.k.a respuesta a nuestro Int-0)                                                |
#  746 | Aplicaciones portables entre PSP y GNU/Linux con SDL                                                          |
#  747 | M$ Surface? No... esto no es de M$ :)                                                                         |
# 1374 | inotify: acciones disparadas por cambios en el sistema de ficheros                                            |
#  749 | OSD, escribiendo en el escritorio                                                                             |
#  750 | Citas de Dijkstra                                                                                             |
#  751 | MetaReceta: Creación de paquetes Debian                                                                       |
#  752 | GNU/Linux y Nintendo DS (2ª Parte)                                                                            |
#  753 | ATMEL y el Software Libre                                                                                     |
#  754 | autotools                                                                                                     |
#  966 | MicroSinCity                                                                                                  |
#  758 | Gestionando preferencias con GConf y Python                                                                   |
#  757 | Twitter + crysol                                                                                              |
#  759 | Diez (o más) señales de que no eres tan buen programador como piensas                                         |
#  760 | Hasta luego SCO!                                                                                              |
#  761 | 10 señales de que no eres tan gnu-ista como crees                                                             |
#  764 | OWS: OSD Workspace Switcher                                                                                   |
#  765 | Grandes inventos de Microsoft: El ratón y la interfaz gráfica.                                                |
#  766 | GNU Emacs: Modo para programación en C#                                                                       |
#  767 | Real como la vida misma....                                                                                   |
#  768 | Software para electrónicos: Kicad (2ª Parte)                                                                  |
#  769 | Molinux en la UCLM                                                                                            |
#  770 | Obtener la IP con scapy                                                                                       |
#  771 | Jugando con LEGO MindStorms: NXT                                                                              |
#  773 | ZeroC Ice: Tareas periódicas en un servidor                                                                   |
#  774 | Downloading films is stealing                                                                                 |
#  775 | Lexmark e250d en Debian (y GNU/Linux en general)                                                              |
#  776 | python-scapy_1.1.1-3 en Debian (unstable)                                                                     |
#  777 | Lego Mindstorms NXT: programar con NXC                                                                        |
#  778 | I Concurso Universitario de Software Libre de C-LM                                                            |
#  779 | Lego Mindstorms NXT: BlueTooth                                                                                |
#  780 | ZeroC IceGrid: Guía rápida I                                                                                  |
#  781 | La virgulilla está muerta!                                                                                    |
#  850 | Configurar adaptador inalámbrico de red USB con ndiswrapper                                                   |
#  782 | InfoGLOBAL : Presentación                                                                                     |
#  783 | Timeout de un método en C++ con Glib                                                                          |
#  784 | Kit de desarrollo para Symbian en GNU/Linux                                                                   |
#  869 | Mas librerias para kicad                                                                                      |
#  788 | Reunión Club .NET                                                                                             |
#  789 | Editar menú de Gnome (y solución al "Menú Debian" desaparecido)                                               |
#  790 | SQL in'y'ection                                                                                               |
#  791 | LaTeX: Chuletario básico                                                                                      |
#  792 | Necesito ayuda con la compilacion en emacs                                                                    |
#  794 | Más eficaz que la porra es el miedo a la porra                                                                |
#  795 | ZeroC IceStorm: gestionando eventos                                                                           |
#  796 | Sockets «raw» con Python                                                                                      |
#  797 | git, el control de versiones definitivo (por ahora)                                                           |
#  798 | ZeroC IceBox: Creación de un servicio                                                                         |
#  941 | GNU Emacs: Editando programas Python                                                                          |
#  800 | HTTP GET con libcurl en C++                                                                                   |
#  801 | Demo del nuevo instalador Debian                                                                              |
#  802 | Bolsa de Trabajo Ceslcam                                                                                      |
#  803 | Bolsa de Trabajo Ceslcam                                                                                      |
#  804 | Jornadas sobre el uso del Software Libre y la incorporación de las TIC en las Empresas                        |
#  806 | Patrones: Todo lo que nunca quisiste saber y siempre evitaste preguntar                                       |
#  807 | GNU Emacs: Reemplazar texto en múltiples ficheros                                                             |
#  808 | Bolsa de Trabajo de Software Libre                                                                            |
#  809 | Más de 20 estudiantes de la UCLM desarrollarán proyectos en SL                                                |
#  810 | Catálogo de Modismos y Patrones                                                                               |
#  811 | 100Mbps + 100Mbps = 200Mbps: port trunking (a.k.a. bonding ports)                                             |
#  812 | Parted y Python: pyparted                                                                                     |
#  813 | Nuevo sistema antipiratería de Vista SP1: dar la brasa!                                                       |
#  814 | New Debian Developer                                                                                          |
#  815 | GNU Emacs: Construir un «major mode» paso a paso                                                              |
#  816 | Entrevista a Ana María Méndez (APEMIT)                                                                        |
#  817 | Conectar a Internet por medio de un móvil 3G EDITADO                                                          |
#  818 | Creación de un parser con flex y bison en C++                                                                 |
#  819 | Analizador léxico, sintáctico y semántico con JFlex y CUP                                                     |
# 1003 | Cambiar nombres de ficheros segun un patrón                                                                   |
#  821 | Emulador de Cisco IOS: Dynamips y Dynagen                                                                     |
#  822 | Razones de peso por las que necesitas Windows Live!                                                           |
#  823 | Building Skills                                                                                               |
#  825 | ¡El Ceslcam regala un pendrive de 4GB!                                                                        |
#  827 | Solución al problema con los overlays en monitores secundarios                                                |
#  832 | Comparaciones odiosas (lista de)                                                                              |
#  829 | Configuración básica para jed                                                                                 |
#  831 | GNOME VFS con Python                                                                                          |
#  833 | Simulación de código C para AVR                                                                               |
# 1506 | Debian TDD                                                                                                    |
#  835 | Traceando código C en los AVR "in circuit": avarice                                                           |
#  836 | II Curso Online de Java Ceslcam                                                                               |
#  837 | Sesión Técnica "Sun OpenSource Technologies" en la ESI                                                        |
#  838 | Jornada Técnica Molinux en la ESI de Ciudad Real                                                              |
#  839 | (Py)GTK Tips 'n Tricks                                                                                        |
#  845 | Dell vende portátiles con Ubuntu Linux de serie... pero...                                                    |
#  846 | El efecto 2038...                                                                                             |
#  840 | OpenWRT en La Fonera                                                                                          |
#  841 | Configuración del chipset Intel 82801H con ALSA                                                               |
#  842 | ZeroC Ice: Persistencia de sirvientes con Freeze Evictor                                                      |
#  843 | Java como primer lenguaje: mala idea                                                                          |
#  844 | Ebay y el software libre...                                                                                   |
#  848 | Desarrollo de aplicaciones para PSP-Slim y PSP-Fat con FW actuales                                            |
#  849 | Instalación Debian                                                                                            |
#  851 | Ya está disponible en la plataforma de formación del CESLCAM el curso Molinux 3.2                             |
#  852 | Router «chupachups» en GNU/Linux                                                                              |
#  853 | "Amara" por fin en Debian                                                                                     |
#  854 | Usar un Treeview como Handler de Python Logging                                                               |
#  855 | Buenísimo                                                                                                     |
#  856 | Kicad: Conclusiones                                                                                           |
#  858 | Divide y vencerás                                                                                             |
#  857 | Revista Begins                                                                                                |
#  859 | El "Meta-amigo"                                                                                               |
#  860 | CRySoL GNU Install Party v3.2                                                                                 |
#  861 | M$ libera la especificación del formato de los ficheros de Office                                             |
#  865 | Exposición 'Por Tierras de Molinux'                                                                           |
#  863 | Entrevista a Alexey Leonidovich Pazhitnov                                                                     |
#  864 | Instalar torrenflux-b4rt en Debian                                                                            |
#  866 | Pendrive cifrado con dm-crypt en Debian                                                                       |
#  867 | Borrado a conciencia de ficheros y particiones en Debian                                                      |
#  870 | Actualizar firmware de XPort                                                                                  |
#  871 | GNU Emacs: manipulando el control de versiones                                                                |
#  872 | Gran Acogida de la Plataforma de Formación de la Junta con el CESLCAM                                         |
#  873 | Nexuiz 2.4 en la calle                                                                                        |
#  874 |  El Ceslcam presenta nuevos cursos de OpenOffice en su plataforma e-learning                                  |
#  875 | ¿Quién teme al lobo feroz?                                                                                    |
#  876 | Comienzan los preparativos para la fase final del I Concurso de SL de C-LM                                    |
#  877 | OpenOffice.org, la suite de productividad ofimática de... Telefónica?                                         |
#  878 | GNU Emacs: Enviar emails                                                                                      |
#  879 | ¡dotBF necesita tu ayuda!                                                                                     |
#  880 | Vota Microsoft, la realidad patente!                                                                          |
#  881 | Sabías que... "cp" no tiene porqué borrar tus ficheros.                                                       |
#  882 | ¡¡¡Ya estamos en China!!!                                                                                     |
#  883 | Abierto el plazo de inscripción para asistir a la Fase Final del I Concurso Universitario de SL de C-LM       |
#  885 | M$ utiliza software libre...                                                                                  |
#  886 | ¡NDS y Fonera por fin!                                                                                        |
#  887 | iPhone e iPod Touch con Mono :)                                                                               |
#  888 | Compilando e instalando PAlib                                                                                 |
#  889 | Transferencia vía WiFi para Nintendo DS: senDS 3.0                                                            |
#  890 | Gestión sencillita de tu colección de películas                                                               |
#  891 | Programación de Shaders GLSL en GNU/Linux                                                                     |
#  892 | Se buscan colaboradores para talleres en Fase Final del I Concurso SL de C-LM                                 |
#  893 | Montar y desmontar una PSP                                                                                    |
#  894 | Espaguetis, ajo, aceite y guindilla                                                                           |
#  895 | Kicad: Resultado Final...                                                                                     |
#  896 | Charlas sobre software libre                                                                                  |
#  897 | ¿Anti-hoygan en desarrollo?                                                                                   |
#  898 | Llamadas VoIP desde NDS                                                                                       |
#  899 | Dinerocracia                                                                                                  |
#  900 | Primeros pasos con openWRT                                                                                    |
#  901 | Instalar X-Wrt en La Fonera                                                                                   |
#  902 | Técnicas de Ataque TCP/IP                                                                                     |
#  903 | Filtrado por MAC                                                                                              |
#  904 | GNU Bash para programadores Python                                                                            |
#  905 | Fase Final del Concurso de SL de CLM                                                                          |
#  906 | Crear sistemas de ficheros XFS                                                                                |
#  907 | Patentes Inconcebibles y Basura Espacial                                                                      |
#  908 | Material para el taller de videojuegos                                                                        |
#  909 | LaTeX: Listados de código cómodos y resultones con listings                                                   |
#  910 | GNU Emacs: reStructuredText                                                                                   |
#  911 | GladeWrapper, o cómo hacer una aplicación GTK con Python en 7 líneas                                          |
#  912 | Concurso de Videotutoriales en Molinux                                                                        |
#  913 | ZeroC Ice: Parseando un fichero Slice                                                                         |
#  914 | Bindings Python de librerías C++, con SIP                                                                     |
#  915 | Comparaciones odiosas: git contra el mundo                                                                    |
#  916 | Modular GTK GUIs based on partial descriptions with glade and Python                                          |
#  917 | Goocanvas I parte: Hello World!                                                                               |
#  918 | Unas reflexiones sobre "sintactic sugar" y el goto                                                            |
#  921 | Politonos gratis                                                                                              |
#  922 | ¿A qué huele el código?                                                                                       |
#  923 | Más amigo informático                                                                                         |
#  924 | Upgrade a drupal-5.7                                                                                          |
#  926 | Scanner HP Scanjet 3200C                                                                                      |
#  931 | Listados de código en CRySoL                                                                                  |
#  932 | Aviso a los autores de recetas                                                                                |
#  934 | Nokia 6300 como módem para Debian (con simyo)                                                                 |
#  935 | Manual básico de iproute2                                                                                     |
#  936 | Yo plagio                                                                                                     |
#  937 | más canon                                                                                                     |
#  938 | Cómo limpiar tu ordenador                                                                                     |
#  939 | Bindings Python de librerías C++ con Boost.Python                                                             |
#  943 | Prácticas de programación infames (1ª parte)                                                                  |
#  944 | Ubuntu 8.04 en Airis Kira 300                                                                                 |
#  945 | Carga dinámica de contenido HTML con XMLHttpRequest                                                           |
#  949 | Enlaces útiles para Chumby                                                                                    |
#  950 | SSH en el Chumby                                                                                              |
#  951 | Debian GNU/Linux en el Dell XPS 420                                                                           |
#  954 | Escáner EPSON V10 en Debian                                                                                   |
#  955 | Uso de Mercurial                                                                                              |
#  956 | El Chumby desde tu navegador                                                                                  |
#  957 | Preinscripción III Edición Curso Java CESLCAM                                                                 |
#  958 | El put* canon.                                                                                                |
#  959 | Entorno de desarrollo para el Chumby                                                                          |
#  960 | ZeroC-IceE para el Chumby                                                                                     |
#  998 | 25º aniversario del proyecto GNU                                                                              |
#  962 | Puesta en marcha de un servidor DHCP                                                                          |
#  963 | Truco tonto: engañar a wget                                                                                   |
#  964 | Gracias al canon                                                                                              |
#  965 | Patrones de diseño en Python                                                                                  |
#  967 | intro (<3K) de CRySoL                                                                                         |
#  968 | Drupal 6.3                                                                                                    |
#  970 | Lo único seguro es que no lo es                                                                               |
#  971 | Prácticas de Programación Infames: OpenJDK                                                                    |
#  984 | ZeroC Ice: recogiendo estadísticas.                                                                           |
#  985 | scapy 2.0.0.5 en Debian                                                                                       |
#  986 | Ayuda con instalación de Ubuntu a medias                                                                      |
#  988 | Usar Pidgin para unirte a una sala Jabber                                                                     |
#  994 | Coexistencia feliz entre GNU/Linux y Enemy Territory                                                          |
#  989 | Primeras reacciones al banner anti-software privativo de CRySoL                                               |
#  990 | Cambiar el "timezone" en Debian                                                                               |
#  991 | Administrar scripts de arranque                                                                               |
#  992 | La importancia de cifrar tu vida.                                                                             |
# 1008 | Cosillas pendientes                                                                                           |
#  993 | Python: merge lists                                                                                           |
#  995 | Utilizar un servidor FTP remoto como backup                                                                   |
#  996 | Cambiar la password de Active Directory desde GNU                                                             |
#  997 | Asignatura sobre Software Libre en la Universidad de Sevilla                                                  |
#  999 | La Forma Canónica Ortodoxa                                                                                    |
# 1000 | Y no es broma: el plagio se paga                                                                              |
# 1001 | micro reto de la semana                                                                                       |
# 1002 | Sub-repositorios en mercurial con Forest                                                                      |
# 1004 | Pensar en C++: Herencia de interfaces                                                                         |
# 1005 | Nano reto de programación en BASH                                                                             |
# 1006 | Nueva edición Concurso Universitario de Software Libre de CLM                                                 |
# 1007 | Mini reto estúpido (again and again)                                                                          |
# 1009 | Hercules Webcam Deluxe bajo GNU/Linux                                                                         |
# 1010 | print con colores en python                                                                                   |
# 1012 | mini-watchdog en C                                                                                            |
# 1013 | logging con colorcitos en Python                                                                              |
# 1014 | Reto de la semana: "display 7 segmentos oblícuo"                                                              |
# 1015 | Probando OS                                                                                                   |
# 1016 | Documentación oficial de Scapy                                                                                |
# 1017 | Patrón Singleton en Python como metaclase                                                                     |
# 1018 | Metaclase para invocación automática del "constructor" de la superclase                                       |
# 1019 | El inesperado valor docente del absentismo                                                                    |
# 1020 | Encuentra una idea y participa en el Concurso Universitario de Software Libre de C-LM                         |
# 1021 | Mailman and Exim4                                                                                             |
# 1022 | GTK UIManager                                                                                                 |
# 1023 | Mini tutorial de OO con Python                                                                                |
# 1024 | udev: Configurando el acceso al USB sin ser root                                                              |
# 1025 | Contenedores y downcasting en C++                                                                             |
# 1026 | Programación de Tareas                                                                                        |
# 1027 | Cumpleaños feliz!                                                                                             |
# 1028 | GNU Emacs: usando emacs + cscope                                                                              |
# 1029 | Ampliado el plazo de inscripción en el Concurso Univ. de Software Libre                                       |
# 1030 | "se trata [...] de un empecinamiento en separar el equipo del SO"                                             |
# 1031 | El colmo del colmo: Especulando con el contenido libre                                                        |
# 1032 | DLXview para GNU's actuales                                                                                   |
# 1033 | Doble Monitor con ATI Radeon HD 3870                                                                          |
# 1034 | Lo bueno del capitalismo                                                                                      |
# 1035 | Servir un repo mercurial por http (solo lectura)                                                              |
# 1036 | GNU Emacs: Cambiar la configuración de colores                                                                |
# 1037 | Soy nuevo en esta comunidad, saludos.                                                                         |
# 1038 | Para que dices que servía esto?                                                                               |
# 1039 | Bridges de red para VirtualBox y QEMU                                                                         |
# 1040 | Mermelada                                                                                                     |
# 1041 | Nueva versión de Molinux Adarga 4.0                                                                           |
# 1042 | XPS M1530                                                                                                     |
# 1043 | Introducción a los hilos con la librería glib                                                                 |
# 1044 | DevkitPro 23b para Debian/Ubuntu/Molinux                                                                      |
# 1045 | De ingenieros informáticos y otras criaturas fantásticas                                                      |
# 1046 | Ayuda con molinux, acceso a programas                                                                         |
# 1048 | ayuda con mail/sendmail                                                                                       |
# 1049 | El piratear se va a acabar                                                                                    |
# 1050 | Instalar Debian GNU/Linux en el Acer Aspire ONE A150L                                                         |
# 1051 | Mapnik - Visualizador GIS para Python y C++                                                                   |
# 1052 | adjuntos para comentarios                                                                                     |
# 1053 | El sistema de 3 avisos "funciona" en UK                                                                       |
# 1054 | mis cosas                                                                                                     |
# 1055 | Los ilegales intentan engañarte... ¡No te dejes manipular!, para que nadie te time                            |
# 1056 | Tslib: librería para la pantalla táctil del Chumby                                                            |
# 1057 | Ayuda con máquina virtual para ubuntu                                                                         |
# 1058 | El Robo del Milenio: cómo Internet llegó a ser libre, y porqué es importante                                  |
# 1059 | DlxView: Un emulador para arquitecturas DLX                                                                   |
# 1060 | Accediendo a los bookmarks de Firefox desde Python                                                            |
# 1061 | Bacula usando un disco duro                                                                                   |
# 1062 | Manipulación «eficiente» de secuencias de bytes en Python                                                     |
# 1063 | Alsa: audio loopbacks (o cómo capturar el audio que reproduzco)                                               |
# 1064 | Copyright amazing adventures                                                                                  |
# 1065 | Necesito algo de ayuda sobre mi LAN                                                                           |
# 1066 | ZeroC Ice: Desarrollo de plugins                                                                              |
# 1067 | Preforking TCP Server                                                                                         |
# 1073 | Seguridad WiFi con tarjetas Atheros                                                                           |
# 1068 | Encuentro digital con David Bravo                                                                             |
# 1069 | La consejería de educación y ciencia de CLM apuesta por Windows                                               |
# 1070 | babel: ¿cuadro o tabla?                                                                                       |
# 1071 | Suicidios de discos duros...                                                                                  |
# 1072 | LaTeX: Referencias imprescindibles                                                                            |
# 1074 | Python-3.0 (a.k.a Python 3000) para Debian                                                                    |
# 1075 | Utilidades para medir el ancho de banda en Debian                                                             |
# 1076 | Gimp: recortar una imagen en línea de órdenes                                                                 |
# 1077 | Nuevo Window$ Xp: Le acercamos al holocausto nuclear....                                                      |
# 1078 | Montando OpenVZ's                                                                                             |
# 1079 | Soy Linux... y mi hermano, mi perro y mi coche también                                                        |
# 1080 | Instalar Debian desde red con PXE (nunca fue tan fácil)                                                       |
# 1081 | Router casero con Debian en el fit-PC 1.0                                                                     |
# 1082 | DVB-T Realtek 2831U on Debian                                                                                 |
# 1083 | nohands: convirtiendo nuestro PC en un manos libres bluetooth                                                 |
# 1084 | No habrá sistema de 3 amenazas a internautas en UK                                                            |
# 1085 | Darwin Streaming Server para Dispositivos Móviles                                                             |
# 1086 | Solución al problema de captura por firewire                                                                  |
# 1087 | Updated debian packages for devkitPro                                                                         |
# 1088 | Buenas referencias, malas terribles referencias                                                               |
# 1089 | Cómo funciona apt/dpkg                                                                                        |
# 1090 | Activar "compositing" en GNOME (sin utilizar Compiz ni derivados)                                             |
# 1091 | Crear un IconView                                                                                             |
# 1092 | Cairo: using a SVG as a shape (or Cairo Groups)                                                               |
# 1093 | Cairo: usar un SVG como figura ("Cairo Groups")                                                               |
# 1094 | Partición cifrada con dm-crypt en Debian                                                                      |
# 1095 | Google Gears works on Iceweasel (Debian, Ubuntu)                                                              |
# 1096 | Install Party v.4                                                                                             |
# 1097 | Save (and restore) a MySQL data base                                                                          |
# 1100 | El auténtico emblema de informática                                                                           |
# 1101 | Cambiar "accels" de GTK sobre la marcha                                                                       |
# 1102 | ¿De qué me suena?                                                                                             |
# 1103 | EasyCAP en GNU/Linux                                                                                          |
# 1377 | INGSOFT                                                                                                       |
# 1105 | Subtítulos fuera de la imagen en mplayer                                                                      |
# 1106 | Si eres legal, eres legal                                                                                     |
# 1107 | Culpable a sabiendas de ser inocente                                                                          |
# 1108 | Abierto Plazo de Inscripción Fase Final Concurso Software Libre de CLM                                        |
# 1109 | Recordmydesktop: drag and drop                                                                                |
# 1110 | Fase Final Concurso Univ. Software Libre de CLM                                                               |
# 1119 | Contenidos libres                                                                                             |
# 1111 | Eaglemode: mi PC a vista de pájaro...                                                                         |
# 1112 | ¡¡¡Stallman, devuelve el dinero de los pisos....!!!                                                           |
# 1113 | ¡Dos "crysoleros" ganan en el concurso de Software Libre!                                                     |
# 1114 | Debian Live personalizada en una línea                                                                        |
# 1115 | El 'software' libre favorece a la empresa (www.expansion.com)                                                 |
# 1116 | ¡Felicidades David!                                                                                           |
# 1117 | ¿Software garantizado?                                                                                        |
# 1118 | Molinux Zero: distribución GNU/Linux para equipos obsoletos y con pocos recursos                              |
# 1120 | ¿Quién dijo que con inkscape no se podía?                                                                     |
# 1121 | Es como Lego!! ;-)                                                                                            |
# 1122 | Omikey Cardman 5321 RFID reader en Debian                                                                     |
# 1123 | ¿Qué hay detrás de Opera Unite?                                                                               |
# 1124 | Configurar Glacier2                                                                                           |
# 1125 | Stallman, famoso gracias a un peluche?                                                                        |
# 1126 | GNU Emacs: cursor en forma de línea vertical delgada                                                          |
# 1127 | Bacula: comandos de bajo nivel                                                                                |
# 1129 | ¿Cómo instalar OpenCV en Ubuntu 9.04?                                                                         |
# 1130 | Software libre para la docencia                                                                               |
# 1131 | JCCM quiere Windows 7                                                                                         |
# 1135 | Si ZP dice que Bill Gates lo dice...                                                                          |
# 1136 | La realidad (Amazon) supera a la ficción («Derecho a leer»)                                                   |
# 1137 | Enjuto Mojamuto: "No todos somos González Sinde"                                                              |
# 1138 | Configurar HTC Magic (G2) con Android en Debian GNU/Linux                                                     |
# 1223 | Abierta Inscripción Concurso Universitario de Software Libre de CLM                                           |
# 1212 | Sincronización del calendario de Gnome con Google Calendar                                                    |
# 1213 | Desactivación de pitidos varios                                                                               |
# 1214 | Debian en el Dell E4300                                                                                       |
# 1215 | Utilizar HTC Magic (G2) como módem en Debian GNU/Linux                                                        |
# 1216 | Just for fun                                                                                                  |
# 1217 | Configuración de módem USB Huawei en GNU/Linux (Huawei Linux)                                                 |
# 1218 | Atheist                                                                                                       |
# 1219 | Arreglar la guía docente 2009/2010                                                                            |
# 1220 | Configurar paneles de Gnome con doble monitor                                                                 |
# 1221 | Distribuir programas con Autotools                                                                            |
# 1222 | Python time                                                                                                   |
# 1224 | eduroam con network-manager (one more time)                                                                   |
# 1225 | Obtener permisos de root en el HTC Magic (G2)                                                                 |
# 1226 | Debian en el Acer Aspire Revo                                                                                 |
# 1227 | Configuración y uso de Pbuilder                                                                               |
# 1228 | Java, Ice, Netbeans, Eclipse y otras malas hierbas                                                            |
# 1230 | Guía rápida para creación de paquetes Debian                                                                  |
# 1231 | Creación del directorio 'debian' con dh_make para debianizar tu programa                                      |
# 1232 | Empaquetar una librería C++                                                                                   |
# 1233 | http://unidadlocal.com/ nos plagia (y quizá a ti también)                                                     |
# 1234 | Hacer un Makefile para paquete Debian                                                                         |
# 1235 | LaTeX: Creación de tablas de forma sencilla                                                                   |
# 1236 | Crear un paquete Debian binario sencillito                                                                    |
# 1237 | ¿Qué se puede hacer en Crysol?                                                                                |
# 1238 | Crear un paquete Debian con scripts de inicio                                                                 |
# 1239 | Ampliado plazo de Inscripción al III Concurso Univ. de Software Libre de CLM                                  |
# 1240 | Manipulación de documentos PDF desde Python, con pyPdf                                                        |
# 1241 | uBoot: "ARM, Levántate y anda"                                                                                |
# 1242 | Barrer la escoria en la red                                                                                   |
# 1245 | Servicios de GMX en GNU/Linux                                                                                 |
# 1246 | Frases célebres perdidas                                                                                      |
# 1253 | Escribir caracteres Unicode en GNU/Linux                                                                      |
# 1254 | LaTeX: babel + enumitem                                                                                       |
# 1256 | Menús y barra de herramientas dinámicas en PyGTK                                                              |
# 1257 | UIManager con Actions avanzadas en PyGTK                                                                      |
# 1258 | Creative ZEN con Debian GNU/Linux                                                                             |
# 1259 | El Supremo de EE UU decide qué invenciones son patentables                                                    |
# 1260 | Maneras de indentar                                                                                           |
# 1261 | Instalación de bacula                                                                                         |
# 1262 | Al parecer, utilizar GNU/Linux es delito en la Universidad de Boston                                          |
# 1264 | Creación de un módulo Drupal                                                                                  |
# 1265 | Creación de un plugin de munin para mldonkey                                                                  |
# 1266 | Concentrador OpenVPN en Debian GNU/Linux (o Ubuntu)                                                           |
# 1269 | 500 euros para el mejor software libre de 2009                                                                |
# 1268 | Manifiesto en defensa de los Derechos Fundamentales en Internet                                               |
# 1270 | Pasito a pasito...                                                                                            |
# 1271 | modificacion de iso ubunutu 910                                                                               |
# 1272 | Un googol para dominarlos a todos                                                                             |
# 1273 | Compilar Linux para la tarjeta arm mini2440                                                                   |
# 1274 | Sincronización remota en 4 pasos con rsync                                                                    |
# 1275 | Usar una partición real con Virtualbox                                                                        |
# 1276 | ARM mini2440: Configurando uBoot para arranque desde SD                                                       |
# 1277 | Manipulación de ficheros PostScript                                                                           |
# 1278 | Patrón Flyweight en Python como metaclase                                                                     |
# 1316 | Montar una partición de un disco VDI de VirtualBox                                                            |
# 1317 | Creando túneles TCP/IP (port forwarding) con SSH: Los 8 escenarios posibles usando OpenSSH                    |
# 1319 | Escaneando a PDF con Python y SANE                                                                            |
# 1320 | ¿Qué es eso de REST?                                                                                          |
# 1321 | Bridges y filtrado de protocolos                                                                              |
# 1322 | Cuando lo decíamos nos tachaban de locos...                                                                   |
# 1323 | Inyección de tráfico en chipsets Atheros                                                                      |
# 1324 | easygit: git para gente normal                                                                                |
# 1325 | Autenticación PAM en Drupal                                                                                   |
# 1326 | Conectar remotamente a una cámara Axis 211W mediante OpenCV en Ubuntu 9.04                                    |
# 1327 | Denunciar al estado español por el monopolio de las entidades de gestión                                      |
# 1328 | Enviar correo a través de Gmail con Python                                                                    |
# 1329 | Ejecutar acciones disparadas por eventos en repositorios Mercurial (hooks)                                    |
# 1330 | Manipulación de ficheros MP3                                                                                  |
# 1331 | El Presidente de Telefónica quiere cobrar por el trabajo de los demás                                         |
# 1332 | Configurar altavoces/auriculares bluetooth en GNU/Linux                                                       |
# 1333 | Empezando con SystemC                                                                                         |
# 1389 | «ingsoft» realista                                                                                            |
# 1335 | Problemas con la red en Java openjdk-6 en Debian                                                              |
# 1336 | problemas con adsl telefónica y debian linux                                                                  |
# 1337 | HP LaserJet P1005 en Debian                                                                                   |
# 1338 | Palpatine 2.0                                                                                                 |
# 1339 | Notificación por e-mail de cambios en repositorios Mercurial                                                  |
# 1340 | Patrón ThreadPool en Python                                                                                   |
# 1341 | Si es legal, ES LEGAL                                                                                         |
# 1342 | Guía rápida de CMake en GNU/Linux                                                                             |
# 1343 | CMake: Compilar un Hola Mundo!                                                                                |
# 1344 | CMake: Construir una librería estática y/o dinámica                                                           |
# 1345 | CMake: Instalar un paquete                                                                                    |
# 1346 | CMake: Enlazado de librerías                                                                                  |
# 1347 | CMake: Compilando aplicaciones ZeroC Ice                                                                      |
# 1348 | Día del Documento Libre                                                                                       |
# 1349 | Guía de referencia para cámaras AXIS                                                                          |
# 1350 | GNU Emacs: Macros de teclado                                                                                  |
# 1351 | Abierta inscripción a Día de Software Libre en la ESII                                                        |
# 1352 | Configuración de claws-mail para gmail con IMAP                                                               |
# 1353 | Configuring IGMP in a LAN to control IPTV multicast flows over Cisco Catalyst 3550-12T                        |
# 1354 | Instalación de un servidor Apache, PHP y MySQL en Debian                                                      |
# 1355 | Proxy SOCKS con SSH: más fácil imposible                                                                      |
# 1356 | Notificación de eventos con pynotify                                                                          |
# 1357 | Installing Omnet on Debian                                                                                    |
# 1358 | Reto de la semana: containers de la STL                                                                       |
# 1359 | Juicio en Luxembugo contra el canon                                                                           |
# 1360 | GNU Emacs: Cambiar fácilmente entre el .c y el .h                                                             |
# 1361 | PycURL: utilizando autenticación y cookies desde Python                                                       |
# 1362 | Configurar dispositivos Android para desarrollo bajo GNU/Linux                                                |
# 1363 | La comisaria europea de Agenda Digital a favor del software libre en las Administraciones Públicas            |
# 1364 | problemon en el pc                                                                                            |
# 1365 | ¿Por qué el programador no es la estrella?                                                                    |
# 1520 | Intel HD Graphic [Urgente]                                                                                    |
# 1367 | Reproducir vídeo con mplayer utilizando la GPU y vdpau para decodificar                                       |
# 1368 | Configuración manual de una conexión de red en Debian (con iproute2)                                          |
# 1369 | Escándalo DELL: Simplemente NO COMPRES DELL.                                                                  |
# 1370 | Repositorio de paquetes Debian «serio básico» y cómo usarlo                                                   |
# 1371 | Procrastinación y el «mal de la computadora»                                                                  |
# 1383 | GNU Emacs: The kill ring                                                                                      |
# 1380 | FoxG20                                                                                                        |
# 1384 | Crear una imagen Emdebian para tu FriendlyARM                                                                 |
# 1385 | Posts para INGSOFT                                                                                            |
# 1386 | Transformar un servidor fisico linux en servidor virtual                                                      |
# 1387 | INGSOFT: «Programación insolidaria»                                                                           |
# 1388 | INGSOFT: Keep It Simple, Stupid (KISS)                                                                        |
# 1390 | Python para aprender a programar                                                                              |
# 1391 | Python Advanced String Formatting                                                                             |
# 1392 | Microsoft patenta el apagado del sistema operativo                                                            |
# 1393 | Bilbliografía sobre métodos ágiles                                                                            |
# 1394 | GNU Emacs: El cliente de Twitter definitivo                                                                   |
# 1395 | X.org con el stylus de la tablet HP Compaq TC1100 en Debian                                                   |
# 1397 | Quinto aniversario                                                                                            |
# 1396 | Trucos útiles para la TabletPC HP Compaq TC1100                                                               |
# 1398 | El programa no ejecuta el archivo de video                                                                    |
# 1399 | Recuperar iconos perdidos en GNOME                                                                            |
# 1400 | Bacula con sqlite para hacer backup a disco                                                                   |
# 1401 | Empezando con mercurial                                                                                       |
# 1406 | Mercurial: hacer un hook para prohibir ficheros «incorrectos»                                                 |
# 1403 | IV Concurso Universitario de Software Libre de Castilla La Mancha                                             |
# 1405 | Imagen OPIE para tu FriendlyARM                                                                               |
# 1407 | El juego – HexGlass                                                                                           |
# 1408 | Audio a través de HDMI en un Zotac HD-ID11                                                                    |
# 1409 | Como aprovechar la RAM al máximo                                                                              |
# 1410 | arco-devel, el paquete                                                                                        |
# 1411 | dbus + Python                                                                                                 |
# 1412 | Software libre y recetas de cocina                                                                            |
# 1413 | python-xlib: emulando el teclado                                                                              |
# 1414 | arco-devel: speedbar                                                                                          |
# 1416 | Blender -  Efecto de Profundidad de Campo                                                                     |
# 1417 | Blender - Efecto de  Resplandor (Glow)                                                                        |
# 1418 | Alitas de muerte (a.k.a. alitas al horno)                                                                     |
# 1419 | Creada la página réplica en español de AUCTeX para GNU Emacs                                                  |
# 1420 | Página web réplica en español de EMMS                                                                         |
# 1421 | Visita guiada a Emacs (Réplica en castellano)                                                                 |
# 1422 | Alpine, consulta tu cuenta de correo Gmail desde la consola en modo texto                                     |
# 1423 | Introducción a la programación en Emacs Lisp, de Chassell                                                     |
# 1424 | wii-mote: ese extraño mando a distancia                                                                       |
# 1425 | Control de acceso con PAM                                                                                     |
# 1426 | Implementación de cifrado RC4 en awk                                                                          |
# 1427 | Page Speed                                                                                                    |
# 1428 | Introducción a la programación en Emacs Lisp, de Chassell                                                     |
# 1429 | hook subversion para integración con Hudson                                                                   |
# 1430 | Manual de AUCTeX para GNU Emacs                                                                               |
# 1431 | Jarabe de limón con miel                                                                                      |
# 1432 | Blender - Herramientas de Selección                                                                           |
# 1433 | arco-devel: zoom para GNU Emacs                                                                               |
# 1434 | Curso de «Introducción a GNU/Linux» en la ESI de Ciudad Real                                                  |
# 1435 | GNU Emacs: Editar archivos remotos                                                                            |
# 1436 | Archivos nuevos con el mismo grupo que el directorio padre                                                    |
# 1438 | Kit de desarrollo libre para PS3                                                                              |
# 1437 | arco-devel: auto-insert                                                                                       |
# 1439 | Emulador remoto para Android                                                                                  |
# 1440 | ¿Cuántas pedimos?                                                                                             |
# 1441 | Planificación manual de CPU's con taskset                                                                     |
# 1442 | Formatos simples: XML, Yaml, Json, Properties e INI's                                                         |
# 1443 | accept: un decorador para type-checking versátil en Python                                                    |
# 1444 | Tomates Piratas                                                                                               |
# 1446 | Nace el dominio de primer nivel .42                                                                           |
# 1447 | Kōans                                                                                                         |
# 1448 | Si los ingenieros de tu empresa son unos inútiles: contrata buenos abogados                                   |
# 1449 | Donald Knuth galardonado con el «Premio Fronteras» de la Fundación BBVA                                       |
# 1450 | Combinaciones Emacs                                                                                           |
# 1451 | Creando ejecutables válidos para cualquier PSP... ¡como Sony!                                                 |
# 1452 | Actualizado el Manual de GNU Emacs a 22.2                                                                     |
# 1453 | «Estamos hartos de escribir mierda»                                                                           |
# 1454 | Redmine PAM authentication plugin                                                                             |
# 1485 | Integración Continua de aplicaciones Python con Hudson/Jenkins                                                |
# 1456 | Cambiar contraseña en partición cifrada                                                                       |
# 1457 | Se acabó el IPv4                                                                                              |
# 1458 | Handler de SFTP para firefox en GNOME                                                                         |
# 1459 | Hook Mercurial para integración con Hudson                                                                    |
# 1460 | Tele-enseñanza en terminales                                                                                  |
# 1473 | Dependency injection and mocking classes using C++ and google-mock library                                    |
# 1474 | Dobles de prueba                                                                                              |
# 1475 | Campaña para la candidatura de la Comunidad del Software Libre a los Premios Príncipe de Asturias             |
# 1476 | Compilación cruzada de IceServices para arquitecturas ARM                                                     |
# 1477 | Open letter to hardware manufacturers                                                                         |
# 1478 | Agilismo = dejar de hacer el «gili»                                                                           |
# 1481 | Un pequeño script para tener un Jukebox de Modarchive.org                                                     |
# 1505 | Principios FIRST                                                                                              |
# 1484 | Fotografía final con R.Stallman                                                                               |
# 1486 | Entrevista a Richard M. Stallman en Baquía TV                                                                 |
# 1487 | arco-devel: toggle-split                                                                                      |
# 1488 | GNU Emacs: el-get, un apt-get para Emacs                                                                      |
# 1489 | The poor's man "dropbox"-thing                                                                                |
# 1490 | Antiprogramación                                                                                              |
# 1491 | FUSE y python: crea tu propio sistema de ficheros fácilmente                                                  |
# 1493 | Atajos en bash                                                                                                |
# 1494 | Fase Final IV edición Concurso Univ. de Software Libre de CLM                                                 |
# 1495 | LaTeX: Ayuda «en línea» en GNU Emacs                                                                          |
# 1496 | Fotos de las Jornadas de Software Libre                                                                       |
# 1497 | Una de listos                                                                                                 |
# 1498 | Ayuda                                                                                                         |
# 1499 | Recomendacion acerca de "Celulares"(Acento pendeeeeeejo XD)                                                   |
# 1500 | Atributos con tipado estático en Python (usando un descriptor)                                                |
# 1501 | 1ª Semana de Obras Libres del 13 al 19 de mayo                                                                |
# 1508 | Liberado el código de Adventure Game Studio (AGS)                                                             |
# 1509 | GNU Emacs: My Emacs Python environment                                                                        |
# 1510 | Install Party y Videoforum sobre software libre en Daimiel - 17 de mayo                                       |
# 1511 | Vídeos de las Jornadas de Software Libre de Ciudad Real - 15 al 18 de marzo de 2011                           |
# 1512 | Pruebas unitarias C con el plugin CxxTest de Atheist                                                          |
# 1513 | Pruebas web con selenium y Atheist                                                                            |
# 1532 | Libro de Python                                                                                               |
# 1514 | Licencias de Windows y MacOS X                                                                                |
# 1515 | Clase LaTeX para escribir el PFC                                                                              |
# 1516 | Python en Android                                                                                             |
# 1517 | La arquitectura de aplicaciones software                                                                      |
# 1518 | Personalizar gdm3                                                                                             |
# 1519 | Proyecto ¿Colaborais?                                                                                         |
# 1521 | GNU Emacs: Tablas fáciles (también en HTML y LaTeX)                                                           |
# 1522 | Comprar billete de tren (Renfe) eligiendo asiento con Software Libre                                          |
# 1524 | Python y GTK3                                                                                                 |
# 1525 | Programadores de poca fe                                                                                      |
# 1526 | La forma más sencilla de usar repositorios git es... mercurial                                                |
# 1527 | Apple Wireless Keyboard con Debian                                                                            |
# 1528 | Pequeño FAQ de Mailman                                                                                        |
# 1529 | Nombres de teclas en python                                                                                   |
# 1530 | $GA€, canon y presunción de culpabilidad                                                                      |
# 1531 | Cómo usar TOR en Debian                                                                                       |
# 1534 | Ejecutando un mismo comando en varias máquinas (con fabric)                                                   |
# 1535 | La Historia de OpenGL vs Direct3D                                                                             |
# 1537 | ¿Y si contrataran a los conductores igual que a los programadores?                                            |
# 1538 | Referencia rápida de LVM                                                                                      |
# 1540 | GNU Emacs: emacs --daemon                                                                                     |
# 1541 | stdeb, o cómo crear paquetes debian de módulos Python como churros                                            |
# 1542 | GNU Emacs: Configurar indentación                                                                             |
# 1544 | Una curiosidad que me pasó                                                                                    |
# 1546 | 9 reglas para una mejor orientación a objetos                                                                 |
# 1548 | Cambio en la configuración de sudo                                                                            |
# 1549 | eduroam en Android con certificado usando un QR code                                                          |
# 1550 | XPWeek: mis conclusiones                                                                                      |
# 1551 | Steve Jobs & sus iSubnormales diciendo que fué un genio.                                                      |
# 1552 | Abierta Inscripción VI Edición Concurso Universitario de Software Libre                                       |
# 1553 | Abierta Inscripción al VI Concurso Universitario de Software Libre                                            |
# 1555 | Filtro de contenidos.                                                                                         |
# 1556 | iOS vs Android: el coste social de la eficiencia (o el coste técnico de la libertad)                          |
# 1557 | Configuración de thunderbird/icedove para el correo de la UCLM                                                |
# 1558 | "Reconciliación" Android y Linux                                                                              |
# 1559 | WM8650                                                                                                        |
# 1561 | Ver eventos deportivos usando Sopcast y XBMC                                                                  |
# 1562 | Acelerar velocidad del Emulador de Android                                                                    |
# 1563 | Mojo picón                                                                                                    |
# 1564 | Espaguetti con brócoli                                                                                        |
# 1565 | Pimientos rellenos                                                                                            |
# 1566 | 97 Things Every Programmer Should Know                                                                        |
# 1567 | GNU Emacs 24: How to install on Debian/Ubuntu                                                                 |
# 1568 | Pasta con pollo                                                                                               |
# 1569 | Instalar Debian en Asus ZenBook UX31E                                                                         |
# 1570 | Separación silábica en LibreOffice                                                                            |
# 1571 | Linux Kernel Hacking. Módulos I2C para tu núcleo                                                              |
# 1572 | Consulta sobre los "Raspberry"                                                                                |
# 1573 | Consulta sobre los "Raspberry"                                                                                |
# 1574 | GNU Emacs: Pestañas realmente útiles (cambiando con alt-<num>)                                                |
# 1578 | Configurar las impresoras de la ESI en tu Debian GNU/Linux                                                    |
# 1686 | GHDL + VHPIDIRECT o como crear, compilar y ejecutar un programa VHDL con llamadas a código C                  |
# 1687 | Distribuyendo programas Python en el PyPI (Python Package Index)                                              |
# 1688 |  Asyncronous spy assertions with python-doublex                                                               |
# 1689 | Architectural aspects which TDD can not help                                                                  |
# 1690 | Intentando una instalación decente de Debian en el ASUS UX32VD                                                |
# 1691 | Inslación de Debian en un ASUS UX32V con W8 preinstalado                                                      |
# 1692 | Desactivar traducciones de índices de repositorios Debian                                                     |
# 1693 | debian/control                                                                                                |
# 1694 | Virtual machine unattended Debian installations with libvirt and d-i preseeding                               |
# 1695 | Creating a virtual grid with libvirt + debian preseeds + puppet + IceGrid                                     |
# 1696 | Configurar apt para que no descargue traducciones                                                             |
# 1697 | Altavoces bluetooth en GNOME                                                                                  |
# 1698 | Debian GNU/Linux Install Party V.7                                                                            |
# 1699 | Android SDK en Debian 64 bits                                                                                 |
# 1700 | Android testing                                                                                               |
# 1701 | Instalar un módulo Python en un virtualenv                                                                    |
# 1702 | Soporte mejorado para el ASUS UX32VD                                                                          |
# 1703 | Adios Google Reader, Hola Tiny Tiny RSS                                                                       |
# 1704 | emacs-pills: compilation feedback with colors                                                                 |
# 1705 | Fallo de pdflatex en debian sid                                                                               |


      skip = []

      db[QUERY].each do |post|
        # Get required fields and construct Jekyll compatible name
        node_id = post[:nid]

        if skip.include?(node_id)
          next
        end

        title = post[:title]
        content = post[:body]
        created = post[:created]
        time = Time.at(created)
        is_published = post[:status] == 1
        dir = is_published ? "_posts" : "_drafts"
        slug = title.strip.downcase.gsub(/(&|&amp;)/, ' and ').gsub(/[\s\.\/\\]/, '-').gsub(/[^\w-]/, '').gsub(/[-_]{2,}/, '-').gsub(/^[-_]/, '').gsub(/[-_]$/, '')
        name = time.strftime("%Y-%m-%d-") + slug + '.md'

        # Get the relevant fields as a hash, delete empty fields and convert
        # to YAML for the header
        data = {
           'layout' => 'post',
           'title' => title.to_s,
           'created' => created,
         }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        # Write out the data and content to file
        File.open("#{dir}/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end

        # Make a file to redirect from the old Drupal URL
        if is_published
          aliases = db["SELECT dst FROM #{prefix}url_alias WHERE src = ?", "node/#{node_id}"].all

          aliases.push(:dst => "node/#{node_id}")

          aliases.each do |url_alias|
            FileUtils.mkdir_p url_alias[:dst]
            File.open("#{url_alias[:dst]}/index.md", "w") do |f|
              f.puts "---"
              f.puts "layout: refresh"
              f.puts "refresh_to_post_id: /#{time.strftime("%Y/%m/%d/") + slug}"
              f.puts "---"
            end
          end
        end
      end

      # TODO: Make dirs & files for nodes of type 'page'
        # Make refresh pages for these as well

      # TODO: Make refresh dirs & files according to entries in url_alias table
    end
  end
end
