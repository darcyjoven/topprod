# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asdi100.4gl
# Descriptions...: 料件標準成本資料維護作業
# Date & Author..: 98/06/24 By Eric
# Modify.........: No.FUN-4B0016 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.TQC-5A0061 05/10/20 By Sarah 查詢時單身如果有輸入條件查出來的筆數與顯示的筆數不合
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sta           RECORD LIKE sta_file.*,
    g_sta_t         RECORD LIKE sta_file.*,
    g_sta_o         RECORD LIKE sta_file.*,
    g_ima           RECORD LIKE ima_file.*,
    g_oba02         LIKE oba_file.oba02,
    g_ima06         LIKE ima_file.ima06,
    g_ima09         LIKE ima_file.ima09,
    g_ima02         LIKE ima_file.ima02,        #品名
    g_ima05         LIKE ima_file.ima05,        #版本
    g_ima08         LIKE ima_file.ima08,        #來源
    g_ima25         LIKE ima_file.ima25,        #單位
    g_stb           DYNAMIC ARRAY OF RECORD        #程式變數(Program Variables)
                    stb02       LIKE stb_file.stb02,
                    stb03       LIKE stb_file.stb03,
                    stb04       LIKE stb_file.stb04,
                    stb05       LIKE stb_file.stb05,
                    stb06       LIKE stb_file.stb06,
                    stb06a      LIKE stb_file.stb06a,
                    stb07       LIKE stb_file.stb07,
                    stb08       LIKE stb_file.stb08,
                    stb09       LIKE stb_file.stb09,
                    stb09a      LIKE stb_file.stb09a,
                    stb10       LIKE stb_file.stb10,
                    stbtot      LIKE type_file.num20_6        #No.FUN-690010 DECIMAL(20,6)
                    END RECORD,
    g_stb_t         RECORD
                    stb02       LIKE stb_file.stb02,
                    stb03       LIKE stb_file.stb03,
                    stb04       LIKE stb_file.stb04,
                    stb05       LIKE stb_file.stb05,
                    stb06       LIKE stb_file.stb06,
                    stb06a      LIKE stb_file.stb06a,
                    stb07       LIKE stb_file.stb07,
                    stb08       LIKE stb_file.stb08,
                    stb09       LIKE stb_file.stb09,
                    stb09a      LIKE stb_file.stb09a,
                    stb10       LIKE stb_file.stb10,
                    stbtot      LIKE type_file.num20_6        #No.FUN-690010DECIMAL(20,6)
                    END RECORD,
     g_wc,g_wc2      string,  #No.FUN-580092 HCN
     g_sql           string,  #No.FUN-580092 HCN
     g_sql_cnt       string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,         #No.FUN-690010SMALLINT,              #單身筆數
    l_ac            LIKE type_file.num5,         #No.FUN-690010SMALLINT,              #目前處理的ARRAY CNT
    l_cmd           LIKE type_file.chr1000       #No.FUN-690010CHAR(200) 
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-690010SMALLINT
 
#----------------------------------------------------------------------
#主程式開始
#-----------------------------------------------------------------------
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-690010INTEGER   
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-690010CHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-690010INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-690010INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-690010INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-690010 SMALLINT
MAIN
#  DEFINE       l_time    LIKE type_file.chr8            #No.FUN-6A0089
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-690010SMALLINT
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ASD")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i100_w AT p_row,p_col
         WITH FORM "asd/42f/asdi100" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_forupd_sql = "SELECT * FROM sta_file WHERE sta01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql
 
    CALL i100_menu()
 
    CLOSE WINDOW i100_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
         RETURNING g_time    #No.FUN-6A0089
END MAIN
 
FUNCTION i100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  define  g_cnt         LIKE type_file.num5          #No.FUN-690010decimal(5,0)
 
    CLEAR FORM                             #清除畫面
    CALL g_stb.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_sta.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON sta01,sta07,sta02,sta03,sta04,sta05,sta06,sta06a,
                               sta11
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sta01)
#                CALL q_ima(0,0,g_sta.sta01) RETURNING g_sta.sta01
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.state = 'c'
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO sta01
                 NEXT FIELD sta01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CONSTRUCT g_wc2 ON stb02,stb03,stb10,stb04,stb05,  # 螢幕上取單身條件
                       stb06,stb07,stb08,stb09,stb06a,stb09a
                  FROM s_stb[1].stb02, s_stb[1].stb03, s_stb[1].stb10,
                       s_stb[1].stb04, s_stb[1].stb05, s_stb[1].stb06,
                       s_stb[1].stb07, s_stb[1].stb08, s_stb[1].stb09,
                       s_stb[1].stb06a, s_stb[1].stb09a
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
 
   #start TQC-5A0061
   #LET g_sql_cnt = "SELECT count(*) FROM sta_file",
   #                " WHERE ", g_wc CLIPPED
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql_cnt = "SELECT count(*) FROM sta_file",
                       " WHERE ", g_wc  CLIPPED
    ELSE
       LET g_sql_cnt = "SELECT count(UNIQUE sta01) ",
                       "  FROM sta_file, stb_file",
                       " WHERE sta01 = stb01",
                       "   AND ", g_wc  CLIPPED,
                       "   AND ", g_wc2 CLIPPED
    END IF
   #end TQC-5A0061
    PREPARE i100_precount FROM g_sql_cnt
    DECLARE i100_count CURSOR FOR i100_precount
    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT sta01 FROM sta_file",
                   " WHERE ", g_wc CLIPPED," ORDER BY sta01"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE sta01",
                   "  FROM sta_file, stb_file",
                   " WHERE sta01 = stb01",
                   "   AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY sta01"
    END IF
 
    PREPARE i100_prepare FROM g_sql
    IF STATUS THEN CALL cl_err('i100_pre',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
    END IF
    DECLARE i100_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
 
END FUNCTION
 
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i100_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
           #NEXT OPTION "next"
         WHEN "delete" 
            IF cl_chk_act_auth() THEN 
               CALL i100_r()
            END IF
           #NEXT OPTION "next"
         WHEN "modify" 
            IF cl_chk_act_auth() THEN 
               CALL i100_u()
            END IF
           #NEXT OPTION "next"
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
#FUN-4B0016
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_stb),'','')
            END IF
##
         #No.FUN-6A0150-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_sta.sta01 IS NOT NULL THEN
                 LET g_doc.column1 = "sta01"
                 LET g_doc.value1 = g_sta.sta01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0150-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_stb.clear()
    INITIALIZE g_sta.* TO NULL
    LET g_sta.sta02='1'
    LET g_sta.sta03=0
    LET g_sta.sta04=0
    LET g_sta.sta05=0
    LET g_sta.sta06=0
    LET g_sta.sta06a=0
    LET g_sta.sta08=0
    LET g_sta.sta09=0
    LET g_sta.sta10=0
    LET g_sta.sta11='N'
    LET g_ima.ima131=NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CLEAR FORM
        BEGIN WORK
        CALL i100_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
        IF cl_null(g_sta.sta01) THEN CONTINUE WHILE END IF
        INSERT INTO sta_file VALUES (g_sta.*)
        IF STATUS THEN 
#        CALL cl_err(g_sta.sta01,STATUS,1)       #No.FUN-660120
         CALL cl_err3("ins","sta_file",g_sta.sta01,"",STATUS,"","",1)       #NO.FUN-660120
        CONTINUE WHILE END IF
       #UPDATE ima_file SET ima131=g_ima.ima131 WHERE ima01=g_sta.sta01                     #FUN-C30315 mark 
        UPDATE ima_file SET ima131=g_ima.ima131,imadate = g_today WHERE ima01=g_sta.sta01   #FUN-C30315 add
        IF STATUS THEN 
#        CALL cl_err(g_sta.sta01,STATUS,1)          #NO.FUN-660120
         CALL cl_err3("upd","ima_file",g_sta.sta01,"",STATUS,"","",1)       #NO.FUN-660120
        CONTINUE WHILE END IF
        COMMIT WORK
        SELECT sta01 INTO g_sta.sta01 FROM sta_file WHERE sta01 = g_sta.sta01
        LET g_sta_t.* = g_sta.*
        CALL g_stb.clear()
        LET g_rec_b = 0
#       CALL i100_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i100_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sta.sta01) THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sta_t.* = g_sta.*
    LET g_sta_o.* = g_sta.*
    BEGIN WORK
 
    OPEN i100_cl USING g_sta.sta01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_sta.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i100_cl
        RETURN
    END IF
    CALL i100_show()
    WHILE TRUE
        CALL i100_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_sta.*=g_sta_t.*
           CALL i100_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        UPDATE sta_file SET * = g_sta.* WHERE sta01 = g_sta.sta01
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0)   #No.FUN-660120
           CALL cl_err3("upd","sta_file",g_sta_t.sta01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
           CONTINUE WHILE 
        END IF
       #UPDATE ima_file SET ima131=g_ima.ima131 WHERE ima01=g_sta.sta01                    #FUN-C30315 mark
        UPDATE ima_file SET ima131=g_ima.ima131,imadate = g_today WHERE ima01=g_sta.sta01  #FUN-C30315 add
        EXIT WHILE
    END WHILE
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
#---------------------------------------------------------------------------
#處理INPUT
#---------------------------------------------------------------------------
FUNCTION i100_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,           #No.FUN-690010CHAR(1),               #判斷必要欄位是否有輸入
    l_count         LIKE type_file.num5,         #No.FUN-690010SMALLINT,
    l_n1            LIKE type_file.num5,         #No.FUN-690010SMALLINT,
    p_cmd           LIKE type_file.chr1          #No.FUN-690010CHAR(1)               #a:輸入 u:更改
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_sta.sta01,g_ima.ima131,g_sta.sta07,g_sta.sta02,g_sta.sta03,
                  g_sta.sta08,g_sta.sta09,g_sta.sta10,g_sta.sta11,
                  g_sta.sta04,g_sta.sta05,g_sta.sta06,g_sta.sta06a
                  WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD sta07
          IF g_ima08 = 'M' AND cl_null(g_sta.sta07) THEN
#No.MOD-580325-begin                                                           
             CALL cl_err('','asd-003',0)                                        
#            ERROR '主制程欄位不可空白!'                                        
#No.MOD-580325-end     
          END IF
 
        AFTER FIELD sta01
          IF NOT cl_null(g_sta.sta01) THEN
             #FUN-AA0059 ------------------------addd start---------------
              IF NOT s_chk_item_no(g_sta.sta01,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD sta01
              END IF 
             #FUN-AA0059 -----------------------add end----------------------
              SELECT ima02,ima05,ima08,ima25,ima06,ima09,ima131
                INTO g_ima02,g_ima05,g_ima08,g_ima25,g_ima06,g_ima09,g_ima.ima131
                FROM ima_file WHERE ima01 = g_sta.sta01
              IF STATUS THEN
#                CALL cl_err('sel ima',STATUS,1)    #No.FUN-660120
                 CALL cl_err3("sel","ima_file",g_sta.sta01,"",STATUS,"","sel ima",1)  #No.FUN-660120
                  NEXT FIELD sta01 
              END IF
              IF g_ima08 NOT MATCHES '[MPXS]' THEN
                 CALL cl_err('source code not matches [mps]',STATUS,1)
                 NEXT FIELD sta01
              END IF
              SELECT oba02 INTO g_oba02 FROM oba_file WHERE oba01=g_ima.ima131
              DISPLAY g_ima02,g_ima05,g_ima08,g_ima25,g_ima06,g_ima09,g_ima.ima131
                   TO ima02,ima05,ima08,ima25,ima06,ima09,ima131
              DISPLAY g_oba02 TO oba02
          END IF
          IF cl_null(g_sta_t.sta01) OR g_sta.sta01 != g_sta_t.sta01 THEN
             SELECT COUNT(*) INTO g_cnt FROM sta_file WHERE sta01 = g_sta.sta01
             IF g_cnt > 0 THEN   #資料重複
                CALL cl_err('select sta',-239,0)
                LET g_sta.sta01 = g_sta_t.sta01
                DISPLAY BY NAME g_sta.sta01 
                NEXT FIELD sta01
             END IF
          END IF
 
        AFTER FIELD ima131
          IF NOT cl_null(g_ima.ima131) THEN
             SELECT oba02 INTO g_oba02 FROM oba_file WHERE oba01=g_ima.ima131
             IF STATUS <> 0 THEN
#No.MOD-580325-begin                                                           
#               CALL cl_err('','aom-005',0)                                        #No.FUN-660120
                CALL cl_err3("sel","oba_file","g_ima.ima131","","aom-005","","",1)  #No.FUN-660120
#               ERROR '無此產品分類!'                                           
#No.MOD-580325-end       
                SELECT ima131 INTO g_ima.ima131 FROM ima_file
                 WHERE ima01=g_sta.sta01
                NEXT FIELD ima131
             END IF
             DISPLAY g_oba02 TO oba02
          END IF
 
        AFTER FIELD sta02
          IF NOT cl_null(g_sta.sta02) THEN 
              IF g_sta.sta02 NOT MATCHES '[012]' THEN
                  NEXT FIELD sta02
              END IF
          END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sta01)
#                CALL q_ima(0,0,g_sta.sta01) RETURNING g_sta.sta01
#                CALL FGL_DIALOG_SETBUFFER( g_sta.sta01 )
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_sta.sta01
#                 CALL cl_create_qry() RETURNING g_sta.sta01
                  CALL q_sel_ima(FALSE, "q_ima","",g_sta.sta01,"","","","","",'' ) 
                  RETURNING  g_sta.sta01

#FUN-AA0059---------mod------------end-----------------
#                 CALL FGL_DIALOG_SETBUFFER( g_sta.sta01 )
                 DISPLAY BY NAME g_sta.sta01
                 NEXT FIELD sta01
               WHEN INFIELD(ima131)
#                CALL q_oba(0,0,g_ima.ima131) RETURNING g_ima.ima131
#                CALL FGL_DIALOG_SETBUFFER( g_ima.ima131 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oba"
                 LET g_qryparam.default1 = g_ima.ima131
                 CALL cl_create_qry() RETURNING g_ima.ima131
#                 CALL FGL_DIALOG_SETBUFFER( g_ima.ima131 )
                 DISPLAY BY NAME g_ima.ima131
                 NEXT FIELD ima131
            END CASE
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(sta01) THEN
       #         LET g_sta.* = g_sta_o.*
       #         DISPLAY BY NAME g_sta.* 
       #         NEXT FIELD sta01
       #     END IF
       #MOD-650015 --end
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #No.FUN-690010SMALLINT,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,         #No.FUN-690010SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,         #No.FUN-690010CHAR(1),               #單身鎖住否
    p_cmd           LIKE type_file.chr1,         #No.FUN-690010CHAR(1),               #處理狀態
    l_allow_insert  LIKE type_file.num5,         #No.FUN-690010SMALLINT,              #可新增否
    l_allow_delete  LIKE type_file.num5          #No.FUN-690010SMALLINT               #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = 
      " SELECT stb02,stb03,stb04,stb05,stb06,stb06a,stb07,stb08,stb09,stb09a,stb10,0 ",
      "   FROM stb_file  ",
      "  WHERE stb01 = ? ",
      "    AND stb02 = ? ",
      "    AND stb03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031  
        INPUT ARRAY g_stb
              WITHOUT DEFAULTS FROM s_stb.*  
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i100_cl USING g_sta.sta01
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i100_cl INTO g_sta.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE i100_cl
                RETURN
            END IF
 
           #IF NOT cl_null(g_stb_t.stb02) THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_stb_t.* = g_stb[l_ac].*  #BACKUP
 
                OPEN i100_bcl USING g_sta.sta01,g_stb_t.stb02,g_stb_t.stb03
                IF STATUS THEN
                    CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i100_bcl INTO g_stb[l_ac].*
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_stb_t.stb02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    END IF
                    CALL i100_tot('d',l_ac)
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
#              CALL g_stb.deleteElement(l_ac)   #取消 Array Element
#              IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
#                 LET g_action_choice = "detail"
#                 LET l_ac = l_ac_t
#              END IF
#              EXIT INPUT
            END IF
            INSERT INTO stb_file(stb01,stb02,stb03,stb04,stb05,
                                 stb06,stb07,stb08,stb09,stb06a,
                                 stb09a,stb10)
                          VALUES(g_sta.sta01,      g_stb[l_ac].stb02,
                                 g_stb[l_ac].stb03,g_stb[l_ac].stb04,
                                 g_stb[l_ac].stb05,g_stb[l_ac].stb06,
                                 g_stb[l_ac].stb07,g_stb[l_ac].stb08,
                                 g_stb[l_ac].stb09,g_stb[l_ac].stb06a,
                                 g_stb[l_ac].stb09a,g_stb[l_ac].stb10)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_stb[l_ac].stb02,SQLCA.sqlcode,0)   #No.FUN-660120
               CALL cl_err3("ins","stb_file",g_sta.sta01,g_stb[l_ac].stb02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1 
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_stb[l_ac].* TO NULL      #900423
            LET g_stb_t.* = g_stb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD stb02    #No.+288 add
 
        BEFORE FIELD stb03
           IF NOT cl_null(g_stb[l_ac].stb02) THEN
              IF g_stb[l_ac].stb02 < 0 THEN
                  NEXT FIELD stb02
              END IF
              IF g_stb[l_ac].stb02 < 1998 THEN
                  LET g_stb[l_ac].stb02 = YEAR(g_today)
              END IF
           END IF
 
        AFTER FIELD stb03
           IF NOT cl_null(g_stb[l_ac].stb03) THEN
              IF g_stb[l_ac].stb03 < 1 OR g_stb[l_ac].stb03 > 12 THEN
                  NEXT FIELD stb03
              END IF
              IF g_stb[l_ac].stb03 != g_stb_t.stb03 OR
                 cl_null(g_stb_t.stb03) THEN
                 SELECT COUNT(*) INTO l_n FROM stb_file
                  WHERE stb01 = g_sta.sta01
                    AND stb02 = g_stb[l_ac].stb02
                    AND stb03 = g_stb[l_ac].stb03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_stb[l_ac].stb03 = g_stb_t.stb03
                    NEXT FIELD stb03
                 END IF
              END IF
           END IF
 
        AFTER FIELD stb07
            IF NOT cl_null(g_stb[l_ac].stb07) THEN
               CALL i100_tot('d',l_ac)
            END IF
 
        AFTER FIELD stb08
            IF NOT cl_null(g_stb[l_ac].stb08) THEN
               CALL i100_tot('d',l_ac)
            END IF
 
        AFTER FIELD stb09
            IF NOT cl_null(g_stb[l_ac].stb09) THEN
               CALL i100_tot('d',l_ac)
            END IF
 
        AFTER FIELD stb09a
            IF NOT cl_null(g_stb[l_ac].stb09a) THEN
               CALL i100_tot('d',l_ac)
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_stb_t.stb02) AND
               NOT cl_null(g_stb_t.stb03) THEN
                IF NOT cl_delete() THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM stb_file WHERE stb01 = g_sta.sta01
                                       AND stb02 = g_stb_t.stb02
                                       AND stb03 = g_stb_t.stb03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_stb_t.stb02,SQLCA.sqlcode,0)   #No.FUN-660120
                    CALL cl_err3("del","stb_file",g_sta.sta01,g_stb_t.stb02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                COMMIT WORK
            END IF
                
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_stb[l_ac].* = g_stb_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_stb[l_ac].stb02,-263,1)
                LET g_stb[l_ac].* = g_stb_t.*
            ELSE
                UPDATE stb_file SET
                       stb01=g_sta.sta01,
                       stb02=g_stb[l_ac].stb02,
                       stb03=g_stb[l_ac].stb03,
                       stb04=g_stb[l_ac].stb04,
                       stb05=g_stb[l_ac].stb05,
                       stb06=g_stb[l_ac].stb06,
                       stb07=g_stb[l_ac].stb07,
                       stb08=g_stb[l_ac].stb08,
                       stb09=g_stb[l_ac].stb09,
                       stb10=g_stb[l_ac].stb10,
                       stb06a=g_stb[l_ac].stb06a,
                       stb09a=g_stb[l_ac].stb09a
                 WHERE stb01 = g_sta.sta01
                   AND stb02 = g_stb_t.stb02
                   AND stb03 = g_stb_t.stb03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_stb[l_ac].stb02,SQLCA.sqlcode,0)   #No.FUN-660120
                   CALL cl_err3("upd","stb_file",g_sta.sta01,g_stb_t.stb02,SQLCA.sqlcode,"","",1)  #No.FUN-660120
                   LET g_stb[l_ac].* = g_stb_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_stb[l_ac].* = g_stb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_stb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end-- 
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i100_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i100_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(stb02) AND l_ac > 1 THEN
                LET g_stb[l_ac].* = g_stb[l_ac-1].*
                NEXT FIELD stb02
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
 
    CLOSE i100_bcl
    COMMIT WORK
    CALL i100_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i100_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM sta_file WHERE sta01 = g_sta.sta01
         INITIALIZE g_sta.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#----------------------------------------------------------------------------
#Query 查詢
#----------------------------------------------------------------------------
FUNCTION i100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sta.* TO NULL               #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i100_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_sta.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_sta.* TO NULL
    ELSE
       OPEN i100_count
       FETCH i100_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
#---------------------------------------------------------------------------
#處理資料的讀取
#---------------------------------------------------------------------------
FUNCTION i100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #No.FUN-690010CHAR(1),               #處理方式
    l_abso          LIKE type_file.num10         #No.FUN-690010INTEGER                #絕對的筆數
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     i100_cs INTO g_sta.sta01
    WHEN 'P' FETCH PREVIOUS i100_cs INTO g_sta.sta01
    WHEN 'F' FETCH FIRST    i100_cs INTO g_sta.sta01
    WHEN 'L' FETCH LAST     i100_cs INTO g_sta.sta01
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
            FETCH ABSOLUTE g_jump i100_cs INTO g_sta.sta01
            LET mi_no_ask = FALSE
  END CASE
 
  IF SQLCA.sqlcode THEN
     INITIALIZE g_sta.* TO NULL  #TQC-6B0105
     CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0) RETURN
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
  SELECT * INTO g_sta.* FROM sta_file WHERE sta01 = g_sta.sta01
  IF SQLCA.sqlcode THEN
#    CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0)   #No.FUN-660120
     CALL cl_err3("sel","sta_file",g_sta.sta01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
     INITIALIZE g_sta.* TO NULL
     RETURN
  END IF
    SELECT ima02,ima05,ima08,ima25,ima06,ima09,ima131
      INTO g_ima02,g_ima05,g_ima08,g_ima25,g_ima06,g_ima09,g_ima.ima131
      FROM ima_file WHERE ima01 = g_sta.sta01
#No.FUN-6A0150--------str------
#    IF STATUS THEN 
##    CALL cl_err('sel ima',STATUS,0)           #No.FUN-660120
#     CALL cl_err3("sel","ima_file",g_sta.sta01,"",STATUS,"","sel ima",1)  #No.FUN-660120
#   END IF
#No.FUN-6A0150--------end------
    SELECT oba02 INTO g_oba02 FROM oba_file WHERE oba01=g_ima.ima131
    IF STATUS <> 0 THEN let g_oba02=' ' END IF
  CALL i100_show()
 
END FUNCTION
#---------------------------------------------------------------------------
#將資料顯示在畫面上
#---------------------------------------------------------------------------
FUNCTION i100_show()
    LET g_sta_t.* = g_sta.*                #保存單頭舊值
    DISPLAY BY NAME g_sta.sta01,g_sta.sta02,g_sta.sta03,g_sta.sta07,
                    g_sta.sta04,g_sta.sta05,g_sta.sta06,g_sta.sta06a,
                    g_sta.sta08,g_sta.sta09,g_sta.sta10,g_sta.sta11
    DISPLAY g_ima02,g_ima05,g_ima08,g_ima25,g_ima.ima131,g_ima06,g_ima09,g_oba02
         TO ima02,ima05,ima08,ima25,ima131,ima06,ima09,oba02
    CALL i100_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-690010CHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_sta.sta01) THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i100_cl USING g_sta.sta01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_sta.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i100_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sta01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sta.sta01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM sta_file WHERE sta01 = g_sta.sta01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_sta.sta01,SQLCA.sqlcode,0)   #No.FUN-660120
          CALL cl_err3("del","sta_file",g_sta.sta01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660120
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM stb_file WHERE stb01 = g_sta.sta01
       CLEAR FORM
       CALL g_stb.clear()
       INITIALIZE g_sta.* LIKE sta_file.*             #DEFAULT 設定
       OPEN i100_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i100_cs
          CLOSE i100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i100_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i100_cs
          CLOSE i100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i100_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i100_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i100_fetch('/')
       END IF
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-690010CHAR(300)
 
    CONSTRUCT l_wc2 ON stb02,stb03,stb10,stb04,stb05,  # 螢幕上取單身條件
                       stb06,stb07,stb08,stb09,stb06a,stb09a
                  FROM s_stb[1].stb02, s_stb[1].stb03, s_stb[1].stb10,
                       s_stb[1].stb04, s_stb[1].stb05, s_stb[1].stb06,
                       s_stb[1].stb07, s_stb[1].stb08, s_stb[1].stb09,
                       s_stb[1].stb06a, s_stb[1].stb09a
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
    CALL i100_b_fill(l_wc2)
END FUNCTION
#-------------------------------------------------------------------------
# BODY FILL UP
#-------------------------------------------------------------------------
FUNCTION i100_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-690010CHAR(300)
 
    LET g_sql =
        "SELECT stb02,stb03,stb04,stb05,stb06,stb06a,stb07,stb08,stb09,",
        "       stb09a,stb10,0 ",
        "  FROM stb_file",
        " WHERE stb01 ='",g_sta.sta01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY stb02 DESC,stb03 DESC"
 
    PREPARE i100_pb FROM g_sql
    IF STATUS THEN CALL cl_err('i100_pb',STATUS,1) RETURN END IF
    DECLARE stb_curs                       #SCROLL CURSOR
        CURSOR FOR i100_pb
 
    CALL g_stb.clear()
    LET g_cnt = 1
    FOREACH stb_curs INTO g_stb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        CALL i100_tot('a',g_cnt)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_stb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-690010CHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_stb TO s_stb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
       #MOD-470335
      ON ACTION help 
         CALL cl_show_help()
      #--
 
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
 
 
#FUN-4B0016
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
      ON ACTION related_document                #No.FUN-6A0150  相關文件
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
 
 
FUNCTION i100_tot(p_cmd,l_i)
   DEFINE l_i   LIKE type_file.num5,          #No.FUN-690010SMALLINT,
          p_cmd LIKE type_file.chr1           #No.FUN-690010CHAR(1)
 
   IF cl_null(g_stb[l_i].stb07) THEN LET g_stb[l_i].stb07 = 0 END IF
   IF cl_null(g_stb[l_i].stb08) THEN LET g_stb[l_i].stb08 = 0 END IF
   IF cl_null(g_stb[l_i].stb09) THEN LET g_stb[l_i].stb09 = 0 END IF
   IF cl_null(g_stb[l_i].stb09a) THEN LET g_stb[l_i].stb09a = 0 END IF
 
   LET g_stb[l_i].stbtot=g_stb[l_i].stb07+g_stb[l_i].stb08+g_stb[l_i].stb09+
                         g_stb[l_i].stb09a
 
END FUNCTION
 
#單頭
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-690010CHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("sta01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-690010CHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("sta01",FALSE)
       END IF
   END IF
 
END FUNCTION
