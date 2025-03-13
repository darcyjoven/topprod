# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt120.4gl
# Descriptions...: RMA序號明細維護作業
# Date & Author..: 98/02/10 By Star
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790031 07/09/07 By claire  語法調整 
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/24 by JIACHENCHAO 更改关于字段ima26的相关语句
# Modify.........: No.FUN-BB0084 11/12/23 By lixh1 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
    g_rma   RECORD LIKE rma_file.*,
    g_rmb   RECORD
            rmb02     LIKE rmb_file.rmb02,
            rmb03     LIKE rmb_file.rmb03,
            rmb12     LIKE rmb_file.rmb12,
            rmb04     LIKE rmb_file.rmb04,
            rmb05     LIKE rmb_file.rmb05,
            rmb06     LIKE rmb_file.rmb06
            END RECORD,
    g_rmb_t RECORD
            rmb02     LIKE rmb_file.rmb02,
            rmb03     LIKE rmb_file.rmb03,
            rmb12     LIKE rmb_file.rmb12,
            rmb04     LIKE rmb_file.rmb04,
            rmb05     LIKE rmb_file.rmb05,
            rmb06     LIKE rmb_file.rmb06
            END RECORD,
    g_rmb_o RECORD
            rmb02     LIKE rmb_file.rmb02,
            rmb03     LIKE rmb_file.rmb03,
            rmb12     LIKE rmb_file.rmb12,
            rmb04     LIKE rmb_file.rmb04,
            rmb05     LIKE rmb_file.rmb05,
            rmb06     LIKE rmb_file.rmb06
            END RECORD,
    b_rmc   RECORD LIKE rmc_file.*,
    g_rmc           DYNAMIC ARRAY OF RECORD    #程式變數(Profram Variables)
                    rmc02     LIKE rmc_file.rmc02,
                    rmc07     LIKE rmc_file.rmc07,
                    rmc08     LIKE rmc_file.rmc08,
                    rmc14     LIKE rmc_file.rmc14, #修護碼
                    rmc16     LIKE rmc_file.rmc16,
                    rmc10     LIKE rmc_file.rmc10,
                    rmc11     LIKE rmc_file.rmc11,
                    rmc12     LIKE rmc_file.rmc12,
                    rmc13     LIKE rmc_file.rmc13,
                    rmc09     LIKE rmc_file.rmc09,
                    rmc19     LIKE rmc_file.rmc19,
                    rmc17     LIKE rmc_file.rmc17,
                    rmc18     LIKE rmc_file.rmc18,
                    rmc23     LIKE rmc_file.rmc23,
                    rmc24     LIKE rmc_file.rmc24,
                    rmc21     LIKE rmc_file.rmc21, #除帳碼
                    rmc22     LIKE rmc_file.rmc22
                    END RECORD,
    g_rmc_t         RECORD
                    rmc02     LIKE rmc_file.rmc02,
                    rmc07     LIKE rmc_file.rmc07,
                    rmc08     LIKE rmc_file.rmc08,
                    rmc14     LIKE rmc_file.rmc14, #修護碼
                    rmc16     LIKE rmc_file.rmc16,
                    rmc10     LIKE rmc_file.rmc10,
                    rmc11     LIKE rmc_file.rmc11,
                    rmc12     LIKE rmc_file.rmc12,
                    rmc13     LIKE rmc_file.rmc13,
                    rmc09     LIKE rmc_file.rmc09,
                    rmc19     LIKE rmc_file.rmc19,
                    rmc17     LIKE rmc_file.rmc17,
                    rmc18     LIKE rmc_file.rmc18,
                    rmc23     LIKE rmc_file.rmc23,
                    rmc24     LIKE rmc_file.rmc24,
                    rmc21     LIKE rmc_file.rmc21, #除帳碼
                    rmc22     LIKE rmc_file.rmc22
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
#   g_t1                VARCHAR(3),
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_buf,g_buf1    LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    p_row,p_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cmd               LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(70)
 
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0085
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
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t120_w AT p_row,p_col WITH FORM "arm/42f/armt120"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_forupd_sql =
      "SELECT rmb02,rmb03,rmb12,rmb04,rmb05,rmb06 FROM rmb_file ",
      " WHERE rmb01 = ? AND rmb02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t120_cl CURSOR FROM g_forupd_sql
    CALL t120_menu()
    CLOSE WINDOW t120_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t120_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_rmc.clear()
    WHILE TRUE
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        rma01,rmb02,rma03,rma04,rma12,rma18,rma13,rma14,rmaconf,rma09,
        rmb03,rmb05,rmb04,rmb06,rmb12,
        rmauser,rmagrup,rmamodu,rmadate,rmavoid
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
      EXIT WHILE
    END WHILE
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rmauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
    #End:FUN-980030
 
    CONSTRUCT g_wc2 ON rmc02,rmc07,rmc08,rmc14,rmc16,rmc10,
                       rmc11,rmc12,rmc13,rmc21,rmc22,rmc09,
                       rmc19,rmc17,rmc18,rmc23,rmc24
            FROM       s_rmc[1].rmc02,s_rmc[1].rmc07,s_rmc[1].rmc08,
                       s_rmc[1].rmc14,s_rmc[1].rmc16,s_rmc[1].rmc10,
                       s_rmc[1].rmc11,s_rmc[1].rmc12,s_rmc[1].rmc13,
                       s_rmc[1].rmc21,s_rmc[1].rmc22,s_rmc[1].rmc09,
                       s_rmc[1].rmc19,s_rmc[1].rmc17,s_rmc[1].rmc18,
                       s_rmc[1].rmc23,s_rmc[1].rmc24
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
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT rma01,rmb02 FROM rma_file,rmb_file",
                   " WHERE rma01 = rmb01 ",
                   "   AND ", g_wc CLIPPED,
                   " ORDER BY rma01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rma01,rmb02 ",
                   "  FROM rma_file,rmb_file, rmc_file",
                   " WHERE rma01 = rmb01",
                   "   AND rmb01 = rmc01",
                   "   AND rmb02 = rmc02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rma01,rmb02"
    END IF
 
    PREPARE t120_prepare FROM g_sql
    DECLARE t120_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t120_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql = "SELECT COUNT(*) FROM rma_file,rmb_file",
                   " WHERE rma01 = rmb01 ", "   AND ", g_wc CLIPPED
    ELSE
       LET g_sql = "SELECT COUNT(DISTINCT rma01,rmb02) ",
                   "  FROM rma_file,rmb_file, rmc_file",
                   " WHERE rma01 = rmb01",
                   "   AND rmb01 = rmc01",
                   "   AND rmb02 = rmc02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
    PREPARE t120_precount FROM g_sql
    DECLARE t120_count CURSOR FOR t120_precount
END FUNCTION
 
FUNCTION t120_menu()
 
   WHILE TRUE
      CALL t120_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t120_q()
            END IF
      #  WHEN "delete"
      #     IF cl_chk_act_auth() THEN
      #        CALL t120_r()
      #     END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t120_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t120_b()
            ELSE
               LET g_action_choice = NULL
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
               CALL t120_y()
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t120_z()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmc),'','')
            END IF
 
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_rma.rma01 IS NOT NULL THEN
                LET g_doc.column1 = "rma01"
                LET g_doc.column2 = "rmb02"
                LET g_doc.value1 = g_rma.rma01
                LET g_doc.value2 = g_rmb.rmb02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0018-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t120_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT rmb01,rmb02,rmb03,rmb12,rmb04,rmb05,rmb06 INTO g_rma.rma01,g_rmb.*
      FROM rmb_file WHERE rmb01 = g_rma.rma01 AND rmb02 = g_rmb.rmb02
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
   #IF g_rma.rma01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF  #NO.FUN-6A0018
    IF g_rma.rma01 IS NULL  OR g_rmb.rmb02 IS NULL THEN   #NO.FUN-6A0018  #MOD-790031 modify
       CALL cl_err('',-400,0)  
       RETURN 
    END IF
    IF g_rma.rmaconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rmb_o.* = g_rmb.*
    BEGIN WORK
 
    OPEN t120_cl USING g_rma.rma01,g_rmb.rmb02
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_rmb.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t120_show()
    WHILE TRUE
        LET g_rma.rmamodu=g_user
        LET g_rma.rmadate=g_today
        CALL t120_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rmb.*=g_rmb_t.*
            CALL t120_show()
            CALL cl_err('','9001',0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        UPDATE rmb_file SET rmb03 = g_rmb.rmb03,
                            rmb12 = g_rmb.rmb12,
                            rmb05 = g_rmb.rmb05,
                            rmb06 = g_rmb.rmb06
         WHERE rmb01 = g_rma.rma01 AND rmb02 = g_rmb.rmb02
        LET g_buf = g_rma.rma01,'-',g_rmb.rmb02 USING '####&'
        IF STATUS THEN 
  #      CALL cl_err(g_buf,STATUS,0)  # FUN-660111
        CALL cl_err3("upd","rmb_file",g_rma.rma01,g_rmb_t.rmb02,STATUS,"","",1) #FUN-660111 
        CONTINUE WHILE END IF
        EXIT WHILE
    END WHILE
    CLOSE t120_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
 
END FUNCTION
 
#處理INPUT
FUNCTION t120_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
  DEFINE l_n1            LIKE type_file.num5    #No.FUN-690010 SMALLINT
  DEFINE l_occ           RECORD LIKE occ_file.*
  DEFINE l_oap           RECORD LIKE oap_file.*
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_rmb.rmb03,g_rmb.rmb05,g_rmb.rmb06,g_rmb.rmb04,g_rmb.rmb12,
        g_rma.rmaconf,g_rma.rmauser,g_rma.rmagrup,g_rma.rmamodu,
        g_rma.rmadate,g_rma.rmavoid WITHOUT DEFAULTS
 
        AFTER FIELD rmb12
        #FUN-BB0084 -------------Begin-----------------
           IF NOT cl_null(g_rmb.rmb12) AND NOT cl_null(g_rmb.rmb04) THEN
              LET g_rmb.rmb12 = s_digqty(g_rmb.rmb12,g_rmb.rmb04)  
              DISPLAY BY NAME g_rmb.rmb12
           END IF 
        #FUN-BB0084 -------------End-------------------
           IF NOT cl_null(g_rmb.rmb12) THEN
               SELECT COUNT(*) INTO l_n1  FROM rmc_file
                WHERE rmc01 = g_rma.rma01 AND rmc02 = g_rmb.rmb02
               IF g_rmb.rmb12 < l_n1  THEN
                  CALL cl_err(g_rmb.rmb12,'arm-500',0)
                  LET g_rmb.rmb12 = g_rmb_t.rmb12
                  NEXT FIELD rmb12
               END IF
           END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(rmb12) THEN
       #         LET g_rma.* = g_rma_t.*
       #         CALL t120_show()
       #         NEXT FIELD rmb12
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
 
FUNCTION t120_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rma.* TO NULL              #NO.FUN-6A0018 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t120_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_rma.* TO NULL 
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t120_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rma.* TO NULL
    ELSE
        OPEN t120_count
        FETCH t120_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t120_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
#   MESSAGE ""
END FUNCTION
 
FUNCTION t120_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t120_cs INTO g_rma.rma01,g_rmb.rmb02
        WHEN 'P' FETCH PREVIOUS t120_cs INTO g_rma.rma01,g_rmb.rmb02
        WHEN 'F' FETCH FIRST    t120_cs INTO g_rma.rma01,g_rmb.rmb02
        WHEN 'L' FETCH LAST     t120_cs INTO g_rma.rma01,g_rmb.rmb02
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
            FETCH ABSOLUTE g_jump t120_cs INTO g_rma.rma01,g_rmb.rmb02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)
        INITIALIZE g_rmb.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
    SELECT rmb02,rmb03,rmb12,rmb04,rmb05,rmb06 INTO g_rmb.* FROM rmb_file
     WHERE rmb01 = g_rma.rma01 AND rmb02 = g_rmb.rmb02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)   # FUN-660111 
       CALL cl_err3("sel","rmb_file",g_rma.rma01,g_rmb.rmb02,SQLCA.sqlcode,"","",1) #FUN-660111
       INITIALIZE g_rma.* TO NULL
       INITIALIZE g_rmb.* TO NULL
       RETURN
    ELSE
        LET g_data_owner = g_rma.rmauser #FUN-4C0055
        LET g_data_group = g_rma.rmagrup #FUN-4C0055
        LET g_data_plant = g_rma.rmaplant #FUN-980030
    END IF
 
    CALL t120_show()
END FUNCTION
 
FUNCTION t120_show()
    DEFINE l_buf LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(30)
 
    LET g_rmb_t.* = g_rmb.*                #保存單頭舊值
 
    DISPLAY BY NAME
 
 
        g_rma.rma01,g_rma.rma03,g_rma.rma13,g_rma.rma14,g_rma.rma09,
        g_rma.rma12,g_rma.rma18,g_rma.rma04,
        g_rma.rmaconf,g_rma.rmauser,g_rma.rmagrup,g_rma.rmamodu,g_rma.rmadate,
        g_rma.rmavoid
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
    SELECT gen02 INTO l_buf FROM gen_file WHERE gen01 = g_rma.rma13
    DISPLAY l_buf TO FORMONLY.gen02
    CALL cl_getmsg('arm-501',0) RETURNING g_msg
    DISPLAY g_msg TO FORMONLY.rma09_desc
    DISPLAY BY NAME
        g_rmb.rmb02,g_rmb.rmb03,g_rmb.rmb05,g_rmb.rmb12,g_rmb.rmb04,
        g_rmb.rmb06
    CALL t120_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t120_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_rma.* FROM rma_file WHERE rmb01 = g_rma.rma01 AND rmb02 = g_rmb.rmb02
    IF g_rma.rma01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_rma.rmaconf = 'Y' THEN CALL cl_err('','arm-101',0) RETURN END IF
    BEGIN WORK
 
    OPEN t120_cl USING g_rma.rma01,g_rmb.rmb02
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_rma.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t120_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rma01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "rmb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rma.rma01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_rmb.rmb02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete rma,rmc,oao,oap!"
       DELETE FROM rma_file WHERE rma01 = g_rma.rma01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
 #         CALL cl_err('No rma deleted','',0)  # FUN-660111 
          CALL cl_err3("del","rma_file",g_rma.rma01,"","","","No rma deleted",1) #FUN-660111
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM rmc_file WHERE rmc01 = g_rma.rma01
       DELETE FROM oao_file WHERE oao01 = g_rma.rma01
       DELETE FROM oap_file WHERE oap01 = g_rma.rma01
       UPDATE rma_file SET rma01=NULL WHERE rma01=g_rma.rma01
 
       LET g_msg=TIME
       INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,
                             azoplant,azolegal) #FUN-980007 
        VALUES ('armt120',g_user,g_today,g_msg,g_rma.rma01,'delete',
                 g_plant,g_legal)               #FUN-980007
       CLEAR FORM
       CALL g_rmc.clear()
       INITIALIZE g_rma.* TO NULL
       MESSAGE ""
       OPEN t120_count
       FETCH t120_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t120_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t120_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t120_fetch('/')
       END IF
    END IF
    CLOSE t120_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_possible      LIKE type_file.num5,    #No.FUN-690010 SMALLINT, #用來設定判斷重複的可能性
    l_b2      	    LIKE type_file.chr50,   #No.FUN-690010 VARCHAR(30),
    l_ima35,l_ima36 LIKE ima_file.ima35,    #No.FUN-690010 VARCHAR(10),
#    l_qty	    LIKE ima_file.ima26,    #No.FUN-690010 DECIMAL(15,3), #FUN-A20044
    l_qty	    LIKE type_file.num15_3,    #No.FUN-690010 DECIMAL(15,3), #FUN-A20044
    l_flag          LIKE type_file.num10,   #No.FUN-690010 INTEGER,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    IF g_rma.rma01 IS NULL THEN RETURN END IF
    LET g_action_choice = ""
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
    IF g_rma.rmaconf = 'Y' THEN CALL cl_err('','aap-005',0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM rmc_file ",
                       "   WHERE rmc01= ? ",
                       "   AND rmc02= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
      
      INPUT ARRAY g_rmc WITHOUT DEFAULTS FROM s_rmc.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            OPEN t120_cl USING g_rma.rma01,g_rmb.rmb02
            IF STATUS THEN
               CALL cl_err("OPEN t120_cl:", STATUS, 1)
               CLOSE t120_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t120_cl INTO g_rmb.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t120_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                #CKP
                LET p_cmd='u'
                LET g_rmc_t.* = g_rmc[l_ac].*  #BACKUP
                OPEN t120_bcl USING g_rma.rma01,g_rmc_t.rmc02
                IF STATUS THEN
                    CALL cl_err("OPEN t120_bcl:", STATUS, 1)
                ELSE
                    FETCH t120_bcl INTO b_rmc.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock rmc',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    CALL t120_b_move_to()
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            CALL t120_b_move_back()
            INSERT INTO rmc_file VALUES(b_rmc.*)
            IF SQLCA.sqlcode THEN
 #              CALL cl_err('ins rmc',SQLCA.sqlcode,0)  # FUN-660111 
               CALL cl_err3("ins","rmc_file",b_rmc.rmc01,b_rmc.rmc02,SQLCA.sqlcode,"","ins rmc",1) #FUN-660111
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
	       COMMIT WORK
            END IF
 
        BEFORE INSERT
                LET l_n = ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rmc[l_ac].* TO NULL      #900423
                LET b_rmc.rmc01=g_rma.rma01
                LET b_rmc.rmc03=g_rmb.rmb02
                LET g_rmc[l_ac].rmc08=g_today
                LET g_rmc[l_ac].rmc14='0'
                LET g_rmc[l_ac].rmc16='Y'
                LET g_rmc[l_ac].rmc10=0
                LET g_rmc[l_ac].rmc11=0
                LET g_rmc[l_ac].rmc12=0
                LET g_rmc[l_ac].rmc13=0
                LET g_rmc[l_ac].rmc21='0'
                LET g_rmc[l_ac].rmc22=g_today
                LET g_rmc[l_ac].rmc09='Y'
                LET g_rmc[l_ac].rmc19=0
                LET g_rmc[l_ac].rmc17=g_today
                LET g_rmc[l_ac].rmc18=0
                LET g_rmc_t.* = g_rmc[l_ac].*             #新輸入資料
                CALL cl_show_fld_cont()     #FUN-550037(smin)
                NEXT FIELD rmc02
 
        BEFORE FIELD rmc02                            #default 序號
            IF g_rmc[l_ac].rmc02 IS NULL OR g_rmc[l_ac].rmc02 = 0 THEN
               SELECT max(rmc02)+1 INTO g_rmc[l_ac].rmc02 FROM rmc_file
                WHERE rmc01 = g_rma.rma01
               IF g_rmc[l_ac].rmc02 IS NULL THEN
                  LET g_rmc[l_ac].rmc02 = 1
               END IF
            END IF
 
        AFTER FIELD rmc02        #check 序號是否重複
            IF NOT cl_null(g_rmc[l_ac].rmc02) THEN
{
#               SELECT COUNT(*) INTO l_cnt FROM rmc_file
#                WHERE rmc01 = g_rma.rma01 AND rmc02 = g_rmc[l_ac].rmc02
#               IF l_cnt >= g_rmb.rmb12 THEN
#                  CALL cl_err('','arm-500',0) NEXT FIELD rmc02
#               END IF
}
                IF g_rmc[l_ac].rmc02 != g_rmc_t.rmc02 OR
                   cl_null(g_rmc_t.rmc02) THEN
                   SELECT count(*) INTO l_n FROM rmc_file
                    WHERE rmc01 = g_rma.rma01
                      AND rmc02 = g_rmc[l_ac].rmc02
                   IF l_n > 0 THEN
                      LET g_rmc[l_ac].rmc02 = g_rmc_t.rmc02
                      CALL cl_err('',-239,0) NEXT FIELD rmc02
                   END IF
                END IF
            END IF
 
        AFTER FIELD rmc10
           IF NOT cl_null(g_rmc[l_ac].rmc10) THEN
               LET g_rmc[l_ac].rmc12 = g_rmc[l_ac].rmc10*g_rmc[l_ac].rmc11
           END IF
 
        AFTER FIELD rmc11
           IF NOT cl_null(g_rmc[l_ac].rmc11) THEN
               LET g_rmc[l_ac].rmc12 = g_rmc[l_ac].rmc10*g_rmc[l_ac].rmc11
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmc_t.rmc02 > 0 AND g_rmc_t.rmc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmc_file
                    WHERE rmc01 = g_rma.rma01 AND rmc02 = g_rmc_t.rmc02
                IF SQLCA.sqlcode THEN
      #              CALL cl_err(g_rmc_t.rmc02,SQLCA.sqlcode,0)  # FUN-660111 
                    CALL cl_err3("del","rmc_file",g_rma.rma01,g_rmc_t.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmc[l_ac].* = g_rmc_t.*
               CLOSE t120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmc[l_ac].rmc02,-263,1)
                LET g_rmc[l_ac].* = g_rmc_t.*
            ELSE
                CALL t120_b_move_back()
                UPDATE rmc_file SET * = b_rmc.*
                 WHERE rmc01=g_rma.rma01
                   AND rmc02=g_rmc_t.rmc02
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           #        CALL cl_err('upd rmc',SQLCA.sqlcode,0)  # FUN-660111 
                   CALL cl_err3("upd","rmc_file",g_rma.rma01,g_rmc_t.rmc02,SQLCA.sqlcode,"","upd rmc",1) #FUN-660111
                   LET g_rmc[l_ac].* = g_rmc_t.*
                   ROLLBACK WORK
                ELSE
                   MESSAGE 'UPDATE O.K'
		   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmc[l_ac].* = g_rmc_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D40030 add
           #CKP
           #LET g_rmc_t.* = g_rmc[l_ac].*          # 900423
            CLOSE t120_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t120_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmc02) AND l_ac > 1 THEN
                LET g_rmc[l_ac].* = g_rmc[l_ac-1].*
                LET g_rmc[l_ac].rmc02 = 0
                NEXT FIELD rmc02
            END IF
 
 
        ON ACTION material_usage
           LET g_msg="armt130 '",g_rma.rma01,"' ",g_rmb.rmb02," ",
                     g_rmc[l_ac].rmc08
           #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
           CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
 
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
      UPDATE rma_file SET rmamodu = g_user,rmadate = g_today
       WHERE rma01 = g_rma.rma01
 
      CLOSE t120_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION t120_b_move_to()
   LET g_rmc[l_ac].rmc02 = b_rmc.rmc02
   LET g_rmc[l_ac].rmc07 = b_rmc.rmc07
   LET g_rmc[l_ac].rmc08 = b_rmc.rmc08
   LET g_rmc[l_ac].rmc14 = b_rmc.rmc14
   LET g_rmc[l_ac].rmc16 = b_rmc.rmc16
   LET g_rmc[l_ac].rmc10 = b_rmc.rmc10
   LET g_rmc[l_ac].rmc11 = b_rmc.rmc11
   LET g_rmc[l_ac].rmc12 = b_rmc.rmc12
   LET g_rmc[l_ac].rmc13 = b_rmc.rmc13
   LET g_rmc[l_ac].rmc21 = b_rmc.rmc21
   LET g_rmc[l_ac].rmc22 = b_rmc.rmc22
   LET g_rmc[l_ac].rmc09 = b_rmc.rmc09
   LET g_rmc[l_ac].rmc19 = b_rmc.rmc19
   LET g_rmc[l_ac].rmc17 = b_rmc.rmc17
   LET g_rmc[l_ac].rmc18 = b_rmc.rmc18
   LET g_rmc[l_ac].rmc23 = b_rmc.rmc23
   LET g_rmc[l_ac].rmc24 = b_rmc.rmc24
END FUNCTION
 
FUNCTION t120_b_move_back()
   LET b_rmc.rmc02 = g_rmc[l_ac].rmc02
   LET b_rmc.rmc07 = g_rmc[l_ac].rmc07
   LET b_rmc.rmc08 = g_rmc[l_ac].rmc08
   LET b_rmc.rmc14 = g_rmc[l_ac].rmc14
 
   LET  b_rmc.rmc16 =g_rmc[l_ac].rmc16
   LET  b_rmc.rmc10  =g_rmc[l_ac].rmc10
   LET   b_rmc.rmc11 =g_rmc[l_ac].rmc11
   LET   b_rmc.rmc12 =g_rmc[l_ac].rmc12
   LET   b_rmc.rmc13 =g_rmc[l_ac].rmc13
   LET   b_rmc.rmc21 =g_rmc[l_ac].rmc21
   LET   b_rmc.rmc22 =g_rmc[l_ac].rmc22
   LET   b_rmc.rmc09 =g_rmc[l_ac].rmc09
   LET   b_rmc.rmc19 =g_rmc[l_ac].rmc19
   LET   b_rmc.rmc17 =g_rmc[l_ac].rmc17
   LET   b_rmc.rmc18 =g_rmc[l_ac].rmc18
   LET   b_rmc.rmc23 =g_rmc[l_ac].rmc23
   LET   b_rmc.rmc24 =g_rmc[l_ac].rmc24
   LET b_rmc.rmc28=0
   LET b_rmc.rmc31=0
   LET b_rmc.rmc311=0
   LET b_rmc.rmc312=0
   LET b_rmc.rmc313=0
   LET b_rmc.rmcplant = g_plant #FUN-980007
   LET b_rmc.rmclegal = g_legal #FUN-980007
END FUNCTION
 
FUNCTION t120_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON rmc02,rmc07,rmc08,rmc14,rmc16,rmc10,
                       rmc11,rmc12,rmc13,rmc21,rmc22,rmc09,
                       rmc19,rmc17,rmc18,rmc23,rmc24
            FROM       s_rmc[1].rmc02,s_rmc[1].rmc07,s_rmc[1].rmc08,
                       s_rmc[1].rmc14,s_rmc[1].rmc16,s_rmc[1].rmc10,
                       s_rmc[1].rmc11,s_rmc[1].rmc12,s_rmc[1].rmc13,
                       s_rmc[1].rmc21,s_rmc[1].rmc22,s_rmc[1].rmc09,
                       s_rmc[1].rmc19,s_rmc[1].rmc17,s_rmc[1].rmc18,
                       s_rmc[1].rmc23,s_rmc[1].rmc24
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
    CALL t120_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t120_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT rmc02,rmc07,rmc08,rmc14,rmc16,rmc10,",
        "       rmc11,rmc12,rmc13,rmc09,rmc19,rmc17,rmc18,rmc23,",
        "       rmc24,rmc21,rmc22",
        " FROM rmc_file ",
        " WHERE rmc01 ='",g_rma.rma01,"'",  #單頭
       #"   AND rmc03 =",g_rmb.rmb02,
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t120_pb FROM g_sql
    DECLARE rmc_curs                       #SCROLL CURSOR
        CURSOR FOR t120_pb
 
    CALL g_rmc.clear()
    LET g_cnt = 1
    FOREACH rmc_curs INTO g_rmc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmc TO s_rmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
   #  ON ACTION delete
   #     LET g_action_choice="delete"
   #     EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t120_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         #CKP
         CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t120_y() 			# when g_rma.rmaconf='N' (Turn to 'Y')
DEFINE l_cnt LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
#CHI-C30107 ------------ add ----------- begin
   IF g_rma.rmaconf='Y' THEN RETURN END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rmc_file
    WHERE rmc01=g_rma.rma01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-017') THEN RETURN END IF 
#CHI-C30107 ------------ add ----------- end
   SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
   IF g_rma.rmaconf='Y' THEN RETURN END IF
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rmc_file
    WHERE rmc01=g_rma.rma01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#---BUGNO:7379 END---------------
 
#  IF NOT cl_confirm('aap-017') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
 
 
    OPEN t120_cl USING g_rma.rma01,g_rmb.rmb02
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_rmb.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t120_cl ROLLBACK WORK RETURN
    END IF
 
   UPDATE rma_file SET rmaconf = 'Y' WHERE rma01 = g_rma.rma01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
      LET g_rma.rmaconf='N' ROLLBACK WORK
   ELSE
      LET g_rma.rmaconf='Y' COMMIT WORK
   END IF
   DISPLAY BY NAME g_rma.rmaconf
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
END FUNCTION
 
FUNCTION t120_z() # when g_rma.rmaconf='Y' (Turn to 'N')
   SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
   IF g_rma.rmaconf='N' THEN RETURN END IF
   IF NOT cl_confirm('aap-018') THEN RETURN END IF
 
   BEGIN WORK
 
    OPEN t120_cl USING g_rma.rma01,g_rmb.rmb02
    IF STATUS THEN
       CALL cl_err("OPEN t120_cl:", STATUS, 1)
       CLOSE t120_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t120_cl INTO g_rmb.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t120_cl ROLLBACK WORK RETURN
    END IF
 
   UPDATE rma_file SET rmaconf = 'N' WHERE rma01 = g_rma.rma01
   IF STATUS THEN
      LET g_rma.rmaconf='Y' ROLLBACK WORK
   ELSE
      LET g_rma.rmaconf='N' COMMIT WORK
   END IF
   DISPLAY BY NAME g_rma.rmaconf
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
END FUNCTION
#Patch....NO.TQC-610037 <001> #
