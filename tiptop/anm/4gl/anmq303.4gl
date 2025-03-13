# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: anmq303.4gl 
# Descriptions...: 銀行對帳單查詢導入作業
# Date & Author..: Rayven 07/03/26
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-870067 08/07/17 By douzh  增加匯豐銀行導入對帳單接口
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nmu_file add nmu23
# Modify.........: No.FUN-B50159 11/05/30 By lutingting 畫面增加對帳碼nmu24
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-C50168 12/05/18 By xuxz 調整作業開啟條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nmu_hd        RECORD                       #單頭變數
        nmu03       LIKE nmu_file.nmu03,
        nmu04       LIKE nmu_file.nmu04,
        nmu05       LIKE nmu_file.nmu05
        END RECORD,
    g_nmu_hd_t      RECORD                       #單頭變數
        nmu03       LIKE nmu_file.nmu03,
        nmu04       LIKE nmu_file.nmu04,
        nmu05       LIKE nmu_file.nmu05
        END RECORD,
    g_nmu_hd_o      RECORD                       #單頭變數
        nmu03       LIKE nmu_file.nmu03,
        nmu04       LIKE nmu_file.nmu04,
        nmu05       LIKE nmu_file.nmu05
        END RECORD,
    g_nmu           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        nmu24       LIKE nmu_file.nmu24,    #FUN-B50159
        nmu01       LIKE nmu_file.nmu01,
        nmu02       LIKE nmu_file.nmu02,
        nmu15       LIKE nmu_file.nmu15,
        nmu06       LIKE nmu_file.nmu06,
        nmu19       LIKE nmu_file.nmu19,
        nmu20       LIKE nmu_file.nmu20,
        nmu08       LIKE nmu_file.nmu08,
        nmu09       LIKE nmu_file.nmu09,
        nmu10       LIKE nmu_file.nmu10,
        nmu11       LIKE nmu_file.nmu11,
        nmu13       LIKE nmu_file.nmu13,
        nmu14       LIKE nmu_file.nmu14,
        nmu16       LIKE nmu_file.nmu16,
        nmu12       LIKE nmu_file.nmu12
        END RECORD,
    g_nmu_t         RECORD                       #程式變數(舊值)
        nmu24       LIKE nmu_file.nmu24,    #FUN-B50159
        nmu01       LIKE nmu_file.nmu01,
        nmu02       LIKE nmu_file.nmu02,
        nmu15       LIKE nmu_file.nmu15,
        nmu06       LIKE nmu_file.nmu06,
        nmu19       LIKE nmu_file.nmu19,
        nmu20       LIKE nmu_file.nmu20,
        nmu08       LIKE nmu_file.nmu08,
        nmu09       LIKE nmu_file.nmu09,
        nmu10       LIKE nmu_file.nmu10,
        nmu11       LIKE nmu_file.nmu11,
        nmu13       LIKE nmu_file.nmu13,
        nmu14       LIKE nmu_file.nmu14,
        nmu16       LIKE nmu_file.nmu16,
        nmu12       LIKE nmu_file.nmu12
        END RECORD,
    g_wc            STRING,                      #WHERE CONDITION
    g_sql           STRING,   
    g_rec_b         LIKE type_file.num5,         #單身筆數
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT
DEFINE   g_before_input_done LIKE type_file.num5
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_cmd          LIKE type_file.chr1000
DEFINE   g_msg1         LIKE ze_file.ze03
DEFINE   g_msg2         LIKE ze_file.ze03
DEFINE   g_msg3         LIKE ze_file.ze03
DEFINE   g_msg4         LIKE ze_file.ze03
DEFINE   g_payee        LIKE type_file.num20_6
DEFINE   g_payer        LIKE type_file.num20_6
DEFINE   l_channel      base.Channel            #No.FUN-870067
 
MAIN
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
                                                                                
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ANM")) THEN                                               
       EXIT PROGRAM                                                             
    END IF
 
   #TQC-C50168--Mark--str
   #IF g_aza.aza73 = 'N' THEN
   #   CALL cl_err('','anm-980',1)
   #   EXIT PROGRAM
   #END IF
   #TQC-C50168--Mark--end
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
     
    INITIALIZE g_nmu_hd.* to NULL
    INITIALIZE g_nmu_hd_t.* to NULL
    INITIALIZE g_nmu_hd_o.* to NULL
 
    LET g_forupd_sql = "SELECT nmu03,nmu04,nmu05 FROM nmu_file WHERE nmu03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q303_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW q303_w WITH FORM "anm/42f/anmq303"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()         
 
    LET g_action_choice = ""                                              
    CALL q303_menu()  
    CLOSE WINDOW q303_w                         #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q303_curs()
    CLEAR FORM #清除畫面
    CALL cl_opmsg('q')
    CALL cl_set_head_visible("","YES")
   INITIALIZE g_nmu_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON nmu03,nmu04,nmu05, # 螢幕上取條件
                      nmu24,                 #FUN-B50159
                      nmu01,nmu02,nmu15,nmu06,nmu08,nmu09,
                      nmu10,nmu11,nmu13,nmu14,nmu16,nmu12
         FROM nmu03,nmu04,nmu05,
              s_nmu[1].nmu24,                #FUN-B50159
              s_nmu[1].nmu01,s_nmu[1].nmu02,s_nmu[1].nmu15,
              s_nmu[1].nmu06,s_nmu[1].nmu08,s_nmu[1].nmu09,
              s_nmu[1].nmu10,s_nmu[1].nmu11,s_nmu[1].nmu13,
              s_nmu[1].nmu14,s_nmu[1].nmu16,s_nmu[1].nmu12
 
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
         ON ACTION CONTROLP
             CASE
                 WHEN INFIELD(nmu03)
                     CALL cl_init_qry_var()    
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_nma"                              
                     CALL cl_create_qry() RETURNING g_qryparam.multiret       
                     DISPLAY g_qryparam.multiret TO nmu03
             END CASE
 
         ON IDLE g_idle_seconds                                              
            CALL cl_on_idle()                                                
 
         ON ACTION qbe_select
            CALL cl_qbe_select() 
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
            CONTINUE CONSTRUCT                                               
 
         ON ACTION about         
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help()  
    
         ON ACTION controlg      
            CALL cl_cmdask()     
 
    END CONSTRUCT   
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN 
        CALL q303_show()
        RETURN
    END IF
 
    LET g_sql = "SELECT UNIQUE nmu03 ",
                "  FROM nmu_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY nmu03"
    PREPARE q303_prepare FROM g_sql
    DECLARE q303_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q303_prepare
 
    LET g_sql_tmp = "SELECT UNIQUE nmu03 ",
                    "  FROM nmu_file ",
                    " WHERE ", g_wc CLIPPED,
                    " INTO TEMP x "
    DROP TABLE x
    PREPARE q303_pre_x FROM g_sql_tmp
    EXECUTE q303_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE q303_precnt FROM g_sql
    DECLARE q303_cnt CURSOR FOR q303_precnt
END FUNCTION
 
FUNCTION q303_menu()
   WHILE TRUE
      CALL q303_bp("G")
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL q303_q()
           END IF
        WHEN "online_download_bill"
          #TQC-C50168--add--str
           IF g_aza.aza73 = 'N' THEN
              CALL cl_err('','anm-159',1)
           ELSE
          #TQC-C50168--add--end
              IF cl_chk_act_auth() THEN
                 CALL q303_odb()
              END IF
           END IF #TQC-C50168 add
        WHEN "induct_the_bill"
           IF cl_chk_act_auth() THEN
              CALL q303_itb()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q303_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index, g_row_count)
    INITIALIZE g_nmu_hd TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_nmu.clear() 
    DISPLAY '     ' TO FORMONLY.cnt
    CALL q303_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN q303_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_nmu_hd TO NULL
    ELSE
        OPEN q303_cnt
        FETCH q303_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL q303_fetch('F')                     # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION q303_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1       #處理方式
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q303_cs INTO g_nmu_hd.nmu03
        WHEN 'P' FETCH PREVIOUS q303_cs INTO g_nmu_hd.nmu03
        WHEN 'F' FETCH FIRST    q303_cs INTO g_nmu_hd.nmu03
        WHEN 'L' FETCH LAST     q303_cs INTO g_nmu_hd.nmu03
        WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds                                          
                   CALL cl_on_idle()                                            
 
                ON ACTION about         
                   CALL cl_about()      
           
                ON ACTION help          
                   CALL cl_show_help()  
           
                ON ACTION controlg      
                   CALL cl_cmdask()     
                                                                                
            END PROMPT   
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q303_cs INTO g_nmu_hd.nmu03
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmu_hd.nmu03, SQLCA.sqlcode, 0)
        INITIALIZE g_nmu_hd.* TO NULL
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
    SELECT UNIQUE nmu03,nmu04,nmu05 INTO g_nmu_hd.nmu03,g_nmu_hd.nmu04,g_nmu_hd.nmu05
      FROM nmu_file
     WHERE nmu03 = g_nmu_hd.nmu03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","nmu_file",g_nmu_hd.nmu03,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_nmu TO NULL
        RETURN
    END IF
    CALL q303_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q303_show()
    LET g_nmu_hd_t.* = g_nmu_hd.*                     #保存單頭舊值
    LET g_nmu_hd_o.* = g_nmu_hd.*
    DISPLAY BY NAME g_nmu_hd.nmu03,g_nmu_hd.nmu04,    #顯示單頭值
                    g_nmu_hd.nmu05
 
    CALL q303_nmu03_04(g_nmu_hd.nmu03,g_nmu_hd.nmu04)
 
    CALL q303_b_fill(g_wc) #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION q303_b_fill(p_wc2)
DEFINE 
    p_wc2    STRING,      #NO.FUN-910082 
    l_cnt    LIKE type_file.num5
 
    LET g_sql =
        "SELECT nmu24,nmu01,nmu02,nmu15,nmu06,nmu19,nmu20,nmu08,nmu09,nmu10,",   #FUN-B50159 add nmu24
        "       nmu11,nmu13,nmu14,nmu16,nmu12",
        "  FROM nmu_file",
        " WHERE nmu03 = '", g_nmu_hd.nmu03, "'",
	"   AND ", p_wc2 CLIPPED,
        " ORDER BY nmu01,nmu02"
    PREPARE q303_pb 
       FROM g_sql
    DECLARE q303_bcs                             #SCROLL CURSOR
     CURSOR FOR q303_pb
 
    CALL g_nmu.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_payee = 0
    LET g_payer = 0
    FOREACH q303_bcs INTO g_nmu[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
        #FUN-B50159--add--str--
        IF cl_null(g_nmu[g_cnt].nmu24) THEN
           LET g_nmu[g_cnt].nmu24 = 'N'
        END IF 
        #FUN-B50159--add--end

        IF g_nmu[g_cnt].nmu09 = 1 THEN
           IF NOT cl_null(g_nmu[g_cnt].nmu10) THEN
              LET g_payee = g_payee + g_nmu[g_cnt].nmu10
           END IF
        END IF
        IF g_nmu[g_cnt].nmu09 = -1 THEN
           IF NOT cl_null(g_nmu[g_cnt].nmu10) THEN
              LET g_payer = g_payer + g_nmu[g_cnt].nmu10
           END IF
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nmu.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    DISPLAY g_payee TO FORMONLY.payee_amount
    DISPLAY g_payer TO FORMONLY.payer_amount
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION q303_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmu TO s_nmu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()    
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL q303_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
         EXIT DISPLAY              
 
      ON ACTION previous
         CALL q303_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
         EXIT DISPLAY                
 
      ON ACTION jump 
         CALL q303_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
         EXIT DISPLAY              
 
      ON ACTION next
         CALL q303_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
         EXIT DISPLAY              
 
      ON ACTION last 
         CALL q303_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION online_download_bill
         LET g_action_choice="online_download_bill"
         EXIT DISPLAY
 
      ON ACTION induct_the_bill
         LET g_action_choice="induct_the_bill"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q303_nmu03_04(l_nmu03,l_nmu04)
    DEFINE l_nmu03   LIKE nmu_file.nmu03
    DEFINE l_nmu04   LIKE nmu_file.nmu04
    DEFINE l_nma02   LIKE nma_file.nma02
    DEFINE l_nmt02   LIKE nmt_file.nmt02        
    DEFINE l_nmt12   LIKE nmt_file.nmt12                  #No.FUN-870067
 
    SELECT nma02 INTO l_nma02
      FROM nma_file
     WHERE nma01 = l_nmu03
 
#   SELECT nmt02 INTO l_nmt02                             #No.FUN-870067
    SELECT nmt02,nmt12 INTO l_nmt02,l_nmt12               #No.FUN-870067
      FROM nmt_file
     WHERE nmt01 = l_nmu04
    
#No.FUN-870067--begin
    IF l_nmt12 = g_aza.aza78 THEN
       CALL cl_set_comp_visible("nmu02,nmu06,nmu07,nmu20,nmu21,nmu22,",FALSE)
    ELSE
       CALL cl_set_comp_visible("nmu02,nmu06,nmu07,nmu20,nmu21,nmu22,",TRUE)
    END IF
#No.FUN-870067--end
    DISPLAY l_nma02 TO FORMONLY.nma02
    DISPLAY l_nmt02 TO FORMONLY.nmt02
END FUNCTION
 
FUNCTION q303_odb()
  DEFINE l_nmu03   LIKE nmu_file.nmu03
 
    CALL p301_tm(g_nmu_hd.nmu03)
         RETURNING l_nmu03
    IF cl_null(l_nmu03) THEN
       RETURN
    ELSE
       LET g_nmu_hd.nmu03 = l_nmu03
       SELECT nmu04,nmu05 INTO g_nmu_hd.nmu04,g_nmu_hd.nmu05
         FROM nmu_file
        WHERE nmu03 = g_nmu_hd.nmu03
       CALL q303_show()
    END IF
END FUNCTION
 
FUNCTION q303_itb()
  DEFINE l_locale       LIKE type_file.chr1000
  DEFINE l_file         LIKE type_file.chr50
  DEFINE l_cmd          LIKE type_file.chr1000
  DEFINE li_status      LIKE type_file.num10
  DEFINE tok            base.StringTokenizer
  DEFINE l_loc          String
  DEFINE l_pos          LIKE type_file.num5
  DEFINE l_pos2         LIKE type_file.num5
  DEFINE l_nma01        LIKE nma_file.nma01
  DEFINE l_nma04        LIKE nma_file.nma04
  DEFINE l_nma10        LIKE nma_file.nma10
  DEFINE l_nma39        LIKE nma_file.nma39
  DEFINE l_nmt09        LIKE nmt_file.nmt09
  DEFINE l_nmt12        LIKE nmt_file.nmt12
  DEFINE l_nmr02        LIKE nmr_file.nmr02
  DEFINE l_nmr021       LIKE nmr_file.nmr02
  DEFINE l_nmr03        LIKE nmr_file.nmr03
  DEFINE l_nmr031       LIKE nmr_file.nmr03
  DEFINE l_str          LIKE type_file.chr4
  DEFINE l_str1         String
  DEFINE l_str2         String
  DEFINE l_str3         String
  DEFINE l_str4         String
  DEFINE l_str5         LIKE type_file.chr18                    #No.FUN-870067
  DEFINE l_str6         String                                  #No.FUN-870067
  DEFINE l_str7         String                                  #No.FUN-870067
  DEFINE l_nmaacti      LIKE nma_file.nmaacti
  DEFINE l_nma43        LIKE nma_file.nma43
  DEFINE i,j,k          LIKE type_file.num5
  DEFINE data_array     DYNAMIC ARRAY OF STRING
  DEFINE field_array    DYNAMIC ARRAY OF STRING
  DEFINE str_array      DYNAMIC ARRAY OF STRING
  DEFINE l_tok_data     base.StringTokenizer
  DEFINE l_cnt_data     LIKE type_file.num5
  DEFINE l_tok_field    base.StringTokenizer 
  DEFINE l_cnt_field    LIKE type_file.num5
  DEFINE l_tok_str      base.StringTokenizer 
  DEFINE l_cnt_str      LIKE type_file.num5
  DEFINE field_str      STRING
  DEFINE sr             RECORD LIKE nmu_file.*
  DEFINE buf            base.StringBuffer
  DEFINE l_nmu          RECORD LIKE nmu_file.*
  DEFINE l_n            LIKE type_file.num5
  DEFINE p_file         LIKE type_file.chr1000
  DEFINE g_read         base.Channel
  DEFINE l_i            LIKE type_file.num5                   #No.FUN-870067
  DEFINE l_field        LIKE type_file.chr1                   #No.FUN-870067
  DEFINE l_date         LIKE type_file.dat                    #No.FUN-870067
  DEFINE l_chr          LIKE type_file.chr18                  #No.FUN-870067
  DEFINE l_type         LIKE type_file.chr1                   #No.FUN-870067
  DEFINE l_type2        LIKE type_file.chr1                   #No.FUN-870067
  DEFINE l_pos3         LIKE type_file.num5                   #No.FUN-870067
  DEFINE l_pos4         LIKE type_file.num5                   #No.FUN-870067
  DEFINE l_sum          LIKE nmu_file.nmu11                   #No.FUN-870067  #期初余額
  DEFINE l_chr5         LIKE type_file.chr5                   #No.FUN-870067
  DEFINE l_ze03         LIKE ze_file.ze03                     #No.FUN-870067
    
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nmu23    LIKE nmu_file.nmu23
#FUN-B30166--add--end

  WHENEVER ERROR CONTINUE
 
  INITIALIZE l_locale TO NULL
  INITIALIZE li_status TO NULL
  LET l_locale = cl_browse_file()
  IF cl_null(l_locale) THEN
     CALL cl_msgany(10,10,'give up!')
     RETURN
  END IF
 
  LET tok = base.StringTokenizer.create(l_locale,"/")
  WHILE tok.hasMoreTokens()
    LET l_loc = tok.nextToken()
  END WHILE
  
#No.FUN-870067--begin
  LET l_str5 = l_loc.subString(l_loc.getLength()-3,l_loc.getLength())
# LET l_str5 = l_loc.subString(1,l_loc.getLength()-5)
# IF l_str5 = 'LCDE.BLQSAM.OC5' THEN
  #判斷是否是HSBC專用的MT940文件
  IF l_str5 = '.940' THEN
 
     LET l_file = "/tmp/",l_loc
     CALL cl_upload_file(l_locale, l_file) RETURNING li_status
     IF NOT li_status THEN
        CALL cl_msgany(10,10,'upload fail!')
        RETURN
     END IF
     
     
     LET l_cmd = "cat /tmp/",l_loc," |u8togb > /tmp/temp_gb.txt"
     RUN l_cmd
     LET l_cmd = "cat /tmp/temp_gb.txt |gbtob5 > /tmp/temp.txt"
     RUN l_cmd
     LET l_cmd = "cat /tmp/temp.txt > /tmp/",l_loc
     RUN l_cmd
     LET l_file = "/tmp/",l_loc
     
     DROP TABLE nmu_temp
     
     CREATE TEMP TABLE nmu_temp( 
                 nmu01    LIKE nmu_file.nmu01,
                 nmu02    LIKE nmu_file.nmu02,
                 nmu03    LIKE nmu_file.nmu03,
                 nmu04    LIKE nmu_file.nmu04,
                 nmu05    LIKE nmu_file.nmu05,
                 nmu06    LIKE nmu_file.nmu06,
                 nmu07    LIKE nmu_file.nmu07,
                 nmu08    LIKE nmu_file.nmu08,
                 nmu09    LIKE nmu_file.nmu09,
                 nmu10    LIKE nmu_file.nmu10,
                 nmu11    LIKE nmu_file.nmu11,
                 nmu12    LIKE nmu_file.nmu12,
                 nmu13    LIKE nmu_file.nmu13,
                 nmu14    LIKE nmu_file.nmu14,
                 nmu15    LIKE nmu_file.nmu15,
                 nmu16    LIKE nmu_file.nmu16,
                 nmu17    LIKE nmu_file.nmu17,
                 nmu18    LIKE nmu_file.nmu18,
                 nmu19    LIKE nmu_file.nmu19,
                 nmu20    LIKE nmu_file.nmu20,
                 nmu21    LIKE nmu_file.nmu21,
                 nmu22    LIKE nmu_file.nmu22);
      DELETE FROM nmu_temp
     
      LET g_read = base.Channel.create()
      CALL g_read.openFile(l_file,"r")
     
     WHILE TRUE
        LET l_str1 = ""
        LET l_str1 = g_read.readLine()
        LET l_str2 = l_str1.subString(1,1)
        LET l_str3 = l_str1.subString(4,4)
        LET l_chr = NULL
 
        IF NOT cl_null(l_str1)  THEN
           IF l_str2 = ':' THEN
              IF l_str2 = l_str3 THEN
                 LET l_str4 = l_str1.subString(2,3)
                 LET l_str1 = l_str1.subString(5,l_str1.getLength())
              ELSE
                 LET l_str4 = l_str1.subString(2,4)
                 LET l_str1 = l_str1.subString(6,l_str1.getLength())
              END IF
           ELSE
              LET l_str4 = NULL
           END IF
           CASE l_str4
               WHEN '25'
                  LET l_nma04 = l_str1.trim()
                  SELECT nma01,nmaacti,nma43 INTO l_nma01,l_nmaacti,l_nma43
                    FROM nma_file
                   WHERE nma04 = l_nma04
                  IF SQLCA.sqlcode OR l_nmaacti <> 'Y' OR l_nma43 <> 'Y' THEN
                     CALL cl_err('','anm-977',1)
                     RETURN
                  END IF
                 
                  SELECT nma39,nma04,nma10 INTO l_nma39,l_nma04,l_nma10
                   FROM nma_file
                  WHERE nma01 = l_nma01
                 
                  SELECT nmt09,nmt12 INTO l_nmt09,l_nmt12
                    FROM nmt_file
                   WHERE nmt01 = l_nma39
                  LET sr.nmu03 = l_nma01
                  LET sr.nmu04 = l_nma39
                  LET sr.nmu05 = l_nma04
                  LET sr.nmu17 = l_nmt09
                  LET sr.nmu18 = l_nmt12
 
               WHEN '61' 
                  LET l_pos = l_str1.getindexof(',',5)
                  LET l_pos4 = l_str1.getindexof('/',5)
                  LET l_str6 = l_str1.subString(1,l_pos)
                  LET l_date = l_str6.subString(1,6)
                  LET sr.nmu01 = l_date
                  LET l_field = l_str6.subString(12,12)
                  CALL cl_numchk(l_field,1) RETURNING l_i
                  IF l_i = 0 THEN
                     LET l_type2 = l_str6.subString(11,12)
                     IF l_type2 = 'RC' THEN
                        LET sr.nmu09 = '-1'
                     ELSE
                        LET sr.nmu09 = '+1'
                     END IF
                     LET l_pos2   = l_pos+2
                     LET l_chr = l_str1.subString(13,l_pos2) 
                  ELSE
                     LET l_type2 = l_str6.subString(11,11)
                     IF l_type2 = 'D' THEN
                        LET sr.nmu09 = '-1'
                     ELSE
                        LET sr.nmu09 = '+1'
                     END IF                  	
                     LET l_pos2   = l_pos+2 
                     LET l_chr = l_str1.subString(12,l_pos2)
                  END IF
                  LET l_chr = cl_replace_str(l_chr,",",".")
                  LET sr.nmu10 = l_chr
                  IF NOT cl_null(l_sum) OR l_sum > sr.nmu10 THEN
                     LET sr.nmu11 = l_sum-sr.nmu10
                     LET l_sum = sr.nmu11
                  END IF
                  LET l_pos3 = l_pos2+1
                  LET l_type = l_str1.subString(l_pos3,l_pos3+1)
                  IF l_type = 'S' THEN
                     LET sr.nmu15 = l_str1.subString(l_pos3,l_pos3+4)
                     LET sr.nmu14 = l_str1.subString(l_pos3+5,l_pos4-1)
                  ELSE
                     LET sr.nmu15 = l_str1.subString(l_pos3+1,l_pos3+3)
                     LET sr.nmu14 = l_str1.subString(l_pos3+4,l_pos4-1)
                  END IF 
                   
               WHEN '86'
                  LET l_chr5 = l_str1.subString(1,5)
                  IF l_chr5 = 'TOTAL' THEN
                     LET sr.nmu13 = l_str1.trim() 
                  ELSE
                     LET l_chr5 = NULL
                     LET sr.nmu13 = NULL
                     LET sr.nmu16 = l_str1.trim()
                  END IF 
               
               WHEN '60F'
                  LET sr.nmu08 = l_str1.subString(8,10)
                  LET l_chr = l_str1.subString(11,l_str1.getLength())
                  LET l_chr = cl_replace_str(l_chr,",",".")
                  LET l_sum = l_chr
 
               WHEN '62F'
                  LET sr.nmu11 = l_str1.subString(11,l_str1.getLength())
 
               OTHERWISE  
                  IF l_chr5 ='TOTAL' THEN
                     LET l_tok_field = base.StringTokenizer.create(l_str1," ")
                     LET l_cnt_field = l_tok_field.countTokens()
                     LET sr.nmu16  = l_tok_field.nextToken()
                     IF l_cnt_field >0 THEN 
                        LET k=0
                        WHILE l_tok_field.hasMoreTokens()
                           LET k=k+1
                           LET field_array[k]=l_tok_field.nextToken()
                           IF sr.nmu15 = 'TRF' THEN
                              SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'anm-335' AND ze02 = '2'
                              LET sr.nmu19 = l_ze03
                              LET sr.nmu12 = l_str1.subString(11,l_str1.getLength())
                           ELSE
                              IF k=1 THEN
                                 SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = 'anm-336' AND ze02 = '2'
                                 LET sr.nmu19 = l_ze03
                                 LET l_str7 =sr.nmu16 CLIPPED
                              END IF
                              IF k >=2 THEN
                                 LET sr.nmu12 = l_str1.subString(l_str7.getlength()+1,l_str1.getlength())
                              END IF
                           END IF
                        END WHILE
                     END IF
                     IF l_str2 !=':' THEN
                        LET sr.nmu16 = l_str1.subString(1,10)
                     ELSE
                        EXIT CASE
                     END IF
                  ELSE
                     IF l_str2 !=':' THEN
                        LET l_tok_field = base.StringTokenizer.create(l_str1," ")
                        LET l_cnt_field = l_tok_field.countTokens()
                        IF l_cnt_field >0 THEN 
                           LET k=0
                           WHILE l_tok_field.hasMoreTokens()
                             LET k=k+1
                             LET field_array[k]=l_tok_field.nextToken()
                             IF k=1 THEN
                                LET sr.nmu19=field_array[k] 
                                LET l_str7 = sr.nmu19
                             END IF
                             IF k >=2 THEN
                                LET sr.nmu12 = l_str1.subString(l_str7.getlength()+1,l_str1.getlength())
                             END IF
                           END WHILE
                        END IF
                     ELSE
                        EXIT CASE
                     END IF
                  END IF
           END CASE 
        END IF
     
        IF NOT cl_null(l_str1) AND l_str2 != ':' THEN
           IF l_str1 !='-' THEN
              INSERT INTO nmu_temp VALUES(sr.*)
              IF SQLCA.sqlcode THEN
                 CALL cl_err('insert into temptable:',SQLCA.sqlcode,1)
                 RETURN
              ELSE
                 LET sr.nmu12 = NULL
                 LET l_chr5=NULL
              END IF      
           END IF
        END IF
 
        IF cl_null(l_str1) AND l_str2 = ':' THEN
           CONTINUE WHILE
        END IF
 
        IF cl_null(l_str1) AND cl_null(l_str2)  THEN
           EXIT WHILE
        END IF
        
        CONTINUE WHILE
     END WHILE
  ELSE
#No.FUN-870067--end
     LET l_str = l_loc.subString(l_loc.getLength()-2,l_loc.getLength())
     IF l_str <> 'act' THEN
        LET l_str = l_loc.subString(l_loc.getLength()-3,l_loc.getLength())
        IF l_str <> 'eact' THEN
           CALL cl_err('','anm-975',1)
           RETURN
        ELSE
           LET l_loc = l_loc.subString(1,l_loc.getLength()-5)
        END IF
     ELSE
        LET l_loc = l_loc.subString(1,l_loc.getLength()-4)
     END IF
     LET l_nmr03 = l_loc.subString(l_loc.getLength()-5,l_loc.getLength())
     LET l_loc = l_loc.subString(1,l_loc.getLength()-7)
     LET l_nmr02 = l_loc.subString(l_loc.getLength()-5,l_loc.getLength())
     LET l_loc = l_loc.subString(1,l_loc.getLength()-7)
     LET l_nma04 = l_loc
     
     SELECT nma01,nmaacti,nma43 INTO l_nma01,l_nmaacti,l_nma43
       FROM nma_file
      WHERE nma04 = l_nma04
     IF SQLCA.sqlcode OR l_nmaacti <> 'Y' OR l_nma43 <> 'Y' THEN
        CALL cl_err('','anm-977',1)
        RETURN
     END IF
     IF cl_null(l_nmr02) OR cl_null(l_nmr03) THEN
        CALL cl_err('','anm-976',1)
        RETURN
     END IF
     IF l_nmr03 < l_nmr02 THEN
        CALL cl_err('','mfg9234',1)
        RETURN
     END IF
     SELECT nmr02,nmr03 INTO l_nmr021,l_nmr031
       FROM nmr_file
      WHERE nmr01 = l_nma01
     IF l_nmr02 = l_nmr021 AND l_nmr03 = l_nmr031 THEN
        IF NOT cl_confirm('anm-258') THEN
           RETURN
        END IF
     END IF
     IF l_nmr02 > l_nmr031 THEN
        CALL cl_getmsg('anm-254',g_lang) RETURNING g_msg2
        CALL cl_getmsg('anm-256',g_lang) RETURNING g_msg3
        LET g_msg4 = l_nmr031
        LET g_msg1 = g_msg2 CLIPPED,g_msg4 CLIPPED,g_msg3 CLIPPED  
        IF NOT cl_confirm(g_msg1) THEN
           RETURN
        END IF
     END IF
     IF l_nmr03 < l_nmr021 THEN
        CALL cl_getmsg('anm-255',g_lang) RETURNING g_msg2
        CALL cl_getmsg('anm-256',g_lang) RETURNING g_msg3
        LET g_msg4 = l_nmr021
        LET g_msg1 = g_msg2 CLIPPED,g_msg4 CLIPPED,g_msg3 CLIPPED  
        IF NOT cl_confirm(g_msg1) THEN
           RETURN
        END IF
     END IF
     
     SELECT nma39,nma04,nma10 INTO l_nma39,l_nma04,l_nma10
       FROM nma_file
      WHERE nma01 = l_nma01
     
     SELECT nmt09,nmt12 INTO l_nmt09,l_nmt12
       FROM nmt_file
      WHERE nmt01 = l_nma39
     LET sr.nmu03 = l_nma01
     LET sr.nmu04 = l_nma39
     LET sr.nmu05 = l_nma04
     LET sr.nmu08 = l_nma10
     LET sr.nmu17 = l_nmt09
     LET sr.nmu18 = l_nmt12
     
     LET l_file = "/tmp/",l_loc
     CALL cl_upload_file(l_locale, l_file) RETURNING li_status
     IF NOT li_status THEN
        CALL cl_msgany(10,10,'upload fail!')
        RETURN
     END IF
     
      LET l_cmd = "cat /tmp/",l_loc," |gbtob5 > /tmp/temp.txt"
      RUN l_cmd
      LET l_cmd = "cat /tmp/temp.txt > /tmp/",l_loc
      RUN l_cmd
      LET l_file = "/tmp/",l_loc
     
     DROP TABLE nmu_temp
     
     CREATE TEMP TABLE nmu_temp( 
                 nmu01    LIKE nmu_file.nmu01,
                 nmu02    LIKE nmu_file.nmu02,
                 nmu03    LIKE nmu_file.nmu03,
                 nmu04    LIKE nmu_file.nmu04,
                 nmu05    LIKE nmu_file.nmu05,
                 nmu06    LIKE nmu_file.nmu06,
                 nmu07    LIKE nmu_file.nmu07,
                 nmu08    LIKE nmu_file.nmu08,
                 nmu09    LIKE nmu_file.nmu09,
                 nmu10    LIKE nmu_file.nmu10,
                 nmu11    LIKE nmu_file.nmu11,
                 nmu12    LIKE nmu_file.nmu12,
                 nmu13    LIKE nmu_file.nmu13,
                 nmu14    LIKE nmu_file.nmu14,
                 nmu15    LIKE nmu_file.nmu15,
                 nmu16    LIKE nmu_file.nmu16,
                 nmu17    LIKE nmu_file.nmu17,
                 nmu18    LIKE nmu_file.nmu18,
                 nmu19    LIKE nmu_file.nmu19,
                 nmu20    LIKE nmu_file.nmu20,
                 nmu21    LIKE nmu_file.nmu21,
                 nmu22    LIKE nmu_file.nmu22);
       DELETE FROM nmu_temp
     
     LET g_read = base.Channel.create()
     CALL g_read.openFile(l_file,"r")
     
     WHILE TRUE
        LET l_str1 = ""
        LET l_str1 = g_read.readLine()
        LET l_str2 = l_str1.subString(l_str1.getLength(),l_str1.getLength())
        IF NOT cl_null(l_str1) AND l_str2 = '\r' THEN
           LET l_str1 = l_str1.subString(1,l_str1.getLength()-1)
        END IF
     
        IF cl_null(l_str1) AND l_str2 = '\r' THEN
           CONTINUE WHILE
        END IF
        IF cl_null(l_str1) AND cl_null(l_str2) THEN
           EXIT WHILE
        END IF
     
        LET field_str = l_str1
        LET l_tok_field = base.StringTokenizer.create(field_str," ;")
        LET l_cnt_field = l_tok_field.countTokens()
        IF l_cnt_field >0 THEN 
           CALL field_array.clear()
           INITIALIZE sr.* TO NULL
           LET k=0
           WHILE l_tok_field.hasMoreTokens()
              LET k=k+1
              LET field_array[k]=l_tok_field.nextToken()
           END WHILE
        END IF
        FOR k = 1 TO l_cnt_field
            LET l_str3 = field_array[k]
            LET l_tok_str = base.StringTokenizer.create(l_str3,"=")
            LET l_cnt_str = l_tok_str.countTokens()
            IF l_cnt_str > 0 THEN
               CALL str_array.clear()
               LET i = 0
               WHILE l_tok_str.hasMoreTokens()
                  LET i = i+1
                  LET str_array[i] = l_tok_str.nextToken()
               END WHILE
               CASE str_array[1]
                 WHEN "ETYDAT"
                   LET sr.nmu01 = str_array[2]
                 WHEN "ETYTIM"
                   LET sr.nmu02 = str_array[2]                       
                 WHEN "RPYACC"
                   LET sr.nmu06 = str_array[2]
                 WHEN "GSBACC"
                   LET sr.nmu07 = str_array[2]
                 WHEN "TRSAMTD"
                   IF str_array[2] >0 THEN 
                      LET sr.nmu09 = -1
                      LET sr.nmu10 = str_array[2]
                   END IF 
                 WHEN "TRSAMTC"
                   IF str_array[2] > 0 THEN 
                      LET sr.nmu09 = 1
                      LET sr.nmu10 = str_array[2]
                   END IF 
                 WHEN "TRSBLV"
                   LET sr.nmu11 = str_array[2]
                 WHEN "BUSNAR"
                   LET sr.nmu12 = str_array[2]
                 WHEN "NARYUR"
                   LET sr.nmu13 = str_array[2]
                 WHEN "YURREF"
                   LET sr.nmu14 = str_array[2]
                 WHEN "TRSCOD"
                   LET sr.nmu15 = str_array[2]
                 WHEN "REFNBR"
                   LET sr.nmu16 = str_array[2]
                 WHEN "RPYNAM"
                   LET sr.nmu19 = str_array[2]
                 WHEN "RPYBNK"
                   LET sr.nmu20 = str_array[2]
                 WHEN "GSBNAM"
                   LET sr.nmu21 = str_array[2]
                 WHEN "INFFLG"
                   LET sr.nmu22 = str_array[2]
                 OTHERWISE EXIT CASE
               END CASE
            END IF
        END FOR
        INSERT INTO nmu_temp VALUES(sr.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err('insert into temptable:',SQLCA.sqlcode,1)
           RETURN
        END IF 
     
        CONTINUE WHILE
     END WHILE
     
  END IF                             #No.FUN-870067--end     
       BEGIN WORK
       DECLARE q303_cs1 CURSOR FOR SELECT * FROM nmu_temp
       FOREACH q303_cs1 INTO l_nmu.*
#No.FUN-870067--begin
          IF l_str5 = '.940' THEN
             LET l_nmu.nmu03 = l_nma01
             LET l_nmu.nmu04 = l_nma39
             LET l_nmu.nmu05 = l_nma04
             LET l_nmu.nmu08 = l_nma10
             LET l_nmu.nmu17 = l_nmt09
             LET l_nmu.nmu18 = l_nmt12
             IF cl_null(l_nmu.nmu13) THEN 
                LET l_nmu.nmu13 = ' '
             ELSE
                IF l_nmu.nmu13='TOTAL CHARGE:' THEN
                   LET l_nmu.nmu15 = 'CHG'
                END IF
             END IF
 
             #FUN-980005 add legal 
             LET l_nmu.nmulegal = g_legal 
             #FUN-980005 add legal 
 
#FUN-B30166--add--str
             LET l_date1 = g_today
             LET l_year = YEAR(l_date1)USING '&&&&'
             LET l_month = MONTH(l_date1) USING '&&'
             LET l_day = DAY(l_date1) USING  '&&'
             LET l_time = TIME(CURRENT)
             LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                          l_time[1,2],l_time[4,5],l_time[7,8]
             SELECT MAX(nmu23) + 1 INTO l_nmu.nmu23 FROM nmu_file
              WHERE nmu23[1,14] = l_dt
             IF cl_null(l_nmu.nmu23) THEN
                LET l_nmu.nmu23 = l_dt,'000001'
             END if
#FUN-B30166--add--end

             INSERT INTO nmu_file VALUES(l_nmu.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err('insert into nmu_file:',SQLCA.sqlcode,1)
                ROLLBACK WORK
                RETURN
             END IF 
          ELSE
#No.FUN-870067--end
             SELECT COUNT(*) INTO l_n FROM nmu_file 
              WHERE nmu01 = l_nmu.nmu01 
                AND nmu17 = l_nmt09 
                AND nmu18 = l_nmt12
                AND nmu16 = l_nmu.nmu16
                AND nmu03 = l_nma01
             IF l_n >0 THEN 
                CONTINUE FOREACH 
             ELSE 
                LET l_nmu.nmu03 = l_nma01
                LET l_nmu.nmu04 = l_nma39
                LET l_nmu.nmu05 = l_nma04
                LET l_nmu.nmu08 = l_nma10
                LET l_nmu.nmu17 = l_nmt09
                LET l_nmu.nmu18 = l_nmt12
                IF cl_null(l_nmu.nmu13) THEN LET l_nmu.nmu13 = ' ' END IF   #No.FUN-870067
 
                #FUN-980005 add legal 
                LET l_nmu.nmulegal = g_legal 
                #FUN-980005 add legal 
 
                INSERT INTO nmu_file VALUES(l_nmu.*)
                IF SQLCA.sqlcode THEN
                   CALL cl_err('insert into nmu_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   RETURN
                END IF 
             END IF 
          END IF                                    #No.FUN-870067
       END FOREACH      
       SELECT COUNT(*) INTO l_n FROM nmr_file 
        WHERE nmr01 = l_nma01
       IF l_n = 0 THEN 
          INSERT INTO nmr_file VALUES(l_nma01,l_nmr02,l_nmr03,g_legal) #FUN-980005 add legal 
          IF SQLCA.sqlcode THEN 
             CALL cl_err('insert nmr_file',SQLCA.sqlcode,1)
             ROLLBACK WORK
             RETURN 
          END IF 
       ELSE
          CASE 
            WHEN l_nmr03 < l_nmr021  
              UPDATE nmr_file SET nmr02 = l_nmr02, 
                                  nmr03 = l_nmr03
               WHERE nmr01 = l_nma01
              IF SQLCA.sqlcode THEN 
                 CALL cl_err('',SQLCA.sqlcode,1)
                 ROLLBACK WORK
                 RETURN 
              END IF  
            WHEN l_nmr02 < l_nmr021 AND l_nmr03 >= l_nmr021 AND l_nmr03 <= l_nmr031
              UPDATE nmr_file SET nmr02 = l_nmr02
               WHERE nmr01 = l_nma01
              IF SQLCA.sqlcode THEN 
                 CALL cl_err('',SQLCA.sqlcode,1)
                 ROLLBACK WORK
                 RETURN 
              END IF 
            WHEN l_nmr03 > l_nmr031 AND l_nmr02 >= l_nmr021 AND l_nmr02 <= l_nmr031
              UPDATE nmr_file SET nmr03 = l_nmr03
               WHERE nmr01 = l_nma01
              IF SQLCA.sqlcode THEN 
                 CALL cl_err('',SQLCA.sqlcode,1) #No.FUN-B80067---調整至回滾事務前---
                 ROLLBACK WORK
                 RETURN 
              END IF 
            WHEN l_nmr03 > l_nmr031 AND l_nmr02 < l_nmr021 
              UPDATE nmr_file SET nmr02 = l_nmr02,
                                  nmr03 = l_nmr03
               WHERE nmr01 = l_nma01
              IF SQLCA.sqlcode THEN  
                 CALL cl_err('',SQLCA.sqlcode,1) #No.FUN-B80067---調整至回滾事務前---
                 ROLLBACK WORK
                 RETURN 
              END IF 
            OTHERWISE EXIT CASE 
          END CASE 
       END IF   
     
       COMMIT WORK
     
       LET g_nmu_hd.nmu03 = l_nmu.nmu03
       LET g_nmu_hd.nmu04 = l_nmu.nmu04
       LET g_nmu_hd.nmu05 = l_nmu.nmu05
       LET g_wc = "nmu03 = '",l_nmu.nmu03,"'"
       IF cl_null(l_nmu.nmu03) THEN
          CLEAR FORM
          CALL cl_err('','anm-259',1)
       END IF
 
       CALL q303_show()
END FUNCTION
 
FUNCTION q303_str(p_file)
  DEFINE p_file     LIKE type_file.chr1000
  DEFINE g_read     base.Channel
  DEFINE l_str      String
  DEFINE l_str2     String
  DEFINE l_str3     String
 
  LET g_read = base.Channel.create()
  CALL g_read.openFile(p_file,"r")
 
  WHILE TRUE
     LET l_str = ""
     LET l_str = g_read.readLine()
     LET l_str2 = l_str2,l_str CLIPPED
     LET l_str3 = l_str2.subString(l_str2.getLength(),l_str2.getLength())
     IF NOT cl_null(l_str) AND l_str3 = '\r' THEN
        LET l_str2 = l_str2.subString(1,l_str2.getLength()-1)
     END IF
 
     IF cl_null(l_str) THEN
        EXIT WHILE
     END IF
     CONTINUE WHILE
  END WHILE
 
  RETURN l_str2
END FUNCTION
