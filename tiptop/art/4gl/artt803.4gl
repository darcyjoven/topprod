# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt803.4gl
# Descriptions...: 百貨公司核算資料維護作業
# Date & Author..: NO.FUN-B50008 11/05/06 By baogc 
# Modify.........: NO.FUN-B50157 11/05/24 By huangtao 含稅否做管控，同一銷售年月不可重複
# Modify.........: No.TQC-B70038 11/07/06 By pauline 游標未進入銷售日期欄位直接確認單頭,可能造成同一門店同一日期資料重複
# Modify.........: No:TQC-B70078 11/07/11 by pauline 修改銷售金額選取條件  
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:FUN-B80116 11/08/15 by pauline 修改含未稅欄位default值
# Modify.........: No:FUN-B80127 11/08/18 by pauline 百貨核算金額開放允許輸入負數
# Modify.........: No:TQC-BB0123 11/11/15 by pauline 控卡platn code不是當前營運中心時，不允許執行任何動作

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20255 12/02/17 by fanbj 取單號時依據銷售日期取號
# Modify.........: No:TQC-C20440 12/02/24 By baogc 批次產生銷售核算資料時，核算否存在情況報錯相反
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:CHI-D20015 13/03/27 By minpp 將確認人，確認日期改為確認異動人員，確認異動日期，取消審核時，回寫確認異動人員及日期
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_rcd         RECORD LIKE rcd_file.*,
       g_rcd_t       RECORD LIKE rcd_file.*,
       g_rcd_o       RECORD LIKE rcd_file.*,
       g_rce         DYNAMIC ARRAY OF RECORD
           rce02       LIKE rce_file.rce02,
           rce03       LIKE rce_file.rce03,
           rce03_desc  LIKE tqa_file.tqa02,
           rce06       LIKE rce_file.rce06,
           rce04       LIKE rce_file.rce04,
           rce05       LIKE rce_file.rce05,
           amountdif   LIKE rce_file.rce06
                     END RECORD,
       g_rce_t       RECORD
           rce02       LIKE rce_file.rce02,
           rce03       LIKE rce_file.rce03,
           rce03_desc  LIKE tqa_file.tqa02,
           rce06       LIKE rce_file.rce06,
           rce04       LIKE rce_file.rce04,
           rce05       LIKE rce_file.rce05,
           amountdif   LIKE rce_file.rce06
                     END RECORD,
       g_rce_o       RECORD 
           rce02       LIKE rce_file.rce02,
           rce03       LIKE rce_file.rce03,
           rce03_desc  LIKE tqa_file.tqa02,
           rce06       LIKE rce_file.rce06,
           rce04       LIKE rce_file.rce04,
           rce05       LIKE rce_file.rce05,
           amountdif   LIKE rce_file.rce06
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING, 
       g_wc1         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE g_t1                LIKE oay_file.oayslip
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_flag              LIKE type_file.num5
DEFINE g_flag_b            LIKE type_file.chr1
DEFINE l_azw08             LIKE azw_file.azw08
DEFINE g_rcj               RECORD LIKE rcj_file.*
DEFINE g_cs_str            LIKE type_file.chr1
DEFINE g_start             LIKE type_file.dat
DEFINE g_end               LIKE type_file.dat

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

   LET g_forupd_sql = "SELECT * FROM rcd_file WHERE rcd01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t803_cl CURSOR FROM g_forupd_sql
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t803_w AT p_row,p_col WITH FORM "art/42f/artt803"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   SELECT * INTO g_rcj.* FROM rcj_file WHERE rcj00 = '0'
   LET g_cs_str = 'Y'
   CALL t803_menu()
   CLOSE WINDOW t803_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t803_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_rce.clear()
   
   IF g_cs_str = 'Y' THEN
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rcd.* TO NULL
      CONSTRUCT BY NAME g_wc ON rcd01,rcdplant,rcd02,rcd03,rcd04,rcdconf,
                                rcdcond,rcdcont,rcdconu,rcduser,rcdgrup,
                                rcdoriu,rcdmodu,rcddate,rcdorig,rcdacti,rcdcrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rcd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rcd01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcd01
                  NEXT FIELD rcd01

               WHEN INFIELD(rcdplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azw"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rcdplant
                  NEXT FIELD rcdplant
      
               WHEN INFIELD(rcdconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_gen"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO rcdconu                                                                              
                  NEXT FIELD rcdconu
                  
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
      
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rcduser', 'rcdgrup')
 
      CONSTRUCT g_wc1 ON rce02,rce03,rce06,rce04,rce05
              FROM s_rce[1].rce02,s_rce[1].rce03,s_rce[1].rce06,
                   s_rce[1].rce04,s_rce[1].rce05
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(rce03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rce03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rce03
                  NEXT FIELD rce03

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
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
       END CONSTRUCT
   
       IF INT_FLAG THEN
          RETURN
       END IF 
    END IF
    
    LET g_wc1 = g_wc1 CLIPPED
    LET g_wc  = g_wc  CLIPPED

    IF cl_null(g_wc) THEN
       LET g_wc =" 1=1"
    END IF
    IF cl_null(g_wc1) THEN
       LET g_wc1=" 1=1"
    END IF

    LET g_sql = "SELECT DISTINCT rcd01 ",
                "  FROM rcd_file LEFT OUTER JOIN rce_file ",
                "       ON (rcd01=rce01) ",
                " WHERE ", g_wc CLIPPED," AND ",g_wc1 CLIPPED
    IF g_cs_str = 'N' THEN
       LET g_sql = g_sql CLIPPED," AND (rcd02 BETWEEN '",g_start,"' AND '",g_end,"') AND rcdconf <> 'X'"
    END IF
    LET g_sql = g_sql CLIPPED," ORDER BY rcd01"
    PREPARE t803_prepare FROM g_sql
    DECLARE t803_cs
       SCROLL CURSOR WITH HOLD FOR t803_prepare
       
    LET g_sql = "SELECT COUNT(DISTINCT rcd01) ",
                "  FROM rcd_file LEFT OUTER JOIN rce_file ",
                "       ON (rcd01=rce01) ",
                " WHERE ", g_wc CLIPPED," AND ",g_wc1 CLIPPED
    IF g_cs_str = 'N' THEN
       LET g_sql = g_sql CLIPPED," AND (rcd02 BETWEEN '",g_start,"' AND '",g_end,"') AND rcdconf <> 'X'"
    END IF
    LET g_sql = g_sql CLIPPED," ORDER BY rcd01"

    PREPARE t803_precount FROM g_sql
    DECLARE t803_count CURSOR FOR t803_precount
 
END FUNCTION
 
FUNCTION t803_menu()
 
   WHILE TRUE
      CALL t803_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t803_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_cs_str = 'Y'
               CALL t803_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t803_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t803_u()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t803_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t803_yes()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t803_w()
            END IF

         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t803_void(1)
            END IF

         #FUN-D20039 ----------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t803_void(2)
            END IF
         #FUN-D20039 ----------end

         WHEN "p_pro_sale"
            IF cl_chk_act_auth() THEN
               CALL t803_p_pro_sale()
            END IF

         WHEN "re_sale_data"
            IF cl_chk_act_auth() THEN
               CALL t803_re_sale_data()
            END IF

         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rce),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rcd.rcd01 IS NOT NULL THEN
                 LET g_doc.column1 = "rcd01"
                 LET g_doc.value1 = g_rcd.rcd01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t803_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY g_rce TO s_rce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
            CALL t803_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DISPLAY
 
         ON ACTION previous
            CALL t803_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DISPLAY
 
         ON ACTION jump
            CALL t803_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DISPLAY
 
         ON ACTION next
            CALL t803_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DISPLAY
 
         ON ACTION last
            CALL t803_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            ACCEPT DISPLAY
 
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
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

         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            EXIT DISPLAY

         ON ACTION void
            LET g_action_choice="void"
            EXIT DISPLAY

         #FUN-D20039 ------------sta
          ON ACTION undo_void
            LET g_action_choice="undo_void"
            EXIT DISPLAY
         #FUN-D20039 ------------end

         ON ACTION p_pro_sale
            LET g_action_choice="p_pro_sale"
            EXIT DISPLAY

         ON ACTION re_sale_data
            LET g_action_choice="re_sale_data"
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

FUNCTION t803_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rce.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t803_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rcd.* TO NULL
      RETURN
   END IF
 
   OPEN t803_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rcd.* TO NULL
   ELSE
      OPEN t803_count
      FETCH t803_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t803_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t803_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t803_cs INTO g_rcd.rcd01
      WHEN 'P' FETCH PREVIOUS t803_cs INTO g_rcd.rcd01
      WHEN 'F' FETCH FIRST    t803_cs INTO g_rcd.rcd01
      WHEN 'L' FETCH LAST     t803_cs INTO g_rcd.rcd01
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
        FETCH ABSOLUTE g_jump t803_cs INTO g_rcd.rcd01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcd.rcd01,SQLCA.sqlcode,0)
      INITIALIZE g_rcd.* TO NULL
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
 
   SELECT * INTO g_rcd.* FROM rcd_file 
    WHERE rcd01 = g_rcd.rcd01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rcd_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rcd.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_rcd.rcduser
   LET g_data_group = g_rcd.rcdgrup
   LET g_data_plant = g_rcd.rcdplant   #TQC-BB0123 add
 
   CALL t803_show()
 
END FUNCTION
 
FUNCTION t803_show()
 
   LET l_ac = 1
   LET g_rcd_t.* = g_rcd.*
   LET g_rcd_o.* = g_rcd.*
   DISPLAY BY NAME g_rcd.rcd01,g_rcd.rcdplant,g_rcd.rcd02,
                   g_rcd.rcd03,g_rcd.rcd04,g_rcd.rcdconf,
                   g_rcd.rcdcond,g_rcd.rcdcont,g_rcd.rcdconu,
                   g_rcd.rcdoriu,g_rcd.rcdorig,g_rcd.rcduser,
                   g_rcd.rcdmodu,g_rcd.rcdacti,g_rcd.rcdgrup,
                   g_rcd.rcddate,g_rcd.rcdcrat

   SELECT azw08 INTO l_azw08 FROM azw_file
    WHERE azw01 = g_rcd.rcdplant AND azwacti = 'Y'
   DISPLAY l_azw08 TO FORMONLY.rcdplant_desc
   CALL t803_b_fill(g_wc1)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t803_b_fill(p_wc1)
DEFINE p_wc1   STRING
 
   LET g_sql = "SELECT rce02,rce03,'',rce06,rce04,rce05,'' ",
               "  FROM rce_file",
               " WHERE rce01 ='",g_rcd.rcd01,"' "
 
   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rce02 "
 
   DISPLAY g_sql
 
   PREPARE t803_pb FROM g_sql
   DECLARE rce_cs CURSOR FOR t803_pb
 
   CALL g_rce.clear()
   LET g_cnt = 1
 
   FOREACH rce_cs INTO g_rce[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT tqa02 INTO g_rce[g_cnt].rce03_desc FROM tqa_file
        WHERE tqa01 = g_rce[g_cnt].rce03
          AND tqa03 = '29'
          AND tqaacti = 'Y'
       CASE g_rcd.rcd04
          WHEN 'Y'
             LET g_rce[g_cnt].amountdif = g_rce[g_cnt].rce06 - g_rce[g_cnt].rce05
          WHEN 'N'
             LET g_rce[g_cnt].amountdif = g_rce[g_cnt].rce06 - g_rce[g_cnt].rce04
       END CASE
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rce.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION

FUNCTION t803_a()
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_gen02     LIKE gen_file.gen02
   DEFINE li_result   LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM
   CALL g_rce.clear()
   LET g_wc = NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rcd.* LIKE rcd_file.*
   LET g_rcd_t.* = g_rcd.*
   LET g_rcd_o.* = g_rcd.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rcd.rcdplant = g_plant
      LET g_rcd.rcdlegal = g_legal
      LET g_rcd.rcd02    = g_today
      LET g_rcd.rcd04    = 'N'
      LET g_rcd.rcdacti  = 'Y'
      LET g_rcd.rcdconf  = 'N'
      LET g_rcd.rcduser  = g_user
      LET g_rcd.rcdoriu  = g_user  
      LET g_rcd.rcdorig  = g_grup  
      LET g_rcd.rcdgrup  = g_grup
      LET g_rcd.rcdcrat  = g_today
      SELECT azw08 INTO l_azw08 FROM azw_file WHERE azw01 = g_rcd.rcdplant
      DISPLAY l_azw08 TO FORMONLY.rcdplant_desc

      CALL t803_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_rcd.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rcd.rcd01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      #CALL s_auto_assign_no("art",g_rcd.rcd01,g_today,"G1","rcd_file","rcd01","","","")   #TQC-C20255  mark
      CALL s_auto_assign_no("art",g_rcd.rcd01,g_rcd.rcd02,"G1","rcd_file","rcd01","","","") #TQC-C20255 add
         RETURNING li_result,g_rcd.rcd01
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF
      DISPLAY BY NAME g_rcd.rcd01

      INSERT INTO rcd_file VALUES (g_rcd.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK        # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rcd_file",g_rcd.rcd01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK         # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
 
      SELECT * INTO g_rcd.* FROM rcd_file
       WHERE rcd01 = g_rcd.rcd01
      LET g_rcd_t.* = g_rcd.*
      LET g_rcd_o.* = g_rcd.*
      CALL g_rce.clear()
      LET g_rec_b = 0
      CALL t803_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t803_i(p_cmd)
DEFINE
   p_cmd     LIKE type_file.chr1,
   l_docno   LIKE rcd_file.rcd01,
   l_n       LIKE type_file.num5,
   li_result   LIKE type_file.num5
DEFINE l_yy  LIKE type_file.num5
DEFINE l_mm  LIKE type_file.num5
DEFINE l_rcd02 LIKE rcd_file.rcd02
DEFINE l_rcd02_1 LIKE rcd_file.rcd02   #FUN-B80116 add

   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_rcd.rcd01,g_rcd.rcd02,g_rcd.rcd03,g_rcd.rcd04,g_rcd.rcdplant,
                   g_rcd.rcdconf,g_rcd.rcdcond,g_rcd.rcdcont,g_rcd.rcdconu,
                   g_rcd.rcduser,g_rcd.rcdmodu,g_rcd.rcdgrup,g_rcd.rcddate,
                   g_rcd.rcdacti,g_rcd.rcdcrat,g_rcd.rcdoriu,g_rcd.rcdorig
 
   CALL cl_set_head_visible("","YES") 
   
   INPUT BY NAME g_rcd.rcd01,g_rcd.rcdplant,g_rcd.rcd02,g_rcd.rcd03,g_rcd.rcd04
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t803_set_entry(p_cmd)
         CALL t803_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rcd01")
#FUN-B80116 add START
         LET l_yy = YEAR(g_rcd.rcd02)
         LET l_mm = MONTH(g_rcd.rcd02)
         LET l_rcd02 = MDY(l_mm,1,l_yy)
         LET l_rcd02_1 = MDY(l_mm+1,1,l_yy)-1
            SELECT COUNT(*) INTO l_n FROM rcd_file
                WHERE rcd02<= l_rcd02_1
                AND rcd02>= l_rcd02
                AND rcd04 = 'N'
            IF l_n>0 THEN
                LET g_rcd.rcd04 ='N'
            ELSE
                LET g_rcd.rcd04 ='Y'
            END IF
            DISPLAY BY NAME g_rcd.rcd04
#FUN-B80116 add END

      AFTER FIELD rcd01
         IF NOT cl_null(g_rcd.rcd01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rcd.rcd01 <> g_rcd_t.rcd01) THEN
               CALL s_check_no("art",g_rcd.rcd01,g_rcd_t.rcd01,"G1","rcd_file","rcd01","")
                    RETURNING li_result,g_rcd.rcd01
               IF (NOT li_result) THEN                                                            
                  LET g_rcd.rcd01=g_rcd_t.rcd01                                                                 
                  NEXT FIELD rcd01                                                                                     
               END IF
               LET l_docno = g_rcd_t.rcd01
               LET l_docno = l_docno[1,3]
            END IF
         END IF
         
      AFTER FIELD rcd02
         IF NOT cl_null(g_rcd.rcd02) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rcd.rcd02 <> g_rcd_t.rcd02) THEN
               SELECT COUNT(*) INTO l_n FROM rcd_file 
                WHERE rcd02 = g_rcd.rcd02 AND rcdplant = g_rcd.rcdplant
                  AND rcdconf <> 'X'
               IF l_n > 0 THEN
                 # CALL cl_err('',-239,0) #TQC-B70038
                  CALL cl_err('','art-719',0)  #TQC-B70038
                  NEXT FIELD rcd02
               END IF
               IF g_rcd.rcd02 <= g_rcj.rcj01 THEN
                  CALL cl_err('','art-718',0)
                  NEXT FIELD rcd02
               END IF
            END IF
         END IF
#FUN-B80116 add START
            LET l_yy = YEAR(g_rcd.rcd02)
            LET l_mm = MONTH(g_rcd.rcd02)
            LET l_rcd02 = MDY(l_mm,1,l_yy)
            LET l_rcd02_1 = MDY(l_mm+1,1,l_yy)-1
            SELECT COUNT(*) INTO l_n FROM rcd_file
                WHERE rcd02<= l_rcd02_1
                AND rcd02>= l_rcd02
                AND rcd04 = 'N'
            IF l_n>0 THEN
                LET g_rcd.rcd04 ='N'
            ELSE
                LET g_rcd.rcd04 ='Y'
            END IF
            DISPLAY BY NAME g_rcd.rcd04
#FUN-B80116 add END
         
#FUN-B50157 -------------------STA
      AFTER INPUT
         LET g_rcd.rcduser = s_get_data_owner("rcd_file") #FUN-C10039
         LET g_rcd.rcdgrup = s_get_data_group("rcd_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF 
         LET l_yy = YEAR(g_rcd.rcd02)
         LET l_mm = MONTH(g_rcd.rcd02)
         LET l_rcd02 = MDY(l_mm,1,l_yy)
         IF p_cmd = 'u' THEN
            SELECT COUNT(*) INTO l_n FROM rcd_file
             WHERE rcd02<= LAST_DAY(g_rcd.rcd02)
               AND rcd02>= l_rcd02
               AND rcd04 = g_rcd_t.rcd04
            IF l_n = 1 THEN
               EXIT INPUT
            END IF 
         END IF
         SELECT COUNT(*) INTO l_n FROM rcd_file
          WHERE rcd02<= LAST_DAY(g_rcd.rcd02)
            AND rcd02>= l_rcd02
            AND rcd04 = 'Y'
          IF l_n>0 THEN
             IF g_rcd.rcd04 = 'N' THEN
                CALL cl_err('','art-861',0)
                NEXT FIELD rcd04
             END IF
      
          END IF   
         SELECT COUNT(*) INTO l_n FROM rcd_file
          WHERE rcd02<= LAST_DAY(g_rcd.rcd02)
            AND rcd02>= l_rcd02
            AND rcd04 = 'N'
         IF l_n>0 THEN
             IF g_rcd.rcd04 = 'Y' THEN
                CALL cl_err('','art-862',0)
                NEXT FIELD rcd04
             END IF
         END IF
         #TQC-B70038  BEGIN
         SELECT COUNT(*) INTO l_n FROM rcd_file
          WHERE rcd02 = g_rcd.rcd02 AND rcdplant = g_rcd.rcdplant
            AND rcdconf <> 'X'
         IF l_n > 0 THEN
            CALL cl_err('','art-719',0)
            NEXT FIELD rcd02
         END IF
         #TQC-B70038  END
#FUN-B50157 -------------------END
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(rcd01)                                                                                                      
              LET g_t1=s_get_doc_no(g_rcd.rcd01)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'G1','art') RETURNING g_t1
              LET g_rcd.rcd01 = g_t1                                                                                                
              DISPLAY BY NAME g_rcd.rcd01                                                                                          
              NEXT FIELD rcd01
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

FUNCTION t803_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rcd.rcd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   SELECT * INTO g_rcd.* FROM rcd_file 
    WHERE rcd01=g_rcd.rcd01
      
   IF g_rcd.rcdacti ='N' THEN
      CALL cl_err(g_rcd.rcd01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rcd.rcdconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_rcd.rcdconf = 'X' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN t803_cl USING g_rcd.rcd01
 
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t803_cl INTO g_rcd.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rcd.rcd01,SQLCA.sqlcode,0)
       CLOSE t803_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t803_show()
 
   WHILE TRUE
      LET g_rcd_o.* = g_rcd.*
      LET g_rcd.rcdmodu=g_user
      LET g_rcd.rcddate=g_today
 
      CALL t803_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rcd.*=g_rcd_t.*
         CALL t803_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE rcd_file SET rcd_file.* = g_rcd.*
       WHERE rcd01 = g_rcd.rcd01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rcd_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t803_cl
   COMMIT WORK
 
   CALL t803_b_fill("1=1")

END FUNCTION
 

FUNCTION t803_yes() 
DEFINE l_cnt      LIKE type_file.num5

   IF cl_null(g_rcd.rcd01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
#CHI-C30107 ---------------- add -------------- begin
   IF g_rcd.rcdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rcd.rcdconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_rcd.rcdacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF 
   IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 ---------------- add -------------- end
   SELECT * INTO g_rcd.* FROM rcd_file 
    WHERE rcd01=g_rcd.rcd01
   IF g_rcd.rcdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rcd.rcdconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_rcd.rcdacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF g_rcd.rcd02 <= g_rcj.rcj01 THEN
      CALL cl_err('','art-723',0)
      RETURN
   END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rce_file
    WHERE rce01 = g_rcd.rcd01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#  IF NOT cl_confirm('art-026') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   OPEN t803_cl USING g_rcd.rcd01
   
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t803_cl INTO g_rcd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcd.rcd01,SQLCA.sqlcode,0)
      CLOSE t803_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET g_time =TIME
 
   UPDATE rcd_file SET rcdconf='Y',
                       rcdcond=g_today, 
                       rcdcont=g_time, 
                       rcdconu=g_user
     WHERE rcd01=g_rcd.rcd01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_rcd.rcdconf='Y'
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rcd.* FROM rcd_file 
    WHERE rcd01 = g_rcd.rcd01
   DISPLAY BY NAME g_rcd.rcdconf                                                                                         
   DISPLAY BY NAME g_rcd.rcdcond                                                                                         
   DISPLAY BY NAME g_rcd.rcdcont                                                                                         
   DISPLAY BY NAME g_rcd.rcdconu
END FUNCTION

FUNCTION t803_w()

   IF g_rcd.rcd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_rcd.* FROM rcd_file
    WHERE rcd01=g_rcd.rcd01
   IF g_rcd.rcdconf <> 'Y' THEN CALL cl_err('',9025,0) RETURN END IF
   IF g_rcd.rcd02 <= g_rcj.rcj01 THEN
      CALL cl_err('','art-723',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK

   IF NOT cl_confirm('axm-109') THEN ROLLBACK WORK RETURN END IF
   # FUN-B80085增加空白行

   LET g_time = TIME     #CHI-D20015
   UPDATE rcd_file SET rcdconf = 'N',
                      #CHI-D20015----mod---str
                      #rcdconu='',
                      #rcdcond='',
                      #rcdcont = ''
                       rcdconu=g_user,
                       rcdcond=g_today,
                       rcdcont=g_time
                      #CHI-D20015----mod--end
    WHERE rcd01 = g_rcd.rcd01

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rcd_file",g_rcd.rcd01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   ELSE
      MESSAGE 'UPDATE rcd_file OK'
   END IF

   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rcd.rcdconf='N'
     #CHI-D20015---mod---str
     #LET g_rcd.rcdconu=NULL
     #LET g_rcd.rcdcond=NULL
     #LET g_rcd.rcdcont=NULL
      LET g_rcd.rcdconu=g_user
      LET g_rcd.rcdcond=g_today
      LET g_rcd.rcdcont=g_time
     #CHI-D20015---mod----end
      DISPLAY BY NAME g_rcd.rcdconf
      DISPLAY BY NAME g_rcd.rcdcond
      DISPLAY BY NAME g_rcd.rcdcont
      DISPLAY BY NAME g_rcd.rcdconu
   ELSE
      LET g_rcd.rcdconu=g_rcd_t.rcdconu
      LET g_rcd.rcdcond=g_rcd_t.rcdcond
      LET g_rcd.rcdconf='Y'
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t803_void(p_type) 
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
DEFINE l_cnt      LIKE type_file.num5

   IF cl_null(g_rcd.rcd01) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
 
   SELECT * INTO g_rcd.* FROM rcd_file 
    WHERE rcd01=g_rcd.rcd01
   #FUN-D20039 ----------sta
   IF p_type = 1 THEN
      IF g_rcd.rcdconf='X' THEN RETURN END IF
   ELSE
      IF g_rcd.rcdconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20039 ----------end
   IF g_rcd.rcdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_rcd.rcdacti = 'N' THEN CALL cl_err('','art-145',0) RETURN END IF
   IF g_rcd.rcdconf = 'X' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM rcd_file
       WHERE rcd02 = g_rcd.rcd02 AND rcdplant = g_rcd.rcdplant
         AND rcdconf <> 'X'
      IF l_cnt > 0 THEN
         CALL cl_err('','art-725',0)
         RETURN
      END IF
   END IF
 
   BEGIN WORK
   
   OPEN t803_cl USING g_rcd.rcd01
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t803_cl INTO g_rcd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcd.rcd01,SQLCA.sqlcode,0)
      CLOSE t803_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   IF cl_void(0,0,g_rcd.rcdconf) THEN
      LET g_success = 'Y'
      LET g_time =TIME
      IF g_rcd.rcdconf = 'X' THEN
         LET g_rcd.rcdconf = 'N'
      ELSE
         IF g_rcd.rcdconf = 'N' THEN
            LET g_rcd.rcdconf = 'X'
         END IF
      END IF
 
      UPDATE rcd_file SET rcdconf=g_rcd.rcdconf,
                          rcddate=g_today,
                          rcdmodu=g_user
        WHERE rcd01=g_rcd.rcd01
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
      END IF
 
      IF g_success = 'Y' THEN
         LET g_rcd.rcdconf='X'
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   CLOSE t803_cl
   COMMIT WORK
   SELECT * INTO g_rcd.* FROM rcd_file 
    WHERE rcd01 = g_rcd.rcd01
   DISPLAY BY NAME g_rcd.rcdconf                                                                                         
   DISPLAY BY NAME g_rcd.rcddate
   DISPLAY BY NAME g_rcd.rcdmodu
END FUNCTION

FUNCTION t803_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rcd.rcd01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rcd.* FROM rcd_file
    WHERE rcd01=g_rcd.rcd01
 
   IF g_rcd.rcdconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_rcd.rcdacti = 'N' THEN
      CALL cl_err('','aic-201',0)
      RETURN
   END IF
  
   BEGIN WORK
 
   OPEN t803_cl USING g_rcd.rcd01
   IF STATUS THEN
      CALL cl_err("OPEN t803_cl:", STATUS, 1)
      CLOSE t803_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t803_cl INTO g_rcd.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rcd.rcd01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t803_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL      
       LET g_doc.column1 = "rcd01"      
       LET g_doc.value1 = g_rcd.rcd01    
       CALL cl_del_doc()              
      DELETE FROM rcd_file WHERE rcd01 = g_rcd.rcd01
      DELETE FROM rce_file WHERE rce01 = g_rcd.rcd01

      CLEAR FORM
      CALL g_rce.clear()

      OPEN t803_count
      FETCH t803_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t803_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t803_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t803_fetch('/')
      END IF
   END IF
 
   CLOSE t803_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t803_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_rce           RECORD LIKE rce_file.*,
    l_ogb14         LIKE ogb_file.ogb14,
    l_ogb14t        LIKE ogb_file.ogb14t,
    l_ohb14         LIKE ohb_file.ohb14,
    l_ohb14t        LIKE ohb_file.ohb14t

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_rcd.rcd01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_rcd.* FROM rcd_file
     WHERE rcd01=g_rcd.rcd01
 
    IF g_rcd.rcdacti ='N' THEN
       CALL cl_err(g_rcd.rcd01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_rcd.rcdconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_rcd.rcdconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF

    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM rce_file WHERE rce01 = g_rcd.rcd01
    IF l_n = 0 THEN
       IF cl_confirm('art-720') THEN
          LET l_rce.rce01 = g_rcd.rcd01
          LET l_rce.rce02 = 1
          LET l_rce.rceplant = g_plant
          LET l_rce.rcelegal = g_legal
          LET g_sql = "SELECT ogb40,COALESCE(SUM(ogb14),0),COALESCE(SUM(ogb14t),0) FROM ogb_file,oga_file",
                      " WHERE oga01 = ogb01 ",
                      #"   AND oga00 = '1' AND oga02 = '",g_rcd.rcd02,"'",    #TQC-B70078
                      "   AND oga09 IN ('2','3','4','6') AND oga02 = '",g_rcd.rcd02,"'",
                      "   AND ogapost = 'Y'",    #TQC-B70078
                      "   AND ogb40 IS NOT NULL",
                      " GROUP BY ogb40",
                      " ORDER BY ogb40"
          PREPARE auto_ogb_pre FROM g_sql
          DECLARE auto_ogb_cs CURSOR  FOR auto_ogb_pre
          FOREACH auto_ogb_cs INTO l_rce.rce03,l_rce.rce04,l_rce.rce05
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             SELECT COALESCE(SUM(ohb14),0),COALESCE(SUM(ohb14t),0) INTO l_ohb14,l_ohb14t FROM ohb_file,oha_file
              WHERE oha01 = ohb01 AND oha02 = g_rcd.rcd02 AND ohb40 = l_rce.rce03
                    AND oha05 IN ('1','2')  AND ohapost = 'Y'      #TQC-B70078
             LET l_rce.rce04 = l_rce.rce04 - l_ohb14
             LET l_rce.rce05 = l_rce.rce05 - l_ohb14t
             IF g_rcd.rcd04 = 'N' THEN
                IF l_rce.rce04 < 0 THEN
                   LET l_rce.rce06 = 0
                ELSE
                   LET l_rce.rce06 = l_rce.rce04
                END IF
             ELSE
                IF l_rce.rce05 < 0 THEN
                   LET l_rce.rce06 = 0
                ELSE
                   LET l_rce.rce06 = l_rce.rce05
                END IF
             END IF
             INSERT INTO rce_file VALUES(l_rce.*)
             LET l_rce.rce02 = l_rce.rce02 + 1
          END FOREACH
          LET g_sql = "SELECT ohb40,COALESCE(SUM(ohb14),0),COALESCE(SUM(ohb14t),0) FROM ohb_file,oha_file",
                      " WHERE oha01 = ohb01 ",
                      " AND oha02 = '",g_rcd.rcd02,"'",
                      " AND ohb40 IS NOT NULL",
                      " AND ohb40 NOT IN (SELECT ogb40 FROM ogb_file,oga_file ",
                      "                    WHERE oga01 = ogb01 AND oga00 = '1' AND oga02 = '",g_rcd.rcd02,"'",
                      "                      AND ogb40 IS NOT NULL)",
                      " GROUP BY ohb40",
                      " ORDER BY ohb40"
          PREPARE auto_ohb_pre FROM g_sql
          DECLARE auto_ohb_cs CURSOR  FOR auto_ohb_pre
          FOREACH auto_ohb_cs INTO l_rce.rce03,l_rce.rce04,l_rce.rce05
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             LET l_rce.rce04 = 0 - l_rce.rce04
             LET l_rce.rce05 = 0 - l_rce.rce05
             IF g_rcd.rcd04 = 'N' THEN
                IF l_rce.rce04 < 0 THEN
                   LET l_rce.rce06 = 0
                ELSE
                   LET l_rce.rce06 = l_rce.rce04
                END IF
             ELSE
                IF l_rce.rce05 < 0 THEN
                   LET l_rce.rce06 = 0
                ELSE
                   LET l_rce.rce06 = l_rce.rce05
                END IF
             END IF
             INSERT INTO rce_file VALUES(l_rce.*)
             LET l_rce.rce02 = l_rce.rce02 + 1
          END FOREACH
       END IF
       CALL t803_b_fill("1=1")
    END IF
    
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rce02,rce03,'',rce06,rce04,rce05,''",
                       "  FROM rce_file ",
                       " WHERE rce01 = ? AND rce02 = ? ",
                       " FOR UPDATE   "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t803_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rce WITHOUT DEFAULTS FROM s_rce.*
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
           LET l_lock_sw = 'N'
           LET l_n  = ARR_COUNT()

           BEGIN WORK
 
           OPEN t803_cl USING g_rcd.rcd01
           IF STATUS THEN
              CALL cl_err("OPEN t803_cl:", STATUS, 1)
              CLOSE t803_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t803_cl INTO g_rcd.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rcd.rcd01,SQLCA.sqlcode,0)
              CLOSE t803_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rce_t.* = g_rce[l_ac].*
              LET g_rce_o.* = g_rce[l_ac].*
              OPEN t803_bcl USING g_rcd.rcd01,g_rce_t.rce02
              IF STATUS THEN
                 CALL cl_err("OPEN t803_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t803_bcl INTO g_rce[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rce_t.rce04,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT tqa02 INTO g_rce[l_ac].rce03_desc FROM tqa_file
                  WHERE tqa01 = g_rce[l_ac].rce03
                    AND tqa03 = '29'
                    AND tqaacti = 'Y'
                 CASE g_rcd.rcd04
                    WHEN 'Y'
                       LET g_rce[l_ac].amountdif = g_rce[l_ac].rce06 - g_rce[l_ac].rce05
                    WHEN 'N'
                       LET g_rce[l_ac].amountdif = g_rce[l_ac].rce06 - g_rce[l_ac].rce04
                 END CASE
              END IF
          END IF 

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rce[l_ac].* TO NULL
           LET g_rce_t.* = g_rce[l_ac].*
           LET g_rce_o.* = g_rce[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rce02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rce_file(rce01,rce02,rce03,rce04,rce05,rce06,
                                rceplant,rcelegal)   
           VALUES(g_rcd.rcd01,g_rce[l_ac].rce02,g_rce[l_ac].rce03,
                  g_rce[l_ac].rce04,g_rce[l_ac].rce05,g_rce[l_ac].rce06,
                  g_plant,g_legal)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rce_file",g_rcd.rcd01,g_rce[l_ac].rce02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              IF p_cmd='u' THEN
                 CALL t803_upd_log()
              END IF
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rce02
           IF g_rce[l_ac].rce02 IS NULL OR g_rce[l_ac].rce02 = 0 THEN
              SELECT MAX(rce02)+1
                INTO g_rce[l_ac].rce02
                FROM rce_file
               WHERE rce01 = g_rcd.rcd01
              IF g_rce[l_ac].rce02 IS NULL THEN
                 LET g_rce[l_ac].rce02 = 1
              END IF
           END IF
 
        AFTER FIELD rce02
           IF NOT cl_null(g_rce[l_ac].rce02) THEN
              IF g_rce[l_ac].rce02 != g_rce_t.rce02
                 OR g_rce_t.rce02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rce_file
                  WHERE rce01 = g_rcd.rcd01
                    AND rce02 = g_rce[l_ac].rce02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rce[l_ac].rce02 = g_rce_t.rce02
                    NEXT FIELD rce02
                 END IF
              END IF
           END IF
 
        AFTER FIELD rce03
           IF NOT cl_null(g_rce[l_ac].rce03) THEN
              IF g_rce_o.rce03 IS NULL OR
                 (g_rce[l_ac].rce03 != g_rce_o.rce03 ) THEN
                 SELECT COUNT(*) INTO l_n FROM rce_file 
                  WHERE rce01 = g_rcd.rcd01 AND rce03 = g_rce[l_ac].rce03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD rce03
                 END IF
                 SELECT COUNT(*) INTO l_n FROM rcb_file,rca_file
                  WHERE rcb01 = g_plant AND rcb02 <= g_rcd.rcd02
                    AND rcb03 >= g_rcd.rcd02
                    AND rcb01 = rca01 AND rcb02 = rca02 AND rcb03 = rca03
                    AND rcaconf = 'Y'
                    AND rcb05 = g_rce[l_ac].rce03
                 IF l_n = 0 THEN
                    CALL cl_err('','art-717',0)
                    NEXT FIELD rce03
                 END IF
                 SELECT tqa02 INTO g_rce[l_ac].rce03_desc
                   FROM tqa_file
                  WHERE tqa01 = g_rce[l_ac].rce03
                    AND tqa03 = '29' AND tqaacti = 'Y'
                 SELECT COALESCE(SUM(ogb14),0),COALESCE(SUM(ogb14t),0) INTO l_ogb14,l_ogb14t FROM ogb_file,oga_file
                  #WHERE ogb01 = oga01 AND oga00 = '1' AND oga02 = g_rcd.rcd02  #TQC-B70078
                  WHERE ogb01 = oga01 AND oga09 IN ('2','3','4','6') AND oga02 = g_rcd.rcd02
                    AND ogb40 = g_rce[l_ac].rce03
                    AND ogapost = 'Y'                 #TQC-B70078    
                 SELECT COALESCE(SUM(ohb14),0),COALESCE(SUM(ohb14t),0) INTO l_ohb14,l_ohb14t FROM ohb_file,oha_file
                  WHERE oha01 = ohb01 AND oha02 = g_rcd.rcd02
                    AND ohb40 = g_rce[l_ac].rce03
                    AND oha05 IN ('1','2')  AND ohapost = 'Y'      #TQC-B70078
                 LET g_rce[l_ac].rce04 = l_ogb14  - l_ohb14
                 LET g_rce[l_ac].rce05 = l_ogb14t - l_ohb14t
              END IF
           END IF

        AFTER FIELD rce06
           IF NOT cl_null(g_rce[l_ac].rce06) THEN
            #  IF g_rce[l_ac].rce06 < 0 THEN                 #FUN-B80127 mark
            #     CALL cl_err('','aec-020',0)                #FUN-B80127 mark
            #     NEXT FIELD rce06                           #FUN-B80127 mark
            #  END IF                                        #FUN-B80127 mark
              CASE g_rcd.rcd04
                 WHEN 'Y'
                    IF NOT cl_null(g_rce[l_ac].rce05) THEN
                       LET g_rce[l_ac].amountdif = g_rce[l_ac].rce06 - g_rce[l_ac].rce05
                    END IF
                 WHEN 'N'
                    IF NOT cl_null(g_rce[l_ac].rce04) THEN
                       LET g_rce[l_ac].amountdif = g_rce[l_ac].rce06 - g_rce[l_ac].rce04
                    END IF
              END CASE
           END IF
 
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rce_t.rce02 > 0 AND g_rce_t.rce02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rce_file
               WHERE rce01 = g_rcd.rcd01
                 AND rce02 = g_rce_t.rce02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rce_file",g_rcd.rcd01,g_rce_t.rce02,SQLCA.sqlcode,"","",1) 
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              CALL t803_upd_log() 
              LET g_rec_b=g_rec_b-1
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rce[l_ac].* = g_rce_t.*
              CLOSE t803_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF cl_null(g_rce[l_ac].rce02) THEN
              NEXT FIELD rce02
           END IF
              
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rce[l_ac].rce02,-263,1)
              LET g_rce[l_ac].* = g_rce_t.*
           ELSE
              UPDATE rce_file SET rce02  =g_rce[l_ac].rce02,
                                  rce03  =g_rce[l_ac].rce03,
                                  rce04  =g_rce[l_ac].rce04,
                                  rce05  =g_rce[l_ac].rce05,
                                  rce06  =g_rce[l_ac].rce06
               WHERE rce01 = g_rcd.rcd01
                 AND rce02 = g_rce_t.rce02 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rce_file",g_rcd.rcd01,g_rce_t.rce02,SQLCA.sqlcode,"","",1) 
                 LET g_rce[l_ac].* = g_rce_t.*
              ELSE
                 MESSAGE 'UPDATE rce_file O.K'
                 CALL t803_upd_log() 
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
                 LET g_rce[l_ac].* = g_rce_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_rce.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE t803_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE t803_bcl
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(rce02) AND l_ac > 1 THEN
              LET g_rce[l_ac].* = g_rce[l_ac-1].*
              LET g_rce[l_ac].rce02 = g_rec_b + 1
              NEXT FIELD rce02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
           CASE
              WHEN INFIELD(rce03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rce03"
                 LET g_qryparam.where = "   (rca02 <= '",g_rcd.rcd02,"' ",
                                        "AND rca03 >= '",g_rcd.rcd02,"') ",
                                        "AND rca01  = '",g_plant,"' "
                 LET g_qryparam.default1 = g_rce[l_ac].rce03
                 CALL cl_create_qry() RETURNING g_rce[l_ac].rce03
                 NEXT FIELD rce03
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
    
    CLOSE t803_bcl
    COMMIT WORK
#   CALL t803_delall() #CHI-C30002 mark
    CALL t803_delHeader()     #CHI-C30002 add
 
END FUNCTION

FUNCTION t803_upd_log()
   LET g_rcd.rcdmodu = g_user
   LET g_rcd.rcddate = g_today
   UPDATE rcd_file SET rcdmodu = g_rcd.rcdmodu,
                       rcddate = g_rcd.rcddate
    WHERE rcd01 = g_rcd.rcd01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","rcd_file",g_rcd.rcdmodu,g_rcd.rcddate,SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_rcd.rcdmodu,g_rcd.rcddate
   MESSAGE 'UPDATE rcd_file O.K.'
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t803_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rcd.rcd01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rcd_file ",
                  "  WHERE rcd01 LIKE '",l_slip,"%' ",
                  "    AND rcd01 > '",g_rcd.rcd01,"'"
      PREPARE t803_pb1 FROM l_sql 
      EXECUTE t803_pb1 INTO l_cnt
      
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
         CALL t803_void(1)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rcd_file WHERE rcd01 = g_rcd.rcd01
         INITIALIZE g_rcd.*  TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t803_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rce_file
#   WHERE rce01 = g_rcd.rcd01
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rcd_file 
#      WHERE rcd01 = g_rcd.rcd01
#     CALL g_rce.clear()
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t803_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rcd01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t803_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rcd01",FALSE)
   END IF
 
END FUNCTION

FUNCTION t803_p_pro_sale()
DEFINE  l_startdate  LIKE type_file.dat
DEFINE  l_enddate    LIKE type_file.dat
DEFINE  l_saleno     LIKE rcd_file.rcd01
DEFINE  l_saletax    LIKE rcd_file.rcd04
DEFINE  li_result    LIKE type_file.chr1
DEFINE  l_date       LIKE type_file.dat
DEFINE  l_rcd        RECORD LIKE rcd_file.*
DEFINE  l_rce        RECORD LIKE rce_file.*
DEFINE  l_n          LIKE type_file.num5
DEFINE  l_num        LIKE type_file.num5
DEFINE  l_ogb14      LIKE ogb_file.ogb14
DEFINE  l_ogb14t     LIKE ogb_file.ogb14t
DEFINE  l_ohb14      LIKE ohb_file.ohb14
DEFINE  l_ohb14t     LIKE ohb_file.ohb14t
DEFINE  l_success    LIKE type_file.chr1
DEFINE  l_str        LIKE type_file.chr1
#FUN-B50157 --------------STA
DEFINE  l_yy         LIKE type_file.num5
DEFINE  l_mm         LIKE type_file.num5
DEFINE  l_rcd02      LIKE rcd_file.rcd02
#FUN-B50157 --------------END
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW t803_p_w AT p_row,p_col WITH FORM "art/42f/artt803_p"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   INPUT l_startdate,l_enddate,l_saleno,l_saletax FROM startdate,enddate,saleno,saletax

   BEFORE INPUT
      LET l_saletax = 'N'
      DISPLAY l_saletax TO FORMONLY.saletax
      
      AFTER FIELD startdate
         IF NOT cl_null(l_startdate) THEN
            IF l_startdate <= g_rcj.rcj01 THEN
               CALL cl_err('','art-718',0)
               NEXT FIELD startdate
            END IF 
            IF NOT cl_null(l_enddate) THEN 
               IF l_startdate > l_enddate THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD startdate
               END IF 
            END IF 
         END IF 
      
      AFTER FIELD enddate
         IF NOT cl_null(l_enddate) THEN
            IF l_enddate <= g_rcj.rcj01 THEN
               CALL cl_err('','art-718',0)
               NEXT FIELD enddate
            END IF 
            IF NOT cl_null(l_startdate) THEN 
               IF l_startdate > l_enddate THEN
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD enddate
               END IF 
            END IF 
         END IF 
      
      AFTER FIELD saleno
         IF NOT cl_null(l_saleno) THEN
            CALL s_check_no("art",l_saleno,l_saleno,"G1","rcd_file","rcd01","")
              RETURNING li_result,l_saleno
            IF (NOT li_result) THEN
               LET l_saleno = NULL
               NEXT FIELD saleno
            END IF
         END IF
      
      ON ACTION controlp
         CASE
            WHEN INFIELD(saleno)                                                                                                      
              LET g_t1=s_get_doc_no(l_saleno)                                                                                    
              CALL q_oay(FALSE,FALSE,g_t1,'G1','art') RETURNING g_t1                                                  
              LET l_saleno = g_t1                                                                                                
              DISPLAY l_saleno TO saleno
              NEXT FIELD saleno
            OTHERWISE EXIT CASE
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

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION close
         LET INT_FLAG = 1
         EXIT INPUT
        
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t803_p_w
      RETURN
   END IF
  
   CLOSE WINDOW t803_p_w

   LET l_date = l_startdate
   BEGIN WORK
   CALL s_showmsg_init()
   LET l_success = 'Y'
   LET l_str = 'N'
   WHILE (l_date <= l_enddate)
      LET l_rcd.rcd01 = l_saleno
      LET l_num = 1
      #CALL s_auto_assign_no("art",l_rcd.rcd01,g_today,"G1","rcd_file","rcd01","","","")    #TQC-C20255 mark
      CALL s_auto_assign_no("art",l_rcd.rcd01,l_date,"G1","rcd_file","rcd01","","","")    #TQC-C20255 add
         RETURNING li_result,l_rcd.rcd01
      IF (NOT li_result) THEN LET l_date = l_date + 1  CONTINUE WHILE  END IF
      LET l_rcd.rcd02 = l_date
      LET l_rcd.rcd04 = l_saletax
      LET l_rcd.rcdacti = 'Y'
      LET l_rcd.rcdconf = 'N'
      LET l_rcd.rcdcond = ''
      LET l_rcd.rcdcont = ''
      LET l_rcd.rcdconu = ''
      LET l_rcd.rcdplant = g_plant
      LET l_rcd.rcdlegal = g_legal
      LET l_rcd.rcdorig = g_grup
      LET l_rcd.rcdoriu = g_user
      LET l_rcd.rcduser = g_user
      LET l_rcd.rcdgrup = g_grup
      LET l_rcd.rcdcrat = g_today
      LET l_rcd.rcdmodu = ''
      LET l_rcd.rcddate = ''
#FUN-B50157 ----------------STA
      LET l_yy = YEAR(l_rcd.rcd02)
      LET l_mm = MONTH(l_rcd.rcd02)
      LET l_rcd02 = MDY(l_mm,1,l_yy)
         SELECT COUNT(*) INTO l_n FROM rcd_file
          WHERE rcd02<= LAST_DAY(l_rcd.rcd02)
            AND rcd02>= l_rcd02
            AND rcd04 = 'N'
          IF l_n>0 THEN
             IF l_rcd.rcd04 = 'Y' THEN
               #CALL s_errmsg('rcd02',l_date,'','art-861',1) #TQC-C20440 Mark
                CALL s_errmsg('rcd02',l_date,'','art-862',1) #TQC-C20440 Add
                LET l_date = l_date+1
                CONTINUE WHILE
             END IF
          END IF 
          SELECT COUNT(*) INTO l_n FROM rcd_file
          WHERE rcd02<= LAST_DAY(l_rcd.rcd02)
            AND rcd02>= l_rcd02
            AND rcd04 = 'Y'
          IF l_n>0 THEN
             IF l_rcd.rcd04 = 'N' THEN
               #CALL s_errmsg('rcd02',l_date,'','art-862',1) #TQC-C20440 Mark
                CALL s_errmsg('rcd02',l_date,'','art-861',1) #TQC-C20440 Add
                LET l_date = l_date+1
                CONTINUE WHILE
             END IF
          END IF  
#FUN-B50157 ----------------END
      SELECT COUNT(*) INTO l_n FROM rcd_file WHERE rcd02 = l_date AND rcdplant = g_plant
         AND rcdconf <> 'X'
      IF l_n > 0 THEN
         CALL s_errmsg('rcd02',l_date,'','art-719',1)
      ELSE
         INSERT INTO rcd_file VALUES(l_rcd.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('ins rcd','','',SQLCA.sqlcode,1)
            LET l_success = 'N'
            EXIT WHILE
         END IF
         LET g_sql = "SELECT ogb40,COALESCE(SUM(ogb14),0),COALESCE(SUM(ogb14t),0) ",
                     "  FROM ogb_file,oga_file ",
                     #" WHERE oga01 = ogb01 AND oga00 = '1' ",           #TQC-B70078
                     " WHERE oga01 = ogb01 AND oga09 IN ('2','3','4','6') ",
                     "   AND oga02 = '",l_date,"' ",
                     "   AND ogb40 IS NOT NULL",
                     "   AND ogapost = 'Y'",    #TQC-B70078
                     " GROUP BY ogb40",
                     " ORDER BY ogb40"
         PREPARE p_rcd_pre FROM g_sql
         DECLARE p_rcd_cs CURSOR FOR p_rcd_pre
         FOREACH p_rcd_cs INTO l_rce.rce03,l_rce.rce04,l_rce.rce05
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach',SQLCA.sqlcode,0)
               CONTINUE FOREACH
            END IF
            SELECT COALESCE(SUM(ohb14),0),COALESCE(SUM(ohb14t),0) INTO l_ohb14,l_ohb14t
              FROM ohb_file,oha_file
             WHERE oha01 = ohb01 AND oha02 = l_date
               AND ohb40 = l_rce.rce03
               AND oha05 IN ('1','2')  AND ohapost = 'Y'      #TQC-B70078
            LET l_rce.rce04 = l_rce.rce04 - l_ohb14
            LET l_rce.rce05 = l_rce.rce05 - l_ohb14t
            CASE l_saletax
               WHEN 'Y' 
                  IF l_rce.rce05 < 0 THEN
                     LET l_rce.rce06 = 0
                  ELSE
                     LET l_rce.rce06 = l_rce.rce05
                  END IF
               WHEN 'N' 
                  IF l_rce.rce04 < 0 THEN
                     LET l_rce.rce06 = 0
                  ELSE
                     LET l_rce.rce06 = l_rce.rce04
                  END IF
            END CASE
            LET l_rce.rce01 = l_rcd.rcd01
            LET l_rce.rce02 = l_num 
            LET l_rce.rceplant = g_plant
            LET l_rce.rcelegal = g_legal
            INSERT INTO rce_file VALUES(l_rce.*)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins rce','','',SQLCA.sqlcode,1)
               LET l_success = 'N'
               CONTINUE FOREACH
            END IF
            LET l_num = l_num + 1
         END FOREACH
         LET g_sql = "SELECT ohb40,COALESCE(SUM(ohb14),0),COALESCE(SUM(ohb14t),0) ",
                     "  FROM ohb_file,oha_file ",
                     " WHERE oha01 = ohb01 ",
                     "   AND oha02 = '",l_date,"' ",
                     "   AND ohb40 IS NOT NULL",
                     "   AND ohb40 NOT IN(SELECT ogb40 FROM ogb_file,oga_file ",
                     "                     WHERE oga01 = ogb01 AND oga00 = '1' ",
                     "                       AND oga02 = '",l_date,"' ",
                     "                       AND ogb40 IS NOT NULL)",
                     " GROUP BY ohb40",
                     " ORDER BY ohb40"
         PREPARE p_rcd_pre1 FROM g_sql
         DECLARE p_rcd_cs1 CURSOR FOR p_rcd_pre1
         FOREACH p_rcd_cs1 INTO l_rce.rce03,l_rce.rce04,l_rce.rce05
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach',SQLCA.sqlcode,0)
               CONTINUE FOREACH
            END IF
            LET l_rce.rce04 = 0 - l_rce.rce04
            LET l_rce.rce05 = 0 - l_rce.rce05
            CASE l_saletax
               WHEN 'Y' 
                  IF l_rce.rce05 < 0 THEN
                     LET l_rce.rce06 = 0
                  ELSE
                     LET l_rce.rce06 = l_rce.rce05
                  END IF
               WHEN 'N' 
                  IF l_rce.rce04 < 0 THEN
                     LET l_rce.rce06 = 0
                  ELSE
                     LET l_rce.rce06 = l_rce.rce04
                  END IF
            END CASE
                        LET l_rce.rce01 = l_rcd.rcd01
            LET l_rce.rce02 = l_num
            LET l_rce.rceplant = g_plant
            LET l_rce.rcelegal = g_legal
            INSERT INTO rce_file VALUES(l_rce.*)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins rce','','',SQLCA.sqlcode,1)
               LET l_success = 'N'
               CONTINUE FOREACH
            END IF
            LET l_num = l_num + 1
         END FOREACH
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM rce_file WHERE rce01 = l_rcd.rcd01
         IF l_n > 0 THEN
            LET l_str = 'Y'
         ELSE
            DELETE FROM rcd_file WHERE rcd01 = l_rcd.rcd01
         END IF
      END IF
      LET l_date = l_date + 1
   END WHILE
   IF l_str = 'N' THEN
      CALL s_errmsg('ins rce','','','apm1031',1)
   END IF
   IF l_success  = 'Y' AND l_str = 'Y' THEN
      CALL s_showmsg()
      CALL cl_err('','aps-525',0)
      COMMIT WORK
      LET g_cs_str = 'N'
      LET g_start = l_startdate
      LET g_end   = l_enddate
      CALL t803_q()
   ELSE
      CALL s_showmsg()
      CALL cl_err('','aps-528',0)
      ROLLBACK WORK
   END IF
   
END FUNCTION

FUNCTION t803_re_sale_data()
DEFINE l_rce03         LIKE rce_file.rce03
DEFINE l_sum_ogb14     LIKE ogb_file.ogb14
DEFINE l_sum_ogb14t    LIKE ogb_file.ogb14t
DEFINE l_sum_ohb14     LIKE ohb_file.ohb14
DEFINE l_sum_ohb14t    LIKE ohb_file.ohb14t
DEFINE l_success       LIKE type_file.chr1

   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rcd.rcd01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_rcd.rcdconf = 'X' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF

   IF g_rcd.rcdconf = 'Y' THEN
      CALL cl_err('','9022',0)
      RETURN
   END IF

   IF NOT cl_confirm('art-724') THEN 
      RETURN
   END IF 
   BEGIN WORK
   LET l_success = 'Y'

   LET g_sql = "SELECT rce03 FROM rce_file ",
               " WHERE rce01 = '",g_rcd.rcd01,"' "
   PREPARE sel_rce_pre FROM g_sql
   DECLARE sel_pre_cs CURSOR FOR sel_rce_pre
   FOREACH sel_pre_cs INTO l_rce03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT COALESCE(SUM(ogb14),0),COALESCE(SUM(ogb14t),0) INTO l_sum_ogb14,l_sum_ogb14t 
        FROM ogb_file,oga_file 
       WHERE oga01 = ogb01 
         #AND oga00 = '1' AND oga02 = g_rcd.rcd02   # TQC-B70078
         AND oga09 IN ('2','3','4','6') AND oga02 = g_rcd.rcd02
         AND ogb40 = l_rce03
         AND ogapost = 'Y'   # TQC-B70078
      SELECT COALESCE(SUM(ohb14),0),COALESCE(SUM(ohb14t),0) INTO l_sum_ohb14,l_sum_ohb14t
        FROM ohb_file,oha_file
       WHERE oha01 = ohb01
         AND oha02 = g_rcd.rcd02 
         AND ohb40 = l_rce03
         AND oha05 IN ('1','2')  AND ohapost = 'Y'      #TQC-B70078
      IF NOT cl_null(l_sum_ogb14) AND NOT cl_null(l_sum_ogb14t) THEN
         UPDATE rce_file SET rce04 = l_sum_ogb14  - l_sum_ohb14,
                             rce05 = l_sum_ogb14t - l_sum_ohb14t
          WHERE rce01 = g_rcd.rcd01
            AND rce03 = l_rce03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET l_success = 'N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH

   IF l_success = 'Y' THEN
      CALL cl_err('','aps-525',0)
      COMMIT WORK
   ELSE
      CALL cl_err('','aps-528',0)
      ROLLBACK WORK
   END IF

   CALL t803_b_fill("1=1")
END FUNCTION

#FUN-B50008

