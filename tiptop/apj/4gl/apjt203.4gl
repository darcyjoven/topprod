# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: apjt203.4gl
# Descriptions...: 活動預計材料耗用維護
# Date & Author..: No.FUN-790025 2007/11/12 By zhangyajun
# Modify.........: No.TQC-840018 2008/04/08 By Zhangyjun  規格變動：去除字段轉請購量(pjfb08)
# Modify.........: No.MOD-840322 2008/04/23 By shiwuying 本作業增加料號依BOM表整批產生功能
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0142 09/12/17 By jan 單身寫入時，出現-236，欄位數量不合
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0215 10/11/30 By lixh1 修改INSERT INTO字段不對應
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_pjfb1         RECORD   
        pjfb01       LIKE pjfb_file.pjfb01,
        pjfb02       LIKE pjfb_file.pjfb02 
                     END RECORD,
    g_pjfb1_t        RECORD   
        pjfb01       LIKE pjfb_file.pjfb01,
        pjfb02       LIKE pjfb_file.pjfb02     
                     END RECORD,
    g_pjfb1_o        RECORD   
        pjfb01       LIKE pjfb_file.pjfb01,
        pjfb02       LIKE pjfb_file.pjfb02 
                     END RECORD,
 
    g_pjfb           DYNAMIC ARRAY OF RECORD      
        pjfb03       LIKE pjfb_file.pjfb03,
        pjfb04       LIKE pjfb_file.pjfb04,
        pjfb05       LIKE pjfb_file.pjfb05,
        ima021       LIKE ima_file.ima021,
        ima25        LIKE ima_file.ima25,       
        pjfb06       LIKE pjfb_file.pjfb06,
        pjfb07       LIKE pjfb_file.pjfb07,
#        pjfb08      LIKE pjfb_file.pjfb08,   #TQC-840018
        pjfbacti     LIKE pjfb_file.pjfbacti
                     END RECORD,
    g_pjfb_t         RECORD 
        pjfb03       LIKE pjfb_file.pjfb03,
        pjfb04       LIKE pjfb_file.pjfb04,
        pjfb05       LIKE pjfb_file.pjfb05,
        ima021       LIKE ima_file.ima021,
        ima25        LIKE ima_file.ima25,       
        pjfb06       LIKE pjfb_file.pjfb06,
        pjfb07       LIKE pjfb_file.pjfb07,
#        pjfb08      LIKE pjfb_file.pjfb08,  #TQC-840018 mark
        pjfbacti     LIKE pjfb_file.pjfbacti
                     END RECORD,
    g_pjfb_o         RECORD
        pjfb03       LIKE pjfb_file.pjfb03,
        pjfb04       LIKE pjfb_file.pjfb04,
        pjfb05       LIKE pjfb_file.pjfb05,
        ima021       LIKE ima_file.ima021,
        ima25        LIKE ima_file.ima25,       
        pjfb06       LIKE pjfb_file.pjfb06,
        pjfb07       LIKE pjfb_file.pjfb07,
#        pjfb08      LIKE pjfb_file.pjfb08,   #TQC-840018
        pjfbacti     LIKE pjfb_file.pjfbacti
                     END RECORD,
    g_wc,g_wc2,g_sql STRING,
    g_rec_b          LIKE type_file.num5,
    l_ac             LIKE type_file.num5,
    p_row,p_col      LIKE type_file.num5 
    
DEFINE g_forupd_sql         STRING       #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_cnt                LIKE type_file.num10 
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_row_count          LIKE type_file.num10 
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5 
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_argv1              LIKE pjj_file.pjj01
DEFINE g_argv2              LIKE pjk_file.pjk02
 
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
   INITIALIZE g_pjfb1.pjfb01 TO NULL
    
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_pjfb1.pjfb01=g_argv1
   LET g_pjfb1.pjfb02=g_argv2
   
   LET g_forupd_sql = "SELECT pjfb01,pjfb02 FROM pjfb_file",
                      " WHERE pjfb01=? AND pjfb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t203_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 19
   OPEN WINDOW t203_w AT p_row,p_col
        WITH FORM "apj/42f/apjt203"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) THEN
    IF cl_null(g_argv2) THEN
      LET g_wc=g_wc,"pjfb01 = '",g_argv1 CLIPPED,"'"
    ELSE 
      LET g_wc=g_wc,"pjfb01 = '",g_argv1 CLIPPED,"' AND pjfb02 = '",g_argv2 CLIPPED,"'"
    END IF      
    CALL t203_q()
    IF g_rec_b<=0 AND NOT cl_null(g_argv2) THEN
      LET g_pjfb1.pjfb01=g_argv1                                                   
      LET g_pjfb1.pjfb02=g_argv2
      CALL t203_show()
      LET l_ac = g_rec_b + 1
      CALL t2031()             #No.MOD-840322
#      CALL t203_b()           #No.MOD-840322
    END IF
   END IF
   CALL t203_menu()
   CLOSE WINDOW t203_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION t203_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_pjfb.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_pjfb1.* TO NULL
  
   IF cl_null(g_argv1) THEN 
   CONSTRUCT BY NAME g_wc ON pjfb01,pjfb02
       
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
             
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjfb01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjk1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
                   DISPLAY g_qryparam.multiret TO  pjfb01
                   NEXT FIELD pjfb01
               WHEN INFIELD(pjfb02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_pjk"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO  pjfb02
                   NEXT FIELD pjfb02
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
   #      LET g_wc = g_wc clipped," AND pjfbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pjfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND pjfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('jfbuser', 'jfbgrup')
   #End:FUN-980030
   
   CONSTRUCT g_wc2 ON pjfb03,pjfb04,pjfb05,pjfb06,pjfb07,pjfbacti        
     FROM s_pjfb[1].pjfb03,s_pjfb[1].pjfb04,
          s_pjfb[1].pjfb05,s_pjfb[1].pjfb06,s_pjfb[1].pjfb07,s_pjfb[1].pjfbacti
 
       BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
       ON ACTION controlp
           CASE
               WHEN INFIELD(pjfb04)
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form = "q_ima"
               #   LET g_qryparam.state = "c"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO pjfb04
                  NEXT FIELD pjfb04
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
   END IF
   IF INT_FLAG THEN
      RETURN
   END IF
   IF cl_null(g_wc2) THEN
     LET g_wc2=" 1=1"
   END IF
   LET g_sql = "SELECT UNIQUE pjfb01,pjfb02 ",
               " FROM pjfb_file ",
               " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
               " ORDER BY pjfb01"
   PREPARE t203_prepare FROM g_sql
   DECLARE t203_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t203_prepare
 
  IF g_wc2 = " 1=1" THEN
       LET g_sql_tmp="SELECT UNIQUE pjfb01,pjfb02 FROM pjfb_file WHERE ",g_wc CLIPPED,
                 " INTO TEMP x"
   ELSE
       LET g_sql_tmp="SELECT UNIQUE pjfb01,pjfb02 FROM pjfb_file WHERE ",
                 g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " INTO TEMP x"
   END IF
   
   DROP TABLE x                            
   PREPARE t203_precount_x FROM g_sql_tmp  
   EXECUTE t203_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t203_precount FROM g_sql
   DECLARE t203_count CURSOR FOR t203_precount
END FUNCTION
 
#No.MOD-840322------------start-------------
FUNCTION t2031()
   DEFINE  l_chr       LIKE type_file.chr1
 
   OPEN WINDOW t1201_w AT p_row,p_col WITH FORM "apj/42f/apjt1201"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("apjt1201")
 
   LET l_chr='1'
   INPUT l_chr WITHOUT DEFAULTS FROM FORMONLY.a
 
      AFTER FIELD a
         IF l_chr NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET l_chr = '1'
   END IF
   CLOSE WINDOW t1201_w 
 
   IF cl_null(l_chr) THEN
      LET l_chr = '1'
   END IF
   LET g_rec_b = 0
   CASE
      WHEN l_chr = '1'
         CALL g_pjfb.clear()
         CALL t203_b()
      WHEN l_chr='2'
         CALL p203(g_pjfb1.pjfb01,g_pjfb1.pjfb02)
   #      LET g_wc=NULL
         CALL t203_b_fill(g_wc)
         CALL t203_b()
      OTHERWISE EXIT CASE
   END CASE
END FUNCTION
#No.MOD-840322-------------end--------------
 
FUNCTION t203_menu()
 
   WHILE TRUE
      CALL t203_bp("G")
      CASE g_action_choice
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t203_q()
            END IF
         
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t203_r()
            END IF
                
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t203_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t203_out()
            END IF
         
         WHEN "help"
            CALL cl_show_help()
         
         WHEN "exit"
            EXIT WHILE
         
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjfb),'','')
            END IF
         
         WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_pjfb1.pjfb01 IS NOT NULL THEN
                LET g_doc.column1 = "pjfb01"
                LET g_doc.value1 = g_pjfb1.pjfb01
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t203_pjfb01(p_cmd)
   DEFINE  l_pjj02     LIKE pjj_file.pjj02,         
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjj02 INTO l_pjj02
      FROM pjj_file WHERE pjj01=g_pjfb1.pjfb01 AND pjjacti='Y' 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-048'
                                  LET l_pjj02   = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_pjj02 TO FORMONLY.pjj02
 
   END IF
 
END FUNCTION
 
FUNCTION t203_pjfb02(p_cmd)
   DEFINE  l_pjk03     LIKE pjk_file.pjk03,
           l_pjk16     LIKE pjk_file.pjk16, 
           l_pjk17     LIKE pjk_file.pjk17,
           l_pjkacti   LIKE pjk_file.pjkacti,          
           p_cmd       LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT pjk03,pjk16,pjk17,pjkacti
     INTO l_pjk03,l_pjk16,l_pjk17,l_pjkacti
     FROM pjk_file
     WHERE pjk01 = g_pjfb1.pjfb01 AND pjk02=g_pjfb1.pjfb02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-049'
                                  LET l_pjk03 = NULL
                                  LET l_pjk16 = NULL    
                                  LET l_pjk17 = NULL 
        WHEN l_pjkacti='N'        LET g_errno = '9028'                                                           
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_pjk03 TO FORMONLY.pjk03
      DISPLAY l_pjk16 TO FORMONLY.pjk16
      DISPLAY l_pjk17 TO FORMONLY.pjk17
   END IF
 
END FUNCTION
 
FUNCTION t203_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_pjfb1.* TO NULL
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pjfb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   
   CALL t203_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pjfb1.pjfb01=NULL
      LET g_pjfb1.pjfb02=NULL
      RETURN
   END IF
   
   OPEN t203_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pjfb1.pjfb01=NULL
      LET g_pjfb1.pjfb02=NULL
   ELSE
      OPEN t203_count
      FETCH t203_count INTO g_row_count
      IF g_row_count>0 THEN
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t203_fetch('F')                  # 讀出TEMP第一筆並顯示
      ELSE 
        CALL cl_err('',100,0)
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION t203_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式 
   l_abso          LIKE type_file.num10     #絕對的筆數 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t203_cs INTO g_pjfb1.pjfb01,g_pjfb1.pjfb02
      WHEN 'P' FETCH PREVIOUS t203_cs INTO g_pjfb1.pjfb01,g_pjfb1.pjfb02
      WHEN 'F' FETCH FIRST    t203_cs INTO g_pjfb1.pjfb01,g_pjfb1.pjfb02
      WHEN 'L' FETCH LAST     t203_cs INTO g_pjfb1.pjfb01,g_pjfb1.pjfb02
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
         FETCH ABSOLUTE g_jump t203_cs INTO g_pjfb1.pjfb01,g_pjfb1.pjfb02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pjfb1.pjfb01 TO NULL
      INITIALIZE g_pjfb1.pjfb02 TO NULL
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
   
   CALL t203_show()
 
END FUNCTION
 
FUNCTION t203_show()
   LET g_pjfb1_t.* = g_pjfb1.*
   LET g_pjfb1_o.* = g_pjfb1.*
   
   DISPLAY BY NAME g_pjfb1.pjfb01         #單頭
   DISPLAY BY NAME g_pjfb1.pjfb02
   CALL t203_pjfb01('d')
   CALL t203_pjfb02('d')
   #-->顯示單頭值
   CALL t203_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t203_r()
  DEFINE l_n,i    LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjfb1.pjfb01) AND cl_null(g_pjfb1.pjfb02) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t203_cl USING g_pjfb1.pjfb01,g_pjfb1.pjfb02
   IF STATUS THEN
      CALL cl_err("OPEN t203_cl:", STATUS, 1)
      CLOSE t203_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t203_cl INTO g_pjfb1.*           # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t203_show()
 
   IF cl_delh(0,0) THEN   #確認一下
       INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjfb01"           #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjfb1.pjfb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM pjfb_file WHERE pjfb01=g_pjfb1.pjfb01 AND pjfb02=g_pjfb1.pjfb02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjfb_file","","",SQLCA.sqlcode,"","BODY DELETE",1)
      ELSE
         CLEAR FORM
 
         DROP TABLE x
         PREPARE t203_precount_x2 FROM g_sql_tmp
         EXECUTE t203_precount_x2
 
         CALL g_pjfb.clear()
         OPEN t203_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t203_cs
            CLOSE t203_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t203_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t203_cs
            CLOSE t203_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t203_cs
         IF g_row_count>0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t203_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t203_fetch('/')
         END IF
         END IF
      END IF
      COMMIT WORK
   END IF
 
   CLOSE t203_cl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t203_b()
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
 
   IF cl_null(g_pjfb1.pjfb01) AND cl_null(g_pjfb1.pjfb02) THEN
      RETURN
   END IF
   
   LET g_pjfb1_t.pjfb01=g_pjfb1.pjfb01
   LET g_pjfb1_t.pjfb02=g_pjfb1.pjfb02
   CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT pjfb03,pjfb04,pjfb05,'','',pjfb06,",
#                      " pjfb07,pjfb08,pjfbacti FROM pjfb_file",  #TQC-840018 mark
                       " pjfb07,pjfbacti FROM pjfb_file",         #TQC-840018
                      " WHERE pjfb01=? AND pjfb02=? AND pjfb03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t203_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pjfb WITHOUT DEFAULTS FROM s_pjfb.*
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
            BEGIN WORK
            LET p_cmd='u'
            LET g_pjfb_t.* = g_pjfb[l_ac].*  #BACKUP
            LET g_pjfb_o.* = g_pjfb[l_ac].*  #BACKUP
 
            OPEN t203_cl USING g_pjfb1.pjfb01,g_pjfb1.pjfb02
            IF STATUS THEN
               CALL cl_err("OPEN t203_cl:", STATUS, 1)
               CLOSE t203_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t203_cl INTO g_pjfb1.*     
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               CLOSE t203_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            OPEN t203_bcl USING g_pjfb1.pjfb01,g_pjfb1.pjfb02,g_pjfb_t.pjfb03
            IF STATUS THEN
               CALL cl_err("OPEN t203_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t203_bcl INTO g_pjfb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjfb_t.pjfb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT ima021,ima25 INTO g_pjfb[l_ac].ima021,g_pjfb[l_ac].ima25 
                  FROM ima_file
                  WHERE ima01 = g_pjfb[l_ac].pjfb04
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjfb[l_ac].* TO NULL
#         LET g_pjfb[l_ac].pjfb08 =  0      #TQC-840018 mark
         LET g_pjfb[l_ac].pjfb07 =  g_today 
         LET g_pjfb[l_ac].pjfbacti ='Y'      #Body default
         LET g_pjfb_t.* = g_pjfb[l_ac].*         #新輸入資料
         LET g_pjfb_o.* = g_pjfb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD pjfb03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pjfb_file
             VALUES(g_pjfb1.pjfb01,g_pjfb1.pjfb02,g_pjfb[l_ac].pjfb03,g_pjfb[l_ac].pjfb04,
                    g_pjfb[l_ac].pjfb05,g_pjfb[l_ac].pjfb06,
#                    g_pjfb[l_ac].pjfb07,g_pjfb[l_ac].pjfb08,   #TQC-840018 mark
                  #  g_pjfb[l_ac].pjfb07,NULL,                   #TQC-840018   #TQC-AB0215
                    g_pjfb[l_ac].pjfb07,'',g_pjfb[l_ac].pjfbacti,g_today,g_grup,'',g_user,g_grup,g_user)   #TQC-AB0215                      
                  # g_pjfb[l_ac].pjfbacti,g_today,g_grup,'',g_user,g_grup,g_user, g_user, g_grup)  #TQC-9C0142      #No.FUN-980030 10/01/04  insert columns oriu, orig     #TQC-AB0215
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pjfb_file","","",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD pjfb03                        #default 序號
         IF cl_null(g_pjfb[l_ac].pjfb03) THEN
            SELECT max(pjfb03)+1 INTO g_pjfb[l_ac].pjfb03
              FROM pjfb_file 
             WHERE pjfb01 = g_pjfb1.pjfb01 AND pjfb02=g_pjfb1.pjfb02
            IF cl_null(g_pjfb[l_ac].pjfb03) THEN
               LET g_pjfb[l_ac].pjfb03 = 1
            END IF
         END IF
 
      AFTER FIELD pjfb03                       #check 是否重複
         IF NOT cl_null(g_pjfb[l_ac].pjfb03) THEN
            IF g_pjfb[l_ac].pjfb03 != g_pjfb_t.pjfb03 OR g_pjfb_t.pjfb03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM pjfb_file
                WHERE pjfb03 = g_pjfb[l_ac].pjfb03 AND pjfb01 = g_pjfb1.pjfb01 AND pjfb02 = g_pjfb1.pjfb02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_pjfb[l_ac].pjfb03 = g_pjfb_t.pjfb03
                  NEXT FIELD pjfb03
               END IF
               IF g_pjfb[l_ac].pjfb03 <= 0 THEN
                  CALL cl_err('pjfb02','aec-994',0)
                  NEXT FIELD pjfb03
               END IF
            END IF
         END IF
 
      BEFORE FIELD pjfb04
         CALL t203_set_entry(p_cmd)
         
      AFTER FIELD pjfb04                 #料件編號
         #FUN-AA0059 ------------------add start--------------
         IF NOT cl_null(g_pjfb[l_ac].pjfb04) THEN
            IF NOT s_chk_item_no(g_pjfb[l_ac].pjfb04,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_pjfb[l_ac].pjfb04 = g_pjfb_o.pjfb04
               DISPLAY BY NAME g_pjfb[l_ac].pjfb04
               NEXT FIELD pjfb04
            END IF
         END IF
         #FUN-AA0059 ------------------add end----------------
         IF g_pjfb_o.pjfb04 IS NULL OR (g_pjfb[l_ac].pjfb04 != g_pjfb_o.pjfb04) THEN
            IF g_pjfb[l_ac].pjfb04[1,4] !='MISC'  THEN
               CALL t203_pjfb04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjfb[l_ac].pjfb04,g_errno,0)
                  LET g_pjfb[l_ac].pjfb04 = g_pjfb_o.pjfb04
                  DISPLAY BY NAME g_pjfb[l_ac].pjfb04
                  NEXT FIELD pjfb04
               END IF
            ELSE CALL t203_pjfb04('a')
            END IF
         END IF
         LET g_pjfb_o.pjfb04 = g_pjfb[l_ac].pjfb04
         CALL t203_set_no_entry(p_cmd)
         
      BEFORE FIELD pjfb05
         CALL t203_set_entry(p_cmd)
         CALL t203_set_no_entry(p_cmd)
 
      AFTER FIELD pjfb06
         IF NOT cl_null(g_pjfb[l_ac].pjfb06) THEN
            IF g_pjfb[l_ac].pjfb06 < 0 THEN
               CALL cl_err('pjfb06','apj-035',0)
               NEXT FIELD pjfb06
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_pjfb_t.pjfb03 > 0 AND g_pjfb_t.pjfb03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pjfb_file
                 WHERE pjfb01 = g_pjfb1.pjfb01 AND pjfb02=g_pjfb1.pjfb02 AND pjfb03=g_pjfb_t.pjfb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pjfb_file",g_pjfb_t.pjfb03,"",SQLCA.sqlcode,"","",1)
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
            LET g_pjfb[l_ac].* = g_pjfb_t.*
            CLOSE t203_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pjfb[l_ac].pjfb03,-263,1)
            LET g_pjfb[l_ac].* = g_pjfb_t.*
         ELSE
            UPDATE pjfb_file SET pjfb03 = g_pjfb[l_ac].pjfb03,
                                 pjfb04 = g_pjfb[l_ac].pjfb04,
                                 pjfb05 = g_pjfb[l_ac].pjfb05,
                                 pjfb06 = g_pjfb[l_ac].pjfb06,
                                 pjfb07 = g_pjfb[l_ac].pjfb07,
#                                 pjfb08 = g_pjfb[l_ac].pjfb08,    #TQC-840018
                                 pjfbacti=g_pjfb[l_ac].pjfbacti,
                                 pjfbgrup = g_grup,
                                 pjfbdate = g_today
             WHERE pjfb01 = g_pjfb1.pjfb01 AND pjfb02 = g_pjfb1.pjfb02 AND pjfb03=g_pjfb_t.pjfb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pjfb_file","",g_pjfb_t.pjfb03,SQLCA.sqlcode,"","",1)
               LET g_pjfb[l_ac].* = g_pjfb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
                LET g_pjfb[l_ac].* = g_pjfb_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_pjfb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t203_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t203_bcl
         COMMIT WORK
 
     ON ACTION CONTROLN
        CALL t203_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pjfb03) AND l_ac > 1 THEN
            LET g_pjfb[l_ac].* = g_pjfb[l_ac-1].*
            NEXT FIELD pjfb03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjfb04)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form = "q_ima"
             #  LET g_qryparam.default1 = g_pjfb[l_ac].pjfb04
             #  CALL cl_create_qry() RETURNING g_pjfb[l_ac].pjfb04
               CALL q_sel_ima(FALSE, "q_ima", "", g_pjfb[l_ac].pjfb04, "", "", "", "" ,"",'' )  RETURNING g_pjfb[l_ac].pjfb04
#FUN-AA0059 --End--
               DISPLAY BY NAME g_pjfb[l_ac].pjfb04
               CALL t203_pjfb04('d')
               NEXT FIELD pjfb04
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
 
   CLOSE t203_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t203_pjfb04(p_cmd)
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima25    LIKE ima_file.ima44,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima25,imaacti
      INTO l_ima02,l_ima021,l_ima25,l_imaacti
      FROM ima_file WHERE ima01 = g_pjfb[l_ac].pjfb04
 
   CASE 
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'mfg3006'
                                    LET l_ima02 = NULL
                                    LET l_ima021 = NULL
                                    LET l_ima25 = NULL
      WHEN l_imaacti='N'            LET g_errno = '9028'
      WHEN l_imaacti MATCHES '[PH]' LET g_errno = '9038'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_pjfb[l_ac].pjfb05  = l_ima02
      LET g_pjfb[l_ac].ima021 = l_ima021
      LET g_pjfb[l_ac].ima25 = l_ima25
      DISPLAY BY NAME g_pjfb[l_ac].ima25
      DISPLAY BY NAME g_pjfb[l_ac].pjfb05
      DISPLAY BY NAME g_pjfb[l_ac].ima021
   END IF
 
END FUNCTION
 
 
FUNCTION t203_b_askkey()
#DEFINE   l_wc2          LIKE type_file.chr1000
 DEFINE   l_wc2  STRING     #NO.FUN-910082
 
   CONSTRUCT l_wc2 ON pjfb03,pjfb04,pjfb05,pjfb06,pjfb07,pjfbacti      #螢幕上取單身條件 #TQC-840018
           FROM s_pjfb[1].pjfb02,s_pjfb[1].pjfb03,s_pjfb[1].pjfb04,
                s_pjfb[1].pjfb05,s_pjfb[1].pjfb06,s_pjfb[1].pjfb07,s_pjfb[1].pjfbacti     #TQC-840018
 
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
         
      ON ACTION qbe_select
         CALL cl_qbe_select()
         
      ON ACTION qbe_save
         CALL cl_qbe_save()
                   
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL t203_b_fill(l_wc2)
 
END FUNCTION
 
 
FUNCTION t203_b_fill(p_wc2)
#   DEFINE p_wc2          LIKE type_file.chr1000
   DEFINE p_wc2  STRING     #NO.FUN-910082
 
   LET g_sql="SELECT pjfb03,pjfb04,pjfb05,'','',pjfb06,pjfb07,pjfbacti",   #TQC-840018
             " FROM pjfb_file ",
             " WHERE pjfb01='",g_pjfb1.pjfb01,"' AND pjfb02='",g_pjfb1.pjfb02,"'"
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjfb03 "
   DISPLAY g_sql
   PREPARE t203_pb FROM g_sql
   DECLARE pjfb_cs CURSOR FOR t203_pb
   CALL g_pjfb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pjfb_cs INTO g_pjfb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima021,ima25 INTO g_pjfb[g_cnt].ima021,g_pjfb[g_cnt].ima25 FROM ima_file
        WHERE ima01 = g_pjfb[g_cnt].pjfb04
       IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","ima_file",g_pjfb[g_cnt].ima021,"",SQLCA.sqlcode,"","",0)  
         LET g_pjfb[g_cnt].ima021 = NULL
         LET g_pjfb[g_cnt].ima25 = NULL
       END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pjfb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t203_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjfb TO s_pjfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t203_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
           
      ON ACTION previous
         CALL t203_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
        
      ON ACTION jump
         CALL t203_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION next
         CALL t203_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY
         
      ON ACTION last
         CALL t203_fetch('L')
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
 
FUNCTION t203_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
      CALL cl_set_comp_entry("pjfb05",TRUE)
END FUNCTION
 
 
FUNCTION t203_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
      IF g_pjfb[l_ac].pjfb04[1,4] !='MISC' THEN
         CALL cl_set_comp_entry("pjfb05",FALSE)
      END IF
END FUNCTION
 
FUNCTION t203_out()
   IF cl_null(g_pjfb1.pjfb01) OR g_rec_b=0 THEN                                                                               
        CALL cl_err('',-400,1)                                                                                                
        RETURN                                                                                                                
   END IF 
   IF cl_null(g_wc) THEN LET g_wc = "pjfb01='",g_pjfb1.pjfb01 CLIPPED,"' AND pjfb02 ='",g_pjfb1.pjfb02 CLIPPED,"'" END IF
   IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF                  
   LET g_msg ='p_query "apjt203" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'
   CALL cl_cmdrun(g_msg)
END FUNCTION
#No.FUN-790025 
