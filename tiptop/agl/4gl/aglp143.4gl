# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: aglp143.4gl
# Descriptions...: 內部管理傳票拋轉還原
# Date & Author..: 06/08/03 By Sarah
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No.FUN-A50102 10/06/07 By lutingting GP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實現 
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B40056 11/06/03 By guoch
# Modify.........: No.FUN-D40105 13/06/27 by lujh 憑證編號開窗可多選
# Modify.........: No.TQC-D60072 13/04/28 by lujh 報錯訊息要有憑證編號
# Modify.........: No:MOD-G30031 16/03/09 By doris 1.輸入時,傳票編號不允許打*號
#                                                  2.拋轉還原時多控卡不允許刪除不同來源碼的傳票

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       STRING  #No.FUN-580092 HCN  
DEFINE g_dbs_gl         LIKE type_file.chr21      #No.FUN-680098  VARCHAR(21)
DEFINE p_plant          LIKE azp_file.azp01       #No.FUN-680098  VARCHAR(12)
DEFINE p_bookno         LIKE aaa_file.aaa01
DEFINE gl_date		LIKE type_file.dat        #No.FUN-680098  DATE
DEFINE gl_yy,gl_mm      LIKE type_file.num5       #No.FUN-680098  SMALLINT
DEFINE g_existno	LIKE npp_file.nppglno     #No.FUN-680098  VARCHAR(16)
DEFINE p_row,p_col      LIKE type_file.num5       #No.FUN-680098  SMALLINT
DEFINE g_aaz84          LIKE aaz_file.aaz84       #還原方式 1.刪除 2.作廢 
DEFINE l_flag           LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1)
       g_change_lang    LIKE type_file.chr1,      #是否有做語言切換  #No.FUN-680098 VARCHAR(1) 
       g_flag           LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1)
       ls_date          STRING
DEFINE g_msg            LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(72)\
#FUN-D40105--add--str--
DEFINE l_time_t LIKE type_file.chr8  
DEFINE g_existno_str     STRING  
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING 
DEFINE tm   RECORD
            wc1         STRING
            END RECORD 
#FUN-D40105--add--end--
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0073
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant  = ARG_VAL(1)                      
   LET p_bookno = ARG_VAL(2)                      
   LET g_existno= ARG_VAL(3)                      
   LET g_bgjob  = ARG_VAL(4)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p143_ask()
         #FUN-D40105--add--str--
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         #FUN-D40105--add--end--
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            LET g_success = 'Y'
            #FUN-D40105--add--str--
            CALL p143_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D40105--add--end--
            CALL p143_t()
            CALL s_showmsg()   #FUN-D40105  add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CLOSE WINDOW p143_t_w9
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p143_t_w9
               CLOSE WINDOW p143_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p143_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #FUN-D40105  add
         CALL p143_existno_chk()  #FUN-D40105  add
         CALL p143_t()
         CALL s_showmsg()   #FUN-D40105  add
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p143_ask()
   DEFINE l_abapost,l_flag   LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)
   DEFINE l_aba19            LIKE aba_file.aba19 
   DEFINE l_abaacti          LIKE aba_file.abaacti
   DEFINE lc_cmd             LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(500)
 
   OPEN WINDOW p143_w AT p_row,p_col WITH FORM "agl/42f/aglp143" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   LET p_plant   = g_plant
   LET p_bookno  = g_aaz.aaz64
   LET g_existno = NULL
   LET g_bgjob = 'N'
 
   DISPLAY BY NAME p_plant,p_bookno,g_existno 
   DIALOG ATTRIBUTES(UNBUFFERED)  #FUN-D40105  add 
   #INPUT BY NAME p_plant,p_bookno,g_existno,g_bgjob WITHOUT DEFAULTS #FUN-D40105 mark
   INPUT BY NAME p_plant,p_bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)    #FUN-D40105 add
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_change_lang = TRUE
         #EXIT INPUT   #FUN-D40105  mark 
         EXIT DIALOG   #FUN-D40105  add 
 
      AFTER FIELD p_plant
         IF NOT cl_null(p_plant) THEN
            #FUN-990031--mod--str--    營運中心要控制在當前法人下
            #SELECT azp01 FROM azp_file WHERE azp01 = p_plant
            #IF STATUS THEN 
            #   CALL cl_err3("sel","azp_file",p_plant,"","mfg9142","","",1)
            #   NEXT FIELD p_plant 
            #END IF
            SELECT * FROM azw_file WHERE azw01 = p_plant AND azw02 = g_legal                                                           
            IF STATUS THEN                                                                                                             
               CALL cl_err3("sel","azw_file",p_plant,"","agl-171","","",1)                                                             
               NEXT FIELD p_plant                                                                                                      
            END IF                                                                                                                     
            #FUN-990031--mod--end 
 
            LET g_plant_new=p_plant
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new 
         END IF
 
      AFTER FIELD p_bookno
         IF NOT cl_null(p_bookno) THEN
            LET g_aaz.aaz64 = p_bookno
         END IF

      #FUN-D40105--mark--str--
      #AFTER FIELD g_existno
      #   IF NOT cl_null(g_existno) THEN 
      #      LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti ",
      #               #"  FROM ",g_dbs_gl,"aba_file",   #FUN-A50102
      #                "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
      #                " WHERE aba01 = ? AND aba00 = ? AND aba06='CC'"
 	  #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      #      PREPARE p143_t_p1 FROM g_sql
      #      DECLARE p143_t_c1 CURSOR FOR p143_t_p1
      #      IF STATUS THEN
      #         CALL cl_err('decl aba_cursor:',STATUS,0) 
      #         NEXT FIELD g_existno
      #      END IF
 
      #      OPEN p143_t_c1 USING g_existno,g_aaz.aaz64
      #      FETCH p143_t_c1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
      #                           l_abaacti 
      #      IF STATUS THEN
      #         CALL cl_err('sel aba:',STATUS,0) 
      #         NEXT FIELD g_existno
      #      END IF
 
      #      IF l_abaacti = 'N' THEN
      #         CALL cl_err('','mfg8001',1) 
      #         NEXT FIELD g_existno
      #      END IF
      #      IF l_abapost = 'Y' THEN
      #         CALL cl_err(g_existno,'aap-130',0)
      #         NEXT FIELD g_existno
      #      END IF
            
      #      #FUN-B50090 add begin-------------------------
      #      #重新抓取關帳日期
      #      SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
      #      #FUN-B50090 add -end--------------------------
      #      IF gl_date < g_sma.sma53 THEN 
      #         CALL cl_err(gl_date,'aap-027',0)
      #         NEXT FIELD g_existno
      #      END IF
      #      IF l_aba19 ='Y' THEN 
      #         CALL cl_err(gl_date,'aap-026',0)
      #         NEXT FIELD g_existno
      #      END IF
      #   END IF
      #FUN-D40105--mark--end--
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p143_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
            EXIT PROGRAM
         END IF
 
         LET l_flag='N'
         IF cl_null(p_plant)   THEN LET l_flag='Y' END IF
         IF cl_null(p_bookno)  THEN LET l_flag='Y' END IF
         #IF cl_null(g_existno) THEN LET l_flag='Y' END IF   #FUN-D40105 nark
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
        #得出總帳 database name
        #g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new    # 得資料庫名稱

      #FUN-D40105--mark--str--
      #ON ACTION CONTROLR
      #   CALL cl_show_req_fields()
 
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
 
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE INPUT
 
      #ON ACTION about        
      #   CALL cl_about()     
     
      #ON ACTION help         
      #   CALL cl_show_help() 
     
      #ON ACTION exit                            #加離開功能
      #   LET INT_FLAG = 1
      #   EXIT INPUT
   
      ##No.FUN-580031 --start--
      #ON ACTION qbe_select
      #   CALL cl_qbe_select()
 
      #ON ACTION qbe_save
      #   CALL cl_qbe_save()
      #No.FUN-580031 ---end---
      #FUN-D40105--add--end-- 
      ON ACTION CONTROLP           #FUN-D40105  add
 
   END INPUT

   #FUN-D40105--add--str--
   CONSTRUCT BY NAME  tm.wc1 ON g_existno
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

   AFTER FIELD g_existno
      IF tm.wc1 = " 1=1" THEN 
         CALL cl_err('','9033',0)
         NEXT FIELD g_existno 
      END IF  
     #MOD-G30031---add---str--
      IF GET_FLDBUF(g_existno) = "*" THEN
         CALL cl_err('','9089',1)
         NEXT FIELD g_existno
      END IF
     #MOD-G30031---add---end--
      CALL  p143_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(g_existno)
              LET g_existno_str = ''
              CALL q_aba01_1( TRUE, TRUE, p_plant,p_bookno,' ','CC')
              RETURNING g_existno_str   
              DISPLAY g_existno_str TO g_existno
              NEXT FIELD g_existno
         END CASE

   END CONSTRUCT

   INPUT BY NAME g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

   END INPUT 
   
   ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
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
         IF GET_FLDBUF(g_existno) = "*" THEN
            CALL cl_err('','9089',1)
            CONTINUE DIALOG 
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
   #FUN-D40105--add--end--
   
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p143_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "aglp143"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         #CALL cl_err('aglp143','9031',1) 
          CALL s_errmsg('','aglp143','','9031',1)   #FUN-D40105 add    
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant CLIPPED ,"'",
                      " '",p_bookno CLIPPED ,"'",
                      " '",g_existno CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('aglp143',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p143_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION p143_t()
   DEFINE l_npp	   	    RECORD LIKE npp_file.*
 
   IF g_bgjob = 'N' THEN  
      OPEN WINDOW p143_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
      LET g_success = 'Y'
      LET g_plant_new = p_plant
      CALL s_getdbs()
      LET g_dbs_gl = g_dbs_new 
 
      #還原方式為刪除/作廢
     #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",  #FUN-A50102
      LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
                  " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE aaz84_pre FROM g_sql
      DECLARE aaz84_cs CURSOR FOR aaz84_pre
 
      OPEN aaz84_cs 
      FETCH aaz84_cs INTO g_aaz84
      IF STATUS THEN 
         #CALL cl_err('sel aaz84',STATUS,1)         #FUN-D40105 mark
         CALL s_errmsg('','sel aaz84','',STATUS,1)  #FUN-D40105 add
         LET g_success = 'N'                        #FUN-D40105 add
         #RETURN
      END IF
   END IF
 
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
     #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",   #FUN-A50102
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                "   SET abaacti = 'N' ",    #FUN-A50102
                #" WHERE aba01 = ? AND aba00 = ? "     #FUN-D40105  mark
                " WHERE  aba00 = ? ",                  #FUN-D40105 add
                "   AND ",tm.wc1                       #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p143_updaba_p FROM g_sql
      #EXECUTE p143_updaba_p USING g_existno,g_aaz.aaz64  #FUN-D40105  mark
      EXECUTE p143_updaba_p USING g_aaz.aaz64             #FUN-D40105  add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)         #FUN-D40105 mark
         CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)  #FUN-D40105 add
         LET g_success = 'N'
         #RETURN                                               #FUN-D40105 mark
      END IF
   ELSE
      IF g_bgjob = 'N' THEN
         MESSAGE "Delete GL's Voucher body!"
         CALL ui.Interface.refresh()
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"   #FUN-A50102
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abb01")    #FUN-D40105  add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),   #FUN-A50102
                #" WHERE abb01=? AND abb00=?"    #FUN-A50102   #FUN-D40105  mark
                " WHERE  abb00 = ? ",            #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p143_2_p3 FROM g_sql
      #EXECUTE p143_2_p3 USING g_existno,g_aaz.aaz64   #FUN-D40105 mark
      EXECUTE p143_2_p3 USING g_aaz.aaz64              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abb)',SQLCA.sqlcode,1)          #FUN-D40105  mark
         CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)  #FUN-D40105  add
         LET g_success = 'N' 
         #RETURN                                           #FUN-D40105  mark
      END IF
      IF g_bgjob = 'N' THEN
         MESSAGE "Delete GL's Voucher head!"
         CALL ui.Interface.refresh()
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"   #FUN-A50102
      LET tm.wc1 = cl_replace_str(tm.wc1,"abb01","aba01")     #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                #" WHERE aba01=? AND aba00=?"     #FUN-A50102   #FUN-D40105  mark
                " WHERE  aba00 = ? ",            #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p143_2_p4 FROM g_sql
      #EXECUTE p143_2_p4 USING g_existno,g_aaz.aaz64   #FUN-D40105  mark
      EXECUTE p143_2_p4 USING g_aaz.aaz64              #FUN-D40105  add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del aba)',SQLCA.sqlcode,1)         #FUN-D40105 mark
         CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)  #FUN-D40105 add
         LET g_success = 'N' 
         #RETURN                                           #FUN-D40105 mark
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         #CALL cl_err('(del aba)','aap-161',1)         #FUN-D40105 mark
         CALL s_errmsg('','','(del aba)','aap-161',1)  #FUN-D40105 add
         LET g_success = 'N' 
         #RETURN                                       #FUN-D40105  mark
      END IF
      IF g_bgjob = 'N' THEN
         MESSAGE "Delete GL's Voucher desp!"
         CALL ui.Interface.refresh()
      END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"   #FUN-A50102
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","abc01")     #FUN-D40105 add
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'),   #FUN-A50102
                #" WHERE abc01=? AND abc00=?"    #FUN-A50102   #FUN-D40105 mark
                " WHERE  abc00=?",               #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p143_2_p5 FROM g_sql
      #EXECUTE p143_2_p5 USING g_existno,g_aaz.aaz64   #FUN-D40105 mark
      EXECUTE p143_2_p5 USING g_aaz.aaz64              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del abc)',SQLCA.sqlcode,1)         #FUN-D40105 mark
         CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)  #FUN-D40105 add
         LET g_success = 'N' 
         #RETURN                                           FUN-D40105 mark
      END IF
#FUN-B40056 -begin
      LET tm.wc1 = cl_replace_str(tm.wc1,"abc01","tic04")     #FUN-D40105 add 
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),   #FUN-A50102
                #" WHERE tic04=? AND tic00=?"    #FUN-A50102   #FUN-D40105 mark 
                " WHERE  tic00 =?",              #FUN-D40105 add
                "   AND ",tm.wc1                 #FUN-D40105 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE p143_2_p8 FROM g_sql
      #EXECUTE p143_2_p8 USING g_existno,g_aaz.aaz64   #FUN-D40105 mark 
      EXECUTE p143_2_p8 USING g_aaz.aaz64              #FUN-D40105 add
      IF SQLCA.sqlcode THEN
         #CALL cl_err('(del tic)',SQLCA.sqlcode,1)         #FUN-D40105 mark
         CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)  #FUN-D40105 add
         LET g_success = 'N' 
         #RETURN                                           #FUN-D40105 mark
      END IF     
#FUN-B40056 -end
   END IF
   IF g_bgjob = 'N' THEN
      MESSAGE "Delete GL's Voucher detail!"
      CALL ui.Interface.refresh()
   END IF  
   IF g_success = 'N' THEN RETURN END IF
 
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980003 add azoplant,azolegal
                 VALUES ('aglp143',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980003 add g_plant,g_legal
   #----------------------------------------------------------------------

   #FUN-D40105--add--str--
   IF g_aaz84 = '2' THEN
      LET tm.wc1 = cl_replace_str(tm.wc1,"aba01","nppglno")
   ELSE
      LET tm.wc1 = cl_replace_str(tm.wc1,"tic04","nppglno")
   END IF 
   #FUN-D40105--add--end--    
   #FUN-D40105--mark--str--
   #UPDATE npp_file SET npp03  = NULL,
   #                    nppglno= NULL,
   #                    npp06  = NULL,
   #                    npp07  = NULL 
   #              WHERE nppglno=g_existno
   #FUN-D40105--add--end--
   #FUN-D40105--add--str--
   LET g_sql = "UPDATE npp_file SET npp03  = NULL,nppglno= NULL,",
               "                    npp06  = NULL,npp07  = NULL ",
               " WHERE ",tm.wc1
   PREPARE p143_pre_1 FROM g_sql
   EXECUTE p143_pre_1
   #FUN-D40105--add--end--              
   IF STATUS THEN
      #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","(upd npp03)",1)  #FUN-D40105 mark
      CALL s_errmsg('','','npp_file',STATUS,1)  #FUN-D40105 add
      LET g_success='N'
      #RETURN
   END IF
END FUNCTION

FUNCTION p143_existno_chk()
   DEFINE   l_chk_bookno       LIKE type_file.num5    
   DEFINE   l_chk_bookno1      LIKE type_file.num5    
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01 
   DEFINE   l_aba00            LIKE aba_file.aba00
   DEFINE   l_aba06            LIKE aba_file.aba06   #MOD-G30031 add 
   DEFINE   l_aaa07            LIKE aaa_file.aaa07 
   DEFINE   l_npp00            LIKE npp_file.npp00 
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07     
   DEFINE   l_nppglno          LIKE npp_file.nppglno   
   DEFINE   l_cnt              LIKE type_file.num5    
   DEFINE   lc_cmd             LIKE type_file.chr1000 
   DEFINE   l_sql              STRING        
   DEFINE   l_cnt1             LIKE type_file.num5     
   DEFINE   l_aba20            LIKE aba_file.aba20 

   CALL s_showmsg_init()
   LET g_success = 'Y' 
   LET tm.wc1 = cl_replace_str(tm.wc1,"g_existno","aba01")
   LET g_sql="SELECT aba01,aba02,aba03,aba04,abapost,aba19,abaacti,aba06 ",   #MOD-G30031 add aba06
             "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),   
            #" WHERE aba00 = ? AND aba06='CC'",   #MOD-G30031 mark
             " WHERE aba00 = ? ",                 #MOD-G30031 add
             "   AND ",tm.wc1
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   
   PREPARE p143_t_p1 FROM g_sql
   DECLARE p143_t_c1 CURSOR FOR p143_t_p1
   IF STATUS THEN
      CALL s_errmsg('decl aba_cursor:','','',STATUS,1)
      LET g_success = 'N'
   END IF
 
   FOREACH p143_t_c1 USING g_aaz.aaz64
                      INTO l_aba01,gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
                           l_abaacti,l_aba06   #MOD-G30031 add l_aba06 
      IF STATUS THEN
         #CALL s_errmsg('sel aba:','','',STATUS,1)      #TQC-D60072 mark
         CALL s_errmsg('sel aba:',l_aba01,'',STATUS,1)  #TQC-D60072 add   
         LET g_success = 'N'
      END IF
 
      IF l_abaacti = 'N' THEN
         CALL s_errmsg('',l_aba01,'','mfg8001',1)
         LET g_success = 'N'
      END IF
      IF l_abapost = 'Y' THEN
         CALL s_errmsg('',l_aba01,'','aap-130',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---str--
      IF l_aba06 <> 'CC' THEN
         CALL s_errmsg('sel aba:',l_aba01,'','agl040',1)
         LET g_success = 'N'
      END IF
     #MOD-G30031---add---end--
            
      #重新抓取關帳日期
      SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
      IF gl_date < g_sma.sma53 THEN 
         CALL s_errmsg(gl_date,l_aba01,'','aap-027',1)
         LET g_success = 'N'
      END IF
      IF l_aba19 ='Y' THEN 
         CALL s_errmsg(gl_date,l_aba01,'','aap-026',1)
         LET g_success = 'N'
      END IF
   END FOREACH 
END FUNCTION 
