# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: gglq901.4gl
# Descriptions...: 財務月結核查作業
# Date & Author..: 13/05/27 By zhangweib     FUN-D40121
# Modify.........: No:TQC-D70023 13/07/04 By zhangweib 1.出貨單沒扣帳不應該檢查是否立帳
#                                                      2.修改串查方式,變為雙擊資料串到新程序
#                                                      3.檢查分錄科目與單據科目是否一致時不應該把沒有科目的資料也帶出來
#                                                      4.應收未審核資料應該報錯未審核為拋轉而不僅僅是為拋轉
#                                                      5.查詢時期別给当前默认的期别
#                                                      6.總帳未審核資料應該報錯未審核為過帳而不是僅報為過帳
# Modify.........: No:TQC-D70037 13/07/16 By zhangweib 檢查應收單頭科目是否與分錄科目相同時,應該考慮到直接收款的問題
# Modify.........: No:MOD-DB0073 13/11/11 By fengmy 去掉DM紅沖單據的科目不一致報錯
# Modify.........: No:MOD-DC0024 13/12/05 By fengmy 1.ooa40是以'01'非'1'来存库的
#                                                   2.直接付款情况下且未付金额为0的情况下不需判断'分录与单据科目不一致'
#                                                     冲账单据未付金额为0的情况下不需判断'分录与单据科目不一致'
#                                                   3.sql错误信息位置错误
#                                                   4.加入aapt140
#                                                   5.oaz92=Y,sys=1时，排除'出货单已扣账未立账'报错信息
#                                                   6.axrt300,oma00='22'or'24'不用检查分录底稿

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm         RECORD
          yy      LIKE type_file.num5,      #No.FUN-D40121
          mm      LIKE type_file.num5,
          sys     LIKE type_file.chr1
                  END RECORD
DEFINE g_oma      DYNAMIC ARRAY OF RECORD
          oma01   LIKE oma_file.oma01,
          msg     STRING,
          prog    LIKE zz_file.zz01
                  END RECORD,
       g_wc,g_sql STRING,
       g_rec_b    LIKE type_file.num10,
       g_tot      LIKE oox_file.oox09
DEFINE g_sql_tmp  STRING
DEFINE g_cnt      LIKE type_file.num10
DEFINE g_msg      LIKE type_file.chr1000
DEFINE g_jump     LIKE type_file.num10
DEFINE mi_no_ask  LIKE type_file.num5
DEFINE g_detail   LIKE type_file.chr1
DEFINE l_ac       LIKE type_file.num5
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_curs_index LIKE type_file.num10
DEFINE l_table    STRING
DEFINE b_date,e_date LIKE type_file.dat
DEFINE l_wc  STRING

MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   LET tm.yy = ARG_VAL(1)
   LET tm.mm = ARG_VAL(2)
   LET tm.sys = ARG_VAL(3)
   LET l_wc = ARG_VAL(4)
   
   LET g_sql = "sys.type_file.chr5,",     #系統別
               "oma01.ima_file.ima01,",   #Key 值
               "flag1.type_file.chr1,",   #
               "flag2.type_file.chr1,",   #
               "flag3.type_file.chr1,",   #
               "flag4.type_file.chr1,",   #
               "flag5.type_file.chr1,",   #
               "flag6.type_file.chr1,",   #
               "flag7.type_file.chr1,",   #
               "prog.zz_file.zz01"        #程序編號
   LET l_table = cl_prt_temptable('gglq901',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW q901_w WITH FORM "ggl/42f/gglq901"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_init()
     #CALL cl_set_comp_visible("prog",FALSE)

      IF NOT cl_null(l_wc) THEN
         CALL q901_q()
      END IF  
      CALL q901_menu()
   CLOSE WINDOW q901_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q901_cs()
   DEFINE l_sql       STRING
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE l_length    LIKE type_file.num5    #MOD-DB0073 add
   CLEAR FORM #清除畫面
   CALL g_oma.clear()
   CALL cl_opmsg('q')
   CALL cl_set_head_visible("","YES")
   IF cl_null(tm.yy) THEN
      LET tm.yy = YEAR(g_today)
   END IF
  #No.TQC-D70023 ---Mod--- Start
  #IF cl_null(tm.mm) THEN 
  #   LET tm.mm = MONTH(g_today)
  #END IF
   IF cl_null(tm.mm) THEN
      SELECT aaa05 INTO tm.mm FROM aaa_file WHERE aaa01 = g_aza.aza81
   END IF
  #No.TQC-D70023 ---Mod--- End
   IF cl_null(tm.sys) THEN
      LET tm.sys = '1'
   END IF 
   IF cl_null(l_wc) THEN
   INPUT BY NAME tm.yy,tm.mm,tm.sys WITHOUT DEFAULTS

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END INPUT
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
   CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,b_date,e_date
   MESSAGE ' WAIT '
   LET g_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE q901_del FROM g_sql
   EXECUTE q901_del
   CASE
      WHEN tm.sys = '1'    #AXR
        #ola_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AXR',ola01,olaconf,CASE ooydmy1 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','axrt200'",
                     "   FROM ola_file LEFT OUTER JOIN ooy_file ON ola01 like rtrim(ltrim(ooyslip)) || '-%'",
                     "  WHERE ola28 Is Null ",
                     "    AND (ola40 IS NULL OR ola40<>'Y')",
                     "    AND ola02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_ola FROM g_sql
         EXECUTE q901_ola
        #ole_file 判斷審核否、拋轉否、財務確認否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AXR',ole01,oleconf,CASE ooydmy1 WHEN 'Y' THEN 'N' ELSE '' END CASE,ole28,'','','','','axrt201'",
                     "   FROM ole_file LEFT OUTER JOIN ooy_file ON ole01 like rtrim(ltrim(ooyslip)) || '-%' ",
                     "  WHERE ole14 Is Null ",
                     "    AND ole03 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_ole FROM g_sql
         EXECUTE q901_ole
        #olc_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AXR',olc01,olcconf,'N','','','','','','axrt210' FROM olc_file ",
                     "  WHERE olc23 Is NOT Null ",
                     "    AND olc02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_olc FROM g_sql
         EXECUTE q901_olc
        #oma_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AXR',oma01,omaconf,CASE ooydmy1 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','axrt300'",
                     "   FROM oma_file LEFT OUTER JOIN ooy_file ON oma01 like rtrim(ltrim(ooyslip)) || '-%' ",
                     "       ,npq_file ",         #No.TQC-D70023   Add
                     "  WHERE oma33 Is Null ",
                     "    AND npq01 = oma01 ",   #No.TQC-D70023
                     "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_oma FROM g_sql
         EXECUTE q901_oma
        #oox_file 判斷拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXR',oox01||'/'||oox02,'','N','','','','','','gxrq600' ",
                     "   FROM oox_file LEFT OUTER JOIN npp_file ON npp01 = 'AR'||oox01||'0'||oox02 ",
                     "  WHERE oox02 < 10 ",
                     "    AND oox01 = '",tm.yy,"'",
                     "    AND oox02 = '",tm.mm,"'",
                     "    AND nppglno Is Null",
                     "    AND oox00 = 'AR'",
                     "UNION", 
                     " SELECT DISTINCT 'AXR',oox01||'/'||oox02,'','N','','','','','','gxrq600' ", 
                     "   FROM oox_file LEFT OUTER JOIN npp_file ON npp01 = 'AR'||oox01||oox02",
                     "  WHERE oox02 > 9 ",
                     "    AND oox01 = '",tm.yy,"'",
                     "    AND oox02 = '",tm.mm,"'",
                     "    AND nppglno Is Null",
                     "    AND oox00 = 'AR'"
         PREPARE q901_oox_ar FROM g_sql
         EXECUTE q901_oox_ar
        #oma_file 判斷分錄與單據科目一致否
         CALL gglq901_axr1()   #No.TQC-D70037   Add
        #No.TQC-D70037 ---Mark--- Start
        #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
        #            " SELECT 'AXR',oma01,'','','','N','','','','axrt300' FROM oma_file,npq_file,npp_file ",
        #            "  WHERE oma18 <> npq03 ",
        #            "    AND npq06 = '1'",
        #            "    AND npp01 = npq01",   #No.TQC-D70023   Add
        #            "    AND nppsys = 'AR'",   #No.TQC-D70023   Add
        #            "    AND npq01 = oma01",
        #            "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
        #PREPARE q901_oma1 FROM g_sql
        #EXECUTE q901_oma1
        #No.TQC-D70037 ---Mark--- End
        #oma_file 判斷多帳期金額與單身金額是否一致
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AXR',oma01,'','','','','','N','','axrt300' FROM oma_file a ",
                     "  WHERE EXISTS (SELECT 1 FROM (SELECT oma01,(oma56t-oma57),SUM(omc13) FROM oma_file,omc_file",
                     "                                WHERE oma64 = '1' ",
                     "                                  AND omc01 = oma01",
                     "                                GROUP BY oma01,(oma56t-oma57) ",
                     "                               HAVING (oma56t-oma57) != SUM(omc13)",
                     "                               ) b",
                     "                        WHERE a.oma01 = b.oma01)",
                     "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_oma2 FROM g_sql
         EXECUTE q901_oma2
        #oma_file 判斷分錄核算項與單據廠商是否一致
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXR',oma01,'','','','','N','','','axrt300' FROM oma_file a,npq_file,aag_file",
                     "  WHERE oma01 = npq01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag43 = 'Y'",
                     "    AND aag15 IS NOT Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "    AND npq03 = aag01",
                     "    AND NOT EXISTS (",
                     "            SELECT 1 FROM oma_file b,npq_file,aag_file",
                     "             WHERE oma01 = npq01",
                     "               AND npq03 = aag01",
                     "               AND aag00 = '",g_aaz.aaz64,"'",
                     "               AND aag43 = 'Y'",
                     "               AND npq21 = npq11",
                     "               AND npq21 = oma03",
                     "               AND aag15 IS NOT Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "               AND a.oma01 = b.oma01)",
                     "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_oma3 FROM g_sql
         EXECUTE q901_oma3
        #oma_file 判斷單身科目是否符合
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXR',oma01,'','','','','','','N','axrt300' FROM oma_file,omb_file,aag_file",
                     "  WHERE oma01 = omb01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag19 = '23'",
                     "    AND omb33 = aag01",
                     "    AND oma00 NOT IN('11','12','13','21')",   #2013.07.30 zhangwei Add NOT
                     "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_oma4 FROM g_sql
         EXECUTE q901_oma4
        #ooa_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AXR',ooa01,ooaconf,CASE ooydmy1 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','axrt400'",
                     "   FROM ooa_file LEFT OUTER JOIN ooy_file ON ooa01 like rtrim(ltrim(ooyslip)) || '-%' ",
                     "  WHERE ooa33 Is Null ",
                     "    AND ooa00 = '1' ",
                     "    AND ooa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_ooa FROM g_sql
         EXECUTE q901_ooa
        #ooa_file 判斷分錄核算項與單據廠商是否一致
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXR',ooa01,'','','','','N','','','axrt401' FROM ooa_file a,npq_file,aag_file",
                     "  WHERE ooa01 = npq01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag43 = 'Y'",
                     "    AND npq03 = aag01",
                     "    AND aag15 IS NOT Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "    AND ooa00 = '1' ",
                     "    AND ooa37 = '3'",
                     "    AND NOT EXISTS (",
                     "            SELECT 1 FROM ooa_file b,npq_file,aag_file,oob_file",   #No.TQC-D70023   Add oob_file
                     "             WHERE ooa01 = npq01",
                     "               AND npq03 = aag01",
                     "               AND aag00 = '",g_aaz.aaz64,"'",
                     "               AND aag43 = 'Y'",
                    #No.TQC-D70023 ---Mod--- Start
                    #"               AND npq21 = npq11",
                    #"               AND npq21 = ooa03",
                     "               AND ooa01 = oob01",
                    #"               AND ((ooa40 = '2' AND npq21 = npq11 AND npq21 = ooa03) OR (ooa40 = '1' AND npq21 = npq11 AND npq21 = oob24))",   #MOD-DC0024 mark
                     "               AND ((ooa40 = '02' AND npq21 = npq11 AND npq21 = ooa03) OR (ooa40 = '01' AND npq21 = npq11 AND npq21 = oob24))", #MOD-DC0024 
                    #No.TQC-D70023 ---Mod--- End
                     "               AND aag15 IS NOT Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "               AND npq06 = '1'",
                     "               AND a.ooa01 = b.ooa01)",
                     "    AND NOT EXISTS (",
                     "            SELECT 1 FROM ooa_file c,oob_file,aag_file,npq_file",
                     "             WHERE ooa01 = oob01",
                     "               AND ooa01 = npq01",
                     "               AND npq03 = aag01",
                     "               AND aag00 = '",g_aaz.aaz64,"'",
                     "               AND aag43 = 'Y'",
                    #No.TQC-D70023 ---Mod--- Start
                    #"               AND npq21 = npq11",
                    #"               AND npq21 = oob24",
                    #"               AND ((ooa40 = '2' AND npq21 = npq11 AND npq21 = oob24) OR (ooa40 = '1' AND npq21 = npq11 AND npq21 = ooa03))",   #MOD-DC0024 mark
                     "               AND ((ooa40 = '02' AND npq21 = npq11 AND npq21 = oob24) OR (ooa40 = '01' AND npq21 = npq11 AND npq21 = ooa03))", #MOD-DC0024
                    #No.TQC-D70023 ---Mod--- End
                     "               AND aag15 IS NOT Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "               AND npq06 = '2'",
                     "               AND a.ooa01 = c.ooa01)",
                     "    AND ooa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_ooa1 FROM g_sql
         EXECUTE q901_ooa1
         CALL q901_axr()   #已扣帳未立帳
      WHEN tm.sys = '2'    #AAP
        #apa_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',apa01,apa41,CASE apydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','apa'||apa00 ",
                     "  FROM apa_file LEFT OUTER JOIN apy_file ON apa01 like rtrim(ltrim(apyslip)) || '-%'",
                     "  WHERE apa02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND apaacti = 'Y' ",
                     "    AND apa42 = 'N'",
                     "    AND apa00 NOT IN ('23','24','25')",
                     "    AND apa44 Is Null",
                     "    AND apa79 NOT IN ('2','3')",
                     "UNION", 
                     " SELECT 'AAP',apa01,apa41,'','','','','','','apa'||apa00 ",
                     "  FROM apa_file ",
                     "  WHERE apa02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND apaacti = 'Y' ",
                     "    AND apa42 = 'N'",
                     "    AND apa00 NOT IN ('23','24','25')",
                     "    AND apa41 = 'N'",
                     "    AND apa79 IN ('2','3')"
         PREPARE q901_apa FROM g_sql
         EXECUTE q901_apa
        #oox_file 判斷拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AAP',oox01||'/'||oox02,'','N','','','','','','gapq600' ",
                     "   FROM oox_file LEFT OUTER JOIN npp_file ON npp01 = 'AP'||oox01||'0'||oox02",
                     "  WHERE oox02 < 10 ",
                     "    AND oox01 = '",tm.yy,"'",
                     "    AND oox02 = '",tm.mm,"'",
                     "    AND nppglno Is Null", 
                     "    AND oox00 = 'AP'",
                     "UNION", 
                     " SELECT DISTINCT 'AAP',oox01||'/'||oox02,'','N','','','','','','gapq600' ",
                     "   FROM oox_file LEFT OUTER JOIN npp_file ON npp01 = 'AP'||oox01||oox02",
                     "  WHERE oox02 > 9 ",
                     "    AND oox01 = '",tm.yy,"'",
                     "    AND oox02 = '",tm.mm,"'",
                     "    AND nppglno Is Null", 
                     "    AND oox00 = 'AP'"
         PREPARE q901_oox_ap FROM g_sql
         EXECUTE q901_oox_ap
        #apa_file 判斷分錄與單據科目一致否
        #MOD-DB0073 ---begin
         CASE g_aza.aza41
              WHEN 1  LET l_length=3
              WHEN 2  LET l_length=4
              WHEN 3  LET l_length=5
         END CASE
         #MOD-DB0073 ---end
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',apa01,'','','N','','','','','apa'||apa00 ",
                     "   FROM apa_file a,npq_file ",
                     "  WHERE apa02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND apaacti = 'Y' ",
                     "    AND apa01 = npq01",
                     "    AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "    AND npq06 = 2",
                     "    AND apa42 = 'N'",
                     "    AND NOT EXISTS (SELECT 1 FROM apa_file b,npq_file ",
                     "                     WHERE apa01 = npq01 ",
                     "                       AND npq06 = '2' ",
                     "                       AND ((apa54 = npq03 AND apa00 LIKE '1%')",
                     "                         OR (apa51 = npq03 AND apa00 LIKE '2%'))", 
                     "                      AND a.apa01 = b.apa01)"    #No.TQC-D70037   Add
                     #MOD-DC0024--begin----
                    ,"    AND NOT EXISTS (SELECT 1 FROM apa_file d",
                     "                     WHERE apa55='2' and (apa34f-apa35f) = 0 ",
                     "                      AND a.apa01 = d.apa01)",
                     "    AND NOT EXISTS (SELECT 1 FROM apa_file e",
                     "                     WHERE apa56f<>0 and (apa34f-apa35f) = 0 ",
                     "                      AND a.apa01 = e.apa01)"
                     #MOD-DC0024--end----
                     #MOD-DB0073 ---begin
                    ," AND apa01[1,",l_length,"] NOT IN( SELECT apyslip from apy_file where apykind='22' and apydmy6 ='Y' ) ", #MOD-DB0073 add apy
                     "UNION",
                     " SELECT 'AAP',apa01,'','','N','','','','','apa'||apa00 ",
                     "   FROM apa_file a,npq_file ",
                     "  WHERE apa02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND apaacti = 'Y' ",
                     "    AND apa01 = npq01",
                     "    AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "    AND npq06 = 1",
                     "    AND apa42 = 'N'",
                     #MOD-DC0024--begin----
                     "    AND NOT EXISTS (SELECT 1 FROM apa_file d",
                     "                     WHERE apa55='2' and (apa34f-apa35f) = 0 ",
                     "                      AND a.apa01 = d.apa01)",
                     "    AND NOT EXISTS (SELECT 1 FROM apa_file e",
                     "                     WHERE apa56f<>0 and (apa34f-apa35f) = 0 ",
                     "                      AND a.apa01 = e.apa01)",
                     #MOD-DC0024--end----
                     "    AND NOT EXISTS (SELECT 1 FROM apa_file b,npq_file ",
                     "                     WHERE apa01 = npq01 ",
                     "                       AND npq06 = '1' AND apa51 = npq03 ",                  
                     "                      AND a.apa01 = b.apa01)"    
                    ," AND apa01[1,",l_length,"] IN( SELECT apyslip from apy_file where apykind='22' and apydmy6 ='Y' ) " 
                     #MOD-DB0073 ---end
         PREPARE q901_apa1 FROM g_sql
         EXECUTE q901_apa1
        #apa_file 判斷多帳期金額與單身金額是否一致
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                    #" SELECT 'AAP',apa01,'','','','','','N','','apa'||apa00 FROM apa_file a ",       #MOD-DC0024 mark
                     " SELECT 'AAP',apa01,'','','','N','','','','apa'||apa00 FROM apa_file a ",       #MOD-DC0024 
                     "  WHERE EXISTS (SELECT 1 FROM (SELECT apa01,(apa34-apa35),SUM(apa13) FROM apa_file,apc_file",
                     "                                WHERE apa63 = '1' ",
                     "                                  AND apc01 = apa01",
                     "                                GROUP BY apa01,(apa34-apa35) ",
                     "                               HAVING (apa34-apa35) != SUM(apc13)",
                     "                               ) b",
                     "                        WHERE a.apa01 = b.apa01)",
                     "    AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_apa2 FROM g_sql
         EXECUTE q901_apa2
        #apa_file 判斷分錄核算項與單據廠商是否一致
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AAP',apa01,'','','','','N','','','apa'||apa00 FROM apa_file a,npq_file,aag_file",
                     "  WHERE apa01 = npq01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag43 = 'Y'",
                     "    AND npq03 = aag01",
                     "    AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "    AND aag15 Is Not Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "    AND apa00 != '36'",
                     "    AND NOT EXISTS (",
                     "            SELECT 1 FROM apa_file b,npq_file,aag_file",
                     "             WHERE apa01 = npq01",
                     "               AND npq03 = aag01",
                     "               AND aag00 = '",g_aaz.aaz64,"'",
                     "               AND aag43 = 'Y'",
                     "               AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "               AND aag15 Is Not Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "               AND npq21 = npq11",
                     "               AND npq21 = apa05",
                     "               AND a.apa01 = b.apa01)",
                     "    AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_apa3 FROM g_sql
         EXECUTE q901_apa3
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AAP',apa01,'','','','','N','','','apa'||apa00 FROM apa_file a,npq_file,aag_file",
                     "  WHERE apa01 = npq01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag43 = 'Y'",
                     "    AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "    AND aag15 Is Not Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "    AND apa00 != '36'",
                     "    AND npq03 = aag01",
                     "    AND apa00 = '36' ",
                     "    AND NOT EXISTS (",
                     "            SELECT 1 FROM apa_file b,npq_file,aag_file,apf_file",
                     "             WHERE apa01 = npq01",
                     "               AND npq03 = aag01",
                     "               AND aag00 = '",g_aaz.aaz64,"'",
                     "               AND aag43 = 'Y'",
                     "               AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "               AND aag15 Is Not Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "               AND npq21 = npq11",
                     "               AND npq21 = apf03",
                     "               AND npq06 = '1'",
                     "               AND apf01 = apa01",
                     "               AND a.apa01 = b.apa01)",
                     "    AND NOT EXISTS (",
                     "            SELECT 1 FROM apa_file c,npq_file,aag_file,aph_file",
                     "             WHERE apa01 = npq01",
                     "               AND npq03 = aag01",
                     "               AND aag00 = '",g_aaz.aaz64,"'",
                     "               AND aag43 = 'Y'",
                     "               AND npqsys = 'AP' ",    #No.TQC-D70023   Add
                     "               AND aag15 Is Not Null AND aag15 != ' '",   #No.TQC-D70023   Add
                     "               AND npq21 = npq11",
                     "               AND npq21 = aph21",
                     "               AND aph01 = apa01",
                     "               AND npq06 = '2'",
                     "               AND a.apa01 = c.apa01)",
                     "    AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_apa4 FROM g_sql
         EXECUTE q901_apa4
        #apa_file 判斷单身科目是否正确
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',apa01,'','','','','','N','','apa'||apa00 FROM apa_file,aag_file,apb_file ",
                     "  WHERE apa01 = apb01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag19 = '5'",
                     "    AND apb25 = aag01",
                     "    AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_apa5 FROM g_sql
         EXECUTE q901_apa5
        #apa_file 判斷分录科目是否正确
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',apa01,'','','','','','N','','apa'||apa00 FROM apa_file,aag_file,npq_file ",
                     "  WHERE apa01 = npq01",
                     "    AND aag00 = '",g_aaz.aaz64,"'",
                     "    AND aag19 = '5'",
                     "    AND npq03 = aag01",
                     "    AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_apa6 FROM g_sql
         EXECUTE q901_apa6
        #apf_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',apf01,apf41,CASE apydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','apf'||apf00 ",
                     "   FROM apf_file LEFT OUTER JOIN apy_file ON apf01 like rtrim(ltrim(apyslip)) || '-%'",
                     "  WHERE apf02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND apfacti = 'Y' ",
                     "    AND apf00 NOT IN ('11','16')",
                     "    AND apf44 Is Null"
         PREPARE q901_apf FROM g_sql
         EXECUTE q901_apf
        #ala_file 判斷審核否、拋轉否(預購開狀)
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',ala01,alafirm,'N','','','','','','aapt710' ",
                     "   FROM ala_file ",
                     "  WHERE ala08 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND alaacti = 'Y' ",
                     "    AND (alaclos IS NULL OR alaclos<> 'Y') ",
                     "    AND ala72 Is Null"
         PREPARE q901_ala FROM g_sql
         EXECUTE q901_ala
        #ala_file 判斷審核否(開狀付款)
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',ala01,alafirm,'','','','','','','aapt710' ",
                     "   FROM ala_file ",
                     "  WHERE ala78 = 'N'",
                     "    AND ala08 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND (alaclos IS NULL OR alaclos<> 'Y') ",
                     "    AND ala34+ala56+ala53+ala54 > 0 ",
                     "    AND alaacti ='Y' "
         PREPARE q901_ala1 FROM g_sql
         EXECUTE q901_ala1
        #alc_file 判斷審核否(預購修改)
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',alc01,alcfirm,'','','','','','','aapt740' ",
                     "   FROM alc_file ",
                     "  WHERE alc72 Is Null ",
                     "    AND alc08 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND alcacti = 'Y' "
         PREPARE q901_alc FROM g_sql
         EXECUTE q901_alc
        #alc_file 判斷審核否(修改付款)
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',alc01,alc78,'','','','','','','aapt740' ",
                     "   FROM alc_file ",
                     "  WHERE alc78 = 'N'",
                     "    AND alc08 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND alc34+alc56+alc53+alc54 > 0 ",
                     "    AND alcacti = 'Y' "
         PREPARE q901_alc1 FROM g_sql
         EXECUTE q901_alc1
        #alk_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',alk01,alkfirm,'N','','','','','','aapt810' ",
                     "   FROM alk_file ",
                     "  WHERE alk02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND alkacti = 'Y' ",
                     "    AND alk72 Is Null "
         PREPARE q901_alk FROM g_sql
         EXECUTE q901_alk
        #alh_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',alh01,alhfirm,'N','','','','','','aapt820' ",
                     "   FROM alh_file ",
                     "  WHERE alh021 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND alhacti = 'Y' ",
                     "    AND alh72 Is Null "
         PREPARE q901_alh FROM g_sql
         EXECUTE q901_alh
        #als_file 判斷審核否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',als01,alsfirm,'','','','','','','aapt800' ",
                     "   FROM als_file ",
                     "  WHERE als02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND alsacti = 'Y' "
         PREPARE q901_als FROM g_sql
         EXECUTE q901_als
        #als_file 判斷審核否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT 'AAP',aqa01,aqaconf,'N','','','','','',CASE WHEN aqa00 = '1' THEN 'aapt900' ELSE 'aapt910' END CASE ",
                     "   FROM als_file ",
                     "  WHERE als02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND aqa05 Is Null",
                     "    AND alsacti = 'Y' "
         PREPARE q901_aqa FROM g_sql
         EXECUTE q901_aqa
         CALL q901_aap()   #已扣帳未立帳
         CALL q901_aap1()  #rvv料件科目与apb25不一致
      WHEN tm.sys = '3'    #ANM
        #nmd_file 判斷審核否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nmd01,nmd30,'','','','','','','anmt100' FROM nmd_file",
                     "  WHERE nmd30 = 'N'",
                     "    AND nmd07 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nmd FROM g_sql
         EXECUTE q901_nmd
        #oox_file 判斷拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AAP',oox00||'/'||oox01||'/'||oox02,'','N','','','','','',oox00 ",
                     "   FROM oox_file LEFT OUTER JOIN npp_file ON npp01 = 'NM'||oox01||'0'||oox02 ",
                     "  WHERE oox02 < 10 ",
                     "    AND oox01 = '",tm.yy,"'",
                     "    AND oox02 = '",tm.mm,"'",
                     "    AND nppglno Is Null",
                     "    AND oox00 IN('NM','NR','NP')",
                     "UNION",
                     " SELECT DISTINCT 'AAP',oox00||'/'||oox01||'/'||oox02,'','N','','','','','',oox00 ",
                     "   FROM oox_file LEFT OUTER JOIN npp_file ON npp01 = 'NM'||oox01||oox02",
                     "  WHERE oox02 > 9 ",
                     "    AND oox01 = '",tm.yy,"'",
                     "    AND oox02 = '",tm.mm,"'",
                     "    AND nppglno Is Null",
                     "    AND oox00 IN('NM','NR','NP')"
         PREPARE q901_oox_nm FROM g_sql
         EXECUTE q901_oox_nm
        #npl_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',npl01,nplconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt150'",
                     "   FROM npl_file LEFT OUTER JOIN nmy_file ON npl01 like rtrim(ltrim(nmyslip)) || '-%' ",
                     "  WHERE npl09 IS Null ",
                     "    AND npl02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_npl FROM g_sql
         EXECUTE q901_npl
        #nmh_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nmh01,nmh38,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt200'",
                     "   FROM nmh_file LEFT OUTER JOIN nmy_file ON nmh01 like rtrim(ltrim(nmyslip)) || '-%'",
                     "  WHERE nmh33 IS Null ",
                     "    AND nmh38 != 'X'",
                     "    AND nmh04 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nmh FROM g_sql
         EXECUTE q901_nmh
        #npn_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',npn01,npnconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt250'",
                     "   FROM npn_file LEFT OUTER JOIN nmy_file ON npn01 like rtrim(ltrim(nmyslip)) || '-%' ",
                     "  WHERE npn09 IS Null ",
                     "    AND npnconf != 'X'",
                     "    AND npn02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_npn FROM g_sql
         EXECUTE q901_npn
        #nmg_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nmg00,nmgconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt302'",
                     "   FROM nmg_file LEFT OUTER JOIN nmy_file ON nmg00 like rtrim(ltrim(nmyslip)) || '-%'",
                     "  WHERE nmg13 IS Null ",
                     "    AND nmgconf != 'X'",
                     "    AND nmg20 <> '21' ",
                     "    AND nmg01 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nmg FROM g_sql
         EXECUTE q901_nmg
        #nne_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nne01,nneconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt710'",
                     "   FROM nne_file LEFT OUTER JOIN nmy_file ON nne01 like rtrim(ltrim(nmyslip)) || '-%' ",
                     "  WHERE nneglno IS Null ",
                     "    AND nneconf != 'X'",
                     "    AND nne02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nne FROM g_sql
         EXECUTE q901_nne
        #nng_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nng01,nngconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt720'",
                     "   FROM nng_file LEFT OUTER JOIN nmy_file ON nng01 like rtrim(ltrim(nmyslip)) || '-%'",
                     "  WHERE nngglno IS Null ",
                     "    AND nngconf != 'X'",
                     "    AND nng02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nng FROM g_sql
         EXECUTE q901_nng
        #nni_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nni01,nniconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt740'",
                     "   FROM nni_file LEFT OUTER JOIN nmy_file ON nni01 like rtrim(ltrim(nmyslip)) || '-%' ",
                     "  WHERE nniglno IS Null ",
                     "    AND nniconf != 'X'",
                     "    AND nni02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nni FROM g_sql
         EXECUTE q901_nni
        #nnk_file 判斷審核否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'ANM',nnk01,nnkconf,CASE nmydmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','','anmt750'",
                     "   FROM nnk_file LEFT OUTER JOIN nmy_file ON nnk01 like rtrim(ltrim(nmyslip)) || '-%' ",
                     "  WHERE nnkglno IS Null ",
                     "    AND nnkconf != 'X'",
                     "    AND nnk02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_nnk FROM g_sql
         EXECUTE q901_nnk
      WHEN tm.sys = '4'    #AFA
        #faq_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',faq01,faqconf,faqpost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','afat101'",
                     "   FROM faq_file LEFT OUTER JOIN fah_file ON faq01 like rtrim(ltrim(fahslip)) || '-%'",
                     "  WHERE faqconf != 'X'",
                     "    AND faq06 Is Null",
                     "    AND faq02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_faq FROM g_sql
         EXECUTE q901_faq
        #fas_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fas01,fasconf,faspost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','afat102'",
                     "   FROM fas_file LEFT OUTER JOIN fah_file ON fas01 like rtrim(ltrim(fahslip)) || '-%'",
                     "  WHERE fasconf != 'X'",
                     "    AND fas07 Is Null",
                     "    AND fas02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fas FROM g_sql
         EXECUTE q901_fas
        #fau_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fau01,fauconf,'N','','','','','','afat103'",
                     "   FROM fau_file",
                     "  WHERE fauconf != 'X'",
                     "    AND faupost = 'N'",
                     "    AND fau02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fau FROM g_sql
         EXECUTE q901_fau
        #faw_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',faw01,fawconf,'N','','','','','','afat104' FROM faw_file",
                     "  WHERE fawconf != 'X'",
                     "    AND fawpost = 'N'",
                     "    AND faw02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_faw FROM g_sql
         EXECUTE q901_faw
        #fay_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fay01,fayconf,faypost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','afat105'",
                     "   FROM fay_file LEFT OUTER JOIN fah_file ON fay01 like rtrim(ltrim(fahslip)) || '-%'",
                     "  WHERE fayconf != 'X'",
                     "    AND fay06 Is Null",
                     "    AND fay02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fay FROM g_sql
         EXECUTE q901_fay
        #fba_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fba01,fbaconf,fbapost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','afat106'",
                     "   FROM fba_file LEFT OUTER JOIN fah_file ON fba01 like rtrim(ltrim(fahslip)) || '-%' ",
                     "  WHERE fbaconf != 'X'",
                     "    AND fba06 Is Null",
                     "    AND fba02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fba FROM g_sql
         EXECUTE q901_fba
        #fbc_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fbc01,fbcconf,fbcpost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','afat106'",
                     "   FROM fbc_file LEFT OUTER JOIN fah_file ON fbc01 like rtrim(ltrim(fahslip)) || '-%' ",
                     "  WHERE fbcconf != 'X'",
                     "    AND fbc06 Is Null",
                     "    AND fbc02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fbc FROM g_sql
         EXECUTE q901_fbc
        #fbg_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fbg01,fbgconf,fbgpost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','',",
                     "                 CASE WHEN fbg00 = '1' THEN 'afat108' ELSE 'afat109' END CASE",
                     "   FROM fbg_file LEFT OUTER JOIN fah_file ON fbg01 like rtrim(ltrim(fahslip)) || '-%' ",
                     "  WHERE fbgconf != 'X'",
                     "    AND fbg08 Is Null",
                     "    AND fbg02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fbg FROM g_sql
         EXECUTE q901_fbg
        #fbe_file 判斷審核否、過帳否、拋轉否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fbe01,fbeconf,fbepost,CASE fahdmy3 WHEN 'Y' THEN 'N' ELSE '' END CASE,'','','','','afat110'",
                     "   FROM fbe_file LEFT OUTER JOIN fah_file ON fbe01 like rtrim(ltrim(fahslip)) || '-%'",
                     "  WHERE fbeconf != 'X'",
                     "    AND fbe14 Is Null",
                     "    AND fbe02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fbe FROM g_sql
         EXECUTE q901_fbe
        #fbl_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fbl01,fblconf,'N','','','','','','afat111' FROM fbl_file",
                     "  WHERE fblconf != 'X'",
                     "    AND fblpost = 'N'",
                     "    AND fbl02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fbl FROM g_sql
         EXECUTE q901_fbl
        #fbs_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fbs01,fbsconf,'N','','','','','','gfat120' FROM fbs_file",
                     "  WHERE fbsconf != 'X'",
                     "    AND fbspost = 'N'",
                     "    AND fbs02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fbs FROM g_sql
         EXECUTE q901_fbs
        #fgh_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fgh01,'N','','','','','','','afai102' FROM fgh_file",
                     "  WHERE fghconf = 'N'",
                     "    AND fgh02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fgh FROM g_sql
         EXECUTE q901_fgh
        #fec_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fec01,'N','','','','','','','afat300' FROM fec_file",
                     "  WHERE fecconf = 'N'",
                     "    AND fec02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fec FROM g_sql
         EXECUTE q901_fec
        #fee_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AFA',fee01,'N','','','','','','','afat305' FROM fee_file",
                     "  WHERE feeconf = 'N'",
                     "    AND fee02 BETWEEN '",b_date,"' AND '",e_date,"'"
         PREPARE q901_fee FROM g_sql
         EXECUTE q901_fee
         CALL q901_afa()  #判斷應折而未折
      WHEN tm.sys = '5'    #AGL
        #nnk_file 判斷審核否、過帳否
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AGL',aba01,aba19,'N','','','','','',aba06 FROM aba_file",
                     "  WHERE abapost = 'N' ",
                     "    AND aba19 != 'X'",
                     "    AND aba03 = '",tm.yy,"'",
                     "    AND aba04 = '",tm.mm,"'"
         PREPARE q901_aba FROM g_sql
         EXECUTE q901_aba
      WHEN tm.sys = '6'    #AXC
        #ima_file 當料件來源碼(ima08)為M或P時,ima39是否為空
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',ima01,'N','','','','','','','aimi100' FROM ima_file",
                     "  WHERE ima08 IN ( 'M','P') ",
                     "    AND ima39 IS Null"
         PREPARE q901_ima FROM g_sql
         EXECUTE q901_ima
        #ccz_file 檢查會計科目頁簽裡面的科目是否有為空
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',ccz00,'','N','','','','','','axcs010' FROM ccz_file",
                     "  WHERE ccz14 IS Null OR ccz15 Is Null ",
                     "     OR ccz33 Is Null OR ccz34 Is Null ",
                     "     OR ccz35 Is Null OR ccz36 Is Null ",
                     "     OR ccz16 Is Null OR ccz17 Is Null ",
                     "     OR ccz18 Is Null OR ccz19 Is Null ",
                     "     OR ccz24 Is Null OR ccz25 Is Null ",
                     "     OR ccz20 Is Null OR ccz21 Is Null ",
                     "     OR ccz37 Is Null OR ccz38 Is Null ",
                     "     OR ccz39 Is Null OR ccz40 Is Null ",
                     "     OR ccz22 Is Null OR ccz29 Is Null ",
                     "     OR (ccz43 = 'Y' AND ccz44 Is Null) "
         PREPARE q901_ccz FROM g_sql
         EXECUTE q901_ccz
        #azf_file 雜收發理由碼科目檢查/成本分群碼是否為空
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',azf01,'','','N','','','','','aooi312' FROM azf_file",
                     "  WHERE azf02 = 'G'  ",
                     "    AND (azf05 IS Null OR azf07 IS Null OR azf14 IS Null)"
         PREPARE q901_azf FROM g_sql
         EXECUTE q901_azf
         
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',azf01,'','','N','','','','','aooi313' FROM azf_file",
                     "  WHERE azf02 = '2'  ",
                     "    AND (azf07 IS Null OR azf14 IS Null OR azf20 IS Null OR azf21 IS Null)"
         PREPARE q901_azf1 FROM g_sql
         EXECUTE q901_azf1
        #成本分錄作業的單身科目檢查
        #axct320
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cde05,'','','','N','','','','axct320' ",
                     "   FROM cde_file,cdf_file",
                     "  WHERE cde01 = cdf01 ",
                     "    AND cde02 = cdf02 ",
                     "    AND cde03 = cdf03 ",
                     "    AND cde04 = cdf04 ",
                     "    AND cde06 = cdf05 ",
                     "    AND cde07 = cdf06 ",
                     "    AND (cde09 Is Null OR cdf08 Is Null)",
                     "    AND cde02 = '",tm.yy,"'",
                     "    AND cde03 = '",tm.mm,"'"
         PREPARE q901_cde FROM g_sql
         EXECUTE q901_cde
        #axct328
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdg05,'','','','N','','','','axct328' ",
                     "   FROM cdg_file,cdh_file",
                     "  WHERE cdg01 = cdh01 ",
                     "    AND cdg02 = cdh02 ",
                     "    AND cdg03 = cdh03 ",
                     "    AND cdg04 = cdh04 ",
                     "    AND cdg06 = cdh05 ",
                     "    AND cdg07 = cdh06 ",
                     "    AND (cdg09 Is Null OR cdh08 Is Null)",
                     "    AND cdg00 = '1' ",
                     "    AND cdg02 = '",tm.yy,"'",
                     "    AND cdg03 = '",tm.mm,"'"
         PREPARE q901_cdg FROM g_sql
         EXECUTE q901_cdg
        #axct326
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdm04,'','','','N','','','','axct326' ",
                     "   FROM cdm_file",
                     "  WHERE cdm07 Is Null",
                     "    AND cdm00 = '1' ",
                     "    AND cdm02 = '",tm.yy,"'",
                     "    AND cdm03 = '",tm.mm,"'"
         PREPARE q901_cdm FROM g_sql
         EXECUTE q901_cdm
        #axct327
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdg05,'','','','N','','','','axct327' ",
                     "   FROM cdg_file,cdh_file",
                     "  WHERE cdg01 = cdh01 ",
                     "    AND cdg02 = cdh02 ",
                     "    AND cdg03 = cdh03 ",
                     "    AND cdg04 = cdh04 ",
                     "    AND cdg06 = cdh05 ",
                     "    AND cdg07 = cdh06 ",
                     "    AND cdg00 = '2' ",
                     "    AND (cdg09 Is Null OR cdh08 Is Null)",
                     "    AND cdg02 = '",tm.yy,"'",
                     "    AND cdg03 = '",tm.mm,"'"
         PREPARE q901_cdg1 FROM g_sql
         EXECUTE q901_cdg1
        #axct322
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdj13,'','','','N','','','','axct322' ",
                     "   FROM cdj_file",
                     "  WHERE (cdj08 Is Null OR cdj09 Is Null)",
                     "    AND cdj00 = '1' ",
                     "    AND cdj02 = '",tm.yy,"'",
                     "    AND cdj03 = '",tm.mm,"'"
         PREPARE q901_cdj FROM g_sql
         EXECUTE q901_cdj
        #axct323
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdk04,'','','','N','','','','axct323' ",
                     "   FROM cdk_file",
                     "  WHERE cdk07 Is Null",
                     "    AND cdk02 = '",tm.yy,"'",
                     "    AND cdk03 = '",tm.mm,"'"
         PREPARE q901_cdk FROM g_sql
         EXECUTE q901_cdk
        #axct330
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdj13,'','','','N','','','','axct330' ",
                     "   FROM cdj_file",
                     "  WHERE (cdj08 Is Null OR cdj09 Is Null)",
                     "    AND cdj00 = '2' ",
                     "    AND cdj02 = '",tm.yy,"'",
                     "    AND cdj03 = '",tm.mm,"'"
         PREPARE q901_cdj1 FROM g_sql
         EXECUTE q901_cdj1
        #axct331
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdj13,'','','','N','','','','axct331' ",
                     "   FROM cdj_file",
                     "  WHERE (cdj08 Is Null OR cdj09 Is Null)",
                     "    AND cdj00 = '3' ",
                     "    AND cdj02 = '",tm.yy,"'",
                     "    AND cdj03 = '",tm.mm,"'"
         PREPARE q901_cdj2 FROM g_sql
         EXECUTE q901_cdj2
        #axct329
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdm04,'','','','N','','','','axct329' ",
                     "   FROM cdm_file",
                     "  WHERE cdm07 Is Null",
                     "    AND cdm00 = '2' ",
                     "    AND cdm02 = '",tm.yy,"'",
                     "    AND cdm03 = '",tm.mm,"'"
         PREPARE q901_cdm1 FROM g_sql
         EXECUTE q901_cdm1
        #axct311
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdb11,'','','','N','','','','axct311' ",
                     "   FROM cdb_file",
                     "  WHERE cdb12 Is Null",
                     "    AND cdb01 = '",tm.yy,"'",
                     "    AND cdb02 = '",tm.mm,"'"
         PREPARE q901_cdb FROM g_sql
         EXECUTE q901_cdb
        #axct311里面的成本中心cdb03，是否存在于axrt200里面的cci02
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXC',cdb11,'','','','','N','','','axct311' ",
                     "   FROM cdb_file a",
                     "  WHERE NOT EXISTS (", 
                     "           SELECT 1 FROM cdb_file b,cci_file",
                     "            WHERE cdb01 = '",tm.yy,"'",
                     "              AND cdb02 = '",tm.mm,"'",
                     "              AND cci01 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "              AND cci02 = cdb03 ",
                     "              AND a.cdb01 = b.cdb01", 
                     "              AND a.cdb02 = b.cdb02",
                     "              AND a.cdb03 = b.cdb03 ",
                     "              AND a.cdb04 = b.cdb04",
                     "              AND a.cdb08 = b.cdb08 ",
                     "              AND a.cdb11 = b.cdb11)",
                     "    AND cdb02 = '",tm.yy,"'",
                     "    AND cdb03 = '",tm.mm,"'"
         PREPARE q901_cdb1 FROM g_sql
         EXECUTE q901_cdb1

   END CASE
   DISPLAY tm.yy TO yy
   DISPLAY tm.mm TO mm
   DISPLAY tm.sys TO sys
END FUNCTION

FUNCTION q901_menu()

   WHILE TRUE
      CALL q901_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q901_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_oma),'','')
             END IF
         WHEN "details"
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  CALL q901_detail()
               END IF
            END IF
        #No.TQC-D70023 ---Add--- Start
         WHEN "accept"
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  CALL q901_detail()
               END IF
            END IF
        #No.TQC-D70023 ---Add--- End
      END CASE
   END WHILE
END FUNCTION

FUNCTION q901_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL q901_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL q901_b_fill()
   MESSAGE ''
END FUNCTION

FUNCTION q901_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000
   DEFINE l_oma01   LIKE oma_file.oma01
   DEFINE l_flag1   LIKE type_file.chr1
   DEFINE l_flag2   LIKE type_file.chr1
   DEFINE l_flag3   LIKE type_file.chr1
   DEFINE l_flag4   LIKE type_file.chr1
   DEFINE l_flag5   LIKE type_file.chr1
   DEFINE l_flag6   LIKE type_file.chr1
   DEFINE l_flag7   LIKE type_file.chr1
   DEFINE l_zz01    LIKE zz_file.zz01
   DEFINE l_msg     STRING
   DEFINE l_sys     LIKE type_file.chr5
   DEFINE l_oma     STRINg

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " ORDER BY prog,oma01"
   PREPARE q901_pre FROM l_sql
   IF STATUS THEN CALL cl_err('q901_pre',STATUS,1) END IF
   DECLARE q901_bcs CURSOR FOR q901_pre

   FOR g_cnt = 1 TO g_oma.getLength()           #單身 ARRAY 乾洗
      INITIALIZE g_oma[g_cnt].* TO NULL
   END FOR
   LET g_cnt = 1
   LET g_tot = 0
   FOREACH q901_bcs INTO l_sys,l_oma01,l_flag1,l_flag2,l_flag3,
                         l_flag4,l_flag5,l_flag6,l_flag7,l_zz01
      IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
      LET l_msg = NULL
      CALL q901_msg(l_flag1,l_flag2,l_flag3,l_flag4,l_flag5,l_flag6,l_flag7) RETURNING l_msg
      IF l_zz01 = 'axmt670' OR l_zz01 = 'axmt620' THEN LET l_msg = cl_getmsg('agl-298',g_lang) END IF
      LET g_oma[g_cnt].oma01 = l_oma01
      LET g_oma[g_cnt].prog  = l_zz01
      LET g_oma[g_cnt].msg   = l_msg
      IF cl_null(g_oma[g_cnt].msg) THEN CONTINUE FOREACH END IF
      CASE
         WHEN tm.sys = '2'  #AAP
            CASE
               WHEN g_oma[g_cnt].prog = 'apa11' LET g_oma[g_cnt].prog = 'aapt110'
               WHEN g_oma[g_cnt].prog = 'apa12' LET g_oma[g_cnt].prog = 'aapt120'
               WHEN g_oma[g_cnt].prog = 'apa13' LET g_oma[g_cnt].prog = 'aapt121'
               WHEN g_oma[g_cnt].prog = 'apa14' LET g_oma[g_cnt].prog = 'aapt140'  #MOD-DC0024 add
               WHEN g_oma[g_cnt].prog = 'apa15' LET g_oma[g_cnt].prog = 'aapt150'
               WHEN g_oma[g_cnt].prog = 'apa16' LET g_oma[g_cnt].prog = 'aapt160'
               WHEN g_oma[g_cnt].prog = 'apa17' LET g_oma[g_cnt].prog = 'aapt151'
               WHEN g_oma[g_cnt].prog = 'apa21' LET g_oma[g_cnt].prog = 'aapt210'
               WHEN g_oma[g_cnt].prog = 'apa22' LET g_oma[g_cnt].prog = 'aapt220'
               WHEN g_oma[g_cnt].prog = 'apa23' LET g_oma[g_cnt].prog = 'aapq230'
               WHEN g_oma[g_cnt].prog = 'apa24' LET g_oma[g_cnt].prog = 'aapq240'
               WHEN g_oma[g_cnt].prog = 'apa25' LET g_oma[g_cnt].prog = 'aapq231'
               WHEN g_oma[g_cnt].prog = 'apa26' LET g_oma[g_cnt].prog = 'aapt260'
               WHEN g_oma[g_cnt].prog = 'apf33' LET g_oma[g_cnt].prog = 'aapt330'
               WHEN g_oma[g_cnt].prog = 'apf34' LET g_oma[g_cnt].prog = 'aapt331'
               WHEN g_oma[g_cnt].prog = 'apf32' LET g_oma[g_cnt].prog = 'aapt332'
               WHEN g_oma[g_cnt].prog = 'apf36' LET g_oma[g_cnt].prog = 'aapt335'

               WHEN g_oma[g_cnt].prog = 'rvu1'  LET g_oma[g_cnt].prog = 'apmt720'
               WHEN g_oma[g_cnt].prog = 'rvu2'  LET g_oma[g_cnt].prog = 'apmt721'
               WHEN g_oma[g_cnt].prog = 'rvu3'  LET g_oma[g_cnt].prog = 'apmt722'
            END CASE  
         WHEN tm.sys = '5'  #AGL
            CASE
               WHEN g_oma[g_cnt].prog = 'AC' LET g_oma[g_cnt].prog = 'aglt130'
               WHEN g_oma[g_cnt].prog = 'RV' LET g_oma[g_cnt].prog = 'aglt120'
               OTHERWISE                     LET g_oma[g_cnt].prog = 'aglt110'
            END CASE  
         WHEN tm.sys = '6'  #AXC
            IF g_oma[g_cnt].prog = 'axct311' THEN
               LET l_oma = tm.yy,"/",tm.mm,"/",g_oma[g_cnt].oma01
               DISPLAY l_oma TO oma01
            END IF
      END CASE
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_oma.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY BY NAME g_tot
END FUNCTION

FUNCTION q901_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        #No.TQC-D70023 ---Add--- Start
         IF g_rec_b != 0 AND l_ac > 0 AND NOT cl_null(l_ac) THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
        #No.TQC-D70023 ---Add--- End

      #BEFORE ROW
      CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

     #No.TQC-D70023 ---Add--- Start
      ON ACTION accept
         LET g_action_choice = 'accept'
         EXIT DISPLAY
     #No.TQC-D70023 ---Add--- End

      ON ACTION details
         LET g_action_choice = 'details'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q901_detail()
   DEFINE l_msg      STRING

   LET g_msg =''
   CASE
     #AXR
      WHEN g_oma[l_ac].prog = "axrt200"
         LET g_msg ="axrt200 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axrt201"
         LET g_msg ="axrt201 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axrt210"
         LET g_msg ="axrt210 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axrt300"
         LET g_msg ="axrt300 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axrt400"
         LET g_msg ="axrt400 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
      WHEN g_oma[l_ac].prog = "axrt401"                                       #No.TQC-D70023   Add
         LET g_msg ="axrt400 '",g_oma[l_ac].oma01 CLIPPED,"' 'query' '33'"    #No.TQC-D70023   Add
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axmt670"
         LET g_msg ="axmt670 '",g_oma[l_ac].oma01 CLIPPED,"' 'q'    "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axmt620"
         LET g_msg ="axmt620 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "gxrq600"
         LET l_msg =' oox01="',tm.yy CLIPPED,'" AND oox02 = "',tm.mm,'"'
         LET g_msg ="gxrq600 '",l_msg,"'                            "
         CALL cl_cmdrun(g_msg) RETURN
     #AAP
      WHEN g_oma[l_ac].prog = "aapq230"
         LET g_msg ="aapq230 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapq231"
         LET g_msg ="aapq231 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapq240"
         LET g_msg ="aapq240 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt110"
         LET g_msg ="aapt110 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt120"
         LET g_msg ="aapt120 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt121"
         LET g_msg ="aapt121 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      #MOD-DC0024---add--begin
      WHEN g_oma[l_ac].prog = "aapt140"
         LET g_msg ="aapt140 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      #MOD-DC0024---add--end
      WHEN g_oma[l_ac].prog = "aapt150"
         LET g_msg ="aapt150 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt151"
         LET g_msg ="aapt151 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt160"
         LET g_msg ="aapt160 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt210"
         LET g_msg ="aapt210 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt220"
         LET g_msg ="aapt220 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt260"
         LET g_msg ="aapt260 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt330"
         LET g_msg ="aapt330 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt331"
         LET g_msg ="aapt331 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt332"
         LET g_msg ="aapt332 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt335"
         LET g_msg ="aapt335 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt710"
         LET g_msg ="aapt710 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt740"
         LET g_msg ="aapt740 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt810"
         LET g_msg ="aapt810 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt820"
         LET g_msg ="aapt820 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt800"
         LET g_msg ="aapt800 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt900"
         LET g_msg ="aapt900 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aapt910"
         LET g_msg ="aapt910 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "apmt720"
         LET g_msg ="apmt720 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "apmt721"
         LET g_msg ="apmt721 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "apmt722"
         LET g_msg ="apmt722 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "gapq600"
         LET l_msg =' oox01="',tm.yy CLIPPED,'" AND oox02 = "',tm.mm,'"'
         LET g_msg ="gapq600 '",l_msg,"'                            "
         CALL cl_cmdrun(g_msg) RETURN
     #ANM
      WHEN g_oma[l_ac].prog = "anmt100"
         LET g_msg ="anmt100 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt150"
         LET g_msg ="anmt150 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt200"
         LET g_msg ="anmt200 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt250"
         LET g_msg ="anmt250 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt302"
         LET g_msg ="anmt302 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt710"
         LET g_msg ="anmt710 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt720"
         LET g_msg ="anmt720 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt740"
         LET g_msg ="anmt740 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "anmt750"
         LET g_msg ="anmt750 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "NM"
         LET l_msg =' oox01="',tm.yy CLIPPED,'" AND oox02 = "',tm.mm,'"'
         LET g_msg ="gnmq600 '",l_msg,"'                            "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "NR"
         LET l_msg =' oox01="',tm.yy CLIPPED,'" AND oox02 = "',tm.mm,'"'
         LET g_msg ="gnmq610 '1' '",l_msg,"'                        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "NP"
         LET l_msg =' oox01="',tm.yy CLIPPED,'" AND oox02 = "',tm.mm,'"'
         LET g_msg ="gnmq610 '2' '",l_msg,"'                        "
         CALL cl_cmdrun(g_msg) RETURN
     #AFA
      WHEN g_oma[l_ac].prog = "afai100"
         LET g_msg ="afai100 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat101"
         LET g_msg ="afat101 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat102"
         LET g_msg ="afat102 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat103"
         LET g_msg ="afat103 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat104"
         LET g_msg ="afat104 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat105"
         LET g_msg ="afat105 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat106"
         LET g_msg ="afat106 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat107"
         LET g_msg ="afat107 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat108"
         LET g_msg ="afat108 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat109"
         LET g_msg ="afat109 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat110"
         LET g_msg ="afat110 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat111"
         LET g_msg ="afat111 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "gfat120"
         LET g_msg ="gfat120 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afai102"
         LET g_msg ="afai102 '1' '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat300"
         LET g_msg ="afat300 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "afat305"
         LET g_msg ="afat305 '",g_oma[l_ac].oma01 CLIPPED,"' 'query'"
         CALL cl_cmdrun(g_msg) RETURN
     #AGL
      WHEN g_oma[l_ac].prog = "aglt110"
         LET g_msg ="aglt110 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aglt130"
         LET g_msg ="aglt130 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aglt120"
         LET g_msg ="aglt120 '",g_aaz.aaz64,"' '",g_oma[l_ac].oma01 CLIPPED,"'"
         CALL cl_cmdrun(g_msg) RETURN
     #AXC
      WHEN g_oma[l_ac].prog = "aimi100"
         LET g_msg ="aimi100 '",g_oma[l_ac].oma01 CLIPPED,"'        "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axcs010"
         LET g_msg ="axcs010 "
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aooi312"
         LET g_msg ="aooi300 'G' '",g_oma[l_ac].oma01 CLIPPED,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "aooi313"
         LET g_msg ="aooi300 'H' '",g_oma[l_ac].oma01 CLIPPED,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct320"
         LET l_msg =' cde05="',g_oma[l_ac].oma01 CLIPPED,'" AND (cde09 Is Null OR cdf08 Is Null)'
         LET g_msg ="axct320 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct327"
         LET l_msg =' cdg05="',g_oma[l_ac].oma01 CLIPPED,'" AND (cdg09 Is Null OR cdh08 Is Null)'
         LET g_msg ="axct321 '2' '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct328"
         LET l_msg =' cdg05="',g_oma[l_ac].oma01 CLIPPED,'" AND (cdg09 Is Null OR cdh08 Is Null)'
         LET g_msg ="axct321 '1' '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct328"
         LET l_msg =' cdg05="',g_oma[l_ac].oma01 CLIPPED,'" AND (cdg09 Is Null OR cdh08 Is Null)'
         LET g_msg ="axct321 '1' '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct322"
         LET l_msg =' cdj13="',g_oma[l_ac].oma01 CLIPPED,'" AND (cdj09 Is Null OR cdj08 Is Null)'
         LET g_msg ="axct322 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct330"
         LET l_msg =' cdj13="',g_oma[l_ac].oma01 CLIPPED,'" AND (cdj09 Is Null OR cdj08 Is Null)'
         LET g_msg ="axct330 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct329"
         LET l_msg =' cdm10="',g_oma[l_ac].oma01 CLIPPED,'" AND cdm07 Is Null'
         LET g_msg ="axct329 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct326"
         LET l_msg =' cdm10="',g_oma[l_ac].oma01 CLIPPED,'" AND cdm07 Is Null'
         LET g_msg ="axct326 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct331"
         LET l_msg =' cdj13="',g_oma[l_ac].oma01 CLIPPED,'" AND (cdj09 Is Null OR cdj08 Is Null)'
         LET g_msg ="axct331 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct311"
         LET l_msg =' cdb11="',g_oma[l_ac].oma01 CLIPPED,'" AND cdb01 = "',tm.yy,'" AND cdb02 = "',tm.mm,'" AND cdb12 Is Null'
         LET g_msg ="axct311 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
      WHEN g_oma[l_ac].prog = "axct323"
         LET l_msg =' cdk10="',g_oma[l_ac].oma01 CLIPPED,'" AND cdk07 Is Null'
         LET g_msg ="axct323 '",l_msg,"'"
         CALL cl_cmdrun(g_msg) RETURN
   END CASE

END FUNCTION

FUNCTION q901_msg(p_flag1,p_flag2,p_flag3,p_flag4,p_flag5,p_flag6,p_flag7)
   DEFINE p_flag1      LIKE type_file.chr1
   DEFINE p_flag2      LIKE type_file.chr1
   DEFINE p_flag3      LIKE type_file.chr1
   DEFINE p_flag4      LIKE type_file.chr1
   DEFINE p_flag5      LIKE type_file.chr1
   DEFINE p_flag6      LIKE type_file.chr1
   DEFINE p_flag7      LIKE type_file.chr1
   DEFINE l_msg        STRING

   CASE
     #p_flag1:審核否                     p_flag2:拋轉否
     #p_flag3:財務確認否                 p_flag4:分錄與單據科目一致
     #p_flag5:分錄核算項與單據廠商是否一致  p_flag6:多帳期金額與單據金額是否一致
     #p_flag7:單身科目是否符合
      WHEN tm.sys = '1'   #AXR
         IF NOT cl_null(p_flag1) AND p_flag1 = 'N' THEN  #未審核
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('apm-381',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('apm-381',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag2) AND p_flag2 = 'N' THEN  #未拋轉
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei Mark
           #ELSE
           #   LET l_msg = l_msg,"/",cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei Mark
            END IF
         END IF
         IF NOT cl_null(p_flag3) AND p_flag3 = 'N' THEN  #財務未確認
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-290',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-290',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag4) AND p_flag4 = 'N' THEN  #分錄與單據科目不一致
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-293',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-293',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag5) AND p_flag5 = 'N' THEN  #分錄核算項與單據廠商不一致
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-295',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-295',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag6) AND p_flag6 = 'N' THEN  #多帳期金額與單據金額不一致
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-294',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-294',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag7) AND p_flag7 = 'N' THEN  #單身科目不符合
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-296',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-296',g_lang)
            END IF
         END IF
     #p_flag1:審核否                   p_flag2:拋轉否
     #p_flag3:分錄與單據科目不一致        p_flag4:多帳期金額與單據金額不一致 
     #p_flag5:分錄核算項與單據廠商不一致   p_flag6:单身科目錯誤
     #p_flag7:'+':apa51='STOCK' rvv料件科目與立帳的apb25不一致/ '-':已扣帳未立帳
      WHEN tm.sys = '2'   #AAP
         IF NOT cl_null(p_flag1) AND p_flag1 = 'N' THEN  #未審核
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('apm-381',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('apm-381',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag2) AND p_flag2 = 'N' THEN  #未拋轉
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei mark
           #ELSE
           #   LET l_msg = l_msg,"/",cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei mark
            END IF
         END IF
         IF NOT cl_null(p_flag3) AND p_flag3 = 'N' THEN  #分錄與單據科目不一致
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-293',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-293',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag4) AND p_flag4 = 'N' THEN  #多帳期金額與單據金額不一致 
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-294',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-294',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag5) AND p_flag5 = 'N' THEN  #分錄核算項與單據廠商不一致
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-295',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-295',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag6) AND p_flag6 = 'N' THEN  #單身科目不符合
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-296',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-296',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag7) THEN  #'+':apa51='STOCK' rvv料件科目與立帳的apb25不一致
                                       #'-':已扣帳未立帳
            IF p_flag7 = '+' THEN
               LET l_msg = cl_getmsg('agl-299',g_lang)
            ELSE
               LET l_msg = cl_getmsg('agl-298',g_lang)
            END IF
         END IF
     #p_flag1:審核否   p_flag2:拋轉否
     #p_flag3:        p_flag4:""
     #p_flag5:""      p_flag6:""
     #p_flag7:""
      WHEN tm.sys = '3'   #AFA
         IF NOT cl_null(p_flag1) AND p_flag1 = 'N' THEN  #未審核
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('apm-381',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('apm-381',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag2) AND p_flag2 = 'N' THEN  #未拋轉
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei mark
           #ELSE
           #   LET l_msg = l_msg,"/",cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei mark
            END IF
         END IF
     #p_flag1:審核否   p_flag2:過帳否
     #p_flag3:拋轉否   p_flag4:應折而未折
     #p_flag5:""      p_flag6:""
     #p_flag7:""
      WHEN tm.sys = '4'   #AFA
         IF NOT cl_null(p_flag1) AND p_flag1 = 'N' THEN  #未審核
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('apm-381',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('apm-381',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag2) AND p_flag2 = 'N' THEN  #未過帳
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('aim-307',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('aim-307',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag3) AND p_flag3 = 'N' THEN  #未拋轉
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei mark
           #ELSE
           #   LET l_msg = l_msg,"/",cl_getmsg('agl-292',g_lang)
           #2013.07.30 zhangwei mark
            END IF
         END IF
         IF NOT cl_null(p_flag4) AND p_flag4 = 'N' THEN  #應折而未折
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('agl-297',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('agl-297',g_lang)
            END IF
         END IF
     #p_flag1:審核否   p_flag2:過帳否
     #p_flag3:""      p_flag4:""
     #p_flag5:""      p_flag6:""
     #p_flag7:""
      WHEN tm.sys = '5'   #AGL
         IF NOT cl_null(p_flag1) AND p_flag1 = 'N' THEN  #未審核
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('apm-381',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('apm-381',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag2) AND p_flag2 = 'N' THEN  #未過帳
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('aim-307',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('aim-307',g_lang)
            END IF
         END IF
     #p_flag1:料件科目為空         p_flag2:會計科目頁簽有空值
     #p_flag3:雜收發理由碼科目檢查   p_flag4:成本分錄作業的單身科目檢查
     #p_flag5:成本中心不存在      p_flag6:""
     #p_flag7:""
      WHEN tm.sys = '6'   #AXC
         IF NOT cl_null(p_flag1) AND p_flag1 = 'N' THEN  #料件科目為空
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('ggl-008',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('ggl-008',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag2) AND p_flag2 = 'N' THEN  #會計科目頁簽有空值
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('ggl-009',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('ggl-009',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag3) AND p_flag3 = 'N' THEN  #雜收發理由碼科目檢查
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('ggl-013',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('ggl-013',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag4) AND p_flag4 = 'N' THEN  #成本分錄作業的單身科目檢查
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('ggl-014',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('ggl-014',g_lang)
            END IF
         END IF
         IF NOT cl_null(p_flag5) AND p_flag5 = 'N' THEN  #成本中心不存在
            IF cl_null(l_msg) THEN
               LET l_msg = cl_getmsg('ggl-015',g_lang)
            ELSE
               LET l_msg = l_msg,"/",cl_getmsg('ggl-015',g_lang)
            END IF
         END IF

   END CASE

   RETURN l_msg
END FUNCTION

FUNCTION q901_afa()
   DEFINE g_faj   RECORD LIKE faj_file.*
   DEFINE l_ym    LIKE type_file.chr10
   DEFINE l_fbi02 LIKE fbi_file.fbi02
   DEFINE l_mm    LIKE type_file.chr10

   IF tm.mm < 10 THEN
      LET l_ym = tm.yy USING "<<<<","0",tm.mm USING "<<<<"
      LET l_mm = "0",tm.mm USING "<<<<"
   ELSE
      LET l_ym = tm.yy USING "<<<<",tm.mm USING "<<<<"
      LET l_mm = tm.mm
   END IF

   SELECT * INTO g_faa.* FROM faa_file
   
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_sql="SELECT faj_file.* FROM faj_file ",
             " WHERE faj43 NOT IN ('0','4','5','6','7','X') ",
             " AND faj27 <= '",l_ym CLIPPED,"'",
             " AND fajconf='Y' " 
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3','4')"                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj28 IN ('1','2','3')"                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' "
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," UNION ALL ", 
               "SELECT faj_file.* FROM faj_file ",   #折畢再提/續提
               " WHERE faj43 IN ('7') ",  
               " AND faj28 = '1' ",
               " AND fajconf='Y' " 
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN  
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' "
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," ORDER BY 2,3,4 "  
 
   PREPARE r304_pre FROM g_sql
   IF STATUS THEN 
      CALL cl_err('r304_pre',STATUS,0) 
      RETURN 
   END IF
   DECLARE r304_cur CURSOR WITH HOLD FOR r304_pre
   FOREACH r304_cur INTO g_faj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('r304_cur foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF

      IF g_faj.faj43 = "Z" THEN
        LET g_faj.faj105 = "Y" 
      ELSE
        LET g_faj.faj105 = "N" 
      END IF
 
      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM fan_file 
        WHERE fan01=g_faj.faj02 AND fan02=g_faj.faj022
          AND (fan03>tm.yy OR (fan03=tm.yy AND fan04>=l_mm))
          AND fan05 <> '3' AND fan041='1'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
      #--
 
      #--已全額提列減值準備的固定資產,不再提列折舊                              
      IF g_faj.faj33 - (g_faj.faj101 - g_faj.faj102) <= 0 THEN       
         CONTINUE FOREACH                                                      
      END IF                                                                   
      #--
 
      #--檢核異動未過帳
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fay_file,faz_file
        WHERE fay01=faz01 AND faz03=g_faj.faj02 AND faz031=g_faj.faj022
          AND faypost<>'Y' AND YEAR(fay02)=tm.yy AND MONTH(fay02)=l_mm
          AND fayconf<>'X'
      IF g_cnt > 0 THEN 
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fba_file,fbb_file
        WHERE fba01=fbb01 AND fbb03=g_faj.faj02 AND fbb031=g_faj.faj022
          AND fbapost<>'Y' AND YEAR(fba02)=tm.yy AND MONTH(fba02)=l_mm
          AND fbaconf<>'X' 
      IF g_cnt > 0 THEN
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fbc_file,fbd_file
        WHERE fbc01=fbd01 AND fbd03=g_faj.faj02 AND fbd031=g_faj.faj022
          AND fbcpost<>'Y' AND YEAR(fbc02)=tm.yy AND MONTH(fbc02)=l_mm
          AND fbcconf<>'X'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fgh_file,fgi_file
        WHERE fgh01=fgi01 AND fgi06=g_faj.faj02 AND fgi07=g_faj.faj022
          AND fghconf<>'Y' AND YEAR(fgh02)=tm.yy AND MONTH(fgh02)=l_mm
          AND fghconf<>'X'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH                                                      
      END IF
      #--
 
      #--檢核當月處份應提列折舊='N',已存在處份資料,不可進行折舊 
      IF g_faa.faa23 = 'N' THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM fbg_file,fbh_file
           WHERE fbg01=fbh01 AND fbh03=g_faj.faj02 AND fbh031=g_faj.faj022
             AND YEAR(fbg02)=tm.yy AND MONTH(fbg02)=l_mm
             AND fbgconf<>'X'
         IF g_cnt > 0 THEN
            CONTINUE FOREACH                                                      
         END IF
         
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM fbe_file,fbf_file
           WHERE fbe01=fbf01 AND fbf03=g_faj.faj02 AND fbf031=g_faj.faj022
             AND YEAR(fbe02)=tm.yy AND MONTH(fbe02)=l_mm
             AND fbeconf<>'X'
         IF g_cnt > 0 THEN
            CONTINUE FOREACH                                                      
         END IF
      END IF
 
      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN  
         IF g_faj.faj23='1' THEN 
            DECLARE r304_fbi CURSOR FOR
            SELECT fbi02 FROM fbi_file WHERE fbi01=g_faj.faj24 AND fbi03= g_faj.faj04  
            FOREACH r304_fbi INTO l_fbi02
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi02) THEN
                  EXIT FOREACH
               END IF
            END FOREACH
            IF cl_null(l_fbi02) THEN
               CONTINUE FOREACH
            END IF
         END IF
      ELSE
         IF cl_null(g_faj.faj55) THEN
            CONTINUE FOREACH
         END IF
      END IF          
      EXECUTE insert_prep USING "AFA",g_faj.faj02,"","","","N","","","",'afai100'
                              
   END FOREACH
END FUNCTION

FUNCTION q901_axr()
   DEFINE l_oaz92      LIKE oaz_file.oaz92
   DEFINE l_azw01      LIKE azw_file.azw01

   SELECT oaz92 INTO l_oaz92 FROM oaz_file
   
   LET g_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y'",
               "   AND azw02 = '",g_legal,"'"
   PREPARE sel_azw FROM g_sql
   DECLARE sel_azw_cs CURSOR FOR sel_azw

   IF l_oaz92 = 'Y' THEN
     #出貨單開立票但沒有全部開立
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " SELECT 'AXR',omf00,'','','','','','','','axmt670' FROM omf_file a ",
                  "  WHERE omf03 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "    AND omf13 NOT LIKE 'MISC%'",
                  "    AND NOT EXISTS (SELECT 1 FROM omf_file b,omb_file ",
                  "                     WHERE omb31 = omf11 ",
                  "                       AND omb32 = omf12 ",
                  "                       AND omf16 = omb12 ",
                  "                       AND omf04 = omb01 ",
                  "                       AND a.omf00 = b.omf00 ",
                  "                       AND a.omf21 = b.omf21)",
                 #No.TQC-D70023 ---Add--- Start
                  "    AND NOT EXISTS (SELECT 1 FROM omf_file b,omb_file ",
                  "                     WHERE omb31 = omf11 ",
                  "                       AND omb32 = omf12 ",
                  "                       AND omf16 = (omb12 * -1) ",
                  "                       AND omf04 = omb01 ",
                  "                       AND a.omf00 = b.omf00 ",
                  "                       AND a.omf21 = b.omf21) ", 
                  "    AND omf08 = 'Y' ",
                 #No.TQC-D70023 ---AdD--- End
                  "UNION",
                  " SELECT 'AXR',omf00,'','','','','','','','axmt670' FROM omf_file a ",
                  "  WHERE omf03 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "    AND omf13 LIKE 'MISC%'",
                  "    AND NOT EXISTS (SELECT 1 FROM ( ",
                  "                       SELECT DISTINCT omf00,SUM(omf29t),SUM(omb14t) ",
                  "                         FROM omf_file,omb_file ",
                  "                        WHERE omf13 = 'MISC' ",
                  "                          AND omf11 = omb31 ",
                  "                          AND omf12 = omb32 ",
                  "                        GROUP BY omf00,omf21",
                  "                       HAVING SUM(omf29t) = SUM(omb14t)))",
                 #No.TQC-D70023 ---Add--- Start
                  "    AND NOT EXISTS (SELECT 1 FROM ( ",
                  "                       SELECT DISTINCT omf00,SUM(omf29t * -1),SUM(omb14t) ",
                  "                         FROM omf_file,omb_file ",
                  "                        WHERE omf13 = 'MISC' ",
                  "                          AND omf11 = omb31 ",
                  "                          AND omf12 = omb32 ",
                  "                        GROUP BY omf00,omf21",
                  "                       HAVING SUM(omf29t) = SUM(omb14t)))",
                  "    AND omf08 = 'Y' "
                 #No.TQC-D70023 ---AdD--- End
      PREPARE q901_omf FROM g_sql
      EXECUTE q901_omf
   END IF
   
   FOREACH sel_azw_cs INTO l_azw01
      IF l_oaz92 = 'Y' THEN
     #走發出商品流程
        #出貨單沒有開立發票
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXR',oga01,'','','','','','','','axmt620' ",
                     "   FROM ",cl_get_target_table(l_azw01,'oga_file'),",",
                                cl_get_target_table(l_azw01,'ogb_file')," a",
                     "  WHERE oga02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND oga01 = ogb01",
                     "    AND oga65 = 'N'",
                     "    AND ogaconf = 'Y'",
                     "    AND NOT EXISTS (SELECT 1 FROM omf_file,",
                                cl_get_target_table(l_azw01,'ogb_file')," b",
                     "                     WHERE ogb01 = omf11 AND ogb03 = omf12",
                     "                       AND omf04 Is Not Null AND omfpost = 'Y'",   #No.TQC-D70023   Add
                     "                       AND a.ogb01 = b.ogb01 AND a.ogb03 = b.ogb03)",
                     "    AND NOT EXISTS (SELECT 1 FROM omb_file, ",
                                cl_get_target_table(l_azw01,'ogb_file')," c",
                     "                     WHERE omb31 = ogb01 AND omb32 = ogb03 ",
                     "                       AND a.ogb01 = c.ogb01 AND a.ogb03 = c.ogb03)"
         PREPARE q901_omf1 FROM g_sql
        #EXECUTE q901_omf1    #MOD-DC0024 mark
      ELSE
         LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " SELECT DISTINCT 'AXR',oga01,'','','','','','','','axmt620' ",
                     "   FROM ",cl_get_target_table(l_azw01,'oga_file'),",",
                                cl_get_target_table(l_azw01,'ogb_file')," a",
                     "  WHERE oga02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND oga01 = ogb01",
                     "    AND oga65 = 'N'",
                     "    AND ogapost = 'Y'",   #No.TQC-D70023   Add
                     "    AND ogb04 NOT LIKE 'MISC%'",
                     "    AND ogaconf = 'Y'",
                     "    AND a.ogb01 = b.ogb01 AND a.ogb03 = b.ogb03)",
                     "    AND NOT EXISTS (SELECT 1 FROM omb_file, ",
                                cl_get_target_table(l_azw01,'ogb_file')," c",
                     "                     WHERE omb31 = ogb01 AND omb32 = ogb03 ",
                     "                       AND a.ogb01 = c.ogb01 AND a.ogb03 = c.ogb03)",
                     "UNION",
                     " SELECT DISTINCT 'AXR',oga01,'','','','','','','','axmt620' ",
                     "   FROM ",cl_get_target_table(l_azw01,'oga_file'),",",
                                cl_get_target_table(l_azw01,'ogb_file')," a",
                     "  WHERE oga02 BETWEEN '",b_date,"' AND '",e_date,"'",
                     "    AND oga01 = ogb01",
                     "    AND oga65 = 'N'",
                     "    AND ogapost = 'Y'",   #No.TQC-D70023   Add
                     "    AND ogaconf = 'Y'",
                     "    AND ogb04 LIKE 'MISC%'",
                     "    AND a.ogb01 = b.ogb01 AND a.ogb03 = b.ogb03)",
                     "    AND NOT EXISTS (SELECT 1 FROM (",
                     "                       SELECT ogb01,ogb03,SUM(CASE WHEN ogb1006 Is Null THEN ogb13*ogb12 ELSE ogb13*ogb12*(ogb1006/100) END),",
                     "                                              CASE WHEN oga213 = 'N' THEN SUM(omb14) ELSE SUM(omb14t) END ",
                     "                         FROM omb_file,",
                                                    cl_get_target_table(l_azw01,'oga_file'),",",
                                                    cl_get_target_table(l_azw01,'ogb_file'),
                     "                        WHERE ogb01 = omb31 ",
                     "                          AND ogb03 = omb32",
                     "                          AND oga01 = ogb01",
                     "                        GROUP BY ogb01,ogb03,oga213",
                     "                       HAVING SUM(CASE WHEN ogb1006 Is Null THEN ogb13*ogb12 ELSE ogb13*ogb12*(ogb1006/100) END) != CASE WHEN oga213 = 'N' THEN SUM(omb14) ELSE SUM(omb14t) END",
                     "))"
         PREPARE q901_oga FROM g_sql
         EXECUTE q901_oga 
      END IF
   END FOREACH
END FUNCTION

#No.TQC-D70037 ---Add--- Start
FUNCTION gglq901_axr1()
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT 'AXR',oma01,'','','','N','','','','axrt300' FROM oma_file,npq_file,npp_file ",
               "  WHERE oma18 <> npq03 ",
               "    AND npq06 = '1'",
               "    AND oma65 = '1' ",
               "    AND npp01 = npq01",
               "    AND nppsys = 'AR'",
               "    AND npq01 = oma01",
               "    AND oma00 LIKE '1%'",
               "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'",
               " UNION",
               " SELECT 'AXR',oma01,'','','','N','','','','axrt300' FROM oma_file,npq_file,npp_file ",
               "  WHERE oma18 = npq03 ",
               "    AND npq06 = '1'",
               "    AND oma65 = '1' ",
               "    AND npp01 = npq01",
               "    AND nppsys = 'AR'",
               "    AND npq01 = oma01",
               "    AND oma56t != npq07",
               "    AND oma00 LIKE '1%'",
               "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
   PREPARE q901_oma1 FROM g_sql
   EXECUTE q901_oma1
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT DISTINCT 'AXR',oma01,'','','','N','','','','axrt300' FROM npp_file,npq_file,oma_file a",
               "  WHERE npq06 = '1'   AND npp01 = npq01 ",
               "    AND oma01 = npq01 AND oma65 = '2' ",
               "    AND nppsys = 'AR' AND oma00 LIKE '1%'",
               "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'",
               "    AND NOT EXISTS (SELECT 1 FROM (SELECT oma01,SUM(oob10),AVG(npq07),AVG(oma56t) ",
               "                                     FROM oma_file,npp_file,npq_file,oob_file ",
               "                                    WHERE npq06 = '1' AND npp01 = npq01 ",
               "                                      AND oma65 = '2' AND oma01 = npq01 ",
               "                                      AND nppsys = 'AR' AND oma00 LIKE '1%'",
               "                                      AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'",
               "                                      AND oob01 = oma01 AND oob03 = '1'",
               "                                    GROUP BY oma01,oma18,npq03 ",
               "                                   HAVING (AVG(oma56t) - SUM(oob10) = AVG(npq07) AND oma18 = npq03) OR AVG(oma56t) = SUM(oob10)) c",
               "                     WHERE a.oma01 = c.oma01)"
   PREPARE q901_oma1_1 FROM g_sql
   EXECUTE q901_oma1_1

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " SELECT 'AXR',oma01,'','','','N','','','','axrt300' FROM oma_file a,npp_file ",
               "  WHERE nppsys = 'AR'",
               "    AND npp01 = oma01",
               "    AND oma00 LIKE '2%'",
               "    AND oma00 NOT IN ('22','24') ",    #MOD-DC0024 add
               "    AND NOT EXISTS (SELECT 1 FROM oma_file b,npq_file,npp_file ",
               "                     WHERE oma01 = npp01 ",
               "                       AND npp01 = npq01 ",
               "                       AND nppsys = 'AR' ",
               "                       AND npq06 = '2'   ",
               "                       AND npq03 = oma18 ",
               "                       AND oma56t= npq07 ",
               "                       AND a.oma01 = b.oma01)",
               "    AND oma02 BETWEEN '",b_date,"' AND '",e_date,"'"
   PREPARE q901_oma1_2 FROM g_sql
   EXECUTE q901_oma1_2

END FUNCTION
#No.TQC-D70037 ---Add--- End

FUNCTION q901_aap()
   DEFINE l_azw01      LIKE azw_file.azw01

   LET g_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y'",
               "   AND azw02 = '",g_legal,"'"
   PREPARE sel_azw2 FROM g_sql
   DECLARE sel_azw_cs2 CURSOR FOR sel_azw2
   
   FOREACH sel_azw_cs2 INTO l_azw01
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " SELECT DISTINCT 'AAP',rvv01,'','','','','','','-','rvu'||rvu00",
                  "   FROM ",cl_get_target_table(l_azw01,'rvv_file')," a,",cl_get_target_table(l_azw01,'rvu_file'),
                  "  WHERE rvv01 = rvu01 ",
                  "    AND rvu03 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "    AND rvuconf = 'Y' ",
                  "    AND rvu00 != '2' ",   #2013.08.02 zhangwei Add
                  "    AND rvv31 NOT LIKE 'MISC%' ",
                  "    AND NOT EXISTS (SELECT 1 FROM( ",
                  "                       SELECT rvv01,rvv02,rvv17,SUM(apb09) ",
                  "                         FROM ",cl_get_target_table(l_azw01,'rvv_file'),",apb_file,",
                                                   cl_get_target_table(l_azw01,'rvu_file'),
                  "                        WHERE apb21 = rvv01 ",
                  "                          AND apb22 = rvv02 ",
                  "                          AND rvu01 = rvv01 ",
                  "                          AND rvv31 NOT LIKE 'MISC%' ",
                  "                          AND apb34 <> 'Y' ",
                  "                          AND rvu03 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "                        GROUP BY rvv01,rvv02,rvv17 ",
                  "                       HAVING rvv17 = SUM(apb09)) b,apb_file ",
                  "                     WHERE apb21 = rvv01 ",
                  "                       AND apb22 = rvv02 ",
                  "                       AND a.rvv01 = b.rvv01 ",
                  "                       AND a.rvv02 = b.rvv02 )",
                  " UNION ",
                  "SELECT DISTINCT 'AAP',rvv01,'','','','','','','-','rvu'||rvu00",
                  "  FROM ",cl_get_target_table(l_azw01,'rvv_file')," a,",cl_get_target_table(l_azw01,'rvu_file'),
                  " WHERE rvv01 = rvu01 ",
                  "   AND rvu03 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "   AND rvuconf = 'Y' ",
                  "   AND rvu00 != '2' ",   #2013.08.02 zhangwei Add
                  "   AND rvv31 LIKE 'MISC%' ",
                  "   AND NOT EXISTS (SELECT 1 FROM( ",
                  "                      SELECT rvv01,rvv02,SUM(rvv39),SUM(apb24)",
                  "                        FROM ",cl_get_target_table(l_azw01,'rvv_file'),",apb_file,",
                                                  cl_get_target_table(l_azw01,'rvu_file'),
                  "                       WHERE apb21 = rvv01 ",
                  "                         AND apb22 = rvv02 ",
                  "                         AND rvu01 = rvv01 ",
                  "                         AND rvv31 LIKE 'MISC%' ",
                  "                         AND apb34 <> 'Y' ",
                  "                         AND rvu03 BETWEEN '",b_date,"' AND '",e_date,"'",
                  "                       GROUP BY rvv01,rvv02 ",
                  "                      HAVING SUM(rvv39) = SUM(apb24)) b,apb_file",
                  "                    WHERE apb21 = rvv01 ",
                  "                      AND apb22 = rvv02 ",
                  "                      AND a.rvv01 = b.rvv01 ", 
                  "                      AND a.rvv02 = b.rvv02 )"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
      PREPARE q901_apa7 FROM g_sql
      EXECUTE q901_apa7
   END FOREACH

END FUNCTION

FUNCTION q901_aap1()
   DEFINE l_azw01      LIKE azw_file.azw01

  #取科目來源
   SELECT ccz07 INTO g_ccz.ccz07 FROM ccz_file

   LET g_sql = "SELECT azw01 FROM azw_file ",
               " WHERE azwacti = 'Y'",
               "   AND azw02 = '",g_legal,"'"
   PREPARE sel_azw1 FROM g_sql
   DECLARE sel_azw_cs1 CURSOR FOR sel_azw1

   FOREACH sel_azw_cs1 INTO l_azw01
      CASE
         WHEN g_ccz.ccz07 = '1'   #取自料件主檔    ima39
            LET g_sql = "SELECT DISTINCT 'AAP',apa01,'','','','','','','+','apa'||apa00 ",
                        "  FROM apa_file a,apb_file,",
                        cl_get_target_table(l_azw01,'rvv_file'),
                        " WHERE NOT EXISTS (",
                        "                   SELECT 1 FROM apa_file b,apb_file",
                                     cl_get_target_table(l_azw01,'rvv_file'),",",
                                     cl_get_target_table(l_azw01,'ima_file'),
                        "                    WHERE apa01 = apb01 ",
                        "                      AND apa51 = 'STOCK'",
                        "                      AND rvv01 = apb21",
                        "                      AND rvv02 = apb22",
                        "                      AND rvv31 = ima01",
                        "                      AND ima39 = apb25",
                        "                      AND a.apa01 = b.apa01 )",
                        "   AND apa01 = apb01",
                        "   AND apb21 = rvv01",
                        "   AND apb22 = rvv02",
                        "   AND apa51 = 'STOCK'",
                        "   AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         WHEN g_ccz.ccz07 = '2'   #取自料件分群檔  imz39
            LET g_sql = "SELECT DISTINCT 'AAP',apa01,'','','','','','','+','apa'||apa00 ",
                        "  FROM apa_file a,apb_file,",
                        cl_get_target_table(l_azw01,'rvv_file'),
                        " WHERE NOT EXISTS (",
                        "                   SELECT 1 FROM apa_file b,apb_file",
                                     cl_get_target_table(l_azw01,'rvv_file'),
                                     cl_get_target_table(l_azw01,'ima_file'),
                                     cl_get_target_table(l_azw01,'imz_file'),
                        "                    WHERE apa01 = apb01 ",
                        "                      AND apa51 = 'STOCK'",
                        "                      AND rvv01 = apb21",
                        "                      AND rvv02 = apb22",
                        "                      AND rvv31 = ima01",
                        "                      AND imz39 = apb25",
                        "                      AND ima06 = imz01",
                        "                      AND a.apa01 = b.apa01 )",
                        "   AND apa01 = apb01",
                        "   AND apb21 = rvv01",
                        "   AND apb22 = rvv02",
                        "   AND apa51 = 'STOCK'",
                        "   AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         WHEN g_ccz.ccz07 = '3'   #取自倉庫檔      imd08
            LET g_sql = "SELECT DISTINCT 'AAP',apa01,'','','','','','','+','apa'||apa00 ",
                        "  FROM apa_file a,apb_file,",
                        cl_get_target_table(l_azw01,'rvv_file'),
                        " WHERE NOT EXISTS (",
                        "                   SELECT 1 FROM apa_file b,apb_file,",
                                     cl_get_target_table(l_azw01,'rvv_file'),",",
                                     cl_get_target_table(l_azw01,'imd_file'),
                        "                    WHERE apa01 = apb01 ",
                        "                      AND apa51 = 'STOCK'",
                        "                      AND rvv01 = apb21",
                        "                      AND rvv02 = apb22",
                        "                      AND rvv32 = imd01",
                        "                      AND imd08 = apb25",
                        "                      AND a.apa01 = b.apa01 )",
                        "   AND apa01 = apb01",
                        "   AND apb21 = rvv01",
                        "   AND apb22 = rvv02",
                        "   AND apa51 = 'STOCK'",
                        "   AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
         WHEN g_ccz.ccz07 = '4'   #取自倉庫庫位檔   ime09
            LET g_sql = "SELECT DISTINCT 'AAP',apa01,'','','','','','','+','apa'||apa00 ",
                        "  FROM apa_file a,apb_file,",
                        cl_get_target_table(l_azw01,'rvv_file'),
                        " WHERE NOT EXISTS (",
                        "                   SELECT 1 FROM apa_file b,apb_file,",
                                     cl_get_target_table(l_azw01,'rvv_file'),",",
                                     cl_get_target_table(l_azw01,'ime_file'),
                        "                    WHERE apa01 = apb01 ",
                        "                      AND apa51 = 'STOCK'",
                        "                      AND rvv01 = apb21",
                        "                      AND rvv02 = apb22",
                        "                      AND rvv32 = ime01",
                        "                      AND rvv33 = ime02",
                        "                      AND imeacti = 'Y'",
                        "                      AND ime09 = apb25",
                        "                      AND a.apa01 = b.apa01 )",
                        "   AND apa01 = apb01",
                        "   AND apb21 = rvv01",
                        "   AND apb22 = rvv02",
                        "   AND apa51 = 'STOCK'",
                        "   AND apa02 BETWEEN '",b_date,"' AND '",e_date,"'"
      END CASE
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," ",g_sql
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
      PREPARE q901_apa8 FROM g_sql
      EXECUTE q901_apa8
   END FOREACH
END FUNCTION
