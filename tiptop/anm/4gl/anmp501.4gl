# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmp501.4gl
# Descriptions...: 付款單拋轉還原作業
# Date & Author..: 96/11/18 By Apple
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-960141 09/06/26 By dongbg GP5.2修改:增加類型欄位1:付款 2:退款
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE type         LIKE nmd_file.nmd40          #FUN-9601441
DEFINE np_no        LIKE nmd_file.nmd01
DEFINE g_dbs_py	    STRING         #No.FUN-680107 VARCHAR(21)
DEFINE g_nmd10      LIKE nmd_file.nmd10
DEFINE g_nmd101     LIKE nmd_file.nmd101
DEFINE g_nmd34      LIKE nmd_file.nmd34
DEFINE g_sql        STRING                       #No.FUN-580092 HCN   
DEFINE g_flag  	    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE g_change_lang  LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #是否有做語言切換 No.FUN-570127
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
MAIN 
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE l_flag       LIKE type_file.chr1          #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570127 --start--
  INITIALIZE g_bgjob_msgfile TO NULL
  LET np_no   = ARG_VAL(1)
  LET type    = ARG_VAL(2)    #FUN-960141 add
  LET g_bgjob = ARG_VAL(3)    #背景作業   #FUN-960141 modify
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
 
     CALL  cl_used(g_prog,g_time,1)  # 計錄各程式實際被執行的狀況 #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
#NO.FUN-570127 mark--
#   LET p_row = 5 LET p_col = 30
#   OPEN WINDOW p501 AT p_row,p_col WITH FORM "anm/42f/anmp501" 
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('z')
 
#   CALL p501()
#   CLOSE WINDOW p501
#NO.FUN-570127  mark--
 
#NO.FUN-570127 start--
   WHILE TRUE
     IF g_bgjob = "N" THEN
        CALL p501_ip()
        IF cl_sure(18,20) THEN
           LET g_success = 'Y'
           BEGIN WORK
           CALL p501()
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
              CLOSE WINDOW p501
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL p501()
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
#->No.FUN-570127 ---end---
  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION p501()
   DEFINE l_ans      LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 #NO.FUN-570127 mark--
#     WHILE TRUE  
#       LET g_flag = 'Y'
#       CALL p501_ip()
#
#      IF g_flag = 'N' THEN 
#         CONTINUE WHILE
#      END IF
#
#        IF INT_FLAG THEN 
#          LET INT_FLAG = 0
#          EXIT WHILE
#       END IF
#
#       IF cl_sure(0,0) THEN 
#
#          BEGIN WORK
 
#          LET g_success = 'Y'
#NO.FUN-570127 MARK--
 
          CALL p501_upd()
#NO.FUN-570127 mark--
#          IF g_success = 'Y' THEN 
#             COMMIT WORK
#             CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#          ELSE
#             ROLLBACK WORK
#             CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#          END IF 
#          IF g_flag THEN
#             CONTINUE WHILE
#          ELSE
#             EXIT WHILE
#          END IF
#       END IF
#     END WHILE
#NO.FUN-570127 mark--
 
END FUNCTION
 
FUNCTION p501_ip()
   DEFINE   l_cnt     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE   l_nmd02   LIKE nmd_file.nmd02
   DEFINE   l_nmd12   LIKE nmd_file.nmd12
   DEFINE   l_nmd30   LIKE nmd_file.nmd30
   DEFINE   lc_cmd    LIKE type_file.chr1000 #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
#->No.FUN-570127 --start--
   OPEN WINDOW p501 AT p_row,p_col WITH FORM "anm/42f/anmp501"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   LET type = "1"   #FUN-960141 add
   LET g_bgjob = "N"
   WHILE TRUE                                             
   LET g_action_choice = ""                              
#->No.FUN-570127 ---end---
 
   #INPUT BY NAME np_no WITHOUT DEFAULTS  
   #INPUT BY NAME np_no,g_bgjob  WITHOUT DEFAULTS    #NO.FUN-57012    #FUN-9601417
   INPUT BY NAME type,np_no,g_bgjob  WITHOUT DEFAULTS    #NO.FUN-570127    #FUN-960141
 
      #FUN-960141 add
      AFTER FIELD type
         IF NOT cl_null(type) THEN
            IF type NOT MATCHES '[12]' THEN
               NEXT FIELD type
            END IF
         ELSE
            NEXT FIELD type
         END IF    
      #FUN-960141 end
 
      AFTER FIELD np_no 
         IF NOT cl_null(np_no) THEN 
            SELECT nmd12,nmd30 INTO l_nmd12,l_nmd30 FROM nmd_file 
             WHERE nmd01 = np_no 
               AND nmd40 = type    #FUN-960141 add
            IF SQLCA.sqlcode THEN 
#              CALL cl_err(np_no,'anm-221',0)   #No.FUN-660148
               CALL cl_err3("sel","nmd_file",np_no,"","anm-221","","",0) #No.FUN-660148
               NEXT FIELD np_no
            END IF
            IF l_nmd12 != 'X' THEN 
               CALL cl_err(np_no,'anm-236',0) 
               NEXT FIELD np_no
            END IF
            IF l_nmd30 != 'N' THEN 
               CALL cl_err(np_no,'anm-237',0)
               NEXT FIELD np_no
            END IF
            IF l_nmd30 = 'X' THEN 
               CALL cl_err(np_no,'9024',0) 
               NEXT FIELD np_no
            END IF
            SELECT nmd10,nmd101,nmd34 INTO g_nmd10,g_nmd101,g_nmd34 FROM nmd_file WHERE nmd01 = np_no
            IF SQLCA.sqlcode THEN 
               LET g_nmd10 = ' '
               LET g_nmd101 = ' '
               LET g_nmd34 = ' '
#              CALL cl_err(np_no,'anm-221',0)   #No.FUN-660148
               CALL cl_err3("sel","nmd_file",np_no,"","anm-221","","",0) #No.FUN-660148
               NEXT FIELD np_no
            END IF
            LET g_plant_new = g_nmd34
            CALL s_getdbs()
            LET g_dbs_py = g_dbs_new 
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(np_no)
#              CALL q_nmd2(10,3,np_no,'X') RETURNING l_nmd02,np_no
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmd2"
               LET g_qryparam.where = " nmd40 = '",type,"' "  #FUN-960141 add
               LET g_qryparam.default1 = np_no
               LET g_qryparam.arg1 = "X"
               CALL cl_create_qry() RETURNING l_nmd02,np_no
               DISPLAY BY NAME np_no 
               NEXT FIELD np_no
         END CASE
 
      ON ACTION locale                    #genero
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE                    #NO.FUN-570127 
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
   
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570127 start---
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p501
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "anmp501"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('anmp501','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                     " '",np_no CLIPPED,"'",
                     " '",type CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('anmp501',g_time,lc_cmd CLIPPED)
     END IF
      CLOSE WINDOW p501
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
  END IF
  EXIT WHILE
END WHILE
#->No.FUN-570127 ---end---
END FUNCTION
   
FUNCTION p501_upd()
 
   #-->付款單號拋轉
   IF type = '1' THEN   #FUN-960141
      #LET g_sql="UPDATE ",g_dbs_py CLIPPED,"aph_file ",  # Update 傳票單頭有效碼
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aph_file'), #FUN-A50102
                "  SET aph09 = 'N' WHERE aph01=? AND aph02=?"
   #FUN-960141 add
   ELSE
      #LET g_sql="UPDATE ",g_dbs_py CLIPPED,"oob_file ",  # Update 傳票單頭有效碼
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oob_file'), #FUN-A50102
                "  SET oob20 = 'N' WHERE oob01=? AND oob02=?"
   END IF
   #End
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE p501_upd FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare aph_file/oob_file error !',SQLCA.sqlcode,1)  #FUN-960141 
      LET g_success = 'N' 
      RETURN
   END IF
 
   EXECUTE p501_upd USING g_nmd10,g_nmd101
   IF SQLCA.sqlcode THEN
      CALL cl_err('Upd. aph_file/oob_file error !',SQLCA.sqlcode,1)  #FUN-960141 
      LET g_success = 'N' 
      RETURN
   END IF
 
   #-->應付資料
   DELETE FROM nmd_file WHERE nmd01 = np_no 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('Del. nmd_file error !',SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("del","nmd_file",np_no,"",SQLCA.sqlcode,"","Del. nmd_file error !",1) #No.FUN-660148
      LET g_success = 'N' 
      RETURN
   END IF
 
   DELETE FROM nmf_file WHERE nmf01 = np_no AND nmf03='1'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('Del. nmf_file error !',SQLCA.sqlcode,1)   #No.FUN-660148
      CALL cl_err3("del","nmf_file",np_no,"",SQLCA.sqlcode,"","Del. nmf_file error !",1) #No.FUN-660148
      LET g_success = 'N' 
      RETURN
   END IF
 
END FUNCTION
