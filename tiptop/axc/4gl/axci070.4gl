# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axci070.4gl
# Descriptions...: 聯產品預設分配比例維護作業
# Date & Author..: 03/05/27 By Nicola
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No:8440 03/10/08 Melody 當g_bmm_t.bmm06為NULL值時,會造成畫面
#                                          是有改分配率,而UPDATE卻沒執行
#                                          --> per 設為 not null, required
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: No.MOD-530493 05/03/26 By pengu  在查詢時單身的g_sql有錯，造成無法產生報表
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/18 By Sunyanchun   老報表改成p_query 
# Modify.........: No.TQC-970161 09/07/20 By dxfwo  把程序中的DISPLAY l_ac  TO FORMONLY.cn3拿掉 或 修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bmm01         LIKE bmm_file.bmm01,   #
    g_bmm01_t       LIKE bmm_file.bmm01,   #
    g_bmm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmm02       LIKE bmm_file.bmm02,   #項次
        bmm03       LIKE bmm_file.bmm03,   #聯產品料件號編號
        ima02s      LIKE ima_file.ima02,   #品名
        bmm06       LIKE bmm_file.bmm06,   #分配率
        bmm05       LIKE bmm_file.bmm05    #生效否
                    END RECORD,
    g_bmm_t         RECORD                 #程式變數 (舊值)
        bmm02       LIKE bmm_file.bmm02,   #項次
        bmm03       LIKE bmm_file.bmm03,   #聯產品料件號編號
        ima02s      LIKE ima_file.ima02,   #品名
        bmm06       LIKE bmm_file.bmm06,   #分配率
        bmm05       LIKE bmm_file.bmm05    #生效否
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000, #NO.TQC-630166 mark         #No.FUN-680122 VARCHAR(300),
    g_wc,g_wc2,g_sql     STRING,     #NO.TQC-630166 
    g_flag              LIKE type_file.chr1,                                 #No.FUN-680122 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5                                  #No.FUN-680122 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0146
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    WHENEVER ERROR CONTINUE
    LET g_bmm01  = ARG_VAL(1)           #主件編號
    LET p_row = 4 LET p_col = 19
 
    OPEN WINDOW i070_w AT  p_row,p_col         #顯示畫面
        WITH FORM "axc/42f/axci070"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF cl_null(g_bmm01) THEN
       LET g_flag = 'Y'
       CALL i070_q()
    ELSE
       LET g_flag = 'N'
    END IF
    CALL i070_menu()
    CLOSE WINDOW i070_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
#QBE 查詢資料
FUNCTION i070_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE  l_i,l_j      LIKE type_file.num5,          #No.FUN-680122 SMALLINT
           l_buf        LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(500)
 
   CLEAR FORM                             #清除畫面
   CALL g_bmm.clear()
 
   IF g_flag = 'Y' THEN
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_bmm01 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON bmm01               # 螢幕上取單頭條件
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
   ELSE
      LET g_wc = " bmm01 ='",g_bmm01,"'"
   END IF
   IF INT_FLAG THEN  RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
   #End:FUN-980030
 
 
   IF g_flag = 'Y' THEN
      CONSTRUCT g_wc2 ON bmm02,bmm03,bmm06,bmm05               # 螢幕上取單身條件
               FROM s_bmm[1].bmm02,s_bmm[1].bmm03,
                    s_bmm[1].bmm06,s_bmm[1].bmm05
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
       IF INT_FLAG THEN  RETURN END IF
   ELSE
      LET g_wc2 = " 1=1"
   END IF
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT UNIQUE bmm01 FROM bmm_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY bmm01"
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE bmm01 ",
                   #-------No.MOD-530493-----
                  #"  FROM bmm_file, ",
                  "  FROM bmm_file ",
                   #---------No.MOD-530493 END----
                  " WHERE ", g_wc  CLIPPED,
                  "   AND ", g_wc2 CLIPPED,
                  " ORDER BY bmm01"
   END IF
 
   PREPARE i070_prepare FROM g_sql
   DECLARE i070_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i070_prepare
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      LET g_sql="SELECT COUNT(distinct bmm01) FROM bmm_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(distinct bmm01) FROM bmm_file ",
                " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i070_precount FROM g_sql
   DECLARE i070_count CURSOR FOR i070_precount
END FUNCTION
 
FUNCTION i070_menu()
   WHILE TRUE
      CALL i070_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i070_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i070_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i070_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0015
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_bmm),'','')
             END IF
         #--
 
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bmm01 IS NOT NULL THEN
                 LET g_doc.column1 = "bmm01"
                 LET g_doc.value1 = g_bmm01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0019-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i070_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bmm.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i070_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmm01 TO NULL
        RETURN
    END IF
    OPEN i070_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmm01 TO NULL
    ELSE
        OPEN i070_count
        FETCH i070_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i070_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i070_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680122 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680122 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i070_cs INTO g_bmm01
        WHEN 'P' FETCH PREVIOUS i070_cs INTO g_bmm01
        WHEN 'F' FETCH FIRST    i070_cs INTO g_bmm01
        WHEN 'L' FETCH LAST     i070_cs INTO g_bmm01
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso i070_cs INTO g_bmm01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmm01,SQLCA.sqlcode,0)
        INITIALIZE g_bmm01 TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i070_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i070_show()
    LET g_bmm01_t = g_bmm01                #保存單頭舊值
    DISPLAY g_bmm01 TO bmm01     # 顯示單頭值
    CALL i070_bmm01()
    CALL i070_sum(g_bmm01)
    CALL i070_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i070_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT             #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用                    #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否                    #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                      #No.FUN-680122 VARCHAR(1)
    l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否                      #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                      #No.FUN-680122 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   IF cl_null(g_bmm01) THEN
      RETURN
   END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT bmm02,bmm03,'',bmm06,bmm05 FROM bmm_file ",
                      " WHERE bmm01=? AND bmm02=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i070_bcl CURSOR FROM g_forupd_sql
 
      LET l_ac_t = 0
#     LET l_allow_insert = cl_detail_input_auth("insert")    #No.TQC-970161                                                         
#     LET l_allow_delete = cl_detail_input_auth("delete")    #No.TQC-970161                                                         
      LET l_allow_insert = false                             #No.TQC-970161                                                         
      LET l_allow_delete = false                             #No.TQC-970161
 
      INPUT ARRAY g_bmm WITHOUT DEFAULTS FROM s_bmm.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
      BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
#         DISPLAY l_ac  TO FORMONLY.cn3  #No.TQC-970161 
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_bmm_t.* = g_bmm[l_ac].*  #BACKUP
 
              OPEN i070_bcl USING g_bmm01,g_bmm_t.bmm02
              IF STATUS THEN
                 CALL cl_err("OPEN i070_bcl:", STATUS, 1)
                 CLOSE i070_bcl
                 ROLLBACK WORK
                 RETURN
              ELSE
                 FETCH i070_bcl INTO g_bmm[l_ac].*
                 IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bmm_t.bmm02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
                 SELECT ima02 INTO g_bmm[l_ac].ima02s
                   FROM ima_file
                  WHERE ima01 = g_bmm[l_ac].bmm03
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
      AFTER FIELD bmm06
          IF NOT cl_null(g_bmm[l_ac].bmm06) THEN
             IF g_bmm[l_ac].bmm06<0 THEN
                CALL cl_err(g_bmm[l_ac].bmm06,'afa-040',0)
                LET g_bmm[l_ac].bmm06 = g_bmm_t.bmm06
                NEXT FIELD bmm06
             END IF
          END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_bmm[l_ac].* = g_bmm_t.*
             CLOSE i070_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_bmm[l_ac].bmm02,-263,1)
             LET g_bmm[l_ac].* = g_bmm_t.*
          ELSE
             UPDATE bmm_file SET bmm06=g_bmm[l_ac].bmm06
              WHERE bmm01=g_bmm01 AND bmm02=g_bmm_t.bmm02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bmm[l_ac].bmm02,SQLCA.sqlcode,0)   #No.FUN-660127
                CALL cl_err3("upd","bmm_file",g_bmm01,g_bmm_t.bmm02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                LET g_bmm[l_ac].* = g_bmm_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
          CALL i070_sum(g_bmm01)
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_bmm[l_ac].* = g_bmm_t.*
             END IF
             CLOSE i070_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE i070_bcl
          COMMIT WORK
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
      CLOSE i070_bcl
      COMMIT WORK
END FUNCTION
 
FUNCTION i070_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bmm02,bmm03,bmm06,bmm05
            FROM s_bmm[1].bmm02,s_bmm[1].bmm03,
                 s_bmm[1].bmm06,s_bmm[1].bmm05
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
    CALL i070_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i070_b_fill(p_wc2)              #BODY FILL UP
   DEFINE
        p_wc2           LIKE type_file.chr1000,      #No.FUN-680122 VARCHAR(200),  
        l_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   LET g_sql = "SELECT bmm02,bmm03,ima02,bmm06,bmm05 ",
               "  FROM bmm_file LEFT OUTER JOIN ima_file ON bmm03 = ima_file.ima01",
               " WHERE bmm01 ='",g_bmm01,"'",
               "   AND ",p_wc2 CLIPPED,           #單身
               " ORDER BY bmm02,bmm03,bmm06,bmm05"
 
   PREPARE i070_pb FROM g_sql
   DECLARE bmm_cs CURSOR FOR i070_pb    #SCROLL CURSOR
 
   CALL g_bmm.clear()
   LET g_cnt = 1
   LET g_rec_b=0
   FOREACH bmm_cs INTO g_bmm[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_bmm.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i070_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmm TO s_bmm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i070_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i070_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i070_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i070_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i070_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#NO.FUN-7C0043---BEGIN
FUNCTION i070_out()
#DEFINE
#  l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#  sr              RECORD
#      bmm01       LIKE bmm_file.bmm01,   #
#      bmm02       LIKE bmm_file.bmm02,   #
#      bmm03       LIKE bmm_file.bmm03,   #
#      bmm04       LIKE bmm_file.bmm04,   #
#      bmm06       LIKE bmm_file.bmm06,   #
#      ima55       LIKE ima_file.ima55,   #
#      ima02       LIKE ima_file.ima02,   #主件編號的品名
#      ima02s      LIKE ima_file.ima02    #聯產品料號的品名
#                  END RECORD,
#  l_name          LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)         #External(Disk) file name
#  l_za05          LIKE type_file.chr1000         #No.FUN-680122 VARCHAR(40)          #
   DEFINE l_cmd  LIKE type_file.chr1000
   IF cl_null(g_wc) AND NOT cl_null(g_bmm01) THEN                                                                                   
      LET g_wc = " bmm01 = '",g_bmm01,"'"                                                                                           
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
   END IF                                                                                                                           
   LET l_cmd = 'p_query "axci070" "',g_wc CLIPPED,'"'            
   CALL cl_cmdrun(l_cmd)
#  IF g_wc IS NULL THEN
#    CALL cl_err('','9057',0)
#    RETURN
#  END IF
#  CALL cl_wait()
#  CALL cl_outnam('axci070') RETURNING l_name
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#  LET g_sql="SELECT bmm01,bmm02,bmm03,bmm04,bmm06 ",
#            "  FROM bmm_file ",
#            " WHERE ",g_wc CLIPPED
#  PREPARE i070_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i070_co CURSOR FOR i070_p1      # CURSOR
 
#  START REPORT i070_rep TO l_name
 
#  FOREACH i070_co INTO sr.*
#     IF SQLCA.sqlcode THEN
#       CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
#     SELECT ima02,ima55 INTO sr.ima02,sr.ima55 FROM ima_file WHERE ima01 = sr.bmm01
#     SELECT ima02 INTO sr.ima02s FROM ima_file WHERE ima01 = sr.bmm03
#     OUTPUT TO REPORT i070_rep(sr.*)
#  END FOREACH
 
#  FINISH REPORT i070_rep
 
#  CLOSE i070_co
#  ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i070_rep(sr)
#DEFINE
#  l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1),    
#  l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#  l_ima02_1       LIKE ima_file.ima02,
#  l_ima02_2       LIKE ima_file.ima02,
#  l_ima021_1      LIKE ima_file.ima021,
#  l_ima021_2      LIKE ima_file.ima021,
#  sr              RECORD
#      bmm01       LIKE bmm_file.bmm01,   #
#      bmm02       LIKE bmm_file.bmm02,
#      bmm03       LIKE bmm_file.bmm03,   #
#      bmm04       LIKE bmm_file.bmm04,   #
#      bmm06       LIKE bmm_file.bmm06,   #
#      ima55       LIKE ima_file.ima55,   #
#      ima02       LIKE ima_file.ima02,   #主件編號的品名
#      ima02s      LIKE ima_file.ima02    #聯產品料號的品名
#                  END RECORD
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.bmm01,sr.bmm02,sr.bmm03
 
#  FORMAT
#        PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno=g_pageno+1
#        LET pageno_total=PAGENO USING '<<<','/pageno'
#        PRINT g_head CLIPPED,pageno_total
#        PRINT
#        PRINT g_dash
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#              g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#        PRINT g_dash1
#
#        LET l_trailer_sw = 'y'
 
#     ON EVERY ROW
#        SELECT ima02,ima021 INTO l_ima02_1,l_ima021_1 FROM ima_file WHERE ima01=sr.bmm01
#        IF SQLCA.sqlcode THEN
#           LET l_ima021_1 = NULL
#           LET l_ima021_1 = NULL
#        END IF
 
#        SELECT ima02,ima021 INTO l_ima02_1,l_ima021_2 FROM ima_file WHERE ima01=sr.bmm03
#        IF SQLCA.sqlcode THEN
#           LET l_ima021_2 = NULL
#           LET l_ima021_2 = NULL
#        END IF
 
#        PRINT COLUMN 02,sr.bmm01,
#              COLUMN 23,sr.ima55,
#              COLUMN 28,sr.bmm02 USING '###&',
#              COLUMN 33,sr.bmm03,
#              COLUMN 54,sr.bmm04,
#              COLUMN 59,sr.bmm06
#        PRINT COLUMN 02,sr.ima02,
#              COLUMN 33,sr.ima02s
#        PRINT COLUMN g_c[31],sr.bmm01,
#              COLUMN g_c[32],l_ima02_1,
#              COLUMN g_c[33],l_ima021_1,
#              COLUMN g_c[34],sr.ima55,
#              COLUMN g_c[35],sr.bmm02 USING '###&',
#              COLUMN g_c[36],sr.bmm03,
#              COLUMN g_c[37],l_ima02_2,
#              COLUMN g_c[38],l_ima021_2,
#              COLUMN g_c[39],sr.bmm04,
#              COLUMN g_c[40],cl_numfor(sr.bmm06,40,3)
 
#     AFTER GROUP OF sr.bmm01
#        PRINT COLUMN g_c[39],g_x[9] CLIPPED,
#              COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bmm06),40,3)
#        SKIP 1 LINE
 
#     ON LAST ROW
#        PRINT g_dash
#        IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#NO.TQC-630166 start-
#            IF g_wc[001,080] > ' ' THEN
#      	       PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED
#            END IF
#            IF g_wc[071,140] > ' ' THEN
#      	       PRINT COLUMN 10,     g_wc[071,140] CLIPPED
#            END IF
#            IF g_wc[141,210] > ' ' THEN
#      	       PRINT COLUMN 10,     g_wc[141,210] CLIPPED
#            END IF
#            CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
#           PRINT g_dash
#        END IF
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
#END REPORT
#NO.FUN-7C0043---END
FUNCTION i070_bmm01()
  DEFINE l_ima02  LIKE ima_file.ima02,
         l_ima021 LIKE ima_file.ima021
 
  SELECT ima02,ima021
    INTO l_ima02,l_ima021
    FROM ima_file
   WHERE ima01 =g_bmm01
 
  DISPLAY l_ima02  TO FORMONLY.ima02
  DISPLAY l_ima021 TO FORMONLY.ima021
 
END FUNCTION
 
FUNCTION i070_sum(l_bmm01)
   DEFINE l_bmm01 LIKE bmm_file.bmm01,
          l_sum   LIKE bmm_file.bmm06
 
   SELECT SUM(bmm06) INTO l_sum FROM bmm_file
    WHERE bmm01=l_bmm01 AND bmm05='Y'
   IF STATUS THEN
      LET l_sum=0
   END IF
   DISPLAY l_sum TO FORMONLY.tot
 
END FUNCTION
 
