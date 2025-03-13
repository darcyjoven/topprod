# Prog. Version..: '5.30.08-13.07.05(00010)'     #
#
# Pattern name...: anmp940.4gl
# Descriptions...: 集團間資金調撥傳票拋轉還原作業
# Date & Author..: No.FUN-620051 2006/03/28 By Mandy 
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670060 06/08/07 By wujie   背景執行功能修改
# Modify.........: No.FUN-680088 06/08/25 By Rayven 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.FUN-D60110 13/06/24 by zhangweib 憑證編號開窗可多選
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wc,g_sql     string  
DEFINE   g_dbs_gl 	   LIKE type_file.chr21    #No.FUN-680107 VARCHAR(21)
DEFINE   p_plant        LIKE aac_file.aac01     #No.FUN-680107 VARCHAR(12)
DEFINE   p_acc          LIKE aaa_file.aaa01     #No.FUN-670039
DEFINE   gl_date	      LIKE type_file.dat      #No.FUN-680107 DATE
DEFINE   gl_yy,gl_mm	   LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE   g_str 		   LIKE type_file.chr3     #No.FUN-680107 VARCHAR(3)
DEFINE   g_mxno		   LIKE type_file.chr8     #No.FUN-680107 VARCHAR(8)
DEFINE   g_aaz84        LIKE aaz_file.aaz84     #還原方式 1.刪除 2.作廢 no.4868
DEFINE   p_row,p_col    LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE   g_change_lang  LIKE type_file.chr1     # Prog. Version..: '5.30.08-13.07.05(01) #是否有做語言切換 No.FUN-570127
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(72)
DEFINE   g_flag         LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#===mandy======
DEFINE   g_existno	   LIKE nnv_file.nnv01     #No.FUN-680107 VARCHAR(16)	   
DEFINE   g_existno1   	LIKE nnv_file.nnv01     #No.FUN-680088
DEFINE   g_choice 	   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE   g_npp00        LIKE npp_file.npp00
DEFINE   g_carry    RECORD 
                        dbs_out        LIKE type_file.chr50,    #No.FUN-680107 VARCHAR(21)
                        dbs_in         LIKE type_file.chr50,    #No.FUN-680107 VARCHAR(21)
                        plant_out      LIKE nnv_file.nnv05,
                        plant_in       LIKE nnv_file.nnv20,
                        voucher_out    LIKE nnv_file.nnv34,
                        voucher_in     LIKE nnv_file.nnv35,
                        voucher_out_1  LIKE nnv_file.nnv34,     #No.FUN-680088
                        voucher_in_1   LIKE nnv_file.nnv35      #No.FUN-680088
                    END RECORD
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
#No.FUN-CB0096 ---end  --- Add
#No.FUN-D60110 ---Add--- Start
DEFINE g_existno_str     STRING
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING
DEFINE tm   RECORD
            wc1         STRING
            END RECORD
#No.FUN-D60110 ---Add--- End
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE l_flag       LIKE type_file.chr1                         #No.FUN-570127  #No.FUN-680107 VARCHAR(1)
     OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
#  LET p_plant   = ARG_VAL(1)           #總帳營運中心編號
   LET g_choice  = ARG_VAL(1)           #總帳營運中心編號
   LET p_acc     = ARG_VAL(2)           #總帳帳別編號
   LET g_existno = ARG_VAL(3)           #原總帳傳票編號
   LET g_bgjob   = ARG_VAL(4)           #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570127 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p940_ask()
         #FUN-D60110 ---Add--- Start
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         #FUN-D60110 ---Add--- End 
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
           #FUN-D60110 ---Add--- Start
            CALL s_showmsg_init()
            CALL p940_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            ELSE
               CALL p940_run()
            END IF
            #FUN-D60110 ---Add--- End
           #No.FUN-D60110 ---Mark--- Start
           #CALL p940('0')  #No.FUN-680088 add '0'
           ##No.FUN-680088 --start--
           #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           #   CALL p940('1')
           #END IF
           ##No.FUN-680088 --end--
           #No.FUN-D60110 ---Mark--- Start
            CALL s_showmsg()          #No.FUN-710024
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p940
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
        #No.FUN-D60110 ---Mark--- Start
        #LET g_success = 'Y'
        #CASE g_choice
        #    WHEN '1'
        #         LET g_npp00 = 21
        #    WHEN '2'
        #         LET g_npp00 = 22
        #    WHEN '3'
        #         LET g_npp00 = 23
        #END CASE 
        #IF NOT cl_null(g_existno) THEN
        #    CASE g_choice
        #        WHEN '1' 
#       #                SELECT '','',nnv05,nnv20,nnv34,nnv35   #No.FUN-680088 mark
        #                SELECT '','',nnv05,nnv20,nnv34,nnv35,'',''  #No.FUNN-680088
        #                  INTO g_carry.*
        #                  FROM nnv_file
        #                 WHERE nnv01 = g_existno
        #                IF STATUS THEN
        #                    #無此張單據!請重新輸入!
#       #                    CALL cl_err(g_existno,'anm-941',1)   #No.FUN-660148
        #                    CALL cl_err3("sel","nnv_file",g_existno,"","anm-941","","",1) #No.FUN-660148
        #                ELSE
        #                    IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
        #                        #此張單據未拋傳票,無法做傳票還原!請重新輸入!
#       #                        CALL cl_err(g_existno,'anm-942',1)   #No.FUN-660148
        #                        CALL cl_err3("sel","nnv_file",g_existno,"","anm-942","","",1) #No.FUN-660148
        #                    END IF
        #                    #No.FUN-680088 --start--
        #                    CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #                    CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #                    IF g_aza.aza63 = 'Y' THEN
        #                       #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_out CLIPPED,"npp_file ",
        #                       LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'), #FUN-A50102
        #                                   "  WHERE npp01 = '",g_existno,"'",
        #                                   "    AND npptype = '1' "
 	#                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                       CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql #FUN-A50102
        #                       PREPARE nnv_p1 FROM g_sql
        #                       DECLARE nnv_c1 CURSOR FOR nnv_p1
        #                       OPEN nnv_c1
        #                       FETCH nnv_c1 INTO g_carry.voucher_out_1
        #                       IF STATUS THEN
        #                          CALL cl_err(g_existno,'anm-941',1)
        #                       ELSE
        #                          IF cl_null(g_carry.voucher_out_1) THEN
        #                             CALL cl_err(g_existno,'anm-942',1)
        #                          END IF
        #                       END IF
        #                       #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_in CLIPPED,"npp_file ",
        #                       LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'), #FUN-A50102
        #                                   "  WHERE npp01 = '",g_existno,"'",
        #                                   "    AND npptype = '1' "
        #                       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                       CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql #FUN-A50102
        #                       PREPARE nnv_p2 FROM g_sql
        #                       DECLARE nnv_c2 CURSOR FOR nnv_p2
        #                       OPEN nnv_c2
        #                       FETCH nnv_c2 INTO g_carry.voucher_in_1
        #                       IF STATUS THEN
        #                          CALL cl_err(g_existno,'anm-941',1)
        #                       ELSE
        #                          IF cl_null(g_carry.voucher_in_1) THEN
        #                             CALL cl_err(g_existno,'anm-942',1)
        #                          END IF
        #                       END IF
        #                    END IF
        #                    #No.FUN-680088 --end--
        #                END IF
        #        WHEN '2'
#       #                SELECT '','',nnw05,nnw20,nnw28,nnw29  #No.FUN-680088 mark
        #                SELECT '','',nnw05,nnw20,nnw28,nnw29,'',''  #No.FUN-680088
        #                  INTO g_carry.*
        #                  FROM nnw_file
        #                 WHERE nnw01 = g_existno
        #                   AND nnw00 = '1' #還本
        #                IF STATUS THEN
        #                    #無此張單據!請重新輸入!
#       #                    CALL cl_err(g_existno,'anm-941',1)   #No.FUN-660148
        #                    CALL cl_err3("sel","nnw_file", g_existno,"","anm-941","","",1) #No.FUN-660148
        #                ELSE
        #                    IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
        #                        #此張單據未拋傳票,無法做傳票還原!請重新輸入!
#       #                        CALL cl_err(g_existno,'anm-942',1)   #No.FUN-660148
        #                        CALL cl_err3("sel","nnw_file", g_existno,"","anm-942","","",1) #No.FUN-660148
        #                    END IF
        #                    #No.FUN-680088 --start--
        #                    CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #                    CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #                    IF g_aza.aza63 = 'Y' THEN
        #                       #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_out CLIPPED,"npp_file ",
        #                       LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'), #FUN-A50102
        #                                   "  WHERE npp01 = '",g_existno,"'",
        #                                   "    AND npptype = '1' "
 	#                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                       CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql #FUN-A50102
        #                       PREPARE nnw_p1 FROM g_sql
        #                       DECLARE nnw_c1 CURSOR FOR nnw_p1
        #                       OPEN nnw_c1
        #                       FETCH nnw_c1 INTO g_carry.voucher_out_1
        #                       IF STATUS THEN
        #                          CALL cl_err(g_existno,'anm-941',1)
        #                       ELSE
        #                          IF cl_null(g_carry.voucher_out_1) THEN
        #                             CALL cl_err(g_existno,'anm-942',1)
        #                          END IF
        #                       END IF
        #                       #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_in CLIPPED,"npp_file ",
        #                       LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'), #FUN-A50102
        #                                   "  WHERE npp01 = '",g_existno,"'",
        #                                   "    AND npptype = '1' "
 	#                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                       CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql #FUN-A50102
        #                       PREPARE nnw_p2 FROM g_sql
        #                       DECLARE nnw_c2 CURSOR FOR nnw_p2
        #                       OPEN nnw_c2
        #                       FETCH nnw_c2 INTO g_carry.voucher_in_1
        #                       IF STATUS THEN
        #                          CALL cl_err(g_existno,'anm-941',1)
        #                       ELSE
        #                          IF cl_null(g_carry.voucher_in_1) THEN
        #                             CALL cl_err(g_existno,'anm-942',1)
        #                          END IF
        #                       END IF
        #                    END IF
        #                    #No.FUN-680088 --end--
        #                END IF
        #        WHEN '3'
#       #                SELECT '','',nnw05,nnw20,nnw28,nnw29,  #No.FUN-680088  mark
        #                SELECT '','',nnw05,nnw20,nnw28,nnw29,'',''  #No.FUN-680088
        #                  INTO g_carry.*
        #                  FROM nnw_file
        #                 WHERE nnw01 = g_existno
        #                   AND nnw00 = '2' #還息
        #                IF STATUS THEN
        #                    #無此張單據!請重新輸入!
#       #                    CALL cl_err(g_existno,'anm-941',1)   #No.FUN-660148
        #                    CALL cl_err3("sel","nnw_file", g_existno,"","anm-941","","",1) #No.FUN-660148
        #                ELSE
        #                    IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
        #                        #此張單據未拋傳票,無法做傳票還原!請重新輸入!
#       #                        CALL cl_err(g_existno,'anm-942',1)   #No.FUN-660148
        #                        CALL cl_err3("sel","nnw_file", g_existno,"","anm-942","","",1) #No.FUN-660148
        #                    END IF
        #                    #No.FUN-680088 --start--
        #                    CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #                    CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #                    IF g_aza.aza63 = 'Y' THEN
        #                       #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_out CLIPPED,"npp_file ",
        #                       LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'), #FUN-A50102
        #                                   "  WHERE npp01 = '",g_existno,"'",
        #                                   "    AND npptype = '1' "
 	#                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                       CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql #FUN-A50102
        #                       PREPARE nnw_p3 FROM g_sql
        #                       DECLARE nnw_c3 CURSOR FOR nnw_p3
        #                       OPEN nnw_c3
        #                       FETCH nnw_c3 INTO g_carry.voucher_out_1
        #                       IF STATUS THEN
        #                          CALL cl_err(g_existno,'anm-941',1)
        #                       ELSE
        #                          IF cl_null(g_carry.voucher_out_1) THEN
        #                             CALL cl_err(g_existno,'anm-942',1)
        #                          END IF
        #                       END IF
        #                       #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_in CLIPPED,"npp_file ",
        #                       LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'), #FUN-A50102
        #                                   "  WHERE npp01 = '",g_existno,"'",
        #                                   "    AND npptype = '1' "
 	#                           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                       CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql #FUN-A50102
        #                       PREPARE nnw_p4 FROM g_sql
        #                       DECLARE nnw_c4 CURSOR FOR nnw_p4
        #                       OPEN nnw_c4
        #                       FETCH nnw_c4 INTO g_carry.voucher_in_1
        #                       IF STATUS THEN
        #                          CALL cl_err(g_existno,'anm-941',1)
        #                       ELSE
        #                          IF cl_null(g_carry.voucher_in_1) THEN
        #                             CALL cl_err(g_existno,'anm-942',1)
        #                          END IF
        #                       END IF
        #                    END IF
        #                    #No.FUN-680088 --end--
        #                END IF
        #    END CASE 
        #    CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #    CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #END IF
        #BEGIN WORK
        #CALL p940('0')  #No.FUN-680088 add '0'
        ##No.FUN-680088 --start--
        #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        #   CALL p940('1')
        #END IF
        ##No.FUN-680088 --end--
        #No.FUN-D60110 ---Mark--- End

        #No.FUN-D60110 ---Add--- Start
         LET g_success = 'Y'
         CASE g_choice
             WHEN '1'
                  LET g_npp00 = 21
             WHEN '2'
                  LET g_npp00 = 22
             WHEN '3'
                  LET g_npp00 = 23
         END CASE 
         LET tm.wc1 = "g_existno IN ('",g_existno,"')"
         CALL s_showmsg_init()
         BEGIN WORK
         CALL p940_existno_chk()
         IF g_success = 'Y' THEN CALL p940_run() END IF 
        #No.FUN-D60110 ---Add--- End
         CALL s_showmsg()          #No.FUN-710024
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN

#No.FUN-D60110 ---Add--- Start
FUNCTION p940_run()

   CASE
      WHEN g_choice = '1'
         LET g_sql = "SELECT '','',nnv05,nnv20,nnv34,nnv35,'','',nnv01", 
                     "  FROM nnv_file",
                     "  WHERE ",tm.wc1 CLIPPED
         PREPARE p940_nnv_prep4 FROM g_sql
         DECLARE p940_nnv_p4 CURSOR FOR p940_nnv_prep4
         FOREACH p940_nnv_p4 INTO g_carry.*,g_existno
            CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
            CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
            IF g_aza.aza63 = 'Y' THEN
               LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'),
                           "  WHERE npp01 = '",g_existno,"'",
                           "    AND npptype = '1' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
               CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql 
               PREPARE nnv_p31 FROM g_sql
               EXECUTE nnv_p31 INTO g_carry.voucher_out_1
               LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'),
                           "  WHERE npp01 = '",g_existno,"'",
                           "    AND npptype = '1' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
               CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql 
               PREPARE nnv_p41 FROM g_sql
               EXECUTE nnv_p41 INTO g_carry.voucher_in_1
            END IF
            CALL p940('0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p940('1')
            END IF
         END FOREACH
      WHEN g_choice = '2'
         LET g_sql = "SELECT '','',nnw05,nnw20,nnw28,nnw29,'','',nnw01", 
                     "  FROM nnw_file",
                     " WHERE ",tm.wc1 CLIPPED,
                     "   AND nnw00 = '1'" #還本
         PREPARE p940_nnw_prep41 FROM g_sql
         DECLARE p940_nnw_p41 CURSOR FOR p940_nnw_prep41
         FOREACH p940_nnw_p41 INTO g_carry.*,g_existno
            CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
            CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
            IF g_aza.aza63 = 'Y' THEN
               LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'),
                           "  WHERE npp01 = '",g_existno,"'",
                           "    AND npptype = '1' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
               CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql 
               PREPARE nnw_p31 FROM g_sql
               EXECUTE nnw_p31 INTO g_carry.voucher_out_1
               LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'),
                           "  WHERE npp01 = '",g_existno,"'",
                           "    AND npptype = '1' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
               CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql 
               PREPARE nnw_p41 FROM g_sql
               EXECUTE nnw_p41 INTO g_carry.voucher_in_1
            END IF
            CALL p940('0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p940('1')
            END IF
         END FOREACH
      WHEN g_choice = '3'
         LET g_sql = "SELECT '','',nnw05,nnw20,nnw28,nnw29,'','',nnw01", 
                     "  FROM nnw_file",
                     " WHERE ",tm.wc1 CLIPPED,
                     "   AND nnw00 = '2'" #還息
         PREPARE p940_nnw_prep42 FROM g_sql
         DECLARE p940_nnw_p42 CURSOR FOR p940_nnw_prep42
         FOREACH p940_nnw_p42 INTO g_carry.*,g_existno
            CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
            CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
            IF g_aza.aza63 = 'Y' THEN
               LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'),
                           "  WHERE npp01 = '",g_existno,"'",
                           "    AND npptype = '1' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
               CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql 
               PREPARE nnw_p32 FROM g_sql
               EXECUTE nnw_p32 INTO g_carry.voucher_out_1
               LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'),
                           "  WHERE npp01 = '",g_existno,"'",
                           "    AND npptype = '1' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
               CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql 
               PREPARE nnw_p42 FROM g_sql
               EXECUTE nnw_p42 INTO g_carry.voucher_in_1
            END IF
            CALL p940('0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p940('1')
            END IF
         END FOREACH
   END CASE
END FUNCTION
#No.FUN-D60110 ---Add--- End
 
FUNCTION p940(p_npptype)  #No.FUN-680088 add p_npptype
  DEFINE l_existno   LIKE nnv_file.nnv01
  DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680088
 
      #CALL s_showmsg_init()   #No.FUN-710024    #No.FUN-D60110   Mark
 
       #==>撥出傳票資料的刪除或作廢
       IF g_success = 'Y' THEN
           IF p_npptype = '0' THEN  #No.FUN-680088
              #CALL p940_t1(g_carry.dbs_out,g_carry.voucher_out,p_npptype)  #No.FUN-680088 add p_npptype
             CALL p940_t1(g_carry.plant_out,g_carry.dbs_out,g_carry.voucher_out,p_npptype)   #FUN-A50102
           #No.FUN-680088 --start--
           ELSE
              #CALL p940_t1(g_carry.dbs_out,g_carry.voucher_out_1,p_npptype)
              CALL p940_t1(g_carry.plant_out,g_carry.dbs_out,g_carry.voucher_out_1,p_npptype) #FUN-A50102
           END IF
           #No.FUN-680088 --end--
       END IF
       #==>撥入傳票資料的刪除或作廢
       IF g_success = 'Y' THEN
           IF p_npptype = '0' THEN  #No.FUN-680088
              #CALL p940_t1(g_carry.dbs_in ,g_carry.voucher_in,p_npptype)  #No.FUN-680088 add p_npptype 
              CALL p940_t1(g_carry.plant_in ,g_carry.dbs_in ,g_carry.voucher_in,p_npptype) #FUN-A50102
           #No.FUN-680088 --start--
           ELSE
              #CALL p940_t1(g_carry.dbs_in ,g_carry.voucher_in_1,p_npptype)
              CALL p940_t1(g_carry.plant_in ,g_carry.dbs_in ,g_carry.voucher_in_1,p_npptype) #FUN-A50102
           END IF
           #No.FUN-680088 --end--
       END IF
 
       IF g_success = 'Y' THEN
           CASE g_choice 
                WHEN '1'
                     LET g_sql = "SELECT nnv01 ",
                                 "  FROM nnv_file ",
                                 " WHERE nnv05 = '",g_carry.plant_out,"'",
                                 "   AND nnv20 = '",g_carry.plant_in,"'",
                                 "   AND nnv34 = '",g_carry.voucher_out,"'",
                                 "   AND nnv35 = '",g_carry.voucher_in,"'"
                WHEN '2'
                     LET g_sql = "SELECT nnw01 ",
                                 "  FROM nnw_file ",
                                 " WHERE nnw05 = '",g_carry.plant_out,"'",
                                 "   AND nnw20 = '",g_carry.plant_in,"'",
                                 "   AND nnw28 = '",g_carry.voucher_out,"'",
                                 "   AND nnw29 = '",g_carry.voucher_in,"'",
                                 "   AND nnw00 = '1' "  #還本
                WHEN '3'
                     LET g_sql = "SELECT nnw01 ",
                                 "  FROM nnw_file ",
                                 " WHERE nnw05 = '",g_carry.plant_out,"'",
                                 "   AND nnw20 = '",g_carry.plant_in,"'",
                                 "   AND nnw28 = '",g_carry.voucher_out,"'",
                                 "   AND nnw29 = '",g_carry.voucher_in,"'",
                                 "   AND nnw00 = '2' "  #還息
           END CASE
           PREPARE p940_sel_no_pre FROM g_sql
           DECLARE p940_sel_no_cur CURSOR FOR p940_sel_no_pre
           LET l_existno = NULL
           FOREACH p940_sel_no_cur INTO l_existno
               IF SQLCA.sqlcode THEN
                   LET g_success = 'N'
 #No.FUN-710024--begin
 #                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   LET g_showmsg=g_carry.plant_out,"/",g_carry.plant_in,"/",g_carry.voucher_out,"/",g_carry.voucher_in
                   CALL s_errmsg('nnw05,nnw20,nnw28,nnw29',g_showmsg,'foreach:',SQLCA.sqlcode,1)
 #No.FUN-710024--end        
                   EXIT FOREACH
               END IF
 #No.FUN-710024--begin
              IF g_success='N' THEN                                                                                                          
                 LET g_totsuccess='N'                                                                                                       
                 LET g_success="Y"                                                                                                          
              END IF              
 #No.FUN-710024--end        
               LET g_existno1 = l_existno
               #==>UPDATE 調撥/還本/還息的撥出/撥入傳票編號為NULL
               CALL p940_t2(l_existno)
               IF g_success = 'N' THEN EXIT FOREACH END IF
 
               #==>UPDATE 撥出銀行存款異動記錄檔/分錄底稿單頭檔
               #CALL p940_t3(g_carry.dbs_out,l_existno,p_npptype)  #No.FUN-680088 add p_npptype 
               CALL p940_t3(g_carry.plant_out,l_existno,p_npptype)   #FUN-A50102
               IF g_success = 'N' THEN EXIT FOREACH END IF
 
               #==>UPDATE 撥入銀行存款異動記錄檔/分錄底稿單頭檔
               #CALL p940_t3(g_carry.dbs_in,l_existno,p_npptype)  #No.FUN-680088 add p_npptype
               CALL p940_t3(g_carry.plant_in,l_existno,p_npptype)    #FUN-A50102
               IF g_success = 'N' THEN EXIT FOREACH END IF
           END FOREACH
#No.FUN-710024--begin
           IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
           END IF 
#No.FUN-710024--end  
 
 
           #No.FUN-680088 --start--
           #CALL p940_t4(g_carry.dbs_out,g_existno1,p_npptype)
           CALL p940_t4(g_carry.plant_out,g_existno1,p_npptype)  #FUN-A50102
           IF g_success = 'N' THEN RETURN END IF
           #CALL p940_t4(g_carry.dbs_in,g_existno1,p_npptype)
           CALL p940_t4(g_carry.plant_in,g_existno1,p_npptype)   #FUN-A50102
           IF g_success = 'N' THEN RETURN END IF
           #No.FUN-680088 --end--
       END IF
    ERROR ""
END FUNCTION
 
FUNCTION p940_ask()
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE   l_aba19            LIKE aba_file.aba19
   DEFINE   l_abaacti          LIKE aba_file.aba19
   DEFINE   l_aaa07            LIKE aaa_file.aaa07
   DEFINE   l_cnt              LIKE type_file.num5    #TQC-620099  #No.FUN-680107 SMALLINT
   DEFINE   lc_cmd             LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500)     #No.FUN-570127
 
 
#->No.FUN-570127 --start--
   OPEN WINDOW p940 AT p_row,p_col WITH FORM "anm/42f/anmp940"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
#->No.FUN-570127 ---end---
 
   LET g_existno = NULL
   LET g_bgjob = 'N' #NO.FUN-570127 
   LET g_choice = '1'
   DISPLAY NULL TO FORMONLY.g_existno  #No.FUN-D60110 Add
   WHILE TRUE        #NO.FUN-570127
   DIALOG ATTRIBUTES(UNBUFFERED)  #No.FUN-D60110 Add
     #INPUT g_choice,g_existno WITHOUT DEFAULTS FROM FORMONLY.choice,FORMONLY.existno ATTRIBUTE(UNBUFFERED)   #No.FUN-D60110  Mark
      INPUT BY NAME g_choice ATTRIBUTE(WITHOUT DEFAULTS=TRUE)    #No.FUN-D60110  Add
    
         AFTER FIELD choice
            CASE g_choice
                WHEN '1'
                     LET g_npp00 = 21
                WHEN '2'
                     LET g_npp00 = 22
                WHEN '3'
                     LET g_npp00 = 23
            END CASE 
            
        #No.FUN-D60110 ---Mark--- Start
        #AFTER FIELD existno
        #   IF cl_null(g_choice) THEN
        #       NEXT FIELD choice
        #   END IF
        #   IF NOT cl_null(g_existno) THEN
        #       CASE g_choice
        #           WHEN '1' 
   #    #                   SELECT '','',nnv05,nnv20,nnv34,nnv35  #No.FUN-680088 mark
        #                   SELECT '','',nnv05,nnv20,nnv34,nnv35,'',''  #No.FUN-680088
        #                     INTO g_carry.*
        #                     FROM nnv_file
        #                    WHERE nnv01 = g_existno
        #                   IF STATUS THEN
        #                       #無此張單據!請重新輸入!
   #    #                       CALL cl_err(g_existno,'anm-941',1)   #No.FUN-660148
        #                       CALL cl_err3("sel","nnv_file",g_existno,"","anm-941","","",1) #No.FUN-660148
        #                       NEXT FIELD existno
        #                   ELSE
        #                       IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
        #                           #此張單據未拋傳票,無法做傳票還原!請重新輸入!
   #    #                           CALL cl_err(g_existno,'anm-942',1)   #No.FUN-660148
        #                           CALL cl_err3("sel","nnv_file",g_existno,"","anm-942","","",1) #No.FUN-660148
        #                           NEXT FIELD existno
        #                       END IF
        #                       #No.FUN-680088 --start--
        #                       CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #                       CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #                       IF g_aza.aza63 = 'Y' THEN
        #                          #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_out CLIPPED,"npp_file ",
        #                          LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'), #FUN-A50102
        #                                      "  WHERE npp01 = '",g_existno,"'",
        #                                      "    AND npptype = '1' "
        #                         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                          CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql #FUN-A50102
        #                          PREPARE nnv_p3 FROM g_sql
        #                          DECLARE nnv_c3 CURSOR FOR nnv_p3
        #                          OPEN nnv_c3
        #                          FETCH nnv_c3 INTO g_carry.voucher_out_1
        #                          IF STATUS THEN
        #                             CALL cl_err(g_existno,'anm-941',1)
        #                             NEXT FIELD existno
        #                          ELSE
        #                             IF cl_null(g_carry.voucher_out_1) THEN
        #                                CALL cl_err(g_existno,'anm-942',1)
        #                                NEXT FIELD existno
        #                             END IF
        #                          END IF
        #                          #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_in CLIPPED,"npp_file ",
        #                          LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'), #FUN-A50102
        #                                      "  WHERE npp01 = '",g_existno,"'",
        #                                      "    AND npptype = '1' "
        #                         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                          CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql #FUN-A50102
        #                          PREPARE nnv_p4 FROM g_sql
        #                          DECLARE nnv_c4 CURSOR FOR nnv_p4
        #                          OPEN nnv_c4
        #                          FETCH nnv_c4 INTO g_carry.voucher_in_1
        #                          IF STATUS THEN
        #                             CALL cl_err(g_existno,'anm-941',1)
        #                             NEXT FIELD existno
        #                          ELSE
        #                             IF cl_null(g_carry.voucher_in_1) THEN
        #                                CALL cl_err(g_existno,'anm-942',1)
        #                                NEXT FIELD existno
        #                             END IF
        #                          END IF
        #                       END IF
        #                       #No.FUN-680088 --end--
        #                   END IF
        #           WHEN '2'
   #    #                   SELECT '','',nnw05,nnw20,nnw28,nnw29 #No.FUN-680088 mark
        #                   SELECT '','',nnw05,nnw20,nnw28,nnw29,'','' #No.FUN-680088
        #                     INTO g_carry.*
        #                     FROM nnw_file
        #                    WHERE nnw01 = g_existno
        #                      AND nnw00 = '1' #還本
        #                   IF STATUS THEN
        #                       #無此張單據!請重新輸入!
   #    #                       CALL cl_err(g_existno,'anm-941',1)   #No.FUN-660148
        #                       CALL cl_err3("sel","nnw_file", g_existno,"","anm-941","","",1) #No.FUN-660148
        #                       NEXT FIELD existno
        #                   ELSE
        #                       IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
        #                           #此張單據未拋傳票,無法做傳票還原!請重新輸入!
   #    #                           CALL cl_err(g_existno,'anm-942',1)   #No.FUN-660148
        #                           CALL cl_err3("sel","nnw_file", g_existno,"","anm-942","","",1) #No.FUN-660148
        #                           NEXT FIELD existno
        #                       END IF
        #                       #No.FUN-680088 --start--
        #                       CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #                       CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #                       IF g_aza.aza63 = 'Y' THEN
        #                          #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_out CLIPPED,"npp_file ",
        #                          LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'), #FUN-A50102
        #                                      "  WHERE npp01 = '",g_existno,"'",
        #                                      "    AND npptype = '1' "
        #                         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                          CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql #FUN-A50102
        #                          PREPARE nnw_p5 FROM g_sql
        #                          DECLARE nnw_c5 CURSOR FOR nnw_p5
        #                          OPEN nnw_c5
        #                          FETCH nnw_c5 INTO g_carry.voucher_out_1
        #                          IF STATUS THEN
        #                             CALL cl_err(g_existno,'anm-941',1)
        #                             NEXT FIELD existno
        #                          ELSE
        #                             IF cl_null(g_carry.voucher_out_1) THEN
        #                                CALL cl_err(g_existno,'anm-942',1)
        #                                NEXT FIELD existno
        #                             END IF
        #                          END IF
        #                          #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_in CLIPPED,"npp_file ",
        #                          LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'), #FUN-A50102
        #                                      "  WHERE npp01 = '",g_existno,"'",
        #                                      "    AND npptype = '1' "
        #                         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                          CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql #FUN-A50102
        #                          PREPARE nnw_p6 FROM g_sql
        #                          DECLARE nnw_c6 CURSOR FOR nnw_p6
        #                          OPEN nnw_c6
        #                          FETCH nnw_c6 INTO g_carry.voucher_in_1
        #                          IF STATUS THEN
        #                             CALL cl_err(g_existno,'anm-941',1)
        #                             NEXT FIELD existno
        #                          ELSE
        #                             IF cl_null(g_carry.voucher_in_1) THEN
        #                                CALL cl_err(g_existno,'anm-942',1)
        #                                NEXT FIELD existno
        #                             END IF
        #                          END IF
        #                       END IF
        #                       #No.FUN-680088 --end--
        #                   END IF
        #           WHEN '3'
   #    #                   SELECT '','',nnw05,nnw20,nnw28,nnw29  #No.FUN-680088 mark
        #                   SELECT '','',nnw05,nnw20,nnw28,nnw29,'',''  #No.FUN-680088
        #                     INTO g_carry.*
        #                     FROM nnw_file
        #                    WHERE nnw01 = g_existno
        #                      AND nnw00 = '2' #還息
        #                   IF STATUS THEN
        #                       #無此張單據!請重新輸入!
   #    #                       CALL cl_err(g_existno,'anm-941',1)   #No.FUN-660148
        #                       CALL cl_err3("sel","nnw_file", g_existno,"","anm-941","","",1) #No.FUN-660148
        #                       NEXT FIELD existno
        #                   ELSE
        #                       IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
        #                           #此張單據未拋傳票,無法做傳票還原!請重新輸入!
   #    #                           CALL cl_err(g_existno,'anm-942',1)   #No.FUN-660148
        #                           CALL cl_err3("sel","nnw_file", g_existno,"","anm-942","","",1) #No.FUN-660148
        #                           NEXT FIELD existno
        #                       END IF
        #                       #No.FUN-680088 --start--
        #                       CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #                       CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #                       IF g_aza.aza63 = 'Y' THEN
        #                          #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_out CLIPPED,"npp_file ",
        #                          LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'), #FUN-A50102
        #                                      "  WHERE npp01 = '",g_existno,"'",
        #                                      "    AND npptype = '1' "
        #                          CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                          CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql #FUN-A50102
        #                          PREPARE nnw_p7 FROM g_sql
        #                          DECLARE nnw_c7 CURSOR FOR nnw_p7
        #                          OPEN nnw_c7
        #                          FETCH nnw_c7 INTO g_carry.voucher_out_1
        #                          IF STATUS THEN
        #                             CALL cl_err(g_existno,'anm-941',1)
        #                             NEXT FIELD existno
        #                          ELSE
        #                             IF cl_null(g_carry.voucher_out_1) THEN
        #                                CALL cl_err(g_existno,'anm-942',1)
        #                                NEXT FIELD existno
        #                             END IF
        #                          END IF
        #                          #LET g_sql = " SELECT nppglno FROM ",g_carry.dbs_in CLIPPED,"npp_file ",
        #                          LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'), #FUN-A50102
        #                                      "  WHERE npp01 = '",g_existno,"'",
        #                                      "    AND npptype = '1' "
        #                         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #                          CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql #FUN-A50102
        #                          PREPARE nnw_p8 FROM g_sql
        #                          DECLARE nnw_c8 CURSOR FOR nnw_p8
        #                          OPEN nnw_c8
        #                          FETCH nnw_c8 INTO g_carry.voucher_in_1
        #                          IF STATUS THEN
        #                             CALL cl_err(g_existno,'anm-941',1)
        #                             NEXT FIELD existno
        #                          ELSE
        #                             IF cl_null(g_carry.voucher_in_1) THEN
        #                                CALL cl_err(g_existno,'anm-942',1)
        #                                NEXT FIELD existno
        #                             END IF
        #                          END IF
        #                       END IF
        #                       #No.FUN-680088 --end--
        #                   END IF
        #       END CASE 
        #       CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
        #       CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
        #   END IF
        #No.FUN-D60110 ---Mark--- End
    
         AFTER INPUT
            IF INT_FLAG THEN
              #EXIT INPUT     #No.FUN-D60110   Mark
               EXIT DIALOG     #No.FUN-D60110 Add
            END IF
            CALL cl_qbe_init()

        #No.FUN-D60110 ---Mark--- Start
        #ON ACTION CONTROLR
        #   CALL cl_show_req_fields()
        #
        #ON ACTION CONTROLG
        #   CALL cl_cmdask()
        #
        #ON ACTION locale                    #genero
        #   LET g_change_lang = TRUE
        #   EXIT INPUT
        #
        #ON IDLE g_idle_seconds
        #   CALL cl_on_idle()
        #   CONTINUE INPUT
        #
        #ON ACTION about        
        #   CALL cl_about()     
        #
        #ON ACTION help         
        #   CALL cl_show_help() 
        #
        #
        #ON ACTION exit  
        #   LET INT_FLAG = 1
        #   EXIT INPUT
        #
        #ON ACTION qbe_select
        #   CALL cl_qbe_select()
        #
        #ON ACTION qbe_save
        #   CALL cl_qbe_save()
        #No.FUN-D60110 ---Mark--- Start

         ON ACTION CONTROLP           #No.FUN-D60110 Add
    
      END INPUT

   #FUN-D60110 ---Add--- Start
   CONSTRUCT BY NAME  tm.wc1 ON existno
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

  #AFTER FIELD g_existno   #MOD-G30031 mark
   AFTER FIELD existno     #MOD-G30031 add
      IF tm.wc1 = " 1=1" THEN 
         CALL cl_err('','9033',0)
        #NEXT FIELD g_existno   #MOD-G30031 mark
         NEXT FIELD existno     #MOD-G30031 add 
      END IF  
     #MOD-G30031---add---str--
      IF GET_FLDBUF(existno) = "*" THEN
         CALL cl_err('','9089',1)
         NEXT FIELD existno
      END IF
     #MOD-G30031---add---end-- 
      CALL  p940_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
        #NEXT FIELD g_existno   #MOD-G30031 mark
         NEXT FIELD existno     #MOD-G30031 add  
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(existno)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              CASE
                 WHEN g_choice = '1'
                    LET g_qryparam.form = "q_nnv"
                 WHEN g_choice = '2'
                    LET g_qryparam.form = "q_nnw"
                    LET g_qryparam.where = "nnw00 = '1'"
                 WHEN g_choice = '3'
                    LET g_qryparam.form = "q_nnw"
                    LET g_qryparam.where = "nnw00 = '2'"
              END CASE
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO existno
              NEXT FIELD existno
         END CASE

   END CONSTRUCT
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION exit 
         LET INT_FLAG = 1
         EXIT DIALOG    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
  
      ON ACTION ACCEPT
        #MOD-G30031---add---str--
         IF GET_FLDBUF(existno) = "*" THEN
            CALL cl_err('','9089',1)
            NEXT FIELD existno
         END IF
        #MOD-G30031---add---end--
         EXIT DIALOG        
       
      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END DIALOG 
   CASE g_choice
       WHEN '1'
            LET g_npp00 = 21
       WHEN '2'       
            LET g_npp00 = 22
       WHEN '3'       
            LET g_npp00 = 23
   END CASE
   #FUN-D60110 ---Add--- End
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p940
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "anmp940"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('anmp940','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant CLIPPED,"'",
                      " '",p_acc CLIPPED,"'",
                      " '",g_existno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('anmp940',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p940
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
#傳票資料的處理 
#FUNCTION p940_t1(p_dbs,p_aba01,p_npptype)  #No.FUN-680088 add p_npptype
FUNCTION p940_t1(l_plant,p_dbs,p_aba01,p_npptype)    #FUN-A50102
  DEFINE p_dbs     LIKE type_file.chr50    #No.FUN-680107 VARCHAR(21)
  DEFINE p_aba01   LIKE aba_file.aba01
  DEFINE l_aba00   LIKE aba_file.aba00
  DEFINE l_aaz84   LIKE aaz_file.aaz84
  DEFINE p_npptype LIKE npp_file.npptype   #No.FUN-680088
  DEFINE l_plant   LIKE type_file.chr21    #FUN-A50102
 
     
     IF p_npptype = '0' THEN  #No.FUN-680088
        #LET g_sql="SELECT nmz02b FROM ",p_dbs CLIPPED,"nmz_file ",
        LET g_sql="SELECT nmz02b FROM ",cl_get_target_table(l_plant,'nmz_file'), #FUN-A50102
                  " WHERE nmz00 = '0' "
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_nmz02b_p FROM g_sql
        DECLARE p940_nmz02b_cus CURSOR FOR p940_nmz02b_p
        OPEN p940_nmz02b_cus
        FETCH p940_nmz02b_cus INTO l_aba00
        IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err('sel nmz02b',100,1)
           CALL s_errmsg('nmz00','0','sel nmz02b',100,1)       
#No.FUN-710024--end
            LET g_success = 'N'
            RETURN
        END IF
     #No.FUN-680088 --start--
     ELSE
        #LET g_sql="SELECT nmz02c FROM ",p_dbs CLIPPED,"nmz_file ",
        LET g_sql="SELECT nmz02c FROM ",cl_get_target_table(l_plant,'nmz_file'), #FUN-A50102
                  " WHERE nmz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_nmz02c_p FROM g_sql
        DECLARE p940_nmz02c_cus CURSOR FOR p940_nmz02c_p
        OPEN p940_nmz02c_cus
        FETCH p940_nmz02c_cus INTO l_aba00
        IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err('sel nmz02c',100,1)
           CALL s_errmsg('nmz00','0','sel nmz02c',100,1)       
#No.FUN-710024--end
            LET g_success = 'N'
            RETURN
        END IF
     END IF
     #No.FUN-680088 --end--
 
     #LET g_sql="SELECT aaz84 FROM ",p_dbs CLIPPED,"aaz_file ",
     LET g_sql="SELECT aaz84 FROM ",cl_get_target_table(l_plant,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
     PREPARE p940_aaz84_p FROM g_sql
     DECLARE p940_aaz84_cus CURSOR FOR p940_aaz84_p
     OPEN p940_aaz84_cus
     FETCH p940_aaz84_cus INTO l_aaz84
     IF STATUS OR cl_null(l_aaz84) THEN
         #傳票拋轉還原時,還原方式未定義(aaz84),請至總帳會計系統參數設定(agls103),將此參數設定好.
#No.FUN-710024--begin
#         CALL cl_err(p_dbs,'anm-943',1)
         CALL s_errmsg('aaz00','0',p_dbs,'anm-943',1)       
#No.FUN-710024--end
         LET g_success = 'N'
         RETURN
     END IF
 
     IF l_aaz84 = '2' THEN   #還原方式為'2':作廢 
        #LET g_sql="UPDATE ",p_dbs CLIPPED,"aba_file ",
        LET g_sql="UPDATE ",cl_get_target_table(l_plant,'aba_file'), #FUN-A50102
                  "   SET abaacti = 'N' ",
                  " WHERE aba01 = ? ",
                  "   AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_upd_aba FROM g_sql
        EXECUTE p940_upd_aba USING p_aba01,l_aba00
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#No.FUN-710024--begin
#           CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) 
           LET g_showmsg=p_aba01,"/",l_aba00    
           CALL s_errmsg('aba01,aba00',g_showmsg,'(upd abaacti)',SQLCA.sqlcode,1)
#No.FUN-710024--end
            LET g_success = 'N' 
            RETURN
        END IF
     ELSE
        #==>刪除會計傳票單身檔
        #LET g_sql="DELETE FROM ",p_dbs CLIPPED,"abb_file",
        LET g_sql="DELETE FROM ",cl_get_target_table(l_plant,'abb_file'), #FUN-A50102
                  " WHERE abb01=? ",
                  "   AND abb00=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_del_abb FROM g_sql
        EXECUTE p940_del_abb USING p_aba01,l_aba00
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#No.FUN-710024--begin
#            CALL cl_err('(del abb)',SQLCA.sqlcode,1) 
            LET g_showmsg=p_aba01,"/",l_aba00    
            CALL s_errmsg('abb01,abb00',g_showmsg,'(del abb)',SQLCA.sqlcode,1)
#No.FUN-710024--end
            LET g_success = 'N' 
            RETURN
        END IF
     
        #==>刪除會計傳票單頭檔
        #LET g_sql="DELETE FROM ",p_dbs CLIPPED,"aba_file",
        LET g_sql="DELETE FROM ",cl_get_target_table(l_plant,'aba_file'), #FUN-A50102
                  " WHERE aba01=? ",
                  "   AND aba00=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_del_aba FROM g_sql
        EXECUTE p940_del_aba USING p_aba01,l_aba00
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#            CALL cl_err('(del aba)','aap-161',1) 
            LET g_showmsg=p_aba01,"/",l_aba00    
            CALL s_errmsg('aba01,aba00',g_showmsg,'(del aba)','aap-161',1)
#No.FUN-710024--end
            LET g_success = 'N' 
            RETURN
        END IF
     
        #==>刪除會計傳票額外摘要檔
        #LET g_sql="DELETE FROM ",p_dbs CLIPPED,"abc_file",
        LET g_sql="DELETE FROM ",cl_get_target_table(l_plant,'abc_file'), #FUN-A50102
                  " WHERE abc01=? ",
                  "   AND abc00=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_del_abc FROM g_sql
        EXECUTE p940_del_abc USING p_aba01,l_aba00
        IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#           CALL cl_err('(del abc)',SQLCA.sqlcode,1) 
           LET g_showmsg=p_aba01,"/",l_aba00    
           CALL s_errmsg('abc01,abc00',g_showmsg,'(del abc)',SQLCA.sqlcode,1)
#No.FUN-710024--end
           LET g_success = 'N' 
           RETURN
        END IF
#FUN-B40056  --begin
        LET g_sql="DELETE FROM ",cl_get_target_table(l_plant,'tic_file'),
                  " WHERE tic04=? ",
                  "   AND tic00=? "
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE p940_del_tic FROM g_sql
        EXECUTE p940_del_tic USING p_aba01,l_aba00
        IF SQLCA.sqlcode THEN
           LET g_showmsg=p_aba01,"/",l_aba00    
           CALL s_errmsg('tic04,tic00',g_showmsg,'(del tic)',SQLCA.sqlcode,1)
           LET g_success = 'N' 
           RETURN
        END IF
#FUN-B40056  --end
     END IF
  #No.FUN-CB0096 ---start--- Add
   LET l_time = TIME
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,p_aba01,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
 
#UPDATE 調撥/還本/還息
FUNCTION p940_t2(p_existno)
  DEFINE p_existno    LIKE nnv_file.nnv01   
 
     LET g_msg = TIME
     INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)          #FUN-980005 add plant & legal 
                       VALUES('anmp940',g_user,g_today,g_msg,p_existno,'delete',g_plant,g_legal)
     CASE g_choice
          WHEN '1'
                   #==>更新調撥資料
                   UPDATE nnv_file 
                      SET nnv34 = NULL,
                          nnv35 = NULL
                    WHERE nnv01 = p_existno
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                      CALL cl_err('up nnv_file',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                       CALL cl_err3("upd","nnv_file",p_existno,"",SQLCA.sqlcode,"","up nnv_file",1) #No.FUN-660148
                       CALL s_errmsg('nnv01',p_existno,'up nnv_file',SQLCA.sqlcode,1)
#No.FUN-710024--end
                       LET g_success = 'N'
                   END IF
          WHEN '2'
                   #==>更新還本資料
                   UPDATE nnw_file 
                      SET nnw28 = NULL,
                          nnw29 = NULL
                    WHERE nnw01 = p_existno
                      AND nnw00 = '1'
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                      CALL cl_err('up nnw_file',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                       CALL cl_err3("upd","nnw_file",p_existno,"",SQLCA.sqlcode,"","up nnw_file",1) #No.FUN-660148
                       CALL s_errmsg('nnw01',p_existno,'up nnw_file',SQLCA.sqlcode,1)
#No.FUN-710024--end
                       LET g_success = 'N'
                   END IF
          WHEN '3'
                   #==>更新還息資料
                   UPDATE nnw_file 
                      SET nnw28 = NULL,
                          nnw29 = NULL
                    WHERE nnw01 = p_existno
                      AND nnw00 = '2'
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                      CALL cl_err('up nnw_file',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                       CALL cl_err3("upd","nnw_file:",p_existno,"",SQLCA.sqlcode,"","up nnw_file",1) #No.FUN-660148
                       CALL s_errmsg('nnw01',p_existno,'up nnw_file',SQLCA.sqlcode,1)
#No.FUN-710024--end
                       LET g_success = 'N'
                   END IF
     END CASE
END FUNCTION
 
#==>UPDATE 銀行存款異動記錄檔/分錄底稿單頭檔
#FUNCTION p940_t3(p_dbs,p_existno,p_npptype)  #No.FUN-680088 add p_npptype
FUNCTION p940_t3(l_plant,p_existno,p_npptype)   #FUN-A50102
  #DEFINE p_dbs        LIKE type_file.chr21   #No.FUN-680107 VARCHAR(21)#FUN-A50102
  DEFINE p_existno    LIKE nnv_file.nnv01   
  DEFINE p_npptype    LIKE npp_file.npptype  #No.FUN-680088 
  DEFINE l_plant      LIKE type_file.chr21    #FUN-A50102
  
 
     IF p_npptype = '0' THEN  #No.FUN-680088
        #==>更新銀行存款異動記錄檔
        #LET g_sql = " UPDATE ",p_dbs CLIPPED,"nme_file",
        LET g_sql = " UPDATE ",cl_get_target_table(l_plant,'nme_file'), #FUN-A50102
                    "    SET nme10 = NULL ,",
                    "        nme16 = NULL  ", 
                    "  WHERE nme12 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
        PREPARE upd_nme FROM g_sql
        EXECUTE upd_nme USING p_existno
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#No.FUN-710024--begin
#            CALL cl_err('upd nme:',SQLCA.sqlcode,1) 
           CALL s_errmsg('nme12',p_existno,'upd nme:',SQLCA.sqlcode,1)
#No.FUN-710024--end
            LET g_success = 'N'
        END IF
     END IF  #No.FUN-680088
 
#No.FUN-680088 --start-- mark
#    #==>分錄底稿單頭檔
#    LET g_sql = " UPDATE ",p_dbs CLIPPED,"npp_file",
#                "    SET npp03   = NULL ,",
#                "        nppglno = NULL ,", 
#                "        npp06   = NULL ,", 
#                "        npp07   = NULL  ", 
#                " WHERE npp01 = ? ",
#                "   AND npptype = '",p_npptype,"'"  #No.FUN-680088
#    PREPARE upd_npp FROM g_sql
#    EXECUTE upd_npp USING p_existno
#    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err('upd npp:',SQLCA.sqlcode,1) 
#        LET g_success = 'N'
#    END IF
#No.FUN-68008 --end--
END FUNCTION
 
#No.FUN-680088 --start--
#FUNCTION p940_t4(p_dbs,p_existno,p_npptype)
FUNCTION p940_t4(l_plant,p_existno,p_npptype)   #FUN-A50102
  #DEFINE p_dbs        LIKE type_file.chr21   #No.FUN-680107 VARCHAR(21)#FUN-A50102 
  DEFINE p_existno    LIKE nnv_file.nnv01   
  DEFINE p_npptype    LIKE npp_file.npptype  #No.FUN-680088
 DEFINE l_plant       LIKE type_file.chr21    #FUN-A50102 
  
     #==>分錄底稿單頭檔
     #LET g_sql = " UPDATE ",p_dbs CLIPPED,"npp_file",
     LET g_sql = " UPDATE ",cl_get_target_table(l_plant,'npp_file'), #FUN-A50102
                 "    SET npp03   = NULL ,",
                 "        nppglno = NULL ,", 
                 "        npp06   = NULL ,", 
                 "        npp07   = NULL  ", 
                 " WHERE npp01 = ? ",
                 "   AND npptype = '",p_npptype,"'"  #No.FUN-680088
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
     PREPARE upd_npp FROM g_sql
     EXECUTE upd_npp USING p_existno
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#No.FUN-710024--begin
#         CALL cl_err('upd npp:',SQLCA.sqlcode,1) 
        LET g_showmsg=p_existno,"/",p_npptype  
        CALL s_errmsg('npp01,npptype',g_showmsg,'upd npp:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
END FUNCTION
#No.FUN-680088 --end--

#No.FUN-D60110 ---Add--- Start
FUNCTION p940_existno_chk()
   DEFINE l_nnv01      LIKE nnv_file.nnv01
   DEFINE l_nnw01      LIKE nnw_file.nnw01

   CASE g_choice
      WHEN '1'
         LET tm.wc1 = cl_replace_str(tm.wc1,"existno","nnv01")
         LET g_sql = "SELECT '','',nnv05,nnv20,nnv34,nnv35,'','',nnv01", 
                     "  FROM nnv_file",
                     "  WHERE ",tm.wc1 CLIPPED
         PREPARE p940_nnv_prep FROM g_sql
         DECLARE p940_nnv_p CURSOR FOR p940_nnv_prep
         FOREACH p940_nnv_p INTO g_carry.*,l_nnv01
            IF STATUS THEN
              #無此張單據!請重新輸入!
               CALL s_errmsg('sel nnv_file',l_nnv01,'',"anm-941",1) 
               LET g_success = 'N'
            ELSE
               IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
                 #此張單據未拋傳票,無法做傳票還原!請重新輸入!
                  CALL s_errmsg('sel nnv_file',l_nnv01,'',"anm-942",1) 
                  LET g_success = 'N'
               END IF
               CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
               CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
               IF g_aza.aza63 = 'Y' THEN
                  LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'),
                              "  WHERE npp01 = '",l_nnv01,"'",
                              "    AND npptype = '1' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
                  CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql 
                  PREPARE nnv_p3 FROM g_sql
                  DECLARE nnv_c3 CURSOR FOR nnv_p3
                  OPEN nnv_c3
                  FETCH nnv_c3 INTO g_carry.voucher_out_1
                  IF STATUS THEN
                     CALL s_errmsg('sel nnv_file',l_nnv01,'',"anm-941",1) 
                     LET g_success = 'N'
                  ELSE
                     IF cl_null(g_carry.voucher_out_1) THEN
                        CALL s_errmsg('sel nnv_file',l_nnv01,'',"anm-942",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
                  LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'),
                              "  WHERE npp01 = '",l_nnv01,"'",
                              "    AND npptype = '1' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
                  CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql 
                  PREPARE nnv_p4 FROM g_sql
                  DECLARE nnv_c4 CURSOR FOR nnv_p4
                  OPEN nnv_c4
                  FETCH nnv_c4 INTO g_carry.voucher_in_1
                  IF STATUS THEN
                         CALL s_errmsg('sel nnv_file',l_nnv01,'',"anm-941",1) 
                     LET g_success = 'N'
                  ELSE
                     IF cl_null(g_carry.voucher_in_1) THEN
                        CALL s_errmsg('sel nnv_file',l_nnv01,'',"anm-942",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
            END IF
         END FOREACH
      WHEN '2'
         LET tm.wc1 = cl_replace_str(tm.wc1,"existno","nnw01")
         LET g_sql = "SELECT '','',nnw05,nnw20,nnw28,nnw29,'','',nnw01", 
                       "  FROM nnw_file",
                       " WHERE ",tm.wc1 CLIPPED,
                       "   AND nnw00 = '1'" #還本
         PREPARE p940_nnw_prep1 FROM g_sql
         DECLARE p940_nnw_p1 CURSOR FOR p940_nnw_prep1
         FOREACH p940_nnw_p1 INTO g_carry.*,l_nnw01
            IF STATUS THEN
              #無此張單據!請重新輸入!
               CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-941",1) 
               LET g_success = 'N'
            ELSE
               IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
                 #此張單據未拋傳票,無法做傳票還原!請重新輸入!
                  CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-942",1) 
                  LET g_success = 'N'
               END IF
               CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
               CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
               IF g_aza.aza63 = 'Y' THEN
                  LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'),
                              "  WHERE npp01 = '",l_nnw01,"'",
                              "    AND npptype = '1' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
                  CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql
                  PREPARE nnw_p5 FROM g_sql
                  DECLARE nnw_c5 CURSOR FOR nnw_p5
                  OPEN nnw_c5
                  FETCH nnw_c5 INTO g_carry.voucher_out_1
                  IF STATUS THEN
                     CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-941",1) 
                     LET g_success = 'N'
                  ELSE
                     IF cl_null(g_carry.voucher_out_1) THEN
                        CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-942",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
                  LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'),
                              "  WHERE npp01 = '",l_nnw01,"'",
                              "    AND npptype = '1' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
                  CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql
                  PREPARE nnw_p6 FROM g_sql
                  DECLARE nnw_c6 CURSOR FOR nnw_p6
                  OPEN nnw_c6
                  FETCH nnw_c6 INTO g_carry.voucher_in_1
                  IF STATUS THEN
                     CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-941",1) 
                     LET g_success = 'N'
                  ELSE
                     IF cl_null(g_carry.voucher_in_1) THEN
                        CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-942",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
            END IF
         END FOREACH
      WHEN '3'
         LET tm.wc1 = cl_replace_str(tm.wc1,"existno","nnw01")
         LET g_sql = "SELECT '','',nnw05,nnw20,nnw28,nnw29,'','',nnw01", 
                       "  FROM nnw_file",
                       " WHERE ",tm.wc1 CLIPPED,
                       "   AND nnw00 = '2'" #還息
         PREPARE p940_nnv_prep2 FROM g_sql
         DECLARE p940_nnv_p2 CURSOR FOR p940_nnv_prep2
         FOREACH p940_nnv_p2 INTO g_carry.*,l_nnw01
           IF STATUS THEN
               #無此張單據!請重新輸入!
               CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-941",1) 
               LET g_success = 'N'
           ELSE
               IF cl_null(g_carry.voucher_out) OR cl_null(g_carry.voucher_in) THEN
                   #此張單據未拋傳票,無法做傳票還原!請重新輸入!
               CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-942",1) 
               LET g_success = 'N'
               END IF
               CALL s_getdbs_curr(g_carry.plant_out) RETURNING g_carry.dbs_out
               CALL s_getdbs_curr(g_carry.plant_in ) RETURNING g_carry.dbs_in
               IF g_aza.aza63 = 'Y' THEN
                  LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_out,'npp_file'),
                              "  WHERE npp01 = '",l_nnw01,"'",
                              "    AND npptype = '1' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_carry.plant_out) RETURNING g_sql 
                  PREPARE nnw_p7 FROM g_sql
                  DECLARE nnw_c7 CURSOR FOR nnw_p7
                  OPEN nnw_c7
                  FETCH nnw_c7 INTO g_carry.voucher_out_1
                  IF STATUS THEN
                     CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-941",1) 
                     LET g_success = 'N'
                  ELSE
                     IF cl_null(g_carry.voucher_out_1) THEN
                        CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-942",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
                  LET g_sql = " SELECT nppglno FROM ",cl_get_target_table(g_carry.plant_in,'npp_file'),
                              "  WHERE npp01 = '",l_nnw01,"'",
                              "    AND npptype = '1' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_carry.plant_in) RETURNING g_sql
                  PREPARE nnw_p8 FROM g_sql
                  DECLARE nnw_c8 CURSOR FOR nnw_p8
                  OPEN nnw_c8
                  FETCH nnw_c8 INTO g_carry.voucher_in_1
                  IF STATUS THEN
                     CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-941",1) 
                     LET g_success = 'N'
                  ELSE
                     IF cl_null(g_carry.voucher_in_1) THEN
                        CALL s_errmsg('sel nnv_file',l_nnw01,'',"anm-942",1) 
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
            END IF
         END FOREACH
   END CASE
END FUNCTION
#No.FUN-D60110 ---Add--- End
