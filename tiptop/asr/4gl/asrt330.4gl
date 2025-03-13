# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asrt330.4gl
# Descriptions...: 期末用料盤點作業
# Date & Author..: 06/02/16 By kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.TQC-670052 06/07/20 By Claire 增加判斷
# Modify.........: No.TQC-670051 06/07/20 By Claire fetch(/)增加判斷
# Modify.........: No.TQC-680030 06/08/11 By pengu 不按查詢,直接按單身,依然可以修改單身
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0166 06/11/10 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.TQC-940105 09/05/08 By mike DISPLAY BY NAME g_srn03 欄位在畫面中不存在/復制srn03開窗選資料畫面不顯示   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0003 10/11/01 By houlia 倉庫權限使用控管修改 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BC0041 11/12/06 By ck2yuan  資料資料重新擷取時，期末數量會一直重複加，修改update判斷語法
# Modify.........: No:FUN-BB0086 12/01/05 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_srn01         LIKE srn_file.srn01,   #盤點日期
    g_srn01_t       LIKE srn_file.srn01,   #盤點日期(舊值)
    g_srn03         LIKE srn_file.srn03,   #倉
    g_srn03_t       LIKE srn_file.srn03,   
    g_srn04         LIKE srn_file.srn04,   #儲
    g_srn04_t       LIKE srn_file.srn04,   #儲
    g_srn05         LIKE srn_file.srn05,   #批
    g_srn05_t       LIKE srn_file.srn05,   #批
    g_srn09         LIKE srn_file.srn09,   
    g_srn10         LIKE srn_file.srn10,   
    g_srn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        srn02       LIKE srn_file.srn02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        srn06       LIKE srn_file.srn06,
        srn07       LIKE srn_file.srn07,
        srn08       LIKE srn_file.srn08
                    END RECORD,
    g_srn_t         RECORD                 #程式變數 (舊值)
        srn02       LIKE srn_file.srn02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        srn06       LIKE srn_file.srn06,
        srn07       LIKE srn_file.srn07,
        srn08       LIKE srn_file.srn08
                    END RECORD,
    g_wc,g_sql,g_wc2    string,                 #No.FUN-580092 HCN                 
    g_show              LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,        #單身筆數        #No.FUN-680130 SMALLINT
    g_flag          LIKE type_file.chr1,        #No.FUN-680130 CAHR(1)
    g_ss            LIKE type_file.chr1,        #No.FUN-680130 VARCHAR(1)
    l_ac            LIKE type_file.num5,        #目前處理的ARRAY CNT        #No.FUN-680130 SMALLINT
    g_argv1         LIKE srn_file.srn01
DEFINE p_row,p_col     LIKE type_file.num5      #No.FUN-680130 SMALLINT
DEFINE g_jump       LIKE type_file.num10        #TQC-670051 add   #No.FUN-680130 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5         #TQC-670051 add   #No.FUN-680130 SMALLINT
DEFINE tm      RECORD
                 wc    STRING,                                      
                 date  LIKE type_file.dat,      #No.FUN-680130 DATE
                 year  LIKE type_file.num5,     #No.FUN-680130 SMALLINT
                 month LIKE type_file.num5      #No.FUN-680130 SMALLINT
               END RECORD
#主程式開始
DEFINE   g_forupd_sql STRING                    #SELECT ... FOR UPDATE SQL   
DEFINE   g_sql_tmp    STRING                    #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680130 INTEGER
 
MAIN
#DEFINE                                         #No.FUN-6B0014
#       l_time    LIKE type_file.chr8           #No.FUN-6B0014
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
   LET g_argv1 =ARG_VAL(1)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW t330_w AT p_row,p_col
     WITH FORM "asr/42f/asrt330"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL t330_q()
   END IF
   CALL t330_menu()
 
   CLOSE WINDOW t330_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
 
END MAIN
 
#QBE 查詢資料
FUNCTION t330_cs()
DEFINE l_sql   STRING                                    
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " srn01 = '",g_argv1,"'"
    ELSE
       CLEAR FORM                         #清除畫面
       CALL g_srn.clear()
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_srn01 TO NULL    #No.FUN-750051
   INITIALIZE g_srn03 TO NULL    #No.FUN-750051
   INITIALIZE g_srn04 TO NULL    #No.FUN-750051
   INITIALIZE g_srn05 TO NULL    #No.FUN-750051
   INITIALIZE g_srn09 TO NULL    #No.FUN-750051
   INITIALIZE g_srn10 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON srn01,srn03,srn04,srn05,srn09,srn10,srn02,srn06,srn07,srn08
          FROM srn01,srn03,srn04,srn05,srn09,srn10,s_srn[1].srn02,
               s_srn[1].srn06,s_srn[1].srn07,s_srn[1].srn08
               
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(srn03)
#FUN-AB0003  --modify
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_imd1"
#               LET g_qryparam.state ="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
#FUN-AB0003  --end
                DISPLAY g_qryparam.multiret TO srn03
                NEXT FIELD srn03
            WHEN INFIELD(srn02)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  ="q_ima"
#              LET g_qryparam.state ="c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO srn02
               NEXT FIELD srn02
            WHEN INFIELD(srn06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gef"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srn06
               NEXT FIELD srn06
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
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT DISTINCT srn01,srn03,srn04,srn05,srn09,srn10 FROM srn_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY srn01"
    PREPARE t330_prepare FROM g_sql      #預備一下
    DECLARE t330_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t330_prepare
 
    DROP TABLE t330_cnttmp
#   LET l_sql=l_sql," INTO TEMP t330_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP t330_cnttmp"  #No.TQC-720019
    
#   PREPARE t330_cnttmp_pre FROM l_sql            #No.TQC-720019
    PREPARE t330_cnttmp_pre FROM g_sql_tmp        #No.TQC-720019
    EXECUTE t330_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM t330_cnttmp"
    
    PREPARE t330_precount FROM g_sql
    DECLARE t330_count CURSOR FOR t330_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_srn01=g_argv1
    END IF
 
    CALL t330_show()
END FUNCTION
 
FUNCTION t330_menu()
 
   WHILE TRUE
      CALL t330_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL t330_a()
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t330_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL t330_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t330_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t330_b()
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
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_srn),'','')
             END IF
         WHEN "gen_data"
            IF cl_chk_act_auth() THEN
               CALL t330_g()
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t330_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_srn.clear()
   LET g_srn01_t  = NULL
   LET g_srn03_t  = NULL
   LET g_srn04_t  = NULL
   LET g_srn05_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t330_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_srn01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_srn.clear()
      ELSE
         CALL t330_b_fill('1=1')            #單身
      END IF
 
      CALL t330_b()                      #輸入單身
 
      LET g_srn01_t = g_srn01
      LET g_srn03_t = g_srn03
      LET g_srn04_t = g_srn04
      LET g_srn05_t = g_srn05
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t330_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改        #No.FUN-680130 VARCHAR(1)
    l_cnt           LIKE type_file.num10     #No.FUN-680130 INTEGER
 
    LET g_ss='Y'
 
   #LET g_srn01=MDY(MONTH(g_today)+1,1,YEAR(g_today)) -1
    LET g_srn01=t330_GETLASTDAY(MDY(MONTH(g_today),1,YEAR(g_today)))
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT g_srn01,g_srn03,g_srn04,g_srn05 WITHOUT DEFAULTS
        FROM srn01,srn03,srn04,srn05
 
       AFTER FIELD srn01
          IF g_srn01_t IS NULL OR (g_srn01<>g_srn01_t) THEN
             LET g_srn09=YEAR(g_srn01)
             LET g_srn10=MONTH(g_srn01)
             DISPLAY g_srn09 TO srn09
             DISPLAY g_srn10 TO srn10
          END IF
 
       AFTER FIELD srn03
          IF NOT cl_null(g_srn03) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM imd_file WHERE imd01=g_srn03
                                                        AND imdacti='Y'
             IF l_cnt=0 OR SQLCA.sqlcode THEN
                CALL cl_err('',100,1)
                LET g_srn03=g_srn03_t
                NEXT FIELD srn03
             END IF       
#FUN-AB0003  --modify
             IF NOT s_chk_ware(g_srn03) THEN
                NEXT FIELD srn03
             END IF 
#FUN-AB0003  --end                                    
          END IF
 
       AFTER INPUT
          IF cl_null(g_srn04) THEN 
             LET g_srn04=' '
             DISPLAY BY NAME g_srn04
          END IF
          IF cl_null(g_srn05) THEN 
             LET g_srn05=' ' 
             DISPLAY BY NAME g_srn05
          END IF
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(srn03)
#FUN-AB0003  --modify
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_imd1"
#               CALL cl_create_qry() RETURNING g_srn03
                CALL q_imd_1(FALSE,TRUE,"","","","","") RETURNING g_srn03
#FUN-AB0003  --end
               #DISPLAY BY NAME g_srn03    #TQC-940105  
                DISPLAY g_srn03 TO srn03   #TQC-940105  
                NEXT FIELD srn03
          END CASE
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
FUNCTION t330_q()
   LET g_srn01 = ''
   LET g_srn03 = ''
   LET g_srn04 = ''
   LET g_srn05 = ''
   LET g_srn09 = ''
   LET g_srn10 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_srn01,g_srn03,g_srn04,g_srn05,
              g_srn09,g_srn10 TO NULL                    #No.FUN-6A0166
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_srn.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL t330_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10 TO NULL
      RETURN
   END IF
 
   OPEN t330_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10 TO NULL
   ELSE
      OPEN t330_count
      FETCH t330_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t330_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t330_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1    #處理方式    #No.FUN-680130 VARCHAR(1)
  #l_abso          LIKE type_file.num10   #絕對的筆數  #TQC-670051 mark        #No.FUN-680130 INTEGER
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t330_bcs INTO g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10
       WHEN 'P' FETCH PREVIOUS t330_bcs INTO g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10
       WHEN 'F' FETCH FIRST    t330_bcs INTO g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10
       WHEN 'L' FETCH LAST     t330_bcs INTO g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10
       WHEN '/'
              IF (NOT mi_no_ask) THEN       #TQC-670051 add
                   CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                     LET INT_FLAG = 0  ######add for prompt bug
                   PROMPT g_msg CLIPPED,': ' FOR g_jump  #TQC-670051 l_abso->g_jump
                      ON IDLE g_idle_seconds
                         CALL cl_on_idle()
#                         CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
              
                   END PROMPT
                   IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
              END IF                  #TQC-670051 add
          FETCH ABSOLUTE g_jump t330_bcs INTO g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10  #TQC-670051 l_abso->g_jump
          LET mi_no_ask = FALSE   #TQC-670051 add 
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_srn01,SQLCA.sqlcode,0)
      INITIALIZE g_srn01 TO NULL  #TQC-6B0105
      INITIALIZE g_srn03 TO NULL  #TQC-6B0105
      INITIALIZE g_srn04 TO NULL  #TQC-6B0105
      INITIALIZE g_srn05 TO NULL  #TQC-6B0105
      INITIALIZE g_srn09 TO NULL  #TQC-6B0105
      INITIALIZE g_srn10 TO NULL  #TQC-6B0105
   ELSE
      CALL t330_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump  #TQC-670051 l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t330_show()
 
   DISPLAY g_srn01 TO srn01
   DISPLAY g_srn03 TO srn03
   DISPLAY g_srn04 TO srn04
   DISPLAY g_srn05 TO srn05
   DISPLAY g_srn09 TO srn09
   DISPLAY g_srn10 TO srn10
 
   CALL t330_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t330_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680130 SMALLINT
   l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680130 SMALLINT
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680130 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680130 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680130 SMALLINT
   l_allow_delete  LIKE type_file.num5,    #可刪除否          #No.FUN-680130 SMALLINT
   l_cnt           LIKE type_file.num10                       #No.FUN-680130 INTEGER
 
   LET g_action_choice = ""
 
  #--------No.TQC-680030 modify
   IF cl_null(g_srn01) OR cl_null(g_srn03) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF
  #--------No.TQC-680030 end
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT srn02,'','',srn06,srn07,srn08 FROM srn_file",
                      "  WHERE srn01 = ? AND srn02= ? AND srn03 = ?",
                      "   AND srn04 = ? AND srn05 = ? FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t330_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_srn.clear() END IF
 
   INPUT ARRAY g_srn WITHOUT DEFAULTS FROM s_srn.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_srn_t.* = g_srn[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN t330_bcl USING g_srn01,g_srn[l_ac].srn02,g_srn03,g_srn04,g_srn05
            IF STATUS THEN
               CALL cl_err("OPEN t330_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t330_bcl INTO g_srn[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN t330_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL t330_set_srn02(g_srn[l_ac].srn02) RETURNING g_srn[l_ac].ima02,
                                                                   g_srn[l_ac].ima021
                  LET g_srn_t.*=g_srn[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_srn[l_ac].* TO NULL            #900423
         LET g_srn_t.* = g_srn[l_ac].*               #新輸入資料
         LET g_srn[l_ac].srn07=0
         LET g_srn[l_ac].srn08=0
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD srn02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_srn[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_srn[l_ac].* TO s_srn.*
            CALL g_srn.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
         INSERT INTO srn_file(srn01,srn02,srn03,srn04,srn05,srn06,srn07,srn08,srn09,srn10,
                              srn11,srn12,srn13,srn14,srn15,srn16,srn17,srn18,srn19,srn20)
              VALUES(g_srn01,g_srn[l_ac].srn02,g_srn03,g_srn04,g_srn05,
                     g_srn[l_ac].srn06,g_srn[l_ac].srn07,g_srn[l_ac].srn08,
                     g_srn09,g_srn10,0,0,0,0,0,0,0,0,0,0)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_srn[l_ac].srn02,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("ins","srn_file",g_srn[l_ac].srn02,g_srn03,SQLCA.sqlcode,"","",1)  #No.FUN-660138
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD srn02                         # check data 是否重複
         IF NOT cl_null(g_srn[l_ac].srn02) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_srn[l_ac].srn02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_srn[l_ac].srn02= g_srn_t.srn02
               NEXT FIELD srn02
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_srn[l_ac].srn02 != g_srn_t.srn02 OR g_srn_t.srn02 IS NULL THEN
               SELECT ima25 INTO g_srn[l_ac].srn06 FROM ima_file 
                WHERE ima01=g_srn[l_ac].srn02
                  AND imaacti='Y'          #TQC-670052 add
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('',100,1)   #No.FUN-660138
                  CALL cl_err3("sel","ima_file",g_srn[l_ac].srn02,"",100,"","",1)  #No.FUN-660138
                  LET g_srn[l_ac].srn06=null
                  DISPLAY BY NAME g_srn[l_ac].srn06
                  NEXT FIELD srn02        #TQC-670052 modify srn06->srn02
               END IF
               DISPLAY BY NAME g_srn[l_ac].srn06
               SELECT COUNT(*) INTO l_n FROM srn_file
                  WHERE srn01 = g_srn01
                    AND srn02 = g_srn[l_ac].srn02
                    AND srn03 = g_srn03
                    AND srn04 = g_srn04
                    AND srn05 = g_srn05
               IF (l_n > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_srn[l_ac].srn02,-239,0)
                  LET g_srn[l_ac].srn02 = g_srn_t.srn02
                  LET g_srn[l_ac].ima02 = g_srn_t.ima02
                  LET g_srn[l_ac].ima021= g_srn_t.ima021
                  LET g_srn[l_ac].srn06 = g_srn_t.srn06
                  DISPLAY BY NAME g_srn[l_ac].srn02,
                                  g_srn[l_ac].ima02,
                                  g_srn[l_ac].ima021,
                                  g_srn[l_ac].srn06
                  NEXT FIELD srn02
               END IF
               LET g_srn[l_ac].srn07=t330_get_imk09(g_srn[l_ac].srn02,
                                                    g_srn03,g_srn04,g_srn05,
                                                    g_srn09,g_srn10)
               LET g_srn[l_ac].srn07 = s_digqty(g_srn[l_ac].srn07,g_srn[l_ac].srn06)   #No.FUN-BB0086
               DISPLAY BY NAME g_srn[l_ac].srn07
               CALL t330_set_srn02(g_srn[l_ac].srn02) RETURNING g_srn[l_ac].ima02,
                                                                g_srn[l_ac].ima021
               DISPLAY BY NAME g_srn[l_ac].srn02,
                               g_srn[l_ac].ima02,
                               g_srn[l_ac].ima021
            END IF
         ELSE
            LET g_srn[l_ac].srn06 = null
            LET g_srn[l_ac].ima02 = null
            LET g_srn[l_ac].ima021= null
            DISPLAY BY NAME g_srn[l_ac].ima02,g_srn[l_ac].ima021
         END IF
 
      AFTER FIELD srn06
         IF NOT cl_null(g_srn[l_ac].srn06) THEN
            IF g_srn_t.srn06 IS NULL OR (g_srn_t.srn06 != g_srn[l_ac].srn06) THEN
               SELECT COUNT(*) INTO l_cnt FROM gfe_file WHERE
                   gfe01=g_srn[l_ac].srn06
               IF l_cnt=0 OR SQLCA.sqlcode THEN
                  CALL cl_err('',100,1)
                  NEXT FIELD srn06
               END IF    
            END IF
            #No.FUN-BB0086--add--begin--
            LET g_srn[l_ac].srn08 = s_digqty(g_srn[l_ac].srn08,g_srn[l_ac].srn06)
            DISPLAY BY NAME g_srn[l_ac].srn08
            #No.FUN-BB0086--add--end--
         END IF

      #No.FUN-BB0086--add--begin--
      AFTER FIELD srn08
         IF NOT cl_null(g_srn[l_ac].srn08) THEN
            LET g_srn[l_ac].srn08 = s_digqty(g_srn[l_ac].srn08,g_srn[l_ac].srn06)
            DISPLAY BY NAME g_srn[l_ac].srn08
         END IF  
      #No.FUN-BB0086--add--end--
      
      BEFORE DELETE                            #是否取消單身
         IF g_srn_t.srn02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM srn_file WHERE srn01 = g_srn01
                                   AND srn02 = g_srn_t.srn02
                                   AND srn03 = g_srn03
                                   AND srn04 = g_srn04
                                   AND srn05 = g_srn05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_srn_t.srn02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("del","srn_file",g_srn01,g_srn_t.srn02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_srn[l_ac].* = g_srn_t.*
            CLOSE t330_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_srn[l_ac].srn02,-263,1)
            LET g_srn[l_ac].* = g_srn_t.*
         ELSE
            UPDATE srn_file SET srn02 = g_srn[l_ac].srn02,
                                srn06 = g_srn[l_ac].srn06,
                                srn07 = g_srn[l_ac].srn07,
                                srn08 = g_srn[l_ac].srn08
                                 WHERE srn01 = g_srn01
                                   AND srn02 = g_srn_t.srn02
                                   AND srn03 = g_srn03
                                   AND srn04 = g_srn04
                                   AND srn05 = g_srn05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_srn[l_ac].srn02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("upd","srn_file",g_srn01,g_srn_t.srn02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               LET g_srn[l_ac].* = g_srn_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac           #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_srn[l_ac].* = g_srn_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_srn.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t330_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D40030 Add 
         CLOSE t330_bcl
         COMMIT WORK
         #CKP2
        #CALL g_srn.deleteElement(g_rec_b+1)    #FUN-D40030 Add
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(srn02)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  ="q_ima"
#              CALL cl_create_qry() RETURNING g_srn[l_ac].srn02
               CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                   RETURNING  g_srn[l_ac].srn02 
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_srn[l_ac].srn02
               NEXT FIELD srn02
            WHEN INFIELD(srn06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gef"
               CALL cl_create_qry() RETURNING g_srn[l_ac].srn06
               DISPLAY BY NAME g_srn[l_ac].srn06
               NEXT FIELD srn06
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(srn02) AND l_ac > 1 THEN
            LET g_srn[l_ac].* = g_srn[l_ac-1].*
            LET g_srn[l_ac].srn02=null
            NEXT FIELD srn02
         END IF
 
      ON ACTION CONTROLZ
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END     
 
   END INPUT
 
   CLOSE t330_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t330_b_fill(p_wc)                     #BODY FILL UP
DEFINE
   p_wc            LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
   LET g_sql = "SELECT srn02,'','',srn06,srn07,srn08",
               " FROM srn_file ",
               " WHERE srn01 = '",g_srn01,"'",
               "   AND srn03 = '",g_srn03,"'",
               "   AND srn04 = '",g_srn04,"'",
               "   AND srn05 = '",g_srn05,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY srn02"
   PREPARE t330_prepare2 FROM g_sql       #預備一下
   DECLARE srn_cs CURSOR FOR t330_prepare2
 
   CALL g_srn.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH srn_cs INTO g_srn[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL t330_set_srn02(g_srn[g_cnt].srn02) RETURNING 
                                          g_srn[g_cnt].ima02,g_srn[g_cnt].ima021
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_srn.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t330_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srn TO s_srn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL t330_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t330_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t330_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t330_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t330_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
 
      #FUN-4B0018
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
#@    ON ACTION 資料擷取
      ON ACTION gen_data
         LET g_action_choice="gen_data"
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END    
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t330_copy()
DEFINE
   l_n             LIKE type_file.num5,          #No.FUN-680130 SMALLINT
   l_cnt           LIKE type_file.num10,         #No.FUN-680130 INTEGER
   l_newno1,l_oldno1  LIKE srn_file.srn01,
   l_newno2,l_oldno2  LIKE srn_file.srn03,
   l_newno3,l_oldno3  LIKE srn_file.srn04,
   l_newno4,l_oldno4  LIKE srn_file.srn05
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_srn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   DISPLAY " " TO srn01
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INPUT l_newno1,l_newno2,l_newno3,l_newno4 FROM srn01,srn03,srn04,srn05
 
       AFTER FIELD srn01
          DISPLAY YEAR(g_srn01) TO srn09
          DISPLAY MONTH(g_srn01) TO srn10
 
       AFTER FIELD srn03
          IF NOT cl_null(l_newno2) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM imd_file WHERE imd01=l_newno2
                                                        AND imdacti='Y'
             IF l_cnt=0 OR SQLCA.sqlcode THEN
                CALL cl_err('',100,1)
                NEXT FIELD srn03
             END IF                                           
          END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
         IF cl_null(l_newno3) THEN
            LET l_newno3=' '
            DISPLAY l_newno3 TO srn04
         END IF
         
         IF cl_null(l_newno4) THEN
            LET l_newno4=' '
            DISPLAY l_newno4 TO srn05
         END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(srn03)
#FUN-AB0003  --modify
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_imd1"
#               CALL cl_create_qry() RETURNING g_srn03
                CALL q_imd_1(FALSE,TRUE,"","","","","") RETURNING g_srn03
#FUN-AB0003  --end
               #DISPLAY BY NAME g_srn03     #TQC-940105
                LET l_newno2=g_srn03        #TQC-940105     
                DISPLAY l_newno2 TO srn03   #TQC-940105   
                NEXT FIELD srn03
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
      LET INT_FLAG = 0
      DISPLAY g_srn01 TO srn01
      DISPLAY g_srn03 TO srn03
      DISPLAY g_srn04 TO srn04
      DISPLAY g_srn05 TO srn05
      DISPLAY g_srn09 TO srn09
      DISPLAY g_srn10 TO srn10
      RETURN
   END IF
 
   DROP TABLE t330_x
 
   SELECT * FROM srn_file             #單身複製
    WHERE srn01 = g_srn01
     INTO TEMP t330_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","t330_x",g_srn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
      RETURN
   END IF
 
   UPDATE t330_x SET srn01=l_newno1,
                     srn03=l_newno2,
                     srn04=l_newno3,
                     srn05=l_newno4,
                     srn08=0,
                     srn09=YEAR(l_newno1),
                     srn10=MONTH(l_newno1)
 
   INSERT INTO srn_file SELECT * FROM t330_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","srn_file","","",SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660138
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_srn01=l_newno1
      LET g_srn03=l_newno2
      LET g_srn04=l_newno3
      LET g_srn05=l_newno4
      LET g_srn09=YEAR(l_newno1)
      LET g_srn10=MONTH(l_newno1)
      CALL t330_show()
   END IF
 
END FUNCTION
 
FUNCTION t330_set_srn02(p_srn02)
DEFINE p_srn02 LIKE srn_file.srn02,
       l_ima02 LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021
 
   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01=p_srn02
   IF SQLCA.sqlcode THEN
      LET l_ima02=null
      LET l_ima021=null
   END IF
   RETURN l_ima02,l_ima021
END FUNCTION
 
FUNCTION t330_g()
DEFINE l_imk RECORD LIKE imk_file.*,
       l_cnt,l_count LIKE type_file.num10,      #No.FUN-680130 INTEGER
       l_img09 LIKE img_file.img09,
       l_sql   STRING
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   OPEN WINDOW t330a_w AT 2,2 WITH FORM "asr/42f/asrt330a" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
         
   CALL cl_ui_locale("asrt330a")
 
   LET tm.date=t330_GETLASTDAY(g_today)
   LET tm.year=YEAR(tm.date)
   LET tm.month=MONTH(tm.date)
 
   CONSTRUCT BY NAME tm.wc ON imk01,imk02,imk03,imk04
     BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(imk01)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_ima"
#              LET g_qryparam.state = "c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO imk01
               NEXT FIELD imk02
            WHEN INFIELD(imk02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imd1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imk02
               NEXT FIELD imk02
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
    END CONSTRUCT
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW t330a_w
      RETURN
   END IF
 
   IF cl_null(tm.wc) THEN
      LET tm.wc=" 1=1"
   END IF
 
   INPUT tm.date,tm.year,tm.month WITHOUT DEFAULTS FROM date,year,month
   
     AFTER INPUT
        IF MDY(tm.month,1,tm.year) IS NULL THEN
           NEXT FIELD year
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
      CLOSE WINDOW t330a_w
      RETURN
   END IF
 
   IF NOT cl_sure(0,0) THEN 
      CLOSE WINDOW t330a_w
      RETURN
   END IF
   
   LET g_success='Y'
   LET l_count=0
   BEGIN WORK
   LET l_sql="SELECT * FROM imk_file ",
             " WHERE imk05=",tm.year," AND imk06=",tm.month,
             " AND ", tm.wc CLIPPED
   PREPARE t300a_cur_pre FROM l_sql
   DECLARE t300a_cur CURSOR FOR t300a_cur_pre
 
   FOREACH t300a_cur INTO l_imk.*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_count=l_count+1
      LET l_img09=t330_get_img09(l_imk.imk01,l_imk.imk02,l_imk.imk03,l_imk.imk04)
      SELECT COUNT(*) INTO l_cnt FROM srn_file WHERE srn01=tm.date
                                                 AND srn02=l_imk.imk01
                                                 AND srn03=l_imk.imk02
                                                 AND srn04=l_imk.imk03
                                                 AND srn05=l_imk.imk04
      IF l_cnt=0 OR SQLCA.sqlcode THEN                                           
         INSERT INTO srn_file(srn01,srn02,srn03,srn04,srn05,
                              srn06,srn07,srn08,srn09,srn10,
                              srn11,srn12,srn13,srn14,srn15,
                              srn16,srn17,srn18,srn19,srn20)
              VALUES(tm.date,l_imk.imk01,l_imk.imk02,l_imk.imk03,l_imk.imk04,
                     l_img09,l_imk.imk09,0,tm.year,tm.month,
                     0,0,0,0,l_imk.imk081,
                     l_imk.imk082,l_imk.imk083,l_imk.imk084,l_imk.imk085,0)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
#           CALL cl_err('ins srn',SQLCA.sqlcode,1)   #No.FUN-660138
            CALL cl_err3("ins","srn_file",tm.date,l_imk.imk01,SQLCA.sqlcode,"","ins srn",1)  #No.FUN-660138
            EXIT FOREACH
         END IF
      ELSE
         IF cl_null(l_imk.imk09) THEN
            LET l_imk.imk09=0
         END IF
         #UPDATE srn_file set srn07=srn07+l_imk.imk09 WHERE srn01=tm.date   #MOD-BC0041 mark
         UPDATE srn_file set srn07=l_imk.imk09 WHERE srn01=tm.date          #MOD-BC0041 add
                                                       AND srn02=l_imk.imk01
                                                       AND srn03=l_imk.imk02
                                                       AND srn04=l_imk.imk03
                                                       AND srn05=l_imk.imk04
         IF SQLCA.sqlcode OR (SQLCA.sqlerrd[3]=0) THEN
            LET g_success='N'
#           CALL cl_err('upd srn',SQLCA.sqlcode,1)   #No.FUN-660138
            CALL cl_err3("upd","srn_file",tm.date,l_imk.imk01,SQLCA.sqlcode,"","upd srn",1)  #No.FUN-660138
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
   IF l_count=0 THEN
      LET g_success='N'
      CALL cl_err('','mfg9328',1)
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','lib-284',1)
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE WINDOW t330a_w
END FUNCTION
 
FUNCTION t330_get_img09(p_img01,p_img02,p_img03,p_img04)
DEFINE p_img01 LIKE img_file.img01,
       p_img02 LIKE img_file.img02,
       p_img03 LIKE img_file.img03,
       p_img04 LIKE img_file.img04,
       l_img09 LIKE img_file.img09
       
   SELECT img09 INTO l_img09 FROM img_file WHERE img01=p_img01
                                             AND img02=p_img02
                                             AND img03=p_img03
                                             AND img04=p_img04
   IF SQLCA.sqlcode OR cl_null(l_img09) THEN
      SELECT ima25 INTO l_img09 FROM ima_file WHERE ima01=p_img01
   END IF
   RETURN l_img09
END FUNCTION
 
FUNCTION t330_r()
 
  #TQC-670051-begin
   IF cl_null(g_srn01) OR cl_null(g_srn03) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF
  #TQC-670051-end
 
   IF NOT cl_delh(20,16) THEN RETURN END IF
   DELETE FROM srn_file WHERE srn01=g_srn01
                          AND srn03=g_srn03
                          AND srn04=g_srn04
                          AND srn05=g_srn05
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('del srn',SQLCA.sqlcode,1)   #No.FUN-660138
      CALL cl_err3("del","srn_file",g_srn01,g_srn03,SQLCA.sqlcode,"","del srn",1)  #No.FUN-660138
      RETURN      
   END IF   
 
   INITIALIZE g_srn01,g_srn03,g_srn04,g_srn05,g_srn09,g_srn10 TO NULL
   MESSAGE ""
   DROP TABLE t330_cnttmp                         #No.TQC-720019
   PREPARE t330_cnttmp_pre2 FROM g_sql_tmp        #No.TQC-720019
   EXECUTE t330_cnttmp_pre2                       #No.TQC-720019   
   OPEN t330_count
   #FUN-B50064-add-start--
   IF STATUS THEN
      CLOSE t330_bcs
      CLOSE t330_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end-- 
   FETCH t330_count INTO g_row_count
   #FUN-B50064-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE t330_bcs
      CLOSE t330_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end-- 
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t330_bcs
   #TQC-670051-begin
   #CALL t330_fetch('F')
   #IF g_row_count>0 THEN
   #   OPEN t330_bcs
   #   CALL t330_fetch('F') 
   #ELSE
   #   DISPLAY g_srn01 TO srn01
   #   DISPLAY g_srn03 TO srn03
   #   DISPLAY g_srn04 TO srn04
   #   DISPLAY g_srn05 TO srn05
   #   DISPLAY 0 TO FORMONLY.cn2
   #   CALL g_srn.clear()
   #   CALL t330_menu()
   #END IF  
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL t330_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE
      CALL t330_fetch('/')
   END IF
   #TQC-670051-end
                          
END FUNCTION
 
FUNCTION t330_GETLASTDAY(p_date)
DEFINE p_date   LIKE type_file.dat        #No.FUN-680130 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION
 
FUNCTION t330_get_imk09(p_imk01,p_imk02,p_imk03,p_imk04,p_imk05,p_imk06)
DEFINE p_imk01 LIKE imk_file.imk01,
       p_imk02 LIKE imk_file.imk02,
       p_imk03 LIKE imk_file.imk03,
       p_imk04 LIKE imk_file.imk04,
       p_imk05 LIKE imk_file.imk05,
       p_imk06 LIKE imk_file.imk06,
       l_imk09 LIKE imk_file.imk09
       
   SELECT imk09 INTO l_imk09 FROM imk_file WHERE imk01=p_imk01
                                             AND imk02=p_imk02
                                             AND imk03=p_imk03
                                             AND imk04=p_imk04
                                             AND imk05=p_imk05
                                             AND imk06=p_imk06
   IF SQLCA.sqlcode OR cl_null(l_imk09) THEN
      LET l_imk09=0
   END IF
   RETURN l_imk09
END FUNCTION
