# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: aapp600.4gl
# Descriptions...: 账龄统计更新作业   
# Date & Author..: 11/06/01 by wujie  TQC-B50125
# Modify.........: No.MOD-B60211 11/06/24 By wujie 代码改错
# Modify.........: No.TQC-B60351 11/06/28 By wujie 应付部分增加apv的扣除，之前有sql写错
# Modify.........: No.TQC-B90102 11/09/16 By yinhy 動態彈窗q_qcc改為q_occ
# Modify.........: No.TQC-B90170 11/09/23 By wujie TQC-B60351
# Modify.........: No.FUN-C30260 12/03/22 By zhangweib 在SQL抓取資料時要過濾客戶/供應商為空的情況
# Modify.........: No.TQC-C30341 12/03/30 By zhangll 增加顯示产生筆數
# Modify.........: No.TQC-C30349 12/04/06 By lujh 將原幣資料一並統計放入統計檔（add alz10 幣別 varchar2(4),來源為apa13/oma23）
# Modify.........: No.MOD-C90152 12/09/21 By wujie  排除应付暂估资料
# Modify.........: No.MOD-CA0195 12/10/26 By yinhy 產生alz統計當的時候沒有考慮立賬時本幣直接衝賬金額（apc15）
# Modify.........: No.FUN-C80102 12/12/13 By zhangweib add alz12 varchar2(10),來源為apc03/omc03
#                                                      寫入統計檔時，零用金部份也要寫入
# Modify.........: No.MOD-D50117 13/05/14 By yinhy 查詢oox10時增加截止日期判斷
# Modify.........: No.FUN-D40121 13/05/30 By zhangweib 新增匯兌損益金額對應字段,給默認值
# Modify.........: No:TQC-D80007 13/08/07 By lujh 算alz09的時還要加上直接收款的金額

DATABASE ds
#TQC-B50125 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                          # Print condition RECORD
             wc      LIKE type_file.chr1000,
             alz00   LIKE alz_file.alz00,
             alz02   LIKE alz_file.alz02,
             alz03   LIKE alz_file.alz03
              END RECORD
    DEFINE l_flag    LIKE  type_file.chr1
    DEFINE g_sql     STRING
    DEFINE g_argv1   LIKE type_file.chr1
    DEFINE g_count   LIKE type_file.num10  #TQC-C30341 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function

   LET g_argv1 = ARG_VAL(1)       #AP/AR     
   IF cl_null(g_argv1) THEN EXIT PROGRAM END IF 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CONTINUE 
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
   IF g_argv1 ='1' THEN LET g_prog ='aapp600' ELSE LET g_prog ='axrp600' END IF  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE 
      CALL aapp600_tm()                    # Input print condition
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         CALL aapp600_p()         
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
            CLOSE WINDOW aapp600_w
            EXIT WHILE
         END IF
      ELSE
         CONTINUE WHILE
      END IF 
   END WHILE 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION aapp600_tm()
   DEFINE   l_cmd         LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
            l_flag        LIKE type_file.chr1               #是否必要欄位有輸入  #No.FUN-690028 VARCHAR(1)
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01 
 
   OPEN WINDOW aapp600_w WITH FORM "aap/42f/aapp600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL                      # Default condition 
 
   LET g_action_choice = ""
   DIALOG ATTRIBUTES(UNBUFFERED) 
      INPUT BY NAME tm.alz00,tm.alz02,tm.alz03 
         BEFORE INPUT 
            LET tm.alz00 = g_argv1
            LET tm.alz02 = YEAR(g_today)
            LET tm.alz03 = MONTH(g_today)
             

 
 
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入

      END INPUT
      CONSTRUCT BY NAME tm.wc ON alz01
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
 
      END CONSTRUCT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION CONTROLP
          CASE
              WHEN INFIELD(alz01)
                CALL cl_init_qry_var()
                IF tm.alz00 ='1' THEN 
                   LET g_qryparam.form ='q_pmc14'
                ELSE 
               	   #LET g_qryparam.form ='q_qcc'
               	   LET g_qryparam.form ='q_occ'  #TQC-B90102
                END IF 
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO alz01
          END CASE 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION accept
            EXIT DIALOG
      
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG 
       
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG 
   END DIALOG
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aapp600_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B30211
      EXIT PROGRAM   
   END IF
END FUNCTION
 
FUNCTION aapp600_p()
DEFINE l_sql     STRING
DEFINE l_apa     RECORD LIKE apa_file.*
DEFINE l_apc     RECORD LIKE apc_file.*
DEFINE l_oma     RECORD LIKE oma_file.*
DEFINE l_omc     RECORD LIKE omc_file.*
DEFINE l_aph05   LIKE  aph_file.aph05 
DEFINE l_aph05f  LIKE  aph_file.aph05f
DEFINE l_apg05   LIKE  apg_file.apg05 
DEFINE l_apg05f  LIKE  apg_file.apg05f
DEFINE l_aph05_n   LIKE  aph_file.aph05 
DEFINE l_apg05_n   LIKE  apg_file.apg05    
DEFINE l_alz     RECORD LIKE alz_file.*
DEFINE l_oob09   LIKE  oob_file.oob09
DEFINE l_oob09_n   LIKE  oob_file.oob09
DEFINE l_oob10   LIKE  oob_file.oob10  
DEFINE l_oox10   LIKE  oox_file.oox10  
DEFINE l_amt     LIKE  type_file.num20_6
DEFINE l_amtf    LIKE  type_file.num20_6
DEFINE l_wc      STRING
#No.TQC-B60351 --begin
DEFINE l_apv04   LIKE apv_file.apv04
DEFINE l_apv04_n LIKE apv_file.apv04
DEFINE l_apv04f  LIKE apv_file.apv04f
#No.TQC-B60351 --end
#FUN-D40121--add--str--
DEFINE l_amt_arf   LIKE omc_file.omc08
DEFINE l_amt_ar    LIKE omc_file.omc09
DEFINE l_amt_apf   LIKE apc_file.apc08
DEFINE l_amt_ap    LIKE apc_file.apc09
DEFINE l_apg05f_ap LIKE apg_file.apg05f
DEFINE l_apg05_ap  LIKE apg_file.apg05
DEFINE l_oob09_ar  LIKE oob_file.oob09
DEFINE l_oob10_ar  LIKE oob_file.oob10
DEFINE l_oob09_ap  LIKE oob_file.oob09
DEFINE l_oob10_ap  LIKE oob_file.oob10
#FUN-D40121--add--end--
#TQC-D80007--add--str--
DEFINE l_apv04_1   LIKE apv_file.apv04
DEFINE l_apv04f_1  LIKE apv_file.apv04f
#TQC-D80007--add--end--
   
   BEGIN WORK
   LET g_success = 'Y'
   INITIALIZE l_apa.* TO NULL
   INITIALIZE l_apc.* TO NULL
   INITIALIZE l_alz.* TO NULL
   LET l_aph05   = NULL
   LET l_aph05f  = NULL
   LET l_apg05   = NULL
   LET l_apg05f  = NULL 
   LET l_sql = "DELETE FROM alz_file WHERE alz00 = '",tm.alz00,"' AND alz02 ='",tm.alz02,"' AND alz03 ='",tm.alz03,"' AND ",tm.wc
   PREPARE p600_del_alz FROM l_sql  
   EXECUTE p600_del_alz
   IF STATUS THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF   
   LET g_count = 0  #TQC-C30341 add
   CASE 
      WHEN tm.alz00 ='1'
         LET l_wc = cl_replace_str(tm.wc,"alz01","apa06")
         LET g_sql = "SELECT apa00,apa01,apa02,apa06,apa13,apa54,apc02,apc03,apc04,SUM(apc08),SUM(apc09),SUM(apc10),SUM(apc11),SUM(apc15) ",    #TQC-C30349  add  apa13 #MOD-CA0195 add apc15   #FUN-C80102 add apc03  #FUN-D40121 add apa54
                     "  FROM apa_file,apc_file ",
                     " WHERE apc01 = apa01",
                     "   AND (YEAR(apa02) < '",tm.alz02,"'",
                     "    OR YEAR(apa02) ='",tm.alz02,"' AND MONTH(apa02) <='",tm.alz03,"')",
                     "   AND (apa00 LIKE '1%' OR apa00 LIKE '2%')",
                    #"   AND apa00 != '13' AND apa00 != '17' AND apa00 != '25' AND apa00 != '16' ",   #TQC-C30349   add  #No.MOD-C90152 16  #FUN-C80102 mark
                     "   AND apa41 ='Y'",
                     "   AND apa42 ='N'",
                     "   AND ",l_wc CLIPPED,
                     "   AND apa06 IS NOT NULL ",         #No.FUN-C30260   Add
                     " GROUP BY apa00,apa01,apa02,apa06,apa13,apa54,apc02,apc03,apc04"       #TQC-C30349  add  apa13    #FUN-C80102 add apc03  #FUN-D40121 add apa54
         PREPARE p600_pre1 FROM g_sql
         DECLARE p600_cs1 CURSOR FOR p600_pre1
         FOREACH p600_cs1 INTO l_apa.apa00,l_apa.apa01,l_apa.apa02,l_apa.apa06,l_apa.apa13,l_apa.apa54,l_apc.apc02,l_apc.apc03,l_apc.apc04,l_apc.apc08,l_apc.apc09,l_apc.apc10,l_apc.apc11,l_apc.apc15    #TQC-C30349  add  l_apa.apa13, #MOD-CA0195 add apc15  #FUN-C80102 add l_apc.apc03  #FUN-D40121 add l_apa.apa54
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            #FUN-D40121-add--str--
            IF cl_null(l_apc.apc09) THEN 
               LET l_apc.apc09 = 0
            END IF
            IF cl_null(l_apc.apc08) THEN
               LET l_apc.apc08 = 0
            END IF
            #FUN-D40121-add--end--
            LET l_sql = "SELECT SUM(apg05f),SUM(apg05)",
                        "  FROM apg_file,apf_file ",
                        " WHERE apf01 = apg01 AND apf41 <> 'X' ",
		        " and apf41 ='Y' ",
                        "   AND apg04 ='",l_apa.apa01,"'",
                        "   AND apg06 ='",l_apc.apc02,"'",
                        "   AND (YEAR(apf02) >'",tm.alz02,"'",
                        "    OR YEAR(apf02) ='",tm.alz02,"' AND MONTH(apf02)>'",tm.alz03,"')"
            PREPARE sel_apg FROM l_sql
            EXECUTE sel_apg INTO l_apg05f,l_apg05
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_apg05f) THEN LET l_apg05f =0 END IF 
            IF cl_null(l_apg05) THEN LET l_apg05 =0 END IF 
            LET l_sql = "SELECT SUM(apg05)",
                        "  FROM apg_file,apf_file ",
                        " WHERE apf01 = apg01 AND apf41 <> 'X' ",
			" and apf41 ='Y' ",
                        "   AND apg04 ='",l_apa.apa01,"'",
                        "   AND apg06 ='",l_apc.apc02,"'",
#No.TQC-B60351 --begin
#                       "   AND (YEAR(apf02) >'",tm.alz02,"'",
#                       "    OR YEAR(apf02) ='",tm.alz02,"' AND MONTH(apf02)='",tm.alz03,"')"
                        "   AND YEAR(apf02) ='",tm.alz02,"' AND MONTH(apf02)='",tm.alz03,"'"   #No.TQC-B90170
#No.TQC-B60351 --end
            PREPARE sel_apg3 FROM l_sql
            EXECUTE sel_apg3 INTO l_apg05_n
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_apg05_n) THEN LET l_apg05_n =0 END IF 
            LET l_sql = "SELECT SUM(aph05f),SUM(aph05)",
                        "  FROM aph_file,apf_file ",
                        " WHERE apf01 = aph01 AND apf41 <> 'X' ",
			" AND apf41 = 'Y' ",
 			#lixwz201020 
                        "   AND aph04 ='",l_apa.apa01,"'",
                        "   AND aph17 ='",l_apc.apc02,"'",
                        "   AND (YEAR(apf02) >'",tm.alz02,"'",
                        "    OR YEAR(apf02) ='",tm.alz02,"' AND MONTH(apf02)>'",tm.alz03,"')"
            PREPARE sel_aph FROM l_sql
            EXECUTE sel_aph INTO l_aph05f,l_aph05
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_aph05f) THEN LET l_aph05f =0 END IF 
            IF cl_null(l_aph05) THEN LET l_aph05 =0 END IF 
            LET l_sql = "SELECT SUM(aph05)",
                        "  FROM aph_file,apf_file ",
                        " WHERE apf01 = aph01 AND apf41 <> 'X' ",
			" AND apf41 = 'Y' ",
                        "   AND aph04 ='",l_apa.apa01,"'",
                        "   AND aph17 ='",l_apc.apc02,"'",
#No.TQC-B60351 --begin
#                       "   AND (YEAR(apf02) >'",tm.alz02,"'",
#                       "    OR YEAR(apf02) ='",tm.alz02,"' AND MONTH(apf02)='",tm.alz03,"')"
                        "   AND YEAR(apf02) ='",tm.alz02,"' AND MONTH(apf02)='",tm.alz03,"'"   #No.TQC-B90170 
#No.TQC-B60351 --end
            PREPARE sel_aph3 FROM l_sql
            EXECUTE sel_aph3 INTO l_aph05_n
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_aph05_n) THEN LET l_aph05_n =0 END IF 
            LET l_sql = "SELECT SUM(oob09),SUM(oob10)",
                        "  FROM oob_file,ooa_file",
                        " WHERE ooa01 = oob01",
                        "   AND oob04 ='9'",
                        "   AND oob06 ='",l_apa.apa01,"'",
                        "   AND (YEAR(ooa02) >'",tm.alz02,"'",
                        "    OR YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) >'",tm.alz03,"')",
                        "   AND ooaconf <>'X'"

            IF l_apa.apa00 MATCHES '[1*]' THEN 
               LET l_sql = l_sql," AND oob03 ='1'"
            ELSE 
               LET l_sql = l_sql," AND oob03 ='2'"
            END IF 
            PREPARE sel_oob FROM l_sql
            EXECUTE sel_oob INTO l_oob09,l_oob10
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oob09) THEN LET l_oob09 =0 END IF 
            IF cl_null(l_oob10) THEN LET l_oob10 =0 END IF 
            LET l_sql = "SELECT SUM(oob09)",
                        "  FROM oob_file,ooa_file",
                        " WHERE ooa01 = oob01",
                        "   AND oob04 ='9'",
                        "   AND oob06 ='",l_apa.apa01,"'",
#No.TQC-B60351 --begin
#                       "   AND (YEAR(ooa02) >'",tm.alz02,"'",
#                       "    OR YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) ='",tm.alz03,"')",
                        "   AND YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) ='",tm.alz03,"'",   #No.TQC-B90170  
#No.TQC-B60351 --end
                        "   AND ooaconf <>'X'"

            IF l_apa.apa00 MATCHES '[1*]' THEN 
               LET l_sql = l_sql," AND oob03 ='1'"
            ELSE 
               LET l_sql = l_sql," AND oob03 ='2'"
            END IF 
            PREPARE sel_oob3 FROM l_sql
            EXECUTE sel_oob3 INTO l_oob09_n
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oob09_n) THEN LET l_oob09_n =0 END IF 
#No.TQC-B60351 --begin
            LET l_sql = "SELECT SUM(apv04f),SUM(apv04)",
                        "  FROM apv_file,ooa_file",
                        " WHERE ooa01 = apv01",
                        "   AND apv03 ='",l_apa.apa01,"'",
                        "   AND apv05 ='",l_apc.apc02,"'",
                        "   AND YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) >'",tm.alz03,"'",  #No.TQC-B90170 
                        "   AND ooaconf <>'X'"

            PREPARE sel_apv FROM l_sql
            EXECUTE sel_apv INTO l_apv04f,l_apv04
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_apv04f) THEN LET l_apv04f =0 END IF 
            IF cl_null(l_apv04) THEN LET l_apv04 =0 END IF            

            LET l_sql = "SELECT SUM(apv04)",
                        "  FROM apv_file,ooa_file",
                        " WHERE ooa01 = apv01",
                        "   AND apv03 ='",l_apa.apa01,"'",
                        "   AND apv05 ='",l_apc.apc02,"'",
                        "   AND YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) >'",tm.alz03,"'",   #No.TQC-B90170 
                        "   AND ooaconf <>'X'"

            PREPARE sel_apv1 FROM l_sql
            EXECUTE sel_apv1 INTO l_apv04_n
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_apv04_n) THEN LET l_apv04_n =0 END IF 
#No.TQC-B60351 --end
            #TQC-D80007--add--str--
            LET l_sql = "SELECT SUM(apv04f),SUM(apv04)",
                        "  FROM apv_file,apa_file,aznn_file",  
                        " WHERE apa01 = apv01 ",
                        "   AND apv03 ='",l_apa.apa01,"'",
                        "   AND apv05 ='",l_apc.apc02,"'",
                        "   AND ((YEAR(apa02) ='",tm.alz02,"' AND MONTH(apa02) >'",tm.alz03,"')", 
                        "         OR YEAR(apa02) > '",tm.alz02,"')",
                        "   AND apa63 <>'X'"

            PREPARE sel_apv_1 FROM l_sql
            EXECUTE sel_apv_1 INTO l_apv04f_1,l_apv04_1
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_apv04f_1) THEN LET l_apv04f_1 =0 END IF 
            IF cl_null(l_apv04_1) THEN LET l_apv04_1 =0 END IF
            #TQC-D80007--add--end--
            IF l_aph05 =0 AND l_apg05 =0 AND l_aph05_n =0 AND l_apg05_n =0 AND l_apc.apc09 = l_apc.apc11+l_apc.apc15 AND l_oob09 =0 AND l_oob09_n =0  AND l_apv04_n =0 THEN   #No.TQC-B60351 add l_apv04_n  #MOD-CA0195 add apc15
               CONTINUE FOREACH 
            END IF 
            LET l_sql = "SELECT SUM(oox10) FROM oox_file",
                        " WHERE oox00 ='AP' AND oox03 ='",l_apa.apa01,"' AND oox041 ='",l_apc.apc02,"'",
                        "   AND (oox01 < '",tm.alz02,"'",                                 #MOD-D50117
                        "   OR (oox01 = '",tm.alz02,"'"," AND oox02 <= '",tm.alz03,"'))"  #MOD-D50117
            PREPARE sel_oox FROM l_sql
            EXECUTE sel_oox INTO l_oox10
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oox10) THEN LET l_oox10 =0 END IF   
            IF l_apa.apa00 MATCHES '1*' THEN    #No.FUN-C80102 Mark     #FUN-D40121  unmark
            #IF l_apa.apa00 MATCHES '2*' THEN    #No.FUN-C80102 Add     #FUN-D40121  mark
               LET l_oox10 = l_oox10 *(-1)
            END IF  

            #FUN-D40121--add--str--
            IF YEAR(l_apa.apa02) = tm.alz02 AND MONTH(l_apa.apa02)=tm.alz03 THEN	
               LET l_amt_apf=l_apc.apc08     ##本月应收原币金额	
               LET l_amt_ap=l_apc.apc09      ##本月应收本币金额	
            ELSE	
               LET l_amt_apf=0	
               LET l_amt_ap=0	
            END IF 	

            LET l_sql = "SELECT SUM(apg05f),SUM(apg05)",
                        "  FROM apg_file,apf_file ",
                        " WHERE apf01 = apg01 AND apf41 <> 'X' ",
                        "   AND apg04 ='",l_apa.apa01,"'",
                        "   AND apg06 ='",l_apc.apc02,"'",
                        "   AND YEAR(apf02) ='",tm.alz02,"'",	
                        "    AND MONTH(apf02) ='",tm.alz03,"'"
            PREPARE sel_apg_1 FROM l_sql
            EXECUTE sel_apg_1 INTO l_apg05f_ap,l_apg05_ap
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_apg05f_ap) THEN LET l_apg05f_ap =0 END IF 
            IF cl_null(l_apg05_ap) THEN LET l_apg05_ap =0 END IF 

            LET l_sql = "SELECT SUM(oob09),SUM(oob10)",
                        "  FROM oob_file,ooa_file",
                        " WHERE ooa01 = oob01",
                        "   AND oob04 ='9'",
                        "   AND oob06 ='",l_apa.apa01,"'",
                        "   AND YEAR(ooa02) ='",tm.alz02,"'",	
                        "    AND MONTH(ooa02) ='",tm.alz03,"'",	
                        "   AND ooaconf <>'X'"

            IF l_apa.apa00 MATCHES '[1*]' THEN 
               LET l_sql = l_sql," AND oob03 ='1'"
            ELSE 
               LET l_sql = l_sql," AND oob03 ='2'"
            END IF 
            PREPARE sel_oob_1 FROM l_sql
            EXECUTE sel_oob_1 INTO l_oob09_ap,l_oob10_ap
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oob09_ap) THEN LET l_oob09_ap =0 END IF 
            IF cl_null(l_oob10_ap) THEN LET l_oob10_ap =0 END IF

            ###本月发生额		
            LET l_alz.alz13 = l_amt_ap-l_apg05_ap-l_oob10_ap		
            LET l_alz.alz13f=l_amt_apf-l_apg05f_ap-l_oob09_ap		
            IF l_apa.apa00 MATCHES '2*' THEN		
               LET l_alz.alz13 = l_alz.alz13*(-1)           		
               LET l_alz.alz13f = l_alz.alz13f*(-1)          		
            END IF		

            LET l_alz.alz14 = l_apa.apa54
            LET l_alz.alz15 = l_oox10
            #FUN-D40121--add--end--
            
            LET l_amt = l_apc.apc11-l_apg05-l_aph05-l_oob10-l_apv04_1             #TQC-D80007 add l_apv04
            LET l_alz.alz09 = l_apc.apc09 - l_amt + l_oox10
            LET l_amtf = l_apc.apc10 - l_apg05f - l_aph05f - l_oob09-l_apv04f_1   #TQC-D80007 add l_apv04f
            LET l_alz.alz09f= l_apc.apc08 - l_amtf
            IF l_apa.apa00 MATCHES '2*' THEN 
               LET l_alz.alz09 = l_alz.alz09*(-1)
               LET l_alz.alz09f = l_alz.alz09f*(-1)
            END IF 
            #FUN-D40121--add--str--
            IF cl_null(l_alz.alz09) THEN 
               LET l_alz.alz09 = 0
            END IF
            IF cl_null(l_alz.alz09f) THEN
               LET l_alz.alz09f = 0
            END IF
            #FUN-D40121--add--end--
            LET l_alz.alz00 = '1'
            LET l_alz.alz01 = l_apa.apa06
            LET l_alz.alz02 = tm.alz02
            LET l_alz.alz03 = tm.alz03
            LET l_alz.alz04 = l_apa.apa01
            LET l_alz.alz05 = l_apc.apc02
            LET l_alz.alz06 = l_apa.apa02
            LET l_alz.alz07 = l_apc.apc04 
            LET l_alz.alz08 = l_apc.apc09 
            LET l_alz.alz09 = l_alz.alz09 
            LET l_alz.alz08f= l_apc.apc08
            LET l_alz.alz09f= l_alz.alz09f
            LET l_alz.alz10 = l_apa.apa13    #TQC-C30349  add  
            LET l_alz.alz12 = l_apc.apc03    #FUN-C80102  add
            INSERT INTO alz_file VALUES (l_alz.*)
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            LET g_count = g_count + 1  #TQC-C30341 add
         END FOREACH 
      WHEN tm.alz00 ='2'
         LET l_wc = cl_replace_str(tm.wc,"alz01","oma03")
         LET g_sql = "SELECT oma00,oma01,oma02,oma03,oma23,oma18,omc02,omc03,omc04,SUM(omc08),SUM(omc09),SUM(omc10),SUM(omc11) ",   #TQC-C30349  add  oma23 #FUN-C80102 add omc03  #FUN-D40121 add oma18
                     "  FROM oma_file,omc_file ",
                     " WHERE omc01 = oma01",
                     "   AND (YEAR(oma02) < '",tm.alz02,"'",
                     "    OR YEAR(oma02) ='",tm.alz02,"' AND MONTH(oma02) <='",tm.alz03,"')",
                     "   AND (oma00 LIKE '1%' OR oma00 LIKE '2%')",
                     "   AND omaconf ='Y'",
#                    "   AND oma01 ='14A-SYS11060006'",  #No.MOD-B60211
                     "   AND omavoid ='N'",
                     "   AND ",l_wc CLIPPED,
                     "   AND oma03 IS NOT NULL",    #No.FUN-C30260   Add
                     " GROUP BY oma00,oma01,oma02,oma03,oma23,oma18,omc02,omc03,omc04"       #TQC-C30349  add  oma23   #FUN-C80102 add omc03  #FUN-D40121 add oma18
         PREPARE p600_pre2 FROM g_sql
         DECLARE p600_cs2 CURSOR FOR p600_pre2
         FOREACH p600_cs2 INTO l_oma.oma00,l_oma.oma01,l_oma.oma02,l_oma.oma03,l_oma.oma23,l_oma.oma18,l_omc.omc02,l_omc.omc03,l_omc.omc04,l_omc.omc08,l_omc.omc09,l_omc.omc10,l_omc.omc11    #TQC-C30349  add  l_oma.oma23  #FUN-C80102 add l_omc.omc03  #FUN-D40121 add l_oma.oma18
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            #FUN-D40121--add--str--
            IF cl_null(l_omc.omc09) THEN 
               LET l_omc.omc09 = 0
            END IF
            IF cl_null(l_omc.omc08) THEN
               LET l_omc.omc08 = 0
            END IF
            #FUN-D40121--add--end--
            LET l_sql = "SELECT SUM(oob09),SUM(oob10)",
                        "  FROM oob_file,ooa_file",
                        " WHERE ooa01 = oob01",
                        "   AND oob06 ='",l_oma.oma01,"'",
                        "   AND oob19 ='",l_omc.omc02,"'",
                        "   AND (YEAR(ooa02) >'",tm.alz02,"'",
                        "    OR YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) >'",tm.alz03,"')",
                        "   AND ooaconf <>'X'"

            PREPARE sel_oob1 FROM l_sql
            EXECUTE sel_oob1 INTO l_oob09,l_oob10
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oob09) THEN LET l_oob09 =0 END IF 
            IF cl_null(l_oob10) THEN LET l_oob10 =0 END IF 
            LET l_sql = "SELECT SUM(oob09)",
                        "  FROM oob_file,ooa_file",
                        " WHERE ooa01 = oob01",
                        "   AND oob06 ='",l_oma.oma01,"'",
                        "   AND oob19 ='",l_omc.omc02,"'",
#No.TQC-B60351 --begin
#                       "   AND (YEAR(ooa02) >'",tm.alz02,"'",
#                       "    OR YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) ='",tm.alz03,"')",
                        "   AND YEAR(ooa02) ='",tm.alz02,"' AND MONTH(ooa02) ='",tm.alz03,"'",   #No.TQC-B90170 
#No.TQC-B60351 --end
                        "   AND ooaconf <>'X'"

            PREPARE sel_oob4 FROM l_sql
            EXECUTE sel_oob4 INTO l_oob09_n
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oob09_n) THEN LET l_oob09_n =0 END IF 
            IF l_oob09 =0 AND l_oob09_n =0 AND l_omc.omc09 = l_omc.omc11 THEN 
               CONTINUE FOREACH 
            END IF 
            LET l_sql = "SELECT SUM(oox10) FROM oox_file",
                        " WHERE oox00 ='AR' AND oox03 ='",l_oma.oma01,"' AND oox041 ='",l_omc.omc02,"'",
                        "   AND (oox01 < '",tm.alz02,"'",                                 #MOD-D50117
                        "   OR (oox01 = '",tm.alz02,"'"," AND oox02 <= '",tm.alz03,"'))"  #MOD-D50117
            PREPARE sel_oox1 FROM l_sql
            EXECUTE sel_oox1 INTO l_oox10
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            IF cl_null(l_oox10) THEN LET l_oox10 =0 END IF   
           #IF l_oma.oma00 MATCHES '1*' THEN   #No.FUN-C80102   Mark
            IF l_oma.oma00 MATCHES '2*' THEN   #No.FUN-C80102   Add
               LET l_oox10 = l_oox10 *(-1)
            END IF  

            #FUN-D40121--add--str--
            IF YEAR(l_oma.oma02) = tm.alz02 AND MONTH(l_oma.oma02)=tm.alz03 THEN					
               LET l_amt_arf=l_omc.omc08     ##本月应收原币金额					
               LET l_amt_ar=l_omc.omc09      ##本月应收本币金额					
            ELSE					
               LET l_amt_arf=0					
               LET l_amt_ar=0					
            END IF

            LET l_sql = "SELECT SUM(oob09),SUM(oob10)",	
                        "  FROM oob_file,ooa_file",	
                        " WHERE ooa01 = oob01",	
                        "   AND oob06 ='",l_oma.oma01,"'",	
                        "   AND oob19 ='",l_omc.omc02,"'",	
                        "   AND YEAR(ooa02) ='",tm.alz02,"'",	
                        "    AND MONTH(ooa02) ='",tm.alz03,"'",	
                        "   AND ooaconf <>'X'"	
            PREPARE sel_oob2 FROM l_sql	
            EXECUTE sel_oob2 INTO l_oob09_ar,l_oob10_ar   	
            IF STATUS THEN	
               CALL cl_err('',SQLCA.sqlcode,1)	
               LET g_success ='N'	
               RETURN	
            END IF 	
            IF cl_null(l_oob09_ar) THEN LET l_oob09_ar=0 END IF 	
            IF cl_null(l_oob10_ar) THEN LET l_oob10_ar=0 END IF 	
	
            ###本月发生额	
            LET l_alz.alz13 = l_amt_ar-l_oob10_ar	
            LET l_alz.alz13f= l_amt_arf-l_oob09_ar	
            IF l_oma.oma00 MATCHES '2*' THEN	
               LET l_alz.alz13 = l_alz.alz13*(-1)           	
               LET l_alz.alz13f = l_alz.alz13f*(-1)          	
            END IF	

            LET l_alz.alz14 = l_oma.oma18
            LET l_alz.alz15 = l_oox10
            #FUN-D40121--add--end--
            
            LET l_amt = l_omc.omc11-l_oob10
            LET l_alz.alz09 = l_omc.omc09 - l_amt + l_oox10
            LET l_amtf = l_omc.omc10 - l_oob09
            LET l_alz.alz09f= l_omc.omc08 - l_amtf
            IF l_oma.oma00 MATCHES '2*' THEN 
               LET l_alz.alz09 = l_alz.alz09*(-1)
               LET l_alz.alz09f = l_alz.alz09f*(-1)
            END IF 
            #FUN-D40121--add--str--
            IF cl_null(l_alz.alz09) THEN 
               LET l_alz.alz09 = 0
            END IF
            IF cl_null(l_alz.alz09f) THEN
               LET l_alz.alz09f = 0
            END IF
            #FUN-D40121--add--end--
            LET l_alz.alz00 = '2'
            LET l_alz.alz01 = l_oma.oma03
            LET l_alz.alz02 = tm.alz02
            LET l_alz.alz03 = tm.alz03
            LET l_alz.alz04 = l_oma.oma01
            LET l_alz.alz05 = l_omc.omc02
            LET l_alz.alz06 = l_oma.oma02
            LET l_alz.alz07 = l_omc.omc04 
            LET l_alz.alz08 = l_omc.omc09 
            LET l_alz.alz09 = l_alz.alz09 
            LET l_alz.alz08f= l_omc.omc08
            LET l_alz.alz09f= l_alz.alz09f
            LET l_alz.alz10 = l_oma.oma23       #TQC-C30349  add 
            LET l_alz.alz12 = l_omc.omc03       #FUN-C80102  add
            INSERT INTO alz_file VALUES (l_alz.*)
            IF STATUS THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               LET g_success ='N'
               RETURN
            END IF
            LET g_count = g_count + 1  #TQC-C30341 add
         END FOREACH 
   END CASE 
   #TQC-C30341 add
   IF g_count = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','apm1031',1)
   END IF
   #TQC-C30341 add--end
   
END FUNCTION
 
