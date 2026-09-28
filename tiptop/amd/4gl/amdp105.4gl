# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amdp105.4gl
# Descriptions...: 已申報年月更新作業
# Date & Author..: 97/02/25 By Connie
# Modify.........: No.FUN-570123 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-780253 07/08/27 By Smapmin 還原時將apa173/apa174/apa175清空
# Modify.........: No.MOD-830132 08/03/17 By Smapmin 修改SQL語法
# Modify.........: No.MOD-960054 09/06/04 By Sarah 將p105()裡的BEGIN WORK拿掉
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0011 09/11/03 By liuxqa s_dbstring修改。
# Modify.........: No.FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B30572 11/03/18 By Sarah amdp101在MOD-990070增加了回寫oma_file,故amdp105也應回寫oma_file

# Modify.........: No.FUN-B30211 11/04/01 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lastyy,g_lastmm  smallint
DEFINE tm  RECORD            
         ama01  LIKE ama_file.ama01,
         byy    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         bmm    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         eyy    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         emm    LIKE type_file.num5,       #No.FUN-680074 SMALLINT
         ama08  LIKE ama_file.ama08, 
         ama09  LIKE ama_file.ama09 
        END RECORD
DEFINE  g_azp RECORD LIKE azp_file.*
DEFINE  g_row,g_col  LIKE type_file.num5                      #No.FUN-680074 SMALLINT
DEFINE  l_flag          LIKE type_file.chr1,                  #No.FUN-570123        #No.FUN-680074 VARCHAR(1)
        g_change_lang   LIKE type_file.chr1                   #No.FUN-680074 VARCHAR(1) #是否有做語言切換 No.FUN-570123
 
MAIN
#     DEFINEl_time  LIKE type_file.chr8        #No.FUN-6A0068
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
#->No.FUN-570123 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.byy  = ARG_VAL(1)
   LET tm.bmm  = ARG_VAL(2)
   LET tm.eyy  = ARG_VAL(3)
   LET tm.emm  = ARG_VAL(4)
   LET tm.ama01= ARG_VAL(5)
   LET tm.ama08= ARG_VAL(6)
   LET tm.ama09= ARG_VAL(7)
   LET g_bgjob = ARG_VAL(8)                #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570123 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570123 --start--------
     #CALL cl_used('amdp105',g_time,1) RETURNING g_time   #No.FUN-6A0068   #FUN-B30211
      CALL cl_used(g_prog,g_time,1) RETURNING g_time      #No.FUN-6A0068   #FUN-B30211

#   LET tm.byy = ARG_VAL(1)
#   LET tm.bmm = ARG_VAL(2)
#   LET tm.eyy = ARG_VAL(3)
#   LET tm.emm = ARG_VAL(4)
#   LET g_row = 6 LET g_col = 15
 
#   OPEN WINDOW p105_w AT g_row,g_col WITH FORM "amd/42f/amdp105" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#   CALL p105_tm(0,0)        
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p105_tm(0,0)
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p105()
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
               CLOSE WINDOW p105_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p105()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #CALL cl_used('amdp105',g_time,2) RETURNING g_time  #No.FUN-6A0068   #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-6A0068   #FUN-B30211
#->No.FUN-570123 ---end---
 
END MAIN
 
FUNCTION p105_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680074 SMALLINT
            l_cmd         LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(1000)
            l_ama         RECORD LIKE ama_file.*
   DEFINE   lc_cmd        LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(500)    #No.FUN-570123
 
#->No.FUN-570123 ---start---
   LET p_row = 6 LET p_col = 28
 
   OPEN WINDOW p105_w AT g_row,g_col WITH FORM "amd/42f/amdp105"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
#->No.FUN-570123 ---end---
 
   WHILE TRUE
      MESSAGE ""
      CALL ui.Interface.refresh()
      CALL cl_opmsg('p')
      INITIALIZE tm.* TO NULL        
 
      LET tm.byy=YEAR(g_today)
      LET tm.eyy=YEAR(g_today)
      LET tm.bmm=MONTH(g_today)
      LET tm.emm=MONTH(g_today)
      LET tm.ama08= tm.eyy
      LET tm.ama09= tm.emm
      LET g_bgjob = "N"             #NO.FUN-570123 
 
      #INPUT BY NAME tm.ama01,tm.byy,tm.bmm,tm.eyy,tm.emm,tm.ama08,tm.ama09 WITHOUT DEFAULTS 
      INPUT BY NAME tm.ama01,tm.byy,tm.bmm,tm.eyy,tm.emm,tm.ama08,tm.ama09,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570123 
       ON ACTION locale
#           CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_change_lang = TRUE                #NO.FUN-570123 
             EXIT INPUT
 
 
         AFTER FIELD ama01
            IF cl_null(tm.ama01) THEN
               NEXT FIELD ama01  
            ELSE
               SELECT * INTO l_ama.* from ama_file WHERE ama01 = tm.ama01 AND amaacti= 'Y'
                  IF SQLCA.sqlcode THEN 
 #                    CALL cl_err(tm.ama01,'amd-002',0)   #No.FUN-660093
                     CALL cl_err3("sel","ama_file",tm.ama01,"","amd-002","","",0)   #No.FUN-660093
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit      #加離開功能genero
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
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p105_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
    #->No.FUN-570123 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "amdp105"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('amdp105','9031',1)
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
            CALL cl_cmdat('amdp105',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p105_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
    EXIT WHILE
   END WHILE
 
#      IF cl_sure(21,21) THEN
#         CALL cl_wait()
#         CALL p105()
#         ERROR ""
#      END IF
#   END WHILE
 
#   CLOSE WINDOW p105_w
#NO.FUN-570123 mark--------------
END FUNCTION
 
FUNCTION p105()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680074 VARCHAR(20)  # External(Disk) file name
#         l_time    LIKE type_file.chr8           #No.FUN-6A0068
          l_sql     STRING,                       # RDSQL STATEMENT        #No.FUN-680074
          l_flag    LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
          l_chr     LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_amd     RECORD LIKE amd_file.*,
          l_cnt     LIKE type_file.num5           #MOD-B30572 add
 
#  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-570123   #No.FUN-6A0068
     
   LET g_lastmm = tm.ama09 - 1
   IF g_lastmm = 0 THEN 
      LET g_lastyy = tm.ama08 -1
      LET g_lastmm = 12
   ELSE
      LET g_lastyy = tm.ama08
   END IF 
 
   LET g_success = 'Y'
  #BEGIN WORK    #MOD-960054 mark
   DECLARE p105_a CURSOR FOR  
      SELECT amd_file.* FROM amd_file
       WHERE amd22 = tm.ama01
         AND amd173 BETWEEN tm.byy AND tm.eyy
         AND amd174 BETWEEN tm.bmm AND tm.emm 
         #AND (amd175 IS NOT NULL OR amd175 <> ' ')  # 已取流水號   #MOD-830132
         AND amd175 IS NOT NULL   # 已取流水號   #MOD-830132
 
   FOREACH p105_a INTO l_amd.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('p105_a',SQLCA.sqlcode,0)
         EXIT FOREACH 
      END IF
## No:2354 modify 1998/07/13 -------------------------
      SELECT azp03 INTO g_azp.azp03 FROM azp_file
       WHERE azp01=l_amd.amd25
      IF STATUS THEN 
    #    CALL cl_err('database not fount',status,0)  #No.FUN-660093
         CALL cl_err3("sel","azp_file",l_amd.amd25,"",STATUS,"","database not fount",0)   #No.FUN-660093
         LET g_success='N'
         EXIT FOREACH
      END IF
###### -----------------------------------------------

      #---->1.1 更新媒體已申報年度月份
      UPDATE amd_file SET amd26 = ''      ,amd27 = ''
       WHERE amd01 = l_amd.amd01 AND amd02 = l_amd.amd02 AND amd021 = l_amd.amd021 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #    CALL cl_err('up amd_file',SQLCA.sqlcode,0)   #No.FUN-660093
         CALL cl_err3("upd","amd_file",l_amd.amd01,l_amd.amd02,SQLCA.sqlcode,"","up amd_file",0)  #No.FUN-660093
         LET g_success = 'N'
         EXIT FOREACH 
      END IF

      #---->1.2 更新銷項資料
      IF l_amd.amd021 = '3' THEN 
        #str MOD-B30572 add
         LET l_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_amd.amd25,'oma_file'),
                     " WHERE oma01 ='",l_amd.amd01,"'"
         PREPARE pre_count_oma FROM l_sql
         EXECUTE pre_count_oma INTO l_cnt 
         IF l_cnt > 0 THEN 
            LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'oma_file'),
                      "   SET oma173='',oma174='',oma175=''",
                      " WHERE oma01 ='",l_amd.amd01,"'"
            PREPARE pre_upd_oma FROM l_sql
            EXECUTE pre_upd_oma
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","oma_file",l_amd.amd01,"",SQLCA.sqlcode,"","up oma_file",0)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
        #end MOD-B30572 add
## No:2354 modify 1998/07/13 -------------------------
        #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"ome_file ",  #TQC-9B0011 mod
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'ome_file'), #FUN-A50102
                   "   SET ome173='',ome174='',ome175=''",
                   " WHERE ome01 ='",l_amd.amd03,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      	 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102           
         PREPARE pre_upd_ome FROM l_sql
         EXECUTE pre_upd_ome
        #UPDATE ome_file SET ome173 = tm.ama08,ome174 = tm.ama09,
        #                    ome175 = l_amd.amd175
        #               WHERE ome01 = l_amd.amd03
###### -----------------------------------------------
        #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #    CALL cl_err('up ome_file',SQLCA.sqlcode,0)
        #    LET g_success = 'N'
        #    EXIT FOREACH 
        #END IF
      END IF

      #---->1.3 更新進項資料  (apa)
      IF l_amd.amd021 = '2' THEN 
## No:2354 modify 1998/07/13 -------------------------
        #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"apa_file ",   #TQC-9B0011 mod
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'apa_file'), #FUN-A50102
                   "   SET apa173='',apa174='',apa175=''",
                   " WHERE apa01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102               
         PREPARE pre_upd_apa FROM l_sql
         EXECUTE pre_upd_apa
        #UPDATE apa_file SET apa173 = tm.ama08,apa174 = tm.ama09,
        #                    apa175 = l_amd.amd175
        #              WHERE apa01 = l_amd.amd01
###### -----------------------------------------------
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('up apa_file',SQLCA.sqlcode,0)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
      END IF

      #---->1.4 更新進項資料 (apk)
      IF l_amd.amd021 = '5' THEN 
## No:     modify 1998/07/13 -------------------------
        #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"apk_file",   #TQC-9B0011 mod
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'apk_file'), #FUN-A50102
                   "   SET apk173='',apk174='',apk175=''",
                   " WHERE apk01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102              
         PREPARE pre_upd_apk FROM l_sql
         EXECUTE pre_upd_apk
        #UPDATE apk_file SET apk173 = tm.ama08,apk174 = tm.ama09,
        #                    apk175 = l_amd.amd175
        #              WHERE apk01 = l_amd.amd01
###### -----------------------------------------------
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('up apk_file',SQLCA.sqlcode,0)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
         #-----MOD-780253---------
        #LET l_sql="UPDATE ",s_dbstring(g_azp.azp03 CLIPPED),"apa_file",     #TQC-9B0011 mod
         LET l_sql="UPDATE ",cl_get_target_table(l_amd.amd25,'apa_file'), #FUN-A50102
                   "   SET apa173='',apa174='',apa175=''",
                   " WHERE apa01 ='",l_amd.amd01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	 CALL cl_parse_qry_sql(l_sql,l_amd.amd25) RETURNING l_sql #FUN-A50102          
         PREPARE pre_upd_apa2 FROM l_sql
         EXECUTE pre_upd_apa2
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('up apa_file',SQLCA.sqlcode,0)
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
         #-----END MOD-780253-----
      END IF
   END FOREACH 

   #--->1.4 更新申報稅籍, 還原時, 更新至上期. 
   IF g_success = 'Y' THEN 
      UPDATE ama_file SET ama08 = g_lastyy,ama09 = g_lastmm
       WHERE ama01 = tm.ama01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #   CALL cl_err('up ome_file',SQLCA.sqlcode,0)  #No.FUN-660093
         CALL cl_err3("upd","ama_file",tm.ama01,"",SQLCA.sqlcode,"","up ome_file",0)  #No.FUN-660093
         LET g_success = 'N'
      END IF
   END IF
#NO.FUN-570123 MARK--
#  IF g_success = 'Y' THEN
#     COMMIT WORK
#     CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#  ELSE
#     ROLLBACK WORK
#     CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#  END IF
#  IF l_flag THEN
#     CALL p105_tm(0,0)
#  ELSE
#     EXIT PROGRAM
#  END IF
#NO.FUN-570123 MARK---
 
END FUNCTION
