# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apjt205.4gl
# Descriptions...: 活動預計設備需求維護 
# Date & Author..: No.FUN-790025 2007/11/12 By ChenMoyan
# Modified.......: No.TQC-840009 2008/04/08 By ChenMoyan 顯示網絡名稱和活動名稱
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-960094 09/06/11 By lilingyu 單身的BEGIN WORK放到外面
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0142 09/12/17 By jan 單身寫入時，出現-236，欄位數量不合
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0215 10/11/30 By lixh1 修改INSERT INTO字段不對應
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_pjmb1         RECORD   
        pjmb01       LIKE pjmb_file.pjmb01,
        pjmb02       LIKE pjmb_file.pjmb02
                     END RECORD,
    g_pjmb1_t        RECORD   
        pjmb01       LIKE pjmb_file.pjmb01,
        pjmb02       LIKE pjmb_file.pjmb02
                     END RECORD,
    g_pjmb1_o        RECORD   
        pjmb01       LIKE pjmb_file.pjmb01,
        pjmb02       LIKE pjmb_file.pjmb02
                     END RECORD,
 
 
    g_pjmb           DYNAMIC ARRAY OF RECORD
        pjmb03       LIKE pjmb_file.pjmb03,
        pjmb04       LIKE pjmb_file.pjmb04,
        pjy02        LIKE pjy_file.pjy02,
        pjmb05       LIKE pjmb_file.pjmb05,
        pjy03        LIKE pjy_file.pjy03,
        pjy04        LIKE pjy_file.pjy04,
        pjmb06       LIKE pjmb_file.pjmb06,
        amt          LIKE type_file.num20_6,
        pjmbacti     LIKE pjmb_file.pjmbacti
                     END RECORD,
    g_pjmb_t         RECORD
        pjmb03       LIKE pjmb_file.pjmb03,                                                                                         
        pjmb04       LIKE pjmb_file.pjmb04,                                                                                         
        pjy02        LIKE pjy_file.pjy02,                                                                                           
        pjmb05       LIKE pjmb_file.pjmb05,                                                                                         
        pjy03        LIKE pjy_file.pjy03,                                                                                           
        pjy04        LIKE pjy_file.pjy04,                                                                                           
        pjmb06       LIKE pjmb_file.pjmb06,                                                                                         
        amt          LIKE type_file.num20_6,
        pjmbacti     LIKE pjmb_file.pjmbacti                                                                                       
                     END RECORD,             
    g_pjmb_o         RECORD
        pjmb03       LIKE pjmb_file.pjmb03,                                                                                         
        pjmb04       LIKE pjmb_file.pjmb04,                                                                                         
        pjy02        LIKE pjy_file.pjy02,                                                                                           
        pjmb05       LIKE pjmb_file.pjmb05,                                                                                         
        pjy03        LIKE pjy_file.pjy03,                                                                                           
        pjy04        LIKE pjy_file.pjy04,                                                                                           
        pjmb06       LIKE pjmb_file.pjmb06,                                                                                         
        amt          LIKE type_file.num20_6,
        pjmbacti     LIKE pjmb_file.pjmbacti                                                                                       
                     END RECORD,           
 
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,
    l_ac             LIKE type_file.num5,
    p_row,p_col      LIKE type_file.num5,
    g_argv1          LIKE pjmb_file.pjmb01,
    g_argv2          LIKE pjmb_file.pjmb02 
    
DEFINE g_forupd_sql         STRING       #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt                LIKE type_file.num10 
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10 
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5 
DEFINE g_chr               LIKE type_file.chr1
 
 
MAIN
DEFINE p_row,p_col          LIKE type_file.num5 
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_pjmb1.pjmb01 = g_argv1
   LET g_pjmb1.pjmb02 = g_argv2
   INITIALIZE g_pjmb1.pjmb01 TO NULL
 
   LET g_forupd_sql = "SELECT pjmb01,pjmb02 FROM pjmb_file",
                      " WHERE pjmb01=? AND pjmb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t205_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW t205_w AT p_row,p_col
        WITH FORM "apj/42f/apjt205"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN             
      SELECT count(*) INTO g_cnt FROM pjmb_file WHERE pjmb01=g_argv1 AND pjmb02 = g_argv2 
      IF g_cnt >0 THEN                                                                                                                 
         CALL t205_q()                                                                                                                 
      ELSE                                                                                                                             
         CALL t205_show()                                                                                                              
         CALL t205_b()        
         LET g_argv1 = ""                                                                                                                 
         LET g_argv2 = ""                                                                                                         
      END IF           
   END IF               
   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN                                       
      SELECT count(*) INTO g_cnt FROM pjmb_file WHERE pjmb01=g_argv1        
      IF g_cnt >0 THEN                                                                                                              
         CALL t205_q()                                                                                                              
      ELSE 
         CALL cl_err("",100,0)
      END IF
   END IF
   CALL t205_menu()
   CLOSE WINDOW t205_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION t205_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_pjmb.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_pjmb1.pjmb01 TO NULL
   INITIALIZE g_pjmb1.pjmb02 TO NULL
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_wc = "pjmb01='",g_argv1,"' AND pjmb02 = '",g_argv2,"'" 
      LET g_wc2 = " 1=1 "
   ELSE
     #No.TQC-840009 --Begin
     # IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN                                                                                
     #    LET g_wc = "pjmb01='",g_argv1,"'"     
     #    LET g_wc2 = " 1=1 "                                                             
     # ELSE   
     #No.TQC-840009 --End
         CONSTRUCT BY NAME g_wc ON pjmb01,pjmb02
       
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
             
           ON ACTION controlp
              CASE
                WHEN INFIELD(pjmb01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjk"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pjmb01
                   NEXT FIELD pjmb01
                WHEN INFIELD(pjmb02)                                                                                                 
                   CALL cl_init_qry_var()                                                                                           
                   LET g_qryparam.state = "c"                                                                                       
                   LET g_qryparam.form = "q_pjk" 
                   LET g_qryparam.multiret_index = 2                                                                                   
                   CALL cl_create_qry() RETURNING g_qryparam.multiret         
                   LET g_qryparam.multiret_index = 1                                                      
                   DISPLAY g_qryparam.multiret TO pjmb02                                                                            
                   NEXT FIELD pjmb02   
                OTHERWISE EXIT CASE
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
     RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND pjmbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pjmbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND pjmbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('jmbuser', 'jmbgrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON pjmb03,pjmb04,pjmb05,pjmb06,pjmbacti
     FROM tb2[1].pjmb03,tb2[1].pjmb04,
          tb2[1].pjmb05,tb2[1].pjmb06,tb2[1].pjmbacti
 
       BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjmb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjy"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjmb04
                  NEXT FIELD pjmb04
               OTHERWISE EXIT CASE
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
 # END IF      #No.TQC-840009
END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_sql = "SELECT UNIQUE pjmb01,pjmb02 ",
               " FROM pjmb_file ",
               " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
               " ORDER BY pjmb01"
   PREPARE t205_prepare FROM g_sql
   DECLARE t205_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t205_prepare
 
  IF g_wc2 = " 1=1" THEN
       LET g_sql_tmp="SELECT UNIQUE pjmb01,pjmb02 FROM pjmb_file WHERE ",g_wc CLIPPED,
                 " INTO TEMP x"
   ELSE
       LET g_sql_tmp="SELECT UNIQUE pjmb01,pjmb02 FROM pjmb_file WHERE ",
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"
   END IF
   
   DROP TABLE x                            
   PREPARE t205_precount_x FROM g_sql_tmp  
   EXECUTE t205_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t205_precount FROM g_sql
   DECLARE t205_count CURSOR FOR t205_precount
END FUNCTION
 
 
FUNCTION t205_menu()
 
   WHILE TRUE
      CALL t205_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t205_q()
            END IF
         
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t205_r()
            END IF
         
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t205_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "output"
            IF cl_chk_act_auth() THEN      
               CALL t205_out()                                                                                         
            END IF           
         
         WHEN "help"
            CALL cl_show_help()
         
         WHEN "exit"
            EXIT WHILE
         
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjmb),'','')
            END IF
         
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_pjmb1.pjmb01 IS NOT NULL THEN
                LET g_doc.column1 = "pjmb01"
                LET g_doc.value1 = g_pjmb1.pjmb01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t205_pjmb01(p_cmd)
   DEFINE  l_pjj02     LIKE pjj_file.pjj02,
           l_pjk03     LIKE pjk_file.pjk03,
           l_pjk16     LIKE pjk_file.pjk16,
           l_pjk17     LIKE pjk_file.pjk17,
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      SELECT pjj02,pjk03,pjk16,pjk17                                                                                             
      INTO l_pjj02,l_pjk03,l_pjk16,l_pjk17                                                                                       
      FROM pjj_file,pjk_file WHERE pjj01=g_argv1 AND pjk02=g_argv2
   ELSE
   #No.TQC-840009 --Begin
   #   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
   #      SELECT pjj02,pjk03,pjk16,pjk17                                                                                                
   #      INTO l_pjj02,l_pjk03,l_pjk16,l_pjk17                                                                                       
   #      FROM pjj_file,pjk_file WHERE pjj01=g_argv1 AND pjk02=g_pjmb1.pjmb02
   #   ELSE  
   #No.TQC-840009 --End
         SELECT pjj02,pjk03,pjk16,pjk17
         INTO l_pjj02,l_pjk03,l_pjk16,l_pjk17
         FROM pjj_file,pjk_file WHERE pjj01=g_pjmb1.pjmb01 AND pjk02=g_pjmb1.pjmb02 AND pjj01=pjk01
   #  END IF     #No.TQC-840009
   END IF
 
   CASE WHEN SQLCA.SQLCODE = 100 # LET g_errno = 'apj-004'
                                   LET l_pjj02   = NULL
                                   LET l_pjk03   = NULL
                                   LET l_pjk16   = NULL
                                   LET l_pjk17   = NULL
             OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      DISPLAY l_pjj02  TO FORMONLY.pjj02
      DISPLAY l_pjk03  TO FORMONLY.pjk03 
      DISPLAY l_pjk16  TO FORMONLY.pjk16
      DISPLAY l_pjk17  TO FORMONLY.pjk17
   END IF
 
END FUNCTION
 
 
FUNCTION t205_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjmb1.pjmb01 TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjmb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   
   CALL t205_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjmb1.pjmb01=NULL
      RETURN
   END IF
   
   OPEN t205_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjmb1.pjmb01=NULL
   ELSE
      OPEN t205_count
      FETCH t205_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t205_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
 
FUNCTION t205_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t205_cs INTO g_pjmb1.pjmb01,g_pjmb1.pjmb02
      WHEN 'P' FETCH PREVIOUS t205_cs INTO g_pjmb1.pjmb01,g_pjmb1.pjmb02
      WHEN 'F' FETCH FIRST    t205_cs INTO g_pjmb1.pjmb01,g_pjmb1.pjmb02
      WHEN 'L' FETCH LAST     t205_cs INTO g_pjmb1.pjmb01,g_pjmb1.pjmb02
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0 
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
         FETCH ABSOLUTE g_jump t205_cs INTO g_pjmb1.pjmb01,g_pjmb1.pjmb02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjmb1.pjmb01,SQLCA.sqlcode,0)
      INITIALIZE g_pjmb1.pjmb01 TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   
   CALL t205_show()
 
END FUNCTION
 
 
FUNCTION t205_show()
   LET g_pjmb1_t.* = g_pjmb1.*
   LET g_pjmb1_o.* = g_pjmb1.*
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      LET g_pjmb1.pjmb01 = g_argv1
      LET g_pjmb1.pjmb02 = g_argv2
   ELSE
      IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
         LET g_pjmb1.pjmb01 = g_argv1
      END IF
   END IF 
   DISPLAY BY NAME g_pjmb1.*         #單頭
   CALL t205_pjmb01('d')
   #-->顯示單頭值
   CALL t205_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t205_b()
DEFINE
   l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT 
   l_n             LIKE type_file.num5,       #檢查重複用 
   l_cnt           LIKE type_file.num5,       #檢查重複用 
   l_flag          LIKE type_file.chr1,      
   l_lock_sw       LIKE type_file.chr1,       #單身鎖
   p_cmd           LIKE type_file.chr1,       #處理狀態 
   l_allow_insert  LIKE type_file.num5,       #可新增否
   l_allow_delete  LIKE type_file.num5,       #可刪除否 
   l_msg           LIKE type_file.chr1000
   
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_pjmb1.pjmb01) THEN
      RETURN
   END IF
   IF cl_null(g_pjmb1.pjmb02) THEN
      RETURN
   END IF 
 
   LET g_pjmb1_t.pjmb01=g_pjmb1.pjmb01
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT pjmb03,pjmb04,'',pjmb05,'','',pjmb06,'',pjmbacti",
                      "        FROM pjmb_file",
                      " WHERE pjmb01=? AND pjmb02=? AND pjmb03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t205_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjmb WITHOUT DEFAULTS FROM tb2.*
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
         BEGIN WORK                    #TQC-960094     
         IF g_rec_b >= l_ac THEN
#           BEGIN WORK                 #TQC-960094
            LET p_cmd='u'
            LET g_pjmb_t.* = g_pjmb[l_ac].*  #BACKUP
            LET g_pjmb_o.* = g_pjmb[l_ac].*  #BACKUP
 
            OPEN t205_cl USING g_pjmb1.pjmb01,g_pjmb1.pjmb02
            IF STATUS THEN
               CALL cl_err("OPEN t205_cl:", STATUS, 1)
               CLOSE t205_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t205_cl INTO g_pjmb1.*     # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pjmb1.pjmb01,SQLCA.sqlcode,0)
               CLOSE t205_cl
               ROLLBACK WORK
               RETURN
            END IF
            LET p_cmd='u'
 
            OPEN t205_bcl USING g_pjmb1.pjmb01,g_pjmb1.pjmb02,g_pjmb[l_ac].pjmb03
            IF STATUS THEN
               CALL cl_err("OPEN t205_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t205_bcl INTO g_pjmb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjmb1.pjmb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT pjy02,pjy03,pjy04 INTO g_pjmb[l_ac].pjy02,g_pjmb[l_ac].pjy03,g_pjmb[l_ac].pjy04 
                  FROM pjy_file
                  WHERE pjy01 = g_pjmb[l_ac].pjmb04 AND pjyacti = "Y"
               LET g_pjmb[l_ac].amt = g_pjmb[l_ac].pjy04*g_pjmb[l_ac].pjmb06 
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjmb[l_ac].* TO NULL
         LET g_pjmb[l_ac].pjmb05 =  1 
         LET g_pjmb[l_ac].pjmb06 =  0 
         LET g_pjmb[l_ac].pjmbacti =  'Y'        #Body default
         LET g_pjmb_t.* = g_pjmb[l_ac].*         #新輸入資料
         LET g_pjmb_o.* = g_pjmb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         NEXT FIELD pjmb03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjmb_file
             VALUES(g_pjmb1.pjmb01,g_pjmb1.pjmb02,g_pjmb[l_ac].pjmb03,
                    g_pjmb[l_ac].pjmb04,g_pjmb[l_ac].pjmb05,g_pjmb[l_ac].pjmb06,
                    g_pjmb[l_ac].pjmbacti,g_today,
                  # g_grup,'',g_user,g_grup,g_user, g_user, g_grup)  #TQC-9C0142      #No.FUN-980030 10/01/04  insert columns oriu, orig     #TQC-AB0215
                    g_grup,'',g_user,g_grup,g_user)     #TQC-AB0215
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjmb_file",g_pjmb1.pjmb02,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD pjmb03                        #default 序號
         IF cl_null(g_pjmb[l_ac].pjmb03) THEN
            SELECT max(pjmb03)+1 INTO g_pjmb[l_ac].pjmb03
              FROM pjmb_file 
             WHERE pjmb01 = g_pjmb1.pjmb01 AND pjmb02 = g_pjmb1.pjmb02
            IF cl_null(g_pjmb[l_ac].pjmb03) THEN
               LET g_pjmb[l_ac].pjmb03 = 1
            END IF
         END IF
 
      AFTER FIELD pjmb03                        #check 是否重複
         IF NOT cl_null(g_pjmb[l_ac].pjmb03) THEN
            IF g_pjmb[l_ac].pjmb03 != g_pjmb_t.pjmb03 OR g_pjmb_t.pjmb03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjmb_file
                WHERE pjmb03 = g_pjmb[l_ac].pjmb03 AND pjmb01 = g_pjmb1.pjmb01
                      AND pjmb02 = g_pjmb1.pjmb02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjmb[l_ac].pjmb03 = g_pjmb_t.pjmb03
                  NEXT FIELD pjmb03
               END IF
               IF g_pjmb[l_ac].pjmb03 <= 0 THEN
                  CALL cl_err('pjmb03','aec-994',0)
                  NEXT FIELD pjmb03
               END IF
            END IF
         END IF
 
      AFTER FIELD pjmb04                  #料件編號
         SELECT count(*) INTO l_cnt FROM pjy_file                                                                            
            WHERE pjy01=g_pjmb[l_ac].pjmb04                                                                                       
                  IF l_cnt = 0 THEN                                                                                                 
                     LET l_msg = g_pjmb[l_ac].pjmb04 clipped using '###&'                                                                
                     CALL cl_err(l_msg,'apj-004',0)                                                                                 
                     LET g_pjmb[l_ac].pjmb04 = g_pjmb_t.pjmb04                                                                          
                     DISPLAY BY NAME g_pjmb[l_ac].pjmb04         
                     NEXT FIELD pjmb04                                                                                              
                  END IF                                  
         LET g_pjmb_o.pjmb03 = g_pjmb[l_ac].pjmb03
         CALL t205_pjmb04('d')                                                                                          
         CALL t205_pjmb06()
         CALL t205_set_no_entry(p_cmd)
         
      BEFORE FIELD pjmb04
         CALL t205_set_entry(p_cmd)
         CALL t205_set_no_entry(p_cmd)
 
      AFTER FIELD pjmb05
         IF NOT cl_null(g_pjmb[l_ac].pjmb05) THEN
            IF g_pjmb[l_ac].pjmb05 < 0 THEN
               CALL cl_err('pjmb05','apj-035',0)
               NEXT FIELD pjmb05
            END IF
         END IF
 
      AFTER FIELD pjmb06               
         IF cl_null(g_pjmb[l_ac].pjmb06) THEN
            NEXT FIELD pjmb06
         ELSE                                                                                             
            IF g_pjmb[l_ac].pjmb06 < 0 THEN                                                                                         
               CALL cl_err('pjmb06','apj-035',0)                                                                                    
               NEXT FIELD pjmb06                                                                                                    
            ELSE
               CALL t205_pjmb06()
            END IF 
         END IF                
 
      BEFORE DELETE                            #是否取消單身
         IF g_pjmb_t.pjmbacti = 'N' THEN
            CALL cl_err(g_pjmb1_t.pjmb01,'mfg1000',0)
            CANCEL DELETE
         END IF
         IF g_pjmb_t.pjmb03 > 0 AND g_pjmb_t.pjmb03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjmb_file
                 WHERE pjmb01 = g_pjmb1.pjmb01 AND pjmb02=g_pjmb1.pjmb02 AND pjmb03=g_pjmb_t.pjmb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pjmb_file",g_pjmb1_t.pjmb02,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            IF g_rec_b = 0 THEN
               LET g_row_count = g_row_count-1
               DISPLAY g_row_count TO FORMONLY.cnt
            END IF
            DISPLAY g_rec_b TO FORMONLY.cn2
            
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pjmb[l_ac].* = g_pjmb_t.*
            CLOSE t205_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjmb1.pjmb02,-263,1)
            LET g_pjmb[l_ac].* = g_pjmb_t.*
         ELSE
            UPDATE pjmb_file SET pjmb03 = g_pjmb[l_ac].pjmb03,
                                 pjmb04 = g_pjmb[l_ac].pjmb04,
                                 pjmb05 = g_pjmb[l_ac].pjmb05,
                                 pjmb06 = g_pjmb[l_ac].pjmb06,
                                 pjmbacti = g_pjmb[l_ac].pjmbacti,
                                 pjmbmodu = g_user,
                                 pjmbdate = g_today
             WHERE pjmb01 = g_pjmb1.pjmb01 AND pjmb02=g_pjmb1.pjmb02 AND pjmb03=g_pjmb_t.pjmb03
             CALL t205_pjmb06()
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjmb_file",g_pjmb1.pjmb01,g_pjmb1.pjmb02,SQLCA.sqlcode,"","",1)
               LET g_pjmb[l_ac].* = g_pjmb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjmb[l_ac].* = g_pjmb_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjmb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t205_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t205_bcl
         COMMIT WORK
 
     ON ACTION CONTROLN
        CALL t205_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pjmb03) AND l_ac > 1 THEN
            LET g_pjmb[l_ac].* = g_pjmb[l_ac-1].*
            NEXT FIELD pjmb03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjmb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjy"
               LET g_qryparam.default1 = g_pjmb[l_ac].pjmb04
               CALL cl_create_qry() RETURNING g_pjmb[l_ac].pjmb04
               DISPLAY BY NAME g_pjmb[l_ac].pjmb04
               CALL t205_pjmb04('d')
               NEXT FIELD pjmb04
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
              RETURNING g_fld_name,g_frm_name
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
 
   CLOSE t205_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t205_pjmb06()
DEFINE l_amt LIKE type_file.num20_6
    LET l_amt = g_pjmb[l_ac].pjy04*g_pjmb[l_ac].pjmb06
    LET g_pjmb[l_ac].amt = l_amt
    DISPLAY BY NAME g_pjmb[l_ac].amt
END FUNCTION
 
FUNCTION t205_pjmb04(p_cmd)
    DEFINE l_pjy02    LIKE pjy_file.pjy02,
           l_pjy03    LIKE pjy_file.pjy03,
           l_pjy04    LIKE pjy_file.pjy04,
           p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjy02,pjy03,pjy04
      INTO l_pjy02,l_pjy03,l_pjy04
      FROM pjy_file WHERE pjy01 = g_pjmb[l_ac].pjmb04
 
   CASE 
      WHEN SQLCA.SQLCODE = 100     
                                    LET l_pjy02 = NULL
                                    LET l_pjy03 = NULL
                                    LET l_pjy04 = NULL
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjmb[l_ac].pjy02  = l_pjy02
      LET g_pjmb[l_ac].pjy03 = l_pjy03
      LET g_pjmb[l_ac].pjy04 = l_pjy04
      DISPLAY BY NAME g_pjmb[l_ac].pjy03
      DISPLAY BY NAME g_pjmb[l_ac].pjy04
      DISPLAY BY NAME g_pjmb[l_ac].pjy02
   END IF
 
END FUNCTION
 
 
FUNCTION t205_b_askkey()
#DEFINE   l_wc2          LIKE type_file.chr1000
DEFINE l_wc2  STRING     #NO.FUN-910082
 
   CONSTRUCT l_wc2 ON pjmb03,pjmb04,pjmb05,pjmb06,pjmbacti      #螢幕上取單身條件
           FROM tb2[1].pjmb03,tb2[1].pjmb04,
                tb2[1].pjmb05,tb2[1].pjmb06,tb2[1].pjmbacti
 
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
         
                   
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL t205_b_fill(l_wc2)
 
END FUNCTION
 
 
 
 
FUNCTION t205_b_fill(p_wc2)
#   DEFINE p_wc2          LIKE type_file.chr1000
   DEFINE p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql="SELECT pjmb03,pjmb04,'',pjmb05,'','',pjmb06,'',pjmbacti",
             " FROM pjmb_file ",
             " WHERE pjmb01='",g_pjmb1.pjmb01,"' ",
             " AND pjmb02='",g_pjmb1.pjmb02,"'"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjmb02 "
   DISPLAY g_sql
   PREPARE t205_pb FROM g_sql
   DECLARE pjmb_cs CURSOR FOR t205_pb
   CALL g_pjmb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjmb_cs INTO g_pjmb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT pjy02,pjy03,pjy04 INTO g_pjmb[g_cnt].pjy02,g_pjmb[g_cnt].pjy03,g_pjmb[g_cnt].pjy04 FROM pjy_file
        WHERE pjy01 = g_pjmb[g_cnt].pjmb04 AND pjyacti='Y'
       IF SQLCA.sqlcode THEN
         LET g_pjmb[g_cnt].pjy02 = NULL
         LET g_pjmb[g_cnt].pjy03 = NULL
         LET g_pjmb[g_cnt].pjy04 = NULL
       END IF
      LET g_pjmb[g_cnt].amt = g_pjmb[g_cnt].pjy04*g_pjmb[g_cnt].pjmb06
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjmb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t205_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjmb TO tb2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete                                                                                                              
         LET g_action_choice="delete"                                                                                               
         EXIT DISPLAY 
         
      ON ACTION first
         CALL t205_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
           
      ON ACTION previous
         CALL t205_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
        
      ON ACTION jump
         CALL t205_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION next
         CALL t205_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION last
         CALL t205_fetch('L')
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
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE 
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
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                           
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO") 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t205_out()
    DEFINE l_cmd           LIKE type_file.chr1000                                                                                    
    IF cl_null(g_wc) AND cl_null(g_wc2)
       AND NOT cl_null(g_pjmb1.pjmb01) AND NOT cl_null(g_pjmb1.pjmb02)  THEN                                                     
           LET g_wc=" pjmb01= '",g_pjmb1.pjmb01,"' AND pjmb02='",g_pjmb1.pjmb02,"' "                                                                     
    ELSE
       IF NOT cl_null(g_wc2) THEN 
         LET g_wc = g_wc," AND ",g_wc2
       END IF                                                    
    END IF                                                                                                                           
   IF cl_null(g_wc)  THEN                                                                                                             
      CALL cl_err('','9057',0) RETURN END IF                                                                                        
    LET l_cmd = 'p_query "apjt205" "',g_wc CLIPPED,'" '                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN    
END FUNCTION                                 
FUNCTION t205_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF INFIELD(pjmb03) THEN
#      CALL cl_set_comp_entry("pjmb04",TRUE)
   END IF
END FUNCTION
 
FUNCTION t205_r()
   DEFINE l_n,i    LIKE type_file.num5                                                                                               
                                                                                                                                    
   IF s_shut(0) THEN RETURN END IF                                                                                                  
                                                                                                                                    
   IF cl_null(g_pjmb1.pjmb01) AND cl_null(g_pjmb1.pjmb02) THEN                                                                      
      CALL cl_err("",-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                           
   BEGIN WORK                                                                                                                       
                                                                                                                                    
   OPEN t205_cl USING g_pjmb1.pjmb01,g_pjmb1.pjmb02                                                                                 
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN t205_cl:", STATUS, 1)                                                                                       
      CLOSE t205_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   FETCH t205_cl INTO g_pjmb1.*           # 對DB鎖定                                                                                
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN                                                                                                                        
   END IF                                                                                                                           
   CALL t205_show()                                                                                                                 
                                                                                                                                    
   IF cl_delh(0,0) THEN   #確認一下                                                                                                 
       INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjmb01"           #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjmb1.pjmb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM pjmb_file WHERE pjmb01=g_pjmb1.pjmb01 AND pjmb02=g_pjmb1.pjmb02                                                   
      IF SQLCA.sqlcode THEN                                                                                                         
         CALL cl_err3("del","pjmb_file","","",SQLCA.sqlcode,"","BODY DELETE",1)                                                     
      ELSE                                                                                                                          
         CLEAR FORM                                                                                                                 
                                                                                                                                    
         DROP TABLE x                                                                                                               
         PREPARE t205_precount_x2 FROM g_sql_tmp                                                                                    
         EXECUTE t205_precount_x2                                                                                                   
                                                                                                                                    
         CALL g_pjmb.clear()                                                                                                        
         OPEN t205_count                                                                                                            
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t205_cs
            CLOSE t205_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t205_count INTO g_row_count                                                                                          
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t205_cs
            CLOSE t205_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt                                                                                        
         OPEN t205_cs                                                                                                               
         IF g_row_count>0 THEN                                                                                                      
         IF g_curs_index = g_row_count + 1 THEN                                                                                     
            LET g_jump = g_row_count                                                                                                
            CALL t205_fetch('L')      
         ELSE                                                                                                                       
            LET g_jump = g_curs_index                                                                                               
            LET mi_no_ask = TRUE                                                                                                    
            CALL t205_fetch('/')                                                                                                    
         END IF                                                                                                                     
         END IF                                                                                                                     
      END IF                                                                                                                        
      COMMIT WORK                                                                                                                   
   END IF                                                                                                                           
                                                                                                                                    
   CLOSE t205_cl                                                                                                                    
   COMMIT WORK                                                                                                                      
                                                                                                                                    
END FUNCTION                 
 
FUNCTION t205_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
#         CALL cl_set_comp_entry("pjmb04",FALSE)
END FUNCTION
#No.FUN-790025
