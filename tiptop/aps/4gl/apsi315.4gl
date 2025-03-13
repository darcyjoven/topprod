# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apsi315.4gl
# Descriptions...: 鎖定設備維護作業
# Input parameter:
# Modify.........: No:FUN-960103 09/06/26 By Duke 將原單檔架構改變為假雙檔方式
# Modify.........: No:FUN-980080 09/08/20 By Mandy APS多機台鎖定功能調整
# Modify.........: No.FUN-A70036 10/08/11 By Mandy aeci700點選"APS鎖定使用設備"按鈕時,若資源編號(vne05)沒有輸入,則不insert資料至vne_file
# Modify.........: No.FUN-B50101 11/05/17 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-BA0024 11/10/27 By Abby 不控卡已確認(sfb87 = 'Y')

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_sfb           RECORD LIKE sfb_file.*,   #FUN-870092
    g_vne_a         RECORD LIKE vne_file.*,   #頭
    g_vne_a_t       RECORD LIKE vne_file.*,
    g_vne01_t       LIKE vne_file.vne01,
    g_vne02_t       LIKE vne_file.vne02,
    g_vne03_t       LIKE vne_file.vne03,
    g_vne04_t       LIKE vne_file.vne04,
    g_vne012_t      LIKE vne_file.vne012, #FUN-B50101 add
    g_vne_b         DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        vne05         LIKE vne_file.vne05,
        desc          LIKE eci_file.eci06,      
        vne50         LIKE vne_file.vne50,   
        vne51         LIKE vne_file.vne51,
        vne06         LIKE vne_file.vne06,
        vne311        LIKE vne_file.vne311,
        vne312        LIKE vne_file.vne312,
        vne313        LIKE vne_file.vne313,
        vne314        LIKE vne_file.vne314,
        vne315        LIKE vne_file.vne315,
        vne316        LIKE vne_file.vne316,
        vne07         LIKE vne_file.vne07
                    END RECORD,
    g_vne_b_t       RECORD                 #程式變數 (舊值)
        vne05         LIKE vne_file.vne05,
        desc          LIKE eci_file.eci06,
        vne50         LIKE vne_file.vne50,
        vne51         LIKE vne_file.vne51,
        vne06         LIKE vne_file.vne06,
        vne311        LIKE vne_file.vne311,
        vne312        LIKE vne_file.vne312,
        vne313        LIKE vne_file.vne313,
        vne314        LIKE vne_file.vne314,
        vne315        LIKE vne_file.vne315,
        vne316        LIKE vne_file.vne316,
        vne07         LIKE vne_file.vne07
                    END RECORD,
     g_wc,g_sql          STRING,
     g_wc2               STRING,
    g_argv1         LIKE vne_file.vne01,   #工單編號
    g_argv2         LIKE vne_file.vne02,   #途程編號
    g_argv3         LIKE vne_file.vne03,   #製程序號
    g_argv4         LIKE vne_file.vne04,   #作業編號
    g_argv5         LIKE vne_file.vne012,  #製程段號 FUN-B50101 add
    g_rec_b         LIKE type_file.num5,   #單身筆數        
    p_row,p_col     LIKE type_file.num5,   
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  
    g_cmd           LIKE type_file.chr1000,
   #g_vne_rowid     LIKE type_file.chr18, #FUN-B50101 mark
    g_ecm45         LIKE ecm_file.ecm45,
    g_sma917        LIKE sma_file.sma917

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL    
DEFINE g_before_input_done  LIKE type_file.num5          

DEFINE   g_cnt          LIKE type_file.num10        
DEFINE   g_i            LIKE type_file.num5         
DEFINE   g_msg          LIKE type_file.chr1000      
DEFINE   g_row_count    LIKE type_file.num10        
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   g_jump         LIKE type_file.num10        
DEFINE   mi_no_ask      LIKE type_file.num5         

MAIN
    DEFINE l_cnt        LIKE type_file.num5     #FUN-A70036 add

    #FUN-B50101---mod---str---
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    #FUN-B50101---mod---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    

   LET g_argv1 =ARG_VAL(1)              #工單編號
   LET g_argv2 =ARG_VAL(2)              #途程編號
   LET g_argv3 =ARG_VAL(3)              #製程序號
   LET g_argv4 =ARG_VAL(4)              #作業編號
   LET g_argv5 =ARG_VAL(5)              #製程段號 #FUN-B50101 add
   LET g_vne01_t = NULL

   LET g_vne_a.vne01 =g_argv1              #工單編號
   LET g_vne_a.vne02 =g_argv2              #途程編號
   LET g_vne_a.vne03 =g_argv3              #製程序號
   LET g_vne_a.vne04 =g_argv4              #作業編號
   LET g_vne_a.vne012 =g_argv5             #製程段號 #FUN-B50101 add

   LET p_row = 3 LET p_col = 20
   OPEN WINDOW i315_w AT p_row,p_col
        WITH FORM "aps/42f/apsi315"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("vne012",g_sma.sma541='Y')  #FUN-B50101 add

 
   IF NOT cl_null(g_argv1) AND
      NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) AND
      NOT cl_null(g_argv4) THEN 
        SELECT * INTO g_sfb.*
          FROM sfb_file
         WHERE sfb01 = g_argv1
        CALL i315_q()
   #FUN-A70036--mark---str---
   #    CALL i315_menu()
   #ELSE
   #    CALL i315_menu()
   #FUN-A70036--mark---end---
    END IF
    #FUN-A70036--add---str--
    LET g_vne_a.vne01 =g_argv1              #工單編號
    LET g_vne_a.vne02 =g_argv2              #途程編號
    LET g_vne_a.vne03 =g_argv3              #製程序號
    LET g_vne_a.vne04 =g_argv4              #作業編號
    LET g_vne_a.vne012 =g_argv5             #製程段號 #FUN-B50101
    CALL i315_show()
    CALL i315_menu()
    #FUN-A70036--add---end--

    CLOSE WINDOW i315_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
          RETURNING g_time  

END MAIN

#QBE 查詢資料
FUNCTION i315_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
   CLEAR FORM                             #清除畫面

   CALL g_vne_b.clear()

 IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) OR
    cl_null(g_argv4)  THEN
     CALL cl_set_head_visible("","YES")    

     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          vne01,vne02,vne03,vne04,vne012   #FUN-B50101 add vne012

     BEFORE CONSTRUCT
            CALL cl_qbe_init()

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
	 CALL cl_qbe_list() RETURNING lc_qbe_sn
	 CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
 ELSE 
     DISPLAY BY NAME g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
      LET g_wc = "     vne01 ='",g_vne_a.vne01,"'",
                 " AND vne02 ='",g_vne_a.vne02,"'",
                 " AND vne03 ='",g_vne_a.vne03,"' ",
                 " AND vne04 ='",g_vne_a.vne04,"' ",
                 " AND vne012 ='",g_vne_a.vne012,"' " #FUN-B50101 add vne012
 END IF
 IF INT_FLAG THEN RETURN END IF
 #資料權限的檢查
 IF g_priv2='4' THEN                           #只能使用自己的資料
     LET g_wc = g_wc clipped," AND vneuser = '",g_user,"'"
 END IF
 IF g_priv3='4' THEN                           #只能使用相同群的資料
     LET g_wc = g_wc clipped," AND vnegrup MATCHES '",g_grup CLIPPED,"*'"
 END IF

 IF g_priv3 MATCHES "[5678]" THEN    #群組權限
     LET g_wc = g_wc clipped," AND vnegrup IN ",cl_chk_tgrup_list()
 END IF

 IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) OR
    cl_null(g_argv4) THEN
     CONSTRUCT g_wc2 ON vne05 ,vne50,vne51,vne06,vne311,vne312,vne313,vne314,          # 螢幕上取單身條件 
                        vne315,vne316,vne07
               FROM s_vne[1].vne05 ,s_vne[1].vne50 ,s_vne[1].vne51 ,
                    s_vne[1].vne06 ,s_vne[1].vne311 ,s_vne[1].vne312 ,
                    s_vne[1].vne313,s_vne[1].vne314,s_vne[1].vne315,
                    s_vne[1].vne316,vne07
     
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)

        ON ACTION controlp
         CASE
            WHEN INFIELD(vne05)                 #生產站別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 IF g_sma.sma917 = 0 THEN
                     LET g_qryparam.form     = "q_eca1"
                 ELSE
                     LET g_qryparam.form     = "q_eci"
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vne05
                 NEXT FIELD vne05
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
     
        ON ACTION qbe_save
           CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
 ELSE 
     LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT UNIQUE vne01,vne02,vne03,vne04,vne012 FROM vne_file ", #FUN-B50101 add vne012
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY vne01,vne02,vne03,vne04,vne012 "                    #FUN-B50101 add vne012
    ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE vne01,vne02,vne03,vne04,vne012 FROM vne_file ", #FUN-B50101 add vne012
                      "  FROM vne_file ",
                      " WHERE ",g_wc  CLIPPED, 
                      "   AND ",g_wc2 CLIPPED,
                      " ORDER BY vne01,vne02,vne03,vne04,vne012"                     #FUN-B50101 add vne012
    END IF

    PREPARE i315_prepare FROM g_sql
    DECLARE i315_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i315_prepare

    LET g_forupd_sql = "SELECT * FROM vne_file ",
                       " WHERE vne01 = ? ",
                       "   AND vne02 = ? ",
                       "   AND vne03 = ? ",
                       "   AND vne04 = ? ",
                       "   AND vne012 = ? ", #FUN-B50101 add vne012
                      #" FOR UPDATE NOWAIT " #FUN-B50101 mark
                       " FOR UPDATE " #FUN-B50101 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50101 add

    DECLARE i315_cl CURSOR FROM g_forupd_sql

   LET g_sql= "SELECT vne01,vne02,vne03,vne04,vne012 FROM vne_file ", #FUN-B50101 add vne012
              " WHERE ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " GROUP BY vne01,vne02,vne03,vne04,vne012 ",            #FUN-B50101 add vne012
              " INTO TEMP x "
   DROP TABLE x
   PREPARE i315_precount_x FROM g_sql
   EXECUTE i315_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i315_pp FROM g_sql
   DECLARE i315_count CURSOR FOR i315_pp

END FUNCTION

FUNCTION i315_menu()

   WHILE TRUE
      CALL i315_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i315_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i315_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vne_b),'','')
            END IF
         #apsi315
         WHEN "aps_lock_used_time"
            IF cl_chk_act_auth() THEN
                CALL i315_aps_vnd()
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_vne_a.vne01 IS NOT NULL THEN
                LET g_doc.column1 = "vne01"
                LET g_doc.column2 = "vne02"
                LET g_doc.column3 = "vne03"
                LET g_doc.column4 = "vne04"
                LET g_doc.column5 = "vne012"      #FUN-B50101 add vne012
                LET g_doc.value1 = g_vne_a.vne01
                LET g_doc.value2 = g_vne_a.vne02
                LET g_doc.value3 = g_vne_a.vne03
                LET g_doc.value4 = g_vne_a.vne04
                LET g_doc.value5 = g_vne_a.vne012 #FUN-B50101 add vne012
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION i315_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_vne_b.clear()
    CALL i315_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i315_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vne_a.* TO NULL
        #FUN-A70036--add---str--
        LET g_vne_a.vne01 =g_argv1              #工單編號
        LET g_vne_a.vne02 =g_argv2              #途程編號
        LET g_vne_a.vne03 =g_argv3              #製程序號
        LET g_vne_a.vne04 =g_argv4              #作業編號
        LET g_vne_a.vne012 =g_argv5             #製程段號 #FUN-B50101 add vne012
        #FUN-A70036--add---end--
    ELSE
        CALL i315_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i315_count
        FETCH i315_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i315_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     i315_cs INTO g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
        WHEN 'P' FETCH PREVIOUS i315_cs INTO g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
        WHEN 'F' FETCH FIRST    i315_cs INTO g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
        WHEN 'L' FETCH LAST     i315_cs INTO g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump i315_cs INTO g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vne_a.vne01,SQLCA.sqlcode,0)
        INITIALIZE g_vne_a.* TO NULL  
        #FUN-A70036--add---str--
        LET g_vne_a.vne01 =g_argv1              #工單編號
        LET g_vne_a.vne02 =g_argv2              #途程編號
        LET g_vne_a.vne03 =g_argv3              #製程序號
        LET g_vne_a.vne04 =g_argv4              #作業編號
        LET g_vne_a.vne012 =g_argv5             #製程段號 #FUN-B50101 add 
        #FUN-A70036--add---end--
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
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vne_file",g_vne_a.vne01,g_vne_a.vne02,SQLCA.sqlcode,"","",1) 
        INITIALIZE g_vne_a.* TO NULL
        #FUN-A70036--add---str--
        LET g_vne_a.vne01 =g_argv1              #工單編號
        LET g_vne_a.vne02 =g_argv2              #途程編號
        LET g_vne_a.vne03 =g_argv3              #製程序號
        LET g_vne_a.vne04 =g_argv4              #作業編號
        LET g_vne_a.vne012 =g_argv5             #製程段號 #FUN-B50101 add
        #FUN-A70036--add---end--
        RETURN
    ELSE
        LET g_data_owner = g_vne_a.vneuser      
        LET g_data_group = g_vne_a.vnegrup     
        CALL i315_show()
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i315_show()


    LET g_vne_a_t.* = g_vne_a.*            #保存單頭舊值
    DISPLAY BY NAME                        #顯示單頭值
        g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012

    LET g_ecm45 = ''
    LET g_sma917 = g_sma.sma917
    SELECT ecm45 
      INTO g_ecm45
      FROM ecm_file
     WHERE ecm01 = g_vne_a.vne01
       AND ecm03 = g_vne_a.vne03
   #FUN-A70036---mod---str---
    DISPLAY g_sma917,g_ecm45 TO sma917,ecm45
   #DISPLAY BY NAME g_sma917,g_ecm45 
   #FUN-A70036---mod---end---

    CALL i315_b_fill(g_wc2)                 #單身

    CALL cl_show_fld_cont()                   
END FUNCTION
#單身
FUNCTION i315_b()
DEFINE    l_ecm50      LIKE ecm_file.ecm50  #FUN-A70036 add
DEFINE    l_ecm51      LIKE ecm_file.ecm51  #FUN-A70036 add
DEFINE
    l_cnt           LIKE type_file.num5,          
    l_min_vne50     LIKE vne_file.vne50,    #最小的開工日
    l_max_vne51     LIKE vne_file.vne51,    #最大的完成日
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT       
    l_n             LIKE type_file.num5,    #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       
    p_cmd           LIKE type_file.chr1,    #處理狀態        
    l_allow_insert  LIKE type_file.num5,    #可新增否       
    l_allow_delete  LIKE type_file.num5     #可刪除否      

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_vne_a.vne01) OR cl_null(g_vne_a.vne02) OR 
       cl_null(g_vne_a.vne03) OR cl_null(g_vne_a.vne04) OR 
       g_vne_a.vne012 IS NULL THEN #FUN-B50101 add vne012
        RETURN
    END IF
    SELECT * INTO g_sfb.*
      FROM sfb_file
     WHERE sfb01 = g_vne_a.vne01
    IF g_sfb.sfb04 = '8' THEN CALL cl_err('','aap-730',1) RETURN END IF
   #IF g_sfb.sfb87 = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF #FUN-BA0024 mark
    IF g_sfb.sfb87 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT vne05 ,'',vne50,vne51,vne06, ",
                       " vne311,vne312,vne313,vne314,vne315,vne316,vne07  FROM vne_file ",
                       " WHERE vne01 = ? ",
                       "   AND vne02 = ? ",
                       "   AND vne03 = ? ",
                       "   AND vne04 = ? ", 
                       "   AND vne012 = ? ",  #FUN-B50101 add
                       "   AND vne05 = ? ",
                      #" FOR UPDATE NOWAIT " #FUN-B50101 add
                       " FOR UPDATE "        #FUN-B50101 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50101 add

    DECLARE i315_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_vne_b WITHOUT DEFAULTS FROM s_vne.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            IF g_rec_b >= l_ac THEN #FUN-980080 add
               BEGIN WORK
               
               OPEN i315_cl USING g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_vne_a.vne012 #FUN-B50101 add vne012
               IF STATUS THEN
                  CALL cl_err("OPEN i315_cl_b1", STATUS, 1)
                  CLOSE i315_cl
                  ROLLBACK WORK
                  RETURN
               END IF
               
               FETCH i315_cl INTO g_vne_a.*   # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err('Fetch i315_cl_b2',SQLCA.sqlcode,1)
                  CLOSE i315_cl
                  ROLLBACK WORK
                  RETURN
               END IF

           #IF g_rec_b >= l_ac THEN #FUN-980080 mark
               LET p_cmd='u'
               LET g_vne_b_t.* = g_vne_b[l_ac].*  #BACKUP 

               OPEN i315_bcl USING g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,
                                   g_vne_a.vne04,g_vne_a.vne012,g_vne_b_t.vne05 #FUN-B50101 add vne012
               IF STATUS THEN
                  CALL cl_err("OPEN i315_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i315_bcl INTO g_vne_b[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('Fetch i315_bcl',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                     IF g_sma.sma917 = 0 THEN
                     #工作站
                        CALL i315_vne05_0(l_ac)
                     ELSE
                     #機器編號
                        CALL i315_vne05_1(l_ac)
                     END IF
                     LET g_vne_b_t.*=g_vne_b[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     
             END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vne_b[l_ac].* TO NULL   
           #FUN-A70036---add----str---
            IF l_ac = 1 THEN
                LET g_vne_b[l_ac].vne06  = g_sfb.sfb08
            END IF
            LET g_vne_b[l_ac].vne311 = 0
            LET g_vne_b[l_ac].vne312 = 0
            LET g_vne_b[l_ac].vne313 = 0
            LET g_vne_b[l_ac].vne314 = 0
            LET g_vne_b[l_ac].vne315 = 0
            LET g_vne_b[l_ac].vne316 = 0
            LET g_vne_b[l_ac].vne07  = 0
           #FUN-A70036---add----end---
           #FUN-A70036--mod----str---
           #LET g_vne_b[l_ac].vne50 = g_today
           #LET g_vne_b[l_ac].vne51 = g_today
            SELECT ecm50,ecm51 INTO l_ecm50,l_ecm51 
              FROM ecm_file
             WHERE ecm01 = g_vne_a.vne01
               AND ecm03 = g_vne_a.vne03
            LET g_vne_b[l_ac].vne50 = l_ecm50
            LET g_vne_b[l_ac].vne51 = l_ecm51
           #FUN-A70036--mod----end---
            LET g_vne_b_t.* = g_vne_b[l_ac].*                  #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD vne05

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO vne_file(vne01,vne02,vne03,vne04,vne012,vne05,vne06,vne07,vne50,vne51, #FUN-B50101 add vne012
                                 vne311,vne312,vne313,vne314,vne315,vne316)
                           VALUES(g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,
                                  g_vne_a.vne04,g_vne_a.vne012, #FUN-B50101 add vne012
                                  g_vne_b[l_ac].vne05,g_vne_b[l_ac].vne06,
                                  g_vne_b[l_ac].vne07,g_vne_b[l_ac].vne50,
                                  g_vne_b[l_ac].vne51,0,0,0,0,0,0)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vne_file",g_vne_a.vne01,g_vne_a.vne02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
           #CALL i315_aps_vnd() #FUN-980080 mark
            CALL s_upd_vne06(g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_sfb.sfb08)
           #CALL i315_b_fill(g_wc2) #FUN-980080 mark

        AFTER FIELD vne05                  
            IF NOT cl_null(g_vne_b[l_ac].vne05) THEN 
               IF g_sma.sma917 = 0 THEN 
                   #工作站
                   CALL i315_vne05_0(l_ac)
               ELSE
                   #機器編號
                   CALL i315_vne05_1(l_ac)
               END IF
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('vne05:',g_errno,1)
                   LET g_vne_b[l_ac].vne05 = g_vne_b_t.vne05
                   DISPLAY BY NAME g_vne_b[l_ac].vne05
                   NEXT FIELD vne05
               END IF
               IF g_vne_b[l_ac].vne06 IS NULL THEN
                  LET g_vne_b[l_ac].vne06 = 0
               END IF

               IF g_vne_b[l_ac].vne311 IS NULL THEN
                  LET g_vne_b[l_ac].vne311 = 0
               END IF
               IF g_vne_b[l_ac].vne312 IS NULL THEN
                  LET g_vne_b[l_ac].vne312 = 0
               END IF
               IF g_vne_b[l_ac].vne313 IS NULL THEN
                  LET g_vne_b[l_ac].vne313 = 0
               END IF
               IF g_vne_b[l_ac].vne314 IS NULL THEN
                  LET g_vne_b[l_ac].vne314 = 0
               END IF
               IF g_vne_b[l_ac].vne315 IS NULL THEN
                  LET g_vne_b[l_ac].vne315 = 0
               END IF
               IF g_vne_b[l_ac].vne316 IS NULL THEN
                  LET g_vne_b[l_ac].vne316 = 0
               END IF
               IF g_vne_b[l_ac].vne07 IS NULL THEN
                  LET g_vne_b[l_ac].vne07 = 0
               END IF

               IF g_vne_b[l_ac].vne05 != g_vne_b_t.vne05 OR 
                  cl_null(g_vne_b_t.vne05) THEN
                   SELECT count(*) INTO l_n FROM vne_file
                    WHERE vne01 = g_vne_a.vne01
                      AND vne02 = g_vne_a.vne02
                      AND vne03 = g_vne_a.vne03
                      AND vne04 = g_vne_a.vne04
                      AND vne012 = g_vne_a.vne012 #FUN-B50101 add
                      AND vne05 = g_vne_b[l_ac].vne05
                   IF l_n > 0 THEN
                       CALL cl_err(g_vne_b[l_ac].vne05,-239,1)
                       LET g_vne_b[l_ac].vne05 = g_vne_b_t.vne05
                       NEXT FIELD vne05
                   END IF

                   #==>刪除舊的vnd_file資料
                   SELECT count(*) INTO l_n FROM vnd_file
                    WHERE vnd01 = g_vne_a.vne01
                      AND vnd02 = g_vne_a.vne02
                      AND vnd03 = g_vne_a.vne03
                      AND vnd04 = g_vne_a.vne04
                      AND vnd012 = g_vne_a.vne012 #FUN-B50101 add
                     #AND vnd05 = g_vnd_b_t.vnd05 #FUN-A70036 mark
                      AND vnd05 = g_vne_b_t.vne05 #FUN-A70036 add
                   IF l_n > 0 THEN
                      #FUN-A70036--mark--str---
                      #DELETE FROM vnd_file
                      # WHERE vnd01 = g_vne_a.vne01
                      #   AND vnd02 = g_vne_a.vne02
                      #   AND vnd03 = g_vne_a.vne03
                      #   AND vnd04 = g_vne_a.vne04
                      #   AND vnd05 = g_vne_b_t.vne05
                      # IF SQLCA.sqlcode THEN
                      #     CALL cl_err3("delete","vne_file",g_vne_a.vne01,g_vne_a.vne03,SQLCA.sqlcode,"","",1)
                      # END IF
                      #FUN-A70036--mark--str---
                      #FUN-A70036--add---str---
                       IF cl_confirm('aps-315') THEN #資源編號已異動,是否延用舊有的"APS鎖定設備時間"資料?
                          UPDATE vnd_file
                             SET vnd05 = g_vne_b[l_ac].vne05
                           WHERE vnd01 = g_vne_a.vne01
                             AND vnd02 = g_vne_a.vne02
                             AND vnd03 = g_vne_a.vne03
                             AND vnd04 = g_vne_a.vne04
                             AND vnd012 = g_vne_a.vne012 #FUN-B50101 add
                             AND vnd05 = g_vne_b_t.vne05
                       ELSE
                           DELETE FROM vnd_file
                            WHERE vnd01 = g_vne_a.vne01
                              AND vnd02 = g_vne_a.vne02
                              AND vnd03 = g_vne_a.vne03
                              AND vnd04 = g_vne_a.vne04
                              AND vnd012 = g_vne_a.vne012 #FUN-B50101 add
                              AND vnd05 = g_vne_b_t.vne05
                       END IF 
                       IF SQLCA.sqlcode THEN
                           CALL cl_err3("change vne_file","vne_file",g_vne_a.vne01,g_vne_a.vne03,SQLCA.sqlcode,"","",1) 
                       END IF
                      #FUN-A70036--add---end---
                   END IF
               END IF
           #FUN-980080 mark
           #ELSE
           #  NEXT FIELD vne05
            END IF

        AFTER FIELD vne51
            IF g_vne_b[l_ac].vne51<g_vne_b[l_ac].vne50 THEN
                CALL cl_err('','aec-993',1) #完工日期不可小於開工日期
                LET g_vne_b[l_ac].vne51 = g_vne_b_t.vne51
                DISPLAY BY NAME g_vne_b[l_ac].vne51
                NEXT FIELD vne51
            END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vne_b_t.vne05) THEN

                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vne_file
                 WHERE vne01 = g_vne_a.vne01 
                   AND vne02 = g_vne_a.vne02
                   AND vne03 = g_vne_a.vne03
                   AND vne04 = g_vne_a.vne04 
                   AND vne012 = g_vne_a.vne012 #FUN-B50101 add
                   AND vne05 = g_vne_b_t.vne05
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN #FUN-980080 mod
                   CALL cl_err3("del","vne_file",g_vne_a.vne01,g_vne_a.vne02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                #FUN-980080---mod---str---
                SELECT COUNT(*) INTO l_cnt
                  FROM vnd_file
                  WHERE vnd01 = g_vne_a.vne01
                    AND vnd02 = g_vne_a.vne02
                    AND vnd03 = g_vne_a.vne03
                    AND vnd04 = g_vne_a.vne04
                    AND vnd012 = g_vne_a.vne012 #FUN-B50101 add
                    AND vnd05 = g_vne_b_t.vne05
                IF l_cnt >= 1 THEN
                    DELETE FROM vnd_file
                      WHERE vnd01 = g_vne_a.vne01
                        AND vnd02 = g_vne_a.vne02
                        AND vnd03 = g_vne_a.vne03
                        AND vnd04 = g_vne_a.vne04
                        AND vnd012 = g_vne_a.vne012 #FUN-B50101 add
                        AND vnd05 = g_vne_b_t.vne05
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL cl_err3("del","vne_file",g_vne_a.vne01,g_vne_b_t.vne06,SQLCA.sqlcode,"","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                END IF
                #FUN-980080---mod---end---
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF
             CALL s_upd_vne06(g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_sfb.sfb08)
            #CALL i315_b_fill(g_wc2) #FUN-980080 mark

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vne_b[l_ac].* = g_vne_b_t.*
               CLOSE i315_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vne_b[l_ac].vne05,-263,1)
               LET g_vne_b[l_ac].* = g_vne_b_t.*
            ELSE
               UPDATE vne_file 
                  SET vne05=g_vne_b[l_ac].vne05,
                      vne06=g_vne_b[l_ac].vne06,
                      vne50=g_vne_b[l_ac].vne50,
                      vne51=g_vne_b[l_ac].vne51
                WHERE vne01=g_vne_a.vne01 
                  AND vne02=g_vne_a.vne02 
                  AND vne03=g_vne_a.vne03
                  AND vne04=g_vne_a.vne04 
                  AND vne012 = g_vne_a.vne012 #FUN-B50101 add
                  AND vne05=g_vne_b_t.vne05
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","vne_file",g_vne_a.vne01,g_vne_b_t.vne05,SQLCA.sqlcode,"","",1)
                   LET g_vne_b[l_ac].* = g_vne_b_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
               CALL s_upd_vne06(g_vne_a.vne01,g_vne_a.vne02,g_vne_a.vne03,g_vne_a.vne04,g_sfb.sfb08)
              #CALL i315_b_fill(g_wc2) #FUN-980080 mark
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_vne_b[l_ac].* = g_vne_b_t.*
               END IF
               CLOSE i315_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i315_bcl
            COMMIT WORK
            #FUN-980080---mod---str---
            CALL i315_b_fill(g_wc2) #FUN-980080 add
            #==>更新ecm51預計完工日
            SELECT COUNT(*) INTO l_cnt 
              FROM vne_file
             WHERE vne01 = g_vne_a.vne01 
               AND vne02 = g_vne_a.vne02
               AND vne03 = g_vne_a.vne03
               AND vne04 = g_vne_a.vne04 
               AND vne012 = g_vne_a.vne012 #FUN-B50101 add
            IF l_cnt >= 1 THEN
                SELECT MIN(vne50),MAX(vne51) INTO l_min_vne50,l_max_vne51
                  FROM vne_file
                 WHERE vne01 = g_vne_a.vne01 
                   AND vne02 = g_vne_a.vne02
                   AND vne03 = g_vne_a.vne03
                   AND vne04 = g_vne_a.vne04 
                   AND vne012 = g_vne_a.vne012 #FUN-B50101 add
                UPDATE ecm_file
                   SET ecm50 = l_min_vne50,
                       ecm51 = l_max_vne51
                 WHERE ecm01 = g_vne_a.vne01 
                   AND ecm03 = g_vne_a.vne03 
                   AND ecm012 = g_vne_a.vne012 #FUN-B50101 add
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("update","ecm_file",g_vne_a.vne01,g_vne_a.vne03,SQLCA.sqlcode,"","",1)
                END IF
            END IF
            #FUN-980080---mod---end---

        ON ACTION controlp
           CASE
              WHEN INFIELD(vne05)
                   IF g_sma.sma917 = 0 THEN 
                       #工作站
                       CALL q_eca(FALSE,TRUE,g_vne_b[l_ac].vne05) RETURNING g_vne_b[l_ac].vne05
                       DISPLAY BY NAME g_vne_b[l_ac].vne05     
                       NEXT FIELD vne05
                   ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_eci"
                       LET g_qryparam.default1 = g_vne_b[l_ac].vne05
                       CALL cl_create_qry() RETURNING g_vne_b[l_ac].vne05
                       DISPLAY BY NAME g_vne_b[l_ac].vne05     
                       NEXT FIELD vne05
                   END IF
           END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vne05) AND l_ac > 1 THEN
                LET g_vne_b[l_ac].* = g_vne_b[l_ac-1].*
                LET g_vne_b[l_ac].vne05 = NULL
                DISPLAY g_vne_b[l_ac].* TO s_vne[l_ac].*
                NEXT FIELD vne05
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT

    CLOSE i315_bcl
    COMMIT WORK

END FUNCTION
 
FUNCTION i315_b_fill(p_wc2)              #BODY FILL UP
#DEFINE    p_wc2           LIKE type_file.chr1000, 
 DEFINE    p_wc2          STRING,       
    l_flag          LIKE type_file.chr1     

    LET g_sql =
        "SELECT vne05 ,'',vne50,vne51,vne06, ",
        "       vne311,vne312,vne313,vne314,vne315,vne316,vne07 ",
        "  FROM vne_file ",
        " WHERE vne01 = '",g_vne_a.vne01,"'",
        "  AND  vne02 = '",g_vne_a.vne02,"'",
        "  AND  vne03 = '",g_vne_a.vne03,"'",
        "  AND  vne04 = '",g_vne_a.vne04,"'",
        "  AND  vne012 = '",g_vne_a.vne012,"'", #FUN-B50101 add
        "  AND ", p_wc2 CLIPPED,            #單身
        "  ORDER BY vne05"
    PREPARE i315_pb FROM g_sql
    DECLARE vne_cs CURSOR FOR i315_pb            #SCROLL CURSOR
 
    CALL g_vne_b.clear()

    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH vne_cs INTO g_vne_b[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_sma.sma917 = 0 THEN 
            #工作站
            CALL i315_vne05_0(g_cnt)
        ELSE
            #機器編號
            CALL i315_vne05_1(g_cnt)
        END IF
        LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_vne_b.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i315_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vne_b TO s_vne.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #ON ACTION output
     #     LET g_action_choice="output"
     #     EXIT DISPLAY

      ON ACTION first
         CALL i315_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
 

      ON ACTION previous
         CALL i315_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 

      ON ACTION jump
         CALL i315_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION next
         CALL i315_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 

      ON ACTION last
         CALL i315_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #apsi315
      ON ACTION aps_lock_used_time
         LET g_action_choice = "aps_lock_used_time"
         EXIT DISPLAY

      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i315_vne05_0(l_n) #工作站
DEFINE
    l_n             LIKE type_file.num5,   #目前的ARRAY CNT  
    p_cmd           LIKE type_file.chr1,  
    l_ecaacti       LIKE eca_file.ecaacti

    LET g_errno = ' '
    SELECT eca02,ecaacti INTO g_vne_b[l_n].desc,l_ecaacti FROM eca_file
     WHERE eca01 = g_vne_b[l_n].vne05

         CASE WHEN SQLCA.SQLCODE = 100  
                   LET g_errno = 'aec-100' #無此工作站
                   LET g_vne_b[l_n].desc = ' '
                   LET l_ecaacti = ' '
              WHEN l_ecaacti='N' 
                   LET g_errno = '9028'
              OTHERWISE          
                   LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_vne_b[l_n].desc

END FUNCTION

FUNCTION i315_vne05_1(l_n) #機器編號
DEFINE
    l_n             LIKE type_file.num5,   #目前的ARRAY CNT  
    p_cmd           LIKE type_file.chr1,  
    l_eciacti       LIKE eci_file.eciacti

    LET g_errno = ' '
    SELECT eci06,eciacti INTO g_vne_b[l_n].desc,l_eciacti FROM eci_file
     WHERE eci01 = g_vne_b[l_n].vne05

         CASE WHEN SQLCA.SQLCODE = 100  
                   LET g_errno = 'mfg4010' #無此機器編號,請重新輸入
                   LET g_vne_b[l_n].desc = ' '
                   LET l_eciacti = ' '
              WHEN l_eciacti='N' 
                   LET g_errno = '9028'
              OTHERWISE          
                   LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_vne_b[l_n].desc

END FUNCTION

#APS鎖定製程時間維護  apsi311
FUNCTION i315_aps_vnd()
DEFINE  l_vnd RECORD LIKE vnd_file.*

  IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF
  IF cl_null(g_vne_a.vne04) OR
     cl_null(g_vne_b[l_ac].vne05) THEN
     CALL cl_err('','arm-034',1)
     RETURN
  END IF

  LET l_vnd.vnd01  = g_vne_a.vne01
  LET l_vnd.vnd02  = g_vne_a.vne02
  LET l_vnd.vnd03  = g_vne_a.vne03
  LET l_vnd.vnd04  = g_vne_a.vne04
  LET l_vnd.vnd012  = g_vne_a.vne012 #FUN-B50101 add
  LET l_vnd.vnd05  = g_vne_b[l_ac].vne05
 
  SELECT  * FROM vnd_file 
  WHERE vnd01 = l_vnd.vnd01
    AND vnd02 = l_vnd.vnd02
    AND vnd03 = l_vnd.vnd03
    AND vnd04 = l_vnd.vnd04
    AND vnd05 = l_vnd.vnd05 
    AND vnd012 = l_vnd.vnd012 #FUN-B50101 add

    #FUN-A70036 mark---str---
    #IF SQLCA.SQLCODE=100 THEN
    #   LET l_vnd.vnd06 = 0
    #   LET l_vnd.vnd07 = NULL
    #   LET l_vnd.vnd08 = NULL
    #   LET l_vnd.vnd09 = 0
    #   LET l_vnd.vnd10 = 1
    #   LET l_vnd.vnd11 = 0  
    #   INSERT INTO vnd_file VALUES(l_vnd.*)
    #      IF STATUS THEN
    #         CALL cl_err3("ins","vnd_file",l_vnd.vnd01,l_vnd.vnd02,SQLCA.sqlcode,
    #                      "","",1)
    #         ROLLBACK WORK
    #         RETURN
    #      ELSE
    #         COMMIT WORK
    #      END IF
    #END IF
    #FUN-A70036 mark---end---
     LET g_cmd = "apsi311 '",l_vnd.vnd01,"' '",l_vnd.vnd02,"' '",l_vnd.vnd03,"' '",l_vnd.vnd04,"' '",l_vnd.vnd05,"' '",g_prog,"' '",l_vnd.vnd012,"'" #FUN-B50101 add vnd012
     CALL cl_cmdrun(g_cmd)

END FUNCTION
#FUN-960103
