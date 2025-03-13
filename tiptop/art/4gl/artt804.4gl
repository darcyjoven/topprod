# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt804.4gl
# Descriptions...: 競爭對手銷售資料維護作業
# Date & Author..: NO.FUN-B50009 11/05/09 By huangtao
# Modify.........: No:MOD-B70038 11/07/06 By JoHung 銷售日期改為必填且同一營運中心不可重複
# Modify.........: No:FUN-B70033 11/07/12 by pauline 同業競爭資料可輸入負數金額
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20257 12/02/17 by fanbj 列印功能取消ON
# Modify.........: No:TQC-C20256 12/02/20 by fanbj 取號按銷售日期取號
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20015 13/03/27 By minpp 將確認人，確認日期改為確認異動人員，確認異動日期，取消審核時，回寫確認異動人員及日期
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rcf         RECORD LIKE rcf_file.*,
       g_rcf_t       RECORD LIKE rcf_file.*,
       g_rcf_o       RECORD LIKE rcf_file.*,
       g_rcf01_t     LIKE rcf_file.rcf01,
       g_t1          LIKE oay_file.oayslip,
       g_sheet       LIKE oay_file.oayslip,
       g_ydate       LIKE type_file.dat,
       g_rcg         DYNAMIC ARRAY OF RECORD
          rcg02        LIKE rcg_file.rcg02,
          rcg03        LIKE rcg_file.rcg03,
          rcg03_desc   LIKE lse_file.lse02,
          rcg04        LIKE rcg_file.rcg04
                          END RECORD,
       g_rcg_t            RECORD
          rcg02        LIKE rcg_file.rcg02,
          rcg03        LIKE rcg_file.rcg03,
          rcg03_desc   LIKE lse_file.lse02,
          rcg04        LIKE rcg_file.rcg04
                          END RECORD,
       g_rcg_o            RECORD 
          rcg02        LIKE rcg_file.rcg02,
          rcg03        LIKE rcg_file.rcg03,
          rcg03_desc   LIKE lse_file.lse02,
          rcg04        LIKE rcg_file.rcg04
                          END RECORD,
           g_sql          STRING,
           g_wc           STRING,
           g_wc2          STRING,
           g_rec_b        LIKE type_file.num5,
           l_ac           LIKE type_file.num5
DEFINE g_gec07            LIKE gec_file.gec07
DEFINE g_forupd_sql       STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_argv1             LIKE rcf_file.rcf01
DEFINE g_argv2             STRING 
DEFINE l_rcg               RECORD  LIKE rcg_file.*    
 
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

 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM rcf_file WHERE rcf01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t804_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t804_w WITH FORM "art/42f/artt804"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL t804_menu()
   CLOSE WINDOW t804_w
 
   CALL cl_used(g_prog,g_time,2)
      RETURNING g_time
 
END MAIN
 
FUNCTION t804_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rcg.clear()
   
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_rcf.* TO NULL
      
   CONSTRUCT BY NAME g_wc ON rcf01,rcfplant,rcf02,rcf03,
                                rcfconf,rcfcond,rcfcont,rcfconu,
                                rcfuser,rcfgrup,rcforiu,rcfcrat,
                                rcfmodu,rcforig,rcfacti,rcfdate      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rcf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rcf01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcf01
                  NEXT FIELD rcf01
                  
               WHEN INFIELD(rcfplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azw01_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcfplant
                  NEXT FIELD rcfplant

               WHEN INFIELD(rcfconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rcfconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcfconu
                  NEXT FIELD rcfconu
                  
                  
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

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rcfuser', 'rcfgrup')

   CONSTRUCT g_wc2 ON rcg02,rcg03,rcg04
                 FROM s_rcg[1].rcg02,s_rcg[1].rcg03,s_rcg[1].rcg04
                 
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rcg03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rcg03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcg03
                  NEXT FIELD rcg03
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
   
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT rcf01 FROM rcf_file ",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY rcf01"
   ELSE
      LET g_sql = "SELECT UNIQUE rcf01 ",
                  "  FROM rcf_file, rcg_file ",
                  " WHERE rcf01 = rcg01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rcf01"
   END IF
 
   PREPARE t804_prepare FROM g_sql
   DECLARE t804_cs
       SCROLL CURSOR WITH HOLD FOR t804_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rcf_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM rcf_file,rcg_file WHERE ",
                "rcg01=rcf01  AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t804_precount FROM g_sql
   DECLARE t804_count CURSOR FOR t804_precount
 
END FUNCTION
 
FUNCTION t804_menu()

   WHILE TRUE
      CALL t804_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t804_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t804_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t804_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t804_u()
            END IF
 

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN 
                  CALL t804_copy()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t804_x()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN 
                  CALL t804_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 

 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE

         WHEN "confirm"
            IF cl_chk_act_auth() THEN 
                  CALL t804_y()
            END IF
   
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN 
                  CALL t804_z()
            END IF

         WHEN "void"                  #作廢功能
            IF cl_chk_act_auth() THEN 
               CALL t804_void(1)
            END IF
      
         #FUN-D20039 ----------sta
         WHEN "undo_void"              #取消作廢功能
            IF cl_chk_act_auth() THEN
               CALL t804_void(2)
            END IF
         #FUN-D20039 ----------end 

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rcg),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rcf.rcf01 IS NOT NULL THEN
                 LET g_doc.column1 = "rcf01"
                 LET g_doc.value1 = g_rcf.rcf01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t804_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rcg TO s_rcg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY 

      ON ACTION  invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY 
         
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t804_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t804_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t804_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t804_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t804_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      #TQC-C20257--start add----------------- 
      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DISPLAY
      #TQC-C20257--end add-------------------
 
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
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
      

      ON ACTION void               #作廢功能 
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20039 ----------sta
      ON ACTION undo_void               #作廢功能    
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ----------end
          
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
 

FUNCTION  t804_y()

   IF cl_null(g_rcf.rcf01) THEN
      CALL cl_err('',-400,0)
   END IF
#CHI-C30107 ------------ add ------------- begin
   IF g_rcf.rcfconf = 'Y' THEN
      CALL cl_err(g_rcf.rcf01,'alm-005',0)
      RETURN
   END IF
   IF g_rcf.rcfconf = 'X' THEN
      CALL cl_err(g_rcf.rcf01,'alm-134',0)
      RETURN
   END IF
   IF g_rcf.rcfacti = 'N' THEN
      CALL cl_err(g_rcf.rcf01,'art-834',0)
      RETURN
   END IF
   IF NOT cl_confirm("alm-006") THEN
      RETURN
   END IF
   SELECT * INTO g_rcf.* FROM rcf_file
    WHERE rcf01 = g_rcf.rcf01
#CHI-C30107 ------------ add ------------- end
   IF g_rcf.rcfconf = 'Y' THEN
      CALL cl_err(g_rcf.rcf01,'alm-005',0)
      RETURN
   END IF
   IF g_rcf.rcfconf = 'X' THEN
      CALL cl_err(g_rcf.rcf01,'alm-134',0)
      RETURN
   END IF 
   IF g_rcf.rcfacti = 'N' THEN
      CALL cl_err(g_rcf.rcf01,'art-834',0)
      RETURN
   END IF 
   SELECT * INTO g_rcf.* FROM rcf_file
    WHERE rcf01 = g_rcf.rcf01
    
   LET g_success = 'Y'

   BEGIN WORK
   OPEN t804_cl USING g_rcf.rcf01
   IF STATUS THEN
      CALL cl_err("open t804_cl:",STATUS,1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t804_cl INTO g_rcf.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF

#CHI-C30107 ------------ mark ------------ begin
#  IF NOT cl_confirm("alm-006") THEN
#     RETURN
#  ELSE
#CHI-C30107 ------------ mark ------------ end
      LET g_rcf.rcfconf = 'Y'
      LET g_rcf.rcfconu = g_user
      LET g_rcf.rcfcond = g_today
     #LET g_rcf.rcfcont = g_time        #CHI-D20015
      LET g_rcf.rcfcont = TIME          #CHI-D20015
      UPDATE rcf_file 
         SET rcfconf = g_rcf.rcfconf,
             rcfconu = g_rcf.rcfconu,
             rcfcond = g_rcf.rcfcond,
             rcfcont = g_rcf.rcfcont
       WHERE rcf01 =  g_rcf.rcf01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd rcf:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
       END IF
#  END IF  #CHI-C30107 mark
   CLOSE t804_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      LET g_rcf.rcfconf = "N"
      LET g_rcf.rcfconu = ''
      LET g_rcf.rcfcond = ''
      LET g_rcf.rcfcont = ''
   END IF
   SELECT * INTO g_rcf.* FROM rcf_file where rcf01 = g_rcf.rcf01       #CHI-D20015
   CALL t804_show()
 
END FUNCTION

FUNCTION t804_z()

   IF (g_rcf.rcf01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_rcf.rcfacti='N' THEN
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF

   IF g_rcf.rcfconf!='Y' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF

   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   BEGIN WORK

   OPEN t804_cl USING g_rcf.rcf01
   IF STATUS THEN
       CALL cl_err("OPEN t804_cl:", STATUS, 1)
       CLOSE t804_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t804_cl INTO g_rcf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF
   CALL t804_show()
   LET g_rcf.rcfcont = TIME     #CHI-D20015
   UPDATE rcf_file
      SET rcfconf='N',
         #CHI-D20015---mod--str
         #rcfconu='',
         #rcfcond='',
         #rcfcont=''
          rcfconu=g_user,
          rcfcond=g_today,
          rcfcont=g_rcf.rcfcont
         #CHI-D20015---mod--end
    WHERE rcf01 = g_rcf.rcf01 
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","rcf_file",g_rcf.rcf01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF
   CLOSE t804_cl
   COMMIT WORK
   SELECT * INTO g_rcf.* FROM rcf_file where rcf01 = g_rcf.rcf01 
   CALL t804_show()

END FUNCTION

FUNCTION t804_x()
  
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rcf.rcf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_rcf.* FROM rcf_file
    WHERE rcf01=g_rcf.rcf01

   IF g_rcf.rcfconf='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF

   IF g_rcf.rcfconf='Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF


    BEGIN WORK

   OPEN t804_cl USING g_rcf.rcf01
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t804_cl INTO g_rcf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL t804_show()
   IF cl_exp(0,0,g_rcf.rcfacti) THEN
      LET g_chr=g_rcf.rcfacti
      IF g_rcf.rcfacti='Y' THEN
         LET g_rcf.rcfacti='N'
      ELSE
         LET g_rcf.rcfacti='Y'
      END IF

      UPDATE rcf_file SET rcfacti=g_rcf.rcfacti,
                          rcfmodu=g_user,
                          rcfdate=g_today
       WHERE rcf01=g_rcf.rcf01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lua_file",g_rcf.rcf01,"",SQLCA.sqlcode,"","",1)
         LET g_rcf.rcfacti=g_chr
      END IF
   END IF
   CLOSE t804_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_rcf.rcf01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT rcfacti,rcfmodu,rcfdate
     INTO g_rcf.rcfacti,g_rcf.rcfmodu,g_rcf.rcfdate FROM rcf_file
    WHERE rcf01 = g_rcf.rcf01
   DISPLAY BY NAME g_rcf.rcfacti,g_rcf.rcfmodu,g_rcf.rcfdate

END FUNCTION
 
FUNCTION t804_void(p_type)      
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_n        LIKE type_file.num5
DEFINE l_flag     LIKE type_file.num5    
DEFINE l_void     LIKE type_file.chr1  #y=要作廢，n=取消作廢

 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_rcf.* FROM rcf_file 
      WHERE rcf01=g_rcf.rcf01 
    
   IF g_rcf.rcf01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_rcf.rcfconf='X' THEN RETURN END IF
    ELSE
       IF g_rcf.rcfconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_rcf.rcfconf = 'Y' THEN 
      CALL cl_err('',9023,0) 
      RETURN 
   END IF

   BEGIN WORK
 
   OPEN t804_cl USING g_rcf.rcf01
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rcf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
      CLOSE t804_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_rcf.rcfconf = 'X' THEN
      LET l_void='Y'
   ELSE
      LET l_void='N'
   END IF

   IF cl_void(0,0,l_void) THEN
      LET g_chr = g_rcf.rcfconf
      IF g_rcf.rcfconf = 'N' THEN
         LET g_rcf.rcfconf = 'X'
      ELSE
         LET g_rcf.rcfconf = 'N'
      END IF
      UPDATE rcf_file SET rcfconf=g_rcf.rcfconf,
                          rcfmodu=g_user,
                          rcfdate=g_today
       WHERE rcf01 = g_rcf.rcf01 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","rcf_file",g_rcf.rcf01,"",SQLCA.sqlcode,"","up rcfconf",1)
          LET g_rcf.rcfconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t804_cl
   COMMIT WORK
 
   SELECT * INTO g_rcf.* FROM rcf_file WHERE rcf01=g_rcf.rcf01 
   DISPLAY BY NAME g_rcf.rcfconf                                                                                        
   DISPLAY BY NAME g_rcf.rcfmodu                                                                                        
   DISPLAY BY NAME g_rcf.rcfdate
END FUNCTION




FUNCTION t804_bp_refresh()
  DISPLAY ARRAY g_rcg TO s_rcg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t804_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_azw08     LIKE azw_file.azw08   

   MESSAGE ""
   CLEAR FORM
   CALL g_rcg.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rcf.* LIKE rcf_file.*
   LET g_rcf01_t = NULL
  
   LET g_rcf_t.* = g_rcf.*
   LET g_rcf_o.* = g_rcf.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rcf.rcf02 = g_today
      LET g_rcf.rcfuser=g_user
      LET g_rcf.rcforiu = g_user
      LET g_rcf.rcforig = g_grup 
      LET g_data_plant  = g_plant 
      LET g_rcf.rcfgrup = g_grup
      LET g_rcf.rcfacti = 'Y'
      LET g_rcf.rcfcrat = g_today
      LET g_rcf.rcfconf = 'N'
      LET g_rcf.rcfplant = g_plant
      LET g_rcf.rcflegal = g_legal

      SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_rcf.rcfplant
      DISPLAY l_azw08 TO rcfplant_desc

      CALL t804_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rcf.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rcf.rcf01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK                                                        
      #CALL s_auto_assign_no("art",g_rcf.rcf01,g_today,"G2","rcf_file",  #TQC-C20256 mark
      CALL s_auto_assign_no("art",g_rcf.rcf01,g_rcf.rcf02,"G2","rcf_file",   #TQC-C20256 add                                                         
                                   "rcf01","","","")                                                                             
                RETURNING li_result,g_rcf.rcf01
      IF (NOT li_result) THEN                                                                                                      
         CONTINUE WHILE                                                                                                           
      END IF                                                                                                                       
      DISPLAY BY NAME g_rcf.rcf01
      INSERT INTO rcf_file VALUES (g_rcf.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rcf_file",g_rcf.rcf01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK            # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rcf.rcf01,'I')
      END IF
 
      LET g_rcf01_t = g_rcf.rcf01
      LET g_rcf_t.* = g_rcf.*
      LET g_rcf_o.* = g_rcf.*
      LET g_rec_b = 0
      CALL t804_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t804_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rcf.rcf01 IS NULL  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rcf.* FROM rcf_file
    WHERE rcf01=g_rcf.rcf01

    IF g_rcf.rcfconf ='X' THEN
       CALL cl_err(g_rcf.rcf01,'art-025',0)
       RETURN
    END IF
   
   IF g_rcf.rcfconf = 'Y'  THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rcf01_t = g_rcf.rcf01
 
   BEGIN WORK
 
   OPEN t804_cl USING g_rcf.rcf01
 
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      ROLLBACK WORK
      CLOSE t804_cl
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rcf.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       CLOSE t804_cl
       RETURN
   END IF
 
   CALL t804_show()
 
   WHILE TRUE
      LET g_rcf01_t = g_rcf.rcf01
      LET g_rcf_o.* = g_rcf.*
      LET g_rcf.rcfmodu=g_user
      LET g_rcf.rcfdate=g_today
      CALL t804_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rcf.*=g_rcf_t.*
         CALL t804_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rcf.rcf01 != g_rcf01_t THEN
         UPDATE rcg_file SET rcg01 = g_rcf.rcf01
           WHERE rcg01 = g_rcf01_t 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rcg_file",g_rcf01_t,"",SQLCA.sqlcode,"","rcg",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF

      UPDATE rcf_file SET rcf_file.* = g_rcf.*
       WHERE rcf01 = g_rcf.rcf01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rcf_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t804_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rcf.rcf01,'U')
 
   CALL t804_b_fill("1=1")
   CALL t804_bp_refresh()
 
END FUNCTION
 
FUNCTION t804_i(p_cmd)
DEFINE
   l_n         LIKE type_file.num5,
   p_cmd       LIKE type_file.chr1,
   li_result   LIKE type_file.num5,
   l_azw08     LIKE azw_file.azw08,   #MOD-B70038 add ,
   l_cnt       LIKE type_file.num5    #MOD-B70038 add 

 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rcf.rcf01,g_rcf.rcfplant,g_rcf.rcf02,g_rcf.rcf03, 
                   g_rcf.rcfconf,g_rcf.rcfcond,g_rcf.rcfcont,g_rcf.rcfconu,
                   g_rcf.rcfuser,g_rcf.rcfgrup,g_rcf.rcforiu,g_rcf.rcfcrat,
                   g_rcf.rcfmodu,g_rcf.rcforig,g_rcf.rcfacti,g_rcf.rcfdate      


   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_rcf.rcfplant
   DISPLAY l_azw08 TO rcfplant_desc 

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_rcf.rcf01,g_rcf.rcf02,g_rcf.rcf03
                  
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t804_set_entry(p_cmd)
         CALL t804_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rcf01")
 
      AFTER FIELD rcf01
         IF NOT cl_null(g_rcf.rcf01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_rcf.rcf01 != g_rcf_t.rcf01) THEN
                                        
               CALL s_check_no("art",g_rcf.rcf01,g_rcf01_t,"G2","rcf_file","rcf01","")                                             
                    RETURNING li_result,g_rcf.rcf01                                                                                 
               IF (NOT li_result) THEN                                                                                              
                   LET g_rcf.rcf01=g_rcf01_t                                                                                        
                   NEXT FIELD rcf01                                                                                                 
               END IF
            END IF
         END IF

#MOD-B70038 -- begin --
      AFTER FIELD rcf02
         IF NOT cl_null(g_rcf.rcf02) THEN
            CALL t804_rcf02_check(p_cmd) RETURNING l_cnt
            IF l_cnt > 0 THEN
               CALL cl_err(g_rcf.rcf02,'art-840',0)
               NEXT FIELD rcf02
            END IF
         END IF

      AFTER INPUT
         LET g_rcf.rcfuser = s_get_data_owner("rcf_file") #FUN-C10039
         LET g_rcf.rcfgrup = s_get_data_group("rcf_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         CALL t804_rcf02_check(p_cmd) RETURNING l_cnt
         IF l_cnt > 0 THEN
            CALl cl_err(g_rcf.rcf02,'art-840',0)
            NEXT FIELD rcf02
         END IF
#MOD-B70038 -- end --
           
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rcf01)
               LET g_t1=s_get_doc_no(g_rcf.rcf01)
               CALL q_oay(FALSE,FALSE,g_t1,'G2','ART') RETURNING g_t1  
               LET g_rcf.rcf01 = g_t1
               DISPLAY BY NAME g_rcf.rcf01
               NEXT FIELD rcf01
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
 


FUNCTION t804_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rcg.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t804_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rcf.* TO NULL
      RETURN
   END IF
 
   OPEN t804_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rcf.* TO NULL
   ELSE
      OPEN t804_count
      FETCH t804_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t804_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t804_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t804_cs INTO g_rcf.rcf01
      WHEN 'P' FETCH PREVIOUS t804_cs INTO g_rcf.rcf01
      WHEN 'F' FETCH FIRST    t804_cs INTO g_rcf.rcf01
      WHEN 'L' FETCH LAST     t804_cs INTO g_rcf.rcf01
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
        FETCH ABSOLUTE g_jump t804_cs INTO g_rcf.rcf01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rcf.* TO NULL
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
 
   SELECT * INTO g_rcf.* FROM rcf_file WHERE rcf01 = g_rcf.rcf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rcf_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rcf.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rcf.rcfuser
   LET g_data_group = g_rcf.rcfgrup
   LET g_data_plant = g_rcf.rcfplant  

   CALL t804_show()
 
END FUNCTION
 
FUNCTION t804_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azw08  LIKE azw_file.azw08   
 
   LET g_rcf_t.* = g_rcf.*
   LET g_rcf_o.* = g_rcf.*
   DISPLAY BY NAME g_rcf.rcf01,g_rcf.rcfplant,g_rcf.rcf02,g_rcf.rcf03, 
                   g_rcf.rcfconf,g_rcf.rcfcond,g_rcf.rcfcont,g_rcf.rcfconu,
                   g_rcf.rcfuser,g_rcf.rcfgrup,g_rcf.rcforiu,g_rcf.rcfcrat,
                   g_rcf.rcfmodu,g_rcf.rcforig,g_rcf.rcfacti,g_rcf.rcfdate 

   LET l_azw08 = NULL                
   SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_rcf.rcfplant
   DISPLAY l_azw08 TO rcfplant_desc

   CALL t804_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
#FUN-B30025--mark--str--
#FUNCTION t804_x()
# 
#   IF s_shut(0) THEN
#      RETURN
#   END IF
# 
#   IF g_rcf.rcf01 IS NULL AND g_rcf.rcfplant IS NULL THEN
#      CALL cl_err("",-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_rcf.* FROM rcf_file
#    WHERE rcf01=g_rcf.rcf01 
#      AND rcfplant = g_rcf.rcfplant 
#    
#   IF g_rcf.rcfconf = '1' OR g_rcf.rcfconf = '2' THEN 
#      CALL cl_err('',9023,0) 
#      RETURN 
#   END IF
#   #IF g_rcf.rcfconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF  #FUN-AA0086
##add--FUN-AA0086--str--
#   IF g_rcf.rcfconf = '3' THEN   
#      CALL cl_err('','amr-100',0)
#      RETURN
#   END IF
##add--FUN-AA0086--end--
#   BEGIN WORK 
#   OPEN t804_cl USING g_rcf.rcf01
#   IF STATUS THEN
#      CALL cl_err("OPEN t804_cl:", STATUS, 1)
#      CLOSE t804_cl
#      RETURN
#   END IF
# 
#   FETCH t804_cl INTO g_rcf.*
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
#      RETURN
#   END IF
# 
#   LET g_success = 'Y'
# 
#   CALL t804_show()
#   
#   IF cl_exp(0,0,g_rcf.rcfacti) THEN
#      LET g_chr=g_rcf.rcfacti
#      IF g_rcf.rcfacti='Y' THEN
#         LET g_rcf.rcfacti='N'
#      ELSE
#         LET g_rcf.rcfacti='Y'
#      END IF
# 
#      UPDATE rcf_file SET rcfacti=g_rcf.rcfacti,
#                          rcfmodu=g_user,
#                          rcfdate=g_today
#       WHERE rcf01=g_rcf.rcf01
#         AND rcfplant = g_rcf.rcfplant 
#      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err3("upd","rcf_file",g_rcf.rcf01,"",SQLCA.sqlcode,"","",1) 
#         LET g_rcf.rcfacti=g_chr
#         LET g_success = 'N'
#      END IF
#   END IF
# 
#   CLOSE t804_cl
# 
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      CALL cl_flow_notify(g_rcf.rcf01,'V')
#   ELSE
#      ROLLBACK WORK
#   END IF
# 
#   SELECT rcfacti,rcfmodu,rcfdate
#     INTO g_rcf.rcfacti,g_rcf.rcfmodu,g_rcf.rcfdate FROM rcf_file
#    WHERE rcf01=g_rcf.rcf01 
#      AND rcfplant = g_rcf.rcfplant 
#   DISPLAY BY NAME g_rcf.rcfacti,g_rcf.rcfmodu,g_rcf.rcfdate
# 
#END FUNCTION
#FUN-B30025--mark--end--
 
FUNCTION t804_r()
   DEFINE l_flag   LIKE type_file.num5 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rcf.rcf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

 
   SELECT * INTO g_rcf.* FROM rcf_file
    WHERE rcf01=g_rcf.rcf01 
 
   IF g_rcf.rcfconf = 'Y'  THEN
      CALL cl_err('','art-023',0)
      RETURN
   END IF

   IF g_rcf.rcfconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
 
   BEGIN WORK
 
   OPEN t804_cl USING g_rcf.rcf01
   IF STATUS THEN
      CALL cl_err("OPEN t804_cl:", STATUS, 1)
      ROLLBACK WORK
      CLOSE t804_cl
      RETURN
   END IF
 
   FETCH t804_cl INTO g_rcf.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t804_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL         
       LET g_doc.column1 = "rcf01"         
       LET g_doc.value1 = g_rcf.rcf01      
       CALL cl_del_doc()                                          
      DELETE FROM rcf_file WHERE rcf01 = g_rcf.rcf01
      DELETE FROM rcg_file WHERE rcg01 = g_rcf.rcf01 
      CLEAR FORM
      CALL g_rcg.clear()
      OPEN t804_count
      FETCH t804_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t804_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t804_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t804_fetch('/')
      END IF
   END IF
 
   CLOSE t804_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rcf.rcf01,'D')
END FUNCTION
 

 
FUNCTION t804_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_flag          LIKE type_file.chr1
DEFINE l_flag1      LIKE type_file.num5 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rcf.rcf01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rcf.* FROM rcf_file
      WHERE rcf01=g_rcf.rcf01 

    IF g_rcf.rcfconf = 'Y' THEN
       CALL cl_err('','abm-879',0)
       RETURN
    END IF
                                    
    LET g_plant_new = g_rcf.rcfplant

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rcg02,rcg03,'',rcg04",
                       "  FROM rcg_file ",
                       " WHERE rcg01=? AND rcg02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t804_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_rcg WITHOUT DEFAULTS FROM s_rcg.*
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
 
           OPEN t804_cl USING g_rcf.rcf01
           IF STATUS THEN
              CALL cl_err("OPEN t804_cl:", STATUS, 1)
              CLOSE t804_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t804_cl INTO g_rcf.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rcf.rcf01,SQLCA.sqlcode,0)
              CLOSE t804_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rcg_t.* = g_rcg[l_ac].*  #BACKUP
              LET g_rcg_o.* = g_rcg[l_ac].*  #BACKUP
              OPEN t804_bcl USING g_rcf.rcf01,g_rcg_t.rcg02
              IF STATUS THEN
                 CALL cl_err("OPEN t804_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t804_bcl INTO g_rcg[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rcg_t.rcg02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT lse02 INTO g_rcg[l_ac].rcg03_desc FROM lse_file
                  WHERE lse01 = g_rcg[l_ac].rcg03 AND lse04 = 'Y'
              END IF
           END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rcg[l_ac].* TO NULL
           LET g_rcg[l_ac].rcg04 = 0
           LET g_rcg_t.* = g_rcg[l_ac].*
           LET g_rcg_o.* = g_rcg[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rcg02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rcg_file VALUES(g_rcf.rcf01,g_rcg[l_ac].rcg02,g_rcg[l_ac].rcg03,
                                      g_rcg[l_ac].rcg04,g_legal,g_plant)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rcg_file",g_rcf.rcf01,g_rcg[l_ac].rcg02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rcg02
           IF g_rcg[l_ac].rcg02 IS NULL OR g_rcg[l_ac].rcg02 = 0 THEN
              SELECT max(rcg02)+1
                INTO g_rcg[l_ac].rcg02
                FROM rcg_file
               WHERE rcg01 = g_rcf.rcf01 
              IF g_rcg[l_ac].rcg02 IS NULL OR g_rcg[l_ac].rcg02 = 0 THEN
                 LET g_rcg[l_ac].rcg02 = 1
              END IF
           END IF
 
        AFTER FIELD rcg02
           IF NOT cl_null(g_rcg[l_ac].rcg02) THEN
              IF g_rcg[l_ac].rcg02 != g_rcg_t.rcg02
                 OR g_rcg_t.rcg02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rcg_file
                  WHERE rcg01 = g_rcf.rcf01
                    AND rcg02 = g_rcg[l_ac].rcg02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rcg[l_ac].rcg02 = g_rcg_t.rcg02
                    NEXT FIELD rcg02
                 END IF
              END IF
           END IF
 
       AFTER FIELD rcg03
          IF NOT cl_null(g_rcg[l_ac].rcg03) THEN
             IF g_rcg_t.rcg03 IS NULL OR g_rcg[l_ac].rcg03 != g_rcg_t.rcg03 THEN
              SELECT COUNT(*) INTO l_cnt FROM rcf_file,rcg_file
               WHERE rcf01= rcg01
                 AND rcf01= g_rcf.rcf01
                 AND rcf02= g_rcf.rcf02
                 AND rcg03= g_rcg[l_ac].rcg03
               IF l_cnt > 0 THEN
                  CALL cl_err('','art-833',0)
                  LET g_rcg[l_ac].rcg03 = g_rcg_t.rcg03
                  NEXT FIELD rcg03
               END IF
              END IF
              CALL t804_rcg03()
              IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_rcg[l_ac].rcg03,g_errno,0)
                  LET g_rcg[l_ac].rcg03 = g_rcg_t.rcg03
                  NEXT FIELD rcg03
              END IF
           END IF 
        #FUN-B70033  Begin 
        #AFTER FIELD rcg04
        #    IF NOT cl_null(g_rcg[l_ac].rcg04) THEN
        #        IF g_rcg[l_ac].rcg04 < 0 THEN
        #           CALL cl_err('','art-831',0)
        #           NEXT FIELD rcg04
        #        END IF
        #     END IF    
        #FUN-B70033 End
           
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rcg_t.rcg02 > 0 AND g_rcg_t.rcg02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rcg_file
               WHERE rcg01 = g_rcf.rcf01
                 AND rcg02 = g_rcg_t.rcg02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rcg_file",g_rcf.rcf01,g_rcg_t.rcg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rcg[l_ac].* = g_rcg_t.*
              CLOSE t804_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF  
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rcg[l_ac].rcg02,-263,1)
              LET g_rcg[l_ac].* = g_rcg_t.*
           ELSE
              UPDATE rcg_file SET rcg02=g_rcg[l_ac].rcg02,
                                  rcg03=g_rcg[l_ac].rcg03,
                                  rcg04=g_rcg[l_ac].rcg04
               WHERE rcg01=g_rcf.rcf01
                 AND rcg02=g_rcg_t.rcg02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rcg_file",g_rcf.rcf01,g_rcg_t.rcg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rcg[l_ac].* = g_rcg_t.*
              ELSE
                 LET g_rcf.rcfmodu = g_user                                                         
                 LET g_rcf.rcfdate = g_today 
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
                 LET g_rcg[l_ac].* = g_rcg_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rcg.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t804_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE t804_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(rcg02) AND l_ac > 1 THEN
              LET g_rcg[l_ac].* = g_rcg[l_ac-1].*
              LET g_rcg[l_ac].rcg02 = g_rec_b + 1
              NEXT FIELD rcg02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(rcg03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lse01"
              LET g_qryparam.default1 = g_rcg[l_ac].rcg03
              CALL cl_create_qry() RETURNING g_rcg[l_ac].rcg03
              DISPLAY BY NAME g_rcg[l_ac].rcg03
              CALL t804_rcg03()
              NEXT FIELD rcg03
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
 
    IF p_cmd = 'u' THEN
 
       UPDATE rcf_file SET rcfmodu = g_rcf.rcfmodu,
                           rcfdate = g_rcf.rcfdate
       WHERE rcf01 = g_rcf.rcf01 AND rcfplant = g_rcf.rcfplant
      
       DISPLAY BY NAME g_rcf.rcfmodu,g_rcf.rcfdate
    END IF 
    
    CLOSE t804_bcl
    COMMIT WORK
#   CALL t804_delall()  #CHI-C30002 mark
    CALL t804_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t804_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rcf.rcf01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rcf_file ",
                  "  WHERE rcf01 LIKE '",l_slip,"%' ",
                  "    AND rcf01 > '",g_rcf.rcf01,"'"
      PREPARE t804_pb1 FROM l_sql 
      EXECUTE t804_pb1 INTO l_cnt
      
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
         CALL t804_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rcf_file WHERE rcf01 = g_rcf.rcf01
         INITIALIZE g_rcf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t804_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rcg_file
#   WHERE rcg01 = g_rcf.rcf01
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rcf_file WHERE rcf01 = g_rcf.rcf01 
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t804_b_fill(p_wc2)
DEFINE p_wc2   STRING

   LET g_sql = "SELECT rcg02,rcg03,'',rcg04 ",
               "  FROM rcg_file",
               " WHERE rcg01 ='",g_rcf.rcf01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rcg02 "

   PREPARE t804_pb FROM g_sql
   DECLARE rcg_cs CURSOR FOR t804_pb
 
   CALL g_rcg.clear()
   LET g_cnt = 1
 
   FOREACH rcg_cs INTO g_rcg[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT lse02 INTO g_rcg[g_cnt].rcg03_desc FROM lse_file
           WHERE lse01 = g_rcg[g_cnt].rcg03 AND lse04 = 'Y'
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","lse_file",g_rcg[g_cnt].rcg03,"",SQLCA.sqlcode,"","",0)  
          LET g_rcg[g_cnt].rcg03_desc = NULL
       END IF

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rcg.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t804_copy()
   DEFINE l_newno       LIKE rcf_file.rcf01,
          l_oldno       LIKE rcf_file.rcf01,
          li_result     LIKE type_file.num5,
          l_n           LIKE type_file.num5,
          l_old_plant   LIKE rcf_file.rcfplant
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_rcf.rcf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t804_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM rcf01
 
       AFTER FIELD rcf01
          IF l_newno IS NULL THEN
             NEXT FIELD rcf01
          ELSE
             CALL s_check_no("art",l_newno,"","G2","rcf_file","rcf01","") 
                RETURNING li_result,l_newno
             IF (NOT li_result) THEN 
                LET g_rcf.rcf01=g_rcf_t.rcf01
                NEXT FIELD rcf01
             END IF 
             BEGIN WORK
             #CALL s_auto_assign_no("art",l_newno,g_today,"G2","rcf_file", #TQC-C20256 mark
             CALL s_auto_assign_no("art",l_newno,g_rcf.rcf02,"G2","rcf_file",   #TQC-C20256 add
                                   "rcf01","","","")                    
                RETURNING li_result,l_newno 
             IF (NOT li_result) THEN
                ROLLBACK WORK
                NEXT FIELD rcf01 
             ELSE
                COMMIT WORK
             END IF
                                                                                                                                    
             DISPLAY l_newno TO rcf01
          END IF          	  

      ON ACTION controlp
         CASE
            WHEN INFIELD(rcf01)
               LET g_t1=s_get_doc_no(g_rcf.rcf01)
               CALL q_oay(FALSE,FALSE,g_t1,'G2','ART') RETURNING g_t1  
               LET l_newno = g_t1
               DISPLAY l_newno TO rcf01
               NEXT FIELD rcf01
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
      DISPLAY BY NAME g_rcf.rcf01 
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM rcf_file
       WHERE rcf01=g_rcf.rcf01
       INTO TEMP y
 
   UPDATE y
       SET rcf01=l_newno,
           rcf02 = g_rcf.rcf02,
           rcf03 = g_rcf.rcf03,
           rcfconf = 'N',
           rcfplant = g_plant,
           rcflegal =g_legal,
           rcfuser = g_user,
           rcfgrup = g_grup,
           rcforiu = g_user,   
           rcforig = g_grup,   
           rcfmodu = NULL,
           rcfdate = NULL,
           rcfacti = 'Y',
           rcfcrat = g_today,
           rcfcont = ''  
 
   INSERT INTO rcf_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rcf_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rcg_file
       WHERE rcg01=g_rcf.rcf01 
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rcg01=l_newno,rcgplant = g_plant,rcglegal=g_legal
 
   INSERT INTO rcg_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK          # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rcg_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK             # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_rcf.rcf01
   LET l_old_plant = g_rcf.rcfplant
   SELECT rcf_file.* INTO g_rcf.* FROM rcf_file WHERE rcf01 = l_newno AND rcfplant = g_plant
   CALL t804_u()
   CALL t804_b()
   #SELECT rcf_file.* INTO g_rcf.*          #FUN-C80046
   #   FROM rcf_file WHERE rcf01 = l_oldno  #FUN-C80046
   #CALL t804_show()    #FUN-C80046
 
END FUNCTION
 

FUNCTION t804_rcg03()
DEFINE l_lse04   LIKE lse_file.lse04

   LET g_errno = ""
   SELECT lse02,lse04 INTO g_rcg[l_ac].rcg03_desc,l_lse04 FROM lse_file
    WHERE lse01 = g_rcg[l_ac].rcg03
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-830'
                            RETURN
         WHEN l_lse04='N' LET g_errno = 'alm-004'
                            RETURN
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE  
END FUNCTION 
FUNCTION t804_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rcf01",TRUE)
    END IF
   
 
END FUNCTION
 
FUNCTION t804_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("rcf01",FALSE)
    END IF

END FUNCTION

#MOD-B70038 -- begin --
FUNCTION t804_rcf02_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_cnt LIKE type_file.num5
   IF p_cmd = 'a' THEN
      SELECT COUNT(*) INTO l_cnt FROM rcf_file
         WHERE rcfplant = g_rcf.rcfplant
           AND rcf02 = g_rcf.rcf02 
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM rcf_file
         WHERE rcf01 <> g_rcf.rcf01
           AND rcfplant = g_rcf.rcfplant
           AND rcf02 = g_rcf.rcf02
   END IF
   RETURN l_cnt
END FUNCTION
#MOD-B70038 -- end --
#FUN-B50009

