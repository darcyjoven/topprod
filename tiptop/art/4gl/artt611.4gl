# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: artt611.4gl
# Descriptions...: 交款单维护作业
# Date & Author..: FUN-BB0117 11/11/23 By  yangxf
# Modify.........: No:FUN-C20009 12/02/03 By shiwuying 增加栏位lui15
# Modify.........: No:FUN-C20007 12/02/06 By xuxz 添加“拋轉財務”按鈕
# Modify.........: No.TQC-C20204 12/02/15 By xuxz 調整傳入參數的取值方法
# Modify.........: No.TQC-C20525 12/02/29 By fanbj 費用單串查資料時單身的費用單號等於費用單傳過來的單號
# Modify.........: No:TQC-C30027 12/03/02 By shiwuying 交款单交款BUG修改
# Modify.........: No:FUN-C30029 12/03/20 By xuxz 添加拋轉財務還原按鈕
# Modify.........: No.TQC-C30290 12/03/28 By fanbj 交款金额栏位控管未收金额-交款未审核金额-支出金额>0
# Modify.........: No.TQC-C40013 12/04/05 By suncx 費用單直接收款產生的收款單點擊“拋轉財務”時需要提示不可拋轉
# Modify.........: No.FUN-C30072 12/04/17 By yangxf 费用类型为支出的费用单不予以录入，自动产生单身时只带预收/收入
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C10024  12/05/17 By jinjj 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.FUN-CB0076 12/11/21 By xumeimei 添加GR打印功能
# Modify.........: No:CHI-C80041 13/01/22 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20015 13/03/36 By minpp 修改审核人员，审核日期为审核异动人员，审核异动日期,取消审核给值
# Modify.........: No:FUN-D30033 13/04/15 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_lui      RECORD LIKE lui_file.*,
       g_lui_t    RECORD LIKE lui_file.*,
       g_lui_o    RECORD LIKE lui_file.*,
       g_lui01_t  LIKE lui_file.lui01,
       g_luj      DYNAMIC ARRAY OF RECORD
           luj02   LIKE luj_file.luj02,
           luj03   LIKE luj_file.luj03,
           luj04   LIKE luj_file.luj04,
           luj05   LIKE luj_file.luj05,
           oaj02   LIKE oaj_file.oaj02,
           lub09   LIKE lub_file.lub09,
           lub07   LIKE lub_file.lub07,
           lub08   LIKE lub_file.lub08,
           lub04t  LIKE lub_file.lub04t,
           lub11   LIKE lub_file.lub11,
           amt_1   LIKE luj_file.luj06,
           luj06   LIKE luj_file.luj06,
           oaj04   LIKE oaj_file.oaj04,
           aag02   LIKE aag_file.aag02,
           oaj041  LIKE oaj_file.oaj041,
           aag02_1 LIKE aag_file.aag02,
           luj07   LIKE luj_file.luj07
                  END RECORD,

       g_luj_t    RECORD
           luj02   LIKE luj_file.luj02,
           luj03   LIKE luj_file.luj03,
           luj04   LIKE luj_file.luj04,
           luj05   LIKE luj_file.luj05,
           oaj02   LIKE oaj_file.oaj02,
           lub09   LIKE lub_file.lub09,
           lub07   LIKE lub_file.lub07,
           lub08   LIKE lub_file.lub08,
           lub04t  LIKE lub_file.lub04t,
           lub11   LIKE lub_file.lub11,
           amt_1   LIKE luj_file.luj06,
           luj06   LIKE luj_file.luj06,
           oaj04   LIKE oaj_file.oaj04,
           aag02   LIKE aag_file.aag02,
           oaj041  LIKE oaj_file.oaj041,
           aag02_1 LIKE aag_file.aag02,
           luj07   LIKE luj_file.luj07
                  END RECORD,

       g_luj_o    RECORD
           luj02   LIKE luj_file.luj02,
           luj03   LIKE luj_file.luj03,
           luj04   LIKE luj_file.luj04,
           luj05   LIKE luj_file.luj05,
           oaj02   LIKE oaj_file.oaj02,
           lub09   LIKE lub_file.lub09,
           lub07   LIKE lub_file.lub07,
           lub08   LIKE lub_file.lub08,
           lub04t  LIKE lub_file.lub04t,
           lub11   LIKE lub_file.lub11,
           amt_1   LIKE luj_file.luj06,
           luj06   LIKE luj_file.luj06,
           oaj04   LIKE oaj_file.oaj04,
           aag02   LIKE aag_file.aag02,
           oaj041  LIKE oaj_file.oaj041,
           aag02_1 LIKE aag_file.aag02,
           luj07   LIKE luj_file.luj07
                  END RECORD,
       g_sql          STRING,
       g_wc           STRING,
       g_wc2          STRING,
       g_rec_b        LIKE type_file.num5,
       l_ac           LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_argv1             LIKE lua_file.lua01
DEFINE g_argv2             LIKE lui_file.lui01
DEFINE li_result           LIKE type_file.num5
DEFINE g_gen02             LIKE gen_file.gen02
DEFINE g_gem02             LIKE gem_file.gem02
#FUN-CB0076----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
DEFINE l_table1          STRING
TYPE sr1_t    RECORD
    luiplant  LIKE lui_file.luiplant,
    lui01     LIKE lui_file.lui01,
    lua04     LIKE lua_file.lua04,
    lua20     LIKE lua_file.lua20,
    lui05     LIKE lui_file.lui05,
    lui02     LIKE lui_file.lui02,
    lui06     LIKE lui_file.lui06,
    luicond   LIKE lui_file.luicond,
    luicont   LIKE lui_file.luicont,
    luiconu   LIKE lui_file.luiconu,
    luj02     LIKE luj_file.luj02,
    luj03     LIKE luj_file.luj03,
    luj04     LIKE luj_file.luj04,
    luj05     LIKE luj_file.luj05,
    lub09     LIKE lub_file.lub09,
    lub07     LIKE lub_file.lub07,
    lub08     LIKE lub_file.lub08,
    lub04t    LIKE lub_file.lub04t,
    lub11     LIKE lub_file.lub11,
    lub12     LIKE lub_file.lub12,
    luj06     LIKE luj_file.luj06,
    rtz13     LIKE rtz_file.rtz13,
    occ02     LIKE occ_file.occ02,
    gen02     LIKE gen_file.gen02,
    oaj02     LIKE oaj_file.oaj02,
    amt       LIKE lub_file.lub11
END RECORD
TYPE sr2_t    RECORD
     rxy01    LIKE rxy_file.rxy01,
     rxy02    LIKE rxy_file.rxy02,
     rxy03    LIKE rxy_file.rxy03,
     rxy05    LIKE rxy_file.rxy05,
     rxy06    LIKE rxy_file.rxy06,
     rxy32    LIKE rxy_file.rxy32,
     rxy33    LIKE rxy_file.rxy33
END RECORD
#FUN-CB0076----add---end
DEFINE g_void      LIKE type_file.chr1  #CHI-C80041

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="luiplant.lui_file.luiplant,",
              "lui01.lui_file.lui01,",
              "lua04.lua_file.lua04,",
              "lua20.lua_file.lua20,",
              "lui05.lui_file.lui05,",
              "lui02.lui_file.lui02,",
              "lui06.lui_file.lui06,",
              "luicond.lui_file.luicond,",
              "luicont.lui_file.luicont,",
              "luiconu.lui_file.luiconu,",
              "luj02.luj_file.luj02,",
              "luj03.luj_file.luj03,",
              "luj04.luj_file.luj04,",
              "luj05.luj_file.luj05,",
              "lub09.lub_file.lub09,",
              "lub07.lub_file.lub07,",
              "lub08.lub_file.lub08,",
              "lub04t.lub_file.lub04t,",
              "lub11.lub_file.lub11,",
              "lub12.lub_file.lub12,",
              "luj06.luj_file.luj06,",
              "rtz13.rtz_file.rtz13,",
              "occ02.occ_file.occ02,",
              "gen02.gen_file.gen02,",
              "oaj02.oaj_file.oaj02,",
              "amt.lub_file.lub11"
   LET l_table = cl_prt_temptable('artt611',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   LET g_sql ="rxy01.rxy_file.rxy01,",
              "rxy02.rxy_file.rxy02,",
              "rxy03.rxy_file.rxy03,",
              "rxy05.rxy_file.rxy05,",
              "rxy06.rxy_file.rxy06,",
              "rxy32.rxy_file.rxy32,",
              "rxy33.rxy_file.rxy33"
   LET l_table1 = cl_prt_temptable('artt6111',g_sql) CLIPPED
   IF l_table1 = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end
   LET g_forupd_sql = "SELECT * FROM lui_file WHERE lui01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t611_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t611_w WITH FORM "art/42f/artt611"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN 
      CALL t611_q()
   END IF 
   CALL t611_menu()
   CLOSE WINDOW t611_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)    #FUN-CB0076 add
END MAIN

#QBE 查詢資料
FUNCTION t611_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM
   CALL g_luj.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lui.* TO NULL
   IF cl_null(g_argv1) AND cl_null(g_argv2) THEN 
      DIALOG ATTRIBUTE (UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON lui01,lui02,lui03,lui04,luiplant,
                                   luilegal,lui05,lui06,lui07,lui08,
                                   lui09,lui15,lui10,lui11,lui12,lui14,  #FUN-C20009
                                   luiconf,luiconu,luicond,lui13,
                                   luiuser,luigrup,luioriu,luimodu,
                                   luidate,luiorig,luiacti,luicrat
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(lui01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui01
                     NEXT FIELD lui01
   
                  WHEN INFIELD(lui04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui04"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui04
                     NEXT FIELD lui04
   
                  WHEN INFIELD(luiplant)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_luiplant"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luiplant
                     NEXT FIELD luiplant
   
                  WHEN INFIELD(luilegal)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_luilegal"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luilegal
                     NEXT FIELD luilegal
   
                  WHEN INFIELD(lui05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui05
                     NEXT FIELD lui05
   
                  WHEN INFIELD(lui06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui06"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui06
                     NEXT FIELD lui06
   
                  WHEN INFIELD(lui07)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui07"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui07
                     NEXT FIELD lui07
   
                  WHEN INFIELD(lui11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui11"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui11
                     NEXT FIELD lui11
   
                  WHEN INFIELD(lui12)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lui12"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lui12
                     NEXT FIELD lui12
                     
                  WHEN INFIELD(luiconu)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_luiconu"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO luiconu
                     NEXT FIELD luiconu
                  OTHERWISE EXIT CASE
               END CASE
            END CONSTRUCT
   
            CONSTRUCT g_wc2 ON luj02,luj03,luj04,
                               luj05,luj06,luj07
                 FROM s_luj[1].luj02,s_luj[1].luj03,
                      s_luj[1].luj04,s_luj[1].luj05,
                      s_luj[1].luj06,s_luj[1].luj07
            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)
   
               ON ACTION CONTROLP
                  CASE
                    WHEN INFIELD(luj03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.form ="q_luj03"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO luj03
                      NEXT FIELD luj03
                    WHEN INFIELD(luj05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = 'c'
                      LET g_qryparam.form ="q_luj05"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO luj05
                      NEXT FIELD luj05                   
                  END CASE
            END CONSTRUCT
            ON ACTION controlg
               CALL cl_cmdask()       
                
            ON ACTION close
               LET INT_FLAG=1
               EXIT DIALOG
            
            ON ACTION accept
               EXIT DIALOG
            
            ON ACTION cancel
               LET INT_FLAG=1
               EXIT DIALOG
              
         END DIALOG
   
         IF INT_FLAG THEN
            RETURN
         END IF
      END IF
      #TQC-C20525--start mark------------------
      #IF NOT cl_null(g_argv1) THEN
      #   LET g_wc = " lui04 = '",g_argv1,"'"
      #   LET g_wc2 = " 1=1"
      #END IF 
      #TQC-C20525--end mark--------------------

      #TQC-C20525--start add-------------------
      IF NOT cl_null(g_argv1) THEN
         LET g_wc2 = " luj03 = '",g_argv1,"'"
         LET g_wc = " 1=1 " 
      END IF 
      #TQC-C20525--end add---------------------
   
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = " lui01 = '",g_argv2,"'"
         LET g_wc2 = " 1=1"
      END IF 
      IF g_wc2 = " 1=1" THEN
         LET g_sql = "SELECT  lui01 FROM lui_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY lui01"
      ELSE
         LET g_sql = "SELECT UNIQUE lui_file. lui01 ",
                     " FROM lui_file, luj_file ",
                     " WHERE lui01 = luj01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY lui01"
      END IF                

      PREPARE t611_prepare FROM g_sql
      DECLARE t611_cs
         SCROLL CURSOR WITH HOLD FOR t611_prepare
      IF g_wc2 = " 1=1" THEN
         LET g_sql="SELECT COUNT(*) FROM lui_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT lui01)",
                " FROM lui_file,luj_file WHERE ",
                " luj01=lui01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
      PREPARE t611_precount FROM g_sql
      DECLARE t611_count CURSOR FOR t611_precount

END FUNCTION


FUNCTION t611_menu()

   WHILE TRUE
      CALL t611_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t611_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t611_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t611_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t611_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t611_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-CB0076------add----str
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t611_out()
            END IF
         #FUN-CB0076------add----end
         WHEN "confirm"                            #业务审核
            IF cl_chk_act_auth() THEN
               CALL t611_yes()
            END IF

         WHEN "undo_confirm"                       #取消业务审核
             IF cl_chk_act_auth() THEN
               CALL t611_no()
            END IF

         WHEN "pay_money"                          #收款
            IF cl_chk_act_auth() THEN
               CALL t611_pay()
            END IF 

         WHEN "money_detail"                       #款别明细
            IF cl_chk_act_auth() THEN
               CALL s_pay_detail('11',g_lui.lui01,g_lui.luiplant,g_lui.luiconf)
            END IF

         WHEN "pay_confirm"                        #交款审核
              IF cl_chk_act_auth() THEN
               CALL t611_pay_y()
            END IF

         WHEN "pay_undo_confirm"                   #取消交款审核
            IF cl_chk_act_auth() THEN
               CALL t611_pay_no()
            END IF

        #FN-C20007--add--str
         WHEN "spin_fin"                      #拋轉財務
            IF cl_chk_act_auth() THEN
               CALL t611_axrp602()
            END IF 
         #FN-C20007--add--end 
         #FUN-C30029--add--str
         WHEN "spin_fin_z"
            IF cl_chk_act_auth() THEN
               CALL t611_axrp606()
            END IF
         #FUN-C30029--add--end
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_luj),'','')
            END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lui.lui01 IS NOT NULL THEN
                 LET g_doc.column1 = "lui01"
                 LET g_doc.value1 = g_lui.lui01
                 CALL cl_doc()
               END IF
         END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t611_v()
               IF g_lui.luiconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
               CALL cl_set_field_pic(g_lui.luiconf,"","","",g_void,"")
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION

FUNCTION t611_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_luj TO s_luj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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

      #FUN-CB0076------add-----str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-CB0076------add-----end
      ON ACTION first
         CALL t611_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t611_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t611_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL t611_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL t611_fetch('L')
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
      ON ACTION pay_money
         LET g_action_choice="pay_money"
         EXIT DISPLAY 

      ON ACTION money_detail
         LET g_action_choice="money_detail"
         EXIT DISPLAY

      ON ACTION pay_confirm
         LET g_action_choice="pay_confirm"
         EXIT DISPLAY    

      ON ACTION pay_undo_confirm
         LET g_action_choice="pay_undo_confirm"
         EXIT DISPLAY

#---------FUN-C20007--add--str
      ON ACTION spin_fin
         LET g_action_choice = "spin_fin"
         EXIT DISPLAY
#---------FUN-C20007--add-end

      #---FUN-C30029--add--str
      ON ACTION spin_fin_z
         LET g_action_choice = "spin_fin_z"
         EXIT DISPLAY
      #---FUN-C30029--add--end

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

FUNCTION t611_bp_refresh()
  DISPLAY ARRAY g_luj TO s_luj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION t611_a()
   DEFINE li_result  LIKE type_file.num5
   MESSAGE ""
   CLEAR FORM
   CALL g_luj.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF
   
   INITIALIZE g_lui.* LIKE lui_file.*
   LET g_lui01_t = NULL
   LET g_lui_t.* = g_lui.*
   LET g_lui_o.* = g_lui.*
   WHILE TRUE
      IF NOT cl_null(g_argv1) THEN
         LET g_lui.lui04 = g_argv1
         SELECT lua06,lua07,lua04,lua20
           INTO g_lui.lui05,g_lui.lui06,g_lui.lui07,g_lui.lui08
           FROM lua_file
          WHERE lua01 = g_lui.lui04
      END IF 
      LET g_lui.lui02 = g_today
      LET g_lui.lui03 = g_today
      LET g_lui.luiuser=g_user
      LET g_lui.luioriu = g_user
      LET g_lui.luiorig = g_grup
      LET g_lui.luigrup=g_grup
      LET g_lui.luicrat=g_today
      LET g_lui.luiacti='Y'
      LET g_lui.luiconf = 'N'
      LET g_lui.luiplant = g_plant
      LET g_lui.luilegal = g_legal
      LET g_lui.lui09 = 0
      LET g_lui.lui10 = 0
      LET g_lui.lui11 = g_user
      LET g_lui.lui12 = g_grup
      LET g_lui.lui15 = 'N'     #FUN-C20009
      LET g_lui.luiconf = 'N'
      CALL t611_i("a")
      IF INT_FLAG THEN
         INITIALIZE g_lui.* TO NULL
         CLEAR FORM
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL s_auto_assign_no("art",g_lui.lui01,g_today,"B1","lui_file","lui01","","","")
        RETURNING li_result,g_lui.lui01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lui.lui01
      IF cl_null(g_lui.lui01) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK
      INSERT INTO lui_file VALUES (g_lui.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lui_file",
                      g_lui.lui01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         MESSAGE ""
         COMMIT WORK
         CALL cl_flow_notify(g_lui.lui01,'I')
      END IF
      SELECT lui01 INTO g_lui.lui01 FROM lui_file
       WHERE lui01 = g_lui.lui01
      LET g_lui01_t = g_lui.lui01
      LET g_lui_t.* = g_lui.*
      LET g_lui_o.* = g_lui.*
      CALL g_luj.clear()
      LET g_rec_b = 0
     #IF NOT cl_null(g_lui.lui04) THEN
         IF cl_confirm('alm1249') THEN
            CALL t611_ins_luj()    
            CALL t611_b_fill(" 1=1")
         END IF 
     #END IF 
      CALL t611_b()
      EXIT WHILE
   END WHILE

END FUNCTION

#By shi 重新调整
FUNCTION t611_ins_luj()
   DEFINE l_luj    RECORD LIKE luj_file.*
   DEFINE l_lub    RECORD LIKE lub_file.*
   DEFINE l_luj06  LIKE luj_file.luj06
   DEFINE l_lup06  LIKE lup_file.lup06

   LET g_sql = "SELECT lub_file.* FROM lub_file,lua_file",
               " WHERE lub01 = lua01 ",
               "   AND lub13 = 'N' ",
               "   AND lub09 <> '10' ",        #FUN-C30072  add 
               "   AND lua15 = 'Y' "
   IF NOT cl_null(g_lui.lui04) THEN
      LET g_sql = g_sql CLIPPED,"   AND lub01 = '",g_lui.lui04,"'"
   ELSE
      LET g_sql = g_sql CLIPPED,"   AND lua06 = '",g_lui.lui05,"'"
      IF NOT cl_null(g_lui.lui06) THEN
         LET g_sql = g_sql CLIPPED,"   AND lua07 = '",g_lui.lui06,"'"
      END IF
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY lub01,lub02 "
   PREPARE t611_pb1 FROM g_sql
   DECLARE luj_cs1 CURSOR FOR t611_pb1
   FOREACH luj_cs1 INTO l_lub.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_lup06 = 0 #TQC-C30027
      LET l_luj06 = 0 #TQC-C30027
      #汇总已支出金额,不区分审核/未审核
      IF l_lub.lub04t < 0 THEN
         SELECT SUM(lup06) INTO l_lup06
           FROM lup_file,luo_file
          WHERE lup01 = luo01
            AND luo03 = '2'
            AND lup03 = l_lub.lub01
            AND lup04 = l_lub.lub02
            AND luoconf <> 'X' #CHI-C80041
      END IF
      IF cl_null(l_lup06) THEN LET l_lup06 = 0 END IF

      #汇总已交款金额，不区分审核/未审核
      SELECT sum(luj06) INTO l_luj06
        FROM luj_file,lui_file
       WHERE lui01 = luj01
         AND luj03 = l_lub.lub01
         AND luj04 = l_lub.lub02
         AND luiconf <> 'X'  #CHI-C80041
      IF cl_null(l_luj06) THEN LET l_luj06=0 END IF

      LET l_luj.luj06 = l_lub.lub04t - l_luj06 + l_lup06
      IF l_luj.luj06 = 0 THEN 
          CONTINUE FOREACH
      END IF 

      LET l_luj.luj01 = g_lui.lui01
      SELECT MAX(luj02) + 1 INTO l_luj.luj02
        FROM luj_file
       WHERE luj01 = g_lui.lui01
      IF cl_null(l_luj.luj02) THEN
         LET l_luj.luj02 = 1
      END IF 
      LET l_luj.luj03 = l_lub.lub01
      LET l_luj.luj04 = l_lub.lub02
      LET l_luj.luj05 = l_lub.lub03
      LET l_luj.luj07 = NULL
      LET l_luj.lujplant = g_lui.luiplant
      LET l_luj.lujlegal = g_lui.luilegal       
      INSERT INTO luj_file VALUES l_luj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lui_file",g_lui.lui01,"",SQLCA.sqlcode,"","",1)
         CONTINUE FOREACH
      END IF 
   END FOREACH
   #只要有一个大于0就产生到单身，删除同一个费用编号都小于0的项次
   DELETE FROM luj_file WHERE luj01 = g_lui.lui01
                          AND luj05 NOT IN (SELECT DISTINCT luj05 FROM luj_file
                                             WHERE luj01 = g_lui.lui01
                                               AND luj06 > 0  )
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","lui_file",g_lui.lui01,"",SQLCA.sqlcode,"","",1)
   END IF
   SELECT SUM(luj06) INTO g_lui.lui09
     FROM luj_file
    WHERE luj01 = g_lui.lui01
   UPDATE lui_file SET lui09 = g_lui.lui09
    WHERE lui01 = g_lui.lui01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lui_file",g_lui.lui01,"",SQLCA.sqlcode,"","",1)
   END IF
   DISPLAY BY NAME g_lui.lui09
END FUNCTION 

FUNCTION t611_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lui.lui01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lui.luiconf = 'F' THEN
      CALL cl_err(g_lui.lui01,'alm1061',0)
      RETURN
   END IF

   IF g_lui.luiconf = 'Y' THEN
      CALL cl_err(g_lui.lui01,'alm1061',0)
      RETURN
   END IF
   IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
   SELECT * INTO g_lui.* FROM lui_file
    WHERE lui01=g_lui.lui01

   MESSAGE ""
   LET g_lui01_t = g_lui.lui01
   BEGIN WORK

   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t611_cl INTO g_lui.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
       CLOSE t611_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t611_show()

   WHILE TRUE
      LET g_lui01_t = g_lui.lui01
      LET g_lui_o.* = g_lui.*
      LET g_lui.luimodu=g_user
      LET g_lui.luidate=g_today
      
      CALL t611_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lui.*=g_lui_t.*
         CALL t611_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_lui.lui01 != g_lui01_t THEN
         UPDATE luj_file SET luj01 = g_lui.lui01
          WHERE luj01 = g_lui01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","luj_file",g_lui01_t,
                         "",SQLCA.sqlcode,"","luj",1)
            CONTINUE WHILE
         END IF
      END IF

      UPDATE lui_file SET lui_file.* = g_lui.*
       WHERE lui01 = g_lui.lui01

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lui_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t611_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lui.lui01,'U')
   CALL t611_b_fill("1=1")
   CALL t611_bp_refresh()

END FUNCTION

FUNCTION t611_plant_desc()
   DEFINE l_rtz13    LIKE rtz_file.rtz13
   DEFINE l_azt02    LIKE azt_file.azt02
   SELECT rtz13 INTO l_rtz13 FROM rtz_file
    WHERE rtz01 = g_plant
   SELECT azt02 INTO l_azt02 FROM azt_file
    WHERE azt01 = g_legal
   DISPLAY l_rtz13 TO rtz13
   DISPLAY l_azt02 TO azt02   
END FUNCTION 

FUNCTION t611_i(p_cmd)
   DEFINE  l_n       LIKE type_file.num5,
           p_cmd     LIKE type_file.chr1
   DEFINE li_result  LIKE type_file.num5
   DEFINE l_rtz13    LIKE rtz_file.rtz13
   DEFINE l_azt02    LIKE azt_file.azt02 
   DEFINE l_lnt30    LIKE lnt_file.lnt30
   DEFINE l_tqa02    LIKE tqa_file.tqa02
   DEFINE g_t1       LIKE oay_file.oayslip
   DEFINE l_ooz09    LIKE ooz_file.ooz09
   SELECT ooz09 INTO l_ooz09 FROM ooz_file
   IF s_shut(0) THEN
      RETURN
   END IF
   DISPLAY BY NAME g_lui.luiplant,g_lui.luilegal,g_lui.luiuser,g_lui.luimodu,
                   g_lui.luiconf,g_lui.luicrat,g_lui.luigrup,g_lui.luidate,g_lui.luiacti,
                   g_lui.luioriu,g_lui.luiorig,g_lui.lui15 #FUN-C20009
   CALL t611_plant_desc()
   CALL t611_lui11('d')
   CALL t611_lui12()
   INPUT BY NAME g_lui.lui01,g_lui.lui02,g_lui.lui03,g_lui.lui04,
                 g_lui.luiplant,g_lui.luilegal,g_lui.lui05,
                 g_lui.lui06,g_lui.lui07,g_lui.lui08,g_lui.lui09,
                 g_lui.lui10,g_lui.lui11,g_lui.lui12,g_lui.lui13
      WITHOUT DEFAULTS
  
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t611_set_entry(p_cmd)
         CALL t611_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lui01")
      AFTER FIELD lui01
         IF NOT cl_null(g_lui.lui01) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lui_t.lui01 <> g_lui.lui01) THEN
                 CALL s_check_no("art",g_lui.lui01,g_lui.lui01,"B1","lui_file","lui01","")
                      RETURNING li_result,g_lui.lui01
                 IF (NOT li_result) THEN
                    LET g_lui.lui01 = g_lui_t.lui01
                    NEXT FIELD lui01
                 END IF
             END IF
          END IF

      AFTER FIELD lui03
         IF NOT cl_null(g_lui.lui03) THEN 
            IF g_lui.lui02 <= l_ooz09 THEN
                LET g_lui.lui03 = l_ooz09 + 1
                CALL  cl_err('','alm1276',0)           #立账日期不可以小于关帐日期 
                NEXT FIELD lui03
            END IF 
         END IF 

      AFTER FIELD lui04 
         IF NOT cl_null(g_lui.lui04) THEN
            CALL t611_lui04()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui04 = g_lui_t.lui04
               NEXT FIELD lui04
            END IF 
            #FUN-C30072 add begin ---
            CALL t611_chk_lui04_luj03(g_lui.lui04)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui04 = g_lui_t.lui04
               NEXT FIELD lui04
            END IF
            #FUN-C30072 add end ----
            CALL t611_lui04_desc()
            CALL cl_set_comp_entry("lui05,lui06,lui07",FALSE)
         ELSE 
            LET g_lui.lui05 = g_lui_t.lui05
            LET g_lui.lui06 = g_lui_t.lui06
            LET g_lui.lui07 = g_lui_t.lui07
            CALL cl_set_comp_entry("lui05,lui06,lui07",TRUE)
         END IF 

      AFTER FIELD lui05
         IF NOT cl_null(g_lui.lui05) THEN
            CALL t611_lui05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui05 = g_lui_t.lui05
               NEXT FIELD lui05
            END IF 
            IF NOT cl_null(g_lui.lui04) THEN 
               CALL t611_lui04_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lui.lui05 = g_lui_t.lui05
                  NEXT FIELD lui05
               END IF
            END IF 
            CALL t611_chk_lui07()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui05 = g_lui_t.lui05
               NEXT FIELD lui05
            END IF

            #带出主品牌
            IF cl_null(g_lui.lui07) THEN   
               SELECT lne08 INTO l_lnt30
                 FROM lne_file 
                WHERE lne01 = g_lui.lui05
               SELECT tqa02 INTO l_tqa02 FROM tqa_file
                WHERE tqa01 = l_lnt30
                  AND tqa03 = '2'
               DISPLAY l_lnt30 TO lnt30   
               DISPLAY l_tqa02 TO tqa02 
            END IF  
         END IF 

      AFTER FIELD lui06
         IF NOT cl_null(g_lui.lui06) THEN
            CALL t611_lui06()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui06 = g_lui_t.lui06
               NEXT FIELD lui06
            END IF 
            IF NOT cl_null(g_lui.lui04) THEN
               CALL t611_lui04_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lui.lui06 = g_lui_t.lui06
                  NEXT FIELD lui06
               END IF
            END IF
            CALL t611_chk_lui07()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui06 = g_lui_t.lui06
               NEXT FIELD lui06
            END IF 
         END IF 

      AFTER FIELD lui07
         IF NOT cl_null(g_lui.lui07) THEN
            CALL t611_lui07(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui07 = g_lui_t.lui07
               NEXT FIELD lui07
            END IF
            IF NOT cl_null(g_lui.lui04) THEN
               CALL t611_lui04_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lui.lui07 = g_lui_t.lui07
                  NEXT FIELD lui07
               END IF
            END IF
            IF NOT cl_null(g_lui.lui05) OR NOT cl_null(g_lui.lui06) THEN 
               CALL t611_chk_lui07()          #判断合同商户、摊位是否与当前作业一致
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lui.lui07 = g_lui_t.lui07
                  NEXT FIELD lui07
               END IF    
            END IF 
            CALL t611_lui07_show()            #带出对应的商户和摊位以及其他栏位值
            CALL cl_set_comp_entry("lui05,lui06",FALSE)
         ELSE
#           LET g_lui.lui05 = g_lui_t.lui05     #FUN-C30072 MARK  
#           LET g_lui.lui06 = g_lui_t.lui06     #FUN-C30072 MARK
            CALL cl_set_comp_entry("lui05,lui06,lui07",TRUE)
         END IF 

      AFTER FIELD lui11
         IF NOT cl_null(g_lui.lui11) THEN
            CALL t611_lui11(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               #LET g_lui.lui11 = g_lui_t.lui11    #TQC-C30290 mark
               LET g_lui.lui11 = g_lui_o.lui11     #TQC-C30290 add
               NEXT FIELD lui11
            END IF 
         END IF 
         
      AFTER FIELD lui12
         IF NOT cl_null(g_lui.lui12) THEN
            CALL t611_lui12()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lui.lui12 = g_lui_t.lui12    
               NEXT FIELD lui12
            END IF 
         END IF 
         
      ON ACTION controlp
         CASE
             #交款单单别开窗
             WHEN INFIELD(lui01)
                  LET g_t1 = s_get_doc_no(g_lui.lui01)
                  CALL q_oay(FALSE,FALSE,'','B1','ART') RETURNING g_t1
                  LET g_lui.lui01 = g_t1
                  DISPLAY BY NAME g_lui.lui01
                  NEXT FIELD lui01
             WHEN INFIELD(lui04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_lua_1"
                  LET g_qryparam.default1=g_lui.lui04
                  CALL cl_create_qry() RETURNING g_lui.lui04
                  DISPLAY BY NAME g_lui.lui04
                  CALL t611_lui04()
                  NEXT FIELD lui04
             WHEN INFIELD(lui05)  
                  CALL cl_init_qry_var()
                  LET  g_qryparam.form="q_occ"
                  CALL cl_create_qry() RETURNING g_lui.lui05
                  DISPLAY BY NAME g_lui.lui05
                  CALL t611_lui05('d')
                  NEXT FIELD lui05
             WHEN INFIELD(lui06)  
                  CALL cl_init_qry_var()
                  LET  g_qryparam.form="q_lmf03"
                  LET g_qryparam.arg1 = g_plant
                  LET g_qryparam.default1 = g_lui.lui06
                  CALL cl_create_qry() RETURNING g_lui.lui06
                  DISPLAY BY NAME g_lui.lui06
                  CALL t611_lui06()
                  NEXT FIELD lui06
             WHEN INFIELD(lui07)  
                  CALL cl_init_qry_var()
                  LET  g_qryparam.form="q_lnt"
                  CALL cl_create_qry() RETURNING g_lui.lui07
                  CALL t611_lui07('d')
                  DISPLAY BY NAME g_lui.lui07
                  NEXT FIELD lui07
             WHEN INFIELD(lui11)  
                  CALL cl_init_qry_var()
                  LET  g_qryparam.form="q_gen"
                  CALL cl_create_qry() RETURNING g_lui.lui11
                  DISPLAY BY NAME g_lui.lui11
                  CALL t611_lui11('d')
                  NEXT FIELD lui11
             WHEN INFIELD(lui12)  
                  CALL cl_init_qry_var()
                  LET  g_qryparam.form="q_gem"
                  CALL cl_create_qry() RETURNING g_lui.lui12
                  DISPLAY BY NAME g_lui.lui12
                  CALL t611_lui12()
                  NEXT FIELD lui12        
          END CASE         

      
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

FUNCTION t611_lui04()
   DEFINE l_lua37  LIKE lua_file.lua37,   #直接收款
          l_lua08t LIKE lua_file.lua08t,  #含税金额
          l_lua35  LIKE lua_file.lua35,   #已收金额 
          l_lua36  LIKE lua_file.lua36,   #清算金额
          l_lua14  LIKE lua_file.lua14,   #结案否
          l_lua15  LIKE lua_file.lua15    #审核码 
   LET g_errno = ''       
   SELECT lua14,lua37,lua08t,lua35,lua36,lua15
     INTO l_lua14,l_lua37,l_lua08t,l_lua35,l_lua36,l_lua15
     FROM lua_file 
    WHERE lua01 = g_lui.lui04
    CASE 
       WHEN SQLCA.SQLCODE = 100          LET g_errno = 'alm-112'        #无此费用单 
       WHEN l_lua08t-l_lua35-l_lua36 = 0 LET g_errno = 'alm1277'        #费用已收 
       WHEN l_lua15 <> 'Y'               LET g_errno = 'alm-110'        #费用单未审核
       WHEN l_lua37 = 'Y'                LET g_errno = 'art-758'        #费用单直接收款时，不可通过交款单交款！    
       WHEN l_lua14 = '2'                LET g_errno = 'alm1529'        #费用单已结案，不可交款
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE 
END FUNCTION 

#FUN-C30072 add begin ---
FUNCTION t611_chk_lui04_luj03(p_no)
   DEFINE p_no  LIKE lua_file.lua01
   DEFINE l_cnt LIKE type_file.num10
   SELECT COUNT(*) INTO l_cnt
     FROM lub_file
    WHERE lub01 = p_no
      AND lub09 = '10'
   IF l_cnt > 0 THEN
      LET g_errno = 'art1065'       #费用支出类型的费用单，不允许录入
   END IF
END FUNCTION
#FUN-C30072 add end ----

FUNCTION t611_lui04_desc()
   DEFINE l_occ02 LIKE occ_file.occ02
   SELECT lua06,lua07,lua04,lua20
     INTO g_lui.lui05,g_lui.lui06,g_lui.lui07,g_lui.lui08
     FROM lua_file
    WHERE lua01 = g_lui.lui04
   DISPLAY BY NAME g_lui.lui05,g_lui.lui06,g_lui.lui07,g_lui.lui08
   SELECT occ02 INTO l_occ02
     FROM occ_file
    WHERE occ01 = g_lui.lui05
      AND occ06 IN ('1','3')
   DISPLAY l_occ02 TO lui05_desc
END FUNCTION 

FUNCTION t611_lui04_chk()
   DEFINE l_lua06  LIKE lua_file.lua06,
          l_lua07  LIKE lua_file.lua07,
          l_lua04  LIKE lua_file.lua04,
          l_lua20  LIKE lua_file.lua20
   LET g_errno = ''
   SELECT lua06,lua07,lua04,lua20
     INTO l_lua06,l_lua07,l_lua04,l_lua20
     FROM lua_file
    WHERE lua01 = g_lui.lui04
   IF g_lui.lui05 <> l_lua06 OR (cl_null(l_lua06) AND NOT cl_null(g_lui.lui05)) THEN 
      LET g_errno = 'alm1323'
   END IF 
   IF g_lui.lui06 <> l_lua07 OR (cl_null(l_lua07) AND NOT cl_null(g_lui.lui06)) THEN
      LET g_errno = 'alm1324'
      RETURN
   END IF
   IF g_lui.lui07 <> l_lua04 OR (cl_null(l_lua04) AND NOT cl_null(g_lui.lui07)) THEN
      LET g_errno = 'alm1325'
      RETURN
   END IF

END FUNCTION 

FUNCTION t611_lui05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_occacti LIKE occ_file.occacti
   DEFINE l_occ02   LIKE occ_file.occ02
   DEFINE l_occ1004 LIKE occ_file.occ1004
   LET g_errno = ''
   SELECT occacti,occ02,occ1004 INTO l_occacti,l_occ02,l_occ1004
     FROM occ_file 
    WHERE occ01 = g_lui.lui05
      AND occ06 IN ('1','3')
   CASE 
      WHEN SQLCA.SQLCODE = 100   LET g_errno = 'alm1278'           #无此商户编号
      WHEN l_occacti <> 'Y'      LET g_errno = 'alm1279'           #此商户编号无效
                                 LET l_occ02 = ''
      WHEN l_occ1004 <> '1'      LET g_errno = 'alm-997'    #未审核
                                 LET l_occ02 = ''
      OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE 
   IF p_cmd= 'd' OR cl_null(g_errno) THEN 
       DISPLAY l_occ02 TO lui05_desc
   END IF   
END FUNCTION 

FUNCTION t611_lui06()
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_lmf06   LIKE lmf_file.lmf06
   DEFINE l_lmfacti LIKE lmf_file.lmfacti
   LET g_errno = ''
   SELECT lmf06,lmfacti INTO l_lmf06,l_lmfacti
     FROM lmf_file
    WHERE lmf01 = g_lui.lui06
      AND lmfstore = g_lui.luiplant
      AND lmflegal = g_lui.luilegal
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm-042'                #此摊位编号不存在
      WHEN l_lmf06 <> 'Y'      LET g_errno = 'alm1063'                #此摊位编号未审核
      WHEN l_lmfacti <> 'Y'    LET g_errno = 'alm-877'                #此摊位编号无效
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
END FUNCTION 

FUNCTION t611_lui07(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_lntacti LIKE lnt_file.lntacti
   DEFINE l_lnt26   LIKE lnt_file.lnt26
   LET g_errno = ''
   SELECT lnt26,lntacti INTO l_lnt26,l_lntacti
     FROM lnt_file 
    WHERE lnt01 = g_lui.lui07
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'alm1295'        #无此合同单号
      WHEN l_lnt26 <> 'Y'      LET g_errno = 'alm1041'        #合同未终审
      WHEN l_lntacti <> 'Y'    LET g_errno = 'alm1296'        #合同无效
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   
END FUNCTION 

#判断合同的商户，摊位是否与本作业的一致
FUNCTION t611_chk_lui07()
   DEFINE l_lnt04  LIKE lnt_file.lnt04
   DEFINE l_lnt06  LIKE lnt_file.lnt06
   LET g_errno = ''
   IF cl_null(g_lui.lui07) THEN 
      RETURN 
   END IF 
   SELECT lnt04,lnt06 INTO l_lnt04,l_lnt06
     FROM lnt_file 
    WHERE lnt01 = g_lui.lui07
   IF NOT cl_null(g_lui.lui05) AND cl_null(g_lui.lui06) THEN 
      IF g_lui.lui05 <> l_lnt04 THEN 
         LET g_errno = 'alm1306'             #商户编号与合同单对应的商户编号不一致
         RETURN 
      END IF 
   END IF 
   IF NOT cl_null(g_lui.lui06) AND cl_null(g_lui.lui05) THEN 
      IF g_lui.lui06 <> l_lnt06 THEN  #摊位编号与合同单对应的摊位编号不一致
         LET g_errno = 'alm1307'
         RETURN 
      END IF 
   END IF 
   IF NOT cl_null(g_lui.lui05) AND NOT cl_null(g_lui.lui06) THEN 
      IF g_lui.lui05 <> l_lnt04 AND g_lui.lui06 = l_lnt06 THEN
         LET g_errno = 'alm1308'             #商户编号与合同单对应的商户编号不一致 
         RETURN        
      END IF
      IF g_lui.lui05 = l_lnt04 AND g_lui.lui06 <> l_lnt06 THEN
         LET g_errno = 'alm1309'             #摊位编号与合同单对应的摊位编号不一致
         RETURN        
      END IF
      IF g_lui.lui05 <> l_lnt04 AND g_lui.lui06 <> l_lnt06 THEN
         LET g_errno = 'alm1310'             #商户编号、摊位编号与合同单对应的商户编号、摊位编号不一致 
         RETURN        
      END IF
   END IF 
END FUNCTION
 
#如果合同的商户与本作业一致，带出摊位以及其他栏位值
FUNCTION t611_lui07_show()
   DEFINE l_lnt30  LIKE lnt_file.lnt30
   DEFINE l_tqa02  LIKE tqa_file.tqa02
   DEFINE l_occ02  LIKE occ_file.occ02
   #通过合同单号带出版本号、商户号、摊位号
   SELECT lnt02,lnt04,lnt06,lnt30 
     INTO g_lui.lui08,g_lui.lui05,g_lui.lui06,l_lnt30
     FROM lnt_file 
    WHERE lnt01 = g_lui.lui07
   DISPLAY BY NAME g_lui.lui08,g_lui.lui05,g_lui.lui06
   SELECT tqa02 INTO l_tqa02 FROM tqa_file
    WHERE tqa01 = l_lnt30
      AND tqa03 = '2'
   SELECT occ02 INTO l_occ02
     FROM occ_file
    WHERE occ01 = g_lui.lui05
      AND occ06 IN ('1','3')   
   DISPLAY l_lnt30 TO lnt30
   DISPLAY l_tqa02 TO tqa02 
   DISPLAY l_occ02 TO lui05_desc
END FUNCTION 

FUNCTION t611_lui11(p_cmd)
   DEFINE l_genacti    LIKE gen_file.genacti
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE l_gen03      LIKE gen_file.gen03   #TQC-C30290  add
   
   LET g_errno = ''
   SELECT genacti,gen02,gen03
     #INTO l_genacti,g_gen02,g_lui.lui12      #TQC-C30290 mark   
     INTO l_genacti,g_gen02,l_gen03           #TQC-C30290 add
     FROM gen_file
    WHERE gen01 = g_lui.lui11
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-207'       #此业务员不存在
                               LET g_gen02 = ''
                               #LET g_lui.lui12 = ''         #TQC-C30290 mark 
      WHEN l_genacti <> 'Y'    LET g_errno = 'alm-879'       #此业务员无效
                               LET g_gen02 = ''
                               #LET g_lui.lui12 = ''         #TQC-C30290 mark
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd= 'd' OR cl_null(g_errno) THEN
      #TQC-C30290--start add---------------------------------------
      IF cl_null(g_lui.lui12) OR (NOT cl_null(g_lui_o.lui11) AND g_lui.lui11 <> g_lui_o.lui11) 
         OR cl_null(g_lui_o.lui11 ) THEN 
         LET g_lui_o.lui11 = g_lui.lui11                           
         IF p_cmd <> 'd' THEN
      #TQC-C30290--end add----------------------------------------- 
            SELECT gem02 INTO l_gem02
              FROM gem_file
             #WHERE gem01 = g_lui.lui12    #TQC-C30290 mark
      #TQC-C30290--start add-----
             WHERE gem01 = l_gen03         
            LET g_lui.lui12 = l_gen03  
            DISPLAY l_gem02 TO gem02  
         END IF  
      END IF                         
      #TQC-C30290--end add----------
   END IF
   DISPLAY g_gen02 TO gen02
   #DISPLAY l_gem02 TO gem02         #TQC-C30290 mark 
   DISPLAY BY NAME g_lui.lui12       #TQC-C30290 add
END FUNCTION 

FUNCTION t611_lui12()
DEFINE l_gemacti    LIKE gem_file.gemacti
DEFINE l_n          LIKE type_file.num5
   LET g_errno = ''
   SELECT gemacti,gem02
     INTO l_gemacti,g_gem02
     FROM gem_file
    WHERE gem01 = g_lui.lui12
   CASE
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'      #部门编号不存在
                               LET g_gem02 = ''
      WHEN l_gemacti <> 'Y'    LET g_errno = 'asf-472'      #部门编号无效
                               LET g_gem02 = ''
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   #TQC-C30290--start mark------------------------------
   #IF NOT cl_null(g_lui.lui11) AND cl_null(g_errno) THEN
   #   SELECT COUNT(*) INTO l_n
   #     FROM gen_file,gem_file
   #    WHERE gen01 = g_lui.lui11
   #      AND gen03 = gem01
   #      AND gem01 = g_lui.lui12
   #  IF l_n = 0 THEN
   #     LET g_errno = 'apj-033'
   #     RETURN
   #  END IF
   #END IF
   #TQC-C30290--end mark--------------------------------
   DISPLAY g_gem02 TO gem02
END FUNCTION

FUNCTION t611_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CLEAR FORM
   CALL g_luj.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t611_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lui.* TO NULL
      RETURN
   END IF

   OPEN t611_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lui.* TO NULL
   ELSE
      OPEN t611_count
      FETCH t611_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t611_fetch('F')
   END IF

END FUNCTION

FUNCTION t611_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t611_cs INTO g_lui.lui01
      WHEN 'P' FETCH PREVIOUS t611_cs INTO g_lui.lui01
      WHEN 'F' FETCH FIRST    t611_cs INTO g_lui.lui01
      WHEN 'L' FETCH LAST     t611_cs INTO g_lui.lui01
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
            FETCH ABSOLUTE g_jump t611_cs INTO g_lui.lui01
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
      INITIALIZE g_lui.* TO NULL
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

   SELECT * INTO g_lui.* FROM lui_file WHERE lui01 = g_lui.lui01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lui_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lui.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_lui.luiuser
   LET g_data_group = g_lui.luigrup
   CALL t611_show()

END FUNCTION

FUNCTION t611_show()
   DEFINE l_lnt30    LIKE lnt_file.lnt30
   DEFINE l_tqa02    LIKE tqa_file.tqa02
   DEFINE l_gen02    LIKE gen_file.gen02
   DEFINE l_amt      LIKE lui_file.lui10
   LET g_lui_t.* = g_lui.*
   LET g_lui_o.* = g_lui.*
   DISPLAY BY NAME g_lui.lui01,g_lui.lui02,g_lui.lui03,g_lui.lui04,
                   g_lui.luiplant,g_lui.luilegal,g_lui.lui05,
                   g_lui.lui06,g_lui.lui07,g_lui.lui08,g_lui.lui09,
                   g_lui.lui15,  #FUN-C20009
                   g_lui.lui10,g_lui.lui11,g_lui.lui12,g_lui.lui14,
                   g_lui.luiconf,g_lui.luiconu,g_lui.luicont,g_lui.luicond,g_lui.lui13,
                   g_lui.luiuser,g_lui.luigrup,
                   g_lui.luioriu,g_lui.luimodu,
                   g_lui.luidate,g_lui.luiorig,
                   g_lui.luiacti,g_lui.luicrat
   CALL t611_plant_desc()
   CALL t611_lui11('d')
   CALL t611_lui12()
   CALL t611_lui05('d')
   CALL t611_lui07_show()
   IF cl_null(g_lui.lui07) THEN
      SELECT lne08 INTO l_lnt30
        FROM lne_file
       WHERE lne01 = g_lui.lui05
      SELECT tqa02 INTO l_tqa02 FROM tqa_file
       WHERE tqa01 = l_lnt30
         AND tqa03 = '2'
      DISPLAY l_lnt30 TO lnt30
      DISPLAY l_tqa02 TO tqa02
   END IF 
   SELECT gen02 INTO l_gen02 
     FROM gen_file
    WHERE gen01 = g_lui.luiconu
   DISPLAY l_gen02 TO gen02_1
   LET l_amt = g_lui.lui09 - g_lui.lui10
   DISPLAY l_amt TO amt
   #CALL cl_set_field_pic(g_lui.luiconf,"","","","","")  #CHI-C80041
   IF g_lui.luiconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF   #CHI-C80041
   CALL cl_set_field_pic(g_lui.luiconf,"","","",g_void,"")  #CHI-C80041
   CALL t611_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t611_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lui.lui01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lui.luiconf <> 'N' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   
   SELECT * INTO g_lui.* FROM lui_file
    WHERE lui01=g_lui.lui01
   BEGIN WORK

   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t611_cl INTO g_lui.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t611_show()

   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "lui01"
       LET g_doc.value1 = g_lui.lui01
       CALL cl_del_doc()
      DELETE FROM lui_file WHERE lui01 = g_lui.lui01
      DELETE FROM luj_file WHERE luj01 = g_lui.lui01
      CLEAR FORM
      CALL g_luj.clear()
      OPEN t611_count
      FETCH t611_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t611_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t611_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t611_fetch('/')
      END IF
   END IF
   CLOSE t611_cl
   COMMIT WORK
END FUNCTION

FUNCTION t611_b()
DEFINE
    l_n             LIKE type_file.num5,
    l_luj06         LIKE luj_file.luj06,
    l_lup06         LIKE lup_file.lup06,
    l_i1            LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_ac_t          LIKE type_file.num5   #FUN-D30033 add

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lui.lui01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_lui.* FROM lui_file
     WHERE lui01=g_lui.lui01

    IF g_lui.luiconf = 'F' THEN
       CALL cl_err(g_lui.lui01,'alm1061',0)
       RETURN
    END IF

    IF g_lui.luiconf = 'Y' THEN
       CALL cl_err(g_lui.lui01,'alm1061',0)
       RETURN
    END IF 
    IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
    LET g_forupd_sql = "SELECT luj02,luj03,luj04,luj05,'','','','','','','',",
                       "  luj06,'','','','',luj07",
                       "  FROM luj_file",
                       "  WHERE luj01=? AND luj02=? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t611_bcl CURSOR FROM g_forupd_sql

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_luj WITHOUT DEFAULTS FROM s_luj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_aza.aza63 = 'Y' THEN 
              CALL cl_set_comp_visible("oaj041,aag02_1",TRUE)
           ELSE 
              CALL cl_set_comp_visible("oaj041,aag02_1",FALSE)   
           END IF 
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
           OPEN t611_cl USING g_lui.lui01
           IF STATUS THEN
              CALL cl_err("OPEN t611_cl:", STATUS, 1)
              CLOSE t611_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t611_cl INTO g_lui.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
              CLOSE t611_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_luj_t.* = g_luj[l_ac].*
              OPEN t611_bcl USING g_lui.lui01,g_luj_t.luj02
              IF STATUS THEN
                 CALL cl_err("OPEN t611_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t611_bcl INTO g_luj[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_luj_t.luj02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t611_luj03('d')
                 CALL t611_luj04('d')
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_luj[l_ac].* TO NULL
           IF NOT cl_null(g_lui.lui04) THEN 
              LET g_luj[l_ac].luj03 = g_lui.lui04
           END IF 
           LET g_luj_t.* = g_luj[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD luj02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           ELSE 
              INSERT INTO luj_file(luj01,luj02,luj03,luj04,luj05,luj06,
                                   luj07,lujlegal,lujplant)
               VALUES(g_lui.lui01,g_luj[l_ac].luj02,
                     g_luj[l_ac].luj03,g_luj[l_ac].luj04,
                     g_luj[l_ac].luj05,g_luj[l_ac].luj06,
                     g_luj[l_ac].luj07,g_legal,g_plant)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","luj_file",g_lui.lui01,
                             g_luj[l_ac].luj02,SQLCA.sqlcode,"","",1)
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 LET g_success = 'Y'
                 LET g_rec_b=g_rec_b+1
                 DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
           END IF 

        BEFORE FIELD luj02
           IF g_luj[l_ac].luj02 IS NULL OR g_luj[l_ac].luj02 = 0 THEN
              SELECT max(luj02)+1
                INTO g_luj[l_ac].luj02
                FROM luj_file
               WHERE luj01 = g_lui.lui01
              IF g_luj[l_ac].luj02 IS NULL THEN
                 LET g_luj[l_ac].luj02 = 1
              END IF
           END IF

        AFTER FIELD luj02
           IF NOT cl_null(g_luj[l_ac].luj02) THEN
              IF (g_luj[l_ac].luj02 != g_luj_t.luj02
                  AND NOT cl_null(g_luj_t.luj02))
                 OR g_luj_t.luj02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM luj_file
                  WHERE luj01 = g_lui.lui01
                    AND luj02 = g_luj[l_ac].luj02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_luj[l_ac].luj02 = g_luj_t.luj02
                    NEXT FIELD luj02
                 END IF
              END IF
           END IF

        #费用单号控管
        AFTER FIELD luj03
           IF NOT cl_null(g_luj[l_ac].luj03) THEN
              #FUN-C30072 add begin ---
              CALL t611_chk_lui04_luj03(g_luj[l_ac].luj03)
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_luj[l_ac].luj03 = g_luj_t.luj03
                  NEXT FIELD luj03
              END IF
              #FUN-C30072 add end -----
              IF NOT cl_null(g_luj[l_ac].luj04) AND 
                 (p_cmd = 'a' OR (p_cmd = 'd' AND g_luj_t.luj03 != g_luj[l_ac].luj03)) THEN
                 SELECT COUNT(*) INTO l_n
                   FROM luj_file 
                  WHERE luj01 = g_lui.lui01
                    AND luj03 = g_luj[l_ac].luj03
                    AND luj04 = g_luj[l_ac].luj04
                 IF l_n > 0 THEN 
                    LET g_luj[l_ac].luj03 = g_luj_t.luj03 
                    CALL cl_err('','alm1322',0)
                    NEXT FIELD luj03
                 END IF 
              END IF 
              CALL t611_luj03(p_cmd)
              IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  LET g_luj[l_ac].luj03 = g_luj_t.luj03
                  NEXT FIELD luj03
              END IF
              CALL t611_luj04(p_cmd)          #费用单号+项次带出费用编号、类型、日期等
              IF NOT cl_null(g_errno) THEN 
                  CALL cl_err('',g_errno,0)
                  LET g_luj[l_ac].luj03 = g_luj_t.luj03
                  NEXT FIELD luj03
              END IF 
           END IF  
           
        #费用单项次控管
        AFTER FIELD luj04
           IF NOT cl_null(g_luj[l_ac].luj04) THEN 
              IF NOT cl_null(g_luj[l_ac].luj03) AND 
                 (p_cmd = 'a' OR (p_cmd = 'd' AND g_luj_t.luj04 != g_luj[l_ac].luj04)) THEN
                 SELECT COUNT(*) INTO l_n
                   FROM luj_file
                  WHERE luj01 = g_lui.lui01
                    AND luj03 = g_luj[l_ac].luj03
                    AND luj04 = g_luj[l_ac].luj04
                 IF l_n > 0 THEN
                    LET g_luj[l_ac].luj04 = g_luj_t.luj04
                    CALL cl_err('','alm1322',0)
                    NEXT FIELD luj03
                 END IF
              END IF
              CALL t611_luj04(p_cmd)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,0)
                 LET g_luj[l_ac].luj04 = g_luj_t.luj04
                 NEXT FIELD luj04
              END IF 
           END IF 

        #交款金额
        AFTER FIELD luj06
           IF NOT cl_null(g_luj[l_ac].luj06) THEN
              SELECT SUM(luj06) INTO l_luj06
                FROM luj_file
               WHERE luj03 = g_luj[l_ac].luj03
                 AND luj04 = g_luj[l_ac].luj04
                 AND NOT (luj01 = g_lui.lui01 AND luj02 = g_luj[l_ac].luj02)
              IF cl_null(l_luj06) THEN
                 LET l_luj06 = 0
              END IF
              #支出单支出金额
              SELECT SUM(lup06) INTO l_lup06
                FROM lup_file,luo_file
               WHERE lup01 = luo01
                 AND luo03 = '2'
                 AND lup03 = g_luj[l_ac].luj03
                 AND lup04 = g_luj[l_ac].luj04
                 AND luoconf <> 'X' #CHI-C80041
              IF cl_null(l_lup06) THEN
                 LET l_lup06 = 0
              END IF
              IF g_luj[l_ac].lub04t > 0 THEN 
                 IF g_luj[l_ac].luj06 <= 0 THEN 
                    LET g_luj[l_ac].luj06 = g_luj_t.luj06
                    CALL cl_err('','alm1441',0)
                    NEXT FIELD luj06
                 END IF 
                 IF g_luj[l_ac].luj06 > g_luj[l_ac].amt_1 THEN
                    LET g_luj[l_ac].luj06 = g_luj_t.luj06
                    CALL cl_err('','art-769',0)
                    NEXT FIELD luj06
                 END IF
                 #TQC-C30290--start add--------------------------
                 IF g_luj[l_ac].luj06 > g_luj[l_ac].lub04t-l_luj06+l_lup06 THEN
                    CALL cl_err('','art-771',0)  
                    LET g_luj[l_ac].luj06 = g_luj_t.luj06
                    NEXT FIELD luj06
                 END IF 
                 #TQC-C30290--end add----------------------------
              END IF
              IF g_luj[l_ac].lub04t < 0 THEN 
                 IF g_luj[l_ac].luj06 >= 0 THEN
                    LET g_luj[l_ac].luj06 = g_luj_t.luj06
                    CALL cl_err('','alm1440',0)
                    NEXT FIELD luj06
                 END IF
                 IF g_luj[l_ac].luj06 < g_luj[l_ac].lub04t-l_luj06+l_lup06 THEN   
                     LET g_luj[l_ac].luj06 = g_luj_t.luj06 
                     CALL cl_err('','art-771',0)
                     NEXT FIELD luj06
                 END IF
              END IF 
           END IF      

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_luj_t.luj02 > 0 AND g_luj_t.luj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM luj_file
               WHERE luj01 = g_lui.lui01
                 AND luj02 = g_luj_t.luj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","luj_file",g_lui.lui01,
                               g_luj_t.luj02,SQLCA.sqlcode,"","",1)
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
              LET g_luj[l_ac].* = g_luj_t.*
              CLOSE t611_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_luj[l_ac].luj02,-263,1)
              LET g_luj[l_ac].* = g_luj_t.*
           ELSE
              UPDATE luj_file SET luj02=g_luj[l_ac].luj02,
                                  luj03=g_luj[l_ac].luj03,
                                  luj04=g_luj[l_ac].luj04,
                                  luj05=g_luj[l_ac].luj05,
                                  luj06=g_luj[l_ac].luj06,
                                  luj07=g_luj[l_ac].luj07
               WHERE luj01=g_lui.lui01
                 AND luj02=g_luj_t.luj02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","luj_file",g_lui.lui01,
                               g_luj_t.luj02,SQLCA.sqlcode,"","",1)
                 LET g_luj[l_ac].* = g_luj_t.*
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
              IF p_cmd = 'a' THEN 
                 CALL g_luj.deleteElement(l_ac)
               #FUN-D30033--add--begin--
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
               #FUN-D30033--add--end----
              END IF 
              IF p_cmd = 'u' THEN
                 LET g_luj[l_ac].* = g_luj_t.*
              END IF
              CLOSE t611_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_success =  'N' THEN 
              CLOSE t611_bcl
              ROLLBACK WORK   
           ELSE 
              SELECT SUM(luj06) INTO g_lui.lui09
                FROM luj_file
               WHERE luj01 = g_lui.lui01
              UPDATE lui_file SET lui09 = g_lui.lui09
               WHERE lui01 = g_lui.lui01
              DISPLAY BY NAME g_lui.lui09
              DISPLAY g_lui.lui09-g_lui.lui10 TO amt
              CLOSE t611_bcl
           END IF 
           LET l_ac_t = l_ac   ##FUN-D30033 add

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()


        ON ACTION controlp
           CASE
             WHEN INFIELD(luj03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lua_1"
               LET g_qryparam.default1 = g_luj[l_ac].luj03
                 CALL cl_create_qry() RETURNING g_luj[l_ac].luj03
                  DISPLAY BY NAME g_luj[l_ac].luj03
                  NEXT FIELD luj03
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
    LET g_lui.luimodu = g_user
    LET g_lui.luidate = g_today
    UPDATE lui_file
    SET luimodu = g_lui.luimodu,
        luidate = g_lui.luidate
     WHERE lui01 = g_lui.lui01
    DISPLAY BY NAME g_lui.luimodu,g_lui.luidate
    END IF
    CLOSE t611_bcl
#   CALL t611_delall() #CHI-C30002 mark
    CALL t611_delHeader()     #CHI-C30002 add
    CALL t611_fill_head()
END FUNCTION

#By shi 重新调整
FUNCTION t611_luj03(p_cmd)
 DEFINE p_cmd    LIKE type_file.chr1
 DEFINE l_lua37  LIKE lua_file.lua37    #直接收款
 DEFINE l_lua08t LIKE lua_file.lua08t   #含税金额
 DEFINE l_lua35  LIKE lua_file.lua35    #已收金额 
 DEFINE l_lua36  LIKE lua_file.lua36    #清算金额
 DEFINE l_lua15  LIKE lua_file.lua15    #审核码 
 DEFINE l_lua04  LIKE lua_file.lua04   #合同编号
 DEFINE l_lua06  LIKE lua_file.lua06   #客户编号
 DEFINE l_lua07  LIKE lua_file.lua07   #摊位编号
 DEFINE l_lua14  LIKE lua_file.lua14
   LET g_errno = ''       
   SELECT lua04,lua06,lua07,lua37,lua08t,lua35,lua36,lua14,lua15
     INTO l_lua04,l_lua06,l_lua07,l_lua37,l_lua08t,l_lua35,l_lua36,l_lua14,l_lua15
     FROM lua_file 
    WHERE lua01 = g_luj[l_ac].luj03
    CASE 
       WHEN SQLCA.SQLCODE = 100          LET g_errno = 'alm-112'        #无此费用单 
       WHEN g_luj[l_ac].luj03 <> g_lui.lui04 AND NOT cl_null(g_lui.lui04)
                                         LET g_errno = 'alm1321'        #需与单头的费用单号一致
       WHEN l_lua15 <> 'Y'               LET g_errno = 'alm1290'        #费用单未审核
       WHEN l_lua04 <> g_lui.lui07 AND NOT cl_null(g_lui.lui07)
                                         LET g_errno = 'alm1291'        #费用单号对应的合同编号与单头不一致
       WHEN l_lua06 <> g_lui.lui05 AND NOT cl_null(g_lui.lui05)
                                         LET g_errno = 'alm1297'        #费用单号对应的商户编号与单头不一致
       WHEN l_lua07 <> g_lui.lui06 AND NOT cl_null(g_lui.lui06)
                                         LET g_errno = 'alm1298'        #费用单号对应的摊位编号与单头不一致
       WHEN l_lua08t-l_lua35-l_lua36 = 0 LET g_errno = 'alm1289'        #费用已收 
       WHEN l_lua14 = '2'                LET g_errno = 'alm1529'
       OTHERWISE                         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

#By shi 重新调整
FUNCTION t611_luj04(p_cmd)
 DEFINE p_cmd    LIKE type_file.chr1
 DEFINE l_lub03  LIKE lub_file.lub03   #费用编号
 DEFINE l_lub09  LIKE lub_file.lub09   #费用类型
 DEFINE l_lub07  LIKE lub_file.lub07   #开始日期
 DEFINE l_lub08  LIKE lub_file.lub08   #结束日期
 DEFINE l_lub04t LIKE lub_file.lub04t  #费用金额 
 DEFINE l_lub11  LIKE lub_file.lub11   #已收金额
 DEFINE l_lub12  LIKE lub_file.lub12   #清算金额
 DEFINE l_lub13  LIKE lub_file.lub13   #结案否
 DEFINE l_luj06  LIKE luj_file.luj06
 DEFINE l_lup06  LIKE lup_file.lup06  
#FUN-C10024--add--str--
DEFINE    l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--
   LET g_errno = ''
   IF cl_null(g_luj[l_ac].luj03) OR cl_null(g_luj[l_ac].luj04) THEN
      RETURN 
   END IF   
   SELECT lub03,lub09,lub07,lub08,lub04t,lub11,lub12,lub13
     INTO l_lub03,g_luj[l_ac].lub09,g_luj[l_ac].lub07,
          g_luj[l_ac].lub08,g_luj[l_ac].lub04t,g_luj[l_ac].lub11,l_lub12,l_lub13
     FROM lub_file
    WHERE lub01 = g_luj[l_ac].luj03
      AND lub02 = g_luj[l_ac].luj04
   CASE 
      WHEN SQLCA.SQLCODE = 100          LET g_errno = 'alm1299'        #无对应资料
      WHEN l_lub13 = 'Y'                LET g_errno = 'alm1300'        #已经结案
                                        LET g_luj[l_ac].luj05 = ''
      WHEN g_luj[l_ac].lub04t-g_luj[l_ac].lub11-l_lub12 = 0
                                        LET g_errno = 'alm1301'        #费用已交清
                                        LET g_luj[l_ac].luj05 = '' 
      OTHERWISE                         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE 
   IF cl_null(g_errno) THEN
      IF p_cmd <> 'd' THEN
         LET g_luj[l_ac].luj05 = l_lub03
      END IF
      SELECT oaj02,oaj04,oaj041 INTO g_luj[l_ac].oaj02,g_luj[l_ac].oaj04,g_luj[l_ac].oaj041
        FROM oaj_file
       WHERE oaj01 = g_luj[l_ac].luj05
       CALL s_get_bookno(YEAR(g_lui.lui02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
       SELECT aag02 INTO g_luj[l_ac].aag02
         FROM aag_file
        WHERE aag01 = g_luj[l_ac].oaj04
          #AND aag00=g_aza.aza81  #FUN-C10024
          AND aag00 =l_bookno1   #FUN-C10024 add

       SELECT aag02 INTO g_luj[l_ac].aag02_1
         FROM aag_file
        WHERE aag01 = g_luj[l_ac].oaj041
          #AND aag00=g_aza.aza82 #FUN-C10024
          AND aag00 =l_bookno2  #FUN-C10024 add
      LET g_luj[l_ac].amt_1 = g_luj[l_ac].lub04t - g_luj[l_ac].lub11 - l_lub12 
   END IF
   IF cl_null(g_errno) THEN
      IF (cl_null(g_luj_t.luj03) OR (NOT cl_null(g_luj_t.luj03) AND g_luj[l_ac].luj03 != g_luj_t.luj03)) OR
         (cl_null(g_luj_t.luj04) OR (NOT cl_null(g_luj_t.luj04) AND g_luj[l_ac].luj04 != g_luj_t.luj04)) THEN
         SELECT SUM(luj06) INTO l_luj06
           FROM luj_file
          WHERE luj03 = g_luj[l_ac].luj03
            AND luj04 = g_luj[l_ac].luj04
            AND NOT (luj01 = g_lui.lui01 AND luj02 = g_luj[l_ac].luj02)
         IF cl_null(l_luj06) THEN
            LET l_luj06 = 0
         END IF
         #支出单支出金额
         SELECT SUM(lup06) INTO l_lup06
           FROM lup_file,luo_file
          WHERE lup01 = luo01
            AND luo03 = '2'
            AND lup03 = g_luj[l_ac].luj03
            AND lup04 = g_luj[l_ac].luj04
            AND luoconf <> 'X' #CHI-C80041
         IF cl_null(l_lup06) THEN
            LET l_lup06 = 0
         END IF
         LET g_luj[l_ac].luj06 = g_luj[l_ac].lub04t-l_luj06+l_lup06
      END IF
   END IF    
END FUNCTION 

#CHI-C30002 -------- add -------- begin
FUNCTION t611_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lui.lui01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lui_file ",
                  "  WHERE lui01 LIKE '",l_slip,"%' ",
                  "    AND lui01 > '",g_lui.lui01,"'"
      PREPARE t611_pb2 FROM l_sql 
      EXECUTE t611_pb2 INTO l_cnt      
      
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
         CALL t611_v()
         IF g_lui.luiconf = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF 
         CALL cl_set_field_pic(g_lui.luiconf,"","","",g_void,"") 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  lui_file WHERE lui01 = g_lui.lui01
         INITIALIZE g_lui.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t611_delall()
#  SELECT COUNT(*) INTO g_cnt FROM luj_file
#   WHERE luj01 = g_lui.lui01
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM lui_file WHERE lui01 = g_lui.lui01
#  END IF

#END FUNCTION
#CHI-C30002 -------- mark -------- end


FUNCTION t611_b_fill(p_wc2)
   DEFINE p_wc2      STRING
   DEFINE l_lub12  LIKE lub_file.lub12   #清算金额
#FUN-C10024--add--str--
   DEFINE l_bookno1 LIKE aag_file.aag00,
          l_bookno2 LIKE aag_file.aag00,
          l_flag    LIKE type_file.chr1
#FUN-C10024--add--end--
   LET g_sql = "SELECT luj02,luj03,luj04,luj05,'','','','','','','',",
               "  luj06,'','','','',luj07",
               "  FROM luj_file",
               " WHERE luj01 ='",g_lui.lui01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY luj02 "

   PREPARE t611_pb FROM g_sql
   DECLARE luj_cs CURSOR FOR t611_pb

   CALL g_luj.clear()
   LET g_cnt = 1
   CALL s_get_bookno(YEAR(g_lui.lui02)) RETURNING l_flag,l_bookno1,l_bookno2   #FUN-C10024 add
   FOREACH luj_cs INTO g_luj[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT lub09,lub07,lub08,lub04t,lub11,lub12
        INTO g_luj[g_cnt].lub09,g_luj[g_cnt].lub07,
             g_luj[g_cnt].lub08,g_luj[g_cnt].lub04t,g_luj[g_cnt].lub11,l_lub12
        FROM lub_file
       WHERE lub01 = g_luj[g_cnt].luj03
         AND lub02 = g_luj[g_cnt].luj04
      IF cl_null(g_luj[g_cnt].lub11) THEN
         LET g_luj[g_cnt].lub11 = 0
      END IF
      IF cl_null(l_lub12) THEN
         LET l_lub12 = 0
      END IF
      LET g_luj[g_cnt].amt_1 = g_luj[g_cnt].lub04t-g_luj[g_cnt].lub11-l_lub12
      SELECT oaj02,oaj04,oaj041 INTO g_luj[g_cnt].oaj02,g_luj[g_cnt].oaj04,g_luj[g_cnt].oaj041
        FROM oaj_file
       WHERE oaj01 = g_luj[g_cnt].luj05

       SELECT aag02 INTO g_luj[g_cnt].aag02
         FROM aag_file
        WHERE aag01 = g_luj[g_cnt].oaj04
          #AND aag00=g_aza.aza81  #FUN-C10024
          AND aag00 =l_bookno1   #FUN-C10024 add


       SELECT aag02 INTO g_luj[g_cnt].aag02_1
         FROM aag_file
        WHERE aag01 = g_luj[g_cnt].oaj041
          #AND aag00=g_aza.aza82 #FUN-C10024
          AND aag00 =l_bookno2  #FUN-C10024 add
      LET g_errno = ' '
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_luj.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t611_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lui01,lui05,lui06,lui07,luj02",TRUE)
    END IF 
    IF cl_null(g_argv1) THEN
       CALL cl_set_comp_entry("lui04",TRUE)
    ELSE 
       CALL cl_set_comp_entry("lui04",FALSE)
    END IF
    IF NOT cl_null(g_lui.lui04) THEN 
       CALL cl_set_comp_entry("lui05,lui06,lui07",FALSE)
    ELSE 
       CALL cl_set_comp_entry("lui05,lui06,lui07",TRUE) 
    END IF 
    
END FUNCTION

FUNCTION t611_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lui01,lui04,lui05,lui06,lui07,luj02,",FALSE)
    END IF

END FUNCTION


FUNCTION t611_yes()                       #審核
   DEFINE  l_sql    STRING 
   DEFINE  l_gen02  LIKE gen_file.gen02
   DEFINE  l_n      LIKE luj_file.luj06
   DEFINE  l_luj05  LIKE luj_file.luj05
   IF cl_null(g_lui.lui01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
#CHI-C30107 -------- add ---------- begin
   IF g_lui.luiconf = 'Y' THEN
        CALL cl_err('','alm1318',0)
        RETURN
   END IF

   IF g_lui.luiconf = 'F' THEN
        CALL cl_err('','alm1319',0)
        RETURN
   END IF
   IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF NOT cl_confirm('alm-006') THEN
        RETURN
   END IF
#CHI-C30107 -------- add ---------- end
   SELECT * INTO g_lui.* FROM lui_file WHERE lui01=g_lui.lui01
   LET l_sql = "SELECT luj05,SUM(luj06) FROM luj_file ",
               "  WHERE luj01 = '",g_lui.lui01,"' group by luj05" 
   PREPARE t611_sel_luj3 FROM l_sql 
   DECLARE t611_sel_luj_cs3 CURSOR FOR t611_sel_luj3
   FOREACH t611_sel_luj_cs3 INTO l_luj05,l_n 
      IF STATUS THEN
         CALL s_errmsg("lui01",g_lui.lui01,"t611_sel_luj_cs3",STATUS,1)
         EXIT FOREACH
      END IF
      IF l_n < 0 THEN 
         CALL cl_err(l_luj05,'alm1347',0)
         RETURN 
      END IF 
   END FOREACH 
   IF g_lui.luiconf = 'Y' THEN
        CALL cl_err('','alm1318',0)
        RETURN
   END IF     

   IF g_lui.luiconf = 'F' THEN
        CALL cl_err('','alm1319',0)
        RETURN
   END IF
   IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
#CHI-C30107 -------- mark --------- begin
#  IF NOT cl_confirm('alm-006') THEN
#       RETURN
#  END IF
#CHI-C30107 -------- mark --------- end

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t611_cl INTO g_lui.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_lui.luicont = Time
   UPDATE lui_file
   SET luiconf = 'F',
       luiconu = g_user,
       luicond = g_today,
       luicont = g_lui.luicont,
       luimodu = g_user,
       luidate = g_today
    WHERE lui01 = g_lui.lui01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lui_file",g_lui.lui01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lui.luiconf = 'F'
      LET g_lui.luiconu = g_user
      LET g_lui.luicond = g_today
      LET g_lui.luimodu = g_user
      LET g_lui.luidate = g_today
      DISPLAY BY NAME g_lui.luiconf,g_lui.luiconu,g_lui.luicond,
                      g_lui.luicont,g_lui.luimodu,g_lui.luidate
      SELECT gen02 INTO l_gen02
        FROM gen_file 
       WHERE gen01 = g_lui.luiconu
      DISPLAY l_gen02 TO gen02_1
      CALL cl_set_field_pic(g_lui.luiconf,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION t611_no()                     #取消審核
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_rxy05 LIKE rxy_file.rxy05,
          l_rxy06 LIKE rxy_file.rxy06,
          l_rxy32 LIKE rxy_file.rxy32
   DEFINE l_rxx04 LIKE rxx_file.rxx04
   DEFINE l_lul07 LIKE lul_file.lul07
   DEFINE l_gen02_1 LIKE gen_file.gen02    #CHI-D20015
   DEFINE l_sql   STRING 
   IF cl_null(g_lui.lui01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_lui.*
   FROM lui_file
   WHERE lui01=g_lui.lui01

   IF g_lui.luiconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   
   IF g_lui.luiconf='Y' THEN
      CALL cl_err('','alm1320',0)
      RETURN 
   END IF  
   IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t611_cl INTO g_lui.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF NOT cl_confirm('alm-008') THEN
        RETURN
   END IF
   #如果有待抵单，则还原待抵单
   SELECT rxx04 INTO l_rxx04 FROM rxx_file
    WHERE rxx02 = '07' AND rxx00 = '07'
      AND rxx01 = g_lui.lui01 AND rxxplant = g_lui.luiplant
   IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
   IF l_rxx04 > 0 THEN 
      LET l_sql = "SELECT rxy06,rxy32,rxy05 ",
                  "  FROM rxy_file ",
                  " WHERE rxy00 = '07' AND rxy01 = '",g_lui.lui01, "' ",
                  "   AND rxy03 = '07' AND rxyplant = '",g_lui.luiplant,"' ",
                  "   AND rxy19 = '3' "
      PREPARE sel_rxy_pre1 FROM l_sql
      DECLARE sel_rxy_cs1 CURSOR FOR sel_rxy_pre1
      FOREACH sel_rxy_cs1 INTO l_rxy06,l_rxy32,l_rxy05
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         UPDATE lul_file SET lul07 = COALESCE(lul07,0) - l_rxy05
          WHERE lul01 = l_rxy06 AND lul02 = l_rxy32
         SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = l_rxy06
         UPDATE luk_file SET luk11 = l_lul07
          WHERE luk01 = l_rxy06
      END FOREACH
   END IF
   #刪除對應的rxx_file,rxy_file
   DELETE FROM rxx_file WHERE rxx01 IN (SELECT lui01 FROM lui_file WHERE lui01 = g_lui.lui01)
   DELETE FROM rxy_file WHERE rxy01 IN (SELECT lui01 FROM lui_file WHERE lui01 = g_lui.lui01)
   DELETE FROM rxz_file WHERE rxz01 IN (SELECT lui01 FROM lui_file WHERE lui01 = g_lui.lui01)
   UPDATE lui_file SET luiconf = 'N',
                      #CHI-D20015---mod--str
                      #luiconu = '',
                      #luicond = '',
                       luiconu = g_user,
                       luicond = g_today,
                       #CHI-D20015---mod--end
                       luimodu = g_user,luidate = g_today
    WHERE lui01 = g_lui.lui01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lui_file",g_lui.lui01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lui.luiconf = 'N'
      #CHI-D20015---MOD--STR
      LET g_lui.luiconu = ''
      LET g_lui.luicond = ''
      LET g_lui.luicont = ''
      LET g_lui.luiconu = g_user
      LET g_lui.luicond = g_today
      LET g_lui.luicont = Time
      #CHI-D20015---MOD--END
      LET g_lui.luimodu = g_user
      LET g_lui.luidate = g_today
      LET g_lui.lui10 = ''
      UPDATE lui_file SET luiconf = 'N',
                         #CHI-D20015---MOD--STR
                         #luiconu = '',
                         #luicond = '',
                         #luicont = '',
                          luiconu = g_user,
                          luicond = g_today,
                          luicont = g_lui.luicont,
                          #CHI-D20015---MOD--END
                          lui10 = ''
       WHERE lui01 = g_lui.lui01
      DISPLAY BY NAME g_lui.luiconf,g_lui.luiconu,g_lui.luicond,
                      g_lui.luicont,g_lui.luimodu,g_lui.luidate,
                      g_lui.lui10
     #DISPLAY '' TO gen02_1                                                 #FUN-D20015
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lui.luiconu   #FUN-D20015
      DISPLAY l_gen02_1 TO gen02_1                                            #FUN-D20015
      DISPLAY '' TO amt
      CALL cl_set_field_pic(g_lui.luiconf,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF 
END FUNCTION



FUNCTION t611_pay()
DEFINE l_sum    LIKE type_file.num20_6
   IF g_lui.lui01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lui.* FROM lui_file WHERE lui01=g_lui.lui01

   IF g_lui.luiconf = 'N' THEN
      CALL cl_err('','alm1257',1)
      RETURN
   END IF

   IF g_lui.luiconf = 'Y' THEN
      CALL cl_err('','art-811',1)
      RETURN
   END IF
   IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lui.lui09 < 0 THEN
      CALL cl_err('','alm1258',1)
      RETURN 
   END IF 
   SELECT SUM(luj06) INTO l_sum FROM luj_file
       WHERE luj01 = g_lui.lui01
         AND lujplant = g_lui.luiplant      
   IF l_sum IS NULL THEN LET l_sum = 0 END IF
   IF g_lui.lui09 IS NULL THEN LET g_lui.lui09 = 0 END IF

   IF l_sum != g_lui.lui09 THEN
      CALL cl_err('','alm1256',1)
      RETURN
   END IF
   CALL s_pay("11",g_lui.lui01,g_lui.luiplant,g_lui.lui09,'N')
   CALL t611_upd_money()
END FUNCTION

FUNCTION t611_upd_money()
DEFINE l_sql    STRING
DEFINE l_rxx04  LIKE rxx_file.rxx04
DEFINE l_rxy06  LIKE rxy_file.rxy06
DEFINE l_rxy32  LIKE rxy_file.rxy32
DEFINE l_rxy05  LIKE rxy_file.rxy05
DEFINE l_lul07  LIKE lul_file.lul07

   SELECT SUM(rxx04) INTO g_lui.lui10
     FROM rxx_file
    WHERE rxx00 = '11'
      AND rxx01 = g_lui.lui01 AND rxxplant = g_lui.luiplant
   IF cl_null(g_lui.lui10) THEN LET g_lui.lui10 = 0 END IF

   UPDATE lui_file SET lui10 = g_lui.lui10
    WHERE lui01 = g_lui.lui01
   DISPLAY BY NAME g_lui.lui10
#   SELECT rxx04 INTO l_rxx04 FROM rxx_file
#    WHERE rxx02 = '07' AND rxx00 = '11'
#      AND rxx01 = g_lui.lui01 AND rxxplant = g_lui.luiplant
#   IF cl_null(l_rxx04) THEN LET l_rxx04 = 0 END IF
#
#   IF l_rxx04 > 0 THEN
#      LET l_sql = "SELECT rxy06,rxy32,rxy05 ",
#                  "  FROM rxy_file ",
#                  " WHERE rxy00 = '07' AND rxy01 = '",g_lui.lui01, "' ",
#                  "   AND rxy03 = '07' AND rxyplant = '",g_lui.luiplant,"' ",
#                  "   AND rxy19 = '3' "
#      PREPARE sel_rxy_pre FROM l_sql
#      DECLARE sel_rxy_cs CURSOR FOR sel_rxy_pre
#      FOREACH sel_rxy_cs INTO l_rxy06,l_rxy32,l_rxy05
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         UPDATE lul_file SET lul07 = COALESCE(lul07,0) + l_rxy05
#          WHERE lul01 = l_rxy06 AND lul02 = l_rxy32
#         SELECT SUM(lul07) INTO l_lul07 FROM lul_file WHERE lul01 = l_rxy06
#         UPDATE luk_file SET luk11 = l_lul07
#          WHERE luk01 = l_rxy06
#      END FOREACH
#   END IF
   CALL t611_fill_head()
END FUNCTION 

FUNCTION t611_fill_head()
   DEFINE l_amt   LIKE lui_file.lui10
   IF NOT cl_null(g_lui.lui10) AND NOT cl_null(g_lui.lui09)  THEN
      LET l_amt = g_lui.lui09 - g_lui.lui10
      DISPLAY l_amt TO FORMONLY.amt
   END IF
END FUNCTION

FUNCTION t611_pay_y()
   DEFINE l_gen02  LIKE gen_file.gen02
   IF cl_null(g_lui.lui01) THEN
        CALL cl_err('','-400',0)
        RETURN 
   END IF 
   SELECT * INTO g_lui.* FROM lui_file WHERE lui01=g_lui.lui01

   IF g_lui.luiconf = 'N' AND g_lui.luiconf <> 'Y' THEN
        CALL cl_err('','alm1280',0)
        RETURN
   END IF

   IF g_lui.luiconf='Y' THEN
        CALL cl_err('','alm1259',0)
        RETURN
   END IF
   IF g_lui.luiconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lui.lui09 - g_lui.lui10 > 0 
      OR cl_null(g_lui.lui10) THEN
      CALL cl_err('','alm1281',0)
      RETURN       
   END IF 

   IF NOT cl_confirm('alm-006') THEN
       RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t611_cl INTO g_lui.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL s_showmsg_init()
   LET g_lui.luicont = Time
   UPDATE lui_file
   SET luiconf = 'Y',
       luiconu = g_user,
       luicond = g_today,
       luicont = g_lui.luicont,
       luimodu = g_user,
       luidate = g_today
    WHERE lui01 = g_lui.lui01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lui_file",g_lui.lui01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      CALL t611_ins_luklul()     #產生待抵單
      CALL t611_b_fill(" 1=1")
      CALL t611_upd_lua_lub('1')    #更新回写费用单单身
      MESSAGE ""
      IF g_success = 'Y' THEN
         LET g_lui.luiconf = 'Y'
         LET g_lui.luiconu = g_user
         LET g_lui.luicond = g_today
         LET g_lui.luimodu = g_user
         LET g_lui.luidate = g_today
         DISPLAY BY NAME g_lui.luiconf,g_lui.luiconu,g_lui.luicond,
                         g_lui.luicont,g_lui.luimodu,g_lui.luidate
         SELECT gen02 INTO l_gen02
           FROM gen_file
          WHERE gen01 = g_lui.luiconu
         DISPLAY l_gen02 TO gen02_1
         CALL cl_set_field_pic(g_lui.luiconf,"","","","","")
      END IF 
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION 

#產生待抵單
FUNCTION t611_ins_luklul()
DEFINE l_luk        RECORD LIKE luk_file.*
DEFINE l_lul        RECORD LIKE lul_file.*
DEFINE l_sql        STRING
DEFINE l_luj06_sum  LIKE luj_file.luj06
DEFINE l_luj05      LIKE luj_file.luj05
DEFINE l_n          LIKE type_file.num5
   INITIALIZE l_luk.* TO NULL
   INITIALIZE l_lul.* TO NULL
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_luk.luk01 FROM rye_file
   # WHERE rye01 = 'art'
   #   AND rye02 = 'B2'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','B2',g_plant,'N') RETURNING l_luk.luk01   #FUN-C90050 add

   IF cl_null(l_luk.luk01) THEN
      CALL s_errmsg('luk01',l_luk.luk01,'sel_rye','art-330',1)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_auto_assign_no("art",l_luk.luk01,g_today,'B2',"luk_file","luk01","","","")
      RETURNING li_result,l_luk.luk01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET l_sql = "SELECT luj05,SUM(luj06) FROM luj_file,oaj_file ",
               " WHERE luj05 = oaj01 AND oaj05 = '01' AND luj01 = '",g_lui.lui01,"'",
               " group by luj05"     
   PREPARE t611_sel_1 FROM l_sql
   DECLARE t611_sel_1_cs CURSOR FOR t611_sel_1
   FOREACH t611_sel_1_cs INTO l_luj05,l_luj06_sum   
      IF l_luj06_sum > 0 THEN
         LET l_sql = "SELECT luj02,luj05,luj06,luj03,luj04 ",
                     "  FROM luj_file,oaj_file ",
                     " WHERE luj01 = '",g_lui.lui01,"' ",
                     "   AND luj05 = oaj01 AND oaj05 = '01' ",
                     "   AND luj06 > 0 ",
                     "   AND luj05 = '",l_luj05,"'",
                     " ORDER BY luj02 DESC"
                    #" ORDER BY luj02,luj05 DESC"
         PREPARE sel_luj_pre FROM l_sql
         DECLARE sel_luj_cs CURSOR FOR sel_luj_pre
         FOREACH sel_luj_cs INTO l_lul.lul04,l_lul.lul05,l_lul.lul06,l_lul.lul09,l_lul.lul10
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            SELECT MAX(lul02) + 1 INTO l_lul.lul02
              FROM lul_file
             WHERE lul01 = l_luk.luk01
            IF cl_null(l_lul.lul02) THEN LET l_lul.lul02 = '1' END IF
            LET l_lul.lul01 = l_luk.luk01
            LET l_lul.lul03 = g_lui.lui01
            IF l_lul.lul06 - l_luj06_sum > 0 THEN 
               LET l_lul.lul06 = l_luj06_sum
            ELSE 
               LET l_luj06_sum = l_luj06_sum - l_lul.lul06
            END IF 
            LET l_lul.lul07 = 0
            LET l_lul.lul08 = 0
            LET l_lul.lulplant = g_lui.luiplant
            LET l_lul.lullegal = g_lui.luilegal
            INSERT INTO lul_file VALUES(l_lul.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('ins lul',l_lul.lul01,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
            UPDATE luj_file SET luj07 = l_luk.luk01
             WHERE luj01 = g_lui.lui01 AND luj02 = l_lul.lul04
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('upd luj',g_lui.lui01,l_lul.lul04,SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
   END FOREACH 
   SELECT count(*) INTO l_n 
     FROM lul_file 
    WHERE lul01 = l_luk.luk01
   IF l_n > 0 THEN 
      SELECT SUM(lul06) INTO l_luk.luk10
        FROM lul_file 
       WHERE lul01 = l_luk.luk01
      LET l_luk.luk02 = g_today
      LET l_luk.luk03 = g_lui.lui03 #立帳日期
      LET l_luk.luk04 = '1'
      LET l_luk.luk05 = g_lui.lui01
      LET l_luk.luk06 = g_lui.lui05
      LET l_luk.luk07 = g_lui.lui06
      LET l_luk.luk08 = g_lui.lui07
      LET l_luk.luk09 = g_lui.lui08
      LET l_luk.luk11 = 0
      LET l_luk.luk12 = 0
      LET l_luk.luk13 = g_user
      LET l_luk.luk14 = g_grup
      LET l_luk.luk15 = ''
      LET l_luk.lukconf = 'Y'
      LET l_luk.lukcond = g_today
      LET l_luk.lukcont = TIME
      LET l_luk.lukconu = g_user
      LET l_luk.lukmksg = 'N'
      LET l_luk.lukacti = 'Y'
      LET l_luk.lukcrat = g_today
      LET l_luk.lukdate = g_today
      LET l_luk.lukgrup = g_grup
      LET l_luk.lukmodu = ''
      LET l_luk.lukuser = g_user
      LET l_luk.lukoriu = g_user
      LET l_luk.lukorig = g_grup
      LET l_luk.lukplant = g_lui.luiplant
      LET l_luk.luklegal = g_lui.luilegal

      INSERT INTO luk_file VALUES(l_luk.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('ins luk',l_luk.luk01,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF    
END FUNCTION

#20111226 By shi重新整理
FUNCTION t611_upd_lua_lub(p_type)
 DEFINE p_type    LIKE type_file.chr1 #1:交款审核,2:取消交款审核
 DEFINE l_luj     RECORD LIKE luj_file.*
 DEFINE l_lua14   LIKE lua_file.lua14
 DEFINE l_lua33   LIKE lua_file.lua33
 DEFINE l_lub04t  LIKE lub_file.lub04t
 DEFINE l_lub11   LIKE lub_file.lub11
 DEFINE l_lub12   LIKE lub_file.lub12
 DEFINE l_lub13   LIKE lub_file.lub13
 DEFINE l_liw     RECORD LIKE liw_file.*
 DEFINE l_lla     RECORD LIKE lla_file.*
 DEFINE l_lij05   LIKE lij_file.lij05

   SELECT * INTO l_lla.* FROM lla_file WHERE llastore = g_lui.luiplant
   LET g_sql = "SELECT * ",
               "  FROM luj_file ",
               " WHERE luj01 = '",g_lui.lui01,"'"
   PREPARE sel_luj_pre1 FROM g_sql
   DECLARE sel_luj_cs1 CURSOR FOR sel_luj_pre1
   FOREACH sel_luj_cs1 INTO l_luj.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','sel_luj_cs1',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      SELECT lua33,lub04t,lub11,lub12,lub13
        INTO l_lua33,l_lub04t,l_lub11,l_lub12,l_lub13
        FROM lua_file,lub_file
       WHERE lua01 = lub01
         AND lua01 = l_luj.luj03
         AND lub02 = l_luj.luj04
      IF cl_null(l_lub11) THEN LET l_lub11 = 0 END IF
      IF cl_null(l_lub12) THEN LET l_lub12 = 0 END IF
      IF p_type = '1' THEN
         LET l_lub11 = l_lub11 + l_luj.luj06
      ELSE
         LET l_lub11 = l_lub11 - l_luj.luj06
      END IF
      #如果含税金额=已收+清算+这次交款金额则单身结案
      IF l_lub04t = l_lub11+l_lub12 THEN
         LET l_lub13 = 'Y'
      ELSE
      	 LET l_lub13 = 'N'
      END IF
      UPDATE lub_file SET lub11 = l_lub11,
                          lub13 = l_lub13
       WHERE lub01 = l_luj.luj03
         AND lub02 = l_luj.luj04
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_luj.luj03,'/',l_luj.luj04
         CALL s_errmsg('lub01,lub02',g_showmsg,'upd lub_file','',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      #如果单身结案则单头结案,更新单头已收金额
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM lub_file
       WHERE lub01 = l_luj.luj03
         AND lub13 = 'N'
      IF g_cnt = 0 THEN
         LET l_lua14 = '2'
      ELSE
         LET l_lua14 = '1'
      END IF
      SELECT SUM(lub11) INTO l_lub11 FROM lub_file
       WHERE lub01 = l_luj.luj03
      IF cl_null(l_lub11) THEN LET l_lub11 = 0 END IF
      UPDATE lua_file SET lua14 = l_lua14,lua35 = l_lub11
       WHERE lua01 = l_luj.luj03
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_luj.luj03
         CALL s_errmsg('lua01',g_showmsg,'upd lua11/lub14','',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      #更新账单已收金额和结案
      IF cl_null(l_lua33) THEN CONTINUE FOREACH END IF
      #账单是否按自然月拆分lla05不同，抓取账单的SQL也不同
      SELECT lij05 INTO l_lij05 FROM lij_file,lua_file,lnt_file
       WHERE lua04 = lnt01
         AND lnt71 = lij01
         AND lij02 = l_luj.luj05
         AND lua01 = l_luj.luj03
      IF l_lla.lla05 = 'N' OR l_lij05 = '1' THEN #收付实现制也不拆分
         SELECT liw_file.* INTO l_liw.* FROM liw_file,lub_file,lua_file
          WHERE lua01 = lub01
            AND lub01 = l_luj.luj03
            AND lub02 = l_luj.luj04
            AND liw05 = lua33       #帐期
            AND liw06 = lua34       #出账日
            AND liw02 = lub16       #合同版本号
            AND liw16 = l_luj.luj03 #费用单号
            AND liw04 = l_luj.luj05 #费用编号
      ELSE
         SELECT liw_file.* INTO l_liw.* FROM liw_file,lub_file,lua_file
          WHERE lua01 = lub01
            AND lub01 = l_luj.luj03
            AND lub02 = l_luj.luj04
            AND liw05 = lua33       #帐期
            AND liw06 = lua34       #出账日
            AND liw02 = lub16       #合同版本号
            AND liw16 = l_luj.luj03 #费用单号
            AND liw04 = l_luj.luj05 #费用编号
            AND liw07 = lub07       #开始日期
            AND liw08 = lub08       #结束日期
      END IF
      IF cl_null(l_liw.liw14) THEN LET l_liw.liw14 = 0 END IF
      IF cl_null(l_liw.liw15) THEN LET l_liw.liw15 = 0 END IF
      IF p_type = '1' THEN
         LET l_liw.liw14 = l_liw.liw14 + l_luj.luj06
      ELSE
         LET l_liw.liw14 = l_liw.liw14 - l_luj.luj06
      END IF
      IF l_liw.liw13 = l_liw.liw14 + l_liw.liw15 THEN
         LET l_liw.liw17 = 'Y'
      ELSE
         LET l_liw.liw17 = 'N'
      END IF
      UPDATE liw_file SET liw14 = l_liw.liw14,
                          liw17 = l_liw.liw17
        WHERE liw01 = l_liw.liw01
          AND liw03 = l_liw.liw03
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_liw.liw01,'/',l_liw.liw03
         CALL s_errmsg('liw01,liw03',g_showmsg,'upd liw_file','',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   END FOREACH
END FUNCTION

#FUNCTION t611_upd_lua_lub()
#   DEFINE l_sql     STRING 
#   DEFINE l_n       LIKE type_file.num5
#   DEFINE l_liw14   LIKE liw_file.liw14
#   DEFINE l_luj03   LIKE luj_file.luj03,
#          l_luj04   LIKE luj_file.luj04,
#          l_luj05   LIKE luj_file.luj05,
#          l_luj06   LIKE luj_file.luj06
#   DEFINE l_lub04t  LIKE lub_file.lub04t,
#          l_lub11   LIKE lub_file.lub11,
#          l_lub11_1 LIKE lub_file.lub11,
#          l_lub12   LIKE lub_file.lub12
#   DEFINE l_sum_lub11 LIKE lub_file.lub11
#   LET l_sql = "SELECT luj03,luj04,luj05,luj06 ",
#               "  FROM luj_file ",
#               " WHERE luj01 = '",g_lui.lui01,"'"
#   PREPARE sel_luj_pre1 FROM l_sql
#   DECLARE sel_luj_cs1 CURSOR FOR sel_luj_pre1
#   FOREACH sel_luj_cs1 INTO l_luj03,l_luj04,l_luj05,l_luj06
#      IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          LET g_success = 'N'
#          EXIT FOREACH
#      END IF
#      SELECT lub11 INTO l_lub11_1
#        FROM lub_file 
#       WHERE lub01 = l_luj03
#         AND lub02 = l_luj04
#      IF cl_null(l_lub11_1) THEN LET l_lub11_1 = 0 END IF 
#      UPDATE lub_file SET lub11 = l_luj06 + l_lub11_1
#       WHERE lub01 = l_luj03
#         AND lub02 = l_luj04
#      SELECT lub04t,lub11,lub12 INTO l_lub04t,l_lub11,l_lub12
#        FROM lub_file 
#       WHERE lub01 = l_luj03
#         AND lub02 = l_luj04
#      IF cl_null(l_lub12) THEN LET l_lub12 = 0 END IF 
#      IF l_lub04t - l_lub11 - l_lub12 = 0 THEN
#         UPDATE lub_file SET lub13 = 'Y' 
#          WHERE lub01 = l_luj03
#            AND lub02 = l_luj04
#         UPDATE liw_file SET liw17 = 'Y'
#          WHERE liw16 = l_luj03
#            AND liw04 = l_luj05
#            AND liw18 = l_luj04
#      END IF  
#      SELECT liw14 INTO l_liw14 
#        FROM liw_file 
#       WHERE liw16 = l_luj03
#         AND liw04 = l_luj05
#         AND liw18 = l_luj04
#      IF cl_null(l_liw14) THEN 
#         LET l_liw14 = 0
#      END IF 
#      UPDATE liw_file SET liw14 = l_luj06 + l_liw14
#       WHERE liw16 = l_luj03
#         AND liw04 = l_luj05
#         AND liw18 = l_luj04
#   END FOREACH
#   #更新单头已收金额
#   SELECT SUM(lub11) INTO l_sum_lub11
#     FROM lub_file 
#    WHERE lub01 = g_lui.lui04
#   IF cl_null(l_sum_lub11) THEN LET l_sum_lub11 = 0 END IF 
#   UPDATE lua_file SET lua35 = l_sum_lub11 
#    WHERE lua01 = g_lui.lui04
#   #更新单头结案否、合同账单结案否
#   SELECT COUNT(*) INTO l_n FROM lub_file 
#    WHERE lub01 = g_lui.lui04
#      AND lub13 = 'N'
#   IF l_n = 0 THEN
#      UPDATE lua_file SET lua14 = '2'
#       WHERE lua01 = g_lui.lui04
#   END IF 
#END FUNCTION 	

FUNCTION t611_pay_no()
   DEFINE l_gen02 LIKE gen_file.gen02
   DEFINE l_n     LIKE type_file.chr1
   IF cl_null(g_lui.lui01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF

   SELECT * INTO g_lui.* FROM lui_file
    WHERE lui01=g_lui.lui01

   IF g_lui.luiconf <> 'Y' THEN
        CALL cl_err('','alm1288',0)
        RETURN
   END IF

   IF NOT cl_null(g_lui.lui14) THEN
       CALL cl_err('','alm1286',0)
       RETURN
   END IF

  #FUN-C20009 Begin---
   IF g_lui.lui15 = 'Y' THEN
      CALL cl_err('','art-893',0)
      RETURN
   END IF
  #FUN-C20009 End-----
   
   SELECT COUNT(*) INTO l_n
     FROM rxy_file,luk_file 
    WHERE rxy05 = luk01
      AND luk05 = g_lui.lui01
   IF l_n > 0 THEN 
      CALL cl_err('','alm1287',0) 
      RETURN 
   END IF  
   #如果待抵单有支出，不可取消审核
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM lup_file,luo_file,lul_file
    WHERE luo01 = lup01
      AND lup03 = lul01
      AND luo03 = '1'
      AND lul03 = g_lui.lui01 
      AND luoconf <> 'X' #CHI-C80041
   IF g_cnt > 0 THEN
      CALL cl_err('','alm1372',0)
      RETURN
   END IF
   #该待抵单已用于交款，不可取消审核
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM rxy_file,lul_file
    WHERE lul01 = rxy06
      AND lul03 = g_lui.lui01
      AND rxy03 = '07'
      AND rxy19 = '3'
   IF g_cnt > 0 THEN
      CALL cl_err('','alm1373',0)
      RETURN
   END IF
   #待抵单有变更，不允许取消审核
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM lun_file,lul_file
    WHERE lun03 = lul01
      AND lul03 = g_lui.lui01
   IF g_cnt > 0 THEN
      CALL cl_err('','alm1378',0)
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'

   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      LET g_success='N'
   END IF

   FETCH t611_cl INTO g_lui.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)
      CLOSE t611_cl
      LET g_success='N'
   END IF

   IF NOT cl_confirm('alm-008') THEN
        RETURN
   END IF
   LET g_lui.luicont = Time
   UPDATE lui_file SET luiconf = 'F',
                       luiconu = g_user,
                       luicont = g_lui.luicont,
                       luicond = g_today
    WHERE lui01 = g_lui.lui01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lui_file",g_lui.lui01,"",STATUS,"","",1)
      LET g_success = 'N'
   END IF
   #删除对应的待抵单
   DELETE FROM lul_file WHERE lul03 = g_lui.lui01
   DELETE FROM luk_file WHERE luk05 = g_lui.lui01
   UPDATE luj_file SET luj07 = ''
    WHERE luj01 = g_lui.lui01
   CALL t611_b_fill(" 1=1")
  #CALL t611_upd_lua()        #更新费用单信息
   CALL t611_upd_lua_lub('2')
   IF g_success = 'Y' THEN
      LET g_lui.luiconf = 'F'
      LET g_lui.luiconu = g_user
      LET g_lui.luicond = g_today
      DISPLAY BY NAME g_lui.luiconf,g_lui.luiconu,g_lui.luicont,g_lui.luicond
      SELECT gen02 INTO l_gen02
        FROM gen_file
       WHERE gen01 = g_lui.luiconu
      DISPLAY l_gen02 TO gen02_1
      CALL cl_set_field_pic(g_lui.luiconf,"","","","","")
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION 
  
FUNCTION t611_upd_lua()   #更新费用单信息
   DEFINE l_sql    STRING
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_lub11  LIKE lub_file.lub11
   DEFINE l_liw14  LIKE liw_file.liw14
   DEFINE l_luj03  LIKE luj_file.luj03,
          l_luj04  LIKE luj_file.luj04,
          l_luj05  LIKE luj_file.luj05,
          l_luj06  LIKE luj_file.luj06
   DEFINE l_sum_lub11 LIKE lub_file.lub11
   LET l_sql = "SELECT luj03,luj04,luj05,luj06 ",
               "  FROM luj_file ",
               " WHERE luj01 = '",g_lui.lui01,"'"
   PREPARE sel_luj_pre2 FROM l_sql
   DECLARE sel_luj_cs2 CURSOR FOR sel_luj_pre2
   FOREACH sel_luj_cs2 INTO l_luj03,l_luj04,l_luj05,l_luj06
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF
      SELECT lub11 INTO l_lub11
        FROM lub_file 
       WHERE lub01 = l_luj03
         AND lub02 = l_luj04
      UPDATE lub_file SET lub11 = l_lub11 - l_luj06,
                          lub13 = 'N' 
       WHERE lub01 = l_luj03
         AND lub02 = l_luj04
      UPDATE lub_file SET lub13 = 'N'
       WHERE lub01 = l_luj03 
         AND lub02 = l_luj04
      SELECT liw14 INTO l_liw14
        FROM liw_file
       WHERE liw16 = l_luj03
         AND liw04 = l_luj05
      IF cl_null(l_liw14) THEN
         LET l_liw14 = 0
      END IF
      UPDATE liw_file SET liw14 = l_liw14 - l_luj06
       WHERE liw16 = l_luj03
         AND liw04 = l_luj05
   END FOREACH
   #更新单头已收金额
   SELECT SUM(lub11) INTO l_sum_lub11
     FROM lub_file
    WHERE lub01 = g_lui.lui04
   IF cl_null(l_sum_lub11) THEN LET l_sum_lub11 = 0 END IF
   UPDATE lua_file SET lua35 = l_sum_lub11
    WHERE lua01 = g_lui.lui04 
   #更新状况码
   UPDATE lua_file SET lua14 = '1'
    WHERE lua01 = g_lui.lui04
   UPDATE liw_file SET liw17 = 'N'
    WHERE liw16 = g_lui.lui04  
END FUNCTION 
#FUN-BB0117
#FUN-C30029--add--str
FUNCTION t611_axrp606()
   DEFINE l_str  STRING
   DEFINE l_wc   STRING
   DEFINE l_wc2  STRING
   DEFINE l_lui14 LIKE lui_file.lui14
   DEFINE l_azp01 LIKE azp_file.azp01
   DEFINE l_lui01 LIKE lui_file.lui01
   IF s_shut(0) THEN
       RETURN
   END IF
   IF cl_null(g_lui.lui01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF cl_null(g_lui.lui14) THEN 
      CALL cl_err('','axr-393',1)
      RETURN
   END IF 
   IF NOT (cl_confirm("axr-391")) THEN
      RETURN
   END IF
   LET l_wc = ''
   LET l_wc2 = ''
   LET l_str = ''
   LET l_azp01 = g_plant
   LET l_wc  = 'azp01 = "',l_azp01,'"'
   LET l_wc2 = 'lui01 = "',g_lui.lui01,'"'
   LET l_str = " axrp606 '",l_wc,"' '",l_wc2,"' 'Y'"
   
   CALL cl_cmdrun_wait(l_str)
   SELECT lui14 INTO l_lui14 FROM lui_file WHERE lui01 = g_lui.lui01
   DISPLAY l_lui14 TO lui14
   LET g_lui.lui14 = l_lui14
END FUNCTION
#FUN-C30029--add--end
#FUN-C20007--add-str
FUNCTION t611_axrp602()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_azp01 LIKE azp_file.azp01
   DEFINE li_sql STRING
   DEFINE li_str STRING
   DEFINE li_wc STRING
   DEFINE li_wc2 STRING 
   DEFINE l_yy LIKE type_file.num5
   DEFINE l_mm LIKE type_file.num5
   DEFINE l_lui14 LIKE lui_file.lui14
   DEFINE l_luj03 LIKE luj_file.luj03
   IF s_shut(0) THEN
       RETURN
    END IF
   IF cl_null(g_lui.lui01) THEN 
      RETURN 
   END IF 

#TQC-C40013 add str--------------
   IF g_lui.lui15 = 'Y' THEN 
      CALL cl_err(g_lui.lui01,'axr1000',1)
      RETURN
   END IF
#TQC-C40013 add end--------------

   LET l_cnt = 0 
   SELECT azp01 INTO l_azp01 FROM azp_file,azw_file 
    WHERE azw01 = azp01 AND azw02 = g_legal AND azw01 = g_lui.luiplant
   LET li_sql = "SELECT luj03  ",
               "   FROM ",cl_get_target_table(l_azp01,'luj_file'),
               "  WHERE luj01 = '",g_lui.lui01,"'"
   CALL cl_replace_sqldb(li_sql) RETURNING li_sql
    CALL cl_parse_qry_sql(li_sql,l_azp01) RETURNING li_sql
    PREPARE p602_lua_pre5 FROM li_sql
    DECLARE p602_lua_cs5 CURSOR FOR p602_lua_pre5
   FOREACH p602_lua_cs5 INTO l_luj03
   LET li_sql = " SELECT count(*)  ",
               "   FROM ",cl_get_target_table(l_azp01,'lua_file'),
               "  WHERE  luaplant = ? ",
               "    AND lua37 = 'N' ",
               "    AND lua15 = 'Y' ",
               "    AND lua32<>'6' ",
               "    AND lua01 = ? "
    CALL cl_replace_sqldb(li_sql) RETURNING li_sql
    CALL cl_parse_qry_sql(li_sql,l_azp01) RETURNING li_sql
    PREPARE p602_lua_pre FROM li_sql
    EXECUTE p602_lua_pre USING l_azp01,l_luj03 INTO l_cnt
    IF l_cnt = 0 THEN 
       RETURN 
    END IF 
    LET l_cnt = 0 
    LET li_sql = " SELECT count(*)  ",
               "   FROM ",cl_get_target_table(l_azp01,'lui_file'),
               #"  WHERE lui04 = ? ",
               "   WHERE  lui01 = ? ",
               "    AND year(lui03) = ? AND month(lui03) =? ",    #年度+期別
               "    AND luiconf = 'Y' ",
               "    AND lui14 IS NULL"
   CALL cl_replace_sqldb(li_sql) RETURNING li_sql
   CALL cl_parse_qry_sql(li_sql,l_azp01) RETURNING li_sql
   PREPARE p602_lui_pre FROM li_sql
   LET l_yy = YEAR(g_lui.lui03)
   LET l_mm = MONTH(g_lui.lui03)
   EXECUTE p602_lui_pre USING g_lui.lui01,l_yy,l_mm INTO l_cnt
   IF l_cnt = 0 THEN 
      RETURN 
   END IF 
   END FOREACH
   IF NOT (cl_confirm("axr119")) THEN 
      RETURN 
   END IF 
#-------TQC-C2024--mod--str
  #LET li_wc = " azp01 = '",l_azp01,"'"
  #LET li_wc2 = " lui01 = '",g_lui.lui01,"' AND lui05 = '",g_lui.lui05,"' AND lui02 = '",g_lui.lui02,"'"
  #
  #LET li_str = "axrp602 ",
  #             ' "',li_wc,'" ',
  #             ' "',li_wc2,'" ',
  #             ' " "',
  #             ' "',l_yy,'" ',
  #             ' "',l_mm,'" ',
  #             ' "Y" '
   LET li_wc  = 'azp01 = "',l_azp01,'"'
   LET li_wc2 = 'lui01 = "',g_lui.lui01,'" AND lui05 = "',g_lui.lui05,'" AND lui02 = "',g_lui.lui02,'"'
   LET li_str = " axrp602 '",li_wc,"' '",li_wc2,"' '' '",YEAR(g_today),"' '",MONTH(g_today),"' 'Y'"
#------TQC-C20204--mod--end
   CALL cl_cmdrun_wait(li_str) 
   SELECT lui14 INTO l_lui14 FROM lui_file WHERE lui01 = g_lui.lui01
   DISPLAY l_lui14 TO lui14
   LET g_lui.lui14 = l_lui14#FUN-C30029 add
END FUNCTION 
#FUN-C20007--add-end

#FUN-CB0076-------add------str
FUNCTION t611_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_occ02   LIKE occ_file.occ02,
       l_gen02   LIKE gen_file.gen02,
       l_oaj02   LIKE oaj_file.oaj02,
       l_amt     LIKE ogb_file.ogb11,
       l_lui01   LIKE lui_file.lui01
DEFINE sr        RECORD
       luiplant  LIKE lui_file.luiplant,
       lui01     LIKE lui_file.lui01,
       lua04     LIKE lua_file.lua04,
       lua20     LIKE lua_file.lua20,
       lui05     LIKE lui_file.lui05,
       lui02     LIKE lui_file.lui02,
       lui06     LIKE lui_file.lui06,
       luicond   LIKE lui_file.luicond,
       luicont   LIKE lui_file.luicont,
       luiconu   LIKE lui_file.luiconu,
       luj02     LIKE luj_file.luj02,
       luj03     LIKE luj_file.luj03,
       luj04     LIKE luj_file.luj04,
       luj05     LIKE luj_file.luj05,
       lub09     LIKE lub_file.lub09,
       lub07     LIKE lub_file.lub07,
       lub08     LIKE lub_file.lub08,
       lub04t    LIKE lub_file.lub04t,
       lub11     LIKE lub_file.lub11,
       lub12     LIKE lub_file.lub12,
       luj06     LIKE luj_file.luj06
                 END RECORD
DEFINE sr3       RECORD
       rxy01     LIKE rxy_file.rxy01,
       rxy02     LIKE rxy_file.rxy02,
       rxy03     LIKE rxy_file.rxy03,
       rxy05     LIKE rxy_file.rxy05,
       rxy06     LIKE rxy_file.rxy06,
       rxy32     LIKE rxy_file.rxy32,
       rxy33     LIKE rxy_file.rxy33
                 END RECORD

     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM
     END IF
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog, g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('luiuser', 'luigrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lui01 = '",g_lui.lui01,"'" END IF
     LET l_sql = "SELECT luiplant,lui01,'','',lui05,lui02,lui06,luicond,luicont,luiconu,",
                 "       luj02,luj03,luj04,luj05,lub09,lub07,lub08,lub04t,lub11,lub12,luj06",
                 "  FROM lui_file,luj_file,lub_file",
                 " WHERE lui01 = luj01",
                 "   AND luj03 = lub01",
                 "   AND luj04 = lub02",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED,
                 " ORDER BY lui01,luj02 "
     PREPARE t611_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   
        EXIT PROGRAM
     END IF
     DECLARE t611_cs1 CURSOR FOR t611_prepare1

     DISPLAY l_table
     LET l_lui01 = ' '
     FOREACH t611_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT lua04,lua20 INTO sr.lua04,sr.lua20 FROM lua_file 
        WHERE lua01 = (SELECT lui04 FROM lui_file WHERE lui01 = sr.lui01)
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.luiplant
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.luiconu
       LET l_oaj02 = ' '
       SELECT oaj02 INTO l_oaj02 FROM oaj_file WHERE oaj01 = sr.luj05
       LET l_occ02 = ' '
       SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = sr.lui05
       LET l_amt = 0
       LET l_amt = sr.lub04t-sr.lub11-sr.lub12
       EXECUTE insert_prep USING sr.*,l_rtz13,l_occ02,l_gen02,l_oaj02,l_amt
       IF l_lui01 <> sr.lui01 THEN
          LET l_sql = "SELECT rxy01,rxy02,rxy03,rxy05,rxy06,rxy32,rxy33",
                      "  FROM rxy_file",
                      " WHERE rxy01 = '",sr.lui01,"'",
                      "   AND rxy00 = '11'"
          PREPARE t611_prepare2 FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare2:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
             EXIT PROGRAM
          END IF
          DECLARE t611_cs2 CURSOR FOR t611_prepare2
          DISPLAY l_table1
          FOREACH t611_cs2 INTO sr3.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            EXECUTE insert_prep1 USING sr3.*
          END FOREACH
       END IF
       LET l_lui01 = sr.lui01
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lui01,lui02,lui03,lui04,luiplant,luilegal,lui05,lui06,lui07,lui08,lui09,lui15,lui10,lui11,lui12,lui14,luiconf,luiconu,luicond,lui13,luiuser,luigrup,luioriu,luimodu,luidate,luiorig,luiacti,luicrat')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'luj02,luj03,luj04,luj05,lub09,lub07,lub08,lub04t,lub11,lub12,luj06')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1=''
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3=''
     END IF
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF
     END IF
     CALL t611_grdata()
END FUNCTION

FUNCTION t611_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt611")
       IF handler IS NOT NULL THEN
           START REPORT t611_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lui01,luj02 "
           DECLARE t611_datacur1 CURSOR FROM l_sql
           FOREACH t611_datacur1 INTO sr1.*
               OUTPUT TO REPORT t611_rep(sr1.*)
           END FOREACH
           FINISH REPORT t611_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t611_rep(sr1)
    DEFINE sr1           sr1_t
    DEFINE sr2           sr2_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_lub04t_sum  LIKE lub_file.lub04t
    DEFINE l_lub11_sum   LIKE lub_file.lub11
    DEFINE l_amt_sum     LIKE lub_file.lub11
    DEFINE l_luj06_sum   LIKE luj_file.luj06
    DEFINE l_lub09       STRING 
    DEFINE l_plant       STRING

    ORDER EXTERNAL BY sr1.lui01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc4
              
        BEFORE GROUP OF sr1.lui01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_plant  = sr1.luiplant,' ',sr1.rtz13
            PRINTX l_plant
            LET l_lub09 = cl_gr_getmsg('gre-316',g_lang,sr1.lub09)
            PRINTX l_lub09
            PRINTX sr1.*

        AFTER GROUP OF sr1.lui01
            LET l_lub04t_sum = GROUP SUM(sr1.lub04t)
            LET l_amt_sum = GROUP SUM(sr1.amt)
            LET l_lub11_sum = GROUP SUM(sr1.lub11)
            LET l_luj06_sum = GROUP SUM(sr1.luj06)
            PRINTX l_lub04t_sum
            PRINTX l_amt_sum
            PRINTX l_lub11_sum
            PRINTX l_luj06_sum
            LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE rxy01 = '",sr1.lui01,"'",
                        " ORDER BY rxy02"
            START REPORT artt611_subrep01
            DECLARE artt611_repcur2 CURSOR FROM g_sql
            FOREACH artt611_repcur2 INTO sr2.*
                OUTPUT TO REPORT artt611_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT artt611_subrep01
        ON LAST ROW

END REPORT
REPORT artt611_subrep01(sr2)
    DEFINE sr2          sr2_t
    DEFINE l_rxy03      STRING
    DEFINE l_rxy06      STRING

    FORMAT
        ON EVERY ROW
           PRINTX sr2.*
           LET l_rxy03 = cl_gr_getmsg('gre-336',g_lang,sr2.rxy03)
           PRINTX l_rxy03
           IF sr2.rxy03 = '07' THEN
              LET l_rxy06 =sr2.rxy06,'( ',sr2.rxy32,' )' 
           ELSE
               LET l_rxy06 =sr2.rxy06
           END IF
           PRINTX l_rxy06

END REPORT
#FUN-CB0076-------add------end
#CHI-C80041---begin
FUNCTION t611_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lui.lui01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t611_cl USING g_lui.lui01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t611_cl INTO g_lui.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lui.lui01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t611_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lui.luiconf = 'Y' OR g_lui.luiconf = 'F' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lui.luiconf)   THEN 
        LET l_chr=g_lui.luiconf
        IF g_lui.luiconf='N' THEN 
            LET g_lui.luiconf='X' 
        ELSE
            LET g_lui.luiconf='N'
        END IF
        UPDATE lui_file
            SET luiconf=g_lui.luiconf,  
                luimodu=g_user,
                luidate=g_today
            WHERE lui01=g_lui.lui01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lui_file",g_lui.lui01,"",SQLCA.sqlcode,"","",1)  
            LET g_lui.luiconf=l_chr 
        END IF
        DISPLAY BY NAME g_lui.luiconf
   END IF
 
   CLOSE t611_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lui.lui01,'V')
 
END FUNCTION
#CHI-C80041---end

