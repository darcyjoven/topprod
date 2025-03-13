# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrp601.4gl
# Descriptions...: 多營運中心MRP 需求量拋轉作業
# Date & Author..: No.FUN-630040 06/03/20 By Nicola
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-730119 07/03/30 By Nicola 1.mrp的需求數量為0時，不轉入
#                                                   2.需求工廠寫入錯誤
# Modify.........: No.TQC-740016 07/04 05 By Judy 語言功能失效
# Modify.........: No.TQC-940177 09/05/11 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.MOD-960035 09/07/07 By Smapmin 修改"已拋轉採購單，不可覆蓋！"的判斷條件
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/08 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-910088 11/11/28 By chenjing 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pnx          RECORD LIKE pnx_file.* 
DEFINE g_pnx01        LIKE pnx_file.pnx01
DEFINE g_mss_v        LIKE mss_file.mss_v
DEFINE g_del          LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
DEFINE g_wc,g_sql     STRING
DEFINE g_cnt          LIKE type_file.num10    #NO.FUN-680082 INTEGER
DEFINE g_msg          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(72)
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0076
 
   CALL p601_p1()
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0076
 
END MAIN
 
FUNCTION p601_p1()
   DEFINE l_flag      LIKE type_file.chr1         #NO.FUN-680082 SMALLINT
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01         #No.FUN-580031
 
   OPEN WINDOW p601_w WITH FORM "amr/42f/amrp601"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
 
      CLEAR FORM
 
      CONSTRUCT BY NAME g_wc ON azp01
      
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(azp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azp01
                  NEXT FIELD azp01
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
#TQC-740016.....begin
         ON ACTION locale
            CALL cl_dynamic_locale()
#TQC-740016.....end
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      LET g_del = "Y"
 
      INPUT g_mss_v,g_del,g_pnx01 WITHOUT DEFAULTS FROM mss_v,del,pnx01 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD pnx01
            IF NOT cl_null(g_pnx01) THEN
               SELECT * FROM geu_file
                WHERE geu01 = g_pnx01
                  AND geu00 = "4"
               IF STATUS THEN
#                  CALL cl_err(g_pnx01,"anm-027",0) #No.FUN-660107
                   CALL cl_err3("sel","geu_file",g_pnx01,"","anm-027","","",0)        #NO.FUN-660107
                  NEXT FIELD pnx01
               END IF
            END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pnx01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_geu"
                  LET g_qryparam.arg1 = "4"
                  LET g_qryparam.default1 = g_pnx01
                  CALL cl_create_qry() RETURNING g_pnx01
                  DISPLAY g_pnx01 TO pnx01
                  NEXT FIELD pnx01
               OTHERWISE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
#TQC-740016.....begin
         ON ACTION locale
            CALL cl_dynamic_locale()
#TQC-740016.....end
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      IF cl_sure(0,0) THEN
         CALL p601_p2()
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
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p601_w
 
END FUNCTION
 
FUNCTION p601_p2()
   DEFINE l_mss   RECORD LIKE mss_file.*
   DEFINE l_ima   RECORD LIKE ima_file.*
   DEFINE l_pnx   RECORD LIKE pnx_file.*
   DEFINE l_pny   RECORD LIKE pny_file.*
   DEFINE l_fac   LIKE pnx_file.pnx14
   DEFINE l_flag  LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
   DEFINE l_azp03 LIKE azp_file.azp03
   DEFINE l_azp01 LIKE azp_file.azp01   #No.TQC-730119
 
   LET g_sql = "SELECT azp01,azp03 FROM azp_file",   #No.TQC-730119
               " WHERE ",g_wc CLIPPED,
               "   AND azp01 IN ( SELECT zxy03 FROM zxy_file ",          #FUN-980092 GP5.2 add
               "                   WHERE zxy01 ='",g_user CLIPPED,"')"   #FUN-980092 GP5.2 add
 
   PREPARE p601_azppb FROM g_sql
   DECLARE azp_curs CURSOR FOR p601_azppb
  
   BEGIN WORK
   LET g_success = "Y"
 
   FOREACH azp_curs INTO l_azp01,l_azp03   #No.TQC-730119
      IF STATUS THEN
         CALL cl_err("azp_curs",STATUS,1)
         EXIT FOREACH
      END IF
    
      #--Begin FUN-980092 add--------
      LET g_plant_new = l_azp01  
      CALL s_gettrandbs()       ##FUN-980092 GP5.2 Modify #改抓Transaction DB
      #--End   FUN-980092 add--------
 
      LET g_sql = "SELECT mss_file.*,ima_file.* ",
#TQC-940177   --start 
                 #" FROM ",l_azp03 CLIPPED,".dbo.mss_file, ",
                 #         l_azp03 CLIPPED,".dbo.ima_file ",
                 #" FROM ",s_dbstring(l_azp03 CLIPPED),"mss_file, ", #FUN-980092 mark
                 # " FROM ",s_dbstring(g_dbs_tra CLIPPED),"mss_file, ", #FUN-980092 add
                 #          s_dbstring(l_azp03 CLIPPED),"ima_file ", 
                  " FROM ",cl_get_target_table(g_plant_new,'mss_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'ima_file'),     #FUN-A50102
#TQC-940177   --end   
                  " WHERE mss01 = ima01 ", 
                  "   AND ima913 = 'Y'",
                  "   AND mss_v = '",g_mss_v CLIPPED,"'" 
      
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  ##FUN-980092 GP5.2 add
      PREPARE p601_pb FROM g_sql
      DECLARE mss_curs CURSOR FOR p601_pb
     
      FOREACH mss_curs INTO l_mss.*,l_ima.*
         IF STATUS THEN
            CALL cl_err("mss_curs",STATUS,1)
            EXIT FOREACH
         END IF
      
         SELECT * INTO l_pnx.* FROM pnx_file
          WHERE pnx01 = g_pnx01
            AND pnx02 = "2"
            AND pnx03 = g_mss_v
            AND pnx04 = l_azp01   #No.TQC-730119
            AND pnx05 = g_mss_v
            AND pnx06 = l_mss.mss00
 
         IF STATUS THEN
         ELSE
            IF l_pnx.pnx19 = "Y" THEN
               LET g_msg = l_azp01,"+",g_mss_v   #No.TQC-730119
               CALL cl_err(g_msg,"amr-100",0)
               CONTINUE FOREACH
            END IF
 
            SELECT COUNT(*) INTO g_cnt FROM pny_file
             WHERE pny01 = l_pnx.pnx01
               AND pny02 = l_pnx.pnx02
               AND pny03 = l_pnx.pnx03
               AND pny04 = l_pnx.pnx04
               AND pny05 = l_pnx.pnx05
               AND pny06 = l_pnx.pnx06
               #AND pny22 IS NOT NULL   #MOD-960035
               #AND pny22 != " "   #MOD-960035
               AND pny21 IS NOT NULL   #MOD-960035
               AND pny21 != " "   #MOD-960035
            IF g_cnt > 0 THEN
               LET g_msg = l_azp01,"+",g_mss_v   #No.TQC-730119
               CALL cl_err(g_msg,"amr-004",0)
               CONTINUE FOREACH
            ELSE
               IF g_del = "Y" THEN
                  SELECT COUNT(*) INTO g_cnt FROM pny_file
                   WHERE pny01 = l_pnx.pnx01
                     AND pny02 = l_pnx.pnx02
                     AND pny03 = l_pnx.pnx03
                     AND pny04 = l_pnx.pnx04
                     AND pny05 = l_pnx.pnx05
                     AND pny06 = l_pnx.pnx06
                  IF g_cnt > 0 THEN
                     IF cl_confirm('amr-005')  THEN
                        DELETE FROM pny_file
                         WHERE pny01 = l_pnx.pnx01
                           AND pny02 = l_pnx.pnx02
                           AND pny03 = l_pnx.pnx03
                           AND pny04 = l_pnx.pnx04
                           AND pny05 = l_pnx.pnx05
                           AND pny06 = l_pnx.pnx06
                        IF STATUS THEN
#                           CALL cl_err("del pny err",STATUS,0) #No.FUN-660107
                            CALL cl_err3("del","pny_file",l_pnx.pnx01,l_pnx.pnx02,STATUS,"","del pny err",0)        #NO.FUN-660107
                           LET g_success = "N"
                        END IF
                        DELETE FROM pnx_file
                         WHERE pnx01 = l_pnx.pnx01
                           AND pnx02 = l_pnx.pnx02
                           AND pnx03 = l_pnx.pnx03
                           AND pnx04 = l_pnx.pnx04
                           AND pnx05 = l_pnx.pnx05
                           AND pnx06 = l_pnx.pnx06
                        IF STATUS THEN
#                           CALL cl_err("del pnx1 err",STATUS,0) #No.FUN-660107
                            CALL cl_err3("del","pnx_file",l_pnx.pnx01,l_pnx.pnx02,STATUS,"","del pnx1 err",0)        #NO.FUN-660107
                           LET g_success = "N"
                        END IF
                     ELSE
                        CONTINUE FOREACH
                     END IF
                  ELSE
                     DELETE FROM pnx_file
                      WHERE pnx01 = l_pnx.pnx01
                        AND pnx02 = l_pnx.pnx02
                        AND pnx03 = l_pnx.pnx03
                        AND pnx04 = l_pnx.pnx04
                        AND pnx05 = l_pnx.pnx05
                        AND pnx06 = l_pnx.pnx06
                        IF STATUS THEN
#                           CALL cl_err("del pnx2 err",STATUS,0) #No.FUN-660107
                            CALL cl_err3("del","pnx_file",l_pnx.pnx01,l_pnx.pnx02,STATUS,"","del pnx2 err",0)        #NO.FUN-660107
                           LET g_success = "N"
                        END IF
                  END IF 
               ELSE
                  CONTINUE FOREACH
               END IF 
            END IF
         END IF     
 
         LET g_pnx.pnx01 = g_pnx01
         LET g_pnx.pnx02 = "2"
         LET g_pnx.pnx03 = g_mss_v
         LET g_pnx.pnx04 = l_azp01   #No.TQC-730119
         LET g_pnx.pnx05 = g_mss_v
         LET g_pnx.pnx06 = l_mss.mss00
         LET g_pnx.pnx07 = l_mss.mss01
         LET g_pnx.pnx08 = l_mss.mss11
         LET g_pnx.pnx09 = l_mss.mss03
         LET g_pnx.pnx10 = l_ima.ima44
         LET g_pnx.pnx11 = 1
         IF g_pnx.pnx10 != l_ima.ima25 THEN
            CALL s_umfchk(g_pnx.pnx07,l_ima.ima25,g_pnx.pnx10) RETURNING l_flag,l_fac
            IF l_flag = "1" THEN
               LET l_fac = 1
            END IF
            LET g_pnx.pnx12 = l_mss.mss09 * l_fac
         ELSE
            LET g_pnx.pnx12 = l_mss.mss09
         END IF
         LET g_pnx.pnx12 = s_digqty(g_pnx.pnx12,g_pnx.pnx10)  #FUN-910088--add
         LET g_pnx.pnx13 = l_ima.ima907 
         IF g_pnx.pnx10 = g_pnx.pnx13 THEN
            LET g_pnx.pnx14 = 1
         ELSE
            CALL s_umfchk(g_pnx.pnx07,g_pnx.pnx10,g_pnx.pnx13) RETURNING l_flag,l_fac
            IF l_flag = "1" THEN
               LET g_pnx.pnx14 = 1
            ELSE
               LET g_pnx.pnx14 = l_fac
            END IF
         END IF 
         LET g_pnx.pnx15 = 0
         LET g_pnx.pnx16 = g_pnx.pnx10
         LET g_pnx.pnx17 = g_pnx.pnx11
         LET g_pnx.pnx18 = g_pnx.pnx12
         LET g_pnx.pnx19 = "N"
         LET g_pnx.pnx20 = 0
         LET g_pnx.pnxplant = g_plant #FUN-980004 add
         LET g_pnx.pnxlegal = g_legal #FUN-980004 add
      
         #-----No.TQC-730119-----
         IF g_pnx.pnx18 = 0 THEN
            CONTINUE FOREACH
         END IF
         #-----No.TQC-730119 END-----
 
         INSERT INTO pnx_file VALUES(g_pnx.*)
         IF STATUS THEN
#            CALL cl_err("ins pnx error","",0) #No.FUN-660107
             CALL cl_err3("ins","pnx_file",g_pnx.pnx01,g_pnx.pnx02,"","","ins pnx error",0)        #NO.FUN-660107
            LET g_success = "N"
         END IF
      
         UPDATE mss_file SET mss10 = "Y"
          WHERE mss00 = l_mss.mss00
            AND mss01 = l_mss.mss01
            AND mss02 = l_mss.mss02
            AND mss03 = l_mss.mss03
            AND mss_v = l_mss.mss_v
         IF STATUS THEN
#            CALL cl_err("upd mss err",STATUS,0) #No.FUN-660107
             CALL cl_err3("upd","mss_file",l_mss.mss01,l_mss.mss02,STATUS,"","upd mss err",0)        #NO.FUN-660107
            LET g_success = "N"
         END IF
      
      END FOREACH
   END FOREACH
 
END FUNCTION
 
 
