# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"arti110.4gl"
#Descriptions..: 采購類型維護
#Date & Author..:08/07/28 By lala
# Modify.........: No:FUN-870100 09/06/29 By lala add rty12  del pos  azp->azp
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10037 10/01/09 By bnlent 採購中心字段管控採購類型為2或4時非空
# Modify.........: No:TQC-A30154 10/05/31 By Cockroach 預設上筆資料有誤
# Modify.........: No:TQC-A60046 10/06/21 By chenmoyan 跨庫語句MSV版本有誤
# Modify.........: No:FUN-A50102 10/07/14 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-A70003 10/07/23 By huangtao 新增最高存量的欄位 
# Modify.........: No:TQC-A70122 10/07/29 By vealxu sql語句錯誤，from 相同的table
# Modify.........: No:FUN-A80121 10/08/23 By shenyang  單身選擇料件可以多選，多選后自動生成多筆單身資料
# Modify.........: No:FUN-A90048 10/09/27 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No:FUN-AA0047 10/10/20 By huangtao 修改錄入rty02報錯的bug
# Modify.........: No:TQC-AB0135 10/11/28 By huangtao
# Modify.........: No:TQC-AC0224 10/12/17 By suncx 統倉統配必須輸入配送中心信息
# Modify.........: No:TQC-B20056 11/02/17 By huangtao 配送中心不在check部門資料檔
# Modify.........: No:FUN-B40050 11/04/18 By shiwuying 批量产生时加企业料号控管
# Modify.........: No:FUN-B40044 11/04/26 By shiwuying MISC*料号产品名称修改
# Modify.........: No:FUN-B40043 11/04/26 By shiwuying 产品策略判断修改
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60007 11/06/02 By lixia 修改產品編號未帶出相應的產品名稱
# Modify.........: No.TQC-B80177 11/08/24 By lixia 退出異常
# Modify.........: No.TQC-C40061 12/04/11 By fanbj 採購中心為統倉統配時必須輸入配送中心，配送中心欄位的背景顏色需改為相應的必輸的顏色
# Modify.........: No.FUN-C60086 12/06/25 By xjll   arti110 產品策略開窗在服飾流通行業下不可開母料件編號
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90049 12/10/04 By Lori 新增預設成本倉rty14和非預設成本倉rty15
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40114 13/04/16 By Sakura 可超交比率%(rty07)可輸入0,且修改錯誤碼代號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rty01         LIKE rty_file.rty01,
        g_rty01_t       LIKE rty_file.rty01,
        g_rty   DYNAMIC ARRAY OF RECORD 
                rty02   LIKE rty_file.rty02,
                rty02_desc LIKE ima_file.ima02,
                rty14   LIKE rty_file.rty14,      #FUN-C90049 add
                rty15   LIKE rty_file.rty15,      #FUN-C90049 add 
                rty03   LIKE rty_file.rty03,
                rty04   LIKE rty_file.rty04,
                rty04_desc LIKE gem_file.gem02,
                rty12   LIKE rty_file.rty12,    #FUN-870100
                rty12_desc LIKE geu_file.geu02, #FUN-870100
                rty05   LIKE rty_file.rty05,
                rty06   LIKE rty_file.rty06,
                rty07   LIKE rty_file.rty07,
                rty08   LIKE rty_file.rty08,
                rty09   LIKE rty_file.rty09,
                rty10   LIKE rty_file.rty10,
                rty11   LIKE rty_file.rty11,
                rtyacti LIKE rty_file.rtyacti,
                rty13   LIKE rty_file.rty13    #TQC-A70003
                #rtypos  LIKE rty_file.rtypos  #FUN-870100
                        END RECORD,
        g_rty_t RECORD
                rty02   LIKE rty_file.rty02,
                rty02_desc LIKE ima_file.ima02,
                rty14   LIKE rty_file.rty14,    #FUN-C90049 add
                rty15   LIKE rty_file.rty15,    #FUN-C90049 add
                rty03   LIKE rty_file.rty03,
                rty04   LIKE rty_file.rty04,
                rty04_desc LIKE gem_file.gem02,
                rty12   LIKE rty_file.rty12,    #FUN-870100
                rty12_desc LIKE geu_file.geu02, #FUN-870100
                rty05   LIKE rty_file.rty05,
                rty06   LIKE rty_file.rty06,
                rty07   LIKE rty_file.rty07,
                rty08   LIKE rty_file.rty08,
                rty09   LIKE rty_file.rty09,
                rty10   LIKE rty_file.rty10,
                rty11   LIKE rty_file.rty11,
                rtyacti LIKE rty_file.rtyacti,
                rty13   LIKE rty_file.rty13     #TQC-A70003
                #rtypos  LIKE rty_file.rtypos  #FUN-870100
                        END RECORD,
        g_rty_o RECORD
                rty02   LIKE rty_file.rty02,
                rty02_desc LIKE ima_file.ima02,
                rty14   LIKE rty_file.rty14,    #FUN-C90049 add
                rty15   LIKE rty_file.rty15,    #FUN-C90049 add
                rty03   LIKE rty_file.rty03,
                rty04   LIKE rty_file.rty04,
                rty04_desc LIKE gem_file.gem02,
                rty12   LIKE rty_file.rty12,    #FUN-870100
                rty12_desc LIKE geu_file.geu02, #FUN-870100
                rty05   LIKE rty_file.rty05,
                rty06   LIKE rty_file.rty06,
                rty07   LIKE rty_file.rty07,
                rty08   LIKE rty_file.rty08,
                rty09   LIKE rty_file.rty09,
                rty10   LIKE rty_file.rty10,
                rty11   LIKE rty_file.rty11,
                rtyacti LIKE rty_file.rtyacti,
                rty13   LIKE rty_file.rty13    #TQC-A70003
                #rtypos  LIKE rty_file.rtypos  #FUN-870100
                        END RECORD
DEFINE g_sql   STRING,
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
DEFINE g_multi_ima01  STRING
DEFINE l_line    STRING
DEFINE g_flag              LIKE type_file.num5
#FUN-C90049 add begin---
DEFINE g_rtz      RECORD
          rtz07   LIKE rtz_file.rtz07,
          rtz08   LIKE rtz_file.rtz08
                  END RECORD
#FUN-C90049 add end-----
 
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
    OPEN WINDOW i110_w AT p_row,p_col WITH FORM "art/42f/arti110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL i110_menu()
    
    CLOSE WINDOW i110_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i110_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rty TO s_rty.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
      ON ACTION first
         CALL i110_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i110_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i110_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i110_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i110_fetch('L')
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
      
      ON ACTION acti
         LET g_action_choice="acti"
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
 
FUNCTION i110_menu()
 
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL i110_a()
            END IF
#         WHEN "delete"
#            IF cl_chk_act_auth() THEN
#               CALL i110_r()
#            END IF
#         WHEN "modify"
#            IF cl_chk_act_auth() THEN
#               CALL i110_u()
#            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i110_copy()
            END IF
         WHEN "next"
            CALL i110_fetch('N')
         WHEN "previous"
            CALL i110_fetch('P')
         WHEN "jump"
            CALL i110_fetch('/')
         WHEN "first"
            CALL i110_fetch('F')
         WHEN "last"
            CALL i110_fetch('L')
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
            END IF
         WHEN "acti"
            IF cl_chk_act_auth() THEN
               CALL i110_acti()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i110_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rty),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i110_cs()
 
    CLEAR FORM
    CALL g_rty.clear()
    
    CONSTRUCT g_wc ON rty01,rty02,rty14,rty15,rty03,rty04,rty12,rty05,rty06,rty07,rty08,rty09,rty10,rty11,rtyacti,rty13 FROM        #FUN-870100  #TQC-A70003  #FUN-C90049 add rty14,rty15                    
        rty01,
        s_rty[1].rty02,s_rty[1].rty14,s_rty[1].rty15,s_rty[1].rty03,s_rty[1].rty04,s_rty[1].rty12,s_rty[1].rty05,s_rty[1].rty06,s_rty[1].rty07,        #FUN-870100    #FUN-C90049 add rty14,rty15
        s_rty[1].rty08,s_rty[1].rty09,s_rty[1].rty10,s_rty[1].rty11,s_rty[1].rtyacti,s_rty[1].rty13                     #FUN-870100  #TQC-A70003 
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rty01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rty01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty01
                 CALL i110_rty01('a')
                 NEXT FIELD rty01
               WHEN INFIELD(rty02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rty02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty02
                #CALL i110_rty02('a') #FUN-A90048
                 NEXT FIELD rty02
               WHEN INFIELD(rty04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rty04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty04
                 CALL i110_rty04('a')
                 NEXT FIELD rty04
               WHEN INFIELD(rty05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rty05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty05
                 CALL i110_rty05('a')
                 NEXT FIELD rty05
               WHEN INFIELD(rty10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rty10"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty10
                 NEXT FIELD rty10
               WHEN INFIELD(rty11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rty11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty11
                 NEXT FIELD rty11
               #No.FUN-870100---begin
               WHEN INFIELD(rty12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_geu"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '4'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rty12
                 CALL i110_rty12('d')
                 NEXT FIELD rty12
               #No.FUN-870100---end
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN 
        RETURN
    END IF
      
    LET g_sql="SELECT DISTINCT rty01 FROM rty_file WHERE ",
        " rty01 IN ",g_auth,
        " AND ",g_wc CLIPPED, " ORDER BY rty01"
 
    PREPARE i110_prepare FROM g_sql
    DECLARE i110_cs SCROLL CURSOR WITH HOLD FOR i110_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT rty01) FROM rty_file WHERE ",
              " rty01 IN ",g_auth,
              " AND ",g_wc CLIPPED
 
    PREPARE i110_precount FROM g_sql
    DECLARE i110_count CURSOR FOR i110_precount
 
END FUNCTION
 
FUNCTION i110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
 
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_rty.clear()
    MESSAGE ""
    DISPLAY ' ' TO FORMONLY.cnt
 
    CALL i110_cs()              
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rty01 TO NULL
        RETURN
    END IF
 
    OPEN i110_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rty.clear()
    ELSE
        OPEN i110_count
        FETCH i110_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt
           CALL i110_fetch('F')
        ELSE
           CALL cl_err('',100,0)
        END IF
    END IF
END FUNCTION
 
FUNCTION i110_fetch(p_flrty)
    DEFINE
        p_flrty         LIKE type_file.chr1
    CASE p_flrty
        WHEN 'N' FETCH NEXT     i110_cs INTO g_rty01
        WHEN 'P' FETCH PREVIOUS i110_cs INTO g_rty01
        WHEN 'F' FETCH FIRST    i110_cs INTO g_rty01
        WHEN 'L' FETCH LAST     i110_cs INTO g_rty01
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
            FETCH ABSOLUTE g_jump i110_cs INTO g_rty01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rty01,SQLCA.sqlcode,0)
        INITIALIZE g_rty01 TO NULL  
        RETURN
    ELSE
      CASE p_flrty
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    CALL i110_show()
 
END FUNCTION
 
FUNCTION i110_acti()
 
   IF (g_rty01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   UPDATE rty_file
      SET rtyacti='Y'
    WHERE rty01=g_rty01
    IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","rty_file",g_rty01,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   CALL i110_show()
 
END FUNCTION
 
FUNCTION i110_rty01(p_cmd)         
DEFINE  p_cmd        LIKE type_file.chr1 
DEFINE  l_rty01_desc LIKE azp_file.azp02,
        l_tqa01      LIKE rtz_file.rtz02,
        l_tqa01_desc LIKE tqa_file.tqa02,
        l_azw07      LIKE azw_file.azw07,
        l_azw07_desc LIKE azp_file.azp02,
        l_tqaacti    LIKE tqa_file.tqaacti
 
   LET g_errno = ' '
   
  SELECT azp02 INTO l_rty01_desc FROM azp_file WHERE azp01 = g_rty01
  SELECT rtz02 INTO l_tqa01 FROM rtz_file WHERE rtz01 = g_rty01
  SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01 = g_rty01
   CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-193'
                                 LET l_rty01_desc = NULL
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   IF cl_null(l_azw07) AND NOT cl_null(l_rty01_desc) AND NOT cl_null(l_tqa01) THEN
      LET g_errno = ''
   END IF
 
   SELECT tqa02,tqaacti INTO l_tqa01_desc,l_tqaacti 
     FROM tqa_file WHERE tqa01 = l_tqa01 AND tqa03 = '14' 
  CASE
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-175'
                                 LET l_tqa01_desc = NULL
        WHEN l_tqaacti='N'       LET g_errno='9028'
        OTHERWISE
        LET g_errno=SQLCA.sqlcode USING '------'
  END CASE
 
  SELECT azp02 INTO l_azw07_desc FROM azp_file WHERE azp01 = l_azw07
  CASE
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-174'
                                 LET l_azw07_desc = NULL
        OTHERWISE
        LET g_errno=SQLCA.sqlcode USING '------'
  END CASE
 
  IF cl_null(l_azw07) AND NOT cl_null(l_rty01_desc) AND NOT cl_null(l_tqa01) THEN
      LET g_errno = ''
  END IF
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_rty01_desc TO FORMONLY.rty01_desc
      DISPLAY l_tqa01 TO FORMONLY.tqa01
      DISPLAY l_azw07 TO FORMONLY.azw07
      DISPLAY l_tqa01_desc TO FORMONLY.tqa01_desc
      DISPLAY l_azw07_desc TO FORMONLY.azw07_desc
  END IF
 
END FUNCTION
 
FUNCTION i110_rty02(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1
DEFINE  l_rty02_desc    LIKE ima_file.ima02,
        l_imaacti       LIKE ima_file.imaacti
        
    LET g_errno=''
   #FUN-B40044 Begin---
    IF g_rty[l_ac].rty02[1,4]='MISC' THEN
       SELECT ima02 INTO l_rty02_desc FROM ima_file WHERE ima01='MISC'
       IF NOT SQLCA.sqlcode THEN
          LET g_rty[l_ac].rty02_desc = l_rty02_desc
       END IF
    ELSE
   #FUN-B40044 End-----
    SELECT ima02,imaacti INTO l_rty02_desc,l_imaacti FROM ima_file WHERE ima01 = g_rty[l_ac].rty02 AND imaacti='Y'
    CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-030' 
                                 LET l_rty02_desc = NULL 
        WHEN l_imaacti='N'       LET g_errno='9028'
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   END IF #FUN-B40044
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rty[l_ac].rty02_desc = l_rty02_desc
      DISPLAY BY NAME g_rty[l_ac].rty02_desc
   END IF
END FUNCTION
 
#TQC-B20056 ---------------------STA
#FUNCTION i110_rty04(p_cmd)
#DEFINE  p_cmd      LIKE type_file.chr1
#DEFINE  l_rty04_desc    LIKE gem_file.gem02,
#       l_gemacti       LIKE gem_file.gemacti
#       
#   LET g_errno=''
#   IF g_rty[l_ac].rty03 MATCHES '[234]' THEN
#      SELECT gem02,gemacti INTO l_rty04_desc,l_gemacti FROM gem_file WHERE gem01 = g_rty[l_ac].rty04 AND gemacti='Y'
#      CASE                          
#          WHEN SQLCA.sqlcode=100   LET g_errno = 'art-188' 
#                                   LET l_rty04_desc = NULL 
#          WHEN l_gemacti='N'       LET g_errno='9028'
#          OTHERWISE
#          LET g_errno=SQLCA.sqlcode USING '------'
#      END CASE
#      IF cl_null(g_errno) OR p_cmd = 'd' THEN
#         LET g_rty[l_ac].rty04_desc = l_rty04_desc
#         DISPLAY BY NAME g_rty[l_ac].rty04_desc
#      END IF
#   END IF
#END FUNCTION

FUNCTION i110_rty04(p_cmd)
DEFINE  p_cmd           LIKE type_file.chr1
DEFINE  l_rty04_desc    LIKE geu_file.geu02
DEFINE  l_geuacti       LIKE geu_file.geuacti
   LET g_errno=''
   IF g_rty[l_ac].rty03 MATCHES '[234]' THEN
      SELECT geu02,geuacti INTO l_rty04_desc,l_geuacti FROM geu_file WHERE geu00 = '8' AND geu01 = g_rty[l_ac].rty04 AND geuacti = 'Y'
      CASE
         WHEN SQLCA.sqlcode=100   LET g_errno = 'art-188'
                                  LET l_rty04_desc = NULL
         WHEN l_geuacti='N'       LET g_errno='9028'
         OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
      END CASE
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
         LET g_rty[l_ac].rty04_desc = l_rty04_desc
         DISPLAY BY NAME g_rty[l_ac].rty04_desc
      END IF
   END IF
END FUNCTION
#TQC-B20056 ----------------------END
 
FUNCTION i110_rty05(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1
DEFINE  l_rty01    LIKE azp_file.azp01
DEFINE  l_rty06    LIKE gem_file.gem02
DEFINE  l_rtoconf  LIKE gem_file.gemacti
DEFINE  l_rtt01    LIKE rtt_file.rtt01
DEFINE  l_rtt02    LIKE rtt_file.rtt02
DEFINE  l_rts04    LIKE rts_file.rts04
DEFINE  l_n        LIKE type_file.num5
DEFINE  l_sql      STRING
#DEFINE  l_dbs      LIKE azp_file.azp03     #FUN-A50102 mark
   
    LET l_n = 0
    LET l_sql = ''
    LET g_errno=''
#FUN-A50102 ---------------modify start----------------------------------------
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_rty01
##TQC-A60046 --Begin
##   LET l_sql =" SELECT COUNT(*) FROM ",l_dbs CLIPPED,".rtt_file,",
##                                       l_dbs CLIPPED,".rts_file,",
##                                       l_dbs CLIPPED,".rto_file ",
#    LET l_sql =" SELECT COUNT(*) FROM ",s_dbstring(l_dbs CLIPPED),"rtt_file,",
#                                        s_dbstring(l_dbs CLIPPED),"rts_file,",
#                                        s_dbstring(l_dbs CLIPPED),"rto_file ",
##TQC-A60046 --End
     LET l_sql =" SELECT COUNT(*) FROM ",cl_get_target_table(g_rty01,'rtt_file'),",",
                                       # cl_get_target_table(g_rty01,'rtt_file'),",",     #TQC-A70122  mark
                                       # cl_get_target_table(g_rty01,'rtt_file'),         #TQC-A70122  mark
                                         cl_get_target_table(g_rty01,'rts_file'),",",     #TQC-A70122
                                         cl_get_target_table(g_rty01,'rto_file'),         #TQC-A70122  
#FUN-A550102 ---------------modify end----------------------------------------
               " WHERE rtt04 = '",g_rty[l_ac].rty02,"' ",
               "   AND rttplant = '",g_rty01,"' AND rtt15 = 'Y' ",
               "   AND rts01 = rtt01 AND rts02 = rtt02  ",
               "   AND rto01 = rts04 AND rto03 = rts02  ",
               "   AND rtsplant = '",g_rty01,"' ",
               "   AND rtsconf = 'Y' AND rto05 = '",g_rty[l_ac].rty05,"' ", 
               "   AND rtoconf ='Y' ",
               "   AND rto08 <= '",g_today,"' ",
               "   AND rto09 >= '",g_today,"' ",
               "   AND rtoplant = '",g_rty01,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102 
    CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql    #FUN-A50102  
    PREPARE s_rtt_pb FROM l_sql
    EXECUTE s_rtt_pb INTO l_n
    IF l_n>0 THEN
#TQC-A60046 --Begin
#   LET l_sql =" SELECT DISTINCT rto06 FROM ",l_dbs CLIPPED,".rtt_file,",
#                                       l_dbs CLIPPED,".rts_file,",
#                                       l_dbs CLIPPED,".rto_file ",
#   LET l_sql =" SELECT DISTINCT rto06 FROM ",s_dbstring(l_dbs CLIPPED),"rtt_file,",       #FUN-A50102 mark
#                                       s_dbstring(l_dbs CLIPPED),"rts_file,",             #FUN-A50102 mark
#                                       s_dbstring(l_dbs CLIPPED),"rto_file ",             #FUN-A50102 mark
    LET l_sql =" SELECT DISTINCT rto06 FROM ",cl_get_target_table(g_rty01,'rtt_file'),",", #FUN-A50102
                                              cl_get_target_table(g_rty01,'rts_file'),",", #FUN-A50102
                                              cl_get_target_table(g_rty01,'rto_file'),     #FUN-A50102
#TQC-A60046 --End
               " WHERE rtt04 = '",g_rty[l_ac].rty02,"' ",
               "   AND rttplant = '",g_rty01,"' AND rtt15 = 'Y' ",
               "   AND rts01 = rtt01 AND rts02 = rtt02  ",
               "   AND rto01 = rts04 AND rto03 = rts02  ",
               "   AND rtsplant = '",g_rty01,"' ",
               "   AND rtsconf = 'Y' AND rto05 = '",g_rty[l_ac].rty05,"' ", 
               "   AND rtoconf ='Y' ",
               "   AND rto08 <= '",g_today,"' ",
               "   AND rto09 >= '",g_today,"' ",
               "   AND rtoplant = '",g_rty01,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql   #FUN-A50102 
            PREPARE s_rtt1_pb FROM l_sql
            EXECUTE s_rtt1_pb INTO l_rty06
    END IF
 
 
   IF NOT cl_null(l_rty06) THEN
      LET g_rty[l_ac].rty06 = l_rty06
      DISPLAY BY NAME g_rty[l_ac].rty06
   END IF
 
   IF l_n=0 THEN
      LET l_sql =" SELECT COUNT(*) ", 
#                "   FROM  ",l_dbs,".pmc_file  ",#TQC-A60046
#                "   FROM  ",s_dbstring(l_dbs CLIPPED),"pmc_file  ",#TQC-A60046    #FUN-A50102 mark
                 "   FROM  ",cl_get_target_table(g_rty01,'pmc_file'),              #FUN-A50102
                 "  WHERE pmc01= '",g_rty[l_ac].rty05,"'  ",
                 "    AND pmcacti='Y' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql     #FUN-A50102   
      PREPARE s_pmc_pb FROM l_sql
      EXECUTE s_pmc_pb INTO l_n
      IF SQLCA.sqlcode THEN   
        CALL cl_err3("sel","pmc_file",g_rty[l_ac].rty05,"",SQLCA.sqlcode,"","",1)
        RETURN 
      END IF  
      IF l_n >0 THEN
         LET g_rty[l_ac].rty06 = '1'
         DISPLAY BY NAME g_rty[l_ac].rty06
      ELSE
         LET g_errno = 100
      END IF
   END IF
 
END FUNCTION
#No.FUN-870100---begin
FUNCTION i110_rty12(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1
DEFINE  l_rty12_desc    LIKE geu_file.geu02,
        l_geuacti       LIKE geu_file.geuacti
        
    LET g_errno=''
    SELECT geu02,geuacti INTO l_rty12_desc,l_geuacti
      FROM geu_file 
     WHERE geu01 = g_rty[l_ac].rty12 AND geu00='4'
    CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno = 'art-591'   
                                 LET l_rty12_desc = NULL 
        WHEN l_geuacti='N'       LET g_errno='9028'
        OTHERWISE   
        LET g_errno=SQLCA.sqlcode USING '------' 
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rty[l_ac].rty12_desc = l_rty12_desc
      DISPLAY BY NAME g_rty[l_ac].rty12_desc
   END IF
END FUNCTION
#No.FUN-870100---end
FUNCTION i110_show()
    DISPLAY g_rty01 TO rty01
    CALL i110_rty01('d')
    CALL i110_b_fill(g_wc)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)
DEFINE   p_wc2       STRING
DEFINE  l_rty02_desc    LIKE ima_file.ima02,
 #       l_rty04_desc    LIKE gem_file.gem02,                 #TQC-B20056 mark
        l_rty04_desc    LIKE geu_file.geu02,                  #TQC-B20056  
        l_rty06         LIKE gem_file.gem02
    LET g_sql =
        "SELECT rty02,'',rty14,rty15,rty03,rty04,'',rty12,'',rty05,rty06,rty07,rty08,rty09,rty10,rty11,rtyacti,rty13 FROM rty_file ",  #FUN-870100    #TQC-A70003   #FUN-C90049 add rty14,rty15
        " WHERE rty01= '",g_rty01,"'"
        
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    PREPARE i110_pb FROM g_sql
    DECLARE rty_cs CURSOR FOR i110_pb
 
    CALL g_rty.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rty_cs INTO g_rty[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
       #FUN-B40044 Begin---
       #SELECT ima02 INTO g_rty[g_cnt].rty02_desc FROM ima_file WHERE ima01 = g_rty[g_cnt].rty02 AND imaacti = 'Y'
        IF g_rty[g_cnt].rty02[1,4]='MISC' THEN
           SELECT ima02 INTO g_rty[g_cnt].rty02_desc
             FROM ima_file WHERE ima01='MISC'
        ELSE
           SELECT ima02 INTO g_rty[g_cnt].rty02_desc FROM ima_file
            WHERE ima01 = g_rty[g_cnt].rty02 AND imaacti = 'Y'
        END IF
       #FUN-B40044 End-----
       #SELECT gem02 INTO g_rty[g_cnt].rty04_desc FROM gem_file WHERE gem01 = g_rty[g_cnt].rty04 AND gemacti = 'Y'     #TQC-B20056 mark
       SELECT geu02 INTO g_rty[g_cnt].rty04_desc FROM geu_file WHERE geu01 = g_rty[g_cnt].rty04 AND geuacti = 'Y' AND geu00 = '8'     #TQC-B20056
       SELECT geu02 INTO g_rty[g_cnt].rty12_desc FROM geu_file WHERE geu01 = g_rty[g_cnt].rty12 AND geuacti = 'Y' #FUN-870100 ADD
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_rty.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i110_action()
#TQC-AB0135 -----------STA
  DEFINE l_rtz04 LIKE rtz_file.rtz04

  SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rty01
  IF cl_null(l_rtz04) OR STATUS = 100 THEN
     RETURN
  END IF
#TQC-AB0135 -----------END
  IF cl_confirm("art-221") THEN
     CALL i110_default_store()   #FUN-C90049
     LET g_cnt=1
     DECLARE rte_cury CURSOR FOR
             SELECT rte03
            #FUN-B40050 Begin---
            #FROM rte_file
            #WHERE rte01 IN (select rtz04 from rtz_file WHERE rtz01 = g_rty01)
               FROM rte_file,ima_file
              WHERE rte01 IN (select rtz04 from rtz_file WHERE rtz01 = g_rty01)
                AND ima01 = rte03
                AND (ima120 = '1' OR ima120 IS NULL OR ima120 = ' ')
            #FUN-B40050 End-----
       FOREACH rte_cury INTO g_rty[g_cnt].rty02
       INSERT INTO rty_file (rty01,rty02,rtyacti,rty14,rty15)                  #FUN-C90049 add rty14,rty15
          VALUES (g_rty01,g_rty[g_cnt].rty02,'N',g_rtz.rtz07,g_rtz.rtz08)      #FUN-C90049 add g_rtz.rtz07,g_rtz.rtz08
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","rty_file",'','',SQLCA.sqlcode,"","",1)
       END IF
      LET g_cnt=g_cnt+1
 
      END FOREACH
      COMMIT WORK
  END IF
  
END FUNCTION
 
FUNCTION i110_a()
DEFINE   l_n       LIKE type_file.num5
 
   MESSAGE ""
 
   CLEAR FORM
   CALL g_rty.clear()
   LET g_wc = NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i110_i('a')
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_rty01) THEN
         CONTINUE WHILE
      END IF
 
      SELECT COUNT(*) INTO l_n FROM rty_file WHERE rty01 = g_rty01
      IF l_n>0 THEN
         CALL cl_err('','art-456',1)
         RETURN
      ELSE
         CALL i110_action()
      END IF
      CALL i110_b_fill(' 1=1')
      CALL i110_b()
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i110_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_n       LIKE type_file.num5
 
   CALL cl_set_head_visible("","YES")
   
   INPUT g_rty01 WITHOUT DEFAULTS      
     FROM rty01
 
      AFTER FIELD rty01
         IF NOT cl_null(g_rty01) THEN
            LET g_sql= "SELECT COUNT(*) FROM azp_file WHERE azp01=? AND azp01 IN ",g_auth
            PREPARE azp_count FROM g_sql
            EXECUTE azp_count USING g_rty01 INTO l_n
            IF l_n>0 THEN
               CALL i110_rty01('a')
            ELSE
               CALL cl_err('','art-457',1)
               LET g_rty01=g_rty01_t
               DISPLAY BY NAME g_rty01
            END IF
         END IF

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rty01)  THEN
              NEXT FIELD rty01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rty01) THEN
 #           LET g_rty.* = g_rty_t.*
            CALL i110_show()
            NEXT FIELD rty01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rty01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_rty01
              CALL cl_create_qry() RETURNING g_rty01
              DISPLAY BY NAME g_rty01
              NEXT FIELD rty01
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
 
FUNCTION i110_b()
DEFINE         l_ac_t  LIKE type_file.num5,
               l_n     LIKE type_file.num5,
               l_n1    LIKE type_file.num5,
               azp_1   LIKE type_file.num5,
               azp_2   LIKE type_file.num5,
               l_rtd01 LIKE rtd_file.rtd01,
               l_rty01 LIKE azp_file.azp01,
               l_rty02_desc    LIKE ima_file.ima02,
#               l_rty04_desc    LIKE gem_file.gem02,            #TQC-B20056 mark
               l_rty04_desc     LIKE geu_file.geu02,            #TQC-B20056
               l_rty05 LIKE rty_file.rty05,
               l_rty06 LIKE rty_file.rty06,
               l_lock_sw       LIKE type_file.chr1,
               p_cmd   LIKE type_file.chr1,
               l_allow_insert  LIKE type_file.num5,
               l_allow_delete  LIKE type_file.num5
 
#FUN-870100 ADD----
DEFINE   l_ima913    LIKE ima_file.ima913,
         l_ima914    LIKE ima_file.ima914,
         l_geu02     LIKE geu_file.geu02
#FUN-870100 END----------
DEFINE   i           LIKE type_file.num5                        #TQC-AB0135
DEFINE   l_cnt       LIKE type_file.num5                        #FUN-C60086
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
 
        IF cl_null(g_rty01) THEN
           CALL cl_err("",-400,0)
           RETURN 
        END IF
 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT rty02,'',rty14,rty15,rty03,rty04,'',rty12,'',rty05,rty06,rty07,rty08,rty09,rty10,rty11,rtyacti,rty13",  #FUN-870100   #TQC-A70003   #FUN-C90049 add rty14,rty15
                        " FROM rty_file",
                        " WHERE rty01=? AND rty02=?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i110_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rty WITHOUT DEFAULTS FROM s_rty.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                           INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                           APPEND ROW=l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
 
           IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("rty02",FALSE)
           ELSE 
              CALL cl_set_comp_entry("rty02",TRUE)
           END IF
 
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
 
                BEGIN WORK 
 
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rty_t.*=g_rty[l_ac].*
                        LET g_rty_o.*=g_rty[l_ac].*
 
                        OPEN i110_bcl USING g_rty01,g_rty_t.rty02
                        IF STATUS THEN
                            CALL cl_err("OPEN i110_bcl:",STATUS,1)
                            LET l_lock_sw='Y'
                        ELSE
                            FETCH i110_bcl INTO g_rty[l_ac].*
                            IF SQLCA.sqlcode THEN
                               CALL cl_err('',SQLCA.sqlcode,1)
                               LET l_lock_sw="Y"
                            END IF
                            CALL i110_rty02('d')
                            CALL i110_rty04('d')
                            CALL i110_rty12('d') #FUN-870100
                        END IF
                 END IF
 
                 IF g_rty[l_ac].rty03 = "1" THEN
                    CALL cl_set_comp_entry("rty04",FALSE)
                    LET g_rty[l_ac].rty04 = ''
                    LET g_rty[l_ac].rty04_desc = ''
                    DISPLAY BY NAME g_rty[l_ac].rty04
                    DISPLAY BY NAME g_rty[l_ac].rty04_desc
                 ELSE
                    #TQC-C40061--start add-------------------------
                    IF g_rty[l_ac].rty03 = '3' THEN
                       CALL cl_set_comp_required("rty04",TRUE)
                    ELSE
                       CALL cl_set_comp_required("rty04",FALSE)
                    END IF
                    #TQC-C40061--end add---------------------------
                    CALL cl_set_comp_entry("rty04",TRUE)    
                 END IF
                 IF NOT cl_null(g_rty[l_ac].rty02) THEN                                                                                      
                    SELECT ima913,ima914 INTO l_ima913,l_ima914 FROM ima_file WHERE ima01=g_rty[l_ac].rty02                                  
                    #No.FUN-A10037 ..begin
                    #IF l_ima913 = 'Y' THEN                                                                                                   
                    #   CALL cl_set_comp_entry("rty12",FALSE)                                                                                 
                    #ELSE                                                                                                                     
                    #   CALL cl_set_comp_entry("rty12",TRUE)                                                                                  
                    #END IF                                                                                                                   
                    #No.FUN-A10037 ..end
                 END IF               
                 #No.FUN-A10037 ..begin
                 IF g_rty[l_ac].rty03 ='2' OR g_rty[l_ac].rty03='4' THEN                                                                                      
                    CALL cl_set_comp_required("rty12",TRUE)
                 ELSE
                    CALL cl_set_comp_required("rty12",FALSE)
                 END IF
                 #No.FUN-A10037 ..end
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rty[l_ac].* TO NULL
                LET g_rty[l_ac].rtyacti = 'Y'
                #LET g_rty[l_ac].rtypos = 'N'  #FUN-870100
                LET g_rty_t.*=g_rty[l_ac].*
                LET g_rty_o.*=g_rty[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rty02
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
 
                IF cl_null(g_rty[l_ac].rty03) OR cl_null(g_rty[l_ac].rty05) OR cl_null(g_rty[l_ac].rty06) THEN
                   LET g_rty[l_ac].rtyacti = 'N'
                ELSE
                   LET g_rty[l_ac].rtyacti = 'Y'
                END IF
 
                INSERT INTO rty_file(rty01,rty02,rty03,rty04,rty12,rty05,rty06,rty07,rty08,rty09,rty10,rty11,rtyacti,rty13,rty14,rty15)  #FUN-870100   #TQC-A70003   #FUN-C90049 add rty14,rty15
                              VALUES(g_rty01,g_rty[l_ac].rty02,g_rty[l_ac].rty03,g_rty[l_ac].rty04,g_rty[l_ac].rty12,g_rty[l_ac].rty05,g_rty[l_ac].rty06,g_rty[l_ac].rty07,  #FUN-870100
                              g_rty[l_ac].rty08,g_rty[l_ac].rty09,g_rty[l_ac].rty10,g_rty[l_ac].rty11,g_rty[l_ac].rtyacti,g_rty[l_ac].rty13,g_rty[l_ac].rty14,g_rty[l_ac].rty15)   #TQC-A70003   #FUN-C90049 add rty14,rty15
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rty_file",g_rty01,g_rty[l_ac].rty02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT O.K.'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b To FORMONLY.cn2
                END IF
 
 
      AFTER FIELD rty02
        IF NOT cl_null(g_rty[l_ac].rty02) THEN
#NO.FUN-A90048 add -----------start--------------------     
          IF NOT s_chk_item_no(g_rty[l_ac].rty02,'') THEN
             CALL cl_err('',g_errno,1)
             LET g_rty[l_ac].rty02= g_rty_t.rty02 
             NEXT FIELD rty02
          END IF
#NO.FUN-A90048 add ------------end --------------------      
#FUN-C60086----add--begin-----------------
            IF s_industry("slk") AND g_azw.azw04 = '2' THEN
               SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_rty[l_ac].rty02 AND ima151 = 'Y'
               IF l_cnt > 0 THEN
                  CALL cl_err('','mfg-789',0)
                  LET g_rty[l_ac].rty02 = g_rty_t.rty02
                  NEXT FIELD rty02
               END IF
            END IF
#FUN-C60086 ---add---end------------------
           IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rty[l_ac].rty02!=g_rty_t.rty02) THEN
          #FUN-B40044 Begin---
          #  #FUN-B40043 Begin---
          #  #SELECT COUNT(*) INTO l_n FROM tqa_file WHERE tqa03='14' AND tqa01=(SELECT rtz02 FROM rtz_file WHERE rtz01 = g_rty01) AND tqa05='Y' AND tqaacti='Y'
          #   LET l_n = 0
          #   SELECT COUNT(*) INTO l_n FROM rtz_file
          #    WHERE rtz01=g_rty01
          #      AND rtz04 IS NULL
          #  #FUN-B40043 End-----
          #   IF l_n>0 THEN
          #      SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_rty[l_ac].rty02 AND imaacti='Y'
          #       IF l_n > 0 THEN
          #          SELECT COUNT(*) INTO l_n FROM rty_file
          #          WHERE rty02=g_rty[l_ac].rty02 AND rtyacti = 'Y' AND rty01=g_rty01
          #          IF l_n>0 THEN
          #              CALL cl_err('',-239,0)
          #              LET g_rty[l_ac].rty02=g_rty_t.rty02
          #              DISPLAY BY NAME g_rty[l_ac].rty02
          #              NEXT FIELD rty02
          #          ELSE
          #             CALL i110_rty02('a')
          #             IF NOT cl_null(g_errno) THEN
          #                CALL cl_err(g_rty[l_ac].rty02,g_errno,0)
          #                LET g_rty[l_ac].rty02 = g_rty_t.rty02
          #                DISPLAY BY NAME g_rty[l_ac].rty02
          #                NEXT FIELD rty02
          #             ELSE
          #                IF NOT cl_null(g_rty[l_ac].rty05) THEN
          #                   IF g_rty[l_ac].rty03 MATCHES '[1234]'  THEN
          #                      SELECT COUNT(*) INTO l_n FROM rto_file WHERE rtoplant = g_rty01 AND rtoconf = 'Y'
          #                     IF l_n>0 THEN
          #                         CALL i110_rty05('a')
          #                         IF NOT cl_null(g_errno) THEN
          #                           CALL cl_err(g_rty[l_ac].rty02,g_errno,0)
          #                           LET g_errno=''
          #                           LET g_rty[l_ac].rty02 = g_rty_t.rty02
          #                           DISPLAY BY NAME g_rty[l_ac].rty02
          #                           NEXT FIELD rty02
          #                         END IF
          #                         IF g_rty[l_ac].rty03='3' AND g_rty[l_ac].rty06='2' THEN
          #                            CALL cl_err('','art-521',0)
          #                            LET g_rty[l_ac].rty02=g_rty_t.rty02
          #                            DISPLAY BY NAME g_rty[l_ac].rty02
          #                            NEXT FIELD rty02
          #                         END IF
          #                     #No.FUN-870100---begin---09/06/29
          #                     #ELSE
          #                     #  SELECT COUNT(*) INTO l_n1 FROM pmc_file,azp_file WHERE pmc930 = azp01 AND pmc01 = g_rty[l_ac].rty05  AND azp09 = '4' AND pmcacti = 'Y'
          #                     #  IF l_n1>0 THEN
          #                     #     LET g_rty[l_ac].rty06 = '1'
          #                     #     DISPLAY BY NAME g_rty[l_ac].rty06 
          #                     #  END IF
          #                     #No.FUN-870100---end---09/06/29
          #                     END IF
          #                   END IF
          #                END IF
          #             END IF
          #          END IF
          #       ELSE
       	  #           CALL cl_err('','art-030',0)
       	  #           LET g_rty[l_ac].rty02 = g_rty_t.rty02
       	  #           DISPLAY BY NAME g_rty[l_ac].rty02
          #    	      NEXT FIELD rty02
          #       END IF
          #   ELSE
          #      SELECT COUNT(*) INTO l_n FROM rte_file,rtd_file WHERE rtd01 = rte01 AND rtd01 = (SELECT rtz04 FROM rtz_file WHERE rtz01=g_rty01 ) AND rte07 = 'Y' AND rtdconf='Y' AND rte03=g_rty[l_ac].rty02
          #       IF l_n > 0 THEN
          #          SELECT COUNT(*) INTO l_n FROM rty_file
          #          WHERE rty02=g_rty[l_ac].rty02 AND rtyacti = 'Y' AND rty01=g_rty01
          #          IF l_n>0 THEN
          #              CALL cl_err('',-239,0)
          #              LET g_rty[l_ac].rty02=g_rty_t.rty02
          #              DISPLAY BY NAME g_rty[l_ac].rty02
          #              NEXT FIELD rty02
          #          ELSE
          #             CALL i110_rty02('a')
          #             IF NOT cl_null(g_errno) THEN
          #                CALL cl_err(g_rty[l_ac].rty02,g_errno,0)
          #                LET g_rty[l_ac].rty02 = g_rty_t.rty02
          #                DISPLAY BY NAME g_rty[l_ac].rty02
          #                NEXT FIELD rty02
          #             ELSE
          #                IF NOT cl_null(g_rty[l_ac].rty05) THEN
          #                   IF g_rty[l_ac].rty03 MATCHES '[1234]'  THEN
          #                      SELECT COUNT(*) INTO l_n FROM rto_file WHERE rtoplant = g_rty01 AND rtoconf = 'Y'
          #                     IF l_n>0 THEN
          #                         CALL i110_rty05('a')
          #                         IF NOT cl_null(g_errno) THEN
          #                           CALL cl_err(g_rty[l_ac].rty02,g_errno,0)
          #                           LET g_errno=''
          #                           LET g_rty[l_ac].rty02 = g_rty_t.rty02
          #                           DISPLAY BY NAME g_rty[l_ac].rty02
          #                           NEXT FIELD rty02
          #                         END IF
          #                         IF g_rty[l_ac].rty03='3' AND g_rty[l_ac].rty06='2' THEN
          #                            CALL cl_err('','art-521',0)
          #                            LET g_rty[l_ac].rty02=g_rty_t.rty02
          #                            DISPLAY BY NAME g_rty[l_ac].rty02
          #                            NEXT FIELD rty02
          #                         END IF
          #                     #No.FUN-870100---begin---09/06/29
          #                     #ELSE
          #                     #  SELECT COUNT(*) INTO l_n1 FROM pmc_file,azp_file 
          #                     #   WHERE pmc930 = azp01 AND pmc01 = g_rty[l_ac].rty05 
          #                     #     AND azp09 = '4' AND pmcacti = 'Y'
          #                     #  IF l_n1>0 THEN
          #                     #     LET g_rty[l_ac].rty06 = '1'
          #                     #     DISPLAY BY NAME g_rty[l_ac].rty06
          #                     #  END IF
          #                     #No.FUN-870100---end---09/06/29
          #                     END IF
          #                   END IF
          #                END IF
          #             END IF
          #          END IF
          #       ELSE
       	  #           CALL cl_err('','art-030',0)
       	  #           LET g_rty[l_ac].rty02 = g_rty_t.rty02
       	  #           DISPLAY BY NAME g_rty[l_ac].rty02
          #    	      NEXT FIELD rty02
          #       END IF
          #   END IF
          #END IF
           SELECT COUNT(*) INTO l_n FROM rty_file
            WHERE rty02=g_rty[l_ac].rty02 AND rtyacti = 'Y' AND rty01=g_rty01
           IF l_n>0 THEN
               CALL cl_err('',-239,0)
               LET g_rty[l_ac].rty02=g_rty_t.rty02
               DISPLAY BY NAME g_rty[l_ac].rty02
               NEXT FIELD rty02
           ELSE
              CALL i110_rty02('a')
              IF NOT cl_null(g_rty[l_ac].rty05) THEN
                 IF g_rty[l_ac].rty03 MATCHES '[1234]'  THEN
                    SELECT COUNT(*) INTO l_n FROM rto_file WHERE rtoplant = g_rty01 AND rtoconf = 'Y'
                    IF l_n>0 THEN
                       CALL i110_rty05('a')
                       IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_rty[l_ac].rty02,g_errno,0)
                         LET g_errno=''
                         LET g_rty[l_ac].rty02 = g_rty_t.rty02
                         DISPLAY BY NAME g_rty[l_ac].rty02
                         NEXT FIELD rty02
                       END IF
                       IF g_rty[l_ac].rty03='3' AND g_rty[l_ac].rty06='2' THEN
                          CALL cl_err('','art-521',0)
                          LET g_rty[l_ac].rty02=g_rty_t.rty02
                          DISPLAY BY NAME g_rty[l_ac].rty02
                          NEXT FIELD rty02
                       END IF
                    END IF
                 END IF
              END IF
           END IF
          #FUN-B40044 End-----
        #TQC-B60007--add--str--
        ELSE
           CALL i110_rty02('a')
        #TQC-B60007--add--end--
        END IF
     END IF
        IF cl_null(g_rty[l_ac].rty02) THEN
           LET g_rty[l_ac].rty02_desc=''
           DISPLAY BY NAME g_rty[l_ac].rty02_desc
        END IF
      #FUN-870100 ADD----
        IF NOT cl_null(g_rty[l_ac].rty02) THEN
           SELECT ima913,ima914 INTO l_ima913,l_ima914 FROM ima_file WHERE ima01=g_rty[l_ac].rty02
           IF l_ima913 = 'Y' THEN 
              IF cl_null(g_rty[l_ac].rty12) THEN 
                 LET g_rty[l_ac].rty12 = l_ima914
                 SELECT geu02 INTO l_geu02 FROM geu_file WHERE geu01=l_ima914
                 LET g_rty[l_ac].rty12_desc=l_geu02
                 DISPLAY BY NAME g_rty[l_ac].rty12
                 DISPLAY BY NAME g_rty[l_ac].rty12_desc
              END IF
              IF g_rty[l_ac].rty03 MATCHES '[13]'  THEN
                 CALL cl_err('','art-119',0)
                 NEXT FIELD rty03
              END IF
           END IF     
        END IF      
      #FUN-870100 END----
        LET g_rty_o.rty02=g_rty[l_ac].rty02
 
 
      #FUN-870100 ADD-----
       AFTER FIELD rty03
           IF NOT cl_null(g_rty[l_ac].rty02) THEN
              SELECT ima913,ima914 INTO l_ima913,l_ima914 FROM ima_file WHERE ima01=g_rty[l_ac].rty02
              IF l_ima913 = 'Y' THEN 
                 IF cl_null(g_rty[l_ac].rty12) THEN 
                    LET g_rty[l_ac].rty12 = l_ima914                                                                                      
                    SELECT geu02 INTO l_geu02 FROM geu_file WHERE geu01=l_ima914                                                          
                    LET g_rty[l_ac].rty12_desc=l_geu02                                                                                    
                    DISPLAY BY NAME g_rty[l_ac].rty12                                                                                     
                    DISPLAY BY NAME g_rty[l_ac].rty12_desc                             
                 END IF  
                 IF g_rty[l_ac].rty03 MATCHES '[13]'  THEN
                    CALL cl_err('','art-119',0)
                    NEXT FIELD rty03
                 END IF   
              END IF     
           END IF           
           #No.FUN-A10037 ..begin
           IF g_rty[l_ac].rty03 ='2' OR g_rty[l_ac].rty03='4' THEN                                                                                      
              CALL cl_set_comp_required("rty12",TRUE)
           ELSE
              CALL cl_set_comp_required("rty12",FALSE)
           END IF
           #No.FUN-A10037 ..end
      #FUN-870100 END-----
 
       ON CHANGE rty03
           IF g_rty[l_ac].rty03 = "1" THEN
               CALL cl_set_comp_entry("rty04",FALSE)
               LET g_rty[l_ac].rty04 = ''
               LET g_rty[l_ac].rty04_desc = ''
               DISPLAY BY NAME g_rty[l_ac].rty04
               DISPLAY BY NAME g_rty[l_ac].rty04_desc
           ELSE
              #TQC-C40061--start add-------------------------
              IF g_rty[l_ac].rty03 = '3' THEN 
                 CALL cl_set_comp_required("rty04",TRUE)
              ELSE
                 CALL cl_set_comp_required("rty04",FALSE) 
              END IF  
              #TQC-C40061--end add---------------------------
               CALL cl_set_comp_entry("rty04",TRUE)    
           END IF
          #FUN-870100 ADD-----
           IF NOT cl_null(g_rty[l_ac].rty02) THEN
              SELECT ima913,ima914 INTO l_ima913,l_ima914 FROM ima_file WHERE ima01=g_rty[l_ac].rty02
              IF l_ima913 = 'Y' THEN 
              #  CALL cl_set_comp_entry("rty12",FALSE) 
              #  LET g_rty[l_ac].rty12 = l_ima914
              #  SELECT geu02 INTO l_geu02 FROM geu_file WHERE geu01=l_ima914
              #  LET g_rty[l_ac].rty12_desc=l_geu02
              #  DISPLAY BY NAME g_rty[l_ac].rty12
              #  DISPLAY BY NAME g_rty[l_ac].rty12_desc
                 IF g_rty[l_ac].rty03 MATCHES '[13]'  THEN
                    CALL cl_err('','art-119',0)
                    NEXT FIELD rty03
                 END IF   
              END IF     
           END IF           
          #FUN-870100 END-----
 
       #FUN-C90049 add begin---
       AFTER FIELD rty14
          IF not cl_null(g_rty[l_ac].rty14) THEN
             CALL i110_ck_store(g_rty[l_ac].rty14,'Y')
             DISPLAY BY NAME g_rty[l_ac].rty14
             IF not cl_null(g_errno) THEN
                CALL cl_err("",g_errno,0)
                NEXT FIELD rty14
             ELSE
                IF NOT s_chk_ware1(g_rty[l_ac].rty14,g_rty01) THEN
                   NEXT FIELD rty14
                END IF                 
             END IF
          END IF
       AFTER FIELD rty15
          IF not cl_null(g_rty[l_ac].rty15) THEN
             CALL i110_ck_store(g_rty[l_ac].rty15,'N')
             DISPLAY BY NAME g_rty[l_ac].rty15
             IF not cl_null(g_errno) THEN
                CALL cl_err("",g_errno,0)
                NEXT FIELD rty15
             ELSE
                IF NOT s_chk_ware1(g_rty[l_ac].rty15,g_rty01) THEN
                   NEXT FIELD rty15
                END IF
             END IF
          END IF
       #FUN-C90049 add end-----

       AFTER FIELD rty04
           IF NOT cl_null(g_rty[l_ac].rty04) THEN
              IF p_cmd = 'a' OR p_cmd = 'u' THEN
                  CALL i110_rty04('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rty[l_ac].rty04,g_errno,0)
                     LET g_rty[l_ac].rty04 = g_rty_t.rty04
                     DISPLAY BY NAME g_rty[l_ac].rty04
                     NEXT FIELD rty04
                  END IF
               END IF
           END IF
           IF cl_null(g_rty[l_ac].rty04) THEN
              LET g_rty[l_ac].rty04_desc=''
              DISPLAY BY NAME g_rty[l_ac].rty04_desc
           END IF
           #TQC-AC0224 add ---begin------------------
           IF cl_null(g_rty[l_ac].rty04) AND g_rty[l_ac].rty03 = '3' THEN
              CALL cl_err(g_rty[l_ac].rty03,'art-994',0)
              NEXT FIELD rty04
           END IF
           #TQC-AC0224 add ----end--------------------
 
       AFTER FIELD rty05
           IF NOT cl_null(g_rty[l_ac].rty05) THEN
            IF NOT cl_null(g_rty[l_ac].rty02) THEN
             IF g_rty[l_ac].rty03 MATCHES '[1234]'  THEN
                IF p_cmd = 'a' OR p_cmd = 'u' THEN
                   CALL i110_rty05('a')
                   IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rty[l_ac].rty05,g_errno,0)
                     LET g_errno=''
                     LET g_rty[l_ac].rty05 = g_rty_t.rty05
                     DISPLAY BY NAME g_rty[l_ac].rty05
                     NEXT FIELD rty05
                   END IF
                   IF g_rty[l_ac].rty03='3' AND g_rty[l_ac].rty06='2' THEN
                      CALL cl_err('','art-521',0)
                      LET g_rty[l_ac].rty05=g_rty_t.rty05
                      DISPLAY BY NAME g_rty[l_ac].rty05
                      NEXT FIELD rty05
                   END IF
                END IF
            END IF
            END IF
           END IF
           IF cl_null(g_rty[l_ac].rty05) THEN
              LET g_rty[l_ac].rty06=''
              DISPLAY BY NAME g_rty[l_ac].rty06
           END IF
 
       AFTER FIELD rty07
           #IF g_rty[l_ac].rty07<=0 THEN #MOD-D40114 mark
           IF g_rty[l_ac].rty07 < 0 THEN #MOD-D40114 add
              #CALL cl_err('','art-185',0) #MOD-D40114 mark 
               CALL cl_err('','art758',0)  #MOD-D40114 add
               LET g_rty[l_ac].rty07 = g_rty_t.rty07
               NEXT FIELD rty07
           END IF
       
       AFTER FIELD rty08
           IF g_rty[l_ac].rty08<0 THEN
               CALL cl_err('','art-184',0)
               LET g_rty[l_ac].rty08 = g_rty_t.rty08
               NEXT FIELD rty08
           END IF
       
       AFTER FIELD rty09
           IF g_rty[l_ac].rty09<0 THEN
               CALL cl_err('','art-184',0)
               LET g_rty[l_ac].rty09 = g_rty_t.rty09
               NEXT FIELD rty09
           END IF
 
       AFTER FIELD rty10
          IF NOT cl_null(g_rty[l_ac].rty10) THEN
             SELECT COUNT(*) INTO l_n FROM poz_file WHERE poz01 = g_rty[l_ac].rty10 AND pozacti = 'Y'
             IF l_n = 0 THEN
                CALL cl_err('','art-217',0)
                LET g_rty[l_ac].rty10 = g_rty_t.rty10
                DISPLAY BY NAME g_rty[l_ac].rty10
                NEXT FIELD rty10
             END IF
          END IF
 
       AFTER FIELD rty11
          IF NOT cl_null(g_rty[l_ac].rty11) THEN
             SELECT COUNT(*) INTO l_n FROM poz_file WHERE poz01 = g_rty[l_ac].rty11 AND pozacti = 'Y'
             IF l_n = 0 THEN
                CALL cl_err('','art-217',0)
                LET g_rty[l_ac].rty11 = g_rty_t.rty11
                DISPLAY BY NAME g_rty[l_ac].rty11
                NEXT FIELD rty11
             END IF
          END IF
      #No.FUN-A10037 ..begin
       BEFORE FIELD rty12 
          IF g_rty[l_ac].rty03 ='2' OR g_rty[l_ac].rty03='4' THEN                                                                                      
             CALL cl_set_comp_required("rty12",TRUE)
          ELSE
             CALL cl_set_comp_required("rty12",FALSE)
          END IF
      #No.FUN-A10037 ..end
     #FUN-870100 ADD----
      AFTER FIELD rty12
         #No.FUN-A10037  ..begin
         IF NOT cl_null(g_rty[l_ac].rty12) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND                    
               g_rty[l_ac].rty12 <> g_rty_t.rty12 OR cl_null(g_rty_t.rty12)) THEN
               CALL i110_rty12('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('rty12:',g_errno,1)
                  LET g_rty[l_ac].rty12 = g_rty_t.rty12
                  DISPLAY BY NAME g_rty[l_ac].rty12
                  NEXT FIELD rty12 
               ELSE 
                  LET g_rty_t.rty12 = g_rty[l_ac].rty12
               END IF
            END IF
         END IF
         #No.FUN-A10037  ..end
         IF cl_null(g_rty[l_ac].rty12) THEN                                                                                       
            LET g_rty[l_ac].rty12_desc=''                                                                                         
            DISPLAY BY NAME g_rty[l_ac].rty12_desc                                                                                
         END IF            
     #FUN-870100 END---
 
       BEFORE DELETE
           IF NOT cl_null(g_rty_t.rty02) THEN
           #No.FUN-870100---begin
              #IF g_aza.aza91='Y' AND g_aza.aza87='Y' THEN
              #   IF NOT (g_rty[l_ac].rtyacti='N' AND g_rty[l_ac].rtypos='Y') THEN
              #      CALL cl_err("", 'aim-944', 1) 
              #      CANCEL DELETE
              #   END IF
              #END IF
              #No.FUN-870100---end
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rty_file
                  WHERE rty01 = g_rty01 AND rty02 = g_rty_t.rty02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rty_file",g_rty01,g_rty_t.rty02,SQLCA.sqlcode,"","",1)
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
              LET g_rty[l_ac].* = g_rty_t.*
              CLOSE i110_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rty[l_ac].rty02,-263,1)
              LET g_rty[l_ac].* = g_rty_t.*
           ELSE
             
              UPDATE rty_file SET  rty02 = g_rty[l_ac].rty02,
                                   rty03 = g_rty[l_ac].rty03,
                                   rty04 = g_rty[l_ac].rty04,
                                   rty05 = g_rty[l_ac].rty05,
                                   rty06 = g_rty[l_ac].rty06,
                                   rty07 = g_rty[l_ac].rty07,
                                   rty08 = g_rty[l_ac].rty08,
                                   rty09 = g_rty[l_ac].rty09,
                                   rty10 = g_rty[l_ac].rty10,
                                   rty11 = g_rty[l_ac].rty11,
                                   rty12 = g_rty[l_ac].rty12,     #FUN-870100
                                   rtyacti = g_rty[l_ac].rtyacti,
                                   rty13 = g_rty[l_ac].rty13,     #TQC-A70003
                                   rty14 = g_rty[l_ac].rty14,     #FUN-C90049 add
                                   rty15 = g_rty[l_ac].rty15      #FUN-C90049 add
                                   #rtypos = g_rty[l_ac].rtypos   #FUN-870100
                 WHERE rty01=g_rty01
                   AND rty02=g_rty_t.rty02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rty_file",g_rty01,g_rty_t.rty02,SQLCA.sqlcode,"","",1) 
                 LET g_rty[l_ac].* = g_rty_t.*
              ELSE
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rty[l_ac].* = g_rty_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rty.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i110_bcl
              ROLLBACK WORK
              EXIT INPUT                              #TQC-AB0135 mark #TQC-B80177
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 Add
    #       CLOSE i110_bcl                             #TQC-AB0135 mark
    #       COMMIT WORK                                #TQC-AB0135 mark

#TQC-AB0135 ------------------STA
        AFTER INPUT
           IF g_rec_b <> 0 THEN
             FOR i = 1 TO g_rec_b
                IF cl_null(g_rty[i].rty03) THEN
                   CALL cl_err("","art-689",0)
                   NEXT FIELD rty03
                END IF
             END FOR
             IF cl_null(g_rty[l_ac].rty03) AND p_cmd = 'a'  THEN
                NEXT FIELD rty03
             END IF
          END IF
           CLOSE i110_bcl
           COMMIT WORK
#TQC-AB0135 ------------------END           

      ON ACTION CONTROLO                        
           IF INFIELD(rty02) AND l_ac > 1 THEN
              LET g_rty[l_ac].* = g_rty[l_ac-1].*
             #LET g_rty[l_ac].rty02 = g_rec_b + 1   #TQC-A30154 mark
              LET g_rec_b = g_rec_b + 1             #TQC-A30154 add 
              NEXT FIELD rty02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
             WHEN INFIELD(rty02) 
             IF p_cmd = 'a' THEN  
                 CALL q_ima(1,1,g_rty01) RETURNING g_multi_ima01  # No.FUN-A80121         
                    IF NOT cl_null(g_multi_ima01)  THEN
                       CALL i110_multi_ima01()
                       CALL i110_b_fill(" 1=1")
                       CALL i110_bp_refresh()
                       LET g_flag = TRUE
                       EXIT INPUT
                    END IF 
                    COMMIT WORK
             ELSE        
         #       CALL cl_init_qry_var()
                 SELECT rtz04 INTO l_rtd01 FROM rtz_file WHERE rtz01=g_rty01
                 SELECT COUNT(*) INTO l_n FROM tqa_file 
                       WHERE tqa03='14'
                         AND tqa01=(SELECT rtz02 FROM rtz_file WHERE rtz01 = g_rty01 )
                         AND tqa05='Y' AND tqaacti='Y'
          #No.FUN-A90048 ------------start -------------------     
          #     IF l_n>0 THEN
          #        LET g_qryparam.form ="q_ima"
          #     ELSE
          #        LET g_qryparam.form ="q_rte03_1"
          #        LET g_qryparam.arg1 = l_rtd01
          #     END IF
          #     LET g_qryparam.default1 = g_rty[l_ac].rty02
          #     CALL cl_create_qry() RETURNING g_rty[l_ac].rty02
          #    IF l_n>0 THEN
                  CALL q_sel_ima(FALSE, "q_ima", "",g_rty[l_ac].rty02, "", "", "", "" ,"",g_rty01 ) RETURNING g_rty[l_ac].rty02
          #    ELSE
          #       CALL q_sel_ima(FALSE, "q_rte03_1", "",g_rty[l_ac].rty02, l_rtd01, "", "", "" ,"",g_rty01 ) RETURNING g_rty[l_ac].rty02
          #    END IF   
          #No.FUN-A90048 -------------end ---------------------
               DISPLAY BY NAME g_rty[l_ac].rty02
               CALL i110_rty02('a')
               NEXT FIELD rty02
            END IF
           #FUN-C90049 add begin---
           WHEN INFIELD(rty14)   #預設成本倉
              CALL q_imd_1(FALSE,TRUE,g_rty[l_ac].rty14,"",g_rty01,'Y',"") RETURNING g_rty[l_ac].rty14
              IF not cl_null(g_rty[l_ac].rty14) THEN
                 CALL i110_ck_store(g_rty[l_ac].rty14,'Y')
                 IF not cl_null(g_errno) THEN
                    CALL cl_err("",g_errno,0)
                    DISPLAY BY NAME g_rty[l_ac].rty14
                    NEXT FIELD rty14
                 ELSE
                    IF NOT s_chk_ware1(g_rty[l_ac].rty14,g_rty01) THEN
                       NEXT FIELD rty14
                    END IF                   
                 END IF
              END IF
           WHEN INFIELD(rty15)   #預設非成本倉
              CALL q_imd_1(FALSE,TRUE,g_rty[l_ac].rty15,"",g_rty01,'N',"") RETURNING g_rty[l_ac].rty15
              IF not cl_null(g_rty[l_ac].rty15) THEN
                 CALL i110_ck_store(g_rty[l_ac].rty15,'N')
                 IF not cl_null(g_errno) THEN
                    CALL cl_err("",g_errno,0)
                    DISPLAY BY NAME g_rty[l_ac].rty15
                    NEXT FIELD rty15
                 ELSE
                    IF NOT s_chk_ware1(g_rty[l_ac].rty15,g_rty01) THEN
                       NEXT FIELD rty15
                    END IF
                 END IF
              END IF
           #FUN-C90049 add end-----
           WHEN INFIELD(rty04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_geu"
               LET g_qryparam.default1 = g_rty[l_ac].rty04
               LET g_qryparam.arg1 = '8' 
               CALL cl_create_qry() RETURNING g_rty[l_ac].rty04
               DISPLAY BY NAME g_rty[l_ac].rty04
               CALL i110_rty04('a')
               NEXT FIELD rty04
           WHEN INFIELD(rty05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc2"
               LET g_qryparam.default1 = g_rty[l_ac].rty05
               CALL cl_create_qry() RETURNING g_rty[l_ac].rty05
               DISPLAY BY NAME g_rty[l_ac].rty05
               CALL i110_rty05('a')
               NEXT FIELD rty05
           WHEN INFIELD(rty10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz01"
               LET g_qryparam.default1 = g_rty[l_ac].rty10
               CALL cl_create_qry() RETURNING g_rty[l_ac].rty10
               DISPLAY BY NAME g_rty[l_ac].rty10
               NEXT FIELD rty10
           WHEN INFIELD(rty11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz01"
               LET g_qryparam.default1 = g_rty[l_ac].rty11
               CALL cl_create_qry() RETURNING g_rty[l_ac].rty11
               DISPLAY BY NAME g_rty[l_ac].rty11
               NEXT FIELD rty11
           WHEN INFIELD(rty12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_geu"
               LET g_qryparam.default1 = g_rty[l_ac].rty12
               LET g_qryparam.arg1 = '4'
               CALL cl_create_qry() RETURNING g_rty[l_ac].rty12
               DISPLAY BY NAME g_rty[l_ac].rty12
               CALL i110_rty12('a')
               NEXT FIELD rty12
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
  IF g_flag THEN
       LET g_flag = FALSE
       CALL i110_b()
    END IF
 
    
    CLOSE i110_bcl
    COMMIT WORK
    CALL i110_delall()
    CALL i110_show()
    
END FUNCTION
 
FUNCTION i110_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rty_file
      WHERE rty01 = g_rty01
 
   IF g_cnt = 0 THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rty_file WHERE rty01 = g_rty01
   END IF
 
END FUNCTION
 
FUNCTION i110_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rty01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT rty01 INTO g_rty01 FROM rty_file
    WHERE rty01=g_rty01 AND rtyacti='Y'
 
   IF g_rty[l_ac].rtyacti ='N' THEN    
      CALL cl_err(g_rty01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rty01_t = g_rty01
   BEGIN WORK
 
   CALL i110_show()
 
   WHILE TRUE
      LET g_rty01_t = g_rty01
 
#      CALL i110_i("u")                         
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rty01=g_rty01_t
         CALL i110_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE rty_file SET rty01 = g_rty01
       WHERE rty01 = g_rty01 AND rtyacti='Y'
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rty_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   COMMIT WORK
   CALL i110_show()
   CALL cl_flow_notify(g_rty01,'U')
 
   CALL i110_b_fill("1=1")
   CALL i110_bp_refresh()
 
END FUNCTION
 
FUNCTION i110_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rty01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM rty_file WHERE rty01 = g_rty01 AND rtyacti='Y'
      CLEAR FORM
      CALL g_rty.clear()
      OPEN i110_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i110_cs
         CLOSE i110_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i110_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i110_cs
         CLOSE i110_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i110_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i110_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i110_fetch('/')
         END IF
      END IF
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i110_copy()
DEFINE   l_newno     LIKE rty_file.rty01,
          l_oldno    LIKE rty_file.rty01,
          l_cnt      LIKE type_file.num5,
          l_rtz04_1  LIKE rtz_file.rtz04,
          l_rtz04_2  LIKE rtz_file.rtz04
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rty01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno FROM rty01
 
       AFTER FIELD rty01
          IF l_newno IS NOT NULL THEN
              SELECT COUNT(azp01) INTO l_cnt FROM azp_file WHERE azp01=l_newno
              IF l_cnt=0 THEN
                 CALL cl_err('','art-476',0)
                 DISPLAY g_rty01 TO rty01
                 NEXT FIELD rty01
              ELSE
                 SELECT rtz04 INTO l_rtz04_1 FROM rtz_file WHERE rtz01=g_rty01
                 SELECT rtz04 INTO l_rtz04_2 FROM rtz_file WHERE rtz01=l_newno
                 IF l_rtz04_1 <> l_rtz04_2 THEN
                    CALL cl_err('','art-463',0)
                    DISPLAY g_rty01 TO rty01
                    NEXT FIELD rty01
                 END IF
                 SELECT COUNT(*) INTO l_cnt FROM rty_file
                     WHERE rty01 = l_newno
                 IF l_cnt > 0 THEN
                    CALL cl_err(l_newno,-239,0)
                    NEXT FIELD rty01
                 END IF
                 IF SQLCA.sqlcode THEN
                     DISPLAY g_rty01 TO rty01
                     LET l_newno = NULL
                     NEXT FIELD rty01
                  END IF
              END IF
           END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rty01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rty01" 
                LET g_qryparam.default1 = g_rty01
                CALL cl_create_qry() RETURNING l_newno
                DISPLAY l_newno TO rty01
              NEXT FIELD rty01
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_rty01 TO rty01
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rty_file         
       WHERE rty01=g_rty01
       INTO TEMP y
 
   UPDATE y
       SET rty01=l_newno,
           rtyacti='N'
           #rtypos='N' #FUN-870100
 
   INSERT INTO rty_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rty_file","","",SQLCA.sqlcode,"","",1) 
      RETURN
   ELSE
       MESSAGE 'ROW(',l_newno,') O.K' 
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rty01
   LET g_rty01 = l_newno
   CALL i110_b()
   #LET g_rty01 = l_oldno #FUN-C80046
   #CALL i110_show()      #FUN-C80046
 
END FUNCTION
 
FUNCTION i110_bp_refresh()
  DISPLAY ARRAY g_rty TO s_rty.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  CALL i110_show()
END FUNCTION
 
FUNCTION i110_out()
#p_query
DEFINE l_cmd  STRING
define l_msg   STRING  
    IF cl_null(g_wc) THEN
    CALL cl_err('','9057',0) RETURN
    END IF
    LET l_msg=" rty01 in ",g_auth,""
    LET l_cmd = 'p_query "arti110" "',g_wc CLIPPED,'" "',l_msg,'" '
    CALL cl_cmdrun(l_cmd) 
 
END FUNCTION
# No.FUN-A80121 .. begin
FUNCTION i110_multi_ima01()  
DEFINE  l_rty        RECORD LIKE rty_file.*
DEFINE  l_ima913     LIKE ima_file.ima913
DEFINE  l_ima914     LIKE ima_file.ima914         
DEFINE  tok          base.StringTokenizer
DEFINE  l_rty06      LIKE gem_file.gem02
DEFINE  l_sql        STRING
DEFINE  l_n          LIKE type_file.num5
DEFINE  l_rty07      LIKE rty_file.rty07

  CALL s_showmsg_init()
  LET tok = base.StringTokenizer.create(g_multi_ima01,"|")
  WHILE tok.hasMoreTokens()
     LET l_rty.rty02 = tok.nextToken()

    #FUN-AA0047 Begin--- By shi
     LET g_cnt = 0
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_rty01,'rty_file'),
                 "  WHERE rty01 = '",g_rty01,"' AND rty02 = '",l_rty.rty02,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql
     PREPARE sel_rty02_pre FROM l_sql
     EXECUTE sel_rty02_pre INTO g_cnt
     IF g_cnt > 0 THEN 
        CALL s_errmsg('rty01',l_rty.rty02,'INS rty_file','-239',1)
        CONTINUE WHILE 
     END IF
    #FUN-AA0047 End----- 
     IF NOT cl_null(l_rty.rty02) THEN   
          IF NOT s_chk_item_no(l_rty.rty02,'') THEN
             CALL s_errmsg('rty01',l_rty.rty02,'INS rty_file',g_errno,1)
             CONTINUE WHILE
          END IF
     END IF
     LET l_rty.rty03 =  '1'
     LET l_rty.rty04 =  NULL
     SELECT ima913,ima914 INTO l_ima913,l_ima914 
     FROM ima_file 
     WHERE ima01=g_rty[l_ac].rty02
        IF l_ima913 = 'Y' THEN
            IF l_rty.rty03 MATCHES '[13]'  THEN
               CALL s_errmsg('rty01',l_rty.rty02,'INS rty_file','art-119',1)
               CONTINUE WHILE
            END IF
        END IF     
     LET l_sql="SELECT ima54,ima27,ima38,ima271 FROM ",cl_get_target_table(g_rty01,'ima_file'),
                   " WHERE ima01 = '",l_rty.rty02,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql
         PREPARE sel_ima54_pre FROM l_sql
         EXECUTE sel_ima54_pre INTO l_rty.rty05,l_rty.rty08,l_rty.rty09,l_rty.rty13
     # 參照FUNCTION i110_rty05(p_cmd)的邏輯，對rty06賦值   
     IF NOT cl_null(l_rty.rty05) THEN    
        LET l_sql  = " SELECT COUNT(*) FROM ",cl_get_target_table(g_rty01,'rtt_file'),",",
                                         cl_get_target_table(g_rty01,'rts_file'),",",     
                                         cl_get_target_table(g_rty01,'rto_file'),          
                     " WHERE rtt04 = '",l_rty.rty02,"' ",
                     "   AND rttplant = '",g_rty01,"' AND rtt15 = 'Y' ",
                     "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                     "   AND rto01 = rts04 AND rto03 = rts02  ",
                     "   AND rtsplant = '",g_rty01,"' ",
                     "   AND rtsconf = 'Y' AND rto05 = '",l_rty.rty05,"' ", 
                     "   AND rtoconf ='Y' ",
                     "   AND rto08 <= '",g_today,"' ",
                     "   AND rto09 >= '",g_today,"' ",
                     "   AND rtoplant = '",g_rty01,"' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
        CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql   
        PREPARE s_rtt01_pb FROM l_sql
        EXECUTE s_rtt01_pb INTO l_n
        IF l_n>0 THEN
            LET l_sql = " SELECT DISTINCT rto06 FROM ",cl_get_target_table(g_rty01,'rtt_file'),",", 
                                              cl_get_target_table(g_rty01,'rts_file'),",", 
                                              cl_get_target_table(g_rty01,'rto_file'),     
                        " WHERE rtt04 = '",l_rty.rty02,"' ",
                        "   AND rttplant = '",g_rty01,"' AND rtt15 = 'Y' ",
                        "   AND rts01 = rtt01 AND rts02 = rtt02  ",
                        "   AND rto01 = rts04 AND rto03 = rts02  ",
                        "   AND rtsplant = '",g_rty01,"' ",
                        "   AND rtsconf = 'Y' AND rto05 = '",l_rty.rty05,"' ", 
                        "   AND rtoconf ='Y' ",
                        "   AND rto08 <= '",g_today,"' ",
                        "   AND rto09 >= '",g_today,"' ",
                        "   AND rtoplant = '",g_rty01,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
            CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql   
            PREPARE s_rtt02_pb FROM l_sql
            EXECUTE s_rtt02_pb INTO l_rty06
         END IF
         IF NOT cl_null(l_rty06) THEN
            LET l_rty.rty06 = l_rty06
         END IF
         IF l_n=0 THEN
             LET l_sql =" SELECT COUNT(*) ", 
                 "   FROM  ",cl_get_target_table(g_rty01,'pmc_file'),             
                 "  WHERE pmc01= '",l_rty.rty05,"'  ",
                 "    AND pmcacti='Y' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
            CALL cl_parse_qry_sql(l_sql,g_rty01) RETURNING l_sql       
            PREPARE s_pmc01_pb FROM l_sql
            EXECUTE s_pmc01_pb INTO l_n
            IF SQLCA.sqlcode THEN   
              CALL s_errmsg('rty01',l_rty.rty02,'SEL pmc_file','SQLCA.sqlcode',1)
              CONTINUE WHILE
            END IF  
            IF l_n >0 THEN
               LET l_rty.rty06 = '1'
            END IF
         END IF
     END IF     
     IF NOT cl_null(l_rty.rty02) THEN 
  #    CALL  s_overate('rty02')  RETURNING  l_rty07  #FUN-AA0047 mark
       CALL  s_overate(l_rty.rty02)  RETURNING l_rty07  #FUN-AA0047
       LET l_rty.rty07 = l_rty07
     END IF  
     LET l_rty.rty10 =  NULL
     LET l_rty.rty11 =  NULL
     LET l_rty.rty12 =  NULL
     LET l_rty.rtyacti =  'Y'
 #   INSERT INTO rty_file VALUES (g_rty01,g_rty[l_ac].*)
     INSERT INTO rty_file(rty01,rty02,rty03,rty04,rty12,rty05,rty06,rty07,rty08,rty09,rty10,rty11,rtyacti,rty13)  #FUN-870100   #TQC-A70003
       VALUES(g_rty01,l_rty.rty02,l_rty.rty03,l_rty.rty04,l_rty.rty12,l_rty.rty05,l_rty.rty06,l_rty.rty07,  #FUN-870100
              l_rty.rty08,l_rty.rty09,l_rty.rty10,l_rty.rty11,l_rty.rtyacti,l_rty.rty13)
     IF STATUS THEN
       CALL s_errmsg('rty01',l_rty.rty02,'INS rty_file',STATUS,1)
       CONTINUE WHILE
     END IF  
   END WHILE
   CALL s_showmsg()
END FUNCTION
# No.FUN-A80121  ..end

#FUN-C90049 add begin---
FUNCTION i110_default_store()   #取得預設成本倉,預舍非成本倉
 
   WHENEVER ERROR CALL cl_err_msg_log
   OPEN WINDOW i110_1_w WITH FORM "art/42f/arti110_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   INPUT   BY NAME g_rtz.rtz07,g_rtz.rtz08     WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_rtz.rtz07   = NULL
         LET g_rtz.rtz08   = NULL
      AFTER FIELD rtz07
         IF not cl_null(g_rtz.rtz07) THEN
            CALL i110_ck_store(g_rtz.rtz07,'Y')
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               DISPLAY BY NAME g_rtz.rtz07
               NEXT FIELD rtz07
            END IF
            IF NOT s_chk_ware1(g_rtz.rtz07,g_rty01) THEN
               NEXT FIELD rtz07
            END IF
         END IF
      AFTER FIELD rtz08
         IF not cl_null(g_rtz.rtz08) THEN
            CALL i110_ck_store(g_rtz.rtz08,'N')
            IF not cl_null(g_errno) THEN
               CALL cl_err("",g_errno,0)
               DISPLAY BY NAME g_rtz.rtz08
               NEXT FIELD rtz08
            END IF
            IF NOT s_chk_ware1(g_rtz.rtz08,g_rty01) THEN
               NEXT FIELD rtz08
            END IF
         END IF
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
      ON ACTION controlp
         CASE
            WHEN INFIELD(rtz07)   #預設成本倉
               CALL q_imd_1(FALSE,TRUE,g_rtz.rtz07,"",g_rty01,'Y',"") RETURNING g_rtz.rtz07
               DISPLAY BY NAME g_rtz.rtz07
            WHEN INFIELD(rtz08)   #預設非成本倉
               CALL q_imd_1(FALSE,TRUE,g_rtz.rtz08,"",g_rty01,'N',"") RETURNING g_rtz.rtz08
               DISPLAY BY NAME g_rtz.rtz08
            OTHERWISE
               EXIT CASE
         END CASE
      ON ACTION controlg
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
   END INPUT

   CLOSE WINDOW i110_1_w
END FUNCTION

FUNCTION i110_ck_store(p_imd01,p_cost)
   DEFINE p_imd01   LIKE imd_file.imd01
   DEFINE p_cost    LIKE type_file.chr1             #是否為成本倉
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_imdacti LIKE imd_file.imdacti

   SELECT COUNT(*) INTO l_cnt
     FROM jce_file
    WHERE jce02 = p_imd01

   IF l_cnt > 0 AND p_cost = 'Y' THEN
      LET g_errno = 'art1083'
      RETURN
   END IF

   IF l_cnt = 0 AND p_cost = 'N' THEN
      LET g_errno = 'art1084'
      RETURN
   END IF

   IF p_cost = 'Y' THEN
      SELECT imdacti INTO l_imdacti FROM imd_file
       WHERE imd01 = p_imd01
         AND imd20 = g_rty01
         AND imd01 NOT IN (SELECT jce02 FROM jce_file)
      CASE
         WHEN SQLCA.sqlcode = 100
            LET g_errno = 'aic-218'
         WHEN l_imdacti = 'N'
            LET g_errno = 'art-948'
         OTHERWISE
            LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
   ELSE
      SELECT imdacti INTO l_imdacti FROM imd_file
       WHERE imd01 = p_imd01
         AND imd20 = g_rty01
         AND imd01 IN (SELECT jce02 FROM jce_file)
      CASE
         WHEN SQLCA.sqlcode = 100
            LET g_errno = 'aic-217'
         WHEN l_imdacti = 'N'
            LET g_errno = 'art-947'
         OTHERWISE
            LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
   END IF
END FUNCTION
#FUN-C90049 add end-----
