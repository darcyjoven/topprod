# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Descriptions...: 批量指定變更作業
# Pattern name...: artp101.4gl 
# Date & Author..: FUN-870006 08/11/20 By Sunyanchun
# Modify.........: NO.FUN-870100 09/08/25 By Cockroach 超市移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10073 10/01/07 By Cockroach 跨DB修改
# Modify.........: No.FUN-A10036 10/01/13 By bnlent 更新價格信息表處理邏輯
# Modify.........: No.FUN-A50102 10/07/14 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-A90074 10/10/11 By lilingyu 重新過單
# Modify.........: No.FUN-AA0037 10/10/21 By huangtao 修改p101_shop_method(）
# Modify.........: No.FUN-AB0039 10/11/12 By huangtao mod FUN-AA0037的bug
# Modify.........: No.MOD-B10197 10/11/25 By shenyang 
# Modify.........: No.MOD-B20065 11/02/17 By baogc 增加對輸入日期的控管，更改處理範圍為狀態碼為已核準(1)的資料，在策略更新的同時更新狀態碼
# Modify.........: No.MOD-B30401 11/03/14 By suncx 更新價格策略和自定價的同時更新已傳POS否欄位為N
# Modify.........: No.FUN-B30126 11/03/23 By huangtao 加上背景作業功能 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40103 11/05/04 By shiwuying 增加开价否栏位
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.TQC-B60122 11/06/16 By yangxf IF去掉SQLCA.sqlerrd[3] = 0
# Modify.........: No.TQC-BA0009 11/11/01 By pauline 修改背景處理寫法
# Modify.........: No.FUN-BB0070 11/11/14 By pauline 取消rtj05,判斷指定的策略中如不存在指定的料件，則以INSERT方式變更，如已經在，則UPDATE
# Modify.........: No.FUN-BC0076 11/12/27 By baogc 流通資料基礎化 -- 策略變更添加採購策略
# Modify.........: No.TQC-C20082 12/02/08 By baogc BUG修改
# Modify.........: No.FUN-C30261 12/03/27 By pauline 修改pos狀態
# Modify.........: No.FUN-C50036 12/05/22 By fanbj 更新arti122中的生效日期

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rtm           RECORD LIKE rtm_file.*    #TQC-A90074 
DEFINE g_rtj           RECORD LIKE rtj_file.*
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE g_cnt             LIKE type_file.num10
DEFINE g_i               LIKE type_file.num5
DEFINE g_flag            LIKE type_file.chr1
DEFINE g_msg             LIKE type_file.chr1000
DEFINE g_change_lang     LIKE type_file.chr1000
DEFINE l_ac              LIKE type_file.num5
DEFINE g_rec_b           LIKE type_file.num5
DEFINE g_sql             STRING
DEFINE g_date            LIKE rti_file.rti03
DEFINE g_org             LIKE type_file.chr1000
DEFINE g_rti01           LIKE type_file.chr1000
DEFINE g_rtm01           LIKE type_file.chr1000
DEFINE g_rti             DYNAMIC ARRAY OF RECORD
           status        LIKE type_file.chr1,
           rti01         LIKE rti_file.rti01,
           rti02         LIKE rti_file.rti02,
           rti03         LIKE rti_file.rti03,
           rtiplant        LIKE rti_file.rtiplant,
           azp02         LIKE azp_file.azp02
                         END RECORD
DEFINE g_count           LIKE type_file.num5
 
MAIN
   DEFINE l_flag   LIKE type_file.chr1
   DEFINE ls_date  STRING 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
#FUN-B30126 -------------STA
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_date = ARG_VAL(1)
   LET g_org  = ARG_VAL(2)
   LET g_rti01 = ARG_VAL(3)
   LET g_rtm01 = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5) 
   IF g_bgjob IS NULL THEN
      LET g_bgjob='N'
   END IF

#FUN-B30126 -------------END
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
  #TQC-C20082 Add Begin ---
   IF g_bgjob = 'Y' AND cl_null(g_date) THEN
      LET g_date = g_today
   END IF
  #TQC-C20082 Add End -----

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 5 LET p_col = 28
#TQC-BA0009 mark START 
#   OPEN WINDOW p101_w AT p_row,p_col WITH FORM "art/42f/artp101"
#      ATTRIBUTE (STYLE = g_win_style)
 
#   CALL cl_ui_init()
#TQC-BA0009 mark END
   CALL cl_opmsg('z')
 
   WHILE TRUE
     IF g_bgjob='N' THEN                           #FUN-B30126 add
        LET g_success = 'Y'
        CALL p101_p1()
        IF g_success = 'Y' THEN
           CALL cl_end2(1) RETURNING l_flag
           IF l_flag != 1 THEN
              EXIT WHILE
           END IF 
        ELSE
           IF g_success = 'N' THEN
              CALL cl_err('','abm-020',1)
           END IF
        END IF
        CLOSE WINDOW p101_w   #TQC-BA0009 add
#FUN-B30126 -------------STA
     ELSE
       LET g_success='Y'
       CALL p101_p2()                       
       EXIT WHILE       #TQC-BA0009 add    
     END IF
#FUN-B30126 -------------END
   END WHILE
#   CLOSE WINDOW p101_w   #TQC-BA0009 mark

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p101_p1()
  DEFINE li_result  LIKE type_file.num5,
         l_n       LIKE type_file.num5
  DEFINE tok       base.StringTokenizer
  DEFINE l_sql     STRING
  DEFINE lc_cmd LIKE type_file.chr1000         #FUN-B30126  add

#TQC-BA0009 add START
   OPEN WINDOW p101_w AT p_row,p_col WITH FORM "art/42f/artp101"
      ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
#TQC-BA0009 add END

  WHILE TRUE
     INPUT g_date,g_org,g_rti01,g_rtm01  
         FROM date,plant,rti01,rtm01
 
         BEFORE INPUT
            CALL cl_qbe_init()
            LET g_date = g_today
            DISPLAY g_date TO FORMONLY.date
 
#MOD-B20065 ADD-BEGIN---
         AFTER FIELD date
            IF NOT cl_null(g_date) THEN
               IF g_date > g_today THEN
                  CALL cl_err('','art-127',0)
                  NEXT FIELD date
               END IF
            END IF
#MOD-B20065 ADD-END-----

         AFTER FIELD plant
            IF cl_null(g_org) THEN          #MOD-B10197
               CALL cl_err('','art513',0)   #MOD-B10197
               NEXT FIELD plant             #MOD-B10197
            END IF                          #MOD-B10197               
            IF NOT cl_null(g_org) THEN
       #        IF g_org IS NOT NULL THEN           #TQC-BA0009 mark 
               IF NOT cl_null(g_rtm01) THEN         #TQC-BA0009 add
                  CALL p101_chkplant()
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD plant                 
                  END IF
                  LET l_sql = cl_replace_str(g_org,'|',"','")
                  LET l_sql = "('",l_sql,"')"
               END IF              
            END IF
#MOD-B10197--add--begin
         BEFORE FIELD rti01,rtm01
           IF cl_null(g_org) THEN 
               CALL cl_err('','art513',0)
               NEXT FIELD plant
           END IF
##MOD-B10197--add--end 
                
         AFTER INPUT 
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
         ON ACTION controlp
            CASE
               WHEN INFIELD(plant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_org
                  CALL cl_create_qry() RETURNING g_org
                  DISPLAY g_org TO FORMONLY.plant
                  NEXT FIELD plant
 
               WHEN INFIELD(rti01)
                  CALL p101_query('1') RETURNING g_rti01
                  DISPLAY g_rti01 TO FORMONLY.rti01
                  NEXT FIELD rti01
 
               WHEN INFIELD(rtm01)
                  CALL p101_query('2') RETURNING g_rtm01
                  DISPLAY g_rtm01 TO FORMONLY.rti01
                  NEXT FIELD rtm01
            END CASE
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about 
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

#FUN-B30126 -------------STA    
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS
        ON ACTION about
           CALL cl_about()
        ON ACTION help
           CALL cl_show_help()
        ON ACTION controlp
           CALL cl_cmdask()
        ON ACTION exit
           LET INT_FLAG=1
           EXIT INPUT
        ON ACTION qbe_save
           CALL cl_qbe_save()
        ON ACTION locale
           LET g_change_lang=TRUE
           EXIT INPUT
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p101_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
      END IF
#FUN-B30126 -------------END

      EXIT WHILE
  END WHILE
 
#FUN-B30126 -------------STA
   IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "artp101"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('artp101','9031',1)
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_date CLIPPED,"'",
                     " '",g_org CLIPPED,"'",
                     " '",g_rti01 CLIPPED,"'",
                     " '",g_rtm01 CLIPPED,"'",                    
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('artp101',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p101_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
     EXIT PROGRAM
   END IF
#FUN-B30126 -------------END
  IF cl_sure(18,20) THEN
     CALL p101_p2()
  ELSE
     LET g_success = 'K'
  END IF
 
END FUNCTION
 
 
FUNCTION p101_chkplant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_azp01         LIKE azp_file.azp01
DEFINE l_n             LIKE type_file.num5
DEFINE l_str           STRING
        LET g_errno = ''
        LET l_str = g_auth
        LET tok = base.StringTokenizer.createExt(g_org,"|",'',TRUE)
        WHILE tok.hasMoreTokens()
           LET l_ck = tok.nextToken()
           IF l_ck IS NULL THEN
               CONTINUE WHILE
           END IF
           SELECT azp01 INTO l_azp01
             FROM azp_file WHERE azp01 = l_ck
           IF SQLCA.sqlcode = 100 THEN
              LET g_errno = 'art-044'
              RETURN
           END IF
           LET l_n = l_str.getindexof(l_ck,1)
           IF l_n = 0 THEN
              LET g_errno = 'art-500'
              RETURN
           END IF
       END WHILE
END FUNCTION
 
 
FUNCTION p101_p2()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
 
   LET tok = base.StringTokenizer.createExt(g_org,"|",'',TRUE)
   LET g_cnt = 1
   
   BEGIN WORK
   CALL s_showmsg_init() #FUN-BC0076 Add
   LET g_success = 'Y' 
   LET g_count = 0
 
   #遍歷所有的機構
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN CONTINUE WHILE END IF
      
      #變更價格策略、商品策略
      CALL p101_p3(l_ck)    
      #更新自定價調整單
      CALL p101_p4(l_ck)     
   END WHILE
   
   CALL s_showmsg() #FUN-BC0076 Add

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#更新自定價調整單
FUNCTION p101_p4(p_org)
DEFINE p_org   LIKE azp_file.azp01
#DEFINE l_dbs   LIKE azp_file.azp01    #FUN-A50102 mark
DEFINE l_ck    LIKE type_file.chr50
DEFINE tok     base.StringTokenizer
DEFINE l_wc    LIKE type_file.chr1000
DEFINE l_rtm01 LIKE rtm_file.rtm01
DEFINE l_rtn03 LIKE rtn_file.rtn03   
DEFINE l_rtn04 LIKE rtn_file.rtn04
DEFINE l_rtn11 LIKE rtn_file.rtn11 
DEFINE l_rtn12 LIKE rtn_file.rtn12   
DEFINE l_rtn13 LIKE rtn_file.rtn13   
DEFINE l_rtn15 LIKE rtn_file.rtn15
DEFINE l_rtn18 LIKE rtn_file.rtn18 #FUN-C50036 add
DEFINE l_rtn17 LIKE rtn_file.rtn17 #FUN-B40103
DEFINE l_rth01 LIKE rth_file.rth01   
DEFINE l_rth02 LIKE rth_file.rth02 
DEFINE l_rthpos LIKE rth_file.rthpos #FUN-B40071
  
  #TQC-A10073 MARK&ADD -----------------------------------------
  #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_org
  #LET l_dbs = l_dbs||"."
#FUN-A50102 ---------------mark start--------------------
#  LET g_plant_new = p_org
#  CALL s_gettrandbs()
#  LET l_dbs = g_dbs_tra
#  LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-A50102 --------------mark end-----------------------
  #TQC-A10073 MARK&ADD -----------------------------------------
 
   LET g_sql = "SELECT * FROM rtg_file ",
               "   WHERE rtg01 = ? AND rtg02 = ? AND rtg04 = ? FOR UPDATE "
   LET g_sql=cl_forupd_sql(g_sql)

   DECLARE lock_rtg_cur CURSOR FROM g_sql
 
#  LET g_sql = "SELECT rtm01 FROM ",l_dbs,"rtm_file ",                        #FUN-A50102 mark
   LET g_sql = "SELECT rtm01 FROM ",cl_get_target_table(p_org,'rtm_file'),    #FUN-A50102 
               " WHERE rtmplant = '",p_org,"'",
               "   AND rtm03 = '",g_date,"'",
               "   AND rtm900 = '1' ",                        #MOD-B20065 ADD
               "   AND rtm02 = '2' ",
               "   AND rtmconf = 'Y' "
 
   IF g_rtm01 IS NOT NULL THEN
      LET tok = base.StringTokenizer.createExt(g_rtm01,"|",'',TRUE)
      LET l_wc = "('"
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         IF l_ck IS NULL THEN CONTINUE WHILE END IF
         LET l_wc = l_wc,l_ck,"','"
      END WHILE 
      LET l_wc = l_wc[1,LENGTH(l_wc)-2],") "
      LET g_sql = g_sql," AND rtm01 IN ",l_wc
   END IF
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql          #FUN-A50102
   PREPARE pre_sel_rtm FROM g_sql
   DECLARE curs_get_rtm CURSOR FOR pre_sel_rtm
 
   #找出該機構所有選擇的商品策略和價格策略
   FOREACH curs_get_rtm INTO l_rtm01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rtm01 IS NULL THEN CONTINUE FOREACH END IF 
     #LET g_sql = "SELECT rtn03,rtn04,rtn11,rtn12,rtn13,rtn15 FROM ",l_dbs,"rtn_file ",                         #FUN-A50102 mark
      #FUN-C50036--start mark------------------------
      #LET g_sql = "SELECT rtn03,rtn04,rtn11,rtn12,rtn13,rtn15,rtn17 FROM ",cl_get_target_table(p_org,'rtn_file'),     #FUN-A50102 #FUN-B40103
      #FUN-C50036--end mark--------------------------
      LET g_sql = "SELECT rtn03,rtn04,rtn11,rtn12,rtn13,rtn15,rtn17,rtn18 FROM ",cl_get_target_table(p_org,'rtn_file'), #FUN-C50036 add
                  " WHERE rtn01 = ? AND rtnplant = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql        #FUN-A50102
      PREPARE pre_sel_rtn FROM g_sql
      DECLARE cur_rtn CURSOR FOR pre_sel_rtn
     
      FOREACH cur_rtn USING l_rtm01,p_org 
                      #INTO l_rtn03,l_rtn04,l_rtn11,l_rtn12,l_rtn13,l_rtn15,l_rtn17 #FUN-B40103 #FUN-C50036 mark
                      INTO l_rtn03,l_rtn04,l_rtn11,l_rtn12,l_rtn13,l_rtn15,l_rtn17,l_rtn18      #FUN-C50036 add
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         
         IF l_rtn03 IS NULL THEN CONTINUE FOREACH END IF 
         IF l_rtn04 IS NULL THEN CONTINUE FOREACH END IF 
 
        #LET g_sql = "SELECT rth01,rth02 FROM ",l_dbs,"rth_file ",                         #FUN-A50102 mark
         LET g_sql = "SELECT rth01,rth02 FROM ",cl_get_target_table(p_org,'rth_file'),     #FUN-A50102
                     " WHERE rth01 = ? AND rth02 = ? AND rthplant = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql         #FUN-A50102
         PREPARE pre_sel_rth5 FROM g_sql
         EXECUTE pre_sel_rth5 USING l_rtn03,l_rtn04,p_org 
                               INTO l_rth01,l_rth02
         IF SQLCA.SQLCODE = 100 THEN
           #CALL cl_err(l_rtn03,'art-',1)                                 #FUN-BC0076 Mark
            CALL s_errmsg('rth01',l_rtn03,'sel rth_file',SQLCA.sqlcode,1) #FUN-BC0076 Add
            LET g_success = 'N'
            RETURN
         END IF
 
         IF l_rtn11 IS NULL THEN LET l_rtn11 = 0 END IF
         IF l_rtn12 IS NULL THEN LET l_rtn12 = 0 END IF
         IF l_rtn13 IS NULL THEN LET l_rtn13 = 0 END IF
         IF l_rtn15 IS NULL THEN LET l_rtn15 = 'N' END IF
         IF l_rtn17 IS NULL THEN LET l_rtn17 = 'N' END IF #FUN-B40103
 
         LET g_sql = "SELECT * FROM rth_file WHERE rth01 = ? ",
                     "   AND rth02 = ? AND rthplant = ? FOR UPDATE "
         LET g_sql=cl_forupd_sql(g_sql)

         DECLARE lock_rth_cur CURSOR FROM g_sql
         #檢查該資料是否已經被鎖
         OPEN lock_rth_cur USING l_rth01,l_rth02,p_org   
         IF SQLCA.sqlcode = "-243" THEN
           #CALL cl_err("open lock_rth_cur:",SQLCA.sqlcode,1)         #FUN-BC0076 Mark
            CALL s_errmsg('','','open lock_rth_cur:',SQLCA.sqlcode,1) #FUN-BC0076 Add
            LET g_success = 'N'
            CLOSE lock_rth_cur
            RETURN
         END IF      
        #FUN-B40071 --START--
        SELECT rthpos INTO l_rthpos FROM rth_file
         WHERE rth01 = l_rth01 AND rth02 = l_rth02 AND rthplant = p_org
        IF l_rthpos <> '1' THEN
           LET l_rthpos = '2'
        ELSE
           LET l_rthpos = '1'
        END IF        
        #FUN-B40071 --END--        
        #LET g_sql = "UPDATE ",l_dbs,"rth_file SET rth04 = ?,rth05 = ?,",             #FUN-A50102 mark
        
         LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rth_file')," SET",          #FUN-A50102
                     "                             rth04 = ?,rth05 = ?,",             #FUN-A50102
                     "                             rth06 = ?,rthacti = ?, ",
                     "                             rth08 = ?,rth09 = ?, ",            #FUN-C50036 add 
                     "                             rthpos= ?,rth07 = ? ",             #MOD-B30401 add #FUN-B40103 
                     "   WHERE rth01 = ? AND rth02 = ? AND rthplant = ? "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
         CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql         #FUN-A50102
         PREPARE pre_upd_rth5 FROM g_sql
         #FUN-C50036--start mark--------------------
         #EXECUTE pre_upd_rth5 USING l_rtn11,l_rtn12,l_rtn13,l_rtn15,l_rthpos,     #MOD-B30401 add 'N' for rthpos #FUN-B40071
         #                           l_rtn17,                                 #FUN-B40103
         #FUN-C50036--end mark--------------------------
         
         #FUN-C50036--start add------------------------------------------
         EXECUTE pre_upd_rth5 USING l_rtn11,l_rtn12,l_rtn13,l_rtn15,
                                    l_rtn18,g_date,l_rthpos,l_rtn17,
         #FUN-C50036--end add--------------------------------------------
                                    l_rth01,l_rth02,p_org   
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #CALL cl_err3("upd","rth_file",l_rth01,"",SQLCA.sqlcode,"","",1) #FUN-BC0076 Mark
            CALL s_errmsg('rth01',l_rth01,'upd rth_file',SQLCA.sqlcode,1)   #FUN-BC0076 Add
            LET g_success = 'N'
            RETURN 
         END IF
       #MOD-B20065 ADD-BEGIN---
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rtm_file')," SET rtm900 = '2'",
                        " WHERE rtm01= '",l_rtm01,"'"
            PREPARE pre_upd_rtm1 FROM g_sql
            EXECUTE pre_upd_rtm1
            IF SQLCA.sqlerrd[3]=0 THEN
               RETURN 0
            END IF
       #MOD-B20065 ADD-END-----
      END FOREACH
   END FOREACH
END FUNCTION
 
#變更價格策略、商品策略
FUNCTION p101_p3(p_org)
DEFINE p_org   LIKE azp_file.azp01
#DEFINE l_dbs   LIKE azp_file.azp01      #FUN-A50102
DEFINE l_ck    LIKE type_file.chr50
DEFINE tok     base.StringTokenizer
DEFINE l_wc    LIKE type_file.chr1000
DEFINE l_rti01 LIKE rti_file.rti01
DEFINE l_rtk02 LIKE rtk_file.rtk02
DEFINE l_rtk04 LIKE rtk_file.rtk04
DEFINE l_rtk05 LIKE rtk_file.rtk05
DEFINE l_flag  LIKE type_file.num5
 
  #TQC-A10073  MARK&ADD---------------------------------
  #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = p_org
  #LET l_dbs = l_dbs||"."
#FUN-A50102 ----------------mark start--------------------
#  LET g_plant_new = p_org
#  CALL s_gettrandbs()
#  LET l_dbs = g_dbs_tra
#  LET l_dbs = s_dbstring(l_dbs CLIPPED)
# #TQC-A10073  MARK&ADD---------------------------------  
#FUN-A50102 ---------------mark end------------------------
   LET g_sql = "SELECT rti01 ",
             # " FROM ",l_dbs,"rti_file ",                       #FUN-A50102 mark
               " FROM ",cl_get_target_table(p_org,'rti_file'),   #FUN-A50102
               " WHERE rtiplant = '",p_org,"'",
               "   AND rti03 ='",g_date,"'",
               "   AND rti02 = '2' ",
               "   AND rti900 = '1' ",  #TQC-C20082 Add
               "   AND rticonf = 'Y' "
 
#   IF g_rti01 IS NULL THEN    #TQC-BA0009 mark
   IF cl_null(g_rti01) THEN    #TQC-BA0009 add
      LET l_wc = " 1=1"
   ELSE  
      LET tok = base.StringTokenizer.createExt(g_rti01,"|",'',TRUE)
      LET g_cnt = 1
      LET l_wc = "('"
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         IF l_ck IS NULL THEN CONTINUE WHILE END IF
         LET l_wc = l_wc,l_ck,"','"
      END WHILE 
      LET l_wc = l_wc[1,LENGTH(l_wc)-2],") "
      LET g_sql = g_sql," AND rti01 IN ",l_wc
   END IF
 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql          #FUN-A50102
   PREPARE pre_sel_rti FROM g_sql
   DECLARE curs_get_rti CURSOR FOR pre_sel_rti
 
   #找出該機構所有選擇的商品策略和價格策略
   FOREACH curs_get_rti INTO l_rti01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rti01 IS NULL THEN CONTINUE FOREACH END IF 
      
    #FUN-BC0076 Mark&Add Begin ---
    #備註：變更策略邏輯寫至 artt100_sub.4gl 中
    #      調用方法：CALL t100_sub(p_no,p_org) 其中p_no為策略變更單號，p_org為營運中心
    ##LET g_sql = "SELECT rtk02,rtk04,rtk05 FROM ",l_dbs,"rtk_file ",                    #FUN-A50102 mark
    # LET g_sql = "SELECT rtk02,rtk04,rtk05 FROM ",cl_get_target_table(p_org,'rtk_file'),#FUN-A50102
    #             " WHERE rtk01 = ? AND rtkplant = ? "
    # CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
    # CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql      #FUN-A50102
    # PREPARE pre_rtk FROM g_sql
    # DECLARE cur_rtk CURSOR FOR pre_rtk
 
    # FOREACH cur_rtk USING l_rti01,p_org INTO l_rtk02,l_rtk04,l_rtk05
    #    IF l_rtk02 = '1' THEN   #商品策略
    #       IF l_rtk04 IS NULL THEN CONTINUE FOREACH END IF
    #      #CALL p101_shop_method(l_dbs,p_org,l_rti01,l_rtk04) RETURNING l_flag       #FUN-A50102 mark
    #       CALL p101_shop_method(p_org,l_rti01,l_rtk04) RETURNING l_flag             #FUN-A50102       
    #       IF l_flag = 0 THEN
    #          LET g_success = 'N'
    #          RETURN 
    #       END IF
    #    ELSE                  #價格策略
    #       IF l_rtk05 IS NULL THEN CONTINUE FOREACH END IF
    #      #CALL p101_price_method(l_dbs,p_org,l_rti01,l_rtk05) RETURNING l_flag     #FUN-A50102 mark
    #       CALL p101_price_method(p_org,l_rti01,l_rtk05) RETURNING l_flag           #FUN-A50102  
    #       IF l_flag = 0 THEN
    #          LET g_success = 'N'
    #          RETURN 
    #       END IF
    #    END IF
    #    LET g_count = g_count + 1
    # END FOREACH

    #備註：變更策略邏輯寫至 artt100_sub.4gl 中
    #      調用方法：CALL t100_sub(p_no,p_org) 其中p_no為策略變更單號，p_org為營運中心
     #TQC-C20082 Add Begin ---
      UPDATE rti_file SET rti900 = '2' WHERE rti01 = l_rti01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('','','upd rti_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
     #TQC-C20082 Add End -----
      CALL t100_sub(l_rti01,p_org)
    #FUN-BC0076 Mark&Add End -----
   END FOREACH
   
END FUNCTION
#取出策略變更單中所有的價格策略更改這些價格策略
#FUNCTION p101_price_method(p_dbs,p_org,p_no,p_method)   #FUN-A50012 mark
FUNCTION p101_price_method(p_org,p_no,p_method)          #FUN-A50102  
DEFINE p_org      LIKE azp_file.azp01        #機構
#DEFINE p_dbs      LIKE azp_file.azp01        #db_user   #FUN-A50102 mark 
DEFINE p_no       LIKE rti_file.rti01        #策略變更單單號
DEFINE p_method   LIKE rtk_file.rtk04        #價格策略
DEFINE l_n        LIKE type_file.num5
DEFINE l_rtj      RECORD    
          rtj03         LIKE rtj_file.rtj03,  
          rtj04         LIKE rtj_file.rtj04, 
   #       rtj05         LIKE rtj_file.rtj05,  #FUN-BB0070 mark
          rtj09         LIKE rtj_file.rtj09,         
          rtj10         LIKE rtj_file.rtj10,        
          rtj11         LIKE rtj_file.rtj11,
          rtj12         LIKE rtj_file.rtj12,  
          rtj13         LIKE rtj_file.rtj13,
          rtj14         LIKE rtj_file.rtj14,    
          rtj15         LIKE rtj_file.rtj15,   
          rtj16         LIKE rtj_file.rtj16,  
          rtj17         LIKE rtj_file.rtj17,
          rtj18         LIKE rtj_file.rtj18,
          rtj25         LIKE rtj_file.rtj25, #FUN-C50036 add
          rtj19         LIKE rtj_file.rtj19,   
          rtj23         LIKE rtj_file.rtj23, #FUN-B40103
          rtj20         LIKE rtj_file.rtj20
                   END RECORD
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_fac       LIKE type_file.num20_6
DEFINE l_flag      LIKE type_file.num5
DEFINE l_flag1     LIKE type_file.num5
DEFINE l_msg       LIKE type_file.chr1000
DEFINE l_rtg08     LIKE rtg_file.rtg08   #No.FUN-A10036 
DEFINE l_azp01     LIKE azp_file.azp01   #No.FUN-A10036 
DEFINE l_azp03     LIKE azp_file.azp03   #No.FUN-A10036 
DEFINE l_rtgpos    LIKE rtg_file.rtgpos  #No.FUN-B40071
 
#   LET g_sql = "SELECT rtj03,rtj04,rtj05,rtj09,rtj10,rtj11,rtj12,rtj13,",    #FUN-BB0070 mark
   LET g_sql = "SELECT rtj03,rtj04,rtj09,rtj10,rtj11,rtj12,rtj13,",     #FUN-BB0070 add 
               #"rtj14,rtj15,rtj16,rtj17,rtj18,rtj19,rtj23,rtj20 ",        #FUN-B40103 #FUN-C50036 mark
               "rtj14,rtj15,rtj16,rtj17,rtj18,rtj25,rtj19,rtj23,rtj20 ",               #FUN-C50036 add
              #" FROM ",p_dbs,"rtj_file ",                                #FUN-A50102 mark
               " FROM ",cl_get_target_table(p_org,'rtj_file'),            #FUN-A50102
               " WHERE rtj01 = ? AND rtj02 = ? AND rtjplant = ? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102 
   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql    #FUN-A50102
   PREPARE pre_sel_rtj1 FROM g_sql
   DECLARE curs_rtj1 CURSOR FOR pre_sel_rtj1
 
   FOREACH curs_rtj1 USING p_no,'2',p_org INTO l_rtj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_n = 0
     #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"rtg_file ",                        #FUN-A50102 mark
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_org,'rtg_file'),    #FUN-A50102
                  " WHERE rtg01 = ? AND rtg03 = ? AND rtg04 = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql       #FUN-A50102
      PREPARE pre_sel_rtg FROM g_sql
      EXECUTE pre_sel_rtg USING p_method,l_rtj.rtj04,l_rtj.rtj09 INTO l_n
 
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_rtj.rtj04
      LET l_flag = NULL
      LET l_fac = NULL 
      CALL s_umfchk(l_rtj.rtj04,l_rtj.rtj09,l_ima25) RETURNING l_flag,l_fac
      IF l_flag = 1 THEN 
         LET l_msg = l_rtj.rtj09 CLIPPED,'->',l_ima25 CLIPPED 
         CALL cl_err(l_msg CLIPPED,'aqc-500',1)
         RETURN 0
      END IF    
 
#      IF l_rtj.rtj05 = '1' THEN   #FUN-BB0070 mark
         IF l_n = 0 OR l_n IS NULL THEN     #價格策略中無該商品,新增 
           #LET g_sql = "SELECT MAX(rtg02)+1 FROM ",p_dbs,"rtg_file ",                        #FUN-A50102 mark
            LET g_sql = "SELECT MAX(rtg02)+1 FROM ",cl_get_target_table(p_org,'rtg_file'),    #FUN-A50102 
                        " WHERE rtg01 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql      #FUN-A50102 
            PREPARE pre_sel_rtg1 FROM g_sql
            EXECUTE pre_sel_rtg1 USING p_method INTO l_n
            IF l_n= 0 OR l_n IS NULL THEN LET l_n = 1 END IF 
 
           #LET g_sql = "INSERT INTO ",p_dbs,"rtg_file VALUES(",                              #FUN-A50102 mark
           #LET g_sql = "INSERT INTO ",cl_get_target_table(p_org,'rtg_file')," VALUES(",      #FUN-A50102   #FUN-C30261 mark
            LET g_sql = "INSERT INTO ",cl_get_target_table(p_org,'rtg_file'),                     #FUN-C30261 add
                        #" (rtg01,rtg02,rtg03,rtg04,rtg05,rtg06,rtg07,rtg08,rtg10,rtg09,rtgpos) ", #FUN-C30261 add  #FUN-C50036 mark
                        " (rtg01,rtg02,rtg03,rtg04,rtg05,rtg06,rtg07,rtg08,rtg10,rtg09,rtg11,rtg12,rtgpos) ",       #FUN-C50036 add
                        " VALUES(",                                                               #FUN-C30261 add
                        #"?,?,?,?,?, ?,?,?,?,?,?) "                #FUN-B40103                                      #FUN-C50036 mark
                        "?,?,?,?,?, ?,?,?,?,?,?,?,?) "                                                              #FUN-C50036 add
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql          #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql    #FUN-A50102
            PREPARE pre_ins_rtg FROM g_sql
            EXECUTE pre_ins_rtg USING p_method,l_n,l_rtj.rtj04,l_rtj.rtj09,
                                      l_rtj.rtj16,l_rtj.rtj17,l_rtj.rtj18,
                                     #l_rtj.rtj19,l_rtj.rtj23,l_rtj.rtj20,'N' #FUN-B40103  #FUN-C30261 mark
                                      #l_rtj.rtj19,l_rtj.rtj23,l_rtj.rtj20,'1' #FUN-B40103  #FUN-C30261 add         #FUN-C50036 mark
                                      l_rtj.rtj19,l_rtj.rtj23,l_rtj.rtj20,l_rtj.rtj25,g_date,'1'                    #FUN-C50036 add
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("ins","rtg_file",l_n,"",SQLCA.sqlcode,"","",0) 
               RETURN 0
            END IF
       #MOD-B20065 ADD-BEGIN---
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rti_file')," SET rti900 = '2'",
                        " WHERE rti01= '",p_no,"'"
            PREPARE pre_upd_rti1 FROM g_sql
            EXECUTE pre_upd_rti1
            IF SQLCA.sqlerrd[3]=0 THEN
               RETURN 0
            END IF
       #MOD-B20065 ADD-END-----
  #FUN-BB0070 mark START
  #       END IF
  #    ELSE
  #       IF l_n <> 0 THEN
  #FUN-BB0070 mark END
       ELSE   #FUN-BB0070 add   #價格策略中有該商品,更改
            LET l_rtg08 = ''  #No.FUN-A10036                                                                                                 
           #LET g_sql = "SELECT rtg02,rtg08 FROM ",p_dbs,"rtg_file ",    #No.FUN-A10036      #FUN-A50102 mark
           #FUN-B40071 --START--
            LET g_sql = "SELECT rtg02,rtg08 FROM ",cl_get_target_table(p_org,'rtg_file'),    #FUN-A50102 
                        " WHERE rtg01 = ? AND rtg03 = ? AND rtg04 = ? "
           #FUN-B40071 --END--
            LET g_sql = "SELECT rtg02,rtg08,rtgpos FROM ",cl_get_target_table(p_org,'rtg_file'),    #FUN-A50102 
                        " WHERE rtg01 = ? AND rtg03 = ? AND rtg04 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql  #FUN-A50102
            PREPARE pre_sel_rtg2 FROM g_sql
            EXECUTE pre_sel_rtg2 USING p_method,l_rtj.rtj04,l_rtj.rtj09 
               INTO l_n,l_rtg08,l_rtgpos   #No.FUN-A10036 #FUN-B40071
            IF SQLCA.SQLCODE  THEN
               CALL cl_err('',SQLCA.sqlcode,0)                                                                                  
               RETURN 0     
            END IF
           
            OPEN lock_rtg_cur USING l_rtj.rtj09,l_rtj.rtj16,l_rtj.rtj17
            IF SQLCA.sqlcode = "-243" THEN
               CALL cl_err("open lock_rtg_cur:",SQLCA.sqlcode,1)
               RETURN 0
            END IF
            IF l_rtg08 IS NULL THEN LET l_rtg08 = 'N' END IF   #No.FUN-A10036
 
           #LET g_sql = "UPDATE ",p_dbs,"rtg_file SET rtg04 = ?,rtg05 = ?, ",                           #FUN-A50102 mark           
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rtg_file')," SET rtg04 = ?,rtg05 = ?, ",   #FUN-A50102
                        "   rtg06 = ?,rtg07 = ? ,rtg08 = ? ,rtg09 = ?, ",
                        "   rtg10 = ?, ",  #FUN-B40103
                        "   rtg11 = ?, rtg12 = ?, ",                 #FUN-C50036 add  
                        "   rtgpos= ?",    #MOD-B30401 add
                        "   WHERE rtg01 = ? AND rtg02 = ? AND rtg04 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql       #FUN-A50102
            PREPARE pre_upd_rtg2 FROM g_sql
            #FUN-B40071 --START--
            #EXECUTE pre_upd_rtg2 USING l_rtj.rtj09,l_rtj.rtj16,l_rtj.rtj17,
            #                           l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj23,l_rtj.rtj20,'N',    #MOD-B30401 add 'N' for rtgpos ##FUN-B40103
            #                           p_method,l_n,l_rtj.rtj09            
           #FUN-C30261 add START
            IF l_rtgpos <> '1' THEN
               LET l_rtgpos = '2'
            ELSE
               LET l_rtgpos = '1'
            END IF
           #FUN-C30261 add END
            EXECUTE pre_upd_rtg2 USING l_rtj.rtj09,l_rtj.rtj16,l_rtj.rtj17,
                                       #l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj23,l_rtj.rtj20,l_rtgpos,                   #FUN-C50036 mark
                                       l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj23,l_rtj.rtj20,l_rtj.rtj25,g_date,l_rtgpos, #FUN-C50036 add
                                       p_method,l_n,l_rtj.rtj09
            #FUN-B40071 --END--
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rtg_file",l_n,"",SQLCA.sqlcode,"","",0) 
               RETURN 0
            END IF
       #MOD-B20065 ADD-BEGIN---
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rti_file')," SET rti900 = '2'",
                        " WHERE rti01= '",p_no,"'"
            PREPARE pre_upd_rti2 FROM g_sql
            EXECUTE pre_upd_rti2
            IF SQLCA.sqlerrd[3]=0 THEN
               RETURN 0
            END IF
       #MOD-B20065 ADD-END----- 

            #更新價格信息表
            #No.FUN-A10036 ...begin
            #當價格策略中商品由允許自定價變更為不允許自定價時
            #則需在變更價格策略的同時，將使用此價格策略的各營
            #運中心自定價表中此商品記錄刪除 
            IF l_rtg08 = 'Y' AND l_rtj.rtj19 = 'N' THEN
               LET l_n =0
               LET g_sql = "SELECT DISTINCT rtz01 FROM rtz_file ",
                           "   WHERE rtz05 = '",p_method,"'"
               PREPARE pre_tqb FROM g_sql
               DECLARE cur_tqb CURSOR FOR pre_tqb
               FOREACH cur_tqb INTO l_azp01
               #FUN-A50102 -------------mark start----------------------
               #   LET g_plant_new = l_azp01
               #   CALL s_gettrandbs()
               #   LET l_azp03=g_dbs_tra
               #   LET l_azp03 = s_dbstring(l_azp03 CLIPPED)
               #FUN-A50102 -------------mark end------------------------
               #   LET g_sql = "SELECT COUNT(*) FROM ",l_azp03,"rth_file ",                      #FUN-A50102 mark
                   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_azp01,'rth_file'),  #FUN-A50102
                               "    WHERE rth01 = '",l_rtj.rtj04,"'",
                               "      AND rth02 = '",l_rtj.rtj09,"'",
                               "      AND rthplant ='",l_azp01,"' "      
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
                   CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102        
                   PREPARE pre_sel_rth FROM g_sql
                   EXECUTE pre_sel_rth INTO l_n
                   IF l_n IS NULL THEN LET l_n = 0 END IF
                   IF l_n != 0 THEN
                   #  LET g_sql = "DELETE FROM ",l_azp03,"rth_file ",                    #FUN-A50102 mark
                      LET g_sql = "DELETE FROM ",cl_get_target_table(l_azp01,'rth_file'),#FUN-A50102
                                  "    WHERE rth01 = '",l_rtj.rtj04,"'",
                                  "      AND rth02 = '",l_rtj.rtj09,"'",
                                  "      AND rthplant ='",l_azp01,"' "      
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql         #FUN-A50102
                      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-A50102     
                      PREPARE pre_del_rth FROM g_sql
                      EXECUTE pre_del_rth
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                       
                         CALL cl_err3("del","rth_file",l_rtj.rtj04,"",SQLCA.sqlcode,"","",1)
                         LET g_success='N'
                         RETURN 0 
                      END IF
                   END IF
               END FOREACH
            END IF
            #No.FUN-A10036 ...end
         END IF
  #    END IF   #FUN-BB0070 mark
   END FOREACH
 
#  LET g_sql = "UPDATE ",p_dbs,"rtf_file SET rtf04 = rtf04 + 1 WHERE rtf01 = ? "                             #FUN-A50102 mark
   LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rtf_file')," SET rtf04 = rtf04 + 1 WHERE rtf01 = ? "     #FUN-A50102 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102 
   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql       #FUN-A50102
   PREPARE pre_upd_rtf FROM g_sql
   EXECUTE pre_upd_rtf USING p_method
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rtf_file",p_method,"",SQLCA.sqlcode,"","",0) 
      RETURN 0
   END IF
   RETURN 1
END FUNCTION
 
#取出策略變更單中所有的商品策略更改這些商品策略
#FUNCTION p101_shop_method(p_dbs,p_org,p_no,p_method)    #FUN-A50102 mark
FUNCTION p101_shop_method(p_org,p_no,p_method)           #FUN-A50102  
DEFINE p_org      LIKE azp_file.azp01        #機構
#DEFINE p_dbs      LIKE azp_file.azp01        #db_user   #FUN-A50102 
DEFINE p_no       LIKE rti_file.rti01        #策略變更單單號
DEFINE p_method   LIKE rtk_file.rtk04        #商品策略
DEFINE l_ruh04    LIKE ruh_file.ruh04                           #FUN-AB0039
DEFINE l_ruh06    LIKE ruh_file.ruh06                           #FUN-AB0039
DEFINE l_rtepos   LIKE rte_file.rtepos                          #NO.FUN-B40071
DEFINE  l_rtj       RECORD
          rtj03         LIKE rtj_file.rtj03,                    #FUN-AB0039
          rtj04         LIKE rtj_file.rtj04,
  #        rtj05         LIKE rtj_file.rtj05,   #FUN-BB0070 mark
          rtj06         LIKE rtj_file.rtj06,
          rtj07         LIKE rtj_file.rtj07,
          rtj08         LIKE rtj_file.rtj08,
          rtj20         LIKE rtj_file.rtj20,
          rtj21         LIKE rtj_file.rtj21                        #FUN-AA0037
                    END RECORD
DEFINE l_n          LIKE type_file.num5
DEFINE l_n1          LIKE type_file.num5                          #FUN-AA0037
 
 #   LET g_sql = "SELECT rtj04,rtj05,rtj06,rtj07,rtj08,rtj20 ",          #FUN-AA0037  mark
#     LET g_sql = "SELECT rtj03,rtj04,rtj05,rtj06,rtj07,rtj08,rtj20,rtj21 ",          #FUN-AA0037   #FUN-AB0039 add rtj03  #FUN-BB0070 mark
     LET g_sql = "SELECT rtj03,rtj04,rtj06,rtj07,rtj08,rtj20,rtj21 ",       #FUN-BB0070 add
              #" FROM ",p_dbs,"rtj_file ",                               #FUN-A50102 mark
               " FROM ",cl_get_target_table(p_org,'rtj_file'),           #FUN-A50102   
               " WHERE rtj01 = ? AND rtj02 = '1' AND rtjplant = ? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql            #FUN-A50102  
   PREPARE pre_rtj FROM g_sql
   DECLARE cur_rtj CURSOR FOR pre_rtj
 
   FOREACH cur_rtj USING p_no,p_org INTO l_rtj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#FUN-AB0039 --------------STA
      LET g_sql ="SELECT ruh04 ,ruh06 FROM ",cl_get_target_table(p_org,'ruh_file'),
               " WHERE ruh01='",p_no,"'",
               " AND ruh02 = '",l_rtj.rtj03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
      CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql 
      PREPARE p101_sel_ruh FROM g_sql
      DECLARE ruh_cs CURSOR FOR p101_sel_ruh
#FUN-AB0039 --------------END
      #檢查變更單中的商品在商品策略中是否存在
      LET l_n = 0 
     #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs,"rte_file ",                       #FUN-A50102 mark
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_org,'rte_file'),   #FUN-A50102
                  " WHERE rte01 = ? AND rte03 = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql     #FUN-A50102
      PREPARE pre_rte FROM g_sql
      EXECUTE pre_rte USING p_method,l_rtj.rtj04 INTO l_n
      
#      IF l_rtj.rtj05 = '1' THEN             #新增  #FUN-BB0070 mark
         IF l_n = 0 OR l_n IS NULL THEN      #產品策略中無該商品,新增 
           #LET g_sql = "SELECT MAX(rte02)+1 FROM ",p_dbs,"rte_file ",                       #FUN-A50102 mark
            LET g_sql = "SELECT MAX(rte02)+1 FROM ",cl_get_target_table(p_org,'rte_file'),   #FUN-A50102
                        " WHERE rte01 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql     #FUN-A50102 
            PREPARE pre_sel_rte FROM g_sql
            EXECUTE pre_sel_rte USING p_method INTO l_n
            IF l_n = 0 OR l_n IS NULL THEN LET l_n = 1 END IF
 
           #LET g_sql = "INSERT INTO ",p_dbs,"rte_file VALUES(",               #FUN-A50102 mark
           #LET g_sql = "INSERT INTO ",cl_get_target_table(p_org,'rte_file')," VALUES(",  #FUN-A50102  #FUN-C30261 mark
            LET g_sql = "INSERT INTO ",cl_get_target_table(p_org,'rte_file'),                #FUN-C30261 add
                        " (rte01,rte02,rte03,rte04,rte05,rte06,rte07,rtepos,rte08,rte09) ",  #FUN-C30261 add
                        "  VALUES(",                                                         #FUN-C30261 add
     #                   "?,?,?,?,?, ?,?,?)"                                   #FUN-AA0037 mark
                         "?,?,?,?,?, ?,?,?,?,?)"                                   #FUN-AA0037
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql       #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql #FUN-A50102
            PREPARE pre_ins_rte FROM g_sql
            EXECUTE pre_ins_rte USING p_method,l_n,l_rtj.rtj04,l_rtj.rtj06,
     #                                 l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,'N'                     #FUN-A50102 mark
                                      #l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,'N',l_rtj.rtj21,'2'     #FUN-A50102 #FUN-C30261 mark
                                       l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,'1',l_rtj.rtj21,'2'     #FUN-C30261 add
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("ins","rte_file",l_n,"",SQLCA.sqlcode,"","",0) 
               RETURN 0
            END IF
#FUN-AA0037 ---------start
            FOREACH ruh_cs INTO l_ruh04,l_ruh06                                      #FUN-AB0039  
               LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_org,'rvy_file'),
                        " WHERE rvy01 = ?",
                        " AND rvy02 = ?"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
               CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql 
               PREPARE pre_sel_rvy FROM g_sql
               EXECUTE pre_sel_rvy USING p_method,l_n INTO l_n1
               IF l_n1 = 0 THEN
                  LET l_n1 = 1 
               ELSE
                  LET g_sql = " SELECT MAX(rvy03)+1 FROM ",cl_get_target_table(p_org,'rvy_file'),
                             " WHERE rvy01 = ?",
                             " AND rvy02 = ?"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql
                  PREPARE pre_sel_rvy1 FROM g_sql
                  EXECUTE pre_sel_rvy1 USING p_method,l_n INTO l_n1
               END IF
               LET g_sql = " INSERT INTO ",cl_get_target_table(p_org,'rvy_file'),
                           "(rvy01,rvy02,rvy03,rvy04,rvy05,rvy06)",
                           " VALUES( ?,?,?,?,?,?)"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql
               PREPARE pre_ins_rvy FROM g_sql
               EXECUTE pre_ins_rvy USING p_method,l_n,l_n1,l_ruh04,'2',l_ruh06
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("ins","rvy_file",l_n,"",SQLCA.sqlcode,"","",0)
                  RETURN 0
               END IF   
            END FOREACH                                                    #FUN-AB0039
       #MOD-B20065 ADD-BEGIN---
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rti_file')," SET rti900 = '2'",
                        " WHERE rti01= '",p_no,"'"
            PREPARE pre_upd_rti3 FROM g_sql
            EXECUTE pre_upd_rti3
            IF SQLCA.sqlerrd[3]=0 THEN
               RETURN 0
            END IF
       #MOD-B20065 ADD-END-----

#FUN-AA0037 ---------end
   #FUN-BB0070 mark START
   #      END IF  
   #   ELSE
   #      IF l_n <> 0 THEN
   #FUN-BB0070 mark END
       ELSE  #FUN-BB0070 add    #產品策略中有該商品,更改 
           #LET g_sql = "SELECT rte02 FROM ",p_dbs,"rte_file ",                      #FUN-A50102 mark
            LET g_sql = "SELECT rte02 FROM ",cl_get_target_table(p_org,'rte_file'),  #FUN-A50102
                        " WHERE rte01 = ? AND rte03 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql       #FUN-A50102
            PREPARE pre_sel_rte1 FROM g_sql
            EXECUTE pre_sel_rte1 USING p_method,l_rtj.rtj04 INTO l_n   #取項次

            #FUN-B40071 --START--
           #SELECT rtppos INTO l_rtepos FROM rte_file  #FUN-C30261 mark
            SELECT rtepos INTO l_rtepos FROM rte_file  #FUN-C30261 add 
             WHERE rte01 = p_method AND rte03 = l_rtj.rtj04
            #FUN-B40071 --END--
          
           #LET g_sql = "UPDATE ",p_dbs,"rte_file SET rte04 = ?,",         #FUN-A50102 mark
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rte_file')," SET rte04 = ?,",  #FUN-A50102
                        " rte05 = ?,rte06 = ?,rte07 = ?,",
                        " rtepos = ?,rte08 = ?,rte09 = ? ",          #FUN-AA0037
                        " WHERE rte01 = ? AND rte02 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql            #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql      #FUN-A50102
            PREPARE pre_upd_rte FROM g_sql
            #FUN-B40071 --START--
            #EXECUTE pre_upd_rte USING l_rtj.rtj06,l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,
            #                          'N',l_rtj.rtj21,'2',           #FUN-AA0037
            #                          p_method,l_n
            IF l_rtepos <> '1' THEN            
               LET l_rtepos = '2'
            ELSE
               LET l_rtepos = '1'
            END IF            
            EXECUTE pre_upd_rte USING l_rtj.rtj06,l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,
                                      l_rtepos,l_rtj.rtj21,'2',           
                                      p_method,l_n
            
            #FUN-B40071 --END--
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN           
               CALL cl_err3("upd","rte_file",l_n,"",SQLCA.sqlcode,"","",0) 
               RETURN 0
            END IF
#FUN-AA0037  -------start
            LET g_sql = "DELETE FROM ",cl_get_target_table(p_org,'rvy_file'),
                        " WHERE rvy01 = ? AND rvy02 = ? "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql
             PREPARE pre_del_rvy FROM g_sql
             EXECUTE pre_del_rvy USING p_method,l_n 
#            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN          #No.TQC-B60122
             IF SQLCA.sqlcode THEN                                  #No.TQC-B60122
                CALL cl_err('',SQLCA.sqlcode,0)
                RETURN 0
             END IF
             FOREACH ruh_cs INTO l_ruh04,l_ruh06                             #FUN-AB0039 
                LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(p_org,'rvy_file'),
                        " WHERE rvy01 = ?",
                        " AND rvy02 = ?"
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql
                PREPARE pre_sel_rvy2 FROM g_sql
                EXECUTE pre_sel_rvy2 USING p_method,l_n INTO l_n1
                IF l_n1 = 0 THEN
                   LET l_n1 = 1
                ELSE
                   LET g_sql = " SELECT MAX(rvy03)+1 FROM ",cl_get_target_table(p_org,'rvy_file'),
                           " WHERE rvy01 = ?",
                           " AND rvy02 = ?"
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql
                   PREPARE pre_sel_rvy3 FROM g_sql
                   EXECUTE pre_sel_rvy3 USING p_method,l_n INTO l_n1
                END IF
                LET g_sql = " INSERT INTO ",cl_get_target_table(p_org,'rvy_file'),
                            "(rvy01,rvy02,rvy03,rvy04,rvy05,rvy06)",
                            " VALUES(?,?,?,?,?,?)"
                CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql
                PREPARE pre_ins_rvy1 FROM g_sql
                EXECUTE pre_ins_rvy1 USING p_method,l_n,l_n1,l_ruh04,'2',l_ruh06
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err('',SQLCA.sqlcode,0)
                   RETURN 0
                END IF
             END FOREACH                                        #FUN-AB0039 
       #MOD-B20065 ADD-BEGIN---
            LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rti_file')," SET rti900 = '2'",
                        " WHERE rti01= '",p_no,"'"
            PREPARE pre_upd_rti4 FROM g_sql
            EXECUTE pre_upd_rti4
            IF SQLCA.sqlerrd[3]=0 THEN
               RETURN 0
            END IF
       #MOD-B20065 ADD-END-----
#FUN-AA0037  -------end
         END IF
    #  END IF  #FUN-BB0070 mark
   END FOREACH  
   #更新商品策略變更序號
#  LET g_sql = "UPDATE ",p_dbs,"rtd_file SET rtd04 = rtd04 + 1 WHERE rtd01 = ? "                            #FUN-A50102 mark
   LET g_sql = "UPDATE ",cl_get_target_table(p_org,'rtd_file')," SET rtd04 = rtd04 + 1 WHERE rtd01 = ? "    #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql               #FUN-A50102
   CALL cl_parse_qry_sql(g_sql,p_org) RETURNING g_sql         #FUN-A50102 
   PREPARE pre_upd_rtd FROM g_sql
   EXECUTE pre_upd_rtd USING p_method
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rtd_file",p_method,"",SQLCA.sqlcode,"","",0) 
      RETURN 0
   END IF
 
   RETURN 1
END FUNCTION
FUNCTION p101_query(p_flag)
DEFINE p_flag     LIKE type_file.chr1
DEFINE l_no       LIKE type_file.chr1000
DEFINE l_i        LIKE type_file.num5
 
   IF g_org IS NULL THEN RETURN '' END IF
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p101_w1 AT p_row,p_col WITH FORM "art/42f/artp101_1"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL  p101_rti01(p_flag)   #MOD-B10197 
   CALL p101_b_fill(p_flag)
 
   INPUT ARRAY g_rti WITHOUT DEFAULTS FROM s_rti.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
      ON ACTION all
         FOR l_i = 1 TO g_rti.getLength()
             LET g_rti[l_i].status = 'Y'
         END FOR
      ON ACTION no_all   
         FOR l_i = 1 TO g_rti.getLength()
             LET g_rti[l_i].status = 'N'
         END FOR
   END INPUT
 
   IF INT_FLAG THEN
      CALL g_rti.clear() 
      CALL  p101_rti01(p_flag)   #MOD-B10197
      LET INT_FLAG = 0
      CLOSE WINDOW p101_w1
      RETURN ''
   END IF
   LET l_no = "1"
   FOR l_i = 1 TO g_rti.getLength()
       IF g_rti[l_i].rti01 IS NULL THEN CONTINUE FOR END IF
       IF g_rti[l_i].status = 'Y' THEN
          LET l_no = l_no,g_rti[l_i].rti01,"|"
       END IF
   END FOR
   
   IF LENGTH(l_no) > 1 THEN
      LET l_no = l_no[2,LENGTH(l_no)-1]
   ELSE
      LET l_no = ' '
   END IF
   CLOSE WINDOW p101_w1
   RETURN l_no
END FUNCTION
#MOD-B10197--add--begin
FUNCTION p101_rti01(p_flag)
DEFINE p_flag    LIKE type_file.chr1
DEFINE l_rti01   LIKE gae_file.gae04
DEFINE l_index   LIKE type_file.num5
DEFINE l_str     STRING

   SELECT gae04 INTO l_rti01 FROM gae_file
    WHERE gae01 = 'artp101_1'
      AND gae12 = 'std'
      AND gae02 = 'rti01'
      AND gae03 = g_lang

   LET l_str = l_rti01
   LET l_index = l_str.getIndexOf("/",1)
   CASE p_flag
      WHEN '1'
         CALL cl_set_comp_att_text("rti01",l_str.subString(1,l_index-1))
      WHEN '2'
         CALL cl_set_comp_att_text("rti01",l_str.subString(l_index+1,l_str.getLength()))
   END CASE
END FUNCTION
#MOD-B10197--add--end

FUNCTION p101_b_fill(p_flag)
DEFINE p_flag     LIKE type_file.chr1
DEFINE l_azp01    LIKE azp_file.azp01
#DEFINE l_dbs      LIKE azp_file.azp03   #FUN-A50102
DEFINE l_where    LIKE type_file.chr1000
 
   CALL p101_plant() RETURNING l_where
   LET g_sql = "SELECT azp01 FROM azp_file WHERE azp01 IN ",l_where
   PREPARE pre_azp3 FROM g_sql
   DECLARE cur_azp3 CURSOR FOR pre_azp3
 
   LET g_cnt = 1
   CALL g_rti.clear()
 
   FOREACH cur_azp3 INTO l_azp01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      IF l_azp01 IS NULL THEN CONTINUE FOREACH END IF
     #TQC-A10073 MARK&ADD -----------------------------
     #LET l_dbs = l_dbs||"."
#FUN-A50102 ------------------------mark start----------------------
#     LET g_plant_new = l_azp01
#     CALL s_gettrandbs()
#     LET l_dbs = g_dbs_tra
#     LET l_dbs = s_dbstring(l_dbs CLIPPED)
#FUN-A50102 ------------------------mark end-----------------------
     #TQC-A10073 MARK&ADD -----------------------------
      IF p_flag = '1' THEN
         LET g_sql = "SELECT 'N',rti01,rti02,rti03,rtiplant ",
                    #" FROM ",l_dbs,"rti_file ",                         #FUN-A50102 mark
                     " FROM ",cl_get_target_table(l_azp01,'rti_file'),   #FUN-A50102
                     " WHERE rtiplant = '",l_azp01,"'",
                     "   AND rti03 ='",g_date,"'",
                     "   AND rti900 = '1' ",                             #MOD-B20065 ADD
                     "   AND rti02 = '2' ",
                     "   AND rticonf = 'Y' "
      END IF
      IF p_flag = '2' THEN
         LET g_sql = "SELECT 'N',rtm01,rtm02,rtm03,rtmplant ",
                    #" FROM ",l_dbs,"rtm_file ",                         #FUN-A50102 mark                         
                     " FROM ",cl_get_target_table(l_azp01,'rtm_file'),   #FUN-A50102  
                     " WHERE rtmplant = '",l_azp01,"'",
                     "   AND rtm03 ='",g_date,"'",
                     "   AND rtm900 = '1' ",                             #MOD-B20065 ADD
                     "   AND rtm02 = '2' ",
                     "   AND rtmconf = 'Y' "
      END IF
   
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A50102 
      CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql   #FUN-A50102   
      PREPARE p101_rtm FROM g_sql
      DECLARE p101_curs CURSOR FOR p101_rtm
 
      FOREACH p101_curs INTO g_rti[g_cnt].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT azp02 INTO g_rti[g_cnt].azp02 FROM azp_file 
             WHERE azp01 = g_rti[g_cnt].rtiplant
         LET g_cnt = g_cnt + 1
      END FOREACH
   END FOREACH
 
   CALL g_rti.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   CALL p101_bp_refresh()
END FUNCTION
FUNCTION p101_bp_refresh()
   DISPLAY ARRAY g_rti TO s_rti.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
         EXIT DISPLAY
       ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
FUNCTION p101_plant()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_where         LIKE type_file.chr1000
 
   IF g_org IS NULL THEN RETURN '' END IF
 
   LET g_cnt = 1
   LET tok = base.StringTokenizer.createExt(g_org,"|",'',TRUE)
   LET l_where = "('"
   WHILE tok.hasMoreTokens()    
      LET l_ck = tok.nextToken()
      LET l_where = l_where,l_ck,"','"
   END WHILE
   LET l_where = l_where[1,LENGTH(l_where)-2],")"
 
   RETURN l_where
END FUNCTION
#FUN-870100
