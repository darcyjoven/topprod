# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zv.4gl
# Descriptions...: 程式固定列印方式設定作業
# Date & Author..: 94/02/15 By Felicity Tseng
# Modify.........: No.FUN-790036 07/11/20 By Echo 功能調整
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60063 10/10/26 By jacklai CR透過p_zv直接送印
# Modify.........: No.FUN-B30131 11/03/17 By jacklai 將p_zv的zv06改抓zaw08
# Modify.........: No.FUN-B40019 11/04/11 By CaryHsu 開放zv03可以讓使用者直接選取列印的方式
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B40095 11/05/27 BY jacklai Genero Report 直接送印功能
# Modify.........: No.TQC-B90011 11/09/02 BY jacklai GR預設帶出客製樣板
# Modify.........: No.FUN-BB0099 11/11/23 By janethuang 同一程式代號可以輸入多樣版 
# Modify.........: No.FUN-C70120 12/08/01 By janet 增加列印方式說明、加上GR部份,並將列印方式改成開窗選擇、增加zv09 
# Modify.........: No:FUN-C30027 12/09/13 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-CC0127 12/12/25 By janet GR補上L:終端機及修正CR無法選L BUG
# Modify.........: No.FUN-D10036 13/01/09 By janet 判斷l_ac>0才選擇列印方式 
# Modify.........: No.FUN-D10135 13/01/31 By janet GR直接列印格式有pdf.xls.xlsx.xls(每頁).xlsx(每頁).rtf.html等7種格式 
# Modify.........: No:FUN-D30034 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds    #FUN-790036
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
   DEFINE g_zv02         LIKE zv_file.zv02,       #使用者   (假單頭)
          g_zv05         LIKE zv_file.zv05,       #類別代號 (假單頭)
          g_zv02_t       LIKE zv_file.zv02,       #使用者   (舊值)
          g_zv05_t       LIKE zv_file.zv05,       #類別代號 (舊值)
          g_zv_lock      RECORD LIKE zv_file.*,
          g_zv           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
              zv01       LIKE zv_file.zv01,       #程式代號
              gaz03      LIKE gaz_file.gaz03,     #程式名稱  
              zv06       LIKE zv_file.zv06,       #報表列印的樣板
              zv03       LIKE zv_file.zv03,       #固定列印方式 
              zv03_desc  LIKE type_file.chr1000,  #固定列印說明 #FUN-C70120 add  
              zv09       LIKE zv_file.zv09,       #列印份數    #FUN-C70120 add          
              zv04       LIKE zv_file.zv04,       #縮小列印選項
              zv07       LIKE zv_file.zv07,       #印表機名稱
              zv08       LIKE zv_file.zv08,       #立即列印否
              zvacti     LIKE zv_file.zvacti      #有效否
                          END RECORD,
          g_zv_t         RECORD                     #程式變數 (舊值)
              zv01       LIKE zv_file.zv01,       #程式代號
              gaz03      LIKE gaz_file.gaz03,     #程式名稱  
              zv06       LIKE zv_file.zv06,       #報表列印的樣板
              zv03       LIKE zv_file.zv03,       #固定列印方式
              zv03_desc  LIKE type_file.chr1000,  #固定列印說明 #FUN-C70120 add  
              zv09       LIKE zv_file.zv09,       #列印份數    #FUN-C70120 add                 
              zv04       LIKE zv_file.zv04,       #縮小列印選項
              zv07       LIKE zv_file.zv07,       #印表機名稱
              zv08       LIKE zv_file.zv08,       #立即列印否
              zvacti     LIKE zv_file.zvacti      #有效否
                          END RECORD,
          g_wc            STRING,                
          g_sql           STRING,                
          g_ss            LIKE type_file.chr1,
          g_rec_b         LIKE type_file.num5,       #單身筆數    
          l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT
   DEFINE g_forupd_sql    STRING                     #SELECT ... FOR UPDATE SQL
   DEFINE g_cnt           LIKE type_file.num10       
   DEFINE g_msg           LIKE type_file.chr1000  
   DEFINE g_curs_index    LIKE type_file.num10    
   DEFINE g_row_count     LIKE type_file.num10    
   DEFINE g_jump          LIKE type_file.num10,   
          mi_no_ask       LIKE type_file.num5     
   DEFINE g_zw02          LIKE zw_file.zw02
   DEFINE g_zx02          LIKE zx_file.zx02
   DEFINE g_is_cr         LIKE type_file.num5       #FUN-A60063
   DEFINE g_is_gr         LIKE type_file.num5       #FUN-B40095
   DEFINE g_sys_printers  STRING                    #FUN-B40095
   DEFINE g_call_cr       LIKE type_file.chr1       #FUN-C70120 add
   #FUN-C70120 add (s)----
   DEFINE  g_zv_cr    RECORD
     a1      LIKE type_file.chr1, 
     a2      LIKE type_file.chr1,  
     a3      LIKE type_file.chr1, 
     a4      LIKE type_file.chr1, 
     a5      LIKE type_file.chr1, 
     a6      LIKE type_file.chr1,  
     a7      LIKE type_file.chr1, 
     a8      LIKE type_file.chr1, 
     a9      LIKE type_file.chr1,           
     l      LIKE type_file.chr1,      
     d      LIKE type_file.chr1,
     e      LIKE type_file.chr1,
     p      LIKE type_file.chr1,
     r      LIKE type_file.chr1,
     x      LIKE type_file.chr1,
     a      LIKE type_file.chr1,     
     n      LIKE type_file.chr1      
    END RECORD 
DEFINE  g_zv_prt    RECORD
         a1      LIKE type_file.chr1, 
         a2      LIKE type_file.chr1,  
         a3      LIKE type_file.chr1, 
         a4      LIKE type_file.chr1, 
         a5      LIKE type_file.chr1, 
         a6      LIKE type_file.chr1,  
         a7      LIKE type_file.chr1, 
         a8      LIKE type_file.chr1, 
         a9      LIKE type_file.chr1,           
         l      LIKE type_file.chr1,    
         t      LIKE type_file.chr1,    
         d      LIKE type_file.chr1,    
         x      LIKE type_file.chr1,    
         oh     LIKE type_file.chr1,    
         w      LIKE type_file.chr1,    
         m      LIKE type_file.chr1,    
         s      LIKE type_file.chr1,    
         p      LIKE type_file.chr1,    
         v      LIKE type_file.chr1,    
         n      LIKE type_file.chr1,    
         c      LIKE type_file.chr1,    
         j      LIKE type_file.chr1,    
         h      LIKE type_file.chr1, 
         f      LIKE type_file.chr1,    
         b      LIKE type_file.chr1,    
         e      LIKE type_file.chr1          
        END RECORD     
   #FUN-C70120 add (e)----- 
#主程式開始
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5        
 
   OPTIONS                                          #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)         #計算使用時間 (進入時間) 
       RETURNING g_time    
 
   LET g_zv02 = NULL                     #清除鍵值
   LET g_zv05 = NULL                     #清除鍵值
   LET g_zv02_t = NULL
   LET g_zv05_t = NULL
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW p_zv_w AT p_row,p_col WITH FORM "azz/42f/p_zv"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from zv_file ",
                      " WHERE zv02 = ? AND zv05 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zv_cl CURSOR FROM g_forupd_sql
 
   LET g_sql = "SELECT unique zaa11 FROM zaa_file ",
               " WHERE zaa01 = ? AND zaa10 = ? ",
               "   AND ((zaa04='default' AND zaa17='default') OR ",
               "         zaa04 = ? OR zaa17 = ? )"
   DECLARE p_zaa_curs CURSOR FROM g_sql
 
   CALL p_zv_menu()
 
   CLOSE WINDOW p_zv_w                #結束畫面
    CALL  cl_used(g_prog,g_time,2)        #計算使用時間 (退出使間) 
         RETURNING g_time   
END MAIN
 
FUNCTION p_zv_curs()
   DEFINE l_cnt    LIKE type_file.num10  #FUN-C70120 add
   
 
   CLEAR FORM                             #清除畫面
   CALL g_zv.clear()
 
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   CONSTRUCT g_wc ON zv02,zv05,zv01,zv06,zv03,zv09,zv04,zv07,zv08,zvacti      #FUN-C70120 add zv09
        FROM zv02,zv05,s_zv[1].zv01,s_zv[1].zv06,s_zv[1].zv03,s_zv[1].zv09,   #FUN-C70120 add s_zv[1].zv09
             s_zv[1].zv04,s_zv[1].zv08,s_zv[1].zv07,s_zv[1].zvacti

 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
             CASE  
               WHEN INFIELD(zv02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zx"          
                  LET g_qryparam.default1 = g_zv02
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zv02
                  NEXT FIELD zv02
 
               WHEN INFIELD(zv05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zw"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.default1 = g_zv05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zv05
                  NEXT FIELD zv05
 
               WHEN INFIELD(zv01)                 
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_zaa3"  #FUN-B40095
                 LET g_qryparam.form = "q_zz"     #FUN-B40095
                 LET g_qryparam.arg1 =  g_lang
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1= g_zv[1].zv01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO zv01

               #FUN-C70120 add---start--------------- 120817
               WHEN INFIELD(zv03)                 
                  IF NOT p_zv_chkgr(g_zv[1].zv01) THEN                    #檢查程式是否為GR
                       IF NOT p_zv_chkcr(g_zv[1].zv01) THEN               #檢查程式是否為CR
                            SELECT COUNT(*) INTO l_cnt FROM zaa_file         #ZAA
                                WHERE zaa01 = g_zv[1].zv01 AND zaa04 = g_zv02
                                AND zaa17 = g_zv05 AND zaa10 ='Y'
                            LET g_call_cr="N" 
                            CALL p_zv_prt('N')
                        ELSE 
                            LET g_call_cr="Y" 
                            CALL p_zv_cr()
                        END IF  
                  ELSE 
                      LET g_call_cr="G" 
                      #CALL p_zv_prt('G') #FUN-D10135 mark
                      CALL p_zv_gr()      #FUN-D10135
                  END IF                                   
                  DISPLAY g_zv[1].zv03 TO zv03   
                  ##FUN-D10135 add -(s)   
                   IF g_zv[1].zv03 MATCHES "[1L]" THEN
                       CALL cl_set_comp_entry("zv09,zv07",TRUE)  
                       IF g_zv[1].zv03 ="1" THEN                       
                          LET g_zv[1].zv07 = cl_gr_printer_list()
                       ELSE 
                         IF g_zv_t.zv07 IS NULL THEN 
                           LET g_zv[l_ac].zv07=""
                         END IF  
                         CALL cl_set_comp_entry("zv08", TRUE)
                       END IF 
                   ELSE 
                    CALL cl_set_comp_entry("zv07,zv09,zv08", FALSE)
                    LET g_zv[l_ac].zv07 = ""                
                   END IF 
                  ##FUN-D10135 add -(e)

            END CASE
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION controlg      
             CALL cl_cmdask()     
 
          ON ACTION qbe_select
      	      CALL cl_qbe_select() 
 
          ON ACTION qbe_save
              CALL cl_qbe_save()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
 
   LET g_sql= "SELECT UNIQUE zv02,zv05 FROM zv_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zv02,zv05"
   PREPARE p_zv_prepare FROM g_sql      #預備一下
   DECLARE p_zv_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_zv_prepare
 
END FUNCTION
 
FUNCTION p_zv_count()
 
   LET g_sql= "SELECT UNIQUE zv02,zv05 FROM zv_file",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY zv02"
 
  PREPARE p_zv_precount FROM g_sql
  DECLARE p_zv_count CURSOR FOR p_zv_precount
  LET g_cnt=1
  LET g_cnt=0
  FOREACH p_zv_count
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_cnt = g_cnt - 1
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
    LET g_row_count=g_cnt #No.FUN-580092 HCN
END FUNCTION
 
FUNCTION p_zv_menu()
 
   WHILE TRUE
      CALL p_zv_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_zv_a()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_zv_copy()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_zv_r()
            END IF
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL p_zv_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL p_zv_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL p_zv_out()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_zv_u()
            END IF
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zv),'','')
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
 
FUNCTION p_zv_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL p_zv_curs()                      #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN p_zv_b_curs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                     #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_zv02 TO NULL
   ELSE
      CALL p_zv_fetch('F')               #讀出TEMP第一筆並顯示
      CALL p_zv_count()
      DISPLAY g_row_count TO FORMONLY.cnt 
   END IF
 
END FUNCTION
 
FUNCTION p_zv_fetch(p_flag)
DEFINE
   p_flag   LIKE type_file.chr1,    #處理方式   #No.FUN-680135 VARCHAR(1)
   l_abso   LIKE type_file.num10    #絕對的筆數 #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zv_b_curs INTO g_zv02,g_zv05
      WHEN 'P' FETCH PREVIOUS p_zv_b_curs INTO g_zv02,g_zv05
      WHEN 'F' FETCH FIRST    p_zv_b_curs INTO g_zv02,g_zv05
      WHEN 'L' FETCH LAST     p_zv_b_curs INTO g_zv02,g_zv05
      WHEN '/' 
            IF (NOT mi_no_ask) THEN    #FUN-6A0080
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                  LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump p_zv_b_curs INTO g_zv02,g_zv05
            LET mi_no_ask = FALSE       #FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_zv02,SQLCA.sqlcode,0)
      INITIALIZE g_zv02 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_zv_show()
   END IF
 
END FUNCTION
 
FUNCTION p_zv_show()
 
   DISPLAY g_zv02,g_zv05 TO zv02,zv05                   #單頭
   LET g_zx02 = ""
   LET g_zw02 = ""
   SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01 = g_zv02
   IF SQLCA.sqlcode THEN
      LET g_zx02 = NULL
   END IF
 
   SELECT zw02 INTO g_zw02 FROM zw_file WHERE zw01 = g_zv05
   IF SQLCA.sqlcode THEN
      LET g_zw02 = NULL
   END IF
   DISPLAY g_zw02,g_zx02 TO zw02,zx02 
 
   CALL p_zv_b_fill(g_wc)                       #單身
 
   CALL cl_show_fld_cont()                      #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zv_b()
   DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT 
          l_n             LIKE type_file.num5,   #檢查重複用        
          l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        
          p_cmd           LIKE type_file.chr1,   #處理狀態          
          l_allow_insert  LIKE type_file.num5,   #可新增否          
          l_allow_delete  LIKE type_file.num5    #可刪除否          
   DEFINE lc_zwacti       LIKE zw_file.zwacti    
   DEFINE l_i             LIKE type_file.num10   
   DEFINE l_cnt           LIKE type_file.num10   
   DEFINE l_zaa10         LIKE zaa_file.zaa10
   DEFINE l_zaa04         LIKE zaa_file.zaa04
   DEFINE l_zaa17         LIKE zaa_file.zaa17
   DEFINE l_printers      STRING                  #FUN-B40095
   DEFINE l_prt           LIKE type_file.chr1    #FUN-C70120 add 
   DEFINE l_zv03_str      STRING                 #FUN-C70120 add
   DEFINE l_zv09          LIKE zv_file.zv09      #FUN-C70120 add
   DEFINE l_zvacti        LIKE zv_file.zvacti    #FUN-D10135 add
   
   LET g_action_choice = ""
 
   IF g_zv02 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')

   #LET g_forupd_sql = "SELECT zv01,'',zv06,zv03,zv04,zv07,zv08,zvacti ",         #FUN-C70120 mark
   LET g_forupd_sql = "SELECT zv01,'',zv06,zv03,'',zv09,zv04,zv07,zv08,zvacti ",  #FUN-C70120 add 
                      "  FROM zv_file",
                      #" WHERE zv02=? AND zv05=? AND zv01=? FOR UPDATE" #FUN-BB0099 mark
                      " WHERE zv02=? AND zv05=? AND zv01=? AND zv06=? FOR UPDATE" #FUN-BB0099 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zv_bcl CURSOR FROM g_forupd_sql     
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET l_printers = cl_gr_printer_list()    #FUN-B40095
 
   INPUT ARRAY g_zv WITHOUT DEFAULTS FROM s_zv.*
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
         LET l_zaa10 = ""
         LET l_zv09= 1                  #FUN-C70120
         #FUN-B40095 --start--
         IF NOT p_zv_chkgr(g_zv[l_ac].zv01) THEN
            IF NOT p_zv_chkcr(g_zv[l_ac].zv01) THEN END IF
         END IF
         #FUN-B40095 --end--


         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_zv_t.* = g_zv[l_ac].*  #BACKUP
            LET p_cmd='u'
            OPEN p_zv_bcl USING g_zv02,g_zv05,g_zv_t.zv01,g_zv_t.zv06 #FUN-BB0099 add zv06
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN"||g_zv_t.zv01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            FETCH p_zv_bcl INTO g_zv[l_ac].* 
            IF SQLCA.sqlcode THEN
               CALL cl_err("FETCH"||g_zv_t.zv01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               CALL p_zv_zv01(' ')  
               
               CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc #FUN-C70120 add 
               DISPLAY BY NAME g_zv[l_ac].zv03_desc  #FUN-D10135 add
               LET g_zv_t.*=g_zv[l_ac].*
               
               IF NOT p_zv_chkgr(g_zv[l_ac].zv01) THEN          #FUN-B40095 #檢查程式是否為GR
                   IF NOT p_zv_chkcr(g_zv[l_ac].zv01) THEN               #FUN-A60063 #檢查程式是否為CR
                        SELECT COUNT(*) INTO l_cnt FROM zaa_file 
                            WHERE zaa01 = g_zv[l_ac].zv01 AND zaa04 = g_zv02
                            AND zaa17 = g_zv05 AND zaa10 ='Y'
                        IF l_cnt = 0 THEN
                            LET l_zaa10 = "N"
                        ELSE
                            LET l_zaa10 = "Y"
                        END IF
                        LET g_call_cr="N" #FUN-C70120 add
                    END IF  #FUN-A60063
                END IF  #FUN-B40095
            END IF
            IF NOT g_is_gr THEN #FUN-B40095
                IF NOT g_is_cr THEN  #FUN-A60063
                    CALL cl_set_comp_entry("zv03", TRUE)
                    IF g_zv[l_ac].zv03 MATCHES "[LN]" THEN
                       CALL cl_set_comp_entry("zv04", TRUE)
                       CALL cl_set_comp_visible("zv04",TRUE) #FUN-D10135 add
                    ELSE
                       CALL cl_set_comp_entry("zv04", FALSE)
                       CALL cl_set_comp_visible("zv04",FALSE) #FUN-D10135 add
                    END IF
                    IF g_zv[l_ac].zv03 MATCHES "[123456789LN]" THEN
                       CALL cl_set_comp_entry("zv07", TRUE)
                       CALL cl_set_comp_visible("zv07",TRUE) #FUN-D10135 add
                    ELSE
                       CALL cl_set_comp_entry("zv07", FALSE)
                       CALL cl_set_comp_visible("zv07",FALSE) #FUN-D10135 add
                    END IF
                #FUN-A60063 --start--
                   LET g_call_cr="N" #FUN-C70120 add
                ELSE
                    #CALL cl_set_comp_entry("zv03,zv04", FALSE)  #FUN-B40019
                    CALL cl_set_comp_entry("zv04", FALSE)        #FUN-B40019
                    CALL cl_set_comp_visible("zv04",FALSE) #FUN-D10135 add
                    CALL cl_set_comp_entry("zv07", TRUE)
                    CALL cl_set_comp_visible("zv07",TRUE) #FUN-D10135 add
                    LET g_call_cr="Y" #FUN-C70120 add
                END IF
                #FUN-A60063 --end--
            #FUN-B40095 --start--
            ELSE
                CALL cl_set_comp_entry("zv04", FALSE)
                CALL cl_set_comp_visible("zv04",FALSE) #FUN-D10135 add
                CALL cl_set_comp_entry("zv03,zv07", TRUE)
                CALL cl_set_comp_visible("zv07",TRUE) #FUN-D10135 add
                LET g_call_cr="G" #FUN-C70120 add
            END IF
            #FUN-B40095 --end--
            CALL cl_show_fld_cont()     
         END IF

  

 
      AFTER FIELD zv01
         IF NOT cl_null(g_zv[l_ac].zv01) THEN 
            IF g_zv[l_ac].zv01 != g_zv_t.zv01 OR g_zv_t.zv01 IS NULL THEN
                #FUN-A60063 --start--
                #檢查程式是否為GR
                #FUN-B40095 --start--
                IF p_zv_chkgr(g_zv[l_ac].zv01) THEN
                    SELECT COUNT(*) INTO l_n FROM zv_file  
                     WHERE zv02 = g_zv02 AND zv05 = g_zv05
                       AND zv01 = g_zv[l_ac].zv01
                       AND zv06 = g_zv[l_ac].zv06 #FUN-BB0099  
                       
                    IF l_n > 0 THEN              
                       CALL cl_err(g_zv[l_ac].zv01,-239,0)
                       LET g_zv[l_ac].zv01 = g_zv_t.zv01
                       #FUN-D10135 add -(s)
                       LET g_zv[l_ac].gaz03=''
                       LET g_zv[l_ac].zv03=''
                       LET g_zv[l_ac].zv03_desc=''
                       LET g_zv[l_ac].zv06=''
                       LET g_zv[l_ac].zv09=''
                       #FUN-D10135 add -(e)
                       CALL p_zv_zv01(' ')    
                       NEXT FIELD zv01
                    END IF

                    #帶出預設樣版
                    CALL p_zv_get_gr_default_template(g_zv[l_ac].zv01, g_zv02, g_zv05)    #No.FUN-B30131
                    RETURNING g_zv[l_ac].zv06 
                    DISPLAY BY NAME g_zv[l_ac].zv06

                    #帶出程式名稱
                    CALL cl_get_progdesc(g_zv[l_ac].zv01, g_rlang)
                    RETURNING g_zv[l_ac].gaz03
                    DISPLAY BY NAME g_zv[l_ac].gaz03

                    LET g_zv[l_ac].zv03 = 'L' # FUN-D10135 add
                    #FUN-C70120 add-------start------- #印表方式說明 
                    #CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING l_zv03_str
                    #DISPLAY l_zv03_str TO g_zv[l_ac].zv03_desc
                    #FUN-C70120 add-------end-------
                    #FUN-D10135 add -(s)
                    CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc
                    DISPLAY BY NAME g_zv[l_ac].zv03_desc
                    #FUN-D10135 add -(e)
                    LET g_zv[l_ac].zv04 = ''
                    CALL cl_set_comp_entry("zv04", FALSE)
                    CALL cl_set_comp_entry("zv03,zv07", TRUE)
                    LET g_call_cr = 'G' #FUN-C70120 add
                ELSE
                #FUN-B40095 --end--
                    IF p_zv_chkcr(g_zv[l_ac].zv01) THEN
                        SELECT COUNT(*) INTO l_n FROM zv_file 
                         WHERE zv02 = g_zv02 AND zv05 = g_zv05
                           AND zv01 = g_zv[l_ac].zv01
                           AND zv06 = g_zv[l_ac].zv06 #FUN-BB0099 
                           
                        IF l_n > 0 THEN  
                           CALL cl_err(g_zv[l_ac].zv01,-239,0)
                           LET g_zv[l_ac].zv01 = g_zv_t.zv01
                           CALL p_zv_zv01(' ')  
                           #FUN-D10135 add -(s)
                           LET g_zv[l_ac].gaz03=''
                           LET g_zv[l_ac].zv03=''
                           LET g_zv[l_ac].zv03_desc=''
                           LET g_zv[l_ac].zv06=''
                           LET g_zv[l_ac].zv09=''
                           #FUN-D10135 add -(e)                           
                           NEXT FIELD zv01
                        END IF

                        #帶出預設樣版
                        #CALL p_zv_get_zaw02(g_zv[l_ac].zv01, g_zv02, g_zv05)   #No.FUN-B30131
                        CALL p_zv_get_zaw08(g_zv[l_ac].zv01, g_zv02, g_zv05)    #No.FUN-B30131
                            RETURNING g_zv[l_ac].zv06 
                        DISPLAY BY NAME g_zv[l_ac].zv06

                        #帶出程式名稱
                        CALL cl_get_progdesc(g_zv[l_ac].zv01, g_rlang)
                            RETURNING g_zv[l_ac].gaz03
                        DISPLAY BY NAME g_zv[l_ac].gaz03
                        
                        #FUN-C70120 add-------start------- #印表方式說明 
                        #CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING l_zv03_str
                        #DISPLAY l_zv03_str TO g_zv[l_ac].zv03_desc
                        #FUN-C70120 add-------end-------
                        
                        LET g_zv[l_ac].zv03 = 'L'
                        #FUN-D10135 add -(s)
                        CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc
                        DISPLAY BY NAME g_zv[l_ac].zv03_desc
                        #FUN-D10135 add -(e)
                        LET g_zv[l_ac].zv04 = ''
                        #CALL cl_set_comp_entry("zv03,zv04", FALSE)  #FUN-B40019
                        CALL cl_set_comp_entry("zv04", FALSE)        #FUN-B40019
                        CALL cl_set_comp_entry("zv07", TRUE)
                        LET g_call_cr = 'Y' #FUN-C70120 add
                    ELSE
                    #FUN-A60063 --end--
                        SELECT COUNT(*) INTO l_cnt FROM zaa_file
                         WHERE zaa01 = g_zv[l_ac].zv01
                        IF l_cnt = 0 THEN
                           #CALL cl_err(g_zv[l_ac].zv01,"azz-089",0)  #FUN-D10135 mark
                            CALL cl_err(g_zv[l_ac].zv01,"mfg9002",0)  #FUN-D10135 add  顯示無此報表代號
                            #FUN-D10135 add -(s)
                           LET g_zv[l_ac].gaz03=''
                           LET g_zv[l_ac].zv03=''
                           LET g_zv[l_ac].zv03_desc=''
                           LET g_zv[l_ac].zv06=''
                           LET g_zv[l_ac].zv09=''
                           #FUN-D10135 add -(e)
                           NEXT FIELD zv01
                        END IF
                        CALL p_zv_zv01(' ')    
                        LET g_zv[l_ac].zv03='L'   #FUN-D10135 add
                        ##FUN-C70120 add-------start------- #印表方式說明 
                        #CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING l_zv03_str
                        #DISPLAY l_zv03_str TO g_zv[l_ac].zv03_desc
                        ##FUN-C70120 add-------end-------       
                        #FUN-D10135 add -(s)
                        CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc
                        DISPLAY BY NAME g_zv[l_ac].zv03_desc
                        #FUN-D10135 add -(e)                        
                        SELECT COUNT(*) INTO l_n FROM zv_file
                         WHERE zv02 = g_zv02 AND zv05 = g_zv05
                           AND zv01 = g_zv[l_ac].zv01
                           AND zv06 = g_zv[l_ac].zv06
                           
                        IF l_n > 0 THEN
                           CALL cl_err(g_zv[l_ac].zv01,-239,0)
                           LET g_zv[l_ac].zv01 = g_zv_t.zv01
                           CALL p_zv_zv01(' ')    
                           NEXT FIELD zv01
                        END IF
         
                        SELECT COUNT(*) INTO l_cnt FROM zaa_file 
                         WHERE zaa01 = g_zv[l_ac].zv01 AND zaa04 = g_zv02
                           AND zaa17 = g_zv05 AND zaa10 ='Y'
                        IF l_cnt = 0 THEN
                           LET l_zaa10 = "N"
                        ELSE
                           LET l_zaa10 = "Y"
                        END IF

                        #FUN-A60063 --start--
                        CALL cl_set_comp_entry("zv03", TRUE)
                        IF g_zv[l_ac].zv03 MATCHES "[LN]" THEN
                           CALL cl_set_comp_entry("zv04", TRUE)
                        ELSE
                           CALL cl_set_comp_entry("zv04", FALSE)
                        END IF
                        IF g_zv[l_ac].zv03 MATCHES "[123456789LN]" THEN
                           CALL cl_set_comp_entry("zv07", TRUE)
                        ELSE
                           CALL cl_set_comp_entry("zv07", FALSE)
                        END IF
                        #FUN-A60063 --end--
                        LET g_call_cr = 'N' #FUN-C70120 add                 
                        OPEN p_zaa_curs USING g_zv[l_ac].zv01,l_zaa10,g_zv02,g_zv05
                        FETCH p_zaa_curs INTO g_zv[l_ac].zv06
                        DISPLAY BY NAME g_zv[l_ac].zv06
                    END IF  #FUN-A60063
                END IF  #FUN-B40095
               
            END IF
         #FUN-D10135 add-(s) 
         ELSE 
                CALL cl_err(g_zv[l_ac].zv01,'aap-099',0)
                NEXT FIELD zv01
         #FUN-D10135 add-(e)            
         END IF
      
      AFTER FIELD zv06
         IF NOT cl_null(g_zv[l_ac].zv06) THEN
            #FUN-D10135 add - (s) 
            #判斷此樣板是否已存在了
            IF g_zv[l_ac].zv06 != g_zv_t.zv06 OR g_zv_t.zv06 IS NULL THEN  
                SELECT COUNT(*) INTO l_n FROM zv_file 
                 WHERE zv02 = g_zv02 AND zv05 = g_zv05
                   AND zv01 = g_zv[l_ac].zv01
                   AND zv06 = g_zv[l_ac].zv06               
                IF l_n > 0 THEN  
                   CALL cl_err(g_zv[l_ac].zv01,-239,0)
                   LET g_zv[l_ac].zv01 = g_zv_t.zv01
                   CALL p_zv_zv01(' ')  
                   DISPLAY '' TO zv06  
                   NEXT FIELD zv01
                END IF
            END IF 
            #FUN-D10135 add -(e)

         
            IF g_zv[l_ac].zv06 != g_zv_t.zv06 OR g_zv_t.zv06 IS NULL THEN
                #FUN-B40095 --start--
                IF g_is_gr THEN
                    SELECT COUNT(*) INTO l_cnt FROM gdw_file
                     WHERE gdw01 = g_zv[l_ac].zv01 
                       AND gdw09 = g_zv[l_ac].zv06     #No.FUN-B30131 add
                       AND ((gdw05 = 'default' AND gdw04 = 'default')
                        OR　gdw04 = g_zv05 OR gdw05 = g_zv02)
                ELSE
                #FUN-B40095 --end--
                    #FUN-A60063 --start--
                    IF g_is_cr THEN #CR報表
                        SELECT COUNT(*) INTO l_cnt FROM zaw_file
                            WHERE zaw01 = g_zv[l_ac].zv01 
                            #AND zaw02 = g_zv[l_ac].zv06    #No.FUN-B30131 marked
                            AND zaw08 = g_zv[l_ac].zv06     #No.FUN-B30131 add
                            AND ((zaw05 = 'default' AND zaw04 = 'default')
                            OR　zaw05 = g_zv02 OR zaw04 = g_zv05)
                    ELSE #p_zaa報表
                    #FUN-A60063 --end--
                       SELECT COUNT(*) INTO l_cnt FROM zaa_file 
                        WHERE zaa01 = g_zv[l_ac].zv01 AND zaa10 = l_zaa10
                          AND ((zaa04='default' AND zaa17='default') OR 
                                zaa04 = g_zv02 OR  zaa17 = g_zv05)
                          AND zaa11 = g_zv[l_ac].zv06
                    END IF  #FUN-A60063
                END IF #FUN-B40095
                
                IF l_cnt = 0 THEN
                    CALL cl_err(g_zv[l_ac].zv06,'lib-261',0)
                    NEXT FIELD zv06
                END IF
            END IF
         ##FUN-D10135 add -(s)
         ELSE 
                CALL cl_err(g_zv[l_ac].zv06,'aap-099',0)
                NEXT FIELD zv06         
         ##FUN-D10135 add -(e)
         END IF
         
 
      ON CHANGE zv03
 
         IF NOT g_is_gr THEN #FUN-B40095
           #FUN-D10135 add -(s)
           IF p_zv_chkcr(g_zv[l_ac].zv01) THEN  #CR
              IF g_zv[l_ac].zv03 NOT MATCHES "[123456789LDEPRXAN]" THEN 
                CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                NEXT FIELD zv03
              END IF 
           ELSE 
              IF g_zv[l_ac].zv03 NOT MATCHES "[123456789LTDXIWMSPVNCJ]" THEN 
                CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                NEXT FIELD zv03
              END IF 
           END IF 
           #FUN-D10135 add -(e)
             IF g_zv[l_ac].zv03 MATCHES "[LN]" THEN
                CALL cl_set_comp_entry("zv04", TRUE)
                LET g_zv[l_ac].zv04 = "1"                
             ELSE
                CALL cl_set_comp_entry("zv04", FALSE)
                LET g_zv[l_ac].zv04 = ""
             END IF
             IF g_zv[l_ac].zv03 MATCHES "[123456789LN]" THEN
                CALL cl_set_comp_entry("zv07,zv09", TRUE)
                #FUN-D10135 add -(s)
                IF g_zv[l_ac].zv03 MATCHES "[123456789]" THEN
                  CALL cl_set_comp_entry("zv08",FALSE )
                ELSE 
                  CALL cl_set_comp_entry("zv08",FALSE )
                END IF 
                #FUN-D10135 add -(e)
             ELSE
                CALL cl_set_comp_entry("zv07", FALSE)
                LET g_zv[l_ac].zv07 = ""
             END IF

         #FUN-B40095 --start--
         ELSE
            #IF g_zv[l_ac].zv03 NOT MATCHES "[123456789LDXABEF]" THEN #FUN-C07120 add BEF #FUN-D10135 mark
            IF g_zv[l_ac].zv03 NOT MATCHES "[1LDXPBEFI]" THEN #FUN-D10135  add
                CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                NEXT FIELD zv03
            #FUN-D10135 add -(s)
            ELSE
                IF g_zv[l_ac].zv03 MATCHES "[1L]" THEN
                   IF g_zv[l_ac].zv03 ="1" THEN 
                      #LET g_zv[l_ac].zv07 = cl_gr_printers_show()
                      LET g_zv[l_ac].zv07 = cl_gr_printer_list()
                      CALL cl_set_comp_entry("zv07,zv09", TRUE)
                   ELSE 
                     IF g_zv_t.zv07 IS NULL THEN 
                       LET g_zv[l_ac].zv07=""
                     END IF  
                     CALL cl_set_comp_entry("zv08,zv07,zv09", TRUE)
                   END IF 
                ELSE 
                    CALL cl_set_comp_entry("zv07", FALSE)
                    LET g_zv[l_ac].zv07 = ""                
                END IF 
            #FUN-D10135 add -(e)
            END IF
            
         END IF
         #FUN-B40095 --end--
 
         
         ##FUN-C70120 add-------start------- #印表方式說明 
         #CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING l_zv03_str
         #DISPLAY l_zv03_str TO g_zv[l_ac].zv03_desc
         ##FUN-C70120 add-------end------- 

         #FUN-D10135 add (s)
            CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc
            DISPLAY BY NAME g_zv[l_ac].zv03_desc        
         #FUN-D10135 add (e)
         DISPLAY BY NAME g_zv[l_ac].zv04,g_zv[l_ac].zv07

         #FUN-D10135 add -(s) 

          IF g_zv[l_ac].zv03='1' OR g_zv[l_ac].zv03='L' THEN 
             IF g_zv[l_ac].zv03 ="1" THEN 
                LET g_zv[l_ac].zv07 = cl_gr_printer_list()
                LET g_zv[l_ac].zv08 = 'N'
                CALL cl_set_comp_entry("zv07,zv09", TRUE)   
                CALL cl_err_msg(NULL,"azz1308",NULL,0)
              ELSE 
               IF g_zv_t.zv07 IS NULL THEN 
                  LET g_zv[l_ac].zv07="" 
               END IF 
               CALL cl_set_comp_entry("zv08,zv07,zv09", TRUE)               
               LET g_zv[l_ac].zv08="Y"
               LET g_zv[l_ac].zv09="1"               
             END IF 
           
          ELSE 
             LET g_zv[l_ac].zv07=""
             LET g_zv[l_ac].zv08="N"
             LET g_zv[l_ac].zv09="1"
             CALL cl_set_comp_entry("zv09,zv07,zv08", FALSE) #份數、印表機名稱隱藏
          END IF                        
         #FUN-D10135 add -(e) 
 
      #FUN-B40095 --start--   
      AFTER FIELD zv03
         #FUN-D10135 add -(s)

          IF NOT g_is_gr THEN #FUN-B40095

           #FUN-D10135 add -(s)
           IF p_zv_chkcr(g_zv[l_ac].zv01) THEN  #CR
              IF g_zv[l_ac].zv03 NOT MATCHES "[123456789LDEPRXAN]" THEN 
                CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                NEXT FIELD zv03
              END IF 
           ELSE 
              IF g_zv[l_ac].zv03 NOT MATCHES "[123456789LTDXIWMSPVNCJ]" THEN 
                CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                NEXT FIELD zv03
              END IF 
           END IF 
           #FUN-D10135 add -(e)
          
             IF g_zv[l_ac].zv03 MATCHES "[LN]" THEN
                CALL cl_set_comp_entry("zv04", TRUE)
                LET g_zv[l_ac].zv04 = "1"                
             ELSE
                CALL cl_set_comp_entry("zv04", FALSE)
                LET g_zv[l_ac].zv04 = ""
             END IF
             IF g_zv[l_ac].zv03 MATCHES "[123456789LN]" THEN
                CALL cl_set_comp_entry("zv07,zv09", TRUE)                
                #FUN-D10135 add -(s)
                IF g_zv[l_ac].zv03 MATCHES "[123456789]" THEN
                  CALL cl_set_comp_entry("zv08",FALSE )
                ELSE 
                  CALL cl_set_comp_entry("zv08",FALSE )
                END IF 
                #FUN-D10135 add -(e)
             ELSE
                CALL cl_set_comp_entry("zv07", FALSE)
                LET g_zv[l_ac].zv07 = ""
             END IF

         #FUN-B40095 --start--
         ELSE
            #IF g_zv[l_ac].zv03 NOT MATCHES "[123456789LDXABEF]" THEN #FUN-C07120 add BEF #FUN-D10135 mark
            IF g_zv[l_ac].zv03 NOT MATCHES "[1LDXPBEFI]" THEN #FUN-D10135  add
                CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                NEXT FIELD zv03
            #FUN-D10135 add -(s)
            ELSE
                IF g_zv[l_ac].zv03 MATCHES "[1L]" THEN
                   IF g_zv[l_ac].zv03 ="1" THEN 
                      #LET g_zv[l_ac].zv07 = cl_gr_printers_show()
                      LET g_zv[l_ac].zv07 = cl_gr_printer_list()
                      CALL cl_set_comp_entry("zv09", TRUE)
                   ELSE 
                     IF g_zv_t.zv07 IS NULL THEN 
                        LET g_zv[l_ac].zv07=""                         
                     END IF 
                     CALL cl_set_comp_entry("zv08,zv09,zv07", TRUE)
                   END IF 
                ELSE 
                    CALL cl_set_comp_entry("zv07", FALSE)
                    LET g_zv[l_ac].zv07 = ""                
                END IF 
            #FUN-D10135 add -(e)
            END IF
            
         END IF
         #FUN-D10135 add-(e)

      
         #FUN-C70120 mark-start----
         #IF g_is_gr THEN
            #IF g_zv[l_ac].zv03 NOT MATCHES "[123456789L]" THEN
                #CALL cl_err_msg(NULL,"azz-250",g_zv[l_ac].zv03,0)
                #NEXT FIELD zv03
            #END IF 
         #END IF
         #FUN-C70120 mark-end----
         #FUN-C70120 add-start-----
         IF NOT cl_null(g_zv[l_ac].zv03) THEN
            IF g_zv[l_ac].zv03 != g_zv_t.zv03 OR g_zv_t.zv03 IS NULL THEN               
                  LET l_prt = g_zv[l_ac].zv03
                  #印表方式說明 
                  #CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING l_zv03_str #FUN-D10135mark
                  #DISPLAY l_zv03_str TO g_zv[l_ac].zv03_desc                              ##FUN-D10135mark
                 #FUN-D10135 add (s)
                    CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc
                    DISPLAY BY NAME g_zv[l_ac].zv03_desc        
                 #FUN-D10135 add (e)                  
            END IF
            #FUN-D10135 add -(s)

             IF g_zv[l_ac].zv03='1' OR g_zv[l_ac].zv03='L' THEN                 
                IF g_zv[l_ac].zv03 ="1" THEN 
                   CALL cl_set_comp_entry("zv09,zv07", TRUE )
                   LET g_zv[l_ac].zv07 = cl_gr_printer_list()
                   LET g_zv[l_ac].zv08='N'
                   CALL cl_err_msg(NULL,"azz1308",NULL,0)
                   
                ELSE 
                   CALL cl_set_comp_entry("zv09,zv07,zv08", TRUE )
                   IF g_zv_t.zv07 IS NULL THEN 
                    LET g_zv[l_ac].zv07=""
                   END IF 
                    LET g_zv[l_ac].zv08="Y"
                    LET g_zv[l_ac].zv09="1"
                END IF 
                
             ELSE 
                LET g_zv[l_ac].zv07=""
                LET g_zv[l_ac].zv08="N"
                LET g_zv[l_ac].zv09="1"
                CALL cl_set_comp_entry("zv09,zv07,zv08", FALSE) #份數、印表機名稱隱藏
             END IF              
         ELSE 
                CALL cl_err(g_zv[l_ac].zv03,'aap-099',0)
                NEXT FIELD zv03
         END IF
         #FUN-D10135 add -(e)
         #FUN-C70120 add-end-----
         

      AFTER FIELD zv07
          IF g_is_gr AND g_zv[l_ac].zv03 MATCHES "[123456789]" THEN
              LET g_sys_printers = cl_gr_printer_list()
              IF g_sys_printers.getIndexOf(g_zv[l_ac].zv07,1) <= 0 THEN
                 CALL cl_err_msg(NULL,"azz1073",NULL,0)
                 NEXT FIELD zv07
              END IF
          END IF
      #FUN-B40095 --end--

      #FUN-D10135 add -(s)--
      ON CHANGE zv08 
         CALL cl_set_comp_entry("zv08", TRUE)
         IF g_zv[l_ac].zv03 <> "L" THEN 
            LET g_zv[l_ac].zv08='N'
            CALL cl_set_comp_entry("zv08", FALSE)
            CALL cl_err_msg(NULL,"azz1308",NULL,0)
            
         END IF     

      AFTER FIELD zv08
          CALL cl_set_comp_entry("zv08", TRUE)
          IF g_zv[l_ac].zv03 <> "L" THEN 
            LET g_zv[l_ac].zv08='N'
            CALL cl_set_comp_entry("zv08", FALSE)
            CALL cl_err_msg(NULL,"azz1308",NULL,0)
          END IF        
      
      ON CHANGE zv09
         IF g_zv[l_ac].zv03='1' OR g_zv[l_ac].zv03='L' THEN 
            IF cl_null(g_zv[l_ac].zv09) THEN
               LET g_zv[l_ac].zv09 = 1
            ELSE 
               IF g_zv[l_ac].zv09 < 0 THEN
                  CALL cl_err_msg(NULL,"aec-992",NULL,0)
                  NEXT FIELD zv09                  
               END IF 
            END IF    
         ELSE 
            LET g_zv[l_ac].zv09 = 1
            CALL cl_set_comp_entry("zv09,zv07,zv08", FALSE) #份數、印表機名稱為no entry
         END IF 
            
      AFTER FIELD zv09
         IF g_zv[l_ac].zv03='1' OR g_zv[l_ac].zv03='L' THEN 
            IF cl_null(g_zv[l_ac].zv09) THEN
               LET g_zv[l_ac].zv09 = 1
            ELSE 
               IF g_zv[l_ac].zv09 < 0 THEN
                  CALL cl_err_msg(NULL,"aec-992",NULL,0)
                  NEXT FIELD zv09                  
               END IF 
            END IF    
         ELSE 
            LET g_zv[l_ac].zv09 = 1
            CALL cl_set_comp_entry("zv09,zv07,zv08", FALSE) #份數、印表機名稱隱藏
         END IF    
      #FUN-D10135 add -(e)--    
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zv[l_ac].* TO NULL       #900423
         LET g_zv_t.* = g_zv[l_ac].*          #新輸入資料
         LET g_zv[l_ac].zv08 = "Y"
         LET g_zv[l_ac].zv09 = 1              #列印份數預設為1 #FUN-C70120 
         LET g_zv[l_ac].zvacti = "Y"
         CALL cl_set_comp_entry("zv04,zv07", FALSE)
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zv01
 
     AFTER INSERT

        #FUN-D10135 add -(s)
          SELECT COUNT(*) INTO l_n FROM zv_file
           WHERE zv02 = g_zv02 AND zv05 = g_zv05
             AND zv01 = g_zv[l_ac].zv01
             AND zv06 = g_zv[l_ac].zv06 #FUN-BB0099  
             
          IF l_n > 0 THEN
             CALL cl_err(g_zv[l_ac].zv01,-239,0)
             LET g_zv[l_ac].zv01 = g_zv_t.zv01
             CALL p_zv_zv01(' ')   
               #FUN-D10135 add -(s)
              LET g_zv[l_ac].gaz03=''
              LET g_zv[l_ac].zv03=''
              LET g_zv[l_ac].zv03_desc=''
              LET g_zv[l_ac].zv06=''
              LET g_zv[l_ac].zv09=''
              #FUN-D10135 add -(e)             
             NEXT FIELD zv01
          END IF
        #FUN-D10135 add -(e)

     
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CANCEL INSERT
        END IF
 
        IF cl_null(g_zv[l_ac].zv08) THEN
           LET g_zv[l_ac].zv08 = "N"
        END IF
        #FUN-D10135 mark -(s)
        ##FUN-C70120 add----start
        #IF cl_null(g_zv[l_ac].zv09) THEN
           #LET g_zv[l_ac].zv09 = 1
        #END IF        
        ##FUN-C70120 add----end

         #FUN-D10135 mark -(e)  
         IF g_zv[l_ac].zv03 ='1' THEN  #SERVER印表機，則直接列印否設為y
            LET g_zv[l_ac].zv08 = 'Y'
            CALL cl_err_msg(NULL,"azz1308",NULL,0)
         END IF 
         #FUN-D10135 add -(s) 
        
         IF g_zv[l_ac].zv03='1' OR g_zv[l_ac].zv03='L' THEN 
            IF cl_null(g_zv[l_ac].zv09) THEN
               LET g_zv[l_ac].zv09 = 1
            ELSE 
               IF g_zv[l_ac].zv09 < 0 THEN
                  CALL cl_err_msg(NULL,"aec-992",NULL,0)
                  NEXT FIELD zv09                  
               END IF 
            END IF   
         ELSE 
            CALL cl_set_comp_entry("zv09,zv07,zv08", FALSE) #份數、印表機名稱為no entry
         END IF         
        #FUN-D10135 add -(e)        
        INSERT INTO zv_file(zv02,zv05,zv01,zv06,zv03,zv09,zv04,zv07,zv08,zvacti)  ##FUN-C70120 add zv09
            VALUES (g_zv02,g_zv05,g_zv[l_ac].zv01, g_zv[l_ac].zv06,
                    g_zv[l_ac].zv03,g_zv[l_ac].zv09,g_zv[l_ac].zv04,g_zv[l_ac].zv07,   #FUN-C70120 add g_zv[l_ac].zv09
                    g_zv[l_ac].zv08,g_zv[l_ac].zvacti)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","zv_file",g_zv02,g_zv05,SQLCA.sqlcode,"","",0)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b = g_rec_b + 1
           DISPLAY g_rec_b TO FORMONLY.cn2
        END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zv[l_ac].* = g_zv_t.*
            CLOSE p_zv_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zv[l_ac].zv04,-263,1)
            LET g_zv[l_ac].* = g_zv_t.*
         ELSE

             #FUN-D10135 add -(s) 
             #判斷是否有重覆
             IF g_zv[l_ac].zv01 != g_zv_t.zv01 AND g_zv[l_ac].zv06 != g_zv_t.zv06 THEN 
              SELECT COUNT(*) INTO l_n FROM zv_file
               WHERE zv02 = g_zv02 AND zv05 = g_zv05
                 AND zv01 = g_zv[l_ac].zv01
                 AND zv06 = g_zv[l_ac].zv06   #FUN-D10135 add
                 
              IF l_n > 0 THEN
                 CALL cl_err(g_zv[l_ac].zv01,-239,0)
                 LET g_zv[l_ac].zv01 = g_zv_t.zv01
                 #FUN-D10135 add -(s)
                 LET g_zv[l_ac].gaz03=''
                 LET g_zv[l_ac].zv03=''
                 LET g_zv[l_ac].zv03_desc=''
                 LET g_zv[l_ac].zv06=''
                 LET g_zv[l_ac].zv09=''
                 #FUN-D10135 add -(e)
                 CALL p_zv_zv01(' ')    
                 NEXT FIELD zv01
              END IF
             END IF 

            ##FUN-C70120 add----start-----------
            #IF cl_null(g_zv[l_ac].zv09) THEN
               #LET g_zv[l_ac].zv09 = 1
            #END IF
            ##FUN-C70120 add----end-----------
            #FUN-D10135 mark -(e)
            #FUN-D10135 add -(s)              
             IF g_zv[l_ac].zv03 ='1' THEN  #SERVER印表機，則直接列印否設為y
                LET g_zv[l_ac].zv08 = 'Y'
             ELSE 
                IF cl_null(g_zv[l_ac].zv08) THEN
                   LET g_zv[l_ac].zv08 = "N"
                END IF             
             END IF          
             IF g_zv[l_ac].zv03='1' OR g_zv[l_ac].zv03='L' THEN 
                IF cl_null(g_zv[l_ac].zv09) THEN
                   LET g_zv[l_ac].zv09 = 1
                ELSE 
                   IF g_zv[l_ac].zv09 < 0 THEN
                      CALL cl_err_msg(NULL,"aec-992",NULL,0)
                      NEXT FIELD zv09                  
                   END IF 
                END IF    
             ELSE 
                CALL cl_set_comp_entry("zv09,zv07,zv08", FALSE) #份數、印表機名稱隱藏
             END IF    
            #FUN-D10135 add -(e) 
 
            UPDATE zv_file SET zv01 = g_zv[l_ac].zv01,
                               zv06 = g_zv[l_ac].zv06,
                               zv03 = g_zv[l_ac].zv03,
                               zv09 = g_zv[l_ac].zv09,     #FUN-C70120 add
                               zv04 = g_zv[l_ac].zv04,
                               zv07 = g_zv[l_ac].zv07,
                               zv08 = g_zv[l_ac].zv08,
                               zvacti = g_zv[l_ac].zvacti
             WHERE zv02=g_zv02
               AND zv05=g_zv05
               AND zv01=g_zv_t.zv01
               AND zv06=g_zv_t.zv06 #FUN-BB0099

            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zv[l_ac].zv01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zv_file",g_zv_t.zv01,'',SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zv[l_ac].* = g_zv_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
     BEFORE DELETE                            #是否取消單身
        IF (NOT cl_null(g_zv_t.zv01)) AND (NOT cl_null(g_zv_t.zv06)) THEN
           IF NOT cl_delb(0,0) THEN
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           DELETE FROM zv_file
             WHERE zv02 = g_zv02 AND zv05 = g_zv05
               AND zv01 = g_zv[l_ac].zv01 AND zv06 = g_zv[l_ac].zv06
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","zv_file",g_zv02,g_zv05,SQLCA.sqlcode,"","",0)
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           LET g_rec_b = g_rec_b-1
           DISPLAY g_rec_b TO FORMONLY.cn2
        END IF
        COMMIT WORK
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac            #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_zv[l_ac].* = g_zv_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_zv.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end--- 
            END IF
            CLOSE p_zv_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac            #FUN-D30034 add
         CALL g_zv.deleteElement(g_rec_b+1)
         CLOSE p_zv_bcl
         COMMIT WORK
 
      ON ACTION controlp
          CASE
             WHEN INFIELD(zv01)
                CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_zaa3"  #FUN-A60063
                LET g_qryparam.form = "q_zz"     #FUN-A60063
                LET g_qryparam.arg1 =  g_lang
                LET g_qryparam.default1= g_zv[l_ac].zv01
                CALL cl_create_qry() RETURNING g_zv[l_ac].zv01
                DISPLAY g_zv[l_ac].zv01 TO zv01
                CALL p_zv_zv01(' ')    
                NEXT FIELD zv01
             WHEN INFIELD(zv06)
                #FUN-B40095 --start--
                IF g_is_gr THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gdw"
                    LET g_qryparam.arg1 = g_zv[l_ac].zv01
                    LET g_qryparam.arg2 = g_zv02
                    LET g_qryparam.arg3 = g_zv05
                    LET g_qryparam.arg4 = g_sma.sma124
                    LET g_qryparam.arg5 = g_lang       #FUN-D10036 add
                    LET g_qryparam.construct = "N"
                    LET g_qryparam.default1 = g_zv[l_ac].zv06
                    CALL cl_create_qry() RETURNING g_zv[l_ac].zv06
                    DISPLAY g_zv[l_ac].zv06 TO zv06 
                ELSE
                #FUN-B40095 --end-- 
                    #FUN-A60063 --start--
                    IF g_is_cr THEN
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zaw4"
                        LET g_qryparam.arg1 = g_zv[l_ac].zv01
                        LET g_qryparam.arg2 = g_zv02
                        LET g_qryparam.arg3 = g_zv05
                        LET g_qryparam.arg4 = g_lang
                        LET g_qryparam.construct = "N"
                        CALL cl_create_qry() RETURNING g_zv[l_ac].zv06
                        DISPLAY g_zv[l_ac].zv06 TO zv06 
                    ELSE
                    #FUN-A60063 --end--
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_zaa"
                        LET g_qryparam.arg1 = g_zv[l_ac].zv01
                        LET g_qryparam.arg2 = g_lang
                        LET g_qryparam.arg3 = l_zaa10
                        LET g_qryparam.arg4 = g_zv02
                        LET g_qryparam.arg5 = g_zv05
                        LET g_qryparam.default3= g_zv[l_ac].zv06
                        LET g_qryparam.construct = "N"
                        CALL cl_create_qry() RETURNING l_zaa04,l_zaa17,g_zv[l_ac].zv06
                        DISPLAY g_zv[l_ac].zv06 TO zv06
                    END IF  #FUN-A60063
                END IF #GR

               #FUN-C70120 add---start--------------- 120817
               WHEN INFIELD(zv03)                 
                    #IF g_is_gr THEN   #FUN-D10135 mark
                    IF p_zv_chkgr(g_zv[l_ac].zv01) THEN #FUN-D10135  add
                       #CALL p_zv_prt('G') #FUN-D10135 mark  
                       CALL p_zv_gr()      #FUN-D10135  add
                    ELSE 
                       #IF g_is_cr THEN    #FUN-D10135 mark
                       IF p_zv_chkcr(g_zv[l_ac].zv01) THEN  #FUN-D10135  add
                          CALL p_zv_cr()
                       ELSE 
                          CALL p_zv_prt('N')
                       END IF 
                    END IF                   
                  DISPLAY g_zv[l_ac].zv03 TO zv03
                  #FUN-D10135 add -(s)
                   IF g_zv[l_ac].zv03="L" OR g_zv[l_ac].zv03="1"  THEN 
                         CALL cl_set_comp_entry("zv09,zv07",TRUE)  
                        IF g_zv[l_ac].zv03 = "1" THEN 
                           LET g_zv[l_ac].zv08='Y'
                           CALL cl_set_comp_entry("zv08",TRUE)
                           CALL cl_err_msg(NULL,"azz1308",NULL,0)
                        ELSE 
                           CALL cl_set_comp_entry("zv08",FALSE )
                        END IF 
                  ELSE
                     CALL cl_set_comp_entry("zv09,zv07,zv08",FALSE)
                  END IF                     
                  #FUN-D10135 add -(e)
                  CALL p_zv_zv03str(g_zv[l_ac].zv01,g_zv[l_ac].zv03) RETURNING g_zv[l_ac].zv03_desc 
                  DISPLAY g_zv[l_ac].zv03_desc TO zv03_desc 

                  #NEXT FIELD zv03
               #FUN-C70120 add---end---------------   120817


                
             #FUN-B40095 --start--   
             WHEN INFIELD(zv07)
                LET g_zv[l_ac].zv07 = cl_gr_printers_show()
                DISPLAY g_zv[l_ac].zv07 TO zv07
             #FUN-B40095 --end-- 
             OTHERWISE
                EXIT CASE
          END CASE
  
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE p_zv_bcl
   COMMIT WORK
 
END FUNCTION

                                            
FUNCTION  p_zv_zv01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
 
   CALL cl_get_progname(g_zv[l_ac].zv01,g_lang) RETURNING g_zv[l_ac].gaz03
 
   IF SQLCA.sqlcode THEN
      LET g_zv[l_ac].gaz03 = NULL  #MOD-530267
      RETURN
   END IF
 
END FUNCTION


 
FUNCTION p_zv_b_fill(p_wc)              #BODY FILL UP
DEFINE 
    #p_wc            LIKE type_file.chr1000
    p_wc         STRING,       #NO.FUN-910082
    l_cnt        LIKE type_file.num10, #FUN-C70120 add
    l_zv03_str   STRING               #FUN-C70120 add


    #LET g_sql = "SELECT zv01,' ',zv06,zv03,zv04,zv07,zv08,zvacti FROM zv_file",         #FUN-C70120 mark
    LET g_sql = "SELECT zv01,' ',zv06,zv03,' ',zv09,zv04,zv07,zv08,zvacti FROM zv_file", #FUN-C70120 add
                " WHERE zv02 = '",g_zv02,"' ",
                "   AND  zv05 = '",g_zv05,"' ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY zv01"
 
   PREPARE p_zv_prepare2 FROM g_sql      #預備一下
   DECLARE zv_curs CURSOR FOR p_zv_prepare2
 
   CALL g_zv.clear()
   LET g_rec_b = 0    #MOD620091
   LET g_cnt = 1
 
   FOREACH zv_curs INTO g_zv[g_cnt].*   #單身 ARRAY 填充
      IF g_cnt=1 THEN
         LET g_rec_b=SQLCA.SQLERRD[3]
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL cl_get_progname( g_zv[g_cnt].zv01,g_lang) RETURNING g_zv[g_cnt].gaz03
      #FUN-C70120 add-------start------- #印表方式說明 
      CALL p_zv_zv03str(g_zv[g_cnt].zv01,g_zv[g_cnt].zv03) RETURNING g_zv[g_cnt].zv03_desc
      #FUN-C70120 add-------end-------
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_zv.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1          
   IF g_rec_b=0 AND g_cnt > 0 THEN
      LET g_rec_b=9999
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zv_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)

 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zv TO s_zv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf


      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL p_zv_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)     
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION previous
         CALL p_zv_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION jump 
         CALL p_zv_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL p_zv_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                 
              
      ON ACTION last 
         CALL p_zv_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      AFTER DISPLAY

         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_zv_a()                            # Add  輸入
  MESSAGE ""
  CLEAR FORM
  CALL g_zv.clear()
 
  # 預設值及將數值類變數清成零
  LET g_zv02_t = NULL
  LET g_zv05_t = NULL
 
  CALL cl_opmsg('a')
 
  WHILE TRUE
     LET g_zv02='default'
     LET g_zv05='default'                 
 
     CALL p_zv_i("a")                           # 輸入單頭
 
     IF INT_FLAG THEN                            # 使用者不玩了
        CLEAR FORM                               # 清單頭
        CALL g_zv.clear()                     # 清單身
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
     CALL g_zv.clear()
     LET g_rec_b = 0
 
     IF g_ss='N' THEN
        CALL g_zv.clear()
     ELSE
        CALL p_zv_b_fill('1=1')             # 單身
     END IF
 
     CALL p_zv_b()                          # 輸入單身
     LET g_zv02_t=g_zv02
     LET g_zv05_t=g_zv05
     EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION p_zv_i(p_cmd)                    # 處理INPUT
DEFINE p_cmd         LIKE type_file.chr1    # a:輸入 u:更改 
DEFINE l_zwacti      LIKE zw_file.zwacti   
 
   LET g_ss = 'N'
   DISPLAY g_zv02 TO zv02
   DISPLAY g_zv05 TO zv05
 
   CALL cl_set_head_visible("","YES")   
 
   INPUT g_zv02,g_zv05 WITHOUT DEFAULTS FROM zv02,zv05
 
      BEFORE INPUT   #FUN-560079
         IF p_cmd = 'u' THEN
            IF g_zv02 = 'default' THEN
               IF g_zv05 <> 'default' THEN
                  CALL cl_set_comp_entry("zv05",TRUE)
                  CALL cl_set_comp_entry("zv02",FALSE)
               ELSE
                  CALL cl_set_comp_entry("zv05",TRUE)
                  CALL cl_set_comp_entry("zv02",TRUE)
               END IF
            ELSE
               IF g_zv05 = 'default' THEN
                  CALL cl_set_comp_entry("zv02",TRUE)
                  CALL cl_set_comp_entry("zv05",FALSE)
               END IF
            END IF
         END IF
 
     AFTER FIELD zv02
         IF NOT cl_null(g_zv02) THEN
            IF g_zv02 != g_zv02_t OR cl_null(g_zv02_t) THEN
               IF g_zv02 CLIPPED  <> 'default' THEN
                  SELECT COUNT(*) INTO g_cnt FROM zx_file
                   WHERE zx01 = g_zv02
                  IF g_cnt = 0 THEN
                      CALL cl_err(g_zv02,'mfg1312',0)
                      NEXT FIELD zv02
                  END IF
               END IF
               SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01 = g_zv02
               IF SQLCA.sqlcode THEN
                  LET g_zx02 = NULL
               END IF
               DISPLAY g_zx02 TO zx02
               IF g_zv02 = 'default' THEN
                  IF g_zv05 <> 'default' THEN
                     CALL cl_set_comp_entry("zv05",TRUE)
                     CALL cl_set_comp_entry("zv02",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("zv05",TRUE)
                     CALL cl_set_comp_entry("zv02",TRUE)
                  END IF
               ELSE
                  IF g_zv05 = 'default' THEN
                     CALL cl_set_comp_entry("zv02",TRUE)
                     CALL cl_set_comp_entry("zv05",FALSE)
                  END IF
               END IF
            END IF
         END IF
 
     AFTER FIELD zv05         #FUN-560079
         IF NOT cl_null(g_zv05) THEN
            IF g_zv05 != g_zv05_t OR cl_null(g_zv05_t) THEN
               IF g_zv05 CLIPPED  <> 'default' THEN
                  SELECT zwacti INTO l_zwacti FROM zw_file
                   WHERE zw01 = g_zv05
                  IF STATUS THEN
                      CALL cl_err3("sel","zw_file",g_zv05,"",STATUS,"","SELECT "|| g_zv05,0)    #No.FUN-660081
                      NEXT FIELD zv05
                  ELSE
                     IF l_zwacti != "Y" THEN   #MOD-560212
                        CALL cl_err_msg(NULL,"azz-218",g_zv05 CLIPPED,10)
                        NEXT FIELD zv05
                     END IF
                  END IF
               END IF
               SELECT zw02 INTO g_zw02 FROM zw_file WHERE zw01 = g_zv05
               IF SQLCA.sqlcode THEN
                  LET g_zw02 = NULL
               END IF
               DISPLAY g_zw02 TO zw02
 
               IF g_zv05 = 'default' THEN
                  IF g_zv02 <> 'default' THEN
                     CALL cl_set_comp_entry("zv02",TRUE)
                     CALL cl_set_comp_entry("zv05",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("zv05",TRUE)
                     CALL cl_set_comp_entry("zv02",TRUE)
                  END IF
               ELSE
                  IF g_zv02 = 'default' THEN
                     CALL cl_set_comp_entry("zv05",TRUE)
                     CALL cl_set_comp_entry("zv02",FALSE)
                  END IF
               END IF
            END IF
         END IF
 
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
           IF (p_cmd = 'a') THEN
             SELECT COUNT(*) INTO g_cnt FROM zv_file
              WHERE zv02=g_zv02 AND zv05 = g_zv05       #FUN-B40095 修正以前的bug              
             IF g_cnt > 0  THEN
               CALL cl_err(g_zv02,-239,1)
               NEXT FIELD zv02
             END IF
           ELSE
               IF g_zv02_t <> g_zv02 OR g_zv05_t <> g_zv05
               THEN
                    SELECT COUNT(*) INTO g_cnt FROM zv_file
                     WHERE zv02=g_zv02 AND zv05 = g_zv05    #FUN-B40095 修正以前的bug
                    IF g_cnt > 0  THEN
                       CALL cl_err(g_zv02,-239,1)
                       NEXT FIELD zv02
                    END IF
               END IF
            END IF
 
     ON ACTION controlp
         CASE
            WHEN INFIELD(zv02)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zx"          #MOD-530267
               LET g_qryparam.default1 = g_zv02
               CALL cl_create_qry() RETURNING g_zv02
               DISPLAY g_zv02 TO zv02
 
               SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01 = g_zv02
               IF SQLCA.sqlcode THEN
                  LET g_zx02 = NULL
               END IF
               DISPLAY g_zx02 TO zx02
               NEXT FIELD zv02
 
            WHEN INFIELD(zv05)                      #FUN-560079
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = g_zv05
               CALL cl_create_qry() RETURNING g_zv05
               DISPLAY g_zv05 TO zv05
 
               SELECT zw02 INTO g_zw02 FROM zw_file WHERE zw01 = g_zv05
               IF SQLCA.sqlcode THEN
                  LET g_zw02 = NULL
               END IF
               DISPLAY g_zw02 TO zw02
               NEXT FIELD zv05
 
            OTHERWISE
               EXIT CASE
         END CASE
 
        ON ACTION CONTROLF                       #MOD-560086
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
#TQC-860017 end
   END INPUT
   CALL cl_set_comp_entry("zv02,zv05",TRUE)        #FUN-650175
 
END FUNCTION
 
FUNCTION p_zv_r()        # 取消整筆 (所有合乎單頭的資料)
  DEFINE  l_zv    RECORD LIKE zv_file.*
 
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_zv02) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  BEGIN WORK
 
  OPEN p_zv_cl USING g_zv02,g_zv05
  IF STATUS THEN
     CALL cl_err("DATA LOCK:",STATUS,1)
     CLOSE p_zv_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH p_zv_cl INTO g_zv_lock.*
  IF SQLCA.sqlcode THEN
     CALL cl_err("zv02 LOCK:",SQLCA.sqlcode,1)
     CLOSE p_zv_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  IF cl_delh(0,0) THEN                   #確認一下
     DELETE FROM zv_file WHERE zv02 = g_zv02 AND zv05 = g_zv05
     IF SQLCA.sqlcode THEN
        CALL cl_err3("del","zv_file",g_zv02,g_zv05,SQLCA.sqlcode,"","BODY DELETE",0)
     ELSE
        CLEAR FORM
        CALL g_zv.clear()
        CALL p_zv_count()
#FUN-B50065------begin---
        IF g_row_count=0 OR cl_null(g_row_count) THEN
           CLOSE p_zv_cl
           COMMIT WORK
           RETURN
        END IF
#FUN-B50065------end------
        DISPLAY g_row_count TO FORMONLY.cnt 
 
        OPEN p_zv_b_curs
         IF g_curs_index = g_row_count + 1 THEN 
            LET g_jump = g_row_count
           CALL p_zv_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL p_zv_fetch('/')
        END IF
     END IF
  END IF
  COMMIT WORK
END FUNCTION
 
FUNCTION p_zv_u()
 
  IF s_shut(0) THEN
     RETURN
  END IF
  IF cl_null(g_zv02) OR cl_null(g_zv05) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('u')
 
  LET g_zv02_t = g_zv02
  LET g_zv05_t = g_zv05
 
 
  BEGIN WORK
  OPEN p_zv_cl USING g_zv02,g_zv05
  IF STATUS THEN
     CALL cl_err("DATA LOCK:",STATUS,1)
     CLOSE p_zv_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH p_zv_cl INTO g_zv_lock.*
  IF SQLCA.sqlcode THEN
     CALL cl_err("zv02 LOCK:",SQLCA.sqlcode,1)
     CLOSE p_zv_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  WHILE TRUE
     CALL p_zv_i("u")
     IF INT_FLAG THEN
        LET g_zv02 = g_zv02_t
        LET g_zv05 = g_zv05_t
        DISPLAY g_zv02,g_zv05 TO zv02,zv05
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
 
     UPDATE zv_file SET zv02 = g_zv02, zv05 = g_zv05
      WHERE zv02 = g_zv02_t AND zv05 = g_zv05_t
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","zv_file",g_zv02_t,g_zv05_t,SQLCA.sqlcode,"","",0)
        CONTINUE WHILE
     END IF
     OPEN p_zv_b_curs
     LET g_jump = g_curs_index
     LET mi_no_ask = TRUE
     CALL p_zv_fetch('/')
     EXIT WHILE
  END WHILE
  COMMIT WORK
END FUNCTION
 
FUNCTION p_zv_copy()
  DEFINE   l_n        LIKE type_file.num5,       #No.FUN-680135 SMALLINT
           l_newfe    LIKE zv_file.zv02,
           l_oldfe    LIKE zv_file.zv02,
           l_newfe2   LIKE zv_file.zv05,
           l_oldfe2   LIKE zv_file.zv05
  DEFINE   l_zwacti   LIKE zw_file.zwacti        #FUN-650175
 
  IF s_shut(0) THEN                              # 檢查權限
     RETURN
  END IF
 
  IF g_zv02 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
  INPUT l_newfe,l_newfe2 WITHOUT DEFAULTS FROM zv02,zv05
 
     BEFORE INPUT
        DISPLAY g_zv02 TO zv02
        DISPLAY g_zv05 TO zv05              
        LET l_newfe = g_zv02
        LET l_newfe2 = g_zv05           
        IF l_newfe = 'default' THEN
           IF l_newfe2 <> 'default' THEN
              CALL cl_set_comp_entry("zv05",TRUE)
              CALL cl_set_comp_entry("zv02",FALSE)
           ELSE
              CALL cl_set_comp_entry("zv05",TRUE)
              CALL cl_set_comp_entry("zv02",TRUE)
           END IF
        ELSE
           IF l_newfe2 = 'default' THEN
              CALL cl_set_comp_entry("zv02",TRUE)
              CALL cl_set_comp_entry("zv05",FALSE)
           END IF
        END IF
     
     AFTER FIELD zv02
        IF cl_null(l_newfe) THEN
           NEXT FIELD zv02
        END IF
        IF l_newfe CLIPPED  <> 'default' THEN
           SELECT COUNT(*) INTO g_cnt FROM zx_file
            WHERE zx01 = l_newfe
           IF g_cnt = 0 THEN
               CALL cl_err(l_newfe,'mfg1312',0)
               NEXT FIELD zv02
           END IF
        END IF
        IF l_newfe = 'default' THEN
           IF l_newfe2 <> 'default' THEN
              CALL cl_set_comp_entry("zv05",TRUE)
              CALL cl_set_comp_entry("zv02",FALSE)
           ELSE
              CALL cl_set_comp_entry("zv05",TRUE)
              CALL cl_set_comp_entry("zv02",TRUE)
           END IF
        ELSE
           IF l_newfe2 = 'default' THEN
              CALL cl_set_comp_entry("zv02",TRUE)
              CALL cl_set_comp_entry("zv05",FALSE)
           END IF
        END IF
        #END FUN-650175
 
    AFTER FIELD zv05         #FUN-560079
        IF cl_null(l_newfe2) THEN
           NEXT FIELD zv05
        END IF
        IF l_newfe2 CLIPPED  <> 'default' THEN
           SELECT zwacti INTO l_zwacti FROM zw_file
            WHERE zw01 = l_newfe2
           IF STATUS THEN
               CALL cl_err3("sel","zw_file",l_newfe2,"",STATUS,"","select "||l_newfe2,0)
               NEXT FIELD zv05
           ELSE
              IF l_zwacti != "Y" THEN   #MOD-560212
                 CALL cl_err_msg(NULL,"azz-218",l_newfe2 CLIPPED,10)
                 NEXT FIELD zv05
              END IF
           END IF
        END IF
 
        IF l_newfe2 = 'default' THEN
           IF l_newfe <> 'default' THEN
              CALL cl_set_comp_entry("zv02",TRUE)
 
              CALL cl_set_comp_entry("zv05",FALSE)
           ELSE
              CALL cl_set_comp_entry("zv05",TRUE)
              CALL cl_set_comp_entry("zv02",TRUE)
           END IF
        ELSE
           IF l_newfe = 'default' THEN
              CALL cl_set_comp_entry("zv05",TRUE)
              CALL cl_set_comp_entry("zv02",FALSE)
           END IF
        END IF
 
     AFTER INPUT
          IF INT_FLAG THEN                            # 使用者不玩了
              EXIT INPUT
          END IF
            SELECT COUNT(*) INTO g_cnt FROM zv_file
            WHERE zv02=l_newfe AND zv05 = l_newfe2 
            IF g_cnt > 0  THEN
              CALL cl_err(l_newfe,-239,1)
              NEXT FIELD zv02
            END IF
 
    ON ACTION controlp
        CASE
           WHEN INFIELD(zv02)
              CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"            #MOD-530267
              LET g_qryparam.default1 = l_newfe
              CALL cl_create_qry() RETURNING l_newfe
              DISPLAY l_newfe TO zv02
              NEXT FIELD zv02
 
           WHEN INFIELD(zv05)
              CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"            #MOD-530267
              LET g_qryparam.default1 = l_newfe2
              CALL cl_create_qry() RETURNING l_newfe2
              DISPLAY l_newfe2 TO zv05
              NEXT FIELD zv05
 
           OTHERWISE
              EXIT CASE
        END CASE
 
#TQC-860017 start
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
     ON ACTION help
        CALL cl_show_help()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
#TQC-860017 end
  END INPUT
  CALL cl_set_comp_entry("zv02,zv05",TRUE)        #FUN-650175
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     DISPLAY g_zv02 TO zv02
     DISPLAY g_zv05 TO zv05
     RETURN
  END IF
 
  DROP TABLE x
  SELECT * FROM zv_file
          WHERE zv02 = g_zv02 AND zv05 = g_zv05
    INTO TEMP x
  IF SQLCA.sqlcode THEN
     CALL cl_err3("sel","zv_file",g_zv02,g_zv05,SQLCA.sqlcode,"","",0)   
     RETURN
  END IF
 
  UPDATE x
     SET zv02 = l_newfe,                              # 資料鍵值
         zv05 = l_newfe2
 
  INSERT INTO zv_file SELECT * FROM x
 
  IF SQLCA.SQLCODE THEN
     CALL cl_err3("ins","zv_file",l_newfe,l_newfe2,SQLCA.sqlcode,"","zv",0)
     RETURN
  END IF
  LET g_cnt = SQLCA.SQLERRD[3]
  MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
  LET l_oldfe = g_zv02
  LET l_oldfe2 = g_zv05
  LET g_zv02 = l_newfe
  LET g_zv05 = l_newfe2
 
  CALL p_zv_b()
 
  #LET g_zv02 = l_oldfe   #FUN-C30027
  #LET g_zv05 = l_oldfe2  #FUN-C30027
 
  #CALL p_zv_show()       #FUN-C30027
END FUNCTION
 
FUNCTION p_zv_out()
DEFINE
    l_i            LIKE type_file.num5,
    sr              RECORD
        zv01       LIKE zv_file.zv01,       #程式代號
        gaz03      LIKE gaz_file.gaz03,     #程式名稱  
        zv06       LIKE zv_file.zv06,       #報表列印的樣板
        zv03       LIKE zv_file.zv03,       #固定列印方式
        zv04       LIKE zv_file.zv04,       #縮小列印選項
        zv07       LIKE zv_file.zv07,       #印表機名稱
        zv08       LIKE zv_file.zv08,       #立即列印否
        zvacti     LIKE zv_file.zvacti      #有效否
                    END RECORD,
    l_name         LIKE type_file.chr20,              #External(Disk) file name
    l_za05         LIKE type_file.chr50               #

 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    CALL cl_wait()
 
    #LET l_name = 'p_zv.out'
    CALL cl_outnam('p_zv') RETURNING l_name
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql=" SELECT zv01,gaz03,zv06,zv03,zv04,zv07,zv08,zvacti", 
              "   FROM zv_file, gaz_file ", 
              "  WHERE ",g_wc CLIPPED,
              "    AND gaz01=zv01 AND gaz02='",g_lang CLIPPED,"' ",
              "    AND zv02 = '",g_zv02 CLIPPED,"'",
              "    AND zv05 = '",g_zv05 CLIPPED,"'",
              "  ORDER BY zv01"
    PREPARE p_zv_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zv_curo                         # SCROLL CURSOR
         CURSOR FOR p_zv_p1
 
    START REPORT p_zv_rep TO l_name
 
    FOREACH p_zv_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF        
        OUTPUT TO REPORT p_zv_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p_zv_rep
 
    CLOSE p_zv_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

#FUN-A60063 --start--
#檢查程式代號是否為CR報表
FUNCTION p_zv_chkcr(p_prog)
    DEFINE p_prog   LIKE zaw_file.zaw01
    DEFINE l_cnt    LIKE type_file.num10
    
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM zaw_file WHERE zaw01 = p_prog
    IF SQLCA.sqlcode THEN
        LET l_cnt = -1
    END IF

    LET g_is_cr = (l_cnt > 0) 
    RETURN g_is_cr
END FUNCTION

#檢查程式代號是否為GR報表
#FUN-B40095 --start--
FUNCTION p_zv_chkgr(p_prog)
    DEFINE p_prog   LIKE gdw_file.gdw01
    DEFINE l_cnt    LIKE type_file.num10

    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM gdw_file WHERE gdw01 = p_prog
    IF SQLCA.sqlcode THEN
        LET l_cnt = -1
    END IF

    LET g_is_gr = (l_cnt > 0) 
    RETURN g_is_gr
END FUNCTION
#FUN-B40095 --end--

#FUNCTION p_zv_get_zaw02(p_prog, p_user, p_clas)    #No.FUN-B30131
FUNCTION p_zv_get_zaw08(p_prog, p_user, p_clas)     #No.FUN-B30131
    DEFINE p_prog       LIKE zaw_file.zaw01
    DEFINE p_user       LIKE zaw_file.zaw05
    DEFINE p_clas       LIKE zaw_file.zaw04
    #DEFINE l_zaw02      LIKE zaw_file.zaw02        #No.FUN-B30131
    DEFINE l_zaw08      LIKE zaw_file.zaw08         #No.FUN-B30131
    DEFINE l_cust       LIKE type_file.chr1
    DEFINE l_rec        RECORD
           zaw02        LIKE zaw_file.zaw02,
           zaw03        LIKE zaw_file.zaw03,
           zaw04        LIKE zaw_file.zaw04,
           zaw05        LIKE zaw_file.zaw05,
           zaw08        LIKE zaw_file.zaw08,        #No.FUN-B30131
           zaw10        LIKE zaw_file.zaw10
           END RECORD
    DEFINE l_arr        DYNAMIC ARRAY OF RECORD
           zaw02        LIKE zaw_file.zaw02,
           zaw03        LIKE zaw_file.zaw03,
           zaw04        LIKE zaw_file.zaw04,
           zaw05        LIKE zaw_file.zaw05,
           zaw08        LIKE zaw_file.zaw08,        #No.FUN-B30131
           zaw10        LIKE zaw_file.zaw10
           END RECORD
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_index      LIKE type_file.num10
   
    #帶出預設樣版
    #DECLARE p_zaw_curs CURSOR FOR SELECT DISTINCT zaw02,zaw03,zaw04,zaw05,zaw10        #No.FUN-B30131 
    DECLARE p_zaw_curs CURSOR FOR SELECT DISTINCT zaw02,zaw03,zaw04,zaw05,zaw08,zaw10   #No.FUN-B30131 
        FROM zaw_file WHERE zaw01 = p_prog 
        AND ((zaw05 = 'default' AND zaw04 = 'default') 
        OR zaw05 = p_user OR zaw04 = p_clas)
        AND zaw10 IN ('std', g_sma.sma124) AND zaw06 = g_rlang
        #ORDER BY zaw02,zaw05,zaw04,zaw10,zaw03         #No.FUN-B30131
        ORDER BY zaw02,zaw08,zaw05,zaw04,zaw10,zaw03    #No.FUN-B30131

    CALL l_arr.clear()
    INITIALIZE l_cust TO NULL
    LET l_index  = 0
    LET l_i = 1
    FOREACH p_zaw_curs INTO l_rec.*
        LET l_rec.zaw03 = UPSHIFT(l_rec.zaw03)
        LET l_arr[l_i].* = l_rec.*
        LET l_i = l_i + 1
    END FOREACH

    #找行業別自定義客製樣版
    LET l_index = 0
    FOR l_i = 1 TO l_arr.getLength()
        IF l_arr[l_i].zaw10 = g_sma.sma124 AND l_arr[l_i].zaw03 = "Y"
            AND (l_arr[l_i].zaw05 = p_user OR l_arr[l_i].zaw04 = p_clas) 
        THEN
            LET l_index = l_i            
            EXIT FOR
        END IF
    END FOR

    #找行業別自定義標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = g_sma.sma124 AND l_arr[l_i].zaw03 = "N"
                AND (l_arr[l_i].zaw05 = p_user OR l_arr[l_i].zaw04 = p_clas) 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找行業別預設客製樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = g_sma.sma124 AND l_arr[l_i].zaw03 = "Y"
                AND (l_arr[l_i].zaw05 = "default" AND l_arr[l_i].zaw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找行業別預設標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = g_sma.sma124 AND l_arr[l_i].zaw03 = "N"
                AND (l_arr[l_i].zaw05 = "default" AND l_arr[l_i].zaw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找標準行業別自定義客製樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = "std" AND l_arr[l_i].zaw03 = "Y"
                AND (l_arr[l_i].zaw05 = p_user OR l_arr[l_i].zaw04 = p_clas) 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF 

    #找標準行業別自定義標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = "std" AND l_arr[l_i].zaw03 = "N"
                AND (l_arr[l_i].zaw05 = p_user OR l_arr[l_i].zaw04 = p_clas) 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找標準行業別預設客製樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = "std" AND l_arr[l_i].zaw03 = "Y"
                AND (l_arr[l_i].zaw05 = "default" AND l_arr[l_i].zaw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找標準行業別預設標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO l_arr.getLength()
            IF l_arr[l_i].zaw10 = "std" AND l_arr[l_i].zaw03 = "N"
                AND (l_arr[l_i].zaw05 = "default" AND l_arr[l_i].zaw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #有找到樣版
    IF l_index > 0 THEN
        #LET l_zaw02 = l_arr[l_index].zaw02 #No.FUN-B30131
        LET l_zaw08 = l_arr[l_index].zaw08  #No.FUN-B30131
    END IF

    #RETURN l_zaw02 #No.FUN-B30131
    RETURN l_zaw08  #No.FUN-B30131
END FUNCTION
#FUN-A60063 --end--


#FUN-B40095 --start--
PRIVATE FUNCTION p_zv_get_gr_default_template(p_prog, p_user, p_clas)
    DEFINE p_prog   LIKE gdw_file.gdw01
    DEFINE p_user   LIKE gdw_file.gdw05
    DEFINE p_clas   LIKE gdw_file.gdw04
    DEFINE la_gdw   DYNAMIC ARRAY OF RECORD
           gdw02    LIKE gdw_file.gdw02,
           gdw03    LIKE gdw_file.gdw03,
           gdw04    LIKE gdw_file.gdw04,
           gdw05    LIKE gdw_file.gdw05,
           gdw06    LIKE gdw_file.gdw06,
           gdw09    LIKE gdw_file.gdw09
           END RECORD
    DEFINE l_i      LIKE type_file.num5
    DEFINE l_index  LIKE type_file.num5   #No.TQC-B90011
    #DEFINE l_select LIKE type_file.num5  #No.TQC-B90011

    DECLARE p_zv_get_gr_deftpl_cur CURSOR FOR SELECT gdw02,gdw03,gdw04,gdw05,gdw06,gdw09
    FROM gdw_file WHERE gdw01=p_prog AND ((gdw05='default' AND gdw04='default') OR gdw05=p_user OR gdw04=p_clas)
    AND (gdw06=g_sma.sma124 OR gdw06='std') AND gdw09 NOT LIKE '%_sub%'
    ORDER BY gdw02,gdw03,gdw04,gdw05,gdw06,gdw09

    LET l_i = 1
    FOREACH p_zv_get_gr_deftpl_cur INTO la_gdw[l_i].*
        LET l_i = l_i + 1
    END FOREACH

    #No.TQC-B90011 --start--
    #找行業別自定義客製樣版
    LET l_index = 0
    FOR l_i = 1 TO la_gdw.getLength()
        IF la_gdw[l_i].gdw06 = g_sma.sma124 AND la_gdw[l_i].gdw03 = "Y"
            AND (la_gdw[l_i].gdw05 = p_user OR la_gdw[l_i].gdw04 = p_clas) 
        THEN
            LET l_index = l_i            
            EXIT FOR
        END IF
    END FOR

    #找行業別自定義標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = g_sma.sma124 AND la_gdw[l_i].gdw03 = "N"
                AND (la_gdw[l_i].gdw05 = p_user OR la_gdw[l_i].gdw04 = p_clas) 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找行業別預設客製樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = g_sma.sma124 AND la_gdw[l_i].gdw03 = "Y"
                AND (la_gdw[l_i].gdw05 = "default" AND la_gdw[l_i].gdw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找行業別預設標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = g_sma.sma124 AND la_gdw[l_i].gdw03 = "N"
                AND (la_gdw[l_i].gdw05 = "default" AND la_gdw[l_i].gdw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找標準行業別自定義客製樣版
    IF l_index = 0 THEN
    FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = "std" AND la_gdw[l_i].gdw03 = "Y"
                AND (la_gdw[l_i].gdw05 = p_user OR la_gdw[l_i].gdw04 = p_clas) 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF 

    #找標準行業別自定義標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = "std" AND la_gdw[l_i].gdw03 = "N"
                AND (la_gdw[l_i].gdw05 = p_user OR la_gdw[l_i].gdw04 = p_clas) 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
        END FOR
    END IF

    #找標準行業別預設客製樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = "std" AND la_gdw[l_i].gdw03 = "Y"
                AND (la_gdw[l_i].gdw05 = "default" AND la_gdw[l_i].gdw04 = "default") 
            THEN
                LET l_index = l_i            
                EXIT FOR
            END IF
    END FOR
    END IF

    #找標準行業別預設標準樣版
    IF l_index = 0 THEN
        FOR l_i = 1 TO la_gdw.getLength()
            IF la_gdw[l_i].gdw06 = "std" AND la_gdw[l_i].gdw03 = "N"
                AND (la_gdw[l_i].gdw05 = "default" AND la_gdw[l_i].gdw04 = "default") 
            THEN
                LET l_index = l_i            
            EXIT FOR
        END IF
    END FOR
    END IF

    IF l_index >= 1 THEN
        RETURN la_gdw[l_index].gdw09
    END IF
    #No.TQC-B90011 --end--

    RETURN NULL
END FUNCTION
#FUN-B40095 --end--

REPORT p_zv_rep(sr)
DEFINE
    l_trailer_sw   LIKE type_file.chr1 ,
    sr              RECORD
        zv01       LIKE zv_file.zv01,       #程式代號
        gaz03      LIKE gaz_file.gaz03,     #程式名稱  
        zv06       LIKE zv_file.zv06,       #報表列印的樣板
        zv03       LIKE zv_file.zv03,       #固定列印方式 
        zv04       LIKE zv_file.zv04,       #縮小列印選項
        zv07       LIKE zv_file.zv07,       #印表機名稱
        zv08       LIKE zv_file.zv08,       #立即列印否
        zvacti     LIKE zv_file.zvacti      #有效否
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.zv01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[9] CLIPPED,' ',g_zv02,' ',g_zx02 CLIPPED,
                  COLUMN 35,g_x[10] CLIPPED,' ',g_zv05,' ',g_zw02 CLIPPED
            PRINT ''
            PRINT g_x[31] CLIPPED,
                  g_x[32] CLIPPED,
                  g_x[33] CLIPPED,
                  g_x[34] CLIPPED,
                  g_x[35] CLIPPED,
                  g_x[36] CLIPPED,
                  g_x[37] CLIPPED,
                  g_x[38] CLIPPED

            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.zv01 CLIPPED, 
                  COLUMN g_c[32],sr.gaz03 CLIPPED,    #MOD-530267
                  COLUMN g_c[33],sr.zv03 CLIPPED,
                  COLUMN g_c[34],sr.zv04 CLIPPED,
                  COLUMN g_c[35],sr.zvacti CLIPPED,
                  COLUMN g_c[36],sr.zv06 CLIPPED,  
                  COLUMN g_c[37],sr.zv07 CLIPPED,  
                  COLUMN g_c[38],sr.zv08 CLIPPED  
 
        ON LAST ROW
#No.FUN-6C0046---begin--
           NEED 4 LINES
            IF g_zz05 = 'Y' THEN 
               CALL cl_wcchp(g_wc,'zv01,zv02,zv03,zv04,zv05,zv06,zv07,zv08')
                    RETURNING g_wc
               PRINT g_dash[1,g_len]
               CALL cl_prt_pos_wc(g_wc)
            END IF
#No.FUN-6C0046---end---            
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

#FUN-C70120 add-------start------------
FUNCTION p_zv_prt(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1    
DEFINE  l_zv03   LIKE zv_file.zv03

 
   MESSAGE " "
   
   LET g_zv_prt.a1  = 'N'
   LET g_zv_prt.a2  = 'N'
   LET g_zv_prt.a3  = 'N'
   LET g_zv_prt.a4  = 'N'
   LET g_zv_prt.a5  = 'N'
   LET g_zv_prt.a6  = 'N'
   LET g_zv_prt.a7  = 'N'
   LET g_zv_prt.a8  = 'N' 
   LET g_zv_prt.a9  = 'N'   
   LET g_zv_prt.l  = 'N'
   LET g_zv_prt.t  = 'N'
   LET g_zv_prt.d  = 'N'
   LET g_zv_prt.x  = 'N'
   LET g_zv_prt.oh = 'N'
   LET g_zv_prt.w  = 'N'                     
   LET g_zv_prt.m  = 'N'
   LET g_zv_prt.s  = 'N'
   LET g_zv_prt.p  = 'N'
   LET g_zv_prt.v  = 'N'
   LET g_zv_prt.n  = 'N'    
   LET g_zv_prt.c  = 'N'
   LET g_zv_prt.j  = 'N'
   LET g_zv_prt.h  = 'N'
   LET g_zv_prt.f  = 'N'
   LET g_zv_prt.b  = 'N'
   LET g_zv_prt.e  = 'N'   

   #IF p_cmd<>"a" THEN  #FUN-D10036 mark     
   #IF p_cmd<>"a" AND l_ac>0  THEN   #FUN-D10036 add  #FUN-D10135 mark
   IF (p_cmd<>"a" AND l_ac>0) OR (NOT cl_null(g_zv[l_ac].zv03)) THEN   #FUN-D10135 add     
         CASE g_zv[l_ac].zv03
             WHEN '1' LET  g_zv_prt.a1  = 'Y' 
             WHEN '2' LET  g_zv_prt.a2  = 'Y' 
             WHEN '3' LET  g_zv_prt.a3  = 'Y' 
             WHEN '4' LET  g_zv_prt.a4  = 'Y'      
             WHEN '5' LET  g_zv_prt.a5  = 'Y' 
             WHEN '6' LET  g_zv_prt.a6  = 'Y' 
             WHEN '7' LET  g_zv_prt.a7  = 'Y' 
             WHEN '8' LET  g_zv_prt.a8  = 'Y' 
             WHEN '9' LET  g_zv_prt.a9  = 'Y' 
             WHEN 'L' LET  g_zv_prt.l  = 'Y' 
             WHEN 'T' LET  g_zv_prt.t  = 'Y'     
             WHEN 'D' LET  g_zv_prt.d  = 'Y'  
             WHEN 'X' LET  g_zv_prt.x  = 'Y'
             WHEN 'I' LET  g_zv_prt.oh  = 'Y'  
             WHEN 'W' LET  g_zv_prt.w  = 'Y' 
             WHEN 'M' LET  g_zv_prt.m  = 'Y' 
             WHEN 'S' LET  g_zv_prt.s  = 'Y' 
             WHEN 'P' LET  g_zv_prt.p  = 'Y' 
             WHEN 'V' LET  g_zv_prt.v  = 'Y' 
             WHEN 'N' LET  g_zv_prt.n  = 'Y' 
             WHEN 'C' LET  g_zv_prt.c  = 'Y' 
             WHEN 'J' LET  g_zv_prt.j  = 'Y' 
             WHEN 'H' LET  g_zv_prt.h  = 'Y' 
             WHEN 'F' LET  g_zv_prt.f  = 'Y'
             WHEN 'B' LET  g_zv_prt.b  = 'Y' 
             WHEN 'E' LET  g_zv_prt.e  = 'Y' 
         OTHERWISE EXIT CASE 
       END CASE 
   END IF 

   OPEN WINDOW p_zv_prt_w WITH FORM "azz/42f/p_zv_prt"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zv_prt")

   IF p_cmd = 'G' THEN #GR
       CALL cl_set_comp_visible("d,x,f,b,e,oh,p,l",TRUE) #FUN-D10036 add 
      CALL cl_set_comp_visible("d,x,f,b,e,oh,p,j,l",TRUE) #FUN-CC0127 add l
      #CALL cl_set_comp_visible("a,l,t,w,m,s,v,n,c,h",FALSE) #FUN-CC0127 mark
      #CALL cl_set_comp_visible("a,t,w,m,s,v,n,c,h,j",FALSE)   #FUN-CC0127 #FUN-D10036 add j #FUN-D10135 mark
      CALL cl_set_comp_visible("a,t,w,m,s,v,n,c,h,j,a2,a3,a4,a5,a6,a7,a8,a9",FALSE)  #FUN-D10135 add
   ELSE
      CALL cl_set_comp_visible("a,l,t,w,m,s,p,v,n,c,j,h,d,x,oh,p",TRUE)
   END IF

 
   DISPLAY BY NAME 
       g_zv_prt.a1,g_zv_prt.a2,g_zv_prt.a3,g_zv_prt.a4,g_zv_prt.a5,
       g_zv_prt.a6,g_zv_prt.a7,g_zv_prt.a8,g_zv_prt.a9,
       g_zv_prt.l, g_zv_prt.t, g_zv_prt.d, g_zv_prt.x,
       g_zv_prt.f,  g_zv_prt.b, g_zv_prt.e,
       g_zv_prt.oh, g_zv_prt.w, g_zv_prt.m, g_zv_prt.s, g_zv_prt.p, 
       g_zv_prt.v,  g_zv_prt.n, g_zv_prt.c,  g_zv_prt.j, g_zv_prt.h 
       
   
   INPUT BY NAME  
       g_zv_prt.a1,g_zv_prt.a2,g_zv_prt.a3,g_zv_prt.a4,g_zv_prt.a5,
       g_zv_prt.a6,g_zv_prt.a7,g_zv_prt.a8,g_zv_prt.a9,   
       g_zv_prt.l, g_zv_prt.t, g_zv_prt.d, g_zv_prt.x,
       g_zv_prt.f,  g_zv_prt.b, g_zv_prt.e,
       g_zv_prt.oh, g_zv_prt.w, g_zv_prt.m, g_zv_prt.s, g_zv_prt.p, 
       g_zv_prt.v,  g_zv_prt.n, g_zv_prt.c, g_zv_prt.j, g_zv_prt.h
       
       WITHOUT DEFAULTS ATTRIBUTE (UNBUFFERED)

       ON CHANGE a1
            IF GET_FLDBUF(a1) = 'Y' THEN
               CALL p_zv_gr_allsetN("a1")   
            END IF
       ON CHANGE a2
            IF GET_FLDBUF(a2) = 'Y' THEN
               CALL p_zv_gr_allsetN("a2")   
            END IF
       ON CHANGE a3
            IF GET_FLDBUF(a3) = 'Y' THEN
               CALL p_zv_gr_allsetN("a3")   
            END IF
       ON CHANGE a4
            IF GET_FLDBUF(a4) = 'Y' THEN
               CALL p_zv_gr_allsetN("a4")   
            END IF            
       ON CHANGE a5
            IF GET_FLDBUF(a5) = 'Y' THEN
               CALL p_zv_gr_allsetN("a5")   
            END IF
       ON CHANGE a6
            IF GET_FLDBUF(a6) = 'Y' THEN
               CALL p_zv_gr_allsetN("a6")   
            END IF
       ON CHANGE a7
            IF GET_FLDBUF(a7) = 'Y' THEN
               CALL p_zv_gr_allsetN("a7")   
            END IF
       ON CHANGE a8
            IF GET_FLDBUF(a8) = 'Y' THEN
               CALL p_zv_gr_allsetN("a8")   
            END IF 
       ON CHANGE a9
            IF GET_FLDBUF(a9) = 'Y' THEN
               CALL p_zv_gr_allsetN("a9")   
            END IF  

       ON CHANGE l
            IF GET_FLDBUF(l) = 'Y' THEN
               CALL p_zv_gr_allsetN("l")   
            END IF
       ON CHANGE t
            IF GET_FLDBUF(t) = 'Y' THEN
               CALL p_zv_gr_allsetN("t")   
            END IF
       ON CHANGE d
            IF GET_FLDBUF(d) = 'Y' THEN
               CALL p_zv_gr_allsetN("d")   
            END IF
       ON CHANGE x
            IF GET_FLDBUF(x) = 'Y' THEN
               CALL p_zv_gr_allsetN("x")   
            END IF            
       ON CHANGE oh
            IF GET_FLDBUF(oh) = 'Y' THEN
               CALL p_zv_gr_allsetN("oh")   
            END IF
       ON CHANGE w
            IF GET_FLDBUF(w) = 'Y' THEN
               CALL p_zv_gr_allsetN("w")   
            END IF
       ON CHANGE m
            IF GET_FLDBUF(m) = 'Y' THEN
               CALL p_zv_gr_allsetN("m")   
            END IF
       ON CHANGE s
            IF GET_FLDBUF(s) = 'Y' THEN
               CALL p_zv_gr_allsetN("s")   
            END IF 
       ON CHANGE p
            IF GET_FLDBUF(p) = 'Y' THEN
               CALL p_zv_gr_allsetN("p")   
            END IF  
       ON CHANGE v
            IF GET_FLDBUF(v) = 'Y' THEN
               CALL p_zv_gr_allsetN("v")   
            END IF
       ON CHANGE n
            IF GET_FLDBUF(n) = 'Y' THEN
               CALL p_zv_gr_allsetN("n")   
            END IF
       ON CHANGE c
            IF GET_FLDBUF(c) = 'Y' THEN
               CALL p_zv_gr_allsetN("c")   
            END IF 
       ON CHANGE j
            IF GET_FLDBUF(j) = 'Y' THEN
               CALL p_zv_gr_allsetN("j")   
            END IF 
       ON CHANGE h
            IF GET_FLDBUF(h) = 'Y' THEN
               CALL p_zv_gr_allsetN("h")   
            END IF
       ON CHANGE f
            IF GET_FLDBUF(f) = 'Y' THEN
               CALL p_zv_gr_allsetN("f")   
            END IF
       ON CHANGE b
            IF GET_FLDBUF(b) = 'Y' THEN
               CALL p_zv_gr_allsetN("b")   
            END IF 
       ON CHANGE e
            IF GET_FLDBUF(e) = 'Y' THEN
               CALL p_zv_gr_allsetN("e")   
            END IF 
       AFTER INPUT
          IF INT_FLAG THEN                            # 使用者不玩了
              EXIT INPUT
          END IF
          LET l_zv03 = ''
          IF g_zv_prt.a1  = 'Y' THEN  LET l_zv03 = '1' END IF
          IF g_zv_prt.a2  = 'Y' THEN  LET l_zv03 = '2' END IF
          IF g_zv_prt.a3  = 'Y' THEN  LET l_zv03 = '3' END IF
          IF g_zv_prt.a4  = 'Y' THEN  LET l_zv03 = '4' END IF
          IF g_zv_prt.a5  = 'Y' THEN  LET l_zv03 = '5' END IF
          IF g_zv_prt.a6  = 'Y' THEN  LET l_zv03 = '6' END IF
          IF g_zv_prt.a7  = 'Y' THEN  LET l_zv03 = '7' END IF
          IF g_zv_prt.a8  = 'Y' THEN  LET l_zv03 = '8' END IF 
          IF g_zv_prt.a9  = 'Y' THEN  LET l_zv03 = '9' END IF           
          IF g_zv_prt.l  = 'Y' THEN  LET l_zv03 = 'L' END IF  
          IF g_zv_prt.t  = 'Y' THEN  LET l_zv03 = 'T' END IF  
          IF g_zv_prt.d  = 'Y' THEN  LET l_zv03 = 'D' END IF #WORD 
          IF g_zv_prt.x  = 'Y' THEN  LET l_zv03 = 'X' END IF #XLS 
          IF g_zv_prt.oh = 'Y' THEN  LET l_zv03 = 'I' END IF #HTML 
          IF g_zv_prt.w  = 'Y' THEN  LET l_zv03 = 'W' END IF #DataSystem CallViewer
          IF g_zv_prt.m  = 'Y' THEN  LET l_zv03 = 'M' END IF #DT(Merge) 
          IF g_zv_prt.s  = 'Y' THEN  LET l_zv03 = 'S' END IF #DT(Pages) 
          IF g_zv_prt.p  = 'Y' THEN  LET l_zv03 = 'P' END IF   #PDF
          IF g_zv_prt.v  = 'Y' THEN  LET l_zv03 = 'V' END IF  #View
          IF g_zv_prt.n  = 'Y' THEN  LET l_zv03 = 'N' END IF  #VPrint
          IF g_zv_prt.c  = 'Y' THEN  LET l_zv03 = 'C' END IF  #Continuous View 
          IF g_zv_prt.j  = 'Y' THEN  LET l_zv03 = 'J' END IF  #JAVAMAIL
          IF g_zv_prt.h  = 'Y' THEN  LET l_zv03 = 'H' END IF  #CK History
          IF g_zv_prt.f  = 'Y' THEN  LET l_zv03 = 'F' END IF  #XLS_P 
          IF g_zv_prt.b  = 'Y' THEN  LET l_zv03 = 'B' END IF  #XLSX
          IF g_zv_prt.e  = 'Y' THEN  LET l_zv03 = 'E' END IF  #XLSX_P         
          LET g_zv[l_ac].zv03 = l_zv03 CLIPPED
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON IDLE g_idle_seconds  
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT       
   LET INT_FLAG = 0 
   CLOSE WINDOW p_zv_prt_w
END FUNCTION

FUNCTION p_zv_gr_allsetN(p_col)
  DEFINE p_col       LIKE type_file.chr2


   LET g_zv_prt.a1  = 'N'
   LET g_zv_prt.a2  = 'N'
   LET g_zv_prt.a3  = 'N'
   LET g_zv_prt.a4  = 'N'
   LET g_zv_prt.a5  = 'N'
   LET g_zv_prt.a6  = 'N'
   LET g_zv_prt.a7  = 'N'
   LET g_zv_prt.a8  = 'N' 
   LET g_zv_prt.a9  = 'N'   
   LET g_zv_prt.l  = 'N'
   LET g_zv_prt.t  = 'N'
   LET g_zv_prt.d  = 'N'
   LET g_zv_prt.x  = 'N'
   LET g_zv_prt.oh = 'N'
   LET g_zv_prt.w  = 'N'                     
   LET g_zv_prt.m  = 'N'
   LET g_zv_prt.s  = 'N'
   LET g_zv_prt.p  = 'N'
   LET g_zv_prt.v  = 'N'
   LET g_zv_prt.n  = 'N'    
   LET g_zv_prt.c  = 'N'
   LET g_zv_prt.j  = 'N'
   LET g_zv_prt.h  = 'N'
   LET g_zv_prt.f  = 'N'
   LET g_zv_prt.b  = 'N'
   LET g_zv_prt.e  = 'N'   
    CASE p_col
      WHEN "a1"  LET g_zv_prt.a1  = 'Y'
      WHEN "a2"  LET g_zv_prt.a2  = 'Y'
      WHEN "a3"  LET g_zv_prt.a3  = 'Y'
      WHEN "a4"   LET g_zv_prt.a4  = 'Y'
      WHEN "a5"   LET g_zv_prt.a5  = 'Y'
      WHEN "a6"   LET g_zv_prt.a6  = 'Y'
      WHEN "a7"   LET g_zv_prt.a7  = 'Y'
      WHEN "a8"   LET g_zv_prt.a8  = 'Y'
      WHEN "a9"   LET g_zv_prt.a9  = 'Y'
      WHEN "l"   LET g_zv_prt.l  = 'Y' 
      WHEN "t"   LET g_zv_prt.t  = 'Y'
      WHEN "d"   LET g_zv_prt.d  = 'Y' 
      WHEN "x"   LET g_zv_prt.x  = 'Y'
      WHEN "oh"   LET g_zv_prt.oh  = 'Y' 
      WHEN "w"   LET g_zv_prt.w  = 'Y' 
      WHEN "m"   LET g_zv_prt.m  = 'Y' 
      WHEN "s"   LET g_zv_prt.s  = 'Y' 
      WHEN "p"   LET g_zv_prt.p  = 'Y' 
      WHEN "v"   LET g_zv_prt.v  = 'Y' 
      WHEN "n"   LET g_zv_prt.n  = 'Y' 
      WHEN "c"   LET g_zv_prt.c  = 'Y' 
      WHEN "j"   LET g_zv_prt.j  = 'Y' 
      WHEN "h"   LET g_zv_prt.h  = 'Y' 
      WHEN "f"   LET g_zv_prt.f  = 'Y' 
      WHEN "b"   LET g_zv_prt.b  = 'Y' 
      WHEN "e"   LET g_zv_prt.e  = 'Y' 
             
      OTHERWISE EXIT CASE 
    END CASE

  
END FUNCTION  


FUNCTION p_zv_cr()
    DEFINE  l_zv03   LIKE zv_file.zv03
    MESSAGE " "


   LET g_zv_cr.a1  = 'N'
   #FUN-D10135 mark-(s) 
   #LET g_zv_cr.a2  = 'N'
   #LET g_zv_cr.a3  = 'N'
   #LET g_zv_cr.a4  = 'N'
   #LET g_zv_cr.a5  = 'N'
   #LET g_zv_cr.a6  = 'N'
   #LET g_zv_cr.a7  = 'N'
   #LET g_zv_cr.a8  = 'N' 
   #LET g_zv_cr.a9  = 'N'  
   #FUN-D10135 mark-(e) 
   LET g_zv_cr.l  = 'N' 
   LET g_zv_cr.d = 'N'
   LET g_zv_cr.e = 'N'
   LET g_zv_cr.p = 'N'
   LET g_zv_cr.r = 'N'
   LET g_zv_cr.x = 'N'
   LET g_zv_cr.a = 'N' 
   LET g_zv_cr.n = 'N' 
   
   
   CASE g_zv[l_ac].zv03
     WHEN '1' LET  g_zv_cr.a1  = 'Y' 
     #FUN-D10135 mark-(s)
     #WHEN '2' LET  g_zv_cr.a2  = 'Y' 
     #WHEN '3' LET  g_zv_cr.a3  = 'Y' 
     #WHEN '4' LET  g_zv_cr.a4  = 'Y'      
     #WHEN '5' LET  g_zv_cr.a5  = 'Y' 
     #WHEN '6' LET  g_zv_cr.a6  = 'Y' 
     #WHEN '7' LET  g_zv_cr.a7  = 'Y' 
     #WHEN '8' LET  g_zv_cr.a8  = 'Y' 
     #WHEN '9' LET  g_zv_cr.a9  = 'Y' 
     #FUN-D10135 mark-(e)
     WHEN 'L' LET  g_zv_cr.l  = 'Y'      
     WHEN 'D' LET  g_zv_cr.d  = 'Y'      
     WHEN 'E' LET  g_zv_cr.e  = 'Y' 
     WHEN 'P' LET  g_zv_cr.p  = 'Y' 
     WHEN 'R' LET  g_zv_cr.r  = 'Y' 
     WHEN 'X' LET  g_zv_cr.x  = 'Y' 
     WHEN 'A' LET  g_zv_cr.a  = 'Y' 
     WHEN 'N' LET  g_zv_cr.n  = 'Y' 
      OTHERWISE EXIT CASE 
   END CASE 

    OPEN WINDOW p_zv_cr_w WITH FORM "azz/42f/p_zv_cr"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_ui_locale("p_zv_cr")
    
    CALL cl_set_comp_visible("a2,a3,a4,a5,a6,a7,a8,a9",FALSE)  #FUN-D10135 add
    
    DISPLAY BY NAME
        g_zv_cr.a1, #,g_zv_cr.a2,g_zv_cr.a3,g_zv_cr.a4,g_zv_cr.a5,  #FUN-D10135 mark
        #g_zv_cr.a6,g_zv_cr.a7,g_zv_cr.a8,g_zv_cr.a9,               #FUN-D10135 mark
        g_zv_cr.p, g_zv_cr.r, g_zv_cr.d, g_zv_cr.e, g_zv_cr.x, g_zv_cr.a      
        , g_zv_cr.n  ,g_zv_cr.l   #FUN-CC0127 add g_zv_cr.l
        
    INPUT BY NAME
        g_zv_cr.a1,#g_zv_cr.a2,g_zv_cr.a3,g_zv_cr.a4,g_zv_cr.a5, #FUN-D10135 mark
        #g_zv_cr.a6,g_zv_cr.a7,g_zv_cr.a8,g_zv_cr.a9,            #FUN-D10135 mark
        g_zv_cr.p, g_zv_cr.r, g_zv_cr.d, g_zv_cr.e, g_zv_cr.x, g_zv_cr.a      
        , g_zv_cr.n , g_zv_cr.l   #FUN-CC0127 add g_zv_cr.l
        WITHOUT DEFAULTS ATTRIBUTE (UNBUFFERED)

        ON CHANGE d
            IF GET_FLDBUF(d) = 'Y' THEN
               CALL p_zv_cr_allsetN("d")  
            END IF

        ON CHANGE e
            IF GET_FLDBUF(e) = 'Y' THEN
               CALL p_zv_cr_allsetN("e")   
            END IF

        ON CHANGE p
            IF GET_FLDBUF(p) = 'Y' THEN
               CALL p_zv_cr_allsetN("p")  
            END IF

        ON CHANGE r
            IF GET_FLDBUF(r) = 'Y' THEN               
               CALL p_zv_cr_allsetN("r")             
            END IF

        ON CHANGE x
            IF GET_FLDBUF(x) = 'Y' THEN
               CALL p_zv_cr_allsetN("x")  
            END IF

        ON CHANGE a
            IF GET_FLDBUF(a) = 'Y' THEN
                CALL p_zv_cr_allsetN("a") 
            END IF
            
        ON CHANGE n
            IF GET_FLDBUF(n) = 'Y' THEN
               CALL p_zv_cr_allsetN("n")  
            END IF
        ON CHANGE a1
            IF GET_FLDBUF(a1) = 'Y' THEN
                CALL p_zv_cr_allsetN("a1")  
            END IF
        ##FUN-D10135 mark -(S)
        #ON CHANGE a2
            #IF GET_FLDBUF(a2) = 'Y' THEN
                #CALL p_zv_cr_allsetN("a2")  
            #END IF   
        #ON CHANGE a3
            #IF GET_FLDBUF(a3) = 'Y' THEN
                #CALL p_zv_cr_allsetN("a3")                  
            #END IF 
        #ON CHANGE a4
           #IF GET_FLDBUF(a4) = 'Y' THEN
               #CALL p_zv_cr_allsetN("a4")  
           #END IF    
        #ON CHANGE a5
            #IF GET_FLDBUF(a5) = 'Y' THEN
                #CALL p_zv_cr_allsetN("a5")  
            #END IF
        #ON CHANGE a6
            #IF GET_FLDBUF(a6) = 'Y' THEN
                #CALL p_zv_cr_allsetN("a6")  
            #END IF   
        #ON CHANGE a7
            #IF GET_FLDBUF(a7) = 'Y' THEN
                #CALL p_zv_cr_allsetN("a7")                  
            #END IF 
        #ON CHANGE a8
           #IF GET_FLDBUF(a8) = 'Y' THEN
               #CALL p_zv_cr_allsetN("a8")  
           #END IF   
        #ON CHANGE a9
           #IF GET_FLDBUF(a9) = 'Y' THEN
               #CALL p_zv_cr_allsetN("a9")  
           #END IF 
        ##FUN-D10135 mark -(e)
        ON CHANGE l
           IF GET_FLDBUF(l) = 'Y' THEN
               CALL p_zv_cr_allsetN("l")  
           END IF                
        AFTER INPUT
            IF INT_FLAG THEN                            # 使用者不玩了
                EXIT INPUT
            END IF
            LET l_zv03 = ''
            IF g_zv_cr.a1  = 'Y' THEN  LET l_zv03 = '1' END IF 
            ##FUN-D10135 mark -(s)
            #IF g_zv_cr.a2  = 'Y' THEN  LET l_zv03 = '2' END IF 
            #IF g_zv_cr.a3  = 'Y' THEN  LET l_zv03 = '3' END IF 
            #IF g_zv_cr.a4  = 'Y' THEN  LET l_zv03 = '4' END IF 
            #IF g_zv_cr.a5  = 'Y' THEN  LET l_zv03 = '5' END IF 
            #IF g_zv_cr.a6  = 'Y' THEN  LET l_zv03 = '6' END IF 
            #IF g_zv_cr.a7  = 'Y' THEN  LET l_zv03 = '7' END IF 
            #IF g_zv_cr.a8  = 'Y' THEN  LET l_zv03 = '8' END IF 
            #IF g_zv_cr.a9  = 'Y' THEN  LET l_zv03 = '9' END IF  
            ##FUN-D10135 mark -(e)
            IF g_zv_cr.l  = 'Y' THEN  LET l_zv03 = 'L' END IF   
            IF g_zv_cr.d  = 'Y' THEN  LET l_zv03 = 'D' END IF 
            IF g_zv_cr.e  = 'Y' THEN  LET l_zv03 = 'E' END IF 
            IF g_zv_cr.p  = 'Y' THEN  LET l_zv03 = 'P' END IF 
            IF g_zv_cr.r  = 'Y' THEN  LET l_zv03 = 'R' END IF 
            IF g_zv_cr.x  = 'Y' THEN  LET l_zv03 = 'X' END IF 
            IF g_zv_cr.a  = 'Y' THEN  LET l_zv03 = 'A' END IF 
            IF g_zv_cr.n  = 'Y' THEN  LET l_zv03 = 'N' END IF 
            LET g_zv[l_ac].zv03 = l_zv03 CLIPPED
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION controlg      
          CALL cl_cmdask()     
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON IDLE g_idle_seconds  
           CALL cl_on_idle()
           CONTINUE INPUT
 
    END INPUT  
    LET INT_FLAG = 0 
    CLOSE WINDOW p_zv_cr_w
END FUNCTION


FUNCTION p_zv_cr_allsetN(p_col)
  DEFINE p_col       LIKE type_file.chr2


  LET g_zv_cr.a1  = 'N'
  ##FUN-D10135 add -(s)
  #LET g_zv_cr.a2  = 'N'
  #LET g_zv_cr.a3  = 'N'
  #LET g_zv_cr.a4  = 'N'
  #LET g_zv_cr.a5  = 'N'
  #LET g_zv_cr.a6  = 'N'
  #LET g_zv_cr.a7  = 'N'
  #LET g_zv_cr.a8  = 'N' 
  #LET g_zv_cr.a9  = 'N'  
  ##FUN-D10135 add -(e)
  LET g_zv_cr.l  = 'N' 
  LET g_zv_cr.d = 'N'
  LET g_zv_cr.e = 'N'
  LET g_zv_cr.p = 'N'
  LET g_zv_cr.r = 'N'
  LET g_zv_cr.x = 'N'
  LET g_zv_cr.a = 'N'
  LET g_zv_cr.n = 'N'
  
    CASE p_col
      WHEN "a1"  LET g_zv_cr.a1  = 'Y'
      ##FUN-D10135 add -(s)
      #WHEN "a2"  LET g_zv_cr.a2  = 'Y'
      #WHEN "a3"  LET g_zv_cr.a3  = 'Y'
      #WHEN "a4"   LET g_zv_cr.a4  = 'Y'
      #WHEN "a5"   LET g_zv_cr.a5  = 'Y'
      #WHEN "a6"   LET g_zv_cr.a6  = 'Y'
      #WHEN "a7"   LET g_zv_cr.a7  = 'Y'
      #WHEN "a8"   LET g_zv_cr.a8  = 'Y'
      #WHEN "a9"   LET g_zv_cr.a9  = 'Y'
       ##FUN-D10135 add -(e)
      WHEN "l"   LET g_zv_cr.l  = 'Y' 
      WHEN "d"   LET g_zv_cr.d  = 'Y' 
      WHEN "e"   LET g_zv_cr.e  = 'Y' 
      WHEN "p"   LET g_zv_cr.p  = 'Y' 
      WHEN "r"   LET g_zv_cr.r  = 'Y' 
      WHEN "x"   LET g_zv_cr.x  = 'Y' 
      WHEN "a"   LET g_zv_cr.a  = 'Y' 
      WHEN "n"   LET g_zv_cr.n  = 'Y'        
      OTHERWISE EXIT CASE 
    END CASE

  
END FUNCTION  


FUNCTION p_zv_zv03str(zv01,zv03)
  DEFINE zv01         LIKE zv_file.zv01
  DEFINE zv03         LIKE zv_file.zv03
  DEFINE l_zv03_str   STRING 
  DEFINE l_cnt        LIKE type_file.num10

  IF NOT p_zv_chkgr(zv01) THEN          ##檢查程式是否為GR
      IF NOT p_zv_chkcr(zv01) THEN               ##檢查程式是否為CR
           SELECT COUNT(*) INTO l_cnt FROM zaa_file 
               WHERE zaa01 = zv01 AND zaa04 = g_zv02
               AND zaa17 = g_zv05 AND zaa10 ='Y'
           LET g_call_cr="N" 
       ELSE
           LET g_call_cr="Y" 
       END IF  
  ELSE 
       LET g_call_cr="G" 
  END IF 


  
  IF zv03 MATCHES "[123456789L]" THEN 
        IF g_call_cr <> "Y" AND g_call_cr <>"G"  THEN #FUN-D10135 add
         IF zv03 = '1' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"1"  END IF
         IF zv03 = '2' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"2"  END IF
         IF zv03 = '3' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"3"  END IF
         IF zv03 = '4' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"4"  END IF
         IF zv03 = '5' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"5"  END IF
         IF zv03 = '6' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"6"  END IF
         IF zv03 = '7' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"7"  END IF
         IF zv03 = '8' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"8"  END IF 
         IF zv03 = '9' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang),"9"  END IF
        #FUN-D10135 add-(s)
        ELSE  #CR與GR只會顯示一個系統印表機，故不需要後面序號
         IF zv03 = '1' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '2' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '3' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '4' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '5' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '6' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '7' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF
         IF zv03 = '8' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF 
         IF zv03 = '9' THEN LET l_zv03_str= cl_getmsg('azz1247',g_lang)  END IF  
         LET l_zv03_str=cl_replace_str(l_zv03_str,"-","")
        END IF 
        #FUN-D10135 add-(e)
         IF zv03 = 'L' THEN LET l_zv03_str= cl_getmsg('azz1248',g_lang) END IF 
  ELSE 
      IF g_call_cr='Y' THEN #CR
         IF zv03 = 'D' THEN LET l_zv03_str= cl_getmsg('azz1242',g_lang) END IF #Word
         IF zv03 = 'E' THEN LET l_zv03_str= cl_getmsg('azz1260',g_lang) END IF #XLS(P)
         IF zv03 = 'P' THEN LET l_zv03_str= cl_getmsg('azz1237',g_lang) END IF #PDF
         IF zv03 = 'R' THEN LET l_zv03_str= cl_getmsg('azz1259',g_lang) END IF #CR
         IF zv03 = 'X' THEN LET l_zv03_str= cl_getmsg('azz1238',g_lang) END IF #XLS
         IF zv03 = 'A' THEN LET l_zv03_str= cl_getmsg('azz1261',g_lang) END IF #XLS(Data only)  
         IF zv03 = 'N' THEN LET l_zv03_str= cl_getmsg('azz1258',g_lang) END IF #None  
      ELSE #GR' zaa
         IF zv03  = 'G' THEN LET l_zv03_str = cl_getmsg('azz1249',g_lang) END IF  
         IF zv03  = 'T' THEN LET l_zv03_str = cl_getmsg('azz1250',g_lang) END IF #text file 
         IF zv03  = 'D' THEN LET l_zv03_str = cl_getmsg('azz1242',g_lang) END IF #WORD 
         IF zv03  = 'X' THEN LET l_zv03_str = cl_getmsg('azz1238',g_lang) END IF #XLS 
         IF zv03  = 'I' THEN LET l_zv03_str = cl_getmsg('azz1243',g_lang) END IF #HTML 
         IF zv03  = 'W' THEN LET l_zv03_str = cl_getmsg('azz1251',g_lang) END IF #DataSystem CallViewer
         IF zv03  = 'M' THEN LET l_zv03_str = cl_getmsg('azz1252',g_lang) END IF #DT(Merge) 
         IF zv03  = 'S' THEN LET l_zv03_str = cl_getmsg('azz1253',g_lang) END IF #DT(Pages) 
         IF zv03  = 'P' THEN LET l_zv03_str = cl_getmsg('azz1237',g_lang) END IF   #PDF
         IF zv03  = 'V' THEN LET l_zv03_str = cl_getmsg('azz1254',g_lang) END IF  #View
         IF zv03  = 'N' THEN LET l_zv03_str = cl_getmsg('azz1255',g_lang) END IF  #VPrint
         IF zv03  = 'C' THEN LET l_zv03_str = cl_getmsg('azz1256',g_lang) END IF  #Continuous View 
         IF zv03  = 'J' THEN LET l_zv03_str = cl_getmsg('azz1244',g_lang) END IF  #JAVAMAIL
         IF zv03  = 'H' THEN LET l_zv03_str = cl_getmsg('azz1257',g_lang) END IF  #CK History
         IF zv03  = 'F' THEN LET l_zv03_str = cl_getmsg('azz1239',g_lang) END IF  #XLS_P 
         IF zv03  = 'B' THEN LET l_zv03_str = cl_getmsg('azz1240',g_lang) END IF  #XLSX
         IF zv03  = 'E' THEN LET l_zv03_str = cl_getmsg('azz1241',g_lang) END IF  #XLSX_P         
      END IF
  END IF 
  RETURN l_zv03_str  
END FUNCTION 

#FUN-C70120--add---end-------------------

#FUN-D10135 add -(s)
FUNCTION p_zv_gr()
DEFINE  p_cmd    LIKE type_file.chr1    
DEFINE  l_zv03   LIKE zv_file.zv03

 
   MESSAGE " "
   
   LET g_zv_prt.a1  = 'N'
   LET g_zv_prt.l  = 'N'
   LET g_zv_prt.d  = 'N'
   LET g_zv_prt.x  = 'N'
   LET g_zv_prt.oh = 'N'
   LET g_zv_prt.p  = 'N'
   LET g_zv_prt.f  = 'N'
   LET g_zv_prt.b  = 'N'
   LET g_zv_prt.e  = 'N'   

   
   #IF p_cmd <>"a" AND l_ac>0 THEN   #FUN-D10135 mark
   IF (p_cmd<>"a" AND l_ac>0) OR (NOT cl_null(g_zv[l_ac].zv03)) THEN   #FUN-D10135 add     
         CASE g_zv[l_ac].zv03
             WHEN '1' LET  g_zv_prt.a1  = 'Y' 
             WHEN 'L' LET  g_zv_prt.l  = 'Y' 
             WHEN 'D' LET  g_zv_prt.d  = 'Y'  
             WHEN 'X' LET  g_zv_prt.x  = 'Y'
             WHEN 'I' LET  g_zv_prt.oh  = 'Y'  
             WHEN 'P' LET  g_zv_prt.p  = 'Y' 
             WHEN 'F' LET  g_zv_prt.f  = 'Y'
             WHEN 'B' LET  g_zv_prt.b  = 'Y' 
             WHEN 'E' LET  g_zv_prt.e  = 'Y' 
         OTHERWISE EXIT CASE 
       END CASE 
       
   END IF 

   OPEN WINDOW p_zv_gr_w WITH FORM "azz/42f/p_zv_gr"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zv_gr")


   DISPLAY BY NAME 
       g_zv_prt.a1,g_zv_prt.l, g_zv_prt.d, g_zv_prt.x,
       g_zv_prt.f,  g_zv_prt.b, g_zv_prt.e,
       g_zv_prt.oh, g_zv_prt.p 
      
       
   
   INPUT BY NAME  
       g_zv_prt.a1, g_zv_prt.l,  g_zv_prt.d, g_zv_prt.x,
       g_zv_prt.f,  g_zv_prt.b, g_zv_prt.e,
       g_zv_prt.oh,  g_zv_prt.p
       
       
       WITHOUT DEFAULTS ATTRIBUTE (UNBUFFERED)

       ON CHANGE a1
            IF GET_FLDBUF(a1) = 'Y' THEN
               CALL p_zv_gr_allsetN("a1")   
            END IF

       ON CHANGE l
            IF GET_FLDBUF(l) = 'Y' THEN
               CALL p_zv_gr_allsetN("l")   
            END IF

       ON CHANGE d
            IF GET_FLDBUF(d) = 'Y' THEN
               CALL p_zv_gr_allsetN("d")   
            END IF
       ON CHANGE x
            IF GET_FLDBUF(x) = 'Y' THEN
               CALL p_zv_gr_allsetN("x")   
            END IF            
       ON CHANGE oh
            IF GET_FLDBUF(oh) = 'Y' THEN
               CALL p_zv_gr_allsetN("oh")   
            END IF

       ON CHANGE p
            IF GET_FLDBUF(p) = 'Y' THEN
               CALL p_zv_gr_allsetN("p")   
            END IF  

       ON CHANGE f
            IF GET_FLDBUF(f) = 'Y' THEN
               CALL p_zv_gr_allsetN("f")   
            END IF
       ON CHANGE b
            IF GET_FLDBUF(b) = 'Y' THEN
               CALL p_zv_gr_allsetN("b")   
            END IF 
       ON CHANGE e
            IF GET_FLDBUF(e) = 'Y' THEN
               CALL p_zv_gr_allsetN("e")   
            END IF 
       AFTER INPUT
          IF INT_FLAG THEN                            # 使用者不玩了
              EXIT INPUT
          END IF
          LET l_zv03 = ''
          IF g_zv_prt.a1  = 'Y' THEN  LET l_zv03 = '1' END IF       
          IF g_zv_prt.l  = 'Y' THEN  LET l_zv03 = 'L' END IF  
          IF g_zv_prt.d  = 'Y' THEN  LET l_zv03 = 'D' END IF #WORD 
          IF g_zv_prt.x  = 'Y' THEN  LET l_zv03 = 'X' END IF #XLS 
          IF g_zv_prt.oh = 'Y' THEN  LET l_zv03 = 'I' END IF #HTML 
          IF g_zv_prt.p  = 'Y' THEN  LET l_zv03 = 'P' END IF   #PDF
          IF g_zv_prt.f  = 'Y' THEN  LET l_zv03 = 'F' END IF  #XLS_P 
          IF g_zv_prt.b  = 'Y' THEN  LET l_zv03 = 'B' END IF  #XLSX
          IF g_zv_prt.e  = 'Y' THEN  LET l_zv03 = 'E' END IF  #XLSX_P         
          LET g_zv[l_ac].zv03 = l_zv03 CLIPPED
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON IDLE g_idle_seconds  
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT       
   LET INT_FLAG = 0 
   CLOSE WINDOW p_zv_gr_w
END FUNCTION
#FUN-D10135 add -(e)
