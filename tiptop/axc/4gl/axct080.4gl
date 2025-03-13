# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axct080.4gl
# Descriptions...: 產品完工比例維護作業
# Date & Author..: 06/02/07 By Sarag
# Modify.........: No.FUN-610080 06/02/07 By Sarah 新增"產品完工比例維護作業"
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/10 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730026 07/04/05 By claire 單身的料號可以修改,update時應寫入srm03
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780048 07/08/13 By dxfwo  _out()轉p_query實現
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.TQC-970289 09/07/28 By destiny 1.給單身產品編號增加管控2.去掉畫面不存在的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_srm01         LIKE srm_file.srm01,         #年度
    g_srm02         LIKE srm_file.srm02,         #月份
    g_srm01_t       LIKE srm_file.srm01,
    g_srm02_t       LIKE srm_file.srm02,
    g_srm           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        srm03       LIKE srm_file.srm03,          #產品編號
        ima02       LIKE ima_file.ima02,          #品名
        ima021      LIKE ima_file.ima021,         #規格
        ima55       LIKE ima_file.ima55,          #單位
        srm04       LIKE srm_file.srm04,          #在製數量  
        srm05       LIKE srm_file.srm05,          #人工完工%   
        srm06       LIKE srm_file.srm06           #製費完工%   
                    END RECORD,
    g_srm_t         RECORD                        #程式變數 (舊值)
        srm03       LIKE srm_file.srm03,          #產品編號
        ima02       LIKE ima_file.ima02,          #品名
        ima021      LIKE ima_file.ima021,         #規格
        ima55       LIKE ima_file.ima55,          #單位
        srm04       LIKE srm_file.srm04,          #在製數量  
        srm05       LIKE srm_file.srm05,          #人工完工%   
        srm06       LIKE srm_file.srm06           #製費完工%   
                    END RECORD,
#    g_wc,g_wc2,g_sql VARCHAR(300)                   #NO.TQC-630166 mark      
    g_wc,g_wc2,g_sql STRING,                      #NO.TQC-630166
    g_flag           LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
    g_rec_b          LIKE type_file.num5,         #單身筆數        #No.FUN-680122 SMALLINT
    l_ac             LIKE type_file.num5,         #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_flag           LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
    g_ss             LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_forupd_sql  STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp     STRING   #No.TQC-720019
DEFINE g_cnt         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_i           LIKE type_file.num5          #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg         LIKE ze_file.ze03            #No.FUN-680122 VARCHAR(72)
DEFINE g_row_count   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_curs_index  LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_jump        LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5  #No.FUN-680122 SMALLINT
DEFINE l_cmd         LIKE type_file.chr1000       #No.FUN-780048
 
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0146
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
    
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
    LET p_row = 4 LET p_col = 5
    OPEN WINDOW t080_w AT  p_row,p_col         #顯示畫面
         WITH FORM "axc/42f/axct080"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL t080_menu()
    CLOSE WINDOW t080_w                    #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
#QBE 查詢資料
FUNCTION t080_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE  l_sql   STRING
 
   CLEAR FORM                             #清除畫面
   CALL g_srm.clear()
   CALL cl_set_head_visible("","YES")             #No.FUN-6A0092 
 
   INITIALIZE g_srm01 TO NULL    #No.FUN-750051
   INITIALIZE g_srm02 TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON srm01,srm02   # 螢幕上取單頭條件
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN  RETURN END IF
 
   CONSTRUCT g_wc2 ON srm03,srm04,srm05,srm06
        FROM s_srm[1].srm03,s_srm[1].srm04,s_srm[1].srm05,s_srm[1].srm06
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE WHEN INFIELD(srm03)
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_ima"
#             LET g_qryparam.state = "c"
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_qryparam.multiret TO srm03
              NEXT FIELD srm03
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN  RETURN END IF
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT UNIQUE srm01,srm02 FROM srm_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY srm01,srm02"
      LET l_sql = "SELECT UNIQUE srm01,srm02 FROM srm_file ",
                  " WHERE ", g_wc CLIPPED
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE srm01,srm02 FROM srm_file ",
                  " WHERE ", g_wc  CLIPPED,
                  "   AND ", g_wc2 CLIPPED,
                  " ORDER BY srm01,srm02"
      LET l_sql = "SELECT UNIQUE srm01,srm02 FROM srm_file ",
                  " WHERE ", g_wc  CLIPPED,
                  "   AND ", g_wc2 CLIPPED
   END IF
 
   PREPARE t080_prepare FROM g_sql
   DECLARE t080_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t080_prepare
 
   DROP TABLE x
#  LET l_sql=l_sql," INTO TEMP x"      #No.TQC-720019
   LET g_sql_tmp=l_sql," INTO TEMP x"  #No.TQC-720019
#  PREPARE t080_precount_x FROM l_sql      #No.TQC-720019
   PREPARE t080_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t080_precount_x
   IF SQLCA.sqlcode THEN
      CALL cl_err('t080_precount_x',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE t080_precount FROM g_sql
   DECLARE t080_count CURSOR FOR t080_precount
END FUNCTION
 
FUNCTION t080_menu()
 
   WHILE TRUE
      CALL t080_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t080_a()
            END IF
        #WHEN "modify"
        #   IF cl_chk_act_auth() THEN
        #      CALL t080_u()
        #   END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t080_r()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t080_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t080_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t080_copy()
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
#              CALL t080_out()
         #No.FUN-780048---Begin                                                                                                     
            IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF 
            LET l_cmd = 'p_query "axct080" "',g_wc CLIPPED,'"'                                                                           
            CALL cl_cmdrun(l_cmd)                                                                                                   
         #No.FUN-780048---End
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srm),'','')
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_srm01 IS NOT NULL THEN
                LET g_doc.column1 = "srm01"
                LET g_doc.column2 = "srm02"
                LET g_doc.value1 = g_srm01
                LET g_doc.value2 = g_srm02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0019-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t080_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_srm.clear()
   INITIALIZE g_srm01 LIKE srm_file.srm01
   INITIALIZE g_srm02 LIKE srm_file.srm02
   LET g_srm01_t = NULL
   LET g_srm02_t = NULL
   LET g_wc = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t080_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_ss='N' THEN
         CALL g_srm.clear()
         LET g_rec_b = 0
      ELSE
          CALL t080_b_fill('1=1')          #單身
      END IF
      CALL t080_b()                        #輸入單身
      LET g_srm01_t = g_srm01              #保留舊值
      LET g_srm02_t = g_srm02              #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t080_u()
   DEFINE  l_buf      LIKE type_file.chr50         #No.FUN-680122CHAR(30)
 
   IF s_shut(0) THEN RETURN END IF
   IF g_srm01 IS NULL OR g_srm02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_srm01_t = g_srm01
   LET g_srm02_t = g_srm02
   BEGIN WORK   #No.+205 mark 拿掉
   WHILE TRUE
      CALL t080_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET g_srm01=g_srm01_t
         LET g_srm02=g_srm02_t
         DISPLAY g_srm01 TO srm01               #單頭
         DISPLAY g_srm02 TO srm02               #單頭
 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_srm01 != g_srm01_t OR g_srm02 != g_srm02_t THEN
         UPDATE srm_file SET srm01 = g_srm01,  #更新DB
                             srm02 = g_srm02
          WHERE srm01 = g_srm01_t AND srm02 = g_srm02_t
         IF SQLCA.sqlcode THEN
            LET l_buf = g_srm01 CLIPPED,'+',g_srm02 CLIPPED
#           CALL cl_err(l_buf,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","srm_file",g_srm01_t,g_srm02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
         END IF
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t080_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680122 VARCHAR(1)
          l_buf           LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(60)
          l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   LET g_ss = 'Y'
   DISPLAY BY NAME g_srm01,g_srm02
 
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT g_srm01,g_srm02  WITHOUT DEFAULTS
         FROM srm01,srm02
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t080_set_entry(p_cmd)
         CALL t080_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD srm01
          IF cl_null(g_srm01) OR g_srm01 < 0 THEN
             NEXT FIELD srm01
          END IF
 
      AFTER FIELD srm02
          IF cl_null(g_srm02) THEN
             NEXT FIELD srm02
          END IF
          IF g_srm02 < 1 OR g_srm02 > 12 THEN
             NEXT FIELD srm02
          END IF
          IF g_srm01 != g_srm01_t OR g_srm01_t IS NULL OR    #輸入後更改不同值時
             g_srm02 != g_srm02_t OR g_srm02_t IS NULL THEN
             SELECT UNIQUE srm01,srm02 FROM srm_file
              WHERE srm01=g_srm01 AND srm02=g_srm02
             IF SQLCA.sqlcode THEN             #不存在, 新來的
                IF p_cmd='a' THEN
                   LET g_ss='N'
                END IF
             ELSE 
                IF p_cmd='u' THEN
                   LET l_buf = g_srm01 clipped,'+',g_srm02 clipped
                   CALL cl_err(l_buf,-239,0)
                   LET g_srm01=g_srm01_t
                   LET g_srm02=g_srm02_t
                   NEXT FIELD srm01
                END IF
             END IF
          END IF
 
       AFTER INPUT
          LET l_flag = 'Y'
          IF INT_FLAG THEN EXIT INPUT END IF
          IF g_srm01 IS NULL OR g_srm01 = ' ' THEN
             LET l_flag = 'N'
          END IF
          IF g_srm02 IS NULL OR g_srm02 = ' ' THEN
             LET l_flag = 'N'
          END IF
          IF l_flag = 'N' THEN NEXT FIELD srm02 END IF
 
      #ON ACTION CONTROLF                  #欄位說明
      #   CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name
      #   CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         #MOD-860081------add-----str---
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
          
          ON ACTION about         
             CALL cl_about()      
          
          ON ACTION controlg      
             CALL cl_cmdask()     
          
          ON ACTION help          
             CALL cl_show_help()  
         #MOD-860081------add-----end---
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION t080_q()
  DEFINE l_srm01 LIKE srm_file.srm01,
         l_srm02 LIKE srm_file.srm02 
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_srm01 TO NULL              #No.FUN-6A0019
    INITIALIZE g_srm02 TO NULL              #No.FUN-6A0019
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_srm.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t080_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_srm01 TO NULL
       INITIALIZE g_srm02 TO NULL
       RETURN
    END IF
    OPEN t080_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_srm01 TO NULL
       INITIALIZE g_srm02 TO NULL
    ELSE
       OPEN t080_count
       IF SQLCA.sqlcode THEN
          CALL cl_err('t080_count',SQLCA.sqlcode,1)
       END IF
       FETCH t080_count INTO g_cnt
       DISPLAY g_cnt TO FORMONLY.cnt  
       LET g_row_count = g_cnt
       CALL t080_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t080_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680122 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680122 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t080_cs INTO g_srm01,g_srm02
        WHEN 'P' FETCH PREVIOUS t080_cs INTO g_srm01,g_srm02
        WHEN 'F' FETCH FIRST    t080_cs INTO g_srm01,g_srm02
        WHEN 'L' FETCH LAST     t080_cs INTO g_srm01,g_srm02
        WHEN '/'
            IF (NOT mi_no_ask) THEN  #No.TQC-720019
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
#            PROMPT g_msg CLIPPED,': ' FOR l_abso  #No.TQC-720019
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            END IF   #No.TQC-720019
#            FETCH ABSOLUTE l_abso t080_cs INTO g_srm01,g_srm02  #No.TQC-720019
             FETCH ABSOLUTE g_jump t080_cs INTO g_srm01,g_srm02  #No.TQC-720019
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_srm01,SQLCA.sqlcode,0)
       INITIALIZE g_srm01 TO NULL  #TQC-6B0105
       INITIALIZE g_srm02 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
#         WHEN '/' LET g_curs_index = l_abso  #No.TQC-720019
          WHEN '/' LET g_curs_index = g_jump  #No.TQC-720019
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL t080_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t080_show()
    LET g_srm01_t = g_srm01                #保存單頭舊值
    LET g_srm02_t = g_srm02                #保存單頭舊值
    DISPLAY g_srm01 TO srm01               #顯示單頭值
    DISPLAY g_srm02 TO srm02               #顯示單頭值
    CALL t080_b_fill(g_wc2)                #單身
    CALL cl_show_fld_cont()                #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t080_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_srm01 IS NULL THEN
      CALL cl_err("",-400,0)               #No.FUN-6A0019
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "srm01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "srm02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_srm01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_srm02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM srm_file WHERE srm01 = g_srm01 AND srm02 = g_srm02
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660127
         CALL cl_err3("del","srm_file",g_srm01,g_srm02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660127
      ELSE
         COMMIT WORK
         CLEAR FORM
         CALL g_srm.clear()
         CALL g_srm.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
#        EXECUTE t080_precount_x                  #No.TQC-720019
         PREPARE t080_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t080_precount_x2                 #No.TQC-720019
         OPEN t080_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t080_cs
            CLOSE t080_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH t080_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t080_cs
            CLOSE t080_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t080_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t080_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t080_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION t080_copy()
DEFINE
   l_srm01,l_oldno1 LIKE srm_file.srm01,
   l_srm02,l_oldno2 LIKE srm_file.srm02,
   l_srm03          LIKE srm_file.srm03,
   l_cnt            LIKE type_file.num10,         #No.FUN-680122INTEGER
   l_msg            LIKE type_file.chr50,         #No.FUN-680122CHAR(40)
   l_buf            LIKE type_file.chr50          #No.FUN-680122CHAR(40)
 
   CALL cl_getmsg('copy',g_lang) RETURNING g_msg
   IF s_shut(0) THEN RETURN END IF
   IF g_srm01 IS NULL OR g_srm02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   LET g_before_input_done = FALSE   #FUN-580026
   CALL t080_set_entry('a')          #FUN-580026
   LET g_before_input_done = TRUE    #FUN-580026
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
 
   INPUT l_srm01,l_srm02 FROM srm01,srm02
      AFTER FIELD srm01
         IF l_srm01 IS NULL THEN
            NEXT FIELD srm01
         END IF
 
      AFTER FIELD srm02
         SELECT count(*) INTO l_cnt FROM srm_file
          WHERE srm01 = l_srm01 AND srm02 = l_srm02
         IF l_cnt > 0 THEN
            CALL cl_err(l_srm01,-239,0)
            NEXT FIELD srm01
         END IF
 
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
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET l_buf = l_srm01 clipped,'+',l_srm02 clipped
   BEGIN WORK
   DROP TABLE x
   SELECT * FROM srm_file WHERE srm01 = g_srm01 AND srm02 = g_srm02
     INTO TEMP x
   UPDATE x SET srm01=l_srm01,srm02=l_srm02
   INSERT INTO srm_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err('srm:',SQLCA.sqlcode,0)   #No.FUN-660127
      CALL cl_err3("ins","srm_file",l_srm01,l_srm02,SQLCA.sqlcode,"","srm:",1)  #No.FUN-660127
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_buf,') O.K'
 
   LET l_oldno1 = g_srm01
   LET l_oldno2 = g_srm02
   LET g_srm01  = l_srm01
   LET g_srm02  = l_srm02
   CALL t080_b()
   #LET g_srm01  = l_oldno1  #FUN-C80046
   #LET g_srm02  = l_oldno2  #FUN-C80046
   #CALL t080_show()         #FUN-C80046
END FUNCTION
 
#單身
FUNCTION t080_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT             #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用                    #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否                    #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                      #No.FUN-680122 VARCHAR(1)
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否                      #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                      #No.FUN-680122 SMALLINT
DEFINE  l_count     LIKE type_file.num5                 #No.TQC-970289
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF cl_null(g_srm01) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT srm03,'','','',srm04,srm05,srm06 FROM srm_file  ",
                      " WHERE srm01=? AND srm02=? AND srm03=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t080_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_srm WITHOUT DEFAULTS FROM s_srm.* 
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
#        DISPLAY l_ac  TO FORMONLY.cn3      #No.TQC-970289
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b>=l_ac THEN
            LET p_cmd = 'u'
            LET g_srm_t.* = g_srm[l_ac].*  #BACKUP
 
            OPEN t080_bcl USING g_srm01 ,g_srm02 ,g_srm[l_ac].srm03
 
            IF STATUS THEN
               CALL cl_err("OPEN t080_bcl:", STATUS, 1)
               CLOSE t080_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t080_bcl INTO g_srm[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_srm_t.srm03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               SELECT ima02,ima021,ima55 
                 INTO g_srm[l_ac].ima02,g_srm[l_ac].ima021,g_srm[l_ac].ima55
                 FROM ima_file
                WHERE ima01 = g_srm[l_ac].srm03
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_srm[l_ac].* TO NULL      #900423
         LET g_srm_t.* = g_srm[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()               #FUN-550037(smin)
         NEXT FIELD srm03
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_srm[l_ac].* = g_srm_t.*
            CLOSE t080_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_srm[l_ac].srm03,-263,1)
            LET g_srm[l_ac].* = g_srm_t.*
         ELSE
            UPDATE srm_file SET srm04=g_srm[l_ac].srm04,
                                srm05=g_srm[l_ac].srm05,
                                srm03=g_srm[l_ac].srm03,  #TQC-730026 add
                                srm06=g_srm[l_ac].srm06
             WHERE srm01=g_srm01 AND srm02=g_srm02 AND srm03=g_srm_t.srm03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_srm[l_ac].srm03,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("upd","srm_file",g_srm01,g_srm_t.srm03,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               LET g_srm[l_ac].* = g_srm_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac               #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_srm[l_ac].* = g_srm_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_srm.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE t080_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac             #FUN-D40030 add
         CLOSE t080_bcl
         COMMIT WORK
 
      AFTER FIELD srm03 
         IF cl_null(g_srm[l_ac].srm03) THEN
            CALL cl_err(g_srm[l_ac].srm03,'mfg5103',0)
         ELSE
            #FUN-AA0059 ---------------add start--------------------
            IF NOT s_chk_item_no(g_srm[l_ac].srm03,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_srm[l_ac].srm03=g_srm_t.srm03
               NEXT FIELD srm03
            END IF 
            #FUN-AA0059 ------------------add end------------------ 
            #No.TQC-970289--begin                                                                                             
            SELECT COUNT(*) INTO l_count FROM ima_file                                                                        
             WHERE ima01=g_srm[l_ac].srm03                                                                                    
            IF l_count=0 THEN                                                                                                 
               CALL cl_err('','mfg3403',1)                                                                                    
               LET g_srm[l_ac].srm03=g_srm_t.srm03                                                                            
               NEXT FIELD srm03                                                                                               
            END IF                                                                                                            
            #No.TQC-970289--end
            SELECT ima02,ima021,ima55
              INTO g_srm[l_ac].ima02,g_srm[l_ac].ima021,g_srm[l_ac].ima55
              FROM ima_file
             WHERE ima01 = g_srm[l_ac].srm03
            DISPLAY g_srm[l_ac].ima02 TO ima02 
            DISPLAY g_srm[l_ac].ima021 TO ima021
            DISPLAY g_srm[l_ac].ima55 TO ima55 
         END IF
      
      AFTER FIELD srm04 
         IF g_srm[l_ac].srm04 < 0 THEN
            CALL cl_err(g_srm[l_ac].srm04,'afa-040',0)
            LET g_srm[l_ac].srm04 = g_srm_t.srm04
            DISPLAY g_srm[l_ac].srm04 TO srm04
            NEXT FIELD srm04
         END IF
 
      AFTER FIELD srm05 
         IF g_srm[l_ac].srm05 < 0 THEN
            CALL cl_err(g_srm[l_ac].srm05,'afa-040',0)
            LET g_srm[l_ac].srm05 = g_srm_t.srm05
            DISPLAY g_srm[l_ac].srm05 TO srm05
            NEXT FIELD srm05
         END IF
 
      AFTER FIELD srm06 
         IF g_srm[l_ac].srm06 < 0 THEN
            CALL cl_err(g_srm[l_ac].srm06,'afa-040',0)
            LET g_srm[l_ac].srm06 = g_srm_t.srm06
            DISPLAY g_srm[l_ac].srm06 TO srm06
            NEXT FIELD srm06
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO srm_file(srm01,srm02,srm03,srm04,srm05,srm06)
                       VALUES(g_srm01,g_srm02,g_srm[l_ac].srm03,
                              g_srm[l_ac].srm04,g_srm[l_ac].srm05,
                              g_srm[l_ac].srm06)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_srm[l_ac].srm03,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","srm_file",g_srm01,g_srm02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_srm_t.srm03 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM srm_file
              WHERE srm01 = g_srm01 AND srm02 = g_srm02
                AND srm03 = g_srm_t.srm03
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_srm_t.srm03,SQLCA.sqlcode,0)   #No.FUN-660127
                CALL cl_err3("del","srm_file",g_srm01,g_srm02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b = g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
         END IF
 
      ON ACTION controlp
         CASE WHEN INFIELD(srm03)
#FUN-AA0059---------mod------------str-----------------
#           CALL cl_init_qry_var()
#           LET g_qryparam.form = "q_ima"
#           LET g_qryparam.default1 = g_srm[l_ac].srm03
#           CALL cl_create_qry() RETURNING g_srm[l_ac].srm03
            CALL q_sel_ima(FALSE, "q_ima","",g_srm[l_ac].srm03,"","","","","",'' ) 
              RETURNING g_srm[l_ac].srm03 
#FUN-AA0059---------mod------------end-----------------
            DISPLAY g_srm[l_ac].srm03 TO srm03
            NEXT FIELD srm03
         END CASE
 
      ON ACTION controls                           #No.FUN-6A0092                                                                   
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6A0092 
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
   END INPUT
 
   CLOSE t080_bcl
   COMMIT WORK
END FUNCTION
   
FUNCTION t080_b_askkey()
DEFINE l_wc2      LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
   CONSTRUCT g_wc2 ON srm03,srm04,srm05,srm06
        FROM s_srm[1].srm03,s_srm[1].srm04,s_srm[1].srm05,s_srm[1].srm06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE WHEN INFIELD(srm03)
#FUN-AA0059---------mod------------str-----------------
    #         CALL cl_init_qry_var()
    #         LET g_qryparam.form = "q_ima"
    #         LET g_qryparam.state = "c"
    #         CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_qryparam.multiret TO srm03
              NEXT FIELD srm03
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL t080_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t080_b_fill(p_wc2)              #BODY FILL UP
   DEFINE
        p_wc2           LIKE type_file.chr1000,       #No.FUN-680122CHAR(200)
        l_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   LET g_sql = "SELECT srm03,ima02,ima021,ima55,srm04,srm05,srm06 ",
               "  FROM srm_file LEFT OUTER JOIN ima_file ON srm03 = ima01",
               " WHERE srm01 = ",g_srm01,
               "   AND srm02 = ",g_srm02,
               "   AND ",p_wc2 CLIPPED,           #單身
               " ORDER BY srm03"
 
   PREPARE t080_pb FROM g_sql
   DECLARE srm_cs CURSOR FOR t080_pb    #SCROLL CURSOR
    
   CALL g_srm.clear()
   LET g_cnt = 1
   LET g_rec_b=0
   FOREACH srm_cs INTO g_srm[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_srm.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t080_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srm TO s_srm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION controls                           #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6A0092  
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL t080_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t080_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL t080_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
 	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t080_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL t080_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t080_out()
DEFINE
   sr              RECORD
       srm01       LIKE srm_file.srm01,   #年度
       srm02       LIKE srm_file.srm02,   #月份
       srm03       LIKE srm_file.srm03,   #產品編號
       srm04       LIKE srm_file.srm04,   #在製數量
       srm05       LIKE srm_file.srm05,   #人工完工%
       srm06       LIKE srm_file.srm06,   #製費完工%
       ima02       LIKE ima_file.ima02,   #品名
       ima021      LIKE ima_file.ima021,  #規格
       ima55       LIKE ima_file.ima55    #單位
                   END RECORD,
   l_name          LIKE type_file.chr20         #No.FUN-680122 VARCHAR(20)              #External(Disk) file name
 
   #改成印當下的那一筆資料內容
   IF g_wc IS NULL THEN
      IF cl_null(g_srm01) THEN
         CALL cl_err('','9057',0) RETURN
      ELSE
         LET g_wc=" srm01='",g_srm01,"'"
      END IF
      IF NOT cl_null(g_srm02) THEN
         LET g_wc=g_wc," and srm02=",g_srm02
      END IF
   END IF
 
   CALL cl_wait()
   CALL cl_outnam('axct080') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_pageno = 0
 
   LET g_sql="SELECT srm_file.*,ima02,ima021,ima55 ",
             "  FROM srm_file LEFT OUTER JOIN ima_file ON srm03 = ima01 ",
             " WHERE ",g_wc CLIPPED
   PREPARE t080_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE t080_co CURSOR FOR t080_p1      # CURSOR
 
   START REPORT t080_rep TO l_name
 
   FOREACH t080_co INTO sr.*
      IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT t080_rep(sr.*)
   END FOREACH
 
   FINISH REPORT t080_rep
 
   CLOSE t080_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t080_rep(sr)
DEFINE
   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
   sr              RECORD
       srm01       LIKE srm_file.srm01,   #年度
       srm02       LIKE srm_file.srm02,   #月份
       srm03       LIKE srm_file.srm03,   #產品編號
       srm04       LIKE srm_file.srm04,   #在製數量
       srm05       LIKE srm_file.srm05,   #人工完工%
       srm06       LIKE srm_file.srm06,   #製費完工%
       ima02       LIKE ima_file.ima02,   #品名
       ima021      LIKE ima_file.ima021,  #規格
       ima55       LIKE ima_file.ima55    #單位
                   END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.srm01,sr.srm02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         PRINT g_head CLIPPED,g_pageno USING '<<<'
         PRINT 
         PRINT g_dash
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
               g_x[36],g_x[37],g_x[38],g_x[39]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.srm02
         PRINT COLUMN g_c[31],sr.srm01 USING '&&&&',
               COLUMN g_c[32],sr.srm02 USING '&&';
 
      ON EVERY ROW
         PRINT COLUMN g_c[33],sr.srm03,
               COLUMN g_c[34],sr.ima02,
               COLUMN g_c[35],sr.ima021,
               COLUMN g_c[36],sr.ima55,
               COLUMN g_c[37],cl_numfor(sr.srm04,15,2),
               COLUMN g_c[38],cl_numfor(sr.srm05,15,2),
               COLUMN g_c[39],cl_numfor(sr.srm06,15,2)
 
      ON LAST ROW
         PRINT g_dash
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#NO.TQC-630166 start--
#            IF g_wc[001,080] > ' ' THEN
#      	       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED
#            END IF
#            IF g_wc[071,140] > ' ' THEN
 #     	       PRINT COLUMN 10,     g_wc[071,140] CLIPPED
 #           END IF
#            IF g_wc[141,210] > ' ' THEN
#      	       PRINT COLUMN 10,     g_wc[141,210] CLIPPED
#            END IF
             CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
            PRINT g_dash[1,g_len]
         END IF
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
 
FUNCTION t080_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("srm01,srm02",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t080_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("srm01,srm02",FALSE)
  END IF
 
END FUNCTION
