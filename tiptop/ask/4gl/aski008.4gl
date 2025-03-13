# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aski008.4gl                                                  
# Descriptions...: 飛票查詢打印維護作業                                        
# Date & Author..: 08/01/18 By ve007   FUN-810016 
# Modify.........: No.FUN-840001 by ve007 debug 810016
# Modify.........: No.FUN-870117 by ve007 增加根據作業編號查詢功能
# Modify.........: No.FUN-8A0145 by hongmei 欄位類型修改
# Modify.........: No.TQC-8C0056 08/12/23 By alex 調整setup參數
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global" 
 
DEFINE
   g_skh      RECORD
              skh02    LIKE skh_file.skh02,           # PBI號
              skh03    LIKE skh_file.skh03,           # 款式號
              skh13    LIKE skh_file.skh13            # 制單號
              END RECORD,
   g_skh_t    RECORD      
              skh02    LIKE skh_file.skh02,           # PBI號 
              skh03    LIKE skh_file.skh03,           # 款式號
              skh13    LIKE skh_file.skh13            # 制單號 
              END RECORD,
   g_skh1     DYNAMIC ARRAY OF RECORD
              skh01    LIKE skh_file.skh01,           #飛票號碼
              skh09    Like skh_file.skh09,           # 屬性一 
              skh10    Like skh_file.skh10,           # 屬性二
              skh11    Like skh_file.skh11,           # 屬性三
              skh04    LIKE skh_file.skh04,           # 床號
              skh05    LIKE skh_file.skh05,           # 扎號
              skh06    LIKE skh_file.skh06,           # 工單號碼   
              skh07    LIKE skh_file.skh07,           # 工序
              skh14    LIKE skh_file.skh14,           # 單元次序
              skh08    LIKE skh_file.skh08,           # 單元編號
              skh12    LIKE skh_file.skh12,           # 數量
              skh100   LIKE skh_file.skh100           # 打印碼
              END RECORD,
    g_skh1_t  RECORD                                           
              skh01    LIKE skh_file.skh01,           #飛票號碼                 
              skh09    Like skh_file.skh09,           # 屬性一                  
              skh10    Like skh_file.skh10,           # 屬性二                  
              skh11    Like skh_file.skh11,           # 屬性三                  
              skh04    LIKE skh_file.skh04,           # 床號                    
              skh05    LIKE skh_file.skh05,           # 扎號                    
              skh06    LIKE skh_file.skh06,           # 工單號碼                
              skh07    LIKE skh_file.skh07,           # 工序                    
              skh14    LIKE skh_file.skh14,           # 單元次序                
              skh08    LIKE skh_file.skh08,           # 單元編號                
              skh12    LIKE skh_file.skh12,           # 數量                    
              skh100   LIKE skh_file.skh100           # 打印碼                  
              END RECORD  
   DEFINE     g_wc                STRING,
              g_wc2               STRING,
              g_sql               STRING,
              g_sql_temp          STRING,
              g_forupd_sql        STRING,
              g_msg               LIKE type_file.chr1000,
              g_agb01             ARRAY[3] OF LIKE agb_file.agb01,
              g_agb02             ARRAY[3] OF LIKE agb_file.agb02,
              g_rec_b             LIKE type_file.num5,         #單身筆數
              l_ac                LIKE type_file.num5,
              p_row,p_col         LIKE type_file.num5,
              g_cnt               LIKE type_file.num10,
              g_row_count         LIKE type_file.num10,
              g_curs_index        LIKE type_file.num10,
              g_jump              LIKE type_file.num10,
              g_no_ask            LIKE type_file.num5,
              l_table             STRING 
   DEFINE     g_ecm04             LIKE ecm_file.ecm04      #by jan add
 
MAIN
   OPTIONS                                 #改變一些系統預設值                  
        INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF 
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN  #TQC-8C0056
      EXIT PROGRAM                                                              
   END IF
   
   LET g_sql = "skh13.skh_file.skh13,",
               "skh07.skh_file.skh07,",
               "skh08.skh_file.skh08,",
               "skh05.skh_file.skh05,",
               "skh12.skh_file.skh12,",
               "agd03a.agd_file.agd03,",
               "agd03b.agd_file.agd03,",
               "agd03c.agd_file.agd03,",
               "skh04.skh_file.skh04,",
               "skh01.skh_file.skh01 "
 
    LET l_table = cl_prt_temptable('aski008',g_sql) CLIPPED                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                                     
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
                " VALUES(?,?,?,?,?, ?,?,?,?,?)"                                                   
    PREPARE insert_prep FROM g_sql                                               
    IF STATUS THEN                                                               
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
    END IF 
    
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql="SELECT skh02,skh13,skh03 FROM skh_file ",
                    "  WHERE skh02=? AND skh13=? AND skh03=? ",
                    " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i008_cl CURSOR FROM g_forupd_sql
   
   IF NOT s_industry('slk') THEN                                                
      CALL cl_err("","-1000",1)                                                 
      EXIT PROGRAM                                                              
   END IF
   
   CALL cl_set_comp_entry("skh01,skh09,skh10,skh11,skh04,skh05,skh06,skh07,skh14,skh08,skh12,skh100",TRUE)                                                                                  
 
   OPEN WINDOW i008_w WITH FORM "ask/42f/aski008"                                            
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i008_menu()                                                            
   CLOSE WINDOW i008_w                                                         
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION i008_cs()
   DEFINE   l_cnt LIKE type_file.num5
   DEFINE   l_i   LIKE type_file.num5
 
   CLEAR FORM #清除畫面 
   CALL g_skh1.clear()
    CALL cl_opmsg('q')                                                      
        CALL cl_set_comp_visible("skh09,skh10,skh11",TRUE)
   
   FOR l_i=1 TO 3                                                               
        LET g_msg=NULL                                                          
        CASE l_i                                                                
             WHEN '1'  SELECT ze03 INTO g_msg  FROM ze_file                     
                       WHERE ze01='ask-005' AND ze02=g_lang                     
                       CALL cl_set_comp_att_text('skh09',g_msg CLIPPED)         
             WHEN '2'  SELECT ze03 INTO g_msg  FROM ze_file
                       WHERE ze01='ask-006' AND ze02=g_lang
                       CALL cl_set_comp_att_text('skh10',g_msg CLIPPED)         
             WHEN '3'  SELECT ze03 INTO g_msg  FROM ze_file 
                       WHERE ze01='ask-007' AND ze02=g_lang
                       CALL cl_set_comp_att_text('skh11',g_msg CLIPPED)         
        END CASE                                                                
   END FOR  
  
   CONSTRUCT  g_wc ON skh02,skh03,skh13,ecm04,skh01,skh09,skh10,skh11,    # No.FUN-870117 add ecm04
                      skh04,skh05,skh06,skh07,skh14,skh08,skh12,
                      skh100 
                 FROM skh02,skh03,skh13,ecm04,s_skh1[1].skh01,s_skh1[1].skh09,  # No.FUN-870117 add ecm04
                      s_skh1[1].skh10,s_skh1[1].skh11,s_skh1[1].skh04,
                      s_skh1[1].skh05,s_skh1[1].skh06,s_skh1[1].skh07,
                      s_skh1[1].skh14,s_skh1[1].skh08,s_skh1[1].skh12,
                      s_skh1[1].skh100    
 
   ON ACTION controlp 
     CASE
        WHEN INFIELD (skh02)
          CALL cl_init_qry_var()
          LET g_qryparam.state='c'
          LET g_qryparam.form='q_skh02'
          CALL cl_create_qry()  RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO skh02
          NEXT FIELD skh02
        WHEN INFIELD (skh13)                                                    
          CALL cl_init_qry_var()                                                
          LET g_qryparam.state='c'                                              
          LET g_qryparam.form='q_skh13'                                         
          CALL cl_create_qry()  RETURNING g_qryparam.multiret                   
          DISPLAY g_qryparam.multiret TO skh13                                  
          NEXT FIELD skh13
        WHEN INFIELD (skh03)                                                    
          CALL cl_init_qry_var()                                                
          LET g_qryparam.state='c'                                              
          LET g_qryparam.form='q_skh03'                                         
          CALL cl_create_qry()  RETURNING g_qryparam.multiret                   
          DISPLAY g_qryparam.multiret TO skh03
          CALL i008_skh03('d')                                  
          NEXT FIELD skh03 
          # No.FUN-870117 --begin--
         WHEN INFIELD (ecm04)
              CALL cl_init_qry_var()
              LET g_qryparam.state='c' 
              LET g_qryparam.form="q_ecm03"
              CALL cl_create_qry() RETURNING g_qryparam.multiret              DISPLAY g_qryparam.multiret TO FORMONLY.ecm04
              NEXT FIELD ecm04 
         # No.FUN-870117 --end--       
       OTHERWISE EXIT CASE
    END CASE
   
    ON IDLE g_idle_seconds                                            
       CALL cl_on_idle()                                              
       CONTINUE CONSTRUCT
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  
  MESSAGE ' WAIT '
  
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF   
    
#    LET g_sql=" SELECT UNIQUE skh02,skh13,skh03 FROM skh_file,ecm_file",             
#            "   WHERE ",g_wc CLIPPED 
     #No.FUN-870117  --begin-- 
     IF g_wc.getIndexOf('ecm04',1) =0 THEN 
       LET g_sql=" SELECT UNIQUE skh02,skh13,skh03,'' FROM skh_file",           
                 " WHERE  ",g_wc CLIPPED 
     ELSE 
     	 LET g_sql=" SELECT UNIQUE skh02,skh13,skh03,ecm04 FROM skh_file,ecm_file,sgd_file",         
                 " WHERE skh06=ecm01  and sgd00=ecm01 and sgd05=skh08 ",   
                 " and ecm03=sgd03 and " ,g_wc CLIPPED
     END IF                       
    # No.FUN-870117 --end--
  PREPARE i008_prepare FROM g_sql
  DECLARE i008_cs
          SCROLL CURSOR WITH HOLD FOR i008_prepare
 
   # 取合乎條件筆數 
   #08/06/24 by jan modify begin--
#   LET g_sql=" SELECT UNIQUE skh02,skh13,skh03 ",
#                  " FROM skh_file WHERE ",g_wc CLIPPED
    #No.FUN-870117  --begin-- 
     IF g_wc.getIndexOf('ecm04',1) =0 THEN 
       LET g_sql=" SELECT UNIQUE skh02,skh13,skh03 FROM skh_file",           
                 " WHERE  ",g_wc CLIPPED 
     ELSE 
     	 LET g_sql=" SELECT UNIQUE skh02,skh13,skh03,ecm04 FROM skh_file,ecm_file,sgd_file" ,        
                 " WHERE skh06=ecm01  and sgd00=ecm01 and sgd05=skh08 ",   
                 " and ecm03=sgd03 and " ,g_wc CLIPPED
     END IF                       
    # No.FUN-870117 --end--
#    LET g_sql=" SELECT UNIQUE skh02,skh13,skh03,ecm04 ",
#              " FROM skh_file,ecm_file WHERE ",
#              " skh06=ecm01 and ",g_wc CLIPPED
#   #08/06/24 by jan end--
  LET g_sql_temp=g_sql CLIPPED," INTO TEMP x "
  DROP TABLE x 
  PREPARE i008_pp_x FROM g_sql_temp 
  EXECUTE i008_pp_x
 
  LET g_sql=" SELECT count(*) FROM x "
  PREPARE i008_pp FROM g_sql
  DECLARE i008_count   CURSOR FOR i008_pp   
                                   
END FUNCTION
   
FUNCTION i008_menu()
   WHILE TRUE
     CALL i008_bp("G")
     CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i008_q()                                                    
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                 
         WHEN "exit"                                                            
            EXIT WHILE
         WHEN "controlg"                                                        
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i008_out()
            END IF
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i008_r()                                                    
            END IF
         WHEN "b_del"                                                         
            IF cl_chk_act_auth() THEN                                           
               CALL i008_b_del()                                                    
            END IF 
      END CASE
    END WHILE
END FUNCTION
 
FUNCTION i008_q()
   
    LET g_row_count = 0                                                         
    LET g_curs_index = 0                                                        
    CALL cl_navigator_setting( g_curs_index, g_row_count )                      
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i008_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF 
    OPEN i008_cs
    IF SQLCA.sqlcode THEN                                                       
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_skh.* TO NULL                                   
    ELSE 
    OPEN i008_count                                                          
       FETCH i008_count INTO g_row_count                                        
       DISPLAY g_row_count TO FORMONLY.cnt                                      
       CALL i008_fetch('F')                  # 讀出TEMP第一筆并顯示             
    END IF                                                                      
        MESSAGE ''                                                              
END FUNCTION 
 
FUNCTION i008_fetch(p_flag)
DEFINE 
    p_flag     LIKE type_file.chr1     #處理方式
    
    CASE p_flag                                                                 
        WHEN 'N' FETCH NEXT     i008_cs INTO g_skh.skh02,g_skh.skh13,
                                             g_skh.skh03,g_ecm04        #by jan add ecm04          
        WHEN 'P' FETCH PREVIOUS i008_cs INTO g_skh.skh02,g_skh.skh13,           
                                             g_skh.skh03,g_ecm04        #by jan add ecm04            
        WHEN 'F' FETCH FIRST    i008_cs INTO g_skh.skh02,g_skh.skh13,           
                                             g_skh.skh03,g_ecm04        #by jan add ecm04            
        WHEN 'L' FETCH LAST     i008_cs INTO g_skh.skh02,g_skh.skh13,           
                                             g_skh.skh03,g_ecm04        #by jan add ecm04            
        WHEN '/'                                                                
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg                   
               LET INT_FLAG = 0  ######add for prompt bug                       
               PROMPT g_msg CLIPPED,': ' FOR g_jump                             
                  ON IDLE g_idle_seconds                                        
                     CALL cl_on_idle()                                          
               END PROMPT                                                       
               IF INT_FLAG THEN                                                 
                   LET INT_FLAG = 0                                             
                   EXIT CASE                                                    
               END IF                                                           
            END IF                                                              
            FETCH ABSOLUTE g_jump i008_cs INTO g_skh.skh02,g_skh.skh13,        
                                               g_skh.skh03,g_ecm04     #by jan add ecm04
            LET g_no_ask = FALSE                                               
    END CASE
 
    IF SQLCA.sqlcode THEN                                                       
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    ELSE
        CASE p_flag                                                             
          WHEN 'F' LET g_curs_index = 1                                         
          WHEN 'P' LET g_curs_index = g_curs_index - 1                          
          WHEN 'N' LET g_curs_index = g_curs_index + 1                          
          WHEN 'L' LET g_curs_index = g_row_count                               
          WHEN '/' LET g_curs_index = g_jump                                    
        END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )                   
     END IF 
     
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("sel","skh_file",g_skh.skh02,"",SQLCA.sqlcode,"","",0)
#        RETURN
#     END IF
 CALL i008_show()
END FUNCTION
 
FUNCTION i008_show()
   LET g_skh_t.*=g_skh.* 
   DISPLAY g_skh.skh02 TO skh02
   DISPLAY g_skh.skh13 TO skh13
   DISPLAY g_skh.skh03 TO skh03
   DISPLAY g_ecm04 TO ecm04          #by jan add
   CALL i008_skh03('d')
   CALL i008_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i008_b_fill(p_wc2)
  DEFINE 
      #p_wc2      LIKE type_file.chr1000
      p_wc2           STRING       #NO.FUN-910082 
  DEFINE l_i,l_j    LIKE type_file.num5
  DEFINE l_chr      LIKE type_file.chr3
  DEFINE l_msg      LIKE type_file.chr1000
  DEFINE l_mag      LIKE type_file.chr1000 
 
  CALL cl_set_comp_visible("skh09,skh10,skh11",TRUE)
  CALL g_agb02.clear()
  CALL g_agb01.clear() 
   
  DECLARE i008_skhtt CURSOR FOR 
    SELECT agb02,agb01 
    FROM agb_file,ima_file
    WHERE ima01=g_skh.skh03
    AND imaag=agb01  ORDER BY agb02
  LET l_i=1
  FOREACH i008_skhtt INTO g_agb02[l_i],g_agb01[l_i]
    IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH 
        END IF
        LET l_i = l_i + 1
        IF l_i>3 THEN
           EXIT FOREACH
        END IF
  END FOREACH
  FOR l_i=1 TO 3
      LET l_j=l_i+8
      IF l_j<10 THEN
         LET l_chr=l_j
         LET l_msg="skh0",l_chr CLIPPED
      ELSE 
         LET l_chr=l_j
         LET l_msg="skh",l_chr CLIPPED
      END IF
      IF g_agb02[l_i]!=0 THEN
        SELECT agc02 INTO l_mag FROM agb_file,agc_file WHERE agb02=g_agb02[l_i] 
           AND agc_file.agc01=agb03 
           AND agb01=g_agb01[l_i] 
        CALL cl_set_comp_att_text(l_msg,l_mag CLIPPED)
      ELSE
        CALL cl_set_comp_visible(l_msg,FALSE)
      END IF
  END FOR
 
  CALL g_skh1.clear()
  LET g_rec_b=0                                                                
  LET l_i = 1 
  
  #No.FUn-870117 --begin--
  IF g_wc.getindexof('ecm04',1) =0 THEN    
     LET g_sql ="SELECT skh01,skh09,skh10,skh11,skh04,skh05,skh06,skh07,", 
             " skh14,skh08,skh12,skh100 FROM skh_file",
             " WHERE skh02='",g_skh.skh02,"' AND skh03='",g_skh.skh03,"'",
             " AND skh13='",g_skh.skh13,"'", 
             "  and ",g_wc CLIPPED ,
             " ORDER BY skh01 "
  ELSE  
  #No.FUn-870117	 --end--        
    LET g_sql ="SELECT skh01,skh09,skh10,skh11,skh04,skh05,skh06,skh07,", 
               " skh14,skh08,skh12,skh100 FROM skh_file,ecm_file,sgd_file",
               " WHERE skh02='",g_skh.skh02,"' AND skh03='",g_skh.skh03,"'",
               " AND skh13='",g_skh.skh13,"'", 
               " and skh06=ecm01  and sgd00=ecm01 and sgd05=skh08 ", 
               " and ecm03=sgd03 and ",g_wc CLIPPED , 
              " ORDER BY skh01 "
  END IF    #No.FUn-870117         
  PREPARE i008_pb FROM g_sql
  DECLARE i008_bcs CURSOR FOR i008_pb
  
  FOREACH i008_bcs INTO g_skh1[l_i].*
        IF SQLCA.sqlcode THEN 
            CALL cl_err('Foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH 
        END IF
        LET l_i=l_i+1
        IF l_i > g_max_rec THEN                                                 
           CALL cl_err( '', 9035, 0 )                                           
           EXIT FOREACH                                                         
        END IF                                                                  
    END FOREACH
 
    CALL g_skh1.deleteElement(l_i)
    LET g_rec_b=(l_i-1)                                                         
    DISPLAY g_rec_b TO FORMONLY.cnt2
    IF g_rec_b != 0 THEN                                                        
       CALL fgl_set_arr_curr(1)                                                 
    END IF                                                                      
END FUNCTION 
 
FUNCTION i008_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN                          
      RETURN                                                                    
  END IF
 
  LET g_action_choice = " "  
 
  CALL cl_set_act_visible("accept,cancel", FALSE)                              
  DISPLAY ARRAY g_skh1 TO s_skh1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)         
                                                                                
      BEFORE DISPLAY                                                            
          CALL cl_navigator_setting( g_curs_index, g_row_count )
    
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()                                                  
      CALL cl_show_fld_cont()
 
      ON ACTION query                                                           
         LET g_action_choice="query"                                            
         EXIT DISPLAY                
   
      ON ACTION delete                                                          
         LET g_action_choice="delete"                                          
         EXIT DISPLAY                                           
                                                                              
      ON ACTION first                                                           
         CALL i008_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #   ACCEPT DISPLAY               
         EXIT DISPLAY                                                          
      
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY 
                                                                                   
      ON ACTION previous                                                        
         CALL i008_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                   
         #   ACCEPT DISPLAY
    #     EXIT DISPLAY                                                                          
 
      ON ACTION jump                                                            
         CALL i008_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #ACCEPT DISPLAY 
     #    EXIT DISPLAY                                                                          
 
      ON ACTION next                                                            
         CALL i008_fetch('N')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #ACCEPT DISPLAY
   #      EXIT DISPLAY                                                                          
   
      ON ACTION last                                                           
         CALL i008_fetch('L')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #ACCEPT DISPLAY
   #      EXIT DISPLAY                                                                          
 
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
      
      ON ACTION b_del
         LET l_ac =  ARR_CURR()
         LET g_action_choice="b_del"
         EXIT DISPLAY     
                                                                                   
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"                                             
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY
 
      END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION 
 
FUNCTION i008_b_del()
DEFINE l_lock_sw  LIKE type_file.chr1,
       l_n        LIKE type_file.num10
       
      IF s_shut(0) THEN
         RETURN
      END IF
      
      #No.FUN-840001 --begin--
      SELECT COUNT(*) INTO l_n FROM skh_file
        WHERE skh02 = g_skh.skh02 
      IF l_n = 0 THEN 
         CALL cl_err('','ask-052',0)
         RETURN
      END IF      
      #No.FUN-840001 --end--
      
      IF g_skh1[l_ac].skh01 IS NULL THEN
         CALL cl_err("",-400,0)
         RETURN
      END IF    
       
      LET g_forupd_sql=" SELECT skh01,skh09,skh10,skh11,skh04,skh05,skh06,",
                        " skh07,skh14,skh08,skh12,skh100 FROM skh_file",
                       "  WHERE skh02=? AND skh13=? AND skh03=? ",
                       " AND skh01=?  FOR UPDATE "
 
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE i008_bcl CURSOR FROM g_forupd_sql
      
      BEGIN WORK 
      LET l_lock_sw = 'N' 
      OPEN i008_bcl USING g_skh.skh02,g_skh.skh13,g_skh.skh03,
                                g_skh1[l_ac].skh01
      IF STATUS THEN                                                      
         CALL cl_err("OPEN i008_bcl:", STATUS, 1)                        
         LET l_lock_sw = "Y"
      END IF
                
      IF g_skh1[l_ac].skh01 IS NOT NULL THEN
            SELECT count(*) INTO l_n FROM sgl_file                           
              WHERE sgl03=g_skh1[l_ac].skh01                                 
            IF(l_n>0) THEN                                                    
              CALL cl_err('','ask-022',1)                                    
              RETURN     
            END IF
            IF NOT cl_delb(0,0) THEN
               RETURN 
            END IF
            IF l_lock_sw="Y" THEN
               CALL cl_err("", -263, 1)                                         
               RETURN                                                    
            END IF       
            SELECT count(*) INTO l_n FROM sgl_file
               WHERE sgl03=g_skh1[l_ac].skh01
            IF(l_n>0) THEN
               CALL cl_err('','ask-022',1)
               RETURN 
            ELSE
               DELETE FROM skh_file
                 WHERE skh01=g_skh1[l_ac].skh01
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_skh1_t.skh01,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    RETURN 
                 END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cnt2
             END IF
      END IF
      COMMIT WORK
 
       LET l_ac=ARR_CURR()
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG=0
          CLOSE i008_bcl
          ROLLBACK WORK
          RETURN 
       END IF
       CLOSE i008_bcl
       COMMIT WORK
 
       CALL i008_delall() 
       CALL i008_show()                                                      
END FUNCTION        
 
FUNCTION i008_delall()
DEFINE   l_cnt     LIKE type_file.num5
   SELECT count(*) INTO l_cnt FROM skh_file
      WHERE skh02=g_skh.skh02 AND skh03=g_skh.skh03
        AND skh13=g_skh.skh13
   IF l_cnt=0 THEN
       CALL cl_getmsg('9044',g_lang)  RETURNING g_msg
       ERROR g_msg CLIPPED
    END IF 
    
    CLEAR FORM 
 
END FUNCTION
 
FUNCTION i008_r()
DEFINE l_n      LIKE type_file.num5
   
    IF s_shut(0) THEN
       RETURN
    END IF
 
    SELECT COUNT(*) INTO l_n FROM skh_file 
       WHERE skh02 = g_skh.skh02 AND skh13 = g_skh.skh13
         AND skh03 = g_skh.skh03 
    IF l_n =0  THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
 
    BEGIN WORK
    
    OPEN i008_cl USING g_skh.skh02,g_skh.skh13,g_skh.skh03  
    IF STATUS THEN
       CALL cl_err("OPEN i008_bcl",STATUS,0)
       CLOSE i008_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    LET g_sql="SELECT skh01 FROM skh_file ",                             
             " WHERE skh02='",g_skh.skh02,"' AND skh13='",g_skh.skh13,"'",
             " AND skh03= '",g_skh.skh03,"' ORDER BY skh01 "                
   DECLARE i008_cs1 CURSOR FROM g_sql 
    FOREACH i008_cs1 INTO g_skh1[l_ac].skh01
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
    SELECT count(*) INTO l_n FROM sgl_file                           
         WHERE sgl03=g_skh1[l_ac].skh01                                 
            IF(l_n>0) THEN                                                    
              CALL cl_err('','ask-022',1)    
              ROLLBACK WORK                                   
              RETURN     
            END IF
       LET l_ac=l_ac+1
    END FOREACH
    
    CALL i008_show()
 
    IF cl_delete() THEN
       DELETE FROM skh_file WHERE skh02=g_skh.skh02 AND skh03=g_skh.skh03
                                  AND skh13=g_skh.skh13  
       CLEAR FORM
       CALL g_skh1.clear()
       DROP TABLE y
       LET g_sql=" SELECT UNIQUE skh02,skh13,skh03 FROM skh_file INTO TEMP y "
       PREPARE i008_pre_x2 FROM g_sql
       EXECUTE i008_pre_x2
       LET g_sql_temp=" SELECT COUNT(*) FROM y"
       PREPARE i008_pre_x3 FROM g_sql_temp                                     
       DECLARE i008_count3 CURSOR FOR i008_pre_x3
       OPEN i008_count3
       FETCH i008_count3 INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
 
       OPEN i008_cs
    
       IF g_curs_index=g_row_count+1 THEN
            LET g_jump=g_row_count
                CALL i008_fetch('L')
       ELSE
            LET g_jump=g_curs_index
            LET g_no_ask=TRUE
            CALL i008_fetch('/')
       END IF
   
     END IF
     CLOSE i008_cl
     COMMIT WORK
END FUNCTION
 
FUNCTION i008_out() 
DEFINE  
   l_i             LIKE type_file.num5,                                        
    sr             RECORD
      skh13        LIKE skh_file.skh13,
      skh03        LIKE skh_file.skh03,
      skh07        LIKE skh_file.skh07,
      skh08        LIKE skh_file.skh08,
      skh05        LIKE skh_file.skh05,
      skh12        LIKE skh_file.skh12,
      skh09        LIKE skh_file.skh09,
      skh10        LIKE skh_file.skh10,
      skh11        LIKE skh_file.skh11,
      skh04        LIKE skh_file.skh04,
      skh01        LIKE skh_file.skh01
                   END RECORD,
   l_name          LIKE type_file.chr20,                                       
   l_za05          LIKE type_file.chr1000, 
   l_agd03a        LIKE agd_file.agd03,
   l_agd03b        LIKE agd_file.agd03,
   l_agd03c        LIKE agd_file.agd03
DEFINE l_sql       STRING
 
   IF g_wc IS NULL THEN                                                        
       CALL cl_err('',-400,0)                                                   
       RETURN                                                                   
    END IF                                                                      
    CALL cl_wait()                                                              
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aski008'
  
    LET g_sql="SELECT skh13,skh03,skh07,skh08,skh05,skh12,skh09,skh10,skh11,skh04,skh01",
              " FROM skh_file WHERE skh02= '",g_skh.skh02,"'",
              " AND skh13 = '",g_skh.skh13,"'",
              " and skh03 = '",g_skh.skh03,"' and ",g_wc CLIPPED
    PREPARE i008_p1 FROM g_sql                # RUNTIME 編譯 
    DECLARE i008_co                           # SCROLL CURSOR 
         CURSOR FOR i008_p1 
    
    FOREACH i008_co INTO sr.*
      SELECT agd03 INTO l_agd03a
        FROM  agd_file,ima_file,agb_file
        WHERE agd02 = sr.skh09
          AND agd01 = agb03
          AND agb01 = imaag
          AND ima01 = sr.skh03
          AND agb02 = 1
      SELECT agd03 INTO l_agd03b
        FROM  agd_file,ima_file,agb_file
        WHERE agd02 = sr.skh10
          AND agd01 = agb03
          AND agb01 = imaag
          AND ima01 = sr.skh03 
          AND agb02 = 2 
      SELECT agd03 INTO l_agd03c
        FROM  agd_file,ima_file,agb_file
        WHERE agd02 = sr.skh11
          AND agd01 = agb03
          AND agb01 = imaag
          AND ima01 = sr.skh03 
          AND agb02 = 3
      EXECUTE insert_prep USING sr.skh13,sr.skh07,sr.skh08,sr.skh05,sr.skh12,
                                l_agd03a,l_agd03b,l_agd03c,sr.skh04,sr.skh01
    END FOREACH
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                      
    CALL cl_prt_cs3('aski008','aski008',l_sql,'')  
    
    UPDATE skh_file SET skh100='Y'
           WHERE skh02=g_skh.skh02 AND skh03=g_skh.skh03 AND skh13=g_skh.skh13
    CALL i008_show()
 
END FUNCTION
  
FUNCTION i008_skh03(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1,
           l_ima02   LIKE ima_file.ima02,
           l_imaacti LIKE ima_file.imaacti
   LET g_errno=' '
   SELECT ima02,imaacti INTO l_ima02,l_imaacti  FROM ima_file 
         WHERE ima01=g_skh.skh03
   
   CASE WHEN SQLCA.sqlcode =100   LET g_errno='mfg3008'
        WHEN l_imaacti='N'        LET g_errno='9028'
        OTHERWISE                 LET g_errno= SQLCA.sqlcode USING '--------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02
   END IF
 
END FUNCTION
#No.FUN-810016
