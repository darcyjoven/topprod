# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt724.4gl
# Descriptions...:贈品入庫單 
# Date & Author..: FUN-960130 09/11/07 By sunyanchun
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-A10012 10/01/05 By destiny流通零售for業態管控 
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.TQC-A20039 10/02/21 By Cockroach 儲位、批號賦空值
# Modify.........: No.TQC-A20041 10/02/22 By Cockroach 欄位開窗調整
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No.FUN-A90049 10/10/13 By huangtao 增加料號的控管
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0062 10/10/26 By yinhy 倉庫權限使用控管修改 
# Modify.........: No.FUN-AB0025 10/11/11 By huangtao 取消rul05的控管
# Modify.........: No.FUN-AB0067 10/11/17 by destiny  增加倉庫的權限控管
# Modify.........: No.TQC-AC0247 10/12/20 by huangrh  顯示歸屬倉庫為當前營運中心的倉庫,修改tlf資料
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-BB0085 11/12/26 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/13 By xianghui 修改FUN-C20068的一些問題
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70087 12/08/03 By bart 整批寫入img_file
# Modify.........: No:FUN-C80046 12/08/16 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-CC0095 12/12/18 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
DEFINE g_ruk         RECORD LIKE ruk_file.*,
       g_ruk_t       RECORD LIKE ruk_file.*,
       g_ruk_o       RECORD LIKE ruk_file.*,
       g_ruk01_t     LIKE ruk_file.ruk01,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rul         DYNAMIC ARRAY OF RECORD
           rul02          LIKE rul_file.rul02,
           rul03          LIKE rul_file.rul03,
           rul03_desc     LIKE ima_file.ima02,
           rul04          LIKE rul_file.rul04,
           rul04_desc     LIKE gfe_file.gfe02,
           rul05          LIKE rul_file.rul05,
           rul06          LIKE rul_file.rul06,
           rul06_desc     LIKE gfe_file.gfe02,
           rul07          LIKE rul_file.rul07,           
           rul09          LIKE rul_file.rul09,
           rul10          LIKE rul_file.rul10,
           rul11          LIKE rul_file.rul11,
           rul12          LIKE rul_file.rul12,
           rul13          LIKE rul_file.rul13
                     END RECORD,
       g_rul_t       RECORD
           rul02          LIKE rul_file.rul02,
           rul03          LIKE rul_file.rul03,
           rul03_desc     LIKE ima_file.ima02,
           rul04          LIKE rul_file.rul04,
           rul04_desc     LIKE gfe_file.gfe02,
           rul05          LIKE rul_file.rul05,
           rul06          LIKE rul_file.rul06,
           rul06_desc     LIKE gfe_file.gfe02,
           rul07          LIKE rul_file.rul07,
           rul09          LIKE rul_file.rul09,
           rul10          LIKE rul_file.rul10,
           rul11          LIKE rul_file.rul11,
           rul12          LIKE rul_file.rul12,
           rul13          LIKE rul_file.rul13     
                     END RECORD,
       g_rul_o       RECORD 
            rul02          LIKE rul_file.rul02,
           rul03          LIKE rul_file.rul03,
           rul03_desc     LIKE ima_file.ima02,
           rul04          LIKE rul_file.rul04,                         
           rul04_desc     LIKE gfe_file.gfe02,
           rul05          LIKE rul_file.rul05,
           rul06          LIKE rul_file.rul06,
           rul06_desc     LIKE gfe_file.gfe02,
           rul07          LIKE rul_file.rul07,
           rul09          LIKE rul_file.rul09,
           rul10          LIKE rul_file.rul10,
           rul11          LIKE rul_file.rul11,
           rul12          LIKE rul_file.rul12,
           rul13          LIKE rul_file.rul13
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE type_file.chr1
DEFINE g_argv2             LIKE ruk_file.ruk01
DEFINE g_flag              LIKE type_file.num5
DEFINE g_rul06_t           LIKE rul_file.rul06  #FUN-BB0085
#DEFINE l_img_table      STRING             #FUN-C70087 #FUN-CC0095

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   LET g_argv1=ARG_VAL(1)           #No.FUN-A10012 
   LET g_argv2=ARG_VAL(2)           #No.FUN-A10012
   IF cl_null(g_argv1) THEN         #No.FUN-A10012
      LET g_argv1='1'
      LET g_ruk.ruk00 = g_argv1
   END IF                           #No.FUN-A10012
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087 #FUN-CC0095
   LET g_forupd_sql = "SELECT * FROM ruk_file WHERE ruk00 = ? AND ruk01 = ? AND rukplant = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t724_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   
   OPEN WINDOW t724_w AT p_row,p_col WITH FORM "art/42f/artt724"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
  DISPLAY BY NAME g_ruk.ruk00 
  IF NOT cl_null(g_argv2) THEN
     CALL t724_q()
  END IF
  
  CALL t724_menu()
   CLOSE WINDOW t724_w
   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t724_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rul.clear()
  
   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " ruk01 = '",g_argv2,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_ruk.* TO NULL
      LET g_ruk.ruk00 = g_argv1
      DISPLAY BY NAME g_ruk.ruk00 
      CONSTRUCT BY NAME g_wc ON ruk01,ruk03,ruk04,ruk05,
                                rukconf,rukcond,rukconu,rukplant,ruk06,rukuser,
                                rukgrup,rukmodu,rukdate,rukacti,
                                rukcrat,rukoriu,rukorig
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruk01"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruk01
                  NEXT FIELD ruk01
      
               WHEN INFIELD(ruk03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruk03"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruk03
                  NEXT FIELD ruk03
               WHEN INFIELD(ruk05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruk05"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruk05
                  NEXT FIELD ruk05
               WHEN INFIELD(rukconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_rukconu"                                                                                    
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rukconu                                                                              
                  NEXT FIELD rukconu
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
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
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rukuser', 'rukgrup')
 
   IF NOT cl_null(g_argv2) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON rul02,rul03,rul04,rul05,rul06,rul07,
                         rul09,rul10,rul11,rul12,rul13   
              FROM s_rul[1].rul02,s_rul[1].rul03,s_rul[1].rul04,
                   s_rul[1].rul05,s_rul[1].rul06,s_rul[1].rul07,
                   s_rul[1].rul09,s_rul[1].rul10,
                   s_rul[1].rul11,s_rul[1].rul12,s_rul[1].rul13
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
             # WHEN INFIELD(rul02)     #TQC-A20041 MARK
             #    CALL cl_init_qry_var()
             #    LET g_qryparam.state = 'c'
             #    LET g_qryparam.form ="q_rul02"
             #    LET g_qryparam.arg1 = g_ruk.ruk00
             #    CALL cl_create_qry() RETURNING g_qryparam.multiret
             #    DISPLAY g_qryparam.multiret TO rul02
             #    NEXT FIELD rul02
               WHEN INFIELD(rul03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rul03"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rul03
                  NEXT FIELD rul03
               WHEN INFIELD(rul04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rul04"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rul04
                  NEXT FIELD rul04
               WHEN INFIELD(rul06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rul06"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rul06
                  NEXT FIELD rul06
               WHEN INFIELD(rul11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
#                  LET g_qryparam.form ="q_rul11"     #TQC-AC0247
#                  LET g_qryparam.arg1 = g_ruk.ruk00  #TQC-AC0247
                  LET g_qryparam.form ="q_rul1101"    #TQC-AC0247
                  LET g_qryparam.arg1 = g_plant   #TQC-AC0247
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rul11
                  NEXT FIELD rul11
               WHEN INFIELD(rul12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rul12"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rul12
                  NEXT FIELD rul12
               WHEN INFIELD(rul13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rul13"
                  LET g_qryparam.arg1 = g_ruk.ruk00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rul13
                  NEXT FIELD rul13
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT distinct ruk00,ruk01,rukplant FROM ruk_file ",
                  " WHERE ", g_wc CLIPPED
   ELSE
      LET g_sql = "SELECT distinct ruk00,ruk01,rukplant ",
                  "  FROM ruk_file, rul_file ",
                  " WHERE ruk01 = rul01 AND ruk00 = rul00 AND rukplant = rulplant ",
                  "   AND ruk00 = '",g_ruk.ruk00,"' AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t724_prepare FROM g_sql
   DECLARE t724_cs
       SCROLL CURSOR WITH HOLD FOR t724_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(ruk00||ruk01||rukplant) FROM ruk_file WHERE ruk00 = '",
                g_argv1,"' AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(ruk00||ruk01||rukplant) FROM ruk_file,rul_file WHERE ",
                "ruk00 = '",g_argv1,"' AND rul01=ruk01 AND rukplant = rulplant",
                " AND ruk00 = rul00 AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t724_precount FROM g_sql
   DECLARE t724_count CURSOR FOR t724_precount
 
END FUNCTION
 
FUNCTION t724_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t724_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t724_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t724_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t724_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t724_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t724_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t724_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t724_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t724_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t724_yes()
            END IF
        #WHEN "un_confirm"
        #   IF cl_chk_act_auth() THEN
        #      CALL t724_no()
        #   END IF
 
        WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t724_void()
            END IF
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rul),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_ruk.ruk01 IS NOT NULL THEN
                 LET g_doc.column1 = "ruk01"
                 LET g_doc.value1 = g_ruk.ruk01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t724_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rul TO s_rul.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t724_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t724_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t724_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t724_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t724_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
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
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      #ON ACTION un_confirm
      #   LET g_action_choice = "un_confirm"
      #   EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls       
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUNCTION t724_no()
#DEFINE l_cnt      LIKE type_file.num5
# 
#   IF g_ruk.ruk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01=g_ruk.ruk01
#      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
#   IF g_ruk.rukconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF
# 
#   IF NOT cl_confirm('aim-302') THEN RETURN END IF 
#   BEGIN WORK
#   OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant  
#   IF STATUS THEN 
#      CALL cl_err("OPEN t724_cl:", STATUS, 1)
#      CLOSE t724_cl  
#      ROLLBACK WORK 
#      RETURN 
#   END IF
#    
#   FETCH t724_cl INTO g_ruk.* 
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
#      CLOSE t724_cl ROLLBACK WORK RETURN 
#   END IF
#                                          
#   UPDATE ruk_file SET rukconf='N', 
#                       rukcond=NULL, 
#                       rukconu=NULL 
#     WHERE ruk01=g_ruk.ruk01
#       AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
#   IF SQLCA.sqlerrd[3]=0 OR SQLCA.SQLCODE THEN 
#      CALL cl_err('',SQLCA.SQLCODE,1)
#      RETURN
#   END IF
#   COMMIT WORK
#   
#   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01=g_ruk.ruk01
#      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
#   DISPLAY BY NAME g_ruk.rukconf                                                                                                    
#   DISPLAY BY NAME g_ruk.rukcond                                                                                                    
#   DISPLAY BY NAME g_ruk.rukconu                                                                                                    
#   DISPLAY '' TO FORMONLY.rukconu_desc                                                                                         
#    #CKP                                                                                                                            
#   IF g_ruk.rukconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
#   CALL cl_set_field_pic(g_ruk.rukconf,"","","",g_chr,"")                                                                           
#                                                                                                                                    
#   CALL cl_flow_notify(g_ruk.ruk01,'V')
#END FUNCTION
FUNCTION t724_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_rul      RECORD LIKE rul_file.*
DEFINE l_img09    LIKE img_file.img09 
DEFINE l_img10    LIKE img_file.img10 
DEFINE l_flag     LIKE type_file.num5
DEFINE l_fac      LIKE ima_file.ima31_fac
DEFINE l_qty      LIKE img_file.img10
DEFINE l_rul11    LIKE rul_file.rul11   #No.FUN-AB0067
DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087

   IF g_ruk.ruk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#CHI-C30107 ------------ add --------------- begin 
   IF g_ruk.rukconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruk.rukconf = 'X' THEN CALL cl_err(g_ruk.ruk01,'9024',0) RETURN END IF
   IF g_ruk.rukacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ------------ add --------------- end
   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_ruk.ruk00 AND rukplant = g_ruk.rukplant
   IF g_ruk.rukconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruk.rukconf = 'X' THEN CALL cl_err(g_ruk.ruk01,'9024',0) RETURN END IF 
   IF g_ruk.rukacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rul_file
    WHERE rul01=g_ruk.ruk01
      AND rul00 = g_ruk.ruk00 AND rulplant = g_ruk.rukplant
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#No.FUN-AB0067--begin    
   LET g_success='Y' 
   CALL s_showmsg_init()   
   DECLARE t724_chk_ware CURSOR FOR SELECT rul11 FROM rul_file
                                   WHERE rul01=g_ruk.ruk01 AND rul00='1'
   FOREACH t724_chk_ware INTO l_rul11           
      IF NOT s_chk_ware(l_rul11) THEN
         LET g_success='N' 
      END IF 
   END FOREACH 
   CALL s_showmsg()
   IF g_success='N' THEN 
      RETURN 
   END IF    
#No.FUN-AB0067--end 
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   
   DECLARE t724_y1_c CURSOR FOR SELECT * FROM rul_file
     WHERE rul00 = g_ruk.ruk00
       AND rul01 = g_ruk.ruk01
       AND rulplant = g_ruk.rukplant

   FOREACH t724_y1_c INTO l_rul.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = l_rul.rul03
         AND img02 = l_rul.rul11
         AND img03 = l_rul.rul12
         AND img04 = l_rul.rul13
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(l_rul.rul03,l_rul.rul11,l_rul.rul12,l_rul.rul13,g_ruk.ruk01,l_rul.rul02,g_ruk.ruk04,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_rul.rul03,l_rul.rul11,l_rul.rul12,l_rul.rul13,g_ruk.ruk01,l_rul.rul02,g_ruk.ruk04) #FUN-CC0095
       END IF
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #FUN-CC0095---end
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
               
   IF g_sma.sma892[3,3] = 'Y' AND l_cnt_img > 0 THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
      ELSE
         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #FUN-C70087---end

   BEGIN WORK
   OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
   
   IF STATUS THEN
      CALL cl_err("OPEN t724_cl:", STATUS, 1)
      CLOSE t724_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t724_cl INTO g_ruk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
      CLOSE t724_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE ruk_file SET rukconf='Y',
                       rukcond=g_today, 
                       rukconu=g_user
     WHERE ruk01=g_ruk.ruk01
       AND ruk00 = g_ruk.ruk00 AND rukplant = g_ruk.rukplant
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   
   LET g_sql = "SELECT * FROM rul_file ",
               "  WHERE rul00 = '",g_ruk.ruk00,"' AND rul01 = '",g_ruk.ruk01,"'",
               "    AND rulplant = '",g_ruk.rukplant,"'"
   PREPARE pre_sel_rul06 FROM g_sql
   DECLARE cur_rul06 CURSOR FOR pre_sel_rul06

   FOREACH cur_rul06 INTO l_rul.*
      IF s_joint_venture( l_rul.rul03 ,g_plant) OR NOT s_internal_item( l_rul.rul03,g_plant ) THEN   #FUN-A90049  
      ELSE                                                                                #FUN-A90049
         SELECT img09,img10 INTO l_img09,l_img10 FROM img_file WHERE img01 = l_rul.rul03
         AND img02 = l_rul.rul11 AND img03 = l_rul.rul12
         AND img04 = l_rul.rul13
         IF SQLCA.sqlcode = 100 THEN 
            CALL cl_err(l_rul.rul03,-1281,1) 
            LET g_success = 'N' 
            EXIT FOREACH
         END IF 
      END IF                                                                              #FUN-A90049
      CALL s_umfchk(g_rul[l_ac].rul03,g_rul[l_ac].rul06,g_rul[l_ac].rul04)
         RETURNING l_flag,l_fac
   
      IF l_flag = 1 THEN
         CALL cl_err(l_rul.rul06,'aic-907',1)
         LET g_success = 'N' 
         EXIT FOREACH
      END IF
      LET l_qty = l_rul.rul10*l_fac
      CALL s_upimg(l_rul.rul03,l_rul.rul11,l_rul.rul12,l_rul.rul13,1,l_qty,g_today,
                   l_rul.rul03,l_rul.rul11,l_rul.rul12,l_rul.rul13,l_rul.rul01,
                   l_rul.rul02,l_rul.rul06,l_rul.rul10,'','','','','','','','','','')
      CALL t724_in_log(l_rul.*)
   END FOREACH 
   IF g_success = 'Y' THEN
      LET g_ruk.rukconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_ruk.ruk01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruk.rukconu
   DISPLAY BY NAME g_ruk.rukconf                                                                                         
   DISPLAY BY NAME g_ruk.rukcond                                                                                         
   DISPLAY BY NAME g_ruk.rukconu
   DISPLAY l_gen02 TO FORMONLY.rukconu_desc
    #CKP
   IF g_ruk.rukconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruk.rukconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruk.ruk01,'V')
END FUNCTION
FUNCTION t724_in_log(p_rul)
DEFINE p_rul           RECORD LIKE rul_file.*
DEFINE l_img09     LIKE img_file.img09,                                                                                             
       l_img10     LIKE img_file.img10,                                                                                             
       l_img26     LIKE img_file.img26 
       
   SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26                                                                           
        FROM img_file WHERE img01 = p_rul.rul03 AND img02 = p_rul.rul11                                                             
                        AND img03 = p_rul.rul12 AND img04 = p_rul.rul13
    INITIALIZE g_tlf.* TO NULL                                                                                                      
    LET g_tlf.tlf01 = p_rul.rul03                                                                                                   
    LET g_tlf.tlf020 = g_ruk.rukplant                                                                                                      
    LET g_tlf.tlf02 = 731                                                                                                            
    LET g_tlf.tlf021 = p_rul.rul11                                                                                                  
    LET g_tlf.tlf022 = p_rul.rul12                                                                                                  
    LET g_tlf.tlf023 = p_rul.rul13                                                                                                  
    LET g_tlf.tlf024 = l_img10                                                                                                      
    LET g_tlf.tlf025 = l_img09                                                                                                  
    LET g_tlf.tlf026 = p_rul.rul01                                                                                                  
    LET g_tlf.tlf027 = p_rul.rul02                                                                                                  
#    LET g_tlf.tlf03 = 15                        #TQC-AC0247                                                                                    
    LET g_tlf.tlf03 = 50                         #TQC-AC0247                                                                                   
    LET g_tlf.tlf031 = p_rul.rul11                                                                                                  
    LET g_tlf.tlf032 = p_rul.rul12                                                                                                  
    LET g_tlf.tlf033 = p_rul.rul13                                                                                                  
    LET g_tlf.tlf034 = l_img10                   #TQC-AC0247                                                                                       
    LET g_tlf.tlf035 = l_img09                                                                                                  
    LET g_tlf.tlf036 = p_rul.rul01                                                                                                  
    LET g_tlf.tlf037 = p_rul.rul02                                                                                                  
    LET g_tlf.tlf04 = ' '                                                                                                           
    LET g_tlf.tlf05 = ' '                                                                                                           
    LET g_tlf.tlf06 = g_today
    LET g_tlf.tlf07=g_today                                                                                                         
    LET g_tlf.tlf08=TIME                                                                                                            
    LET g_tlf.tlf09=g_user                                                                                                          
    LET g_tlf.tlf10=p_rul.rul10                                                                                                     
    LET g_tlf.tlf11=p_rul.rul06                                                                                                     
    LET g_tlf.tlf12=p_rul.rul07                                                                                                     
    LET g_tlf.tlf13='art724'                                                                                                       
    LET g_tlf.tlf15=l_img26                                                                                                         
    LET g_tlf.tlf60=p_rul.rul07                                                                                                     
    LET g_tlf.tlf930 = p_rul.rulplant                                                                                               
    LET g_tlf.tlf903 = ' '                                                                                                          
    LET g_tlf.tlf904 = ' '                                                                                                          
    LET g_tlf.tlf905 = p_rul.rul01                                                                                                  
    LET g_tlf.tlf906 = p_rul.rul02                                                                                                  
    LET g_tlf.tlf907 = 1                                                                                                            
    CALL s_tlf(1,0) 
END FUNCTION 
FUNCTION t724_void()
DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
   IF g_ruk.ruk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_ruk.rukconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruk.rukacti = 'N' THEN CALL cl_err(g_ruk.ruk01,'art-142',0) RETURN END IF
   IF g_ruk.rukconf = 'X' THEN CALL cl_err('','art-148',0) RETURN END IF
   BEGIN WORK
 
   OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
   IF STATUS THEN
      CALL cl_err("OPEN t724_cl:", STATUS, 1)
      CLOSE t724_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t724_cl INTO g_ruk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
      CLOSE t724_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_ruk.rukconf) THEN
      LET g_chr = g_ruk.rukconf
      IF g_ruk.rukconf = 'N' THEN
         LET g_ruk.rukconf = 'X'
      ELSE
         LET g_ruk.rukconf = 'N'
      END IF
 
      UPDATE ruk_file SET rukconf=g_ruk.rukconf,
                          rukmodu=g_user,
                          rukdate=g_today
       WHERE ruk01 = g_ruk.ruk01
         AND ruk00 = g_ruk.ruk00 AND rukplant = g_ruk.rukplant
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ruk_file",g_ruk.ruk01,"",SQLCA.sqlcode,"","up rukconf",1)
          LET g_ruk.rukconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t724_cl
   COMMIT WORK
 
   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
   DISPLAY BY NAME g_ruk.rukconf                                                                                        
   DISPLAY BY NAME g_ruk.rukmodu                                                                                        
   DISPLAY BY NAME g_ruk.rukdate
    #CKP
   IF g_ruk.rukconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruk.rukconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruk.ruk01,'V')
END FUNCTION
FUNCTION t724_bp_refresh()
  DISPLAY ARRAY g_rul TO s_rul.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t724_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
   DEFINE l_gen02     LIKE gen_file.gen02
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rul.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruk.* LIKE ruk_file.*
   LET g_ruk.ruk00 = g_argv1
   LET g_ruk01_t = NULL
   DISPLAY BY NAME g_ruk.ruk00 
 
   LET g_ruk_t.* = g_ruk.*
   LET g_ruk_o.* = g_ruk.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruk.rukuser=g_user
      LET g_ruk.rukoriu = g_user 
      LET g_ruk.rukorig = g_grup 
      LET g_data_plant = g_plant #TQC-A10128 ADD
      LET g_ruk.rukgrup=g_grup
      LET g_ruk.rukacti='Y'
      LET g_ruk.rukcrat = g_today
      LET g_ruk.rukconf = 'N'
      LET g_ruk.ruk04 = g_today
      LET g_ruk.ruk05 = g_user
      LET g_ruk.rukplant = g_plant
      LET g_ruk.ruklegal = g_legal
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruk.ruk05
      DISPLAY l_gen02 TO ruk05_desc
      SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruk.rukplant
      DISPLAY l_azp02 TO rukplant_desc
 
      CALL t724_i("a")
   
      IF INT_FLAG THEN
         INITIALIZE g_ruk.* TO NULL
         LET g_ruk.ruk00 = g_argv1
         DISPLAY BY NAME g_ruk.ruk00 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruk.ruk01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      LET g_ruk.ruk00 = g_argv1
#     CALL s_auto_assign_no("art",g_ruk.ruk01,g_today,"","ruk_file","ruk01",g_plant,"","")  #FUN-A70130 mark                                      
      CALL s_auto_assign_no("art",g_ruk.ruk01,g_today,"I3","ruk_file","ruk01",g_plant,"","")  #FUN-A70130 mod                                      
         RETURNING li_result,g_ruk.ruk01
      IF (NOT li_result) THEN CONTINUE WHILE END IF
      DISPLAY BY NAME g_ruk.ruk01
      INSERT INTO ruk_file VALUES (g_ruk.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK           # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","ruk_file",g_ruk.ruk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK             # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ruk.ruk01,'I')
      END IF
 
      LET g_ruk01_t = g_ruk.ruk01
      LET g_ruk_t.* = g_ruk.*
      LET g_ruk_o.* = g_ruk.*
      CALL g_rul.clear()
 
      LET g_rec_b = 0
      CALL t724_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t724_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
 
   IF g_ruk.ruk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruk.* FROM ruk_file
    WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
   IF g_ruk.rukacti ='N' THEN
      CALL cl_err(g_ruk.ruk01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_ruk.rukconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_ruk.rukconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ruk01_t = g_ruk.ruk01
 
   BEGIN WORK
 
   OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
 
   IF STATUS THEN
      CALL cl_err("OPEN t724_cl:", STATUS, 1)
      CLOSE t724_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t724_cl INTO g_ruk.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
       CLOSE t724_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t724_show()
 
   WHILE TRUE
      LET g_ruk01_t = g_ruk.ruk01
      LET g_ruk_o.* = g_ruk.*
      LET g_ruk.rukmodu=g_user
      LET g_ruk.rukdate=g_today
 
      CALL t724_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruk.*=g_ruk_t.*
         CALL t724_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruk.ruk01 != g_ruk01_t THEN
         UPDATE rul_file SET rul01 = g_ruk.ruk01
           WHERE rul01 = g_ruk01_t
             AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rul_file",g_ruk01_t,"",SQLCA.sqlcode,"","rul",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ruk_file SET ruk_file.* = g_ruk.*
       WHERE ruk01 = g_ruk01_t
         AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruk_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t724_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruk.ruk01,'U')
 
   CALL t724_b_fill("1=1")
   #CALL t724_bp_refresh()
 
END FUNCTION
 
FUNCTION t724_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   li_result   LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_ruk.ruk03,g_ruk.ruk04,g_ruk.ruk06,g_ruk.rukplant,
                   g_ruk.rukuser,g_ruk.rukgrup,g_ruk.rukmodu,g_ruk.rukdate,
                   g_ruk.rukacti,g_ruk.rukcrat,g_ruk.rukorig,g_ruk.rukoriu,
                   g_ruk.rukconf
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_ruk.ruk01,g_ruk.ruk03,g_ruk.ruk04,g_ruk.ruk05,g_ruk.ruk06
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t724_set_entry(p_cmd)
         CALL t724_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ruk01")
 
      AFTER FIELD ruk01
         IF NOT cl_null(g_ruk.ruk01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruk.ruk01 != g_ruk_t.ruk01) THEN
#              CALL s_check_no("art",g_ruk.ruk01,g_ruk_t.ruk01,"5","ruk_file","ruk01","")  #FUN-A70130 mark
               CALL s_check_no("art",g_ruk.ruk01,g_ruk_t.ruk01,"I3","ruk_file","ruk01","")  #FUN-A70130 mod
                  RETURNING li_result,g_ruk.ruk01                                                                                   
               DISPLAY BY NAME g_ruk.ruk01                                                                                          
               IF (NOT li_result) THEN                                                                                              
                  LET g_ruk.ruk01=g_ruk_t.ruk01                                                                                     
                  NEXT FIELD ruk01                                                                                                  
               END IF
            END IF
         END IF
      AFTER FIELD ruk03
         IF NOT cl_null(g_ruk.ruk03) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruk.ruk03 != g_ruk_t.ruk03) THEN
               CALL t724_ruk03()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD ruk03                                                                                                   
               END IF
            END IF
         END IF
      
      AFTER FIELD ruk05
         IF NOT cl_null(g_ruk.ruk05) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruk.ruk05 != g_ruk_t.ruk05) THEN
               CALL t724_ruk05()                                                                                                  
               IF NOT cl_null(g_errno)  THEN                                                                                         
                  CALL cl_err('',g_errno,0)                                                                                          
                  NEXT FIELD ruk05                                                                                                   
               END IF
            END IF
         END IF      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ruk01)
               LET g_t1=s_get_doc_no(g_ruk.ruk01)
#              CALL q_smy(FALSE,FALSE,g_t1,'ART','5') RETURNING g_t1  #FUN-A70130--mark--
               CALL q_oay(FALSE,FALSE,g_t1,'I3','ART') RETURNING g_t1  #FUN-A70130--mod--
               LET g_ruk.ruk01 = g_t1
               DISPLAY BY NAME g_ruk.ruk01
               NEXT FIELD ruk01
            WHEN INFIELD(ruk03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_ruk.ruk03
               CALL cl_create_qry() RETURNING g_ruk.ruk03
               DISPLAY BY NAME g_ruk.ruk03
               CALL t724_ruk03()
               NEXT FIELD ruk03
            WHEN INFIELD(ruk05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_ruk.ruk05
               CALL cl_create_qry() RETURNING g_ruk.ruk05
               DISPLAY BY NAME g_ruk.ruk05
               CALL t724_ruk05()
               NEXT FIELD ruk05
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION t724_chk_rul03()
DEFINE  l_n  LIKE  type_file.num5
 
    SELECT COUNT(*) INTO l_n FROM rul_file
       WHERE rul01=g_ruk.ruk01 AND rul03=g_rul[l_ac].rul03
    IF l_n > 0 THEN
       RETURN FALSE
    END IF
  
    RETURN TRUE
END FUNCTION

FUNCTION t724_ruk03()
    DEFINE l_pmc03 LIKE pmc_file.pmc03
 
   LET g_errno = " "
 
   SELECT pmc03
     INTO l_pmc03
     FROM pmc_file WHERE pmc01 = g_ruk.ruk03 AND pmc05 = '1'
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-479'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_pmc03 TO FORMONLY.ruk03_desc
   END CASE
 
END FUNCTION
 
FUNCTION t724_ruk05()
    DEFINE l_gen02 LIKE gen_file.gen02
 
   LET g_errno = " "
 
   SELECT gen02
     INTO l_gen02
     FROM gen_file WHERE gen01 = g_ruk.ruk05
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'proj-15'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_gen02 TO FORMONLY.ruk05_desc
   END CASE
 
END FUNCTION

FUNCTION t724_rul06()
DEFINE l_flag       LIKE type_file.num5
DEFINE l_fac        LIKE ima_file.ima31_fac

   LET g_errno = ' '
   
   SELECT gfe02 INTO g_rul[l_ac].rul06_desc FROM gfe_file
       WHERE gfe01 = g_rul[l_ac].rul06 AND gfeacti = 'Y'
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-319'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
    
END FUNCTION

FUNCTION t724_rul11()
DEFINE l_imdacti       LIKE imd_file.imdacti
DEFINE l_imd20         LIKE imd_file.imd20
DEFINE l_n             LIKE type_file.num5

   LET g_errno = ' '
   SELECT imdacti,imd20 INTO l_imdacti,l_imd20 FROM imd_file 
      WHERE imd01 = g_rul[l_ac].rul11
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aim-877'
        WHEN l_imdacti = 'N'     LET g_errno = 'art-303'
        WHEN l_imd20 IS NULL OR l_imd20 <> g_ruk.rukplant
                                 LET g_errno = 'art-426'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_rul[l_ac].rul11
   IF l_n > 0 THEN LET g_errno = 'axm-065' END IF 
END FUNCTION 
FUNCTION t724_chk_unit()
DEFINE l_flag    LIKE type_file.num5
DEFINE l_fac     LIKE ima_file.ima31_fac

   LET g_errno = ' '
   IF g_rul[l_ac].rul03 IS NULL OR g_rul[l_ac].rul04 IS NULL 
      OR g_rul[l_ac].rul06 IS NULL THEN 
      RETURN 
   END IF 
   
   CALL s_umfchk(g_rul[l_ac].rul03,g_rul[l_ac].rul06,g_rul[l_ac].rul04)
      RETURNING l_flag,l_fac
   
   IF l_flag = 1 THEN
      LET g_errno = 'aic-907'
   ELSE
      LET g_rul[l_ac].rul07 = l_fac
   END IF
END FUNCTION  
FUNCTION t724_rul05()
DEFINE l_rta01      LIKE rta_file.rta01
DEFINE l_rta03      LIKE rta_file.rta03
DEFINE l_rtaacti    LIKE rta_file.rtaacti
DEFINE l_flag       LIKE type_file.num5
DEFINE l_fac        LIKE ima_file.ima31_fac

    LET g_errno = " "
    
    SELECT DISTINCT rta01,rta03,rtaacti INTO l_rta01,l_rta03,l_rtaacti FROM rta_file
       WHERE rta05 = g_rul[l_ac].rul05
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'art-298'
         WHEN l_rtaacti='N' LET g_errno = 'art-231'
          OTHERWISE         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF 
   
   LET g_rul[l_ac].rul03 = l_rta01
   LET g_rul[l_ac].rul06 = l_rta03
   
   SELECT ima02,ima25 INTO g_rul[l_ac].rul03_desc,g_rul[l_ac].rul04
     FROM ima_file WHERE ima01 = g_rul[l_ac].rul03
   SELECT gfe02 INTO g_rul[l_ac].rul04_desc FROM gfe_file
      WHERE gfe01 = g_rul[l_ac].rul04
   SELECT gfe02 INTO g_rul[l_ac].rul06_desc FROM gfe_file
      WHERE gfe01 = g_rul[l_ac].rul06
   CALL s_umfchk(g_rul[l_ac].rul03,g_rul[l_ac].rul06,g_rul[l_ac].rul04)
      RETURNING l_flag,l_fac
   IF l_flag = 1 THEN
      LET g_rul[l_ac].rul07 = 1
   ELSE 
      LET g_rul[l_ac].rul07 = l_fac
   END IF 
   CALL cl_set_comp_entry("rul03,rul06",FALSE)
END FUNCTION

FUNCTION t724_rul03()
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_n       LIKE type_file.num5
 
   LET g_errno = " "
 
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_ruk.rukplant
   IF l_rtz04 IS NULL THEN 
      SELECT ima02,ima25,imaacti
        INTO g_rul[l_ac].rul03_desc,g_rul[l_ac].rul04,l_imaacti
       FROM ima_file WHERE ima01 = g_rul[l_ac].rul03
       
       CASE WHEN SQLCA.SQLCODE = 100  
                             LET g_errno = 'art-037'
          WHEN l_imaacti='N' LET g_errno = '9028'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                             DISPLAY g_rul[l_ac].rul03_desc TO FORMONLY.rul03_desc
                             SELECT gfe02 INTO g_rul[l_ac].rul04_desc FROM gfe_file 
                                 WHERE gfe01 = g_rul[l_ac].rul04
      END CASE
   ELSE 
   	  SELECT COUNT(*) INTO l_n FROM rte_file,rtd_file
   	     WHERE rtd01 = rte01 AND rtd01 = l_rtz04 AND rte03 = g_rul[l_ac].rul03
   	  IF l_n = 0 THEN LET g_errno = 'art-030' RETURN END IF 
   	  SELECT ima02,ima25 INTO g_rul[l_ac].rul03_desc,g_rul[l_ac].rul04
         FROM ima_file WHERE ima01 = g_rul[l_ac].rul03
      SELECT gfe02 INTO g_rul[l_ac].rul04_desc FROM gfe_file WHERE gfe01 = g_rul[l_ac].rul04
   END IF 
END FUNCTION
 
FUNCTION t724_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rul.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t724_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ruk.* TO NULL
      LET g_ruk.ruk00 = g_argv1
      DISPLAY BY NAME g_ruk.ruk00 
      RETURN
   END IF
 
   OPEN t724_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ruk.* TO NULL
      LET g_ruk.ruk00 = g_argv1
      DISPLAY BY NAME g_ruk.ruk00 
   ELSE
      OPEN t724_count
      FETCH t724_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t724_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t724_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t724_cs INTO g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
      WHEN 'P' FETCH PREVIOUS t724_cs INTO g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
      WHEN 'F' FETCH FIRST    t724_cs INTO g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
      WHEN 'L' FETCH LAST     t724_cs INTO g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION HELP
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
        END IF
        FETCH ABSOLUTE g_jump t724_cs INTO g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
      INITIALIZE g_ruk.* TO NULL
      LET g_ruk.ruk00 = g_argv1
      DISPLAY BY NAME g_ruk.ruk00 
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
 
   SELECT * INTO g_ruk.* FROM ruk_file WHERE ruk01 = g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruk_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ruk.* TO NULL
      LET g_ruk.ruk00 = g_argv1
      DISPLAY BY NAME g_ruk.ruk00 
      RETURN
   END IF
 
   LET g_data_owner = g_ruk.rukuser
   LET g_data_group = g_ruk.rukgrup
   LET g_data_plant = g_ruk.rukplant #TQC-A10128 ADD
 
   CALL t724_show()
 
END FUNCTION
 
FUNCTION t724_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
 
   LET g_ruk_t.* = g_ruk.*
   LET g_ruk_o.* = g_ruk.*
   DISPLAY BY NAME g_ruk.ruk01,g_ruk.ruk05, g_ruk.ruk04,
                   g_ruk.rukoriu,g_ruk.rukorig,g_ruk.ruk00,
                   g_ruk.rukconf,g_ruk.ruk03,g_ruk.rukcond,
                   g_ruk.rukconu,g_ruk.rukuser,g_ruk.ruk06,
                   g_ruk.rukmodu,g_ruk.rukacti,g_ruk.rukgrup,
                   g_ruk.rukdate,g_ruk.rukcrat,g_ruk.rukplant
 
   IF g_ruk.rukconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_ruk.rukconf,"","","",g_chr,"")                                                                           
   CALL cl_flow_notify(g_ruk.ruk01,'V') 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruk.rukconu
   DISPLAY l_gen02 TO FORMONLY.rukconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=g_ruk.rukplant
   DISPLAY l_azp02 TO FORMONLY.rukplant_desc
   
   CALL t724_ruk03()
   CALL t724_ruk05()
   CALL t724_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
FUNCTION t724_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruk.ruk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_ruk.rukconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruk.rukconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    
   BEGIN WORK 
   OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
   IF STATUS THEN
      CALL cl_err("OPEN t724_cl:", STATUS, 1)
      CLOSE t724_cl
      RETURN
   END IF
 
   FETCH t724_cl INTO g_ruk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t724_show()
 
   IF g_ruk.rukconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   #BEGIN WORK 
   IF cl_exp(0,0,g_ruk.rukacti) THEN
      LET g_chr=g_ruk.rukacti
      IF g_ruk.rukacti='Y' THEN
         LET g_ruk.rukacti='N'
      ELSE
         LET g_ruk.rukacti='Y'
      END IF
 
      UPDATE ruk_file SET rukacti=g_ruk.rukacti,
                          rukmodu=g_user,
                          rukdate=g_today
       WHERE ruk01=g_ruk.ruk01
         AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruk_file",g_ruk.ruk01,"",SQLCA.sqlcode,"","",1) 
         LET g_ruk.rukacti=g_chr
      END IF
   END IF
 
   CLOSE t724_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruk.ruk01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rukacti,rukmodu,rukdate
     INTO g_ruk.rukacti,g_ruk.rukmodu,g_ruk.rukdate FROM ruk_file
    WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
   DISPLAY BY NAME g_ruk.rukacti,g_ruk.rukmodu,g_ruk.rukdate
 
END FUNCTION
 
FUNCTION t724_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruk.ruk01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruk.* FROM ruk_file
    WHERE ruk01=g_ruk.ruk01
      AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
 
   IF g_ruk.rukconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_ruk.rukconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_ruk.rukacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
   IF STATUS THEN
      CALL cl_err("OPEN t724_cl:", STATUS, 1)
      CLOSE t724_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t724_cl INTO g_ruk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t724_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruk01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruk.ruk01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM ruk_file WHERE ruk01 = g_ruk.ruk01 AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
      DELETE FROM rul_file WHERE rul01 = g_ruk.ruk01 AND rul00 = g_argv1 AND rulplant = g_ruk.rukplant
      CLEAR FORM
      CALL g_rul.clear()
      OPEN t724_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t724_cl
          CLOSE t724_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
      FETCH t724_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t724_cl
          CLOSE t724_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t724_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t724_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t724_fetch('/')
      END IF
   END IF
 
   CLOSE t724_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruk.ruk01,'D')
END FUNCTION
 
FUNCTION t724_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_azp03   LIKE azp_file.azp03
DEFINE l_line    LIKE type_file.num5
DEFINE l_ima906  LIKE ima_file.ima906  #FUN-C30300
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ruk.ruk01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ruk.* FROM ruk_file
     WHERE ruk01=g_ruk.ruk01
       AND ruk00 = g_argv1 AND rukplant = g_ruk.rukplant
 
    IF g_ruk.rukacti ='N' THEN
       CALL cl_err(g_ruk.ruk01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_ruk.rukconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_ruk.rukconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rul02,rul03,'',rul04,'',rul05,rul06,'',rul07,rul09,rul10,rul11,rul12,rul13 ", 
                       "  FROM rul_file ",
                       " WHERE rul00 = ? AND rul01=? AND rul02=? AND rulplant = ? "," FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t724_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rul WITHOUT DEFAULTS FROM s_rul.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t724_cl USING g_ruk.ruk00,g_ruk.ruk01,g_ruk.rukplant
           IF STATUS THEN
              CALL cl_err("OPEN t724_cl:", STATUS, 1)
              CLOSE t724_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t724_cl INTO g_ruk.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ruk.ruk01,SQLCA.sqlcode,0)
              CLOSE t724_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rul_t.* = g_rul[l_ac].*  #BACKUP
              LET g_rul_o.* = g_rul[l_ac].*  #BACKUP
              LET g_rul06_t = g_rul[l_ac].rul06      #FUN-BB0085
              OPEN t724_bcl USING g_ruk.ruk00,g_ruk.ruk01,g_rul_t.rul02,g_ruk.rukplant
              IF STATUS THEN
                 CALL cl_err("OPEN t724_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t724_bcl INTO g_rul[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rul_t.rul02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t724_rul03() 
                 #CALL t724_rul04() 
                 CALL t724_rul06() 
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rul[l_ac].* TO NULL
           LET g_rul[l_ac].rul09 =  0            #Body default
           LET g_rul_t.* = g_rul[l_ac].*
           LET g_rul_o.* = g_rul[l_ac].*
           LET g_rul06_t = g_rul[l_ac].rul06     #FUN-BB0085
           CALL cl_show_fld_cont()
           NEXT FIELD rul02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_rul[l_ac].rul12 IS NULL THEN LET g_rul[l_ac].rul12 = ' ' END IF 
           IF g_rul[l_ac].rul13 IS NULL THEN LET g_rul[l_ac].rul13 = ' ' END IF
           CALL t724_chk_img()
           INSERT INTO rul_file(rul00,rul01,rul02,rul03,rul04,rul05,rul06,
                                rul07,rul09,rul10,rul11,rul12,rul13,rulplant,rullegal)   
           VALUES(g_ruk.ruk00,g_ruk.ruk01,g_rul[l_ac].rul02,
                  g_rul[l_ac].rul03,g_rul[l_ac].rul04,
                  g_rul[l_ac].rul05,g_rul[l_ac].rul06,
                  g_rul[l_ac].rul07,
                  g_rul[l_ac].rul09,g_rul[l_ac].rul10,
                  g_rul[l_ac].rul11,g_rul[l_ac].rul12,
                  g_rul[l_ac].rul13,g_ruk.rukplant,g_ruk.ruklegal)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rul_file",g_ruk.ruk01,g_rul[l_ac].rul02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rul02
           IF g_rul[l_ac].rul02 IS NULL OR g_rul[l_ac].rul02 = 0 THEN
              SELECT max(rul02)+1
                INTO g_rul[l_ac].rul02
                FROM rul_file
               WHERE rul01 = g_ruk.ruk01
                 AND rul00 = g_ruk.ruk00
                 AND rulplant = g_ruk.rukplant
              IF g_rul[l_ac].rul02 IS NULL THEN
                 LET g_rul[l_ac].rul02 = 1
              END IF
           END IF
 
        AFTER FIELD rul02
           IF NOT cl_null(g_rul[l_ac].rul02) THEN
              IF g_rul[l_ac].rul02 != g_rul_t.rul02
                 OR g_rul_t.rul02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rul_file
                  WHERE rul01 = g_ruk.ruk01
                    AND rul02 = g_rul[l_ac].rul02
                    AND rul00 = g_ruk.ruk00
                    AND rulplant = g_ruk.rukplant
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rul[l_ac].rul02 = g_rul_t.rul02
                    NEXT FIELD rul02
                 END IF
              END IF
           END IF
 
      AFTER FIELD rul03
         IF NOT cl_null(g_rul[l_ac].rul03) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_rul[l_ac].rul03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_rul[l_ac].rul03= g_rul_t.rul03
               NEXT FIELD rul03
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_rul_o.rul03 IS NULL OR
               (g_rul[l_ac].rul03 != g_rul_o.rul03 ) THEN
               CALL t724_rul03()        
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rul[l_ac].rul03,g_errno,0)
                  LET g_rul[l_ac].rul03 = g_rul_o.rul03
                  DISPLAY BY NAME g_rul[l_ac].rul03
                  NEXT FIELD rul03
               END IF
               CALL t724_chk_unit()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rul[l_ac].rul03,g_errno,0)
                  LET g_rul[l_ac].rul03 = g_rul_o.rul03
                  DISPLAY BY NAME g_rul[l_ac].rul03
                  NEXT FIELD rul03
               END IF
            END IF  
         END IF  
        
        AFTER FIELD rul05
           IF NOT cl_null(g_rul[l_ac].rul05) THEN
#FUN-AB0025 ----------------------mark------------------------------
#FUN-AA0059 ---------------------start----------------------------
#             IF NOT s_chk_item_no(g_rul[l_ac].rul05,"") THEN
#                CALL cl_err('',g_errno,1)
#                LET g_rul[l_ac].rul05= g_rul_t.rul05
#                NEXT FIELD rul05
#              END IF
#FUN-AA0059 ---------------------end-------------------------------
#FUN-AB0025 -----------------------mark------------------------------
              IF g_rul_o.rul05 IS NULL OR
                 (g_rul[l_ac].rul05 != g_rul_o.rul05 ) THEN
                 CALL t724_rul05()        
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rul[l_ac].rul05,g_errno,0)
                    LET g_rul[l_ac].rul05 = g_rul_o.rul05
                    DISPLAY BY NAME g_rul[l_ac].rul05
                    NEXT FIELD rul05
                 END IF
                 #FUN-BB0085-add-str--
                 CALL t724_rul09_check()
                 IF NOT cl_null(g_rul[l_ac].rul10) AND g_rul[l_ac].rul10 <> 0 THEN      #FUN-C20068
                    IF NOT t724_rul10_check() THEN 
                       LET g_rul06_t = g_rul[l_ac].rul06
                       NEXT FIELD rul10
                    END IF 
                    LET g_rul06_t = g_rul[l_ac].rul06
                 END IF                                                                 #FUN-C20068 
                 #FUN-BB0085-add-end--
              END IF  
           END IF  
           
        AFTER FIELD rul06
           IF NOT cl_null(g_rul[l_ac].rul06) THEN
              IF g_rul_o.rul06 IS NULL OR
                 (g_rul[l_ac].rul06 != g_rul_o.rul06 ) THEN
                 CALL t724_rul06()        
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rul[l_ac].rul06,g_errno,0)
                    LET g_rul[l_ac].rul06 = g_rul_o.rul06
                    DISPLAY BY NAME g_rul[l_ac].rul06
                    NEXT FIELD rul06
                 END IF
                 CALL t724_chk_unit()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rul[l_ac].rul06,g_errno,0)
                    LET g_rul[l_ac].rul06 = g_rul_o.rul06
                    DISPLAY BY NAME g_rul[l_ac].rul06
                    NEXT FIELD rul06
                 END IF
              END IF  
              #FUN-BB0085-add-str--
              CALL t724_rul09_check()
              IF NOT cl_null(g_rul[l_ac].rul10) AND g_rul[l_ac].rul10 <> 0 THEN      #FUN-C20068
                 IF NOT t724_rul10_check() THEN 
                    LET g_rul06_t = g_rul[l_ac].rul06
                    NEXT FIELD rul10
                 END IF 
                 LET g_rul06_t = g_rul[l_ac].rul06
              END IF                                                                 #FUN-C20068
              #FUN-BB0085-add-end--
           END IF 
           
        AFTER FIELD rul10
           IF NOT t724_rul10_check() THEN NEXT FIELD rul10 END IF   #FUN-BB0085
           #FUN-BB0085-mark-str--
           #IF NOT cl_null(g_rul[l_ac].rul10) THEN
           #   IF g_rul_o.rul10 IS NULL OR
           #      (g_rul[l_ac].rul10 != g_rul_o.rul10 ) THEN
           #      IF g_rul[l_ac].rul10 <= 0 THEN 
           #         CALL cl_err('','aem-042',0)
           #         NEXT FIELD rul10
           #      END IF 
           #   END IF  
           #END IF
           #FUN-BB0085-mark-end--
                   
        AFTER FIELD rul11
           IF NOT cl_null(g_rul[l_ac].rul11) THEN
              IF g_rul_o.rul11 IS NULL OR
                 (g_rul[l_ac].rul11 != g_rul_o.rul11 ) THEN
                 CALL t724_rul11()        
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rul[l_ac].rul11,g_errno,0)
                    NEXT FIELD rul11
                 END IF
              END IF  
              #No.FUN-AA0062  --start--
              IF NOT s_chk_ware(g_rul[l_ac].rul11) THEN
                NEXT FIELD rul11
              END IF
              #No.FUN-AA0062  --end--
           END IF
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rul_t.rul02 > 0 AND g_rul_t.rul02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rul_file
               WHERE rul01 = g_ruk.ruk01
                 AND rul02 = g_rul_t.rul02
                 AND rul00 = g_ruk.ruk00
                 AND rulplant = g_ruk.rukplant
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rul_file",g_ruk.ruk01,g_rul_t.rul02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rul[l_ac].* = g_rul_t.*
              CLOSE t724_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF

           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rul[l_ac].rul02,-263,1)
              LET g_rul[l_ac].* = g_rul_t.*
           ELSE
              IF cl_null(g_rul[l_ac].rul12) THEN   #TQC-A20039 ADD
                 LET g_rul[l_ac].rul12=' '
              END IF
              IF cl_null(g_rul[l_ac].rul13) THEN   #TQC-A20039 ADD
                 LET g_rul[l_ac].rul13=' '
              END IF
              CALL t724_chk_img()
              UPDATE rul_file SET rul02=g_rul[l_ac].rul02,
                                  rul03=g_rul[l_ac].rul03,
                                  rul04=g_rul[l_ac].rul04,
                                  rul05=g_rul[l_ac].rul05,
                                  rul06=g_rul[l_ac].rul06,
                                  rul07=g_rul[l_ac].rul07,
                                  rul09=g_rul[l_ac].rul09,
                                  rul10=g_rul[l_ac].rul10,
                                  rul11=g_rul[l_ac].rul11,
                                  rul12=g_rul[l_ac].rul12,
                                  rul13=g_rul[l_ac].rul13
               WHERE rul01=g_ruk.ruk01
                 AND rul02=g_rul_t.rul02
                 AND rul00 = g_ruk.ruk00
                 AND rulplant = g_ruk.rukplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rul_file",g_ruk.ruk01,g_rul_t.rul02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rul[l_ac].* = g_rul_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rul[l_ac].* = g_rul_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rul.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t724_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t724_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rul02) AND l_ac > 1 THEN
              LET g_rul[l_ac].* = g_rul[l_ac-1].*
              LET g_rul[l_ac].rul02 = g_rec_b + 1
              NEXT FIELD rul02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rul03)
#FUN-AA0059---------mod------------str-----------------              
#                 SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruk.ruk03        #No.FUN-A10012
#                 SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruk.rukplant      #No.FUN-A10012
#                 CALL cl_init_qry_var()
#                 IF cl_null(l_rtz04) THEN
#                    LET g_qryparam.form = "q_ima"
#                 ELSE
##                    LET g_qryparam.form ="q_ruk01_1"       #No.FUN-A10012
#                    LET g_qryparam.form ="q_rte03_1"       #No.FUN-A10012
#                    LET g_qryparam.arg1 = l_rtz04
#                 END IF
#                 LET g_qryparam.default1 = g_rul[l_ac].rul03
#                 CALL cl_create_qry() RETURNING g_rul[l_ac].rul03
                 CALL q_sel_ima(FALSE, "q_ima","",g_rul[l_ac].rul03,"","","","","",'' ) 
                    RETURNING g_rul[l_ac].rul03

#FUN-AA0059---------mod------------end-----------------
                 CALL t724_rul03()
                 NEXT FIELD rul03
              #No.FUN-A10012--begin
              WHEN INFIELD(rul06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_smd1"
                 LET g_qryparam.arg1 = g_rul[l_ac].rul03
                 LET g_qryparam.arg2 = g_rul[l_ac].rul04
                 LET g_qryparam.default1 = g_rul[l_ac].rul06
                 CALL cl_create_qry() RETURNING g_rul[l_ac].rul06
                 NEXT FIELD rul06              
              #No.FUN-A10012--end  
              WHEN INFIELD(rul11) OR INFIELD(rul12) OR INFIELD(rul13)
                 CALL cl_init_qry_var()
                 #FUN-C30300---begin
                 LET l_ima906 = NULL
                 SELECT ima906 INTO l_ima906 FROM ima_file
                  WHERE ima01 = g_rul[l_ac].rul03
                 #IF s_industry("icd") AND l_ima906='3' THEN  #TQC-C60028
                 IF s_industry("icd") THEN  #TQC-C60028
                    CALL q_idc(FALSE,TRUE,g_rul[l_ac].rul03,g_rul[l_ac].rul11,
                                g_rul[l_ac].rul12,g_rul[l_ac].rul13)
                    RETURNING g_rul[l_ac].rul11,g_rul[l_ac].rul12,g_rul[l_ac].rul13
                 ELSE
                 #FUN-C30300---end
                    CALL q_img4(FALSE,TRUE,g_rul[l_ac].rul03,g_rul[l_ac].rul11,
                                g_rul[l_ac].rul12,g_rul[l_ac].rul13,'A')
                       RETURNING g_rul[l_ac].rul11,g_rul[l_ac].rul12,g_rul[l_ac].rul13
                 END IF #FUN-C30300
                 DISPLAY BY NAME g_rul[l_ac].rul11
                 DISPLAY BY NAME g_rul[l_ac].rul12
                 DISPLAY BY NAME g_rul[l_ac].rul13
                 IF INFIELD(rul11) THEN NEXT FIELD rul11 END IF
                 IF INFIELD(rul12) THEN NEXT FIELD rul12 END IF
                 IF INFIELD(rul13) THEN NEXT FIELD rul13 END IF
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
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
    UPDATE ruk_file SET rukmodu = g_ruk.rukmodu,rukdate = g_ruk.rukdate
       WHERE ruk01 = g_ruk.ruk01
         AND rul00 = g_ruk.ruk00
         AND rulplant = g_ruk.rukplant
    DISPLAY BY NAME g_ruk.rukmodu,g_ruk.rukdate 
 
    CLOSE t724_bcl
    COMMIT WORK
#   CALL t724_delall() #CHI-C30002 mark
    CALL t724_delHeader()     #CHI-C30002 add
 
END FUNCTION
FUNCTION  t724_chk_img()
DEFINE l_n     LIKE type_file.num5
#FUN-A90049 -------------start------------------------------------   
   IF s_joint_venture( g_rul[l_ac].rul03 ,g_plant) OR NOT s_internal_item( g_rul[l_ac].rul03,g_plant ) THEN
       RETURN
   END IF
#FUN-A90049 --------------end-------------------------------------
   SELECT COUNT(*) INTO l_n FROM img_file WHERE img01 = g_rul[l_ac].rul03
      AND img02 = g_rul[l_ac].rul11 AND img03 = g_rul[l_ac].rul12
      AND img04 = g_rul[l_ac].rul13
   IF l_n > 0 THEN RETURN END IF 
   
   CALL s_add_img(g_rul[l_ac].rul03,g_rul[l_ac].rul11,g_rul[l_ac].rul12,
                  g_rul[l_ac].rul13,g_ruk.ruk01,g_rul[l_ac].rul02,g_ruk.ruk04)
END FUNCTION 

#CHI-C30002 -------- add -------- begin
FUNCTION t724_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ruk.ruk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ruk_file ",
                  "  WHERE ruk01 LIKE '",l_slip,"%' ",
                  "    AND ruk01 > '",g_ruk.ruk01,"'"
      PREPARE t724_pb2 FROM l_sql 
      EXECUTE t724_pb2 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t724_void()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ruk_file WHERE ruk01 = g_ruk.ruk01 AND ruk00 = g_ruk.ruk00
                       AND rukplant = g_ruk.rukplant
         INITIALIZE g_ruk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t724_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rul_file
#   WHERE rul01 = g_ruk.ruk01 AND rul00 = g_ruk.ruk00
#     AND rulplant = g_ruk.rukplant
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM ruk_file WHERE ruk01 = g_ruk.ruk01 AND ruk00 = g_ruk.ruk00
#                            AND rukplant = g_ruk.rukplant
#     CALL g_rul.clear()
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t724_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rul02,rul03,'',rul04,'',rul05,rul06,'',rul07,rul09, ",
               "  rul10,rul11,rul12,rul13 ", 
               "  FROM rul_file",
               " WHERE rul01 ='",g_ruk.ruk01,"' AND rul00 = '",g_ruk.ruk00,"' ",
               "   AND rulplant = '",g_ruk.rukplant,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rul02 "
 
   DISPLAY g_sql
 
   PREPARE t724_pb FROM g_sql
   DECLARE rul_cs CURSOR FOR t724_pb
 
   CALL g_rul.clear()
   LET g_cnt = 1
 
   FOREACH rul_cs INTO g_rul[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02 INTO g_rul[g_cnt].rul03_desc FROM ima_file
           WHERE ima01 = g_rul[g_cnt].rul03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rul[g_cnt].rul03,"",SQLCA.sqlcode,"","",0)  
          LET g_rul[g_cnt].rul03_desc = NULL
       END IF
       SELECT gfe02 INTO g_rul[g_cnt].rul04_desc FROM gfe_file
          WHERE gfe01 = g_rul[g_cnt].rul04
       SELECT gfe02 INTO g_rul[g_cnt].rul06_desc FROM gfe_file
          WHERE gfe01 = g_rul[g_cnt].rul06
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rul.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t724_copy()
   DEFINE l_newno     LIKE ruk_file.ruk01,
          l_oldno     LIKE ruk_file.ruk01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ruk.ruk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t724_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ruk01
 
       AFTER FIELD ruk01
          IF l_newno IS NULL THEN 
             NEXT FIELD ruk01
          ELSE 
#            CALL s_check_no("art",l_newno,"","5","ruk_file","ruk01","")  #FUN-A70130 mark
             CALL s_check_no("art",l_newno,"","I3","ruk_file","ruk01","")  #FUN-A70130 mod 
                RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                NEXT FIELD ruk01
             END IF 
             BEGIN WORK
#            CALL s_auto_assign_no("art",l_newno,g_today,"","ruk_file","ruk01",g_plant,"","") #FUN-A70130 mark                                      
             CALL s_auto_assign_no("art",l_newno,g_today,"I3","ruk_file","ruk01",g_plant,"","") #FUN-A70130 mod                                      
                RETURNING li_result,l_newno                                                                                         
             IF (NOT li_result) THEN                                                                                                
                ROLLBACK WORK                                                                                                       
                NEXT FIELD ruk01                                                                                                    
             ELSE                                                                                                                   
                COMMIT WORK                                                                                                         
             END IF
          END IF
 
      ON ACTION controlp                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(ruk01)                                                                                                     
              LET g_t1=s_get_doc_no(g_ruk.ruk01)                                                                                    
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','5') RETURNING g_t1    #FUN-A70130--mark--                                                             
              CALL q_oay(FALSE,FALSE,g_t1,'I3','ART') RETURNING g_t1  #FUN-A70130--mod--
              LET l_newno = g_t1                                                                                                    
              DISPLAY l_newno TO ruk01                                                                                              
              NEXT FIELD ruk01                                                                                                      
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
      DISPLAY BY NAME g_ruk.ruk01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM ruk_file
       WHERE ruk01=g_ruk.ruk01
         AND ruk00=g_ruk.ruk00
         AND rukplant=g_ruk.rukplant
       INTO TEMP y
 
   UPDATE y
       SET ruk01=l_newno,
           rukplant=g_plant,
           rukconf = 'N',
           rukcond = NULL,
           rukconu = NULL,
           rukuser=g_user,
           rukgrup=g_grup,
           rukmodu=NULL,
           rukdate=NULL,
           rukacti='Y',
           rukcrat=g_today,
           rukorig=g_grup,
           rukoriu=g_user,
           ruklegal=g_legal
 
   INSERT INTO ruk_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruk_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rul_file
       WHERE rul01=g_ruk.ruk01
         AND rul00=g_ruk.ruk00
         AND rulplant=g_ruk.rukplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rul01=l_newno,rulplant=g_plant,rullegal=g_legal
 
   INSERT INTO rul_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK           # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rul_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK            # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_ruk.ruk01
   SELECT ruk_file.* INTO g_ruk.* FROM ruk_file WHERE ruk01 = l_newno
      AND ruk00 = g_ruk.ruk00 AND rukplant = g_plant
   CALL t724_u()
   CALL t724_b()
   #FUN-C80046---begin
   #SELECT ruk_file.* INTO g_ruk.* FROM ruk_file WHERE ruk01 = l_oldno
   #   AND ruk00 = g_ruk.ruk00 AND rukplant = g_ruk.rukplant
   #CALL t724_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t724_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_ruk.ruk01 IS NOT NULL THEN
       LET g_wc = "ruk01='",g_ruk.ruk01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt724" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t724_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ruk01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t724_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ruk01",FALSE)
    END IF
 
END FUNCTION

#FUN-BB0085----add----str----
FUNCTION t724_rul09_check()
   IF NOT cl_null(g_rul[l_ac].rul09) AND NOT cl_null(g_rul[l_ac].rul06) THEN 
      IF cl_null(g_rul06_t) OR g_rul06_t != g_rul[l_ac].rul06 OR
         cl_null(g_rul_t.rul09) OR g_rul_t.rul09 != g_rul[l_ac].rul09 THEN
         LET g_rul[l_ac].rul09 = s_digqty(g_rul[l_ac].rul09,g_rul[l_ac].rul06)
         DISPLAY BY NAME g_rul[l_ac].rul09
      END IF
   END IF
END FUNCTION

FUNCTION t724_rul10_check()
   IF NOT cl_null(g_rul[l_ac].rul10) AND NOT cl_null(g_rul[l_ac].rul06) THEN 
      IF cl_null(g_rul06_t) OR g_rul06_t != g_rul[l_ac].rul06 OR
         cl_null(g_rul_t.rul10) OR g_rul_t.rul10 != g_rul[l_ac].rul10 THEN
         LET g_rul[l_ac].rul10 = s_digqty(g_rul[l_ac].rul10,g_rul[l_ac].rul06)
         DISPLAY BY NAME g_rul[l_ac].rul10
      END IF
   END IF

   IF NOT cl_null(g_rul[l_ac].rul10) THEN
      IF g_rul_o.rul10 IS NULL OR
         (g_rul[l_ac].rul10 != g_rul_o.rul10 ) THEN
         IF g_rul[l_ac].rul10 <= 0 THEN
            CALL cl_err('','aem-042',0)
            RETURN FALSE    
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085----add----end----
#FUN-960130 
