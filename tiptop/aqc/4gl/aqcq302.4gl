# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aqcq302.4gl
# Descriptions...: 
# Date & Author..: 2012/10/10 NO.FUN-C90076 By lixh1 
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_qcs DYNAMIC ARRAY OF RECORD 
             qcs03   LIKE qcs_file.qcs03,  #供應廠商
             pmc03   LIKE pmc_file.pmc03,  #供應廠商
             qcs04   LIKE qcs_file.qcs04,  
             qcs01   LIKE qcs_file.qcs01,
             qcs02   LIKE qcs_file.qcs02,  
             qcs05   LIKE qcs_file.qcs05,
             qcs021  LIKE qcs_file.qcs021,
             ima02   LIKE ima_file.ima02,
             ima021  LIKE ima_file.ima021,
             qcs22   LIKE qcs_file.qcs22, 
             qcs091  LIKE qcs_file.qcs091,
             qcs09   LIKE qcs_file.qcs09,
             qcs13   LIKE qcs_file.qcs13,            
             gen02   LIKE gen_file.gen02,     #lixh1
             qct04   LIKE qct_file.qct04,  
             azf03   LIKE azf_file.azf03,  
             qct11   LIKE qct_file.qct11,  
             qct07   LIKE qct_file.qct07,  
             qct08   LIKE qct_file.qct08,  
             qct131  LIKE qct_file.qct131,  
             qct132  LIKE qct_file.qct132   
             END RECORD
DEFINE g_qcs_excel DYNAMIC ARRAY OF RECORD   #導出EXCEL
             qcs03   LIKE qcs_file.qcs03,  #供應廠商
             pmc03   LIKE pmc_file.pmc03,  #供應廠商
             qcs04   LIKE qcs_file.qcs04,  
             qcs01   LIKE qcs_file.qcs01,
             qcs02   LIKE qcs_file.qcs02,  
             qcs05   LIKE qcs_file.qcs05,
             qcs021  LIKE qcs_file.qcs021,
             ima02   LIKE ima_file.ima02,
             ima021  LIKE ima_file.ima021,
             qcs22   LIKE qcs_file.qcs22, 
             qcs091  LIKE qcs_file.qcs091,
             qcs09   LIKE qcs_file.qcs09,
             qcs13   LIKE qcs_file.qcs13,            
             gen02   LIKE gen_file.gen02,     #lixh1
             qct04   LIKE qct_file.qct04,  
             azf03   LIKE azf_file.azf03,  
             qct11   LIKE qct_file.qct11,  
             qct07   LIKE qct_file.qct07,  
             qct08   LIKE qct_file.qct08,  
             qct131  LIKE qct_file.qct131,  
             qct132  LIKE qct_file.qct132   
             END RECORD             
DEFINE g_wc            STRING
DEFINE g_filter_wc     STRING
DEFINE g_rec_b         LIKE type_file.num10
DEFINE g_cnt           LIKE type_file.num10 
DEFINE l_ac            LIKE type_file.num10
                                                                                                                     
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   CALL q302_table()           #lixh121121

   DELETE FROM aqcq302_tmp     #lixh121121

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    
      OPEN WINDOW q302_w WITH FORM "aqc/42f/aqcq302"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      CALL cl_set_act_visible("revert_filter",FALSE)
      CALL q302_q(0,0)        
      CALL q302_menu()
      CLOSE WINDOW q302_w
   ELSE 
      CALL aqcq302()  
   END IF   
   DROP TABLE aqcq302_tmp     #lixh121121
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    
 
END MAIN      

FUNCTION q302_menu()
   WHILE TRUE
      CALL q302_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL q302_q(0,0)
            END IF
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q302_filter_askkey()
               CALL aqcq302()        #重填充新臨時表
            END IF
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE)
               CALL aqcq302()        #重填充新臨時表
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcs_excel),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION  

FUNCTION q302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   IF cl_null(g_filter_wc) OR g_filter_wc = " 1=1" THEN
      CALL cl_set_act_visible("revert_filter", FALSE)
   END IF 
   DISPLAY g_rec_b TO FORMONLY.cnt
   DISPLAY ARRAY g_qcs TO s_qcs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE ROW
         LET l_ac = ARR_CURR()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION data_filter       #資料過濾
         LET g_action_choice="data_filter"
         EXIT DISPLAY

      ON ACTION revert_filter     #過濾還原
         LET g_action_choice="revert_filter"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY  
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION 

FUNCTION q302_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01 
   CLEAR FORM                             #清除畫面
   CALL g_qcs.clear()
   CALL g_qcs_excel.clear()
   LET g_wc = ''
   LET g_filter_wc = ''
   WHILE TRUE
   CONSTRUCT g_wc ON qcs03,qcs04,qcs01,qcs02,qcs05,qcs021,qcs22,qcs091,qcs09,
                     qcs13,qct04,qct11,qct07,qct08,qct131,qct132
                FROM s_qcs[1].qcs03,s_qcs[1].qcs04,s_qcs[1].qcs01,s_qcs[1].qcs02,s_qcs[1].qcs05,
                     s_qcs[1].qcs021,s_qcs[1].qcs22,s_qcs[1].qcs091,s_qcs[1].qcs09,s_qcs[1].qcs13,
                     s_qcs[1].qct04,s_qcs[1].qct11,s_qcs[1].qct07,s_qcs[1].qct08,s_qcs[1].qct131,
                     s_qcs[1].qct132   

      BEFORE CONSTRUCT
            CALL cl_qbe_init()

      ON ACTION CONTROLP    
         CASE 
            WHEN INFIELD(qcs021)
               CALL cl_init_qry_var()
            #  LET g_qryparam.form = "q_qcs2"
               LET g_qryparam.form = "q_qcs6"  #lixh121204  
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs021
               NEXT FIELD qcs021
            WHEN INFIELD(qcs03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs03
               NEXT FIELD qcs03
            WHEN INFIELD(qcs13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs5"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs13
               NEXT FIELD qcs13
            WHEN INFIELD(qcs01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs1"
               LET g_qryparam.where = " qcs00 MATCHES '[12]' "   #只查詢收貨單和自行輸入的部份
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs01
               NEXT FIELD qcs01
            WHEN INFIELD(qct04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
            #  LET g_qryparam.form = "q_azf"
            #  LET g_qryparam.arg1 = "6"    #檢驗碼           
               LET g_qryparam.form = "q_qct"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qct04
               NEXT FIELD qct04               
               
      END CASE
      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION qbe_select
         CALL cl_qbe_select() 
   END  CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')   
   IF cl_null(g_wc) THEN LET g_wc = '1=1' END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_wc TO NULL
      RETURN
     #EXIT PROGRAM
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time
   END IF
   CALL aqcq302()
   EXIT WHILE
   END WHILE
END FUNCTION
                                                                                        
FUNCTION q302_q(p_row,p_col)
DEFINE lc_qbe_sn            LIKE gbm_file.gbm01   
DEFINE p_row,p_col       LIKE type_file.num5
          
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW axcq302_w AT p_row,p_col
        WITH FORM "aqc/42f/axcq302" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   INITIALIZE g_wc TO NULL         
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   
   CALL q302_cs()
   
END FUNCTION

FUNCTION q302_filter_askkey()
DEFINE  l_wc   STRING
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01 
   CLEAR FORM                             #清除畫面
   CALL g_qcs.clear()
   CALL g_qcs_excel.clear()
   CONSTRUCT l_wc ON qcs03,qcs04,qcs01,qcs02,qcs05,qcs021,qcs22,qcs091,qcs09,
                     qcs13,qct04,qct11,qct07,qct08,qct131,qct132
                FROM s_qcs[1].qcs03,s_qcs[1].qcs04,s_qcs[1].qcs01,s_qcs[1].qcs02,s_qcs[1].qcs05,
                     s_qcs[1].qcs021,s_qcs[1].qcs22,s_qcs[1].qcs091,s_qcs[1].qcs09,s_qcs[1].qcs13,
                     s_qcs[1].qct04,s_qcs[1].qct11,s_qcs[1].qct07,s_qcs[1].qct08,s_qcs[1].qct131,
                     s_qcs[1].qct132   

      BEFORE CONSTRUCT
            CALL cl_qbe_init()

      ON ACTION CONTROLP    
         CASE 
            WHEN INFIELD(qcs021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs2"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs021
               NEXT FIELD qcs021

            WHEN INFIELD(qcs03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs03
               NEXT FIELD qcs03
            WHEN INFIELD(qcs13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs5"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs13
               NEXT FIELD qcs13
            WHEN INFIELD(qcs01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs1"
               LET g_qryparam.where = " qcs00 MATCHES '[12]' "
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs01
               NEXT FIELD qcs01
            WHEN INFIELD(qct04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
            #  LET g_qryparam.form = "q_azf"
            #  LET g_qryparam.arg1 = "6"    #檢驗碼           
               LET g_qryparam.form = "q_qct"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qct04
               NEXT FIELD qct04               
               
      END CASE
      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION qbe_select
         CALL cl_qbe_select() 
   END  CONSTRUCT
   IF INT_FLAG THEN
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN
#     EXIT PROGRAM
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED

END FUNCTION

FUNCTION q302_table()
   CREATE TEMP TABLE aqcq302_tmp(
               qcs03       LIKE qcs_file.qcs03,
               pmc03       LIKE pmc_file.pmc03,
               qcs04       LIKE qcs_file.qcs04,
               qcs01       LIKE qcs_file.qcs01,
               qcs02       LIKE qcs_file.qcs02,
               qcs05       LIKE qcs_file.qcs05,
               qcs021      LIKE qcs_file.qcs021,
               ima02       LIKE ima_file.ima02,
               ima021      LIKE ima_file.ima021,
               qcs22       LIKE qcs_file.qcs22,
               qcs091      LIKE qcs_file.qcs091,
               qcs09       LIKE qcs_file.qcs09,
               qcs13       LIKE qcs_file.qcs13,
               gen02       LIKE gen_file.gen02,   
               qct04       LIKE qct_file.qct04,
               azf03       LIKE azf_file.azf03,
               qct11       LIKE qct_file.qct11,
               qct07       LIKE qct_file.qct07,
               qct08       LIKE qct_file.qct08,
               qct131      LIKE qct_file.qct131,
               qct132      LIKE qct_file.qct132)

END FUNCTION

FUNCTION aqcq302()
DEFINE l_sql,l_sql1,l_sql2       STRING    
   IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF
   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF
   DELETE FROM aqcq302_tmp      #lixh121121
   LET l_sql = " SELECT qcs03,pmc03,qcs04,qcs01,qcs02,qcs05,qcs021,ima02,ima021,qcs22,qcs091,qcs09,",
               "        qcs13,gen02,qct04,azf03,qct11,qct07,qct08,qct131,qct132",
               "   FROM qcs_file LEFT OUTER JOIN pmc_file ON pmc01 = qcs03 ",
               "                 LEFT OUTER JOIN gen_file ON gen01 = qcs13 ",
               "                 LEFT OUTER JOIN ima_file ON ima01 = qcs021,",
               "        qct_file LEFT OUTER JOIN azf_file ON azf01 = qct04 AND azf02='6'",
               "  WHERE qcs01 = qct01 ",
               "    AND qcs02 = qct02 ",
               "    AND qcs05 = qct021 ",
               "    AND qcs14='Y' ",
               "    AND qcs00<'5' ",  
               "    AND ", g_wc CLIPPED," AND ",g_filter_wc CLIPPED,
               "  ORDER BY qcs03,qcs04,qcs01,qcs021"    

#  DISPLAY TIME   #lixh1
   LET l_sql1 = " INSERT INTO aqcq302_tmp ",
                "   SELECT x.* ",
                "     FROM (",l_sql CLIPPED,") x "
   PREPARE q302_prepare1 FROM l_sql1
   EXECUTE q302_prepare1 
#lixh121121 ------Begin-----
#  IF SQLCA.sqlcode THEN
#     CALL cl_err('prepare:',SQLCA.sqlcode,1)
#     RETURN
#  END IF
#  DECLARE q302_curs1 CURSOR FOR q302_prepare1               
#lixh121121 ------End-------
   LET l_sql2 = "SELECT * FROM aqcq302_tmp "
   PREPARE q302_pb FROM l_sql2
   DECLARE q302_curs1 CURSOR FOR q302_pb      
   LET g_cnt = 1
   FOREACH q302_curs1 INTO g_qcs_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#lixh121121 ------Begin-----
#     SELECT pmc03 INTO g_qcs_excel[g_cnt].pmc03 FROM pmc_file
#      WHERE pmc01 = g_qcs_excel[g_cnt].qcs03
#     SELECT ima02,ima021 INTO g_qcs_excel[g_cnt].ima02,g_qcs_excel[g_cnt].ima021 FROM ima_file
#      WHERE ima01 = g_qcs_excel[g_cnt].qcs021
#     IF SQLCA.sqlcode THEN LET g_qcs_excel[g_cnt].ima021 = NULL END IF
#     SELECT azf03 INTO g_qcs_excel[g_cnt].azf03 FROM azf_file
#      WHERE azf01 = g_qcs_excel[g_cnt].qct04 AND azf02='6' 
#lixh121121 ------End-------
      IF g_cnt < = g_max_rec THEN
         LET g_qcs[g_cnt].* = g_qcs_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1
      
   END FOREACH    
#  DISPLAY TIME    #lixh1
   IF g_cnt <= g_max_rec THEN
      CALL g_qcs.deleteElement(g_cnt)
   END IF
   CALL g_qcs_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt             
END FUNCTION
#FUN-C90076 
