# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot400.4gl
# Descriptions...: 出口/報廢核銷底稿維護作業
# Date & Author..: 02/12/22 By Leagh
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/22 By Carrier
#                  增加手冊編號,修改s_codqty,s_coeqty的參數
#                  修改出口方式為0/1/2/3/4/5/6/7 具體內容參考coo_file
# Modify.........: No.MOD-530224 05/03/29 By Carrier add coo21/coo22
# Modify.........: No.FUN-550036 05/05/25 By Trisy 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# MOdify.........: No.TQC-660045 06/06/09 By hellen  cl_err --> cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/08 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-8B0004 08/11/15 By Pengu 單頭報單編號不應受系統編碼長度限制
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-A80036 10/08/30 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No.TQC-B10069 11/01/13 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息.
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0083 11/12/26 By xujing 增加數量欄位小數取位 
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_coo           RECORD  LIKE coo_file.*,
    g_coo_t         RECORD  LIKE coo_file.*,
    g_coo_o         RECORD  LIKE coo_file.*,
    g_coo01_t       LIKE coo_file.coo01,   #出貨單號(舊值)
    g_coo02_t       LIKE coo_file.coo02,   #項次(舊值)
    g_col           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        col03       LIKE col_file.col03,   #項次
        col04       LIKE col_file.col04,   #海關編號
        cob02       LIKE cob_file.cob02,   #
        col06       LIKE col_file.col06,   #單位
        col07       LIKE col_file.col07,   #單耗
        col08       LIKE col_file.col08,   #損耗率
        col09       LIKE col_file.col09,   #成品折算數量
        col10       LIKE col_file.col10,   #調整後數量
       #FUN-840202 --start---
        colud01     LIKE col_file.colud01,
        colud02     LIKE col_file.colud02,
        colud03     LIKE col_file.colud03,
        colud04     LIKE col_file.colud04,
        colud05     LIKE col_file.colud05,
        colud06     LIKE col_file.colud06,
        colud07     LIKE col_file.colud07,
        colud08     LIKE col_file.colud08,
        colud09     LIKE col_file.colud09,
        colud10     LIKE col_file.colud10,
        colud11     LIKE col_file.colud11,
        colud12     LIKE col_file.colud12,
        colud13     LIKE col_file.colud13,
        colud14     LIKE col_file.colud14,
        colud15     LIKE col_file.colud15
       #FUN-840202 --end--
                    END RECORD,
    g_col_t         RECORD                 #程式變數 (舊值)
        col03       LIKE col_file.col03,   #項次
        col04       LIKE col_file.col04,   #海關編號
        cob02       LIKE cob_file.cob02,   #
        col06       LIKE col_file.col06,   #單位
        col07       LIKE col_file.col07,   #單耗
        col08       LIKE col_file.col08,   #損耗率
        col09       LIKE col_file.col09,   #成品折算數量
        col10       LIKE col_file.col10,   #調整後數量
       #FUN-840202 --start---
        colud01     LIKE col_file.colud01,
        colud02     LIKE col_file.colud02,
        colud03     LIKE col_file.colud03,
        colud04     LIKE col_file.colud04,
        colud05     LIKE col_file.colud05,
        colud06     LIKE col_file.colud06,
        colud07     LIKE col_file.colud07,
        colud08     LIKE col_file.colud08,
        colud09     LIKE col_file.colud09,
        colud10     LIKE col_file.colud10,
        colud11     LIKE col_file.colud11,
        colud12     LIKE col_file.colud12,
        colud13     LIKE col_file.colud13,
        colud14     LIKE col_file.colud14,
        colud15     LIKE col_file.colud15
       #FUN-840202 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_buf               LIKE type_file.chr1000,             #No.FUN-680069 VARCHAR(40)
    g_seq           LIKE type_file.num5,                    #No.FUN-680069 SMALLINT     #單身筆數
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5             #No.FUN-680069 SMALLINT
DEFINE g_chr           LIKE type_file.chr1                 #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10                #No.FUN-680069 INTEGER
DEFINE g_msg           LIKE type_file.chr1000              #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10               #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10               #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5           #No.FUN-680069 SMALLINT
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5              #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ACO")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
 
    LET g_coo.coo01  = ARG_VAL(1)          #出貨單號
    LET g_coo.coo02  = ARG_VAL(2)          #項次
 
    LET g_forupd_sql = " SELECT * FROM coo_file WHERE coo01 = ? AND coo02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t400_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 8
    OPEN WINDOW t400_w AT p_row,p_col
         WITH FORM "aco/42f/acot400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL t400_menu()
    CLOSE WINDOW t400_w                   #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t400_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01        #No.FUN-580031  HCN
DEFINE  p_cmd           LIKE type_file.chr1,       #No.FUN-680069 VARCHAR(1)
        l_type          LIKE type_file.chr1        #No.FUN-680069 VARCHAR(01)    #No.MOD-490398
 
   CLEAR FORM                                      #清除畫面
   CALL g_col.clear()
   CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
   #螢幕上取單頭條件
   INITIALIZE g_coo.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON
        coo01,coo02,coo03,coo05,coo06,coo04,coo14,
         coo15,coo07,coo08,coo12,coo11,coo19,coo18,    #No.MOD-490398
         coo09,coo21,coo16,coo17,coo10,cooconf,coo20,coo22, #No:BUG-490398 #No.MOD-530224
        coouser,coogrup,coomodu,coodate,cooacti,
       #FUN-840202   ---start---
        cooud01,cooud02,cooud03,cooud04,cooud05,
        cooud06,cooud07,cooud08,cooud09,cooud10,
        cooud11,cooud12,cooud13,cooud14,cooud15
       #FUN-840202    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
     ON ACTION controlp
           CASE
               WHEN INFIELD(coo11) #商品編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cob"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO coo11
                    NEXT FIELD coo11
                #No.MOD-490398
               WHEN INFIELD(coo09)  #合同編號
                    CALL q_coc2(TRUE,TRUE,g_coo.coo18,g_coo.coo11,
                                g_coo.coo03,'',g_coo.coo12,g_coo.coo04)
                         RETURNING g_coo.coo18
                    SELECT coc04 INTO g_coo.coo09 FROM coc_file
                     WHERE coc03 = g_coo.coo18
                    DISPLAY BY NAME g_coo.coo09
                    NEXT FIELD coo09
               WHEN INFIELD(coo18)  #手冊編號
                    CALL q_coc2(TRUE,TRUE,g_coo.coo18,g_coo.coo11,
                                g_coo.coo03,'',g_coo.coo12,g_coo.coo04)
                         RETURNING g_coo.coo18
                    DISPLAY BY NAME g_coo.coo18
                    NEXT FIELD coo18
               WHEN INFIELD(coo12)      #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_coo.coo12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO coo12
                 NEXT FIELD coo12
                #No.MOD-490398 end
               OTHERWISE EXIT CASE
           END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                              #只能使用自己的資料
   #      LET g_wc = g_wc CLIPPED," AND coouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                              #只能使用相同群的資料
   #      LET g_wc = g_wc CLIPPED," AND coogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc CLIPPED," AND coogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('coouser', 'coogrup')
   #End:FUN-980030
 
 
   #螢幕上取單身條件
   CONSTRUCT g_wc2 ON col03,col04,col06,col07,col08,col09,col10
                    #No.FUN-840202 --start--
                     ,colud01,colud02,colud03,colud04,colud05
                     ,colud06,colud07,colud08,colud09,colud10
                     ,colud11,colud12,colud13,colud14,colud15
                    #No.FUN-840202 ---end---
              FROM s_col[1].col03,s_col[1].col04,s_col[1].col06,
                   s_col[1].col07,s_col[1].col08,s_col[1].col09,s_col[1].col10
                  #No.FUN-840202 --start--
                  ,s_col[1].colud01,s_col[1].colud02,s_col[1].colud03
                  ,s_col[1].colud04,s_col[1].colud05,s_col[1].colud06
                  ,s_col[1].colud07,s_col[1].colud08,s_col[1].colud09
                  ,s_col[1].colud10,s_col[1].colud11,s_col[1].colud12
                  ,s_col[1].colud13,s_col[1].colud14,s_col[1].colud15
                  #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   IF g_wc2 = " 1=1" THEN		             # 若單身未輸入條件
      LET g_sql = "SELECT coo01,coo02 FROM coo_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY coo01,coo02"
   ELSE					             # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE coo01,coo02 ",
                  "  FROM coo_file,col_file ",
                  " WHERE coo01 = col01 ",
                  "   AND coo02 = col02 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY coo01,coo02"
   END IF
 
   PREPARE t400_prepare FROM g_sql
   DECLARE t400_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t400_prepare
 
   #No.TQC-720019  --Begin
   IF g_wc2 = " 1=1" THEN		             # 若單身未輸入條件
      LET g_sql_tmp="SELECT UNIQUE coo01,coo02 FROM coo_file WHERE ",g_wc CLIPPED,
                    "  INTO TEMP x "
   ELSE
      LET g_sql_tmp = "SELECT UNIQUE coo01,coo02 FROM coo_file,col_file ",
                      " WHERE coo01=col01 AND coo02=col02 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      "  INTO TEMP x "
   END IF
   DROP TABLE x
   #PREPARE t400_precount_x FROM g_sql
   PREPARE t400_precount_x FROM g_sql_tmp
   EXECUTE t400_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   #No.TQC-720019  --End  
   PREPARE t400_precount FROM g_sql
   DECLARE t400_count CURSOR FOR t400_precount
END FUNCTION
 
FUNCTION t400_menu()
 
   WHILE TRUE
      CALL t400_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t400_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t400_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t400_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t400_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t400_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_col),'','')
             END IF
         #--
 
         WHEN "generator_detail"
            IF cl_chk_act_auth() THEN
               CALL t400_gen()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069
               CALL t400_y()
               CALL s_showmsg()               #TQC-B10069
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t400_z()
            END IF
        #No.FUN-6A0168-------add--------str----
          WHEN "related_document"           #相關文件
           IF cl_chk_act_auth() THEN
              IF g_coo.coo01 IS NOT NULL THEN
                 LET g_doc.column1 = "coo01"
                 LET g_doc.column2 = "coo02"
                 LET g_doc.value1 = g_coo.coo01
                 LET g_doc.value2 = g_coo.coo02
                 CALL cl_doc()
              END IF 
           END IF
        #No.FUN-6A0168-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t400_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_coo.coo01) OR cl_null(g_coo.coo02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_coo.cooacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_coo.coo01,'mfg1000',0)
        RETURN
    END IF
    IF g_coo.cooconf ='Y' THEN    #檢查資料是否審核
       CALL cl_err(g_msg,'9022',0) RETURN
    END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_coo01_t = g_coo.coo01
    LET g_coo02_t = g_coo.coo02
    LET g_coo.coomodu = g_user
    LET g_coo.coodate = g_today
    LET g_coo_o.* = g_coo.*
    BEGIN WORK
 
    OPEN t400_cl USING g_coo.coo01,g_coo.coo02
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t400_cl INTO g_coo.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t400_cl
        RETURN
    END IF
    CALL t400_show()
    WHILE TRUE
        LET g_coo01_t = g_coo.coo01
        LET g_coo02_t = g_coo.coo02
        CALL t400_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_coo.*=g_coo_t.*
            CALL t400_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_coo.coo01 != g_coo01_t OR g_coo.coo02 != g_coo02_t
        THEN UPDATE col_file SET col01 = g_coo.coo01,
                                 col02 = g_coo.coo02
                WHERE col01 = g_coo01_t AND col02 = g_coo02_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('col',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","col_file",g_coo01_t,g_coo02_t,SQLCA.sqlcode,"","col",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        UPDATE coo_file SET coo_file.* = g_coo.*
            WHERE coo01 = g_coo01_t AND coo02 = g_coo02_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","coo_file",g_coo01_t,g_coo02_t,SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t400_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION t400_i(p_cmd)
   DEFINE
        p_cmd               LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_flag              LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) #判斷必要欄位是否輸入        #No.FUN-680069 VARCHAR(1)
        l_msg1,l_msg2       LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(70)
        l_n                 LIKE type_file.num5,         #No.FUN-680069 SMALLINT
        l_type              LIKE type_file.chr1          #No.FUN-680069 VARCHAR(01)
   CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
   INPUT BY NAME g_coo.coo01,g_coo.coo02,g_coo.coo03,g_coo.coo05,
                 g_coo.coo06,g_coo.coo04,g_coo.coo14,g_coo.coo15,
                  g_coo.coo07,g_coo.coo08,g_coo.coo12,g_coo.coo11, #No.MOD-490398
                  g_coo.coo19,g_coo.coo18,g_coo.coo09,g_coo.coo21, #No.MOD-530224
                 g_coo.coo16,
                  g_coo.coo17,g_coo.coo10,g_coo.cooconf,g_coo.coo20, #No.MOD-490398 end
                  g_coo.coo22, #No.MOD-530224
                 g_coo.coouser,
                 g_coo.coogrup,g_coo.coomodu,g_coo.coodate,g_coo.cooacti,
                #FUN-840202     ---start---
                  g_coo.cooud01,g_coo.cooud02,g_coo.cooud03,g_coo.cooud04,
                  g_coo.cooud05,g_coo.cooud06,g_coo.cooud07,g_coo.cooud08,
                  g_coo.cooud09,g_coo.cooud10,g_coo.cooud11,g_coo.cooud12,
                  g_coo.cooud13,g_coo.cooud14,g_coo.cooud15
                #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t400_set_entry(p_cmd)
            CALL t400_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("coo01")
        #CALL cl_set_docno_format("coo07")    #No.MOD-8B0004 mark
         #No.FUN-550036 ---end---
 
         #No.MOD-490398  --begin
        #AFTER FIELD coo10
        #   IF NOT cl_null(g_coo.coo10) THEN
        #      IF g_coo.coo10 NOT MATCHES '[0123456]' THEN
        #          NEXT FIELD coo10
        #      END IF
        #   END IF
         #No.MOD-490398  --end
 
        AFTER FIELD coo11
           IF g_coo.coo10 != '4' THEN
              IF NOT cl_null(g_coo.coo11) THEN
                 CALL t400_coo11('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_coo.coo11,g_errno,0)
                    LET g_coo.coo11 = g_coo_t.coo11
                    DISPLAY BY NAME g_coo.coo11
                    NEXT FIELD coo11
                 END IF
              END IF
           END IF
 
        AFTER FIELD coo19
            IF g_coo.coo10 MATCHES '[0123567]' THEN    #No.MOD-490398
              IF g_coo.coo19 IS NULL THEN LET g_coo.coo19 = ' ' END IF
              #-->check 是否存在BOM 單頭
              SELECT COUNT(*) INTO l_n FROM com_file
                WHERE com01=g_coo.coo11
                  AND com02=g_coo.coo19
                   AND com03=g_coo.coo12  #No.MOD-490398
                  AND comacti !='N'
              IF l_n = 0 THEN
                 LET g_msg = g_coo.coo11 clipped
                 CALL cl_err(g_msg,'aco-007',0)
                 LET g_coo.coo11 = g_coo_t.coo11
                 LET g_coo.coo19 = g_coo_t.coo19
                 DISPLAY g_coo.coo11 TO s_coo.coo11
                 DISPLAY g_coo.coo19 TO s_coo.coo19
                 NEXT FIELD coo11
              END IF
           END IF
 
         #No.MOD-490398
        AFTER FIELD coo09
           IF NOT cl_null(g_coo.coo09) THEN
              IF g_coo.coo10 != '4' AND cl_null(g_coo.coo09) THEN
                 NEXT FIELD coo09
              END IF
              SELECT coc04 FROM coc_file WHERE coc04 = g_coo.coo09
              IF STATUS THEN
#                CALL cl_err(g_coo.coo09,'aco-026',0)  #No.TQC-660045
                 CALL cl_err3("sel","coc_file",g_coo.coo09,"","aco-026","","",1) #TQC-660045
                 NEXT FIELD coo09
              END IF
              CALL t400_coo09_coo18('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_coo.coo18,g_errno,0)
                 NEXT FIELD coo18
              END IF
              #單身重計
              IF cl_null(g_coo_t.coo16) OR g_coo_t.coo16 != g_coo.coo16 THEN
                 CALL t400_re_count()
              END IF
           END IF
 
        AFTER FIELD coo18
           IF NOT cl_null(g_coo.coo18) THEN
              IF g_coo.coo10 != '4' AND cl_null(g_coo.coo18) THEN
                 NEXT FIELD coo18
              END IF
              SELECT coc03 FROM coc_file WHERE coc03 = g_coo.coo18
              IF STATUS THEN
#                CALL cl_err(g_coo.coo18,'aco-062',0)  #No.TQC-660045
                 CALL cl_err3("sel","coc_file",g_coo.coo18,"","aco-062","","",1) #TQC-660045
                 NEXT FIELD coo18
              END IF
              CALL t400_coo09_coo18('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_coo.coo18,g_errno,0)
                 NEXT FIELD coo18
              END IF
              #單身重計
              IF cl_null(g_coo_t.coo16) OR g_coo_t.coo16 != g_coo.coo16 THEN
                 CALL t400_re_count()
              END IF
           END IF
 
        AFTER FIELD coo12               #海關代號
            IF NOT cl_null(g_coo.coo12) THEN
              CALL t400_coo12('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_coo.coo12,g_errno,0)
                 NEXT FIELD coo12
              END IF
            END IF
         #No.MOD-490398  end
 
        #FUN-840202     ---start---
        AFTER FIELD cooud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cooud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        ON ACTION controlp  #ok
           CASE
               WHEN INFIELD(coo11) #商品編號
                #No.MOD-490398
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cob"
                    LET g_qryparam.default1 = g_coo.coo11
                    CALL cl_create_qry() RETURNING g_coo.coo11
                    DISPLAY BY NAME g_coo.coo11
                    NEXT FIELD coo11
               WHEN INFIELD(coo09) OR INFIELD(coo18)  #合同編號
                   #No.MOD-490398  --begin
                  IF g_coo.coo10 MATCHES '[0123567]' THEN
                     LET l_type = '0'
                     CALL q_coc2(FALSE,FALSE,g_coo.coo18,g_coo.coo11,
                                 g_coo.coo03,l_type,g_coo.coo12,g_coo.coo04)
                          RETURNING g_coo.coo18,g_coo.coo09
                  ELSE    #半成品無對應商品編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_coc"
                     LET g_qryparam.default1 = g_coo.coo09
                     CALL cl_create_qry() RETURNING g_coo.coo09
                  END IF
                   #No.MOD-490398  --end
                  DISPLAY BY NAME g_coo.coo09,g_coo.coo18
                  IF INFIELD(coo09) THEN
                     NEXT FIELD coo09
                  ELSE
                     NEXT FIELD coo18
                  END IF
               WHEN INFIELD(coo12)      #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_coo.coo12
                 CALL cl_create_qry() RETURNING g_coo.coo12
                 DISPLAY BY NAME g_coo.coo12
                 NEXT FIELD coo12
               WHEN INFIELD(coo19)      #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_com"
                 LET g_qryparam.default1 = g_coo.coo19
                 LET g_qryparam.arg1 = g_coo.coo12
                 IF NOT cl_null(g_coo.coo11) THEN
                    LET g_qryparam.where = " com01 = '",g_coo.coo11,"'"
                 END IF
                 CALL cl_create_qry() RETURNING g_coo.coo11,g_coo.coo19
                 DISPLAY BY NAME g_coo.coo19
                 NEXT FIELD coo19
                #No.MOD-490398 end
               OTHERWISE EXIT CASE
           END CASE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(coo01) THEN
        #        LET g_coo.* = g_coo_t.*
        #        DISPLAY BY NAME g_coo.*
        #        NEXT FIELD coo01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
 #No.MOD-490398
FUNCTION t400_coo12(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_coo.coo12
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 #No.MOD-490398 end
 
FUNCTION t400_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("coo01,coo02,coo03,coo05",TRUE)
       CALL cl_set_comp_entry("coo06,coo04,coo14,coo15",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t400_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("coo01,coo02,coo03,coo05",FALSE)
       CALL cl_set_comp_entry("coo06,coo04,coo14,coo15",FALSE)
    END IF
END FUNCTION
 
 #No.MOD-490398
FUNCTION t400_coo11(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_coaacti LIKE coa_file.coaacti,
           l_cob02   LIKE cob_file.cob02,
           l_cobacti LIKE cob_file.cobacti,
           l_coa04   LIKE coa_file.coa04,
           l_fac     LIKE tlf_file.tlf60,
           l_w_qty   LIKE coo_file.coo14
 
    LET g_errno = ' '
    SELECT cob02,cobacti INTO l_cob02,l_cobacti
      FROM cob_file
     WHERE cob01 = g_coo.coo11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET l_cobacti = NULL
                                   LET l_cob02 = ''
         WHEN l_cobacti='N'        LET g_errno = '9028'
                                   LET l_cob02 = ''
         OTHERWISE
              #No.MOD-490398
             SELECT coa04,coaacti INTO l_coa04,l_coaacti FROM coa_file
              WHERE coa01 = g_coo.coo04 AND coa03 = g_coo.coo11
                AND coa05 = g_coo.coo12
             CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-012'
                                            LET l_coaacti = NULL
                  WHEN l_coaacti='N'        LET g_errno = '9028'
                  OTHERWISE                 LET g_errno = SQLCA.SQLCODE
                                                             USING '-------'
             END CASE
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
 #    IF g_coo.coo11 != g_coo_t.coo11 THEN #No.MOD-530224
       #異動數量對庫存單位的換算
       SELECT UNIQUE tlf60 INTO l_fac FROM tlf_file
        WHERE tlf026=g_coo.coo01 AND tlf027=g_coo.coo02
       IF cl_null(l_fac) THEN LET l_fac = 1 END IF
       LET l_w_qty = g_coo.coo14 * l_fac
       IF cl_null(l_coa04) THEN LET l_coa04 = 1 END IF
        #No.MOD-530224  --begin
       LET g_coo.coo21=l_coa04*l_fac
       DISPLAY BY NAME g_coo.coo21
        #No.MOD-530224  --end
       #庫存數量對合同單位的換算
       LET g_coo.coo16 = l_w_qty * l_coa04
       LET g_coo.coo16 = s_digqty(g_coo.coo16,g_coo.coo17) #FUN-BB0083 add
       DISPLAY BY NAME g_coo.coo16
 #    END IF#No.MOD-530224
END FUNCTION
 #No.MOD-490398  end
 
 FUNCTION t400_coo09_coo18(p_cmd)          #No.MOD-490398
    DEFINE p_cmd      LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_coc01    LIKE coc_file.coc01,
           l_sum      LIKE cod_file.cod05,
           l_qty      LIKE cod_file.cod09,
           l_tot      LIKE coo_file.coo16,
           l_tot2     LIKE coo_file.coo16,
           l_w_qty    LIKE cod_file.cod09,
           l_ima25    LIKE ima_file.ima25,
           l_seq      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
           l_fac      LIKE ima_file.ima31_fac,     #No.FUN-680069 DEC(16,8)
           l_unit_fac LIKE ima_file.ima31_fac,     #No.FUN-680069 DEC(16,8)
           l_cnt      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
           l_coo16    LIKE coo_file.coo16
 
    IF g_coo.coo10 = '4' THEN RETURN END IF
    LET g_errno = ' '
    #抓出申請編號
     #No.MOD-490398
    SELECT coc01,coc04 INTO l_coc01,g_coo.coo09 FROM coc_file
     WHERE coc03 = g_coo.coo18 AND cocacti = 'Y'
    IF STATUS THEN
       LET g_errno = 'aco-005' RETURN
    END IF
    DISPLAY BY NAME g_coo.coo09
 
    #異動數量對庫存單位的換算
    SELECT UNIQUE tlf60 INTO l_fac FROM tlf_file
     WHERE tlf026=g_coo.coo01 AND tlf027=g_coo.coo02
    IF cl_null(l_fac) THEN LET l_fac = 1 END IF
    LET l_w_qty = g_coo.coo14 * l_fac
 
    #庫存數量對合同單位的換算
    SELECT coa04 INTO l_unit_fac FROM coa_file
     WHERE coa01 = g_coo.coo04 AND coa03 = g_coo.coo11 AND coa05 = g_coo.coo12
     #No.MOD-490398 end
    IF cl_null(l_unit_fac) OR l_unit_fac = 0 THEN
       LET g_errno = 'abm-731' RETURN
    END IF
    LET g_coo.coo16 = l_w_qty * l_unit_fac
    LET g_coo.coo16 = s_digqty(g_coo.coo16,g_coo.coo17) #FUN-BB0083 add
    DISPLAY BY NAME g_coo.coo16
     #No.MOD-530224  --begin
    LET g_coo.coo21=l_unit_fac*l_fac
    DISPLAY BY NAME g_coo.coo21
     #No.MOD-530224  --end
 
    SELECT COUNT(*) INTO l_cnt FROM com_file
     WHERE com01 = g_coo.coo11
       AND com02 = g_coo.coo19
        AND com03 = g_coo.coo12              #No.MOD-490398
    IF l_cnt > 0 THEN    #成品
       SELECT cod02,cod06 INTO l_seq,g_coo.coo17 FROM cod_file
        WHERE cod01 = l_coc01
          AND cod03 = g_coo.coo11
          AND cod041= g_coo.coo19
           AND cod04 = g_coo.coo12           #No.MOD-490398
       IF STATUS = 100 THEN LET g_errno = 'aco-006' RETURN END IF
 
        #No.MOD-490398
       CALL s_codqty(g_coo.coo18,l_seq) RETURNING l_qty     #合同剩餘量
        #No.MOD-490398  --end
       #成品出口-已確認未報關
       SELECT SUM(coo16) INTO l_tot FROM coo_file
        WHERE coo09 = g_coo.coo09 AND cooconf='Y'
          AND coo11 = g_coo.coo11 AND coo20 = 'N'
          AND coo19 = g_coo.coo19 AND coo10 IN ('0','1','2','3')
           AND coo12 = g_coo.coo12             #No.MOD-490398
       IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
       #成品進口-已確認未報關
       SELECT SUM(coo16) INTO l_tot2 FROM coo_file
        WHERE coo09 = g_coo.coo09 AND cooconf='Y'
          AND coo11 = g_coo.coo11 AND coo20 = 'N'
           AND coo19 = g_coo.coo19 AND coo10 IN ('5','6','7')  #No.MOD-490398
           AND coo12 = g_coo.coo12             #No.MOD-490398
       IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
 
       LET l_tot = l_tot - l_tot2
       LET l_coo16 = g_coo.coo16
        #No.MOD-490398  --begin
       IF g_coo.coo10 MATCHES '[567]' THEN LET l_coo16 = l_coo16 * -1 END IF
        #No.MOD-490398  --end
       IF l_tot + l_coo16 > l_qty THEN LET g_errno = 'aco-004' END IF
     #No.MOD-490398  --begin
    #材料的底稿都在acoi501中維護
    #ELSE                 #材料
    #   SELECT coe02,coe06 INTO l_seq,g_coo.coo17
    #     FROM coe_file
    #    WHERE coe01 = l_coc01
    #      AND coe03 = g_coo.coo11
     #      AND coe04 = g_coo.coo12         #No.MOD-490398
    #   IF STATUS = 100 THEN LET g_errno = 'aco-006' RETURN END IF
 
     #   #No.MOD-490398
    #   CALL s_coeqty(g_coo.coo18,l_seq) RETURNING l_qty     #已進口剩餘量
     #   #No.MOD-490398  --end
    #   #材料報廢-已確認未報關
    #   SELECT SUM(coo16) INTO l_tot FROM coo_file
    #    WHERE coo09 = g_coo.coo09 AND cooconf='Y'
    #      AND coo11 = g_coo.coo11 AND coo20 = 'N'
    #      AND coo19 = g_coo.coo19 AND coo10 = '5'
     #      AND coo12 = g_coo.coo12         #No.MOD-490398
    #   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    #   IF l_tot + g_coo.coo16 > l_qty THEN LET g_errno = 'aco-029' END IF
     #No.MOD-490398  --end
    END IF
    DISPLAY BY NAME g_coo.coo17
END FUNCTION
 
#Query 查詢
FUNCTION t400_q()
DEFINE    p_cmd           LIKE type_file.chr1                  #處理狀態        #No.FUN-680069 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_coo.* TO NULL             #No.FUN-6A0168 
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_col.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t400_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t400_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_coo.* TO NULL
    ELSE
        OPEN t400_count
        FETCH t400_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t400_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式          #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t400_cs INTO g_coo.coo01,g_coo.coo02
        WHEN 'P' FETCH PREVIOUS t400_cs INTO g_coo.coo01,g_coo.coo02
        WHEN 'F' FETCH FIRST    t400_cs INTO g_coo.coo01,g_coo.coo02
        WHEN 'L' FETCH LAST     t400_cs INTO g_coo.coo01,g_coo.coo02
        WHEN '/'
 
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
 
         END IF
         FETCH ABSOLUTE g_jump t400_cs INTO g_coo.coo01,g_coo.coo02
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0)
        INITIALIZE g_coo.* TO NULL  #TQC-6B0105
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
    END IF
    SELECT * INTO g_coo.* FROM coo_file WHERE coo01 = g_coo.coo01 AND coo02 = g_coo.coo02
    IF SQLCA.sqlcode THEN
        LET g_msg = g_coo.coo01,'+',g_coo.coo02 clipped
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","coo_file",g_coo.coo01,g_coo.coo02,STATUS,"","",1)  #TQC-660045
        INITIALIZE g_coo.* TO NULL
        RETURN
    END IF
 
    CALL t400_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t400_show()
    LET g_coo_t.* = g_coo.*                #保存單頭舊值
 
    DISPLAY BY NAME  g_coo.coo01,g_coo.coo02,g_coo.coo03,g_coo.coo04,
                     g_coo.coo05,g_coo.coo06,g_coo.coo07,g_coo.coo08,
                     g_coo.coo09,g_coo.coo10,g_coo.coo11,g_coo.coo19,
                      g_coo.coo14,g_coo.coo15,g_coo.coo16,g_coo.coo21,#No.MOD-530224
                      g_coo.coo17,g_coo.coo22, #No.MOD-530224
                     g_coo.coo18,g_coo.cooconf,g_coo.coo20,g_coo.coouser,
                     g_coo.coogrup,g_coo.coomodu,g_coo.coodate,g_coo.cooacti,
                      g_coo.coo12,             #No.MOD-490398
                  #FUN-840202     ---start---
                     g_coo.cooud01,g_coo.cooud02,g_coo.cooud03,g_coo.cooud04,
                     g_coo.cooud05,g_coo.cooud06,g_coo.cooud07,g_coo.cooud08,
                     g_coo.cooud09,g_coo.cooud10,g_coo.cooud11,g_coo.cooud12,
                     g_coo.cooud13,g_coo.cooud14,g_coo.cooud15
                  #FUN-840202     ----end----
 
    CALL cl_set_field_pic(g_coo.cooconf,"","","","",g_coo.cooacti)
 
    SELECT ima02 INTO g_buf FROM ima_file WHERE ima01 = g_coo.coo04
    DISPLAY g_buf TO ima02  LET g_buf = NULL
    CALL t400_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t400_r()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_coo.coo01) OR cl_null(g_coo.coo02) THEN
       CALL cl_err("",-400,0) RETURN
    END IF
    IF g_coo.cooconf ='Y' THEN CALL cl_err(g_coo.coo01,'9021',0) RETURN END IF
    IF g_coo.cooacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_coo.coo01,'mfg1000',0) RETURN
    END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    BEGIN WORK
 
    OPEN t400_cl USING g_coo.coo01,g_coo.coo02
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t400_cl INTO g_coo.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        LET g_msg = g_coo.coo01,'+',g_coo.coo02 clipped
        CALL cl_err(g_msg,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t400_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "coo01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "coo02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_coo.coo01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_coo.coo02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM coo_file WHERE coo01 = g_coo.coo01 AND coo02 =g_coo.coo02
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('del coo',STATUS,0)  #No.TQC-660045
          CALL cl_err3("del","coo_file",g_coo.coo01,g_coo.coo02,STATUS,"","del coo",1)  #TQC-660045
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM col_file WHERE col01 = g_coo.coo01 AND col02 =g_coo.coo02
       IF STATUS THEN
#         CALL cl_err('del col',STATUS,0)  #No.TQC-660045
          CALL cl_err3("del","col_file",g_coo.coo01,g_coo.coo02,STATUS,"","del col",1) #TQC-660045
          ROLLBACK WORK RETURN
       END IF
       IF g_coo.coo10 MATCHES '[012]' THEN
          UPDATE tlf_file SET tlf910=NULL
           WHERE tlf026=g_coo.coo01 AND tlf027=g_coo.coo02
             AND tlf02 = 50 AND tlf03 = 724
       END IF
        IF g_coo.coo10 MATCHES '[34]' THEN  #No.MOD-490398
          UPDATE tlf_file SET tlf910=NULL
           WHERE tlf026=g_coo.coo01 AND tlf027=g_coo.coo02
             AND tlf02 = 50 AND tlf03 = 40
       END IF
        IF g_coo.coo10 MATCHES '[567]' THEN #No.MOD-490398
          UPDATE tlf_file SET tlf910=NULL
           WHERE tlf026=g_coo.coo01 AND tlf027=g_coo.coo02
             AND tlf02 = 731 AND tlf03 = 50
       END IF
       IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd tlf910:',STATUS,0)  #No.TQC-660045
          CALL cl_err3("upd","tlf_file",g_coo.coo01,g_coo.coo02,STATUS,"","upd tlf910",1) #TQC-660045
          ROLLBACK WORK RETURN
       END IF
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
          VALUES ('acot400',g_user,g_today,g_msg,g_coo.coo01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
       CLEAR FORM
       CALL g_col.clear()
 
          #No.MOD-490398  --begin
         DROP TABLE x
#        EXECUTE t400_precount_x                  #No.TQC-720019
         PREPARE t400_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE t400_precount_x2                 #No.TQC-720019
          #No.MOD-490398  --end
         OPEN t400_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t400_cs
            CLOSE t400_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t400_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t400_cs
            CLOSE t400_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t400_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t400_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t400_fetch('/')
         END IF
       #INITIALIZE g_coo.* TO NULL  #No.TQC-720019
       MESSAGE ""
    END IF
    CLOSE t400_cl
    COMMIT WORK
END FUNCTION
#單身
FUNCTION t400_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT   #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用      #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_col07_t       LIKE col_file.col07,
    l_col08_t       LIKE col_file.col08,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_coo.coo01 IS NULL OR g_coo.coo02 IS NULL THEN RETURN END IF
    IF g_coo.cooacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_coo.coo01,'mfg1000',0) RETURN
    END IF
    IF g_coo.cooconf ='Y' THEN    #檢查資料是否審核
       CALL cl_err(g_msg,'9022',0) RETURN
    END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
     IF g_coo.coo10 NOT MATCHES '[0-7]' THEN RETURN END IF  #No.MOD-490398
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT col03,col04,'',col06,col07,col08,col09,col10, ",
                       #No.FUN-840202 --start--
                       "       colud01,colud02,colud03,colud04,colud05,",
                       "       colud06,colud07,colud08,colud09,colud10,",
                       "       colud11,colud12,colud13,colud14,colud15 ",
                       #No.FUN-840202 ---end---
                       "   FROM col_file ",
                       "  WHERE col01 = ? AND col02 = ? ",
                       "    AND col03 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
     IF g_rec_b=0 THEN CALL g_col.clear() END IF
     INPUT ARRAY g_col WITHOUT DEFAULTS FROM s_col.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            BEGIN WORK
            LET p_cmd=''
 
            OPEN t400_cl USING g_coo.coo01,g_coo.coo02
            IF STATUS THEN
               CALL cl_err("OPEN t400_cl:", STATUS, 1)
               CLOSE t400_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t400_cl INTO g_coo.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t400_cl
               ROLLBACK WORK
               RETURN
            END IF
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_col_t.* = g_col[l_ac].*  #BACKUP
                OPEN t400_bcl USING g_coo.coo01,g_coo.coo02,g_col_t.col03
 
                IF STATUS THEN
                   CALL cl_err("OPEN t400_bcl:", STATUS, 1)
                   CLOSE t400_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t400_bcl INTO g_col[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_col_t.col03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t400_col03('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD col03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_col[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_col[l_ac].* TO s_col.*
              CALL g_col.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO col_file(col01,col02,col03,col04,col06,
                                 col07,col08,col09,col10,col11,col12,
                                #FUN-840202 --start--
                                  colud01,colud02,colud03,
                                  colud04,colud05,colud06,
                                  colud07,colud08,colud09,
                                  colud10,colud11,colud12,
                                  #colud13,colud14,colud15) #FUN-980002
                                #FUN-840202 --end--
                                  colud13,colud14,colud15,  #FUN-980002
                                  colplant,collegal) #FUN-980002
                 VALUES(g_coo.coo01,g_coo.coo02,g_col[l_ac].col03,
                        g_col[l_ac].col04,
                        g_col[l_ac].col06,g_col[l_ac].col07,
                        g_col[l_ac].col08,g_col[l_ac].col09,
                        g_col[l_ac].col10,l_col07_t,l_col08_t,
                       #FUN-840202 --start--
                        g_col[l_ac].colud01, g_col[l_ac].colud02,
                        g_col[l_ac].colud03, g_col[l_ac].colud04,
                        g_col[l_ac].colud05, g_col[l_ac].colud06,
                        g_col[l_ac].colud07, g_col[l_ac].colud08,
                        g_col[l_ac].colud09, g_col[l_ac].colud10,
                        g_col[l_ac].colud11, g_col[l_ac].colud12,
                        g_col[l_ac].colud13, g_col[l_ac].colud14,
                        g_col[l_ac].colud15, g_plant, g_legal) #FUN-980002 add g_plant,g_legal
                       #FUN-840202 --end--
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_col[l_ac].col03,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","col_file",g_coo.coo01,g_coo.coo02,SQLCA.sqlcode,"","",1) #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_col[l_ac].* TO NULL      #900423
            LET g_col_t.* = g_col[l_ac].*         #新輸入資料
            LET l_col07_t = 0
            LET l_col08_t = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD col03
 
        BEFORE FIELD col07                       #check 序號是否重複
            IF NOT cl_null(g_col[l_ac].col03) THEN
               IF p_cmd='a' OR
                 (p_cmd='u' AND g_col[l_ac].col03 != g_col_t.col03) THEN
                  CALL t400_col03(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_col[l_ac].col03,g_errno,0)
                     NEXT FIELD col03
                  END IF
                  SELECT COUNT(*) INTO l_n FROM col_file
                   WHERE col01 = g_coo.coo01 AND col02 = g_coo.coo02
                     AND col03 = g_col[l_ac].col03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_col[l_ac].col03 = g_col_t.col03
                      DISPLAY g_col[l_ac].col03 TO col03           #No.MOD-490371
                     NEXT FIELD col03
                  END IF
               END IF
            END IF
            IF p_cmd = 'a' THEN
               LET l_col07_t = g_col[l_ac].col07
               LET l_col08_t = g_col[l_ac].col08
            END IF
 
        AFTER FIELD col08                        #損耗率
            IF NOT cl_null(g_col[l_ac].col08) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND (g_col[l_ac].col07 != g_col_t.col07 OR
                                   g_col[l_ac].col08 != g_col_t.col08)) THEN
                  #調整後數量
                  LET g_col[l_ac].col10 = g_coo.coo16 * g_col[l_ac].col07*
                                          (1+g_col[l_ac].col08/100)
                  LET g_col[l_ac].col10 = s_digqty(g_col[l_ac].col10,g_col[l_ac].col06) #FUN-BB0083 add
                  DISPLAY g_col[l_ac].col10 TO col10          #No.MOD-490371
               END IF
            END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD colud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD colud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_col_t.col03 > 0 AND
               g_col_t.col03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM col_file
                    WHERE col01 = g_coo.coo01 AND col02 = g_coo.coo02
                      AND col03 = g_col_t.col03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_col_t.col03,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("del","col_file",g_coo.coo01,g_coo.coo02,SQLCA.sqlcode,"","",1) #TQC-660045
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
               LET g_col[l_ac].* = g_col_t.*
               CLOSE t400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_col[l_ac].col03,-263,1)
               LET g_col[l_ac].* = g_col_t.*
            ELSE
               UPDATE col_file SET col03= g_col[l_ac].col03,
                                   col04= g_col[l_ac].col04,
                                   col06= g_col[l_ac].col06,
                                   col07= g_col[l_ac].col07,
                                   col08= g_col[l_ac].col08,
                                   col09= g_col[l_ac].col09,
                                   col10= g_col[l_ac].col10,
                                  #FUN-840202 --start--
                                   colud01 = g_col[l_ac].colud01,
                                   colud02 = g_col[l_ac].colud02,
                                   colud03 = g_col[l_ac].colud03,
                                   colud04 = g_col[l_ac].colud04,
                                   colud05 = g_col[l_ac].colud05,
                                   colud06 = g_col[l_ac].colud06,
                                   colud07 = g_col[l_ac].colud07,
                                   colud08 = g_col[l_ac].colud08,
                                   colud09 = g_col[l_ac].colud09,
                                   colud10 = g_col[l_ac].colud10,
                                   colud11 = g_col[l_ac].colud11,
                                   colud12 = g_col[l_ac].colud12,
                                   colud13 = g_col[l_ac].colud13,
                                   colud14 = g_col[l_ac].colud14,
                                   colud15 = g_col[l_ac].colud15
                                  #FUN-840202 --end-- 
               WHERE col01 = g_coo.coo01 AND col02 = g_coo.coo02
                 AND col03 = g_col_t.col03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_col[l_ac].col03,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","col_file",g_coo.coo01,g_coo.coo02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_col[l_ac].* = g_col_t.*
                   #DISPLAY g_col[l_ac].* TO s_col[l_sl].*   #No.MOD-490371
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               IF p_cmd='u' THEN
                  LET g_col[l_ac].* = g_col_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_col.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
          #LET g_col_t.* = g_col[l_ac].*          # 900423
            CLOSE t400_bcl
            COMMIT WORK
 
           #CALL g_col.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION controlp
            IF INFIELD(col03) THEN
               CALL q_con(FALSE,TRUE,g_coo.coo11,
                          g_col[l_ac].col03,g_coo.coo19,g_coo.coo12) #No.MOD-490398
               RETURNING g_col[l_ac].col03
#               CALL FGL_DIALOG_SETBUFFER( g_col[l_ac].col03 )
                DISPLAY g_col[l_ac].col03 TO col03            #No.MOD-490371
               NEXT FIELD col03
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(col03) AND l_ac > 1 THEN
                LET g_col[l_ac].* = g_col[l_ac-1].*
                NEXT FIELD col03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
        CLOSE t400_cl
        CLOSE t400_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION t400_col03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_con     RECORD LIKE con_file.*
 
    LET g_errno = ' '
 
    SELECT con_file.*,cob02 INTO l_con.*,g_col[l_ac].cob02
      FROM con_file,cob_file
     WHERE con01 = g_coo.coo11
       AND con013= g_coo.coo19
        AND con08 = g_coo.coo12                    #No.MOD-490398
       AND con02 = g_col[l_ac].col03
       AND cob01 = con03
 
    IF STATUS THEN
       LET g_errno = 'aco-063' RETURN
    END IF
    IF p_cmd = 'a' AND cl_null(g_errno) THEN
       LET g_col[l_ac].col04 = l_con.con03
       LET g_col[l_ac].col06 = l_con.con04
       LET g_col[l_ac].col07 = l_con.con05
       LET g_col[l_ac].col08 = l_con.con06
        #No.MOD-490398
       LET g_col[l_ac].col09 = g_coo.coo16*(l_con.con05/(1-(l_con.con06/100)))
       LET g_col[l_ac].col09 = s_digqty(g_col[l_ac].col09,g_col[l_ac].col06) #FUN-BB0083 add
        #No.MOD-490398 end
       LET g_col[l_ac].col10 = g_col[l_ac].col09
       LET g_col[l_ac].col10 = s_digqty(g_col[l_ac].col10,g_col[l_ac].col06) #FUN-BB0083 add
       DISPLAY g_col[l_ac].col04,g_col[l_ac].col06,
               g_col[l_ac].col07,g_col[l_ac].col08,g_col[l_ac].col09,
               g_col[l_ac].col10
             TO col04,col06, col07,col08,col09, col10           #No.MOD-490371
    END IF
     DISPLAY g_col[l_ac].cob02 TO cob02            #No.MOD-490371
END FUNCTION
 
FUNCTION t400_b_askkey()
DEFINE
    l_wc2       LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200) 
 
    CONSTRUCT l_wc2 ON col03,col04,col06,col07,col08,col09,col10
                     #No.FUN-840202 --start--
                      ,colud01,colud02,colud03,colud04,colud05
                      ,colud06,colud07,colud08,colud09,colud10
                      ,colud11,colud12,colud13,colud14,colud15
                     #No.FUN-840202 ---end---
            FROM s_col[1].col03,s_col[1].col04,s_col[1].col06,
                 s_col[1].col07,s_col[1].col08,s_col[1].col09,s_col[1].col10
                #No.FUN-840202 --start--
                ,s_col[1].colud01,s_col[1].colud02,s_col[1].colud03
                ,s_col[1].colud04,s_col[1].colud05,s_col[1].colud06
                ,s_col[1].colud07,s_col[1].colud08,s_col[1].colud09
                ,s_col[1].colud10,s_col[1].colud11,s_col[1].colud12
                ,s_col[1].colud13,s_col[1].colud14,s_col[1].colud15
                #No.FUN-840202 ---end---
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t400_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t400_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           STRING,           #No.FUN-680069
       l_flag          LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
    LET g_sql =
        "SELECT col03,col04,cob02,col06,col07,col08,col09,col10, ",
        #No.FUN-840202 --start--
        "       colud01,colud02,colud03,colud04,colud05,",
        "       colud06,colud07,colud08,colud09,colud10,",
        "       colud11,colud12,colud13,colud14,colud15 ",
        #No.FUN-840202 ---end---
        "  FROM col_file LEFT OUTER JOIN cob_file ON col_file.col04=cob_file.cob01",
        " WHERE col01 ='",g_coo.coo01,"'",
        "   AND col02 = ",g_coo.coo02,
        "   AND cob01 = col04 " 
    #No.FUN-8B0123---Begin
    #   "   AND ",p_wc2 CLIPPED, #單身
    #   " ORDER BY col03 "
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY col03 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t400_pb FROM g_sql
    DECLARE col_cs                       #SCROLL CURSOR
        CURSOR FOR t400_pb
    CALL g_col.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH col_cs INTO g_col[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_col.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_col TO s_col.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic(g_coo.cooconf,"","","","",g_coo.cooacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 產生單身
      ON ACTION generator_detail
         LET g_action_choice="generator_detail"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      ON ACTION controls                       # No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t400_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_coo.coo01 IS NULL OR g_coo.coo02 IS NULL THEN
       CALL cl_err("",-400,0) RETURN
    END IF
    IF g_coo.cooconf='Y' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    BEGIN WORK
 
    OPEN t400_cl USING g_coo.coo01,g_coo.coo02
    IF STATUS THEN
       CALL cl_err("OPEN t400_cl:", STATUS, 1)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t400_cl INTO g_coo.*# 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0)#資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t400_show()
    IF cl_exp(0,0,g_coo.cooacti) THEN
        LET g_chr=g_coo.cooacti
        IF g_coo.cooacti='Y' THEN
            LET g_coo.cooacti='N'
        ELSE
            LET g_coo.cooacti='Y'
        END IF
        UPDATE coo_file                    #更改有效碼
           SET cooacti=g_coo.cooacti
         WHERE coo01=g_coo.coo01 AND coo02 = g_coo.coo02
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","coo_file",g_coo.coo01,g_coo.coo02,SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_coo.cooacti=g_chr
        END IF
        DISPLAY BY NAME g_coo.cooacti
    END IF
    CLOSE t400_cl
    COMMIT WORK
 
    CALL cl_set_field_pic(g_coo.cooconf,"","","","",g_coo.cooacti)
 
END FUNCTION
 
FUNCTION t400_y()
 DEFINE l_coo    RECORD LIKE coo_file.*
 DEFINE l_col    RECORD LIKE col_file.*
 DEFINE only_one LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
 DEFINE l_sum    LIKE cod_file.cod05
 DEFINE l_qty    LIKE cod_file.cod09
 DEFINE l_tot    LIKE coo_file.coo16
 DEFINE l_coc01  LIKE coc_file.coc01
 DEFINE l_flag   LIKE type_file.chr1         #No.FUN-680069 VARCHAR(1)
 DEFINE l_cnt    LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_seq    LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_coo16  LIKE coo_file.coo16
 DEFINE l_col10  LIKE col_file.col10
 DEFINE l_tot2   LIKE coo_file.coo16
 DEFINE ls_tmp   STRING                      #No.FUN-680069 STRING
 
   LET g_success = 'Y'            #TQC-B10047 add 
   IF g_coo.coo01 IS NULL THEN RETURN END IF
   SELECT * INTO g_coo.* FROM coo_file
    WHERE coo01=g_coo.coo01 AND coo02 = g_coo.coo02
   IF g_coo.cooconf='Y' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
    #  CALL cl_err(g_msg,'aco-228',0) RETURN                   #TQC-B10069
       CALL s_errmsg("coo22",g_coo.coo01,"g_msg",'aco-228',1)  #TQC-B10069
       LET g_success = 'N'                                     #TQC-B10069
    END IF
     #No.MOD-530224  --end
   #IF g_coo.cooacti = 'N' THEN CALL cl_err('',9027,0) RETURN END IF  #TQC-B10069
    IF g_coo.cooacti = 'N' THEN     #TQC-B10069
       CALL s_errmsg("cooacti",g_coo.coo01,"",'9027',1)  #TQC-B10069 
       LET g_success = 'N'                               #TQC-B10069
    END IF         #TQC-B10069            
   #開窗整批審核....
   OPEN WINDOW t400_y AT 9,18 WITH FORM "aco/42f/acot400_y"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("acot400_y")
 
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
 
      AFTER FIELD only_one
         IF NOT cl_null(only_one) THEN
            IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t400_y RETURN END IF
   IF only_one = '1'
      THEN LET g_wc = " coo01 = '",g_coo.coo01,"' ",
                      " AND coo02 =",g_coo.coo02
   ELSE
      CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
      CONSTRUCT BY NAME g_wc ON coo01,coo03,coo05,coo11
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t400_y RETURN END IF
   END IF
 
   IF NOT cl_confirm('aap-222') THEN CLOSE WINDOW t400_y RETURN END IF
#CHI-C30107 --------------- add ------------- begin
   SELECT * INTO g_coo.* FROM coo_file
    WHERE coo01=g_coo.coo01 AND coo02 = g_coo.coo02
   IF g_coo.cooconf='Y' THEN RETURN END IF
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL s_errmsg("coo22",g_coo.coo01,"g_msg",'aco-228',1)  
       LET g_success = 'N'                                    
    END IF
    IF g_coo.cooacti = 'N' THEN 
       CALL s_errmsg("cooacti",g_coo.coo01,"",'9027',1)  
       LET g_success = 'N'                               
    END IF  
#CHI-C30107 --------------- add ------------- end
 
   LET g_sql = " SELECT * FROM coo_file" ,
               "  WHERE cooconf='N' ",
               "    AND ",g_wc CLIPPED
   PREPARE firm_pre FROM g_sql
   DECLARE firm_cs CURSOR FOR firm_pre
 
#  LET g_success='Y'    #TQC-B10069  mark 移到FUNCTION前面
   BEGIN WORK
 
   OPEN t400_cl USING g_coo.coo01,g_coo.coo02
   IF STATUS THEN
   #  CALL cl_err("OPEN t400_cl:", STATUS, 1)                 #TQC-B10069
      CALL s_errmsg("",g_coo.coo01,"OPEN t400_cl:",STATUS,1)  #TQC-B10069   
      LET g_success = 'N'                                     #TQC-B10069
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t400_cl INTO g_coo.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
   #   CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0)          #TQC-B10069  
       CALL s_errmsg("",g_coo.coo01,"",SQLCA.sqlcode,1)  #TQC-B10069
       LET g_success = 'N'                               #TQC-B10069
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   FOREACH firm_cs INTO l_coo.*
     #IF STATUS THEN LET g_success='N' EXIT FOREACH END IF #TQC-B10069       
      IF STATUS THEN             #TQC-B10069      
         LET g_success='N'       #TQC-B10069
         CONTINUE FOREACH        #TQC-B10069  
      END IF                     #TQC-B10069
#No.CHI-A80036   ---begin---
      IF l_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
      #  CALL cl_err(l_coo.coo01,'aco-228',1)   #TQC-B10069
         CALL s_errmsg("coo22",l_coo.coo01,l_coo.coo22,'aco-228',1)  #TQC-B10069         
         LET g_success = 'N'           
         CONTINUE FOREACH 
      END IF
      IF l_coo.cooacti = 'N' THEN
      #  CALL cl_err(l_coo.coo01,9027,1)        #TQC-B10069
         CALL s_errmsg("coo01",l_coo.coo01,l_coo.cooacti,'9027',1)  #TQC-B10069      
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
#No.CHI-A80036   ---end---
       IF cl_null(l_coo.coo18) OR cl_null(l_coo.coo07) THEN   #No.MOD-490398
       #  CALL cl_err(l_coo.coo01,'aco-064',1)              #TQC-B10069
         CALL s_errmsg("coo01",l_coo.coo01,"",'aco-064',1)  #TQC-B10069    
         LET g_success = 'N'                                #TQC-B10069
         IF only_one='1' THEN LET g_success='N' END IF
         CONTINUE FOREACH
      END IF
       IF l_coo.coo10 MATCHES '[0123567]' THEN                #No.MOD-490398
         #檢查手冊數量是否已大於申請數量....
         SELECT coc01 INTO l_coc01 FROM coc_file
           WHERE coc03 = l_coo.coo18 AND cocacti = 'Y'        #No.MOD-490398
 
         #若為大手冊可能於核銷時才指定版本生成核銷單身,
         #但更新時仍需以原手冊對應版本為主
         SELECT cod02,cod041 INTO l_seq,l_coo.coo19
           FROM cod_file
          WHERE cod01 = l_coc01 AND cod03 = l_coo.coo11
             AND cod041= l_coo.coo19                          #No.MOD-490398
         IF STATUS THEN
#           CALL cl_err(l_coo.coo01,'aco-077',1)  #No.TQC-660045
         #  CALL cl_err3("sel","cod_file",l_coo.coo01,l_coo.coo11,"aco-077","","",1) #TQC-660045    #TQC-B10069
            CALL s_errmsg("sel",l_coo.coo01,"cod_file",'aco-077',1)  #TQC-B10069
         #  LET g_success='N' EXIT FOREACH      #TQC-B10069
            LET g_success='N' CONTINUE FOREACH  #TQC-B10069 
         END IF
 
          #No.MOD-490398  --begin
         #傳手冊編號
         #CALL s_codqty(l_coo.coo09,l_seq) RETURNING l_qty     #合同剩餘量
         CALL s_codqty(l_coo.coo18,l_seq) RETURNING l_qty      #合同剩餘量
         #成品出口-已確認未報關
         SELECT SUM(coo16) INTO l_tot FROM coo_file
          WHERE coo18 = l_coo.coo18 AND cooconf='Y'
            AND coo11 = l_coo.coo11 AND coo20 = 'N'
            AND coo19 = l_coo.coo19 AND coo10 IN ('0','1','2','3')
         IF cl_null(l_tot) THEN LET l_tot = 0 END IF
         #成品進口-已確認未報關
         SELECT SUM(coo16) INTO l_tot2 FROM coo_file
          WHERE coo18 = l_coo.coo18 AND cooconf='Y'
            AND coo11 = l_coo.coo11 AND coo20 = 'N'
            AND coo19 = l_coo.coo19 AND coo10 IN ('5','6','7')
         IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
 
         LET l_tot = l_tot - l_tot2
         LET l_coo16 = l_coo.coo16
         IF l_coo.coo10 MATCHES '[567]' THEN LET l_coo16 = l_coo16 * -1 END IF
         IF l_tot + l_coo16 > l_qty THEN
         #  CALL cl_err(l_coo.coo01,'aco-065',1) LET g_success='N' EXIT FOREACH     #TQC-B10069
            CALL s_errmsg("",l_coo.coo01,"",'aco-065',1)  #TQC-B10069
            LET g_success='N'         #TQC-B10069 
            CONTINUE FOREACH          #TQC-B10069
         END IF
          #No.MOD-490398 --end
 
         #檢查材料是否超過進口可用量
         DECLARE col_curs CURSOR FOR
          SELECT * FROM col_file
           WHERE col01 = l_coo.coo01 AND col02 = l_coo.coo02
         LET l_flag = 'N'
          #No.MOD-490398  --begin
         FOREACH col_curs INTO l_col.*
            SELECT coc01 INTO l_coc01 FROM coc_file
              WHERE coc03 = l_coo.coo18 AND cocacti = 'Y' #No.MOD-490398
            SELECT (coe051+coe09+coe101+coe107-coe104-coe108-coe109),
                   (coe091+coe102+coe103+coe105+coe106)
              INTO l_sum,l_qty
              FROM coe_file
             WHERE coe01 = l_coc01
               AND coe03 = l_col.col04
            IF cl_null(l_sum) THEN LET l_sum=0 END IF
            IF cl_null(l_qty) THEN LET l_qty=0 END IF
            IF l_qty > l_sum THEN  #已耗用量>已進口量
            #  CALL cl_err(l_col.col04,'aco-029',1)          #TQC-B10069
               CALL s_errmsg("",l_coo.coo01,l_col.col04,'aco-029',1)  #TQC-B10069
            #  LET l_flag = 'Y' EXIT FOREACH       #TQC-B10069
               LET l_flag = 'Y'      #TQC-B10069
               LET g_success = 'N'   #TQC-B10069
               CONTINUE FOREACH      #TQC-B10069
            END IF
            SELECT SUM(col10) INTO l_tot FROM col_file,coo_file
             WHERE coo18 = l_coo.coo18
               AND col01 != l_coo.coo01 AND col02 != l_coo.coo02
               AND col01 = coo01 AND col02 = coo02
               AND cooconf='Y'   AND coo10 IN ('0','1','2','3')
               AND col04 = l_col.col04    #要加材料的商品編號...否則統計???
            IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
            SELECT SUM(col10) INTO l_tot2 FROM col_file,coo_file
             WHERE coo18 = l_coo.coo18
               AND col01 != l_coo.coo01 AND col02 != l_coo.coo02
               AND col01 = coo01 AND col02 = coo02
               AND cooconf='Y'   AND coo10 IN ('5','6','7')
               AND col04 = l_col.col04    #要加材料的商品編號...否則統計???
            IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
 
            LET l_tot = l_tot - l_tot2     #出口-進口
            LET l_col10 = l_col.col10
            IF l_coo.coo10 MATCHES '[567]' THEN LET l_col10 = l_col10 * -1 END IF
 
            IF l_tot + l_col10 > l_sum THEN
            #  CALL cl_err(l_col.col04,'aco-029',1)          #TQC-B10069
            #  LET l_flag = 'Y' EXIT FOREACH                 #TQC-B10069
               CALL s_errmsg("",l_col.col04,"",'aco-029',1)  #TQC-B10069    
               LET l_flag = 'Y'       #TQC-B10069
               LET g_success = 'N'    #TQC-B10069 
               CONTINUE FOREACH       #TQC-B10069  
            END IF
         END FOREACH
          #No.MOD-490398  --end
         IF l_flag = 'Y' THEN CONTINUE FOREACH END IF
      END IF
      UPDATE coo_file SET cooconf='Y'
       WHERE coo01 = l_coo.coo01 AND coo02 = l_coo.coo02
      IF STATUS THEN
#        CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
#        CALL cl_err3("upd","coo_file",l_coo.coo01,l_coo.coo02,STATUS,"","upd cofconf",1) #TQC-660045  #TQC-B10069
         CALL s_errmsg("upd",l_coo.coo01,"upd cofconf",'STATUS',1)  #TQC-B10069
         LET g_success='N'
      END IF
   END FOREACH
   CLOSE WINDOW t400_y  
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_cmmsg(1)
      ELSE
         ROLLBACK WORK
         CALL cl_rbmsg(1)
      END IF
      SELECT cooconf INTO g_coo.cooconf FROM coo_file
       WHERE coo01 = g_coo.coo01 AND coo02 = g_coo.coo02
      DISPLAY BY NAME g_coo.cooconf
      CALL cl_set_field_pic(g_coo.cooconf,"","","","",g_coo.cooacti)
END FUNCTION
 
FUNCTION t400_z()
   DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680069 SMALLINT
   IF g_coo.coo01 IS NULL THEN RETURN END IF
   SELECT * INTO g_coo.* FROM coo_file
    WHERE coo01=g_coo.coo01 AND coo02= g_coo.coo02
   IF g_coo.cooconf='N' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
   IF g_coo.cooacti = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
   IF g_coo.coo20 = 'Y' THEN
      CALL cl_err(g_coo.coo01,'aco-069',0) RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM cnp_file
    WHERE cnp12 = g_coo.coo01 AND cnp13 = g_coo.coo02
   IF l_cnt > 0 THEN
      CALL cl_err(g_coo.coo01,'aco-030',0) RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t400_cl USING g_coo.coo01,g_coo.coo02
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t400_cl INTO g_coo.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_coo.coo01,SQLCA.sqlcode,0)
       CLOSE t400_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   UPDATE coo_file SET cooconf='N'
    WHERE coo01 = g_coo.coo01 AND coo02 = g_coo.coo02
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
      CALL cl_err3("upd","coo_file",g_coo.coo01,g_coo.coo02,STATUS,"","upd cofconf",1) #TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cooconf INTO g_coo.cooconf FROM coo_file
    WHERE coo01 = g_coo.coo01 AND coo02 = g_coo.coo02
   DISPLAY BY NAME g_coo.cooconf
   CALL cl_set_field_pic(g_coo.cooconf,"","","","",g_coo.cooacti)
END FUNCTION
 
FUNCTION t400_gen()
 DEFINE l_col      RECORD LIKE col_file.*,
        l_con      RECORD LIKE con_file.*,
        l_cnt      LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF g_coo.coo01 IS NULL OR g_coo.coo02 IS NULL THEN RETURN END IF
   IF g_coo.cooacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_coo.coo01,'mfg1000',0) RETURN
   END IF
   IF g_coo.cooconf ='Y' THEN    #檢查資料是否審核
      CALL cl_err(g_msg,'9022',0) RETURN
   END IF
     #No.MOD-530224  --begin
    IF g_coo.coo22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    IF g_coo.coo10 NOT MATCHES '[0123567]' THEN RETURN END IF  #No.MOD-490398
   SELECT COUNT(*) INTO l_cnt FROM col_file
    WHERE col01 = g_coo.coo01 AND col02 = g_coo.coo02
   IF l_cnt > 0 THEN
      IF NOT cl_confirm('aco-070') THEN RETURN END IF
      DELETE FROM col_file WHERE col01 = g_coo.coo01 AND col02 = g_coo.coo02
   END IF
 
   DECLARE con_curs CURSOR FOR
    SELECT * FROM con_file
     WHERE con01 = g_coo.coo11
       AND con013 = g_coo.coo19
        AND con08  = g_coo.coo12            #No.MOD-490398
     ORDER BY con02
 
   INITIALIZE l_col.* TO NULL
   LET l_col.col01 = g_coo.coo01
   LET l_col.col02 = g_coo.coo02
   LET l_col.col03 = 0
   FOREACH con_curs INTO l_con.*
      IF STATUS THEN CALL cl_err('con_curs',STATUS,0) EXIT FOREACH END IF
      LET l_col.col03 = l_col.col03 + 1
      LET l_col.col04 = l_con.con03
      LET l_col.col06 = l_con.con04
      LET l_col.col07 = l_con.con05
      LET l_col.col08 = l_con.con06
      LET l_col.col09 = g_coo.coo16*l_col.col07*(1+l_col.col08/100)
      LET l_col.col09 = s_digqty(l_col.col09,l_col.col06) #FUN-BB0083 add
      LET l_col.col10 = l_col.col09
      LET l_col.col10 = s_digqty(l_col.col10,l_col.col06) #FUN-BB0083 add
      LET l_col.col11 = l_col.col07
      LET l_col.col12 = l_col.col08
      LET l_col.colplant = g_plant  #FUN-980002
      LET l_col.collegal = g_legal  #FUN-980002
      INSERT INTO col_file VALUES(l_col.*)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('ins col',STATUS,0)  #No.TQC-660045
         CALL cl_err3("ins","col_file",l_col.col01,l_col.col02,STATUS,"","ins col",1) #TQC-660045
         EXIT FOREACH
      END IF
   END FOREACH
   CALL t400_b_fill('1=1')                 #單身
END FUNCTION
 
FUNCTION t400_re_count()
   DEFINE l_col   RECORD LIKE col_file.*
 
   IF cl_null(g_coo.coo16) THEN RETURN END IF
 
   DECLARE re_curs CURSOR FOR
    SELECT col_file.* FROM col_file
     WHERE col01 = g_coo.coo01 AND col02 = g_coo.coo02
     ORDER BY col03
 
   FOREACH re_curs INTO l_col.*
       IF STATUS THEN CALL cl_err('re_curs',STATUS,0) EXIT FOREACH END IF
       LET l_col.col09 = g_coo.coo16*l_col.col07*(1+l_col.col08/100)
       LET l_col.col09 = s_digqty(l_col.col09,l_col.col06) #FUN-BB0083 add
       LET l_col.col10 = l_col.col09
       LET l_col.col10 = s_digqty(l_col.col10,l_col.col06) #FUN-BB0083 add
       UPDATE col_file SET * = l_col.*
        WHERE col01=l_col.col01 AND col02=l_col.col02 AND col03=l_col.col03
       IF STATUS THEN
#         CALL cl_err('upd col',STATUS,0)  #No.TQC-660045
          CALL cl_err3("upd","col_file",l_col.col01,l_col.col02,STATUS,"","upd col",1) #TQC-660045
          EXIT FOREACH
       END IF
   END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001> #
