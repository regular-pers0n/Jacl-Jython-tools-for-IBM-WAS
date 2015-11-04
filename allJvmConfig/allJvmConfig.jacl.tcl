#Lang: jacl

# allJvmConfig.jacl v1.0.21
# Copyleft - 2013  Javier Dominguez Gomez
# Written by Javier Dominguez Gomez <jdg@member.fsf.org>
# GnuPG Key: 6ECD1616
# Madrid, Spain
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Info:		This Tcl program creates a Replication Domain that the session
#		manager uses for replication of the dynamic cache service, and
#		the stateful session bean failover components.
#
# Usage:	./allJvmConfig.sh

set outputDir [lindex $argv 0]
set listaJVMs [lindex $argv 1]
set cells [$AdminConfig list Cell]

foreach celda_id $cells {
	set celda_name [lindex [split $celda_id (] 0]
	set hostname [info hostname]
	set nodo "${hostname}_nodo"
	
	proc execJvm {} {
		global AdminConfig server server_id sessionManager_id webContainer_id JVM_classpath JVM_bootClasspath JVM_verboseGarbageCollection JVM_iniHeap JVM_maxHeap JVM_debugArgs JVM_genArgs JVM_systemProperties_sort cookies_EnableCookies cookie_maxInMemorySessionCount cookie_allowOverflow cookie_invalidationTimeout cookies_EnableSecurityIntegration cookie_name cookie_path cookie_secure threadpool_list_sort outputDir
		set jvm_dir "$outputDir/JVMs"
		if { [file exists $jvm_dir] != "1" } {file mkdir $jvm_dir}
		set jvm_out_log $jvm_dir/$server.log
		set OUTPUT_jvm [open $jvm_out_log w+]
		puts ""
		puts " ===================="
		puts " $server"
		puts " ===================="
		puts ""
		puts " \[Propiedades de JVM\]"
		puts ""
		puts " Classpath:\t\t$JVM_classpath"
		puts " Booth classpath:\t$JVM_bootClasspath"
		puts " Basura Verb.:\t\t$JVM_verboseGarbageCollection"
		puts " Mem. inicial:\t\t$JVM_iniHeap"
		puts " Mem. maxima:\t\t$JVM_maxHeap"
		puts " Args. debug:\t\t$JVM_debugArgs"
		puts " Args. genericos:\t$JVM_genArgs"
		puts " Prop. Person:"
		puts $OUTPUT_jvm " ===================="
		puts $OUTPUT_jvm " $server"
		puts $OUTPUT_jvm " ===================="
		puts $OUTPUT_jvm ""
		puts $OUTPUT_jvm " \[Propiedades de JVM\]"
		puts $OUTPUT_jvm ""
		puts $OUTPUT_jvm " Classpath:\t\t$JVM_classpath"
		puts $OUTPUT_jvm " Booth classpath:\t$JVM_bootClasspath"
		puts $OUTPUT_jvm " Basura Verb.:\t\t$JVM_verboseGarbageCollection"
		puts $OUTPUT_jvm " Mem. inicial:\t\t$JVM_iniHeap"
		puts $OUTPUT_jvm " Mem. maxima:\t\t$JVM_maxHeap"
		puts $OUTPUT_jvm " Args. debug:\t\t$JVM_debugArgs"
		puts $OUTPUT_jvm " Args. genericos:\t$JVM_genArgs"
		puts $OUTPUT_jvm " Prop. Person:"
		foreach JVM_PropertieId $JVM_systemProperties_sort {
			# La variable $allJvmCustomPropertieValues saca todas las propiedades personalizadas posibles de la JVM
			set allJvmCustomPropertieValues [$AdminConfig showall $JVM_PropertieId]
			
			# Propiedades personalizadas de la JVM
			set JVM_PropertieId_name [$AdminConfig showAttribute $JVM_PropertieId name]
			set JVM_PropertieId_value [$AdminConfig showAttribute $JVM_PropertieId value]
			puts "  - Nombre:\t\t$JVM_PropertieId_name"
			puts "  - Valor:\t\t$JVM_PropertieId_value"
			puts $OUTPUT_jvm "  - Nombre:\t\t$JVM_PropertieId_name"
			puts $OUTPUT_jvm "  - Valor:\t\t$JVM_PropertieId_value"
		}
		puts ""
		puts " \[Web Container - Session Management de JVM\]"
		puts ""
		puts " Cookies activas:\t$cookies_EnableCookies"
		puts " Sesiones Max.:\t\t$cookie_maxInMemorySessionCount"
		puts " Desbordamiento:\t$cookie_allowOverflow"
		puts " Timeout min.:\t\t$cookie_invalidationTimeout"
		puts " Seguridad:\t\t$cookies_EnableSecurityIntegration"
		puts " Nombre de cookie:\t$cookie_name"
		puts " Path:\t\t\t$cookie_path"
		puts " HTTPS Session:\t\t$cookie_secure"
		puts ""
		puts " \[Lista de Thread Pools\]"
		puts ""
		puts $OUTPUT_jvm ""
		puts $OUTPUT_jvm " \[Web Container - Session Management de JVM\]"
		puts $OUTPUT_jvm ""
		puts $OUTPUT_jvm " Cookies activas:\t$cookies_EnableCookies"
		puts $OUTPUT_jvm " Sesiones Max.:\t\t$cookie_maxInMemorySessionCount"
		puts $OUTPUT_jvm " Desbordamiento:\t$cookie_allowOverflow"
		puts $OUTPUT_jvm " Timeout min.:\t\t$cookie_invalidationTimeout"
		puts $OUTPUT_jvm " Seguridad:\t\t$cookies_EnableSecurityIntegration"
		puts $OUTPUT_jvm " Nombre de cookie:\t$cookie_name"
		puts $OUTPUT_jvm " Path:\t\t\t$cookie_path"
		puts $OUTPUT_jvm " HTTPS Session:\t\t$cookie_secure"
		puts $OUTPUT_jvm ""
		puts $OUTPUT_jvm " \[Lista de Thread Pools\]"
		puts $OUTPUT_jvm ""
		foreach threadPool_id $threadpool_list_sort {
			
			# La variable $allThreadPoolProperties saca todas las propiedades personalizadas posibles de los Thread Pools
			set allThreadPoolProperties [$AdminConfig showall $threadPool_id]
			
			set TP_id_name [$AdminConfig showAttribute $threadPool_id name]
			set TP_id_description [$AdminConfig showAttribute $threadPool_id description]
			set TP_id_minimumSize [$AdminConfig showAttribute $threadPool_id minimumSize]
			set TP_id_maximumSize [$AdminConfig showAttribute $threadPool_id maximumSize]
			set TP_id_inactivityTimeout [$AdminConfig showAttribute $threadPool_id inactivityTimeout]
			set TP_id_isGrowable [$AdminConfig showAttribute $threadPool_id isGrowable]
			set TP_id_customProperties [$AdminConfig showAttribute $threadPool_id customProperties]
			set TP_id_customProperties_sort [lsort $TP_id_customProperties]
			
			if {[regexp "Default" $TP_id_name] || [regexp "ORB.thread.pool" $TP_id_name] || [regexp "SIBFAPInboundThreadPool" $TP_id_name] || [regexp "SIBFAPThreadPool" $TP_id_name] || [regexp "TCPChannel.DCS" $TP_id_name] || [regexp "WebContainer" $TP_id_name] || [regexp "server.startup" $TP_id_name]} {
				puts " Nombre:\t\t$TP_id_name"
				puts $OUTPUT_jvm " Nombre:\t\t$TP_id_name"
				if { $TP_id_description=="" } {
					puts " Descripcion:\t\tNo tiene"
					puts $OUTPUT_jvm " Descripción:\t\tNo tiene"
				} else {
					puts " Descripcion:\t\t$TP_id_description"
					puts $OUTPUT_jvm " Descripción:\t\t$TP_id_description"
				}
				puts " Mem. minima:\t\t$TP_id_minimumSize"
				puts " Mem. maxima:\t\t$TP_id_maximumSize"
				puts " Timeout inactividad:\t$TP_id_inactivityTimeout"
				puts " Desbordamiento:\t$TP_id_isGrowable"
				puts $OUTPUT_jvm " Mem. minima:\t\t$TP_id_minimumSize"
				puts $OUTPUT_jvm " Mem. maxima:\t\t$TP_id_maximumSize"
				puts $OUTPUT_jvm " Timeout inactividad:\t$TP_id_inactivityTimeout"
				puts $OUTPUT_jvm " Desbordamiento:\t$TP_id_isGrowable"
				if { $TP_id_customProperties=="\{\}" } {
					puts " Propiedades pers.:\tNo tiene"
					puts ""
					puts $OUTPUT_jvm " Propiedades pers.:\tNo tiene"
					puts $OUTPUT_jvm ""
				} else {
					puts " Propiedades pers.:"
					puts $OUTPUT_jvm " Propiedades pers.:"
					foreach customPropertie_id $TP_id_customProperties_sort {
						foreach customPropertie $customPropertie_id {
							# La variable $allCustomPropertieValues saca todas las propiedades posibles de una custom propertie de un Thread Pool
							set allCustomPropertieValues [$AdminConfig showall $customPropertie]
							
							set TP_cp_name [$AdminConfig showAttribute $customPropertie name]
							set TP_cp_value [$AdminConfig showAttribute $customPropertie value]
							set TP_cp_description [$AdminConfig showAttribute $customPropertie description]
							
							puts "  - Nombre:\t$TP_cp_name"
							puts "  - Valor:\t$TP_cp_value"
							puts $OUTPUT_jvm "  - Nombre:\t$TP_cp_name"
							puts $OUTPUT_jvm "  - Valor:\t$TP_cp_value"
							if { $TP_cp_description=="" } {
								puts "  - Descripcion:\tNo tiene"
								puts $OUTPUT_jvm "  - Descripción:\tNo tiene"
							} else {
								puts "  - Descripcion:\t$TP_cp_description"
								puts $OUTPUT_jvm "  - Descripción:\t$TP_cp_description"
							}
						}
					}
					
				}
			}
		}
		close $OUTPUT_jvm
	}
	
	set listaJVMsOpen [open $listaJVMs r]
	set listaJVMsRead [read $listaJVMsOpen]
	set jvm [split $listaJVMsRead "\n"]
	
	foreach server $jvm {
		set listaServersId [$AdminConfig getid /Node:$nodo/Server:/]
		if {[regexp "$server" $listaServersId]} {
			set server_id [$AdminConfig getid /Cell:$celda_name/Node:$nodo/Server:$server/]
			set sessionManager_id [$AdminConfig list SessionManager $server_id]
			set webContainer_id [$AdminConfig list WebContainer $server_id]
			
			########################################################################
			# INICIO: SECCION JAVA VIRTUAL MACHINE
			########################################################################
			
			# La variable $jvm la defino solo por si quiero aplicar algo a esta JVM con un "$AdminConfig modify $jvm bla bla bla..."
			set jvm [$AdminConfig list JavaVirtualMachine $server_id]
			
			set JVM_classpath [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName classpath}]]
			set JVM_bootClasspath [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName bootClasspath}]]
			set JVM_verboseGarbageCollection [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName verboseModeGarbageCollection}]]
			set JVM_iniHeap [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName initialHeapSize}]]
			set JVM_maxHeap [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName maximumHeapSize}]]
			set JVM_debugArgs [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName debugArgs}]]
			set JVM_genArgs [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName genericJvmArguments}]]
			
			########################################################################
			# INICIO: SECCION CUSTOM PROPERTIES DE JVM
			########################################################################
			
			set JVM_systemProperties [$AdminTask showJVMProperties [subst {-serverName $server -nodeName $nodo -propertyName systemProperties}]]
			set JVM_systemProperties_sort [lsort $JVM_systemProperties]
			
			########################################################################
			# FIN: SECCION CUSTOM PROPERTIES DE JVM
			########################################################################
			
			########################################################################
			# INICIO: SECCION WEB CONTAINER - SESSION MANAGEMENT DE JVM
			########################################################################
			
			# La variable $allWebcontainerProperties saca todas las propiedades posibles del Web Container de la JVM
			set allWebcontainerProperties [$AdminConfig showall $sessionManager_id]
			
			set cookies_EnableCookies [$AdminConfig showAttribute $sessionManager_id enableCookies]
			set cookies_EnableSecurityIntegration [$AdminConfig showAttribute $sessionManager_id enableSecurityIntegration]
			
			set cookies_tuningParams [$AdminConfig showAttribute $sessionManager_id tuningParams]
			set cookie_allowOverflow [$AdminConfig showAttribute $cookies_tuningParams allowOverflow]
			set cookie_maxInMemorySessionCount [$AdminConfig showAttribute $cookies_tuningParams maxInMemorySessionCount]
			set cookie_invalidationTimeout [$AdminConfig showAttribute $cookies_tuningParams invalidationTimeout]
			
			# Propiedades de la cookie, si esta estuviera activa
			set cookiesProperties [$AdminConfig showAttribute $sessionManager_id defaultCookieSettings]
			set cookie_name [$AdminConfig showAttribute $cookiesProperties name]
			set cookie_path [$AdminConfig showAttribute $cookiesProperties path]
			set cookie_secure [$AdminConfig showAttribute $cookiesProperties secure]
			
			########################################################################
			# FIN: SECCION WEB CONTAINER - SESSION MANAGEMENT DE JVM
			########################################################################
			
			########################################################################
			# INICIO: SECCION CONFIGURACION DE THREAD POOLS
			########################################################################
			
			# La variable $threadpool_list es un listado con todos los Trhread Pools de la JVM.
			set threadpool_list [$AdminConfig list ThreadPool $server_id]
			set threadpool_list_sort [lsort $threadpool_list]
			
			########################################################################
			# FIN: SECCION CONFIGURACION DE THREAD POOLS
			########################################################################
			
			########################################################################
			# FIN: SECCION JAVA VIRTUAL MACHINE
			########################################################################
			
			execJvm
		} else {
			puts "\n\n #####################################################################################"
			puts "  El server \"$server\" no existe en el nodo \"$nodo\".\n  Revisa el archivo \"$listaJVMs\"."
			puts " #####################################################################################\n\n"
		}
	}
	close $listaJVMsOpen
	
	########################################################################
	# INICIO: SECCION LISTADO Y CONFIGURACION DE JDBC PROVIDERS
	########################################################################
	
	puts " \[Lista de JDBC Providers\]"
	puts ""
	set jdbcProviders [$AdminConfig list JDBCProvider $celda_id]
	set jdbcProviders_sort [lsort $jdbcProviders]
	foreach jdbcProvider_id $jdbcProviders_sort {
		if {![regexp "Derby JDBC Provider" $jdbcProvider_id]} {
			
			# La variable $allJdbcProvidersProperties saca todas las propiedades posibles de un JDBC Provider
			set allJdbcProvidersProperties [$AdminConfig showall $jdbcProvider_id]
			
			set jdbcProvider_ambito_split [lindex [split $jdbcProvider_id |] 0]
			set jdbcProvider_ambito [lindex [split $jdbcProvider_ambito_split (] 1]
			set jdbcProvider_name [$AdminConfig showAttribute $jdbcProvider_id name]
			set jdbcProvider_description [$AdminConfig showAttribute $jdbcProvider_id description]
			set jdbcProvider_classpath [$AdminConfig showAttribute $jdbcProvider_id classpath]
			set jdbcProvider_nativepath [$AdminConfig showAttribute $jdbcProvider_id nativepath]
			set jdbcProvider_implementationClassName [$AdminConfig showAttribute $jdbcProvider_id implementationClassName]
			set jdbcProvider_providerType [$AdminConfig showAttribute $jdbcProvider_id providerType]
			set jdbcProvider_xa [$AdminConfig showAttribute $jdbcProvider_id xa]
			set jdbcProvider_dir "$outputDir/JDBC_Providers"
			if { [file exists $jdbcProvider_dir] != "1" } {file mkdir $jdbcProvider_dir}
			set jdbcProviders_out_log $jdbcProvider_dir/$jdbcProvider_name.log
			set OUTPUT [open $jdbcProviders_out_log w+]
			
			puts " ============================================="
			puts "  JDBC Provider: $jdbcProvider_name"
			puts " ============================================="
			puts " Ambito:\t\t$jdbcProvider_ambito"
			puts " Descripcion:\t\t$jdbcProvider_description"
			puts " Classpath:\t\t$jdbcProvider_classpath"
			puts " Native library path:\t$jdbcProvider_nativepath"
			puts " Implementacion:\t$jdbcProvider_implementationClassName"
			puts " Tipo de provider:\t$jdbcProvider_providerType"
			puts " XA:\t\t\t$jdbcProvider_xa"
			puts ""
			puts $OUTPUT " ============================================="
			puts $OUTPUT "  JDBC Provider: $jdbcProvider_name"
			puts $OUTPUT " ============================================="
			puts $OUTPUT " Ambito:\t\t$jdbcProvider_ambito"
			puts $OUTPUT " Descripcion:\t\t$jdbcProvider_description"
			puts $OUTPUT " Classpath:\t\t$jdbcProvider_classpath"
			puts $OUTPUT " Native library path:\t$jdbcProvider_nativepath"
			puts $OUTPUT " Implementacion:\t$jdbcProvider_implementationClassName"
			puts $OUTPUT " Tipo de provider:\t$jdbcProvider_providerType"
			puts $OUTPUT " XA:\t\t\t$jdbcProvider_xa"
			close $OUTPUT
		}
	}
	
	########################################################################
	# FIN: SECCION LISTADO Y CONFIGURACION DE JDBC PROVIDERS
	########################################################################
	
	#######################################################################
	# INICIO: SECCION LISTADO Y CONFIGURACION DE POOLES
	#######################################################################
	puts " \[Lista de Pooles\]"
	puts ""
	set dataSources [$AdminConfig list DataSource $celda_id]
	set dataSources_sort [lsort $dataSources]
	
	foreach dataSource_id $dataSources_sort {
		
		# La variable $allDatasourceProperties saca todas las propiedades posibles de un Datasource
		set allDatasourceProperties [$AdminConfig showall $dataSource_id]
		
		# Variables básicas de cada Datasource
		set dataSource_ambito_split [lindex [split $dataSource_id |] 0]
		set dataSource_ambito [lindex [split $dataSource_ambito_split (] 1]
		set dataSource_provider_id [$AdminConfig showAttribute $dataSource_id provider]
		set dataSource_providerType [$AdminConfig showAttribute $dataSource_provider_id providerType]
		
		set dataSource_provider_name [$AdminConfig showAttribute $dataSource_provider_id name]
		set dataSource_name [$AdminConfig showAttribute $dataSource_id name]
		set dataSource_jndiName [$AdminConfig showAttribute $dataSource_id jndiName]
		set dataSource_description [$AdminConfig showAttribute $dataSource_id description]
		set dataSource_datasourceHelperClassname [$AdminConfig showAttribute $dataSource_id datasourceHelperClassname]
		set dataSource_authDataAlias [$AdminConfig showAttribute $dataSource_id authDataAlias]
		
		if {![regexp "DefaultEJBTimerDataSource" $dataSource_name] || ![regexp "Derby JDBC Provider" $dataSource_providerType] || ![regexp "OTiSDataSource" $dataSource_name]} {
			set connectionPool_list [$AdminConfig list ConnectionPool $dataSource_id]
			set connectionPool_list_sort [lsort $connectionPool_list]
			foreach connectionPool_id $connectionPool_list_sort {
				
				set connectionPool_connectionTimeout [$AdminConfig showAttribute $connectionPool_id connectionTimeout]
				set connectionPool_maxConnections [$AdminConfig showAttribute $connectionPool_id maxConnections]
				set connectionPool_minConnections [$AdminConfig showAttribute $connectionPool_id minConnections]
				set connectionPool_reapTime [$AdminConfig showAttribute $connectionPool_id reapTime]
				set connectionPool_unusedTimeout [$AdminConfig showAttribute $connectionPool_id unusedTimeout]
				set connectionPool_agedTimeout [$AdminConfig showAttribute $connectionPool_id agedTimeout]
				set connectionPool_purgePolicy [$AdminConfig showAttribute $connectionPool_id purgePolicy]
				set connectionPool_dir "$outputDir/Datasources"
				if { [file exists $connectionPool_dir] != "1" } {file mkdir $connectionPool_dir}
				set connectionPool_out_log $connectionPool_dir/$dataSource_name.log
				set OUTPUT [open $connectionPool_out_log w+]
				
				puts " ============================="
				puts "  Datasource: $dataSource_name"
				puts " ============================="
				puts " Ambito:\t\t$dataSource_ambito"
				puts " JNDI name:\t\t$dataSource_jndiName"
				puts " Provider:\t\t$dataSource_provider_name"
				puts " Descripcion:\t\t$dataSource_description"
				puts " Helper class:\t\t$dataSource_datasourceHelperClassname"
				puts " Alias de aut.:\t\t$dataSource_authDataAlias"
				puts " Tipo de Provider:\t$dataSource_providerType"
				puts " Propiedades:"
				puts $OUTPUT " ============================="
				puts $OUTPUT "  Datasource: $dataSource_name"
				puts $OUTPUT " ============================="
				puts $OUTPUT " Ambito:\t\t$dataSource_ambito"
				puts $OUTPUT " JNDI name:\t\t$dataSource_jndiName"
				puts $OUTPUT " Provider:\t\t$dataSource_provider_name"
				puts $OUTPUT " Descripcion:\t\t$dataSource_description"
				puts $OUTPUT " Helper class:\t\t$dataSource_datasourceHelperClassname"
				puts $OUTPUT " Alias de aut.:\t\t$dataSource_authDataAlias"
				puts $OUTPUT " Tipo de Provider:\t$dataSource_providerType"
				puts $OUTPUT " Propiedades:"
				set dataSource_J2EEResourceProperty [$AdminConfig list J2EEResourceProperty $dataSource_id]
				set dataSource_J2EEResourceProperty_sort [lsort $dataSource_J2EEResourceProperty]
				foreach J2EEResourceProperty $dataSource_J2EEResourceProperty_sort {
					
					# La variable $allJ2EEResourcePropertyProperties saca todas las custom properties posibles de un Datasource
					set allJ2EEResourcePropertyProperties [$AdminConfig showall $J2EEResourceProperty]
					
					set J2EEResourceProperty_name [$AdminConfig showAttribute $J2EEResourceProperty name]
					set J2EEResourceProperty_value [$AdminConfig showAttribute $J2EEResourceProperty value]
					
					puts " - Nombre:\t\t$J2EEResourceProperty_name"
					puts " - Valor:\t\t$J2EEResourceProperty_value"
					puts $OUTPUT " - Nombre:\t\t$J2EEResourceProperty_name"
					puts $OUTPUT " - Valor:\t\t$J2EEResourceProperty_value"
				}
				puts " Datos de \"Connection pool\":"
				puts " - Timeout:\t\t$connectionPool_connectionTimeout"
				puts " - Conexiones max.:\t$connectionPool_maxConnections"
				puts " - Conexiones min.:\t$connectionPool_minConnections"
				puts " - Reap time:\t\t$connectionPool_reapTime"
				puts " - Unused timeout:\t$connectionPool_unusedTimeout"
				puts " - Aged timeout:\t$connectionPool_agedTimeout"
				puts " - Purge policy:\t$connectionPool_purgePolicy"
				puts ""
				puts $OUTPUT " Datos de \"Connection pool\":"
				puts $OUTPUT " - Timeout:\t\t$connectionPool_connectionTimeout"
				puts $OUTPUT " - Conexiones max.:\t$connectionPool_maxConnections"
				puts $OUTPUT " - Conexiones min.:\t$connectionPool_minConnections"
				puts $OUTPUT " - Reap time:\t\t$connectionPool_reapTime"
				puts $OUTPUT " - Unused timeout:\t$connectionPool_unusedTimeout"
				puts $OUTPUT " - Aged timeout:\t$connectionPool_agedTimeout"
				puts $OUTPUT " - Purge policy:\t$connectionPool_purgePolicy"
				close $OUTPUT
				}
		}
	}
	
	#######################################################################
	# FIN: SECCION LISTADO Y CONFIGURACION DE POOLES
	#######################################################################
	
	########################################################################
	# INICIO: SECCION LISTADO Y CONFIGURACION DE QUEUE CONNECTION FACTORIES
	########################################################################
	puts " \[Lista de Queue Connection Factories\]"
	puts ""
	set JMS_MQQueueConnectionFactory [$AdminConfig list MQQueueConnectionFactory $celda_id]
	set JMS_MQQueueConnectionFactory_sort [lsort $JMS_MQQueueConnectionFactory]
	foreach queueConnectionFactory_id $JMS_MQQueueConnectionFactory_sort {
		
		# La variable $allConnectionFactoryProperties saca todas las propiedades posibles de una Connection Factory
		set allConnectionFactoryProperties [$AdminConfig showall $queueConnectionFactory_id]
		
		# Variables básicas de cada Queue Connection Factory
		set queueConnectionFactory_ambito_split [lindex [split $queueConnectionFactory_id |] 0]
		set queueConnectionFactory_ambito [lindex [split $queueConnectionFactory_ambito_split (] 1]
		set queueConnectionFactory_provider_id [$AdminConfig showAttribute $queueConnectionFactory_id provider]
		set queueConnectionFactory_provider_name [$AdminConfig showAttribute $queueConnectionFactory_provider_id name]
		set queueConnectionFactory_name [$AdminConfig showAttribute $queueConnectionFactory_id name]
		set queueConnectionFactory_jndiName [$AdminConfig showAttribute $queueConnectionFactory_id jndiName]
		set queueConnectionFactory_queueManager [$AdminConfig showAttribute $queueConnectionFactory_id queueManager]
		set queueConnectionFactory_channel [$AdminConfig showAttribute $queueConnectionFactory_id channel]
		set queueConnectionFactory_host [$AdminConfig showAttribute $queueConnectionFactory_id host]
		set queueConnectionFactory_port [$AdminConfig showAttribute $queueConnectionFactory_id port]
		set queueConnectionFactory_transportType [$AdminConfig showAttribute $queueConnectionFactory_id transportType]
		set queueConnectionFactory_dir "$outputDir/Queue Connection Factories"
		if { [file exists $queueConnectionFactory_dir] != "1" } {file mkdir $queueConnectionFactory_dir}
		set queueConnectionFactory_out_log $queueConnectionFactory_dir/$queueConnectionFactory_name.log
		set OUTPUT [open $queueConnectionFactory_out_log w+]
		
		# Variables del Connection Pool de cada Queue Connection Factory
		set queueConnectionFactory_connectionPool_id [$AdminConfig showAttribute $queueConnectionFactory_id connectionPool]
		set queueConnectionFactory_cp_connectionTimeout [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id connectionTimeout]
		set queueConnectionFactory_cp_maxConnections [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id maxConnections]
		set queueConnectionFactory_cp_minConnections [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id minConnections]
		set queueConnectionFactory_cp_reapTime [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id reapTime]
		set queueConnectionFactory_cp_unusedTimeout [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id unusedTimeout]
		set queueConnectionFactory_cp_agedTimeout [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id agedTimeout]
		set queueConnectionFactory_cp_purgePolicy [$AdminConfig showAttribute $queueConnectionFactory_connectionPool_id purgePolicy]
		
		# Variables del Session Pool de cada Queue Connection Factory
		set queueConnectionFactory_sessionPool_id [$AdminConfig showAttribute $queueConnectionFactory_id sessionPool]
		set queueConnectionFactory_sp_connectionTimeout [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id connectionTimeout]
		set queueConnectionFactory_sp_maxConnections [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id maxConnections]
		set queueConnectionFactory_sp_minConnections [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id minConnections]
		set queueConnectionFactory_sp_reapTime [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id reapTime]
		set queueConnectionFactory_sp_unusedTimeout [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id unusedTimeout]
		set queueConnectionFactory_sp_agedTimeout [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id agedTimeout]
		set queueConnectionFactory_sp_purgePolicy [$AdminConfig showAttribute $queueConnectionFactory_sessionPool_id purgePolicy]
		
		puts " ======================================================"
		puts "  Queue Connection Factory: $queueConnectionFactory_name"
		puts " ======================================================"
		puts " Ambito:\t\t$queueConnectionFactory_ambito"
		puts " Provider:\t\t$queueConnectionFactory_provider_name"
		puts " JNDI Name:\t\t$queueConnectionFactory_jndiName"
		puts " Queue manager:\t\t$queueConnectionFactory_queueManager"
		puts " Channel:\t\t$queueConnectionFactory_channel"
		puts " Host:\t\t\t$queueConnectionFactory_host"
		puts " Puerto:\t\t$queueConnectionFactory_port"
		puts " Transport type:\t$queueConnectionFactory_transportType"
		puts " Datos de \"Connection pool\":"
		puts " - Timeout:\t\t$queueConnectionFactory_cp_connectionTimeout"
		puts " - Conexiones max.:\t$queueConnectionFactory_cp_maxConnections"
		puts " - Conexiones min.:\t$queueConnectionFactory_cp_minConnections"
		puts " - Reap time:\t\t$queueConnectionFactory_cp_reapTime"
		puts " - Unused timeout:\t$queueConnectionFactory_cp_unusedTimeout"
		puts " - Aged timeout:\t$queueConnectionFactory_cp_agedTimeout"
		puts " - Purge policy:\t$queueConnectionFactory_cp_purgePolicy"
		puts " Datos de \"Session pool\":"
		puts " - Timeout:\t\t$queueConnectionFactory_sp_connectionTimeout"
		puts " - Conexiones max.:\t$queueConnectionFactory_sp_maxConnections"
		puts " - Conexiones min.:\t$queueConnectionFactory_sp_minConnections"
		puts " - Reap time:\t\t$queueConnectionFactory_sp_reapTime"
		puts " - Unused timeout:\t$queueConnectionFactory_sp_unusedTimeout"
		puts " - Aged timeout:\t$queueConnectionFactory_sp_agedTimeout"
		puts " - Purge policy:\t$queueConnectionFactory_sp_purgePolicy"
		puts ""
		puts $OUTPUT " ======================================================"
		puts $OUTPUT "  Queue Connection Factory: $queueConnectionFactory_name"
		puts $OUTPUT " ======================================================"
		puts $OUTPUT " Ambito:\t\t$queueConnectionFactory_ambito"
		puts $OUTPUT " Provider:\t\t$queueConnectionFactory_provider_name"
		puts $OUTPUT " JNDI Name:\t\t$queueConnectionFactory_jndiName"
		puts $OUTPUT " Queue manager:\t\t$queueConnectionFactory_queueManager"
		puts $OUTPUT " Channel:\t\t$queueConnectionFactory_channel"
		puts $OUTPUT " Host:\t\t\t$queueConnectionFactory_host"
		puts $OUTPUT " Puerto:\t\t$queueConnectionFactory_port"
		puts $OUTPUT " Transport type:\t$queueConnectionFactory_transportType"
		puts $OUTPUT " Datos de \"Connection pool\":"
		puts $OUTPUT " - Timeout:\t\t$queueConnectionFactory_cp_connectionTimeout"
		puts $OUTPUT " - Conexiones max.:\t$queueConnectionFactory_cp_maxConnections"
		puts $OUTPUT " - Conexiones min.:\t$queueConnectionFactory_cp_minConnections"
		puts $OUTPUT " - Reap time:\t\t$queueConnectionFactory_cp_reapTime"
		puts $OUTPUT " - Unused timeout:\t$queueConnectionFactory_cp_unusedTimeout"
		puts $OUTPUT " - Aged timeout:\t$queueConnectionFactory_cp_agedTimeout"
		puts $OUTPUT " - Purge policy:\t$queueConnectionFactory_cp_purgePolicy"
		puts $OUTPUT " Datos de \"Session pool\":"
		puts $OUTPUT " - Timeout:\t\t$queueConnectionFactory_sp_connectionTimeout"
		puts $OUTPUT " - Conexiones max.:\t$queueConnectionFactory_sp_maxConnections"
		puts $OUTPUT " - Conexiones min.:\t$queueConnectionFactory_sp_minConnections"
		puts $OUTPUT " - Reap time:\t\t$queueConnectionFactory_sp_reapTime"
		puts $OUTPUT " - Unused timeout:\t$queueConnectionFactory_sp_unusedTimeout"
		puts $OUTPUT " - Aged timeout:\t$queueConnectionFactory_sp_agedTimeout"
		puts $OUTPUT " - Purge policy:\t$queueConnectionFactory_sp_purgePolicy"
		close $OUTPUT
	}
	#########################################################################
	# FIN: SECCION LISTADO Y CONFIGURACION DE QUEUE CONNECTION FACTORIES
	#########################################################################
	
	########################################################################
	# INICIO: SECCION LISTADO Y CONFIGURACION DE COLAS MQ
	########################################################################
	puts " \[Lista de Colas MQ\]"
	puts ""
	set JMS_MQQueue [$AdminConfig list MQQueue $celda_id]
	set JMS_MQQueue_sort [lsort $JMS_MQQueue]
	foreach queue_id $JMS_MQQueue_sort {
	
		# La variable $allQueueProperties saca todas las propiedades posibles de una Cola MQ
		set allQueueProperties [$AdminConfig showall $queue_id]
		
		# Variables básicas de cada Cola MQ
		set queue_ambito_split [lindex [split $queue_id |] 0]
		set queue_ambito [lindex [split $queue_ambito_split (] 1]
		set queue_name [$AdminConfig showAttribute $queue_id name]
		set queue_provider_id [$AdminConfig showAttribute $queue_id provider]
		set queue_provider_name [$AdminConfig showAttribute $queue_provider_id name]
		set queue_jndiName [$AdminConfig showAttribute $queue_id jndiName]
		set queue_baseQueueName [$AdminConfig showAttribute $queue_id baseQueueName]
		set queue_targetClient [$AdminConfig showAttribute $queue_id targetClient]
		set queue_queueManagerHost [$AdminConfig showAttribute $queue_id queueManagerHost]
		set queue_queueManagerPort [$AdminConfig showAttribute $queue_id queueManagerPort]
		set queue_dir "$outputDir/Queues"
		if { [file exists $queue_dir] != "1" } {file mkdir $queue_dir}
		set queue_out_log $queue_dir/$queueConnectionFactory_name.log
		set OUTPUT [open $queue_out_log w+]
		
		puts " ========================================"
		puts "  Cola MQ: $queue_name"
		puts " ========================================"
		puts " Ambito:\t\t$queue_ambito"
		puts " Provider:\t\t$queue_provider_name"
		puts " JNDI Name:\t\t$queue_jndiName"
		puts " Base queue name:\t$queue_baseQueueName"
		puts " Target client:\t$queue_targetClient"
		puts " Host:\t\t\t$queue_queueManagerHost"
		puts " Puerto:\t\t$queue_queueManagerPort"
		puts ""
		puts $OUTPUT " ========================================"
		puts $OUTPUT "  Cola MQ: $queue_name"
		puts $OUTPUT " ========================================"
		puts $OUTPUT " Ambito:\t\t$queue_ambito"
		puts $OUTPUT " Provider:\t\t$queue_provider_name"
		puts $OUTPUT " JNDI Name:\t\t$queue_jndiName"
		puts $OUTPUT " Base queue name:\t$queue_baseQueueName"
		puts $OUTPUT " Target client:\t$queue_targetClient"
		puts $OUTPUT " Host:\t\t\t$queue_queueManagerHost"
		puts $OUTPUT " Puerto:\t\t$queue_queueManagerPort"
		close $OUTPUT
	}
	########################################################################
	# FIN: SECCION LISTADO Y CONFIGURACION DE COLAS MQ
	########################################################################
	
	########################################################################
	# INICIO: SECCION LISTADO Y CONFIGURACION DE URLs
	########################################################################
	puts " \[Lista de URLs\]"
	puts ""
	set URLs [$AdminConfig list URL $celda_id]
	set URLs_sort [lsort $URLs]
	foreach url_id $URLs_sort {
		
		# La variable $allURLproperties saca todas las propiedades posibles de una URL
		set allURLproperties [$AdminConfig showall $url_id]
	
		# Variables básicas de cada URL
		set url_ambito_split [lindex [split $url_id |] 0]
		set url_ambito [lindex [split $url_ambito_split (] 1]
		set url_provider_id [$AdminConfig showAttribute $url_id provider]
		set url_provider_name [$AdminConfig showAttribute $url_provider_id name]
		set url_name [$AdminConfig showAttribute $url_id name]
		set url_jndiName [$AdminConfig showAttribute $url_id jndiName]
		set url_spec [$AdminConfig showAttribute $url_id spec]
		set url_dir "$outputDir/URLs"
		if { [file exists $url_dir] != "1" } {file mkdir $url_dir}
		set url_out_log $url_dir/$url_name.log
		set OUTPUT [open $url_out_log w+]
		
		puts " ========================================"
		puts "  URL: $url_name"
		puts " ========================================"
		puts " Ambito:\t\t$url_ambito"
		puts " Provider:\t\t$url_provider_name"
		puts " JNDI Name:\t\t$url_jndiName"
		puts " Specification:\t\t$url_spec"
		puts ""
		puts $OUTPUT " ========================================"
		puts $OUTPUT "  URL: $url_name"
		puts $OUTPUT " ========================================"
		puts $OUTPUT " Ambito:\t\t$url_ambito"
		puts $OUTPUT " Provider:\t\t$url_provider_name"
		puts $OUTPUT " JNDI Name:\t\t$url_jndiName"
		puts $OUTPUT " Specification:\t\t$url_spec"
		close $OUTPUT
	}
	########################################################################
	# FIN: SECCION LISTADO Y CONFIGURACION DE URLs
	########################################################################
	puts ""
}
