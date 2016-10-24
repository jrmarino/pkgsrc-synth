$NetBSD: patch-xdata_xsddefault.c,v 1.2 2016/02/07 21:52:06 bouyer Exp $

Fix build in SunOS.
64bit time_t workaround.

--- xdata/xsddefault.c.orig	2014-08-12 17:00:01.000000000 +0200
+++ xdata/xsddefault.c	2016-02-07 22:37:22.000000000 +0100
@@ -118,7 +118,7 @@
 	host *temp_host = NULL;
 	service *temp_service = NULL;
 	contact *temp_contact = NULL;
-	comment *temp_comment = NULL;
+	my_comment *temp_comment = NULL;
 	scheduled_downtime *temp_downtime = NULL;
 	time_t current_time;
 	int fd = 0;
@@ -177,9 +177,9 @@
 
 	/* write file info */
 	fprintf(fp, "info {\n");
-	fprintf(fp, "\tcreated=%lu\n", current_time);
+	fprintf(fp, "\tcreated=%lu\n", (unsigned long)current_time);
 	fprintf(fp, "\tversion=%s\n", PROGRAM_VERSION);
-	fprintf(fp, "\tlast_update_check=%lu\n", last_update_check);
+	fprintf(fp, "\tlast_update_check=%lu\n", (unsigned long)last_update_check);
 	fprintf(fp, "\tupdate_available=%d\n", update_available);
 	fprintf(fp, "\tlast_version=%s\n", (last_program_version == NULL) ? "" : last_program_version);
 	fprintf(fp, "\tnew_version=%s\n", (new_program_version == NULL) ? "" : new_program_version);
@@ -191,8 +191,8 @@
 	fprintf(fp, "\tmodified_service_attributes=%lu\n", modified_service_process_attributes);
 	fprintf(fp, "\tnagios_pid=%d\n", nagios_pid);
 	fprintf(fp, "\tdaemon_mode=%d\n", daemon_mode);
-	fprintf(fp, "\tprogram_start=%lu\n", program_start);
-	fprintf(fp, "\tlast_log_rotation=%lu\n", last_log_rotation);
+	fprintf(fp, "\tprogram_start=%lu\n", (unsigned long)program_start);
+	fprintf(fp, "\tlast_log_rotation=%lu\n", (unsigned long)last_log_rotation);
 	fprintf(fp, "\tenable_notifications=%d\n", enable_notifications);
 	fprintf(fp, "\tactive_service_checks_enabled=%d\n", execute_service_checks);
 	fprintf(fp, "\tpassive_service_checks_enabled=%d\n", accept_passive_service_checks);
@@ -255,19 +255,19 @@
 		fprintf(fp, "\tplugin_output=%s\n", (temp_host->plugin_output == NULL) ? "" : temp_host->plugin_output);
 		fprintf(fp, "\tlong_plugin_output=%s\n", (temp_host->long_plugin_output == NULL) ? "" : temp_host->long_plugin_output);
 		fprintf(fp, "\tperformance_data=%s\n", (temp_host->perf_data == NULL) ? "" : temp_host->perf_data);
-		fprintf(fp, "\tlast_check=%lu\n", temp_host->last_check);
-		fprintf(fp, "\tnext_check=%lu\n", temp_host->next_check);
+		fprintf(fp, "\tlast_check=%lu\n", (unsigned long)temp_host->last_check);
+		fprintf(fp, "\tnext_check=%lu\n", (unsigned long)temp_host->next_check);
 		fprintf(fp, "\tcheck_options=%d\n", temp_host->check_options);
 		fprintf(fp, "\tcurrent_attempt=%d\n", temp_host->current_attempt);
 		fprintf(fp, "\tmax_attempts=%d\n", temp_host->max_attempts);
 		fprintf(fp, "\tstate_type=%d\n", temp_host->state_type);
-		fprintf(fp, "\tlast_state_change=%lu\n", temp_host->last_state_change);
-		fprintf(fp, "\tlast_hard_state_change=%lu\n", temp_host->last_hard_state_change);
-		fprintf(fp, "\tlast_time_up=%lu\n", temp_host->last_time_up);
-		fprintf(fp, "\tlast_time_down=%lu\n", temp_host->last_time_down);
-		fprintf(fp, "\tlast_time_unreachable=%lu\n", temp_host->last_time_unreachable);
-		fprintf(fp, "\tlast_notification=%lu\n", temp_host->last_notification);
-		fprintf(fp, "\tnext_notification=%lu\n", temp_host->next_notification);
+		fprintf(fp, "\tlast_state_change=%lu\n", (unsigned long)temp_host->last_state_change);
+		fprintf(fp, "\tlast_hard_state_change=%lu\n", (unsigned long)temp_host->last_hard_state_change);
+		fprintf(fp, "\tlast_time_up=%lu\n", (unsigned long)temp_host->last_time_up);
+		fprintf(fp, "\tlast_time_down=%lu\n", (unsigned long)temp_host->last_time_down);
+		fprintf(fp, "\tlast_time_unreachable=%lu\n", (unsigned long)temp_host->last_time_unreachable);
+		fprintf(fp, "\tlast_notification=%lu\n", (unsigned long)temp_host->last_notification);
+		fprintf(fp, "\tnext_notification=%lu\n", (unsigned long)temp_host->next_notification);
 		fprintf(fp, "\tno_more_notifications=%d\n", temp_host->no_more_notifications);
 		fprintf(fp, "\tcurrent_notification_number=%d\n", temp_host->current_notification_number);
 		fprintf(fp, "\tcurrent_notification_id=%lu\n", temp_host->current_notification_id);
@@ -280,7 +280,7 @@
 		fprintf(fp, "\tflap_detection_enabled=%d\n", temp_host->flap_detection_enabled);
 		fprintf(fp, "\tprocess_performance_data=%d\n", temp_host->process_performance_data);
 		fprintf(fp, "\tobsess=%d\n", temp_host->obsess);
-		fprintf(fp, "\tlast_update=%lu\n", current_time);
+		fprintf(fp, "\tlast_update=%lu\n", (unsigned long)current_time);
 		fprintf(fp, "\tis_flapping=%d\n", temp_host->is_flapping);
 		fprintf(fp, "\tpercent_state_change=%.2f\n", temp_host->percent_state_change);
 		fprintf(fp, "\tscheduled_downtime_depth=%d\n", temp_host->scheduled_downtime_depth);
@@ -321,22 +321,22 @@
 		fprintf(fp, "\tcurrent_attempt=%d\n", temp_service->current_attempt);
 		fprintf(fp, "\tmax_attempts=%d\n", temp_service->max_attempts);
 		fprintf(fp, "\tstate_type=%d\n", temp_service->state_type);
-		fprintf(fp, "\tlast_state_change=%lu\n", temp_service->last_state_change);
-		fprintf(fp, "\tlast_hard_state_change=%lu\n", temp_service->last_hard_state_change);
-		fprintf(fp, "\tlast_time_ok=%lu\n", temp_service->last_time_ok);
-		fprintf(fp, "\tlast_time_warning=%lu\n", temp_service->last_time_warning);
-		fprintf(fp, "\tlast_time_unknown=%lu\n", temp_service->last_time_unknown);
-		fprintf(fp, "\tlast_time_critical=%lu\n", temp_service->last_time_critical);
+		fprintf(fp, "\tlast_state_change=%lu\n", (unsigned long)temp_service->last_state_change);
+		fprintf(fp, "\tlast_hard_state_change=%lu\n", (unsigned long)temp_service->last_hard_state_change);
+		fprintf(fp, "\tlast_time_ok=%lu\n", (unsigned long)temp_service->last_time_ok);
+		fprintf(fp, "\tlast_time_warning=%lu\n", (unsigned long)temp_service->last_time_warning);
+		fprintf(fp, "\tlast_time_unknown=%lu\n", (unsigned long)temp_service->last_time_unknown);
+		fprintf(fp, "\tlast_time_critical=%lu\n", (unsigned long)temp_service->last_time_critical);
 		fprintf(fp, "\tplugin_output=%s\n", (temp_service->plugin_output == NULL) ? "" : temp_service->plugin_output);
 		fprintf(fp, "\tlong_plugin_output=%s\n", (temp_service->long_plugin_output == NULL) ? "" : temp_service->long_plugin_output);
 		fprintf(fp, "\tperformance_data=%s\n", (temp_service->perf_data == NULL) ? "" : temp_service->perf_data);
-		fprintf(fp, "\tlast_check=%lu\n", temp_service->last_check);
-		fprintf(fp, "\tnext_check=%lu\n", temp_service->next_check);
+		fprintf(fp, "\tlast_check=%lu\n", (unsigned long)temp_service->last_check);
+		fprintf(fp, "\tnext_check=%lu\n", (unsigned long)temp_service->next_check);
 		fprintf(fp, "\tcheck_options=%d\n", temp_service->check_options);
 		fprintf(fp, "\tcurrent_notification_number=%d\n", temp_service->current_notification_number);
 		fprintf(fp, "\tcurrent_notification_id=%lu\n", temp_service->current_notification_id);
-		fprintf(fp, "\tlast_notification=%lu\n", temp_service->last_notification);
-		fprintf(fp, "\tnext_notification=%lu\n", temp_service->next_notification);
+		fprintf(fp, "\tlast_notification=%lu\n", (unsigned long)temp_service->last_notification);
+		fprintf(fp, "\tnext_notification=%lu\n", (unsigned long)temp_service->next_notification);
 		fprintf(fp, "\tno_more_notifications=%d\n", temp_service->no_more_notifications);
 		fprintf(fp, "\tnotifications_enabled=%d\n", temp_service->notifications_enabled);
 		fprintf(fp, "\tactive_checks_enabled=%d\n", temp_service->checks_enabled);
@@ -347,7 +347,7 @@
 		fprintf(fp, "\tflap_detection_enabled=%d\n", temp_service->flap_detection_enabled);
 		fprintf(fp, "\tprocess_performance_data=%d\n", temp_service->process_performance_data);
 		fprintf(fp, "\tobsess=%d\n", temp_service->obsess);
-		fprintf(fp, "\tlast_update=%lu\n", current_time);
+		fprintf(fp, "\tlast_update=%lu\n", (unsigned long)current_time);
 		fprintf(fp, "\tis_flapping=%d\n", temp_service->is_flapping);
 		fprintf(fp, "\tpercent_state_change=%.2f\n", temp_service->percent_state_change);
 		fprintf(fp, "\tscheduled_downtime_depth=%d\n", temp_service->scheduled_downtime_depth);
@@ -371,8 +371,8 @@
 		fprintf(fp, "\thost_notification_period=%s\n", (temp_contact->host_notification_period == NULL) ? "" : temp_contact->host_notification_period);
 		fprintf(fp, "\tservice_notification_period=%s\n", (temp_contact->service_notification_period == NULL) ? "" : temp_contact->service_notification_period);
 
-		fprintf(fp, "\tlast_host_notification=%lu\n", temp_contact->last_host_notification);
-		fprintf(fp, "\tlast_service_notification=%lu\n", temp_contact->last_service_notification);
+		fprintf(fp, "\tlast_host_notification=%lu\n", (unsigned long)temp_contact->last_host_notification);
+		fprintf(fp, "\tlast_service_notification=%lu\n", (unsigned long)temp_contact->last_service_notification);
 		fprintf(fp, "\thost_notifications_enabled=%d\n", temp_contact->host_notifications_enabled);
 		fprintf(fp, "\tservice_notifications_enabled=%d\n", temp_contact->service_notifications_enabled);
 		/* custom variables */
@@ -397,9 +397,9 @@
 		fprintf(fp, "\tcomment_id=%lu\n", temp_comment->comment_id);
 		fprintf(fp, "\tsource=%d\n", temp_comment->source);
 		fprintf(fp, "\tpersistent=%d\n", temp_comment->persistent);
-		fprintf(fp, "\tentry_time=%lu\n", temp_comment->entry_time);
+		fprintf(fp, "\tentry_time=%lu\n", (unsigned long)temp_comment->entry_time);
 		fprintf(fp, "\texpires=%d\n", temp_comment->expires);
-		fprintf(fp, "\texpire_time=%lu\n", temp_comment->expire_time);
+		fprintf(fp, "\texpire_time=%lu\n", (unsigned long)temp_comment->expire_time);
 		fprintf(fp, "\tauthor=%s\n", temp_comment->author);
 		fprintf(fp, "\tcomment_data=%s\n", temp_comment->comment_data);
 		fprintf(fp, "\t}\n\n");
@@ -417,10 +417,10 @@
 			fprintf(fp, "\tservice_description=%s\n", temp_downtime->service_description);
 		fprintf(fp, "\tdowntime_id=%lu\n", temp_downtime->downtime_id);
 		fprintf(fp, "\tcomment_id=%lu\n", temp_downtime->comment_id);
-		fprintf(fp, "\tentry_time=%lu\n", temp_downtime->entry_time);
-		fprintf(fp, "\tstart_time=%lu\n", temp_downtime->start_time);
-		fprintf(fp, "\tflex_downtime_start=%lu\n", temp_downtime->flex_downtime_start);
-		fprintf(fp, "\tend_time=%lu\n", temp_downtime->end_time);
+		fprintf(fp, "\tentry_time=%lu\n", (unsigned long)temp_downtime->entry_time);
+		fprintf(fp, "\tstart_time=%lu\n", (unsigned long)temp_downtime->start_time);
+		fprintf(fp, "\tflex_downtime_start=%lu\n", (unsigned long)temp_downtime->flex_downtime_start);
+		fprintf(fp, "\tend_time=%lu\n", (unsigned long)temp_downtime->end_time);
 		fprintf(fp, "\ttriggered_by=%lu\n", temp_downtime->triggered_by);
 		fprintf(fp, "\tfixed=%d\n", temp_downtime->fixed);
 		fprintf(fp, "\tduration=%lu\n", temp_downtime->duration);
