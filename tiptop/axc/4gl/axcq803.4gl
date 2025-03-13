# Prog. Version..: '5.30.06-13.04.19(00005)'     #
#
# Pattern name...: axcq803.4gl
# Descriptions...: 客戶發出商品進銷存表查詢
# Date & Author..: No.FUN-C60036 12/06/19 By xuxz
# Modify.........: No:FUN-CA0084 12/10/11 By xuxz 查詢點退出不直接退出程序
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No:TQC-D20046 13/02/27 By qiull 修改發出商品測試問題
# Modify.........: No:MOD-D40095 13/04/15 By wujie 没有考虑oha资料
# Modify.........: No:TQC-D40033 13/04/16 By wujie 调整取客户的逻辑，不按tlf中是否存在此客户为标准
# Modify.........: No:MOD-D50165 13/05/20 By wujie tlf99 is not null排除，不折让的销退单排除
# Modify.........: No:MOD-D50198 13/05/23 By wujie 修正期初金额取值，发票仓为成本仓时，都取当月成本价，为非成本仓时期初为上期余额（不是数量*单价）
# Modify.........: No:TQC-D60036 13/06/24 By yangtt 年度和期別添加默認值
# Modify.........: No:FUN-D50073 13/08/22 By yangtt 增加合計欄，并增加顯示期別

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_wc    STRING    #QBE條件
DEFINE g_wc2   STRING 
DEFINE tm      RECORD    #INPUT
         yy    LIKE type_file.chr4,
         mm    LIKE type_file.chr2,
         ccc07 LIKE ccc_file.ccc07,
         ccc08 LIKE ccc_file.ccc08,
         cb1   LIKE type_file.chr1,
         more  LIKE type_file.chr1
               END RECORD 
         
DEFINE g_sql   STRING 
DEFINE g_flag  LIKE type_file.chr1
DEFINE g_str   STRING 
DEFINE g_rec_b LIKE type_file.num10
DEFINE g_change_lang    LIKE type_file.chr1

DEFINE g_occ   DYNAMIC ARRAY OF RECORD 
         occ01 LIKE occ_file.occ01,
         occ02 LIKE occ_file.occ02,
         ima01 LIKE ima_file.ima01,
         ima02 LIKE ima_file.ima02,              #TQC-D20046---qiull---add---
         ima021 LIKE ima_file.ima021,            #TQC-D20046---qiull---add---
         n1    LIKE type_file.num20_6,
         m1    LIKE type_file.num20_6,
         n2    LIKE type_file.num20_6,
         m2    LIKE type_file.num20_6,
         n3    LIKE type_file.num20_6,
         m3    LIKE type_file.num20_6,
         n4    LIKE type_file.num20_6,
         m4    LIKE type_file.num20_6,
         n5    LIKE type_file.num20_6,
         m5    LIKE type_file.num20_6,
         n6    LIKE type_file.num20_6,
         m6    LIKE type_file.num20_6
               END RECORD 
DEFINE g_oaz93 LIKE oaz_file.oaz93
DEFINE g_oaz95 LIKE oaz_file.oaz95
MAIN 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

   #判讀oaz93是否為Y，為Y才運行，不為Y則報錯：系統參數做發出商品管理，本作業不可以執行，請運行axcq802&axcr802
   SELECT oaz93,oaz95 INTO g_oaz93,g_oaz95 FROM oaz_file
   SELECT oaz95 INTO g_oaz.oaz95 FROM oaz_file
   IF g_oaz93 != 'Y' THEN 
      CALL cl_err('','axc-126',1)
      EXIT PROGRAM 
   END IF 
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   #傳入參數
   LET g_flag = 'N'
   #主要邏輯開始
   IF g_flag = 'N' THEN 
      OPEN WINDOW q803_w AT 5,10                                                   
           WITH FORM "axc/42f/axcq803" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
      CALL cl_ui_init() 
 
      IF cl_null(g_bgjob) OR g_bgjob = 'N'        
         THEN CALL q803_tm()         
         ELSE CALL q803()            
      END IF
 
      CALL q803_menu()                                                             
      CLOSE WINDOW q803_w

   ELSE
      CALL q803()
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN 

FUNCTION q803_menu()
   WHILE TRUE
      CALL q803_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q803_tm()
            END IF
         WHEN "output"
             IF cl_chk_act_auth() THEN
               CALL q803_rep()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_occ),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q803_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_pja01        LIKE pja_file.pja01,
          l_imd09        LIKE imd_file.imd09

   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 12
   END IF

   #打開acxr803的畫面輸入查詢條件
   OPEN WINDOW q803_w1 AT p_row,p_col
        WITH FORM "axc/42f/axcr803"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_entry('ccc08',FALSE) 
   CALL cl_opmsg('q')

   #初始化
   INITIALIZE tm.* TO NULL

   
   WHILE TRUE
      DIALOG attributes(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON occ01
      
            BEFORE CONSTRUCT 
               LET tm.cb1 = 'N'
               LET tm.more = 'N'
               LET tm.ccc08 = ' '
               #TQC-D60036---add--str--
               LET tm.yy = g_ccz.ccz01
               LET tm.mm = g_ccz.ccz02
               LET tm.ccc07 = g_ccz.ccz28
               DISPLAY BY NAME tm.yy,tm.mm,tm.ccc07
               #TQC-D60036---add--end--
               
         END CONSTRUCT 
         CONSTRUCT BY NAME g_wc2 ON ima01
      
            BEFORE CONSTRUCT 
               CALL cl_qbe_init()
         END CONSTRUCT 

      INPUT BY NAME tm.yy,tm.mm,tm.ccc07,tm.ccc08,tm.cb1,tm.more
#No.MOD-CB0110 --begin
         BEFORE INPUT 
            LET tm.yy = g_ccz.ccz01
            LET tm.mm = g_ccz.ccz02
            LET tm.ccc07 = g_ccz.ccz28
            DISPLAY BY NAME tm.yy,tm.mm,tm.ccc07
#No.MOD-CB0110 --end

         AFTER FIELD yy
            IF NOT cl_null(tm.yy) THEN 
               IF tm.yy  < 0 THEN 
                  CALL cl_err('','ask-003',0)
                  NEXT FIELD yy
               END IF 
               IF length(tm.yy) <>'4' THEN 
                  CALL cl_err('','ask-003',0)
                  NEXT FIELD yy
               END IF 
            END IF 
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN 
               IF tm.mm >13 THEN 
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm
               END IF 
               IF tm.mm < 1 THEN
                  CALL cl_err('','agl-013',0)
                  NEXT FIELD mm 
               END IF 
            END IF 
            
         ON CHANGE ccc07
            IF tm.ccc07 MATCHES '[34]' THEN
               CALL cl_set_comp_entry('ccc08',TRUE) 
            ELSE
               CALL cl_set_comp_entry('ccc08',FALSE) 
            END IF 
            
         AFTER FIELD ccc08
            IF NOT cl_null(tm.ccc08) OR tm.ccc08 != ' '  THEN
               IF tm.ccc07='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=tm.ccc08
                                             AND pjaclose='N'     
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",tm.ccc08,"",STATUS,"","sel pja:",1)
                     NEXT FIELD ccc08
                  END IF
               END IF
               IF tm.ccc07='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=tm.ccc08
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",tm.ccc08,"",STATUS,"","sel imd:",1)   
                     NEXT FIELD ccc08
                  END IF
               END IF
            ELSE 
               LET tm.ccc08 = ' '
            END IF
            
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF

            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
      END INPUT

      ON ACTION controlp
         CASE 
            WHEN INFIELD(occ01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ01
              #NEXT FIELD cfb07#FUN-CA0084 mark
               NEXT FIELD occ01#FUN-CA0084
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            WHEN INFIELD(ccc08)                                               
                 IF tm.ccc07 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                 CASE tm.ccc07                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 LET g_qryparam.default1 = tm.ccc08   
                 CALL cl_create_qry() RETURNING tm.ccc08                     
                 DISPLAY BY NAME  tm.ccc08                                   
                 NEXT FIELD ccc08                                               
                 END IF
            OTHERWISE
               EXIT CASE
         END CASE
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
                
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
                 
      ON ACTION about         
         CALL cl_about()      
                  
      ON ACTION help          
         CALL cl_show_help()  
                  
      ON ACTION controlg      
         CALL cl_cmdask()     
              
      ON ACTION ACCEPT
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF 
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
         IF cl_null(tm.ccc07) THEN NEXT FIELD ccc07 END IF
         EXIT DIALOG
         
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG
             
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION locale 
         LET g_change_lang = TRUE
         CALL cl_dynamic_locale()    
         CALL cl_show_fld_cont()
            
      END DIALOG
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW q803_w1
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-CA0084 mark
       # EXIT PROGRAM#FUN-CA0084 mark
      END IF
      CALL cl_wait()
      CLOSE WINDOW q803_w1   #FUN-D50073 add
      CALL q803()
      ERROR ""
      EXIT WHILE
   END WHILE
   CLOSE WINDOW q803_w1 
   IF tm.cb1 = 'Y' THEN
      CALL cl_set_comp_visible('ima01,ima02,ima021,n1,n2,n3,n4,n5,n6',TRUE)    #TQC-D20046--qiull--add>ima02,ima021
   ELSE  
      CALL cl_set_comp_visible('ima01,ima02,ima021,n1,n2,n3,n4,n5,n6',FALSE)   #TQC-D20046--qiull--add>ima02,ima021
   END IF 
END FUNCTION 

FUNCTION q803()
   DEFINE l_occ01   LIKE occ_file.occ01,
          l_ima01   LIKE ima_file.ima01,
          l_mm      LIKE type_file.chr2,
          l_yy      LIKE type_file.chr4
   DEFINE l_sql     STRING, 
          l_wc      STRING,
          l_wc2     STRING,
          l_wc3     STRING,
          temp_ima01 STRING
#No.MOD-D50198 --begin
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_flag    LIKE type_file.chr1   #成本仓否
   DEFINE l_azmm02  LIKE azmm_file.azmm02
#No.MOD-D50198 --end
   #FUN-D50073--add--str--
   DEFINE l_n1_tot  LIKE type_file.num20_6
   DEFINE l_n2_tot  LIKE type_file.num20_6
   DEFINE l_n3_tot  LIKE type_file.num20_6
   DEFINE l_n4_tot  LIKE type_file.num20_6
   DEFINE l_n5_tot  LIKE type_file.num20_6
   DEFINE l_n6_tot  LIKE type_file.num20_6
   DEFINE l_m1_tot  LIKE type_file.num20_6
   DEFINE l_m2_tot  LIKE type_file.num20_6
   DEFINE l_m3_tot  LIKE type_file.num20_6
   DEFINE l_m4_tot  LIKE type_file.num20_6
   DEFINE l_m5_tot  LIKE type_file.num20_6
   DEFINE l_m6_tot  LIKE type_file.num20_6
   #FUN-D50073--add--end--

   #初始化單身數組
   CALL g_occ.clear()   
          
   #年度期別處理以及其他初始化
   LET g_rec_b = 0
#No.MOD-D50198 --begin
   SELECT azmm02 INTO l_azmm02 FROM azmm_file WHERE azmm00 = g_ccz.ccz12 AND azmm01 = tm.yy-1
   IF tm.mm = 1 THEN 
   	  IF l_azmm02 = 1 THEN 
         LET l_mm = 12
      ELSE 
         LET l_mm = 13
      END IF 
      LET l_yy = tm.yy - 1
   ELSE 
      LET l_mm = tm.mm - 1
      LET l_yy = tm.yy
   END IF 

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_oaz95
   IF l_n = 0 THEN LET l_flag = 'Y' ELSE LET l_flag = 'N' END IF   #成本仓否
#No.MOD-D50198 --end
   
   LET l_wc = g_wc2
   LET l_wc2= cl_replace_str(l_wc,'ima01','imk01')
   LET l_wc3= cl_replace_str(l_wc,'ima01','tlfc01')
   DISPLAY tm.mm TO mm    #FUN-D50073 add
   DISPLAY tm.yy TO yy    #FUN-D50073 add
   #FUN-D50073--add--str--
   DROP TABLE axcq803_tmp;
   CREATE TEMP TABLE axcq803_tmp(
         occ01 LIKE occ_file.occ01,
         occ02 LIKE occ_file.occ02,
         ima01 LIKE ima_file.ima01,
         ima02 LIKE ima_file.ima02,
         ima021 LIKE ima_file.ima021,
         n1    LIKE type_file.num20_6,
         m1    LIKE type_file.num20_6,
         n2    LIKE type_file.num20_6,
         m2    LIKE type_file.num20_6,
         n3    LIKE type_file.num20_6,
         m3    LIKE type_file.num20_6,
         n4    LIKE type_file.num20_6,
         m4    LIKE type_file.num20_6,
         n5    LIKE type_file.num20_6,
         m5    LIKE type_file.num20_6,
         n6    LIKE type_file.num20_6,
         m6    LIKE type_file.num20_6);
   DELETE FROM axcq803_tmp
   #FUN-D50073--add--end--
   #本作業主要sql
#No.TQC-D40033 --begin
   LET g_sql = " SELECT DISTINCT occ01,imk01 ",
               "   FROM occ_file,imk_file ",
               "  WHERE imk03 = occ01 ",
               "    AND imk05 = ",tm.yy," AND imk06 = ",tm.mm,
               "    AND ",l_wc2,
               "    AND occacti = 'Y' ",               
               "    AND ",g_wc
               

#   IF tm.cb1 = 'Y' THEN 
#      LET g_sql = " SELECT DISTINCT occ01,ima01 "
#   ELSE    
#      LET g_sql = " SELECT DISTINCT occ01,'' "
#   END IF 
#  #LET g_sql = g_sql, " FROM ima_file ,imk_file,occ_file,oga_file ",
#  #LET g_sql = g_sql, " FROM ima_file ,imk_file,occ_file ",
#  #            " WHERE ima01 = imk01 AND imk03 = occ01 ",
#  #            "   AND occ01 = oga03 AND occacti = 'Y' AND ogapost = 'Y' ",
#  #            "   AND imk05 = ",tm.yy," AND imk06 = ",tm.mm,
#  #            "   AND ",g_wc,
#  #            "   AND ",g_wc2
#   LET g_sql = g_sql," FROM ima_file,occ_file,tlf_file ",
#               " WHERE occacti = 'Y' ",
#               "   AND ima01 = tlf01 AND occ01 = tlf19 ",
#               "   AND  YEAR(tlf06)= '",tm.yy,"'",
#               "   AND MONTH(tlf06)= '",tm.mm,"'", 
#               "   AND (tlf13 = 'aomt800' OR tlf13 like 'axmt6%') ",
#               "   AND ",g_wc,
#               "   AND ",g_wc2
#No.TQC-D40033 --end
   PREPARE q803_pre FROM g_sql
   DECLARE q803_cs  CURSOR FOR q803_pre
   IF NOT cl_null(tm.ccc08) THEN 
      FOREACH q803_cs INTO l_occ01,l_ima01
         IF tm.cb1 = 'Y' THEN
            LET temp_ima01 = l_ima01
            IF temp_ima01.substring(1,4) = "MISC" THEN 
               CONTINUE FOREACH
            END IF 
         END IF
         #g_rec_b賦值
         LET g_rec_b = g_rec_b + 1
         #occ01,occ02
         SELECT occ01,occ02 INTO g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02
           FROM oga_file,occ_file 
          WHERE occ01 = oga03 AND occacti='Y' 
            AND ogapost='Y'   AND occ01 = l_occ01
         LET g_occ[g_rec_b].ima01 = l_ima01
         #TQC-D20046--qiull--add--str--
         SELECT ima02,ima021 INTO g_occ[g_rec_b].ima02,g_occ[g_rec_b].ima021
           FROM ima_file
          WHERE ima01 = g_occ[g_rec_b].ima01
         #TQC-D20046--qiull--add--end--
         #期初數量，期初金額
         IF tm.cb1 = 'Y' THEN 
            #期初數量
            SELECT SUM(imk09) INTO g_occ[g_rec_b].n1
              FROM imk_file,ccc_file
             WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
               AND imk05 = l_yy     AND imk06 = l_mm 
               AND imk01 = l_ima01  AND imk01=ccc01
               AND ccc02 = l_yy     AND ccc03 = l_mm
               AND ccc07 = tm.ccc07 AND ccc08 = tm.ccc08
           #期初金額
#No.MOD-D50198 --begin
#发票仓为成本仓时，都取当月成本价，为非成本仓时期初为上期余额（不是数量*单价）
#           SELECT SUM(imk09*ccc23) INTO g_occ[g_rec_b].m1
#             FROM imk_file,ccc_file 
#            WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
#              AND imk01=ccc01      AND imk01 = l_ima01 
#              AND imk05 = l_yy     AND imk06 = l_mm 
#              AND ccc02 = l_yy     AND ccc03 = l_mm
#              AND ccc07 = tm.ccc07 AND ccc08 = tm.ccc08
           IF l_flag = 'Y' THEN 
              SELECT SUM(imk09*ccc23) INTO g_occ[g_rec_b].m1
                FROM imk_file,ccc_file 
               WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
                 AND imk01 = ccc01    AND imk01 = l_ima01 
                 AND imk05 = tm.yy    AND imk06 = tm.mm 
                 AND ccc02 = tm.yy    AND ccc03 = tm.mm
                 AND ccc07 = tm.ccc07 AND ccc08 = tm.ccc08
           ELSE 
              SELECT SUM(ccc12) INTO g_occ[g_rec_b].m1
                FROM imk_file,ccc_file 
               WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
                 AND imk01 = ccc01    AND imk01 = l_ima01 
                 AND imk05 = tm.yy    AND imk06 = tm.mm 
                 AND ccc02 = tm.yy    AND ccc03 = tm.mm
                 AND ccc07 = tm.ccc07 AND ccc08 = tm.ccc08
           END IF 
#No.MOD-D50198 --end
         ELSE
            #期初金額
#No.MOD-D50198 --begin
#发票仓为成本仓时，都取当月成本价，为非成本仓时期初为上期余额（不是数量*单价）
#            LET l_sql = " SELECT SUM(imk09*ccc23) ",
#                        "   FROM imk_file,ccc_file ",
#                        "  WHERE imk02 = '",g_oaz95 ,"'",
#                        "    AND imk03 = '",g_occ[g_rec_b].occ01 ,"'",
#                        "    AND imk01=ccc01 ",     
#                        "    AND ",l_wc2 ,
#                        "    AND imk05 = '",l_yy ,"'",   
#                        "    AND imk06 = '",l_mm ,"'",
#                        "    AND ccc02 = '",l_yy ,"'",  
#                        "    AND ccc03 = '",l_mm ,"'",
#                        "    AND ccc07 = '",tm.ccc07 ,"'",
#                        "    AND ccc08 = '",tm.ccc08 ,"'"
#            PREPARE p803_imk09 FROM l_sql
#            EXECUTE p803_imk09 INTO g_occ[g_rec_b].m1
            IF l_flag = 'Y' THEN 
               LET l_sql = " SELECT SUM(imk09*ccc23) ",
                           "   FROM imk_file,ccc_file ",
                           "  WHERE imk02 = '",g_oaz95 ,"'",
                           "    AND imk03 = '",g_occ[g_rec_b].occ01 ,"'",
                           "    AND imk01=ccc01 ",     
                           "    AND ",l_wc2 ,
                           "    AND imk05 = '",tm.yy ,"'",   
                           "    AND imk06 = '",tm.mm ,"'",
                           "    AND ccc02 = '",tm.yy ,"'",  
                           "    AND ccc03 = '",tm.mm ,"'",
                           "    AND ccc07 = '",tm.ccc07 ,"'",
                           "    AND ccc08 = '",tm.ccc08 ,"'"
            ELSE 
               LET l_sql = " SELECT SUM(ccc12) ",
                           "   FROM imk_file,ccc_file ",
                           "  WHERE imk02 = '",g_oaz95 ,"'",
                           "    AND imk03 = '",g_occ[g_rec_b].occ01 ,"'",
                           "    AND imk01=ccc01 ",     
                           "    AND ",l_wc2 ,
                           "    AND imk05 = '",tm.yy ,"'",   
                           "    AND imk06 = '",tm.mm ,"'",
                           "    AND ccc02 = '",tm.yy ,"'",  
                           "    AND ccc03 = '",tm.mm ,"'",
                           "    AND ccc07 = '",tm.ccc07 ,"'",
                           "    AND ccc08 = '",tm.ccc08 ,"'"
            END IF 
            PREPARE p803_imk09 FROM l_sql
            EXECUTE p803_imk09 INTO g_occ[g_rec_b].m1
#No.MOD-D50198 --end
         END IF 
         #本月出貨轉入數量與金額，本月出貨轉出數量與金額，本月銷退轉入數量與金額，本月銷退轉出數量與金額
         IF tm.cb1 = 'Y' THEN 
            #本月出貨轉入數量與金額
            SELECT -SUM(tlf907*tlf10*tlf60) INTO g_occ[g_rec_b].n2 FROM tlf_file,tlfc_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
               AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
               AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
               AND tlf13 like 'axmt6%' AND tlf13<>'axmt670'
               AND tlf19=g_occ[g_rec_b].occ01
              #AND tlf907=-1  #要减掉签退
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
               AND tlf902<>g_oaz.oaz95
               AND tlf99 IS NULL    #No.MOD-D50165 
            
            SELECT -SUM(tlf907*tlfc21) INTO g_occ[g_rec_b].m2 FROM tlfc_file,tlf_file 
             WHERE tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
               AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
               AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
               AND YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' 
               AND tlf19=g_occ[g_rec_b].occ01
              #AND tlfc907=-1 #要减掉签退
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08
               AND tlfc902<>g_oaz.oaz95
               AND tlf99 IS NULL    #No.MOD-D50165 
            
            #本月出貨轉出數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ[g_rec_b].n3 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='axmt670' 
               AND tlf19=g_occ[g_rec_b].occ01
               AND tlf907=-1
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
            
            SELECT SUM(tlfc21) INTO g_occ[g_rec_b].m3  FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='axmt670' 
               AND tlf19=g_occ[g_rec_b].occ01
               AND tlfc907=-1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08


            #本月銷退轉入數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ[g_rec_b].n4 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='aomt800' 
               AND tlf907=1
               AND tlf19=g_occ[g_rec_b].occ01
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
               AND tlf902<>g_oaz.oaz95                                          #No.MOD-D50165   tlfc902 -->tlf902
               AND tlf905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165 
            
            SELECT SUM(tlfc21) INTO g_occ[g_rec_b].m4 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='aomt800' 
               AND tlf19=g_occ[g_rec_b].occ01
               AND tlf907=1
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08
               AND tlfc902<>g_oaz.oaz95
               AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165 
            
            #本月銷退轉出數量與金額
            SELECT SUM (tlf10*tlf60) INTO g_occ[g_rec_b].n5 FROM tlf_file 
             WHERE YEAR(tlf06)=tm.yy 
               AND MONTH(tlf06)=tm.mm 
               AND tlf13='axmt670' 
               AND tlf19=g_occ[g_rec_b].occ01
               AND tlf907=1
               AND tlf01 = l_ima01
               AND tlfcost = tm.ccc08
               AND tlf905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165
            
            SELECT SUM(tlfc21) INTO g_occ[g_rec_b].m5 FROM tlfc_file LEFT  OUTER  JOIN 
              tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                       AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                       AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
             WHERE YEAR(tlfc06)=tm.yy 
               AND MONTH(tlfc06)=tm.mm 
               AND tlfc13='axmt670' 
               AND tlf19=g_occ[g_rec_b].occ01
               AND tlfc907=1 
               AND tlfctype=tm.ccc07
               AND tlfc01 = l_ima01
               AND tlfccost = tm.ccc08
               AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165
         ELSE
            #本月出貨轉入金額
            LET l_sql = " SELECT -SUM(tlfc907*tlfc21) FROM tlfc_file,tlf_file ",
                     "  WHERE tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "    AND YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' ",
                     "    AND tlf19= '",g_occ[g_rec_b].occ01 ,"'",
                    #"    AND tlfc907= -1 ",
                     "    AND tlfc902<> '",g_oaz.oaz95,"'",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND tlf99 IS NULL ",            #No.MOD-D50165
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_2 FROM l_sql
            EXECUTE p803_tlfc21_2 INTO g_occ[g_rec_b].m2
         
            #本月出貨轉出金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file ",
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19= '",g_occ[g_rec_b].occ01 ,"'",
                     "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_3 FROM l_sql
            EXECUTE p803_tlfc21_3 INTO g_occ[g_rec_b].m3

            #本月銷退轉入金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='aomt800' ",
                     "    AND tlf19='",g_occ[g_rec_b].occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfc902<> '",g_oaz.oaz95,"'",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1') ",            #No.MOD-D50165
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_4 FROM l_sql
            EXECUTE p803_tlfc21_4 INTO g_occ[g_rec_b].m4
            #本月銷退轉出金額
            LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19='",g_occ[g_rec_b].occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND tlfccost = '",tm.ccc08,"'",
                     "    AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1') ",            #No.MOD-D50165
                     "    AND ",l_wc3
            PREPARE p803_tlfc21_5 FROM l_sql
            EXECUTE p803_tlfc21_5 INTO g_occ[g_rec_b].m5
         END IF 
         #數值欄位如果為null給0
         IF tm.cb1 = 'Y' THEN 
            IF cl_null(g_occ[g_rec_b].n1) THEN LET g_occ[g_rec_b].n1 = 0 END IF 
            IF cl_null(g_occ[g_rec_b].n2) THEN LET g_occ[g_rec_b].n2 = 0 END IF
            IF cl_null(g_occ[g_rec_b].n3) THEN LET g_occ[g_rec_b].n3 = 0 END IF
            IF cl_null(g_occ[g_rec_b].n4) THEN LET g_occ[g_rec_b].n4 = 0 END IF
            IF cl_null(g_occ[g_rec_b].n5) THEN LET g_occ[g_rec_b].n5 = 0 END IF
            IF cl_null(g_occ[g_rec_b].n6) THEN LET g_occ[g_rec_b].n6 = 0 END IF
            IF g_occ[g_rec_b].n4 > 0 THEN LET g_occ[g_rec_b].n4 = g_occ[g_rec_b].n4*(-1) END IF   #TQC-D20046--qiull--add--
            IF g_occ[g_rec_b].n5 > 0 THEN LET g_occ[g_rec_b].n5 = g_occ[g_rec_b].n5*(-1) END IF   #TQC-D20046--qiull--add--
         END IF 
         IF cl_null(g_occ[g_rec_b].m1) THEN LET g_occ[g_rec_b].m1 = 0 END IF 
         IF cl_null(g_occ[g_rec_b].m2) THEN LET g_occ[g_rec_b].m2 = 0 END IF
         IF cl_null(g_occ[g_rec_b].m3) THEN LET g_occ[g_rec_b].m3 = 0 END IF
         IF cl_null(g_occ[g_rec_b].m4) THEN LET g_occ[g_rec_b].m4 = 0 END IF
         IF cl_null(g_occ[g_rec_b].m5) THEN LET g_occ[g_rec_b].m5 = 0 END IF
         IF cl_null(g_occ[g_rec_b].m6) THEN LET g_occ[g_rec_b].m6 = 0 END IF
         IF g_occ[g_rec_b].m4 > 0 THEN LET g_occ[g_rec_b].m4 = g_occ[g_rec_b].m4*(-1) END IF  #TQC-D20046--qiull--add--
         IF g_occ[g_rec_b].m5 > 0 THEN LET g_occ[g_rec_b].m5 = g_occ[g_rec_b].m5*(-1) END IF  #TQC-D20046--qiull--add--
         #期末數量，期末金額
         IF tm.cb1 = 'Y' THEN 
            #LET g_occ[g_rec_b].n6 = g_occ[g_rec_b].n1 +g_occ[g_rec_b].n2 -g_occ[g_rec_b].n3 -g_occ[g_rec_b].n4 +g_occ[g_rec_b].n5  #TQC-D20046--mark
            LET g_occ[g_rec_b].n6 = g_occ[g_rec_b].n1 +g_occ[g_rec_b].n2 -g_occ[g_rec_b].n3 +g_occ[g_rec_b].n4 -g_occ[g_rec_b].n5  #TQC-D20046--add
         END IF 
        #LET g_occ[g_rec_b].m6 = g_occ[g_rec_b].m1 +g_occ[g_rec_b].m2 -g_occ[g_rec_b].m3 -g_occ[g_rec_b].m4 +g_occ[g_rec_b].m5 #TQC-D20046--mark
         LET g_occ[g_rec_b].m6 = g_occ[g_rec_b].m1 +g_occ[g_rec_b].m2 -g_occ[g_rec_b].m3 +g_occ[g_rec_b].m4 -g_occ[g_rec_b].m5 #TQC-D20046--add

         #FUN-D50073--add--str--
         INSERT INTO axcq803_tmp VALUES(g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02,
                                        g_occ[g_rec_b].ima01,g_occ[g_rec_b].ima02,
                                        g_occ[g_rec_b].ima021,
                                        g_occ[g_rec_b].n1,g_occ[g_rec_b].m1,
                                        g_occ[g_rec_b].n2,g_occ[g_rec_b].m2,
                                        g_occ[g_rec_b].n3,g_occ[g_rec_b].m3,
                                        g_occ[g_rec_b].n4,g_occ[g_rec_b].m4,
                                        g_occ[g_rec_b].n5,g_occ[g_rec_b].m5,
                                        g_occ[g_rec_b].n6,g_occ[g_rec_b].m6)
         IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
            CALL cl_err3('ins','axcq803_tmp',g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02,SQLCA.sqlcode,'','',1)
            EXIT FOREACH
         END IF
         #FUN-D50073--add--end--
      
      END FOREACH
   ELSE
      FOREACH q803_cs INTO l_occ01,l_ima01
      IF tm.cb1 = 'Y' THEN
         LET temp_ima01 = l_ima01
         IF temp_ima01.substring(1,4) = "MISC" THEN
            CONTINUE FOREACH
         END IF
      END IF
      #g_rec_b賦值
      LET g_rec_b = g_rec_b + 1
      #occ01,occ02
      SELECT occ01,occ02 INTO g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02
        FROM oga_file,occ_file 
       WHERE occ01 = oga03 AND occacti='Y' 
         AND ogapost='Y'   AND occ01 = l_occ01
#No.MOD-D40095 --begin
      IF STATUS THEN
      SELECT occ01,occ02 INTO g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02
        FROM oha_file,occ_file
       WHERE occ01 = oha03 AND occacti='Y'
         AND ohapost='Y'   AND occ01 = l_occ01
      END IF
#No.MOD-D40095 --end
      LET g_occ[g_rec_b].ima01 = l_ima01
      #TQC-D20046--qiull--add--str--
      SELECT ima02,ima021 INTO g_occ[g_rec_b].ima02,g_occ[g_rec_b].ima021
        FROM ima_file
       WHERE ima01 = g_occ[g_rec_b].ima01
      #TQC-D20046--qiull--add--end--
      #期初數量，期初金額
      
      IF tm.cb1 = 'Y' THEN 
         #期初數量
         SELECT SUM(imk09) INTO g_occ[g_rec_b].n1
           FROM imk_file,ccc_file  
          WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
            AND imk05 = l_yy     AND imk06 = l_mm 
            AND imk01 = l_ima01  AND imk01=ccc01
            AND ccc02 = l_yy     AND ccc03 = l_mm
           AND ccc07 = tm.ccc07 AND (ccc08 = tm.ccc08 OR ccc08 IS NULL )
        #期初金額
#No.MOD-D50198 --begin
#发票仓为成本仓时，都取当月成本价，为非成本仓时期初为上期余额（不是数量*单价）
#        SELECT SUM(imk09*ccc23) INTO g_occ[g_rec_b].m1
#          FROM imk_file,ccc_file 
#         WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
#           AND imk01=ccc01      AND imk01 = l_ima01 
#           AND imk05 = l_yy     AND imk06 = l_mm 
#           AND ccc02 = l_yy     AND ccc03 = l_mm
#           AND ccc07 = tm.ccc07 AND (ccc08 = tm.ccc08 OR ccc08 IS NULL )

        IF l_flag = 'Y' THEN 
           SELECT SUM(imk09*ccc23) INTO g_occ[g_rec_b].m1
             FROM imk_file,ccc_file 
            WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
              AND imk01 = ccc01    AND imk01 = l_ima01 
              AND imk05 = tm.yy     AND imk06 = tm.mm 
              AND ccc02 = tm.yy     AND ccc03 = tm.mm
              AND ccc07 = tm.ccc07 AND (ccc08 = tm.ccc08 OR ccc08 IS NULL )
        ELSE 
           SELECT SUM(ccc12) INTO g_occ[g_rec_b].m1
             FROM imk_file,ccc_file 
            WHERE imk02 = g_oaz95  AND imk03 = g_occ[g_rec_b].occ01 
              AND imk01 = ccc01    AND imk01 = l_ima01 
              AND imk05 = tm.yy     AND imk06 = tm.mm 
              AND ccc02 = tm.yy     AND ccc03 = tm.mm
              AND ccc07 = tm.ccc07 AND (ccc08 = tm.ccc08 OR ccc08 IS NULL )
        END IF 
#No.MOD-D50198 --end
      ELSE
         #期初金額
#No.MOD-D50198 --begin
#发票仓为成本仓时，都取当月成本价，为非成本仓时期初为上期余额（不是数量*单价）
#         LET l_sql = " SELECT SUM(imk09*ccc23) ",
#                     "   FROM imk_file,ccc_file ",
#                     "  WHERE imk02 = '",g_oaz95 ,"'",
#                     "    AND imk03 = '",g_occ[g_rec_b].occ01 ,"'",
#                     "    AND imk01=ccc01 ",     
#                     "    AND ",l_wc2 ,
#                     "    AND imk05 = '",l_yy ,"'",   
#                     "    AND imk06 = '",l_mm ,"'",
#                     "    AND ccc02 = '",l_yy ,"'",  
#                     "    AND ccc03 = '",l_mm ,"'",
#                     "    AND ccc07 = '",tm.ccc07 ,"'",
#                     "    AND (ccc08 = '",tm.ccc08,"' OR ccc08 IS NULL ) "
#         PREPARE p803_imk09_1 FROM l_sql
#         EXECUTE p803_imk09_1 INTO g_occ[g_rec_b].m1
         IF l_flag = 'Y' THEN 
            LET l_sql = " SELECT SUM(imk09*ccc23) ",
                        "   FROM imk_file,ccc_file ",
                        "  WHERE imk02 = '",g_oaz95 ,"'",
                        "    AND imk03 = '",g_occ[g_rec_b].occ01 ,"'",
                        "    AND imk01=ccc01 ",     
                        "    AND ",l_wc2 ,
                        "    AND imk05 = '",tm.yy ,"'",   
                        "    AND imk06 = '",tm.mm ,"'",
                        "    AND ccc02 = '",tm.yy ,"'",  
                        "    AND ccc03 = '",tm.mm ,"'",
                        "    AND ccc07 = '",tm.ccc07 ,"'",
                        "    AND (ccc08 = '",tm.ccc08,"' OR ccc08 IS NULL ) "
         ELSE 
            LET l_sql = " SELECT SUM(ccc12) ",
                        "   FROM imk_file,ccc_file ",
                        "  WHERE imk02 = '",g_oaz95 ,"'",
                        "    AND imk03 = '",g_occ[g_rec_b].occ01 ,"'",
                        "    AND imk01=ccc01 ",     
                        "    AND ",l_wc2 ,
                        "    AND imk05 = '",tm.yy ,"'",   
                        "    AND imk06 = '",tm.mm ,"'",
                        "    AND ccc02 = '",tm.yy ,"'",  
                        "    AND ccc03 = '",tm.mm ,"'",
                        "    AND ccc07 = '",tm.ccc07 ,"'",
                        "    AND (ccc08 = '",tm.ccc08,"' OR ccc08 IS NULL ) "
         END IF 
         PREPARE p803_imk09_1 FROM l_sql
         EXECUTE p803_imk09_1 INTO g_occ[g_rec_b].m1
#No.MOD-D50198 --end
      END IF 
      #本月出貨轉入數量與金額，本月出貨轉出數量與金額，本月銷退轉入數量與金額，本月銷退轉出數量與金額
      IF tm.cb1 = 'Y' THEN 
         #本月出貨轉入數量與金額
         SELECT -SUM (tlf907*tlf10*tlf60) INTO g_occ[g_rec_b].n2 FROM tlf_file,tlfc_file 
          WHERE YEAR(tlf06)=tm.yy 
            AND MONTH(tlf06)=tm.mm 
            AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
            AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
            AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
            AND tlf13 like 'axmt6%' AND tlf13<>'axmt670'
            AND tlf19=g_occ[g_rec_b].occ01
           #AND tlf907=-1
            AND tlf01 = l_ima01
            AND tlf902 <> g_oaz.oaz95
            AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            AND tlf99 IS NULL    #No.MOD-D50165
            
         SELECT -SUM(tlfc907*tlfc21) INTO g_occ[g_rec_b].m2 FROM tlfc_file LEFT  OUTER  JOIN 
           tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
          WHERE YEAR(tlfc06)=tm.yy 
            AND MONTH(tlfc06)=tm.mm 
            AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' 
            AND tlf19=g_occ[g_rec_b].occ01
           #AND tlfc907=-1 
            AND tlfctype=tm.ccc07
            AND tlfc902<> g_oaz.oaz95
            AND tlfc01 = l_ima01
            AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )
            AND tlfc905 IN (SELECT oga01 FROM oga_file WHERE oga99 IS NULL)   #No.MOD-D50165
            
         #本月出貨轉出數量與金額
         SELECT SUM (tlf10*tlf60) INTO g_occ[g_rec_b].n3 FROM tlf_file 
          WHERE YEAR(tlf06)=tm.yy 
            AND MONTH(tlf06)=tm.mm 
            AND tlf13='axmt670' 
            AND tlf19=g_occ[g_rec_b].occ01
            AND tlf907=-1
            AND tlf01 = l_ima01
            AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            
         SELECT SUM(tlfc21) INTO g_occ[g_rec_b].m3  FROM tlfc_file LEFT  OUTER  JOIN 
           tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
          WHERE YEAR(tlfc06)=tm.yy 
            AND MONTH(tlfc06)=tm.mm 
            AND tlfc13='axmt670' 
            AND tlf19=g_occ[g_rec_b].occ01
            AND tlfc907=-1 
            AND tlfctype=tm.ccc07
            AND tlfc01 = l_ima01
            AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )

         #本月銷退轉入數量與金額
         SELECT SUM (tlf10*tlf60) INTO g_occ[g_rec_b].n4 FROM tlf_file 
          WHERE YEAR(tlf06)=tm.yy 
            AND MONTH(tlf06)=tm.mm 
            AND tlf13='aomt800' 
            AND tlf907=1
            AND tlf19=g_occ[g_rec_b].occ01
            AND tlf01 = l_ima01
            AND tlf902<> g_oaz.oaz95
            AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            AND tlf905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165
            
         SELECT SUM(tlfc21) INTO g_occ[g_rec_b].m4 FROM tlfc_file LEFT  OUTER  JOIN 
           tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
          WHERE YEAR(tlfc06)=tm.yy 
            AND MONTH(tlfc06)=tm.mm 
            AND tlfc13='aomt800' 
            AND tlf19=g_occ[g_rec_b].occ01
            AND tlf907=1
            AND tlfctype=tm.ccc07
            AND tlfc902<> g_oaz.oaz95
            AND tlfc01 = l_ima01
            AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )
            AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165
            
         #本月銷退轉出數量與金額
         SELECT SUM (tlf10*tlf60) INTO g_occ[g_rec_b].n5 FROM tlf_file 
          WHERE YEAR(tlf06)=tm.yy 
            AND MONTH(tlf06)=tm.mm 
            AND tlf13='axmt670' 
            AND tlf19=g_occ[g_rec_b].occ01
            AND tlf907=1
            AND tlf01 = l_ima01
            AND (tlfcost = tm.ccc08 OR tlfcost IS NULL )
            AND tlf905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165
            
         SELECT SUM(tlfc21) INTO g_occ[g_rec_b].m5 FROM tlfc_file LEFT  OUTER  JOIN 
           tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
                    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
                    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
          WHERE YEAR(tlfc06)=tm.yy 
            AND MONTH(tlfc06)=tm.mm 
            AND tlfc13='axmt670' 
            AND tlf19=g_occ[g_rec_b].occ01
            AND tlfc907=1 
            AND tlfctype=tm.ccc07
            AND tlfc01 = l_ima01
            AND (tlfccost = tm.ccc08 OR tlfccost IS NULL )
            AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1')   #No.MOD-D50165
      ELSE
         #本月出貨轉入金額
         LET l_sql = " SELECT -SUM(tlfc907*tlfc21) FROM tlfc_file,tlf_file ",
                     "  WHERE tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "    AND YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13 like 'axmt6%' AND tlfc13<>'axmt670' ",
                     "    AND tlf19= '",g_occ[g_rec_b].occ01 ,"'",
                   # "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND tlf902<> '",g_oaz.oaz95,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL ) ",
                     "    AND tlf99 IS NULL ",            #No.MOD-D50165
                     "    AND ",l_wc3
         PREPARE p803_tlfc21_2_1 FROM l_sql
         EXECUTE p803_tlfc21_2_1 INTO g_occ[g_rec_b].m2
         
         #本月出貨轉出金額
         LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file ",
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)= '",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19= '",g_occ[g_rec_b].occ01 ,"'",
                     "    AND tlfc907= -1 ",
                     "    AND tlfctype= '",tm.ccc07,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND ",l_wc3
         PREPARE p803_tlfc21_3_1 FROM l_sql
         EXECUTE p803_tlfc21_3_1 INTO g_occ[g_rec_b].m3

         #本月銷退轉入金額
         LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='aomt800' ",
                     "    AND tlf19='",g_occ[g_rec_b].occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND tlf902<> '",g_oaz.oaz95,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1') ",            #No.MOD-D50165
                     "    AND ",l_wc3
         PREPARE p803_tlfc21_4_1 FROM l_sql
         EXECUTE p803_tlfc21_4_1 INTO g_occ[g_rec_b].m4
         #本月銷退轉出金額
         LET l_sql = " SELECT SUM(tlfc21) FROM tlfc_file " ,
                     " LEFT  OUTER  JOIN tlf_file ON  tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02 ",
                     "    AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903 ",
                     "    AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906 ",
                     "  WHERE YEAR(tlfc06)='",tm.yy ,"'",
                     "    AND MONTH(tlfc06)='",tm.mm ,"'",
                     "    AND tlfc13='axmt670' ",
                     "    AND tlf19='",g_occ[g_rec_b].occ01,"'",
                     "    AND tlf907=1 ",
                     "    AND tlfctype='",tm.ccc07,"'",
                     "    AND (tlfccost = '",tm.ccc08,"' OR tlfccost IS NULL )",
                     "    AND tlfc905 IN (SELECT rvu01 FROM rvu_file WHERE rvu116 <> '1') ",            #No.MOD-D50165
                     "    AND ",l_wc3
         PREPARE p803_tlfc21_5_1 FROM l_sql
         EXECUTE p803_tlfc21_5_1 INTO g_occ[g_rec_b].m5
      END IF 
      #數值欄位如果為null給0
      IF tm.cb1 = 'Y' THEN 
         IF cl_null(g_occ[g_rec_b].n1) THEN LET g_occ[g_rec_b].n1 = 0 END IF 
         IF cl_null(g_occ[g_rec_b].n2) THEN LET g_occ[g_rec_b].n2 = 0 END IF
         IF cl_null(g_occ[g_rec_b].n3) THEN LET g_occ[g_rec_b].n3 = 0 END IF
         IF cl_null(g_occ[g_rec_b].n4) THEN LET g_occ[g_rec_b].n4 = 0 END IF
         IF cl_null(g_occ[g_rec_b].n5) THEN LET g_occ[g_rec_b].n5 = 0 END IF
         IF cl_null(g_occ[g_rec_b].n6) THEN LET g_occ[g_rec_b].n6 = 0 END IF
         IF g_occ[g_rec_b].n4 > 0 THEN LET g_occ[g_rec_b].n4 = g_occ[g_rec_b].n4*(-1) END IF   #TQC-D20046--qiull--add--
         IF g_occ[g_rec_b].n5 > 0 THEN LET g_occ[g_rec_b].n5 = g_occ[g_rec_b].n5*(-1) END IF   #TQC-D20046--qiull--add--
      END IF 
      IF cl_null(g_occ[g_rec_b].m1) THEN LET g_occ[g_rec_b].m1 = 0 END IF 
      IF cl_null(g_occ[g_rec_b].m2) THEN LET g_occ[g_rec_b].m2 = 0 END IF
      IF cl_null(g_occ[g_rec_b].m3) THEN LET g_occ[g_rec_b].m3 = 0 END IF
      IF cl_null(g_occ[g_rec_b].m4) THEN LET g_occ[g_rec_b].m4 = 0 END IF
      IF cl_null(g_occ[g_rec_b].m5) THEN LET g_occ[g_rec_b].m5 = 0 END IF
      IF cl_null(g_occ[g_rec_b].m6) THEN LET g_occ[g_rec_b].m6 = 0 END IF
      IF g_occ[g_rec_b].m4 > 0 THEN LET g_occ[g_rec_b].m4 = g_occ[g_rec_b].m4*(-1) END IF  #TQC-D20046--qiull--add--
      IF g_occ[g_rec_b].m5 > 0 THEN LET g_occ[g_rec_b].m5 = g_occ[g_rec_b].m5*(-1) END IF  #TQC-D20046--qiull--add--
      #期末數量，期末金額
      IF tm.cb1 = 'Y' THEN 
         #LET g_occ[g_rec_b].n6 = g_occ[g_rec_b].n1 +g_occ[g_rec_b].n2 -g_occ[g_rec_b].n3 -g_occ[g_rec_b].n4 +g_occ[g_rec_b].n5 #TQC-D20046--mark
         LET g_occ[g_rec_b].n6 = g_occ[g_rec_b].n1 +g_occ[g_rec_b].n2 -g_occ[g_rec_b].n3 +g_occ[g_rec_b].n4 -g_occ[g_rec_b].n5 #TQC-D20046--add
      END IF 
     #LET g_occ[g_rec_b].m6 = g_occ[g_rec_b].m1 +g_occ[g_rec_b].m2 -g_occ[g_rec_b].m3 -g_occ[g_rec_b].m4 +g_occ[g_rec_b].m5  #TQC-D20046--mark
      LET g_occ[g_rec_b].m6 = g_occ[g_rec_b].m1 +g_occ[g_rec_b].m2 -g_occ[g_rec_b].m3 +g_occ[g_rec_b].m4 -g_occ[g_rec_b].m5  #TQC-D20046--add

      #FUN-D50073--add--str--
      INSERT INTO axcq803_tmp VALUES(g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02,
                                     g_occ[g_rec_b].ima01,g_occ[g_rec_b].ima02,
                                     g_occ[g_rec_b].ima021,
                                     g_occ[g_rec_b].n1,g_occ[g_rec_b].m1,
                                     g_occ[g_rec_b].n2,g_occ[g_rec_b].m2,
                                     g_occ[g_rec_b].n3,g_occ[g_rec_b].m3,
                                     g_occ[g_rec_b].n4,g_occ[g_rec_b].m4,
                                     g_occ[g_rec_b].n5,g_occ[g_rec_b].m5,
                                     g_occ[g_rec_b].n6,g_occ[g_rec_b].m6)
      IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
         CALL cl_err3('ins','axcq803_tmp',g_occ[g_rec_b].occ01,g_occ[g_rec_b].occ02,SQLCA.sqlcode,'','',1)
         EXIT FOREACH
      END IF
      #FUN-D50073--add--end--
      
   END FOREACH
   END IF 
   #FUN-D50073--add--str--
   SELECT SUM(n1),SUM(m1),
          SUM(n2),SUM(m2),
          SUM(n3),SUM(m3),
          SUM(n4),SUM(m4),
          SUM(n5),SUM(m5),
          SUM(n6),SUM(m6)
    INTO l_n1_tot,l_m1_tot,
         l_n2_tot,l_m2_tot,
         l_n3_tot,l_m3_tot,
         l_n4_tot,l_m4_tot,
         l_n5_tot,l_m5_tot,
         l_n6_tot,l_m6_tot
    FROM axcq803_tmp
    DISPLAY l_n1_tot TO FORMONLY.n1_tot
    DISPLAY l_n2_tot TO FORMONLY.n2_tot
    DISPLAY l_n3_tot TO FORMONLY.n3_tot
    DISPLAY l_n4_tot TO FORMONLY.n4_tot
    DISPLAY l_n5_tot TO FORMONLY.n5_tot
    DISPLAY l_n6_tot TO FORMONLY.n6_tot
    DISPLAY l_m1_tot TO FORMONLY.m1_tot
    DISPLAY l_m2_tot TO FORMONLY.m2_tot
    DISPLAY l_m3_tot TO FORMONLY.m3_tot
    DISPLAY l_m4_tot TO FORMONLY.m4_tot
    DISPLAY l_m5_tot TO FORMONLY.m5_tot
    DISPLAY l_m6_tot TO FORMONLY.m6_tot
    IF tm.cb1 = 'Y' THEN
       CALL cl_set_comp_visible('n1_tot,n2_tot,n3_tot,n4_tot,n5_tot,n6_tot',TRUE)
    ELSE
       CALL cl_set_comp_visible('n1_tot,n2_tot,n3_tot,n4_tot,n5_tot,n6_tot',FALSE)
    END IF
    #FUN-D50073--add--end--
END FUNCTION 

FUNCTION q803_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY ARRAY g_occ TO sr.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW

         CALL cl_show_fld_cont()                 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q803_rep()
   DEFINE l_occ01_r   LIKE occ_file.occ01,
          l_ima01_r   LIKE ima_file.ima01,
          l_occ01_a   LIKE occ_file.occ01,
          l_ima01_a   LIKE ima_file.ima01
   DEFINE l_cmd     STRING
   DEFINE l_str     STRING 
   DEFINE l_str2    STRING 
   LET g_sql = " SELECT DISTINCT occ01,ima01 ",
               " FROM ima_file ,imk_file,occ_file,oga_file ",
               " WHERE ima01 = imk01 AND imk03 = occ01 ",
               "   AND occ01 = oga03 AND occacti = 'Y' AND ogapost = 'Y' ",
               "   AND imk05 = ",tm.yy," AND imk06 = ",tm.mm,
               "   AND ",g_wc,
               "   AND ",g_wc2
   PREPARE q803_pre_r FROM g_sql
   DECLARE q803_cs_r  CURSOR FOR q803_pre_r
   LET l_str = " occ01 IN ("
   LET l_str2 = " ima01 IN ("
   FOREACH q803_cs_r INTO l_occ01_r,l_ima01_r
      LET l_str = l_str,',"',l_occ01_r,'"'
      LET l_str2 = l_str2,',"',l_ima01_r,'"'
      LET l_occ01_a = l_occ01_r
      LET l_ima01_a = l_ima01_r
   END FOREACH 
   LET l_str = l_str,')'
   LET l_str = cl_replace_str(l_str,'(,','(') 
   LET l_str2 = l_str2,')'
   LET l_str2 = cl_replace_str(l_str2,'(,','(') 

   LET g_str = "axcr803"," '",l_str,"' '",l_str2,"' '",tm.yy,"' '",tm.mm,
               "' '",tm.ccc07,"' '",tm.ccc08,"' '",tm.cb1,"' '",tm.more,"' 'Y'"
   CALL cl_cmdrun_wait(g_str)
            
END FUNCTION 
#FUN-C60036 add
