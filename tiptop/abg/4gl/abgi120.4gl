# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi120.4gl
# Descriptions...: 直接材料用料維護作業 
# Date & Author..: 02/09/25 By nicola 
# Modify.........: ching 031104 No.8563 單位換算
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/09/30 by yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: NO.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i120()_q 一開始應清空g_bgp02的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/06 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770067 07/08/02 By Rayven 新增單身時,報"-1260" 不可能在指定類型間轉換
# Modify.........: No.FUN-820002 07/12/17 By lala   報表轉為使用p_query
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-920163 09/02/20 By mike MSV BUG
# Modify.........: No.FUN-980001 09/08/05 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980120 09/08/17 By lilingyu 銷售單位欄位如果錄入無效值,應該先去檢查是否存在于gfe_file表,如果不存在則show報錯訊息,然后再去檢查有無轉化率
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/22 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80015 11/08/03 By minpp  FOR UPDATE后删掉空白行
# Modify.........: No.FUN-910088 11/12/30 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_bgp01         LIKE bgp_file.bgp01,   #版本
   g_bgp01_t       LIKE bgp_file.bgp01,   #版本(舊值)
   g_bgp02         LIKE bgp_file.bgp02,   #年度    
   g_bgp02_t       LIKE bgp_file.bgp02,   #年度(舊值)
   g_bgp03         LIKE bgp_file.bgp03,   #月份
   g_bgp03_t       LIKE bgp_file.bgp03,   #月份(舊值)
   g_bgp04         LIKE bgp_file.bgp04,   #料號                                 
   g_bgp04_t       LIKE bgp_file.bgp04,   #料號(舊值)
   g_tot           LIKE bgp_file.bgp07,   #總金額
   g_tot_t         LIKE bgp_file.bgp07,   #總金額(舊值)
   g_bgp           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
      bgp04        LIKE bgp_file.bgp04,   #料號
      ima02        LIKE ima_file.ima02,   #品名
      ima021       LIKE ima_file.ima021,  #規格
      bgp05        LIKE bgp_file.bgp05,   #單價
      bgp06        LIKE bgp_file.bgp06,   #數量
      bgp07        LIKE bgp_file.bgp07,   #金額
      bgp11        LIKE bgp_file.bgp11,   
      ima25        LIKE ima_file.ima25,   #
      bgp11_fac    LIKE bgp_file.bgp11_fac,
      bgp08        LIKE bgp_file.bgp08,   #應付款日
      bgp09        LIKE bgp_file.bgp09    #票到期日
                   END RECORD,
   g_bgp_t         RECORD                 #程式變數(舊值)
      bgp04        LIKE bgp_file.bgp04,   #料號
      ima02        LIKE ima_file.ima02,   #品名
      ima021       LIKE ima_file.ima021,  #規格
      bgp05        LIKE bgp_file.bgp05,   #單價
      bgp06        LIKE bgp_file.bgp06,   #數量
      bgp07        LIKE bgp_file.bgp07,   #金額
      bgp11        LIKE bgp_file.bgp11,   
      ima25        LIKE ima_file.ima25,   #
      bgp11_fac    LIKE bgp_file.bgp11_fac,
      bgp08        LIKE bgp_file.bgp08,   #應付款日
      bgp09        LIKE bgp_file.bgp09    #票到期日
                   END RECORD,
   g_wc,g_sql,g_wc2    LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(1300)
   g_show          LIKE type_file.chr1,         #No.FUN-680061 VARCHAR(1)
   g_rec_b         LIKE type_file.num5,         #單身筆數 #No.FUN-680061 SMALLINT
   g_flag          LIKE type_file.chr1,         #No.FUN-680061 VARCHAR(1)
   g_ss            LIKE type_file.chr1,         #No.FUN-680061 VARCHAR(1)
   g_ver           LIKE type_file.chr1,         #No.FUN-680061 VARCHAR(1)
   l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL      
DEFINE g_sql_tmp      STRING   #No.TQC-720019
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680061 INTEGER
DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE g_msg          LIKE ze_file.ze03      #No.FUN-680061 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_row_count    LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE g_curs_index   LIKE type_file.num10    #No.FUN-680061 INTEGER
DEFINE g_jump         LIKE type_file.num10    #查詢指定的筆數 #No.FUN-680061 INTEGER
DEFINE g_no_ask       LIKE type_file.num5     #是否開啟指定筆視窗  #No.FUN-680061 SMALLINT   #No.FUN-6A0057 g_no_ask 
DEFINE g_bgp11_t      LIKE bgp_file.bgp11     #FUN-910088--add--
 
MAIN
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time     #No.FUN-6A0056
 
   LET g_bgp01   = NULL
   LET g_bgp02   = NULL
   LET g_bgp03   = NULL
 
   OPEN WINDOW i120_w WITH FORM "abg/42f/abgi120"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
 
   CALL i120_menu() 
 
   CLOSE WINDOW i120_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i120_cs()
    CLEAR FORM                               #清除畫面
    CALL g_bgp.clear() 
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_bgp01 TO NULL    #No.FUN-750051
   INITIALIZE g_bgp02 TO NULL    #No.FUN-750051
   INITIALIZE g_bgp03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgp01,bgp02,bgp03,bgp04,
                      bgp05,bgp06,bgp07,bgp11,bgp11_fac,bgp08,bgp09
           FROM bgp01,bgp02,bgp03,
                s_bgp[1].bgp04,
                s_bgp[1].bgp05,s_bgp[1].bgp06,s_bgp[1].bgp07,
                s_bgp[1].bgp11,
                s_bgp[1].bgp11_fac,
                s_bgp[1].bgp08,s_bgp[1].bgp09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(bgp04)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()                                      
             #  LET g_qryparam.state = "c"
             #  LET g_qryparam.form ="q_ima"                                
             #  CALL cl_create_qry() RETURNING g_qryparam.multiret       
               CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
               DISPLAY g_qryparam.multiret TO bgp04
            WHEN INFIELD(bgp11)
               CALL cl_init_qry_var()          
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gfe"           
               CALL cl_create_qry() RETURNING g_qryparam.multiret       
               DISPLAY g_qryparam.multiret TO bgp11
               NEXT FIELD bgp11
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
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql = "SELECT UNIQUE bgp01,bgp02,bgp03 FROM bgp_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY bgp01"
    PREPARE i120_prepare FROM g_sql          #預備一下
    DECLARE i120_bcs                         #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i120_prepare
      
#   LET g_sql = "SELECT UNIQUE bgp01,bgp02,bgp03 FROM bgp_file ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE bgp01,bgp02,bgp03 FROM bgp_file ",  #No.TQC-720019
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x"
 
    DROP TABLE x
#   PREPARE i120_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i120_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i120_pre_x


    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i120_precnt FROM g_sql
    DECLARE i120_cnt CURSOR FOR i120_precnt
  
END FUNCTION
 
#中文的MENU 
FUNCTION i120_menu()
DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-820002
   WHILE TRUE
      CALL i120_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
         IF cl_chk_act_auth()                                                   
               THEN CALL i120_out()
         END IF 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgp),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgp01 IS NOT NULL THEN
                LET g_doc.column1 = "bgp01"
                LET g_doc.column2 = "bgp02"
                LET g_doc.column3 = "bgp03"
                LET g_doc.value1 = g_bgp01
                LET g_doc.value2 = g_bgp02
                LET g_doc.value3 = g_bgp03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_a()
   MESSAGE ""
   CLEAR FORM
   LET g_bgp01   = NULL
   LET g_bgp02   = NULL
   LET g_bgp03   = NULL
   LET g_bgp01_t = NULL
   LET g_bgp02_t = NULL
   LET g_bgp03_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i120_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bgp01 = NULL
         LET g_bgp02 = NULL
         LET g_bgp03 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_bgp.clear() 
      LET g_rec_b = 0                    #No.FUN-680064
      CALL i120_b_fill('1=1')            #單身
      CALL i120_b()                      #輸入單身
      LET g_bgp01_t = g_bgp01
      LET g_bgp02_t = g_bgp02
      LET g_bgp03_t = g_bgp03
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i120_i(p_cmd)
   DEFINE
      p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
      l_n             LIKE type_file.num5,    #No.FUN-680061 SMALLINT
      l_str           LIKE type_file.chr50,   #No.FUN-680061 VARCHAR(40)
      l_fab11         LIKE fab_file.fab11
   CALL cl_set_head_visible("","YES")         #No.FUN-6B0033
   INPUT g_bgp01,g_bgp02,g_bgp03,g_tot WITHOUT DEFAULTS
         FROM bgp01,bgp02,bgp03,tot HELP 1
 
      AFTER FIELD bgp02                    #年度
         IF NOT cl_null(g_bgp02) THEN
            IF g_bgp02 < 1 THEN
               NEXT FIELD bgp02
            END IF
         END IF 
 
      AFTER FIELD bgp03                    #月份
         IF NOT cl_null(g_bgp03) THEN
            IF g_bgp03 <1 OR g_bgp03 > 12 THEN
               NEXT FIELD bgp07              #判斷是否在1~12月當中
            END IF
         END IF
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()     
      ON ACTION CONTROLF                 #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
END FUNCTION
 
 
#Query 查詢
FUNCTION i120_q()
DEFINE   l_bgp_hd_bgp01         LIKE bgp_file.bgp01,
         l_bgp_hd_bgp02         LIKE bgp_file.bgp02,
         l_bgp_hd_bgp03         LIKE bgp_file.bgp03
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
      INITIALIZE g_bgp01  TO NULL     #No.FUN-6A0003
      INITIALIZE g_bgp02  TO NULL     #No.FUN-6A0003
      INITIALIZE g_bgp03  TO NULL     #No.FUN-6A0003
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_bgp.clear() 
   CALL i120_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bgp01  TO NULL
      INITIALIZE g_bgp02  TO NULL
      INITIALIZE g_bgp03  TO NULL
      RETURN
   END IF
   OPEN i120_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bgp01  TO NULL
      INITIALIZE g_bgp02  TO NULL
      INITIALIZE g_bgp03  TO NULL
   ELSE
      OPEN i120_cnt
      FETCH i120_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i120_fetch('F')               #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i120_fetch(p_flag)
   DEFINE
      p_flag          LIKE type_file.chr1       #處理方式  #No.FUN-680061 VARCHAR(01)
      #g_jump         LIKE type_file.num10      #絕對的筆數   #NO.TQC-630218   #No.FUN-680061 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i120_bcs INTO g_bgp01,g_bgp02,g_bgp03
      WHEN 'P' FETCH PREVIOUS i120_bcs INTO g_bgp01,g_bgp02,g_bgp03
      WHEN 'F' FETCH FIRST    i120_bcs INTO g_bgp01,g_bgp02,g_bgp03
      WHEN 'L' FETCH LAST     i120_bcs INTO g_bgp01,g_bgp02,g_bgp03
      WHEN '/'
      IF (NOT g_no_ask) THEN    #No.FUN-6A0057 g_no_ask 
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
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
      END IF         
         FETCH ABSOLUTE g_jump i120_bcs INTO g_bgp01,g_bgp02,g_bgp03
         LET g_no_ask = FALSE     #No.FUN-6A0057 g_no_ask 
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bgp01,SQLCA.sqlcode,0)
      INITIALIZE g_bgp01 TO NULL  #TQC-6B0105
      INITIALIZE g_bgp02 TO NULL  #TQC-6B0105
      INITIALIZE g_bgp03 TO NULL  #TQC-6B0105
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
   CALL i120_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i120_show()
    
   DISPLAY g_bgp01  TO bgp01                 #單頭
   DISPLAY g_bgp02  TO bgp02                 #單頭
   DISPLAY g_bgp03  TO bgp03                 #單頭
   CALL i120_b_fill(g_wc)                    #單身
   CALL i120_sum()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i120_r()
 
   IF s_shut(0) THEN RETURN END IF
#  IF g_bgp02 IS NULL THEN RETURN END IF                          #No.FUN-6A0003
   IF g_bgp02 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF   #No.FUN-6A0003
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bgp01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bgp02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "bgp03"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bgp01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bgp02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_bgp03       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bgp_file 
      WHERE bgp01 = g_bgp01
        AND bgp02 = g_bgp02
        AND bgp03 = g_bgp03
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bgp_file",g_bgp01,g_bgp02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
      ELSE
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i120_pre_x                  #No.TQC-720019
         PREPARE i120_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i120_pre_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_bgp.clear()
      OPEN i120_cnt                                                           
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i120_bcs
         CLOSE i120_cnt  
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i120_cnt INTO g_row_count            
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i120_bcs
         CLOSE i120_cnt  
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--                             
      DISPLAY g_row_count TO FORMONLY.cnt                                       
      OPEN i120_bcs                                                              
      IF g_curs_index = g_row_count + 1 THEN                                    
         LET g_jump = g_row_count                                               
         CALL i120_fetch('L')                                                   
      ELSE                                                                      
         LET g_jump = g_curs_index                                              
         LET g_no_ask = TRUE         #No.FUN-6A0057 g_no_ask                                            
         CALL i120_fetch('/')                                                   
      END IF      
      END IF
      LET g_msg=TIME
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
            #VALUES ('abgi120',g_user,g_today,g_msg,g_bgp01,'delete') #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES ('abgi120',g_user,g_today,g_msg,g_bgp01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
   COMMIT WORK 
END FUNCTION
 
 
#單身
FUNCTION i120_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT
      l_n             LIKE type_file.num5,    #檢查重複用   #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,    #單身鎖住否   #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,    #處理狀態     #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.num5,    #可新增否     #No.FUN-680061 SMALLINT
      l_allow_delete  LIKE type_file.num5     #可刪除否     #No.FUN-680061 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF  g_bgp02 IS NULL THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
           "SELECT bgp04,'','',bgp05,bgp06,bgp07,bgp11,'',bgp11_fac,bgp08,bgp09 ",
           " FROM bgp_file  WHERE bgp01 = ? AND bgp02 = ? ",
           "   AND bgp03 = ? AND bgp04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i120_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bgp WITHOUT DEFAULTS FROM s_bgp.*
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
         LET l_lock_sw = 'N'            #DEFAULT
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_bgp_t.* = g_bgp[l_ac].*  #BACKUP
            LET g_bgp11_t = g_bgp[l_ac].bgp11    #FUN-910088--add--
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i601_set_entry_b(p_cmd)
#            CALL i601_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
            OPEN i120_b_cl USING g_bgp01,g_bgp02,g_bgp03,g_bgp_t.bgp04 
            IF STATUS THEN
               CALL cl_err("OPEN i120_b_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bgp01_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_bgp_t.* = g_bgp[l_ac].*
               END IF
               FETCH i120_b_cl INTO g_bgp[l_ac].* 
               CALL i120_bgp04('d',g_bgp[l_ac].bgp04)
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_bgp[l_ac].* TO NULL
         LET g_bgp_t.* = g_bgp[l_ac].*               #新輸入資料
         LET g_bgp[l_ac].bgp05 = 0
         LET g_bgp[l_ac].bgp06 = 0
         LET g_bgp[l_ac].bgp07 = 0
         LET g_bgp[l_ac].bgp08 = ''
         LET g_bgp[l_ac].bgp09 = ''
         LET g_bgp11_t = NULL                        #FUN-910088--add--
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#         LET g_before_input_done = FALSE
#         CALL i601_set_entry_b(p_cmd)
#         CALL i601_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgp04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO bgp_file(bgp01,bgp02,bgp03,bgp04,bgp05,bgp06,bgp07,
                              bgp08,bgp09,bgp11,bgp11_fac)
                VALUES(g_bgp01,g_bgp02,g_bgp03,g_bgp[l_ac].bgp04,
                       g_bgp[l_ac].bgp05,g_bgp[l_ac].bgp06,g_bgp[l_ac].bgp07,
                       g_bgp[l_ac].bgp08,
                       g_bgp[l_ac].bgp09,   #No.TQC-770067
                       g_bgp[l_ac].bgp11,
                       g_bgp[l_ac].bgp11_fac)
#                      g_bgp[l_ac].bgp09)   #No.TQC-770067 mark
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bgp[l_ac].bgp04,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("ins","bgp_file",g_bgp01,g_bgp02,SQLCA.sqlcode,"","",1) #FUN-660105
            CANCEL INSERT
         ELSE
            CALL i120_sum()
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b = g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD bgp04                    #料號
         IF NOT cl_null(g_bgp[l_ac].bgp04) THEN
            #FUN-AA0059 ---------------------------add start----------------------------
            IF NOT s_chk_item_no(g_bgp[l_ac].bgp04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bgp04
            END IF 
            #FUN-AA0059 -----------------------------add end--------------------------    
            IF g_bgp[l_ac].bgp04 != g_bgp_t.bgp04 OR g_bgp_t.bgp04 IS NULL THEN
               SELECT COUNT(*) INTO g_cnt FROM bgp_file
                WHERE bgp01 = g_bgp01 AND bgp02 = g_bgp02
                  AND bgp03 = g_bgp03 AND bgp04 = g_bgp[l_ac].bgp04
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0) 
                  NEXT FIELD bgp04
               END IF
            END IF
            CALL i120_bgp04('a',g_bgp[l_ac].bgp04)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgp04
            END IF
         END IF
          IF cl_null(g_bgp[l_ac].bgp11) THEN
             SELECT ima43 INTO g_bgp[l_ac].bgp11
               FROM ima_file
              WHERE ima01=g_bgp[l_ac].bgp04
           #FUN-910088--add--start--
              IF NOT i120_bgp06_check() THEN
                 LET g_bgp11_t = g_bgp[l_ac].bgp11
                 NEXT FIELD bgp06
              END IF
              LET g_bgp11_t = g_bgp[l_ac].bgp11
           #FUN-910088--add--end--
          END IF
 
      AFTER FIELD bgp11
         IF NOT cl_null(g_bgp[l_ac].bgp11 ) THEN
             CALL i120_bgp11('a',g_bgp[l_ac].bgp11 )
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD bgp11
             END IF
          #FUN-910088--add--start--
             IF NOT i120_bgp06_check() THEN
                LET g_bgp11_t = g_bgp[l_ac].bgp11
                NEXT FIELD bgp06
             END IF
             LET g_bgp11_t = g_bgp[l_ac].bgp11
          #FUN-910088--add--end--
         END IF
 
      AFTER FIELD bgp05
         IF g_bgp[l_ac].bgp05 < 0 THEN
            NEXT FIELD bgp05
         ELSE
            LET g_bgp[l_ac].bgp07 = g_bgp[l_ac].bgp05 * g_bgp[l_ac].bgp06
         END IF 
 
      AFTER FIELD bgp06
         IF NOT i120_bgp06_check() THEN NEXT FIELD bgp06 END IF    #FUN-910088--add--
     #FUN-910088--mark--start--
     #   IF g_bgp[l_ac].bgp06 < 0 THEN
     #      NEXT FIELD bgp06
     #   ELSE
     #      LET g_bgp[l_ac].bgp07 = g_bgp[l_ac].bgp05 * g_bgp[l_ac].bgp06
     #   END IF 
     #FUN-910088--mark--end--
 
      BEFORE DELETE                            #是否取消單身
         IF g_bgp_t.bgp04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM bgp_file
                   WHERE bgp01 = g_bgp01 
                     AND bgp02 = g_bgp02 
                     AND bgp03 = g_bgp03 
                     AND bgp04 = g_bgp_t.bgp04
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgp_t.bgp04,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgp_file",g_bgp01,g_bgp_t.bgp04,SQLCA.sqlcode,"","",1) #FUN-660105
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            CALL i120_sum()
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK 
         END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgp[l_ac].* = g_bgp_t.*
               CLOSE i120_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgp[l_ac].bgp04,-263,1)
               LET g_bgp[l_ac].* = g_bgp_t.*
            ELSE
               UPDATE bgp_file SET bgp04 = g_bgp[l_ac].bgp04,
                                   bgp05 = g_bgp[l_ac].bgp05,
                                   bgp06 = g_bgp[l_ac].bgp06,
                                   bgp07 = g_bgp[l_ac].bgp07,
                                   bgp08 = g_bgp[l_ac].bgp08,
                                   bgp09 = g_bgp[l_ac].bgp09,
                                   bgp11 = g_bgp[l_ac].bgp11,
                                   bgp11_fac = g_bgp[l_ac].bgp11_fac
                      WHERE CURRENT OF i120_b_cl  #要查一下
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bgp[l_ac].bgp04,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bgp_file",g_bgp01,g_bgp[l_ac].bgp04,SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bgp[l_ac].* = g_bgp_t.*
               ELSE
                  CALL i120_sum()
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
      AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgp[l_ac].* = g_bgp_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i120_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30032 add 
            CLOSE i120_b_cl
            COMMIT WORK
 
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(bgp04)
            #  CALL q_ima(1,1,g_bgp[l_ac].bgp04) RETURNING g_bgp[l_ac].bgp04
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()                                      
            #   LET g_qryparam.form ="q_ima"                                
            #   LET g_qryparam.default1=g_bgp[l_ac].bgp04                  
            #   CALL cl_create_qry() RETURNING g_bgp[l_ac].bgp04
               CALL q_sel_ima(FALSE, "q_ima", "", g_bgp[l_ac].bgp04, "", "", "", "" ,"",'' )  RETURNING g_bgp[l_ac].bgp04 
#FUN-AA0059 --End--
               NEXT FIELD bgp04
            WHEN INFIELD(bgp11)
            #  CALL q_gfe(3,4,g_bgp[l_ac].bgp11) RETURNING g_bgp[l_ac].bgp11
               CALL cl_init_qry_var()          
               LET g_qryparam.form ="q_gfe"           
               LET g_qryparam.default1=g_bgp[l_ac].bgp11
               CALL cl_create_qry() RETURNING g_bgp[l_ac].bgp11
               NEXT FIELD bgp11
         END CASE
 
     ON ACTION CONTROLN
        CALL i120_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bgp04) AND l_ac > 1 THEN
            LET g_bgp[l_ac].* = g_bgp[l_ac-1].*
            LET g_bgp[l_ac].bgp04 = NULL
            NEXT FIELD bgp04
         END IF
 
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
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      END INPUT
 
   CLOSE i120_b_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i120_bgp04(p_cmd,p_key)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_ima021  LIKE ima_file.ima021,
        l_ima25   LIKE ima_file.ima25 ,
        l_imaacti LIKE ima_file.imaacti,
        p_key     LIKE bgm_file.bgm017,
        p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT ima02,ima021,ima25,imaacti 
    INTO g_bgp[l_ac].ima02,g_bgp[l_ac].ima021,g_bgp[l_ac].ima25,
         l_imaacti
    FROM ima_file  WHERE ima01 = p_key
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET g_bgp[l_ac].ima02 = NULL  
                                 LET g_bgp[l_ac].ima021= NULL  
                                 LET g_bgp[l_ac].ima25 = NULL  
       WHEN l_imaacti='N'        LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'    LET g_errno = '9038'    #No.FUN-690022
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION i120_bgp11(p_cmd,p_key)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE bgp_file.bgp11,
        l_fac     LIKE pml_file.pml09,     #NO.FUN-680061 DEC(16,8)
        p_cmd     LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti 
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
IF cl_null(g_errno) THEN   #TQC-980120
  LET l_ima01=''
  SELECT ima01 INTO l_ima01 FROM ima_file 
   WHERE ima01=g_bgp[l_ac].bgp04
  SELECT ima25 INTO l_ima25 FROM ima_file
   WHERE ima01=l_ima01
  CALL s_umfchk(l_ima01,p_key,l_ima25)
  RETURNING g_i,l_fac
  IF g_i = 1 THEN
    LET g_errno='abm-731'
    LET l_fac = 1
  END IF
  IF p_cmd='a' THEN
     LET g_bgp[l_ac].bgp11_fac=l_fac
  END IF
  END IF    #TQC-980120  
END FUNCTION
 
 
FUNCTION i120_b_askkey()
   DEFINE
      l_wc            LIKE type_file.chr1000       #No.FUN-680061  VARCHAR(200)
 
   CALL cl_set_head_visible("","YES")         #No.FUN-6B0033			
 
   CONSTRUCT l_wc ON bgp04,bgp11,bgp05,bgp06,bgp07,bgp08,bgp09
             FROM s_bgp[1].bgp04,
                  s_bgp[1].bgp11,
                  s_bgp[1].bgp05,s_bgp[1].bgp06,s_bgp[1].bgp07,
                  s_bgp[1].bgp08,s_bgp[1].bgp09
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
   IF INT_FLAG THEN RETURN END IF
   CALL i120_b_fill(l_wc)
END FUNCTION
 
FUNCTION i120_b_fill(p_wc)                     #BODY FILL UP
   DEFINE
      p_wc            LIKE type_file.chr1000       #No.FUN-680061  VARCHAR(200)
 
   LET g_sql =
       "SELECT bgp04,'','',bgp05,bgp06,bgp07,bgp11,'',bgp11_fac,bgp08,bgp09",
       "  FROM bgp_file ",
       " WHERE bgp01 = '",g_bgp01,"'",
       "   AND bgp02 = '",g_bgp02,"'",
       "   AND bgp03 = '",g_bgp03,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgp04"
   PREPARE i120_prepare2 FROM g_sql       #預備一下
   DECLARE bgp_cs CURSOR FOR i120_prepare2
 
   CALL g_bgp.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH bgp_cs INTO g_bgp[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT ima02,ima021,ima25
        INTO g_bgp[g_cnt].ima02,g_bgp[g_cnt].ima021,g_bgp[g_cnt].ima25 
        FROM ima_file
       WHERE ima01 = g_bgp[g_cnt].bgp04
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_bgp.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   IF g_cnt > g_max_rec THEN
      LET g_msg = g_bgp01 CLIPPED
      CALL cl_err(g_msg,9036,0)
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2 #FUN-920163  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE
      p_ud            LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgp TO s_bgp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first 
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF         
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF         
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump 
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF         
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF         
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL i120_fetch('L')
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i120_sum()
 
   SELECT SUM(bgp07) INTO g_tot FROM bgp_file 
    WHERE bgp01 = g_bgp01 AND bgp02 = g_bgp02 AND bgp03 = g_bgp03
   IF cl_null(g_tot) THEN LET g_tot = 0 END IF
 
   DISPLAY g_tot TO tot
 
END FUNCTION
 
#No.FUN-820002--start-- 
FUNCTION i120_out()
DEFINE l_cmd  LIKE type_file.chr1000
#   DEFINE
#      l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
#      l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
#      l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
#      sr RECORD
#         bgp01      LIKE bgp_file.bgp01,
#         bgp02      LIKE bgp_file.bgp02,
#         bgp03      LIKE bgp_file.bgp03,
#         bgp04      LIKE bgp_file.bgp04,
#         bgp11      LIKE bgp_file.bgp11,
#         bgp11_fac  LIKE bgp_file.bgp11_fac,
#         bgp05      LIKE bgp_file.bgp05,
#         bgp06      LIKE bgp_file.bgp06,
#         bgp07      LIKE bgp_file.bgp07,
#         tot        LIKE bgp_file.bgp07,
#         ima02      LIKE ima_file.ima02,
#         ima021     LIKE ima_file.ima021,
#         ima25      LIKE ima_file.ima25 
#      END RECORD
    IF cl_null(g_wc) AND NOT cl_null(g_bgp01) AND NOT cl_null(g_bgp02)          
       AND NOT cl_null(g_bgp03) AND NOT cl_null(g_bgp04) THEN                   
       LET g_wc = " bgp01 = '",g_bgp01,"' AND bgp02 = '",g_bgp02,               
                  "' AND bgp03 = '",g_bgp03,"'"                                 
    END IF                                                                      
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                
    LET l_cmd = 'p_query "abgi120" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
#   IF  g_bgp02 IS NULL THEN RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('abgi120') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#LET g_sql="SELECT bgp01,bgp02,bgp03,bgp04,bgp11,bgp11_fac, ",
#             "       bgp05,bgp06,bgp07,'','','','' ",
#             "  FROM bgp_file ",   # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED ,
#             " ORDER BY bgp01,bgp02,bgp03 "
#   PREPARE i120_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i120_co CURSOR FOR i120_p1
 
#   START REPORT i120_rep TO l_name
 
#   FOREACH i120_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
 
#      SELECT ima02,ima021,ima25 
#        INTO sr.ima02,sr.ima021,sr.ima25 
#        FROM ima_file
#       WHERE ima01 = sr.bgp04
 
#      OUTPUT TO REPORT i120_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i120_rep
 
#   CLOSE i120_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i120_rep(sr)
#   DEFINE
#      l_trailer_sw    LIKE type_file.chr1,   #NO.FUN-680061 VARCHAR(1)
#      l_azi03         LIKE azi_file.azi03,   #NO.FUN-680061 SMALLINT
#      sr RECORD
#         bgp01      LIKE bgp_file.bgp01,
#         bgp02      LIKE bgp_file.bgp02,
#         bgp03      LIKE bgp_file.bgp03,
#         bgp04      LIKE bgp_file.bgp04,
#         bgp11      LIKE bgp_file.bgp11,
#         bgp11_fac  LIKE bgp_file.bgp11_fac,
#         bgp05      LIKE bgp_file.bgp05,
#         bgp06      LIKE bgp_file.bgp06,
#         bgp07      LIKE bgp_file.bgp07,
#         tot        LIKE bgp_file.bgp07,
#         ima02      LIKE ima_file.ima02,
#         ima021     LIKE ima_file.ima021,
#         ima25      LIKE ima_file.ima25 
#      END RECORD
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.bgp01,sr.bgp02,sr.bgp03,sr.bgp04
 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#               g_x[39],g_x[40]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
   
#      BEFORE GROUP OF sr.bgp01
#         PRINT COLUMN g_c[31],sr.bgp01 CLIPPED;
 
#      BEFORE GROUP OF sr.bgp02
#         PRINT COLUMN g_c[32],sr.bgp02 CLIPPED;
 
#      BEFORE GROUP OF sr.bgp03
#         PRINT COLUMN g_c[33],sr.bgp03 CLIPPED;
 
#      ON EVERY ROW
 
#         PRINT COLUMN g_c[34],sr.bgp04 CLIPPED,
#               COLUMN g_c[35],sr.ima02 CLIPPED,
#               COLUMN g_c[36],sr.ima021 CLIPPED,
#               COLUMN g_c[37],sr.bgp11  CLIPPED,
#               COLUMN g_c[38],cl_numfor(sr.bgp05,38,g_azi03) ,
#               COLUMN g_c[39],cl_numfor(sr.bgp06,39,0) ,
#               COLUMN g_c[40],cl_numfor(sr.bgp07,40,g_azi04) 
 
#      AFTER GROUP OF sr.bgp03
#         PRINT COLUMN g_c[40],g_dash2[1,g_w[40]]
#         PRINT COLUMN g_c[39],g_x[9] CLIPPED,
#               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bgp07),40,g_azi04)
#         SKIP 1 LINE
 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#            PRINT g_dash[1,g_len]
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
 
#END REPORT
#No.FUN-820002--end--
 
#NO.MOD-590329 MARK
 #NO.MOD-580078
#FUNCTION i601_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgp04",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i601_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgp04",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329
#NO.FUN-B80015 
  
#FUN-910088--add--atart--
FUNCTION i120_bgp06_check()
   IF NOT cl_null(g_bgp[l_ac].bgp06) AND NOT cl_null(g_bgp[l_ac].bgp11) THEN
      IF cl_null(g_bgp11_t) OR cl_null(g_bgp_t.bgp06) OR g_bgp11_t != g_bgp[l_ac].bgp11 OR g_bgp_t.bgp06 != g_bgp[l_ac].bgp06 THEN
         LET g_bgp[l_ac].bgp06 = s_digqty(g_bgp[l_ac].bgp06,g_bgp[l_ac].bgp11)
         DISPLAY BY NAME g_bgp[l_ac].bgp06
      END IF
   END IF
   IF g_bgp[l_ac].bgp06 < 0 THEN
      RETURN FALSE    
   ELSE
      LET g_bgp[l_ac].bgp07 = g_bgp[l_ac].bgp05 * g_bgp[l_ac].bgp06
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
