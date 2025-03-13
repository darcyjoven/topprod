# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt611.4gl
# Descriptions...: 開卡作業
# Date & Author..: FUN-960134 09/10/14 By shiwuying
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A60132 10/07/06 By chenmoyan 1.修改t611_tmp2的索引
#                                                      2.MSSQL語法中不能使用CONNECT BY
#                                                      3.MSV中SELECT INTO TEMP TABLE的語法報錯
#                                                      4.MSV中取消確認後，確認日期欄位的值變為1900/1/1
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No:FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:FUN-C30044 12/03/10 By nanbing 開始結束卡號賦值
# Modify.........: No:CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C90066 12/09/13 By shiwuying 效能优化
# Modify.........: No:FUN-C90070 12/09/27 By xumeimei 添加GR打印功能
# Modify.........: No.MOD-CA0064 12/10/18 By Vampire almi660沒有固定代號時,lpx23的長度會是null,直接用固定代號位數lpx22判斷即可,lph34的長度也直接抓lph33即可
# Modify.........: No:CHI-C80041 12/12/26 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D10021 13/01/10 By dongsz 1.AFTER FIELD lrt03帶默認值時按照固定编号抓取最大值并关联卡种表
#                                                   2.檢查是否卡號已存在時按照固定编号抓取并关联卡种表
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No:TQC-D30031 13/03/11 By wuxj  lph33為0時，維護單身當出bug修改
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lrs               RECORD LIKE lrs_file.*        #簽核等級 (單頭)
DEFINE g_lrs_t             RECORD LIKE lrs_file.*        #簽核等級 (舊值)
DEFINE g_lrs_o             RECORD LIKE lrs_file.*        #簽核等級 (舊值)
DEFINE g_lrs01_t           LIKE lrs_file.lrs01           #簽核等級 (舊值)
#DEFINE g_t1                LIKE lrk_file.lrkslip        #FUN-A70130  mark
DEFINE g_t1                LIKE oay_file.oayslip         #FUN-A70130

DEFINE g_lrt               DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                           lrt02   LIKE lrt_file.lrt02,   #項次
                           lrt03   LIKE lrt_file.lrt03,   #卡種
                           lph32   LIKE lph_file.lph32,
                           lph33   LIKE lph_file.lph33,
                           lph34   LIKE lph_file.lph34,
                           lph35   LIKE lph_file.lph35,
                           lrt04   LIKE lrt_file.lrt04,   #開始卡號
                           lrt05   LIKE lrt_file.lrt05    #結束卡號
                           END RECORD
DEFINE g_lrt_t             RECORD                        #程式變數 (舊值)
                           lrt02   LIKE lrt_file.lrt02,   #項次
                           lrt03   LIKE lrt_file.lrt03,   #卡種
                           lph32   LIKE lph_file.lph32,
                           lph33   LIKE lph_file.lph33,
                           lph34   LIKE lph_file.lph34,
                           lph35   LIKE lph_file.lph35,
                           lrt04   LIKE lrt_file.lrt04,   #開始卡號
                           lrt05   LIKE lrt_file.lrt05    #結束卡號
                           END RECORD
DEFINE g_lrt_o             RECORD                        #程式變數 (舊值)
                           lrt02   LIKE lrt_file.lrt02,   #項次
                           lrt03   LIKE lrt_file.lrt03,   #卡種
                           lph32   LIKE lph_file.lph32,
                           lph33   LIKE lph_file.lph33,
                           lph34   LIKE lph_file.lph34,
                           lph35   LIKE lph_file.lph35,
                           lrt04   LIKE lrt_file.lrt04,   #開始卡號
                           lrt05   LIKE lrt_file.lrt05    #結束卡號
                           END RECORD
DEFINE g_sql               STRING                        #CURSOR暫存
DEFINE g_wc                STRING                        #單頭CONSTRUCT結果
DEFINE g_wc2               STRING                        #單身CONSTRUCT結果
DEFINE g_rec_b             LIKE type_file.num10          #單身筆數
DEFINE l_ac                LIKE type_file.num10          #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num10          #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10          #總筆數
DEFINE g_jump              LIKE type_file.num10          #查詢指定的筆數
DEFINE g_no_ask           LIKE type_file.num10          #是否開啟指定筆視窗
#DEFINE g_kindtype          LIKE lrk_file.lrkkind       #FUN-A70130   mark
 DEFINE g_kindtype          LIKE oay_file.oaytype       #FUN-A70130
#FUN-C90070----add---str
DEFINE g_wc1                 STRING
DEFINE g_wc3                 STRING
DEFINE g_wc4                 STRING
DEFINE l_table               STRING
TYPE sr1_t RECORD
    lrs01     LIKE lrs_file.lrs01,
    lrs02     LIKE lrs_file.lrs02,
    lrsplant  LIKE lrs_file.lrsplant, 
    lrs03     LIKE lrs_file.lrs03,
    lrs04     LIKE lrs_file.lrs04,
    lrs05     LIKE lrs_file.lrs05,
    lrt02     LIKE lrt_file.lrt02,
    lrt03     LIKE lrt_file.lrt03,
    lrt04     LIKE lrt_file.lrt04,
    lrt05     LIKE lrt_file.lrt05,
    rtz13     LIKE rtz_file.rtz13,
    lph34     LIKE lph_file.lph34
END RECORD
#FUN-C90070----add---end
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041

MAIN
   OPTIONS                               #改變一些系統預設值
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   #FUN-C90070------add-----str
   LET g_pdate = g_today
   LET g_sql ="lrs01.lrs_file.lrs01,",
              "lrs02.lrs_file.lrs02,",
              "lrsplant.lrs_file.lrsplant,", 
              "lrs03.lrs_file.lrs03,",
              "lrs04.lrs_file.lrs04,",
              "lrs05.lrs_file.lrs05,",
              "lrt02.lrt_file.lrt02,",
              "lrt03.lrt_file.lrt03,",
              "lrt04.lrt_file.lrt04,",
              "lrt05.lrt_file.lrt05,",
              "rtz13.rtz_file.rtz13,",
              "lph34.lph_file.lph34"
   LET l_table = cl_prt_temptable('almt611',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql = "SELECT * FROM lrs_file WHERE lrs01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t611_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t611_w WITH FORM "alm/42f/almt611"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   #LET g_kindtype = '38' #FUN-A70130
   LET g_kindtype = 'N3' #FUN-A70130
 
   CALL t611_menu()
 
   CLOSE WINDOW t611_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN

#QBE 查詢資料
FUNCTION t611_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   CALL g_lrt.clear()
 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lrs.* TO NULL
   CONSTRUCT BY NAME g_wc ON lrsplant,lrslegal,lrs01,lrs02,lrs03,
                             lrs04,lrs05,lrs06,lrsuser,lrsgrup,
                             lrscrat,lrsmodu,lrsoriu,lrsorig,lrsacti,lrsdate
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lrs01)               #單據編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrs01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrs01
               NEXT FIELD lrs01
            WHEN INFIELD(lrsplant)             #門店
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrsplant"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrsplant
               NEXT FIELD lrsplant
            WHEN INFIELD(lrslegal)             #法人
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lrslegal"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrslegal
               NEXT FIELD lrslegal
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
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND lrsuser = '",g_user,"'"
   END IF
 
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND lrsgrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
 
   CONSTRUCT g_wc2 ON lrt02,lrt03,lrt04,lrt05
                FROM s_lrt[1].lrt02,s_lrt[1].lrt03,s_lrt[1].lrt04,
                     s_lrt[1].lrt05
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE
              WHEN INFIELD(lrt03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrt03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrt03
                  NEXT FIELD lrt03
               WHEN INFIELD(lrt04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrt04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrt04
                  NEXT FIELD lrt04
              WHEN INFIELD(lrt05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrt05"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrt05
                  NEXT FIELD lrt05
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
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lrs01 FROM lrs_file ",
                  " WHERE ", g_wc CLIPPED,
      #            "   AND lrsplant IN ",g_auth,
                  " ORDER BY lrs01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lrs01 ",
                  "  FROM lrs_file, lrt_file ",
                  " WHERE lrs01 = lrt01 ",
      #            "   AND lrsplant IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lrs01"
   END IF
 
   PREPARE t611_prepare FROM g_sql
   DECLARE t611_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t611_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lrs_file WHERE ",g_wc CLIPPED
      #          "   AND lrsplant IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lrs01) FROM lrs_file,lrt_file",
                " WHERE lrs01 = lrt01 ",
      #          "   AND lrsplant IN ",g_auth,
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
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
#FUN-C90070------add------str
         WHEN "output"
            IF cl_chk_act_auth() THEN
              CALL t611_out()
            END IF
#FUN-C90070------add------end
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t611_x()
            END IF
 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t611_b()
           ELSE
              LET g_action_choice = NULL
           END IF
 
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL t611_out()
        #   END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t611_y()
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t611_z()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrt),'','')
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_lrs.lrs02 IS NOT NULL THEN
                  LET g_doc.column1 = "lrs02"
                  LET g_doc.value1 = g_lrs.lrs02
                  CALL cl_doc()
               END IF
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t611_v(1)
               IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti)
            END IF
         #CHI-C80041---end
         #FUN-D20039 ------sta
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t611_v(2)
               IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti)
            END IF
         #FUN-D20039 ------end
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
   DISPLAY ARRAY g_lrt TO s_lrt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      #FUN-C90070----add---str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-C90070----add---end
 
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
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
     ON ACTION detail
        LET g_action_choice="detail"
        LET l_ac = 1
        EXIT DISPLAY
 
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY
 
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
      #FUN-D20039 -------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 -------end
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
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t611_bp_refresh()
  DISPLAY ARRAY g_lrt TO s_lrt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
#TQC-A60132 --Begin
FUNCTION t611_create_sql()
DEFINE l_sql STRING
      LET l_sql="drop procedure t611_proc1"
      EXECUTE IMMEDIATE l_sql
      LET l_sql=" create procedure t611_proc1 @v1 integer,@v2 integer,@v3 integer,@v4 nvarchar(20),@v5 nvarchar(1),@v7 nvarchar(20),@v8 integer,@v6 integer output"
                      ||" as begin"
                      ||" declare @i integer"
                      ||" set @i = 0"
                      ||" set @v6 = 0"
                      ||" while @i < @v3"
                      ||" begin "
                      ||" INSERT INTO t611_tmp1 "
                      ||" SELECT (ltrim(@v7) +"
                      ||" substring(cast(cast(power(10,@v8-len(@v1+@i)) as varchar) + cast((@i+@v1) as varchar) as varchar),2,@v8))"
                      ||" as lrt021,@v4 as lrt03,@v5 as lpj16 "
                      ||" set @v6=@v6+1"
                      ||" set @i = @i+1"
                      ||" end"
                      ||" end"                      
      EXECUTE IMMEDIATE l_sql
      PREPARE stmt FROM "{ CALL t611_proc1(?,?,?,?,?,?,?,?) }"
END FUNCTION
#TQC-A60132 --End
 
FUNCTION t611_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_lrt.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lrs.* LIKE lrs_file.*             #DEFAULT 設定
   LET g_lrs01_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_lrs_t.* = g_lrs.*
   LET g_lrs_o.* = g_lrs.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lrs.lrsplant = g_plant
      LET g_lrs.lrslegal = g_legal
      LET g_lrs.lrs02 = g_today
      LET g_lrs.lrs03 = 'N'      #審核狀態
      LET g_lrs.lrsuser=g_user
      LET g_lrs.lrsgrup=g_grup
      LET g_lrs.lrsoriu = g_user
      LET g_lrs.lrsorig = g_today
      LET g_lrs.lrscrat=g_today
      LET g_lrs.lrsacti='Y'              #資料有效
      LET g_data_plant = g_plant  #No.FUN-A10060
 
      CALL t611_lrsplant('d')
 
      CALL t611_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_lrs.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lrs.lrs02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入后, 若該單據需自動編號, 并且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lrs.lrs01,g_lrs.lrs02,g_kindtype,"lrs_file","lrs01",g_lrs.lrsplant,"","")
           RETURNING li_result,g_lrs.lrs01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lrs.lrs01
 
      INSERT INTO lrs_file VALUES (g_lrs.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK             # FUN-B80060 下移兩行
         CALL cl_err3("ins","lrs_file",g_lrs.lrs01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK             # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lrs.lrs01,'I')
         LET g_wc = " lrs01 = '",g_lrs.lrs01,"'"  #FUN-C90070 add
      END IF
 
      LET g_lrs01_t = g_lrs.lrs01        #保留舊值
      LET g_lrs_t.* = g_lrs.*
      LET g_lrs_o.* = g_lrs.*
      CALL g_lrt.clear()
 
      LET g_rec_b = 0
#     CALL t611_gen_body()
      CALL t611_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t611_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lrs.lrs01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lrs.* FROM lrs_file
    WHERE lrs01=g_lrs.lrs01
   #不可跨門店改動資料
   IF g_lrs.lrsplant <> g_plant THEN
      CALL cl_err(g_lrs.lrsplant,'alm-399',0)
      RETURN
   END IF
 
   IF g_lrs.lrsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lrs.lrs01,'mfg1000',0)
      RETURN
   END IF
   IF g_lrs.lrs03 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lrs.lrs03 = 'Y' THEN
      CALL cl_err(g_lrs.lrs01,'mfg1005',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lrs01_t = g_lrs.lrs01
   BEGIN WORK
 
   OPEN t611_cl USING g_lrs.lrs01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t611_cl INTO g_lrs.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t611_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t611_show()
 
   WHILE TRUE
      LET g_lrs01_t = g_lrs.lrs01
      LET g_lrs_o.* = g_lrs.*
      LET g_lrs.lrsmodu=g_user
      LET g_lrs.lrsdate=g_today
 
      CALL t611_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lrs.*=g_lrs_t.*
         CALL t611_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lrs.lrs01 != g_lrs01_t THEN            # 更改單號
         UPDATE lrt_file SET lrt01 = g_lrs.lrs01
          WHERE lrt01 = g_lrs01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lrt_file",g_lrs01_t,"",SQLCA.sqlcode,"","lrt",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lrs_file SET lrs_file.* = g_lrs.*
       WHERE lrs01 = g_lrs01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lrs_file",g_lrs01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t611_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lrs.lrs01,'U')
 
   CALL t611_show()
   CALL t611_b_fill("1=1")
   CALL t611_bp_refresh()
 
END FUNCTION
 
FUNCTION t611_i(p_cmd)
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
   DEFINE l_rtz13     LIKE rtz_file.rtz13     #FUN-A80148
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lrs.lrs01,g_lrs.lrs02,g_lrs.lrs03,
                   g_lrs.lrsuser,g_lrs.lrsmodu,g_lrs.lrscrat,
                   g_lrs.lrsgrup,g_lrs.lrsdate,g_lrs.lrsacti,
                   g_lrs.lrsplant,g_lrs.lrslegal,g_lrs.lrsoriu,
                   g_lrs.lrsorig
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_lrs.lrs01,g_lrs.lrs06
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t611_set_entry(p_cmd)
         CALL t611_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lrs01")
 
      AFTER FIELD lrs01
         #單號處理方式:
         #在輸入單別后, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 并檢查其是否重復
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成后, 再行自動指定單號
         IF NOT cl_null(g_lrs.lrs01) THEN
            CALL s_check_no("alm",g_lrs.lrs01,g_lrs01_t,g_kindtype,"lrs_file","lrs01","")
                 RETURNING li_result,g_lrs.lrs01
            IF (NOT li_result) THEN
               LET g_lrs.lrs01=g_lrs_o.lrs01
               NEXT FIELD lrs01
            END IF
            DISPLAY BY NAME g_lrs.lrs01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lrs01)     #單據編號
               LET g_t1=s_get_doc_no(g_lrs.lrs01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130 mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130  add
               LET g_lrs.lrs01 = g_t1
               DISPLAY BY NAME g_lrs.lrs01
               NEXT FIELD lrs01
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
   END INPUT
END FUNCTION
 
FUNCTION t611_lrsplant(p_cmd)  #門店編號
    DEFINE l_rtz13      LIKE rtz_file.rtz13
    DEFINE l_rtz28      LIKE rtz_file.rtz28
  # DEFINE l_rtzacti    LIKE rtz_file.rtzacti              #FUN-A80148 mark by vealxu
    DEFINE l_azwacti    LIKE azw_file.azwacti              #FUN-A80148 add  by vealxu 
    DEFINE p_cmd        LIKE type_file.chr1
    DEFINE l_azt02      LIKE azt_file.azt02
 
   LET g_errno = " "
 
   SELECT rtz13,rtz28,azwacti                              #FUN-A80148 mod rtzacti ->azwacti by vealxu
     INTO l_rtz13,l_rtz28,l_azwacti                        #FUN-A80148 mod l_rtzacti -> l_azwacti by vealxu 
     FROM rtz_file INNER JOIN azw_file                     #FUN-A80148 add azw_file by vealxu
       ON rtz01 = azw01                                    #FUN-A80148 add by vealxu  
    WHERE rtz01 = g_lrs.lrsplant
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-001'  #
                                  LET l_rtz13 = NULL
        WHEN l_rtz28 = 'N'        LET g_errno = 'alm-002'  #
      # WHEN l_rtzacti = 'N'      LET g_errno = 'aap-223'  #FUN-A80148 mark by vealxu
        WHEN l_azwacti = 'N'      LET g_errno = 'aap-223'  #FUN-A80148 add  by vealxu  
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF p_cmd <> 'd' THEN 
         SELECT azw02 INTO g_lrs.lrslegal FROM azw_file
          WHERE azw01 = g_lrs.lrsplant
         DISPLAY BY NAME g_lrs.lrslegal
      END IF 
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lrs.lrslegal
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION
 
FUNCTION t611_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lrt.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t611_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lrs.* TO NULL
      RETURN
   END IF
 
   OPEN t611_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lrs.* TO NULL
   ELSE
      OPEN t611_count
      FETCH t611_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t611_fetch('F')                  # 讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
FUNCTION t611_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t611_cs INTO g_lrs.lrs01
      WHEN 'P' FETCH PREVIOUS t611_cs INTO g_lrs.lrs01
      WHEN 'F' FETCH FIRST    t611_cs INTO g_lrs.lrs01
      WHEN 'L' FETCH LAST     t611_cs INTO g_lrs.lrs01
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
            FETCH ABSOLUTE g_jump t611_cs INTO g_lrs.lrs01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)
      INITIALIZE g_lrs.* TO NULL
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
 
   SELECT * INTO g_lrs.* FROM lrs_file WHERE lrs01 = g_lrs.lrs01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lrs_file",g_lrs.lrs01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lrs.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lrs.lrsuser
   LET g_data_group = g_lrs.lrsgrup
   LET g_data_plant = g_lrs.lrsplant
 
   CALL t611_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t611_show()
 
   LET g_lrs_t.* = g_lrs.*                #保存單頭舊值
   LET g_lrs_o.* = g_lrs.*                #保存單頭舊值
   DISPLAY BY NAME g_lrs.lrs01,g_lrs.lrs02,g_lrs.lrs03,
                   g_lrs.lrs04,g_lrs.lrs05,g_lrs.lrs06,
                   g_lrs.lrsplant,g_lrs.lrslegal,
                   g_lrs.lrsuser,g_lrs.lrsgrup,g_lrs.lrsmodu,
                   g_lrs.lrsdate,g_lrs.lrsacti,g_lrs.lrscrat,
                   g_lrs.lrsoriu,g_lrs.lrsorig
 
   CALL t611_lrsplant('d')
   #CALL cl_set_field_pic(g_lrs.lrs03,'','','','',g_lrs.lrsacti)  #CHI-C80041
   IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti)  #CHI-C80041
   CALL t611_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t611_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lrs.lrs01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #不可跨門店改動資料
   IF g_lrs.lrsplant <> g_plant THEN
      CALL cl_err(g_lrs.lrsplant,'alm-399',0)
      RETURN
   END IF
   IF g_lrs.lrs03 = 'Y' THEN
      CALL cl_err(g_lrs.lrs01,'aap-019',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t611_cl USING g_lrs.lrs01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t611_cl INTO g_lrs.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t611_show()
 
   IF cl_exp(0,0,g_lrs.lrsacti) THEN                   #確認一下
      LET g_chr=g_lrs.lrsacti
      IF g_lrs.lrsacti='Y' THEN
         LET g_lrs.lrsacti='N'
      ELSE
         LET g_lrs.lrsacti='Y'
      END IF
 
      UPDATE lrs_file SET lrsacti=g_lrs.lrsacti,
                          lrsmodu=g_user,
                          lrsdate=g_today
       WHERE lrs01=g_lrs.lrs01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lrs_file",g_lrs.lrs01,"",SQLCA.sqlcode,"","",1)
         LET g_lrs.lrsacti=g_chr
      END IF
   END IF
 
   CLOSE t611_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lrs.lrs02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lrsacti,lrsmodu,lrsdate
     INTO g_lrs.lrsacti,g_lrs.lrsmodu,g_lrs.lrsdate FROM lrs_file
    WHERE lrs01=g_lrs.lrs01
   DISPLAY BY NAME g_lrs.lrsacti,g_lrs.lrsmodu,g_lrs.lrsdate
   #CALL cl_set_field_pic(g_lrs.lrs03,'','','','',g_lrs.lrsacti)  #CHI-C80041
   IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti)  #CHI-C80041
END FUNCTION
 
FUNCTION t611_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lrs.lrs01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lrs.* FROM lrs_file
    WHERE lrs01=g_lrs.lrs01
   #不可跨門店改動資料
   IF g_lrs.lrsplant <> g_plant THEN
      CALL cl_err(g_lrs.lrsplant,'alm-399',0)
      RETURN
   END IF
   IF g_lrs.lrsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lrs.lrs01,'alm-147',0)
      RETURN
   END IF
   IF g_lrs.lrs03 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lrs.lrs03 = 'Y' THEN
      CALL cl_err(g_lrs.lrs01,'alm-028',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t611_cl USING g_lrs.lrs01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t611_cl INTO g_lrs.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t611_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lrs02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lrs.lrs02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lrs_file WHERE lrs01 = g_lrs.lrs01
      DELETE FROM lrt_file WHERE lrt01 = g_lrs.lrs01
      CLEAR FORM
      CALL g_lrt.clear()
      OPEN t611_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t611_cs
         CLOSE t611_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t611_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t611_cs
         CLOSE t611_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
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
   CALL cl_flow_notify(g_lrs.lrs01,'D')
END FUNCTION
 
FUNCTION t611_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT lrt02,lrt03,'','','','',lrt04,lrt05 ",
               "  FROM lrt_file ",
               " WHERE lrt01 ='",g_lrs.lrs01,"' " 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrt02 "
 
   PREPARE t611_pb FROM g_sql
   DECLARE lrt_cs CURSOR FOR t611_pb
 
   CALL g_lrt.clear()
   LET g_cnt = 1
 
   FOREACH lrt_cs INTO g_lrt[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT lph32,lph33,lph34,lph35
         INTO g_lrt[g_cnt].lph32,g_lrt[g_cnt].lph33,
              g_lrt[g_cnt].lph34,g_lrt[g_cnt].lph35
         FROM lph_file
        WHERE lph01 = g_lrt[g_cnt].lrt03
        
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lrt.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t611_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lrs01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t611_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lrs01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t611_y()
   DEFINE l_lrt    RECORD LIKE lrt_file.*
   DEFINE l_lqe    RECORD LIKE lqe_file.*
 
   IF g_lrs.lrs01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ---------------- add --------------- begin
   IF g_lrs.lrsplant <> g_plant THEN
      CALL cl_err(g_lrs.lrsplant,'alm-399',0)
      RETURN
   END IF
   IF g_lrs.lrsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lrs.lrs01,'mfg1000',0)
      RETURN
   END IF
   IF g_lrs.lrs03 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lrs.lrs03 = 'Y' THEN
      CALL cl_err(g_lrs.lrs01,'mfg1005',0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-017') THEN RETURN END IF
#CHI-C30107 ---------------- add --------------- end 
   SELECT * INTO g_lrs.* FROM lrs_file
    WHERE lrs01=g_lrs.lrs01
 
   #不可跨門店改動資料
   IF g_lrs.lrsplant <> g_plant THEN
      CALL cl_err(g_lrs.lrsplant,'alm-399',0)
      RETURN
   END IF
   IF g_lrs.lrsacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lrs.lrs01,'mfg1000',0)
      RETURN
   END IF
   IF g_lrs.lrs03 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lrs.lrs03 = 'Y' THEN
      CALL cl_err(g_lrs.lrs01,'mfg1005',0)
      RETURN
   END IF
   IF g_rec_b <= 0 THEN
      CALL cl_err(g_lrs.lrs01,'atm-228',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('aap-017') THEN RETURN END IF  #CHI-C30107 mark
 
#FUN-C90066 Begin---
#  DROP TABLE t611_tmp1;
#  DROP TABLE t611_tmp2;
#  DROP TABLE t611_tmp5;
#  CREATE TEMP TABLE t611_tmp1(
#         lrt021 LIKE lpj_file.lpj03,
#         lrt03 LIKE lrt_file.lrt03,
#         lpj16 LIKE lpj_file.lpj16);
#  CREATE TEMP TABLE t611_tmp2(
#         lpj03  LIKE lpj_file.lpj03,
#         lpj09  LIKE lpj_file.lpj09);
# #CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lrt021); #TQC-A60132
#  CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lpj03);  #TQC-A60132
#  CREATE TEMP TABLE t611_tmp5(
#         lrt021 LIKE lpj_file.lpj03);
#  CREATE UNIQUE INDEX t611_tmp5_01 ON t611_tmp5(lrt021);

   CALL t611_create_tmp_table()
#FUN-C90066 End-----
 
   BEGIN WORK
   OPEN t611_cl USING g_lrs.lrs01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t611_cl INTO g_lrs.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()
 
   CALL t611_y_new()
   
   IF g_success = 'N' THEN
   #   RETURN
   END IF
   
   UPDATE lrs_file SET lrs03 = 'Y',lrs04 = g_user,lrs05 = g_today
    WHERE lrs01=g_lrs.lrs01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lrs01',g_lrs.lrs01,'update lqy',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DISPLAY "Finish:",TIME
   CALL s_showmsg()
   CLOSE t611_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT lrs03,lrs04,lrs05 INTO g_lrs.lrs03,g_lrs.lrs04,g_lrs.lrs05
        FROM lrs_file
       WHERE lrs01=g_lrs.lrs01
      DISPLAY BY NAME g_lrs.lrs03,g_lrs.lrs04,g_lrs.lrs05
   ELSE
      ROLLBACK WORK
   END IF
   #CALL cl_set_field_pic(g_lrs.lrs03,'','','','',g_lrs.lrsacti)  #CHI-C80041
   IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti)  #CHI-C80041
END FUNCTION
 
FUNCTION t611_z()
   DEFINE l_lrt         RECORD LIKE lrt_file.*
   DEFINE l_cnt         LIKE type_file.num20
 
   IF g_lrs.lrs01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lrs.* FROM lrs_file
    WHERE lrs01=g_lrs.lrs01
 
   #不可跨門店改動資料
   IF g_lrs.lrsplant <> g_plant THEN
      CALL cl_err(g_lrs.lrsplant,'alm-399',0)
      RETURN
   END IF
   IF g_lrs.lrs03 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lrs.lrs03 = 'N' THEN  #未審核
      CALL cl_err(g_lrs.lrs01,'9025',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF
 
#FUN-C90066 Begin---
#  DROP TABLE t611_tmp1;
#  DROP TABLE t611_tmp2;
#  DROP TABLE t611_tmp5;
#  CREATE TEMP TABLE t611_tmp1(
#         lrt021 LIKE lpj_file.lpj03,
#         lrt03 LIKE lrt_file.lrt03,
#         lpj16 LIKE lpj_file.lpj16);
#  CREATE TEMP TABLE t611_tmp2(
#         lpj03  LIKE lpj_file.lpj03,
#         lpj09  LIKE lpj_file.lpj09);
#  CREATE UNIQUE INDEX t611_tmp1_01 ON t611_tmp1(lrt021);
# #CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lrt021); #TQC-A60132
#  CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lpj03);  #TQC-A60132
#  CREATE TEMP TABLE t611_tmp5(
#         lrt021 LIKE lpj_file.lpj03);
#  CREATE UNIQUE INDEX t611_tmp5_01 ON t611_tmp5(lrt021);

   CALL t611_create_tmp_table()
#FUN-C90066 End-----
 
   BEGIN WORK
   OPEN t611_cl USING g_lrs.lrs01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t611_cl INTO g_lrs.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   DECLARE t611_z_cs CURSOR FOR
    SELECT * FROM lrt_file
     WHERE lrt01 = g_lrs.lrs01
 
   CALL s_showmsg_init()
 
   CALL t611_z_new()
   IF g_success = 'Y' THEN   
      DISPLAY "Undo Confirm Delete From lpj_file Begin Time:",TIME
      DELETE FROM lpj_file WHERE EXISTS (SELECT 'X' FROM t611_tmp1
                                          WHERE lpj03 = t611_tmp1.lrt021)    
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lrs02',g_lrs.lrs01,'delete lpj',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      DISPLAY "Undo Confirm Delete From lpj_file End Time:",TIME
  
#     UPDATE lrs_file SET lrs03 = 'N',lrs04 = '',lrs05 = ''
      UPDATE lrs_file SET lrs03 = 'N',lrs04 = '',lrs05 = NULL         #CHI-D20015 mark
#     UPDATE lrs_file SET lrs03 = 'N',lrs04 = g_user,lrs05 = g_today  #CHI-D20015  
       WHERE lrs01=g_lrs.lrs01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lrs01',g_lrs.lrs01,'update lqy',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   CALL s_showmsg()
      
   CLOSE t611_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT lrs03,lrs04,lrs05 INTO g_lrs.lrs03,g_lrs.lrs04,g_lrs.lrs05
        FROM lrs_file
       WHERE lrs01=g_lrs.lrs01
      DISPLAY BY NAME g_lrs.lrs03,g_lrs.lrs04,g_lrs.lrs05
   ELSE
      ROLLBACK WORK
   END IF
   DISPLAY "Undo Confirm End Time:",TIME
   #CALL cl_set_field_pic(g_lrs.lrs03,'','','','',g_lrs.lrsacti)  #CHI-C80041
   IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti)  #CHI-C80041
END FUNCTION
 
#FUN-870007-start-
FUNCTION t611_y_chk()
DEFINE l_cnt LIKE type_file.num5
      
#        LET g_sql = "DELETE FROM t611_tmp5 a",
#                    " WHERE NOT EXISTS (SELECT 1 FROM lqe_file " 
#        
#   EXECUTE IMMEDIATE g_sql
#   IF SQLCA.sqlcode THEN
#        CALL s_errmsg('','','delete from t611_tmp5',SQLCA.sqlcode,1)
#        LET g_success = 'N'
#        RETURN
#   END IF 
#   SELECT COUNT(*) INTO l_cnt FROM t611_tmp5
#   IF l_cnt > 0 THEN
#      CALL t611_error('t611_tmp5',6,'alm-470')
#      LET g_success = 'N'
#      RETURN
#   END IF   
END FUNCTION
#FUN-870007--end--
 
FUNCTION t611_y_new()
   DEFINE l_cnt         LIKE type_file.num20
   DEFINE l_cnt1        LIKE type_file.num20
   DEFINE l_lph03       LIKE lph_file.lph03
   DEFINE l_lph33       LIKE lph_file.lph33
   DEFINE l_lph34       LIKE lph_file.lph34
   DEFINE l_lrt         RECORD
                        lrt03   LIKE lrt_file.lrt03,   #卡種
                        lrt04   LIKE lrt_file.lrt04,   #開始卡號
                        lrt05   LIKE lrt_file.lrt05    #結束卡號
                        END RECORD
 
   DISPLAY "Confirm Begin:",TIME
 
   LET g_sql = "SELECT lrt03,lrt04,lrt05 ",
               "  FROM lrt_file ",
               " WHERE lrt01 ='",g_lrs.lrs01,"' " 
#  IF NOT cl_null(p_wc2) THEN
#     LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
#  END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrt04 "
 
   PREPARE t611_pb_y FROM g_sql
   DECLARE lrt_cs_y CURSOR FOR t611_pb_y
 
#  CALL l_lrt.clear()
   LET g_cnt = 1
 
   FOREACH lrt_cs_y INTO l_lrt.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       SELECT lph03,lph34,lph33 INTO l_lph03,l_lph34,l_lph33
         FROM lph_file
        WHERE lph01 = l_lrt.lrt03
       CALL t611_gen_card_no(l_lrt.lrt03,l_lph03,l_lph33,l_lph34,l_lrt.lrt04,l_lrt.lrt05,1)
        
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
  #CALL t611_ins_lpj_tmp(2) #FUN-C90066
   CALL t611_lpj_check1(3)
  
   SELECT COUNT(*) INTO l_cnt FROM t611_tmp5
   IF l_cnt > 0 THEN 
      LET g_success = 'N'
      CALL t611_error('t611_tmp5',3,'alm-577')
      RETURN
   ELSE
      LET g_sql = " INSERT INTO lpj_file(lpj02,lpj03,lpj09,lpj16,lpj18,lpj19,lpj07,lpj12,lpj13,lpj14,lpj15) ",
                  " SELECT lrt03,lrt021,'1',lpj16,",
                  "       '",g_today,"', ",
                  "       '",g_lrs.lrsplant,"',0,0,0,0,0 ",
                  "  FROM t611_tmp1 "
      PREPARE t611_reg_p4 FROM g_sql
      EXECUTE t611_reg_p4
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','insert lpj_file',SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF
END FUNCTION

#產生卡號插入t611_tmp1
FUNCTION t611_gen_card_no(p_lrt03,p_lph03,p_lph33,p_lph34,p_no1,p_no2,p_step)
 DEFINE p_step            LIKE type_file.num5
 DEFINE l_rows            LIKE type_file.num20
 DEFINE p_no1             LIKE lrt_file.lrt04
 DEFINE p_no2             LIKE lrt_file.lrt05
 DEFINE l_start_no        LIKE type_file.num20
 DEFINE l_end_no          LIKE type_file.num20
 DEFINE l_start_no1       LIKE type_file.num20
 DEFINE l_length          LIKE type_file.num5
 DEFINE l_length1         LIKE type_file.num5
 DEFINE l_no              LIKE lrt_file.lrt04
 DEFINE p_lph03           LIKE lph_file.lph03
 DEFINE p_lph33           LIKE lph_file.lph33
 DEFINE p_lph34           LIKE lph_file.lph34
 DEFINE p_lrt03           LIKE lrt_file.lrt03
 DEFINE l_nums            LIKE type_file.num20
#TQC-A60132 --Begin
 DEFINE l_db_type         LIKE type_file.chr4
#TQC-A60132 --End
 
  #FUN-C90066 Begin---
  #DISPLAY 'begin_time:',TIME
  #ERROR 'Begin Step ',p_step USING "&<",'(產生卡號)'
  #CALL ui.Interface.refresh()
  #FUN-C90066 End-----
   DISPLAY '產生卡號開始:',TIME
   
#  LET l_no = p_no1[1,p_lph33]     #TQC-D30031  --mark--
   LET l_length  = LENGTH(p_no1)
   #LET l_length1 = LENGTH(p_no1)-LENGTH(p_lph34) #MOD-CA0064 mark
   LET l_length1 = LENGTH(p_no1)-p_lph33          #MOD-CA0064 add
   LET l_start_no = p_no1[p_lph33+1,l_length]
   LET l_end_no = p_no2[p_lph33+1,l_length]
   LET l_nums = l_end_no - l_start_no + 1
   IF cl_null(l_nums) THEN LET l_nums = 0 END IF
   LET l_start_no1 = l_start_no - 1
#TQC-A60132 --Begin
   LET l_db_type=cl_db_get_database_type()
   IF l_db_type='MSV' THEN
      CALL t611_create_sql()
      EXECUTE stmt USING l_start_no IN,l_end_no IN,l_nums IN,p_lrt03 IN,p_lph03 IN,p_lph34 IN,l_length1 IN,l_rows OUT
   ELSE
#TQC-A60132 --End
  #LET g_sql = "SELECT CONCAT('",p_lph34 CLIPPED,"',",
  #            "  LPAD(to_char(id+",l_start_no1,"),",l_length1,",'0')) as lrt021,'",p_lrt03,"' as lrt03, '",p_lph03,"' as lpj16 ",
  #            "  FROM (SELECT level AS id FROM dual ",
  #            "         CONNECT BY level <=",l_nums,")",
  #            "  INTO TEMP t611_tmp1"
   LET g_sql = "SELECT ('",p_lph34 CLIPPED,"' || ",   
               " substr(power(10,",l_length1,"-length(id+",l_start_no1,")) || (id+",l_start_no1,"),2))",
               " as lrt021,'",p_lrt03,"' as lrt03, '",p_lph03,"' as lpj16 ",
               "  FROM (SELECT level AS id FROM dual ",   
               "         CONNECT BY level <=",l_nums,")",
               "  INTO TEMP t611_tmp1"
   PREPARE t611_reg_p1 FROM g_sql
   EXECUTE t611_reg_p1
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t611_tmp1',SQLCA.sqlcode,1)
      RETURN
   END IF
   END IF #TQC-A60132
   IF l_db_type<>'MSV' THEN #TQC-A60132
      LET l_rows = SQLCA.sqlerrd[3]
   END IF                   #TQC-A60132
   DISPLAY '產生卡號結束:',TIME,l_rows
  ##FUN-C90066 Begin---
  #ERROR 'Finish Step ',p_step USING "&<",'(產生卡號):',l_rows,'rows'
  #CALL ui.Interface.refresh()
  #CREATE UNIQUE INDEX t611_tmp1_01 ON t611_tmp1(lrt021);
  #FUN-C90066 End-----
END FUNCTION

FUNCTION t611_z_new()
   DEFINE l_cnt         LIKE type_file.num20
   DEFINE l_cnt1        LIKE type_file.num20
   DEFINE l_lph03       LIKE lph_file.lph03
   DEFINE l_lph33       LIKE lph_file.lph33
   DEFINE l_lph34       LIKE lph_file.lph34
   DEFINE l_lrt         RECORD
                        lrt03   LIKE lrt_file.lrt03,   #卡種
                        lrt04   LIKE lrt_file.lrt04,   #開始卡號
                        lrt05   LIKE lrt_file.lrt05    #結束卡號
                        END RECORD
 
   DISPLAY "取消審核開始:",TIME
 
   DISPLAY "單身卡插入臨時表t611_tmp1開始:",TIME
 
   LET g_sql = "SELECT lrt03,lrt04,lrt05 ",
               "  FROM lrt_file ",
               " WHERE lrt01 ='",g_lrs.lrs01,"' " 
#  IF NOT cl_null(p_wc2) THEN
#     LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
#  END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrt04 "
 
   PREPARE t611_pb_z FROM g_sql
   DECLARE lrt_cs_z CURSOR FOR t611_pb_z
 
#  CALL l_lrt.clear()
   LET g_cnt = 1
 
   FOREACH lrt_cs_z INTO l_lrt.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT l_lph03,lph34,lph33 INTO l_lph03,l_lph34,l_lph33
         FROM lph_file
        WHERE lph01 = l_lrt.lrt03
       CALL t611_gen_card_no(l_lrt.lrt03,l_lph03,l_lph33,l_lph34,l_lrt.lrt04,l_lrt.lrt05,1)
        
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   
  #CALL t611_ins_lpj_tmp(2) #FUN-C90066
   LET g_sql = "INSERT INTO t611_tmp5(lrt021) ",
               "SELECT t611_tmp1.lrt021 FROM t611_tmp1 ",
              #" WHERE t611_tmp1.lrt021 IN (SELECT lpj03 FROM t611_tmp2 WHERE lpj09 <> '1' )" #FUN-C90066
               " WHERE t611_tmp1.lrt021 IN (SELECT lpj03 FROM lpj_file  WHERE lpj09 <> '1' )" #FUN-C90066
   PREPARE t611_rz3 FROM g_sql
   EXECUTE t611_rz3
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','insert temp t611_tmp5',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM t611_tmp5
   IF l_cnt > 0 THEN
      CALL t611_error('t611_tmp5',3,'alm-578')
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION t611_b()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.num5,
       l_allow_delete  LIKE type_file.num5
DEFINE l_dbs LIKE tqb_file.tqb05
DEFINE l_start LIKE lrt_file.lrt04
DEFINE l_end LIKE lrt_file.lrt05
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_lrs.lrs01) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_lrs.* FROM lrs_file
         WHERE lrs01=g_lrs.lrs01
        
        #不可跨門店改動資料
        IF g_lrs.lrsplant <> g_plant THEN
           CALL cl_err(g_lrs.lrsplant,'alm-399',0)
           RETURN
        END IF
 
        IF g_lrs.lrsacti ='N' THEN    #檢查資料是否為無效
           CALL cl_err(g_lrs.lrs01,'mfg1000',0)
           RETURN
        END IF
        IF g_lrs.lrs03 = 'X' THEN RETURN END IF  #CHI-C80041
        IF g_lrs.lrs03 = 'Y' THEN
           CALL cl_err(g_lrs.lrs01,'mfg1005',0)
           RETURN
        END IF
 
#FUN-C90066 Begin---
#       DROP TABLE t611_tmp1;
#       DROP TABLE t611_tmp2;
#       DROP TABLE t611_tmp5;
#       CREATE TEMP TABLE t611_tmp1(
#              lrt021 LIKE lpj_file.lpj03,
#              lrt03 LIKE lrt_file.lrt03,
#              lpj16 LIKE lpj_file.lpj16);
#       CREATE TEMP TABLE t611_tmp2(
#              lpj03  LIKE lpj_file.lpj03,
#              lpj09  LIKE lpj_file.lpj09);
#       CREATE UNIQUE INDEX t611_tmp1_01 ON t611_tmp1(lrt021);
##      CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lrt021); #TQC-A60132
#       CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lpj03);  #TQC-A60132
#       CREATE TEMP TABLE t611_tmp5(
#              lrt021 LIKE lpj_file.lpj03);
#       CREATE UNIQUE INDEX t611_tmp5_01 ON t611_tmp5(lrt021);

        CALL t611_create_tmp_table()
#FUN-C90066 End-----
 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql= "SELECT lrt02,lrt03,'','','','',lrt04,lrt05 ",
                          "  FROM lrt_file ",
                          " WHERE lrt01 = ? ",
                          "   AND lrt02 = ? ",
                          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE t611_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_lrt WITHOUT DEFAULTS FROM s_lrt.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
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
                OPEN t611_cl USING g_lrs.lrs01
                IF STATUS THEN
                   CALL cl_err("OPEN t611_cl:",STATUS,1)
                   CLOSE t611_cl
                   ROLLBACK WORK
                END IF
                
                FETCH t611_cl INTO g_lrs.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)
                        CLOSE t611_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                    LET p_cmd ='u'
                    LET g_lrt_t.*=g_lrt[l_ac].*
                    LET g_lrt_o.*=g_lrt[l_ac].*
                    OPEN t611_bcl USING g_lrs.lrs01,g_lrt_t.lrt02
                    IF STATUS THEN
                       CALL cl_err("OPEN t611_bcl:",STATUS,1)
                       LET l_lock_sw='Y'
                    ELSE
                       FETCH t611_bcl INTO g_lrt[l_ac].*
                       IF SQLCA.sqlcode THEN
                          CALL cl_err(g_lrt_t.lrt02,SQLCA.sqlcode,1)
                          LET l_lock_sw="Y"
                       END IF
                       CALL t611_lrt03(p_cmd)
                       CALL cl_set_comp_entry("lrt03",TRUE)
                       CALL cl_set_comp_required("lrt02,lrt03,lrt04,lrt05",TRUE)
                    END IF
                 END IF
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_lrt[l_ac].* TO NULL
                LET g_lrt_t.*=g_lrt[l_ac].*
                CALL cl_set_comp_entry("lrt03",TRUE)
                CALL cl_set_comp_required("lrt02,lrt03,lrt04,lrt05",TRUE)
                CALL cl_show_fld_cont()
                NEXT FIELD lrt02
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO lrt_file(lrt01,lrt02,lrt03,lrt04,lrt05,lrtplant,lrtlegal)
                 VALUES(g_lrs.lrs01,g_lrt[l_ac].lrt02,g_lrt[l_ac].lrt03,
                        g_lrt[l_ac].lrt04,g_lrt[l_ac].lrt05,
                        g_lrs.lrsplant,g_lrs.lrslegal)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","lrt_file",g_lrs.lrs01,g_lrt[l_ac].lrt02,SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                ELSE
                   MESSAGE 'INSERT O.K.'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
      BEFORE FIELD lrt02
        IF cl_null(g_lrt[l_ac].lrt02) OR g_lrt[l_ac].lrt02 = 0 THEN 
            SELECT max(lrt02)+1 INTO g_lrt[l_ac].lrt02
              FROM lrt_file
             WHERE lrt01 = g_lrs.lrs01
            IF g_lrt[l_ac].lrt02 IS NULL THEN
               LET g_lrt[l_ac].lrt02=1
            END IF
         END IF
         
      AFTER FIELD lrt02 #項次
        IF NOT cl_null(g_lrt[l_ac].lrt02) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_lrt[l_ac].lrt02 <> g_lrt_t.lrt02) THEN
              SELECT COUNT(*) INTO l_n FROM lrt_file
               WHERE lrt01 = g_lrs.lrs01
                 AND lrt02 = g_lrt[l_ac].lrt02
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_lrt[l_ac].lrt02=g_lrt_t.lrt02
                 NEXT FIELD lrt02
              END IF
           END IF
         END IF
       
       AFTER FIELD lrt03
          IF NOT cl_null(g_lrt[l_ac].lrt03) THEN 
             IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                g_lrt[l_ac].lrt03 <> g_lrt_t.lrt03) THEN
                CALL t611_lrt03(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lrt03
                END IF
             END IF
          END IF
 
       BEFORE FIELD lrt04,lrt05
          IF cl_null(g_lrt[l_ac].lrt03) THEN
             CALL cl_err('','alm-536',0)
             NEXT FIELD lrt03
          END IF
 
       AFTER FIELD lrt04 #起始編號
         IF NOT cl_null(g_lrt[l_ac].lrt04) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_lrt[l_ac].lrt04 <> g_lrt_t.lrt04) THEN
              CALL t611_lrt04(g_lrt[l_ac].lrt04,p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lrt[l_ac].lrt04,g_errno,0)
                 LET g_lrt[l_ac].lrt04 = g_lrt_t.lrt04
                 DISPLAY BY NAME g_lrt[l_ac].lrt04
                 NEXT FIELD lrt04
              END IF
              IF NOT cl_null(g_lrt[l_ac].lrt05)THEN
                #FUN-C90066 Begin---
                #CALL t611_check_no(g_lrt[l_ac].lrt03,g_lrt[l_ac].lph34,g_lrt[l_ac].lrt04,g_lrt[l_ac].lrt05,p_cmd)
                 CALL t611_check_no(g_lrt[l_ac].lrt03,g_lrt[l_ac].lrt04,g_lrt[l_ac].lrt05,p_cmd)
                #FUN-C90066 End-----
                 IF g_success = 'N' THEN
                    LET g_lrt[l_ac].lrt04 = g_lrt_t.lrt04
                    DISPLAY BY NAME g_lrt[l_ac].lrt04
                    NEXT FIELD lrt04
                 END IF
              END IF
           END IF
         END IF
       
       AFTER FIELD lrt05 #結束編號
         IF NOT cl_null(g_lrt[l_ac].lrt05) THEN 
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
              g_lrt[l_ac].lrt05 <> g_lrt_t.lrt05) THEN
              CALL t611_lrt04(g_lrt[l_ac].lrt05,p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_lrt[l_ac].lrt05,g_errno,0)
                 LET g_lrt[l_ac].lrt05 = g_lrt_t.lrt05
                 DISPLAY BY NAME g_lrt[l_ac].lrt05
                 NEXT FIELD lrt05
              END IF
              IF NOT cl_null(g_lrt[l_ac].lrt04)THEN
                #FUN-C90066 Begin---
                #CALL t611_check_no(g_lrt[l_ac].lrt03,g_lrt[l_ac].lph34,g_lrt[l_ac].lrt04,g_lrt[l_ac].lrt05,p_cmd)
                 CALL t611_check_no(g_lrt[l_ac].lrt03,g_lrt[l_ac].lrt04,g_lrt[l_ac].lrt05,p_cmd)
                #FUN-C90066 End-----
                 IF g_success = 'N' THEN
                    LET g_lrt[l_ac].lrt05 = g_lrt_t.lrt05
                    DISPLAY BY NAME g_lrt[l_ac].lrt05
                    NEXT FIELD lrt05
                 END IF
              END IF
           END IF
         END IF
         
       BEFORE DELETE                      
           IF g_lrt_t.lrt02 > 0 AND NOT cl_null(g_lrt_t.lrt02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lrt_file
               WHERE lrt01 = g_lrs.lrs01
                 AND lrt02 = g_lrt_t.lrt02
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","lrt_file",g_lrs.lrs01,g_lrt_t.lrt02,SQLCA.sqlcode,"","",1)  
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
              LET g_lrt[l_ac].* = g_lrt_t.*
              CLOSE t611_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lrt[l_ac].lrt02,-263,1)
              LET g_lrt[l_ac].* = g_lrt_t.*
           ELSE
              UPDATE lrt_file SET lrt02 = g_lrt[l_ac].lrt02,
                                  lrt03 = g_lrt[l_ac].lrt03,
                                  lrt04 = g_lrt[l_ac].lrt04,
                                  lrt05 = g_lrt[l_ac].lrt05
                 WHERE lrt01 = g_lrs.lrs01
                   AND lrt02 = g_lrt_t.lrt02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lrt_file",g_lrs.lrs01,g_lrt_t.lrt02,SQLCA.sqlcode,"","",1) 
                 LET g_lrt[l_ac].* = g_lrt_t.*
              ELSE                
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lrt[l_ac].* = g_lrt_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lrt.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t611_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE t611_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(lrt02) AND l_ac > 1 THEN
              LET g_lrt[l_ac].* = g_lrt[l_ac-1].*
              LET g_lrt[l_ac].lrt02 = g_rec_b + 1
              NEXT FIELD lrt05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(lrt03)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lph1" 
               LET g_qryparam.default1 = g_lrt[l_ac].lrt03
               CALL cl_create_qry() RETURNING g_lrt[l_ac].lrt03
               DISPLAY BY NAME g_lrt[l_ac].lrt03
               CALL t611_lrt03('d')
               NEXT FIELD lrt03
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
    LET g_lrs.lrsmodu = g_user
    LET g_lrs.lrsdate = g_today
    UPDATE lrs_file SET lrsmodu = g_lrs.lrsmodu,
                        lrsdate = g_lrs.lrsdate
     WHERE lrs01 = g_lrs.lrs01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","lrs_file",g_lrs.lrsmodu,g_lrs.lrsdate,SQLCA.sqlcode,"","",1)
    END IF
    DISPLAY BY NAME g_lrs.lrsmodu,g_lrs.lrsdate
    CLOSE t611_bcl
    COMMIT WORK
#   CALL t611_delall()  #CHI-C30002 mark
    CALL t611_delHeader()     #CHI-C30002 add
    CALL t611_show()
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
      CALL s_get_doc_no(g_lrs.lrs01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lrs_file ",
                  "  WHERE lrs01 LIKE '",l_slip,"%' ",
                  "    AND lrs01 > '",g_lrs.lrs01,"'"
      PREPARE t611_pb1 FROM l_sql 
      EXECUTE t611_pb1 INTO l_cnt       
      
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
         CALL t611_v(1)
         IF g_lrs.lrs03='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_lrs.lrs03,'','','',g_void,g_lrs.lrsacti) 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lrs_file WHERE lrs01 = g_lrs.lrs01
         INITIALIZE g_lrs.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#CHI-C30002 -------- mark -------- begin
#FUNCTION t611_delall()
#刪除單頭資料
#  SELECT COUNT(*) INTO g_cnt FROM lrt_file
#   WHERE lrt01 = g_lrs.lrs01
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#
#     DELETE FROM lrs_file
#      WHERE lrs01 = g_lrs.lrs01
#     CLEAR FORM 
#     INITIALIZE g_lrs.* TO NULL
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t611_lrt03(p_cmd)
 DEFINE l_lph24        LIKE lph_file.lph24
 DEFINE l_lph32        LIKE lph_file.lph32
 DEFINE l_lph33        LIKE lph_file.lph33
 DEFINE l_lph34        LIKE lph_file.lph34
 DEFINE l_lph35        LIKE lph_file.lph35
 DEFINE p_cmd          LIKE type_file.chr1
 DEFINE l_cnt          LIKE type_file.num5
 
   LET g_errno = " "
 
   SELECT lph24,lph32,lph33,lph34,lph35
     INTO l_lph24,l_lph32,l_lph33,l_lph34,l_lph35
     FROM lph_file
    WHERE lph01 = g_lrt[l_ac].lrt03
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-635'
                                  LET l_lph32 = NULL
        WHEN l_lph24 = 'N'        LET g_errno = '9029'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lnk_file
       WHERE lnk01 = g_lrt[l_ac].lrt03
         AND lnk02 = '1'
         AND lnk03 = g_lrs.lrsplant
         AND lnk05 = 'Y'
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-694'
      END IF
   END IF
   #FUN-C30044 STA
   IF cl_null(g_errno) THEN
      IF p_cmd = 'a' OR 
           g_lrt[l_ac].lrt03 <> g_lrt_t.lrt03 THEN
         CALL t611_lrt04_lrt05(l_lph32,l_lph33,l_lph34,l_lph35) 
      END IF
   END IF    
   #FUN-C30044 END
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lrt[l_ac].lph32 = l_lph32
      LET g_lrt[l_ac].lph33 = l_lph33
      LET g_lrt[l_ac].lph34 = l_lph34
      LET g_lrt[l_ac].lph35 = l_lph35
      
      DISPLAY BY NAME g_lrt[l_ac].lph32,g_lrt[l_ac].lph33,
                      g_lrt[l_ac].lph34,g_lrt[l_ac].lph35,
                      g_lrt[l_ac].lrt04,g_lrt[l_ac].lrt05 #FUN-C30044 add 
   END IF
END FUNCTION
 
FUNCTION t611_lrt04(p_no,p_cmd)
 DEFINE p_cmd          LIKE type_file.chr1
 DEFINE p_no           LIKE lrt_file.lrt04
 DEFINE l_no           LIKE lrt_file.lrt04
 DEFINE l_length       LIKE type_file.num5
 DEFINE l_lph34        LIKE lph_file.lph34     #FUN-D10021 add
 DEFINE l_lph32        LIKE lph_file.lph32     #FUN-D10021 add 
    LET g_errno = ''
    IF g_lrt[l_ac].lph33 > 0 THEN          #TQC-D30031 add
       LET l_no = p_no[1,g_lrt[l_ac].lph33]
    END IF                                 #TQC-D30031 add
    LET l_length = LENGTH(p_no)
    IF g_lrt[l_ac].lph32 <> l_length OR
      #g_lrt[l_ac].lph34 <> l_no THEN                                                               #TQC-D30031 MARK
      (g_lrt[l_ac].lph34 <> l_no AND g_lrt[l_ac].lph33 > 0 AND NOT cl_null(g_lrt[l_ac].lph34))THEN  #TQC-D30031 add
       LET g_errno = 'alm-687'
       RETURN
    END IF
   #FUN-D10021--add--str---
    SELECT lph32,lph34 INTO l_lph32,l_lph34 FROM lph_file
     WHERE lph01 = g_lrt[l_ac].lrt03
   #FUN-D10021--add--end---
    IF cl_null(g_errno) THEN
       SELECT COUNT(*) INTO g_cnt FROM lrs_file,lrt_file,lph_file        #FUN-D10021 add lph_file
        WHERE lrs03 = 'N' AND lrt01 = lrs01
       #  AND substr(lrt04,g_lrt[l_ac].lph33+1,l_length) <= substr(p_no,g_lrt[l_ac].lph33+1,l_length)
       #  AND substr(lrt05,g_lrt[l_ac].lph33+1,l_length) >= substr(p_no,g_lrt[l_ac].lph33+1,l_length) 
       #  AND substr(lrt04,1,g_lrt[l_ac].lph33) = l_no
       #  AND lrt02 <> g_lrt[l_ac].lrt02
          AND lrt04 <= p_no
          AND lrt05 >= p_no
      #   AND lrt03 = g_lrt[l_ac].lrt03             #FUN-D10021 mark
          AND lrt02 <> g_lrt[l_ac].lrt02       
          AND lrt03 = lph01 AND lph34 = l_lph34 AND LENGTH(lrt05) = l_lph32     #FUN-D10021 add
       IF g_cnt > 0 THEN
          LET g_errno = 'alm-579'
       END IF
    END IF
    IF cl_null(g_errno) AND NOT cl_null(g_lrt[l_ac].lrt04) AND
       NOT cl_null(g_lrt[l_ac].lrt05) THEN 
       IF g_lrt[l_ac].lrt04[g_lrt[l_ac].lph33+1,l_length] > g_lrt[l_ac].lrt05[g_lrt[l_ac].lph33+1,l_length] THEN
          LET g_errno = 'aim-919'
          RETURN
       END IF
       SELECT COUNT(*) INTO g_cnt FROM lrs_file,lrt_file,lph_file        #FUN-D10021 add lph_file
        WHERE lrs03 = 'N' AND lrt01 = lrs01
       #  AND substr(lrt04,g_lrt[l_ac].lph33+1,l_length) >= substr(g_lrt[l_ac].lrt04,g_lrt[l_ac].lph33+1,l_length)
       #  AND substr(lrt05,g_lrt[l_ac].lph33+1,l_length) <= substr(g_lrt[l_ac].lrt05,g_lrt[l_ac].lph33+1,l_length)
       #  AND substr(lrt04,1,g_lrt[l_ac].lph33) = l_no
          AND lrt04 >= g_lrt[l_ac].lrt04
          AND lrt05 <= g_lrt[l_ac].lrt05
       #  AND lrt03 =  g_lrt[l_ac].lrt03            #FUN-D10021 mark
          AND lrt02 <> g_lrt[l_ac].lrt02
          AND lrt03 = lph01 AND lph34 = l_lph34 AND LENGTH(lrt05) = l_lph32     #FUN-D10021 add
       IF g_cnt > 0 THEN
          LET g_errno = 'alm-579'
       END IF
    END IF
END FUNCTION
 
#FUNCTION t611_check_no(p_lrt03,p_lph34,p_no1,p_no2,p_cmd)  #FUN-C90066
FUNCTION t611_check_no(p_lrt03,p_no1,p_no2,p_cmd)           #FUN-C90066
 DEFINE p_cmd             LIKE type_file.chr1
 DEFINE p_no1             LIKE lrt_file.lrt04
 DEFINE p_no2             LIKE lrt_file.lrt05
 DEFINE l_lph03           LIKE lph_file.lph03
 DEFINE l_lph33           LIKE lph_file.lph33 #FUN-C90066
 DEFINE l_lph34           LIKE lph_file.lph34 #FUN-C90066
#DEFINE p_lph34           LIKE lph_file.lph34 #FUN-C90066
 DEFINE p_lrt03           LIKE lrt_file.lrt03
 DEFINE l_cnt             LIKE type_file.num5
 
   LET g_success = 'Y'
   CALL s_showmsg_init()
  #FUN-C90066 Begin---
  #DELETE FROM t611_tmp1
  #DELETE FROM t611_tmp2
  #DELETE FROM t611_tmp5
   TRUNCATE TABLE t611_tmp1
   TRUNCATE TABLE t611_tmp5
  #FUN-C90066 End-----
 
  #SELECT lph03 INTO l_lph03 FROM lph_file                             #FUN-C90066
   SELECT lph03,lph33,lph34 INTO l_lph03,l_lph33,l_lph34 FROM lph_file #FUN-C90066
    WHERE lph01 = p_lrt03
 
  #FUN-C90066 Begin---
  #CALL t611_gen_coupon_no(p_lrt03,l_lph03,p_lph34,p_no1,p_no2,1)
  #CALL t611_ins_lpj_tmp(2)
   CALL t611_gen_card_no(p_lrt03,l_lph03,l_lph33,l_lph34,p_no1,p_no2,1)
  #FUN-C90066 End-----
   CALL t611_lpj_check1(3)
 
   SELECT COUNT(*) INTO l_cnt FROM t611_tmp5
   IF l_cnt > 0 THEN
      CALL t611_error('t611_tmp5',3,'alm-577')
      LET g_success = 'N'
   END IF 
   CALL s_showmsg()
END FUNCTION
 
#FUN-C90066 Begin---
##產生卡號插入t611_tmp1
#FUNCTION t611_gen_coupon_no(p_lrt03,p_lph03,p_lph34,p_no1,p_no2,p_step)
# DEFINE p_step            LIKE type_file.num5
# DEFINE l_rows            LIKE type_file.num20
# DEFINE p_no1             LIKE lrt_file.lrt04
# DEFINE p_no2             LIKE lrt_file.lrt05
# DEFINE l_start_no        LIKE type_file.num20
# DEFINE l_end_no          LIKE type_file.num20
# DEFINE l_start_no1       LIKE type_file.num20
# DEFINE l_length          LIKE type_file.num5
# DEFINE l_length1         LIKE type_file.num5
# DEFINE l_no              LIKE lrt_file.lrt04
# DEFINE p_lph03           LIKE lph_file.lph03
# DEFINE p_lph34           LIKE lph_file.lph34
# DEFINE p_lrt03           LIKE lrt_file.lrt03
# DEFINE l_nums            LIKE type_file.num20
##TQC-A60132 --Begin
# DEFINE l_db_type         LIKE type_file.chr4
##TQC-A60132 --End
# 
#   DISPLAY 'begin_time:',TIME
# 
#   ERROR 'Begin Step ',p_step USING "&<",'(產生卡號)'
#   CALL ui.Interface.refresh()
#   DISPLAY '產生卡號開始:',TIME
#   
#   LET l_no = p_no1[1,g_lrt[l_ac].lph33]
#   LET l_length  = LENGTH(p_no1)
#   LET l_length1 = LENGTH(p_no1)-LENGTH(p_lph34)
#   LET l_start_no = p_no1[g_lrt[l_ac].lph33+1,l_length]
#   LET l_end_no = p_no2[g_lrt[l_ac].lph33+1,l_length]
#   LET l_nums = l_end_no - l_start_no + 1
#   IF cl_null(l_nums) THEN LET l_nums = 0 END IF
#   LET l_start_no1 = l_start_no - 1
#  #LET g_sql = "SELECT CONCAT('",p_lph34 CLIPPED,"',",
#  #            "  LPAD(to_char(id+",l_start_no1,"),",l_length1,",'0')) as lrt021,'",p_lrt03,"' as lrt03, '",p_lph03,"' as lpj16 ",
##TQC-A60132 --Begin
#   LET l_db_type=cl_db_get_database_type()
#   IF l_db_type='MSV' THEN
#      CALL t611_create_sql()
#      EXECUTE stmt USING l_start_no IN,l_end_no IN,l_nums IN,p_lrt03 IN,p_lph03 IN,p_lph34 IN,l_length1 IN,l_rows OUT
#   ELSE
##TQC-A60132 --End
#   LET g_sql = "SELECT ('",p_lph34 CLIPPED,"'||",
#               " substr(power(10,",l_length1,"-length(id+",l_start_no1,")) || (id+",l_start_no1,"),2))",
#               " as lrt021,'",p_lrt03,"' as lrt03, '",p_lph03,"' as lpj16 ",
#               "  FROM (SELECT level AS id FROM dual ",
#               "         CONNECT BY level <=",l_nums,")",
#               "  INTO TEMP t611_tmp1"
#   PREPARE t611_reg_py FROM g_sql
#   EXECUTE t611_reg_py
#   END IF    #TQC-A60132
#   IF SQLCA.sqlcode THEN
#      LET g_success = 'N'
#      CALL s_errmsg('','','insert temp t611_tmp1',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   IF l_db_type<>'MSV' THEN #TQC-A60132
#      LET l_rows = SQLCA.sqlerrd[3]
#   END IF                   #TQC-A60132
#   DISPLAY '產生卡號結束:',TIME,l_rows
#   ERROR 'Finish Step ',p_step USING "&<",'(產生卡號):',l_rows,'rows'
#   CALL ui.Interface.refresh()
#   CREATE UNIQUE INDEX t611_tmp1_01 ON t611_tmp1(lrt021);
#END FUNCTION
# 
#FUNCTION t611_ins_lpj_tmp(p_step)
#   DEFINE l_rows         LIKE type_file.num20
#   DEFINE p_step         LIKE type_file.num5
# 
#   ERROR 'Begin Step ',p_step USING '&<','(檢查表1)'
#   CALL ui.Interface.refresh()
#   DISPLAY "產生臨時表lpj_file資料開始:",TIME
##TQC-A60132 --Begin
##  LET g_sql = "SELECT UNIQUE lpj03,lpj09 FROM lpj_file",
##              "  INTO TEMP t611_tmp2 "
#   LET g_sql = " INSERT INTO t611_tmp2",
#               " SELECT UNIQUE lpj03,lpj09 FROM lpj_file"
##TQC-A60132 --End
#   PREPARE t611_reg_p9 FROM g_sql
#   EXECUTE t611_reg_p9
#   IF SQLCA.sqlcode THEN
#      LET g_success = 'N'
#      CALL s_errmsg('','','insert temp t611_tmp2',SQLCA.sqlcode,1)
#      RETURN
#   END IF
#   LET l_rows = SQLCA.sqlerrd[3]
#   DISPLAY '產生臨時表lpj_file資料結束:',TIME,l_rows
#   ERROR 'Finish Step ',p_step USING "&<",'(檢查1):',l_rows,'rows'
#   CALL ui.Interface.refresh()
#   CREATE UNIQUE INDEX t611_tmp2_01 ON t611_tmp2(lpj03);
#END FUNCTION
#FUN-C90066 End-----
 
#卡號存在于lpj_file中，若收集至t611_tmp5中
FUNCTION t611_lpj_check1(p_step)
   DEFINE p_step         LIKE type_file.num5
   DEFINE l_rows         LIKE type_file.num20
 
  #FUN-C90066 Begin---
  #ERROR 'Begin Step ',p_step USING "&<",'(收集有登記過的資料):'
  #CALL ui.Interface.refresh()
  #FUN-C90066 End-----
   DISPLAY "收集有登記過的資料:",TIME
#TQC-A60132 --Begin
#  LET g_sql = "SELECT lrt021 FROM t611_tmp1",
#              " WHERE lrt021 IN (SELECT lpj03 FROM t611_tmp2) ",
#              "  INTO TEMP t611_tmp5"
   LET g_sql = " INSERT INTO t611_tmp5",
               " SELECT lrt021 FROM t611_tmp1",
               "  WHERE lrt021 IN (SELECT lpj03 FROM lpj_file ) " #FUN-C90066
              #"  WHERE lrt021 IN (SELECT lpj03 FROM t611_tmp2) " #FUN-C90066
#TQC-A60132 --End
   PREPARE t611_reg_p22 FROM g_sql
   EXECUTE t611_reg_p22
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t611_tmp5',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY "收集有登記過的資料結束:",TIME,l_rows
  #FUN-C90066 Begin---
  #ERROR 'Finish Step ',p_step USING "&<",'(收集有登記過的資料):',l_rows,'rows'
  #CALL ui.Interface.refresh()  
  #CREATE UNIQUE INDEX t611_tmp5_01 ON t611_tmp5(lrt021);
  #FUN-C90066 End-----
END FUNCTION
 
#錯誤訊息記錄array
FUNCTION t611_error(p_table,p_step,p_errno)
   DEFINE p_table        LIKE gat_file.gat01
   DEFINE p_step         LIKE type_file.num5
   DEFINE p_errno        LIKE ze_file.ze01
   DEFINE l_lrt021       LIKE lrt_file.lrt04
   DEFINE l_i            LIKE type_file.num10
 
  #FUN-C90066 Begin---
  #ERROR 'Begin Step ',p_step USING '&<','(報錯信息匯總',p_table CLIPPED,')'
  #CALL ui.Interface.refresh()
  ##FUN-C90066 End-----
   DISPLAY "報錯",p_table CLIPPED,'開始:',TIME
   LET g_sql = "SELECT lrt021 FROM ",p_table
   DECLARE t611_tmp5_cs CURSOR FROM g_sql
   LET l_i = 1
   FOREACH t611_tmp5_cs INTO l_lrt021
      IF l_i > 10000 THEN
         EXIT FOREACH
      END IF
      CALL s_errmsg('lrt04,lrt05',l_lrt021,'foreach t611_tmp5_cs',p_errno,1)
      LET l_i = l_i + 1
   END FOREACH
   DISPLAY "報錯",p_table CLIPPED,'結束:',TIME
  ##FUN-C90066 Begin---
  #ERROR 'Finish Step ',p_step USING '&<','(報錯信息匯總',p_table CLIPPED,')'
  #CALL ui.Interface.refresh()
  #FUN-C90066 End -----
END FUNCTION
#No.FUN-960134

#FUN-C30044 STA
FUNCTION t611_lrt04_lrt05(l_lph32,l_lph33,l_lph34,l_lph35)
DEFINE l_lrt04       LIKE lrt_file.lrt04
DEFINE l_lrt04_1     LIKE lrt_file.lrt04
DEFINE l_lrt04_2     LIKE lrt_file.lrt04
DEFINE l_n           LIKE type_file.num10
DEFINE l_n1          LIKE type_file.num10
DEFINE l_n2          LIKE type_file.num10
DEFINE l_n3          LIKE type_file.num10
DEFINE l_lph34       LIKE lph_file.lph34
DEFINE l_lph35       LIKE lph_file.lph35
DEFINE l_lph32       LIKE lph_file.lph32
DEFINE l_lph33       LIKE lph_file.lph33
DEFINE l_length      LIKE type_file.num10
DEFINE l_string      STRING 
DEFINE l_str         STRING 
   #取卡明細狀態檔中的最大卡號
  #SELECT MAX(lpj03) INTO l_lrt04_1 FROM lpj_file     #FUN-D10021 mark
  # WHERE lpj02 = g_lrt[l_ac].lrt03                   #FUN-D10021 mark
   SELECT MAX(lpj03) INTO l_lrt04_1 FROM lPj_file,lph_file                   #FUN-D10021 add
    WHERE lpj02 = lph01 AND lph34 = l_lph34 AND LENGTH(lpj03) = l_lph32      #FUN-D10021 add
   #取開卡維護單身檔中未確認的卡號
  #FUN-D10021--mark--str---
  #SELECT MAX(lrt05) INTO l_lrt04_2 
  #  FROM lrt_file,lrs_file 
  # WHERE lrs01 = lrt01
  #   AND lrs03 = 'N'
  #   AND lrt03 = g_lrt[l_ac].lrt03 
  #FUN-D10021--mark--end---
  #FUN-D10021--add---str---
   SELECT MAX(lrt05) INTO l_lrt04_2 FROM lrt_file,lrs_file,lph_file
    WHERE lrs01 = lrt01 AND lrt03 = lph01
      AND lrs03 = 'N' AND lph34 = l_lph34 AND LENGTH(lrt05) = l_lph32 
  #FUN-D10021--add---end---
     #都為空，表示未有開卡記錄，給最小值
   IF( cl_null(l_lrt04_1) AND cl_null(l_lrt04_2)) OR l_lph35 = 0 THEN 
      LET l_lrt04 = l_lph34
      IF l_lph35 > 0 THEN
         FOR l_n = 1 TO l_lph35-1 
          #TQC-D30031  ---add---begin
            IF cl_null(l_lrt04) THEN 
               LET l_lrt04 = "0"
            ELSE
          #TQC-D30031  ---add---end
               LET l_lrt04 = l_lrt04,"0"
            END IF    #TQC-D30031  ---add
         END FOR  
         LET l_lrt04 = l_lrt04,"1"
      END IF
      LET g_lrt[l_ac].lrt04 = l_lrt04
      LET g_lrt[l_ac].lrt05 = l_lrt04 
      RETURN 
   END IF 
   IF NOT cl_null(l_lrt04_1) AND cl_null(l_lrt04_2) THEN
         LET l_n = l_lrt04_1[l_lph33+1,l_lph32]
   END IF 
   IF cl_null(l_lrt04_1) AND NOT cl_null(l_lrt04_2) THEN
         LET l_n = l_lrt04_2[l_lph33+1,l_lph32]
   END IF
   #都不為空取兩者之間較大的卡號
   IF NOT cl_null(l_lrt04_1) AND NOT cl_null(l_lrt04_2) THEN
      LET l_n1 = l_lrt04_1[l_lph33+1,l_lph32]
      LET l_n2 = l_lrt04_2[l_lph33+1,l_lph32]
      IF l_n1 >= l_n2 THEN 
         LET l_n = l_n1
      ELSE
         LET l_n = l_n2
      END IF 
   END IF     
   LET l_n = l_n + 1
   LET l_string = l_n
   LET l_length = LENGTH(l_string)
   #字符串長度大於卡號的流水號長度表示卡號已存在最大值
   IF l_length > l_lph35 THEN 
      LET g_errno = 'alm1612'
      RETURN 
   END IF 
   #補字符串轉數字時少的零
   LET l_n = l_lph35 - l_length 
   LET l_str = ''   
   IF l_n > 0 THEN 
      FOR l_n3 = 1 TO l_n 
         LET l_str = l_str,"0"
      END FOR
      LET l_string = l_str,l_string
   END IF    
   LET l_lrt04 = l_lph34,l_string
   LET g_lrt[l_ac].lrt04 = l_lrt04
   LET g_lrt[l_ac].lrt05 = l_lrt04 
END FUNCTION
#FUN-C30044 END

FUNCTION t611_create_tmp_table()

   DROP TABLE t611_tmp1;
   DROP TABLE t611_tmp5;
   CREATE TEMP TABLE t611_tmp1(
          lrt021 LIKE lpj_file.lpj03,
          lrt03 LIKE lrt_file.lrt03,
          lpj16 LIKE lpj_file.lpj16);
   CREATE UNIQUE INDEX t611_tmp1_01 ON t611_tmp1(lrt021);
   CREATE TEMP TABLE t611_tmp5(
          lrt021 LIKE lpj_file.lpj03);
   CREATE UNIQUE INDEX t611_tmp5_01 ON t611_tmp5(lrt021);
END FUNCTION
#FUN-C90070-------add------str
FUNCTION t611_out()
DEFINE l_sql    LIKE type_file.chr1000, 
       l_rtz13  LIKE rtz_file.rtz13,
       l_lph34  LIKE lph_file.lph34,
       sr       RECORD
                lrs01     LIKE lrs_file.lrs01,
                lrs02     LIKE lrs_file.lrs02,
                lrsplant  LIKE lrs_file.lrsplant, 
                lrs03     LIKE lrs_file.lrs03,
                lrs04     LIKE lrs_file.lrs04,
                lrs05     LIKE lrs_file.lrs05,
                lrt02     LIKE lrt_file.lrt02,
                lrt03     LIKE lrt_file.lrt03,
                lrt04     LIKE lrt_file.lrt04,
                lrt05     LIKE lrt_file.lrt05
                END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrsuser', 'lrsgrup')
     IF cl_null(g_wc) THEN LET g_wc = " lrs01 = '",g_lrs.lrs01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lrt01 = '",g_lrs.lrs01,"'" END IF
     LET l_sql = "SELECT lrs01,lrs02,lrsplant,lrs03,lrs04,lrs05,",
                 "       lrt02,lrt03,lrt04,lrt05",
                 "  FROM lrs_file,lrt_file",
                 " WHERE lrs01 = lrt01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t611_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t611_cs1 CURSOR FOR t611_prepare1

     DISPLAY l_table
     FOREACH t611_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
  
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lrsplant
       LET l_lph34 = ' '
       SELECT lph34 INTO l_lph34 FROM lph_file WHERE lph01=sr.lrt03
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lph34
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrs01,lrs02,lrsplant,lrs03,lrs04,lrs05')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lrt01,lrt02,lrt03,lrt04,lrt05')
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
                       " ORDER BY lrs01,lrt02"
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
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lrs03  STRING

    
    ORDER EXTERNAL BY sr1.lrs01,sr1.lrt02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lrs01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lrt02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrs03 = cl_gr_getmsg("gre-302",g_lang,sr1.lrs03)
            PRINTX sr1.*
            PRINTX l_lrs03

 
       AFTER GROUP OF sr1.lrs01
       AFTER GROUP OF sr1.lrt02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
#CHI-C80041---begin
FUNCTION t611_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lrs.lrs01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lrs.lrs03 ='X' THEN RETURN END IF
    ELSE
       IF g_lrs.lrs03<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end   

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t611_cl USING g_lrs.lrs01
   IF STATUS THEN
      CALL cl_err("OPEN t611_cl:", STATUS, 1)
      CLOSE t611_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t611_cl INTO g_lrs.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrs.lrs01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t611_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lrs.lrs03 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lrs.lrs03)   THEN 
        LET g_chr=g_lrs.lrs03
        IF g_lrs.lrs03='N' THEN 
            LET g_lrs.lrs03='X' 
        ELSE
            LET g_lrs.lrs03='N'
        END IF
        UPDATE lrs_file
            SET lrs03=g_lrs.lrs03,  
                lrsmodu=g_user,
                lrsdate=g_today
            WHERE lrs01=g_lrs.lrs01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lrs_file",g_lrs.lrs01,"",SQLCA.sqlcode,"","",1)  
            LET g_lrs.lrs03=g_chr 
        END IF
        DISPLAY BY NAME g_lrs.lrs03 
   END IF
 
   CLOSE t611_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lrs.lrs01,'V')
 
END FUNCTION
#CHI-C80041---end
