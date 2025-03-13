# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: acot772.4gl
# Descriptions...: 進口材料明細資料維護作業(電子帳冊) 
# Date & Author..: FUN-930151 09/04/01 BY rainy 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  p_row,p_col     LIKE type_file.num5,
        g_rec_b         LIKE type_file.num5,     #單身筆數
        g_row_count     LIKE type_file.num10,
        g_curs_index    LIKE type_file.num10,
        g_sql           STRING,
        g_wc            STRING,
        g_msg           STRING,
        g_void           LIKE type_file.chr1,
        g_forupd_sql         STRING
 
DEFINE tm              RECORD               #設置公用信息使用
         ceu08      LIKE ceu_file.ceu08,
         ceu25   LIKE ceu_file.ceu25,
         ceu28   LIKE ceu_file.ceu28,
         ceu30   LIKE ceu_file.ceu30,
         ceu24   LIKE ceu_file.ceu24,
         ceu26   LIKE ceu_file.ceu26,
         ceu27   LIKE ceu_file.ceu27,
         ceu29   LIKE ceu_file.ceu29,
         ceu32   LIKE ceu_file.ceu32,
         ceu33   LIKE ceu_file.ceu33 
                    END RECORD
 
 
DEFINE tm_t              RECORD               #設置公用信息使用(舊值)
         ceu08   LIKE ceu_file.ceu08,
         ceu25   LIKE ceu_file.ceu25,
         ceu28   LIKE ceu_file.ceu28,
         ceu30   LIKE ceu_file.ceu30,
         ceu24   LIKE ceu_file.ceu24,
         ceu26   LIKE ceu_file.ceu26,
         ceu27   LIKE ceu_file.ceu27,
         ceu29   LIKE ceu_file.ceu29,
         ceu32   LIKE ceu_file.ceu32,
         ceu33   LIKE ceu_file.ceu33 
                    END RECORD                    
 
DEFINE  l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT   
DEFINE  g_cnt           LIKE type_file.num10           
DEFINE  g_login_cnt     LIKE type_file.num5     #是否第一LOGIN設置畫面，1--第一次
DEFINE  g_jump          LIKE type_file.num10
DEFINE  g_no_ask        LIKE type_file.num5
 
 
DEFINE
    g_ceu         RECORD                 #單頭    
        ceu01    LIKE ceu_file.ceu01,   #單據編號 
        ceu03    LIKE ceu_file.ceu03,   #單據日期
        ceu05    LIKE ceu_file.ceu05,   #廠商編號
        ceu06    LIKE ceu_file.ceu06,   #廠商簡稱
        ceu08    LIKE ceu_file.ceu08,   #報單日期
        ceu25    LIKE ceu_file.ceu25,   #提運單號
        ceu17    LIKE ceu_file.ceu17,   #海關代號
        ceu28    LIKE ceu_file.ceu28,   #批準文號 
        ceu30    LIKE ceu_file.ceu30,   #進口報關單號
        ceu24    LIKE ceu_file.ceu24,   #交運方式
        ged02    LIKE ged_file.ged02,
        ceu26    LIKE ceu_file.ceu26,   #貿易方式
        cea02    LIKE cea_file.cea02,
        ceu27    LIKE ceu_file.ceu27,   #成交方式
        ced02    LIKE ced_file.ced02,
        ceu29    LIKE ceu_file.ceu29,   #用途
        cec02    LIKE cec_file.cec02, 
        ceu32    LIKE ceu_file.ceu32,   #產銷國
        geb02    LIKE geb_file.geb02,
        ceu33    LIKE ceu_file.ceu33,   #征免方式
        cnc02    LIKE cnc_file.cnc02,
        ceuconf  LIKE ceu_file.ceuconf, #確認碼                
        ceu21    LIKE ceu_file.ceu21,   #審核日期 
        ceu11    LIKE ceu_file.ceu11,   #Invoice
        ceu09    LIKE ceu_file.ceu09,   #異動方式
        ceuacti  LIKE ceu_file.ceuacti,
        ceuuser  LIKE ceu_file.ceuuser,
        ceugrup  LIKE ceu_file.ceugrup,
        ceumodu  LIKE ceu_file.ceumodu,
        ceudate  LIKE ceu_file.ceudate
                    END RECORD,
                    
    g_ceu_t         RECORD                 #單頭    
        ceu08   LIKE ceu_file.ceu08,
        ceu25   LIKE ceu_file.ceu25,
        ceu17   LIKE ceu_file.ceu17,
        ceu28   LIKE ceu_file.ceu28,
        ceu30   LIKE ceu_file.ceu30,
        ceu24   LIKE ceu_file.ceu24,
        ceu26   LIKE ceu_file.ceu26,
        ceu27   LIKE ceu_file.ceu27,
        ceu29   LIKE ceu_file.ceu29,
        ceu32   LIKE ceu_file.ceu32,
        ceu33   LIKE ceu_file.ceu33
                    END RECORD,                    
 
     g_ceu_b        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ceu02    LIKE ceu_file.ceu02,   #項次
        ceu04    LIKE ceu_file.ceu04,   #料件編號
        ima02    LIKE ima_file.ima02,   #
        ima021   LIKE ima_file.ima021,  #
        ceu15    LIKE ceu_file.ceu15,   #異動數量
        ceu16    LIKE ceu_file.ceu16,   #異動單位 
        pmn31t   LIKE pmn_file.pmn31t,  #稅後單價
        pmn88t   LIKE pmn_file.pmn88t,  #稅後金額
        pmm22    LIKE pmm_file.pmm22,   #幣別
        ceu10    LIKE ceu_file.ceu10,   #商品編號
        ceu31    LIKE ceu_file.ceu31,   #歸併後序號
        cei12    LIKE cei_file.cei12,   #歸併後品名
        cei13    LIKE cei_file.cei13    #歸併後規格
                    END RECORD
 
                    
MAIN
   OPTIONS                                #改變一些系統預設值
     INPUT NO WRAP,
     FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)   RETURNING g_time    #計算使用時間 (進入時間)  
 
   LET g_forupd_sql = "SELECT ceu08,ceu25,ceu17,ceu28,ceu30,",
                      "       ceu24,ceu26,ceu27,ceu29,ceu32,ceu33",
                      "  FROM ceu_file ",
                      " WHERE ceu01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t772_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 3 LET g_login_cnt=1
   OPEN WINDOW t772_w AT p_row,p_col WITH FORM "aco/42f/acot772"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)    
   CALL cl_ui_init()
   CALL t772_menu()
   CLOSE WINDOW t772_w                                  #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間)             
END MAIN
 
 
 
FUNCTION t772_cs()
  CLEAR FORM
  CALL g_ceu_b.clear()
 
  CALL cl_set_head_visible("","YES")
  INITIALIZE g_ceu.* TO NULL    
 
  CONSTRUCT BY NAME g_wc ON ceu01,ceu03,ceu05,ceu06,ceu09,ceu11,ceu08,
                    ceu25,ceu17,ceu28,ceu30,ceuconf,ceu21,
                    ceu24,ceu26,ceu27,ceu29,ceu32,ceu33,
                    ceuuser,ceugrup,ceumodu,ceudate,ceuacti                    
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE WHEN INFIELD(ceu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ceu01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ceu01
            WHEN INFIELD(ceu05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_pmc"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ceu05
            WHEN INFIELD(ceu17) #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_cna"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ceu17
            WHEN INFIELD(ceu24) #交運方式
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_ged"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ceu24
            WHEN INFIELD(ceu26) #貿易方式
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_cea01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ceu26
            WHEN INFIELD(ceu27) #成交方式
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_ced01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ceu27
            WHEN INFIELD(ceu29)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cec01"
                 LET g_qryparam.default1 = g_ceu.ceu29
                 CALL cl_create_qry() RETURNING g_ceu.ceu29
                 DISPLAY BY NAME g_ceu.ceu29
            WHEN INFIELD(ceu32)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_geb"
                 LET g_qryparam.default1 = g_ceu.ceu32
                 CALL cl_create_qry() RETURNING g_ceu.ceu32
                 DISPLAY BY NAME g_ceu.ceu32
            WHEN INFIELD(ceu33)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cnc"
                 LET g_qryparam.default1 = g_ceu.ceu33
                 CALL cl_create_qry() RETURNING g_ceu.ceu33
                 DISPLAY BY NAME g_ceu.ceu33
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ceuuser', 'ceugrup') #FUN-980030
     
  IF INT_FLAG THEN 
     RETURN 
  END IF  
 
  LET g_sql= "SELECT UNIQUE ceu01 FROM ceu_file ",
             " WHERE ", g_wc CLIPPED, 
             " ORDER BY ceu01"
  PREPARE t772_prepare FROM g_sql     
  DECLARE t772_cs SCROLL CURSOR WITH HOLD FOR t772_prepare
 
  LET g_sql="SELECT COUNT(DISTINCT ceu01) FROM ceu_file ",
            " WHERE ",g_wc CLIPPED
  PREPARE t772_precount FROM g_sql
  DECLARE t772_count CURSOR FOR t772_precount
END FUNCTION
 
 
 
FUNCTION t772_menu()
 
   WHILE TRUE
      CALL t772_bp("G")
      CASE g_action_choice        
         WHEN "default_data" 
            IF cl_chk_act_auth() THEN
               CALL t772_default_data()
            END IF
 
         WHEN "default_data_update"
            IF cl_chk_act_auth() THEN
              CALL t772_default_data_update()
            END IF
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t772_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t772_r()
            END IF
         
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t772_u()
            END IF
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t772_y()
               CALL t772_show_pic()
            END IF
            
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t772_z()
               CALL t772_show_pic()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ceu_b),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t772_q()
   DEFINE l_sql STRING  
   LET g_row_count=0
   LET g_curs_index=0
   CALL cl_navigator_setting(g_curs_index, g_row_count)
   INITIALIZE g_ceu.* TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t772_cs()               #取得查詢條件  
   IF INT_FLAG THEN
     LET INT_FLAG = 0
     INITIALIZE g_ceu.* TO NULL
     RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")
 
   OPEN t772_cs               # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ceu.* TO NULL
   ELSE
      CALL t772_fetch('F')                  # 讀出TEMP第一筆並顯示
      OPEN t772_count
      FETCH t772_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cn1     
   END IF
   CALL cl_msg("")
END FUNCTION
 
 
FUNCTION t772_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1  #處理方式 
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t772_cs INTO g_ceu.ceu01
        WHEN 'P' FETCH PREVIOUS t772_cs INTO g_ceu.ceu01
        WHEN 'F' FETCH FIRST    t772_cs INTO g_ceu.ceu01
        WHEN 'L' FETCH LAST     t772_cs INTO g_ceu.ceu01
        WHEN '/'
          IF (NOT g_no_ask) THEN 
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF  
          FETCH ABSOLUTE g_jump t772_cs INTO g_ceu.ceu01
          LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                         
        CALL cl_err(g_ceu.ceu01,SQLCA.sqlcode,0)
        INITIALIZE g_ceu.* TO NULL
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
             
    SELECT DISTINCT ceu01,ceu03,ceu05,ceu06,ceu09,
              ceu11,ceu08,ceu25,ceu17,
              ceu28,ceu30,ceu24,ceu26,ceu27,
              ceu29,ceu32,ceu33,ceuconf,ceu21,
              ceuacti,ceuuser,ceugrup,ceumodu,ceudate 
      INTO g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
           g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,g_ceu.ceu28,
           g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,g_ceu.ceu29,
           g_ceu.ceu32,g_ceu.ceu33,
           g_ceu.ceuconf,g_ceu.ceu21,
           g_ceu.ceuacti,g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,g_ceu.ceudate
      FROM ceu_file 
     WHERE ceu01=g_ceu.ceu01
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ceu_file",g_ceu.ceu01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ceu.* TO NULL
      RETURN
   END IF
   
  CALL t772_show()      
END FUNCTION
 
 
FUNCTION t772_show()
   DISPLAY BY NAME g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
                   g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,g_ceu.ceu28,
                   g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,g_ceu.ceu29,
                   g_ceu.ceu32,g_ceu.ceu33,
                   g_ceu.ceuconf,g_ceu.ceu21,
                   g_ceu.ceuacti,g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,
                   g_ceu.ceudate
   CALL t772_ceu24('d')
   CALL t772_ceu26('d')
   CALL t772_ceu27('d')
   CALL t772_ceu29('d')
   CALL t772_ceu32('d')
   CALL t772_ceu33('d')
   CALL t772_show_pic()
        
   CALL t772_b_fill(g_wc)                   #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
 
FUNCTION t772_ceu24(p_cmd) #交運方式
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_ged02         LIKE ged_file.ged02  
 
    LET g_errno = ' '
    SELECT ged02 INTO l_ged02
      FROM ged_file
     WHERE ged01 = g_ceu.ceu24
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-309'
                            LET g_ceu.ged02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu.ged02 = l_ged02
       DISPLAY BY NAME g_ceu.ged02
    END IF 
END FUNCTION                                                                    
 
 
FUNCTION t772_ceu26(p_cmd) #貿易方式
DEFINE
    p_cmd         LIKE type_file.chr1,
    l_cea02       LIKE cea_file.cea02,  
    l_ceaacti     LIKE cea_file.ceaacti
 
    LET g_errno = ' '
    SELECT cea02,ceaacti 
      INTO l_cea02,l_ceaacti
      FROM cea_file
     WHERE cea01 = g_ceu.ceu26
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-700'
                            LET g_ceu.cea02 = NULL
         WHEN l_ceaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu.cea02 = l_cea02
       DISPLAY BY NAME g_ceu.cea02
    END IF 
END FUNCTION                                                                    
 
 
FUNCTION t772_ceu29(p_cmd) 
DEFINE
    p_cmd        LIKE type_file.chr1,
    l_cec02      LIKE cec_file.cec02,  
    l_cecacti    LIKE cec_file.cecacti
 
    LET g_errno = ' '
    SELECT cec02,cecacti INTO l_cec02,l_cecacti
      FROM cec_file
     WHERE cec01 = g_ceu.ceu29
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                            LET g_ceu.cec02 = NULL
         WHEN l_cecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu.cec02 = l_cec02
       DISPLAY BY NAME g_ceu.cec02
    END IF 
END FUNCTION   
 
 
FUNCTION t772_ceu32(p_cmd) 
DEFINE
    p_cmd        LIKE type_file.chr1,
    l_geb02      LIKE geb_file.geb02,  
    l_gebacti    LIKE geb_file.gebacti
 
    LET g_errno = ' '
    SELECT geb02,gebacti INTO l_geb02,l_gebacti
      FROM geb_file
     WHERE geb01 = g_ceu.ceu32
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                            LET g_ceu.geb02 = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu.geb02 = l_geb02
       DISPLAY BY NAME g_ceu.geb02
    END IF 
END FUNCTION   
 
 
FUNCTION t772_ceu33(p_cmd) 
DEFINE
    p_cmd        LIKE type_file.chr1,
    l_cnc02      LIKE cnc_file.cnc02,  
    l_cncacti    LIKE cnc_file.cncacti
 
    LET g_errno = ' '
    SELECT cnc02,cncacti INTO l_cnc02,l_cncacti
      FROM cnc_file
     WHERE cnc01 = g_ceu.ceu33
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                            LET g_ceu.cnc02 = NULL
         WHEN l_cncacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu.cnc02 = l_cnc02
       DISPLAY BY NAME g_ceu.cnc02
    END IF 
END FUNCTION   
 
 
FUNCTION t772_ceu27(p_cmd)  #成交方式
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_ced02      LIKE ced_file.ced02,  
    l_cedacti    LIKE ced_file.cedacti
 
    LET g_errno = ' '
    SELECT ced02,cedacti INTO l_ced02,l_cedacti
      FROM ced_file
     WHERE ced01 = g_ceu.ceu27
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-739'
                            LET g_ceu.ced02 = NULL
         WHEN l_cedacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu.ced02 = l_ced02
       DISPLAY BY NAME g_ceu.ced02
    END IF 
END FUNCTION   
 
 
FUNCTION t772_ceu04(p_cmd,p_ac)  #料
DEFINE
    p_cmd           LIKE type_file.chr1,
    p_ac            INTEGER, 
    l_ima02         LIKE ima_file.ima02,  
    l_ima021        LIKE ima_file.ima021,
    l_imaacti       LIKE ima_file.imaacti,
 
    l_sql           STRING,
    l_cei12      LIKE cei_file.cei12,
    l_cei13      LIKE cei_file.cei13
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti 
      INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file
     WHERE ima01 = g_ceu_b[p_ac].ceu04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-677'
                            LET g_ceu_b[p_ac].ima02 = NULL
                            LET g_ceu_b[p_ac].ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    LET l_sql = " SELECT cei12,cei13 FROM cei_file ",
                "  WHERE cei03= '",g_ceu_b[p_ac].ceu04,"'"
    DECLARE cei_curs SCROLL CURSOR FROM l_sql
    FOREACH cei_curs INTO l_cei12,l_cei13
      IF STATUS THEN 
         EXIT FOREACH 
      END IF
      EXIT FOREACH
    END FOREACH
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ceu_b[p_ac].ima02 = l_ima02
       LET g_ceu_b[p_ac].cei12 = l_cei12  
       LET g_ceu_b[p_ac].cei13 = l_cei13  
       DISPLAY BY NAME g_ceu_b[p_ac].ima02
       DISPLAY BY NAME g_ceu_b[p_ac].ima021         
       DISPLAY BY NAME g_ceu_b[p_ac].cei12  
       DISPLAY BY NAME g_ceu_b[p_ac].cei13  
    END IF 
END FUNCTION     
 
 
 
FUNCTION t772_ceu02(p_cmd,p_ac,p_ceu19)  #單價幣別
DEFINE
    p_cmd           LIKE type_file.chr1,
    p_ac            INTEGER, 
    p_ceu19         LIKE ceu_file.ceu19,
    l_rvb04         LIKE rvb_file.rvb04,
    l_pmm22         LIKE pmm_file.pmm22,
    l_pmn31t        LIKE pmn_file.pmn31t,
    l_pmn88t        LIKE pmn_file.pmn88t,
    t_azi04         LIKE azi_file.azi04
      
  SELECT rvb04,rvb88t,rvb10t 
    INTO l_rvb04,l_pmn88t,l_pmn31t
    FROM rvb_file #采購單、金額、單價
    WHERE rvb01=g_ceu.ceu01 
      AND rvb02=p_ceu19   
 
  SELECT pmm22 INTO l_pmm22 
    FROM pmm_file 
   WHERE pmm01=l_rvb04
  
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi_file.azi01=l_pmm22
  CALL cl_digcut(l_pmn88t,t_azi04) RETURNING l_pmn88t
 
  LET l_pmn31t=l_pmn88t/g_ceu_b[p_ac].ceu15
  
  IF p_cmd='d' THEN
    LET g_ceu_b[p_ac].pmn31t=l_pmn31t
    LET g_ceu_b[p_ac].pmn88t=l_pmn88t
    LET g_ceu_b[p_ac].pmm22 =l_pmm22
    DISPLAY BY NAME g_ceu_b[p_ac].pmn31t
    DISPLAY BY NAME g_ceu_b[p_ac].pmn88t
    DISPLAY BY NAME g_ceu_b[p_ac].pmm22
  END IF    
END FUNCTION                                                             
 
 
FUNCTION t772_b_fill(p_wc)            
DEFINE p_wc   LIKE type_file.chr1000
DEFINE l_ceu19 LIKE ceu_file.ceu19  
 
    LET g_sql = "SELECT DISTINCT ceu02,ceu04,ima02,ima021,ceu15,",
                "                ceu16,'','','',ceu10,",
                "                ceu31,'','',ceu19 ",
                "  FROM ceu_file,ima_file ",  
                " WHERE ceu04=ima_file.ima01", 
                "   AND ceu01='",g_ceu.ceu01,"'",
                "   AND ",p_wc CLIPPED,
                " ORDER BY 1"
 
    PREPARE t772_prepare2 FROM g_sql      #預備一下
    DECLARE ceu_curs CURSOR FOR t772_prepare2
    CALL g_ceu_b.clear()
    LET g_cnt = 1
    FOREACH ceu_curs INTO g_ceu_b[g_cnt].*,l_ceu19   #單身 ARRAY 填充  
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL t772_ceu04('d',g_cnt)
        CALL t772_ceu02('d',g_cnt,l_ceu19)
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ceu_b.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
    DISPLAY g_rec_b TO FORMONLY.cn2     
END FUNCTION
 
 
FUNCTION t772_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ceu_b TO s_ceu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY 
         CALL cl_navigator_setting(g_curs_index, g_row_count)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
                  
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t772_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t772_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY          
 
      ON ACTION jump
         CALL t772_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t772_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           
 
      ON ACTION last
         CALL t772_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                     
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()     
         CALL t772_show_pic()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY                  
      
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY        
 
      ON ACTION default_data
         LET g_action_choice="default_data"
         EXIT DISPLAY
         
      ON ACTION default_data_update
         LET g_action_choice="default_data_update"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
                    
      ON ACTION cancel
         LET INT_FLAG=FALSE             
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t772_u()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ceu.ceu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_ceu.ceuacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_ceu.ceu01,9027,0)
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'Y' THEN   
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ceu_t.ceu08 = g_ceu.ceu08
   LET g_ceu_t.ceu25 = g_ceu.ceu25
   LET g_ceu_t.ceu17 = g_ceu.ceu17
   LET g_ceu_t.ceu28 = g_ceu.ceu28
   LET g_ceu_t.ceu30 = g_ceu.ceu30
   LET g_ceu_t.ceu24 = g_ceu.ceu24
   LET g_ceu_t.ceu26 = g_ceu.ceu26
   LET g_ceu_t.ceu27 = g_ceu.ceu27
   LET g_ceu_t.ceu29 = g_ceu.ceu29
   LET g_ceu_t.ceu32 = g_ceu.ceu32
   LET g_ceu_t.ceu33 = g_ceu.ceu33
   
   BEGIN WORK
   OPEN t772_cl USING g_ceu.ceu01
   IF STATUS THEN
      CALL cl_err("OPEN t772_cl:", STATUS, 1)
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t772_cl INTO g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
                      g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,
                      g_ceu.ceu26,g_ceu.ceu27,g_ceu.ceu29,  # 鎖住將被更改或取消的資料
                      g_ceu.ceu32,g_ceu.ceu33
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ceu.ceu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t772_show()
   
   WHILE TRUE
      LET g_ceu.ceumodu = g_user
      LET g_ceu.ceudate = g_today
      CALL t772_i("u")                      #欄位更改
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_ceu.ceu08 = g_ceu_t.ceu08
        LET g_ceu.ceu25 = g_ceu_t.ceu25
        LET g_ceu.ceu17 = g_ceu_t.ceu17
        LET g_ceu.ceu28 = g_ceu_t.ceu28
        LET g_ceu.ceu30 = g_ceu_t.ceu30
        LET g_ceu.ceu24 = g_ceu_t.ceu24
        LET g_ceu.ceu26 = g_ceu_t.ceu26
        LET g_ceu.ceu27 = g_ceu_t.ceu27
        LET g_ceu.ceu29 = g_ceu_t.ceu29         
        LET g_ceu.ceu32 = g_ceu_t.ceu32        
        LET g_ceu.ceu33 = g_ceu_t.ceu33        
        CALL t772_show()
        CALL cl_err('','9001',0)
        EXIT WHILE
      END IF
            
      UPDATE ceu_file SET ceu08=g_ceu.ceu08,
                          ceu25=g_ceu.ceu25,
                          ceu17=g_ceu.ceu17,
                          ceu28=g_ceu.ceu28, 
                          ceu30=g_ceu.ceu30,
                          ceu24=g_ceu.ceu24, 
                          ceu26=g_ceu.ceu26,
                          ceu27=g_ceu.ceu27, 
                          ceu29=g_ceu.ceu29,
                          ceu32=g_ceu.ceu32,
                          ceu33=g_ceu.ceu33,
                          ceumodu=g_ceu.ceumodu,   
                          ceudate=g_ceu.ceudate
              WHERE ceu01=g_ceu.ceu01
 
      IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","ceu_file",g_ceu.ceu01,"",SQLCA.sqlcode,"","",1)  
        CONTINUE WHILE
      END IF
    EXIT WHILE
  END WHILE
  COMMIT WORK
END FUNCTION
 
 
FUNCTION t772_ceu17(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file 
     WHERE cna01 = g_ceu.ceu17
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
FUNCTION t772_i(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1
  
  IF s_shut(0) THEN
    RETURN
  END IF
  
  INPUT BY NAME g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
                g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,
                g_ceu.ceu26,g_ceu.ceu27,g_ceu.ceu29,
                g_ceu.ceu32,g_ceu.ceu33
 
    WITHOUT DEFAULTS
       
      AFTER FIELD ceu17               #海關代號
          IF NOT cl_null(g_ceu.ceu17) THEN
            CALL t772_ceu17('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ceu.ceu17,g_errno,0)
               NEXT FIELD ceu17
            END IF
          END IF
          
      AFTER FIELD ceu24 #交運方式
         IF NOT cl_null(g_ceu.ceu24) THEN
            CALL t772_ceu24(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu24
            END IF
         END IF
 
      AFTER FIELD ceu26 #貿易方式
         IF NOT cl_null(g_ceu.ceu26) THEN
            CALL t772_ceu26(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu26
            END IF
         END IF
 
      AFTER FIELD ceu27 #成交方式
         IF NOT cl_null(g_ceu.ceu27) THEN
            CALL t772_ceu27(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu27
            END IF
         END IF
 
      AFTER FIELD ceu29
         IF NOT cl_null(g_ceu.ceu29) THEN
            CALL t772_ceu29(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu29
            END IF
         END IF
 
      AFTER FIELD ceu32
         IF NOT cl_null(g_ceu.ceu32) THEN
            CALL t772_ceu32(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu32
            END IF
         END IF
 
      AFTER FIELD ceu33
         IF NOT cl_null(g_ceu.ceu33) THEN
            CALL t772_ceu33(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu33
            END IF
         END IF
       ON ACTION controlp
          CASE
             WHEN INFIELD(ceu17)  #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_ceu.ceu17
                CALL cl_create_qry() RETURNING g_ceu.ceu17
                DISPLAY BY NAME g_ceu.ceu17
             WHEN INFIELD(ceu24)  #交運方式
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ged"
                LET g_qryparam.default1 = g_ceu.ceu24
                CALL cl_create_qry() RETURNING g_ceu.ceu24
                DISPLAY BY NAME g_ceu.ceu24
             WHEN INFIELD(ceu26)  #貿易方式
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cea01"
                LET g_qryparam.default1 = g_ceu.ceu26
                CALL cl_create_qry() RETURNING g_ceu.ceu26
                DISPLAY BY NAME g_ceu.ceu26
             WHEN INFIELD(ceu27)  #成交方式
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ced01"
                LET g_qryparam.default1 = g_ceu.ceu27
                CALL cl_create_qry() RETURNING g_ceu.ceu27
                DISPLAY BY NAME g_ceu.ceu27
             WHEN INFIELD(ceu29)  
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cec01"
                LET g_qryparam.default1 = g_ceu.ceu29
                CALL cl_create_qry() RETURNING g_ceu.ceu29
                DISPLAY BY NAME g_ceu.ceu29               
             WHEN INFIELD(ceu32)  
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_geb"
                LET g_qryparam.default1 = g_ceu.ceu32
                CALL cl_create_qry() RETURNING g_ceu.ceu32
                DISPLAY BY NAME g_ceu.ceu32               
             WHEN INFIELD(ceu33)  
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cnc"
                LET g_qryparam.default1 = g_ceu.ceu33
                CALL cl_create_qry() RETURNING g_ceu.ceu33
                DISPLAY BY NAME g_ceu.ceu33               
          END CASE
                          
    ON ACTION locale
      LET g_action_choice="locale"
      CALL cl_dynamic_locale()           
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT         
 
    ON ACTION exit
      LET INT_FLAG=1
      EXIT INPUT       
  END INPUT   
END FUNCTION
 
 
 
FUNCTION t772_y()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ceu.ceu01) THEN
     RETURN
   END IF     
 
   SELECT DISTINCT ceu01,ceu03,ceu05,ceu06,ceu09,
                   ceu11,ceu08,ceu25,ceu17,
                   ceu28,ceu30,ceu24,ceu26,ceu27,
                   ceu29,ceu32,ceu33,ceuconf,ceu21,
                   ceuacti,ceuuser,ceugrup,ceumodu,ceudate 
     INTO
        g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
        g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
        g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,
        g_ceu.ceu29,g_ceu.ceu32,g_ceu.ceu33,
        g_ceu.ceuconf,g_ceu.ceu21,g_ceu.ceuacti,
        g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,g_ceu.ceudate
     FROM ceu_file 
    WHERE ceu01=g_ceu.ceu01
   
   IF g_ceu.ceuconf = 'Y' THEN
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF   
   
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF   
   
   LET g_success='Y'
   BEGIN WORK
   OPEN t772_cl USING g_ceu.ceu01
   IF STATUS THEN
      CALL cl_err("OPEN t772_cl:", STATUS, 1)
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t772_cl INTO g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
                      g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,
                      g_ceu.ceu27,g_ceu.ceu29,  # 鎖住將被更改或取消的資料
                      g_ceu.ceu32,g_ceu.ceu33
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ceu.ceu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE ceu_file 
      SET ceuconf='Y',
          ceu21=g_today
    WHERE ceu01 = g_ceu.ceu01
   IF STATUS THEN
     CALL cl_err3("upd","ceu_file",g_ceu.ceu01,g_ceu.ceu01,STATUS,"","upd ceuconf",1)
     LET g_success='N'     
   END IF
   
   UPDATE rva_file 
      SET rva08 = g_ceu.ceu30 
    WHERE rva01 = g_ceu.ceu01
   IF STATUS THEN
     CALL cl_err3("upd","rva_file",g_ceu.ceu01,"",STATUS,"","upd rva08",1)
     LET g_success='N'     
   END IF      
      
   IF g_success = 'Y' THEN
      LET g_ceu.ceuconf = 'Y'
      LET g_ceu.ceu21 = g_today
      COMMIT WORK
      DISPLAY BY NAME g_ceu.ceuconf,g_ceu.ceu21
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF   
END FUNCTION
 
 
FUNCTION t772_z()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ceu.ceu01) THEN
     RETURN
   END IF           
       
   SELECT DISTINCT ceu01,ceu03,ceu05,ceu06,ceu09,
                   ceu11,ceu08,ceu25,ceu17,
                   ceu28,ceu30,ceu24,ceu26,ceu27,
                   ceu29,cue32,ceu33,
                   ceuconf,ceu21,ceuacti,ceuuser,ceugrup,ceumodu,ceudate 
     INTO g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
          g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
          g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,
          g_ceu.ceu29,g_ceu.ceu32,g_ceu.ceu33,
          g_ceu.ceuconf,g_ceu.ceu21,g_ceu.ceuacti,
          g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,g_ceu.ceudate
     FROM ceu_file 
    WHERE ceu01=g_ceu.ceu01
      
   IF g_ceu.ceuconf = 'N' THEN
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF                    
          
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t772_cl USING g_ceu.ceu01
   IF STATUS THEN
      CALL cl_err("OPEN t772_cl:", STATUS, 1)
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t772_cl INTO g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
                      g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,
                      g_ceu.ceu27,g_ceu.ceu29,  # 鎖住將被更改或取消的資料
                      g_ceu.ceu32,g_ceu.ceu33 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ceu.ceu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE ceu_file 
      SET ceuconf='N',ceu21=''
    WHERE ceu01 = g_ceu.ceu01
   IF STATUS THEN
     CALL cl_err3("upd","ceu_file",g_ceu.ceu01,"",STATUS,"","upd ceuconf",1)
     LET g_success='N'     
   END IF
   
   UPDATE rva_file SET rva08 = '' 
    WHERE rva01 = g_ceu.ceu01
   IF STATUS THEN
      CALL cl_err3("upd","rva_file",g_ceu.ceu01,"",STATUS,"","upd rva08",1)
      LET g_success='N'     
   END IF
   
   IF g_success = 'Y' THEN
      LET g_ceu.ceuconf = 'N'
      LET g_ceu.ceu21 = ''
      COMMIT WORK
      DISPLAY BY NAME g_ceu.ceuconf,g_ceu.ceu21
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF     
END FUNCTION
 
 
FUNCTION t772_default_data()
   DEFINE l_ced02 LIKE ced_file.ced02
   DEFINE l_cea02 LIKE cea_file.cea02
   DEFINE l_cec02 LIKE cec_file.cec02
   DEFINE l_ged02 LIKE ged_file.ged02
   DEFINE l_geb02 LIKE geb_file.geb02
   DEFINE l_cnc02 LIKE cnc_file.cnc02
   DEFINE l_acti  LIKE type_file.chr1
   
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ceu.ceu01) THEN
     RETURN
   END IF  
   
   OPEN WINDOW t772_a AT 9,29 WITH FORM "aco/42f/acot772a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("acot772a")
 
   IF g_login_cnt=1 THEN 
     INITIALIZE tm.* TO NULL 
   ELSE
     DISPLAY BY NAME tm.ceu08,tm.ceu25,tm.ceu28,tm.ceu30,
        tm.ceu24,tm.ceu26,tm.ceu27,tm.ceu29,tm.ceu32,tm.ceu33       
   END IF
   LET tm_t.*=tm.*
   
   INPUT BY NAME tm.ceu08,tm.ceu25,tm.ceu28,tm.ceu30,
                 tm.ceu24,tm.ceu26,tm.ceu27,tm.ceu29,tm.ceu32,tm.ceu33 
      WITHOUT DEFAULTS     
      
      AFTER FIELD ceu26
         IF NOT cl_null(tm.ceu26) THEN
            LET g_errno = ' '
            SELECT cea02,ceaacti INTO l_cea02,l_acti
              FROM cea_file
             WHERE cea01 = tm.ceu26
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-700'
                                           LET l_cea02 = NULL
                 WHEN l_acti='N' LET g_errno = '9028'
                 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu26
            END IF
            DISPLAY l_cea02 TO cea02
         ELSE 
            LET l_cea02 = NULL
            DISPLAY l_cea02 TO cea02
         END IF
 
      AFTER FIELD ceu29
         IF NOT cl_null(tm.ceu29) THEN
            LET g_errno = ' '
            SELECT cec02,cecacti INTO l_cec02,l_acti
              FROM cec_file
             WHERE cec01 = tm.ceu29
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                                           LET l_cec02 = NULL
                 WHEN l_acti='N' LET g_errno = '9028'
                 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu29
            END IF
            DISPLAY l_cec02 TO cec02
         ELSE 
            LET l_cec02 = NULL
            DISPLAY l_cec02 TO cec02
         END IF
 
      AFTER FIELD ceu32
         IF NOT cl_null(tm.ceu32) THEN
            LET g_errno = ' '
            SELECT geb02,gebacti INTO l_geb02,l_acti
              FROM geb_file
             WHERE geb01 = tm.ceu32
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                                           LET l_cec02 = NULL
                 WHEN l_acti='N' LET g_errno = '9028'
                 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu32
            END IF
            DISPLAY l_geb02 TO geb02
         ELSE 
            LET l_geb02 = NULL
            DISPLAY l_geb02 TO geb02
         END IF
 
      AFTER FIELD ceu33
         IF NOT cl_null(tm.ceu33) THEN
            LET g_errno = ' '
            SELECT cnc02,cncacti INTO l_cnc02,l_acti
              FROM cnc_file
             WHERE cnc01 = tm.ceu33
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                                           LET l_cec02 = NULL
                 WHEN l_acti='N' LET g_errno = '9028'
                 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu33
            END IF
            DISPLAY l_cnc02 TO cnc02
         ELSE 
            LET l_cnc02 = NULL
            DISPLAY l_cnc02 TO cnc02
         END IF
 
      AFTER FIELD ceu24 #交運方式
         IF NOT cl_null(tm.ceu24) THEN
            LET g_errno = ' '
            SELECT ged02 INTO l_ged02
              FROM ged_file
             WHERE ged01 = tm.ceu24
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-309'
                 OTHERWISE      LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu24
            END IF
            DISPLAY l_ged02 TO ged02
         ELSE 
            LET l_ged02 = NULL
            DISPLAY l_ged02 TO ged02
         END IF
 
      AFTER FIELD ceu27 #成交方式
         IF NOT cl_null(tm.ceu27) THEN
            LET g_errno = ' '
            SELECT ced02,cedacti INTO l_ced02,l_acti
              FROM ced_file
             WHERE ced01 = tm.ceu27
            CASE 
               WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-739'
                                         LET l_ced02 = NULL
               WHEN l_acti='N' LET g_errno = '9028'
                               LET l_ced02 = NULL
               OTHERWISE       LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ceu27
            END IF
            DISPLAY l_ced02 TO ced02
         ELSE
            LET l_ced02 = NULL
            DISPLAY l_ced02 TO ced02
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ceu26)  #貿易方式
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cea01"
               LET g_qryparam.default1 = tm.ceu26
               CALL cl_create_qry() RETURNING tm.ceu26
               SELECT cea02 INTO l_cea02
                 FROM tc_cpb_file WHERE tc_cpb01 = tm.ceu26
               DISPLAY l_cea02 TO cea02
               DISPLAY BY NAME tm.ceu26
            WHEN INFIELD(ceu29)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cec01"
               LET g_qryparam.default1 = tm.ceu29
               CALL cl_create_qry() RETURNING tm.ceu29
               SELECT cec02 INTO l_cec02
                 FROM cec_file 
                WHERE cec01 = tm.ceu29
               DISPLAY l_cec02 TO cec02
               DISPLAY BY NAME tm.ceu29
            WHEN INFIELD(ceu32)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geb"
               LET g_qryparam.default1 = tm.ceu32
               CALL cl_create_qry() RETURNING tm.ceu32
               SELECT geb02 INTO l_geb02
                 FROM geb_file 
                WHERE geb01 = tm.ceu32
               DISPLAY l_geb02 TO geb02
               DISPLAY BY NAME tm.ceu32
            WHEN INFIELD(ceu33)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cnc"
               LET g_qryparam.default1 = tm.ceu33
               CALL cl_create_qry() RETURNING tm.ceu33
               SELECT cnc02 INTO l_cnc02
                 FROM cnc_file 
                WHERE cnc01 = tm.ceu33
               DISPLAY l_cnc02 TO cnc02
               DISPLAY BY NAME tm.ceu33
            WHEN INFIELD(ceu24)  #交運方式
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ged"
               LET g_qryparam.default1 = tm.ceu24
               CALL cl_create_qry() RETURNING tm.ceu24
               SELECT ged02 INTO l_ged02
                 FROM ged_file
                WHERE ged01 = tm.ceu24
               DISPLAY l_ged02 TO ged02
               DISPLAY BY NAME tm.ceu24
            WHEN INFIELD(ceu27)  #成交方式
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ced01"
               LET g_qryparam.default1 = tm.ceu27
               CALL cl_create_qry() RETURNING tm.ceu27
               SELECT ced02 INTO l_ced02
                 FROM ced_file
                WHERE ced01 = tm.ceu27
               DISPLAY l_ced02 TO ced02
               DISPLAY BY NAME tm.ceu27
         END CASE
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
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      INITIALIZE tm.* TO NULL   
      LET tm.*=tm_t.*   
      CLOSE WINDOW t772_a
      RETURN
   END IF
   LET g_login_cnt=0
   CLOSE WINDOW t772_a
END FUNCTION
 
FUNCTION t772_default_data_update()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ceu.ceu01) THEN
     RETURN
   END IF
   IF g_login_cnt=1 THEN RETURN END IF
   
   SELECT DISTINCT ceu01,ceu03,ceu05,ceu06,ceu09,
             ceu11,ceu08,ceu25,ceu17,
             ceu28,ceu30,ceu24,ceu26,ceu27,
             ceu29,ceu32,ceu33,
             ceuconf,ceu21,ceuacti,ceuuser,ceugrup,ceumodu,ceudate 
     INTO g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
          g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
          g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,
          g_ceu.ceu29,g_ceu.ceu32,g_ceu.ceu33,
          g_ceu.ceuconf,g_ceu.ceu21,g_ceu.ceuacti,
          g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,g_ceu.ceudate
     FROM ceu_file 
    WHERE ceu01=g_ceu.ceu01
      
   IF g_ceu.ceuconf = 'Y' THEN
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('aco-740') THEN
      RETURN
   END IF                    
          
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t772_cl USING g_ceu.ceu01
   IF STATUS THEN
      CALL cl_err("OPEN t772_cl:", STATUS, 1)
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t772_cl INTO g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
      g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,
      g_ceu.ceu27,g_ceu.ceu29,  # 鎖住將被更改或取消的資料
      g_ceu.ceu32,g_ceu.ceu33
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ceu.ceu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE ceu_file 
      SET ceu08=tm.ceu08,
          ceu25=tm.ceu25,
          ceu28=tm.ceu28,
          ceu30=tm.ceu30,
          ceu24=tm.ceu24,
          ceu26=tm.ceu26,
          ceu27=tm.ceu27,
          ceu29=tm.ceu29,      
          ceu32=tm.ceu32,      
          ceu33=tm.ceu33      
     WHERE ceu01 = g_ceu.ceu01
   IF STATUS THEN
     CALL cl_err3("upd","ceu_file",g_ceu.ceu01,"",STATUS,"","upd ceuconf",1)
     LET g_success='N'     
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT DISTINCT ceu01,ceu03,ceu05,ceu06,ceu09,
             ceu11,ceu08,ceu25,ceu17,
             ceu28,ceu30,ceu24,ceu26,ceu27,
             ceu29,ceu32,ceu33,
             ceuconf,ceu21,ceuacti,ceuuser,ceugrup,ceumodu,ceudate INTO
             g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
             g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
             g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,
             g_ceu.ceu29,g_ceu.ceu32,g_ceu.ceu33,
             g_ceu.ceuconf,g_ceu.ceu21,g_ceu.ceuacti,
             g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,g_ceu.ceudate
        FROM ceu_file WHERE ceu01=g_ceu.ceu01
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","ceu_file",g_ceu.ceu01,"",SQLCA.sqlcode,"","",1)
         INITIALIZE g_ceu.* TO NULL
         RETURN
      END IF   
      CALL t772_show()        
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF     
END FUNCTION
 
 
FUNCTION t772_r()  
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_ceu.ceu01) THEN
     RETURN
   END IF
 
   SELECT DISTINCT ceu01,ceu03,ceu05,ceu06,ceu09,
                   ceu11,ceu08,ceu25,ceu17,
                   ceu28,ceu30,ceu24,ceu26,ceu27,
                   ceu29,ceu32,ceu33,ceuconf,ceu21,
                   ceuacti,ceuuser,ceugrup,ceumodu,ceudate 
      INTO
        g_ceu.ceu01,g_ceu.ceu03,g_ceu.ceu05,g_ceu.ceu06,g_ceu.ceu09,
        g_ceu.ceu11,g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
        g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,g_ceu.ceu27,
        g_ceu.ceu29,g_ceu.ceu32,g_ceu.ceu33,
        g_ceu.ceuconf,g_ceu.ceu21,g_ceu.ceuacti,
        g_ceu.ceuuser,g_ceu.ceugrup,g_ceu.ceumodu,g_ceu.ceudate
      FROM ceu_file WHERE ceu01=g_ceu.ceu01
 
   IF g_ceu.ceuacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_ceu.ceu01,9027,0)
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_ceu.ceuconf = 'Y' THEN 
      CALL cl_err('','9023',0)
      RETURN
   END IF
         
   BEGIN WORK
 
   OPEN t772_cl USING g_ceu.ceu01
   IF STATUS THEN
      CALL cl_err("OPEN t772_cl:", STATUS, 1)
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t772_cl INTO g_ceu.ceu08,g_ceu.ceu25,g_ceu.ceu17,
                      g_ceu.ceu28,g_ceu.ceu30,g_ceu.ceu24,g_ceu.ceu26,
                      g_ceu.ceu27,g_ceu.ceu29,  # 鎖住將被更改或取消的資料
                      g_ceu.ceu32,g_ceu.ceu33
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ceu.ceu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t772_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM ceu_file WHERE ceu01=g_ceu.ceu01
 
      INITIALIZE g_ceu.* TO NULL
      CLEAR FORM
      CALL g_ceu_b.clear()
 
      OPEN t772_count
      FETCH t772_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cn1     
 
      OPEN t772_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t772_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t772_fetch('/')
      END IF
   END IF
 
   CLOSE t772_cl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION t772_show_pic()
   IF g_ceu.ceuconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_ceu.ceuconf,"","","",g_void,g_ceu.ceuacti)
END FUNCTION
#FUN-930151
