# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axcq460.4gl
# Descriptions...: 进销存报表查询
# Date & Author..: 12/11/14 NO.FUN-C90076 By xujing
# Modify ........: No:MOD-D20002 13/02/01 By fengmy  返工领出、入库、结存调整的没有包含进来
# Modify ........: No.FUN-D10022 13/02/22 By xujing 修改axcq460 RUN axcq775的時候傳入的第六個參數(進庫|出庫)
# Modify ........: No.MOD-D20175 13/02/28 By wujie  ccc和azf的关联增加azf02 =‘G'
 
# Modify ........: No.MOD-D50052 13/05/08 By wujie  去掉一段where条件
# Modify ........: No.FUN-D60123 13/06/27 By chenying 匯總資料新增[總帳科目金額]與[差異金額]
# Modify ........: No.MOD-D70107 13/07/16 By wujie  将ccc52拆分为ccc52和ccc93，结存金额独立成列
# Modify ........: No.MOD-D70116 13/07/18 By wujie  明细单身增加ccc23，平均单价
# Modify ........: No.MOD-D70128 13/07/19 By wujie  将ccc27，ccc28，ccc25从ccc213，ccc223，ccc31中独立出来成为一列
# Modify ........: No.140226 By SunLM 科目余额不能aah算完后,又算abb,导致余额累计出错
# Modify ........: No.140425 By SunLM 数组错乱问题导致，字元转换至数字程序失败.

DATABASE ds
 
 
GLOBALS "../../config/top.global" 
#模組變數(Module Variables)
DEFINE tm         RECORD
                   wc  	    LIKE type_file.chr1000,		
                   ccz01    LIKE ccz_file.ccz01,   
                   ccz02    LIKE ccz_file.ccz02,
                   a        LIKE type_file.chr1  
                  END RECORD,
       g_ccc,g_ccc_excel   DYNAMIC ARRAY OF RECORD
                   azf01   LIKE azf_file.azf01,  #cy add
                   azf03   LIKE azf_file.azf03,
                   ccc01   LIKE ccc_file.ccc01,  #cy add
                   ima02   LIKE ima_file.ima02,  #cy add
                   ima021  LIKE ima_file.ima021,  #cy add
                   ima25   LIKE ima_file.ima25,
                   ccc11   LIKE ccc_file.ccc11,  #cy add
                   ccc12   LIKE ccc_file.ccc12, #cy add
                   ccc211  LIKE ccc_file.ccc211, #cy add
                   ccc221  LIKE ccc_file.ccc221,
                   ccc212  LIKE ccc_file.ccc212,
                   ccc222  LIKE ccc_file.ccc222,
                   ccc213  LIKE ccc_file.ccc213,
                   ccc223  LIKE ccc_file.ccc223,
                   ccc27   LIKE ccc_file.ccc27,    #No.MOD-D70128 add ccc27
                   ccc28   LIKE ccc_file.ccc28,    #No.MOD-D70128 add ccc28
                   ccc214  LIKE ccc_file.ccc214,
                   ccc224  LIKE ccc_file.ccc224,
                   ccc215  LIKE ccc_file.ccc215,
                   ccc225  LIKE ccc_file.ccc225,
                   ccc31   LIKE ccc_file.ccc31,
                   ccc32   LIKE ccc_file.ccc32,
                   ccc41   LIKE ccc_file.ccc41,
                   ccc42   LIKE ccc_file.ccc42,
                   ccc61   LIKE ccc_file.ccc61,
                   ccc62   LIKE ccc_file.ccc62,
                   ccc81   LIKE ccc_file.ccc81,
                   ccc82   LIKE ccc_file.ccc82,
                   ccc25   LIKE ccc_file.ccc25,    #No.MOD-D70128 add ccc25
                   ccc71   LIKE ccc_file.ccc71,
                   ccc72   LIKE ccc_file.ccc72,
                   ccc51   LIKE ccc_file.ccc51,  #MOD-D20002
                   ccc52   LIKE ccc_file.ccc52,  #MOD-D20002
                   ccc93   LIKE ccc_file.ccc93,  #No.MOD-D70107
                   ccc23   LIKE ccc_file.ccc23,  #No.MOD-D70116
                   ccc91   LIKE ccc_file.ccc91,
                   ccc92   LIKE ccc_file.ccc92,
                   ima39   LIKE ima_file.ima39,
                   aag02   LIKE aag_file.aag02,
                   ccc04   LIKE ccc_file.ccc04	
                  END RECORD,
#cy--add--str--
       g_ccc_1     DYNAMIC ARRAY OF RECORD
                   azf01_1   LIKE azf_file.azf01,  #cy add
                   azf03_1   LIKE azf_file.azf03,
                   ccc01_1   LIKE ccc_file.ccc01,  #cy add
                   ima02_1   LIKE ima_file.ima02,  #cy add
                   ima021_1  LIKE ima_file.ima021,  #cy add
                   ima25_1   LIKE ima_file.ima25,
                   ccc11_1   LIKE ccc_file.ccc11,  #cy add
                   ccc12_1   LIKE ccc_file.ccc12, #cy add
                   s1        LIKE ccc_file.ccc21,
                   s2        LIKE ccc_file.ccc22,
                   s3        LIKE ccc_file.ccc31,
                   s4        LIKE ccc_file.ccc32,
                   ccc91_1   LIKE ccc_file.ccc91,
                   ccc92_1   LIKE ccc_file.ccc92,
                   ima39_1   LIKE ima_file.ima39,
                   aag02_1   LIKE aag_file.aag02,
                   azf01_2   LIKE azf_file.azf01,  #cy add
                   azf03_2   LIKE azf_file.azf03,
                   aah04     LIKE aah_file.aah04,   #FUN-D60123 
                   aah04_ccc92 LIKE aah_file.aah04  #FUN-D60123
                  END RECORD,
#cy--add--end--       
       pay_sw     LIKE type_file.num5,         # No.FUN-690028 SMALLINT
       g_wc,g_sql STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN
       g_rec_b    LIKE type_file.num5, 	       #單身筆數  #No.FUN-690028 SMALLINT
       g_rec_b2   LIKE type_file.num5, 	       #單身筆數  #cy add
       g_cnt      LIKE type_file.num10         #No.FUN-690028 INTEGER
DEFINE g_msg      LIKE type_file.chr1000       #No.FUN-A320028
DEFINE l_ac       LIKE type_file.num5          #No.FUN-A320028 
DEFINE l_ac1      LIKE type_file.num5          #cy add
DEFINE g_filter_wc  STRING                     #cy add 
DEFINE g_flag         LIKE type_file.chr1    #FUN-C80102 
DEFINE g_action_flag  LIKE type_file.chr100  #FUN-C80102 
DEFINE g_comb         ui.ComboBox            #FUN-C80102 
DEFINE g_cmd          LIKE type_file.chr1000 #FUN-C80102
DEFINE g_bookno       LIKE aah_file.aah00     #帳別  #FUN-D60123
#FUN-C80102--add--str--
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE   w    ui.Window
#FUN-C80102--add--end--
 
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
   LET pay_sw    = 1

   OPEN WINDOW q460_w WITH FORM "axc/42f/axcq460"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
#   FOR g_cnt = 8 TO 17 DISPLAY '' AT g_cnt,1 END FOR

   INITIALIZE tm.* TO NULL
   SELECT * INTO g_ccz.* FROM ccz_file
   LET tm.ccz01 = g_ccz.ccz01
   LET tm.ccz02 = g_ccz.ccz02
   LET tm.a = '1'
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF   #FUN-D60123
   CALL q460_table()
   CALL q460_q()
   
#cy--add--end--   
   CALL q460_menu()
   DROP TABLE axcq460_tmp;
   CLOSE WINDOW q460_w               #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q460_cs()
   DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   l_wc        STRING                #MOD-B10024

   CLEAR FORM #清除畫面
   CALL g_ccc.clear()
   CALL cl_opmsg('q')
   LET g_filter_wc = ''

   DISPLAY BY NAME tm.ccz01,tm.ccz02,tm.a
   DIALOG ATTRIBUTES(UNBUFFERED)  

   INPUT BY NAME tm.ccz01,tm.ccz02,tm.a ATTRIBUTE (WITHOUT DEFAULTS=TRUE) 

      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)  #cy add 
         
      AFTER FIELD a
         IF cl_null(tm.a) THEN 
            NEXT FIELD a
         END IF 

      # AFTER INPUT 
       
   END INPUT

   CONSTRUCT tm.wc ON azf01,ccc01,ima39,ccc04
                FROM s_ccc[1].azf01,s_ccc[1].ccc01,s_ccc[1].ima39,s_ccc[1].ccc04
                
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

   END CONSTRUCT
   
      AFTER DIALOG
          IF tm.a = '1' THEN 
            #CALL cl_set_comp_visible("azf01_1,azf03_1",FALSE)                    #FUN-D60123
             CALL cl_set_comp_visible("azf01_1,azf03_1,aah04,aah04_ccc92",FALSE)  #FUN-D60123
          END IF 
          IF tm.a = '2' THEN  
            #CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima25_1,ima39_1,aag02_1,azf01_2,azf03_2",FALSE) #FUN-D60123
             CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima25_1,ima39_1,aag02_1,azf01_2,azf03_2,aah04,aah04_ccc92",FALSE)  #FUN-D60123
          END IF 
          IF tm.a = '3' THEN 
             CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima25_1,azf01_1,azf03_1,azf01_2,azf03_2",FALSE)
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0  
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #cy add
      EXIT PROGRAM                                     #cy add
   END IF          

   CALL q460()  
   CALL q460_t()  

END FUNCTION

#cy--add--str--
FUNCTION q460()
   DELETE FROM axcq460_tmp
   IF cl_null(tm.wc) THEN LET tm.wc = "1=1" END IF 
   IF cl_null(g_wc) THEN LET g_wc = "1=1" END IF 
   CALL q460_get_tmp(tm.wc,g_wc)
END FUNCTION

FUNCTION q460_table()

#140425 mark beg------------
#      CREATE TEMP TABLE axcq460_tmp(
#                   azf01   LIKE azf_file.azf01,  
#                   azf03   LIKE azf_file.azf03,
#                   ccc01   LIKE ccc_file.ccc01,  
#                   ima02   LIKE ima_file.ima02,  
#                   ima021  LIKE ima_file.ima021,  
#                   ima25   LIKE ima_file.ima25,
#                   ccc11   LIKE ccc_file.ccc11,  
#                   ccc12   LIKE ccc_file.ccc12, 
#                   ccc211  LIKE ccc_file.ccc211, 
#                   ccc221  LIKE ccc_file.ccc221,
#                   ccc212  LIKE ccc_file.ccc212,
#                   ccc222  LIKE ccc_file.ccc222,
#                   ccc213  LIKE ccc_file.ccc213, 
#                   ccc223  LIKE ccc_file.ccc223,
#                   ccc27   LIKE ccc_file.ccc27, #140425
#                   ccc28   LIKE ccc_file.ccc28, #140425                  
#                   ccc214  LIKE ccc_file.ccc214,
#                   ccc224  LIKE ccc_file.ccc224,
#                   ccc215  LIKE ccc_file.ccc215,
#                   ccc225  LIKE ccc_file.ccc225,
#                   ccc31   LIKE ccc_file.ccc31,
#                   #ccc25   LIKE ccc_file.ccc25,      #No.MOD-D70128 add ccc25 #140425
#                   ccc32   LIKE ccc_file.ccc32,
#                   ccc41   LIKE ccc_file.ccc41,
#                   ccc42   LIKE ccc_file.ccc42,
#                   ccc61   LIKE ccc_file.ccc61,
#                   ccc62   LIKE ccc_file.ccc62,
#                   ccc81   LIKE ccc_file.ccc81,
#                   ccc82   LIKE ccc_file.ccc82,
#                   ccc25   LIKE ccc_file.ccc25,
#                   ccc71   LIKE ccc_file.ccc71,
#                   ccc72   LIKE ccc_file.ccc72,
#                   ccc51   LIKE ccc_file.ccc51,#140425
#                   ccc52   LIKE ccc_file.ccc52,#140425
#                   ccc93   LIKE ccc_file.ccc93,     #No.MOD-D70107 add ccc93 #140425
#                   ccc23   LIKE ccc_file.ccc23,  #140425                 
#                   ccc91   LIKE ccc_file.ccc91,
#                   ccc92   LIKE ccc_file.ccc92,
#                   ima39   LIKE ima_file.ima39,
#                   aag02   LIKE aag_file.aag02,
#                   ccc04   LIKE ccc_file.ccc04,
#                   ccc21   LIKE ccc_file.ccc21,
#                   ccc22   LIKE ccc_file.ccc22);
#                   #ccc27   LIKE ccc_file.ccc27,#140425
#                   #ccc28   LIKE ccc_file.ccc28,#140425
#                   #ccc51   LIKE ccc_file.ccc51,#140425
#                   #ccc52   LIKE ccc_file.ccc52,#140425
#                   #ccc93   LIKE ccc_file.ccc93,     #No.MOD-D70107 add ccc93 #140425
#                   #ccc23   LIKE ccc_file.ccc23)     #No.MOD-D70116 add ccc23 #140425
#140425 mark end-------------
#140425 add beg-------------
      CREATE TEMP TABLE axcq460_tmp(
                   azf01   LIKE azf_file.azf01,  
                   azf03   LIKE azf_file.azf03,
                   ccc01   LIKE ccc_file.ccc01,  
                   ima02   LIKE ima_file.ima02,  
                   ima021  LIKE ima_file.ima021,  
                   ima25   LIKE ima_file.ima25,
                   ccc11   LIKE ccc_file.ccc11,  
                   ccc12   LIKE ccc_file.ccc12, 
                   ccc211  LIKE ccc_file.ccc211, 
                   ccc221  LIKE ccc_file.ccc221,
                   ccc212  LIKE ccc_file.ccc212,
                   ccc222  LIKE ccc_file.ccc222,
                   ccc213  LIKE ccc_file.ccc213, 
                   ccc223  LIKE ccc_file.ccc223,
                   ccc27   LIKE ccc_file.ccc27, 
                   ccc28   LIKE ccc_file.ccc28,                  
                   ccc214  LIKE ccc_file.ccc214,
                   ccc224  LIKE ccc_file.ccc224,
                   ccc215  LIKE ccc_file.ccc215,
                   ccc225  LIKE ccc_file.ccc225,
                   ccc31   LIKE ccc_file.ccc31,
                   ccc32   LIKE ccc_file.ccc32,
                   ccc41   LIKE ccc_file.ccc41,
                   ccc42   LIKE ccc_file.ccc42,
                   ccc61   LIKE ccc_file.ccc61,
                   ccc62   LIKE ccc_file.ccc62,
                   ccc81   LIKE ccc_file.ccc81,
                   ccc82   LIKE ccc_file.ccc82,
                   ccc25   LIKE ccc_file.ccc25,
                   ccc71   LIKE ccc_file.ccc71,
                   ccc72   LIKE ccc_file.ccc72,
                   ccc51   LIKE ccc_file.ccc51,
                   ccc52   LIKE ccc_file.ccc52,
                   ccc93   LIKE ccc_file.ccc93,
                   ccc23   LIKE ccc_file.ccc23,                
                   ccc91   LIKE ccc_file.ccc91,
                   ccc92   LIKE ccc_file.ccc92,
                   ima39   LIKE ima_file.ima39,
                   aag02   LIKE aag_file.aag02,
                   ccc04   LIKE ccc_file.ccc04,
                   ccc21   LIKE ccc_file.ccc21,
                   ccc22   LIKE ccc_file.ccc22);
#140425 add end-------------

                      
END FUNCTION


FUNCTION q460_get_tmp(p_wc1,p_wc2)
DEFINE l_sql,l_sql1 LIKE type_file.chr1000 
DEFINE
    p_wc1           LIKE type_file.chr1000 
DEFINE
    p_wc2           LIKE type_file.chr1000 
DEFINE l_apk03      LIKE apk_file.apk03
    LET l_sql = "SELECT azf01,azf03,ccc01,ima02,ima021,ima25,ccc11,ccc12,ccc211,ccc221,ccc212,",
               #"       ccc222,ccc213,ccc223,ccc214,ccc224,ccc215,ccc225,ccc31,ccc32,ccc41,ccc42,",                         #MOD-D20002 mark
               # "       ccc222,ccc213,ccc223,ccc214,ccc224,ccc215,ccc225,ccc31,ccc25,ccc32+ccc26,ccc41,ccc42,", #MOD-D20002   No.MOD-D70128 add ccc25
                "       ccc222,ccc213,ccc223,ccc27,ccc28,ccc214,ccc224,ccc215,ccc225,ccc31,ccc32+ccc26,ccc41,ccc42,",  #140425 add ccc27,ccc28 ,rm ccc25
               # "       ccc61,ccc62,ccc81,ccc82,ccc25,ccc71,ccc72,ccc91,ccc92,'' ima39,'' aag02,ccc04,", #140425 add ccc25 #mark
               #"       ccc21,ccc22,ccc27,ccc28,ccc51,ccc52 ",                                                              #MOD-D20002 mark
               # "       ccc21,ccc22,ccc27,ccc28,ccc51,ccc52,ccc93,ccc23 ",   #No.MOD-D70107 add ccc93    No.MOD-D70116 add ccc23    #140425 mark                                              #MOD-D20002
               "       ccc61,ccc62,ccc81,ccc82,ccc25,ccc71,ccc72,ccc51,ccc52,ccc93,ccc23,ccc91,ccc92,'' ima39,'' aag02,ccc04,ccc21,ccc22 ",  #140425 add
               
                "  FROM ccc_file LEFT OUTER JOIN ima_file ON ccc01 = ima01  ",
                                              " LEFT OUTER JOIN azf_file ON azf01 = ima12 AND azf02 ='G'  ",   #No.MOD-D20175  add azf02   
#No.MOD-D50052 --begin
                " WHERE ccc02 = '",tm.ccz01,"' AND ccc03 = '",tm.ccz02,"' AND (",p_wc1 CLIPPED,") "
#                " WHERE ccc02 = '",tm.ccz01,"' AND ccc03 = '",tm.ccz02,"' AND (",p_wc1 CLIPPED,") ",
#                "   AND (ccc11 <> 0 OR ccc12 <> 0 OR ccc21+ccc27 <> 0 OR ccc22+ccc28 <> 0 OR ccc31+ccc41+ccc51+ccc61+ccc71+ccc81 <> 0 ",
#                       " OR ccc32+ccc42+ccc52+ccc62+ccc72+ccc82 <> 0 OR ccc91 <> 0 OR ccc92 <> 0) "
#No.MOD-D50052 --end

   LET l_sql = l_sql CLIPPED," ORDER BY azf01,ccc01 "

   LET l_sql1 = " INSERT INTO axcq460_tmp ",
                 l_sql CLIPPED
   PREPARE q460_p FROM l_sql1
   EXECUTE q460_p
   
   IF g_ccz.ccz07 = '1' THEN 
      LET l_sql1 = "MERGE INTO axcq460_tmp o",
                   "           USING (SELECT ima01,ima39 FROM ima_file) a",
                   "         ON (o.ccc01 = a.ima01) ",
                   " WHEN MATCHED ",
                   " THEN ",
                   "    UPDATE ",
                   "       SET o.ima39 = a.ima39, ",
                   "           o.aag02 = (SELECT DISTINCT aag02 FROM aag_file WHERE aag01 = a.ima39 AND rownum <=1)"
   END IF

   IF g_ccz.ccz07 = '2' THEN 
      LET l_sql1 = "MERGE INTO axcq460_tmp o",
                   "           USING (SELECT ima01,imz39 FROM ima_file,imz_file",
                   "           WHERE imz01 = ima06 ) a",
                   "         ON (o.ccc01 = a.ima01) ",
                   " WHEN MATCHED ",
                   " THEN ",
                   "    UPDATE ",
                   "       SET o.ima39 = a.imz39,",
                   "           o.aag02 = (SELECT DISTINCT aag02 FROM aag_file WHERE aag01 = a.imz39 AND rownum <=1) "
   END IF
   IF g_ccz.ccz07 MATCHES'[12]' THEN
      PREPARE q460_p1 FROM l_sql1
      EXECUTE q460_p1
   END IF 
END FUNCTION

FUNCTION q460_t()

   CLEAR FORM
   CALL g_ccc.clear()
   CALL g_ccc_excel.clear()
   CALL q460_show()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q460_show()
   DISPLAY tm.ccz01 TO ccz01
   DISPLAY tm.ccz02 TO ccz02
   DISPLAY tm.a TO a 

   CALL q460_b_fill_1()
   CALL q460_b_fill_2()

   IF cl_null(tm.a)  THEN   
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
   
   CALL q460_set_visible()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q460_set_visible()
   CALL cl_set_comp_visible("azf01_1,azf03_1,ccc01_1,ima02_1,ima021_1,ima25_1,ccc11_1,ccc12_1,s1,s2,s3,s4,ccc91_1,ccc92_1",TRUE)
   CALL cl_set_comp_visible("ima39_1,aag02_1,azf01_2,azf03_2,aah04,aah04_ccc92",TRUE)   #FUN-D60123 add aah04,aah04_ccc92
   CASE tm.a
     WHEN "1" CALL cl_set_comp_visible("azf01_1,azf03_1,aah04,aah04_ccc92",FALSE)  #FUN-D60123 add aah04,aah04_ccc92
     WHEN "2" CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima25_1,ima39_1,aag02_1,azf01_2,azf03_2,aah04,aah04_ccc92",FALSE) #FUN-D60123 add aah04,aah04_ccc92
     WHEN "3" CALL cl_set_comp_visible("azf01_1,azf03_1,ccc01_1,ima02_1,ima021_1,ima25_1,azf01_2,azf03_2",FALSE)
   END CASE
END FUNCTION

FUNCTION q460_b_fill_1()

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   LET g_sql = "SELECT azf01,azf03,ccc01,ima02,ima021,ima25,ccc11,ccc12,ccc211,ccc221,ccc212,",
               "       ccc222,ccc213,ccc223,ccc27,ccc28,ccc214,ccc224,ccc215,ccc225,ccc31,ccc32,ccc41,ccc42,",    #No.MOD-D70128 add ccc27,ccc28
               "       ccc61,ccc62,ccc81,ccc82,ccc25,ccc71,ccc72,ccc51,ccc52,ccc93,ccc23,ccc91,ccc92,ima39,aag02,ccc04 ",   #MOD-D20002 add ccc51,ccc52  No.MOD-D70107 add ccc93   No.MOD-D70116 add ccc23  #No.MOD-D70128 add ccc25
               " FROM axcq460_tmp ",
               " WHERE ",g_filter_wc CLIPPED,  
               " ORDER BY azf01,ccc01 "

   PREPARE axcq460_pb1 FROM g_sql
   DECLARE ccc_curs1  CURSOR FOR axcq460_pb1        #CURSOR

   CALL g_ccc.clear()
   CALL g_ccc_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH ccc_curs1 INTO g_ccc_excel[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach_ccc:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF g_cnt <= g_max_rec THEN
        LET g_ccc[g_cnt].* = g_ccc_excel[g_cnt].*
     END IF
     LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_ccc.deleteElement(g_cnt)
   END IF
   CALL g_ccc_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q460_b_fill_2()

   CALL g_ccc_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
  
   CALL q460_get_sum()
 
END FUNCTION

FUNCTION q460_get_sum()
DEFINE l_tot1    LIKE ccc_file.ccc31
DEFINE l_tot2    LIKE ccc_file.ccc31
DEFINE l_tot3    LIKE ccc_file.ccc31
DEFINE l_tot4    LIKE ccc_file.ccc31
DEFINE l_tot5    LIKE ccc_file.ccc31
DEFINE l_tot6    LIKE ccc_file.ccc31
DEFINE l_tot7    LIKE ccc_file.ccc31
DEFINE l_tot8    LIKE ccc_file.ccc31
DEFINE l_year   LIKE type_file.num5
DEFINE l_month  LIKE type_file.num5
DEFINE l_yy     STRING
DEFINE l_mm     STRING

   LET l_tot1 = 0 
   LET l_tot2 = 0 
   LET l_tot3 = 0 
   LET l_tot4 = 0 
   LET l_tot5 = 0 
   LET l_tot6 = 0 
   LET l_tot7 = 0 
   LET l_tot8 = 0 

   CASE tm.a
      WHEN "1"
        LET g_sql = "SELECT '','',ccc01,ima02,ima021,ima25,SUM(ccc11),SUM(ccc12),SUM(ccc21+ccc27),",
                    "       SUM(ccc22+ccc28),SUM(ccc31+ccc41+ccc51+ccc61+ccc71+ccc81+ccc25),",         #No.MOD-D70128 add ccc25
                    "       SUM(ccc32+ccc42+ccc52+ccc62+ccc72+ccc82+ccc93),SUM(ccc91),SUM(ccc92),ima39,aag02,azf01,azf03, ",   #No.MOD-D70107 add ccc93
                    "       '','' ",  #FUN-D60123 
                    "  FROM axcq460_tmp WHERE ",g_filter_wc CLIPPED 
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY ccc01,ima02,ima021,ima25,ima39,aag02,azf01,azf03 ",
                    " ORDER BY ccc01,ima02,ima021,ima25,ima39,aag02,azf01,azf03 "
        PREPARE q460_pb1 FROM g_sql
        DECLARE q460_curs1 CURSOR FOR q460_pb1       
        FOREACH q460_curs1 INTO g_ccc_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccc_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
           LET g_cnt = g_cnt + 1

        END FOREACH 

      WHEN "2"
         LET g_sql = "SELECT azf01,azf03,'','','','',SUM(ccc11),SUM(ccc12),SUM(ccc21+ccc27),",
                     "       SUM(ccc22+ccc28),SUM(ccc31+ccc41+ccc51+ccc61+ccc71+ccc81+ccc25),",         #No.MOD-D70128 add ccc25
                     "       SUM(ccc32+ccc42+ccc52+ccc62+ccc72+ccc82+ccc93),SUM(ccc91),SUM(ccc92),'','','','', ",      #No.MOD-D70107 add ccc93
                     "       '','' ",  #FUN-D60123 
                     "  FROM axcq460_tmp WHERE ",g_filter_wc CLIPPED 
        LET g_sql = g_sql CLIPPED,
                    " GROUP BY azf01,azf03 ",
                    " ORDER BY azf01,azf03 "
        PREPARE q460_pb2 FROM g_sql
        DECLARE q460_curs2 CURSOR FOR q460_pb2       
        FOREACH q460_curs2 INTO g_ccc_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccc_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF        
                         
           LET g_cnt = g_cnt + 1

        END FOREACH 

     WHEN "3"
        LET g_sql = "SELECT '','','','','','',SUM(ccc11),SUM(ccc12),SUM(ccc21+ccc27),",
                       "       SUM(ccc22+ccc28),SUM(ccc31+ccc41+ccc51+ccc61+ccc71+ccc81+ccc25),",         #No.MOD-D70128 add ccc25
                       "       SUM(ccc32+ccc42+ccc52+ccc62+ccc72+ccc82+ccc93),SUM(ccc91),SUM(ccc92),ima39,aag02,'','', ",      #No.MOD-D70107 add ccc93
                       "       '','' ",  #FUN-D60123 
                       "  FROM axcq460_tmp WHERE ",g_filter_wc CLIPPED 
        LET g_sql = g_sql CLIPPED,
                       " GROUP BY ima39,aag02 ",
                       " ORDER BY ima39,aag02 "
        PREPARE q460_pb3 FROM g_sql
        DECLARE q460_curs3 CURSOR FOR q460_pb3       
        FOREACH q460_curs3 INTO g_ccc_1[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach_ccc_1:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF    
           CALL q460_get_aah(g_ccc_1[g_cnt].ima39_1) RETURNING g_ccc_1[g_cnt].aah04
           IF g_ccc_1[g_cnt].aah04 < 0 THEN LET g_ccc_1[g_cnt].aah04 = g_ccc_1[g_cnt].aah04 * (-1) END IF
           LET g_ccc_1[g_cnt].aah04_ccc92 = g_ccc_1[g_cnt].aah04 - g_ccc_1[g_cnt].ccc92_1

           LET g_cnt = g_cnt + 1

        END FOREACH 

    END CASE

    LET g_sql = "SELECT SUM(ccc11),SUM(ccc12),SUM(ccc21+ccc27),",
                 "      SUM(ccc22+ccc28),SUM(ccc31+ccc41+ccc51+ccc61+ccc71+ccc81+ccc25),",         #No.MOD-D70128 add ccc25
                 "      SUM(ccc32+ccc42+ccc52+ccc62+ccc72+ccc82+ccc93),SUM(ccc91),SUM(ccc92)",      #No.MOD-D70107 add ccc93
                 " FROM axcq460_tmp WHERE ",g_filter_wc CLIPPED 
                 
    PREPARE sum_pre FROM g_sql
    EXECUTE sum_pre INTO l_tot1,l_tot2,l_tot3,l_tot4,
                         l_tot5,l_tot6,l_tot7,l_tot8
                         
    DISPLAY l_tot1 TO FORMONLY.sum1_1
    DISPLAY l_tot2 TO FORMONLY.sum2_1
    DISPLAY l_tot3 TO FORMONLY.sum3_1
    DISPLAY l_tot4 TO FORMONLY.sum4_1
    DISPLAY l_tot5 TO FORMONLY.sum5_1
    DISPLAY l_tot6 TO FORMONLY.sum6_1
    DISPLAY l_tot7 TO FORMONLY.sum7_1
    DISPLAY l_tot8 TO FORMONLY.sum8_1
    DISPLAY l_tot1 TO FORMONLY.sum1
    DISPLAY l_tot2 TO FORMONLY.sum2
    DISPLAY l_tot3 TO FORMONLY.sum3
    DISPLAY l_tot4 TO FORMONLY.sum4
    DISPLAY l_tot5 TO FORMONLY.sum5
    DISPLAY l_tot6 TO FORMONLY.sum6
    DISPLAY l_tot7 TO FORMONLY.sum7
    DISPLAY l_tot8 TO FORMONLY.sum8       


    DISPLAY ARRAY g_ccc_1 TO s_ccc_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
      END DISPLAY  
      CALL g_ccc_1.deleteElement(g_cnt)
      LET g_rec_b2 = g_cnt - 1

    DISPLAY g_rec_b2 TO FORMONLY.cnt1
END FUNCTION

FUNCTION q460_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CALL g_ccc.clear()
   CALL g_ccc_1.clear()
   #CALL cl_set_comp_visible("ccc13,ccc31f,ccc32f,ccc60f,ccc61f,ccc65f,ccc34f,ccc35f,amt1,ccclegal",TRUE)
   DISPLAY BY NAME tm.ccz01,tm.ccz02,tm.a
   CONSTRUCT l_wc ON azf01,ccc01,ima39,ccc04
                FROM s_ccc[1].azf01,s_ccc[1].ccc01,s_ccc[1].ima39,s_ccc[1].ccc04
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
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39
               NEXT FIELD ima39                  
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
FUNCTION q460_menu()
 
   WHILE TRUE
#FUN-C80102--add--str-- 
      IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page1" THEN  
            CALL q460_bp("G")
         END IF
         IF g_action_flag = "page2" THEN  
            CALL q460_bp2()
         END IF
      END IF 
#FUN-C80102--add--end--
#     CALL q460_bp("G")  #cy mark
      CASE g_action_choice
#FUN-C80102--add--str--
         WHEN "page1"
               CALL q460_bp("G")
         
         WHEN "page2"
               CALL q460_bp2()
  
         WHEN "data_filter"
               IF cl_chk_act_auth() THEN
                  CALL q460_filter_askkey()
                  CALL q460_show()
               END IF            

         WHEN "revert_filter"
              IF cl_chk_act_auth() THEN
                 LET g_filter_wc = ''
                 CALL cl_set_act_visible("revert_filter",FALSE) 
                 CALL q460_show() 
              END IF
#FUN-C80102--add--end--
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q460_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " "  #FUN-C80102 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " "  #FUN-C80102 
#No.FUN-A30028 --begin  
         WHEN "qry_ccc" 
            IF cl_chk_act_auth() THEN    
               LET l_ac = ARR_CURR()    
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN       
                  CALL q460_ccc_q() 
                  CALL cl_cmdrun(g_msg)     
               END IF                      
            END IF                        
            LET g_action_choice = " "  #FUN-C80102 
#No.FUN-A30028 --end
         WHEN "ruku_detail"
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()    
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN                
                  CALL q4601()
               END IF 
            END IF
            LET g_action_choice = " "
         WHEN "chuku_detail"
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()    
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN                
                  CALL q4602()
               END IF 
            END IF
            LET g_action_choice = " "           
         #FUN-4B0009
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page1" THEN  #FUN-C80102 add
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page1")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_ccc_excel),'','')
                END IF
             END IF  #FUN-C80102
#FUN-C80120--add--str--
             IF g_action_flag = "page2" THEN
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page2")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_ccc_1),'','')
                END IF
             END IF
#FUN-C80120--add--end--
            LET g_action_choice = " "  #FUN-C80102 
         #--
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
 
FUNCTION q460_q()
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL cl_set_comp_visible("ccc01_1,ima02_1,ima021_1,ima25_1,ima39_1,aag02_1,azf01_1,azf03_1,azf01_2,azf03_2",TRUE)
    CALL cl_set_comp_visible("page2", FALSE)
    CALL ui.interface.refresh()
    CALL cl_set_comp_visible("page2", TRUE)
    CALL g_ccc.clear()
    CALL g_ccc_excel.clear()
    CALL g_ccc_1.clear()
    LET g_action_choice = " "
    CALL q460_cs()
    

END FUNCTION
 
FUNCTION q460_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_flag = 'page1'  #FUN-C80102 
  
 
   IF g_action_choice = "page1"  AND g_flag != '1' THEN
      CALL q460_b_fill_1()
   END IF
   LET g_action_choice = " "
   LET g_flag = ' '   #FUN-C80102
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY BY NAME tm.ccz01,tm.ccz02,tm.a

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.ccz01,tm.ccz02,tm.a FROM ccz01,ccz02,a ATTRIBUTE(WITHOUT DEFAULTS) 
           
         ON CHANGE a 
            IF NOT cl_null(tm.a)  THEN 
               CALL q460_b_fill_2()
               CALL q460_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q460_b_fill_1()
               CALL g_ccc_1.clear()
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.sum1_1
               DISPLAY 0  TO FORMONLY.sum2_1
               DISPLAY 0  TO FORMONLY.sum3_1
               DISPLAY 0  TO FORMONLY.sum4_1
               DISPLAY 0  TO FORMONLY.sum5_1
               DISPLAY 0  TO FORMONLY.sum6_1
               DISPLAY 0  TO FORMONLY.sum7_1
               DISPLAY 0  TO FORMONLY.sum8_1
            END IF
            DISPLAY BY NAME tm.a
            EXIT DIALOG 

#          ON CHANGE a
#             CALL q460_b_fill_2()
#             CALL q460_set_visible()
#             CALL cl_set_comp_visible("page1", FALSE)
#             CALL ui.interface.refresh()
#             CALL cl_set_comp_visible("page1", TRUE)
#             LET g_action_choice = "page2"

      END INPUT 
 
      DISPLAY ARRAY g_ccc TO s_ccc.* ATTRIBUTE(COUNT=g_rec_b)   
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont() 
      END DISPLAY 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################

      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q460_b_fill_1()
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
         
      #add by zhangym 121106 begin-----
      ON ACTION ruku_detail
         LET g_action_choice="ruku_detail"
         EXIT DIALOG 

      ON ACTION chuku_detail
         LET g_action_choice="chuku_detail"
         EXIT DIALOG 
      #add by zhangym 121106 end-----             

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

      ON ACTION qry_ccc
         LET g_action_choice = 'qry_ccc'
         EXIT DIALOG  

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 

   END DIALOG  
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#cy--add--str--
FUNCTION q460_bp2()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.ccz01,tm.ccz02,tm.a TO ccz01,ccz02,a
   LET g_flag = ' '
   LET g_action_flag = 'page2' 
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.ccz01,tm.ccz02,tm.a FROM ccz01,ccz02,a ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN
               CALL q460_b_fill_2()
               CALL q460_set_visible()
               LET g_action_choice = "page2"
            ELSE
               CALL q460_b_fill_1()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page1"
               CALL g_ccc_1.clear()  
               DISPLAY 0  TO FORMONLY.cnt1
               DISPLAY 0  TO FORMONLY.sum1_1
               DISPLAY 0  TO FORMONLY.sum2_1
               DISPLAY 0  TO FORMONLY.sum3_1
               DISPLAY 0  TO FORMONLY.sum4_1
               DISPLAY 0  TO FORMONLY.sum5_1
               DISPLAY 0  TO FORMONLY.sum6_1
               DISPLAY 0  TO FORMONLY.sum7_1
               DISPLAY 0  TO FORMONLY.sum8_1
            END IF
            DISPLAY tm.a TO a 
            EXIT DIALOG

      END INPUT

      DISPLAY ARRAY g_ccc_1 TO s_ccc_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
         END DISPLAY 

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG 

      ON ACTION refresh_detail
         CALL q460_b_fill_1()
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
            CALL q460_detail_fill(l_ac1)
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

FUNCTION q460_detail_fill(p_ac)
DEFINE p_ac   LIKE type_file.num5
DEFINE l_tot11   LIKE ccc_file.ccc31
DEFINE l_tot21   LIKE ccc_file.ccc31
DEFINE l_tot31   LIKE ccc_file.ccc31
DEFINE l_tot41   LIKE ccc_file.ccc31
DEFINE l_tot51   LIKE ccc_file.ccc31
DEFINE l_tot61   LIKE ccc_file.ccc31
DEFINE l_tot71   LIKE ccc_file.ccc31
DEFINE l_tot81   LIKE ccc_file.ccc31
DEFINE l_tot91   LIKE ccc_file.ccc31
DEFINE l_yymm    STRING
DEFINE l_yy      STRING
DEFINE l_mm1     STRING
DEFINE l_mm2     STRING
DEFINE l_ccc21   LIKE ccc_file.ccc21 #140425
DEFINE l_ccc22   LIKE ccc_file.ccc22 #140425

   LET l_tot11 = 0
   LET l_tot21 = 0
   LET l_tot31 = 0
   LET l_tot41 = 0
   LET l_tot51 = 0
   LET l_tot61 = 0
   LET l_tot71 = 0 
   LET l_tot81 = 0
   LET l_tot91 = 0 
   
   CASE tm.a
     WHEN "1"
        LET g_sql = "SELECT * FROM axcq460_tmp ",
                    " WHERE ccc01 = '",g_ccc_1[p_ac].ccc01_1,"' ",
                    " ORDER BY ccc01 "
        PREPARE axcq460_pb_detail1 FROM g_sql
        DECLARE ccc_curs_detail1  CURSOR FOR axcq460_pb_detail1        #CURSOR
        CALL g_ccc.clear()
        LET g_cnt = 1
        LET g_rec_b = 0       

        FOREACH ccc_curs_detail1 INTO g_ccc[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH   

      WHEN "2"
        LET g_sql = "SELECT * FROM axcq460_tmp ", 
                    " WHERE azf01 = '",g_ccc_1[p_ac].azf01_1,"' ",
                    " ORDER BY azf01 "   
        PREPARE axcq460_pb_detail2 FROM g_sql
        DECLARE ccc_curs_detail2  CURSOR FOR axcq460_pb_detail2        #CURSOR
        CALL g_ccc.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH ccc_curs_detail2 INTO g_ccc[g_cnt].*   
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH   
  
      WHEN "3"

           LET g_sql = "SELECT * FROM axcq460_tmp ", 
                       " WHERE ima39 = '",g_ccc_1[p_ac].ima39_1,"' ",
                       " ORDER BY ima39 " 
	 
           PREPARE axcq460_pb_detail3 FROM g_sql
           DECLARE ccc_curs_detail3  CURSOR FOR axcq460_pb_detail3        #CURSOR
        	 
        CALL g_ccc.clear()
        LET g_cnt = 1
        LET g_rec_b = 0

        FOREACH ccc_curs_detail3 INTO g_ccc[g_cnt].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET g_cnt = g_cnt + 1
        END FOREACH
   END CASE

   CALL g_ccc.deleteElement(g_cnt)
   LET g_rec_b = g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q460_ccc_q()

   LET g_msg ='axct100'," '' '' '",g_ccc[l_ac].ccc01 CLIPPED,"' 'query' '",tm.ccz01,"' '",tm.ccz02,"' "

END FUNCTION

FUNCTION q4601()
DEFINE diff_flag           LIKE type_file.chr1 

   LET g_msg =''
   OPEN WINDOW t3101_w WITH FORM "axc/42f/axcq4601"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axcq4601")

   INPUT BY NAME diff_flag
      AFTER FIELD diff_flag
         IF diff_flag NOT MATCHES "[12345]" THEN NEXT FIELD diff_flag END IF

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
   IF INT_FLAG THEN LET INT_FLAG=0 LET diff_flag = '5' END IF
   CLOSE WINDOW t3101_w

   IF diff_flag = '1' THEN
#     LET g_msg = "axcq700 '' '' '' 'N' '' '' 'ima01 = '",g_ccc[l_ac].ccc01,"' ' '",tm.ccz01,"' '",tm.ccz02,"' '1' "
      LET g_msg = "axcq700 '' '' '' 'N' '' '' 'ima01 = '",g_ccc[l_ac].ccc01,"' ' '",tm.ccz01,"' '",tm.ccz02,"' '' ",
                        " '' '' '' '' '' '' '1' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' '' '' "
      CALL cl_cmdrun(g_msg) 
   END IF 
   IF diff_flag = '2' THEN
#     LET g_msg = "axcq700 '' '' '' 'N' '' '' 'ima01 = '",g_ccc[l_ac].ccc01,"' ' '",tm.ccz01,"' '",tm.ccz02,"' '2' "
      LET g_msg = "axcq700 '' '' '' 'N' '' '' 'ima01 = '",g_ccc[l_ac].ccc01,"' ' '",tm.ccz01,"' '",tm.ccz02,"' '' ",
                        " '' '' '' '' '' '' '2' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' '' '' "
      CALL cl_cmdrun(g_msg) 
   END IF 
   IF diff_flag = '3' THEN
#     LET g_msg = "axcq777 '",tm.ccz01,"' '",tm.ccz02,"' '1' 'Y' 'N' "
      LET g_msg = "axcq777 '",tm.ccz01,"' '",tm.ccz02,"' '1' '' 'N' "
      CALL cl_cmdrun(g_msg) 
   END IF 
   IF diff_flag = '4' THEN
      LET g_msg = "axcq775 '",tm.ccz01,"' '",tm.ccz02,"' '1' '' 'N' '1' "          #FUN-D10022 mod 2 to 1
      CALL cl_cmdrun(g_msg) 
   END IF
   IF diff_flag = '5' THEN
      LET g_msg = "axcq003 '",tm.ccz01,"' '",tm.ccz02,"'"
      CALL cl_cmdrun(g_msg)      
   END IF         
             
END FUNCTION

FUNCTION q4602()
DEFINE diff_flag           LIKE type_file.chr1 

   LET g_msg =''
   OPEN WINDOW t3102_w WITH FORM "axc/42f/axcq4602"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("axcq4602")

   INPUT BY NAME diff_flag
      AFTER FIELD diff_flag
         IF diff_flag NOT MATCHES "[12345]" THEN NEXT FIELD diff_flag END IF

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
   IF INT_FLAG THEN LET INT_FLAG=0 LET diff_flag = '3' END IF
   CLOSE WINDOW t3102_w

   IF diff_flag = '1' THEN
#     LET g_msg = "axcq776 '",tm.ccz01,"' '",tm.ccz02,"' '1' 'Y' 'N' "
      LET g_msg = "axcq776 '",tm.ccz01,"' '",tm.ccz02,"' '1' '' 'N' "
      CALL cl_cmdrun(g_msg) 
   END IF 
   IF diff_flag = '2' THEN
      LET g_msg = "axcq775 '",tm.ccz01,"' '",tm.ccz02,"' '1' '' 'N' '2' "          #FUN-D10022 mod 3 to 2
      CALL cl_cmdrun(g_msg) 
   END IF 
   IF diff_flag = '3' THEN
      LET g_msg = "axcq778 '",tm.ccz01,"' '",tm.ccz02,"'"
      CALL cl_cmdrun(g_msg)   
    END IF 
   IF diff_flag = '4' THEN
#     LET g_msg = "axcq761 '' '' '' 'N' '' '' 'ima01 = '",g_ccc[l_ac].ccc01,"' ' '",tm.ccz01,"' '",tm.ccz02,"' '1' "
      LET g_msg = "axcq761 '' '' '' 'N' '' '' 'ima01 = '",g_ccc[l_ac].ccc01,"' ' '",tm.ccz01,"' '",tm.ccz02,"' '' ",
                        " '' '' '1' '' '' '' '' '' '' '' ",
                        " '' '' '' '' '' '' '' '' '' "
      CALL cl_cmdrun(g_msg) 
   END IF
   IF diff_flag = '5' THEN
      LET g_msg = "aimq998 '",tm.ccz01,"' '",tm.ccz02,"' '1' '' 'N' "
      CALL cl_cmdrun(g_msg)
   END IF         
             
END FUNCTION

#FUN-D60123--add--str--
FUNCTION q460_get_aah(l_aah01)
DEFINE l_aah01   LIKE  aah_file.aah01
DEFINE qc_aah04  LIKE  aah_file.aah04
DEFINE qc_aah05  LIKE  aah_file.aah05
DEFINE qj_aah04  LIKE  aah_file.aah04
DEFINE qj_aah05  LIKE  aah_file.aah05
DEFINE qm_aah04  LIKE  aah_file.aah04
DEFINE qm_aah05  LIKE  aah_file.aah05
DEFINE l_aah041  LIKE  aah_file.aah04
DEFINE l_aah042  LIKE  aah_file.aah04
DEFINE l_aah051  LIKE  aah_file.aah05
DEFINE l_aah052  LIKE  aah_file.aah05
DEFINE l_sql     STRING
DEFINE l_aah     STRING
DEFINE l_abb     STRING

   LET l_aah = " SELECT SUM(aah04),SUM(aah05) FROM aah_file",
                 "  WHERE aah00 = '",g_bookno,"'",
                 "    AND aah01 = '",l_aah01,"'" ,
                 "    AND aah02 =  ",tm.ccz01
   #期初               
   LET l_sql = l_aah CLIPPED,"  AND aah03 < ",tm.ccz02                           
            
   PREPARE q460_qc1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('q460_qc1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
   DECLARE q460_qc_cs1 CURSOR FOR q460_qc1  

   #期间 
   LET l_sql = l_aah CLIPPED,"  AND aah03 = ",tm.ccz02                           
            
   PREPARE q460_qj1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('q460_qj1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
   DECLARE q460_qj_cs1 CURSOR FOR q460_qj1  

#140226 mark begin----------
#   LET l_abb =   " SELECT SUM(abb07) FROM aba_file,abb_file",
#                 "  WHERE aba00 = abb00 AND aba01 = abb01 ",
#                 "    AND aba00 = '",g_bookno,"'",
#                 "    AND aba03 =  ",tm.ccz01,
#                 "    AND abb03 = '",l_aah01,"'",
#                 "    AND abb06 = ?",   
#                 "    AND aba19 <> 'X' ",  
#                 "    AND aba19 = 'Y' ",  
#                 "    AND abaacti = 'Y' "
#   #期初              
#   LET l_sql = l_abb CLIPPED,"    AND aba04 < ",tm.ccz02  
#   PREPARE q460_qc2 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('q460_qc2',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#   DECLARE q460_qc_cs2 CURSOR FOR q460_qc2  
#
#   #期间              
#   LET l_sql = l_abb CLIPPED,"    AND aba04 = ",tm.ccz02  
#   PREPARE q460_qj2 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('q460_qj2',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#   DECLARE q460_qj_cs2 CURSOR FOR q460_qj2 
#140226 mark end------------

      #期初值
   LET l_aah041 = 0    LET l_aah051 = 0
   LET l_aah042 = 0    LET l_aah052 = 0  
   OPEN q460_qc_cs1 
   FETCH q460_qc_cs1 INTO l_aah041,l_aah051 
   CLOSE q460_qc_cs1
   IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
   IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
#   OPEN q460_qc_cs2  USING '1'
#   FETCH q460_qc_cs2 INTO l_aah042 #140226 mark 
#   CLOSE q460_qc_cs2
   IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
#   OPEN q460_qc_cs2  USING '2'
#   FETCH q460_qc_cs2 INTO l_aah052 #140226 mark 
#   CLOSE q460_qc_cs2
   IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF   
   
   LET qc_aah04 = l_aah041 + l_aah042
   LET qc_aah05 = l_aah051 + l_aah052
   LET qc_aah04 = qc_aah04 - qc_aah05
   LET qc_aah05 = 0
   #期間
   LET l_aah041 = 0    LET l_aah051 = 0
   LET l_aah042 = 0    LET l_aah052 = 0
   OPEN q460_qj_cs1 
   FETCH q460_qj_cs1 INTO l_aah041,l_aah051 
   CLOSE q460_qj_cs1
   IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
   IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF
#   OPEN q460_qj_cs2  USING '1'
#   FETCH q460_qj_cs2 INTO l_aah042 #140226 mark 
#   CLOSE q460_qj_cs2
   IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
#   OPEN q460_qj_cs2  USING '2'
#   FETCH q460_qj_cs2 INTO l_aah052 #140226 mark 
#   CLOSE q460_qj_cs2
   IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF  

   LET qj_aah04 = l_aah041 + l_aah042
   LET qj_aah05 = l_aah051 + l_aah052
  
   
   
   #期末
   LET qm_aah04 = qc_aah04 + qj_aah04
   LET qm_aah05 = qc_aah05 + qj_aah05
   LET qm_aah04 = qm_aah04 - qm_aah05
   LET qm_aah05 = 0


   RETURN qm_aah04
   


END FUNCTION                 
#FUN-D60123--add--end--

#No.FUN-C90076

