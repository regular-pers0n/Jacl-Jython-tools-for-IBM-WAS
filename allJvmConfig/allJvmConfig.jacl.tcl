#Lang: jacl

# allJvmConfig.jacl v1.0.23
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
set jvmList [lindex $argv 1]
set hostname [info hostname]
set cells [$AdminConfig list Cell]

foreach cellId $cells {
	set cname [$AdminConfig showAttribute $cellId name]
	set nodes [$AdminConfig list Node $cellId]
	foreach nodeId $nodes {
		# $allNodeAttributes show all Node attributes
		set allNodeAttributes [$AdminConfig showall $nodeId]
		set nname [$AdminConfig showAttribute $nodeId name]
		set nhostname [$AdminConfig showAttribute $nodeId hostName]
		
		proc execJvm {jvm} {
			global AdminConfig AdminTask cname nname jvmName jvmId sessionManagerId webContainerId JVM_classpath JVM_bootClasspath JVM_verboseGarbageCollection JVM_iniHeap JVM_maxHeap JVM_debugArgs JVM_genArgs JVM_systemProperties_sort cookies_EnableCookies cookie_maxInMemorySessionCount cookie_allowOverflow cookie_invalidationTimeout cookies_EnableSecurityIntegration cookie_name cookie_path cookie_secure threadpool_list_sort outputDir
			if {[string length $jvm] > 0} {
        			foreach jvmName $jvm {
        				set listServersId [$AdminConfig getid /Node:$nname/Server:/]
        				if {[regexp "$jvmName" $listServersId]} {
        					set jvmId [$AdminConfig getid /Cell:$cname/Node:$nname/Server:$jvmName/]
        					set sessionManagerId [$AdminConfig list SessionManager $jvmId]
        					set webContainerId [$AdminConfig list WebContainer $jvmId]
        					
        					########################################################################
        					# START: JAVA VIRTUAL MACHINE SECTION
        					########################################################################
        					
        					set jvm [$AdminConfig list JavaVirtualMachine $jvmId]
        					
        					set JVM_classpath [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName classpath}]]
        					set JVM_bootClasspath [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName bootClasspath}]]
        					set JVM_verboseGarbageCollection [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName verboseModeGarbageCollection}]]
        					set JVM_iniHeap [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName initialHeapSize}]]
        					set JVM_maxHeap [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName maximumHeapSize}]]
        					set JVM_debugArgs [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName debugArgs}]]
        					set JVM_genArgs [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName genericJvmArguments}]]
        					
        					########################################################################
        					# START: JVM CUSTOM PROPERTIES SECTION
        					########################################################################
        					
        					set JVM_systemProperties [$AdminTask showJVMProperties [subst {-serverName $jvmName -nodeName $nname -propertyName systemProperties}]]
        					set JVM_systemProperties_sort [lsort $JVM_systemProperties]
        					
        					########################################################################
        					# END: JVM CUSTOM PROPERTIES SECTION
        					########################################################################
        					
        					########################################################################
        					# START: WEB CONTAINER SECTION - JVM SESSION MANAGEMENT
        					########################################################################
        					
        					# $allWebcontainerProperties show all Web Container properties from JVM
        					set allWebcontainerProperties [$AdminConfig showall $sessionManagerId]
        					
        					set cookies_EnableCookies [$AdminConfig showAttribute $sessionManagerId enableCookies]
        					set cookies_EnableSecurityIntegration [$AdminConfig showAttribute $sessionManagerId enableSecurityIntegration]
        					
        					set cookies_tuningParams [$AdminConfig showAttribute $sessionManagerId tuningParams]
        					set cookie_allowOverflow [$AdminConfig showAttribute $cookies_tuningParams allowOverflow]
        					set cookie_maxInMemorySessionCount [$AdminConfig showAttribute $cookies_tuningParams maxInMemorySessionCount]
        					set cookie_invalidationTimeout [$AdminConfig showAttribute $cookies_tuningParams invalidationTimeout]
        					
        					# Cookie properties, if where active
        					set cookiesProperties [$AdminConfig showAttribute $sessionManagerId defaultCookieSettings]
        					set cookie_name [$AdminConfig showAttribute $cookiesProperties name]
        					set cookie_path [$AdminConfig showAttribute $cookiesProperties path]
        					set cookie_secure [$AdminConfig showAttribute $cookiesProperties secure]
        					
        					########################################################################
        					# END: WEB CONTAINER SECTION - JVM SESSION MANAGEMENT
        					########################################################################
        					
        					########################################################################
        					# START: THREAD POOLS CONFIGURATION SECTION
        					########################################################################
        					
        					# $threadpool_list show all Trhread Pools list from JVM.
        					set threadpool_list [$AdminConfig list ThreadPool $jvmId]
        					set threadpool_list_sort [lsort $threadpool_list]
        					
        					########################################################################
        					# END: THREAD POOLS CONFIGURATION SECTION
        					########################################################################
        					
        					########################################################################
        					# END: JAVA VIRTUAL MACHINE SECTION
        					########################################################################
        					
        					set jvm_dir "$outputDir/JVMs"
        					if { [file exists $jvm_dir] != "1" } {file mkdir $jvm_dir}
        					set jvm_out_log $jvm_dir/$jvmName.log
        					set OUTPUT_jvm [open $jvm_out_log w+]
        					puts ""
        					puts " ===================="
        					puts " $jvmName"
        					puts " ===================="
        					puts ""
        					puts " \[JVM Properties\]"
        					puts ""
        					if { $JVM_classpath=="" } {
        						puts " Classpath:\t\tEmpty"
        					} else {
        						puts " Classpath:\t\t$JVM_classpath"
        					}
        					if { $JVM_bootClasspath=="" } {
        						puts " Booth classpath:\tEmpty"
        					} else {
        						puts " Booth classpath:\t$JVM_bootClasspath"
        					}
        					puts " Garbage col.:\t\t$JVM_verboseGarbageCollection"
        					puts " Init heap:\t\t$JVM_iniHeap"
        					puts " Max heap:\t\t$JVM_maxHeap"
        					puts " Debug args:\t\t$JVM_debugArgs"
        					puts " Gen. args:\t\t$JVM_genArgs"
        					puts " Custom prop.:"
        					puts $OUTPUT_jvm " ===================="
        					puts $OUTPUT_jvm " $jvmName"
        					puts $OUTPUT_jvm " ===================="
        					puts $OUTPUT_jvm ""
        					puts $OUTPUT_jvm " \[JVM properties\]"
        					puts $OUTPUT_jvm ""
        					if { $JVM_classpath=="" } {
        						puts $OUTPUT_jvm " Classpath:\t\tEmpty"
        					} else {
        						puts $OUTPUT_jvm " Classpath:\t\t$JVM_classpath"
        					}
        					if { $JVM_bootClasspath=="" } {
        						puts $OUTPUT_jvm " Booth classpath:\tEmpty"
        					} else {
        						puts $OUTPUT_jvm " Booth classpath:\t$JVM_bootClasspath"
        					}
        					puts $OUTPUT_jvm " Garbage col.:\t\t$JVM_verboseGarbageCollection"
        					puts $OUTPUT_jvm " Init heap:\t\t$JVM_iniHeap"
        					puts $OUTPUT_jvm " Max heap:\t\t$JVM_maxHeap"
        					puts $OUTPUT_jvm " Debug args:\t\t$JVM_debugArgs"
        					puts $OUTPUT_jvm " Gen. args:\t\t$JVM_genArgs"
        					puts $OUTPUT_jvm " Custom prop.:"
        					foreach JVM_PropertieId $JVM_systemProperties_sort {
        						# $allJvmCustomPropertieValues show all JVM custom properties
        						set allJvmCustomPropertieValues [$AdminConfig showall $JVM_PropertieId]
        						
        						# JVM custom properties
        						set JVM_PropertieId_name [$AdminConfig showAttribute $JVM_PropertieId name]
        						set JVM_PropertieId_value [$AdminConfig showAttribute $JVM_PropertieId value]
        						puts "  - Name:\t\t$JVM_PropertieId_name"
        						puts "  - Value:\t\t$JVM_PropertieId_value"
        						puts $OUTPUT_jvm "  - Name:\t\t$JVM_PropertieId_name"
        						puts $OUTPUT_jvm "  - Value:\t\t$JVM_PropertieId_value"
        					}
        					puts ""
        					puts " \[Web Container - Session Management from JVM\]"
        					puts ""
        					puts " Active cookies:\t$cookies_EnableCookies"
        					puts " Max sessions:\t\t$cookie_maxInMemorySessionCount"
        					puts " Is growable:\t\t$cookie_allowOverflow"
        					puts " Timeout min.:\t\t$cookie_invalidationTimeout"
        					puts " Security:\t\t$cookies_EnableSecurityIntegration"
        					puts " Cookie name:\t\t$cookie_name"
        					puts " Path:\t\t\t$cookie_path"
        					puts " HTTPS Session:\t\t$cookie_secure"
        					puts $OUTPUT_jvm ""
        					puts $OUTPUT_jvm " \[Web Container - Session Management from JVM\]"
        					puts $OUTPUT_jvm ""
        					puts $OUTPUT_jvm " Active cookies:\t$cookies_EnableCookies"
        					puts $OUTPUT_jvm " Max sessions:\t\t$cookie_maxInMemorySessionCount"
        					puts $OUTPUT_jvm " Is growable:\t\t$cookie_allowOverflow"
        					puts $OUTPUT_jvm " Timeout min.:\t\t$cookie_invalidationTimeout"
        					puts $OUTPUT_jvm " Security:\t\t$cookies_EnableSecurityIntegration"
        					puts $OUTPUT_jvm " Cookie name:\t\t$cookie_name"
        					puts $OUTPUT_jvm " Path:\t\t\t$cookie_path"
        					puts $OUTPUT_jvm " HTTPS Session:\t\t$cookie_secure"
        					puts ""
        					puts " \[Thread Pools list\]"
        					puts ""
        					puts $OUTPUT_jvm ""
        					puts $OUTPUT_jvm " \[Thread Pools list\]"
        					puts $OUTPUT_jvm ""
        					foreach threadPool_id $threadpool_list_sort {
        						
        						# $allThreadPoolProperties show all Thread Pools custom properties
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
        							puts " Name:\t\t\t$TP_id_name"
        							puts $OUTPUT_jvm " Name:\t\t\t$TP_id_name"
        							if { $TP_id_description=="" } {
        								puts " Description:\t\tEmpty"
        								puts $OUTPUT_jvm " Description:\t\tEmpty"
        							} else {
        								puts " Description:\t\t$TP_id_description"
        								puts $OUTPUT_jvm " Description:\t\t$TP_id_description"
        							}
        							puts " Min heap:\t\t$TP_id_minimumSize"
        							puts " Max heap:\t\t$TP_id_maximumSize"
        							puts " Inactivity timeout:\t$TP_id_inactivityTimeout"
        							puts " Is growable:\t\t$TP_id_isGrowable"
        							puts $OUTPUT_jvm " Min heap:\t\t$TP_id_minimumSize"
        							puts $OUTPUT_jvm " Max heap:\t\t$TP_id_maximumSize"
        							puts $OUTPUT_jvm " Inactivity timeout:\t$TP_id_inactivityTimeout"
        							puts $OUTPUT_jvm " Is growable:\t\t$TP_id_isGrowable"
        							if { $TP_id_customProperties=="\{\}" } {
        								puts " Custom properties:\tEmpty"
        								puts ""
        								puts $OUTPUT_jvm " Custom properties:\tEmpty"
        								puts $OUTPUT_jvm ""
        							} else {
        								puts " Custom properties:"
        								puts $OUTPUT_jvm " Custom properties:"
        								foreach customPropertie_id $TP_id_customProperties_sort {
        									foreach customPropertie $customPropertie_id {
        										# $allCustomPropertieValues show all custom propertie from a Thread Pool
        										set allCustomPropertieValues [$AdminConfig showall $customPropertie]
        										
        										set TP_cp_name [$AdminConfig showAttribute $customPropertie name]
        										set TP_cp_value [$AdminConfig showAttribute $customPropertie value]
        										set TP_cp_description [$AdminConfig showAttribute $customPropertie description]
        										
        										puts "  - Name:\t$TP_cp_name"
        										puts "  - Value:\t$TP_cp_value"
        										puts $OUTPUT_jvm "  - Name:\t$TP_cp_name"
        										puts $OUTPUT_jvm "  - Value:\t$TP_cp_value"
        										if { $TP_cp_description=="" } {
        											puts "  - Description:\tEmpty"
        											puts $OUTPUT_jvm "  - Description:\tEmpty"
        										} else {
        											puts "  - Description:\t$TP_cp_description"
        											puts $OUTPUT_jvm "  - Description:\t$TP_cp_description"
        										}
        									}
        								}
        								
        							}
        						}
        					}
        					close $OUTPUT_jvm
        				}
        			}
        		}
		}
		
		if { $::argc < 2 } {
			set servers [$AdminControl queryNames type=Server,cell=$cname,node=$nname,*]
			foreach jvmId $servers {
				set jvmName [$AdminControl getAttribute $jvmId name]
				set jvmType [$AdminControl getAttribute $jvmId processType]
				if {![regexp {(dmgr|nodeagent)} $jvmName]} {
					execJvm $jvmName
				}
			}
		} else {
			set jvmListOpen [open $jvmList r]
			set jvmListRead [read $jvmListOpen]
			set jvmName [split $jvmListRead "\n"]
			execJvm $jvmName
			close $jvmListOpen
		}
	}
	puts ""
}
