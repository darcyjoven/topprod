# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimu020.4gl
# Descriptions...: 庫存有效日期更改作業
# Date & Author..: 92/06/27 By Jones
# Modify.........: 95/11/22 By danny (修改331行)
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-530065 05/03/31 By Will 增加料件的開窗
# Modify.........: No.MOD-550069 05/05/09 By day  "增加料件的開窗"部分單號錯誤
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
#
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790007 07/09/03 By lumingxing 匯出EXCEL匯出的值多一空白行
# Modify.........: No.FUN-910053 09/02/13 By jan 單身加入img38欄位；新增"修改備注"ACTION
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-AB0048 10/11/05 By sabrina 按更改有效日期時應依游標所在的那一筆而跳到那一筆修改。不應跳回第一筆
# Modify.........: No.TQC-CC0049 12/12/10 By xuxz 添加顯示規格，倉庫名稱，儲位名稱欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_img            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        img02        LIKE img_file.img02,   #倉庫
        imd02        LIKE imd_file.imd02,   #TQC-CC0049 add 倉庫名稱
        img03        LIKE img_file.img03,   #存放位置
        ime03        LIKE ime_file.ime03,   #TQC-CC0049 add
        img04        LIKE img_file.img04,   #批號
        img09        LIKE img_file.img09,   #庫存單位
        img10        LIKE img_file.img10,   #庫存數量
        img18        LIKE img_file.img18,   #有效日期
        img38        LIKE img_file.img38    #FUN-910053 備注
                     END RECORD,
    g_img1           RECORD
        img01        LIKE img_file.img01,   #料件編號
        ima02        LIKE ima_file.ima02,   #品名規格
        ima05        LIKE ima_file.ima05,   #版本
        ima08        LIKE ima_file.ima08    #來源碼
                     END RECORD,
    g_img_t          RECORD                 #程式變數 (舊值)
        img02        LIKE img_file.img02,   #倉庫
        imd02        LIKE imd_file.imd02,   #TQC-CC0049 add 倉庫名稱
        img03        LIKE img_file.img03,   #存放位置
        ime03        LIKE ime_file.ime03,   #TQC-CC0049 add
        img04        LIKE img_file.img04,   #批號
        img09        LIKE img_file.img09,   #庫存單位
        img10        LIKE img_file.img10,   #庫存數量
        img18        LIKE img_file.img18,   #有效日期
        img38        LIKE img_file.img38    #FUN-910053
                     END RECORD,
    g_wc,g_wc2,g_sql string,                #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num5,   #單身筆數  #No.FUN-690026 SMALLINT
    l_ac             LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql  STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg         LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count   LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index  LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr         LIKE type_file.chr1    #FUN-910053
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0074
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
 
    LET p_row = 2 LET p_col = 18
    OPEN WINDOW u020_w AT p_row,p_col WITH FORM "aim/42f/aimu020"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL u020_menu()
    CLOSE WINDOW u020_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION u020_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_img.clear()
 
    INITIALIZE g_img1.* TO NULL    #FUN-640213 add
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON img01               # 螢幕上取單頭條件
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      #No.FUN-530065--begin       #No.MOD-550069
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(img01)
#FUN-AA0059 --Begin--
          #  CALL cl_init_qry_var()
          #  LET g_qryparam.form = "q_ima"
          #  LET g_qryparam.state = "c"
          #  LET g_qryparam.default1 = g_img1.img01
          #  CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL q_sel_ima( TRUE, "q_ima","",g_img1.img01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --Begin--
            DISPLAY g_qryparam.multiret TO img01
            NEXT FIELD img01
         OTHERWISE
            EXIT CASE
       END CASE
      #No.FUN-530065--end       #No.MOD-550069
 
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
    {
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imguser', 'imggrup')
    #End:FUN-980030
 
    }
    CONSTRUCT g_wc2 ON img02,img03,img04,img09,   # 螢幕上取單身條件
                       img10,img18,img38        #FUN-910053 add img38
            FROM s_img[1].img02,s_img[1].img03,s_img[1].img04,
                 s_img[1].img09,s_img[1].img10,s_img[1].img18,s_img[1].img38   #FUN-910053
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
       LET g_sql = "SELECT UNIQUE img01 FROM img_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE img01 ",
                   "  FROM img_file ",
                   " WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE u020_prepare FROM g_sql
    DECLARE u020_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR u020_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(DISTINCT img01) FROM img_file ",
                  " WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT img01) FROM img_file ",
                  " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE u020_precount FROM g_sql
    DECLARE u020_count CURSOR FOR u020_precount
END FUNCTION
 
FUNCTION u020_menu()
 
   WHILE TRUE
      CALL u020_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL u020_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "更改有效日期"
         WHEN "modify_expiry_date"
            IF cl_chk_act_auth() THEN
               CALL u020_b()
            END IF
        #FUN-910053--BEGIN--
        #更改備注
         WHEN "modify_remark"
            IF cl_chk_act_auth() THEN
               CALL u020_b1()
            END IF
         #FUN-910053--END--
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION u020_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_img.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL u020_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN u020_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_img1.* TO NULL
    ELSE
            OPEN u020_count
            FETCH u020_count INTO g_row_count
            DISPLAY g_row_count TO FORMONLY.cnt
        CALL u020_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION u020_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1     #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     u020_cs INTO g_img1.img01
        WHEN 'P' FETCH PREVIOUS u020_cs INTO g_img1.img01
        WHEN 'F' FETCH FIRST    u020_cs INTO g_img1.img01
        WHEN 'L' FETCH LAST     u020_cs INTO g_img1.img01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump u020_cs INTO g_img1.img01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img1.img01,SQLCA.sqlcode,0)
        INITIALIZE g_img1.* TO NULL  #TQC-6B0105
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
  #-----> 抓出單頭的其它欄位(ima_file)
    SELECT ima02,ima05,ima08 INTO g_img1.ima02,g_img1.ima05,g_img1.ima08
      FROM ima_file
     WHERE ima01 = g_img1.img01
 
 
    CALL u020_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION u020_show()
    DEFINE l_ima021 LIKE ima_file.ima021 #TQC-CC0049 add
#   LET g_img_t.* = g_img.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
       g_img1.img01,g_img1.ima02,g_img1.ima05,g_img1.ima08
   #TQC-CC0049--add-str
    LET l_ima021 = ''
    SELECT ima021 INTO l_ima021 FROM ima_file
     WHERE ima01 = g_img1.img01
    IF  SQLCA.sqlcode THEN LET l_ima021 = '' END IF
    DISPLAY l_ima021 TO ima021
   #TQC-CC0049--add-end
    CALL u020_b_fill(g_wc2)                 #把單身的資料置入陣列中
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION u020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否    #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否    #No.FUN-690026 SMALLINT
 
    LET g_action_choice = ""
    IF g_img1.img01 IS NULL THEN           #若單頭的KEY欄位是虛值時
        RETURN
    END IF
    LET g_chr = '1'      #FUN-910053
    CALL cl_opmsg('b')                     #顯示單身的操作訊息
    #BugNO:3688
    LET g_forupd_sql =
     #" SELECT img02,img03,img04,img09,img10,img18,img38 ",   #FUN-910053#TQC-CC0049 mark
      " SELECT img02,'',img03,'',img04,img09,img10,img18,img38 ",   #TQC-CC0049 add
      "   FROM img_file  ",
      "  WHERE img01 = ? ",
      "    AND img02 = ? ",
      "    AND img03 = ? ",
      "    AND img04 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE u020_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
 
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete")
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
 
        INPUT ARRAY g_img WITHOUT DEFAULTS FROM s_img.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
            CALL u200_b_set_entry()    #FUN-910053
            CALL u200_b_set_no_entry() #FUN-910053
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_img_t.* = g_img[l_ac].*   # 保留舊值
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            #BugNO:3688
           #IF g_img_t.img02 IS NOT NULL THEN
            IF g_rec_b>=l_ac THEN
                OPEN u020_bcl USING g_img1.img01,g_img_t.img02,
                                    g_img_t.img03,g_img_t.img04
                IF STATUS THEN
                    CALL cl_err("OPEN u020_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH u020_bcl INTO g_img[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_img_t.img02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                   #TQC-CC0049 --add--str
                    ELSE
                      #同步顯示倉庫名稱和儲位名稱
                      #初始化變量
                       LET g_img[l_ac].imd02 = ''
                       LET g_img[l_ac].ime03 = ''
                      #查詢出對應的倉庫名稱
                       SELECT imd02 INTO g_img[l_ac].imd02 FROM imd_file
                        WHERE imd01 = g_img[l_ac].img02
                       IF SQLCA.sqlcode THEN LET g_img[l_ac].imd02 = '' END IF
                      #查詢出對應的儲位名稱
                       SELECT ime03 INTO g_img[l_ac].ime03 FROM ime_file
                        WHERE ime01 = g_img[l_ac].img02
                          AND ime02 = g_img[l_ac].img03
                       IF SQLCA.sqlcode THEN LET g_img[l_ac].ime03 = '' END IF
                   #TQC-CC0049 --add--end
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD img02
        AFTER FIELD img18
   #------> 若修改過有效日期而修改後值為空白時顯示原來的值回來並顯示錯誤訊息
           IF g_img[l_ac].img18 IS NULL AND g_img_t.img18 IS NOT NULL THEN
              CALL cl_getmsg('aim-357',g_lang) RETURNING g_msg
              ERROR g_msg
              LET g_img[l_ac].img18 = g_img_t.img18
              DISPLAY BY NAME g_img[l_ac].img18
              NEXT FIELD img18
           END IF
   #------> 若原本倉庫儲位批號有效日期為空白時若輸入有效日期,此有效日期無意義
       IF g_img[l_ac].img02 IS NULL AND g_img[l_ac].img03 IS NULL AND
          g_img[l_ac].img04 IS NULL AND g_img[l_ac].img18 IS NOT NULL THEN
          CALL cl_getmsg('aim-358',g_lang) RETURNING g_msg
          ERROR g_msg
          LET g_img[l_ac].img18 = g_img_t.img18
          NEXT FIELD img18
       END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_img[l_ac].* = g_img_t.*
               CLOSE u020_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_img[l_ac].img02,-263,1)
               LET g_img[l_ac].* = g_img_t.*
            ELSE
              UPDATE img_file SET img18 = g_img[l_ac].img18
               WHERE img01 = g_img1.img01
                 AND img02 = g_img[l_ac].img02
                 AND img03 = g_img[l_ac].img03
                 AND img04 = g_img[l_ac].img04
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_img[l_ac].img02,SQLCA.sqlcode,0) #No.FUN-660156
                 CALL cl_err3("upd","img_file",g_img1.img01,g_img[l_ac].img02,
                               SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 LET g_img[l_ac].* = g_img_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_img[l_ac].* = g_img_t.*
               CLOSE u020_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_img_t.* = g_img[l_ac].*
            CLOSE u020_bcl
            COMMIT WORK
 
       #------> 提供使用者重查的功能
       #ON ACTION CONTROLN
       #    CALL u020_b_askkey()
       #    EXIT INPUT
 
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
 
END FUNCTION
 
#FUN-910053--BEGIN--
FUNCTION u020_b1()
DEFINE
    l_ac_t          LIKE type_file.num5, 
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1, 
    l_allow_insert  LIKE type_file.num5, 
    l_allow_delete  LIKE type_file.num5   
 
    LET g_action_choice = ""
    IF g_img1.img01 IS NULL THEN           #若單頭的KEY欄位是虛值時
        RETURN
    END IF
    LET g_chr = '2'
    CALL cl_opmsg('b')                     #顯示單身的操作訊息
    LET g_forupd_sql =
     #" SELECT img02,img03,img04,img09,img10,img18,img38 ",   #FUN-910053#TQC-CC0049 mark
      " SELECT img02,'',img03,'',img04,img09,img10,img18,img38 ",   #TQC-CC0049 add
      "   FROM img_file  ",
      "  WHERE img01 = ? ",
      "    AND img02 = ? ",
      "    AND img03 = ? ",
      "    AND img04 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE u020_bcl1 CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
 
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
 
        INPUT ARRAY g_img WITHOUT DEFAULTS FROM s_img.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
            CALL u200_b_set_entry()
            CALL u200_b_set_no_entry()
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_img_t.* = g_img[l_ac].*   # 保留舊值
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
                OPEN u020_bcl1 USING g_img1.img01,g_img_t.img02,
                                    g_img_t.img03,g_img_t.img04
                IF STATUS THEN
                    CALL cl_err("OPEN u020_bcl1:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH u020_bcl1 INTO g_img[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_img_t.img02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                   #TQC-CC0049 --add--str
                    ELSE
                      #同步顯示倉庫名稱和儲位名稱
                      #初始化變量
                       LET g_img[l_ac].imd02 = ''
                       LET g_img[l_ac].ime03 = ''
                      #查詢出對應的倉庫名稱
                       SELECT imd02 INTO g_img[l_ac].imd02 FROM imd_file
                        WHERE imd01 = g_img[l_ac].img02
                       IF SQLCA.sqlcode THEN LET g_img[l_ac].imd02 = '' END IF
                      #查詢出對應的儲位名稱
                       SELECT ime03 INTO g_img[l_ac].ime03 FROM ime_file
                        WHERE ime01 = g_img[l_ac].img02
                          AND ime02 = g_img[l_ac].img03
                       IF SQLCA.sqlcode THEN LET g_img[l_ac].ime03 = '' END IF
                   #TQC-CC0049 --add--end
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD img02
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_img[l_ac].* = g_img_t.*
               CLOSE u020_bcl1
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_img[l_ac].img02,-263,1)
               LET g_img[l_ac].* = g_img_t.*
            ELSE
              UPDATE img_file SET img38 = g_img[l_ac].img38
               WHERE img01 = g_img1.img01
                 AND img02 = g_img[l_ac].img02
                 AND img03 = g_img[l_ac].img03
                 AND img04 = g_img[l_ac].img04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","img_file",g_img1.img01,g_img[l_ac].img02,
                               SQLCA.sqlcode,"","",1)
                 LET g_img[l_ac].* = g_img_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_img[l_ac].* = g_img_t.*
               CLOSE u020_bcl1
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET g_img_t.* = g_img[l_ac].*
            CLOSE u020_bcl1
            COMMIT WORK
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
END FUNCTION
 
FUNCTION u200_b_set_entry()
  CALL cl_set_comp_entry("img18,img38",TRUE)
END FUNCTION
 
FUNCTION u200_b_set_no_entry()
 IF g_chr = '1' THEN
    CALL cl_set_comp_entry("img38",FALSE)
 END IF
 
 IF g_chr = '2' THEN
    CALL cl_set_comp_entry("img18",FALSE)
 END IF
END FUNCTION
#FUN-910053--END--
 
FUNCTION u020_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CLEAR img02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON img02,img03,img04,img09,img10,img18,img38   #FUN-910053
         FROM s_img[1].img02,s_img[1].img03,s_img[1].img04,
              s_img[1].img09,s_img[1].img10,s_img[1].img18,s_img[1].img38 #FUN-910053
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL u020_b_fill(l_wc2)
END FUNCTION
 
FUNCTION u020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql =
        "SELECT img02,'',img03,'',img04,img09,img10,img18,img38",  #FUN-910053#TQC-CC0049 add 2個'' after img02 and after img03
        " FROM img_file",
        " WHERE img01 ='",g_img1.img01,"'", #單頭
        " AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    PREPARE u020_pb FROM g_sql
    DECLARE img_curs                       #SCROLL CURSOR
        CURSOR FOR u020_pb
 
    CALL g_img.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH img_curs INTO g_img[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
       #TQC-CC0049 --add--str
       #同步顯示倉庫名稱和儲位名稱
       #初始化變量
        LET g_img[g_cnt].imd02 = ''
        LET g_img[g_cnt].ime03 = ''
       #查詢出對應的倉庫名稱
        SELECT imd02 INTO g_img[g_cnt].imd02 FROM imd_file
         WHERE imd01 = g_img[g_cnt].img02
        IF SQLCA.sqlcode THEN LET g_img[g_cnt].imd02 = '' END IF
       #查詢出對應的儲位名稱
        SELECT ime03 INTO g_img[g_cnt].ime03 FROM ime_file
         WHERE ime01 = g_img[g_cnt].img02
           AND ime02 = g_img[g_cnt].img03
        IF SQLCA.sqlcode THEN LET g_img[g_cnt].ime03 = '' END IF
       #TQC-CC0049 --add--end
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_img.deleteElement(g_cnt)  #TQC-790007
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION u020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
     #MOD-AB0048---取消mark---start--- 
      BEFORE ROW
         LET l_ac = ARR_CURR()
       CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #MOD-AB0048---取消mark---end---
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL u020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL u020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL u020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL u020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL u020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 更改有效日期
      ON ACTION modify_expiry_date
         LET g_action_choice="modify_expiry_date"
         EXIT DISPLAY
 
    #FUN-910053--BEGIN--
     ON ACTION modify_remark
         LET g_action_choice="modify_remark"
         EXIT DISPLAY
    #FUN-910053--END--
         
#    ON ACTION accept
#       LET g_action_choice="detail"
#       LET l_ac = ARR_CURR()
#       EXIT DISPLAY
 
     ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
        LET g_action_choice="exit"
        EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
