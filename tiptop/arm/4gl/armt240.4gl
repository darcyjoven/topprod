# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt240.4gl
# Descriptions...: RMA覆出PACKING維護作業
# Date & Author..: 98/05/01 By plum
# Modify.........: MOD-4A0268 04/09/30 By ching 無箱號不產生單身
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/03 By Mandy 報表轉XML
# Modify.........: No.MOD-490415 05/07/27 By Smapmin 增加刪除功能...
# Modify.........: NO.MOD-570364 05/08/08 BY yiting 無法確認時增加錯誤訊息
#                  重新做display以免沒跑ON ROW CHANGE
# Modify.........: NO.MOD-570393 05/10/28 By Mandy 誤MARK t240_rmq()的相關地方拿掉
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/15 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0213 07/01/12 By chenl 報表底部增加程序代號及接下頁或結束字樣。
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810125 08/01/16 By claire UPDATE rmf_file key 值使用錯誤
# Modify.........: No.FUN-840068 08/04/23 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.CHI-840077 08/04/30 By jamie 單身欄位"數量"不開放修改
# Modify.........: No.FUN-860018 08/06/19 By TSD.lucasyeh 轉Crystal Report  
# Modify.........: No.FUN-890102 08/09/23 By baofei CR追單到31區
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0204 10/01/04 By lilingyu 單身有字段未維護負數控管
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rme   RECORD LIKE rme_file.*,
    g_rme_t RECORD LIKE rme_file.*,
    g_rme_o RECORD LIKE rme_file.*,
    g_rmq           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmq02     LIKE rmq_file.rmq02,
                    rmq05     LIKE rmq_file.rmq05,
                    rmq06     LIKE rmq_file.rmq06,
                    rmq07     LIKE rmq_file.rmq07,
                    rmq08     LIKE rmq_file.rmq08,
                    rmq03     LIKE rmq_file.rmq03,
                    rmq04     LIKE rmq_file.rmq04,
                  #FUN-840068 --start---
                    rmqud01   LIKE rmq_file.rmqud01,
                    rmqud02   LIKE rmq_file.rmqud02,
                    rmqud03   LIKE rmq_file.rmqud03,
                    rmqud04   LIKE rmq_file.rmqud04,
                    rmqud05   LIKE rmq_file.rmqud05,
                    rmqud06   LIKE rmq_file.rmqud06,
                    rmqud07   LIKE rmq_file.rmqud07,
                    rmqud08   LIKE rmq_file.rmqud08,
                    rmqud09   LIKE rmq_file.rmqud09,
                    rmqud10   LIKE rmq_file.rmqud10,
                    rmqud11   LIKE rmq_file.rmqud11,
                    rmqud12   LIKE rmq_file.rmqud12,
                    rmqud13   LIKE rmq_file.rmqud13,
                    rmqud14   LIKE rmq_file.rmqud14,
                    rmqud15   LIKE rmq_file.rmqud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmq_t         RECORD
                    rmq02     LIKE rmq_file.rmq02,
                    rmq05     LIKE rmq_file.rmq05,
                    rmq06     LIKE rmq_file.rmq06,
                    rmq07     LIKE rmq_file.rmq07,
                    rmq08     LIKE rmq_file.rmq08,
                    rmq03     LIKE rmq_file.rmq03,
                    rmq04     LIKE rmq_file.rmq04,
                  #FUN-840068 --start---
                    rmqud01   LIKE rmq_file.rmqud01,
                    rmqud02   LIKE rmq_file.rmqud02,
                    rmqud03   LIKE rmq_file.rmqud03,
                    rmqud04   LIKE rmq_file.rmqud04,
                    rmqud05   LIKE rmq_file.rmqud05,
                    rmqud06   LIKE rmq_file.rmqud06,
                    rmqud07   LIKE rmq_file.rmqud07,
                    rmqud08   LIKE rmq_file.rmqud08,
                    rmqud09   LIKE rmq_file.rmqud09,
                    rmqud10   LIKE rmq_file.rmqud10,
                    rmqud11   LIKE rmq_file.rmqud11,
                    rmqud12   LIKE rmq_file.rmqud12,
                    rmqud13   LIKE rmq_file.rmqud13,
                    rmqud14   LIKE rmq_file.rmqud14,
                    rmqud15   LIKE rmq_file.rmqud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rmq_o         RECORD
                    rmq02     LIKE rmq_file.rmq02,
                    rmq05     LIKE rmq_file.rmq05,
                    rmq06     LIKE rmq_file.rmq06,
                    rmq07     LIKE rmq_file.rmq07,
                    rmq08     LIKE rmq_file.rmq08,
                    rmq03     LIKE rmq_file.rmq03,
                    rmq04     LIKE rmq_file.rmq04,
                  #FUN-840068 --start---
                    rmqud01   LIKE rmq_file.rmqud01,
                    rmqud02   LIKE rmq_file.rmqud02,
                    rmqud03   LIKE rmq_file.rmqud03,
                    rmqud04   LIKE rmq_file.rmqud04,
                    rmqud05   LIKE rmq_file.rmqud05,
                    rmqud06   LIKE rmq_file.rmqud06,
                    rmqud07   LIKE rmq_file.rmqud07,
                    rmqud08   LIKE rmq_file.rmqud08,
                    rmqud09   LIKE rmq_file.rmqud09,
                    rmqud10   LIKE rmq_file.rmqud10,
                    rmqud11   LIKE rmq_file.rmqud11,
                    rmqud12   LIKE rmq_file.rmqud12,
                    rmqud13   LIKE rmq_file.rmqud13,
                    rmqud14   LIKE rmq_file.rmqud14,
                    rmqud15   LIKE rmq_file.rmqud15
                  #FUN-840068 --end--
                    END RECORD,
    g_rme01_t       LIKE rme_file.rme01,
    g_rme01         LIKE rme_file.rme01,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
#   g_t1                VARCHAR(3),
    g_t1                LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_buf,g_buf1        LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5,        #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    l_occ           RECORD LIKE occ_file.*,
    l_gem02         LIKE gem_file.gem02,
    l_gen02         LIKE gen_file.gen02
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_str,l_table  STRING                 #No.FUN-860018 add FOR C.R.                                                          
DEFINE   tm    RECORD                                                                                                               
               wc       STRING                 #No.FUN-860018 add FOR C.R.                                                          
               END RECORD                              
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0085
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
   #No.FUN-860018 add---start                                                                                                       
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   LET g_sql = "rme01.rme_file.rme01,",                                                                                             
               "rme02.rme_file.rme02,",                                                                                             
               "rme011.rme_file.rme011,",                                                                                           
               "rme03.rme_file.rme03,",                                                                                             
               "rme04.rme_file.rme04,",                                                                                             
               "rmq02.rmq_file.rmq02,",                                                                                             
               "rmq05.rmq_file.rmq05,",                                                                                             
               "rmq06.rmq_file.rmq06,",                                                                                             
               "rmq07.rmq_file.rmq07,",                                                                                             
               "rmq03.rmq_file.rmq03,",                                                                                             
               "rmq04.rmq_file.rmq04"                                                                                               
                                              #11 items                                                                             
                                                                                                                                    
   LET l_table = cl_prt_temptable('armt240',g_sql) CLIPPED   # 產生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                       
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,                                                                          
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ? )"                                                                                  
   PREPARE insert_prep FROM g_sql      
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                          
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
   #------------------------------ CR (1) ------------------------------#                                                           
   #No.FUN-860018 add---end  
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 24
   ELSE LET p_row = 5 LET p_col = 8
   END IF
    OPEN WINDOW t240_w AT p_row,p_col WITH FORM "arm/42f/armt240"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_forupd_sql =
      "SELECT * FROM rme_file WHERE rme01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t240_cl CURSOR FROM g_forupd_sql
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    LET g_rme01=ARG_VAL(1)
     #MOD-4A0268
    IF NOT cl_null(g_rme01) THEN
       LET g_wc="rme01='",g_rme01,"'"
       LET g_wc2=" 1=1"
       CALL t240_q()
    END IF
    #--
    CALL t240_menu()
    CLOSE WINDOW t240_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t240_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_rmq.clear()
    IF cl_null(g_rme01) THEN
    WHILE TRUE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031  
   INITIALIZE g_rme.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON            # 螢幕上取單頭條件
        rme01,rme011,rme02,rme03,rme04,rmepack,
      #FUN-840068   ---start---
        rmeud01,rmeud02,rmeud03,rmeud04,rmeud05,
        rmeud06,rmeud07,rmeud08,rmeud09,rmeud10,
        rmeud11,rmeud12,rmeud13,rmeud14,rmeud15
      #FUN-840068    ----end----               #No.FUN-580031 --start--     HCN
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
       #rmeconf,rmeuser,rmegrup,rmemodu,rmedate
      IF INT_FLAG THEN RETURN END IF
      EXIT WHILE
    END WHILE
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
    #End:FUN-980030
 
    LET g_wc = g_wc clipped
    CONSTRUCT g_wc2 ON rmq02,rmq05,rmq06,rmq07,rmq08,rmq03,rmq04
                   #No.FUN-840068 --start--
                      ,rmqud01,rmqud02,rmqud03,rmqud04,rmqud05
                      ,rmqud06,rmqud07,rmqud08,rmqud09,rmqud10
                      ,rmqud11,rmqud12,rmqud13,rmqud14,rmqud15
                   #No.FUN-840068 ---end---
        FROM s_rmq[1].rmq02, s_rmq[1].rmq05, s_rmq[1].rmq06,
             s_rmq[1].rmq07, s_rmq[1].rmq08, s_rmq[1].rmq03, s_rmq[1].rmq04
           #No.FUN-840068 --start--
            ,s_rmq[1].rmqud01,s_rmq[1].rmqud02,s_rmq[1].rmqud03
	    ,s_rmq[1].rmqud04,s_rmq[1].rmqud05,s_rmq[1].rmqud06
            ,s_rmq[1].rmqud07,s_rmq[1].rmqud08,s_rmq[1].rmqud09
            ,s_rmq[1].rmqud10,s_rmq[1].rmqud11,s_rmq[1].rmqud12
	    ,s_rmq[1].rmqud13,s_rmq[1].rmqud14,s_rmq[1].rmqud15
           #No.FUN-840068 ---end---
 
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
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT rme01 FROM rme_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rme01"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rme01 ",
                   "  FROM rme_file, rmq_file",
                   " WHERE rme01 = rmq01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rme01"
    END IF
 
    PREPARE t240_prepare FROM g_sql
    DECLARE t240_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t240_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rme_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rme01) FROM rme_file,rmq_file WHERE ",
                  "rmq01=rme01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t240_precount FROM g_sql
    DECLARE t240_count CURSOR FOR t240_precount
END FUNCTION
 
FUNCTION t240_menu()
 
   WHILE TRUE
      CALL t240_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t240_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t240_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 #MOD-490415
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t240_r()
            END IF
 #END MOD-490415
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t240_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t240_y()
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t240_z()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmq),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rme.rme01 IS NOT NULL THEN
                 LET g_doc.column1 = "rme01"
                 LET g_doc.value1 = g_rme.rme01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0018-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t240_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rme.* TO NULL               #NO.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t240_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_rme.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t240_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL
    ELSE
        OPEN t240_count
        FETCH t240_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t240_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t240_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t240_cs INTO g_rme.rme01
        WHEN 'P' FETCH PREVIOUS t240_cs INTO g_rme.rme01
        WHEN 'F' FETCH FIRST    t240_cs INTO g_rme.rme01
        WHEN 'L' FETCH LAST     t240_cs INTO g_rme.rme01
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
            FETCH ABSOLUTE g_jump t240_cs INTO g_rme.rme01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF SQLCA.sqlcode THEN
 #       CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)#FUN-660111
        CALL cl_err3("sel","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rme.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rme.rmeuser #FUN-4C0055
        LET g_data_group = g_rme.rmegrup #FUN-4C0055
        LET g_data_plant = g_rme.rmeplant #FUN-980030
    END IF
 
    CALL t240_show()
END FUNCTION
 
FUNCTION t240_show()
    LET g_rme_t.* = g_rme.*                #保存單頭舊值
    DISPLAY BY NAME
 
        g_rme.rme01,g_rme.rme011,g_rme.rme02,g_rme.rme03,g_rme.rme04,
        g_rme.rmepack,
       #g_rme.rmeuser,g_rme.rmegrup,g_rme.rmemodu,g_rme.rmedate
       #FUN-840068     ---start---
        g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
        g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
        g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
        g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15 
       #FUN-840068     ----end----
    #CKP
    CALL cl_set_field_pic(g_rme.rmepack  ,"","","","",g_rme.rmevoid)
      CALL t240_rmq()   #MOD-490415 #MOD-570393 unMark
    CALL t240_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t240_rmq()
       DEFINE l_rmf33  LIKE rmf_file.rmf33,
              l_rmq02  LIKE rmq_file.rmq02,
              l_n      LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
     #將此覆出單(rme_file)的單身.dbo.rmq_file 之C/NO (rmq05)
     #      但不存在rmf_file 之C/NO(rmf33) 刪除
    LET g_success="Y"
    BEGIN WORK
 
     #MOD-4A0268
    DELETE FROM rmq_file
     WHERE rmq01=g_rme.rme01
       AND (rmq05 NOT IN (SELECT UNIQUE(rmf33) FROM rmf_file
                           WHERE rmf01=g_rme.rme01)
            OR rmq05 IS NULL )
      # OR rmq08 is null or rmq08=0
    #--
 
    DECLARE rmf_cs CURSOR FOR   #C/NO 不重覆
        SELECT UNIQUE rmf33 FROM rmf_file
         WHERE rmf01=g_rme.rme01
            AND rmf33 IS NOT NULL   #MOD-4A0268
         ORDER BY rmf33
 
    FOREACH rmf_cs  INTO l_rmf33          #單身 ARRAY 填充
        IF STATUS THEN
           LET g_success="N"
           EXIT FOREACH
        ELSE
           LET l_n=0
           SELECT COUNT(*) INTO l_n FROM rmq_file
                  WHERE rmq01=g_rme.rme01 AND rmq05=l_rmf33
           IF l_n=0 THEN
              SELECT MAX(rmq02)+1 INTO l_rmq02 FROM rmq_file
                     WHERE rmq01=g_rme.rme01
              IF l_rmq02 IS NULL THEN LET l_rmq02=1 END IF
              let l_n=0
              SELECT COUNT(*) INTO l_n FROM rmp_file
               WHERE rmp00='1' AND rmp01=g_rme.rme01 AND rmp03=l_rmf33
              IF l_n IS NULL THEN LET l_n=0 END IF
              INSERT INTO rmq_file(rmq01,rmq02,rmq03,rmq05,rmq07,rmq08,
                                   rmqplant,rmqlegal)      #FUN-980007
                     VALUES (g_rme.rme01,l_rmq02,0,l_rmf33,0,l_n,
                             g_plant,g_legal)              #FUN-980007
              IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
      #           CALL cl_err('ins rmq',STATUS,1)#FUN-660111
                 CALL cl_err3("ins","rmq_file",g_rme.rme01,l_rmq02,STATUS,"","ins rmq",1) #FUN-660111
                 LET g_success="N"
                 EXIT FOREACH
              END IF
           ELSE
              let l_n=0
              SELECT COUNT(*) INTO l_n FROM rmp_file
               WHERE rmp00='1' AND rmp01=g_rme.rme01 AND rmp03=l_rmf33
              IF l_n IS NULL THEN LET l_n=0 END IF
              UPDATE rmq_file set rmq08=l_n
               WHERE rmq01=g_rme.rme01 AND rmq05=l_rmf33
              IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
     #            CALL cl_err('up rmq',STATUS,1)#FUN-660111
                 CALL cl_err3("upd","rmq_file",g_rme.rme01,l_rmf33,STATUS,"","up rmq",1) #FUN-660111
                 LET g_success="N"
                 EXIT FOREACH
              END IF
           END IF
        END IF
    END FOREACH
    IF g_success="Y" THEN COMMIT WORK ELSE ROLLBACK WORK END IF
 
 
    CALL t240_b_fill(" 1=1")
END FUNCTION
 
 #MOD-490415
FUNCTION t240_r()
   IF g_rme.rmepack = 'Y' THEN
      CALL cl_err("",'anm-105',0)
      RETURN
   END IF
 
   IF cl_null(g_rme.rme01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF s_shut(0) THEN RETURN END IF
   BEGIN WORK
 
   OPEN t240_cl USING g_rme.rme01
   IF STATUS THEN
      CALL cl_err("OPEN t240_cl:", STATUS, 1)
      CLOSE t240_cl
      ROLLBACK WORK
      RETURN
   END IF
 
  FETCH t240_cl INTO g_rme.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE t240_cl ROLLBACK WORK RETURN
   END IF
   CALL t240_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rme01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rme.rme01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM rme_file WHERE rme01 = g_rme.rme01
 
      DELETE FROM rmq_file WHERE rmq01 = g_rme.rme01
 
      INITIALIZE g_rme.* TO NULL
      CLEAR FORM
      CALL g_rmq.clear()
 
      OPEN t240_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t240_cs
         CLOSE t240_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t240_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t240_cs
         CLOSE t240_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN t240_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t240_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t240_fetch('/')
      END IF
   END IF
 
   CLOSE t240_cl
   COMMIT WORK
 
END FUNCTION
 #END MOD-490415
 
FUNCTION t240_b()                          #本單身無新增,刪除功能
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    g_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #用來設定判斷重複的可能性
    l_b2            LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(30),
    l_ima35,l_ima36 LIKE ima_file.ima35,    #No.FUN-690010 VARCHAR(10),
#    l_qty           LIKE ima_file.ima26,    #No.FUN-690010 DECIMAL(15,3), #FUN-A20044
    l_qty           LIKE type_file.num15_3,    #No.FUN-690010 DECIMAL(15,3), #FUN-A20044
    l_flag          LIKE type_file.num10,   #No.FUN-690010 INTEGER,
    g_rmq04         LIKE rmq_file.rmq04,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL OR g_wc IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rme.rmepack = 'Y' THEN CALL cl_err('pack=Y','aap-086',0) RETURN END IF
    IF g_rme.rmepack="N"  THEN    #AND g_rme.rmegen="Y" THEN  #包裝未確認AND覆出未確認
         CALL t240_rmq()   #MOD-490415 #MOD-570393 unMark
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT rmq02,rmq05,rmq06,rmq07,rmq08,rmq03,rmq04,",
     #No.FUN-840068 --start--
      "        rmqud01,rmqud02,rmqud03,rmqud04,rmqud05,",
      "        rmqud06,rmqud07,rmqud08,rmqud09,rmqud10,",
      "        rmqud11,rmqud12,rmqud13,rmqud14,rmqud15 ", 
     #No.FUN-840068 ---end---
      " FROM rmq_file ",
      "  WHERE rmq01= ? ", #g_rme.rme01
      "   AND rmq02= ? ", #g_rmq_t.rmq02
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t240_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
      INPUT ARRAY g_rmq WITHOUT DEFAULTS FROM s_rmq.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                       #INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)   #MOD-490415
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW =l_allow_insert)   #MOD-490415
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
 
            BEGIN WORK
            OPEN t240_cl USING g_rme.rme01
            IF STATUS THEN
               CALL cl_err("OPEN t240_cl:", STATUS, 1)
               CLOSE t240_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t240_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t240_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
              #CKP
              LET p_cmd='u'
              LET g_rmq_t.* = g_rmq[l_ac].*          # 900423
              LET g_rmq_o.* = g_rmq[l_ac].*          # 900423
               OPEN t240_bcl USING g_rme.rme01,g_rmq_t.rmq02
               IF STATUS THEN
                   CALL cl_err("OPEN t240_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH t240_bcl INTO g_rmq[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_rmq_t.rmq02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
               END IF
               IF l_ac > 1   AND (
                 (g_rmq[l_ac].rmq06 IS NULL)   OR
                  (g_rmq[l_ac].rmq07 IS NULL)   OR
                  (g_rmq[l_ac].rmq03 IS NULL) ) THEN
                  LET g_rmq[l_ac].rmq06 = g_rmq[l_ac-1].rmq06          # 900423
                  LET g_rmq[l_ac].rmq07 = g_rmq[l_ac-1].rmq07          # 900423
                  LET g_rmq[l_ac].rmq03 = g_rmq[l_ac-1].rmq03          # 900423
                  LET g_rmq[l_ac].rmq04 = g_rmq[l_ac-1].rmq04          # 900423
               END IF
               IF g_rmq[l_ac].rmq05 IS NULL THEN LET g_rmq[l_ac].rmq05=0 END IF
               IF g_rmq[l_ac].rmq07 IS NULL THEN LET g_rmq[l_ac].rmq07=0 END IF
               IF g_rmq[l_ac].rmq03 IS NULL THEN LET g_rmq[l_ac].rmq03=0 END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
             #NO.MOD-570364 --START
            DISPLAY BY NAME g_rmq[l_ac].rmq03
            DISPLAY BY NAME g_rmq[l_ac].rmq04
            DISPLAY BY NAME g_rmq[l_ac].rmq05
            DISPLAY BY NAME g_rmq[l_ac].rmq06
            DISPLAY BY NAME g_rmq[l_ac].rmq07
            #--end
 
           #CKP
           #NEXT FIELD rmq06
 
 #MOD-490415
        BEFORE INSERT
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_rmq[l_ac].* TO NULL      #900423
           LET g_rmq_t.* = g_rmq[l_ac].*         #新輸入資料
           NEXT FIELD rmq02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO rmq_file(rmq01,rmq02,rmq05,rmq06,rmq07,rmq08,rmq03,rmq04,
                              #FUN-840068 --start--
                                rmqud01,rmqud02,rmqud03,
                                rmqud04,rmqud05,rmqud06,
                                rmqud07,rmqud08,rmqud09,
                                rmqud10,rmqud11,rmqud12,
                                rmqud13,rmqud14,rmqud15,
                                rmqplant,rmqlegal) #FUN-980007
                              #FUN-840068 --end--
                         VALUES(g_rme.rme01,g_rmq[l_ac].rmq02,g_rmq[l_ac].rmq05,
                                g_rmq[l_ac].rmq06,g_rmq[l_ac].rmq07,
                                g_rmq[l_ac].rmq08,g_rmq[l_ac].rmq03,
                                g_rmq[l_ac].rmq04,
                              #FUN-840068 --start--
                                g_rmq[l_ac].rmqud01,
                                g_rmq[l_ac].rmqud02,
                                g_rmq[l_ac].rmqud03,
                                g_rmq[l_ac].rmqud04,
                                g_rmq[l_ac].rmqud05,
                                g_rmq[l_ac].rmqud06,
                                g_rmq[l_ac].rmqud07,
                                g_rmq[l_ac].rmqud08,
                                g_rmq[l_ac].rmqud09,
                                g_rmq[l_ac].rmqud10,
                                g_rmq[l_ac].rmqud11,
                                g_rmq[l_ac].rmqud12,
                                g_rmq[l_ac].rmqud13,
                                g_rmq[l_ac].rmqud14,
                                g_rmq[l_ac].rmqud15,
                                g_plant,g_legal )  #FUN-980007   
                              #FUN-840068 --end--
           IF SQLCA.sqlcode THEN
      #        CALL cl_err(g_rmq[l_ac].rmq02,SQLCA.sqlcode,1)#FUN-660111
              CALL cl_err3("ins","rmq_file",g_rme.rme01,g_rmq[l_ac].rmq02,SQLCA.sqlcode,"","",1) #FUN-660111
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
 #END MOD-490415
 
        AFTER FIELD rmq07
           IF NOT cl_null(g_rmq[l_ac].rmq07) THEN
               IF g_rmq[l_ac].rmq07 < 0 THEN
                   NEXT FIELD rmq07
               END IF
           END IF
 
#TQC-9C0204 --begin--
        AFTER FIELD rmq04
          IF NOT cl_null(g_rmq[l_ac].rmq04) THEN
             IF g_rmq[l_ac].rmq04 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD CURRENT
             END IF
          END IF  

        AFTER FIELD rmq06
          IF NOT cl_null(g_rmq[l_ac].rmq06) THEN
             IF g_rmq[l_ac].rmq06 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD CURRENT
             END IF
          END IF
#TQC-9C0204 --end--

        AFTER FIELD rmq03
           IF NOT cl_null(g_rmq[l_ac].rmq03) THEN
               IF g_rmq[l_ac].rmq03 < 0 THEN
                   NEXT FIELD rmq03
               END IF
               SELECT rmq04 INTO g_rmq04 FROM rmq_file
                   WHERE rmq01=g_rme.rme01 AND rmq03=g_rmq[l_ac].rmq03
               IF NOT cl_null(g_rmq04) THEN
                  LET g_rmq[l_ac].rmq04=g_rmq04
               END IF
           END IF
 
        #No.FUN-840068 --start--
        AFTER FIELD rmqud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD rmqud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
 #MOD-490415
        BEFORE DELETE                            #是否取消單身
           IF g_rmq_t.rmq02 > 0 AND g_rmq_t.rmq02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rmq_file
               WHERE rmq01 = g_rme.rme01
                 AND rmq02 = g_rmq_t.rmq02
              IF SQLCA.sqlcode THEN
 #                CALL cl_err(g_rmq_t.rmq02,SQLCA.sqlcode,0)#FUN-660111
                 CALL cl_err3("del","rmq_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete Ok"
              CLOSE t240_bcl
              COMMIT WORK
           END IF
 #END MOD-490415
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmq[l_ac].* = g_rmq_t.*
               CLOSE t240_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rmq[l_ac].rmq02,-263,1)
               LET g_rmq[l_ac].* = g_rmq_t.*
            ELSE
                IF g_rmq[l_ac].rmq03 !=0 THEN
                   IF g_rmq[l_ac].rmq04 IS NULL THEN
                   NEXT FIELD rmq04 END IF
                END IF
                UPDATE rmq_file SET
                   rmq05=g_rmq[l_ac].rmq05,
                   rmq06=g_rmq[l_ac].rmq06,
                   rmq07=g_rmq[l_ac].rmq07,
                  #rmq08=g_rmq[l_ac].rmq08,  #CHI-840077 add
                   rmq03=g_rmq[l_ac].rmq03,
                   rmq04=g_rmq[l_ac].rmq04,
                 #FUN-840068 --start--
                   rmqud01 = g_rmq[l_ac].rmqud01,
                   rmqud02 = g_rmq[l_ac].rmqud02,
                   rmqud03 = g_rmq[l_ac].rmqud03,
                   rmqud04 = g_rmq[l_ac].rmqud04,
                   rmqud05 = g_rmq[l_ac].rmqud05,
                   rmqud06 = g_rmq[l_ac].rmqud06,
                   rmqud07 = g_rmq[l_ac].rmqud07,
                   rmqud08 = g_rmq[l_ac].rmqud08,
                   rmqud09 = g_rmq[l_ac].rmqud09,
                   rmqud10 = g_rmq[l_ac].rmqud10,
                   rmqud11 = g_rmq[l_ac].rmqud11,
                   rmqud12 = g_rmq[l_ac].rmqud12,
                   rmqud13 = g_rmq[l_ac].rmqud13,
                   rmqud14 = g_rmq[l_ac].rmqud14,
                   rmqud15 = g_rmq[l_ac].rmqud15
                 #FUN-840068 --end-- 
                   WHERE rmq01=g_rme.rme01
                     AND rmq02=g_rmq_t.rmq02
                IF SQLCA.sqlcode THEN
    #               CALL cl_err('upd rmq',SQLCA.sqlcode,0)#FUN-660111
                   CALL cl_err3("upd","rmq_file",g_rme.rme01,g_rmq_t.rmq02,SQLCA.sqlcode,"","upd rmq",1) #FUN-660111
                   LET g_rmq[l_ac].* = g_rmq_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmq[l_ac].* = g_rmq_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t240_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D40030 add
          #CKP
          #LET g_rmq_t.* = g_rmq[l_ac].*          # 900423
            CLOSE t240_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t240_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmq06) AND l_ac > 1 THEN
                LET g_rmq[l_ac].rmq03 = g_rmq[l_ac-1].rmq03
                LET g_rmq[l_ac].rmq04 = g_rmq[l_ac-1].rmq04
                NEXT FIELD rmq06
            END IF
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
      END INPUT
 
      UPDATE rme_file SET rmemodu = g_user,rmedate = g_today
             WHERE rme01 = g_rme.rme01
 
    CLOSE t240_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t240_delall()
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM rme_file WHERE rme01 = g_rme.rme01
    END IF
END FUNCTION
 
FUNCTION t240_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(220)
    CONSTRUCT l_wc2 ON rmq02,rmq05,rmq06,rmq07,rmq08,rmq03,rmq04
                     #No.FUN-840068 --start--
                      ,rmqud01,rmqud02,rmqud03,rmqud04,rmqud05
                      ,rmqud06,rmqud07,rmqud08,rmqud09,rmqud10
                      ,rmqud11,rmqud12,rmqud13,rmqud14,rmqud15
                     #No.FUN-840068 ---end---
            FROM s_rmq[1].rmq02, s_rmq[1].rmq05, s_rmq[1].rmq06,
                 s_rmq[1].rmq07, s_rmq[1].rmq08, s_rmq[1].rmq03, s_rmq[1].rmq04
           #No.FUN-840068 --start--
                ,s_rmq[1].rmqud01,s_rmq[1].rmqud02,s_rmq[1].rmqud03
	        ,s_rmq[1].rmqud04,s_rmq[1].rmqud05,s_rmq[1].rmqud06
                ,s_rmq[1].rmqud07,s_rmq[1].rmqud08,s_rmq[1].rmqud09
                ,s_rmq[1].rmqud10,s_rmq[1].rmqud11,s_rmq[1].rmqud12
	        ,s_rmq[1].rmqud13,s_rmq[1].rmqud14,s_rmq[1].rmqud15
           #No.FUN-840068 ---end---
 
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
    CALL t240_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t240_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
 
    LET g_sql =
        "SELECT rmq02,rmq05,rmq06,rmq07,rmq08,rmq03,rmq04, ",
       #No.FUN-840068 --start--
        "       rmqud01,rmqud02,rmqud03,rmqud04,rmqud05,",
        "       rmqud06,rmqud07,rmqud08,rmqud09,rmqud10,",
        "       rmqud11,rmqud12,rmqud13,rmqud14,rmqud15 ", 
       #No.FUN-840068 ---end---
        " FROM rmq_file ,rme_file ",
        " WHERE rmq01 ='",g_rme.rme01,"'",  #單頭
        " AND ",p_wc2 CLIPPED,              #單身
        " AND rme01=rmq01 ",
        " ORDER BY 1,5"
 
    PREPARE t240_pb FROM g_sql
    DECLARE rmq_curs                       #SCROLL CURSOR
        CURSOR FOR t240_pb
 
    CALL g_rmq.clear()
    LET g_cnt = 1
    FOREACH rmq_curs INTO g_rmq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t240_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmq TO s_rmq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
 #MOD-490415
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 #END MOD-490415
 
      ON ACTION first
         CALL t240_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t240_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t240_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t240_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t240_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0018  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t240_y()         # when g_rme.rmepack='N' (Turn to 'Y')
   DEFINE l_i  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ---------- add ----------- begin
   IF g_rme.rme01 IS NULL OR g_wc IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmepack = 'Y' THEN CALL cl_err('pack=Y',9023,0) RETURN END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF
#CHI-C30107 ---------- add ----------- end
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL OR g_wc IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
  #IF g_rme.rmeconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
   IF g_rme.rmepack = 'Y' THEN CALL cl_err('pack=Y',9023,0) RETURN END IF
  #IF g_rme.rmegen  = 'N' THEN CALL cl_err('gen=N','aap-717',0) RETURN END IF
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
 
 
    OPEN t240_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t240_cl:", STATUS, 1)
       CLOSE t240_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t240_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t240_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   IF g_rec_b > 0 THEN
      FOR l_i = 1 TO g_rec_b
          IF g_rmq[l_i].rmq02 IS NULL OR g_rmq[l_i].rmq05 IS NULL THEN
             EXIT FOR END IF
          UPDATE rmf_file SET rmf31=g_rmq[l_i].rmq03,rmf32=g_rmq[l_i].rmq04,
                 rmf33=g_rmq[l_i].rmq05,rmf34=g_rmq[l_i].rmq06,
                 rmf35=g_rmq[l_i].rmq07
                 WHERE rmf01=g_rme.rme01 AND rmf02=g_rmq[l_i].rmq02   #MOD-810125 
                #WHERE rmf01=g_rme.rme01 AND rmf33=g_rmq[l_i].rmq05   #MOD-810125 mark
          IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
  #           CALL cl_err('up rmf:',SQLCA.sqlcode,1)#FUN-660111
             CALL cl_err3("upd","rmf_file",g_rme.rme01,g_rmq[l_i].rmq05,SQLCA.sqlcode,"","up rmf:",1) #FUN-660111
             LET g_success="N"
             EXIT FOR
          END IF
      END FOR
   ELSE
     CALL cl_err('','arm-034',0)
     RETURN
   END IF
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
       ROLLBACK WORK  RETURN
   END IF
   UPDATE rme_file SET rmepack = 'Y',rmemodu=g_user,rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
    #  CALL cl_err('upd rmepack',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rmepack",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rme.rmepack="Y"
      LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
      COMMIT WORK
      DISPLAY BY NAME g_rme.rmepack
      CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rme.rmepack='N'
      LET g_rme.rmemodu=g_rme_t.rmemodu LET g_rme.rmedate=g_rme_t.rmedate
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rmepack
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rme.rmepack  ,"","","","",g_rme.rmevoid)
END FUNCTION
 
FUNCTION t240_z()    # when g_rme.rmepack='Y' (Turn to 'N')
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL OR g_wc IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N..',9028,0) RETURN END IF
  #IF g_rme.rmeprin = 'Y' THEN CALL cl_err('prin=Y..','arm-042',0) RETURN END IF
   IF g_rme.rmepack = 'N' THEN CALL cl_err('pack=N..','arm-040',0) RETURN END IF
  #IF g_rme.rmeconf = 'N' THEN CALL cl_err('',9025,0) RETURN END IF
  #IF g_rme.rmepost='Y' THEN CALL cl_err('rmepost=Y:','aap-730',0) RETURN END IF
   IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   BEGIN WORK
 
 
    OPEN t240_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t240_cl:", STATUS, 1)
       CLOSE t240_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t240_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t240_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE rmf_file SET rmf31=NULL,rmf32=NULL,rmf34=NULL,rmf35=NULL
          WHERE rmf01=g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
   #   CALL cl_err('up rmf:',SQLCA.sqlcode,1)#FUN-660111
      CALL cl_err3("upd","rmf_file",g_rme.rme01,"",SQLCA.sqlcode,"","up rmf:",1) #FUN-660111
      LET g_success="N"  RETURN
   END IF
   UPDATE rme_file SET rmepack = 'N',rmemodu=g_user,rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
     # CALL cl_err('upd rmepack',STATUS,1)#FUN-660111
      CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rmepack",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rme.rmepack="N"
      LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
      COMMIT WORK
      DISPLAY BY NAME g_rme.rmepack
      CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rme.rmepack='Y'
      LET g_rme.rmemodu=g_rme_t.rmemodu LET g_rme.rmedate=g_rme_t.rmedate
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rmepack
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rme.rmepack  ,"","","","",g_rme.rmevoid)
END FUNCTION
 
FUNCTION t240_out()
DEFINE
    sr              RECORD
                    rme01     LIKE rme_file.rme01,      # RMA覆出單號
                    rme02     LIKE rme_file.rme02,      # 單據日期
                    rme011    LIKE rme_file.rme011,     # RMA單號
                    rme03     LIKE rme_file.rme03,      # 客戶編號
                    rme04     LIKE rme_file.rme04,      # 客戶簡稱
                    rmq02     LIKE rmq_file.rmq02,      # 項次
                    rmq05     LIKE rmq_file.rmq05,      # C/NO
                    rmq06     LIKE rmq_file.rmq06,      # DEIMESION
                    rmq07     LIKE rmq_file.rmq07,      # WEIGHTS
                    rmq03     LIKE rmq_file.rmq03,      # PLT/NO
                    rmq04     LIKE rmq_file.rmq04       # DIMENSION
                    END RECORD,
    l_name          LIKE type_file.chr20                #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
 
DEFINE l_sql        STRING                              #No.FUN-860018 add FOR C.R.                                                 
                                                                                                                                    
    #No.FUN-860018 add---start                                                                                                      
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                           
    CALL cl_del_data(l_table)                                                                                                       
    #------------------------------ CR (2) ------------------------------#                                                          
                                                                                                                                    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
    #No.FUN-860018 add---end  
 
    IF g_rme.rme01 IS NULL OR g_wc IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    CALL cl_wait()
#    LET l_name = 'armt240.out'
#    CALL cl_outnam('armt240') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT rme01,rme02,rme011,rme03,rme04,rmq02,rmq05,",
              "        rmq06,rmq07,rmq03,rmq04 ",
              " FROM rme_file,rmq_file",
              " WHERE rme01=rmq01 AND ",g_wc CLIPPED,
              "   AND rmeconf <> 'X' ",  #CHI-C80041
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,3 "
    PREPARE t240_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t240_co                         # SCROLL CURSOR
        CURSOR FOR t240_p1
 
#    START REPORT t240_rep TO l_name
 
    FOREACH t240_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-860018 add---start                                                                                                  
        EXECUTE insert_prep USING sr.*                                                                                              
        IF SQLCA.sqlcode  THEN                                                                                                      
           CALL cl_err('insert_prep:',STATUS,1)                                                                                     
           EXIT FOREACH                                                                                                             
        END IF                                                                                                                      
        #------------------------------------CR (3)-------------------------------#                                                 
        #No.FUN-860018 add---end 
#        OUTPUT TO REPORT t240_rep(sr.*)
 
    END FOREACH
    #No.FUN-860018 add---start                                                                                                      
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    #是否列印選擇條件                                                                                                               
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'rme11,rme01,rme02,rme03,rme04')                                                                          
            RETURNING g_str                                                                                                         
    ELSE                                                                                                                            
       LET g_str = ''                                                                                                               
    END IF                                                                                                                          
    LET g_str = g_str                                                                                                               
    CALL cl_prt_cs3('armt240','armt240',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#                                                          
    #No.FUN-860018 add---end   
#    FINISH REPORT t240_rep
    CLOSE t240_co
    MESSAGE ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-860018---begin
#REPORT t240_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#         sr        RECORD
#                   rme01     LIKE rme_file.rme01,      # RMA覆出單號
#                   rme02     LIKE rme_file.rme02,      # 單據日期
#                   rme011    LIKE rme_file.rme011,     # RMA單號
#                   rme03     LIKE rme_file.rme03,      # 客戶編號
#                   rme04     LIKE rme_file.rme04,      # 客戶簡稱
#                   rmq02     LIKE rmq_file.rmq02,      # 項次
#                   rmq05     LIKE rmq_file.rmq05,      # C/NO
#                   rmq06     LIKE rmq_file.rmq06,      # DEIMESION
#                   rmq07     LIKE rmq_file.rmq07,      # WEIGHTS
#                   rmq03     LIKE rmq_file.rmq03,      # PLT/NO
#                   rmq04     LIKE rmq_file.rmq04       # DIMENSION
#                   END RECORD,
#          l_qty,l_cno,l_plt  LIKE type_file.num5    #No.FUN-690010 smallint
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
# ORDER BY sr.rme01,sr.rmq02,sr.rmq05,sr.rmq03
 
# FORMAT
#  PAGE HEADER
 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_x[9] CLIPPED,' ',sr.rme01 CLIPPED,
#           COLUMN 30,g_x[10] CLIPPED,
#           ' ',sr.rme02
#     PRINT g_x[11] CLIPPED,' ',sr.rme011
#     PRINT g_x[12] CLIPPED,' ',sr.rme03  CLIPPED,' (',sr.rme04,')'
#     PRINT g_head CLIPPED,pageno_total
 
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.rme01
#     SKIP TO TOP OF PAGE
#     LET l_cno =0  LET l_plt =0 LET l_qty=0
 
#  AFTER GROUP OF sr.rme01
#    #LET l_plt=l_plt-l_qty
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN g_c[32],cl_numfor(l_cno,32,0),
#           COLUMN g_c[34],cl_numfor(GROUP SUM(sr.rmq07),34,2),
#           COLUMN g_c[35],cl_numfor(l_plt,35,0)
 
#  AFTER GROUP OF sr.rmq03
#     IF NOT cl_null(sr.rmq03) THEN
#        LET l_plt=GROUP SUM(sr.rmq03)
#     END IF
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[31],sr.rmq02 USING '--&',
#           COLUMN g_c[32],cl_numfor(sr.rmq05,32,0),
#           COLUMN g_c[33],sr.rmq06,
#           COLUMN g_c[34],cl_numfor(sr.rmq07,34,2),
#           COLUMN g_c[35],cl_numfor(sr.rmq03,35,0),
#           COLUMN g_c[36],sr.rmq04
#     LET l_cno=l_cno+1
 
#  ON LAST ROW                                                                                                                  
#No.TQC-6C0213--begin                                                                                                               
#            NEED 4 LINE                                                                                                            
#         IF g_zz05 = 'Y'  THEN                                                                                                     
#            CALL cl_wcchp(g_wc,'rme11,rme01,rme02,rme03,rme04')                                                                    
#            RETURNING g_wc                                                                                                         
#            PRINT g_dash[1,g_len]                                                                                                  
#            CALL cl_prt_pos_wc(g_wc)                                                                                               
#         END IF                                                                                                                    
#           PRINT g_dash[1,g_len]                                                                                                   
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED 
#           LET l_last_sw = 'y'                                            
#                                                                         
#      PAGE TRAILER                                                      
#           IF l_last_sw = 'n' THEN                                     
#               PRINT g_dash[1,g_len]                                  
#               PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#           ELSE                                                      
#              SKIP 2 LINE                                           
#           END IF                                                  
#No.TQC-6C0213--end
 
#END REPORT
#No.FUN-860018---end
#No.FUN-890102
