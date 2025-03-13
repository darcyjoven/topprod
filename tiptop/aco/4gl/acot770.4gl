# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: acot770.4gl
# Descriptions...: 出口成品明細資料維護作業 
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  p_row,p_col     LIKE type_file.num5,
        g_rec_b         LIKE type_file.num5,     #單身筆數
        g_row_count     LIKE type_file.num10,
        g_curs_index    LIKE type_file.num10,
        g_sql           STRING,
        g_wc            STRING,
        g_msg           STRING,
        g_void          LIKE type_file.chr1,
        g_forupd_sql         STRING
 
DEFINE tm          RECORD               #設置公用信息使用
         cet08   LIKE cet_file.cet08,   #報關日期
         cet25   LIKE cet_file.cet25,   #提運單號
         cet27   LIKE cet_file.cet27,   #批准文號
         cet29   LIKE cet_file.cet29,   #出口報關單號
         cet24   LIKE cet_file.cet24,   #交運方式
         cet26   LIKE cet_file.cet26,   #成交方式
         cet28   LIKE cet_file.cet28    #用途
                   END RECORD
 
DEFINE tm_t     RECORD               #設置公用信息使用(舊值)
         cet08     LIKE cet_file.cet08,    #報關日期
         cet25     LIKE cet_file.cet25,    #提運單號
         cet27     LIKE cet_file.cet27,    #批准文號
         cet29     LIKE cet_file.cet29,    #出口報關單號
         cet24     LIKE cet_file.cet24,    #交運方式
         cet26     LIKE cet_file.cet26,    #成交方式
         cet28     LIKE cet_file.cet28     #用途
                END RECORD                    
        
DEFINE  l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT   
DEFINE  g_cnt           LIKE type_file.num10           
DEFINE  g_login_cnt     LIKE type_file.num5     #是否第一LOGIN設置畫面，1--第一次
DEFINE  g_jump          LIKE type_file.num10
DEFINE  g_no_ask       LIKE type_file.num5
 
 
DEFINE
    g_cet         RECORD               #單頭    
        cet01    LIKE cet_file.cet01,    #單據編號 
        cet03    LIKE cet_file.cet03,    #單據日期
        cet05    LIKE cet_file.cet05,    #廠商編號
        cet06    LIKE cet_file.cet06,    #廠商簡稱        
        cet08    LIKE cet_file.cet08,    #報單日期
        cet25    LIKE cet_file.cet25,    #提運單號
        cet11    LIKE cet_file.cet11,    #海關代號
        cet27    LIKE cet_file.cet27,    #批準文號 
        cet29    LIKE cet_file.cet29,    #進口報關單號
        cet24    LIKE cet_file.cet24,    #交運方式
        ged02    LIKE ged_file.ged02,    
        cet26    LIKE cet_file.cet26,    #成交方式
        ced02    LIKE ced_file.ced02,
        cet28    LIKE cet_file.cet28,    #用途
        cec02    LIKE cec_file.cec02,
        cetconf  LIKE cet_file.cetconf,  #確認碼                
        cet21    LIKE cet_file.cet21,    #審核日期 
        cet34    LIKE cet_file.cet34,    #Invoice
        cet09    LIKE cet_file.cet09,    #異動方式
        cetacti  LIKE cet_file.cetacti,
        cetuser  LIKE cet_file.cetuser,
        cetgrup  LIKE cet_file.cetgrup,
        cetmodu  LIKE cet_file.cetmodu,
        cetdate  LIKE cet_file.cetdate,
        cet38    LIKE cet_file.cet38,    #產銷國   
        geb02    LIKE geb_file.geb02
                    END RECORD,
                    
    g_cet_t         RECORD                 #單頭    
        cet01    LIKE cet_file.cet01,    #單據編號 
        cet03    LIKE cet_file.cet03,    #單據日期
        cet05    LIKE cet_file.cet05,    #廠商編號
        cet06    LIKE cet_file.cet06,    #廠商簡稱        
        cet08    LIKE cet_file.cet08,    #報單日期
        cet25    LIKE cet_file.cet25,    #提運單號
        cet11    LIKE cet_file.cet11,    #海關代號
        cet27    LIKE cet_file.cet27,    #批準文號 
        cet29    LIKE cet_file.cet29,    #進口報關單號
        cet24    LIKE cet_file.cet24,    #交運方式
        ged02    LIKE ged_file.ged02,    
        cet26    LIKE cet_file.cet26,    #成交方式
        ced02    LIKE ced_file.ced02,
        cet28    LIKE cet_file.cet28,    #用途
        cec02    LIKE cec_file.cec02,
        cetconf  LIKE cet_file.cetconf,  #確認碼                
        cet21    LIKE cet_file.cet21,    #審核日期 
        cet34    LIKE cet_file.cet34,    #Invoice
        cet09    LIKE cet_file.cet09,    #異動方式
        cetacti  LIKE cet_file.cetacti,
        cetuser  LIKE cet_file.cetuser,
        cetgrup  LIKE cet_file.cetgrup,
        cetmodu  LIKE cet_file.cetmodu,
        cetdate  LIKE cet_file.cetdate,
        cet38    LIKE cet_file.cet38,    #產銷國   
        geb02    LIKE geb_file.geb02
                    END RECORD,                    
 
     g_cet_b        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cet02       LIKE cet_file.cet02,    #項次
        cet04       LIKE cet_file.cet04,    #料件編號
        ima02       LIKE ima_file.ima02,    #
        ima021      LIKE ima_file.ima021,   #
        cet15       LIKE cet_file.cet15,    #異動數量
        cet16       LIKE cet_file.cet16,    #異動單位
        cet36       LIKE cet_file.cet36,    #單價
        cet37       LIKE cet_file.cet37,    #金額
        cet35       LIKE cet_file.cet35,    #幣別
        cet10       LIKE cet_file.cet10,    #商品編號
        cet17       LIKE cet_file.cet17,    #BOM版本
        cet31       LIKE cet_file.cet31,    #法定數量一
        cet32       LIKE cet_file.cet32,    #法定數量二
        cet33       LIKE cet_file.cet33     #淨重 
                    END RECORD,
 
     g_cet_b_t    RECORD    #程式變數(Program Variables)
        cet02       LIKE cet_file.cet02,    #項次
        cet04       LIKE cet_file.cet04,    #料件編號
        ima02       LIKE ima_file.ima02,    #
        ima021      LIKE ima_file.ima021,   #
        cet15       LIKE cet_file.cet15,    #異動數量
        cet16       LIKE cet_file.cet16,    #異動單位
        cet36       LIKE cet_file.cet36,    #單價
        cet37       LIKE cet_file.cet37,    #金額
        cet35       LIKE cet_file.cet35,    #幣別
        cet10       LIKE cet_file.cet10,    #商品編號
        cet17       LIKE cet_file.cet17,    #BOM版本
        cet31       LIKE cet_file.cet31,    #法定數量一
        cet32       LIKE cet_file.cet32,    #法定數量二
        cet33       LIKE cet_file.cet33     #淨重 
                    END RECORD
                    
MAIN
   OPTIONS                              #改變一些系統預設值
     INPUT NO WRAP,
     FIELD ORDER FORM
   DEFER INTERRUPT                      #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)   RETURNING g_time    #計算使用時間 (進入時間)  
 
   LET g_forupd_sql = "SELECT cet08,cet25,cet11,cet27,",
                      "       cet29,cet24,cet26,cet28,cet38 ",
                      "  FROM cet_file ",
                      " WHERE cet01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t770_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 3 LET g_login_cnt=1
   OPEN WINDOW t770_w AT p_row,p_col WITH FORM "aco/42f/acot770"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)    
   CALL cl_ui_init()
 
   CALL t770_menu()
   CLOSE WINDOW t770_w                                  #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間)             
END MAIN
 
 
FUNCTION t770_cs()
   CLEAR FORM
   CALL g_cet_b.clear()
 
     CALL cl_set_head_visible("","YES")
     INITIALIZE g_cet.* TO NULL    
     CONSTRUCT BY NAME g_wc ON cet01,cet03,cet05,cet06,cet09,cet34,
                               cet08,cet25,cet27,cet11,cet29,cetconf,cet21,
                               cet24,cet26,cet28,cet38,
                               cetuser,cetgrup,cetmodu,cetdate,cetacti
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(cet01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_cet01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cet01                                 
              WHEN INFIELD(cet05)
                   CALL cl_init_qry_var()                   
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_occ"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cet05
              WHEN INFIELD(cet11) #海關代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_cna"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cet11
              WHEN INFIELD(cet24) #交運方式
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_ged"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cet24
              WHEN INFIELD(cet26) #成交方式
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_ced01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cet26
              WHEN INFIELD(cet28)  #用途
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_cec01"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_cet.cet28
                   CALL cl_create_qry() RETURNING g_cet.cet28
                   DISPLAY BY NAME g_cet.cet28
              WHEN INFIELD(cet38)   #產銷國
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_geb"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_cet.cet38
                   CALL cl_create_qry() RETURNING g_cet.cet38
                   DISPLAY BY NAME g_cet.cet38
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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cetuser', 'cetgrup') #FUN-980030
     
     IF INT_FLAG THEN 
        RETURN 
     END IF  
 
   LET g_sql= "SELECT UNIQUE cet01 FROM cet_file ",
              " WHERE ", g_wc CLIPPED, 
              " ORDER BY cet01"
   PREPARE t770_prepare FROM g_sql     
   DECLARE t770_b_cs SCROLL CURSOR WITH HOLD FOR t770_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT cet01) FROM cet_file WHERE ",g_wc CLIPPED
   PREPARE t770_precount FROM g_sql
   DECLARE t770_count CURSOR FOR t770_precount
END FUNCTION
 
 
FUNCTION t770_menu()
   WHILE TRUE
      CALL t770_bp("G")
      CASE g_action_choice        
         WHEN "default_data" 
            IF cl_chk_act_auth() THEN
               CALL t770_default_data()
            END IF
 
         WHEN "default_data_update"
            IF cl_chk_act_auth() THEN
              CALL t770_default_data_update()
            END IF
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t770_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t770_r()
            END IF
                     
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t770_u()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t770_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t770_y()
               CALL t770_show_pic()
            END IF
            
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t770_z()
               CALL t770_show_pic()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cet_b),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t770_q()
  DEFINE l_sql STRING  
  LET g_row_count=0
  LET g_curs_index=0
  CALL cl_navigator_setting(g_curs_index, g_row_count)
  INITIALIZE g_cet.* TO NULL
  MESSAGE ""
  CALL cl_opmsg('q')
  CLEAR FORM
  DISPLAY '   ' TO FORMONLY.cnt
  CALL t770_cs()               #取得查詢條件  
  IF INT_FLAG THEN
    LET INT_FLAG = 0
    INITIALIZE g_cet.* TO NULL
    RETURN
  END IF
  CALL cl_msg(" SEARCHING ! ")
 
  OPEN t770_b_cs               # 從DB產生合乎條件TEMP(0-30秒)
  IF SQLCA.sqlcode THEN
     CALL cl_err('',SQLCA.sqlcode,0)
     INITIALIZE g_cet.* TO NULL
  ELSE
     CALL t770_fetch('F')                  # 讀出TEMP第一筆並顯示
     OPEN t770_count
     FETCH t770_count INTO g_row_count
     DISPLAY g_row_count TO FORMONLY.cn1     
  END IF
  CALL cl_msg("")
END FUNCTION
 
 
FUNCTION t770_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1  #處理方式 
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t770_b_cs INTO g_cet.cet01
        WHEN 'P' FETCH PREVIOUS t770_b_cs INTO g_cet.cet01
        WHEN 'F' FETCH FIRST    t770_b_cs INTO g_cet.cet01
        WHEN 'L' FETCH LAST     t770_b_cs INTO g_cet.cet01
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
          FETCH ABSOLUTE g_jump t770_b_cs INTO g_cet.cet01
          LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN            
        CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)
        INITIALIZE g_cet.* TO NULL
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
        
   SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,cet34,
                   cet08,cet25,cet11,cet27,cet29,
                   cet24,cet26,cet28,cetconf,cet21,
                   cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
      INTO
         g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
         g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
         g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
         g_cet.cet28,g_cet.cetconf,g_cet.cet21,
         g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
         g_cet.cetdate,g_cet.cet38                   
      FROM cet_file WHERE cet01=g_cet.cet01
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cet_file",g_cet.cet01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_cet.* TO NULL
      RETURN
   END IF
   
  CALL t770_show()      
END FUNCTION
 
 
FUNCTION t770_show()
   DISPLAY BY NAME g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
                   g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
                   g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
                   g_cet.cet28,g_cet.cetconf,g_cet.cet21,
                   g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
                   g_cet.cetdate,g_cet.cet38     
   CALL t770_cet24('d')
   CALL t770_cet26('d')
   CALL t770_cet28('d')
   CALL t770_cet38('d')
   CALL t770_show_pic()
        
   CALL t770_b_fill(g_wc)                   #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
 
FUNCTION t770_cet24(p_cmd) #交運方式
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_ged02         LIKE ged_file.ged02  
 
    LET g_errno = ' '
    SELECT ged02 INTO l_ged02
      FROM ged_file
     WHERE ged01 = g_cet.cet24
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-309'
                            LET g_cet.ged02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_cet.ged02 = l_ged02
       DISPLAY BY NAME g_cet.ged02
    END IF 
END FUNCTION                                                                    
 
 
FUNCTION t770_cet38(p_cmd) 
DEFINE
    p_cmd        LIKE type_file.chr1,
    l_geb02      LIKE geb_file.geb02,  
    l_gebacti    LIKE geb_file.gebacti
 
    LET g_errno = ' '
    SELECT geb02,gebacti INTO l_geb02,l_gebacti
      FROM geb_file
     WHERE geb01 = g_cet.cet38
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                            LET g_cet.geb02 = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_cet.geb02 = l_geb02
       DISPLAY BY NAME g_cet.geb02
    END IF 
END FUNCTION   
 
 
FUNCTION t770_cet28(p_cmd) 
DEFINE
    p_cmd        LIKE type_file.chr1,
    l_cec02      LIKE cec_file.cec02,  
    l_cecacti    LIKE cec_file.cecacti
 
    LET g_errno = ' '
    SELECT cec02,cecacti INTO l_cec02,l_cecacti
      FROM cec_file
     WHERE cec01 = g_cet.cet28
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                            LET g_cet.cec02 = NULL
         WHEN l_cecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_cet.cec02 = l_cec02
       DISPLAY BY NAME g_cet.cec02
    END IF 
END FUNCTION   
 
 
FUNCTION t770_cet26(p_cmd)  #成交方式
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_ced02      LIKE ced_file.ced02,  
    l_cedacti    LIKE ced_file.cedacti
 
    LET g_errno = ' '
    SELECT ced02,cedacti INTO l_ced02,l_cedacti
      FROM ced_file
     WHERE ced01 = g_cet.cet26
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-739'
                            LET g_cet.ced02 = NULL
         WHEN l_cedacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_cet.ced02 = l_ced02
       DISPLAY BY NAME g_cet.ced02
    END IF 
END FUNCTION   
 
 
FUNCTION t770_cet04(p_cmd,p_ac)  #料
DEFINE
    p_cmd           LIKE type_file.chr1,
    p_ac            INTEGER, 
    l_ima02         LIKE ima_file.ima02,  
    l_ima021        LIKE ima_file.ima021,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file
     WHERE ima01 = g_cet_b[p_ac].cet04 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-677'
                            LET g_cet_b[p_ac].ima02 = NULL
                            LET g_cet_b[p_ac].ima021 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_cet_b[p_ac].ima02 = l_ima02
       LET g_cet_b[p_ac].ima021= l_ima021
       DISPLAY BY NAME g_cet_b[p_ac].ima02
       DISPLAY BY NAME g_cet_b[p_ac].ima021         
    END IF 
END FUNCTION     
 
 
FUNCTION t770_cet11(p_cmd)  #
   DEFINE l_cna02   LIKE cna_file.cna02,
          l_cnaacti LIKE cna_file.cnaacti,
          p_cmd     LIKE type_file.chr1
   LET g_errno = ' '
   SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
     FROM cna_file WHERE cna01 = g_cet.cet11
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
        WHEN l_cnaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
 
FUNCTION t770_b_fill(p_wc)            
DEFINE p_wc   LIKE type_file.chr1000
    LET g_sql = "SELECT cet02,cet04,'','',cet15,cet16,cet36,",
                "       cet37,cet35,cet10,cet17,cet31,cet32,cet33 ",
                "  FROM cet_file ",
                " WHERE cet01='",g_cet.cet01,"'",
                "   AND ",p_wc CLIPPED,
                " ORDER BY 1"   
    PREPARE t770_prepare2 FROM g_sql      #預備一下
    DECLARE cet_curs CURSOR FOR t770_prepare2
    CALL g_cet_b.clear()
    LET g_cnt = 1
    FOREACH cet_curs INTO g_cet_b[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL t770_cet04('d',g_cnt)  #料號
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_cet_b.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
    DISPLAY g_rec_b TO FORMONLY.cn2     
END FUNCTION
 
 
FUNCTION t770_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cet_b TO s_cet.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t770_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t770_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY          
 
      ON ACTION jump
         CALL t770_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t770_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           
 
      ON ACTION last
         CALL t770_fetch('L')
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
         CALL t770_show_pic()
 
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
 
 
FUNCTION t770_u()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_cet.cet01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_cet.cetacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_cet.cet01,9027,0)
      RETURN
   END IF
 
   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_cet.cetconf = 'Y' THEN   
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_cet_t.cet01 = g_cet.cet01   #單據編號
   LET g_cet_t.cet08 = g_cet.cet08   #報單日期
   LET g_cet_t.cet25 = g_cet.cet25   #提運單號
   LET g_cet_t.cet11 = g_cet.cet11   #海關代號
   LET g_cet_t.cet27 = g_cet.cet27   #批准文號
   LET g_cet_t.cet29 = g_cet.cet29   #出口報關單號
   LET g_cet_t.cet24 = g_cet.cet24   #交運方式
   LET g_cet_t.cet26 = g_cet.cet26   #成交方式
   LET g_cet_t.cet28 = g_cet.cet28   #用途
   LET g_cet_t.cet38 = g_cet.cet38   #產銷國
   
   BEGIN WORK
   OPEN t770_cl USING g_cet.cet01
   IF STATUS THEN
      CALL cl_err("OPEN t770_cl:", STATUS, 1)
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t770_cl INTO g_cet.cet08,g_cet.cet25,g_cet.cet11,
                      g_cet.cet27,g_cet.cet29,g_cet.cet24,
                      g_cet.cet26,g_cet.cet28,g_cet.cet38    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL t770_show()
   
   WHILE TRUE
      LET g_cet.cetmodu = g_user
      LET g_cet.cetdate = g_today
      CALL t770_i("u")                      #欄位更改
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_cet.cet01 = g_cet_t.cet01   #單據編號
        LET g_cet.cet08 = g_cet_t.cet08   #報單日期
        LET g_cet.cet25 = g_cet_t.cet25   #提運單號
        LET g_cet.cet11 = g_cet_t.cet11   #海關代號
        LET g_cet.cet27 = g_cet_t.cet27   #批准文件編號
        LET g_cet.cet29 = g_cet_t.cet29   #出口報式
        LET g_cet.cet24 = g_cet_t.cet24   #交運方式
        LET g_cet.cet26 = g_cet_t.cet26   #成交方式
        LET g_cet.cet28 = g_cet_t.cet28   #用途
        LET g_cet.cet38 = g_cet_t.cet38   #產銷國
        CALL t770_show()
        CALL cl_err('','9001',0)
        EXIT WHILE
      END IF
            
      UPDATE cet_file SET cet01=g_cet.cet01,
                          cet08=g_cet.cet08,
                          cet25=g_cet.cet25,
                          cet11=g_cet.cet11,
                          cet27=g_cet.cet27, 
                          cet29=g_cet.cet29,
                          cet24=g_cet.cet24, 
                          cet26=g_cet.cet26,
                          cet28=g_cet.cet28, 
                          cet38=g_cet.cet38,
                          cetmodu=g_cet.cetmodu,    
                          cetdate=g_cet.cetdate
              WHERE cet01=g_cet_t.cet01
 
      IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","cet_file",g_cet.cet01,"",SQLCA.sqlcode,"","",1)  
        CONTINUE WHILE
      END IF
    EXIT WHILE
  END WHILE
  COMMIT WORK
END FUNCTION
 
 
 
 
FUNCTION t770_i(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1
  
  IF s_shut(0) THEN
    RETURN
  END IF
 
  INPUT BY NAME g_cet.cet08,g_cet.cet25,g_cet.cet11,
                g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
                g_cet.cet28,g_cet.cet38
       WITHOUT DEFAULTS
       
         
      AFTER FIELD cet11               #海關代號
          IF NOT cl_null(g_cet.cet11) THEN
            CALL t770_cet11('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cet.cet11,g_errno,0)
               NEXT FIELD cet11
            END IF
          END IF
          
      AFTER FIELD cet24 #交運方式
         IF NOT cl_null(g_cet.cet24) THEN
            CALL t770_cet24(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet24
            END IF
         END IF
 
      AFTER FIELD cet26 #成交方式
         IF NOT cl_null(g_cet.cet26) THEN
            CALL t770_cet26(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet26
            END IF
         END IF
 
      AFTER FIELD cet28   #用途
         IF NOT cl_null(g_cet.cet28) THEN
            CALL t770_cet28(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet28
            END IF
         END IF
 
      AFTER FIELD cet38  #產銷國
         IF NOT cl_null(g_cet.cet38) THEN
            CALL t770_cet38(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet38
            END IF
         END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(cet11)  #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_cet.cet11
                CALL cl_create_qry() RETURNING g_cet.cet11
                DISPLAY BY NAME g_cet.cet11
             WHEN INFIELD(cet24)  #交運方式
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ged"
                LET g_qryparam.default1 = g_cet.cet24
                CALL cl_create_qry() RETURNING g_cet.cet24
                DISPLAY BY NAME g_cet.cet24
             WHEN INFIELD(cet26)  #成交方式
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ced01"
                LET g_qryparam.default1 = g_cet.cet26
                CALL cl_create_qry() RETURNING g_cet.cet26
                DISPLAY BY NAME g_cet.cet26
             WHEN INFIELD(cet28)  #用途
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cec01"
                LET g_qryparam.default1 = g_cet.cet28
                CALL cl_create_qry() RETURNING g_cet.cet28
                DISPLAY BY NAME g_cet.cet28               
             WHEN INFIELD(cet38)  #產銷國 
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_geb"
                LET g_qryparam.default1 = g_cet.cet38
                CALL cl_create_qry() RETURNING g_cet.cet38
                DISPLAY BY NAME g_cet.cet38               
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
 
 
#單身
FUNCTION t770_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cet.cet01 IS NULL THEN RETURN END IF
 
    SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,cet34,
                    cet08,cet25,cet11,cet27,cet29,
                    cet24,cet26,cet28,cetconf,cet21,
                    cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
     INTO g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
          g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
          g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
          g_cet.cet28,g_cet.cetconf,g_cet.cet21,
          g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
          g_cet.cetdate,g_cet.cet38                   
     FROM cet_file 
    WHERE cet01=g_cet.cet01
   
   IF g_cet.cetconf = 'Y' THEN
      RETURN
   END IF
 
   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF   
 
   LET g_success='Y'
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT cet02,cet04,'','',cet15,cet16,cet36,",
                      "        cet37,cet35,cet10,cet17,cet31,cet32,cet33 ",
                      "   FROM cet_file ",
                      "  WHERE cet01=? AND cet02=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t770_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_cet_b WITHOUT DEFAULTS FROM s_cet.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd = ''
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL t770_set_entry_b()
            CALL t770_set_no_entry_b()
            BEGIN WORK
 
            OPEN t770_cl USING g_cet.cet01
            IF STATUS THEN
               CALL cl_err("OPEN t770_cl:", STATUS, 1)
               CLOSE t770_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t770_cl INTO g_cet.cet08,g_cet.cet25,g_cet.cet11,
                               g_cet.cet27,g_cet.cet29,g_cet.cet24,
                               g_cet.cet26,g_cet.cet28,g_cet.cet38    # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t770_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cet_b_t.* = g_cet_b[l_ac].*  #BACKUP
 
                OPEN t770_bcl USING g_cet.cet01,g_cet_b_t.cet02
                IF STATUS THEN
                   CALL cl_err("OPEN t770_bcl:", STATUS, 1)
                   CLOSE t770_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t770_bcl INTO g_cet_b[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cet_b_t.cet02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL t770_cet04('d',l_ac)  #料號
                CALL cl_show_fld_cont()     
            END IF
 
 
 
        AFTER FIELD cet17
            IF cl_null(g_cet_b[l_ac].cet17) THEN NEXT FIELD cet17 END IF
 
            IF (g_cet_b[l_ac].cet17 <> g_cet_b_t.cet17)
               OR cl_null(g_cet_b_t.cet17) THEN
 
               SELECT COUNT(*) INTO l_cnt FROM cej_file
                WHERE cej04 = g_cet_b[l_ac].cet04
                  AND cej02 = g_cet_b[l_ac].cet17
                  AND cej07 = 'Y'
               IF l_cnt = 0 THEN
                 CALL cl_err(g_cet_b[l_ac].cet17,'aco-742',1)
                 NEXT FIELD cet17
               END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cet_b[l_ac].* = g_cet_b_t.*
               CLOSE t770_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cet_b[l_ac].cet02,-263,1)
               LET g_cet_b[l_ac].* = g_cet_b_t.*
            ELSE
               UPDATE cet_file 
                  SET cet17=g_cet_b[l_ac].cet17
                WHERE cet01=g_cet.cet01 
                  AND cet02=g_cet_b_t.cet02
               IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","cet_file",g_cet.cet01,g_cet_b_t.cet02,SQLCA.SQLCODE,"","",1)  
                   LET g_cet_b[l_ac].* = g_cet_b_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
                   MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_cet_b[l_ac].* = g_cet_b_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cet_b.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t770_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add 
            CLOSE t770_bcl
            COMMIT WORK
 
 
        ON ACTION controls                     
           CALL cl_set_head_visible("","AUTO") 
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION about         
            CALL cl_about()      
         ON ACTION help          
            CALL cl_show_help()  
        END INPUT
 
         LET g_cet.cetmodu = g_user
         LET g_cet.cetdate = g_today
         UPDATE cet_file 
            SET cetmodu = g_cet.cetmodu,
                cetdate = g_cet.cetdate
          WHERE cet01 = g_cet.cet01
         DISPLAY BY NAME g_cet.cetmodu,g_cet.cetdate
 
        CLOSE t770_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION t770_y()
   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 -------- add ------- begin
   IF cl_null(g_cet.cet01) THEN
     RETURN
   END IF     
   IF g_cet.cetconf = 'Y' THEN
      RETURN
   END IF

   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------- add ------- end
 
   SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,cet34,
                   cet08,cet25,cet11,cet27,cet29,
                   cet24,cet26,cet28,cetconf,cet21,
                   cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
    INTO g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
         g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
         g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
         g_cet.cet28,g_cet.cetconf,g_cet.cet21,
         g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
         g_cet.cetdate,g_cet.cet38                   
    FROM cet_file 
   WHERE cet01=g_cet.cet01
   
   IF g_cet.cetconf = 'Y' THEN
      RETURN
   END IF
 
   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF   
   
#CHI-C30107 ---------- mark ---------- begin
#  IF NOT cl_confirm('axm-108') THEN
#     RETURN
#  END IF   
#CHI-C30107 ---------- mark ---------- end   
   LET g_success='Y'
   BEGIN WORK
   OPEN t770_cl USING g_cet.cet01
   IF STATUS THEN
      CALL cl_err("OPEN t770_cl:", STATUS, 1)
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t770_cl INTO g_cet.cet08,g_cet.cet25,g_cet.cet11,
                      g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
                      g_cet.cet28,g_cet.cet38    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE cet_file 
      SET cetconf='Y',
          cet21=g_today
    WHERE cet01 = g_cet.cet01
   IF STATUS THEN
     CALL cl_err3("upd","cet_file",g_cet.cet01,g_cet.cet01,STATUS,"","upd cetconf",1)
     LET g_success='N'     
   END IF
 
   UPDATE oga_file 
      SET oga39 = g_cet.cet29  #出口報關單號 
    WHERE oga01 = g_cet.cet01
   IF STATUS THEN
     CALL cl_err3("upd","oga_file",g_cet.cet01,"",STATUS,"","upd oga39",1)
     LET g_success='N'     
   END IF      
      
   IF g_success = 'Y' THEN
      LET g_cet.cetconf = 'Y'
      LET g_cet.cet21 = g_today
      COMMIT WORK
      DISPLAY BY NAME g_cet.cetconf,g_cet.cet21
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF
END FUNCTION
 
 
FUNCTION t770_z()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cet.cet01) THEN
     RETURN
   END IF           
       
   SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,cet34,
                   cet08,cet25,cet11,cet27,cet29,
                   cet24,cet26,cet28,cetconf,cet21,
                   cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
    INTO g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
         g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
         g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
         g_cet.cet28,g_cet.cetconf,g_cet.cet21,
         g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
         g_cet.cetdate,g_cet.cet38                   
    FROM cet_file 
   WHERE cet01=g_cet.cet01
      
   IF g_cet.cetconf = 'N' THEN
      RETURN
   END IF
 
   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF                    
          
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t770_cl USING g_cet.cet01
   IF STATUS THEN
      CALL cl_err("OPEN t770_cl:", STATUS, 1)
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t770_cl INTO g_cet.cet08,g_cet.cet25,g_cet.cet11,
                      g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
                      g_cet.cet28,g_cet.cet38    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE cet_file 
      SET cetconf='N',
          cet21=''
    WHERE cet01 = g_cet.cet01
   IF STATUS THEN
     CALL cl_err3("upd","cet_file",g_cet.cet01,g_cet.cet01,STATUS,"","upd cetconf",1)
     LET g_success='N'     
   END IF
 
   UPDATE oga_file 
      SET oga39 = '' 
    WHERE oga01 = g_cet.cet01
   IF STATUS THEN
      CALL cl_err3("upd","oga_file",g_cet.cet01,g_cet.cet01,STATUS,"","upd oga39",1)
      LET g_success='N'     
   END IF
   
   IF g_success = 'Y' THEN
      LET g_cet.cetconf = 'N'
      LET g_cet.cet21 = ''
      COMMIT WORK
      DISPLAY BY NAME g_cet.cetconf,g_cet.cet21
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF
END FUNCTION
 
 
 
FUNCTION t770_default_data()
   DEFINE l_ced02 LIKE ced_file.ced02
   DEFINE l_cec02 LIKE cec_file.cec02
   DEFINE l_ged02 LIKE ged_file.ged02
   DEFINE l_acti LIKE type_file.chr1
   
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cet.cet01) THEN
     RETURN
   END IF  
   
   OPEN WINDOW t770_a AT 9,29 WITH FORM "aco/42f/acot770a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("acot770a")
 
   IF g_login_cnt=1 THEN 
     INITIALIZE tm.* TO NULL 
   ELSE
     DISPLAY BY NAME tm.cet08,tm.cet25,tm.cet27,tm.cet29,
        tm.cet24,tm.cet26,tm.cet28
   END IF
   LET tm_t.*=tm.*
 
  #              報單日期 提運單號 批准文號 出口報關單號  
   INPUT BY NAME tm.cet08,tm.cet25,tm.cet27,tm.cet29,
  #              交運方式 成交方式 用途   
                 tm.cet24,tm.cet26,tm.cet28 WITHOUT DEFAULTS     
      
      AFTER FIELD cet28 #用途 
         IF NOT cl_null(tm.cet28) THEN
            LET g_errno = ' '
            SELECT cec02,cecacti INTO l_cec02,l_acti
              FROM cec_file
             WHERE cec01 = tm.cet28
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1306'
                                           LET l_cec02 = NULL
                 WHEN l_acti='N' LET g_errno = '9028'
                 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet28
            END IF
            DISPLAY l_cec02 TO cec02
         ELSE 
            LET l_cec02 = NULL
            DISPLAY l_cec02 TO cec02
         END IF
 
      AFTER FIELD cet24 #交運方式
         IF NOT cl_null(tm.cet24) THEN
            LET g_errno = ' '
            SELECT ged02 INTO l_ged02
              FROM ged_file
             WHERE ged01 = tm.cet24
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-309'
                 OTHERWISE      LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet24
            END IF
            DISPLAY l_ged02 TO ged02
         ELSE 
            LET l_ged02 = NULL
            DISPLAY l_ged02 TO ged02
         END IF
 
      AFTER FIELD cet26 #成交方式
         IF NOT cl_null(tm.cet26) THEN
            LET g_errno = ' '
            SELECT ced02,cedacti INTO l_ced02,l_acti
              FROM ced_file
             WHERE ced01 = tm.cet26
            CASE 
               WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-739'
                                         LET l_ced02 = NULL
               WHEN l_acti='N' LET g_errno = '9028'
                               LET l_ced02 = NULL
               OTHERWISE       LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cet26
            END IF
            DISPLAY l_ced02 TO ced02
         ELSE
            LET l_ced02 = NULL
            DISPLAY l_ced02 TO ced02
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cet28)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_cec01"
               LET g_qryparam.default1 = tm.cet28
               CALL cl_create_qry() RETURNING tm.cet28
               SELECT cec02 INTO l_cec02
                 FROM cec_file WHERE cec01 = tm.cet28
               DISPLAY l_cec02 TO cec02
               DISPLAY BY NAME tm.cet28
            WHEN INFIELD(cet24)  #交運方式
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ged"
               LET g_qryparam.default1 = tm.cet24
               CALL cl_create_qry() RETURNING tm.cet24
               SELECT ged02 INTO l_ged02
                 FROM ged_file
                WHERE ged01 = tm.cet24
               DISPLAY l_ged02 TO ged02
               DISPLAY BY NAME tm.cet24
            WHEN INFIELD(cet26)  #成交方式
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ced01"
               LET g_qryparam.default1 = tm.cet26
               CALL cl_create_qry() RETURNING tm.cet26
               SELECT ced02 INTO l_ced02
                 FROM ced_file
                WHERE ced01 = tm.cet26
               DISPLAY l_ced02 TO ced02
               DISPLAY BY NAME tm.cet26
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
      CLOSE WINDOW t770_a
      RETURN
   END IF
   LET g_login_cnt=0
   CLOSE WINDOW t770_a
END FUNCTION
 
 
FUNCTION t770_default_data_update()
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cet.cet01) THEN
     RETURN
   END IF
   IF g_login_cnt=1 THEN RETURN END IF
   
   SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,cet34,
                   cet08,cet25,cet11,cet27,cet29,
                   cet24,cet26,cet28,cetconf,cet21,
                   cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
    INTO g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
         g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
         g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
         g_cet.cet28,g_cet.cetconf,g_cet.cet21,
         g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
         g_cet.cetdate,g_cet.cet38                   
    FROM cet_file WHERE cet01=g_cet.cet01
      
   IF g_cet.cetconf = 'Y' THEN
      CALL cl_err('','axr-913',0)
      RETURN
   END IF
 
   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('aco-740') THEN
      RETURN
   END IF                    
          
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t770_cl USING g_cet.cet01
   IF STATUS THEN
      CALL cl_err("OPEN t770_cl:", STATUS, 1)
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t770_cl INTO g_cet.cet08,g_cet.cet25,g_cet.cet11,
                      g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
                      g_cet.cet28,g_cet.cet38    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE cet_file 
      SET cet08=tm.cet08,
          cet25=tm.cet25,
          cet27=tm.cet27,
          cet29=tm.cet29,
          cet24=tm.cet24,
          cet26=tm.cet26,
          cet28=tm.cet28
    WHERE cet01 = g_cet.cet01
   IF STATUS THEN
     CALL cl_err3("upd","cet_file",g_cet.cet01,g_cet.cet01,STATUS,"","upd cetconf",1)
     LET g_success='N'     
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,
                      cet34,cet08,cet25,cet11,
                      cet27,cet29, cet24,cet26,cet28,cetconf,cet21,
                      cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
        INTO g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
             g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
             g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,g_cet.cet28,
             g_cet.cetconf,g_cet.cet21,
             g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
             g_cet.cetdate,g_cet.cet38                   
        FROM cet_file 
       WHERE cet01=g_cet.cet01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","cet_file",g_cet.cet01,"",SQLCA.sqlcode,"","",1)
         INITIALIZE g_cet.* TO NULL
         RETURN
      END IF   
      CALL t770_show()        
   ELSE
      LET g_success='N'
      ROLLBACK WORK
   END IF
END FUNCTION
 
 
 
FUNCTION t770_r()  
   IF s_shut(0) THEN RETURN END IF
 
   IF g_cet.cet01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT DISTINCT cet01,cet03,cet05,cet06,cet09,cet34,
                   cet08,cet25,cet11,cet27,cet29,
                   cet24,cet26,cet28,cetconf,cet21,
                   cetacti,cetuser,cetgrup,cetmodu,cetdate,cet38 
    INTO g_cet.cet01,g_cet.cet03,g_cet.cet05,g_cet.cet06,g_cet.cet09,
         g_cet.cet34,g_cet.cet08,g_cet.cet25,g_cet.cet11,
         g_cet.cet27,g_cet.cet29,g_cet.cet24,g_cet.cet26,
         g_cet.cet28,g_cet.cetconf,g_cet.cet21,
         g_cet.cetacti,g_cet.cetuser,g_cet.cetgrup,g_cet.cetmodu,
         g_cet.cetdate,g_cet.cet38                   
    FROM cet_file 
   WHERE cet01=g_cet.cet01
 
   IF g_cet.cetacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_cet.cet01,9027,0)
      RETURN
   END IF
 
   IF g_cet.cetconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_cet.cetconf = 'Y' THEN 
      CALL cl_err('','9023',0)
      RETURN
   END IF
         
   BEGIN WORK
 
   OPEN t770_cl USING g_cet.cet01
   IF STATUS THEN
      CALL cl_err("OPEN t770_cl:", STATUS, 1)
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t770_cl INTO g_cet.cet08,g_cet.cet25,g_cet.cet11,
                      g_cet.cet27,g_cet.cet29,g_cet.cet24,
                      g_cet.cet26,g_cet.cet28,g_cet.cet38    # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cet.cet01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t770_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM cet_file WHERE cet01=g_cet.cet01
 
      INITIALIZE g_cet.* TO NULL
      CLEAR FORM
      CALL g_cet_b.clear()
 
      OPEN t770_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t770_b_cs
         CLOSE t770_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t770_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t770_b_cs
         CLOSE t770_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cn1     
 
      OPEN t770_b_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t770_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t770_fetch('/')
      END IF
   END IF
 
   CLOSE t770_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t770_show_pic()
  IF g_cet.cetconf = 'X' THEN
     LET g_void = 'Y'
  ELSE
     LET g_void = 'N'
  END IF
  CALL cl_set_field_pic(g_cet.cetconf,"","","",g_void,g_cet.cetacti)
END FUNCTION
 
FUNCTION t770_set_entry_b()
 
  CALL cl_set_comp_entry("cet17",TRUE)
 
END FUNCTION
            
FUNCTION t770_set_no_entry_b()
  CALL cl_set_comp_entry("cet02,cet04,ima02,ima021,cet15,cet16,
                          cet14,cet36,cet37,cet35,cet10,cet31,cet32,cet33",FALSE)
END FUNCTION
#FUN-930151
