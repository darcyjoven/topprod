DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD 
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD,
    g_sfb       DYNAMIC ARRAY OF RECORD
                sfb01  LIKE sfb_file.sfb01,
                sfb81  LIKE sfb_file.sfb81,  
                sfb05  LIKE sfb_file.sfb05,
                ima02  LIKE ima_file.ima02,
                ima021 LIKE ima_file.ima021,
                ima09  LIKE ima_file.ima09,
                azf03  LIKE azf_file.azf03,
                ta_azf01  LIKE azf_file.ta_azf01,
                tc_shb14  LIKE tc_shb_file.tc_shb14,
                postdate  LIKE type_file.dat,
                tdate     LIKE type_file.dat,
                cdate     LIKE type_file.dat,
                sfbud05   LIKE sfb_file.sfbud05
                END RECORD,
    l_ac        LIKE type_file.num5,
    g_sfb03     LIKE qcs_file.qcs03,
    g_qcu04     LIKE qcu_file.qcu04,
    g_qct08     LIKE qct_file.qct08,
    g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
    g_sql       string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b     LIKE type_file.num5       #單身筆數  #No.FUN-690066 SMALLINT
DEFINE g_wc            STRING
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690066 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690066 VARCHAR(72)
 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690066 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690066 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("csf")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW csfq006_w AT p_row,p_col
         WITH FORM "csf/42f/csfq006"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q006_q() 
    CALL q006_menu()
    CLOSE WINDOW csfq006_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q006_menu()
 
   WHILE TRUE
      CALL q006_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q006_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0006
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q006_q()    
    CLEAR FORM
    CALL g_sfb.clear()
     CONSTRUCT g_wc ON                     
        sfb01,sfb81,sfb05
        FROM s_sfb[1].sfb01,s_sfb[1].sfb81,s_sfb[1].sfb05

        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(sfb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfb"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb01
                 NEXT FIELD sfb01

              WHEN INFIELD(sfb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima18"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb05
                 NEXT FIELD sfb05
                 
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
    CALL q006_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q006_b_fill(p_wc2)              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690066 VARCHAR(1000)   #MOD-B90146 mark
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
   DEFINE l_tc_shb06  LIKE tc_shb_file.tc_shb06
   DEFINE l_sfb08  LIKE sfb_file.sfb08

   LET l_sql =                                                                                                        #tianry add 
        "SELECT sfb01,sfb81,sfb05,ima02,ima021,ima09,azf03,NVL(ta_azf01,0),'','','','',sfbud05  ",  #MOD-6A0130 modify
        " FROM  sfb_file LEFT JOIN ima_file ON sfb05 = ima01 ", 
        "                LEFT JOIN azf_file ON azf01 = ima09 ",
        " WHERE ",p_wc2 CLIPPED," AND sfb04 ! = '8' "

    PREPARE q006_pb FROM l_sql    
    DECLARE q006_bcs CURSOR FOR q006_pb
    CALL g_sfb.clear()
    LET g_cnt = 1
    FOREACH q006_bcs INTO g_sfb[g_cnt].*
     
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

     SELECT MIN(tc_shb06) INTO l_tc_shb06 FROM tc_shb_file WHERE tc_shb04 = g_sfb[g_cnt].sfb01 AND tc_shb01 = '1'
     SELECT MIN(tc_shb14) INTO g_sfb[g_cnt].tc_shb14 FROM tc_shb_file
     WHERE tc_shb04 = g_sfb[g_cnt].sfb01 AND tc_shb01 = '1' AND tc_shb06 = l_tc_shb06

     SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = g_sfb[g_cnt].sfb01
     LET g_sfb[g_cnt].postdate = g_sfb[g_cnt].tc_shb14 + (l_sfb08 * g_sfb[g_cnt].ta_azf01)

     LET g_sfb[g_cnt].tdate = g_today

     LET g_sfb[g_cnt].cdate = g_today - g_sfb[g_cnt].postdate
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	  EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_sfb.deleteElement(g_cnt)      #No:MMOD-810252 add
    LET g_rec_b=g_cnt-1                  #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q006_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
              
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY

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
      
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0065
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
 
