# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt140.4gl
# Descriptions...: 營運中心業績分配作業
# Date & Author..: #FUN-B60145 11/06/29 By  yangxf
# Modify.........: No:FUN-B60145 11/07/01 By yangxf 添加已過帳條件
# Modify.........: No:TQC-B70059 11/07/07 By yangxf 調整單身金額異常問題
# Modify.........: No:TQC-B70078 11/07/11 by pauline 修改銷售金額選取條件  
# Modify.........: No:FUN-B70100 11/07/25 By baogc 修改取金額的邏輯
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No:FUN-B80107 11/08/15 by pauline 增加未分配金額欄位
# Modify.........: No:TQC-BB0125 11/11/24 by pauline 控卡platn code不是當前營運中心時，不允許執行任何動作

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/27 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員
# Modify.........: No:FUN-D30033 13/04/12 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_rwv             RECORD LIKE rwv_file.*,
       g_rwv_t           RECORD LIKE rwv_file.*,
       g_rwv_o           RECORD LIKE rwv_file.*,
       g_rwv01_t         LIKE rwv_file.rwv01,
       g_rwvplant_desc   LIKE azw_file.azw08,
       g_rww         DYNAMIC ARRAY OF RECORD
           rww02         LIKE rww_file.rww02,
           rww03         LIKE rww_file.rww03,
           rww03_desc    LIKE type_file.chr100,
           rww04         LIKE rww_file.rww04,
           distribution  LIKE type_file.num10
                     END RECORD,

       g_rww_t       RECORD
           rww02         LIKE rww_file.rww02,
           rww03         LIKE rww_file.rww03,
           rww03_desc    LIKE type_file.chr100,
           rww04         LIKE rww_file.rww04,
           distribution  LIKE type_file.num10
                        END RECORD,

       g_rww_o       RECORD
           rww02         LIKE rww_file.rww02,
           rww03         LIKE rww_file.rww03,
           rww03_desc    LIKE type_file.chr100,
           rww04         LIKE rww_file.rww04,
           distribution  LIKE type_file.num10
                    END RECORD,

       g_sql               STRING,
       g_wc                STRING,
       g_wc2               STRING,
       g_rec_b             LIKE type_file.num5,
       l_ac                LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_t1                LIKE oay_file.oayslip
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

   LET g_forupd_sql = "SELECT * FROM rwv_file WHERE rwv01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t140_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t140_w WITH FORM "art/42f/artt140"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL t140_menu()
   CLOSE WINDOW t140_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION t140_cs()
      DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

      CLEAR FORM
      CALL g_rww.clear()
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_rwv.* TO NULL
      CONSTRUCT BY NAME g_wc ON rwv01,rwv02,rwv03,rwv04,
                                rwvconf,rwvcond,rwvconu,
                                rwvuser,rwvgrup,rwvoriu,rwvorig,
                                rwvdate,rwvmodu,rwvcrat
                                
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(rwv01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_rwv"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rwv01
                  NEXT FIELD rwv01

               WHEN INFIELD(rwvconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rwvconu"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rwvconu
                  NEXT FIELD rwvconu
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
      LET g_wc = g_wc CLIPPED

      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rwvuser', 'rwvgrup')

      CONSTRUCT g_wc2 ON rww02,rww03,rww04,distribution
              FROM s_rww[1].rww02,s_rww[1].rww03,
                   s_rww[1].rww04,s_rww[1].distribution

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(rww03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = 'c'
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.where = "  gen07 = '",g_plant,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rww03
                   NEXT FIELD rww03
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

         ON ACTION qbe_save
            CALL cl_qbe_save()

         END CONSTRUCT

         IF INT_FLAG THEN
            RETURN
         END IF


      IF g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT  rwv01 FROM rwv_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY rwv01"
      ELSE
         LET g_sql = "SELECT UNIQUE rwv_file. rwv01 ",
                     " FROM rwv_file, rww_file ",
                     " WHERE rwv01 = rww01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY rwv01"
      END IF

      PREPARE t140_prepare FROM g_sql
      DECLARE t140_cs
         SCROLL CURSOR WITH HOLD FOR t140_prepare

      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(*) FROM rwv_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT rwv01)",
                " FROM rwv_file,rww_file WHERE ",
                " rww01=rwv01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF

      PREPARE t140_precount FROM g_sql
      DECLARE t140_count CURSOR FOR t140_precount

END FUNCTION


FUNCTION t140_menu()

   WHILE TRUE
      CALL t140_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t140_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t140_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t140_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t140_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t140_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t140_yes()
            END IF

         WHEN "undo_confirm"
             IF cl_chk_act_auth() THEN
               CALL t140_no()
            END IF

         WHEN "heavy"
             IF cl_chk_act_auth() THEN
                CALL t140_heavy()
             END IF 

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_rww),'','')
            END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rwv.rwv01 IS NOT NULL THEN
                    LET g_doc.column1 = "rwv01"
                    LET g_doc.value1 = g_rwv.rwv01
                    CALL cl_doc()
                 END IF
              END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t140_v()
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t140_heavy()
   DEFINE    l_ogb14t  LIKE ogb_file.ogb14t,
             l_ohb14t  LIKE ohb_file.ohb14t
   DEFINE    l_sql     STRING,
             l_cnt     LIKE type_file.num5,
             l_rww03   LIKE rww_file.rww03,
             l_rww04   LIKE rww_file.rww04,
             l_no      LIKE type_file.num5
   SELECT * INTO g_rwv.* FROM rwv_file
    WHERE rwv01=g_rwv.rwv01
   IF g_rwv.rwvconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rwv.rwvconf = 'Y' THEN
      CALL cl_err('','art-746',0)
      RETURN
   END IF 
   IF NOT cl_confirm('art-744') THEN 
      RETURN
   ELSE 
      
      SELECT COALESCE(SUM(ogb14t),0) INTO l_ogb14t
        FROM ogb_file,oga_file
   #   WHERE ogb14t > 0                 #FUN-B70100 MARK
   #     AND ogbplant = g_plant         #FUN-B70100 MARK
       WHERE ogbplant = g_plant         #FUN-B70100 ADD
         AND oga02 = g_rwv.rwv02
         AND oga01 = ogb01
         AND ogapost = 'Y'              #FUN-B60145     
         #AND oga00 = 1                 #TQC-B70078
         AND oga09 IN ('2','3','4','6')         #TQC-B70078
      SELECT COALESCE(SUM(ohb14t),0) INTO l_ohb14t
        FROM ohb_file,oha_file
   #   WHERE ohb14t < 0                 #FUN-B70100 MARK
   #     AND ohbplant = g_plant         #FUN-B70100 MARK
       WHERE ohbplant = g_plant         #FUN-B70100 ADD
         AND oha02 = g_rwv.rwv02
         AND ohb01 = oha01
         AND ohapost = 'Y'              #FUN-B60145
         #AND oha05 = 1                 #TQC-B70078
         AND oha05 IN ('1','2')             #TQC-B70078
      LET g_rwv.rwv03 = l_ogb14t + l_ohb14t*(-1)   
      DISPLAY BY NAME g_rwv.rwv03 
      IF g_rwv.rwv03 != g_rwv_t.rwv03 THEN 
         UPDATE rwv_file SET rwv03 = g_rwv.rwv03
             WHERE rwv01 = g_rwv.rwv01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rwv_file",g_rwv.rwv03,
                            "",SQLCA.sqlcode,"","rwv",1)
         END IF
         IF NOT cl_confirm('art-747') THEN
             CALL t140_b_fill("1=1")    
         ELSE
            LET l_cnt = 0
            LET l_no = 0
            LET l_sql =
                      " SELECT rww03 FROM rww_file ",
                      "  WHERE rww01 = '",g_rwv.rwv01,"'"
            PREPARE t140_set_heavy FROM l_sql
            DECLARE set_heavy CURSOR FOR t140_set_heavy
            CALL g_rww.clear()
            SELECT COUNT(*) INTO l_no
              FROM rww_file 
             WHERE rww01 = g_rwv.rwv01
            FOREACH set_heavy INTO l_rww03
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                LET l_cnt = l_cnt + 1
                IF l_cnt = l_no THEN
                   LET l_rww04 = g_rwv.rwv03 - (cl_digcut(g_rwv.rwv03/l_no,0)*(l_no-1))
                ELSE
                   LET l_rww04 = g_rwv.rwv03/l_no
                   LET l_rww04 = cl_digcut(l_rww04,0)
                END IF
                UPDATE rww_file SET rww04 = l_rww04 
                WHERE rww01 = g_rwv.rwv01
                  AND rww02 = l_cnt
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","rww_file",
                    g_rwv.rwv01,"",SQLCA.sqlcode,"","",1)
                    CONTINUE FOREACH
                END IF
             END FOREACH 
             CALL t140_b_fill("1=1")
             CALL t140_distributed()    #FUN-B70100 ADD
         END IF 
      END IF
  END IF 
END FUNCTION

FUNCTION t140_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rww TO s_rww.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL t140_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t140_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t140_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL t140_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL t140_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION confirm
           LET g_action_choice="confirm"
           EXIT DISPLAY

      ON ACTION undo_confirm
           LET g_action_choice="undo_confirm"
           EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
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

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION heavy                   #重取銷貨金額
         LET g_action_choice= "heavy"
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

FUNCTION t140_bp_refresh()
  DISPLAY ARRAY g_rww TO s_rww.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION t140_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_str       LIKE type_file.chr1
   MESSAGE ""
   CLEAR FORM
   CALL g_rww.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_rwv.* LIKE rwv_file.*
   LET g_rwv01_t = NULL


   LET g_rwv_t.* = g_rwv.*
   LET g_rwv_o.* = g_rwv.*
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_rwv.rwvuser=g_user
      LET g_rwv.rwvoriu = g_user
      LET g_rwv.rwvorig = g_grup
      LET g_rwv.rwvgrup=g_grup
      LET g_rwv.rwvcrat=g_today
      LET g_rwv.rwvplant = g_plant
      LET g_rwv.rwvconf = 'N'
      LET g_rwv.rwv02 = g_today
      SELECT azw08,azw02 INTO g_rwvplant_desc,g_rwv.rwvlegal 
        FROM azw_file
       WHERE azw01 = g_rwv.rwvplant 
         AND azwacti = 'Y'
      CALL t140_i("a")

      IF INT_FLAG THEN
         INITIALIZE g_rwv.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_rwv.rwv01) THEN
         CONTINUE WHILE
      END IF
      
      BEGIN WORK
      CALL s_auto_assign_no("art",g_rwv.rwv01,g_rwv.rwv02,"","rwv_file","rwv01","","","") RETURNING li_result,g_rwv.rwv01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rwv.rwv01

      INSERT INTO rwv_file VALUES (g_rwv.*)
      IF SQLCA.sqlcode THEN
      #   ROLLBACK WORK         #FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","rwv_file",
                      g_rwv.rwv01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK          #FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_rwv.rwv01,'I')
      END IF

      SELECT rwv01 INTO g_rwv.rwv01 FROM rwv_file
       WHERE rwv01 = g_rwv.rwv01
      LET g_rwv01_t = g_rwv.rwv01
      LET g_rwv_t.* = g_rwv.*
      LET g_rwv_o.* = g_rwv.*
      OPEN WINDOW t140_w1 WITH FORM "art/42f/artt140-1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)     
      CALL cl_ui_locale("artt140-1")
      INPUT l_str FROM check
      CLOSE WINDOW t140_w1 
      CASE l_str
         WHEN "1"
               CALL g_rww.clear()
               LET g_rec_b = 0 
         WHEN "2"
               CALL t140_set2()             #抓取員工資料并給單身欄位複製
               CALL t140_b_fill("1=1")
         WHEN "3" 
               CALL t140_set3()             #平均分攤至每位員工設置
               CALL t140_b_fill("1=1")
         OTHERWISE
      END CASE
      CALL t140_distributed()        #FUN-B70100 ADD
      CALL t140_b()
      EXIT WHILE
   END WHILE

END FUNCTION


FUNCTION t140_set2() 
   DEFINE l_sql      STRING,
          l_cnt      LIKE type_file.num5,
          l_rww03    LIKE rww_file.rww03
          
   LET l_cnt = 0
   LET l_sql = 
             " SELECT gen01 FROM gen_file ",
             "  WHERE gen07 = '",g_plant,"'",
             "    AND genacti = 'Y'" 
   PREPARE t140_set FROM l_sql
   DECLARE set_cs CURSOR FOR t140_set
   CALL g_rww.clear()
   FOREACH set_cs INTO l_rww03
       IF SQLCA.sqlcode THEN
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt + 1
       INSERT INTO rww_file VALUES(g_rwv.rwv01,l_cnt,l_rww03,0,g_rwv.rwvlegal,g_plant)
       IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rww_file",
                      g_rwv.rwv01,"",SQLCA.sqlcode,"","",1)
         CONTINUE FOREACH
      END IF 
   END FOREACH        
END FUNCTION 

FUNCTION t140_set3()
   DEFINE l_sql      STRING,
          l_cnt      LIKE type_file.num5,
          l_rww03    LIKE rww_file.rww03,
          l_rww04    LIKE rww_file.rww04,
          l_no       LIKE type_file.num5

   LET l_cnt = 0
   LET l_no = 0
   LET l_sql =
             " SELECT gen01 FROM gen_file ",
             "  WHERE gen07 = '",g_plant,"'",
             "    AND genacti = 'Y'"
   PREPARE t140_set3 FROM l_sql
   DECLARE set3_cs CURSOR FOR t140_set3
   CALL g_rww.clear()
   SELECT COUNT(*) INTO l_no 
     FROM gen_file
    WHERE gen07 = g_plant
      AND genacti = 'Y'
   FOREACH set3_cs INTO l_rww03
       IF SQLCA.sqlcode THEN
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt + 1
       IF l_cnt = l_no THEN 
          LET l_rww04 = g_rwv.rwv03 - (cl_digcut(g_rwv.rwv03/l_no,0)*(l_no-1))
       ELSE
          LET l_rww04 = g_rwv.rwv03/l_no
          LET l_rww04 = cl_digcut(l_rww04,0)
       END IF
       INSERT INTO rww_file VALUES(g_rwv.rwv01,l_cnt,l_rww03,l_rww04,g_rwv.rwvlegal,g_plant)
       IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rww_file",
                      g_rwv.rwv01,"",SQLCA.sqlcode,"","",1)
         CONTINUE FOREACH
      END IF
   END FOREACH
END FUNCTION
FUNCTION t140_u()
   DEFINE li_result   LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rwv.rwv01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_rwv.rwvconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rwv.rwvconf = 'Y' THEN
      CALL cl_err('','art-741',0)
      RETURN
   END IF

   SELECT * INTO g_rwv.* FROM rwv_file
    WHERE rwv01=g_rwv.rwv01


   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_rwv01_t = g_rwv.rwv01
   BEGIN WORK

   OPEN t140_cl USING g_rwv.rwv01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t140_cl INTO g_rwv.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)
       CLOSE t140_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t140_show()

   WHILE TRUE
      LET g_rwv01_t = g_rwv.rwv01
      LET g_rwv_o.* = g_rwv.*
      LET g_rwv.rwvmodu=g_user
      LET g_rwv.rwvdate=g_today
      
      CALL t140_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rwv.*=g_rwv_t.*
         CALL t140_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_rwv.rwv02 != g_rwv_t.rwv02 THEN 
          CALL s_auto_assign_no("art",g_rwv.rwv01,g_rwv.rwv02,"","rwv_file","rwv01","","","") 
                                RETURNING li_result,g_rwv.rwv01
          IF (NOT li_result) THEN
             CONTINUE WHILE
          END IF
      DISPLAY BY NAME g_rwv.rwv01
 
      END IF 
      IF g_rwv.rwv01 != g_rwv01_t THEN
         UPDATE rww_file SET rww01 = g_rwv.rwv01
          WHERE rww01 = g_rwv01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rww_file",g_rwv01_t,
                         "",SQLCA.sqlcode,"","rww",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE rwv_file SET rwv_file.* = g_rwv.*
       WHERE rwv01 = g_rwv.rwv01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rwv_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t140_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rwv.rwv01,'U')
   CALL t140_b_fill("1=1")
   CALL t140_bp_refresh()

END FUNCTION

FUNCTION t140_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1,
   l_ogb14t  LIKE ogb_file.ogb14t,
   l_ohb14t  LIKE ohb_file.ohb14t,
   li_result LIKE type_file.num5
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_rwv.rwvplant,g_rwv.rwvconf,
                   g_rwv.rwvuser,g_rwv.rwvmodu,g_rwv.rwvcrat,
                   g_rwv.rwvgrup,g_rwv.rwvdate,
                   g_rwv.rwvoriu,g_rwv.rwvorig
   DISPLAY g_rwvplant_desc TO rwvplant_desc
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_rwv.rwv01,g_rwv.rwv02,
                 g_rwv.rwv03,g_rwv.rwv04
                 
       WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t140_set_entry(p_cmd)
         CALL t140_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("rwv01")

      AFTER FIELD rwv01
         IF NOT cl_null(g_rwv.rwv01) THEN 
            CALL s_check_no("art",g_rwv.rwv01,g_rwv01_t,"G4","rwv_file","rwv01","") RETURNING li_result,g_rwv.rwv01
            DISPLAY BY NAME g_rwv.rwv01 
            IF (NOT li_result) THEN
               LET g_rwv.rwv01 = g_rwv_t.rwv01
               NEXT FIELD rwv01
            END IF 
            NEXT FIELD rwv02
         END IF
     
      AFTER FIELD rwv02
         IF (NOT cl_null(g_rwv.rwv02) AND p_cmd = 'a') 
            OR NOT cl_null(g_rwv_t.rwv02) AND g_rwv_t.rwv02 != g_rwv.rwv02 THEN
            CALL t140_rwv02()
            IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_rwv.rwv02 = g_rwv_t.rwv02
                NEXT FIELD rwv02
            ELSE
               SELECT COALESCE(SUM(ogb14t),0) INTO l_ogb14t 
                 FROM ogb_file,oga_file
            #   WHERE ogb14t > 0            #FUN-B70100 MARK
            #     AND ogbplant = g_plant    #FUN-B70100 MARK
                WHERE ogbplant = g_plant      #FUN-B70100 ADD
                  AND oga02 = g_rwv.rwv02
                  AND oga01 = ogb01
                  AND ogapost = 'Y'              #FUN-B60145
                  #AND oga00 = 1                 #TQC-B70078
                  AND oga09 IN ('2','3','4','6')         #TQC-B70078
               SELECT COALESCE(SUM(ohb14t),0) INTO l_ohb14t
                 FROM ohb_file,oha_file
            #   WHERE ohb14t < 0            #FUN-B70100 MARK
            #     AND ohbplant = g_plant    #FUN-B70100 MARK
                WHERE ohbplant = g_plant      #FUN-B70100 ADD
                  AND oha02 = g_rwv.rwv02
                  AND ohb01 = oha01
                  AND ohapost = 'Y'              #FUN-B60145
                  #AND oha05 = 1                 #TQC-B70078
                  AND oha05 IN ('1','2')             #TQC-B70078
               LET g_rwv.rwv03 = l_ogb14t + l_ohb14t*(-1)
               IF cl_null(g_rwv.rwv03) OR g_rwv.rwv03 = 0 THEN 
                   CALL cl_err('','art-732',0)
                   NEXT FIELD rwv02
               ELSE 
                   DISPLAY BY NAME g_rwv.rwv03
               END IF 
            END IF 
         END IF 

      ON ACTION CONTROLP
          CASE 
             WHEN INFIELD(rwv01)
                 LET g_t1=s_get_doc_no(g_rwv.rwv01)
                 CALL q_oay(FALSE,FALSE,g_t1,'G4','ART') RETURNING g_t1
                 LET g_rwv.rwv01 = g_t1
                 DISPLAY BY NAME g_rwv.rwv01
                 NEXT FIELD rwv01 
             OTHERWISE
          END CASE
      AFTER INPUT 
         LET g_rwv.rwvuser = s_get_data_owner("rwv_file") #FUN-C10039
         LET g_rwv.rwvgrup = s_get_data_group("rwv_file") #FUN-C10039
          IF INT_FLAG THEN
               EXIT INPUT
          END IF
          IF cl_null(g_rwv.rwv03) OR g_rwv.rwv03 = 0 THEN
               CALL cl_err('','art-732',0)
               NEXT FIELD rwv02
          END IF 
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

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
     
   END INPUT

END FUNCTION

FUNCTION t140_rwv02()
   DEFINE l_n    LIKE type_file.num5
   LET g_errno = ''
   LET l_n = 0
   SELECT COUNT(*) INTO l_n
     FROM rwv_file
    WHERE rwvplant = g_plant
      AND rwv02 = g_rwv.rwv02
   IF l_n > 0  THEN 
      LET g_errno = 'art-739'
   END IF   
END FUNCTION


FUNCTION t140_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rww.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t140_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rwv.* TO NULL
      RETURN
   END IF

   OPEN t140_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rwv.* TO NULL
   ELSE
      OPEN t140_count
      FETCH t140_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL t140_fetch('F')
   END IF

END FUNCTION

FUNCTION t140_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t140_cs INTO g_rwv.rwv01
      WHEN 'P' FETCH PREVIOUS t140_cs INTO g_rwv.rwv01
      WHEN 'F' FETCH FIRST    t140_cs INTO g_rwv.rwv01
      WHEN 'L' FETCH LAST     t140_cs INTO g_rwv.rwv01
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t140_cs INTO g_rwv.rwv01
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)
      INITIALIZE g_rwv.* TO NULL
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

   SELECT * INTO g_rwv.* FROM rwv_file WHERE rwv01 = g_rwv.rwv01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rwv_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rwv.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_rwv.rwvuser
   LET g_data_group = g_rwv.rwvgrup
   LET g_data_plant = g_rwv.rwvplant   #TQC-BB0125 add
   CALL t140_show()

END FUNCTION

FUNCTION t140_show()

   LET g_rwv_t.* = g_rwv.*
   LET g_rwv_o.* = g_rwv.*
   DISPLAY BY NAME g_rwv.rwv01,g_rwv.rwv02,
                   g_rwv.rwv03,g_rwv.rwv04,
                   g_rwv.rwvplant,
                   g_rwv.rwvconf,g_rwv.rwvconu,
                   g_rwv.rwvcond,
                   g_rwv.rwvuser,g_rwv.rwvgrup,
                   g_rwv.rwvoriu,g_rwv.rwvmodu,
                   g_rwv.rwvdate,g_rwv.rwvorig,
                   g_rwv.rwvcrat
   SELECT azw08 INTO g_rwvplant_desc
   FROM azw_file
   WHERE azw01 = g_rwv.rwvplant AND azwacti = 'Y'
   DISPLAY g_rwvplant_desc TO rwvplant_desc
   CALL t140_b_fill(g_wc2)
   CALL t140_distributed()        #FUN-B70100 ADD
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t140_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_rwv.rwv01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_rwv.rwvconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rwv.rwvconf = 'Y' THEN
      CALL cl_err('','art-742',0)
      RETURN
   END IF


   SELECT * INTO g_rwv.* FROM rwv_file
    WHERE rwv01=g_rwv.rwv01
   BEGIN WORK

   OPEN t140_cl USING g_rwv.rwv01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t140_cl INTO g_rwv.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t140_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "rwv01"
       LET g_doc.value1 = g_rwv.rwv01
       CALL cl_del_doc()
      DELETE FROM rwv_file WHERE rwv01 = g_rwv.rwv01
      DELETE FROM rww_file WHERE rww01 = g_rwv.rwv01
      CLEAR FORM
      CALL g_rww.clear()
      OPEN t140_count
      FETCH t140_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t140_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t140_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t140_fetch('/')
      END IF
   END IF

   CLOSE t140_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rwv.rwv01,'D')
END FUNCTION

FUNCTION t140_b()
DEFINE
    l_n             LIKE type_file.num5,
    l_i1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE 
       l_imaacti    LIKE ima_file.imaacti,
       l_gfeacti    LIKE gfe_file.gfeacti
DEFINE l_ac_t LIKE type_file.num5            #FUN-ND30033

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_rwv.rwv01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_rwv.* FROM rwv_file
     WHERE rwv01=g_rwv.rwv01

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT rww02,rww03,'',rww04,''",
                       "  FROM rww_file",
                       "  WHERE rww01=? AND rww02=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t140_bcl CURSOR FROM g_forupd_sql

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_rww WITHOUT DEFAULTS FROM s_rww.*
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
           LET g_success = 'N'
           OPEN t140_cl USING g_rwv.rwv01
           IF STATUS THEN
              CALL cl_err("OPEN t140_cl:", STATUS, 1)
              CLOSE t140_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t140_cl INTO g_rwv.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)
              CLOSE t140_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              IF g_rwv.rwvconf = 'Y' THEN
                 CALL cl_err('','art-742',0)
                 ROLLBACK WORK
                 RETURN
              END IF      
              LET p_cmd='u'
              LET g_rww_t.* = g_rww[l_ac].*
              OPEN t140_bcl USING g_rwv.rwv01,g_rww_t.rww02
              IF STATUS THEN
                 CALL cl_err("OPEN t140_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t140_bcl INTO g_rww[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rww_t.rww02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t140_rww03('d')
                 IF g_rww[l_ac].rww04 <> 0 THEN
                    LET g_rww[l_ac].distribution = cl_digcut(g_rww[l_ac].rww04/g_rwv.rwv03*100,0)
                 ELSE 
                    LET g_rww[l_ac].distribution = 0
                    DISPLAY BY NAME g_rww[l_ac].distribution   
                 END IF 
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rww[l_ac].* TO NULL
           LET g_rww_t.* = g_rww[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rww02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET l_n = 0
              SELECT count(*) INTO l_n
                FROM rww_file
               WHERE rww01 = g_rwv.rwv01
                 AND rww02 = g_rww[l_ac].rww02
           IF l_n > 0 THEN
              CALL cl_err('','art-743',0)
              LET g_rww[l_ac].rww03 = ''
              NEXT FIELD rww03
           ELSE 
              INSERT INTO rww_file(rww01,rww02,rww03,rww04,rwwplant,rwwlegal)

              VALUES(g_rwv.rwv01,g_rww[l_ac].rww02,
                     g_rww[l_ac].rww03,g_rww[l_ac].rww04,
                     g_plant,g_rwv.rwvlegal
                    )
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rww_file",g_rwv.rwv01,
                            g_rww[l_ac].rww02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_success = 'Y'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
          END IF 

        BEFORE FIELD rww02
           IF g_rww[l_ac].rww02 IS NULL OR g_rww[l_ac].rww02 = 0 THEN
              SELECT max(rww02)+1
                INTO g_rww[l_ac].rww02
                FROM rww_file
               WHERE rww01 = g_rwv.rwv01
              IF g_rww[l_ac].rww02 IS NULL THEN
                 LET g_rww[l_ac].rww02 = 1
              END IF
           END IF

        AFTER FIELD rww02
           IF NOT cl_null(g_rww[l_ac].rww02) THEN
              IF (g_rww[l_ac].rww02 != g_rww_t.rww02
                  AND NOT cl_null(g_rww_t.rww02))
                 OR g_rww_t.rww02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rww_file
                  WHERE rww01 = g_rwv.rwv01
                    AND rww02 = g_rww[l_ac].rww02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rww[l_ac].rww02 = g_rww_t.rww02
                    NEXT FIELD rww02
                 END IF
              END IF
           END IF


       AFTER FIELD rww03
           IF NOT cl_null(g_rww[l_ac].rww03) THEN
              IF (g_rww[l_ac].rww03 != g_rww_t.rww03
                 AND NOT cl_null(g_rww_t.rww03)) 
                 OR cl_null(g_rww_t.rww03) THEN 
                 CALL t140_rww03(p_cmd)
                 IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,0)
                     LET g_rww[l_ac].rww03 = g_rww_t.rww03
                     NEXT FIELD rww03
                 END IF   
              END IF 
           END IF

      AFTER FIELD rww04 
           IF NOT cl_null(g_rww[l_ac].rww04) AND g_rww[l_ac].rww04 !=0  THEN
             #FUN-B70100 Mark Begin---
             #IF g_rww[l_ac].rww04 < 0 OR g_rww[l_ac].rww04 > g_rwv.rwv03 THEN 
             #    CALL cl_err('','art-734',0)
             #    LET g_rww[l_ac].rww04 = g_rww_t.rww04
             #    NEXT FIELD rww04
             #ELSE 
             #FUN-B70100 Mark End-----
                  LET g_rww[l_ac].distribution = cl_digcut(g_rww[l_ac].rww04/g_rwv.rwv03*100,0) 
                  CALL t140_rww04(p_cmd)              #判斷分配銷售額總計是否大於銷售總額
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_rww[l_ac].rww04 = g_rww_t.rww04
                      LET g_rww[l_ac].distribution = cl_digcut(g_rww_t.rww04/g_rwv.rwv03*100,0)
                      NEXT FIELD rww04
                  END IF 
                  DISPLAY BY NAME g_rww[l_ac].distribution
             #END IF  ##FUN-B70100 Mark 
           ELSE 
               IF g_rww[l_ac].rww04 = 0 THEN
                   LET g_rww[l_ac].distribution = 0
                   DISPLAY BY NAME g_rww[l_ac].distribution
               END IF   
           END IF    
     
      BEFORE FIELD distribution                                          #TQC-B70059
         LET g_rww_t.distribution = g_rww[l_ac].distribution             #TQC-B70059
     
      AFTER FIELD distribution
           IF NOT cl_null(g_rww[l_ac].distribution) AND g_rww[l_ac].distribution !=0 THEN 
              #FUN-B70100 Mark Begin---
              #IF g_rww[l_ac].distribution < 0 OR g_rww[l_ac].distribution > 100 THEN 
              #   CALL cl_err('','art-735',0)
              #   NEXT FIELD  distribution
              #ELSE 
              #FUN-B70100 Mark End-----
                  IF g_rww[l_ac].distribution != g_rww_t.distribution 
                      AND NOT cl_null(g_rww_t.distribution) THEN
                      LET g_rww[l_ac].rww04 = g_rww[l_ac].distribution * g_rwv.rwv03/100
                      CALL t140_distribution()       #判斷分配比例總和是否大於100    
                      IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_rww[l_ac].distribution = g_rww_t.distribution 
                          LET g_rww[l_ac].rww04 = g_rww_t.distribution * g_rwv.rwv03/100
                          NEXT FIELD distribution
                          DISPLAY BY NAME g_rww[l_ac].rww04
                      END IF 
#                  ELSE                                                                     #TQC-B70059   mark
#                      LET g_rww[l_ac].rww04 = g_rww_t.distribution * g_rwv.rwv03/100       #TQC-B70059   mark
                  END IF 
              #END IF  #FUN-B70100 Mark 
           ELSE 
               IF cl_null(g_rww[l_ac].distribution) THEN 
                  LET g_rww[l_ac].distribution = cl_digcut(g_rww[l_ac].rww04/g_rwv.rwv03*100,0)
               END IF 
               IF g_rww[l_ac].distribution != g_rww_t.distribution 
                    AND NOT cl_null(g_rww_t.distribution) THEN
                    LET g_rww[l_ac].rww04 = 0
               END IF 
               DISPLAY BY NAME g_rww[l_ac].rww04
           END IF 

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rww_t.rww02 > 0 AND g_rww_t.rww02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rww_file
               WHERE rww01 = g_rwv.rwv01
                 AND rww02 = g_rww_t.rww02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rww_file",g_rwv.rwv01,
                               g_rww_t.rww02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
           LET g_success = 'Y'

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rww[l_ac].* = g_rww_t.*
              CLOSE t140_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rww[l_ac].rww02,-263,1)
              LET g_rww[l_ac].* = g_rww_t.*
           ELSE
              UPDATE rww_file SET rww02=g_rww[l_ac].rww02,
                                  rww03=g_rww[l_ac].rww03,
                                  rww04=g_rww[l_ac].rww04
               WHERE rww01=g_rwv.rwv01
                 AND rww02=g_rww_t.rww02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rww_file",g_rwv.rwv01,
                               g_rww_t.rww02,SQLCA.sqlcode,"","",1)
                 LET g_rww[l_ac].* = g_rww_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                 LET g_success = 'Y'
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rww[l_ac].* = g_rww_t.*
            #FUN-D30033--add--str--
              ELSE
                 CALL g_rww.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30033--add--end--
              END IF
              CLOSE t140_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           IF g_success =  'N' THEN 
              CLOSE t140_bcl
              ROLLBACK WORK   
           ELSE 
              CLOSE t140_bcl
           END IF 
           CALL t140_distributed()  #FUN-B70100 ADD
        ON ACTION CONTROLO
           IF INFIELD(rww02) AND l_ac > 1 THEN
              LET g_rww[l_ac].* = g_rww[l_ac-1].*
              LET g_rww[l_ac].rww02 = g_rec_b + 1
              NEXT FIELD rww02
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()


        ON ACTION CONTROLP 
           CASE
             WHEN INFIELD(rww03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.where = "  gen07 = '",g_plant,"'" 
               LET g_qryparam.default1 = g_rww[l_ac].rww03
                 CALL cl_create_qry() RETURNING g_rww[l_ac].rww03
                  DISPLAY BY NAME g_rww[l_ac].rww03
                  NEXT FIELD rww03
               OTHERWISE EXIT CASE
            END CASE

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
    IF p_cmd = 'u' THEN
    LET g_rwv.rwvmodu = g_user
    LET g_rwv.rwvdate = g_today
    UPDATE rwv_file
    SET rwvmodu = g_rwv.rwvmodu,
        rwvdate = g_rwv.rwvdate
     WHERE rwv01 = g_rwv.rwv01
    DISPLAY BY NAME g_rwv.rwvmodu,g_rwv.rwvdate
    END IF
    CLOSE t140_bcl
#   CALL t140_delall()  #CHI-C30002 mark
    CALL t140_delHeader()     #CHI-C30002 add

END FUNCTION


FUNCTION t140_rww04(p_cmd)
   DEFINE l_sum         LIKE rww_file.rww04
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE i,i_min,i_max INTEGER               
   LET g_errno = ''
   LET i_min = 1
   IF p_cmd = 'a' THEN 
      LET i_max = g_rec_b + 1
   ELSE 
      LET i_max = g_rec_b
   END IF  
   LET l_sum = 0
   FOR i = i_min TO i_max
      LET l_sum = l_sum + g_rww[i].rww04 
   END FOR 
   IF l_sum > g_rwv.rwv03 THEN
       LET g_errno = 'art-736'
       LET g_rww[l_ac].distribution = ''
   END IF 
   IF p_cmd = 'y' AND l_sum > g_rwv.rwv03 THEN 
       LET g_errno = 'art-745'
   END IF 

END FUNCTION 

FUNCTION t140_distribution()
   DEFINE l_count    LIKE type_file.num5
   DEFINE i,i_min,i_max INTEGER
   LET g_errno = ''
   LET i_min = 1
   LET i_max = g_rec_b
   LET l_count = 0
   FOR i = i_min TO i_max
   LET l_count = l_count + g_rww[i].distribution
   END FOR
   IF l_count > 100 THEN
       LET g_errno = 'art-737'
   END IF 

END FUNCTION


FUNCTION t140_rww03(p_cmd)
DEFINE l_genacti    LIKE gen_file.genacti
DEFINE p_cmd        LIKE type_file.chr1,
       l_gen02      LIKE gen_file.gen02,
       l_n          LIKE type_file.num5
   LET g_errno = ''
   SELECT genacti,gen02 INTO l_genacti,l_gen02
     FROM gen_file
    WHERE gen01 = g_rww[l_ac].rww03 
      AND gen07 = g_plant
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
                               LET l_gen02 = ''
      WHEN l_genacti <> 'Y'    LET g_errno = 'art-733'
                               LET l_gen02 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT count(*) INTO l_n 
        FROM rww_file
       WHERE rww03 = g_rww[l_ac].rww03
         AND rww01 = g_rwv.rwv01
      IF l_n > 0 THEN 
         LET g_errno = 'art-738'
      END IF 
   END IF 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rww[l_ac].rww03_desc = l_gen02
      DISPLAY BY NAME g_rww[l_ac].rww03_desc
   END IF 

END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t140_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rwv.rwv01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rwv_file ",
                  "  WHERE rwv01 LIKE '",l_slip,"%' ",
                  "    AND rwv01 > '",g_rwv.rwv01,"'"
      PREPARE t140_pb1 FROM l_sql 
      EXECUTE t140_pb1 INTO l_cnt       
      
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
         CALL t140_v()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rwv_file WHERE rwv01 = g_rwv.rwv01
         INITIALIZE g_rwv.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t140_delall()

#  SELECT COUNT(*) INTO g_cnt FROM rww_file
#   WHERE rww01 = g_rwv.rwv01

#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rwv_file WHERE rwv01 = g_rwv.rwv01
#  END IF

#END FUNCTION
#CHI-C30002 -------- mark -------- end


FUNCTION t140_b_fill(p_wc2)
DEFINE p_wc2      STRING

   LET g_sql = "SELECT rww02,rww03,'',rww04,'' ",
               "  FROM rww_file",
               " WHERE rww01 ='",g_rwv.rwv01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rww02 "

   PREPARE t140_pb FROM g_sql
   DECLARE rww_cs CURSOR FOR t140_pb

   CALL g_rww.clear()
   LET g_cnt = 1

   FOREACH rww_cs INTO g_rww[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT gen02 INTO g_rww[g_cnt].rww03_desc
         FROM gen_file 
        WHERE gen01 = g_rww[g_cnt].rww03
       DISPLAY BY NAME g_rww[g_cnt].rww03_desc
       LET g_errno = ' '
       IF g_rww[g_cnt].rww04 <> 0 THEN 
          LET g_rww[g_cnt].distribution = cl_digcut(g_rww[g_cnt].rww04/g_rwv.rwv03*100,0)
       ELSE
          LET g_rww[g_cnt].distribution = 0  
       END IF 
       DISPLAY BY NAME g_rww[g_cnt].distribution
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rww.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION


FUNCTION t140_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rwv01,rwv02",TRUE)
    END IF

END FUNCTION

FUNCTION t140_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rwv01,rwv02,rww02",FALSE)
    END IF

END FUNCTION


FUNCTION t140_yes()                       #審核
   DEFINE l_count   LIKE rwv_file.rwv03
   IF cl_null(g_rwv.rwv01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
#CHI-C30107 ------- add -------- begin
   IF g_rwv.rwvconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rwv.rwvconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
   IF NOT cl_confirm('alm-006') THEN
        RETURN
   END IF
#CHI-C30107 ------- add -------- end
   SELECT * INTO g_rwv.* FROM rwv_file WHERE rwv01=g_rwv.rwv01
   LET l_count = 0
   SELECT SUM(rww04) INTO l_count 
     FROM rww_file
    WHERE rww01 = g_rwv.rwv01 
   IF g_rwv.rwv03 <> l_count THEN 
        CALL cl_err('','art-740',0) 
        RETURN   
   END IF 
   CALL t140_rww04('y')
   IF NOT cl_null(g_errno) THEN 
        CALL cl_err('',g_errno,0)
        RETURN
   END IF 
   IF g_rwv.rwvconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rwv.rwvconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
 
#CHI-C30107 ------------ mark ------------ begin
#  IF NOT cl_confirm('alm-006') THEN
#       RETURN
#  END IF
#CHI-C30107 ------------ mark ------------ end

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t140_cl USING g_rwv.rwv01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t140_cl INTO g_rwv.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

   UPDATE rwv_file
   SET rwvconf = 'Y',
       rwvconu = g_user,
       rwvcond = g_today,
       rwvmodu = g_user,
       rwvdate = g_today
    WHERE rwv01 = g_rwv.rwv01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","rwv_file",g_rwv.rwv01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_rwv.rwvconf = 'Y'
      LET g_rwv.rwvconu = g_user
      LET g_rwv.rwvcond = g_today
      LET g_rwv.rwvmodu = g_user
      LET g_rwv.rwvdate = g_today
      DISPLAY BY NAME g_rwv.rwvconf,g_rwv.rwvconu,g_rwv.rwvcond,
                      g_rwv.rwvmodu,g_rwv.rwvdate
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t140_no()                     #取消審核
   IF cl_null(g_rwv.rwv01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_rwv.*
   FROM rwv_file
   WHERE rwv01=g_rwv.rwv01
   IF g_rwv.rwvconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_rwv.rwvconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'
   OPEN t140_cl USING g_rwv.rwv01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t140_cl INTO g_rwv.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm('alm-008') THEN
        RETURN
   END IF

    #UPDATE rwv_file SET rwvconf = 'N',rwvconu = '',rwvcond = '',           #CHI-D20015 Mark
     UPDATE rwv_file SET rwvconf = 'N',rwvconu = g_user,rwvcond = g_today,  #CHI-D20015 Add
                       rwvmodu = g_user,rwvdate = g_today
      WHERE rwv01 = g_rwv.rwv01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","rwv_file",g_rwv.rwv01,"",STATUS,"","",1)
        LET g_success = 'N'
     ELSE
        LET g_rwv.rwvconf = 'N'
       #CHI-D20015 Mark&Add Str
       #LET g_rwv.rwvconu = ''
       #LET g_rwv.rwvcond = ''
        LET g_rwv.rwvconu = g_user
        LET g_rwv.rwvcond = g_today
       #CHI-D20015 Mark&Add End
        LET g_rwv.rwvmodu = g_user
        LET g_rwv.rwvdate = g_today
        DISPLAY BY NAME g_rwv.rwvconf,g_rwv.rwvconu,g_rwv.rwvcond,
                        g_rwv.rwvmodu,g_rwv.rwvdate
      END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF 
END FUNCTION

#FUN-B70100 Add Begin---
#-<計算已分配金額并回寫和顯示到單頭>-#
FUNCTION t140_distributed()
DEFINE l_distributed    LIKE rwv_file.rwv03
DEFINE l_undistributed  LIKE rwv_file.rwv03    #FUN-B80107 add

   LET l_distributed = 0
   SELECT SUM(rww04) INTO l_distributed FROM rww_file WHERE rww01 = g_rwv.rwv01
   DISPLAY l_distributed TO FORMONLY.distributed

#FUN-B80107 add START
   LET l_undistributed = 0
   LET l_undistributed = g_rwv.rwv03 - l_distributed
   DISPLAY l_undistributed TO FORMONLY.undistributed
#FUN-B80107 add END
END FUNCTION
#FUN-B70100 Add End-----

#FUN-B60145

#CHI-C80041---begin
FUNCTION t140_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rwv.rwv01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t140_cl USING g_rwv.rwv01
   IF STATUS THEN
      CALL cl_err("OPEN t140_cl:", STATUS, 1)
      CLOSE t140_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t140_cl INTO g_rwv.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rwv.rwv01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t140_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rwv.rwvconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_rwv.rwvconf)   THEN 
        LET l_chr=g_rwv.rwvconf
        IF g_rwv.rwvconf='N' THEN 
            LET g_rwv.rwvconf='X' 
        ELSE
            LET g_rwv.rwvconf='N'
        END IF
        UPDATE rwv_file
            SET rwvconf=g_rwv.rwvconf,  
                rwvmodu=g_user,
                rwvdate=g_today
            WHERE rwv01=g_rwv.rwv01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rwv_file",g_rwv.rwv01,"",SQLCA.sqlcode,"","",1)  
            LET g_rwv.rwvconf=l_chr 
        END IF
        DISPLAY BY NAME g_rwv.rwvconf
   END IF
 
   CLOSE t140_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rwv.rwv01,'V')
 
END FUNCTION
#CHI-C80041---end
