# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: armt130.4gl
# Descriptions...: RMA用料明細維護作業
# Date & Author..: 98/03/29 By plum
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980144 09/08/19 By Smapmin 單身雙點造成無窮迴圈
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.CHI-B60093 11/06/30 By JoHung 依系統預設的成本計算類別取得該料的成本平均
# Modify.........: No.FUN-BB0084 11/12/27 By lixh1 增加數量欄位小數取位 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rmc           RECORD LIKE rmc_file.*,       #RMA單號 (假單頭)
    g_rmc01_t       LIKE rmc_file.rmc01,   #(舊值)  單號
    g_rmc02_t       LIKE rmc_file.rmc02,   #(舊值)  項次
    g_rmc08_t       LIKE rmc_file.rmc08,   #(舊值)  修復日期
    g_rmd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmd02  LIKE rmd_file.rmd02,       #項次
                    rmd031 LIKE rmd_file.rmd031,      #rmc02:項次
                    rmd23  LIKE rmd_file.rmd23,       #D/R代碼
                    rmk02  LIKE rmk_file.rmk02,       #D/R代碼內容
                    rmd24  LIKE rmd_file.rmd24,       #額外說明
                    rmd21  LIKE rmd_file.rmd21,       #
                    rmd04  LIKE rmd_file.rmd04,       #
                    rmd07  LIKE rmd_file.rmd07,       #S/N
                    rmd05  LIKE rmd_file.rmd05,       #單位
                    rmd12  LIKE rmd_file.rmd12,       #數量
                    rmd27  LIKE rmd_file.rmd27,       #責任
                    rmd06  LIKE rmd_file.rmd06,       #品名
                    rmd13  LIKE rmd_file.rmd13,       #成本單價
                    rmd14  LIKE rmd_file.rmd14        #成本金額
                    END RECORD,
    g_rmd_t         RECORD                 #程式變數 (舊值)
                    rmd02  LIKE rmd_file.rmd02,       #項次
                    rmd031 LIKE rmd_file.rmd031,      #rmc02:項次
                    rmd23  LIKE rmd_file.rmd23,       #D/R代碼
                    rmk02  LIKE rmk_file.rmk02,       #D/R代碼內容
                    rmd24  LIKE rmd_file.rmd24,       #額外說明
                    rmd21  LIKE rmd_file.rmd21,       #
                    rmd04  LIKE rmd_file.rmd04,       #
                    rmd07  LIKE rmd_file.rmd07,       #S/N
                    rmd05  LIKE rmd_file.rmd05,       #單位
                    rmd12  LIKE rmd_file.rmd12,       #數量
                    rmd27  LIKE rmd_file.rmd27,       #責任
                    rmd06  LIKE rmd_file.rmd06,       #品名
                    rmd13  LIKE rmd_file.rmd13,       #成本單價
                    rmd14  LIKE rmd_file.rmd14        #成本金額
                    END RECORD,
    g_rmd_o         RECORD                 #程式變數 (舊值)
                    rmd02  LIKE rmd_file.rmd02,       #項次
                    rmd031 LIKE rmd_file.rmd031,      #rmc02:項次
                    rmd23  LIKE rmd_file.rmd23,       #D/R代碼
                    rmk02  LIKE rmk_file.rmk02,       #D/R代碼內容
                    rmd24  LIKE rmd_file.rmd24,       #額外說明
                    rmd21  LIKE rmd_file.rmd21,       #
                    rmd04  LIKE rmd_file.rmd04,       #
                    rmd07  LIKE rmd_file.rmd07,       #S/N
                    rmd05  LIKE rmd_file.rmd05,       #單位
                    rmd12  LIKE rmd_file.rmd12,       #數量
                    rmd27  LIKE rmd_file.rmd27,       #責任
                    rmd06  LIKE rmd_file.rmd06,       #品名
                    rmd13  LIKE rmd_file.rmd13,       #成本單價
                    rmd14  LIKE rmd_file.rmd14        #成本金額
                    END RECORD,
     g_sql               string,  #No.FUN-580092 HCN
     g_wc                string,  #No.FUN-580092 HCN
    g_aflag         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
    p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
       EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
   END IF
    LET g_wc= " 1=1"
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET g_rmc01_t = ARG_VAL(1)
    LET g_rmc02_t = ARG_VAL(2)
    LET g_rmc08_t = ARG_VAL(3)
 
    IF cl_null(g_rmc01_t) OR cl_null(g_rmc02_t) OR cl_null(g_rmc08_t) THEN
       CALL cl_err('',100,1)
       EXIT PROGRAM
    END IF
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW t130_w AT p_row,p_col WITH FORM "arm/42f/armt130"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    LET g_wc="rmd01='",g_rmc01_t,"' AND rmd03=",g_rmc02_t
 
    IF NOT (cl_null(g_rmc01_t) AND cl_null(g_rmc02_t)) THEN
       CALL t130_b_fill(g_wc CLIPPED)
#      CALL t130_b('D')
    END IF
    CALL t130_menu()
    CLOSE WINDOW t130_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION t130_curs()
 
    CLEAR FORM                             #清除畫面
    CALL g_rmd.clear()
    CONSTRUCT g_wc ON rmd02,rmd031,rmd23,rmd24,rmd21,rmd04,rmd06,rmd07,
                      rmd05,rmd12,rmd13,rmd14,rmd27
        FROM s_rmd[1].rmd02,s_rmd[1].rmd031,s_rmd[1].rmd23,s_rmd[1].rmd24,
             s_rmd[1].rmd21,s_rmd[1].rmd04,s_rmd[1].rmd06,s_rmd[1].rmd07,
             s_rmd[1].rmd05,s_rmd[1].rmd12,s_rmd[1].rmd13,s_rmd[1].rmd14,
             s_rmd[1].rmd27
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(rmd04) #料件編號
#                CALL q_ima(10,3,g_rmd[1].rmd04)
#                     RETURNING g_rmd[1].rmd04
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.default1 = g_rmd[1].rmd04
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","",g_rmd[1].rmd04,"","","","","",'')  
                  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO rmd04    #No.MOD-490371
                 NEXT FIELD rmd04
              WHEN INFIELD(rmd05) #料件的單位
#                CALL q_gfe(0,0,g_rmd[1].rmd05)
#                     RETURNING g_rmd[1].rmd05
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rmd[1].rmd05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmd05        #No.MOD-490371
                 NEXT FIELD rmd05
              WHEN INFIELD(rmd23) #不良現象
#                CALL q_rmk(10,3,g_rmd[1].rmd23)
#                     RETURNING g_rmd[1].rmd23
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rmk"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rmd[1].rmd23
                 #CALL cl_create_qry() RETURNING g_rmd[1].rmd23
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmd23       #No.MOD-490371
                 NEXT FIELD rmd23
              OTHERWISE
                 EXIT CASE
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND rmcuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND rmcgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND rmcgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmcuser', 'rmcgrup')
    #End:FUN-980030
 
    IF g_wc = " 1=1" THEN                        # 取合乎條件筆數
       LET g_sql = "  SELECT UNIQUE rmd01 ",
                   "  FROM rmc_file,rmd_file ",
                  #"  WHERE rmd01 = ",g_argv1," AND rmd03= ",g_argv2,
                   "  WHERE rmd01 = '",g_rmc01_t,"' AND rmd03= ",g_rmc02_t,
                   "  AND rmd01=rmc01 AND rmd03=rmc02 ",
                   "  ORDER BY 2"
    ELSE
       LET g_sql = "  SELECT UNIQUE rmd01 ",
                   "  FROM rmc_file,rmd_file ",
                   "  WHERE rmd01 = '",g_rmc01_t,"' AND rmd03= ",g_rmc02_t,
                   "  AND rmd01=rmc01 AND rmd03=rmc02 AND ",g_wc CLIPPED,
                   "  ORDER BY 2"
    END IF
   #END IF
    PREPARE t130_prepare FROM g_sql
        DECLARE t130_curs
        SCROLL CURSOR WITH HOLD FOR t130_prepare
    IF g_wc = " 1=1" THEN                        # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rmd_file WHERE ",
                  "rmd01= '",g_rmc01_t ,"' AND rmd03 =",g_rmc02_t
    ELSE
        LET g_sql="SELECT COUNT(*) FROM rmd_file WHERE ",
                  "rmd01= '",g_rmc01_t ,"' AND rmd03 =",g_rmc02_t,g_wc CLIPPED
    END IF
    PREPARE t130_precount FROM g_sql
    DECLARE t130_count CURSOR FOR t130_precount
END FUNCTION
 
FUNCTION t130_menu()
DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(100)
 
   WHILE TRUE
      CALL t130_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmd),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t130_q()
    MESSAGE ""
    CLEAR FORM
    CALL g_rmd.clear()
    DISPLAY '  ' TO FORMONLY.cn2
    CALL t130_curs()
    IF INT_FLAG THEN
        INITIALIZE g_rmc.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t130_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_rmc.* TO NULL
    ELSE
       OPEN t130_count
       FETCH t130_count INTO g_cnt
       DISPLAY g_cnt TO FORMONLY.cnt
       CALL t130_b_fill(g_wc)                  # 讀出TEMP第一筆並顯示
       CALL t130_b('D')
    END IF
    MESSAGE " "
END FUNCTION
 
#單身
FUNCTION t130_b(p_cmd)
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_rmk02         LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
    l_gfe01         LIKE gfe_file.gfe01,    #料件編號: 單位
    l_buf           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
    l_allow_insert  LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1     #No.FUN-690010 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_rmc01_t) THEN
        RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rmd02,rmd031,rmd23,' ',rmd24,rmd21,rmd04,rmd07,rmd05,rmd12,rmd27,rmd06,rmd13,rmd12 FROM rmd_file WHERE rmd01=? AND rmd02 =? AND rmd03=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t130_b_curl CURSOR WITH HOLD FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_rmd WITHOUT DEFAULTS FROM s_rmd.*
                          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec)
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmd_t.* = g_rmd[l_ac].*  #BACKUP
               LET g_rmd_o.* = g_rmd[l_ac].*
               LET p_cmd='u'
               BEGIN WORK
               OPEN t130_b_curl USING g_rmc01_t,g_rmd_t.rmd02,g_rmc02_t
               IF STATUS THEN
                  CALL cl_err("OPEN t130_b_curl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t130_b_curl INTO g_rmd[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rmd_t.rmd02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL t130_set_entry(p_cmd)
            CALL t130_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
           #CKP
           #NEXT FIELD rmd02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rmd[l_ac].* TO NULL      #900423
            LET g_rmd[l_ac].rmd12 = 0         #Body default
            LET g_rmd[l_ac].rmd13 = 0         #Body default
            LET g_rmd[l_ac].rmd14 = g_rmd[l_ac].rmd12 *g_rmd[l_ac].rmd13
            LET g_rmd_t.* = g_rmd[l_ac].*         #新輸入資料
            LET g_rmd_o.* = g_rmd[l_ac].*         #新輸入資料
            LET g_before_input_done = FALSE
            CALL t130_set_entry(p_cmd)
            CALL t130_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmd02
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         INSERT INTO rmd_file(rmd01,rmd02,rmd03,rmd031,rmd04,
                              rmd06,rmd05,rmd12,rmd13,
                              rmd14,rmd07,rmd23,rmd24,
                              rmd27,rmdplant,rmdlegal) #FUN-980007
             VALUES(g_rmc01_t,g_rmd[l_ac].rmd02,g_rmc02_t,
                    g_rmd[l_ac].rmd031,
                    g_rmd[l_ac].rmd04,g_rmd[l_ac].rmd06,
                    g_rmd[l_ac].rmd05,
                    g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd13,
                    g_rmd[l_ac].rmd14,g_rmd[l_ac].rmd07,
                    g_rmd[l_ac].rmd23,g_rmd[l_ac].rmd24,
                    g_rmd[l_ac].rmd27,
                    g_plant,g_legal)                   #FUN-980007
         IF SQLCA.sqlcode THEN
 #            CALL cl_err(g_rmd[l_ac].rmd02,SQLCA.sqlcode,0)  # FUN-660111 
             CALL cl_err3("ins","rmd_file",g_rmc01_t,g_rmd[l_ac].rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
             #CKP
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
        BEFORE FIELD rmd02                        #default 項次
            IF g_rmd[l_ac].rmd02 IS NULL OR
               g_rmd[l_ac].rmd02 = 0 THEN
                SELECT max(rmd02)+1
                   INTO g_rmd[l_ac].rmd02
                   FROM rmd_file
                   WHERE rmd01 = g_rmc01_t
                IF g_rmd[l_ac].rmd02 IS NULL
                   THEN LET g_rmd[l_ac].rmd02 = 1
                END IF
            END IF
 
        AFTER FIELD rmd02                        #check 序號是否重複
            IF g_rmd[l_ac].rmd02 IS NOT NULL THEN
               IF g_rmd[l_ac].rmd02 != g_rmd_o.rmd02 OR
                  g_rmd_t.rmd02 IS NULL THEN
                  SELECT count(*)
                    INTO l_n
                    FROM rmd_file
                   WHERE rmd01 = g_rmc01_t AND
                         rmd02 = g_rmd[l_ac].rmd02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_rmd[l_ac].rmd02 = g_rmd_o.rmd02
                     NEXT FIELD rmd02
                  END IF
               END IF
               LET g_rmd_o.rmd02 = g_rmd[l_ac].rmd02
            END IF
 
        BEFORE FIELD rmd04
            CALL t130_set_entry(p_cmd)
 
        AFTER FIELD rmd04                  #料件編號
            IF NOT cl_null(g_rmd[l_ac].rmd04) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_rmd[l_ac].rmd04,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rmd[l_ac].rmd04= g_rmd_t.rmd04
                  NEXT FIELD rmd04
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               IF g_rmd_o.rmd04 IS NULL OR
                 (g_rmd[l_ac].rmd04 != g_rmd_o.rmd04 ) THEN
                  CALL t130_rmd04(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rmd[l_ac].rmd04,'asf-677',0)
                     LET g_rmd[l_ac].rmd04 = g_rmd_t.rmd04
                     LET g_rmd[l_ac].rmd06 = g_rmd_t.rmd06
                     #------MOD-5A0095 START----------
                     DISPLAY BY NAME g_rmd[l_ac].rmd06
                     #------MOD-5A0095 END------------
                     NEXT FIELD rmd04
                  END IF
                  CALL t130_rmd13()
                  LET g_rmd[l_ac].rmd14 = g_rmd[l_ac].rmd12 *g_rmd[l_ac].rmd13
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_rmd[l_ac].rmd14
                  #------MOD-5A0095 END------------
  #------MOD-5A0095 START----------
  DISPLAY BY NAME g_rmd[l_ac].rmd06
  #------MOD-5A0095 END------------
               END IF
               IF INT_FLAG THEN                 #900423
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET g_rmd[l_ac].* = g_rmd_t.*
                  EXIT INPUT
               END IF
               LET g_rmd_o.rmd04 = g_rmd[l_ac].rmd04
               CALL t130_set_no_entry(p_cmd)
            END IF
 
        AFTER FIELD rmd05                  #料件單位
            IF NOT cl_null(g_rmd[l_ac].rmd05) THEN
               SELECT gfe01 INTO l_gfe01 FROM gfe_file  #須存在單位主檔
               WHERE  gfe01=g_rmd[l_ac].rmd05
               IF STATUS THEN
    #              CALL cl_err('','afa-319',0)  # FUN-660111 
                  CALL cl_err3("sel","gfe_file",g_rmd[l_ac].rmd05,"","afa-319","","",1) #FUN-660111
                  LET g_rmd[l_ac].rmd05 = g_rmd_t.rmd05
                  NEXT FIELD rmd05
               END IF
               CALL t130_rmd12_chk()     #FUN-BB0084 
               LET g_rmd_o.rmd05 = g_rmd[l_ac].rmd05
            END IF
 
        AFTER FIELD rmd27                               #責任
            IF g_rmd[l_ac].rmd27 IS NOT NULL THEN
               IF NOT g_rmd[l_ac].rmd27 MATCHES '[AU]' THEN
                  NEXT FIELD rmd27
               END IF
            END IF
 
        AFTER FIELD rmd12
           CALL t130_rmd12_chk()    #FUN-BB0084
        #FUN-BB0084 ------------Begin-------------
        # IF g_rmd[l_ac].rmd12 IS NOT NULL THEN
        #    LET g_rmd[l_ac].rmd14 = g_rmd[l_ac].rmd12 *g_rmd[l_ac].rmd13
        #    #------MOD-5A0095 START----------
        #    DISPLAY BY NAME g_rmd[l_ac].rmd14
        #    #------MOD-5A0095 END------------
        # END IF
        #FUN-BB0084 ------------End---------------
 
        AFTER FIELD rmd13
          IF g_rmd[l_ac].rmd13 IS NOT NULL THEN
             IF g_rmd[l_ac].rmd13 <0 THEN
                CALL cl_err('','aap-201',0)
                NEXT FIELD rmd13
             END IF
             LET g_rmd[l_ac].rmd14 = g_rmd[l_ac].rmd12 *g_rmd[l_ac].rmd13
          END IF
 
        AFTER FIELD rmd14
          IF g_rmd[l_ac].rmd14 IS NULL OR g_rmd[l_ac].rmd14 <0 THEN
             CALL cl_err('','aap-201',0)
             NEXT FIELD rmd14
          END IF
 
        AFTER FIELD rmd23                               #不良現象
            IF NOT cl_null(g_rmd[l_ac].rmd23) THEN
               SELECT rmk01 INTO l_rmk02 FROM rmk_file  #須存在現象檔
               WHERE  rmk01=g_rmd[l_ac].rmd23
               IF STATUS THEN
 #                 CALL cl_err('','afa-319',0)  # FUN-660111 
                  CALL cl_err3("sel","rmk_file",g_rmd[l_ac].rmd23,"","afa-319","","",1) #FUN-660111
                  NEXT FIELD rmd23
               END IF
               LET g_rmd_o.rmd23 = g_rmd[l_ac].rmd23
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmd_t.rmd02 > 0 AND
               g_rmd_t.rmd02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               DELETE FROM rmd_file
                WHERE rmd01 = g_rmc01_t   AND
                      rmd02 = g_rmd_t.rmd02
               IF SQLCA.sqlcode THEN
                  LET l_buf = g_rmd_t.rmd02 clipped
 #                 CALL cl_err(l_buf,SQLCA.sqlcode,0)  # FUN-660111 
                  CALL cl_err3("del","rmd_file",g_rmc01_t,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE t130_b_curl
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rmd[l_ac].* = g_rmd_t.*
              CLOSE t130_b_curl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rmd[l_ac].rmd02,-263,1)
              LET g_rmd[l_ac].* = g_rmd_t.*
           ELSE
              UPDATE rmd_file SET
                     rmd02 = g_rmd[l_ac].rmd02,
                     rmd031= g_rmd[l_ac].rmd031,
                     rmd04 = g_rmd[l_ac].rmd04,
                     rmd06 = g_rmd[l_ac].rmd06,
                     rmd05 = g_rmd[l_ac].rmd05,
                     rmd12 = g_rmd[l_ac].rmd12,
                     rmd13 = g_rmd[l_ac].rmd13,
                     rmd14 = g_rmd[l_ac].rmd14,
                     rmd07 = g_rmd[l_ac].rmd07,
                     rmd23 = g_rmd[l_ac].rmd23,
                     rmd24 = g_rmd[l_ac].rmd24,
                     rmd27 = g_rmd[l_ac].rmd27
               WHERE rmd01 = g_rmc01_t AND rmd02=g_rmd_t.rmd02
                                       AND rmd03=g_rmc02_t
              IF SQLCA.sqlcode THEN
    #              CALL cl_err(g_rmd[l_ac].rmd02,SQLCA.sqlcode,0)  # FUN-660111 
                  CALL cl_err3("upd","rmd_file",g_rmc01_t,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
                  LET g_rmd[l_ac].* = g_rmd_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE t130_b_curl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmd[l_ac].* = g_rmd_t.*
               END IF
               CLOSE t130_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #CKP
            #LET g_rmd_t.* = g_rmd[l_ac].*          # 900423
            LET l_ac_t = l_ac
            CLOSE t130_b_curl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rmd04) #料件編號
#                CALL q_ima(10,3,g_rmd[l_ac].rmd04)
#                     RETURNING g_rmd[l_ac].rmd04
#                CALL FGL_DIALOG_SETBUFFER( g_rmd[l_ac].rmd04 )
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_rmd[l_ac].rmd04
#                 CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd04
#                 CALL FGL_DIALOG_SETBUFFER( g_rmd[l_ac].rmd04 )
                  CALL q_sel_ima(FALSE, "q_ima","",g_rmd[l_ac].rmd04,"","","","","",'' ) 
                     RETURNING  g_rmd[l_ac].rmd04
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_rmd[l_ac].rmd04       #No.MOD-490371
                 NEXT FIELD rmd04
              WHEN INFIELD(rmd05) #料件的單位
#                CALL q_gfe(0,0,g_rmd[l_ac].rmd05)
#                     RETURNING g_rmd[l_ac].rmd05
#                CALL FGL_DIALOG_SETBUFFER( g_rmd[l_ac].rmd05 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_rmd[l_ac].rmd05
                 CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd05
#                 CALL FGL_DIALOG_SETBUFFER( g_rmd[l_ac].rmd05 )
                  DISPLAY BY NAME g_rmd[l_ac].rmd05       #No.MOD-490371
                 NEXT FIELD rmd05
              WHEN INFIELD(rmd23) #不良現象
#                CALL q_rmk(10,3,g_rmd[l_ac].rmd23)
#                     RETURNING g_rmd[l_ac].rmd23
#                CALL FGL_DIALOG_SETBUFFER( g_rmd[l_ac].rmd23 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rmk"
                 LET g_qryparam.default1 = g_rmd[l_ac].rmd23
                 CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd23
#                 CALL FGL_DIALOG_SETBUFFER( g_rmd[l_ac].rmd23 )
                  DISPLAY BY NAME g_rmd[l_ac].rmd23       #No.MOD-490371
                 NEXT FIELD rmd23
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLN
           #CALL t130_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(rmd02) AND l_ac > 1 THEN
               LET g_rmd[l_ac].* = g_rmd[l_ac-1].*
               LET g_rmd[l_ac].rmd02 = NULL
               NEXT FIELD rmd02
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
 
    CLOSE t130_b_curl
END FUNCTION
 
#FUN-BB0084 -------------Begin----------------
FUNCTION t130_rmd12_chk()
   IF NOT cl_null(g_rmd[l_ac].rmd12) AND NOT cl_null(g_rmd[l_ac].rmd05) THEN
      IF cl_null(g_rmd_o.rmd05) OR cl_null(g_rmd_t.rmd12) OR g_rmd_o.rmd05 = g_rmd[l_ac].rmd05
         OR g_rmd_t.rmd12 ! = g_rmd[l_ac].rmd12 THEN
         LET g_rmd[l_ac].rmd12 = s_digqty(g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd05)
         DISPLAY BY NAME g_rmd[l_ac].rmd12
      END IF
   END IF   
   IF g_rmd[l_ac].rmd12 IS NOT NULL THEN
      LET g_rmd[l_ac].rmd14 = g_rmd[l_ac].rmd12 *g_rmd[l_ac].rmd13
      DISPLAY BY NAME g_rmd[l_ac].rmd14
   END IF
END FUNCTION 
#FUN-BB0084 -------------End------------------
# rmd04+rmc08(armt125:修復日期)的年度,上月份->ccc_file:ccc23
FUNCTION t130_rmd13()
# DEFINE g_rmc08 LIKE rmc_file.rmc08,
  DEFINE rmc08_yy LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
         rmc08_mm LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
 #SELECT rmc08 INTO g_rmc08 FROM rmc_file
 #             WHERE rmc01=g_rmc01_t AND rmc02=g_rmc02_t
 
  LET rmc08_yy=YEAR(g_rmc08_t)
  LET rmc08_mm=MONTH(g_rmc08_t)
  LET rmc08_mm=rmc08_mm - 1
  IF  rmc08_mm=0 THEN LET rmc08_yy=rmc08_yy -1 END IF
  SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'
# SELECT ccc23 INTO g_rmd[l_ac].rmd13 FROM ccc_file                #CHI-B60093 mark
  SELECT AVG(ccc23) INTO g_rmd[l_ac].rmd13 FROM ccc_file           #CHI-B60093
               WHERE ccc01=g_rmd[l_ac].rmd04 AND ccc02=rmc08_yy
                 AND ccc03=rmc08_mm
#                AND ccc07='1'                 #No.FUN-840041      #CHI-B60093
                 AND ccc07=g_ccz.ccz28
  IF g_rmd[l_ac].rmd13 IS NULL THEN LET g_rmd[l_ac].rmd13=0 END IF
END FUNCTION
 
FUNCTION t130_up_rmc()  # rmc13=sum(rmd14)
   DEFINE t_rmd14  LIKE rmd_file.rmd14
 
    SELECT sum(rmd14) INTO t_rmd14 FROM rmc_file,rmd_file
           WHERE rmd01=rmc01 AND rmd03=rmc02
             AND rmd01= g_rmc01_t AND rmd03=g_rmc02_t
 
    IF t_rmd14 IS NULL THEN LET t_rmd14=0 END IF
    UPDATE rmc_file set rmc13=t_rmd14
           WHERE rmc01=g_rmc01_t AND rmc02=g_rmc02_t
END FUNCTION
 
FUNCTION t130_rmd04(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima25    LIKE ima_file.ima25,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,imaacti
      INTO l_ima02,l_ima021,l_ima25,l_imaacti
      FROM ima_file WHERE ima01 = g_rmd[l_ac].rmd04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'arm-006'
                            LET l_ima02 = NULL
                            LET l_ima021 = NULL
                            LET l_ima25 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------       
        #OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
         OTHERWISE          LET g_errno = ' '
    END CASE
   #IF p_cmd = 'a' THEN
   #    LET g_rmd[l_ac].rmd05 = l_ima25    #庫存單位
   #END IF
   #IF (g_errno = ' ' OR p_cmd = 'd' OR g_rmc[l_ac].rmc04 = 'MISC' THEN
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_rmd[l_ac].rmd05  = l_ima25    #庫存單位
       LET g_rmd[l_ac].rmd06  = l_ima02
    END IF
#FUN-BB0084 ------------Begin--------------
    IF NOT cl_null(g_rmd[l_ac].rmd12) THEN
       LET g_rmd[l_ac].rmd12 = s_digqty(g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd05) 
       DISPLAY BY NAME g_rmd[l_ac].rmd12
       DISPLAY BY NAME g_rmd[l_ac].rmd05
    END IF
#FUN-BB0084 ------------End----------------
END FUNCTION
 
FUNCTION t130_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
 
     IF p_wc ="" THEN LET p_wc=" 1=1" END IF
     LET g_sql =
        " SELECT rmd02,rmd031,rmd23,rmk02,rmd24,rmd21,rmd04,rmd07,rmd05, ",
        "        rmd12,rmd27,rmd06,rmd13,rmd14 ",
        " FROM rmd_file,rmc_file,rmk_file ",
        " WHERE rmd01 =rmc01 AND rmd03=rmc02 ",
        " AND rmd23=rmk01 AND ",p_wc CLIPPED,
        " ORDER BY 1"
 
    PREPARE t130_pb FROM g_sql
    DECLARE rmd_curs                       #SCROLL CURSOR
        CURSOR FOR t130_pb
 
    CALL g_rmd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH rmd_curs INTO g_rmd[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
    END FOREACH
    #CKP
    CALL g_rmd.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmd TO s_rmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      #-----TQC-980144---------
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY
      #-----END TQC-980144-----
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t130_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF INFIELD(rmd04) OR ( NOT g_before_input_done ) THEN
         CALL cl_set_comp_entry("rmd06",TRUE)
    END IF
END FUNCTION
 
FUNCTION t130_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF INFIELD(rmd04) OR ( NOT g_before_input_done ) THEN
       IF g_rmd[l_ac].rmd04 != 'MISC' THEN
          CALL cl_set_comp_entry("rmd06",FALSE)
       END IF
    END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003> #
