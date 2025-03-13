# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi005.4gl
# Descriptions...: 部門預計加班維護作業
# Date & Author..: Julius 02/09/20
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530264 05/03/25 By Smapmin 單身輸完到第二筆時不能按確定離開
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改 
# Modify.........: No MOD-5A0004 05/10/07 By Rosayu _r()後筆數不正確
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-5A0134 06/06/20 By rainy 按上筆單身資料沒改變
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i005()_q 一開始應清空g_bge_hd.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 欄位未對齊
# Modify.........: No.FUN-6B0033 06/11/15 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/06/29 By destiny 報表改為使用crystal report
# Modify.........: No.TQC-7A0104 07/10/26 By xufeng  更改時,只要更改月份的值,就會報資料重復
# Modify.........: No.FUN-840092 08/04/21 By rainy  新增複製功能
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-980118 09/08/17 By sherry 職等欄位錄入的值需檢查該職等編號是否有效，無效不可錄入
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-990065 09/12/17 By chenmoyan 画面增加USER,GRUP,MODU,DATE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bge_hd        RECORD                       #單頭變數
        bge01       LIKE bge_file.bge01,
        bge02       LIKE bge_file.bge02,
        bge03       LIKE bge_file.bge03,
        bge04       LIKE bge_file.bge04
        END RECORD,
    g_bge_hd_t      RECORD                       #單頭變數
        bge01       LIKE bge_file.bge01,
        bge02       LIKE bge_file.bge02,
        bge03       LIKE bge_file.bge03,
        bge04       LIKE bge_file.bge04
        END RECORD,
    g_bge_hd_o      RECORD                       #單頭變數
        bge01       LIKE bge_file.bge01,
        bge02       LIKE bge_file.bge02,
        bge03       LIKE bge_file.bge03,
        bge04       LIKE bge_file.bge04
        END RECORD,
    l_bge_hd        RECORD                       #單頭變數
        bge01       LIKE bge_file.bge01,
        bge02       LIKE bge_file.bge02,
        bge03       LIKE bge_file.bge03,
        bge04       LIKE bge_file.bge04
        END RECORD,
    g_bge           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
  bge05     LIKE bge_file.bge05,
  bge06     LIKE bge_file.bge06,
  bge07     LIKE bge_file.bge07,
  bge08     LIKE bge_file.bge08,
  bge11     LIKE bge_file.bge11,
  bge09     LIKE bge_file.bge09,
  bge10     LIKE bge_file.bge10,
  bge12     LIKE bge_file.bge12, 
        bgeuser   LIKE bge_file.bgeuser, #FUN-990065
        bgegrup   LIKE bge_file.bgegrup, #FUN-990065
        bgemodu   LIKE bge_file.bgemodu, #FUN-990065
        bgedate   LIKE bge_file.bgedate  #FUN-990065
        END RECORD,
    g_bge_t         RECORD                       #程式變數(舊值)
  bge05     LIKE bge_file.bge05,
  bge06     LIKE bge_file.bge06,
  bge07     LIKE bge_file.bge07,
  bge08     LIKE bge_file.bge08,
  bge11     LIKE bge_file.bge11,
  bge09     LIKE bge_file.bge09,
  bge10     LIKE bge_file.bge10,
  bge12     LIKE bge_file.bge12,
        bgeuser   LIKE bge_file.bgeuser, #FUN-990065
        bgegrup   LIKE bge_file.bgegrup, #FUN-990065
        bgemodu   LIKE bge_file.bgemodu, #FUN-990065
        bgedate   LIKE bge_file.bgedate  #FUN-990065
        END RECORD,
    g_wc            string,                          #WHERE CONDITION     #No.FUN-580092 HCN
    g_sql           string,                          #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,             #單身筆數            #No.FUN-680061 SMALLINT
    g_mody          LIKE type_file.chr1,             #單身的鍵值是否改變  #FUN-680061    VARCHAR(01)
    l_ac            LIKE type_file.num5,             #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
    l_gem02         LIKE gem_file.gem02
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL      
DEFINE   g_sql_tmp      STRING   #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680061 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
 
#主程式開始
MAIN
DEFINE
#       l_time    LIKE type_file.chr8     #No.FUN-6A0056
    p_row,p_col LIKE type_file.num5    #No.FUN-680061 smallint
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
   
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
    INITIALIZE g_bge_hd_t.* to NULL
 
    LET p_row = 4 LET p_col = 20
    OPEN WINDOW i005_w AT p_row,p_col
        WITH FORM "abg/42f/abgi005" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init() 
    CALL i005_menu()   
    CLOSE WINDOW i005_w                          #結束畫面
      CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i005_curs()
    CLEAR FORM #清除畫面
 
    CALL g_bge.clear() 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_bge_hd.* TO NULL    #No.FUN-750051
    
   CONSTRUCT g_wc 
     ON bge01, bge02, bge03, bge04, # 螢幕上取條件
              bge05, bge06, bge07, bge08, bge11, bge09, bge10, bge12,
              bgeuser,bgegrup,bgemodu,bgedate #FUN-990065
         FROM bge01, bge02, bge03, bge04, 
              s_bge[1].bge05, s_bge[1].bge06, s_bge[1].bge07, s_bge[1].bge08,
        s_bge[1].bge11, s_bge[1].bge09, s_bge[1].bge10, s_bge[2].bge12,
              s_bge[1].bgeuser,s_bge[1].bgegrup,s_bge[1].bgemodu,s_bge[1].bgedate #FUN-990065
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP 
            CASE
                WHEN INFIELD(bge02)
                #   CALL q_gem(10,3,g_bge_hd.bge02)
                #       RETURNING g_bge_hd.bge02
                    CALL cl_init_qry_var()            
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.form = "q_gem"             
                    LET g_qryparam.default1 = g_bge_hd.bge02         
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bge02
                WHEN INFIELD(bge05)
                    CALL cl_init_qry_var()        
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.form ="q_bgd"         
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bge05
                WHEN INFIELD(bge06)
                    CALL cl_init_qry_var()        
                    LET g_qryparam.state = "c" 
                    LET g_qryparam.form ="q_bgd"         
                    LET g_qryparam.multiret_index = 2
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bge06 
            END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
    #No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
             CALL cl_qbe_select() 
                 ON ACTION qbe_save
       CALL cl_qbe_save()
    #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN 
        CALL i005_show()
        RETURN
    END IF
                                                                                
   #FUN-990065   ---start
   #资料权限的检查
   IF g_priv2='4' THEN #只能使用自己的资料
      LET g_wc = g_wc clipped," AND bgeuser = '",g_user,"'"
   END IF

   IF g_priv3='4' THEN #只能使用相同群的资料
      LET g_wc = g_wc clipped," AND bgegrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN
      LET g_wc = g_wc clipped," AND bgegrup IN ",cl_chk_tgrup_list()
   END IF
   #FUN-990065   ---end
 
    LET g_sql = "SELECT UNIQUE bge01, bge02, bge03, bge04",
                "  FROM bge_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY bge01"
    PREPARE i005_prepare FROM g_sql
    DECLARE i005_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i005_prepare
 
#   LET g_sql = "SELECT UNIQUE bge01, bge02, bge03, bge04",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE bge01, bge02, bge03, bge04",  #No.TQC-720019
                "  FROM bge_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i005_precount_x FROM g_sql      #No.TQC-720019
    PREPARE i005_precount_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i005_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x"
    PREPARE i005_precount FROM g_sql
    DECLARE i005_count CURSOR FOR i005_precount
END FUNCTION
 
#中文的MENU
FUNCTION i005_menu()
   WHILE TRUE
      CALL i005_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i005_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i005_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i005_r()
            END IF
          WHEN "modify"                 
            IF cl_chk_act_auth() THEN                                           
               CALL i005_u()                                                    
            END IF
      #FUN-840092 bgein
         WHEN "reproduce"                                                       
            IF cl_chk_act_auth() THEN                                           
               CALL i005_copy()                                                 
            END IF     
      #FUN-840092 end    
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i005_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i005_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bge),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bge_hd.bge01 IS NOT NULL THEN
                LET g_doc.column1 = "bge01"
                LET g_doc.column2 = "bge02"
                LET g_doc.column3 = "bge03"
                LET g_doc.column4 = "bge04"
                LET g_doc.value1 = g_bge_hd.bge01
                LET g_doc.value2 = g_bge_hd.bge02
                LET g_doc.value3 = g_bge_hd.bge03
                LET g_doc.value4 = g_bge_hd.bge04
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i005_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_bge.clear() 
    INITIALIZE g_bge_hd TO NULL                  #單頭初始清空
    INITIALIZE g_bge_hd_o TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i005_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
      IF cl_null(g_bge_hd.bge02)  OR   
         cl_null(g_bge_hd.bge03)  OR  
         cl_null(g_bge_hd.bge04)  THEN 
         CONTINUE WHILE 
      END IF
        CALL g_bge.clear() 
        LET g_rec_b=0 
        CALL i005_b()                            #輸入單身
        LET g_bge_hd_o.* = g_bge_hd.*            #保留舊值
        LET g_bge_hd_t.* = g_bge_hd.*            #保留舊值
        LET g_wc="     bge01='",g_bge_hd.bge01,"' ",
                 " AND bge02='",g_bge_hd.bge02,"' ",
                 " AND bge03='",g_bge_hd.bge03,"' ",
                 " AND bge04='",g_bge_hd.bge04,"' "  
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i005_u()
 
    IF s_shut(0) THEN
  RETURN
    END IF
    IF g_bge_hd.bge01 IS NULL THEN
  CALL cl_err('',-400,0)
  RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bge_hd_t.bge01 = g_bge_hd.bge01
    LET g_bge_hd_t.bge02 = g_bge_hd.bge02
    LET g_bge_hd_t.bge03 = g_bge_hd.bge03
    LET g_bge_hd_t.bge04 = g_bge_hd.bge04
    BEGIN WORK
 
    WHILE TRUE
        CALL i005_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bge_hd.bge01 = g_bge_hd_t.bge01
            LET g_bge_hd.bge02 = g_bge_hd_t.bge02
            LET g_bge_hd.bge03 = g_bge_hd_t.bge03
            LET g_bge_hd.bge04 = g_bge_hd_t.bge04
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bge_file
     SET bge01 = g_bge_hd.bge01,
               bge02 = g_bge_hd.bge02,
               bge03 = g_bge_hd.bge03,
               bge04 = g_bge_hd.bge04
         WHERE bge01 = g_bge_hd_t.bge01
           AND bge02 = g_bge_hd_t.bge02
           AND bge03 = g_bge_hd_t.bge03
           AND bge04 = g_bge_hd_t.bge04
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bge_file",g_bge_hd_t.bge01,g_bge_hd_t.bge02,SQLCA.sqlcode,"","",1) #FUN-660105 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理單頭欄位(bge01, bge02, bge03, bge04)INPUT
FUNCTION i005_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,      #a:輸入 u:更改 #No.FUN-680061 VARCHAR(1)
    l_n     LIKE type_file.num5       #No.FUN-680061 SMALLINT
 
    LET l_n = 0
    INITIALIZE l_gem02 TO NULL
    CALL cl_set_head_visible("","YES")#No.FUN-6B0033
    DISPLAY g_bge_hd.bge01, g_bge_hd.bge02, g_bge_hd.bge03, g_bge_hd.bge04
         TO bge01, bge02, bge03, bge04
        
     CALL cl_set_comp_entry("bge01,bge02,bge03,bge04",TRUE)  #carrier
    INPUT BY NAME
        g_bge_hd.bge01, g_bge_hd.bge02, g_bge_hd.bge03, g_bge_hd.bge04
    WITHOUT DEFAULTS HELP 1
 
#No.FUN-570108--begin                                                           
        BEFORE INPUT                                                            
        LET g_before_input_done = FALSE                                         
        CALL i005_set_entry(p_cmd)                                              
        CALL i005_set_no_entry(p_cmd)                                           
        LET g_before_input_done = TRUE                                          
#No.FUN-570108--end                
        AFTER FIELD bge01
            IF cl_null(g_bge_hd.bge01) THEN
                LET g_bge_hd.bge01 = " "
            END IF
 
        AFTER FIELD bge02
            IF NOT cl_null(g_bge_hd.bge02) THEN
                CALL i005_bge02('a',g_bge_hd.bge02)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD bge02
                END IF
            END IF
 
        AFTER FIELD bge03
            IF cl_null(g_bge_hd.bge03) OR g_bge_hd.bge03 < 1 THEN
                NEXT FIELD bge03
            END IF
 
        AFTER FIELD bge04
            IF cl_null(g_bge_hd.bge04)
      OR g_bge_hd.bge04 < 1
      OR g_bge_hd.bge04 > 12 THEN
                NEXT FIELD bge04
            END IF
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM bge_file
             WHERE bge01 = g_bge_hd.bge01
               AND bge02 = g_bge_hd.bge02
               AND bge03 = g_bge_hd.bge03
               AND bge04 = g_bge_hd.bge04
           #No.TQC-7A0104    ---add---begin----
            IF p_cmd='a' OR (p_cmd <> 'u' AND 
         (  g_bge_hd.bge01 <> g_bge_hd_t.bge01
         OR g_bge_hd.bge02 <> g_bge_hd_t.bge02
         OR g_bge_hd.bge03 <> g_bge_hd_t.bge03
         OR g_bge_hd.bge04 <> g_bge_hd_t.bge04 )) THEN
           #No.TQC-7A0104    ---add---end------
           #No.TQC-7A0104    ---mark--begin-----
           #IF l_n > 0 AND p_cmd <> 'u'
     #OR (  g_bge_hd.bge01 <> g_bge_hd_t.bge01
     #   OR g_bge_hd.bge02 <> g_bge_hd_t.bge02
     #   OR g_bge_hd.bge03 <> g_bge_hd_t.bge03
     #   OR g_bge_hd.bge04 <> g_bge_hd_t.bge04 ) THEN
           #No.TQC-7A0104    ---mark--end-------
               IF l_n >0 THEN     #No.TQC-7A0104 add
       IF p_cmd <> 'u' THEN
           INITIALIZE g_bge_hd TO NULL
       ELSE
           LET g_bge_hd.bge01 = g_bge_hd_t.bge01
           LET g_bge_hd.bge02 = g_bge_hd_t.bge02
           LET g_bge_hd.bge03 = g_bge_hd_t.bge03
           LET g_bge_hd.bge04 = g_bge_hd_t.bge04
       END IF
                   DISPLAY g_bge_hd.bge01, g_bge_hd.bge02,
                           g_bge_hd.bge03, g_bge_hd.bge04
                        TO bge01, bge02, bge03, bge04
                   CALL i005_bge02('a',g_bge_hd.bge02)   
                   CALL cl_err( g_bge_hd.bge01, -239, 0)  
                   NEXT FIELD bge01
               END IF
            END IF
 
        ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION CONTROLP 
            CASE
                WHEN INFIELD(bge02)
                #   CALL q_gem(10,3,g_bge_hd.bge02)
                #       RETURNING g_bge_hd.bge02
                    CALL cl_init_qry_var()            
                    LET g_qryparam.form = "q_gem"             
                    LET g_qryparam.default1 = g_bge_hd.bge02         
                    CALL cl_create_qry() RETURNING g_bge_hd.bge02     
                    DISPLAY BY NAME g_bge_hd.bge02
            END CASE
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION
 
#FUN-840092 begin
FUNCTION i005_copy()
DEFINE
    new_bge01   LIKE bge_file.bge01,
    new_bge02   LIKE bge_file.bge02,
    new_bge03   LIKE bge_file.bge03,
    new_bge04   LIKE bge_file.bge04,
 
    l_gem02     LIKE gem_file.gem02,
    l_gemacti   LIKE gem_file.gemacti,
    l_aca02     LIKE aca_file.aca02,
    l_acaacti   LIKE aca_file.acaacti,
    l_i         LIKE type_file.num10,   
    l_n         LIKE type_file.num5,    
    l_bge       RECORD  LIKE bge_file.*
 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_bge_hd.bge01) OR cl_null(g_bge_hd.bge01)
     OR cl_null(g_bge_hd.bge03) OR cl_null(g_bge_hd.bge04)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   DISPLAY "" AT 1,1
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   DISPLAY g_msg AT 2,1 #ATTRIBUTE(RED)    #No.FUN-940135
 
  INITIALIZE l_gem02 TO NULL
  DISPLAY l_gem02 TO FORMONLY.gem02
  CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
  WHILE TRUE
   INPUT new_bge01,new_bge02,new_bge03,new_bge04 FROM bge01,bge02,bge03,bge04
       AFTER FIELD bge01
         IF cl_null(new_bge01) THEN
             LET new_bge01 = " "
         END IF
 
       AFTER FIELD bge02
         IF NOT cl_null(new_bge02) THEN
             CALL i005_bge02('a',new_bge02)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD bge02
             END IF
         END IF
       AFTER FIELD bge03
         IF cl_null(new_bge03) OR new_bge03 < 1 THEN
             NEXT FIELD bge03
         END IF
 
       AFTER FIELD bge04
         IF cl_null(new_bge04)
   OR new_bge04 < 1
   OR new_bge04 > 12 THEN
             NEXT FIELD bge04
         END IF
 
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM bge_file
          WHERE bge01 = new_bge01
            AND bge02 = new_bge02
            AND bge03 = new_bge03
            AND bge04 = new_bge04
          IF l_n >0 THEN     
                CALL cl_err( '', -239, 0)  
                NEXT FIELD bge01
          END IF
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(bge02)
               CALL cl_init_qry_var()            
               LET g_qryparam.form = "q_gem"             
               LET g_qryparam.default1 = new_bge02         
               CALL cl_create_qry() RETURNING new_bge02     
               DISPLAY new_bge02 TO bge02
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      DISPLAY new_bge01 TO bge01
      DISPLAY new_bge02 TO bge02
      DISPLAY new_bge03 TO bge03
      DISPLAY new_bge04 TO bge04
      RETURN
   END IF
   IF cl_null(new_bge01) OR cl_null(new_bge02) OR cl_null(new_bge03) OR cl_null(new_bge04) THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
    BEGIN WORK
    LET g_success='Y'
    DECLARE i005_c CURSOR FOR
        SELECT *
          FROM bge_file
         WHERE bge01 = g_bge_hd.bge01
           AND bge02 = g_bge_hd.bge02
           AND bge03 = g_bge_hd.bge03
           AND bge04 = g_bge_hd.bge04
    LET l_i = 0
    FOREACH i005_c INTO l_bge.*
        LET l_i = l_i+1
        LET l_bge.bge01 = new_bge01
        LET l_bge.bge02 = new_bge02
        LET l_bge.bge03 = new_bge03
        LET l_bge.bge04 = new_bge04
        LET l_bge.bgeoriu = g_user      #No.FUN-980030 10/01/04
        LET l_bge.bgeorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO bge_file VALUES(l_bge.*)
        IF STATUS THEN
            CALL cl_err3("ins","bge_file",l_bge.bge01,l_bge.bge02,STATUS,l_bge.bge03,"ins bge",1) 
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bge_hd.bge01 = new_bge01
        LET g_bge_hd.bge02 = new_bge02
        LET g_bge_hd.bge03 = new_bge03
        LET g_bge_hd.bge04 = new_bge04
        LET g_wc = '1=1'
        CALL i005_show()          
        #FUN-C30027---end  
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
#FUN-840092 end
 
 
 
FUNCTION i005_bge02(p_cmd,p_key)  #部門
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bge_file.bge02,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT  gem02,gemacti INTO  l_gem02,l_gemacti
      FROM  gem_file WHERE  gem01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-011'
                                   LET l_gem02 = NULL LET l_gemacti = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i005_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bge_hd.* TO NULL             #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bge.clear() 
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i005_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i005_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bge TO NULL
    ELSE
        OPEN i005_count
        FETCH i005_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i005_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i005_fetch(p_flag)
DEFINE
    p_flag  LIKE type_file.chr1    #處理方式  #No.FUN-680061 VARCHAR(1)  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i005_cs INTO g_bge_hd.bge01,
                                             g_bge_hd.bge02,
                                             g_bge_hd.bge03,
                                             g_bge_hd.bge04
        WHEN 'P' FETCH PREVIOUS i005_cs INTO g_bge_hd.bge01,
                                             g_bge_hd.bge02,
                                             g_bge_hd.bge03,
                                             g_bge_hd.bge04
        WHEN 'F' FETCH FIRST    i005_cs INTO g_bge_hd.bge01,
                                             g_bge_hd.bge02,
                                             g_bge_hd.bge03,
                                             g_bge_hd.bge04
        WHEN 'L' FETCH LAST     i005_cs INTO g_bge_hd.bge01,
                                             g_bge_hd.bge02,
                                             g_bge_hd.bge03,
                                             g_bge_hd.bge04
        WHEN '/'
         IF (NOT mi_no_ask) THEN      #No.FUN-6A0057 g_no_ask 
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i005_cs INTO g_bge_hd.bge01,
                                            g_bge_hd.bge02,
                                            g_bge_hd.bge03,
                                            g_bge_hd.bge04
         LET mi_no_ask = FALSE             #No.FUN-6A0057 g_no_ask 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bge_hd.bge01, SQLCA.sqlcode, 0)
        INITIALIZE g_bge_hd.* TO NULL  #TQC-6B0105
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
    SELECT UNIQUE bge01, bge02, bge03, bge04
      FROM bge_file 
     WHERE bge01 = g_bge_hd.bge01
       AND bge02 = g_bge_hd.bge02
       AND bge03 = g_bge_hd.bge03
       AND bge04 = g_bge_hd.bge04
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bge_hd.bge01, SQLCA.sqlcode, 0) #FUN-660105
        CALL cl_err3("sel","bge_file",g_bge_hd.bge01,g_bge_hd.bge02,SQLCA.sqlcode,"","",1) #FUN-660105
        INITIALIZE g_bge TO NULL
        RETURN
    END IF
    CALL i005_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i005_show()
 
    INITIALIZE l_gem02 TO NULL
 
    LET g_bge_hd.* = g_bge_hd.*                  #保存單頭舊值
    DISPLAY BY NAME g_bge_hd.bge01,              #顯示單頭值
                    g_bge_hd.bge02,
                    g_bge_hd.bge03,
                    g_bge_hd.bge04
 
    CALL i005_bge02('d',g_bge_hd.bge02)
    CALL i005_b_fill(g_wc) #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i005_r()
DEFINE
    l_chr LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)  
 
    IF s_shut(0) THEN RETURN END IF         
 
    IF g_bge_hd.bge01 IS NULL THEN 
        CALL cl_err('', -400, 0)
        RETURN
    END IF
    BEGIN WORK
    CALL i005_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bge01"            #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bge02"            #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bge03"            #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bge04"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bge_hd.bge01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bge_hd.bge02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bge_hd.bge03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_bge_hd.bge04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM bge_file 
         WHERE bge01 = g_bge_hd.bge01
           AND bge02 = g_bge_hd.bge02
           AND bge03 = g_bge_hd.bge03
           AND bge04 = g_bge_hd.bge04
 
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_bge_hd.bge01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("del","bge_file",g_bge_hd.bge01,g_bge_hd.bge02,SQLCA.sqlcode,"","",1) #FUN-660105
        ELSE 
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i005_precount_x                  #No.TQC-720019
            PREPARE i005_precount_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i005_precount_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_bge.clear()
            OPEN i005_count
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i005_cs
               CLOSE i005_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i005_count INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i005_cs
               CLOSE i005_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i005_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i005_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE           #No.FUN-6A0057 g_no_ask 
               CALL i005_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK 
END FUNCTION
 
#處理單身欄位(bge05, bge06, bge07, bge08, bge09, bge10, bge11, bge12)輸入
FUNCTION i005_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680061 VARCHAR(1)
    l_bge06     LIKE bge_file.bge06,    #暫存 q_bgd 回傳值
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680061 SMALLINT
 
DEFINE l_bgdacti    LIKE bgd_file.bgdacti   #TQC-980118 add     
 
    LET g_action_choice = ""
 
    IF g_bge_hd.bge01 IS NULL THEN
        RETURN
    END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT bge05, bge06, bge07, bge08,bge11, bge09, bge10, bge12, ",
        "       bgeuser, bgegrup, bgemodu, bgedate ",    #FUN-990065 add
        "  FROM bge_file  WHERE bge01 = ? AND bge02 = ? AND bge03 = ? ",
        "   AND bge04 = ? AND bge05 = ? AND bge06 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i005_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bge WITHOUT DEFAULTS FROM s_bge.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_bge_t.* = g_bge[l_ac].*    #BACKUP
                OPEN i005_bcl USING g_bge_hd.bge01,g_bge_hd.bge02,g_bge_hd.bge03,g_bge_hd.bge04,g_bge_t.bge05,g_bge_t.bge06     
                IF STATUS THEN
                   CALL cl_err("OPEN i005_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bge_t.bge05,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH i005_bcl INTO g_bge[l_ac].* 
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bge[l_ac].* TO NULL
      LET g_bge[l_ac].bge07 = 0
      LET g_bge[l_ac].bge08 = 0
      LET g_bge[l_ac].bge09 = 0
      LET g_bge[l_ac].bge10 = 0
      LET g_bge[l_ac].bge11 = 0
      LET g_bge[l_ac].bge12 = 0
            LET g_bge_t.* = g_bge[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO bge_file(bge01,bge02,bge03,bge04,bge05,bge06,bge07, #No.MOD-470041
                                 bge08,bge09,bge10,bge11,bge12,bgeuser,bgegrup,bgeoriu,bgeorig) #FUN-990065 add user,grup
            VALUES(g_bge_hd.bge01,g_bge_hd.bge02,
                   g_bge_hd.bge03,g_bge_hd.bge04,
                   g_bge[l_ac].bge05,g_bge[l_ac].bge06,
                   g_bge[l_ac].bge07,g_bge[l_ac].bge08,
             g_bge[l_ac].bge09,g_bge[l_ac].bge10,
             g_bge[l_ac].bge11,g_bge[l_ac].bge12,
                   g_user,g_grup, g_user, g_grup) #FUN-990065 add user,grup      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bge[l_ac].bge05,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bge_file",g_bge_hd.bge01,g_bge_hd.bge02,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK 
                SELECT COUNT(*) 
                  INTO g_rec_b
                  FROM bge_file
                 WHERE bge01 = g_bge_hd.bge01
                   AND bge02 = g_bge_hd.bge02
                   AND bge03 = g_bge_hd.bge03
                   AND bge04 = g_bge_hd.bge04
                
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
         AFTER FIELD bge05
      LET l_n = 0
      SELECT COUNT(*)
        INTO l_n
        FROM bgd_file
       WHERE bgd02 = g_bge[l_ac].bge05
             IF NOT cl_null(g_bge[l_ac].bge05) THEN   #MOD-530264
         IF l_n < 1 THEN
                  CALL cl_err(g_bge[l_ac].bge05,'mfg9329',0)   #TQC-980118 add   
            NEXT FIELD bge05
         END IF
             END IF   #MOD-530264
 
             #TQC-980118---Begin                                                                                                    
             SELECT bgdacti INTO l_bgdacti FROM bgd_file                                                                            
              WHERE bgd01 = g_bge_hd.bge01                                                                                          
                AND bgd02 = g_bge[l_ac].bge05                                                                                       
             IF l_bgdacti = 'N' THEN                                                                                                
                CALL cl_err(g_bge[l_ac].bge05,'aco-172',0)                                                                          
                NEXT FIELD bge05                                                                                                    
             END IF                                                                                                                 
             #TQC-980118---End 
 
 
        AFTER FIELD bge06 
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM bgd_file
       WHERE bgd02 = g_bge[l_ac].bge05
         AND bgd03 = g_bge[l_ac].bge06
             IF NOT cl_null(g_bge[l_ac].bge06) THEN   #MOD-530264
         IF l_n < 1 THEN
                NEXT FIELD bge06
               END IF
             END IF   #MOD-530264
 
        AFTER FIELD bge07
            IF g_bge[l_ac].bge07 < 0 OR cl_null(g_bge[l_ac].bge07) THEN
                NEXT FIELD bge07
            END IF
 
        AFTER FIELD bge08
            IF g_bge[l_ac].bge08 < 0 OR cl_null(g_bge[l_ac].bge08) THEN
                NEXT FIELD bge08
            END IF
 
        AFTER FIELD bge09
            IF g_bge[l_ac].bge09 < 0 OR cl_null(g_bge[l_ac].bge09) THEN
                NEXT FIELD bge09
            END IF
 
        AFTER FIELD bge10
            IF g_bge[l_ac].bge10 < 0 OR cl_null(g_bge[l_ac].bge10) THEN
                NEXT FIELD bge10
            END IF
 
        AFTER FIELD bge11
            IF g_bge[l_ac].bge11 < 0 OR cl_null(g_bge[l_ac].bge11) THEN
                NEXT FIELD bge11
            END IF
 
        AFTER FIELD bge12
            IF g_bge[l_ac].bge12 < 0 OR cl_null(g_bge[l_ac].bge12) THEN
                NEXT FIELD bge12
            END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bge_t.bge05) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM bge_file             #刪除該筆單身資料
                 WHERE bge01 = g_bge_hd.bge01
                   AND bge02 = g_bge_hd.bge02
                   AND bge03 = g_bge_hd.bge03
                   AND bge04 = g_bge_hd.bge04
                   AND bge05 = g_bge_t.bge05
       AND bge06 = g_bge_t.bge06
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bge_t.bge05,SQLCA.sqlcode,0)  #FUN-660105
                    CALL cl_err3("del","bge_file",g_bge_hd.bge01,g_bge_t.bge05,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
            COMMIT WORK 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bge[l_ac].* = g_bge_t.*
               CLOSE i005_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bge[l_ac].bge05,-263,1)
               LET g_bge[l_ac].* = g_bge_t.*
            ELSE
               UPDATE bge_file
                  SET bge05 = g_bge[l_ac].bge05,
                      bge06 = g_bge[l_ac].bge06,
                      bge07 = g_bge[l_ac].bge07,
                bge08 = g_bge[l_ac].bge08,
                      bge09 = g_bge[l_ac].bge09,
                      bge10 = g_bge[l_ac].bge10,
                      bge11 = g_bge[l_ac].bge11,
                      bge12 = g_bge[l_ac].bge12,
                      bgemodu=g_user, #FUN-990065
                      bgedate=g_today #FUN-990065
                WHERE CURRENT OF i005_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bge[l_ac].bge05, SQLCA.sqlcode, 0)  #FUN-660105
                   CALL cl_err3("upd","bge_file",g_bge_hd.bge01,g_bge[l_ac].bge05,SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_bge[l_ac].* = g_bge_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK 
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30032 mark
            IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_bge[l_ac].* = g_bge_t.*
                #FUN-D30032--add--begin--
                ELSE
                   CALL g_bge.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30032--add--end----
                END IF
                CLOSE i005_bcl
                ROLLBACK WORK
                EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
            CLOSE i005_bcl
            COMMIT WORK     
        ON ACTION CONTROLN
            CALL i005_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bge03) AND l_ac > 1 THEN
                LET g_bge[l_ac].* = g_bge[l_ac-1].*
                NEXT FIELD bge03
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bge05)
                #   CALL q_bgd(4, 24, '')
                #       RETURNING g_bge[l_ac].bge05, l_bge06
                    CALL cl_init_qry_var()        
                    LET g_qryparam.form ="q_bgd"         
                    LET g_qryparam.arg1 = g_bge_hd.bge01        #TQC-980118 add   
                    LET g_qryparam.default1 = g_bge[l_ac].bge05        #TQC-980118 add   
                    LET g_qryparam.default2 = g_bge[l_ac].bge06        #TQC-980118 add   
                    CALL cl_create_qry() RETURNING g_bge[l_ac].bge05,l_bge06  
        IF l_bge06 != -1 THEN
      LET g_bge[l_ac].bge06 = l_bge06
        END IF
                     DISPLAY BY NAME g_bge[l_ac].bge05  #FUN-990065 add
                     DISPLAY BY NAME g_bge[l_ac].bge06  #FUN-990065 add
                    NEXT FIELD bge05
                WHEN INFIELD(bge06)
                #   CALL q_bgd(4, 24, g_bge[l_ac].bge05)
                #       RETURNING g_bge[l_ac].bge05, l_bge06
                    CALL cl_init_qry_var()        
                    LET g_qryparam.form ="q_bgd"         
                    LET g_qryparam.arg1 = g_bge_hd.bge01        #TQC-980118 add    
                    LET g_qryparam.default1 = g_bge[l_ac].bge05        #TQC-980118 add   
                    LET g_qryparam.default2 = g_bge[l_ac].bge06        #TQC-980118 add   
                    CALL cl_create_qry() RETURNING g_bge[l_ac].bge05,l_bge06  
        IF l_bge06 != -1 THEN
      LET g_bge[l_ac].bge06 = l_bge06
        END IF
                     DISPLAY BY NAME g_bge[l_ac].bge05  #FUN-990065 add
                     DISPLAY BY NAME g_bge[l_ac].bge06  #FUN-990065 add
                    NEXT FIELD bge06
            END CASE
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()     
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
          ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
    
        END INPUT
 
    CLOSE i005_bcl
    COMMIT WORK  
    CALL i005_delall()
END FUNCTION
 
FUNCTION i005_delall()
    SELECT COUNT(*) 
      INTO g_cnt
      FROM bge_file
     WHERE bge01 = g_bge_hd.bge01
       AND bge02 = g_bge_hd.bge02
       AND bge03 = g_bge_hd.bge03
       AND bge04 = g_bge_hd.bge04
    IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
        ERROR g_msg CLIPPED
        DELETE FROM bge_file 
         WHERE bge01 = g_bge_hd.bge01
           AND bge02 = g_bge_hd.bge02
           AND bge03 = g_bge_hd.bge03
           AND bge04 = g_bge_hd.bge04
    END IF
END FUNCTION
 
#單身重查
FUNCTION i005_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(200)
 
    CONSTRUCT l_wc2
     ON bge05, bge06, bge07, bge08, bge11, bge09, bge10, bge12,
              bgeuser,bgegrup,bgemodu,bgedate  #FUN-990065
         FROM s_bge[1].bge05, s_bge[1].bge06, s_bge[1].bge07, s_bge[1].bge08,
        s_bge[1].bge11, s_bge[1].bge09, s_bge[1].bge10, s_bge[1].bge12,
              s_bge[1].bgeuser,s_bge[1].bgegrup,s_bge[1].bgemodu,s_bge[1].bgedate #FUN-990065
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
   
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    #No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
             CALL cl_qbe_select() 
                 ON ACTION qbe_save
       CALL cl_qbe_save()
    #No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0 
        RETURN 
    END IF
    CALL i005_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i005_b_fill(p_wc2)                      #BODY FILL UP
DEFINE 
    p_wc2    LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(200)
    l_cnt    LIKE type_file.num5    #No.FUN-680061 SMALLINT
 
    LET g_sql =
        "SELECT bge05, bge06, bge07, bge08, bge11, bge09, bge10, bge12,",
        "       bgeuser,bgegrup,bgemodu,bgedate ",  #FUN-990065 add user---date
        "  FROM bge_file",
        " WHERE bge01 ='", g_bge_hd.bge01, "' ",
        "   AND bge02 ='", g_bge_hd.bge02, "' ",
        "   AND bge03 ='", g_bge_hd.bge03, "' ",
        "   AND bge04 ='", g_bge_hd.bge04, "' ",
  "   AND ", p_wc2 CLIPPED,
        " ORDER BY bge05"
    PREPARE i005_pb 
       FROM g_sql
    DECLARE i005_bcs                             #SCROLL CURSOR
     CURSOR FOR i005_pb
 
    CALL g_bge.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i005_bcs INTO g_bge[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bge.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION i005_bp(p_ud)
DEFINE
    p_ud    LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_bge TO s_bge.* ATTRIBUTE(COUNT=g_rec_b)           #FUN-5A0134 remark
   DISPLAY ARRAY g_bge TO s_bge.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-5A0134
      BEFORE DISPLAY                                                            
                                                                                
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
    #FUN-840092 bgein
      ON ACTION reproduce                                                       
         LET g_action_choice="reproduce"                                        
         EXIT DISPLAY                                                           
    #FUN-840092 end
 
      ON ACTION first 
         CALL i005_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i005_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL i005_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i005_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL i005_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
  ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
             LET INT_FLAG=FALSE     #MOD-570244 mars
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#製作簡表
FUNCTION i005_out()
DEFINE
    l_i LIKE type_file.num5,          #No.FUN-680061
    sr RECORD 
        bge01       LIKE bge_file.bge01,
        bge02       LIKE bge_file.bge02,
        bge03       LIKE bge_file.bge03,
        bge04       LIKE bge_file.bge04,
        bge05       LIKE bge_file.bge05,
        bge06       LIKE bge_file.bge06, 
        bge07       LIKE bge_file.bge07,
  bge08     LIKE bge_file.bge08,
  bge11     LIKE bge_file.bge11,
  bge09     LIKE bge_file.bge09,
  bge10     LIKE bge_file.bge10,
  bge12     LIKE bge_file.bge12
        END RECORD,
    l_name LIKE type_file.chr20,  #NO.FUN-680061 VARCHAR(20)
    l_za05 LIKE type_file.chr1000 #NO.FUN-680061 VARCHAR(40)
DEFINE l_str        STRING        #No.FUN-770033
    IF cl_null(g_wc) THEN
  CALL cl_err('', 9057, 0)
  RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abgi005') RETURNING l_name                   #No.FUN-770033
    SELECT zo02 
      INTO g_company
      FROM zo_file
     WHERE zo01 = g_lang
#   LET g_sql="SELECT bge01, bge02, bge03, bge04, ",             #No.FUN-770033
    LET g_sql="SELECT bge01, bge02, gem02, bge03, bge04, ",      #No.FUN-770033
              "       bge05, bge06, bge07, bge08, ",
        "       bge11, bge09, bge10, bge12  ",
#             "  FROM bge_file",                                 #No.FUN-770033
              " FROM bge_file LEFT OUTER JOIN gem_file ON bge02 = gem02",                  #No.FUN-770033
#             " WHERE 1=1 AND ", g_wc CLIPPED                    #No.FUN-770033
              " WHERE 1=1 ",                                     #No.FUN-770033
              " AND ", g_wc CLIPPED                              #No.FUN-770033
#No.FUN-770033--begin--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
    IF g_zz05 = 'Y' THEN                                                                                   
       CALL cl_wcchp(g_wc,'bge01, bge02, bge03, bge04,bge05,bge06,bge07,bge08,bge11,bge09,bge10,bge12')                                                            
       RETURNING g_wc                                                                                     
       LET l_str = g_wc                                                                                     
    END IF 
    LET l_str =l_str
    CALL cl_prt_cs1('abgi005','abgi005',g_sql,l_str) 
#No.FUN-770033--end-- 
#No.FUN-770033--start--
   {PREPARE i005_p1 FROM g_sql                   # RUNTIME 編譯
    DECLARE i005_co CURSOR FOR i005_p1
 
    START REPORT i005_rep TO l_name
 
    FOREACH i005_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i005_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i005_rep
 
    CLOSE i005_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)}
#No.FUN-770033--end--
END FUNCTION
 
#No.FUN-770033--start--
{REPORT i005_rep(sr)
DEFINE
    l_trailer_sw LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1)
    l_i LIKE type_file.num5,            #No.FUN-680061 SMALLINT
    str STRING,
    l_gem02         LIKE gem_file.gem02,
    sr RECORD 
        bge01       LIKE bge_file.bge01,
        bge02       LIKE bge_file.bge02,
        bge03       LIKE bge_file.bge03,
        bge04       LIKE bge_file.bge04,
        bge05       LIKE bge_file.bge05,
        bge06       LIKE bge_file.bge06, 
        bge07       LIKE bge_file.bge07,
  bge08     LIKE bge_file.bge08,
  bge11     LIKE bge_file.bge11,
  bge09     LIKE bge_file.bge09,
  bge10     LIKE bge_file.bge10,
  bge12     LIKE bge_file.bge12
        END RECORD
 
    OUTPUT
        TOP MARGIN g_top_margin
        LEFT MARGIN g_left_margin
        BOTTOM MARGIN g_bottom_margin
        PAGE LENGTH g_page_line
 
    ORDER BY sr.bge01, sr.bge02, sr.bge03, sr.bge04, sr.bge05, sr.bge06
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                  g_x[38],g_x[39],g_x[40],g_x[41]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bge01
           PRINT COLUMN g_c[31],sr.bge01;
        BEFORE GROUP OF sr.bge02
           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.bge02
           PRINT COLUMN g_c[32], sr.bge02[1,6],
                 COLUMN g_c[33], l_gem02
        BEFORE GROUP OF sr.bge04
           PRINT COLUMN g_c[34], sr.bge03 USING '####',
                 COLUMN g_c[35], sr.bge04 USING '##';
 
        ON EVERY ROW
            LET str = sr.bge08 USING '#####.#','/',sr.bge11 USING '#####.#'
            PRINT COLUMN g_c[36], sr.bge05,
                  COLUMN g_c[37], sr.bge06 USING '####', 
            #     COLUMN g_c[38], sr.bge07 USING '#####',          #TQC-6A0088
                  COLUMN g_c[38], sr.bge07 USING '############',   #TQC-6A0088
      COLUMN g_c[39], str;
            LET str = sr.bge10 USING '#####.#','/',sr.bge12 USING '#####.#'
#           PRINT COLUMN g_c[40], sr.bge09 USING '#####',   #TQC-6A0088
                  PRINT COLUMN g_c[40], sr.bge09 USING '############', # No.TQC-6A0088
      COLUMN g_c[41], str
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770033--end--
 
#No.FUN-570108--begin                                                           
FUNCTION i005_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)  
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("bge01,bge02,bge03,bge04",TRUE)                     
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i005_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)  
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("bge01,bge02,bge03,bge04",FALSE)                    
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108--end             
