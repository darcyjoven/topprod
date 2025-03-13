# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: sagli007.4gl (copy from agli007)
# Descriptions...: 股東權益變動事項維護作業
# Date & Author..: 11/07/06 By lixiang (FUN-B60144) 
# Modify.........: NO.FUN-BB0065 12/03/06 By belle 拆分程式agli007,agli0071
# Modify.........: No.FUN-BC0089 12/03/06 by belle 總帳股東權益變動表目前取各期異動額，但股東權益是累計餘額
# Modify.........: NO.MOD-C10053 12/03/06 By belle 取得當年度月數最小的那一筆 
# Modify.........: NO.CHI-C20007 12/03/06 By belle 修正agli007整批產生的金額錯誤問題
# Modify.........: NO.FUN-C20023 12/03/06 By belle 取科餘的時候依據加減項設定乘上正負號
# Modify.........: No.TQC-C40217 12/04/23 By lixiang mark列印功能（原程式的列印功能有誤）
# Modify.........: NO.CHI-C40008 12/07/03 by bart 輸入單頭之後出現資料重複，條件少了key
# Modify.........: NO.CHI-C80057 12/10/22 By belle  因股東權益相關科目為貸方科目屬性，取得科餘，改為貸減借
# Modify.........: NO.FUN-CB0021 12/11/06 By belle  增加p_query選項
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_axo12           LIKE axo_file.axo12,
    g_axo12_t         LIKE axo_file.axo12,   
    g_axo01           LIKE axo_file.axo01,
    g_axo01_t         LIKE axo_file.axo01,
    g_axo02           LIKE axo_file.axo02,
    g_axo02_t         LIKE axo_file.axo02,
    g_axo             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        axo14         LIKE axo_file.axo14,
        aya02         LIKE aya_file.aya02,
        #axo04         LIKE axo_file.axo04,
        axo15         LIKE axo_file.axo15,
        axl02         LIKE axl_file.axl02,
        axo04         LIKE axo_file.axo04   #FUN-BB0065
                      END RECORD,
    g_axo_t           RECORD                 #程式變數 (舊值)
        axo14         LIKE axo_file.axo14,
        aya02         LIKE aya_file.aya02,
        #axo04         LIKE axo_file.axo04,
        axo15         LIKE axo_file.axo15,
        axl02         LIKE axl_file.axl02,
        axo04         LIKE axo_file.axo04   #FUN-BB0065 
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql        STRING,
    g_show            LIKE type_file.chr1,   
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT
    g_argv1           LIKE axo_file.axo11,
    g_argv2           LIKE axo_file.axo12,
    g_argv3           LIKE axo_file.axo13,
    g_argv4           LIKE axo_file.axo01,
    g_argv5           LIKE axo_file.axo02,
    g_argv6           LIKE type_file.chr1 
DEFINE p_row,p_col    LIKE type_file.num5   
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10   
DEFINE   g_curs_index  LIKE type_file.num10  

FUNCTION i007(p_argv1) 
DEFINE p_argv1   LIKE type_file.chr1
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_argv6 = p_argv1

#---FUN-BB0065 mark---------------
#   CASE
#      WHEN g_argv6 = '1'
#         LET g_prog = 'agli007'
#      WHEN g_argv6 = '2'
#---FUN-BB0065 mark ---------------
         LET g_prog = 'agli0071'
#   END CASE                         #FUN-BB0065 mark
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
   LET g_argv4 =ARG_VAL(4)
   LET g_argv5 =ARG_VAL(5)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i007_w AT p_row,p_col
     #WITH FORM "agl/42f/agli007"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
     WITH FORM "agl/42f/agli0071"  ATTRIBUTE (STYLE = g_win_style CLIPPED)    #FUN-BB0065 mod
 
   CALL cl_ui_init()
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
      (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
      (NOT cl_null(g_argv5)) THEN
      CALL i007_q()
   END IF   
   CALL i007_menu()
 
   CLOSE WINDOW i007_w                 #結束畫面
 
END FUNCTION
 
#QBE 查詢資料
FUNCTION i007_cs()
DEFINE l_sql STRING
DEFINE l_axo16  LIKE axo_file.axo16

   IF g_argv6 = '1' THEN
      LET l_axo16 = 'Y'
   ELSE
      LET l_axo16 = 'N'
   END IF 
   IF (NOT cl_null(g_argv2)) AND
      (NOT cl_null(g_argv4)) AND
      (NOT cl_null(g_argv5)) THEN
       LET g_wc = "     axo12 = '",g_argv2,"'",
                  " AND axo01 = '",g_argv4,"'",
                  " AND axo02 = '",g_argv5,"'"
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_axo.clear()
       CALL cl_set_head_visible("","YES")   
       INITIALIZE g_axo12 TO NULL
       INITIALIZE g_axo01 TO NULL
       INITIALIZE g_axo02 TO NULL
       CONSTRUCT g_wc ON axo12,axo01,axo02,
                         #axo14,axo04,axo15
                         axo14,axo15,axo04   #FUN-BB0065
          FROM axo12,axo01,axo02,s_axo[1].axo14,
               #s_axo[1].axo04,s_axo[1].axo15
               s_axo[1].axo15,s_axo[1].axo04 #FUN-BB0065
           
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axo12)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form  = "q_axo12"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axo12
                NEXT FIELD axo12
             WHEN INFIELD(axo14)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                IF g_argv6 = '1' THEN
                   LET g_qryparam.form = "q_aya01"
                ELSE
                   LET g_qryparam.form = "q_aya02"
                END IF
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_axo[1].axo14
                NEXT FIELD axo14
             WHEN INFIELD(axo15)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form  = "q_axl"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_axo[1].axo15
                NEXT FIELD axo15
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axouser', 'axogrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT DISTINCT axo12,axo01,axo02 FROM axo_file ",
               " WHERE ", g_wc CLIPPED,
               "   AND axo16='",l_axo16,"' "  
    LET g_sql= l_sql," ORDER BY axo12,axo01,axo02"
    PREPARE i007_prepare FROM g_sql      #預備一下
    DECLARE i007_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i007_prepare
 
    DROP TABLE i007_cnttmp
    LET g_sql_tmp=l_sql," INTO TEMP i007_cnttmp" 
    
    PREPARE i007_cnttmp_pre FROM g_sql_tmp  
    EXECUTE i007_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i007_cnttmp"
 
    PREPARE i007_precount FROM g_sql
    DECLARE i007_count CURSOR FOR i007_precount
 
    IF NOT cl_null(g_argv2) THEN
       LET g_axo12=g_argv2
    END IF
 
    IF NOT cl_null(g_argv4) THEN
       LET g_axo01=g_argv4
    END IF
 
    IF NOT cl_null(g_argv5) THEN
       LET g_axo02=g_argv5
    END IF
    CALL i007_show()
END FUNCTION
 
FUNCTION i007_menu()
DEFINE l_cmd STRING    #FUN-CB0021
 
   WHILE TRUE
      CALL i007_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i007_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i007_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i007_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i007_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i007_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        #str FUN-780068 add 10/19
         WHEN "generate"   #異動明細產生
            IF cl_chk_act_auth() THEN
               CALL i007_g()
            END IF
        #end FUN-780068 add 10/19
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

      #TQC-C40217--mark---beign--   
      #  WHEN "output"
      #     IF cl_chk_act_auth() THEN
      #        CALL i007_out()
      #     END IF
      #TQC-C40217--mark---end---
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),
                base.TypeInfo.create(g_axo),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_axo12 IS NOT NULL THEN
                LET g_doc.column1 = "axo12"
                LET g_doc.value1 = g_axo12
                CALL cl_doc()
             END IF 
          END IF
        #FUN-CB0021--(B)--
         WHEN "output"           
            IF cl_chk_act_auth() THEN
               IF g_argv6='2' THEN
                  IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
                  LET l_cmd='p_query "agli0071" "',g_wc CLIPPED,'"'
                  CALL cl_cmdrun(l_cmd)
               END IF
            END IF
        #FUN-CB0021--(E)--
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i007_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_axo.clear()
   LET g_axo12_t  = NULL
   LET g_axo01_t  = NULL
   LET g_axo02_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i007_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_axo12=NULL
         LET g_axo01=NULL
         LET g_axo02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_axo.clear()
      ELSE
         CALL i007_b_fill('1=1')            #單身
      END IF
 
      CALL i007_b()                      #輸入單身
 
      LET g_axo12_t = g_axo12
      LET g_axo01_t = g_axo01
      LET g_axo02_t = g_axo02
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i007_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
    l_cnt           LIKE type_file.num10,
    li_result       LIKE type_file.num5
DEFINE l_aaa04      LIKE aaa_file.aaa04  #FUN-BB0065
DEFINE l_aaa05      LIKE aaa_file.aaa05  #FUN-BB0065
 
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")     
 
    #--FUN-BB0065 start--
    LET g_axo12 = g_aaz.aaz64
    SELECT aaa04,aaa05 INTO l_aaa04,l_aaa05
      FROM aaa_file WHERE aaa01 = g_axo12
    LET g_axo01 = l_aaa04
    LET g_axo02 = l_aaa05
    #--FUN-BB0065 end-
 
    INPUT g_axo12,g_axo01,g_axo02 WITHOUT DEFAULTS
        FROM axo12,axo01,axo02
 
       AFTER FIELD axo12
          SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=g_axo12
          IF l_cnt=0 THEN
             CALL cl_err(g_axo12,100,0)
             NEXT FIELD axo12
          END IF
          DISPLAY g_axo12 TO axo12
       
       AFTER FIELD axo02
          IF (NOT cl_null(g_axo12)) OR
             (NOT cl_null(g_axo01)) OR
             (NOT cl_null(g_axo02)) THEN
             LET l_cnt=0             
             SELECT COUNT(*) INTO l_cnt FROM axo_file
                                       WHERE axo12=g_axo12
                                         AND axo01=g_axo01
                                         AND axo02=g_axo02
                                         AND axo16 ='N'   #CHI-C40008
            IF l_cnt>0 THEN
               CALL cl_err('','-239',1)
               NEXT FIELD axo12
            END IF
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axo12)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                CALL cl_create_qry() RETURNING g_axo12
                DISPLAY g_axo12 TO axo12
                NEXT FIELD axo12
          END CASE
       ON ACTION CONTROLG
         CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION
 
FUNCTION i007_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axo12,g_axo01,g_axo02 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axo.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i007_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_axo12,g_axo01,g_axo02 TO NULL
      RETURN
   END IF
 
   OPEN i007_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axo12,g_axo01,g_axo02 TO NULL
   ELSE
      OPEN i007_count
      FETCH i007_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i007_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i007_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式
   l_abso          LIKE type_file.num10   #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i007_bcs INTO g_axo12,
                                             g_axo01,g_axo02
       WHEN 'P' FETCH PREVIOUS i007_bcs INTO g_axo12,
                                             g_axo01,g_axo02
       WHEN 'F' FETCH FIRST    i007_bcs INTO g_axo12,
                                             g_axo01,g_axo02
       WHEN 'L' FETCH LAST     i007_bcs INTO g_axo12,
                                             g_axo01,g_axo02
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i007_bcs INTO g_axo12,
                                                g_axo01,g_axo02
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_axo12,SQLCA.sqlcode,0)
      INITIALIZE g_axo12 TO NULL
      INITIALIZE g_axo01 TO NULL
      INITIALIZE g_axo02 TO NULL
   ELSE
      CALL i007_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i007_show()
 
   DISPLAY g_axo12 TO axo12
   DISPLAY g_axo01 TO axo01
   DISPLAY g_axo02 TO axo02
 
   CALL i007_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i007_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,          #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否       
   p_cmd           LIKE type_file.chr1,          #處理狀態         
   l_allow_insert  LIKE type_file.num5,          #可新增否         
   l_allow_delete  LIKE type_file.num5,          #可刪除否         
   l_cnt           LIKE type_file.num10          #No.FUN-680098
DEFINE 
   l_axo16         LIKE axo_file.axo16

   IF g_argv6 = '1' THEN
      LET l_axo16='Y'
   ELSE
      LET l_axo16='N'
   END IF  
   LET g_action_choice = ""
 
   IF cl_null(g_axo12) OR
      cl_null(g_axo01) OR
      cl_null(g_axo02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT axo14,'',axo04,axo15,'' FROM axo_file",
   LET g_forupd_sql = "SELECT axo14,'',axo15,'',axo04 FROM axo_file",   #FUN-BB0065
                      "  WHERE axo12= ? ",
                      "   AND axo01 = ? AND axo02= ? AND axo14= ? ",
                      "   AND axo15 = ? AND axo16= ? FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i007_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_axo.clear() END IF
 
   INPUT ARRAY g_axo WITHOUT DEFAULTS FROM s_axo.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
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
            LET g_axo_t.* = g_axo[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i007_bcl USING g_axo12,g_axo01,g_axo02,
                                #g_axo[l_ac].axo14,g_axo[l_ac].axo15,l_axo16
                                g_axo_t.axo14,g_axo_t.axo15,l_axo16   #FUN-BB0065 mod
            IF STATUS THEN
               CALL cl_err("OPEN i007_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i007_bcl INTO g_axo[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i007_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
                  LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
                  LET g_axo_t.*=g_axo[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axo[l_ac].* TO NULL            #900423
         IF g_argv6 = '1' THEN
            LET l_axo16 = 'Y'
         ELSE
            LET l_axo16 = 'N'
         END IF
         LET g_axo_t.* = g_axo[l_ac].*               #新輸入資料
         LET g_axo[l_ac].axo04=0
         CALL cl_show_fld_cont()
         NEXT FIELD axo14
 
      AFTER FIELD axo14                         # check data 是否重複
         IF NOT cl_null(g_axo[l_ac].axo14) THEN
            IF NOT i007_chk_axo14() THEN
               LET g_axo[l_ac].axo14=g_axo_t.axo14
               LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
               DISPLAY BY NAME g_axo[l_ac].axo14,g_axo[l_ac].aya02
               NEXT FIELD CURRENT
            END IF
            LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
            DISPLAY BY NAME g_axo[l_ac].aya02
            IF g_axo[l_ac].axo14 != g_axo_t.axo14 OR 
               g_axo_t.axo14 IS NULL THEN
               IF NOT i007_chk_dudata() THEN
                  LET g_axo[l_ac].axo14=g_axo_t.axo14
                  LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
                  DISPLAY BY NAME g_axo[l_ac].axo14,g_axo[l_ac].aya02
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
         LET g_axo[l_ac].aya02=i007_set_aya02(g_axo[l_ac].axo14)
         DISPLAY BY NAME g_axo[l_ac].aya02
 
      AFTER FIELD axo04
         CALL i007_set_axo04()
         
      AFTER FIELD axo15                         # check data 是否重複
         IF NOT cl_null(g_axo[l_ac].axo15) THEN
            IF NOT i007_chk_axo15() THEN
               LET g_axo[l_ac].axo15=g_axo_t.axo15
               LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
               DISPLAY BY NAME g_axo[l_ac].axo15,g_axo[l_ac].axl02
               NEXT FIELD CURRENT
            END IF
            LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
            DISPLAY BY NAME g_axo[l_ac].axl02
            IF g_axo[l_ac].axo15 != g_axo_t.axo15 OR 
               g_axo_t.axo15 IS NULL THEN
               IF NOT i007_chk_dudata() THEN
                  LET g_axo[l_ac].axo15=g_axo_t.axo15
                  LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
                  DISPLAY BY NAME g_axo[l_ac].axo15,g_axo[l_ac].axl02
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
         LET g_axo[l_ac].axl02=i007_set_axl02(g_axo[l_ac].axo15)
         DISPLAY BY NAME g_axo[l_ac].axl02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_axo[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axo[l_ac].* TO s_axo.*
            CALL g_axo.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO axo_file(axo11,axo12,axo13,axo01,axo02,axo14,axo04,
                              axo15,axo16,
                              axolegal,axooriu,axoorig)   #FUN-BB0065
              VALUES(' ',g_axo12,' ',g_axo01,g_axo02,
                     g_axo[l_ac].axo14,g_axo[l_ac].axo04,
                     g_axo[l_ac].axo15,l_axo16,
                     g_legal,g_user,g_grup)               #FUN-BB0065
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axo_file",g_axo[l_ac].axo14,
                         "",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF l_ac>0 THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM axo_file WHERE axo12 = g_axo12
                                   AND axo01 = g_axo01
                                   AND axo02 = g_axo02
                                   AND axo14 = g_axo_t.axo14
                                   AND axo15 = g_axo_t.axo15
                                   AND axo16 = l_axo16
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axo_file",g_axo[l_ac].axo14,
                            g_axo[l_ac].axo15,SQLCA.sqlcode,"","",1)
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
            LET g_axo[l_ac].* = g_axo_t.*
            CLOSE i007_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axo[l_ac].axo14,-263,1)
            LET g_axo[l_ac].* = g_axo_t.*
         ELSE
            UPDATE axo_file SET axo14 = g_axo[l_ac].axo14,
                                axo04 = g_axo[l_ac].axo04,
                                axo15 = g_axo[l_ac].axo15
                                 WHERE axo12 = g_axo12
                                   AND axo01 = g_axo01
                                   AND axo02 = g_axo02
                                   AND axo14 = g_axo_t.axo14
                                   AND axo15 = g_axo_t.axo15
                                   AND axo16 = l_axo16
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axo_file",g_axo[l_ac].axo14,
                            g_axo[l_ac].axo15,SQLCA.sqlcode,"","",1)
               LET g_axo[l_ac].* = g_axo_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_axo[l_ac].* = g_axo_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_axo.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i007_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i007_bcl
         COMMIT WORK
         #CKP2
          CALL g_axo.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axo14)
              CALL cl_init_qry_var()
              IF g_argv6 = '1' THEN
                 LET g_qryparam.form = "q_aya01"
              ELSE
                 LET g_qryparam.form = "q_aya02"
              END IF
              LET g_qryparam.default1 = g_axo[l_ac].axo14
              CALL cl_create_qry() RETURNING g_axo[l_ac].axo14
              DISPLAY BY NAME g_axo[l_ac].axo14
              NEXT FIELD axo14
           WHEN INFIELD(axo15)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_axl01"
              LET g_qryparam.default1 = g_axo[l_ac].axo15
              LET g_qryparam.default2 = g_axo[l_ac].axl02
              CALL cl_create_qry() RETURNING g_axo[l_ac].axo15,
                                             g_axo[l_ac].axl02
              DISPLAY BY NAME g_axo[l_ac].axo15
              DISPLAY BY NAME g_axo[l_ac].axl02
              NEXT FIELD axo15
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
             RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END INPUT
 
   CLOSE i007_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i007_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
DEFINE l_axo16  LIKE axo_file.axo16 
 
   IF g_argv6 = '1' THEN
      LET l_axo16 = 'Y'
   ELSE
      LET l_axo16 = 'N'
   END IF
   #LET g_sql = "SELECT axo14,'',axo04,axo15,''",
   LET g_sql = "SELECT axo14,'',axo15,'',axo04",   #FUN-BB0065
               " FROM axo_file ",
               " WHERE axo12 = '",g_axo12,"'",
               "   AND axo01 = '",g_axo01,"'",
               "   AND axo02 = '",g_axo02,"'",
               "   AND axo16 = '",l_axo16,"'", 
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axo14"
   PREPARE i007_prepare2 FROM g_sql       #預備一下
   DECLARE axo_cs CURSOR FOR i007_prepare2
 
   CALL g_axo.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH axo_cs INTO g_axo[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_axo[g_cnt].aya02=i007_set_aya02(g_axo[g_cnt].axo14)
      LET g_axo[g_cnt].axl02=i007_set_axl02(g_axo[g_cnt].axo15)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_axo.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i007_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axo TO s_axo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i007_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i007_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i007_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i007_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i007_fetch('L')
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
 
     #str FUN-780068 add 10/19
      ON ACTION generate   #異動明細產生
         LET g_action_choice="generate"
         EXIT DISPLAY
     #end FUN-780068 add 10/19
 
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

    #TQC-C40217--mark---begin--      
    # ON ACTION output
    #    LET g_action_choice="output"
    #    EXIT DISPLAY
    #TQC-C40217--mark---end--
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
     #FUN-CB0021--(B)--
      ON ACTION output          
         LET g_action_choice="output"          
         EXIT DISPLAY 
     #FUN-CB0021--(B)--
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i007_copy()
DEFINE
   l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
   l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
   l_newno2,l_oldno2  LIKE axo_file.axo12,
   l_newno4,l_oldno4  LIKE axo_file.axo01,
   l_newno5,l_oldno5  LIKE axo_file.axo02,
   li_result       LIKE type_file.num5
DEFINE l_axo16     LIKE axo_file.axo16 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_axo12) OR
      cl_null(g_axo01) OR
      cl_null(g_axo02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   DISPLAY NULL TO axo12
   DISPLAY NULL TO axo01
   DISPLAY NULL TO axo02
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INPUT l_newno2,l_newno4,l_newno5 
    FROM axo12,axo01,axo02
 
       AFTER FIELD axo12
          SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=l_newno2
          IF l_cnt=0 THEN
             CALL cl_err(g_axo12,100,0)
             NEXT FIELD axo12
          END IF
          DISPLAY l_newno2 TO axo12
 
       AFTER FIELD axo02
          IF (NOT cl_null(l_newno2)) OR
             (NOT cl_null(l_newno4)) OR
             (NOT cl_null(l_newno5)) THEN
             LET l_cnt=0             
             SELECT COUNT(*) INTO l_cnt FROM axo_file
                                       WHERE axo12=l_newno2
                                         AND axo01=l_newno4
                                         AND axo02=l_newno5
                                         AND axo16=l_axo16
            IF l_cnt>0 THEN
               CALL cl_err('','-239',1)
               NEXT FIELD axo12
            END IF
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(axo11)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_axz"
                CALL cl_create_qry() RETURNING l_newno2
                DISPLAY l_newno2 TO axo12
                NEXT FIELD axo11
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
      DISPLAY g_axo12 TO axo12
      DISPLAY g_axo01 TO axo01
      DISPLAY g_axo02 TO axo02
      RETURN
   END IF
 
   DROP TABLE i007_x
 
   SELECT * FROM axo_file             #單身複製
    WHERE axo12 = g_axo12
      AND axo01 = g_axo01
      AND axo02 = g_axo02
      AND axo16 = l_axo16
     INTO TEMP i007_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno2 CLIPPED
      CALL cl_err3("ins","i007_x",g_axo12,g_axo01,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE i007_x SET axo12=l_newno2,
                     axo01=l_newno4,
                     axo02=l_newno5
               WHERE axo16 = l_axo16
   INSERT INTO axo_file SELECT * FROM i007_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno2 CLIPPED
      CALL cl_err3("ins","axo_file",l_newno2,l_newno4,
                    SQLCA.sqlcode,"",g_msg,1)
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_axo12=l_newno2
      LET g_axo01=l_newno4
      LET g_axo02=l_newno5
      CALL i007_show()
   END IF
 
END FUNCTION
 
FUNCTION i007_r()
DEFINE l_axo16  LIKE axo_file.axo16

   IF g_argv6='1' THEN
      LET l_axo16='Y'
   ELSE
      LET l_axo16='N'
   END IF

   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_axo12) OR
      cl_null(g_axo01) OR
      cl_null(g_axo02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "axo12"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_axo12       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM axo_file WHERE axo12=g_axo12
                          AND axo01=g_axo01
                          AND axo02=g_axo02
                          AND axo16=l_axo16 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","axo_file",g_axo12,g_axo01,
                   SQLCA.sqlcode,"","del axo",1)
      RETURN      
   END IF   
 
   INITIALIZE g_axo12,g_axo01,g_axo02 TO NULL
   MESSAGE ""
   CLEAR FORM
   CALL g_axo.clear()
   IF NOT cl_null(g_sql_tmp) THEN
      DROP TABLE i007_cnttmp                   #No.TQC-720019
      PREPARE i007_precount_x2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i007_precount_x2                 #No.TQC-720019
   END IF
   OPEN i007_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i007_bcs
      CLOSE i007_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH i007_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i007_bcs
      CLOSE i007_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i007_bcs
      CALL i007_fetch('F') 
   ELSE
      DISPLAY g_axo12 TO axo12
      DISPLAY g_axo01 TO axo01
      DISPLAY g_axo02 TO axo02
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_axo.clear()
      CALL i007_menu()
   END IF
END FUNCTION

# FUN-B60144 ADD
FUNCTION i007_g()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
DEFINE l_flag      LIKE type_file.chr1
DEFINE li_result   LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE  tm    RECORD
              axo12   LIKE axo_file.axo12,    #帳別
              yy      LIKE axo_file.axo01,    #年度
              mm      LIKE axo_file.axo02     #期別
              END RECORD

  #OPEN WINDOW i007_g_w AT p_row,p_col WITH FORM "agl/42f/agli007_g"    #FUN-BC0089
   OPEN WINDOW i007_g_w AT p_row,p_col WITH FORM "agl/42f/agli0071_g"   #FUN-BC0089 mod
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
  #CALL cl_ui_locale("agli007_g")
   CALL cl_ui_locale("agli0071_g")     #FUN-BB0065 mod

   WHILE TRUE
      INPUT BY NAME tm.axo12,tm.yy,tm.mm WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            INITIALIZE tm.* TO NULL
            LET tm.yy = YEAR(g_today)
            LET tm.mm = MONTH(g_today)
            DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm

         AFTER FIELD axo12
            SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=tm.axo12
            IF l_cnt=0 THEN
               CALL cl_err(g_axo12,100,0)
               NEXT FIELD axo12
            END IF
            DISPLAY tm.axo12 TO axo12

         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD yy
            END IF
            IF tm.yy < 0 THEN NEXT FIELD yy END IF
         
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD mm
            END IF
         
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axo12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  CALL cl_create_qry() RETURNING tm.axo12
                  DISPLAY tm.axo12 TO axo12
                  NEXT FIELD axo12
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
         
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i007_g_w
         RETURN
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i007_g_w
         RETURN
      END IF
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i007_g_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'
         CALL i007_g1(tm.*)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE

   CLOSE WINDOW i007_g_w

END FUNCTION

FUNCTION i007_g1(tm)
DEFINE tm          RECORD
                    axo12  LIKE axo_file.axo12,   #帳別
                    yy     LIKE axr_file.axr10,   #年度
                    mm     LIKE axr_file.axr11    #期別
                   END RECORD,
       l_cnt       LIKE type_file.num5,
       sr          RECORD
                    axo14  LIKE axo_file.axo14,   #分類代碼
                    axo15  LIKE axo_file.axo15,   #群組代碼
                    axo04  LIKE axo_file.axo04    #異動金額
                   END RECORD
DEFINE l_aai04     LIKE aai_file.aai04,
       l_aai01     LIKE aai_file.aai01,   #科目
       l_aai05     LIKE aai_file.aai05,   #加減項  #FUN-C20023
       l_aah04     LIKE aah_file.aah04,
       l_aah05     LIKE aah_file.aah05,
       l_axo16     LIKE axo_file.axo16,
       l_aag06     LIKE aag_file.aag06 
DEFINE l_axn02     LIKE axn_file.axn02    #FUN-BC0089
DEFINE l_axn18     LIKE axn_file.axn18    #MOD-C10053
DEFINE l_sum_axo04  LIKE axo_file.axo04   #CHI-C20007
 
   IF g_argv6='1' THEN
      LET l_aai04='Y'
   ELSE  
      LET l_aai04='N'
   END IF
         
   IF g_argv6 = '1' THEN
      LET l_axo16 = 'Y'
   ELSE  
      LET l_axo16 = 'N'
   END IF   
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM axo_file 
    WHERE axo01=tm.yy AND axo02=tm.mm AND axo12=tm.axo12
      AND axo16 = 'N'   #CHI-C40008
   IF l_cnt > 0 THEN
      #先將舊資料刪除，再重新產生
      DELETE FROM axo_file
       WHERE axo01=tm.yy AND axo02=tm.mm AND axo12=tm.axo12
         AND axo16 = 'N'   #CHI-C40008
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("del","axo_file",tm.axo12,tm.yy,SQLCA.sqlcode,"","del axo",1)
         LET g_success='N'
         RETURN    
      END IF        
   END IF           
  #MOD-C10053--Begin--
   LET g_sql ="SELECT UNIQUE aai02,aai03,'' FROM aai_file WHERE aai00='",tm.axo12,"' ",
                                                          " AND aai04='",l_aai04,"' "
   PREPARE i007_axobc_p FROM g_sql
   DECLARE i007_axobc_cs CURSOR FOR i007_axobc_p
   
   FOREACH i007_axobc_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF

     #LET g_sql ="SELECT aai01 FROM aai_file WHERE aai00 = '",tm.axo12,"' ",         #FUN-C20023 mark
      LET g_sql ="SELECT aai01,aai05 FROM aai_file WHERE aai00 = '",tm.axo12,"' ",   #FUN-C20023
                                             " AND aai04 = '",l_aai04,"' ",
                                             " AND aai02 = '",sr.axo14,"' ",
                                             " AND aai03 = '",sr.axo15,"' "
      PREPARE i007_aaibc_p FROM g_sql
      DECLARE i007_aaibc_cs CURSOR FOR i007_aaibc_p
                                                     
     #FOREACH i007_aaibc_cs INTO l_aai01              #FUN-C20023 mark
      FOREACH i007_aaibc_cs INTO l_aai01,l_aai05      #FUN-C20023
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            LET g_success='N'
            EXIT FOREACH
         END IF  
         LET l_aah04 = 0
         LET l_aah05 = 0
         SELECT SUM(aah04) INTO l_aah04 FROM aah_file
          WHERE aah00=tm.axo12 AND aah01=l_aai01 
            AND aah02=tm.yy AND aah03 BETWEEN 0 AND tm.mm
         SELECT SUM(aah05) INTO l_aah05 FROM aah_file
          WHERE aah00=tm.axo12 AND aah01=l_aai01 
            AND aah02=tm.yy AND aah03 BETWEEN 0 AND tm.mm
         IF cl_null(l_aah04) THEN
            LET l_aah04=0
         END IF
         IF cl_null(l_aah05) THEN
            LET l_aah05=0
         END IF
        #LET sr.axo04 = l_aah04 - l_aah05     #CHI-C80057 mark 
         LET sr.axo04 = l_aah05 - l_aah04     #CHI-C80057 
        #FUN-C20023--Begin Mark--
        #SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=l_aai01 AND aag00=tm.axo12
        #IF l_aag06 = '2' THEN
        #   LET sr.axo04 = sr.axo04 * (-1)
        #END IF
        #FUN-C20023---End Mark---
         IF l_aai05 = '-' THEN                   #FUN-C20023
            LET sr.axo04 = sr.axo04 * (-1)       #FUN-C20023
         END IF                                  #FUN-C20023

         IF cl_null(sr.axo04) THEN
            LET sr.axo04=0
         END IF
         IF sr.axo04 <> 0 THEN    #CHI-C20007
            INSERT INTO axo_file(axo11,axo12,axo13,axo01,axo02,axo14,axo04,axo15,axo16)
                          VALUES(' ',tm.axo12,' ',tm.yy,tm.mm,
                                 sr.axo14,sr.axo04,sr.axo15,l_axo16)
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
               UPDATE axo_file SET axo04 = axo04 + sr.axo04
                          WHERE axo12 = tm.axo12
                            AND axo01 = tm.yy 
                            AND axo02 = tm.mm
                            AND axo14 = sr.axo14
                            AND axo15 = sr.axo15
                            AND axo16 = l_axo16
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
                  LET g_success='N'
                  EXIT FOREACH
               END IF
            END IF
         END IF    #CHI-C20007
      END FOREACH
     #算出該分類,群組代碼餘額的期別與餘額
      LET g_sql = " SELECT axn02,axn18 "
                 ," FROM axn_file"
                 ," WHERE axn15 = '", tm.axo12 ,"'"
                 ," AND axn01 = '", tm.yy ,"'"
                 ," AND axn17 = '", sr.axo14,"'"
                 ," AND axn19 = '", sr.axo15,"'"
                 ," AND axn16 = ' '"
                 ," AND axn14 = ' '"
      PREPARE i007_axn_p FROM g_sql
      DECLARE i007_axn_cs SCROLL CURSOR WITH HOLD FOR i007_axn_p
      OPEN i007_axn_cs
      LET l_axn02 = ''  #CHI-C20007
      LET l_axn18 = 0   #CHI-C20007
      FETCH FIRST i007_axn_cs INTO l_axn02,l_axn18
      IF cl_null(l_axn02) THEN LET l_axn02=0 END IF
      IF cl_null(l_axn18) THEN LET l_axn18=0 END IF
     #CHI-C20007--begin--
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM axo_file
        WHERE axo12 = tm.axo12
          AND axo01 = tm.yy
          AND axo02 = tm.mm
          AND axo14 = sr.axo14
          AND axo15 = sr.axo15
          AND axo16 = l_axo16
      LET l_sum_axo04 = 0
      SELECT SUM(axo04) INTO l_sum_axo04 
        FROM axo_file
       WHERE axo12 = tm.axo12
         AND axo01 = tm.yy
         AND axo02 = tm.mm
         AND axo14 = sr.axo14
         AND axo15 = sr.axo15
         AND axo16 = l_axo16

      IF l_cnt > 0 THEN
     #CHI-C20007---end---
         UPDATE axo_file SET axo04 = axo04 - l_axn18
                       WHERE axo12 = tm.axo12
                         AND axo01 = tm.yy
                         AND axo02 = tm.mm
                         AND axo14 = sr.axo14
                         AND axo15 = sr.axo15
                         AND axo16 = l_axo16
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF    #CHI-C20007
   END FOREACH
  #MOD-C10053---End---
  #MOD-C10053--Begin Mark
  #LET g_sql ="SELECT aai01 FROM aai_file WHERE aai00='",tm.axo12,"' ",
  #                                       " AND aai04='",l_aai04,"' "
  #PREPARE i007_aaibc_p FROM g_sql
  #DECLARE i007_aaibc_cs CURSOR FOR i007_aaibc_p
  #                                                  
  #FOREACH i007_aaibc_cs INTO l_aai01 
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
  #      LET g_success='N'
  #      EXIT FOREACH
  #   END IF  
  #   
  #   LET g_sql ="SELECT aai02,aai03,'' FROM aai_file WHERE aai00='",tm.axo12,"' ",
  #                                                   " AND aai04='",l_aai04,"' ", 
  #                                                   " AND aai01='",l_aai01,"' "
  #   PREPARE i007_axobc_p FROM g_sql
  #   DECLARE i007_axobc_cs CURSOR FOR i007_axobc_p
  #
  #   FOREACH i007_axobc_cs INTO sr.*
  #      IF SQLCA.sqlcode THEN
  #         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
  #         LET g_success='N'
  #         EXIT FOREACH
  #      END IF
  #      LET l_aah04 = 0
  #      LET l_aah05 = 0
  #     #FUN-BC0089--Begin--
  #     #MOD-C10053--Begin Mark--
  #     #算出該分類,群組代碼餘額的期別與餘額
  #     #LET g_sql = " SELECT axn02 "
  #     #           ," FROM axn_file"
  #     #           ," WHERE axn15 = '", tm.axo12 ,"'"
  #     #           ," AND axn01 = '", tm.yy ,"'"
  #     #           ," AND axn17 = '", sr.axo14,"'"
  #     #           ," AND axn19 = '", sr.axo15,"'"
  #     #           ," AND axn16 = ' '"
  #     #           ," AND axn14 = ' '"
  #     #PREPARE i007_axn_p FROM g_sql
  #     #DECLARE i007_axn_cs SCROLL CURSOR WITH HOLD FOR i007_axn_p
  #     #OPEN i007_axn_cs
  #     #FETCH LAST i007_axn_cs INTO l_axn02 
  #     #IF cl_null(l_axn02) THEN
  #     #   LET l_axn02=0
  #     #END IF
  #     #LET l_axn02 = l_axn02 + 1
  #     #MOD-C10053---End Mark---
  #      SELECT SUM(aah04) INTO l_aah04 FROM aah_file
  #       WHERE aah00=tm.axo12 AND aah01=l_aai01 
  #         AND aah02=tm.yy AND aah03 BETWEEN l_axn02 AND tm.mm
  #      SELECT SUM(aah05) INTO l_aah05 FROM aah_file
  #       WHERE aah00=tm.axo12 AND aah01=l_aai01 
  #         AND aah02=tm.yy AND aah03 BETWEEN l_axn02 AND tm.mm
  #     #FUN-BC0089---End---
  #     #FUN-BC0089--Begin Mark--
  #     #SELECT aah04 INTO l_aah04 FROM aah_file
  #     # WHERE aah00=tm.axo12 AND aah01=l_aai01 
  #     #   AND aah02=tm.yy AND aah03=tm.mm
  #     #SELECT aah05 INTO l_aah05 FROM aah_file
  #     # WHERE aah00=tm.axo12 AND aah01=l_aai01 
  #     #   AND aah02=tm.yy AND aah03=tm.mm 
  #     #FUN-BC0089---End Mark---
  #      IF cl_null(l_aah04) THEN
  #         LET l_aah04=0
  #      END IF
  #      IF cl_null(l_aah05) THEN
  #         LET l_aah05=0
  #      END IF
  #      LET sr.axo04 = l_aah04 - l_aah05
  #      SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag01=l_aai01 AND aag00=tm.axo12
  #      IF l_aag06 = '2' THEN
  #         LET sr.axo04 = sr.axo04 * (-1)
  #      END IF
  #      IF cl_null(sr.axo04) THEN
  #         LET sr.axo04=0
  #      END IF
  #      INSERT INTO axo_file(axo11,axo12,axo13,axo01,axo02,axo14,axo04,axo15,axo16)
  #                    VALUES(' ',tm.axo12,' ',tm.yy,tm.mm,
  #                           sr.axo14,sr.axo04,sr.axo15,l_axo16)
  #      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #SQLCA.SQLCODE=-239
  #         UPDATE axo_file SET axo04 = axo04 + sr.axo04
  #                    WHERE axo12 = tm.axo12
  #                      AND axo01 = tm.yy 
  #                      AND axo02 = tm.mm
  #                      AND axo14 = sr.axo14
  #                      AND axo15 = sr.axo15
  #                      AND axo16 = l_axo16
  #         IF SQLCA.sqlcode THEN
  #            CALL cl_err3("upd","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
  #            LET g_success='N'
  #            EXIT FOREACH
  #         END IF
  #      ELSE
  #         IF SQLCA.sqlcode THEN
  #            CALL cl_err3("ins","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
  #            LET g_success='N'
  #            EXIT FOREACH
  #         END IF
  #      END IF
  #   END FOREACH
  #END FOREACH

         
END FUNCTION                                       
         
# FUN-B60144 END

##str FUN-780068 add 10/19
#FUNCTION i007_g()   #0期資料產生
#DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
#DEFINE l_flag      LIKE type_file.chr1
#DEFINE li_result   LIKE type_file.num5
#DEFINE l_cnt       LIKE type_file.num5
#DEFINE tm          RECORD
#                   axo12  LIKE axo_file.axo12,   #帳別
#                   yy     LIKE axr_file.axr10,   #年度
#                   mm     LIKE axr_file.axr11    #期別
#                  END RECORD
#
#  OPEN WINDOW i007_g_w AT p_row,p_col WITH FORM "agl/42f/agli007_g"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  CALL cl_ui_locale("agli007_g")
#
#  WHILE TRUE
#     INPUT BY NAME tm.axo12,tm.yy,tm.mm WITHOUT DEFAULTS
#        BEFORE INPUT
#           CALL cl_qbe_display_condition(lc_qbe_sn)   #FUN-580031 add
#           INITIALIZE tm.* TO NULL
#           LET tm.yy = YEAR(g_today)    #現行年度
#           LET tm.mm = MONTH(g_today)   #現行期別
#           DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
#
#        AFTER FIELD axo12
#           SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=tm.axo12
#           IF l_cnt=0 THEN
#              CALL cl_err(g_axo12,100,0)
#              NEXT FIELD axo12
#           END IF
#           DISPLAY tm.axo12 TO axo12          
#      
#        AFTER FIELD yy
#           IF cl_null(tm.yy) THEN
#              CALL cl_err('','mfg5103',0)
#              NEXT FIELD yy
#           END IF
#           IF tm.yy < 0 THEN NEXT FIELD yy END IF
#
#        AFTER FIELD mm
#           IF cl_null(tm.mm) THEN
#              CALL cl_err('','mfg5103',0)
#              NEXT FIELD mm
#           END IF
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(axo11)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_axz"
#                 CALL cl_create_qry() RETURNING tm.axo11
#                 DISPLAY tm.axo11 TO axo11
#                 NEXT FIELD axo11
#           END CASE
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#        ON ACTION controlg      #MOD-4C0121
#           CALL cl_cmdask()     #MOD-4C0121
#
#        AFTER INPUT
#           IF INT_FLAG THEN EXIT INPUT END IF
#
#        #No.FUN-580031 --start--     HCN
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.FUN-580031 --end--       HCN
#     END INPUT
#     IF INT_FLAG THEN
#        LET INT_FLAG=0
#        CLOSE WINDOW i007_g_w
#        RETURN
#     END IF
#     IF NOT cl_sure(0,0) THEN
#        CLOSE WINDOW i007_g_w
#        RETURN
#     ELSE
#        BEGIN WORK
#        LET g_success='Y'
#        CALL i007_g1(tm.*)
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag
#        END IF
#        IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
#     END IF
#  END WHILE
#
#  CLOSE WINDOW i007_g_w
#END FUNCTION
#
#FUNCTION i007_g1(tm)
#DEFINE tm          RECORD
#                   axo11  LIKE axo_file.axo11,   #公司編號 
#                   axo12  LIKE axo_file.axo12,   #帳別
#                   axo13  LIKE axo_file.axo13,   #幣別
#                   yy     LIKE axr_file.axr10,   #年度
#                   mm     LIKE axr_file.axr11    #期別
#                  END RECORD,
#      l_cnt       LIKE type_file.num5,
#      sr          RECORD
#                   axo11  LIKE axo_file.axo11,   #公司編號
#                   axo12  LIKE axo_file.axo12,   #帳別
#                   axo13  LIKE axo_file.axo13,   #幣別
#                   axo01  LIKE axo_file.axo01,   #年度
#                   axo02  LIKE axo_file.axo02,   #期別
#                   axo14  LIKE axo_file.axo14,   #分類代碼
#                   axo15  LIKE axo_file.axo15,   #群組代碼
#                   axo04  LIKE axo_file.axo04    #異動金額
#                  END RECORD
#
#  LET l_cnt = 0
#  SELECT COUNT(*) INTO l_cnt FROM axo_file
#   WHERE axo01=tm.yy    AND axo02=tm.mm
#     AND axo11=tm.axo11 AND axo12=tm.axo12 AND axo13=tm.axo13
#  IF l_cnt > 0 THEN
#     #先將舊資料刪除，再重新產生
#     DELETE FROM axo_file 
#      WHERE axo01=tm.yy    AND axo02=tm.mm
#        AND axo11=tm.axo11 AND axo12=tm.axo12 AND axo13=tm.axo13
#     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err3("del","axo_file",tm.axo11,tm.axo12,SQLCA.sqlcode,"","del axo",1)
#        LET g_success='N'
#        RETURN      
#     END IF
#  END IF
#
#  #異動金額：借方為 - 減少(ayc11='1')
#  #          貸方為 + 增加(ayc11='2')
#  DECLARE i007_ayabc_cs CURSOR FOR
#     SELECT ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13,SUM(ayc12)*-1
#       FROM aya_file,ayb_file,ayc_file
#      WHERE aya01=ayb01
#        AND ayb02=ayc10
#        AND ayc01=tm.axo11
#        AND ayc02=tm.axo12
#        AND ayc03=tm.axo13
#        AND ayc04=tm.yy
#        AND ayc05=tm.mm
#        AND ayc11='1'   #借方
#      GROUP BY ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13
#     UNION 
#     SELECT ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13,SUM(ayc12)
#       FROM aya_file,ayb_file,ayc_file
#      WHERE aya01=ayb01
#        AND ayb02=ayc10
#        AND ayc01=tm.axo11
#        AND ayc02=tm.axo12
#        AND ayc03=tm.axo13
#        AND ayc04=tm.yy
#        AND ayc05=tm.mm
#        AND ayc11='2'   #貸方
#      GROUP BY ayc01,ayc02,ayc03,ayc04,ayc05,aya01,ayc13
#
#  FOREACH i007_ayabc_cs INTO sr.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#        LET g_success='N'
#        EXIT FOREACH
#     END IF
#
#     INSERT INTO axo_file(axo11,axo12,axo13,axo01,axo02,axo14,axo04,axo15,axooriu,axoorig)
#                   VALUES(sr.axo11,sr.axo12,sr.axo13,sr.axo01,sr.axo02,
#                          sr.axo14,sr.axo04,sr.axo15, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #SQLCA.SQLCODE=-239
#        UPDATE axo_file SET axo04 = axo04 + sr.axo04
#                      WHERE axo11 = sr.axo11
#                        AND axo12 = sr.axo12
#                        AND axo13 = sr.axo13
#                        AND axo01 = sr.axo01
#                        AND axo02 = sr.axo02
#                        AND axo14 = sr.axo14
#                        AND axo15 = sr.axo15
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("upd","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#     ELSE
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","axo_file",sr.axo14,sr.axo15,SQLCA.sqlcode,"","",1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#     END IF
#  END FOREACH
#
# END FUNCTION
# #end FUN-780068 add 10/19
 
#FUNCTION i007_chk_axo11(p_axo11)
#  DEFINE p_axo11 LIKE axo_file.axo11
#  DEFINE l_axzacti  LIKE axz_file.axzacti
#  DEFINE l_axz05 LIKE axz_file.axz05
#  DEFINE l_axz06 LIKE axz_file.axz06
#
#  LET l_axz05=NULL
#  LET l_axz06=NULL
#  IF NOT cl_null(p_axo11) THEN
#   # SELECT axzacti,axz05,axz06                              #FUN-920123 mark
#   #   INTO l_axzacti,l_axz05,l_axz06 FROM axz_file          #FUN-920123 mark
#     SELECT axz05,axz06                                      #FUN-920123
#       INTO l_axz05,l_axz06 FROM axz_file                    #FUN-920123   
#                                     WHERE axz01=p_axo11
#     CASE
#        WHEN SQLCA.sqlcode
#           CALL cl_err3("sel","axo_file",p_axo11,"",SQLCA.sqlcode,"","",1)
#           RETURN FALSE,NULL,NULL
#       #FUN-920123 -----------------mark start---------------
#       #WHEN l_axzacti='N'
#       #   CALL cl_err3("sel","axo_file",p_axo11,"",9028,"","",1)
#       #   RETURN FALSE,NULL,NULL
#       #FUN-920123 ---------------  mark end--------------- 
#     END CASE      
#  END IF
#  RETURN TRUE,l_axz05,l_axz06
#END FUNCTION
 
#FUNCTION i007_set_axz02(p_axz01)
#  DEFINE p_axz01 LIKE axz_file.axz01
#  DEFINE l_axz02 LIKE axz_file.axz02
#  
#  IF cl_null(p_axz01) THEN RETURN NULL END IF
#  LET l_axz02=''
#  SELECT axz02 INTO l_axz02 FROM axz_file
#                           WHERE axz01=p_axz01
#  RETURN l_axz02
#END FUNCTION
 
FUNCTION i007_set_aya02(p_aya01)
   DEFINE p_aya01 LIKE aya_file.aya01
   DEFINE l_aya02 LIKE aya_file.aya02
   
   IF cl_null(p_aya01) THEN RETURN NULL END IF
   LET l_aya02=''
   SELECT aya02 INTO l_aya02 FROM aya_file
                            WHERE aya01=p_aya01
   RETURN l_aya02
END FUNCTION
 
FUNCTION i007_chk_axo14()
   IF NOT cl_null(g_axo[l_ac].axo14) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM aya_file 
                                WHERE aya01 = g_axo[l_ac].axo14
                                  AND aya07 = 'N'   #FUN-BB0065
      IF g_cnt=0 THEN
         CALL cl_err3("sel","aya_file",g_axo[l_ac].axo14,"",100,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i007_chk_axo15()
   IF NOT cl_null(g_axo[l_ac].axo15) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM axl_file 
                                WHERE axl01 = g_axo[l_ac].axo15
      IF g_cnt=0 THEN
         CALL cl_err3("sel","axl_file",g_axo[l_ac].axo15,"",100,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i007_set_axo04()
   IF NOT cl_null(g_axo[l_ac].axo04) THEN
      SELECT azi04 INTO t_azi04 FROM azi_file
                               WHERE azi01=g_axo13
      LET g_axo[l_ac].axo04=cl_digcut(g_axo[l_ac].axo04,t_azi04)
      DISPLAY BY NAME g_axo[l_ac].axo04
   END IF
END FUNCTION
 
FUNCTION i007_chk_dudata()
   IF (NOT cl_null(g_axo[l_ac].axo14)) AND 
      (NOT cl_null(g_axo[l_ac].axo15)) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM axo_file
                                WHERE axo12=g_axo12
                                  AND axo01=g_axo01
                                  AND axo02=g_axo02
                                  AND axo14=g_axo[l_ac].axo14
                                  AND axo15=g_axo[l_ac].axo15
      IF g_cnt>0 THEN
         CALL cl_err('',-239,1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#TQC-C40217--mark---begin-- 
#FUNCTION i007_out()
#  DEFINE l_wc STRING
#  IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

#  IF g_argv6 = '1' THEN
#     LET g_wc = g_wc," AND axo16 = 'Y'"
#  ELSE
#     LET g_wc = g_wc," AND axo16 = 'N'"
#  END IF
#  IF g_argv6 = '1' THEN
#     LET l_wc = 'p_query "agli007" "',g_wc CLIPPED,'"'
#  ELSE
#     LET l_wc = 'p_query "agli0071" "',g_wc CLIPPED,'"'
#  END IF
#  CALL cl_cmdrun(l_wc)
#  RETURN
#END FUNCTION
#TQC-C40217--mark---end---
 
FUNCTION i007_set_axl02(p_axl01)
   DEFINE p_axl01 LIKE axl_file.axl01
   DEFINE l_axl02 LIKE axl_file.axl02
   
   IF cl_null(p_axl01) THEN RETURN NULL END IF
   LET l_axl02=''
   SELECT axl02 INTO l_axl02 FROM axl_file
                            WHERE axl01=p_axl01
   RETURN l_axl02
END FUNCTION
##FUN-780013
#FUN-B60144--
