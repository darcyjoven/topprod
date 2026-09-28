DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD
               #wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
               #wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD,
    g_qcs       DYNAMIC ARRAY OF RECORD
                qcs01  LIKE qcs_file.qcs01,
                qcs02  LIKE qcs_file.qcs02,
                qcs05  LIKE qcs_file.qcs05,
                qcs04   LIKE qcs_file.qcs04,
                pmc03   LIKE pmc_file.pmc03,
                qcs021  LIKE qcs_file.qcs021,
                qce03   LIKE qce_file.qce03,
                qcs09_desc LIKE type_file.chr20,
                qcs15   LIKE qcs_file.qcs15,
                qcsud13 LIKE qcs_file.qcsud13,
                rvu03   LIKE rvu_file.rvu03
                END RECORD,
    l_ac        LIKE type_file.num5,
    g_qcs03     LIKE qcs_file.qcs03,
    g_qcu04     LIKE qcu_file.qcu04,
    g_qct08     LIKE qct_file.qct08,
    g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
    g_sql       string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b     LIKE type_file.num5       #單身筆數  #No.FUN-690026 SMALLINT
DEFINE g_wc            STRING
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CQC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW cqc110_w AT p_row,p_col
         WITH FORM "cqc/42f/cqcq110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q110_q()
#    END IF
IF NOT cl_null(g_argv1) THEN CALL q110_q() END IF
    CALL q110_menu()
    CLOSE WINDOW cqc110_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q110_menu()
 
   WHILE TRUE
      CALL q110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q110_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcs),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q110_q()    
    CLEAR FORM
    CALL g_qcs.clear()
     CONSTRUCT g_wc ON                     # 螢幕上取條件
        qcs01,qcs02,qcs05,qcs04,qcs021,qcs15,qcsud13
        FROM qcs01,qcs02,qcs05,s_qcs[1].qcs04,s_qcs[1].qcs021,s_qcs[1].qcs15,s_qcs[1].qcsud13
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(qcs01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_qcs1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qcs01
                 NEXT FIELD qcs01
              
            WHEN INFIELD(qcs021)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO qcs021
                 NEXT FIELD qcs021
              
              OTHERWISE
                 EXIT CASE
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

                 ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q110_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q110_b_fill(p_wc2)              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)   #MOD-B90146 mark
   DEFINE l_sql     STRING
   DEFINE l_sql1    STRING
   DEFINE p_wc2  STRING
   DEFINE l_qcs03  LIKE qcs_file.qcs03
   DEFINE l_qce03  LIKE qce_file.qce03
   DEFINE l_qcs09  LIKE qcs_file.qcs09
   DEFINE l_qcu04  LIKE qcu_file.qcu04
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_str   STRING
   DEFINE l_chr   LIKE type_file.chr20

   LET l_sql =
        "SELECT qcs01,qcs02,qcs05,qcs04, '', qcs021,'','',qcs15, qcsud13, '' ",  #MOD-6A0130 modify
       #" ,ima02, ima021",          #FUN-640006  #MOD-6A0130 mark
        " FROM  qcs_file",  #FUN-640006   #No.TQC-780080 add
        " WHERE ",p_wc2 CLIPPED,
        " ORDER BY qcs01 "
    PREPARE q110_pb FROM l_sql
    DECLARE q110_bcs                       #BODY CURSOR
        CURSOR FOR q110_pb
    CALL g_qcs.clear()
    LET g_cnt = 1
    FOREACH q110_bcs INTO g_qcs[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    LET l_qcu04=''
    LET l_str = ''

    SELECT count(*) INTO l_n from qcs_file,dual WHERE qcsud13=to_date('1899/12/31','YYYY/MM/DD') 
   AND qcs01=g_qcs[g_cnt].qcs01 
   AND qcs02=g_qcs[g_cnt].qcs02 
   AND qcs05=g_qcs[g_cnt].qcs05
   IF(l_n>0) THEN
   LET  g_qcs[g_cnt].qcsud13=''
   DISPLAY g_qcs[g_cnt].qcsud13 TO FORMONLY.qcsud13
   END IF 


   
   SELECT qcs03 INTO l_qcs03 FROM  qcs_file 
   WHERE qcs01=g_qcs[g_cnt].qcs01 AND qcs02=g_qcs[g_cnt].qcs02 AND qcs05=g_qcs[g_cnt].qcs05
   SELECT qcs09 INTO l_qcs09 FROM  qcs_file
   WHERE qcs01=g_qcs[g_cnt].qcs01 AND qcs02=g_qcs[g_cnt].qcs02 AND qcs05=g_qcs[g_cnt].qcs05
   --SELECT qcu04 INTO l_qcu04 FROM qcu_file
   --WHERE qcu01=g_qcs[g_cnt].qcs01 AND qcu02=g_qcs[g_cnt].qcs02 AND qcu021=g_qcs[g_cnt].qcs05
  
     CASE l_qcs09
      WHEN '1'
         CALL cl_getmsg('aqc-004',g_lang) RETURNING  g_qcs[g_cnt].qcs09_desc
      WHEN '2'
         CALL cl_getmsg('apm-244',g_lang) RETURNING  g_qcs[g_cnt].qcs09_desc
      WHEN '3'
         CALL cl_getmsg('aqc-006',g_lang) RETURNING  g_qcs[g_cnt].qcs09_desc
    END CASE

       SELECT rvu03 INTO g_qcs[g_cnt].rvu03 FROM rvu_file WHERE rvu02 = g_qcs[g_cnt].qcs01 AND rvuconf='Y'
       SELECT pmc03 INTO g_qcs[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = l_qcs03
 #      SELECT qce03 INTO g_qcs[g_cnt].qce03 FROM qce_file WHERE qce01 = l_qcu04

  LET l_sql1 =
        "SELECT qcu04",  
        " FROM  qcu_file",  #FUN-640006   #No.TQC-780080 add
        " WHERE qcu01 = '",g_qcs[g_cnt].qcs01 CLIPPED,"'",
        " and qcu02= '",g_qcs[g_cnt].qcs02 CLIPPED,"'",
        " and qcu021= '",g_qcs[g_cnt].qcs05 CLIPPED,"'",
        " ORDER BY qcu01 "
    PREPARE q110_pre FROM l_sql1
    DECLARE q110_bcs1                       #BODY CURSOR
        CURSOR FOR q110_pre
   LET l_qcu04 = ''
   FOREACH q110_bcs1 INTO l_qcu04
     SELECT qce03 INTO l_chr FROM qce_file WHERE qce01 = l_qcu04
     LET l_str = l_chr,"/",l_str
   END FOREACH 
   LET g_qcs[g_cnt].qce03 = l_str
        LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_qcs.deleteElement(g_cnt)      #No:MMOD-810252 add
    LET g_rec_b=g_cnt-1                  #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q110_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcs TO s_qcs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
              
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
