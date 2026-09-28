# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmt411.4gl
# Descriptions...: 訂單底稿維護作業
# Date & Author..: 09/11/09 FUN-9B0160 By hongmei
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.FUN-910088 11/11/28 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_xsb           RECORD LIKE xsb_file.*,
    g_xsb_t         RECORD LIKE xsb_file.*,
    g_xsb_o         RECORD LIKE xsb_file.*,
    g_xsb01_t       LIKE xsb_file.xsb01, 
    g_xsc           DYNAMIC ARRAY OF RECORD
        xsc02       LIKE xsc_file.xsc02,
        xsc03       LIKE xsc_file.xsc03,
        desc        LIKE ima_file.ima021,
        xsc05       LIKE xsc_file.xsc05,
        xsc04       LIKE xsc_file.xsc04,
        xsc06       LIKE xsc_file.xsc06,
        xsc07       LIKE xsc_file.xsc07,
        xsc07t      LIKE xsc_file.xsc07t,
        xsc08       LIKE xsc_file.xsc08,
        xsc09       LIKE xsc_file.xsc09
                    END RECORD,
    g_xsc_t         RECORD
        xsc02       LIKE xsc_file.xsc02,
        xsc03       LIKE xsc_file.xsc03,
        desc        LIKE ima_file.ima021,
        xsc05       LIKE xsc_file.xsc05,
        xsc04       LIKE xsc_file.xsc04,
        xsc06       LIKE xsc_file.xsc06,
        xsc07       LIKE xsc_file.xsc07,
        xsc07t      LIKE xsc_file.xsc07t,
        xsc08       LIKE xsc_file.xsc08,
        xsc09       LIKE xsc_file.xsc09
                    END RECORD,
   g_wc,g_sql,g_wc2  STRING,
   g_wc3             STRING,
   g_rec_b           LIKE type_file.num5,     #單身筆數    
   l_ac              LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE g_forupd_sql  STRING                   #SELECT ... FOR UPDATE   SQL
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE g_t1            LIKE type_file.chr5       
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE g_no_ask        LIKE type_file.num5
DEFINE g_delete        LIKE type_file.chr1
DEFINE g_chr           STRING
DEFINE g_pme031        LIKE pme_file.pme031
DEFINE g_pme032        LIKE pme_file.pme032
DEFINE g_pme033        LIKE pme_file.pme033
DEFINE g_pme034        LIKE pme_file.pme034   
 
MAIN
 
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF   
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET g_forupd_sql = " SELECT * FROM xsb_file WHERE xsb01 =? FOR UPDATE "  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t411_crl CURSOR FROM g_forupd_sql 
 
   OPEN WINDOW t411_w WITH FORM "axm/42f/axmt411" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
    
   CALL t411_menu()
 
   CLOSE WINDOW t411_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t411_cs()
   CLEAR FORM                             #清除畫面 
   CONSTRUCT BY NAME g_wc ON xsb01,xsb02,xsb03,xsb04,xsb05,
                             xsb06,xsb07,xsb13
                             
     ON ACTION controlp          
          CASE
            WHEN INFIELD(xsb01)
               CALL cl_init_qry_var()
               LET g_qryparam.state="c" 
               LET g_qryparam.form="q_xsb01"
               LET g_qryparam.default1=g_xsb.xsb01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO xsb01
               NEXT FIELD ska01 
            WHEN INFIELD(xsb03)
               CALL cl_init_qry_var()
               LET g_qryparam.state="c"
               LET g_qryparam.form="q_xsb03"
               LET g_qryparam.default1=g_xsb.xsb03 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
	             DISPLAY g_qryparam.multiret TO xsb03
               NEXT FIELD xsb03
            OTHERWISE
               EXIT CASE  
        END CASE 
          
     ON IDLE g_idle_seconds   
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   END  CONSTRUCT
   
    CONSTRUCT g_wc2 ON xsc02,xsc03,xsc04,xsc06,xsc05,
                       xsc07,xsc07t,xsc08
                     FROM s_xsc[1].xsc02,s_xsc[1].xsc03,
                       s_xsc[1].xsc04,s_xsc[1].xsc06,
                       s_xsc[1].xsc05,s_xsc[1].xsc07,
                       s_xsc[1].xsc07t,s_xsc[1].xsc08
                       
    ON ACTION CONTROLP
          CASE
            WHEN INFIELD(xsc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form   = "q_xsc03"
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO xsc03
                 NEXT FIELD xsc03
           END CASE       
     
    ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END  CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT xsb01 FROM xsb_file ",
                 " WHERE ",g_wc CLIPPED,
                 " ORDER BY xsb01"
    ELSE
      LET g_sql= "SELECT xsb01 FROM xsb_file,xsc_file",
                 " WHERE xsb01=xsc01  AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY xsb01 " 
    END IF
    PREPARE t411_prepare FROM g_sql      #預備
    DECLARE t411_b_cs                  #宣告成可卷動
        SCROLL CURSOR WITH HOLD FOR t411_prepare
    IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT  COUNT(*)     ",
                " FROM xsb_file WHERE ", g_wc CLIPPED
    ELSE
      LET g_sql="SELECT  COUNT(*)     ",
                " FROM xsb_file,xsc_file WHERE ", 
                " xsb01=xsc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED 
    END IF
    PREPARE t411_precount FROM g_sql
    DECLARE t411_count CURSOR FOR t411_precount
END FUNCTION 
         
FUNCTION t411_menu()
  DEFINE l_cnt           LIKE type_file.num10
 
    WHILE TRUE
      CALL t411_bp("G")
      CASE g_action_choice
         
#         WHEN "insert"
#            IF cl_chk_act_auth() THEN 
#               CALL t411_a()
#            END IF
 
         WHEN "reback"
            IF cl_chk_act_auth() THEN
               CALL t411_reback()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN 
               CALL t411_q()
            END IF
 
#         WHEN "delete"
#            IF cl_chk_act_auth() THEN
#               CALL t411_r()
#            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t411_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
#               SELECT COUNT(*) INTO l_cnt FROM xsb_file,xsc_file 
#                                         WHERE xsb01=xsc01
#                                           AND xsbplant = g_plant
#               IF l_cnt > 0 THEN 
                  CALL t411_u()
#               END IF    
            END IF             
          
         WHEN "confirm" 
           IF cl_chk_act_auth() THEN 
              CALL t411_confirm()
              CALL t411_show()
           END IF
 
#         WHEN "notconfirm" 
#           IF cl_chk_act_auth() THEN 
#              CALL t411_notconfirm()
#              CALL t411_show()
#           END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask() 
             
#         WHEN "exporttoexcel"
#            IF cl_chk_act_auth() THEN 
#              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xsb),'','')
#            END IF 
            
      END CASE
    END WHILE
    
END FUNCTION
 
FUNCTION t411_a()
DEFINE li_result       LIKE type_file.num5
   
    MESSAGE ""
    CLEAR FORM 
    CALL g_xsc.clear()
    
#   IF s_shut(0) THEN
#      RETURN
#   END IF
    
    CALL cl_opmsg('a')
 
    WHILE TRUE
       INITIALIZE g_xsb.* TO NULL   #FUN-850068
    
       CALL t411_i("a")
        IF INT_FLAG THEN                   #使用者不
            LET INT_FLAG = 0
            LET g_xsb.xsb01  = NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF         
 
        IF cl_null(g_xsb.xsb01)   THEN
               CONTINUE WHILE
        END IF
        
        CALL s_auto_assign_no("axm",g_xsb.xsb01,g_today,"62","xsb_file","xsb01","","","") 
        RETURNING li_result,g_xsb.xsb01
        
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_xsb.xsb01
      
        BEGIN WORK
           INSERT INTO xsb_file VALUES(g_xsb.*)
           
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,1)   #FUN-B80089
              ROLLBACK WORK
           #   CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,1)   #FUN-B80089
              CONTINUE WHILE
           ELSE
              LET g_xsb01_t = g_xsb.xsb01                   
              SELECT xsb01 INTO g_xsb.xsb01 FROM xsb_file 
               WHERE xsb01 = g_xsb.xsb01 
              COMMIT WORK 
           END IF
 
        CALL cl_flow_notify(g_xsb.xsb01,'I')
        LET g_rec_b=0
        CALL t411_b_fill('1=1')         #單身 
        CALL t411_b()                   #輸入單身
        EXIT WHILE 
      END WHILE
END FUNCTION
 
FUNCTION t411_i(p_cmd)  
   DEFINE    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改
             l_n             LIKE type_file.num5,                 #SMALLINT
             li_result       LIKE type_file.num5
          
   DISPLAY BY NAME g_xsb.xsb01,g_xsb.xsb02,g_xsb.xsb03,g_xsb.xsb04,g_xsb.xsb05,
                   g_xsb.xsb06,g_xsb.xsb07
 
     INPUT BY NAME g_xsb.xsb06    #g_pme031,g_pme032,g_pme033,g_pme034
                 WITHOUT DEFAULTS
 
       BEFORE INPUT
         LET g_before_input_done=FALSE
         LET g_before_input_done=TRUE
 
       ON CHANGE xsb06
          SELECT pme031,pme032,pme033,pme034 INTO g_pme031,g_pme032,g_pme033,g_pme034
              FROM pme_file WHERE pme01 = g_xsb.xsb06
          DISPLAY BY NAME g_pme031,g_pme032,g_pme033,g_pme034       
  
       AFTER FIELD xsb06
          SELECT pme031,pme032,pme033,pme034 INTO g_pme031,g_pme032,g_pme033,g_pme034
              FROM pme_file WHERE pme01 = g_xsb.xsb06
          DISPLAY BY NAME g_pme031,g_pme032,g_pme033,g_pme034
          IF g_xsb.xsb07 != '1' THEN
               CALL cl_err("Warning:","axm_602",1)
               LET g_xsb.* = g_xsb_t.*
          END IF

       AFTER INPUT 
          IF INT_FLAG THEN 
             EXIT INPUT
          END IF
            
       ON ACTION controlz
          CALL cl_show_req_fields()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
          
    END INPUT
END FUNCTION
 
FUNCTION t411_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_xsb.xsb01 TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM 
    CALL g_xsc.clear()
    CALL t411_cs()
    IF INT_FLAG THEN                         #使用者不
        LET INT_FLAG = 0 
        RETURN
    END IF
    OPEN t411_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                    #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_xsb.xsb01 TO NULL
    ELSE
        OPEN t411_count 
        FETCH t411_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t411_fetch('F')                 #讀出TEMP第一筆并顯示
    END IF 
END FUNCTION
 
FUNCTION t411_fetch(p_flag)
DEFINE 
    p_flag          LIKE type_file.chr1                  #處理方式
 
    MESSAGE ""
    CASE p_flag 
        WHEN 'N' FETCH NEXT     t411_b_cs INTO g_xsb.xsb01
        WHEN 'P' FETCH PREVIOUS t411_b_cs INTO g_xsb.xsb01
        WHEN 'F' FETCH FIRST    t411_b_cs INTO g_xsb.xsb01
        WHEN 'L' FETCH LAST     t411_b_cs INTO g_xsb.xsb01
        WHEN '/' 
            IF (NOT g_no_ask) THEN 
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t411_b_cs INTO  g_xsb.xsb01
            LET g_no_ask = FALSE
    END CASE
    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,0)
        INITIALIZE g_xsb.xsb01 TO NULL
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
    SELECT * INTO g_xsb.* FROM xsb_file WHERE xsb01=g_xsb.xsb01
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,0)
        INITIALIZE g_xsb.xsb01 TO NULL
        RETURN
    END IF
    CALL  t411_show()
END FUNCTION 
 
#將資料顯示在畫
FUNCTION t411_show()
   LET g_xsb_t.* = g_xsb.*       
   LET g_xsb_o.* = g_xsb.*      
   DISPLAY BY NAME g_xsb.xsb01,g_xsb.xsb02,g_xsb.xsb03,
                   g_xsb.xsb04,g_xsb.xsb05,g_xsb.xsb06,
                   g_xsb.xsb07,g_xsb.xsb13
      CALL t411_xsb05('d')
      CALL t411_xsb06('d')
      CALL t411_b_fill(g_wc2)              #單身 
      CALL cl_show_fld_cont()                                   
END FUNCTION
 
FUNCTION t411_r()                                                               
 
#   IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_xsb.xsb01)  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_xsb.* FROM xsb_file
        WHERE xsb01=g_xsb.xsb01
 
    IF g_xsb.xsb07='2' THEN 
         CALL cl_err(g_xsb.xsb01,9023,0)
         RETURN
    END IF 
   
    BEGIN WORK
    
    OPEN t411_crl USING g_xsb.xsb01
    IF STATUS THEN
       CALL cl_err("OPEN t411_cl:",STATUS,1)
       CLOSE t411_crl
       ROLLBACK WORK
       RETURN
    END IF
   
  


    FETCH t411_crl INTO g_xsb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,0)
        CLOSE t411_crl
        ROLLBACK WORK
        RETURN
    END IF
    
    CALL t411_show()
 
    IF cl_delh(0,0) THEN                   #確認
         DELETE FROM xsb_file WHERE xsb01=g_xsb.xsb01
         DELETE FROM xsc_file WHERE xsc01=g_xsb.xsb01
         CLEAR FORM
         CALL g_xsc.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         LET g_delete = 'Y'
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN t411_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t411_b_cs
            CLOSE t411_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t411_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t411_b_cs
            CLOSE t411_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t411_b_cs
         IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t411_fetch('L')
         ELSE 
           LET g_jump = g_curs_index 
           LET g_no_ask = TRUE
           CALL t411_fetch('/')
         END IF
      END IF
 
   COMMIT WORK 
   CALL cl_flow_notify(g_xsb.xsb01,'D') 
 
END FUNCTION
 
#單身
FUNCTION t411_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,                #檢查重復用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住
    p_cmd           LIKE type_file.chr1,                #處理狀態
    l_allow_insert  LIKE type_file.num5,                #可新增
    l_allow_delete  LIKE type_file.num5,                #可刪除
    l_str           LIKE type_file.chr20,
    l_img10         LIKE img_file.img10,
    l_ima25         LIKE ima_file.ima25,
    l_cnt           LIKE type_file.num5,
    l_factor        LIKE type_file.num5,
    l_tot           LIKE type_file.num5
 
    LET g_action_choice = ""
                                                                                
#   IF s_shut(0)   THEN RETURN END IF
     
    IF cl_null(g_xsb.xsb01) THEN
        RETURN
    END IF
    IF g_xsb.xsb07 != '1' THEN CALL cl_err('Warning:','axm_602',1) RETURN END IF 
    CALL cl_opmsg('b')
 
#    LET l_allow_insert = cl_detail_input_auth("insert")
#    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql=" SELECT xsc02,xsc03,'',xsc05,xsc04,xsc06, ",
                     "        xsc07,xsc07t,xsc08,xsc09 ",
                     "   FROM xsc_file WHERE xsc01 = ? AND xsc02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t411_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    IF g_rec_b=0 THEN CALL g_xsc.clear() END IF
 
    INPUT ARRAY g_xsc WITHOUT DEFAULTS FROM s_xsc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW= FALSE,   #l_allow_insert,
                    DELETE ROW= FALSE,   #l_allow_delete,
                    APPEND ROW= FALSE)   #l_allow_insert)
    BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
          
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
             
            BEGIN WORK
            OPEN t411_crl USING g_xsb.xsb01
            IF STATUS THEN
               CALL cl_err("OPEN t411_crl:",STATUS,1)
               CLOSE t411_crl
               ROLLBACK WORK 
               RETURN
            END IF
 
            FETCH t411_crl INTO g_xsb.*
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,0)
                ROLLBACK WORK
                CLOSE t411_crl
                RETURN
            END IF

 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_xsc_t.* = g_xsc[l_ac].*  #BACKUP
                OPEN t411_bcl USING g_xsb.xsb01,g_xsc_t.xsc02
                IF STATUS THEN
                   CALL cl_err("OPEN t411_bcl:",STATUS,1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t411_bcl INTO g_xsc[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_xsc_t.xsc02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y" 
                   ELSE  
                      SELECT ima021 INTO g_xsc[l_ac].desc
                        FROM ima_file
                       WHERE ima01 = g_xsc[l_ac].xsc03
                      DISPLAY BY NAME g_xsc[l_ac].desc
                   END IF
                END IF
            END IF
 
#       BEFORE INSERT
#            LET l_n = ARR_COUNT()
#            LET p_cmd='a'
#            INITIALIZE g_xsc[l_ac].* TO NULL
#            LET g_xsc_t.* = g_xsc[l_ac].*         #新輸入資
#            LET g_xsc[l_ac].xsc06=0
#            LET g_xsc[l_ac].xsc05=0
#            LET g_xsc[l_ac].xsc07=0
#            LET g_xsc[l_ac].xsc07t=0
#            
#            CALL cl_show_fld_cont()
#            NEXT FIELD skb02
# 
#       AFTER INSERT
#            IF INT_FLAG THEN
#               CALL cl_err('',9001,0)
#               LET INT_FLAG = 0
#               CANCEL INSERT
#            END IF
            SELECT COUNT(*) INTO l_n FROM xsc_file
                                    WHERE xsc01=g_xsb.xsb01
                                      AND xsc02=g_xsc[l_ac].xsc02
#               IF l_n>0 THEN
#                  CALL cl_err('',-239,0)
#                  LET g_xsc[l_ac].xsc02=g_xsc_t.xsc02
#                  NEXT FIELD skb02
#               END IF
#            INSERT INTO xsc_file(xsc01,xsc02,xsc03,xsc04,xsc05,xsc06,
#                                 xsc07,xsc07t,xsc08) 
#            VALUES(g_xsb.xsb01,g_xsc[l_ac].xsc02,g_xsc[l_ac].xsc03,
#                   g_xsc[l_ac].xsc04,g_xsc[l_ac].xsc05,g_xsc[l_ac].xsc06,
#                   g_xsc[l_ac].xsc07,g_xsc[l_ac].xsc07t,g_xsc[l_ac].xsc08)
#            IF SQLCA.sqlcode THEN
#               CALL cl_err(l_str,SQLCA.sqlcode,0)
#               CANCEL INSERT
#            ELSE
#               MESSAGE 'INSERT O.K'
#               COMMIT WORK
#               LET g_rec_b=g_rec_b+1
#               DISPLAY g_rec_b TO FORMONLY.cnt2
#            END IF
            
#        BEFORE FIELD xsc02
#           IF p_cmd='a'  THEN
#              SELECT max(xsc02)+1
#                 INTO g_xsc[l_ac].xsc02
#                 FROM xsc_file
#                 WHERE xsc01=g_xsb.xsb01
#             IF g_xsc[l_ac].xsc02 IS NULL THEN
#                 LET g_xsc[l_ac].xsc02=1
#             END IF
#           END IF
        
#       AFTER FIELD b
#          SELECT SUM(img10) INTO l_img10 FROM img_file 
#           WHERE img01 = g_xsc[l_ac].xsc03 
#             AND imgplant = g_xsa.g_plant 
#          SELECT ima25 INTO l_ima25 FROM ima_file
#           WHERE ima01 = g_xsc[l_ac].xsc03   
#          CALL s_umfchk(g_xsc[l_ac].xsc03,l_ima25,g_xsc[l_ac].xsc04)                                
#              RETURNING l_cnt,l_factor                                          
#          IF l_cnt = 1 THEN                                                      
#             LET l_factor = 1                                                    
#          END IF                                                                 
#          LET l_tot = l_img10 * l_factor 
#          DISPLAY l_tot TO g_xsc[l_ac].b

        AFTER FIELD xsc09
          #FUN-910088--add--start--
           LET g_xsc[l_ac].xsc09 = s_digqty(g_xsc[l_ac].xsc09,g_xsc[l_ac].xsc04)
           DISPLAY BY NAME g_xsc[l_ac].xsc09
          #FUN-910088--add--end--
           IF g_xsb.xsb07 != '1' THEN
              CALL cl_err("","axm_602",1)
              LET g_xsb.* = g_xsb_t.*
           END IF

           IF NOT cl_null(g_xsc[l_ac].xsc09) THEN 
             IF g_xsc[l_ac].xsc09 > g_xsc[l_ac].xsc05 THEN 
                CALL cl_err("","axm_112",0)
                LET g_xsc[l_ac].xsc09 = g_xsc_t.xsc09
                NEXT FIELD xsc09
             END IF    
           END IF 
        
#        AFTER FIELD xsc08
#          IF g_xsb.xsb07 != '1' THEN
#              CALL cl_err("","axm_602",1)
#              LET g_xsb.* = g_xsb_t.*
#          END IF
#          IF NOT cl_null(g_xsc[l_ac].xsc08) THEN 
#             IF g_xsc[l_ac].xsc08 < g_xsb.xsb02 THEN 
#                CALL cl_err("","axm_113",0) 
#                NEXT FIELD xsc08
#             END IF 
#          END IF         
                           
#        BEFORE DELETE
#          IF g_xsc_t.xsc02 IS NOT NULL  THEN
#             IF NOT cl_delb(0,0) THEN
#                 CANCEL DELETE
#             END IF
#             IF l_lock_sw="Y"  THEN
#                 CALL cl_err("",-263,1)
#                 CANCEL DELETE
#             END IF
#             DELETE FROM xsc_file
#                WHERE xsc01=g_xsb.xsb01
#                  AND xsc02=g_xsc_t.xsc02
#             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#                  CALL cl_err('',SQLCA.sqlcode,0)
#                  ROLLBACK WORK
#                  CANCEL DELETE
#             END IF
#             LET g_rec_b=g_rec_b-1
#             DISPLAY g_rec_b TO FORMONLY.cnt2
#          END IF
#          COMMIT WORK 
 
        ON ROW CHANGE 
          IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG=0
              LET g_xsc[l_ac].*=g_xsc_t.*
              CLOSE t411_bcl
              ROLLBACK WORK
              EXIT INPUT
          END IF




          IF l_lock_sw='Y' THEN
              CALL cl_err('',-263,1)
              LET g_xsc[l_ac].*=g_xsc_t.* 
          ELSE
              UPDATE xsc_file SET xsc02 =g_xsc[l_ac].xsc02,
                                  xsc03 =g_xsc[l_ac].xsc03,
                                  xsc04 =g_xsc[l_ac].xsc04,
                                  xsc05 =g_xsc[l_ac].xsc05,
                                  xsc06 =g_xsc[l_ac].xsc06,
                                  xsc07 =g_xsc[l_ac].xsc07,
                                  xsc07t=g_xsc[l_ac].xsc07t,
                                  xsc08 =g_xsc[l_ac].xsc08,
                                  xsc09 =g_xsc[l_ac].xsc09
              WHERE  xsc01=g_xsb.xsb01 AND xsc02=g_xsc_t.xsc02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  LET g_xsc[l_ac].*=g_xsc_t.* 
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
          LET l_ac=ARR_CURR()
          LET l_ac_t=l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
          


             IF p_cmd='u' THEN
                LET g_xsc[l_ac].*=g_xsc_t.*
             END IF
          
          CLOSE t411_bcl
          ROLLBACK WORK
          EXIT INPUT
      END IF
          CLOSE t411_bcl
          COMMIT WORK
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG                                                      
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE INPUT                                                        
    END INPUT
    
    CLOSE t411_bcl
    COMMIT WORK
    CALL t411_delall()
END FUNCTION
 
FUNCTION t411_delall()
    SELECT COUNT(*) INTO g_cnt FROM xsc_file
      WHERE xsc01=g_xsb.xsb01
   
    IF g_cnt=0 THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM xsb_file WHERE xsb01=g_xsb.xsb01
    END IF
END FUNCTION

FUNCTION t411_b_fill(p_wc)              #BODY FILL UP
  DEFINE   p_wc     STRING       #NO.FUN-910082 
  DEFINE   li_c     LIKE type_file.num5
  DEFINE   l_factor LIKE type_file.num5
  DEFINE   l_ima25  LIKE ima_file.ima25
  DEFINE   l_img10  LIKE img_file.img10
    
    IF p_wc IS NULL THEN
       LET p_wc = '1=1'
    END IF
        
    LET g_sql = 
       "SELECT xsc02,xsc03,'',xsc05,xsc04,xsc06,",
       "       xsc07,xsc07t,xsc08,xsc09",
       "  FROM xsc_file ",   
       " WHERE xsc01='",g_xsb.xsb01,"'",
       " AND ",p_wc CLIPPED
 
    PREPARE t411_prepare2 FROM g_sql      #預備
    DECLARE xsc_cs CURSOR FOR t411_prepare2
 
    CALL g_xsc.clear()
 
    LET g_cnt = 1
 
    FOREACH xsc_cs INTO g_xsc[g_cnt].*   #單身 ARRAY 填
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT ima02 INTO g_xsc[g_cnt].desc FROM ima_file
        WHERE ima01 = g_xsc[g_cnt].xsc03

#       SELECT SUM(img10) INTO l_img10 FROM img_file where img01=g_xsc[g_cnt].xsc03
#          AND imgplant = g_plant
#       CALL s_umfchk(g_xsc[g_cnt].xsc03,l_ima25,g_xsc[g_cnt].xsc04)
#            RETURNING li_c,l_factor
#          IF li_c = 1 THEN
#             LET l_factor = 1
#          END IF
#       LET g_xsc[g_cnt].b = l_img10 * l_factor

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN 
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_xsc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cnt2
    LET g_cnt = 0 
 
END FUNCTION
                  
FUNCTION t411_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN 
      RETURN
   END IF
 
   LET g_action_choice = " " 
  
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xsc TO s_xsc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
   BEFORE DISPLAY 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   BEFORE ROW
       LET l_ac = ARR_CURR()
 
   ##########################################################################
   # Standard 4ad ACTION 
   ##########################################################################
    ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
#    ON ACTION DELETE
#         LET g_action_choice="delete" 
#         EXIT DISPLAY
 
    ON ACTION FIRST
         CALL t411_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION PREVIOUS
         CALL t411_fetch('P') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
    ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
    ON ACTION jump
         CALL t411_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION NEXT
         CALL t411_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
     ON ACTION LAST
         CALL t411_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1) 
         ACCEPT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION reback
         LET g_action_choice="reback"
         EXIT DISPLAY
 
#      ON ACTION notconfirm 
#         LET g_action_choice="notconfirm"
#         EXIT DISPLAY

      ON ACTION help 
         LET g_action_choice="help"
         EXIT DISPLAY 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
     
      ON ACTION EXIT
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
 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
 
    END DISPLAY 
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t411_u()
 
#  IF s_shut(0) THEN
#     RETURN 
#  END IF 
 
   IF g_xsb.xsb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_xsb.* FROM xsb_file
    WHERE xsb01=g_xsb.xsb01 
                                                                                
   IF g_xsb.xsb07 != '1' THEN CALL cl_err('Warning:','axm_602',1) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_xsb01_t = g_xsb.xsb01
 
   BEGIN WORK
 
   OPEN t411_crl USING g_xsb.xsb01
 
   IF STATUS THEN 
      CALL cl_err("OPEN t411_crl:", STATUS, 1)
      CLOSE t411_crl 
      ROLLBACK WORK
      RETURN 
   END IF
  
  

  
 FETCH t411_crl INTO g_xsb.*                      # 鎖住將被更改或取消的資
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_xsb.xsb01,SQLCA.sqlcode,0)    # 資料被他人LOCK 
       CLOSE t411_crl 
       ROLLBACK WORK
       RETURN 
   END IF
                                                                                
   CALL t411_show()
 
   WHILE TRUE
      LET g_xsb01_t = g_xsb.xsb01
      LET g_xsb_o.* = g_xsb.*    
            
      CALL t411_i("u") 
 
     IF INT_FLAG THEN
         LET INT_FLAG = 0 
         LET g_xsb.*=g_xsb_t.* 
         CALL t411_show() 
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      
      IF g_xsb.xsb01!=g_xsb01_t  THEN
         UPDATE xsb_file SET xsb01=g_xsb.xsb01
          WHERE xsb01=g_xsb01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","xsb_file",g_xsb01_t,"",SQLCA.sqlcode,"","xsb",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE xsb_file SET xsb_file.* = g_xsb.*                                  
       WHERE xsb01 = g_xsb01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","xsb_file","","",SQLCA.sqlcode,"","",1)             
         CONTINUE WHILE 
      END IF
      
      CALL t411_xsb06('d') 
 
      EXIT WHILE
   END WHILE
 
   CLOSE t411_crl
   COMMIT WORK
   CALL cl_flow_notify(g_xsb.xsb01,'U')
   
   CALL t411_b_fill("1=1")
 
END FUNCTION
 
FUNCTION t411_xsb05(p_cmd)
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE p_cmd     LIKE type_file.chr1
 
   LET g_errno=''
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = g_xsb.xsb05
   DISPLAY l_pmc03 TO desc_t
          
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_pmc03=NULL
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_pmc03 TO FORMONLY.desc
   END IF       
   
END FUNCTION
 
FUNCTION t411_xsb06(p_cmd)                                                      
   DEFINE l_pme031  LIKE pme_file.pme031,
          l_pme032  LIKE pme_file.pme032,
          l_pme033  LIKE pme_file.pme033,
          l_pme034  LIKE pme_file.pme034,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno=''
   
   SELECT pme031,pme032,pme033,pme034 INTO l_pme031,l_pme032,l_pme033,l_pme034
     FROM pme_file WHERE pme01 = g_xsb.xsb06
 
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_pme031=NULL
                               LET l_pme032=NULL 
                               LET l_pme033=NULL
                               LET l_pme034=NULL 
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_pme031  TO FORMONLY.pme031
     DISPLAY l_pme032  TO FORMONLY.pme032     
     DISPLAY l_pme033  TO FORMONLY.pme033
     DISPLAY l_pme034  TO FORMONLY.pme034
   END IF
END FUNCTION 

 
FUNCTION t411_confirm()
   DEFINE   l_oea       RECORD LIKE oea_file.*
   DEFINE   l_oeb       RECORD LIKE oeb_file.*
   DEFINE   li_i        LIKE type_file.num5
   DEFINE   li_cnt      LIKE type_file.num5
   DEFINE   l_xsb13     LIKE xsb_file.xsb13
   DEFINE   l_xsa05     LIKE xsa_file.xsa05
   DEFINE   l_gec04     LIKE gec_file.gec04
   DEFINE   l_gec07     LIKE gec_file.gec07
   DEFINE   l_azi04     LIKE azi_file.azi04
   DEFINE   l_xsa11     LIKE xsa_file.xsa11
   DEFINE   l_occ44     LIKE occ_file.occ44
   DEFINE   l_occ       RECORD LIKE occ_file.*
   DEFINE   l_occ42     LIKE occ_file.occ42
   DEFINE   li_result   STRING
   DEFINE   l_no        LIKE oea_file.oea01
   DEFINE   l_azw02     LIKE azw_file.azw02
   IF cl_null(g_xsb.xsb01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF

   IF g_xsb.xsb07 != '1' THEN
      CALL cl_err("","axm_603",1)
      RETURN
   END IF
   
   IF NOT cl_null(g_xsb.xsb03) THEN
      INITIALIZE l_oea.* TO NULL
      BEGIN WORK
   #  SELECT xsa05 INTO l_xsa05 FROM xsa_file
      CALL t411_no('axm','30') RETURNING l_no
      CALL s_auto_assign_no("axm",l_no,g_today,"30","oea_file",
                            "oea01","","","")
           RETURNING li_result,l_xsb13
    

      IF (NOT li_result) THEN
         LET g_success = 'N'
         CALL cl_err('','abm-621',0)
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF

      LET l_oea.oea00 ='1'
      LET l_oea.oea01 = l_xsb13
      LET l_oea.oea02 = g_xsb.xsb02
      LET l_oea.oea03 = g_xsb.xsb05
      LET l_oea.oea044 = g_xsb.xsb06
      LET l_oea.oea09 = 0              #允許超交率
      LET l_oea.oea11 = '1'            #訂單來源
      LET l_oea.oea21 = g_xsb.xsb08
      LET l_oea.oea211 = g_xsb.xsb09
      LET l_oea.oea213 = g_xsb.xsb10
      LET l_oea.oea23 = g_xsb.xsb11

 #    SELECT occ44 INTO l_occ44 FROM occ_file WHERE occ01 = g_xsb.xsb05
      SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = g_xsb.xsb05 AND occacti='Y'
      LET l_oea.oea21 = l_occ.occ41
      LET l_oea.oea211 = g_xsb.xsb09
      LET l_oea.oea213 = g_xsb.xsb10
      LET l_oea.oea23 = g_xsb.xsb11

      LET l_oea.oea032 = l_occ.occ02
      LET l_oea.oea04 = l_occ.occ09
      LET l_oea.oea17 = l_occ.occ07
      LET l_oea.oea05 = l_occ.occ08
      LET l_oea.oea21 = l_occ.occ41
      LET l_oea.oea65 = l_occ.occ65
      LET l_oea.oea25 = l_occ.occ43
      LET l_oea.oea31 = l_occ44
      LET l_oea.oea32 = l_occ.occ45
      LET l_oea.oea33 = l_occ.occ46
      LET l_oea.oea34 = l_occ.occ53
      LET l_oea.oea41 = l_occ.occ48
      LET l_oea.oea42 = l_occ.occ49
      LET l_oea.oea43 = l_occ.occ47
      LET l_oea.oea61 = 0              #訂單總未稅金額
      LET l_oea.oea62 = 0              #已出貨未稅金額
      LET l_oea.oea63 = 0              #被結案未稅金額
      LET l_oea.oea85 = '0'            #結算方式
      LET l_oea.oea49 = '0'
      LET l_oea.oeaconf = 'Y'
      LET l_oea.oea37 = 'N'
      LET l_oea.oea50 = 'N'
      LET l_oea.oeamksg = 'N'
      LET l_oea.oea18 = 'N'
      LET l_oea.oea07 = 'N'
      LET l_oea.oea65 = 'N'
      LET l_oea.oea918 = 'N'
      LET l_oea.oea919 = 'N'
      LET l_oea.oea901='N'
      LET l_oea.oeaplant = g_plant
      LET l_oea.oealegal = g_legal
      INSERT INTO oea_file VALUES(l_oea.*)
      IF SQLCA.sqlcode THEN
#        IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
         IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115  add
            CALL cl_err("",-239,0)
         ELSE
            CALL cl_err3("ins","oea_file",g_xsb.xsb01,"",SQLCA.sqlcode,"","",1)
         END IF
         RETURN
      END IF

      LET li_i = 0
      FOR li_cnt = 1 TO g_xsc.getlength()
         IF g_xsc[li_cnt].xsc09 = 0 THEN
            LET li_i = li_i + 1
            CONTINUE FOR
         END IF

         INITIALIZE l_oeb.* TO NULL
         LET l_oeb.oeb01 = l_xsb13
         LET l_oeb.oeb03 = g_xsc[li_cnt].xsc02
         LET l_oeb.oeb04 = g_xsc[li_cnt].xsc03
         LET l_oeb.oeb05 = g_xsc[li_cnt].xsc04
         LET l_oeb.oeb06 = g_xsc[li_cnt].desc
         LET l_oeb.oeb12 = g_xsc[li_cnt].xsc09
         LET l_oeb.oeb13 = g_xsc[li_cnt].xsc06

         SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file
#        SELECT xsa11 INTO l_xsa11 FROM xsa_file
         SELECT occ42 INTO l_occ42 FROM occ_file WHERE occ01=g_plant
         SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = l_occ42

         IF l_gec07 = 'N' THEN
            LET l_oeb.oeb14 = g_xsc[li_cnt].xsc09 * g_xsc[li_cnt].xsc06
            LET l_oeb.oeb14 = cl_digcut(l_oeb.oeb14,l_azi04)
            LET l_oeb.oeb14t = l_oeb.oeb14 * (1 + l_gec04/100)
            LET l_oeb.oeb14t = cl_digcut(l_oeb.oeb14t,l_azi04)
         END IF

         IF l_gec07 = 'Y' THEN
            LET l_oeb.oeb14t = g_xsc[li_cnt].xsc09 * g_xsc[li_cnt].xsc06
            LET l_oeb.oeb14t = cl_digcut(l_oeb.oeb14t,l_azi04)
            LET l_oeb.oeb14 = l_oeb.oeb14t / (1 + l_gec04/100)
            LET l_oeb.oeb14 = cl_digcut(l_oeb.oeb14,l_azi04)
         END IF

#         LET l_oeb.oeb14 = g_xsc[li_cnt].xsc07
#         LET l_oeb.oeb14t= g_xsc[li_cnt].xsc07t
         LET l_oeb.oeb15 = g_xsc[li_cnt].xsc08
        #LET l_oeb.oeb72 = l_oeb.oeb15  #FUN-B20060 add   #CHI-C80060 mark
         LET l_oeb.oeb72 = NULL         #CHI-C80060 add
         LET l_oeb.oeb05_fac = 1      #單位換算率
         LET l_oeb.oeb23 = 0          #待出貨數量
         LET l_oeb.oeb24 = 0          #已出貨數量
         LET l_oeb.oeb25 = 0          #已銷退數量
         LET l_oeb.oeb26 = 0          #被結案數量
         LET l_oeb.oeb44 = '1'        #經營方式
         LET l_oeb.oeb47 = '0'        #分攤折價
         LET l_oeb.oeb48 = '1'        #出貨方式
         LET l_oeb.oeb70 = 'N'
         LET l_oeb.oebplant = g_plant
         LET l_oeb.oeb1003 = '1'
         LET l_oeb.oeblegal = g_legal
         IF cl_null(l_oeb.oeb37 ) OR l_oeb.oeb37 = 0 THEN LET l_oeb.oeb37 = l_oeb.oeb13 END IF    #FUN-AB0061 
         INSERT INTO oeb_file VALUES(l_oeb.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET li_i = li_i + 1
         END IF
      END FOR

      IF li_i = 0 THEN
         CALL cl_err("","axm_110",1)
      ELSE
         IF li_i = g_xsc.getLength() THEN
            DELETE FROM oea_file WHERE oea01 = l_xsb13
            CALL cl_err("","afa-043",1)
            RETURN
         ELSE
            CALL cl_err(li_i,"axm_111",1)
         END IF
      END IF
      UPDATE xsb_file SET xsb13 = l_xsb13 WHERE xsb01 = g_xsb.xsb01
      UPDATE xsb_file SET xsb07 = "2" WHERE xsb01 = g_xsb.xsb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","oeb_file",g_xsb.xsb07,"",SQLCA.sqlcode,"","",1)
      ELSE
         LET g_xsb.xsb07 = "2"
         DISPLAY g_xsb.xsb07 TO FORMONLY.xsb07
         SELECT xsb13 INTO g_xsb.xsb13 FROM xsb_file WHERE xsb01 = g_xsb.xsb01
      END IF
   END IF
END FUNCTION
 
#FUNCTION t411_notconfirm()
#   IF cl_null(g_xsb.xsb01)  THEN
#     CALL cl_err('',-400,0)
#     RETURN 
#   END IF
#    IF g_xsb.xsb07!="2" THEN
#       CALL cl_err("",'atm-365',1)
#    ELSE 
#        IF cl_confirm('aap-224') THEN
#            BEGIN WORK
#            UPDATE xsb_file
#            SET xsb07="1"
#            WHERE xsb01=g_xsb.xsb01
#           IF SQLCA.sqlcode THEN 
#              CALL cl_err3("upd","xsb_file",g_xsb.xsb01,"",SQLCA.sqlcode,"","xsb07",1)
#              ROLLBACK WORK
#          ELSE
#             UPDATE xsb_file SET xsb13 = ' ' WHERE xsb01 = g_xsb.xsb01
#             COMMIT WORK
#             LET g_xsb.xsb07="1"
#             LET g_xsb.xsb13=""
#             DISPLAY g_xsb.xsb07 TO FORMONLY.xsb07
#          END IF
#       END IF
#   END IF
#END FUNCTION

FUNCTION t411_reback()
  DEFINE l_azw01    LIKE azw_file.azw01
  DEFINE l_sql      STRING
  DEFINE l_dbs      STRING
   IF g_xsb.xsb07='3' THEN
      CALL cl_err('','axm-533',0)
      RETURN
   END IF

   IF g_xsb.xsb07 != '1' THEN
      CALL cl_err('','axm_604',1)
      RETURN
    END IF

   IF NOT cl_null(g_xsb.xsb03) THEN
      BEGIN WORK

      SELECT azw01 INTO l_azw01 FROM azw_file WHERE azw07 = g_plant
      IF NOT cl_null(l_azw01) THEN
         LET g_plant_new = l_azw01
         #CALL s_gettrandbs()     #FUN-A50102
         #LET l_dbs=g_dbs_tra     #FUN-A50102
      ELSE
         LET g_plant_new = g_plant
         #CALL s_gettrandbs()     #FUN-A50102
         #LET l_dbs=g_dbs_tra     #FUN-A50102
      END IF
         
      #LET l_sql = "UPDATE ",s_dbstring(l_dbs CLIPPED),"pmm_file",
      LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'pmm_file'), #FUN-A50102
                  " SET pmm25 = '3'",
                  " WHERE pmm01 = '",g_xsb.xsb03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
      PREPARE pmm_pre FROM l_sql
      EXECUTE pmm_pre

#     UPDATE pmm_file SET pmm25="3" 
#      WHERE pmm01=g_xsb.xsb03

      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","pmm_file",g_xsb.xsb03,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
      ELSE
         UPDATE xsb_file SET xsb07="3" 
          WHERE xsb01=g_xsb.xsb01
          

        

        IF SQLCA.sqlcode THEN 
            CALL cl_err3("upd","xsb_file",g_xsb.xsb01,"",SQLCA.sqlcode,"","xsb07",1)
            ROLLBACK WORK
         ELSE
            COMMIT WORK
        


            
            CALL cl_err("","axm_115",1)
            LET g_xsb.xsb07='3'
            DISPLAY g_xsb.xsb07 TO FORMONLY.xsb07
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t411_no(l_rye01,l_rye02)
DEFINE l_dbs   LIKE azp_file.azp03
DEFINE l_rye01 LIKE rye_file.rye01
DEFINE l_rye02 LIKE rye_file.rye02
DEFINE l_sql STRING
DEFINE l_no LIKE rva_file.rva01

   #FUN-C90050 mark begin---
   #LET l_sql = "SELECT rye03 FROM rye_file",
   #            " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'" 
   #PREPARE rye_trans FROM l_sql
   #EXECUTE rye_trans USING l_rye01,l_rye02 INTO l_no
   #FUN-C90050 mark end-----

   CALL s_get_defslip(l_rye01,l_rye02,g_plant,'N') RETURNING l_no   #FUN-C90050 add

   IF cl_null(l_no) THEN
      CALL s_errmsg('rye03',l_no,'rye_file','art-330',1)
      LET g_success = 'N'
      RETURN ''
   END IF
   RETURN l_no
END FUNCTION
#FUN-9B0160--End
