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
                sfb38  LIKE sfb_file.sfb38,
                sfbud09  LIKE sfb_file.sfbud09,
                sfb08  LIKE sfb_file.sfb08,
                sfb081  LIKE sfb_file.sfb081,
                sfb09   LIKE sfb_file.sfb09,
                sfb12   LIKE sfb_file.sfb12,
                dybf    LIKE sfb_file.sfb12,
                sfv09   LIKE sfv_file.sfv09,
                dj      LIKE sfb_file.sfb12,
                jine     LIKE sfb_file.sfb12
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
 
    OPEN WINDOW csfq021_w AT p_row,p_col
         WITH FORM "csf/42f/csfq021"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL q021_q() 
    CALL q021_menu()
    CLOSE WINDOW csfq021_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q021_menu()
 
   WHILE TRUE
      CALL q021_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q021_q()
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

 
FUNCTION q021_q()    
    CLEAR FORM
    CALL g_sfb.clear()
     CONSTRUCT g_wc ON                     
        sfb01,sfb81,sfb05,sfb36
        FROM s_sfb[1].sfb01,s_sfb[1].sfb81,s_sfb[1].sfb05,s_sfb[1].sfb38

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
    CALL q021_table() 
    CALL q021(g_wc)
    CALL q021_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q021_b_fill(p_wc2)              #BODY FILL UP
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
        "SELECT DISTINCT sfb01,sfb81,sfb05,ima02,ima021,sfb38,sfbud09,sfb08,sfb081,sfb09,sfb12,dybf,sfv09,dj,jine ",  #MOD-6A0130 modify
        " FROM  axcq021_tmp " #, 
    #    " WHERE ",p_wc2 CLIPPED,"  "
        

    PREPARE q021_pb FROM l_sql    
    DECLARE q021_bcs CURSOR FOR q021_pb
    CALL g_sfb.clear()
    LET g_cnt = 1
    FOREACH q021_bcs INTO g_sfb[g_cnt].*
     
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

  
     LET g_sfb[g_cnt].jine = g_sfb[g_cnt].sfb12*g_sfb[g_cnt].dj
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
 
FUNCTION q021_bp(p_ud)
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
 
FUNCTION q021_table()
   CREATE TEMP TABLE axcq021_tmp( 
                sfb01  LIKE sfb_file.sfb01,
                sfb81  LIKE sfb_file.sfb81,  
                sfb05  LIKE sfb_file.sfb05,
                ima02  LIKE ima_file.ima02,
                ima021 LIKE ima_file.ima021,
                sfb38  LIKE sfb_file.sfb38,
                sfbud09  LIKE sfb_file.sfbud09,
                sfb08  LIKE sfb_file.sfb08,
                sfb081  LIKE sfb_file.sfb081,
                sfb09   LIKE sfb_file.sfb09,
                sfb12   LIKE sfb_file.sfb12,
                dybf    LIKE sfb_file.sfb12,
                sfv09   LIKE sfv_file.sfv09,
                dj      LIKE sfb_file.sfb12,
                jine    LIKE sfb_file.sfb12)   
END FUNCTION 

FUNCTION q021(p_wc2)    
DEFINE p_wc2,l_wc2,l_wc1,l_wc3,l_wc  STRING    
   DEFINE l_sql       STRING,
          l_where     STRING,
          i           LIKE type_file.num10,  #FUN-C80092 num5->10 
          l_flag      LIKE type_file.chr1
   DEFINE l_ckk       RECORD LIKE ckk_file.* 
   DEFINE l_ccg02b  LIKE ccg_file.ccg02,   
          l_ccg03b  LIKE ccg_file.ccg03,  
          l_ccg02e  LIKE ccg_file.ccg02,    
          l_ccg03e  LIKE ccg_file.ccg03,
          l_bmm     LIKE type_file.num5,                 
          l_emm     LIKE type_file.num5              
DEFINE    l_tlf032   LIKE tlf_file.tlf032     
DEFINE    l_tlf930   LIKE tlf_file.tlf930     
DEFINE    l_ima39    LIKE ima_file.ima39      
DEFINE    l_ima391   LIKE ima_file.ima391    
DEFINE    l_ccz07    LIKE ccz_file.ccz07                  
DEFINE    l_msg      STRING        #FUN-C80092
DEFINE    l_filter_wc STRING
DEFINE    l_sfu02     LIKE sfu_file.sfu02
DEFINE    l_yy        LIKE ccc_file.ccc02
DEFINE    l_mm        LIKE ccc_file.ccc03
   
    ###当月有完工入库的
   LET p_wc2=cl_replace_str(p_wc2,'sfb81','sfu02') 
   LET l_wc2=cl_replace_str(p_wc2,'sfb81','tc_shb14')
   LET l_sfu02 = ''
   LET l_wc=cl_replace_str(p_wc2,'sfb01','sfv11') 
   LET l_sql =  " select min(sfu02) FROM sfu_file,sfv_file WHERE sfu01 = sfv01 and ",l_wc CLIPPED," "
   PREPARE q021_pre FROM l_sql
   EXECUTE q021_pre INTO l_sfu02
   LET l_yy = year(l_sfu02)
   LET l_mm = month(l_sfu02)
   IF cl_null(l_yy) THEN 
      LET l_sql =  " SELECT to_char(min(tc_shb14),'yy/mm/dd') FROM  tc_shb_file WHERE ",l_wc2 CLIPPED," " 
      PREPARE q021_pre4 FROM l_sql
      EXECUTE q021_pre4 INTO l_sfu02
   END IF
   
    ###sfu02, --- '',
    LET l_sql =                                                                                                        #tianry add 
        " SELECT distinct sfb01,'',sfb05,ima02,ima021,sfb36,sfbud09,NVL(sfb08,0),NVL(sfb081,0),NVL(sfb09,0),NVL(sfb12,0),0,0,0 dj,0 jine  ",  
        " FROM  sfu_file,sfv_file,sfb_file LEFT JOIN ima_file ON sfb05 = ima01 ",
        " WHERE sfu01 = sfv01 and sfv11 = sfb01 and sfv04 = sfb05 and sfupost = 'Y' ",
        " AND ",p_wc2 CLIPPED,"  "
              
     LET l_sql = " INSERT INTO axcq021_tmp ",l_sql CLIPPED 
     PREPARE q021_ins FROM l_sql
     EXECUTE q021_ins
     
     
     ###当月有报废无入库的
      LET l_wc1=cl_replace_str(p_wc2,'sfb01','tc_shb04')
      LET l_wc1=cl_replace_str(l_wc1,'sfu02','tc_shb14')
      LET l_sql =                                                                                                        #tianry add 
        "SELECT distinct tc_shb04,'',sfb05,ima02,ima021,sfb36,sfbud09,NVL(sfb08,0),NVL(sfb081,0),NVL(sfb09,0),NVL(sfb12,0),0,0,0 dj,0 jine  ",  
        " FROM  tc_shb_file,sfb_file LEFT JOIN ima_file ON sfb05 = ima01 ", 
        " WHERE tc_shb04 = sfb01 and tc_shb05 = sfb05 and ",l_wc1 CLIPPED," AND sfb01 not in (select sfb01 from axcq021_tmp) " 
       # " AND ",l_wc2 CLIPPED,"  "
                  
     LET l_sql = " INSERT INTO axcq021_tmp ",l_sql CLIPPED 
     PREPARE q021_ins1 FROM l_sql
     EXECUTE q021_ins1
      
     ###更新报废数量
          LET l_sql=
               " MERGE INTO axcq021_tmp o ",
               "      USING (SELECT tc_shb04,tc_shb05,sum(tc_shb121) a FROM tc_shb_file where  ",l_wc1 CLIPPED," group by tc_shb04,tc_shb05 ) x ",
               "         ON (o.sfb01 = x.tc_shb04 and o.sfb05 = x.tc_shb05 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.dybf = x.a "    
    
     PREPARE q021_pre1 FROM l_sql
     EXECUTE q021_pre1  
     
    ###更新入库数量
       LET l_wc3 = cl_replace_str(p_wc2,'sfb01','sfv11')
       LET l_sql=
               " MERGE INTO axcq021_tmp o ",
               "      USING (SELECT sfv11,sfv04,sum(sfv09) a FROM sfv_file,sfu_file where  sfv01 = sfu01 and sfupost = 'Y' and ",l_wc3 CLIPPED," GROUP BY sfv11,sfv04) x ",
               "         ON (o.sfb01 = x.sfv11 and o.sfb05 = x.sfv04 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.sfv09 = x.a "    
    
     PREPARE q021_pre3 FROM l_sql
     EXECUTE q021_pre3   
     
    ###更新单价
      LET l_sql=
               " MERGE INTO axcq021_tmp o ",
               "      USING (SELECT ccc01,ccc23 FROM ccc_file where ccc02 = '",l_yy,"' and ccc03 = '",l_mm,"') x ",
               "         ON (o.sfb05 = x.ccc01) ",   #and MONTH(o.sfb81) = x.ccc02 AND MONTH(o.sfb81) = x.ccc03
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.dj = x.ccc23 "    
    
     PREPARE q021_pre2 FROM l_sql
     EXECUTE q021_pre2  
  
     
END FUNCTION 
