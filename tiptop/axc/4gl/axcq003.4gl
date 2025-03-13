# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axcq003.4gl
# Descriptions...:  入库成本调节资料查询
# Date & Author..: No.FUN-C90076 12/11/14 By xujing
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm         RECORD
                   wc  	    STRING, 
                   ccz01    LIKE ccz_file.ccz01,   
                   ccz02    LIKE ccz_file.ccz02,
                   a        LIKE type_file.chr1  
                  END RECORD,
       g_ccb,g_ccb_excel  DYNAMIC ARRAY OF RECORD
                   azf01   LIKE azf_file.azf01,  
                   azf03   LIKE azf_file.azf03,
                   ccc01   LIKE ccc_file.ccc01,  
                   ima02   LIKE ima_file.ima02,  
                   ima021  LIKE ima_file.ima021, 
                   ccb22   LIKE ccb_file.ccb22,	
                   ccb22a  LIKE ccb_file.ccb22a,
                   ccb22b  LIKE ccb_file.ccb22b,
                   ccb22d  LIKE ccb_file.ccb22d,
                   ccb22c  LIKE ccb_file.ccb22c,
                   ccb22e  LIKE ccb_file.ccb22e,
                   ccb22f  LIKE ccb_file.ccb22f,
                   ccb22g  LIKE ccb_file.ccb22g,
                   ccb22h  LIKE ccb_file.ccb22h,
                   ima39   LIKE ima_file.ima39,
                   aag02   LIKE aag_file.aag02,
                   ccb23   LIKE ccb_file.ccb23,
                   ccb04   LIKE ccb_file.ccb04
                  END RECORD,

       g_ccb_1     DYNAMIC ARRAY OF RECORD
                   ccc01   LIKE ccc_file.ccc01,
                   ima02   LIKE ima_file.ima02,  
                   ima021  LIKE ima_file.ima021, 
                   azf01   LIKE azf_file.azf01,  
                   azf03   LIKE azf_file.azf03,
                   ima39   LIKE ima_file.ima39,
                   aag02   LIKE aag_file.aag02,  
                   ccb23   LIKE ccb_file.ccb23,
                   ccb04   LIKE ccb_file.ccb04,
                   ccb22   LIKE ccb_file.ccb22,	
                   ccb22a  LIKE ccb_file.ccb22a,
                   ccb22b  LIKE ccb_file.ccb22b,
                   ccb22d  LIKE ccb_file.ccb22d,
                   ccb22c  LIKE ccb_file.ccb22c,
                   ccb22e  LIKE ccb_file.ccb22e,
                   ccb22f  LIKE ccb_file.ccb22f,
                   ccb22g  LIKE ccb_file.ccb22g,
                   ccb22h  LIKE ccb_file.ccb22h,
                   ima39_1 LIKE ima_file.ima39,
                   aag02_1 LIKE aag_file.aag02,
                   ccb23_1 LIKE ccb_file.ccb23,
                   ccb04_1 LIKE ccb_file.ccb04,
                   azf01_1 LIKE azf_file.azf01,
                   azf03_1 LIKE azf_file.azf03
                  END RECORD,
      
       pay_sw     LIKE type_file.num5,         # No.FUN-690028 SMALLINT
       g_wc,g_sql STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN
       g_rec_b    LIKE type_file.num5, 	       #單身筆數  #No.FUN-690028 SMALLINT
       g_rec_b2   LIKE type_file.num5, 	       #單身筆數  #cy add
       g_cnt      LIKE type_file.num10         #No.FUN-690028 INTEGER
DEFINE g_msg      STRING 
DEFINE l_ac       LIKE type_file.num5          #No.FUN-A320028 
DEFINE l_ac1      LIKE type_file.num5          #cy add
DEFINE g_filter_wc  STRING                     #cy add 
DEFINE g_flag         LIKE type_file.chr1    #FUN-C80102 
DEFINE g_action_flag  LIKE type_file.chr100  #FUN-C80102 
DEFINE g_comb         ui.ComboBox            #FUN-C80102 
DEFINE g_cmd          STRING 
#FUN-C80102--add--str--
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
#FUN-C80102--add--end--
DEFINE g_argv1   LIKE type_file.num5
DEFINE g_argv2   LIKE type_file.num5
 
MAIN
   DEFINE l_time	LIKE type_file.chr8    #計算被使用時間  #No.FUN-690028 VARCHAR(8)
   DEFINE l_sl		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_argv1 = ARG_VAL(1)     #年度
   LET g_argv2 = ARG_VAL(2)     #期別
    
   OPEN WINDOW q003_w WITH FORM "axc/42f/axcq003"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
   CALL q003_table()
   CALL q003_q()
   
   CALL q003_menu()
   DROP TABLE axcq003_tmp;
   CLOSE WINDOW q003_w               #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q003_cs()
   DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   l_wc        STRING                #MOD-B10024

   CLEAR FORM #清除畫面
   LET g_filter_wc = ''
   DISPLAY BY NAME tm.ccz01,tm.ccz02,tm.a
   IF cl_null(g_action_choice) AND NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET tm.ccz01 = g_argv1  
      LET tm.ccz02 = g_argv2 
   ELSE
   DIALOG ATTRIBUTES(UNBUFFERED)  

   INPUT BY NAME tm.ccz01,tm.ccz02,tm.a ATTRIBUTE (WITHOUT DEFAULTS=TRUE) 

      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)   
         
      AFTER FIELD a
         IF cl_null(tm.a) THEN 
            NEXT FIELD a
         END IF 

   END INPUT

   CONSTRUCT tm.wc ON azf01,ccc01,ima39,ccb23,ccb04
                FROM s_ccb[1].azf01,s_ccb[1].ccc01,s_ccb[1].ima39,
                     s_ccb[1].ccb23,s_ccb[1].ccb04
                
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

   END CONSTRUCT
   
      AFTER DIALOG
          IF tm.a = '1' THEN 
             CALL cl_set_comp_visible("azf01_1,azf03_1,ccb23_sum,ccb04_1,ima39_1,aag02_1",FALSE)
          END IF 
          IF tm.a = '2' THEN  
             CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,azf01_1,azf03_1,ccb04_1,ima39_1,aag02_1",FALSE)
             CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",FALSE)
          END IF 
          IF tm.a = '3' THEN 
             CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima39_1,aag02_1,ccb23_sum,ccb04_1",FALSE)
             CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",FALSE)
          END IF
          IF tm.a = '4' THEN
             CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,azf01_1,azf03_1,ccb23_sum,ccb04_1",FALSE)
             CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",FALSE)
          END IF

      ON ACTION CONTROLP
         CASE
          WHEN INFIELD(azf01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_azf"
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azf01
               NEXT FIELD azf01
               
          WHEN INFIELD(ccc01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccc01
               NEXT FIELD ccc01      
               
          WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag1"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39
               NEXT FIELD ima39    
          WHEN INFIELD(ccb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ccb04"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccb04
               NEXT FIELD ccb04               
 
         END CASE 
     
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         CALL cl_dynamic_locale()

      ON ACTION ACCEPT
         LET INT_FLAG = 0
         ACCEPT DIALOG
            
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG 

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
            
      ON ACTION close
         LET INT_FLAG = 1
         EXIT DIALOG  

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)

   END DIALOG  
   END IF 

   IF INT_FLAG THEN
      LET INT_FLAG = 0  
      LET g_action_choice = "page1"
#      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #cy add
#      EXIT PROGRAM                                     #cy add
      DELETE FROM axcq003_tmp
      RETURN
   END IF          

   CALL q003()  
   CALL q003_t()  

END FUNCTION

FUNCTION q003()
   DELETE FROM axcq003_tmp
   IF cl_null(tm.wc) THEN LET tm.wc = "1=1" END IF 
   IF cl_null(g_wc) THEN LET g_wc = "1=1" END IF 
   CALL q003_get_tmp(tm.wc,g_wc)
END FUNCTION

FUNCTION q003_table()
      CREATE TEMP TABLE axcq003_tmp(
                   azf01   LIKE azf_file.azf01,  
                   azf03   LIKE azf_file.azf03,
                   ccc01   LIKE ccc_file.ccc01,  
                   ima02   LIKE ima_file.ima02,  
                   ima021  LIKE ima_file.ima021, 
                   ccb22   LIKE ccb_file.ccb22,	
                   ccb22a  LIKE ccb_file.ccb22a,
                   ccb22b  LIKE ccb_file.ccb22b,
                   ccb22d  LIKE ccb_file.ccb22d,
                   ccb22c  LIKE ccb_file.ccb22c,
                   ccb22e  LIKE ccb_file.ccb22e,
                   ccb22f  LIKE ccb_file.ccb22f,
                   ccb22g  LIKE ccb_file.ccb22g,
                   ccb22h  LIKE ccb_file.ccb22h,
                   ima39   LIKE ima_file.ima39,
                   aag02   LIKE aag_file.aag02,
                   ccb23   LIKE ccb_file.ccb23,
                   ccb04   LIKE ccb_file.ccb04) 
                      
END FUNCTION


FUNCTION q003_get_tmp(p_wc1,p_wc2)
DEFINE l_sql,l_sql1  STRING 
DEFINE sr    RECORD 
                   azf01   LIKE azf_file.azf01,  
                   azf03   LIKE azf_file.azf03,
                   ccc01   LIKE ccc_file.ccc01,  
                   ima02   LIKE ima_file.ima02,  
                   ima021  LIKE ima_file.ima021, 
                   ccb22   LIKE ccb_file.ccb22,	
                   ccb22a  LIKE ccb_file.ccb22a,
                   ccb22b  LIKE ccb_file.ccb22b,
                   ccb22d  LIKE ccb_file.ccb22d,
                   ccb22c  LIKE ccb_file.ccb22c,
                   ccb22e  LIKE ccb_file.ccb22e,
                   ccb22f  LIKE ccb_file.ccb22f,
                   ccb22g  LIKE ccb_file.ccb22g,
                   ccb22h  LIKE ccb_file.ccb22h,
                   ima39   LIKE ima_file.ima39,
                   aag02   LIKE aag_file.aag02,
                   ccb23   LIKE ccb_file.ccb23,
                   ccb04   LIKE ccb_file.ccb04	
             END RECORD,
    p_wc1         STRING, 
    p_wc2         STRING,
    l_apk03      LIKE apk_file.apk03

    LET l_sql = "SELECT azf01,azf03,ccc01,ima02,ima021,ccb22,ccb22a,ccb22b,ccb22d,ccb22c,",
                "ccb22e,ccb22f,ccb22g,ccb22h,'' ima39,'' aag02,ccb23,ccb04",   
                "  FROM ccb_file,ccc_file LEFT OUTER JOIN ima_file ON ccc01 = ima01  ",
                                              " LEFT OUTER JOIN azf_file ON azf01 = ima12 ",      
                " WHERE ccc02 = '",tm.ccz01,"' AND ccc03 = '",tm.ccz02,"' AND (",p_wc1 CLIPPED,") ",
                " AND ccc01=ccb01 AND ccc02=ccb02 AND ccc03=ccb03"
                
   LET l_sql = l_sql CLIPPED," ORDER BY azf01,ccc01 "
   
   PREPARE q003_p FROM l_sql
   DECLARE q003_cs                        #SCROLL CURSOR
           SCROLL CURSOR FOR q003_p
   OPEN q003_cs
   FETCH FIRST q003_cs INTO sr.*
   IF SQLCA.SQLCODE THEN
      LET g_action_choice = "page1" 
      CALL cl_err('',100,0)
   END IF
   
   LET l_sql1 = " INSERT INTO axcq003_tmp ",
                 l_sql CLIPPED
   PREPARE q003_p1 FROM l_sql1
   EXECUTE q003_p1

   IF g_ccz.ccz07 = '1' THEN 
#     LET l_sql1 = "MERGE INTO axcq003_tmp o",
#                  "           USING (SELECT ima01,ima39 FROM ima_file) a ",
#                  "         ON (o.ccc01 = a.ima01) ",
#                  " WHEN MATCHED ",
#                  " THEN ",
#                  "    UPDATE ",
#                  "       SET o.ima39 = a.ima39, ",
#                  "           o.aag02 = (SELECT DISTINCT aag02 FROM aag_file WHERE aag01 = a.ima39 AND rownum <=1)"
      LET l_sql1 = "MERGE INTO axcq003_tmp o",
                   "           USING (SELECT ima01,ima39 FROM ima_file,aag_file",
                   "           WHERE  aag01 = ima39 AND aag00 = '",g_aza.aza81 CLIPPED,"') a ",
                   "         ON (o.ccc01 = a.ima01) ",
                   " WHEN MATCHED ",
                   " THEN ",
                   "    UPDATE ",
                   "       SET o.ima39 = a.ima39, ",
                   "           o.aag02 = (SELECT DISTINCT aag02 FROM aag_file WHERE aag01 = a.ima39 AND rownum <=1)"
   END IF

   IF g_ccz.ccz07 = '2' THEN 
#     LET l_sql1 = "MERGE INTO axcq003_tmp o",
#                  "           USING (SELECT ima01,imz39 FROM ima_file,imz_file",
#                  "           WHERE imz01 = ima06 ) a",
#                  "         ON (o.ccc01 = a.ima01) ",
#                  " WHEN MATCHED ",
#                  " THEN ",
#                  "    UPDATE ",
#                  "       SET o.ima39 = a.imz39,",
#                  "           o.aag02 = (SELECT DISTINCT aag02 FROM aag_file WHERE aag01 = a.imz39 AND rownum <=1) "
      LET l_sql1 = "MERGE INTO axcq003_tmp o",
                   "           USING (SELECT ima01,imz39 FROM ima_file,imz_file,aag_file",
                   "           WHERE imz01 = ima06",
                   "                 aag01 = imz39 AND aag00 = '",g_aza.aza81 CLIPPED,"') a ",
                   "         ON (o.ccc01 = a.ima01) ",
                   " WHEN MATCHED ",
                   " THEN ",
                   "    UPDATE ",
                   "       SET o.ima39 = a.imz39,",
                   "           o.aag02 = (SELECT DISTINCT aag02 FROM aag_file WHERE aag01 = a.imz39 AND rownum <=1) "
   END IF
   IF g_ccz.ccz07 MATCHES'[12]' THEN
      PREPARE q003_p2 FROM l_sql1
      EXECUTE q003_p2
   END IF      
END FUNCTION

FUNCTION q003_t()

   CLEAR FORM
   CALL g_ccb.clear()
   CALL g_ccb_excel.clear()
   CALL q003_show()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q003_show()
   DISPLAY tm.ccz01 TO ccz01
   DISPLAY tm.ccz02 TO ccz02
   DISPLAY tm.a TO a 

   CALL q003_b_fill_1()
   CALL q003_b_fill_2()

   IF NOT cl_null(g_action_choice) THEN   
      LET g_action_choice = "page1" 
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
   ELSE
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
   END IF
   
   CALL q003_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q003_set_visible()
   CALL cl_set_comp_visible("azf01_1,azf03_1,ccc01_1,ima02_1,ima021_1,ima39_1,aag02_1,ccb23_sum,ccb04_1",TRUE)
   CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",TRUE)
   CASE tm.a
     WHEN '1' 
         CALL cl_set_comp_visible("azf01_1,azf03_1,ccb23_sum,ccb04_1,ima39_1,aag02_1",FALSE)
     WHEN '2' 
         CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,azf01_1,azf03_1,ccb04_1,ima39_1,aag02_1",FALSE) 
         CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",FALSE)
     WHEN '3' 
         CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima39_1,aag02_1,ccb23_sum,ccb04_1",FALSE)
         CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",FALSE)
     WHEN '4' 
         CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,azf01_1,azf03_1,ccb23_sum,ccb04_1",FALSE)
         CALL cl_set_comp_visible("azf01_2,azf03_2,ccb04_2,ima39_2,aag02_2,ccb23_sum1",FALSE)
   END CASE
END FUNCTION

FUNCTION q003_b_fill_1()

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   LET g_sql = "SELECT * FROM axcq003_tmp ",
               " WHERE ",g_filter_wc CLIPPED,  
               " ORDER BY azf01,ccc01 "

   PREPARE axcq003_pb1 FROM g_sql
   DECLARE ccb_curs1  CURSOR FOR axcq003_pb1        #CURSOR

   CALL g_ccb.clear()
   CALL g_ccb_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH ccb_curs1 INTO g_ccb_excel[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach_ccb:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF g_cnt <= g_max_rec THEN
        LET g_ccb[g_cnt].* = g_ccb_excel[g_cnt].*
     END IF 
     LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_ccb.deleteElement(g_cnt)
   END IF
   CALL g_ccb_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q003_b_fill_2()

   CALL g_ccb_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
  
   CALL q003_get_sum()
 
END FUNCTION

FUNCTION q003_get_sum()
DEFINE l_tot1    LIKE ccb_file.ccb22a
DEFINE l_tot2    LIKE ccb_file.ccb22b
DEFINE l_tot3    LIKE ccb_file.ccb22c
DEFINE l_tot4    LIKE ccb_file.ccb22d
DEFINE l_tot5    LIKE ccb_file.ccb22e
DEFINE l_tot6    LIKE ccb_file.ccb22f
DEFINE l_tot7    LIKE ccb_file.ccb22g
DEFINE l_tot8    LIKE ccb_file.ccb22h
DEFINE l_tot9    LIKE ccb_file.ccb22

   LET l_tot1 = 0 
   LET l_tot2 = 0 
   LET l_tot3 = 0 
   LET l_tot4 = 0 
   LET l_tot5 = 0 
   LET l_tot6 = 0 
   LET l_tot7 = 0 
   LET l_tot8 = 0 
   LET l_tot9 = 0

   CASE tm.a
      WHEN "1"
        LET g_sql = "SELECT ccc01,ima02,ima021,'','','','','','',",
                    "       SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),", 
                    "       SUM(ccb22c),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h),",
                    "       ima39,aag02,ccb23,ccb04,azf01,azf03",
                    " FROM axcq003_tmp WHERE ",g_filter_wc CLIPPED
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY ccc01,ima02,ima021,ima39,aag02,ccb23,ccb04,azf01,azf03",
                    " ORDER BY ccc01,ima02,ima021,ima39,aag02,ccb23,ccb04,azf01,azf03"
        PREPARE q003_pb1 FROM g_sql
        DECLARE q003_curs1 CURSOR FOR q003_pb1       
        FOREACH q003_curs1 INTO g_ccb_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccb_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF      
           LET g_cnt = g_cnt + 1
        END FOREACH 

      WHEN "2"
        LET g_sql = "SELECT '','','','','','','',ccb23,'',",
                    "       SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),", 
                    "       SUM(ccb22c),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h),",
                    "       '','','','','',''",
                    " FROM axcq003_tmp WHERE ",g_filter_wc CLIPPED
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY ccb23 ",
                    " ORDER BY ccb23 "
        PREPARE q003_pb2 FROM g_sql
        DECLARE q003_curs2 CURSOR FOR q003_pb2       
        FOREACH q003_curs2 INTO g_ccb_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccb_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF        
           LET g_cnt = g_cnt + 1
        END FOREACH

      WHEN "3"
        LET g_sql = "SELECT '','','',azf01,azf03,'','','','',",
                    "       SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),", 
                    "       SUM(ccb22c),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h),",
                    "       '','','','','',''",
                    " FROM axcq003_tmp WHERE ",g_filter_wc CLIPPED
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY azf01,azf03 ",
                    " ORDER BY azf01,azf03 "
        PREPARE q003_pb4 FROM g_sql
        DECLARE q003_curs4 CURSOR FOR q003_pb4       
        FOREACH q003_curs4 INTO g_ccb_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccb_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF        
           LET g_cnt = g_cnt + 1
        END FOREACH 

     WHEN "4"
        LET g_sql = "SELECT '','','','','',ima39,aag02,'','',",
                    "       SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),", 
                    "       SUM(ccb22c),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h),",
                    "       '','','','','',''",
                    " FROM axcq003_tmp WHERE ",g_filter_wc CLIPPED
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY ima39,aag02 ",
                    " ORDER BY ima39,aag02 "
        PREPARE q003_pb3 FROM g_sql
        DECLARE q003_curs3 CURSOR FOR q003_pb3       
        FOREACH q003_curs3 INTO g_ccb_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccb_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF 
           LET g_cnt = g_cnt + 1
        END FOREACH 

    END CASE
    LET g_sql = "SELECT SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),", 
                "       SUM(ccb22c),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h)",
                "  FROM axcq003_tmp WHERE ",g_filter_wc CLIPPED
    PREPARE sum_prep FROM g_sql
    EXECUTE sum_prep INTO l_tot9,l_tot1,l_tot2,l_tot3,l_tot4,
                          l_tot5,l_tot6,l_tot7,l_tot8
                          
    DISPLAY l_tot1 TO FORMONLY.sum1
    DISPLAY l_tot2 TO FORMONLY.sum2
    DISPLAY l_tot3 TO FORMONLY.sum3
    DISPLAY l_tot4 TO FORMONLY.sum4
    DISPLAY l_tot5 TO FORMONLY.sum5
    DISPLAY l_tot6 TO FORMONLY.sum6
    DISPLAY l_tot7 TO FORMONLY.sum7
    DISPLAY l_tot8 TO FORMONLY.sum8
    DISPLAY l_tot9 TO FORMONLY.sum9
        
    DISPLAY ARRAY g_ccb_1 TO s_ccb_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY  
      CALL g_ccb_1.deleteElement(g_cnt)
      LET g_rec_b2 = g_cnt - 1

    DISPLAY g_rec_b2 TO FORMONLY.cnt
END FUNCTION

FUNCTION q003_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CALL g_ccb.clear()
   CALL g_ccb_1.clear()
   DISPLAY BY NAME tm.ccz01,tm.ccz02,tm.a
   CONSTRUCT l_wc ON azf01,ccc01,ima39,ccb23,ccb04
                FROM s_ccb[1].azf01,s_ccb[1].ccc01,s_ccb[1].ima39,
                     s_ccb[1].ccb23,s_ccb[1].ccb04
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
          WHEN INFIELD(azf01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_azf"
               LET g_qryparam.state    = "c"
               LET g_qryparam.arg1     = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azf01
               NEXT FIELD azf01
               
          WHEN INFIELD(ccc01)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ima"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccc01
               NEXT FIELD ccc01   
               
          WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag1"
               LET g_qryparam.state    = "c"
               LET g_qryparam.where    = "aag00 = '",g_aza.aza81 CLIPPED,"' AND aagacti = 'Y' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39
               NEXT FIELD ima39  
               
          WHEN INFIELD(ccb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_ccb04"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ccb04
               NEXT FIELD ccb04 
      END CASE
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()
	 
   END CONSTRUCT
   
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF
  
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED 
END FUNCTION
#cy--add--end--
 
#中文的MENU
FUNCTION q003_menu()
 
   WHILE TRUE
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q003_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q003_bp2()
         END IF
      END IF 

      CASE g_action_choice

         WHEN "page1"
               CALL q003_bp("G")
         
         WHEN "page2"
               CALL q003_bp2()
  
         WHEN "data_filter"
               IF cl_chk_act_auth() THEN
                  CALL q003_filter_askkey()
                  CALL q003_show()
               END IF            

         WHEN "revert_filter"
              IF cl_chk_act_auth() THEN
                 LET g_filter_wc = ''
                 CALL cl_set_act_visible("revert_filter",FALSE) 
                 CALL q003_show() 
              END IF
#FUN-C80102--add--end--
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q003_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "  #FUN-C80102 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "  #FUN-C80102          
         #FUN-4B0009
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  #FUN-C80102 add
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_ccb_excel),'','')
                END IF
             END IF  #FUN-C80102
             IF g_action_flag = "page2" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_ccb_1),'','')
                END IF
             END IF

            LET g_action_choice = " "  #FUN-C80102 
#            MESSAGE "test by Raymon"

          WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "ccc01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q003_q()
    MESSAGE ""
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL
    SELECT * INTO g_ccz.* FROM ccz_file
    LET tm.ccz01 = g_ccz.ccz01
    LET tm.ccz02 = g_ccz.ccz02
    LET tm.a = '1'
    CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima39_1,aag02_1,azf01_1,azf03_1,ccb23_sum,ccb04_1",TRUE)
    CALL cl_set_comp_visible("page2", FALSE)
    CALL ui.interface.refresh()
    CALL cl_set_comp_visible("page2", TRUE)
    CALL g_ccb.clear()
    CALL g_ccb_excel.clear()
    CALL g_ccb_1.clear()
    LET g_action_choice = " " 
    CALL q003_cs()

END FUNCTION
 
FUNCTION q003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_flag = 'page1'   
  
   IF g_action_choice = "page1"  AND g_flag != '1' THEN
      CALL q003_b_fill_1()
   END IF
   LET g_action_choice = " "
   LET g_flag = ' '   #FUN-C80102
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY BY NAME tm.ccz01,tm.ccz02,tm.a

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS) 
           
         ON CHANGE a 
            IF NOT cl_null(tm.a)  THEN 
               CALL q003_b_fill_2()
               CALL q003_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q003_b_fill_1()
               CALL g_ccb_1.clear()
               DISPLAY 0  TO FORMONLY.cnt
               DISPLAY 0  TO FORMONLY.sum1
               DISPLAY 0  TO FORMONLY.sum2
               DISPLAY 0  TO FORMONLY.sum3
               DISPLAY 0  TO FORMONLY.sum4
               DISPLAY 0  TO FORMONLY.sum5
               DISPLAY 0  TO FORMONLY.sum6
               DISPLAY 0  TO FORMONLY.sum7
               DISPLAY 0  TO FORMONLY.sum8
            END IF
            DISPLAY BY NAME tm.a
            EXIT DIALOG 

      END INPUT 
 
      DISPLAY ARRAY g_ccb TO s_ccb.* ATTRIBUTE(COUNT=g_rec_b)   
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont() 
      END DISPLAY 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################

      ON ACTION page2
         LET g_action_choice = 'page2'
         CALL q003_b_fill_2()
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q003_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG   
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG   
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DIALOG   
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG  
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG  
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 

   END DIALOG  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#cy--add--str--
FUNCTION q003_bp2()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.ccz01,tm.ccz02,tm.a TO ccz01,ccz02,a
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN
               CALL q003_b_fill_2()
               CALL q003_set_visible()
               LET g_action_choice = "page2"
            ELSE
               CALL q003_b_fill_1()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page1"
               CALL g_ccb_1.clear()  
               DISPLAY 0  TO FORMONLY.cnt
               DISPLAY 0  TO FORMONLY.sum1
               DISPLAY 0  TO FORMONLY.sum2
               DISPLAY 0  TO FORMONLY.sum3
               DISPLAY 0  TO FORMONLY.sum4
               DISPLAY 0  TO FORMONLY.sum5
               DISPLAY 0  TO FORMONLY.sum6
               DISPLAY 0  TO FORMONLY.sum7
               DISPLAY 0  TO FORMONLY.sum8
            END IF
            DISPLAY tm.a TO a 
            EXIT DIALOG

      END INPUT

      DISPLAY ARRAY g_ccb_1 TO s_ccb_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
         END DISPLAY 

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q003_b_fill_1()
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = "page1"
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 

      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q003_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1" 
            LET g_flag = '1'            
            EXIT DIALOG 
         END IF

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG  

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG 

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about
         CALL cl_about()


      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
    
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION

FUNCTION q003_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_wc   STRING
DEFINE l_sql  STRING 
DEFINE l_tot1    LIKE ccb_file.ccb22a
DEFINE l_tot2    LIKE ccb_file.ccb22b
DEFINE l_tot3    LIKE ccb_file.ccb22c
DEFINE l_tot4    LIKE ccb_file.ccb22d
DEFINE l_tot5    LIKE ccb_file.ccb22e
DEFINE l_tot6    LIKE ccb_file.ccb22f
DEFINE l_tot7    LIKE ccb_file.ccb22g
DEFINE l_tot8    LIKE ccb_file.ccb22h
DEFINE l_tot9    LIKE ccb_file.ccb22

   LET l_tot9 = 0
   LET l_tot1 = 0
   LET l_tot2 = 0
   LET l_tot3 = 0
   LET l_tot4 = 0
   LET l_tot5 = 0
   LET l_tot6 = 0
   LET l_tot7 = 0
   LET l_tot8 = 0

   LET l_sql = "SELECT SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22d),",
                "       SUM(ccb22c),SUM(ccb22e),SUM(ccb22f),SUM(ccb22g),SUM(ccb22h)",
                "  FROM axcq003_tmp WHERE 1=1 "
   CASE tm.a
     WHEN "1"
        IF cl_null(g_ccb_1[p_ac].ccc01) THEN 
           LET g_ccb_1[p_ac].ccc01 = ''
           LET l_wc = " OR ccc01 IS NULL"
        ELSE
           LET l_wc = ''
        END IF
        LET g_sql = "SELECT * FROM axcq003_tmp ",
                    " WHERE (ccc01 = '",g_ccb_1[p_ac].ccc01,"' ",l_wc,")",
                    " ORDER BY ccc01,ima02,ima021 "
        PREPARE axcq003_pb_detail1 FROM g_sql
        DECLARE ccb_curs_detail1  CURSOR FOR axcq003_pb_detail1        #CURSOR
        CALL g_ccb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0       

        FOREACH ccb_curs_detail1 INTO g_ccb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH   
        LET l_sql = l_sql, " AND (ccc01 = '",g_ccb_1[p_ac].ccc01,"' ",l_wc,")" 
        PREPARE sum_prep1 FROM l_sql 
        EXECUTE sum_prep1 INTO l_tot9,l_tot1,l_tot2,l_tot3,l_tot4,
                               l_tot5,l_tot6,l_tot7,l_tot8        

      WHEN "2"
        IF cl_null(g_ccb_1[p_ac].ccb23) THEN 
           LET g_ccb_1[p_ac].ccb23 = ''
           LET l_wc = " OR ccb23 IS NULL"
        ELSE
           LET l_wc = ''
        END IF
        LET g_sql = "SELECT * FROM axcq003_tmp ", 
                    " WHERE (ccb23 = '",g_ccb_1[p_ac].ccb23,"' ",l_wc,")",
                    " ORDER BY ccb23,ccb04 "   
        PREPARE axcq003_pb_detail2 FROM g_sql
        DECLARE ccb_curs_detail2  CURSOR FOR axcq003_pb_detail2        #CURSOR
        CALL g_ccb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH ccb_curs_detail2 INTO g_ccb[g_cnt].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH   
        LET l_sql = l_sql, " AND (ccb23 = '",g_ccb_1[p_ac].ccb23,"' ",l_wc,")"
        PREPARE sum_prep2 FROM l_sql
        EXECUTE sum_prep2 INTO l_tot9,l_tot1,l_tot2,l_tot3,l_tot4,
                               l_tot5,l_tot6,l_tot7,l_tot8       
 
      WHEN "3"
        IF cl_null(g_ccb_1[p_ac].azf01) THEN
           LET g_ccb_1[p_ac].azf01 = ''
           LET l_wc = " OR azf01 IS NULL"
        ELSE
           LET l_wc = ''
        END IF
        LET g_sql = "SELECT * FROM axcq003_tmp ", 
                    " WHERE (azf01 = '",g_ccb_1[p_ac].azf01,"' ",l_wc,")",
                    " ORDER BY azf01,azf03 "   
        PREPARE axcq003_pb_detail4 FROM g_sql
        DECLARE ccb_curs_detail4  CURSOR FOR axcq003_pb_detail4        #CURSOR
        CALL g_ccb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH ccb_curs_detail4 INTO g_ccb[g_cnt].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH
        LET l_sql = l_sql, " AND (azf01 = '",g_ccb_1[p_ac].azf01,"' ",l_wc,")"
        PREPARE sum_prep3 FROM l_sql
        EXECUTE sum_prep3 INTO l_tot9,l_tot1,l_tot2,l_tot3,l_tot4,
                               l_tot5,l_tot6,l_tot7,l_tot8 
 
      WHEN "4"
        IF cl_null(g_ccb_1[p_ac].ima39) THEN
           LET g_ccb_1[p_ac].ima39 = ''
           LET l_wc = " OR ima39 IS NULL"
        ELSE
           LET l_wc = ''
        END IF
           LET g_sql = "SELECT * FROM axcq003_tmp ", 
                       " WHERE (ima39 = '",g_ccb_1[p_ac].ima39,"' ",l_wc,")",
                       " ORDER BY ima39,aag02 " 
	 
           PREPARE axcq003_pb_detail3 FROM g_sql
           DECLARE ccb_curs_detail3  CURSOR FOR axcq003_pb_detail3        #CURSOR
        	 
        CALL g_ccb.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH ccb_curs_detail3 INTO g_ccb[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH
        LET l_sql = l_sql, " AND (ima39 = '",g_ccb_1[p_ac].ima39,"' ",l_wc,")"
        PREPARE sum_prep4 FROM l_sql
        EXECUTE sum_prep4 INTO l_tot9,l_tot1,l_tot2,l_tot3,l_tot4,
                               l_tot5,l_tot6,l_tot7,l_tot8
   END CASE

   CALL g_ccb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cnt
   DISPLAY l_tot1 TO FORMONLY.sum1
   DISPLAY l_tot2 TO FORMONLY.sum2
   DISPLAY l_tot3 TO FORMONLY.sum3
   DISPLAY l_tot4 TO FORMONLY.sum4
   DISPLAY l_tot5 TO FORMONLY.sum5
   DISPLAY l_tot6 TO FORMONLY.sum6
   DISPLAY l_tot7 TO FORMONLY.sum7
   DISPLAY l_tot8 TO FORMONLY.sum8
   DISPLAY l_tot9 TO FORMONLY.sum9
END FUNCTION
#FUN-C90076
