# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: anmt703.4gl
# Descriptions...: 資產抵押融資貨款維護作業
# Date & Author..: 00/07/27 By Mandy
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-650077 06/05/17 By Smapmin 資料顯示有誤
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"`
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780080 07/08/30 By Smapmin 由其他程式串接過來時,單身無法輸入
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
#    g_argv1         VARCHAR(10),             #相關單號
    g_argv1         LIKE nnt_file.nnt01,   #No.FUN-680107 VARCHAR(16)             #No.FUN-550057
    g_nnt01         LIKE nnt_file.nnt01,   #假單頭
    g_nnt01_t       LIKE nnt_file.nnt01,   #假單頭
    g_nnt           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                        nnt02   LIKE nnt_file.nnt02,  
                        nnt03   LIKE nnt_file.nnt03,  
                        nnt04   LIKE nnt_file.nnt04,  
                        nnt05   LIKE nnt_file.nnt05,  
                        nnt06   LIKE nnt_file.nnt06,  
                        nnt07   LIKE nnt_file.nnt07,  
                        nnt08   LIKE nnt_file.nnt08,  
                        nnt09   LIKE nnt_file.nnt09,  
                        nnt10   LIKE nnt_file.nnt10   
                    END RECORD,
    g_nnt_t         RECORD                 #程式變數 (舊值)
                        nnt02   LIKE nnt_file.nnt02,  
                        nnt03   LIKE nnt_file.nnt03,  
                        nnt04   LIKE nnt_file.nnt04,  
                        nnt05   LIKE nnt_file.nnt05,  
                        nnt06   LIKE nnt_file.nnt06,  
                        nnt07   LIKE nnt_file.nnt07,  
                        nnt08   LIKE nnt_file.nnt08,  
                        nnt09   LIKE nnt_file.nnt09,  
                        nnt10   LIKE nnt_file.nnt10   
                    END RECORD,
    g_wc2,g_sql         STRING,  #No.FUN-580092 HCN   
    g_wc                STRING,  #No.FUN-580092 HCN    
    g_rec_b             LIKE type_file.num5,                #單身筆數        #No.FUN-680107 SMALLINT
    l_ac                LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680107 SMALLINT
    g_ss                LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(01)
    l_flag              LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
DEFINE g_forupd_sql     STRING         #SELECT ... FOR UPDATE SQL     
DEFINE   g_cnt          LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   g_i            LIKE type_file.num5           #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03             #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5           #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   OPTIONS
      PROMPT  LINE  LAST,
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET g_argv1 = ARG_VAL(1)               #傳遞的參數:相關單號
   LET g_nnt01 = g_argv1 
 
   INITIALIZE g_nnt_t.* TO NULL
 
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW t703_w AT p_row,p_col
     WITH FORM "anm/42f/anmt703"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
#   CALL t703_q()
IF NOT cl_null(g_argv1) THEN CALL t703_q() END IF
   CALL t703_menu()
   CLOSE WINDOW t703_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
#QBE 查詢資料
FUNCTION t703_cs()
 
    IF NOT cl_null(g_argv1) THEN
       DISPLAY g_argv1 TO nnt01
       LET g_wc =" nnt01= '",g_argv1,"' "
       LET g_sql=" SELECT nnt01",
                 " FROM nnt_file ",
                 " WHERE ",g_wc CLIPPED
    ELSE
       CLEAR FORM                             #清除畫面
       CALL g_nnt.clear()
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nnt01 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON nnt01,nnt02,nnt03,nnt04,nnt05,nnt06,nnt07,
                         nnt08,nnt09,nnt10
           FROM nnt01,s_nnt[1].nnt02,s_nnt[1].nnt03,s_nnt[1].nnt04,
                      s_nnt[1].nnt05,s_nnt[1].nnt06,s_nnt[1].nnt07,
                      s_nnt[1].nnt08,s_nnt[1].nnt09,s_nnt[1].nnt10
                       
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON ACTION controlp
             CASE 
                WHEN INFIELD (nnt03)
#                  CALL q_faj(06,05,g_nnt[1].nnt03,g_nnt[1].nnt04)
#                      RETURNING g_nnt[1].nnt03,g_nnt[1].nnt04
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO nnt03
                   NEXT FIELD nnt03
                WHEN INFIELD (nnt04)
#                  CALL q_faj(06,11,g_nnt[1].nnt03,g_nnt[1].nnt04) 
#                      RETURNING g_nnt[1].nnt03,g_nnt[1].nnt04
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.multiret_index = 2
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO nnt04
                   NEXT FIELD nnt04
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
 
       LET g_sql= "SELECT  UNIQUE nnt01 FROM nnt_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
    END IF
    PREPARE t703_prepare FROM g_sql      #預備一下
    DECLARE t703_b_cs 
        SCROLL CURSOR WITH HOLD FOR t703_prepare
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
  
    LET g_sql="SELECT DISTINCT nnt01",
              " FROM nnt_file WHERE ", g_wc CLIPPED," INTO TEMP x"
    PREPARE t703_precount_x  FROM g_sql
    EXECUTE t703_precount_x 
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t703_precount FROM g_sql
    DECLARE t703_count CURSOR FOR  t703_precount
END FUNCTION
 
FUNCTION t703_menu()
 
   WHILE TRUE
      CALL t703_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t703_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t703_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth()
               THEN CALL t703_out()
            END IF 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnt),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nnt01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnt01"
                 LET g_doc.value1 = g_nnt01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
   
FUNCTION t703_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680107 VARCHAR(1)
   l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
   l_str           LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(40)
 
   LET g_ss='Y'
   DISPLAY  g_nnt01 TO nnt01 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_nnt01 WITHOUT DEFAULTS 
 
      AFTER FIELD nnt01
         IF NOT cl_null(g_nnt01) THEN        
            IF g_nnt01 != g_nnt01_t OR g_nnt01_t IS NULL THEN
               SELECT UNIQUE nnt01 FROM nnt_file
                WHERE nnt01 =g_nnt01
               IF SQLCA.sqlcode THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_nnt01,-239,0)
                     LET g_nnt01=g_nnt01_t
                     NEXT FIELD nnt01
                  END IF
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
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
FUNCTION t703_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CLEAR FORM
   CALL g_nnt.clear()
   CALL t703_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_nnt01 TO NULL
      CALL g_nnt.clear()
      RETURN
   END IF
   OPEN t703_b_cs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                     #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nnt01 TO NULL
   ELSE
      CALL t703_fetch('F')                   #讀出TEMP第一筆並顯示
      OPEN t703_count
      FETCH t703_count INTO g_row_count
      DISPLAY g_row_count to FORMONLY.cnt
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t703_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t703_b_cs INTO g_nnt01
      WHEN 'P' FETCH PREVIOUS t703_b_cs INTO g_nnt01
      WHEN 'F' FETCH FIRST    t703_b_cs INTO g_nnt01
      WHEN 'L' FETCH LAST     t703_b_cs INTO g_nnt01
      WHEN '/' 
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t703_b_cs INTO g_nnt01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nnt01,SQLCA.sqlcode,0)
      #INITIALIZE g_nnt01 TO NULL               #No.FUN-6A0011   #FUN-780080
      RETURN
   ELSE
      OPEN t703_count
      FETCH t703_count INTO g_row_count
      CALL t703_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
   
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t703_show()
   #DISPLAY g_row_count TO nnt01               #單頭   #MOD-650077
   DISPLAY g_nnt01 TO nnt01               #單頭   #MOD-650077
   CALL t703_b_fill(' 1=1')                        #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t703_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680107 VARCHAR(1)
   l_nnt03         LIKE nnt_file.nnt03,                #財產編號 
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_nnt01 IS NULL THEN RETURN END IF 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nnt02,nnt03,nnt04,nnt05,nnt06,nnt07,nnt08,",
                      "       nnt09,nnt10 FROM nnt_file",
                      " WHERE nnt02 = ? AND nnt01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t703_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nnt WITHOUT DEFAULTS FROM s_nnt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
           
       BEFORE INPUT
        IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)
        END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
#          DISPLAY l_ac TO FORMONLY.cn3  #MOD-960067
         #LET g_nnt_t.* = g_nnt[l_ac].*  #BACKUP
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
#         IF g_nnt[l_ac].nnt02 IS NOT NULL THEN
             LET p_cmd='u'
             LET g_nnt_t.* = g_nnt[l_ac].*  #BACKUP
             BEGIN WORK
             OPEN t703_bcl USING g_nnt_t.nnt02,g_nnt01
             IF STATUS THEN
                CALL cl_err("OPEN t703_bcl:", STATUS, 1)
                LET l_lock_sw = 'Y'
             END IF
             FETCH t703_bcl INTO g_nnt[l_ac].* 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_nnt_t.nnt02,SQLCA.sqlcode,1)
                LET l_lock_sw = 'Y'
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
         #NEXT FIELD nnt02
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_nnt[l_ac].* TO NULL      #900423
          LET g_nnt_t.* = g_nnt[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD nnt02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
            #CALL g_nnt.deleteElement(l_ac)   #取消 Array Element
            #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
            #   LET g_action_choice = "detail"
            #   LET l_ac = l_ac_t
            #END IF
            #EXIT INPUT
          END IF
          INSERT INTO nnt_file(nnt01,nnt02,nnt03,nnt04,nnt05,
                               nnt06,nnt07,nnt08,nnt09,nnt10,
                               nntlegal)  #FUN-980005 add legal  
          VALUES(g_nnt01,g_nnt[l_ac].nnt02,g_nnt[l_ac].nnt03,
                 g_nnt[l_ac].nnt04,g_nnt[l_ac].nnt05,
                 g_nnt[l_ac].nnt06,g_nnt[l_ac].nnt07,
                 g_nnt[l_ac].nnt08,g_nnt[l_ac].nnt09,g_nnt[l_ac].nnt10,
                 g_legal)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_nnt[l_ac].nnt02,SQLCA.sqlcode,0)   #No.FUN-660148
             CALL cl_err3("ins","nnt_file",g_nnt01,g_nnt[l_ac].nnt02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            #LET g_nnt[l_ac].* = g_nnt_t.*
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       BEFORE FIELD nnt02                         #check 編號是否重複
          IF cl_null(g_nnt[l_ac].nnt02) OR g_nnt[l_ac].nnt02 = 0 THEN
             SELECT max(nnt02)+1 INTO g_nnt[l_ac].nnt02 FROM nnt_file
              WHERE nnt01 = g_nnt01
             IF g_nnt[l_ac].nnt02 IS NULL THEN
                LET g_nnt[l_ac].nnt02 = 1
             END IF
          END IF
 
       AFTER FIELD nnt02               #check 編號是否重複
          IF NOT cl_null(g_nnt[l_ac].nnt02) THEN
             IF g_nnt[l_ac].nnt02 != g_nnt_t.nnt02 OR cl_null(g_nnt_t.nnt02) THEN
                SELECT count(*) INTO l_n FROM nnt_file
                 WHERE nnt02 = g_nnt[l_ac].nnt02
                   AND nnt01 = g_nnt01 
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_nnt[l_ac].nnt02 = g_nnt_t.nnt02
                   NEXT FIELD nnt02
                END IF
             END IF
          END IF
 
       AFTER FIELD nnt03
          IF NOT cl_null(g_nnt[l_ac].nnt03) THEN 
             SELECT COUNT(*) INTO g_cnt
               FROM faj_file
              WHERE faj02  = g_nnt[l_ac].nnt03
             IF g_cnt = 0 THEN
                CALL cl_err('select faj',STATUS,1)
                NEXT FIELD nnt03
             END IF
          END IF
 
       AFTER FIELD nnt04
          #IF NOT cl_null(g_nnt[l_ac].nnt04) THEN  #MOD-550097
              IF cl_null(g_nnt[l_ac].nnt04) THEN  #MOD-550097
                 LET  g_nnt[l_ac].nnt04=' '       #MOD-550097
              END IF                              #MOD-550097
             SELECT faj06,faj18,(faj17-faj171),faj33,(faj14+faj141)
               INTO g_nnt[l_ac].nnt05,g_nnt[l_ac].nnt06,
                    g_nnt[l_ac].nnt07,g_nnt[l_ac].nnt08,
                    g_nnt[l_ac].nnt09 FROM faj_file
              WHERE faj02  = g_nnt[l_ac].nnt03 
                AND faj022 = g_nnt[l_ac].nnt04 
             IF STATUS THEN
#               CALL cl_err('select faj',STATUS,1)   #No.FUN-660148
                CALL cl_err3("sel","faj_file",g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04,STATUS,"","select faj",1)  #No.FUN-660148
                NEXT FIELD nnt04
             END IF
          #END IF                                 #MOD-550097
 
       AFTER FIELD nnt07
          IF NOT cl_null(g_nnt[l_ac].nnt07) THEN
             IF g_nnt[l_ac].nnt07 = 0 THEN 
                NEXT FIELD nnt07
             END IF
          END IF
 
       AFTER FIELD nnt08
          IF NOT cl_null(g_nnt[l_ac].nnt08) THEN
             IF g_nnt[l_ac].nnt08 = 0 THEN 
                NEXT FIELD nnt08
             END IF
          END IF
 
       AFTER FIELD nnt09
          IF NOT cl_null(g_nnt[l_ac].nnt09) THEN
             IF g_nnt[l_ac].nnt09 = 0 THEN 
                NEXT FIELD nnt09
             END IF
          END IF
 
       AFTER FIELD nnt10
          IF NOT cl_null(g_nnt[l_ac].nnt10) THEN
             IF g_nnt[l_ac].nnt10 = 0 THEN 
                NEXT FIELD nnt10
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_nnt_t.nnt02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM nnt_file
              WHERE nnt02 = g_nnt_t.nnt02 AND nnt01 = g_nnt01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nnt_t.nnt02,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("del","nnt_file",g_nnt_t.nnt02,g_nnt01,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_nnt[l_ac].* = g_nnt_t.*
             CLOSE t703_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_nnt[l_ac].nnt02,-263,1)
             LET g_nnt[l_ac].* = g_nnt_t.*
          ELSE
             UPDATE nnt_file SET nnt01 = g_nnt01,
                                 nnt02 = g_nnt[l_ac].nnt02,
                                 nnt03 = g_nnt[l_ac].nnt03,
                                 nnt04 = g_nnt[l_ac].nnt04, 
                                 nnt05 = g_nnt[l_ac].nnt05,
                                 nnt06 = g_nnt[l_ac].nnt06,
                                 nnt07 = g_nnt[l_ac].nnt07,
                                 nnt08 = g_nnt[l_ac].nnt08,
                                 nnt09 = g_nnt[l_ac].nnt09,
                                 nnt10 = g_nnt[l_ac].nnt10
              WHERE nnt02 = g_nnt_t.nnt02 
                AND nnt01 = g_nnt01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nnt[l_ac].nnt02,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nnt_file",g_nnt_t.nnt02,g_nnt01,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nnt[l_ac].* = g_nnt_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
       #  LET l_ac_t = l_ac   #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nnt[l_ac].* = g_nnt_t.*
           #FUN-D30032--add--str--
             ELSE
                CALL g_nnt.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
           #FUN-D30032--add--end--
             END IF
             CLOSE t703_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30032 add
         #LET g_nnt_t.* = g_nnt[l_ac].*
          CLOSE t703_bcl
          COMMIT WORK
 
       ON ACTION controlp
          CASE 
             WHEN INFIELD (nnt03)
#               CALL q_faj(06,05,g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04)
#                   RETURNING g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04
#               CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt03 )
#               CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt04 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_faj"
                LET g_qryparam.default1 = g_nnt[l_ac].nnt03
                LET g_qryparam.default2 = g_nnt[l_ac].nnt04
                CALL cl_create_qry() RETURNING g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04
#                CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt03 )
#                CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt04 )
                 DISPLAY BY NAME g_nnt[l_ac].nnt03         #No.MOD-490344
                 DISPLAY BY NAME g_nnt[l_ac].nnt04         #No.MOD-490344
                NEXT FIELD nnt03
             WHEN INFIELD (nnt04)
#               CALL q_faj(06,11,g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04) 
#                   RETURNING g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04
#               CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt03 )
#               CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt04 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_faj"
                LET g_qryparam.default1 = g_nnt[l_ac].nnt03
                LET g_qryparam.default2 = g_nnt[l_ac].nnt04
                CALL cl_create_qry() RETURNING g_nnt[l_ac].nnt03,g_nnt[l_ac].nnt04
#                CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt03 )
#                CALL FGL_DIALOG_SETBUFFER( g_nnt[l_ac].nnt04 )
                 DISPLAY BY NAME g_nnt[l_ac].nnt03         #No.MOD-490344
                 DISPLAY BY NAME g_nnt[l_ac].nnt04         #No.MOD-490344
                SELECT faj06,faj18,(faj17-faj171),faj33,(faj14+faj141)
                  INTO g_nnt[l_ac].nnt05,g_nnt[l_ac].nnt06,
                       g_nnt[l_ac].nnt07,g_nnt[l_ac].nnt08,
                       g_nnt[l_ac].nnt09 FROM faj_file
                 WHERE faj022 = g_nnt[l_ac].nnt04
                   AND faj02  = g_nnt[l_ac].nnt03
                IF STATUS THEN
#                  CALL cl_err('select faj',STATUS,1)   #No.FUN-660148
                   CALL cl_err3("sel","faj_file",g_nnt[l_ac].nnt04,g_nnt[l_ac].nnt03,STATUS,"","select faj",1)  #No.FUN-660148
                   NEXT FIELD nnt04
                END IF
                NEXT FIELD nnt04
          END CASE
 
#      ON ACTION CONTROLN
#          CALL t703_b_askkey()
#          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(nnt01) AND l_ac > 1 THEN
             LET g_nnt[l_ac].* = g_nnt[l_ac-1].*
             NEXT FIELD nnt01
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
   
   END INPUT
   CLOSE t703_bcl
   COMMIT WORK
       
END FUNCTION
 
FUNCTION t703_b_askkey()
   CLEAR FORM
   CALL g_nnt.clear()
   CONSTRUCT g_wc2 ON nnt02,nnt03,nnt04,nnt05,nnt06,nnt07,nnt08,nnt09,nnt10
       FROM s_nnt[1].nnt02,s_nnt[1].nnt03,s_nnt[1].nnt04,
            s_nnt[1].nnt05,s_nnt[1].nnt06,s_nnt[1].nnt07,s_nnt[1].nnt08, 
            s_nnt[1].nnt09,s_nnt[1].nnt10  
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
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL t703_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t703_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   LET g_sql ="SELECT nnt02,nnt03,nnt04,nnt05,nnt06,nnt07,",
              "       nnt08,nnt09,nnt10",
              " FROM nnt_file",
              " WHERE nnt01='",g_nnt01,"' AND ",
                p_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t703_pb FROM g_sql
   DECLARE nnt_curs CURSOR FOR t703_pb
   CALL g_nnt.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH nnt_curs INTO g_nnt[g_cnt].*   #單身 ARRAY 填充
   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_nnt.deleteElement(g_cnt)   #取消 Array Element
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t703_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnt TO s_nnt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first 
         CALL t703_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t703_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t703_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t703_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t703_fetch('L')
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
   
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t703_out()
    DEFINE
        l_nnt           RECORD LIKE nnt_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680107 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #        #No.FUN-680107 VARCHAR(40)
   
    IF g_wc  IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    #LET l_name = 'anmt703.out'
    CALL cl_outnam('anmt703') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM nnt_file ",          # 組合出 SQL 指令
              " WHERE nnt01= '",g_nnt01,"' AND ",
                 g_wc CLIPPED
    PREPARE t703_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t703_co CURSOR FOR t703_p1
 
    START REPORT t703_rep TO l_name
 
    FOREACH t703_co INTO l_nnt.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t703_rep(l_nnt.*)
    END FOREACH
 
    FINISH REPORT t703_rep
 
    CLOSE t703_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t703_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
        sr              RECORD LIKE nnt_file.*
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.nnt01,sr.nnt02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[15]))/2)-4,g_x[15] CLIPPED,sr.nnt01
            PRINT g_dash2
            PRINTX name=H1 g_x[31], g_x[32], g_x[33], g_x[34],
                           g_x[35], g_x[36], g_x[37], g_x[38]
            PRINTX name=H2  g_x[39], g_x[40]
 #                   行序    財產編號  附號  單位   數量     未折減
 #                           財產名稱 
            PRINT g_dash1 
 #                 12345678901234567890123456789012345678901234567890123456789012345678901234567890
 #                          1         2         3         4         5         6         7
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINTX name=D1 COLUMN g_c[31],sr.nnt02 USING '####',
                  COLUMN g_c[32],sr.nnt03, 
                  COLUMN g_c[33],sr.nnt04, 
                  COLUMN g_c[34],sr.nnt06, 
                  COLUMN g_c[35],cl_numfor(sr.nnt07,35,0),      
                  COLUMN g_c[36],cl_numfor(sr.nnt08,36,g_azi04),     
                  COLUMN g_c[37],cl_numfor(sr.nnt09,37,g_azi04), 
                  COLUMN g_c[38],cl_numfor(sr.nnt10,38,g_azi04) 
            PRINTX name=D2 COLUMN g_c[40],sr.nnt05
        ON LAST ROW
            PRINT g_dash[1,g_len]
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
