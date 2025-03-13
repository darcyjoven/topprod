# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
#Pattern name..:"arti162.4gl"
#Descriptions..:配送分貨倉庫資料檔
#Date & Author..: No.FUN-870100 08/07/28 By lala
#Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
#Modify.........: No.TQC-A40001 10/05/31 By Cockroach 預設上筆資料有問題 
#Modify.........: No.FUN-B40022 11/04/21 By lilingyu 單身"營運中心"欄位開窗增加多選功能
#Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
#Modify.........: No.FUN-B60114 11/06/22 By suncx1   需求營運中心開窗BUG調整，優化分貨倉庫開窗
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rvk01         LIKE rvk_file.rvk01,
        g_rvk01_t       LIKE rvk_file.rvk01,
        g_rvkacti       LIKE rvk_file.rvkacti,
        g_rvk   DYNAMIC ARRAY OF RECORD 
                rvk04   LIKE rvk_file.rvk04,
                rvk04_desc   LIKE azp_file.azp02,
                rvk02   LIKE rvk_file.rvk02,
                rvk02_desc LIKE oba_file.oba02,
                rvk03   LIKE rvk_file.rvk03,
                rvk03_desc LIKE imd_file.imd02,
                rvkacti LIKE rvk_file.rvkacti
                        END RECORD,
        g_rvk_t RECORD
                rvk04   LIKE rvk_file.rvk04,
                rvk04_desc   LIKE azp_file.azp02,
                rvk02   LIKE rvk_file.rvk02,
                rvk02_desc LIKE oba_file.oba02,
                rvk03   LIKE rvk_file.rvk03,
                rvk03_desc LIKE imd_file.imd02,
                rvkacti LIKE rvk_file.rvkacti
                        END RECORD
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col         LIKE type_file.num5
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_chr               LIKE type_file.chr1
DEFINE  g_cnt               LIKE type_file.num10
DEFINE  g_msg               LIKE ze_file.ze03
DEFINE  g_row_count         LIKE type_file.num10
DEFINE  g_curs_index        LIKE type_file.num10
DEFINE  g_jump              LIKE type_file.num10
DEFINE  mi_no_ask           LIKE type_file.num5
DEFINE  g_flag              LIKE type_file.chr1     #FUN-B40022
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
          
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i162_w AT p_row,p_col WITH FORM "art/42f/arti162"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i162_menu()
    
    CLOSE WINDOW i162_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i162_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rvk TO s_rvk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
      ON ACTION first
         CALL i162_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i162_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i162_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i162_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i162_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i162_menu()
 
   WHILE TRUE
      CALL i162_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i162_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL i162_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i162_r()
            END IF
#         WHEN "modify"
#            IF cl_chk_act_auth() THEN
#               CALL i162_u()
#            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i162_copy()
            END IF
         WHEN "next"
            CALL i162_fetch('N')
         WHEN "previous"
            CALL i162_fetch('P')
         WHEN "jump"
            CALL i162_fetch('/')
         WHEN "first"
            CALL i162_fetch('F')
         WHEN "last"
            CALL i162_fetch('L')
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i162_b()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i162_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rvk),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i162_cs()
 
    CLEAR FORM
    CALL g_rvk.clear()
    
    CONSTRUCT g_wc ON rvk01,rvk04,rvk02,rvk03,rvkacti FROM                              
        rvk01,s_rvk[1].rvk04,s_rvk[1].rvk02,s_rvk[1].rvk03,s_rvk[1].rvkacti
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rvk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvk01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvk01
                 NEXT FIELD rvk01
               WHEN INFIELD(rvk02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvk02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvk02
                 NEXT FIELD rvk02
               WHEN INFIELD(rvk03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvk03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvk03
                 NEXT FIELD rvk03
               WHEN INFIELD(rvk04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rvk04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvk04
                 NEXT FIELD rvk04
               OTHERWISE
                 EXIT CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvkuser', 'rvkgrup') #FUN-980030
 
    IF INT_FLAG THEN 
        RETURN
    END IF
      
    LET g_sql="SELECT DISTINCT rvk01 FROM rvk_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY rvk01"
 
    PREPARE i162_prepare FROM g_sql
    DECLARE i162_cs SCROLL CURSOR WITH HOLD FOR i162_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT rvk01) FROM rvk_file WHERE ",g_wc CLIPPED
 
    PREPARE i162_precount FROM g_sql
    DECLARE i162_count CURSOR FOR i162_precount
    
END FUNCTION
 
FUNCTION i162_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
 
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_rvk.clear()
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
 
    CALL i162_cs()              
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rvk01 TO NULL
        RETURN
    END IF
 
    OPEN i162_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rvk.clear()
    ELSE
        OPEN i162_count
        FETCH i162_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt
           CALL i162_fetch('F')
        ELSE
           CALL cl_err('',100,0)
        END IF
    END IF
END FUNCTION
 
FUNCTION i162_fetch(p_flrvk)
    DEFINE
        p_flrvk         LIKE type_file.chr1
    CASE p_flrvk
        WHEN 'N' FETCH NEXT     i162_cs INTO g_rvk01
        WHEN 'P' FETCH PREVIOUS i162_cs INTO g_rvk01
        WHEN 'F' FETCH FIRST    i162_cs INTO g_rvk01
        WHEN 'L' FETCH LAST     i162_cs INTO g_rvk01
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
            FETCH ABSOLUTE g_jump i162_cs INTO g_rvk01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rvk01,SQLCA.sqlcode,0)
        INITIALIZE g_rvk01 TO NULL  
        RETURN
    ELSE
      CASE p_flrvk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    CALL i162_show()
 
END FUNCTION
 
FUNCTION i162_rvk01(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_rvk01_desc LIKE geu_file.geu02
 
  SELECT geu02 INTO l_rvk01_desc FROM geu_file WHERE geu01 = g_rvk01 AND geuacti='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_rvk01_desc TO FORMONLY.rvk01_desc
  END IF
 
END FUNCTION
 
FUNCTION i162_rvk02(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_rvk02_desc LIKE gem_file.gem02
   
  SELECT oba02 INTO l_rvk02_desc FROM oba_file WHERE oba01 = g_rvk[l_ac].rvk02 AND obaacti='Y' AND oba14='0'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rvk[l_ac].rvk02_desc=l_rvk02_desc
     DISPLAY BY NAME g_rvk[l_ac].rvk02_desc
  END IF
 
END FUNCTION
 
FUNCTION i162_rvk03(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_rvk03_desc LIKE gem_file.gem02
 
  SELECT imd02 INTO l_rvk03_desc FROM imd_file WHERE imd01 = g_rvk[l_ac].rvk03 AND imdacti='Y' AND imd11='Y'
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rvk[l_ac].rvk03_desc=l_rvk03_desc
     DISPLAY BY NAME g_rvk[l_ac].rvk03_desc
  END IF
 
END FUNCTION
 
FUNCTION i162_rvk04(p_cmd)
DEFINE  p_cmd        LIKE type_file.chr1
DEFINE  l_rvk04_desc LIKE azp_file.azp02
 
  SELECT azp02 INTO l_rvk04_desc FROM azp_file WHERE azp01 = g_rvk[l_ac].rvk04 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-511'
                                 LET l_rvk04_desc = NULL
              OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rvk[l_ac].rvk04_desc=l_rvk04_desc
     DISPLAY BY NAME g_rvk[l_ac].rvk04_desc
  END IF
 
END FUNCTION
 
FUNCTION i162_show()
    DISPLAY g_rvk01 TO rvk01
    CALL i162_rvk01('d')
    CALL i162_b_fill(g_wc)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i162_b_fill(p_wc2)
DEFINE   p_wc2       STRING
DEFINE  l_rvk02_desc    LIKE ima_file.ima02,
        l_rvk04_desc    LIKE gem_file.gem02,
        l_rvk06         LIKE gem_file.gem02
    LET g_sql =
        "SELECT rvk04,'',rvk02,'',rvk03,'',rvkacti FROM rvk_file ",
        " WHERE rvk01= '",g_rvk01,"'"
        
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    PREPARE i162_pb FROM g_sql
    DECLARE rvk_cs CURSOR FOR i162_pb
 
    CALL g_rvk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rvk_cs INTO g_rvk[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
        EXIT FOREACH
        END IF
    SELECT azp02 INTO g_rvk[g_cnt].rvk04_desc FROM azp_file WHERE azp01 = g_rvk[g_cnt].rvk04 
    SELECT oba02 INTO g_rvk[g_cnt].rvk02_desc FROM oba_file WHERE oba01 = g_rvk[g_cnt].rvk02 AND obaacti = 'Y' AND oba14='0'
    SELECT imd02 INTO g_rvk[g_cnt].rvk03_desc FROM imd_file WHERE imd01 = g_rvk[g_cnt].rvk03 AND imdacti = 'Y' AND imd11='Y'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rvk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i162_a()
DEFINE   l_n       LIKE type_file.num5
 
   MESSAGE ""
 
   CLEAR FORM 
   CALL g_rvk.clear()
 
   LET g_wc = NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rvk01 LIKE rvk_file.rvk01
   LET g_rvk01_t = NULL
 
   LET g_rvk01_t = g_rvk01
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rvkacti='Y'
 
      CALL i162_i('a')
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rvk01) THEN
         CONTINUE WHILE
      END IF
 
      LET g_rec_b = 0
      CALL i162_b_fill(' 1=1')
      CALL i162_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i162_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_n       LIKE type_file.num5
 
   DISPLAY BY NAME g_rvk01
 
   CALL cl_set_head_visible("","YES")
   
   INPUT g_rvk01  WITHOUT DEFAULTS      
     FROM rvk01
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i162_set_entry(p_cmd)
          CALL i162_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
#          CALL cl_set_docno_format("rvk01")
 
      AFTER FIELD rvk01
         IF NOT cl_null(g_rvk01) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_rvk01 <> g_rvk01_t) THEN
               SELECT COUNT(*) INTO l_n FROM geu_file 
                WHERE geu01=g_rvk01 AND geuacti='Y' AND geu00='8'
               IF l_n>0 THEN
                  SELECT COUNT(*) INTO l_n FROM rvk_file WHERE rvk01=g_rvk01 AND rvkacti='Y'
                  IF l_n=0 THEN
                     CALL i162_rvk01('a')
                  ELSE
                     CALL cl_err('',-239,0)
                     LET g_rvk01=g_rvk01_t
                     DISPLAY BY NAME g_rvk01
                     NEXT FIELD rvk01
                  END IF
               ELSE
                  CALL cl_err('','art-188',0)
                  LET g_rvk01=g_rvk01_t
                  DISPLAY BY NAME g_rvk01
                  NEXT FIELD rvk01
               END IF
            END IF
         END IF
 
      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rvk01)  THEN
              NEXT FIELD rvk01
            END IF
      ON ACTION CONTROLO                        
         IF INFIELD(rvk01) THEN
 #           LET g_rvk.* = g_rvk_t.*
            CALL i162_show()
            NEXT FIELD rvk01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rvk01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_geu"
              LET g_qryparam.default1 = g_rvk01
              LET g_qryparam.arg1='8'
              CALL cl_create_qry() RETURNING g_rvk01
              DISPLAY BY NAME g_rvk01
              NEXT FIELD rvk01
 
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION
 
FUNCTION i162_b()
DEFINE         l_ac_t  LIKE type_file.num5,
               l_n     LIKE type_file.num5,
               l_rvk02_desc    LIKE oba_file.oba02,
               l_rvk03_desc    LIKE imd_file.imd02,
               l_lock_sw       LIKE type_file.chr1,
               p_cmd   LIKE type_file.chr1,
               l_allow_insert  LIKE type_file.num5,
               l_allow_delete  LIKE type_file.num5
 
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
 
        IF cl_null(g_rvk01) THEN
           CALL cl_err("",-400,0)
           RETURN 
        END IF
 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT rvk04,'',rvk02,'',rvk03,'',rvkacti",
                        " FROM rvk_file",
                        " WHERE rvk01=? AND rvk02=? AND rvk04=?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i162_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rvk WITHOUT DEFAULTS FROM s_rvk.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                           INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                           APPEND ROW=l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
 
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
 
                BEGIN WORK 
 
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rvk_t.*=g_rvk[l_ac].*
 
                        OPEN i162_bcl USING g_rvk01,g_rvk_t.rvk02,g_rvk_t.rvk04
                        IF STATUS THEN
                            CALL cl_err("OPEN i162_bcl:",STATUS,1)
                            LET l_lock_sw='Y'
                        ELSE
                            FETCH i162_bcl INTO g_rvk[l_ac].*
                            IF SQLCA.sqlcode THEN
                               CALL cl_err('',SQLCA.sqlcode,1)
                               LET l_lock_sw="Y"
                            END IF
                            CALL i162_rvk04('d')
                            CALL i162_rvk02('d')
                            CALL i162_rvk03('d')
                        END IF
                 END IF
 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                LET g_before_input_done = FALSE                                                                                         
                CALL i162_set_entry(p_cmd)                                                                                              
                CALL i162_set_no_entry(p_cmd)                                                                                           
                LET g_before_input_done = TRUE
                INITIALIZE g_rvk[l_ac].* TO NULL
                LET g_rvk[l_ac].rvkacti = 'Y'
                LET g_rvk_t.*=g_rvk[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rvk04
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
 
                INSERT INTO rvk_file(rvk01,rvk02,rvk03,rvk04,rvkacti,rvkoriu,rvkorig)
                              VALUES(g_rvk01,g_rvk[l_ac].rvk02,g_rvk[l_ac].rvk03,g_rvk[l_ac].rvk04,g_rvk[l_ac].rvkacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rvk_file",g_rvk01,g_rvk[l_ac].rvk02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT O.K.'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
 
 
      AFTER FIELD rvk02
        IF NOT cl_null(g_rvk[l_ac].rvk02) THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rvk[l_ac].rvk02!=g_rvk_t.rvk02) THEN
              SELECT COUNT(*) INTO l_n FROM oba_file WHERE oba01 = g_rvk[l_ac].rvk02 AND obaacti ='Y' AND oba14 = 0
              IF l_n>0 OR g_rvk[l_ac].rvk02='*' THEN
                 SELECT COUNT(*) INTO l_n FROM rvk_file WHERE rvk01=g_rvk01 AND rvk02=g_rvk[l_ac].rvk02 AND rvk04=g_rvk[l_ac].rvk04 AND rvkacti='Y'
                 IF l_n=0 THEN
                    CALL i162_rvk02('a')
                 ELSE
                    CALL cl_err('',-239,0)
                    LET g_rvk[l_ac].rvk02=g_rvk_t.rvk02
                    DISPLAY BY NAME g_rvk[l_ac].rvk02
                    NEXT FIELD rvk02
                 END IF
              ELSE
                 CALL cl_err('','art-248',0)
                 LET g_rvk[l_ac].rvk02=g_rvk_t.rvk02
                 DISPLAY BY NAME g_rvk[l_ac].rvk02
                 NEXT FIELD rvk02
              END IF
           END IF
        END IF
 
       AFTER FIELD rvk03
          IF NOT cl_null(g_rvk[l_ac].rvk03) THEN
             IF NOT cl_null(g_rvk[l_ac].rvk04) THEN
                SELECT COUNT(*) INTO l_n FROM imd_file WHERE imd01 = g_rvk[l_ac].rvk03 AND imdacti ='Y' AND imd11='Y' AND imd20<>g_rvk[l_ac].rvk04
                IF l_n>0 THEN
                   CALL i162_rvk03('a')
                ELSE
                   CALL cl_err('','art-255',0)
                   LET g_rvk[l_ac].rvk03=g_rvk_t.rvk03
                   DISPLAY BY NAME g_rvk[l_ac].rvk03
                   NEXT FIELD rvk03
                END IF
             END IF
          END IF
 
       AFTER FIELD rvk04
        IF NOT cl_null(g_rvk[l_ac].rvk04) AND g_rvk[l_ac].rvk04<>'*' THEN
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rvk[l_ac].rvk04!=g_rvk_t.rvk04) THEN
              CALL i162_rvk04('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_rvk[l_ac].rvk04=g_rvk_t.rvk04
                 DISPLAY BY NAME g_rvk[l_ac].rvk04
                 NEXT FIELD rvk04
              END IF
              IF NOT cl_null(g_rvk[l_ac].rvk02) THEN
                 SELECT COUNT(*) INTO l_n FROM rvk_file WHERE rvk01=g_rvk01 AND rvk02=g_rvk[l_ac].rvk02 AND rvk04=g_rvk[l_ac].rvk04 AND rvkacti='Y'
                 IF l_n>0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rvk[l_ac].rvk04=g_rvk_t.rvk04
                    DISPLAY BY NAME g_rvk[l_ac].rvk04
                    NEXT FIELD rvk04
                 END IF
              END IF
              IF NOT cl_null(g_rvk[l_ac].rvk03) THEN
                 SELECT COUNT(*) INTO l_n FROM imd_file WHERE imd01 = g_rvk[l_ac].rvk03 AND imdacti ='Y' AND imd11='Y' AND imd20<>g_rvk[l_ac].rvk04
                 IF l_n=0 THEN
                    CALL cl_err('','art-255',0)
                    LET g_rvk[l_ac].rvk04=g_rvk_t.rvk04
                    DISPLAY BY NAME g_rvk[l_ac].rvk04
                    NEXT FIELD rvk04
                 END IF
              END IF
           END IF
        END IF
 
       BEFORE DELETE
           IF NOT cl_null(g_rvk_t.rvk02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rvk_file
                  WHERE rvk01 = g_rvk01 AND rvk02 = g_rvk_t.rvk02 AND rvk04 = g_rvk_t.rvk04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rvk_file",g_rvk01,g_rvk_t.rvk02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rvk[l_ac].* = g_rvk_t.*
              CLOSE i162_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rvk[l_ac].rvk02,-263,1)
              LET g_rvk[l_ac].* = g_rvk_t.*
           ELSE
             
              UPDATE rvk_file SET  rvk04 = g_rvk[l_ac].rvk04,
                                   rvk02 = g_rvk[l_ac].rvk02,
                                   rvk03 = g_rvk[l_ac].rvk03,
                                   rvkacti = g_rvk[l_ac].rvkacti
                 WHERE rvk01=g_rvk01
                   AND rvk02=g_rvk_t.rvk02
                   AND rvk04=g_rvk_t.rvk04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rvk_file",g_rvk01,g_rvk_t.rvk02,SQLCA.sqlcode,"","",1) 
                 LET g_rvk[l_ac].* = g_rvk_t.*
              ELSE
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac     #FUN-D30033 mark
     
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rvk[l_ac].* = g_rvk_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rvk.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE i162_bcl
              ROLLBACK WORK
              EXIT INPUT
#FUN-D30033--mark--str--
##FUN-B40022 --begin
#           ELSE
##FUN-B60114 --begin----------------
#              IF l_ac > g_rec_b THEN
#                 CALL g_rvk.deleteElement(l_ac)
#              END IF
#FUN-D30033--mark--end--
#FUN-B60114 --end------------------
             # IF cl_null(g_rvk[l_ac].rvk03) THEN 
             #    NEXT FIELD rvk03
             # END IF 
#FUN-B40022 --end--                    
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 add
           CLOSE i162_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF (INFIELD(rvk02) OR INFIELD(rvk04)) AND l_ac > 1 THEN  #TQC-A40001 add
              LET g_rvk[

l_ac].* = g_rvk[l_ac-1].*
             #LET g_rvk[l_ac].rvk02 = g_rec_b + 1                   #TQC-A40001 mark 
             #NEXT FIELD rvk02
              NEXT FIELD CURRENT 
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
                     
        ON ACTION controlp                         
          CASE
           WHEN INFIELD(rvk02)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oba01"
               LET g_qryparam.arg1 = g_rvk01
               LET g_qryparam.default1 = g_rvk[l_ac].rvk02
               CALL cl_create_qry() RETURNING g_rvk[l_ac].rvk02
               DISPLAY BY NAME g_rvk[l_ac].rvk02
               CALL i162_rvk02('a')
               NEXT FIELD rvk02
           WHEN INFIELD(rvk03)
               CALL cl_init_qry_var()
               IF g_rvk[l_ac].rvk04 IS NULL OR g_rvk[l_ac].rvk04 = '*' THEN
                  LET g_qryparam.form ="q_imd01"
               #FUN-B60114 add begin----------------
               ELSE
                  LET g_qryparam.form ="q_imd01_4"
               END IF 
               #FUN-B60114 add end-----------------
               LET g_qryparam.default1 = g_rvk[l_ac].rvk03
               LET g_qryparam.arg1 = g_rvk[l_ac].rvk04
               CALL cl_create_qry() RETURNING g_rvk[l_ac].rvk03
               DISPLAY BY NAME g_rvk[l_ac].rvk03
               CALL i162_rvk03('a')
               NEXT FIELD rvk03
           WHEN INFIELD(rvk04)
#FUN-B40022 --begin--           
             IF p_cmd = 'a' AND cl_null(g_rvk[l_ac].rvk04) THEN 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp_mul"
               LET g_qryparam.state='c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
              IF NOT cl_null(g_qryparam.multiret) THEN
                  CALL i162_mul_rvk04()
                  CALL i162_b_fill(' 1=1')
                  LET g_flag = TRUE
                  EXIT INPUT
               END IF                  	               
             ELSE                 
#FUN-B40022 --end--             	
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_rvk[l_ac].rvk04
               CALL cl_create_qry() RETURNING g_rvk[l_ac].rvk04
               DISPLAY BY NAME g_rvk[l_ac].rvk04
               CALL i162_rvk04('a')
               NEXT FIELD rvk04
            END IF           #FUN-B40022                
            
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
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

#FUN-B40022 --begin--
    IF g_flag THEN 
       LET g_flag = FALSE 
       CALL i162_b()
    END IF 
#FUN-B40022 --end--   
  
    CLOSE i162_bcl
    COMMIT WORK
    CALL i162_show()
    
END FUNCTION

#FUN-B40022 --begin--
FUNCTION i162_mul_rvk04()
DEFINE   tok          base.StringTokenizer
DEFINE   l_rvk        RECORD LIKE rvk_file.*
DEFINE   l_n          LIKE type_file.num5 

    CALL s_showmsg_init()
    
    LET tok = base.StringTokenizer.create(g_qryparam.multiret,"|") 
        WHILE tok.hasMoreTokens()
           LET l_rvk.rvk04 = tok.nextToken()
           
           LET l_rvk.rvk01 = g_rvk01 
           LET l_rvk.rvk02 = '*'
           LET l_rvk.rvkacti = 'Y'
           LET l_rvk.rvkcrat = g_today
           LET l_rvk.rvkdate = NULL 
           LET l_rvk.rvkgrup = g_grup
           LET l_rvk.rvkmodu = NULL 
           LET l_rvk.rvkuser = g_user 
           LET l_rvk.rvkorig = g_grup
           LET l_rvk.rvkoriu = g_user                        
           
           LET l_n = 0 
           SELECT COUNT(*) INTO l_n FROM rvk_file
            WHERE rvk01 = l_rvk.rvk01
              AND rvk02 = l_rvk.rvk02
              AND rvk04 = l_rvk.rvk04
           IF l_n > 0  THEN 
              CALL cl_err(l_rvk.rvk04,'-239',0)
              CONTINUE WHILE 
           END IF                            

           INSERT INTO rvk_file VALUES (l_rvk.*)
           IF SQLCA.sqlcode THEN
              CALL s_errmsg(l_rvk.rvk04,'','INS rvk_file',SQLCA.sqlcode,1) 
              CONTINUE WHILE
           END IF
        END WHILE
        
    CALL s_showmsg()
END FUNCTION 
#FUN-B40022 --end--
 
FUNCTION i162_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rvk_file
      WHERE rvk01 = g_rvk01
 
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rvk_file WHERE rvk01 = g_rvk01
   END IF
 
END FUNCTION
 
FUNCTION i162_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rvk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT rvk01 INTO g_rvk01 FROM rvk_file
    WHERE rvk01=g_rvk01
 
   IF g_rvk[l_ac].rvkacti ='N' THEN    
      CALL cl_err(g_rvk01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rvk01_t = g_rvk01
   BEGIN WORK
 
   CALL i162_show()
 
   WHILE TRUE
      LET g_rvk01_t = g_rvk01
 
      CALL i162_i("u")                         
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rvk01=g_rvk01_t
         CALL i162_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE rvk_file SET rvk01 = g_rvk01
       WHERE rvk01 = g_rvk01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rvk_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   COMMIT WORK
   CALL i162_show()
   CALL cl_flow_notify(g_rvk01,'U')
 
   CALL i162_b_fill("1=1")
   CALL i162_bp_refresh()
 
END FUNCTION
 
FUNCTION i162_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rvk01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM rvk_file WHERE rvk01 = g_rvk01
      CLEAR FORM
      CALL g_rvk.clear()
      OPEN i162_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i162_cs
         CLOSE i162_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i162_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i162_cs
         CLOSE i162_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i162_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i162_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i162_fetch('/')
         END IF
      END IF
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i162_copy()
DEFINE   l_newno     LIKE rvk_file.rvk01,
          l_oldno     LIKE rvk_file.rvk01,
          l_cnt       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rvk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rvk01
 
       AFTER FIELD rvk01
          IF l_newno IS NOT NULL THEN
              SELECT COUNT(*) INTO l_cnt FROM rvk_file
                  WHERE rvk01 = l_newno AND rvkacti = 'Y'
              IF l_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD rvk01
              END IF
              IF SQLCA.sqlcode THEN
                  DISPLAY BY NAME g_rvk01
                  LET l_newno = NULL
                  NEXT FIELD rvk01
              END IF
           END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rvk01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem" 
                LET g_qryparam.default1 = g_rvk01
                CALL cl_create_qry() RETURNING l_newno
                DISPLAY l_newno TO rvk01
              NEXT FIELD rvk01
              OTHERWISE EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION HELP
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
   END INPUT
 
   BEGIN WORK
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_rvk01 TO rvk01
      ROLLBACK WORK  
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rvk_file         
       WHERE rvk01=g_rvk01 AND rvkacti = 'Y'
       INTO TEMP y
 
   UPDATE y
       SET rvk01=l_newno
 
   INSERT INTO rvk_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rvk_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
       COMMIT WORK 
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rvk01
   LET g_rvk01 = l_newno
   CALL i162_b()
   #LET g_rvk01 = l_oldno  #FUN-C80046
   #CALL i162_show()       #FUN-C80046
 
END FUNCTION
 
FUNCTION i162_bp_refresh()
  DISPLAY ARRAY g_rvk TO s_rvk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL i162_show()
END FUNCTION
 
FUNCTION i162_out()
#p_query
DEFINE l_cmd  STRING
 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    LET l_cmd = 'p_query "arti162" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd) 
 
END FUNCTION
 
FUNCTION i162_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("rvk01,rvk02",TRUE)
        END IF
END FUNCTION
 
FUNCTION i162_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("rvk01,rvk02",FALSE)
        END IF
END FUNCTION
#FUN-870100 
