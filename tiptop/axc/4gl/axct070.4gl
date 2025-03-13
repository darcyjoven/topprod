# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axct070.4gl
# Descriptions...: 聯產品分配比例維護作業
# Date & Author..: 03/06/02 By Jiunn
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.MOD-560157 05/06/21 By kim 查詢僅一張,筆數0 ,與 db 資料不符(提供程式碼)
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770088 07/07/31 By Rayven 年份顯示有誤，結束頁位置不對
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun  橾老報表改成p_query 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970297 09/09/25 By baofei 1.修改單身，去掉新增刪除功能                                                    
#                                                   2.cn3 欄位不存在    
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_cjp01         LIKE cjp_file.cjp01,  #主件
    g_cjp02         LIKE cjp_file.cjp02,  #年
    g_cjp03         LIKE cjp_file.cjp03,  #月
    g_cjp01_t       LIKE cjp_file.cjp01,
    g_cjp02_t       LIKE cjp_file.cjp02,
    g_cjp03_t       LIKE cjp_file.cjp03,
    g_cjp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cjp04       LIKE cjp_file.cjp04,   #聯產品料號
        ima02s      LIKE ima_file.ima02,
        cjp05       LIKE cjp_file.cjp05,   #單位
        cjp06       LIKE cjp_file.cjp06    #分配率    
                    END RECORD,
    g_cjp_t         RECORD                 #程式變數 (舊值)
        cjp04       LIKE cjp_file.cjp04,   #聯產品料號
        ima02s      LIKE ima_file.ima02,
        cjp05       LIKE cjp_file.cjp05,   #單位
        cjp06       LIKE cjp_file.cjp06    #分配率    
                    END RECORD,
#    g_wc,g_wc2,g_sql    VARCHAR(300)  #NO.TQC-630166 mark
    g_wc,g_wc2,g_sql     STRING,     #NO.TQC-630166 
    g_flag          LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680122 SMALLINT
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
    LET g_cjp01  = ARG_VAL(1)           #主件編號
    LET g_cjp02  = ARG_VAL(2)           #年
    LET g_cjp03  = ARG_VAL(3)           #月
    LET p_row = 4 LET p_col = 5
    OPEN WINDOW t070_w AT  p_row,p_col         #顯示畫面
        WITH FORM "axc/42f/axct070"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    IF cl_null(g_cjp01) THEN 
       LET g_flag = 'Y' 
       CALL t070_q()
    ELSE 
       LET g_flag = 'N' 
    END IF
    CALL t070_menu()
    CLOSE WINDOW t070_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
#QBE 查詢資料
FUNCTION t070_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE  l_i,l_j      LIKE type_file.num5,           #No.FUN-680122 SMALLINT
           l_buf        LIKE type_file.chr1000,       #No.FUN-680122CHAR(500)
            l_sql        STRING #MOD-560157 
 
   CLEAR FORM                             #清除畫面
   CALL g_cjp.clear()
 
   IF g_flag = 'Y' THEN 
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_cjp01 TO NULL    #No.FUN-750051
   INITIALIZE g_cjp02 TO NULL    #No.FUN-750051
   INITIALIZE g_cjp03 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON cjp01,cjp02,cjp03   # 螢幕上取單頭條件
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   ELSE
      LET g_wc = " cjp01 ='",g_cjp01,"' AND ",
                 " cjp02 = ",g_cjp02,"  AND ",
                 " cjp03 = ",g_cjp03
   END IF
   IF INT_FLAG THEN  RETURN END IF
 
   IF g_flag = 'Y' THEN
      CONSTRUCT g_wc2 ON cjp04,cjp05,cjp06
               FROM s_cjp[1].cjp04,s_cjp[1].cjp05,s_cjp[1].cjp06
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
      LET g_sql = "SELECT UNIQUE cjp01,cjp02,cjp03 FROM cjp_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY cjp02,cjp03,cjp01"
       LET l_sql = "SELECT UNIQUE cjp01,cjp02,cjp03 FROM cjp_file ", #MOD-560157
                   " WHERE ", g_wc CLIPPED                           #MOD-560157
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE cjp01,cjp02,cjp03 ",
                  "  FROM cjp_file ",
                  " WHERE ", g_wc  CLIPPED,
                  "   AND ", g_wc2 CLIPPED,
                  " ORDER BY cjp01"
       LET l_sql = "SELECT UNIQUE cjp01,cjp02,cjp03 ",   #MOD-560157
                   "  FROM cjp_file ",                   #MOD-560157
                   " WHERE ", g_wc  CLIPPED,             #MOD-560157
                   "   AND ", g_wc2 CLIPPED              #MOD-560157
   END IF
 
   PREPARE t070_prepare FROM g_sql
   DECLARE t070_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t070_prepare
 
    #MOD-560157................begin
  #IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
  #   LET g_sql="SELECT cjp01,cjp02,cjp03 FROM cjp_file",
  #             " WHERE ",g_wc CLIPPED,
  #             " GROUP BY cjp01,cjp02,cjp03"
  #ELSE
  #   LET g_sql="SELECT cjp01,cjp02,cjp03 FROM cjp_file",
  #             " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
  #             " GROUP BY cjp01,cjp02,cjp03"
  #END IF
   DROP TABLE t070_cnttemp
   LET l_sql=l_sql," INTO TEMP t070_cnttemp"
   PREPARE t070_cnttemp_sql FROM l_sql
   EXECUTE t070_cnttemp_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t070_cnttemp',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_sql="SELECT COUNT(*) FROM t070_cnttemp"
    #MOD-560157................end
   PREPARE t070_precount FROM g_sql
   DECLARE t070_count CURSOR FOR t070_precount
END FUNCTION
 
FUNCTION t070_menu()
DEFINE l_cmd  LIKE type_file.chr1000           #No.FUN-7C0043---add---
 
   WHILE TRUE
      CALL t070_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t070_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t070_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL t070_out()   
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cjp),'','')
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_cjp01 IS NOT NULL THEN
                LET g_doc.column1 = "cjp01"
                LET g_doc.column2 = "cjp02"
                LET g_doc.column3 = "cjp03"
                LET g_doc.value1 = g_cjp01
                LET g_doc.value2 = g_cjp02
                LET g_doc.value3 = g_cjp03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0019-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t070_q()
  DEFINE l_cjp01 LIKE cjp_file.cjp01,
         l_cjp02 LIKE cjp_file.cjp02,
         l_cjp03 LIKE cjp_file.cjp03
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_cjp.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t070_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cjp01 TO NULL
        INITIALIZE g_cjp02 TO NULL
        INITIALIZE g_cjp03 TO NULL
        RETURN
    END IF
    OPEN t070_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cjp01 TO NULL
        INITIALIZE g_cjp02 TO NULL
        INITIALIZE g_cjp03 TO NULL
    ELSE
         #MOD-560157................begin
       #FOREACH t070_count INTO l_cjp01,l_cjp02,l_cjp03
       #  LET g_cnt = SQLCA.sqlerrd[3]
       #  EXIT FOREACH
       #END FOREACH
        OPEN t070_count
        IF SQLCA.sqlcode THEN
           CALL cl_err('t070_count',SQLCA.sqlcode,1)
        END IF
        FETCH t070_count INTO g_cnt
         #MOD-560157................end
        DISPLAY g_cnt TO FORMONLY.cnt  
        LET g_row_count = g_cnt
        CALL t070_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t070_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680122 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680122 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t070_cs INTO g_cjp01,g_cjp02,g_cjp03
        WHEN 'P' FETCH PREVIOUS t070_cs INTO g_cjp01,g_cjp02,g_cjp03
        WHEN 'F' FETCH FIRST    t070_cs INTO g_cjp01,g_cjp02,g_cjp03
        WHEN 'L' FETCH LAST     t070_cs INTO g_cjp01,g_cjp02,g_cjp03
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
            FETCH ABSOLUTE l_abso t070_cs INTO g_cjp01,g_cjp02,g_cjp03
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cjp01,SQLCA.sqlcode,0)
        INITIALIZE g_cjp01 TO NULL  #TQC-6B0105
        INITIALIZE g_cjp02 TO NULL  #TQC-6B0105
        INITIALIZE g_cjp03 TO NULL  #TQC-6B0105
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
 
    CALL t070_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t070_show()
    LET g_cjp01_t = g_cjp01                #保存單頭舊值
    LET g_cjp02_t = g_cjp02                #保存單頭舊值
    LET g_cjp03_t = g_cjp03                #保存單頭舊值
    DISPLAY g_cjp01 TO cjp01     # 顯示單頭值
    DISPLAY g_cjp02 TO cjp02     # 顯示單頭值
    DISPLAY g_cjp03 TO cjp03     # 顯示單頭值
    CALL t070_cjp01()
    CALL t070_sum(g_cjp01,g_cjp02,g_cjp03)
    CALL t070_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t070_b()
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
   IF cl_null(g_cjp01) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT cjp04,'',cjp05,cjp06 FROM cjp_file  ",
                      "  WHERE cjp01=? AND cjp02=? AND cjp03=? ",
                      "    AND cjp04=? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t070_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_cjp WITHOUT DEFAULTS FROM s_cjp.* 
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
             #         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   #TQC-970297                 
                      INSERT ROW=false,DELETE ROW=false,APPEND ROW=false)               #TQC-970297                                 
         
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN  
             CALL fgl_set_arr_curr(l_ac)
          END IF
      BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
        #  DISPLAY l_ac  TO FORMONLY.cn3     #TQC-970297   
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          IF g_rec_b>=l_ac THEN
             LET p_cmd = 'u'
             LET g_cjp_t.* = g_cjp[l_ac].*  #BACKUP
 
              OPEN t070_bcl USING g_cjp01 ,g_cjp02 ,g_cjp03, g_cjp_t.cjp04
 
              IF STATUS THEN
                 CALL cl_err("OPEN t070_bcl:", STATUS, 1)
                 CLOSE t070_bcl
                 ROLLBACK WORK
                 RETURN
              ELSE
                 FETCH t070_bcl INTO g_cjp[l_ac].* 
                 IF SQLCA.sqlcode THEN
                     CALL cl_err(g_cjp_t.cjp04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
                 SELECT ima02 INTO g_cjp[l_ac].ima02s
                   FROM ima_file
                  WHERE ima01 = g_cjp[l_ac].cjp04
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
      AFTER FIELD cjp06 
          IF g_cjp[l_ac].cjp06<0 THEN
             CALL cl_err(g_cjp[l_ac].cjp06,'afa-040',0)
             LET g_cjp[l_ac].cjp06 = g_cjp_t.cjp06
             DISPLAY g_cjp[l_ac].cjp06 TO cjp06
             NEXT FIELD cjp06
          END IF
 
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cjp[l_ac].* = g_cjp_t.*
             CLOSE t070_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cjp[l_ac].cjp04,-263,1)
             LET g_cjp[l_ac].* = g_cjp_t.*
          ELSE
             UPDATE cjp_file SET cjp06=g_cjp[l_ac].cjp06
              WHERE cjp01=g_cjp01 AND cjp02=g_cjp02 AND cjp03=g_cjp03
                AND cjp04=g_cjp_t.cjp04
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_cjp[l_ac].cjp04,SQLCA.sqlcode,0)   #No.FUN-660127
                CALL cl_err3("upd","cjp_file",g_cjp01,g_cjp_t.cjp04,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                LET g_cjp[l_ac].* = g_cjp_t.*
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
             IF p_cmd = 'u' THEN
                LET g_cjp[l_ac].* = g_cjp_t.*
             END IF
             CLOSE t070_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t070_bcl
          COMMIT WORK
          CALL t070_sum(g_cjp01,g_cjp02,g_cjp03)
 
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
 
   CLOSE t070_bcl
   COMMIT WORK
END FUNCTION
   
FUNCTION t070_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    CONSTRUCT l_wc2 ON cjp04,cjp05,cjp06
            FROM s_cjp[1].cjp04,s_cjp[1].cjp05,s_cjp[1].cjp06
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
    CALL t070_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t070_b_fill(p_wc2)              #BODY FILL UP
   DEFINE
        p_wc2           LIKE type_file.chr1000,       #No.FUN-680122CHAR(200)
        l_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   LET g_sql = "SELECT cjp04,ima02,cjp05,cjp06 ",
               "  FROM cjp_file LEFT OUTER JOIN ima_file ON cjp04 = ima_file.ima01",
               " WHERE cjp01 ='",g_cjp01,"'",
               "   AND cjp02 = ",g_cjp02,
               "   AND cjp03 = ",g_cjp03,
               "   AND ",p_wc2 CLIPPED,           #單身
               " ORDER BY cjp04"
 
   PREPARE t070_pb FROM g_sql
   DECLARE cjp_cs CURSOR FOR t070_pb    #SCROLL CURSOR
    
   CALL g_cjp.clear()
   LET g_cnt = 1
   LET g_rec_b=0
   FOREACH cjp_cs INTO g_cjp[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_cjp.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t070_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cjp TO s_cjp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t070_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t070_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t070_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t070_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t070_fetch('L')
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
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
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
FUNCTION t070_out()
#DEFINE
#  l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#  sr              RECORD
#      cjp01       LIKE cjp_file.cjp01,   #
#      cjp02       LIKE cjp_file.cjp02,   #
#      cjp03       LIKE cjp_file.cjp03,   #
#      cjp04       LIKE cjp_file.cjp04,   #
#      cjp05       LIKE cjp_file.cjp05,   #
#      cjp06       LIKE cjp_file.cjp06,   #
#      ima55       LIKE ima_file.ima55,
#      ima02       LIKE ima_file.ima02,   #主件編號的品名
#      ima021       LIKE ima_file.ima021,   #主件編號的
#      ima02s      LIKE ima_file.ima02,    #聯產品料號的品名
#      ima021s      LIKE ima_file.ima021    #聯產品料號的
#                  END RECORD,
#  l_name          LIKE type_file.chr20,         #No.FUN-680122CHAR(20)              #External(Disk) file name
#  l_za05          LIKE type_file.chr1000        #No.FUN-680122CHAR(40)       
        #
   DEFINE l_cmd  LIKE type_file.chr1000
   IF cl_null(g_wc) AND NOT cl_null(g_cjp01)                                    
      AND NOT cl_null(g_cjp02) AND NOT cl_null(g_cjp03) THEN                    
      LET g_wc = " cjp01 = '",g_cjp01,"' AND cjp02 = '",g_cjp02,                
                  "' AND cjp03 = '",g_cjp03,"'"                                 
   END IF                                                                       
   IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                 
   LET l_cmd = 'p_query "axct070" "',g_wc CLIPPED,'"'                           
   CALL cl_cmdrun(l_cmd)
 
#  #改成印當下的那一筆資料內容
#  IF g_wc IS NULL THEN
#     CALL cl_err('','9057',0)
#     RETURN
#      IF cl_null(g_cjp01) THEN
#         CALL cl_err('','9057',0) RETURN
#      ELSE
#         LET g_wc=" cjp01='",g_cjp01,"'"
#      END IF
#      IF NOT cl_null(g_cjp02) THEN
#         LET g_wc=g_wc," and cjp02=",g_cjp02
#      END IF
#      IF NOT cl_null(g_cjp03) THEN
#         LET g_wc=g_wc," and cjp03=",g_cjp03
#      END IF
#   END IF
 
#  CALL cl_wait()
#  CALL cl_outnam('axct070') RETURNING l_name
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#  LET g_sql="SELECT cjp01,cjp02,cjp03,cjp04,cjp05,cjp06 ",
#            "  FROM cjp_file ",
#            " WHERE ",g_wc CLIPPED
#  PREPARE t070_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE t070_co CURSOR FOR t070_p1      # CURSOR
 
#  START REPORT t070_rep TO l_name
 
#  FOREACH t070_co INTO sr.*
#     IF SQLCA.sqlcode THEN
#       CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
#     SELECT ima02,ima021,ima55 INTO sr.ima02,sr.ima021,sr.ima55  FROM ima_file
#      WHERE ima01 = sr.cjp01
#     SELECT ima02,ima021 INTO sr.ima02s,sr.ima021s FROM ima_file WHERE ima01 = sr.cjp04
#     OUTPUT TO REPORT t070_rep(sr.*)
#  END FOREACH
 
#  FINISH REPORT t070_rep
 
#  CLOSE t070_co
#  ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t070_rep(sr)
#DEFINE
#  l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(01)
#  l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#  sr              RECORD
#      cjp01       LIKE cjp_file.cjp01,   #
#      cjp02       LIKE cjp_file.cjp02,
#      cjp03       LIKE cjp_file.cjp03,   #
#      cjp04       LIKE cjp_file.cjp04,   #
#      cjp05       LIKE cjp_file.cjp05,   #
#      cjp06       LIKE cjp_file.cjp06,   #
#      ima55       LIKE ima_file.ima55,   #
#      ima02       LIKE ima_file.ima02,   #主件編號的品名
#      ima021      LIKE ima_file.ima021,  #主件編號的
#      ima02s      LIKE ima_file.ima02,    #聯產品料號的品名
#      ima021s     LIKE ima_file.ima021   #聯產品料號的
#                  END RECORD
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.cjp02,sr.cjp03,sr.cjp01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        LET g_pageno=g_pageno+1
#        LET pageno_total=PAGENO USING '<<<','/pageno'
#        PRINT g_head CLIPPED,pageno_total
#        PRINT 
#        PRINT g_dash
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#              g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#              g_x[41]
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     BEFORE GROUP OF sr.cjp02
#        PRINT COLUMN g_c[31],sr.cjp02 USING 'YY';    #No.TQC-770088 mark
#        PRINT COLUMN g_c[31],sr.cjp02 USING '####';  #No.TQC-770088
 
#     BEFORE GROUP OF sr.cjp03
#        PRINT COLUMN g_c[32],sr.cjp03 USING '##';
 
#     BEFORE GROUP OF sr.cjp01
#        PRINT COLUMN g_c[33],sr.cjp01,
#              COLUMN g_c[34],sr.ima02,
#              COLUMN g_c[35],sr.ima021,
#              COLUMN g_c[36],sr.ima55;
#        LET l_i = 1
 
#     ON EVERY ROW
#        PRINT COLUMN g_c[37],sr.cjp04,        
#              COLUMN g_c[38],sr.ima02s,
#              COLUMN g_c[39],sr.ima021s,
#              COLUMN g_c[40],sr.cjp05,
#              COLUMN g_c[41],sr.cjp06 USING '##&.&&'
#        IF l_i = 1 THEN 
#          PRINT COLUMN 07,sr.ima02;
#        END IF
#        PRINT COLUMN 38,sr.ima02s
#        LET l_i = l_i + 1
 
#     AFTER GROUP OF sr.cjp01
#        PRINT COLUMN g_c[40],g_x[9] CLIPPED,    
#              COLUMN g_c[41],GROUP SUM(sr.cjp06) USING '##&.&&'
#        SKIP 1 LINE
 
#     ON LAST ROW
#        PRINT g_dash
#        IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#NO.TQC-630166 start--
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
#           PRINT g_dash[1,g_len]
#        END IF
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[41], g_x[7] CLIPPED    #No.TQC-770088 mark
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-770088
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[41], g_x[6] CLIPPED   #No.TQC-770088 mark
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-770088
#        ELSE
#           SKIP 2 LINE
#        END IF
#END REPORT
#FUN-7C0043---END
FUNCTION t070_cjp01()
   DEFINE l_ima02  LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          l_ima55  LIKE ima_file.ima55
 
   SELECT ima02,ima021,ima55
     INTO l_ima02,l_ima021,l_ima55
     FROM ima_file
    WHERE ima01 =g_cjp01
 
   DISPLAY l_ima02  TO FORMONLY.ima02
   DISPLAY l_ima021 TO FORMONLY.ima021
   DISPLAY l_ima55  TO FORMONLY.ima55
 
END FUNCTION
 
FUNCTION t070_sum(l_cjp01,l_cjp02,l_cjp03)
   DEFINE l_cjp01 LIKE cjp_file.cjp01,
          l_cjp02 LIKE cjp_file.cjp02,
          l_cjp03 LIKE cjp_file.cjp03,
          l_sum   LIKE cjp_file.cjp06
 
   SELECT SUM(cjp06) INTO l_sum FROM cjp_file
    WHERE cjp01=l_cjp01 AND cjp02=l_cjp02 AND cjp03=l_cjp03
   IF STATUS THEN
      LET l_sum=0
   END IF
   DISPLAY l_sum TO FORMONLY.tot
END FUNCTION
 
