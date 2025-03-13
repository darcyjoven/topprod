# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: axcp012.4gl
# Descriptions...: 料件成本階數設定作業
# Date & Author..: 96/02/15  By  Felicity Tseng
# Modify.........: 98/12/14  BY  ANN CHEN 
# Modify.........: by Ostrich 010430 增加ima12 成本分群維護
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: No.MOD-550126 05/06/16 By kim 隱藏'新增','刪除'
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-740096 07/05/09 By kim 新增ima80 ima39 ima06 三個欄位
# Modify.........: No.TQC-790064 07/09/17 By destiny 修改成本階數可以為負的bug
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-AB0026 10/11/23 By Summer 增加"匯出Excel"功能
# Modify.........: No:FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:MOD-CB0200 12/11/23 By Elise 加上查詢成本分群開窗
# Modify.........: No:FUN-C80092 12/12/04 By xujing 成本相關作業程式日誌
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     m_ima           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ima01       LIKE ima_file.ima01,
        ima25       LIKE ima_file.ima25,
        ima08       LIKE ima_file.ima08,
        ima16       LIKE ima_file.ima16,
        ima57       LIKE ima_file.ima57,
        ima80       LIKE ima_file.ima80,  #FUN-740096
        ima39       LIKE ima_file.ima39,  #FUN-740096
        ima391      LIKE ima_file.ima391, #FUN-740096
        ima06       LIKE ima_file.ima06,  #FUN-740096
        ima58       LIKE ima_file.ima58,
        ima12       LIKE ima_file.ima12
                    END RECORD,
    m_ima_t         RECORD                 #程式變數 (舊值)
        ima01       LIKE ima_file.ima01,
        ima25       LIKE ima_file.ima25,
        ima08       LIKE ima_file.ima08,
        ima16       LIKE ima_file.ima16,
        ima57       LIKE ima_file.ima57,
        ima80       LIKE ima_file.ima80,  #FUN-740096
        ima39       LIKE ima_file.ima39,  #FUN-740096
        ima391      LIKE ima_file.ima391, #FUN-740096
        ima06       LIKE ima_file.ima06,  #FUN-740096
        ima58       LIKE ima_file.ima58,
        ima12       LIKE ima_file.ima12
                    END RECORD,
    g_imaacti       LIKE  ima_file.imaacti,     
    g_imauser       LIKE  ima_file.imauser,     
    g_imagrup       LIKE  ima_file.imagrup,     
    g_imamodu       LIKE  ima_file.imamodu,     
    g_imadate       LIKE  ima_file.imadate,     
    g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_sl            LIKE type_file.num5           #No.FUN-680122 SMALLINT          #目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_cka00      LIKE cka_file.cka00    #FUN-C80092 add
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW p012_w WITH FORM "axc/42f/axcp012"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("ima391",g_aza.aza63='Y')  #FUN-740096
 
    LET g_wc2 = '1=1'
    CALL p012_menu()
    CLOSE WINDOW p012_w                 #結束畫面
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p012_menu()
   WHILE TRUE
      CALL p012_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL p012_q() 
            END IF
         WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL p012_b() 
           ELSE
              LET g_action_choice = NULL
           END IF
#        WHEN "G.產生" 
#           IF cl_chk_act_auth() THEN
#              CALL p012_upima57() 
#           END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL p012_out() 
            END IF
         WHEN "help"  CALL cl_show_help()
         WHEN "exit" EXIT WHILE
         WHEN "controlg" CALL cl_cmdask()
         #CHI-AB0026 add --start--
         WHEN "exporttoexcel"
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(m_ima),'','')
         #CHI-AB0026 add --end--
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p012_q()
   CALL p012_b_askkey()   
END FUNCTION
 
FUNCTION p012_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680122 VARCHAR(1)
    l_jump          LIKE type_file.num5,                                          #No.FUN-680122 SMALLINT,              #判斷是否跳過AFTER ROW的處理
    l_allow_insert  LIKE type_file.num5,                #可新增否                 #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                 #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    #FUN-740096............begin
    IF g_rec_b=0 THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    #FUN-740096............end
    CALL cl_opmsg('b')    
 
    LET g_forupd_sql = "SELECT ima01,ima25,ima08,ima16,ima57,ima80,ima39,ima391,ima06,ima58,ima12 ",  #FUN-740096
                       " FROM ima_file  ",
                       " WHERE ima01 = ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p012_bcl CURSOR FROM g_forupd_sql
 
         #MOD-550126................begin
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete")
        LET l_allow_insert = False
        LET l_allow_delete = False
         #MOD-550126................begin
 
        INPUT ARRAY m_ima WITHOUT DEFAULTS FROM s_ima.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            LET l_lock_sw = 'N'
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET m_ima_t.*=m_ima[l_ac].*
               CALL s_log_ins(g_prog,'','',g_wc2,'') RETURNING g_cka00          #FUN-C80092 add
               BEGIN WORK
 
               OPEN p012_bcl USING  m_ima_t.ima01
               IF STATUS THEN
                   CALL cl_err("OPEN p012_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH p012_bcl INTO m_ima[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(m_ima_t.ima01,SQLCA.sqlcode,1)
                      LET l_lock_sw='Y' 
                   END IF
               END IF
               SELECT imaacti,imauser,imagrup,imadate,imamodu 
                 INTO g_imaacti,g_imauser,g_imagrup,g_imadate,g_imamodu 
                 FROM ima_file WHERE ima01 = m_ima[l_ac].ima01 
               IF cl_null(g_imauser) THEN LET g_imauser = g_user END IF 
               #使用者所屬群
               IF cl_null(g_imagrup) THEN LET g_imagrup = g_grup END IF
               IF cl_null(g_imadate) THEN LET g_imadate = g_today END IF 
               DISPLAY  g_imauser,g_imagrup,g_imadate,g_imamodu 
                    TO    imauser,  imagrup,  imadate ,  imamodu 
               CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
        AFTER FIELD ima57
            IF m_ima_t.ima57 != m_ima[l_ac].ima57 THEN 
		LET g_imamodu = g_user                     #修改者
		LET g_imadate = g_today                  #修改日期
                DISPLAY  g_imamodu,g_imadate
                     TO    imamodu,  imadate
#No.TQC-790064--start-- 
                IF m_ima[l_ac].ima57 <0 THEN 
                   CALL cl_err('','axc-207',1)                                                                                       
                  NEXT FIELD ima57                                                                                                  
               END IF 
#No.TQC-790064--end-- 
            END IF 
 
     #  BEFORE FIELD ima58
     #         LET m_ima[l_ac].ima57 = m_ima_t.ima57
     #         DISPLAY m_ima[l_ac].ima57 TO s_ima[l_sl].ima57
     #        #NEXT FIELD ima57
 
        #FUN-740096...............begin
        AFTER FIELD ima39
            IF NOT cl_null(m_ima[l_ac].ima39) THEN
               SELECT COUNT(*) INTO g_cnt FROM aag_file
                      WHERE aag01 = m_ima[l_ac].ima39
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza81
               IF SQLCA.sqlcode THEN
                  LET g_cnt=0
               END IF
               IF g_cnt=0 THEN
#FUN-B10052 --begin--               
#                 CALL cl_err(m_ima[l_ac].ima39,"anm-001",1)
                  CALL cl_err(m_ima[l_ac].ima39,"anm-001",0)
                  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_aag"
                 LET g_qryparam.default1 = m_ima[l_ac].ima39
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1     = g_aza.aza81
                 LET g_qryparam.where = " aag07 != '1' AND aag01 LIKE '",m_ima[l_ac].ima39 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING m_ima[l_ac].ima39
                 DISPLAY BY NAME m_ima[l_ac].ima39                  
#FUN-B10052 --end--
                  NEXT FIELD ima39
               END IF
            END IF

        AFTER FIELD ima391
            IF NOT cl_null(m_ima[l_ac].ima391) THEN
               SELECT COUNT(*) INTO g_cnt FROM aag_file
                      WHERE aag01 = m_ima[l_ac].ima391
                         AND aag07 != '1'
                         AND aag00 = g_aza.aza81
               IF SQLCA.sqlcode THEN
                  LET g_cnt=0
               END IF
               IF g_cnt=0 THEN
#FUN-B10052 --begin--
#                 CALL cl_err(m_ima[l_ac].ima391,"anm-001",1) 
                  CALL cl_err(m_ima[l_ac].ima391,"anm-001",0) 
                  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_aag"
                 LET g_qryparam.default1 = m_ima[l_ac].ima391
                 LET g_qryparam.construct = 'N'                 
                 LET g_qryparam.arg1     = g_aza.aza82
                 LET g_qryparam.where = " aag07 != '1' AND aag01 LIKE '",m_ima[l_ac].ima391 CLIPPED,"%'"                 
                 CALL cl_create_qry() RETURNING m_ima[l_ac].ima391
                 DISPLAY BY NAME m_ima[l_ac].ima391
#FUN-B10052 --end--                  
                  NEXT FIELD ima391                  
               END IF
            END IF
        #FUN-740096...............end
 
        AFTER FIELD ima58
            IF m_ima_t.ima58 != m_ima[l_ac].ima58 THEN
                LET g_imamodu = g_user
                LET g_imadate = g_today
                DISPLAY g_imamodu,g_imadate
                     TO   imamodu,  imadate
#No.TQC-790064--start--                                                                                                             
                IF m_ima[l_ac].ima58 <0 THEN                                                                                        
                   CALL cl_err('','axc-207',1)                                                                                      
                   NEXT FIELD ima58                                                                                                  
                END IF                                                                                                               
#No.TQC-790064--end-- 
            END IF
 
#add by Ostrich 010430
        AFTER FIELD ima12
            SELECT COUNT(*) INTO l_n FROM azf_file
             WHERE azf01=m_ima[l_ac].ima12 AND azf02='G' #6808
               AND azfacti='Y'
            IF l_n = 0 THEN
               CALL cl_err(m_ima[l_ac].ima12,'mfg1306',0)
               LET m_ima[l_ac].ima12 = m_ima_t.ima12
               DISPLAY BY NAME m_ima[l_ac].ima12
               NEXT FIELD ima12
            END IF
            IF m_ima_t.ima12 != m_ima[l_ac].ima12 THEN
                LET g_imamodu = g_user
                LET g_imadate = g_today
                DISPLAY g_imamodu,g_imadate
                     TO   imamodu,  imadate
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET m_ima[l_ac].* = m_ima_t.*
               CLOSE p012_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(m_ima[l_ac].ima01,-263,1)
               LET m_ima[l_ac].* = m_ima_t.*
            ELSE
                UPDATE ima_file SET ima57  = m_ima[l_ac].ima57,
                                 ima39 = m_ima[l_ac].ima39,  #FUN-740096
                                 ima391= m_ima[l_ac].ima391,  #FUN-740096
                                 imauser = g_imauser, 
                                 imagrup = g_imagrup, 
                                 imadate = g_imadate, 
                                 imamodu = g_imamodu,
                                 ima58   = m_ima[l_ac].ima58,      #Adding
                                 ima12   = m_ima[l_ac].ima12       #adding
                       WHERE ima01=m_ima[l_ac].ima01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(m_ima[l_ac].ima01,SQLCA.sqlcode,1)   #No.FUN-660127
#                   CALL cl_err3("upd","ima_file",m_ima_t.ima01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660127   #No.FUN-710027 
                   CALL s_errmsg('ima01',m_ima_t.ima01,'upd ima:',SQLCA.sqlcode,1)                           #No.FUN-710027 
                   ROLLBACK WORK
                   CALL s_log_upd(g_cka00,'N')    #FUN-C80092 add
                ELSE
                   COMMIT WORK
                   CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET m_ima[l_ac].* = m_ima_t.*
               END IF
               CLOSE p012_bcl
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')    #FUN-C80092 add
               EXIT INPUT
            END IF
            CLOSE p012_bcl
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')    #FUN-C80092 add

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ima12) #其他分群碼四
#                CALL q_azf(10,3,m_ima[l_ac].ima12,'G') RETURNING m_ima[l_ac].ima12
#                CALL FGL_DIALOG_SETBUFFER( m_ima[l_ac].ima12 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf"
                 LET g_qryparam.default1 = m_ima[l_ac].ima12
                 LET g_qryparam.arg1 = "G"
                 CALL cl_create_qry() RETURNING m_ima[l_ac].ima12
#                 CALL FGL_DIALOG_SETBUFFER( m_ima[l_ac].ima12 )
                 DISPLAY BY NAME m_ima[l_ac].ima12 
                 NEXT FIELD ima12
              #FUN-740096.....................begin
              WHEN INFIELD(ima39)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_aag"
                 LET g_qryparam.default1 = m_ima[l_ac].ima39
                 LET g_qryparam.arg1     = g_aza.aza81
                 CALL cl_create_qry() RETURNING m_ima[l_ac].ima39
                 DISPLAY BY NAME m_ima[l_ac].ima39
                 NEXT FIELD ima39
              WHEN INFIELD(ima391)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_aag"
                 LET g_qryparam.default1 = m_ima[l_ac].ima391
                 LET g_qryparam.arg1     = g_aza.aza82
                 CALL cl_create_qry() RETURNING m_ima[l_ac].ima391
                 DISPLAY BY NAME m_ima[l_ac].ima391
                 NEXT FIELD ima391
              #FUN-740096.....................end
           END CASE
 
       #ON ACTION CONTROLN
       #    CALL p012_b_askkey()
       #    EXIT INPUT
 
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
 
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
END FUNCTION
 
FUNCTION p012_b_askkey()
    CLEAR FORM
    CALL m_ima.clear()
    CONSTRUCT g_wc2 ON ima01,ima25,ima08,ima16,ima57,ima80,ima39,ima391,ima06,   #FUN-740096
                       ima58 ,ima12
            FROM s_ima[1].ima01,s_ima[1].ima25,s_ima[1].ima08,
                 s_ima[1].ima16,s_ima[1].ima57,
                 s_ima[1].ima80,s_ima[1].ima39,s_ima[1].ima391,s_ima[1].ima06,  #FUN-740096
                 s_ima[1].ima58,s_ima[1].ima12
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #FUN-740096...............begin
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima39)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima39
                  NEXT FIELD ima39
               WHEN INFIELD(ima391)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_aag"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima391
                  NEXT FIELD ima391
              #MOD-CB0200---add---S
               WHEN INFIELD(ima12) #其他分群碼四
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf"
                  LET g_qryparam.arg1 = "G"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima12
                  NEXT FIELD ima12
              #MOD-CB0200---add---E
            END CASE
         #FUN-740096...............end
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL p012_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p012_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200) 
 
    LET g_sql =
        "SELECT ima01,ima25,ima08,ima16,ima57,ima80,ima39,ima391,ima06,ima58,ima12",  #FUN-740096
        " FROM ima_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE p012_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR p012_pb
 
    CALL m_ima.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ima_curs INTO m_ima[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL m_ima.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p012_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
#     ON ACTION 產生
#        LET g_action_choice="產生"
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #CHI-AB0026 add --start--
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #CHI-AB0026 add --end--
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
# Elvis Add 
 
FUNCTION p012_upima57()
   DEFINE l_n  LIKE type_file.num10,          #No.FUN-680122 INTEGER
          l_str LIKE cre_file.cre08           #No.FUN-680122 VARCHAR(10)
 
   IF g_rec_b IS NULL THEN LET g_rec_b = 0 END IF 
   IF g_rec_b = 0 THEN RETURN END IF 
   IF NOT cl_sure(20,20) THEN RETURN END IF 
   FOR l_n = 1 to g_rec_b
       MESSAGE m_ima[l_n].ima01
       CALL ui.Interface.refresh()
       LET l_str = m_ima[l_n].ima16
       LET m_ima[l_n].ima57 = l_str[1,2]
       UPDATE ima_file SET ima57 = m_ima[l_n].ima57 , 
		   imamodu = g_user ,                   #修改者
		   imadate = g_today                  #修改日期
              WHERE ima01 = m_ima[l_n].ima01
       IF SQLCA.sqlcode THEN 
#         CALL cl_err("UPDATE ERROR ",SQLCA.sqlcode,1)   #No.FUN-660127
          CALL cl_err3("upd","ima_file",m_ima[l_n].ima01,"",SQLCA.sqlcode,"","UPDATE ERROR",1)   #No.FUN-660127
          EXIT FOR 
       END IF 
   END FOR 
   MESSAGE ""
   CALL p012_b_fill(g_wc2)
END FUNCTION 
   
FUNCTION p012_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),               # External(Disk) file name
        l_ima   RECORD LIKE ima_file.*,
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),               #
        l_chr           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axcp012') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ima_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p012_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p012_co  CURSOR FOR p012_p1
 
    START REPORT p012_rep TO l_name
 
    FOREACH p012_co INTO l_ima.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT p012_rep(l_ima.*)
    END FOREACH
 
    FINISH REPORT p012_rep
 
    CLOSE p012_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p012_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
        sr RECORD LIKE ima_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ima01
    FORMAT
        PAGE HEADER
           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
           LET g_pageno=g_pageno+1
           LET pageno_total=PAGENO USING '<<<','/pageno'
           PRINT g_head CLIPPED,pageno_total
           PRINT 
           PRINT g_dash
           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                 g_x[36],g_x[37],g_x[38],g_x[39]
           PRINT g_dash1
           LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.ima01,
               COLUMN g_c[32],sr.ima02,
               COLUMN g_c[33],sr.ima021,
               COLUMN g_c[34],sr.ima25,
               COLUMN g_c[35],sr.ima08,
               COLUMN g_c[36],sr.ima16 using '##&',
               COLUMN g_c[37],sr.ima57 using '##&',
               COLUMN g_c[38],sr.ima58 using '###&.&&&',
               COLUMN g_c[39],sr.ima12
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc2,'ima01,ima25,ima08,ima16,ima57,ima58')
                 RETURNING g_sql
            PRINT g_dash
            #TQC-630166
            {
            IF g_sql[001,080] > ' ' THEN
                    PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
            IF g_sql[071,140] > ' ' THEN
                    PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
            IF g_sql[141,210] > ' ' THEN
                    PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
            }
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
 
         END IF
         PRINT g_dash
         LET l_trailer_sw = 'n'
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
     PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
             PRINT g_dash
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
             SKIP 2 LINE
         END IF
END REPORT
