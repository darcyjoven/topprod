# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdp101.4gl
# Descriptions...: 已申報年月更新作業
# Date & Author..: 97/02/25 By Connie
# Modify.........: NO.MOD-490016 04/09/01 By Smapmin 修正為可切換語言
# Modify         : No.MOD-530869 05/03/30 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-5A0020 05/10/20 By Smapmin 當amd021='5'(AP),應更新apa173,apa174
# Modify.........: NO.MOD-5C0017 05/12/05 BY yiting 更新銷項發票的申報年月若不成功
#                  沒有同進項發票的處理:show error message & Rollback
# Modify.........: No.FUN-570123 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
 
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-720071 07/02/08 By Smapmin 修改錯誤訊息顯示
# Modify.........: No.MOD-740388 07/04/23 By Smapmin 已確認的資料才能更新申報年月
# Modify.........: No.TQC-760182 07/06/27 By chenl   申報部門增加開窗功能
# Modify.........: No.MOD-780253 07/08/27 By Smapmin 當amd021='5'(AP),應更新apa175
# Modify.........: No.MOD-830132 08/03/17 By Smapmin 修改SQL語法
# Modify.........: No.MOD-830114 08/03/17 By Smapmin 修改SQL語法
# Modify.........: No.MOD-830115 08/03/17 By Smapmin 跨期別申報時，會將已申報年月更新為目前申報年月
# Modify.........: No.MOD-870124 08/07/10 By Sarah CURSOR p101_a增加amd30='Y'條件
# Modify.........: No.MOD-960057 09/06/04 By baofei 重復begin work                                                                  
#                                                   UPDATE時用KEY去取代rowid
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990070 09/09/08 By Sarah 應回寫oma_file
# Modify.........: No.MOD-990143 09/09/16 By mike 修改amdp101.4gl,CURSOR p101_a的SQL, 
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)   
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
          ama01  LIKE ama_file.ama01,
          byy    LIKE type_file.num5,   #No.FUN-680074 SMALLINT
          bmm    LIKE type_file.num5,   #No.FUN-680074 SMALLINT
          eyy    LIKE type_file.num5,   #No.FUN-680074 SMALLINT
          emm    LIKE type_file.num5,   #No.FUN-680074 SMALLINT
          ama08  LIKE ama_file.ama08,
          ama09  LIKE ama_file.ama09
         END RECORD
DEFINE   g_azp RECORD LIKE azp_file.*
#DEFINE  g_row,g_col  SMALLINT               #No.FUN-680074
DEFINE   g_row,g_col  LIKE type_file.num5    #No.FUN-680074
DEFINE   l_flag          LIKE type_file.chr1,        #No.FUN-570123        #No.FUN-680074 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1         #No.FUN-680074        #是否有做語言切換 No.FUN-570123
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.byy  = ARG_VAL(1)
   LET tm.bmm  = ARG_VAL(2)
   LET tm.eyy  = ARG_VAL(3)
   LET tm.emm  = ARG_VAL(4)
   LET tm.ama01= ARG_VAL(5)
   LET tm.ama08= ARG_VAL(6)
   LET tm.ama09= ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)                #背景作業
   IF cl_null(g_bgjob)  THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B40028
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p101_tm(0,0)
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p101()
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
               CLOSE WINDOW p101_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p101()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
  # CALL cl_used('amdp101',g_time,2) RETURNING g_time   #No.FUN-6A0068  #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0068  #FUN-B30211
END MAIN
 
FUNCTION p101_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680074 SMALLINT
            l_cmd         LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(1000)
            l_ama         RECORD LIKE ama_file.*
   DEFINE   lc_cmd        LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(500)     #No.FUN-570123
 
   LET g_row = 6 LET g_col = 28
 
   OPEN WINDOW p101_w AT g_row,g_col WITH FORM "amd/42f/amdp101"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
 
   WHILE TRUE
      MESSAGE ""
      CALL ui.Interface.refresh()
      LET tm.byy=YEAR(g_today)
      LET tm.eyy=YEAR(g_today)
      LET tm.bmm=MONTH(g_today)
      LET tm.emm=MONTH(g_today)
      LET tm.ama08= tm.eyy
      LET tm.ama09= tm.emm
      LET g_bgjob = "N"             #NO.FUN-570123 By TSD.Martin
   
      INPUT BY NAME tm.ama01,tm.byy,tm.bmm,tm.eyy,tm.emm,tm.ama08,tm.ama09,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570123 
 
        ON ACTION locale       #MOD-490016開啟切換語言別功能
           LET g_change_lang = TRUE
           EXIT INPUT
 
 
         AFTER FIELD ama01
            IF cl_null(tm.ama01) THEN
               NEXT FIELD ama01
            ELSE
               SELECT * INTO l_ama.* from ama_file WHERE ama01 = tm.ama01 AND amaacti= 'Y'
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","ama_file",tm.ama01,"","amd-002","","",0)     #No.FUN-660093
                     NEXT FIELD ama01
                  END IF
            END IF
 
         AFTER FIELD byy
            IF cl_null(tm.byy) THEN
               NEXT FIELD byy
            END IF
 
         AFTER FIELD bmm
            IF cl_null(tm.bmm) THEN 
               NEXT FIELD bmm
            END IF
            IF tm.bmm > 12 OR tm.bmm < 1 THEN
               NEXT FIELD bmm
            END IF
 
         AFTER FIELD eyy
            IF cl_null(tm.eyy) THEN
               NEXT FIELD eyy
            END IF
            IF tm.eyy < tm.byy THEN
               NEXT FIELD eyy
            END IF
 
         AFTER FIELD emm
            IF cl_null(tm.emm) THEN
               NEXT FIELD emm
            END IF
            IF tm.emm > 12 OR tm.emm < 1 THEN 
               NEXT FIELD emm
            END IF
            LET tm.ama08= tm.eyy
            LET tm.ama09= tm.emm
            DISPLAY BY NAME tm.ama08,tm.ama09
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ama01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ama"
              LET g_qryparam.default1 = tm.ama01
              CALL cl_create_qry() RETURNING tm.ama01
              DISPLAY BY NAME tm.ama01
              NEXT FIELD ama01
            OTHERWISE
              EXIT CASE
         END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit      #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW p101_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
      END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "amdp101"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('amdp101','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.byy CLIPPED ,"'",
                         " '",tm.bmm CLIPPED ,"'",
                         " '",tm.eyy CLIPPED ,"'",
                         " '",tm.emm CLIPPED ,"'",
                         " '",tm.ama01 CLIPPED ,"'",
                         " '",tm.ama08 CLIPPED ,"'",
                         " '",tm.ama09 CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('amdp101',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
    EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p101()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680074 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                      # RDSQL STATEMENT        #No.FUN-680074
          l_chr     LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_flag    LIKE type_file.chr1,         #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_amd     RECORD LIKE amd_file.*,
          l_cnt     LIKE type_file.num5          #MOD-740388
 
#  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068 #FUN-B40028 mark
   LET g_success = 'Y'
   DECLARE p101_a CURSOR FOR
      SELECT amd_file.* FROM amd_file    #MOD-960057
       WHERE amd22 = tm.ama01
         AND amd173 BETWEEN tm.byy AND tm.eyy
         AND amd174 BETWEEN tm.bmm AND tm.emm
         AND amd175 IS NOT NULL   # 已取流水號   #MOD-830132
         AND (amd26 is null OR amd26='' OR amd26=0)     #MOD-830115 #MOD-990143 add amd26=0    
         AND (amd27 is null OR amd27='' OR amd27=0)   #MOD-830115  #MOD-990143 add amd27=0   
         AND amd30 = 'Y'   #已確認   #MOD-870124 add
 
   FOREACH p101_a INTO l_amd.*  #MOD-960057  
      IF SQLCA.sqlcode THEN
         CALL cl_err('p101_a',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      SELECT azp03 INTO g_azp.azp03 FROM azp_file
       WHERE azp01=l_amd.amd25
      IF STATUS THEN
         CALL cl_err3("sel","azp_file",l_amd.amd25,"",status,"","database not fount",0)   #No.FUN-660093
         LET g_success='N'
         EXIT FOREACH
      END IF
###### -----------------------------------------------
      #---->1.1 更新媒體已申報年度月份
      UPDATE amd_file SET amd26 = tm.ama08,amd27 = tm.ama09
       WHERE amd01 = l_amd.amd01
         AND amd02 = l_amd.amd02
         AND amd021= l_amd.amd021   #MOD-960057  
         AND amd30 = 'Y'   #MOD-740388
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","amd_file",l_amd.amd01,l_amd.amd02,SQLCA.sqlcode,"","up amd_file",0)    #No.FUN-660093
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #---->1.2 更新銷項資料
      IF l_amd.amd021 = '3' THEN
         LET l_cnt = 0
         #LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring(g_azp.azp03 CLIPPED),"oma_file",
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_amd.amd25,'oma_file'), #FUN-A50102
                     " WHERE oma01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102            
         PREPARE pre_count_oma FROM l_sql
         EXECUTE pre_count_oma INTO l_cnt 
         IF l_cnt > 0 THEN 
            #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"oma_file",
            LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'oma_file'), #FUN-A50102
                      "   SET oma173=",tm.ama08,",",
                      "       oma174=",tm.ama09,",",
                      "       oma175=",l_amd.amd175,
                      " WHERE oma01 ='",l_amd.amd01,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102          
            PREPARE pre_upd_oma FROM l_sql
            EXECUTE pre_upd_oma
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","oma_file",l_amd.amd01,"",SQLCA.sqlcode,"","up oma_file",0)
                LET g_success = 'N'
                EXIT FOREACH
            END IF
         END IF
         LET l_cnt = 0
         #LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring(g_azp.azp03 CLIPPED),"ome_file",   #FUN-940025
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_amd.amd25,'ome_file'), #FUN-A50102
                     " WHERE ome01 ='",l_amd.amd03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102            
         PREPARE pre_count_ome FROM l_sql
         EXECUTE pre_count_ome INTO l_cnt 
         IF l_cnt > 0 THEN 
            #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"ome_file",  #FUN-940025
            LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'ome_file'), #FUN-A50102
                      "   SET ome173=",tm.ama08,",",
                      "       ome174=",tm.ama09,",",
                      "       ome175=",l_amd.amd175,
                      " WHERE ome01 ='",l_amd.amd03,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102          
            PREPARE pre_upd_ome FROM l_sql
            EXECUTE pre_upd_ome
###### -----------------------------------------------
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","ome_file",l_amd.amd03,"",SQLCA.sqlcode,"","up ome_file",0)    #MOD-720071
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF   #MOD-740388
      END IF
      #---->1.3 更新進項資料  (apa)
      IF l_amd.amd021 = '2' THEN
         #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"apa_file",   #FUN-940025
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'apa_file'), #FUN-A50102
                   "   SET apa173=",tm.ama08,",",
                   "       apa174=",tm.ama09,",",
                   "       apa175=",l_amd.amd175,
                   " WHERE apa01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102           
         PREPARE pre_upd_apa FROM l_sql
         EXECUTE pre_upd_apa
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","apa_file",l_amd.amd01,"",SQLCA.sqlcode,"","up apa_file",0)    #MOD-720071
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
      #---->1.4 更新進項資料 (apk)
      IF l_amd.amd021 = '5' THEN
         #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"apk_file",   #FUN-940025
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'apk_file'), #FUN-A50102
                   "   SET apk173=",tm.ama08,",",
                   "       apk174=",tm.ama09,",",
                   "       apk175=",l_amd.amd175,
                   " WHERE apk01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102          
         PREPARE pre_upd_apk FROM l_sql
         EXECUTE pre_upd_apk
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","apk_file",l_amd.amd01,"",SQLCA.sqlcode,"","up apk_file",0)    #MOD-720071
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"apa_file",   #FUN-940025
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'apa_file'), #FUN-A50102
                   "   SET apa173=",tm.ama08,",",
                   "       apa174=",tm.ama09,",",
                   "       apa175=",l_amd.amd175,   #MOD-780253
                   " WHERE apa01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102          
         PREPARE pre_upd_apa2 FROM l_sql
         EXECUTE pre_upd_apa2
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","apa_file",l_amd.amd01,"",SQLCA.sqlcode,"","up apa_file",0)    #MOD-720071
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
   #--->1.4 更新申報稅籍
   IF g_success = 'Y' THEN
      UPDATE ama_file SET ama08 = tm.ama08,ama09 = tm.ama09
       WHERE ama01 = tm.ama01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ama_file",tm.ama01,"",SQLCA.sqlcode,"","up ama_file",0)    #No.FUN-660093
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
