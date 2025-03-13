# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli701.4gl
# Descriptions...: 常用傳票額外摘要維護作業
# Date & Author..: 92/04/11 BY MAY
# Note...........: 本作業不串劃面(agli710/agli720/agli730)
# Modify.........: No:8094 03/08/26 By Wiky 當場用摘要有輸資料時會show單頭資料但如果都沒資料時就不會show
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/25 By Nicola 報表架構修改
# Modify.........: No.TQC-5C0037 05/12/08 By kevin 加入公司名稱
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _fetch() 一開始應清空key值
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-750022 07/05/09 By Lynn 復制時,輸入可用帳套,卻不讓其通過,且無任何提示
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780286 07/09/03 By Smapmin 變數名稱使用錯誤
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/01 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
    g_ahb     RECORD
                 ahb00  LIKE ahb_file.ahb00,    #帳別編號
                 ahb000 LIKE ahb_file.ahb000,   #常用傳票性質
                 ahb01  LIKE ahb_file.ahb01,    #常用傳票編號
                 ahb02  LIKE ahb_file.ahb02     #項次
              END RECORD,
    g_ahb_t   RECORD
                 ahb00  LIKE ahb_file.ahb00,    #帳別編號
                 ahb000 LIKE ahb_file.ahb000,   #常用傳票性質
                 ahb01  LIKE ahb_file.ahb01,    #常用傳票編號
                 ahb02  LIKE ahb_file.ahb02     #項次
              END RECORD,
    g_ahb01_t       LIKE ahb_file.ahb01,   #常用傳票號碼  (舊值)
    g_ahc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variagles)
        ahc03       LIKE ahc_file.ahc03,   #行序
        ahc04       LIKE ahc_file.ahc04    #重要摘要
                    END RECORD,
    g_ahc_t         RECORD                 #程式變數 (舊值)
        ahc03       LIKE ahc_file.ahc03,   #行序
        ahc04       LIKE ahc_file.ahc04    #重要摘要
                    END RECORD,
#   g_wc,g_wc2,g_sql    VARCHAR(300),
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166
    g_sql_tmp           STRING,        #No.FUN-730070
    g_bookno        LIKE ahb_file.ahb00,
    g_argv1         LIKE ahb_file.ahb00,  #No.FUN-730070
    g_argv2         LIKE ahb_file.ahb01,
    g_argv3         LIKE ahb_file.ahb000,
    g_argv4         LIKE ahb_file.ahb02,
    g_flag          LIKE type_file.chr1,           #No.FUN-680098 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5            #目前處理的ARRAY CNT        #No.FUN-680098 SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680098  INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
MAIN
DEFINE
#       l_time   LIKE type_file.chr8          #No.FUN-6A0073
   p_row,p_col LIKE type_file.num5            #No.FUN-680098 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET g_argv1  =ARG_VAL(1)          #帳別編號  #No.FUN-730070
   LET g_argv2  =ARG_VAL(2)          #常用傳票編號
   LET g_argv3  =ARG_VAL(3)          #常用傳票性質
   LET g_argv4  =ARG_VAL(4)          #項次
   LET g_ahb.ahb00 = g_argv1         #No.FUN-730070
   LET g_ahb.ahb000= g_argv3
   LET g_ahb.ahb01 = g_argv2
   LET g_ahb.ahb02 = g_argv4
   LET p_row =4  LET p_col = 30
 
   OPEN WINDOW i701_w AT p_row,p_col
     WITH FORM "agl/42f/agli701"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF (g_argv1 IS NOT NULL AND g_argv1 != ' ' )  AND  #No.FUN-730070
      (g_argv2 IS NOT NULL AND g_argv2 != ' ' )  AND
      (g_argv3 IS NOT NULL AND g_argv3 != ' ')  THEN
      LET g_flag = 'Y'
      LET g_ahb.ahb00 = g_argv1  #No.FUN-730070
      LET g_ahb.ahb000= g_argv3
      LET g_ahb.ahb01 = g_argv2
      LET g_ahb.ahb02 = g_argv4
      CALL i701_q()
      CALL i701_b()
   ELSE
      #No.FUN-730070  --Begin
      #IF g_argv1  IS NULL OR g_argv1  = ' ' THEN
      #   SELECT aaz64 INTO g_ahb.ahb00 FROM aaz_file
      #END IF
      #No.FUN-730070  --End  
      LET g_flag = 'N'
   END IF
 
   CALL i701_menu()
 
   CLOSE WINDOW i701_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i701_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_ahc.clear()
 
   IF g_flag = 'N' THEN
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_ahb.* TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON ahc00,ahc01,ahc02,ahc000,ahc03,ahc04  #No.FUN-730070
           FROM ahc00,ahc01,ahc02,ahc000,s_ahc[1].ahc03,s_ahc[1].ahc04   #No.FUN-730070
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      #No.FUN-730070  --Begin
      #IF g_wc = " 1=1" THEN
      #   LET g_wc = " ahc00 = '",g_ahb.ahb00,"' "
      #ELSE
      #   LET  g_wc = g_wc CLIPPED,"  AND ahc00 = '",g_ahb.ahb00,"'"
      #END IF
      #No.FUN-730070  --End  
   ELSE
      DISPLAY BY NAME g_ahb.ahb00,g_ahb.ahb01,g_ahb.ahb02,g_ahb.ahb000  #No.FUN-730070
      LET g_wc = " ahc01 ='",g_ahb.ahb01,"' AND " ,
                 " ahc00 = '",g_ahb.ahb00,"' AND ",
                 " ahc000= '",g_ahb.ahb000,"' AND ",
                 " ahc02 = ",g_ahb.ahb02,""
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   LET g_sql = "SELECT UNIQUE ahc00,ahc01,ahc02,ahc000 FROM ahc_file ",  #No.FUN-730070
               " WHERE ", g_wc CLIPPED
   PREPARE i701_prepare FROM g_sql
   DECLARE i701_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i701_prepare
 
   #No.FUN-730070  --Begin
   LET g_sql_tmp= "SELECT UNIQUE ahc00,ahc01,ahc02,ahc000 FROM ahc_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   INTO TEMP x"
   DROP TABLE x
   PREPARE i701_pre_x FROM g_sql_tmp   #TQC-710054
   EXECUTE i701_pre_x
   LET g_sql = "SELECT COUNT(*) FROM x"
   #No.FUN-730070  --End
   PREPARE i701_precount FROM g_sql
   DECLARE i701_count CURSOR FOR i701_precount
 
END FUNCTION
 
FUNCTION i701_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i701_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i701_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i701_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i701_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()                                                   
               THEN CALL i701_out()                                            
            END IF                                                                 
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_ahb.ahb01 IS NOT NULL THEN
                  LET g_doc.column1 = "ahb00"
                  LET g_doc.value1 = g_ahb.ahb00
                  LET g_doc.column2 = "ahb000"
                  LET g_doc.value2 = g_ahb.ahb000
                  LET g_doc.column3 = "ahb01"
                  LET g_doc.value3 = g_ahb.ahb01
                  LET g_doc.column4 = "ahb02"
                  LET g_doc.value4 = g_ahb.ahb02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ahb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i701_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ahc.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i701_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i701_count
   FETCH i701_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i701_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ahb.* TO NULL
   ELSE
      CALL i701_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i701_fetch(p_flag)
DEFINE p_flag        LIKE type_file.chr1,      #處理方式        #No.FUN-680098 VARCHAR(1)
       l_agso        LIKE type_file.num10      #絕對的筆數      #No.FUN-680098 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i701_cs INTO g_ahb.ahb00,g_ahb.ahb01,  #No.FUN-730070
                                           g_ahb.ahb02,g_ahb.ahb000
      WHEN 'P' FETCH PREVIOUS i701_cs INTO g_ahb.ahb00,g_ahb.ahb01,  #No.FUN-730070
                                           g_ahb.ahb02,g_ahb.ahb000
      WHEN 'F' FETCH FIRST    i701_cs INTO g_ahb.ahb00,g_ahb.ahb01,  #No.FUN-730070
                                           g_ahb.ahb02,g_ahb.ahb000
      WHEN 'L' FETCH LAST     i701_cs INTO g_ahb.ahb00,g_ahb.ahb01,  #No.FUN-730070
                                           g_ahb.ahb02,g_ahb.ahb000
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
 
         FETCH ABSOLUTE g_jump i701_cs INTO g_ahb.ahb00,g_ahb.ahb01,  #No.FUN-730070
                                              g_ahb.ahb02,g_ahb.ahb000
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode = 100 THEN
      IF (  NOT cl_null(g_argv2) OR NOT cl_null(g_argv3)
         OR NOT cl_null(g_argv4) OR NOT cl_null(g_argv1)) THEN  #No.FUN-730070
         LET g_ahb.ahb00 = g_argv1  #No.FUN-730070
         LET g_ahb.ahb000= g_argv3
         LET g_ahb.ahb01 = g_argv2
         LET g_ahb.ahb02 = g_argv4
         CALL i701_show()
         RETURN
      ELSE
         LET g_msg=g_ahb.ahb01 CLIPPED CLIPPED
         CALL cl_err(g_msg,SQLCA.sqlcode,0)
         #No.FUN-6B0040---------add------str---
         INITIALIZE g_ahb.* TO NULL
         #LET g_ahb.ahb00 = g_argv1                       #No.FUN-730070
         #IF g_argv1 IS NULL OR g_argv1 = ' ' THEN        #No.FUN-730070
         #   SELECT aaz64 INTO g_ahb.ahb00 FROM aaz_file  #No.FUN-730070
         #END IF                                          #No.FUN-730070
         LET g_flag = 'N'
         #No.FUN-6B0040---------add------end---
         RETURN
      END IF
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
   END IF
 
   CALL i701_show()
 
END FUNCTION
 
FUNCTION i701_show()
 
   LET g_ahb_t.* = g_ahb.*                #保存單頭舊值
   DISPLAY g_ahb.ahb00 TO ahc00   #No.FUN-730070
   DISPLAY g_ahb.ahb01 TO ahc01
   DISPLAY g_ahb.ahb000 TO ahc000
   DISPLAY g_ahb.ahb02 TO ahc02
 
   CALL i701_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i701_b()
DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680098  SMALLINT
       l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680098   SMALLINT
       l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680098   VARCHAR(1)
       p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680098   VARCHAR(1)
       l_flag          LIKE type_file.chr1,      #判斷必要欄位是否有輸入        #No.FUN-680098 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,      #可新增否        #No.FUN-680098 SMALLINT
       l_allow_delete  LIKE type_file.num5       #可刪除否        #No.FUN-680098 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_aglshut(0) THEN RETURN END IF                #檢查權限
 
   IF g_ahb.ahb01 IS NULL OR g_ahb.ahb00 IS NULL THEN  #No.FUN-730070
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ahc03,ahc04 FROM ahc_file",
                      "  WHERE ahc01=? AND ahc02 =? AND ahc00 =?",
                      "   AND ahc000=? AND ahc03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i701_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ahc WITHOUT DEFAULTS FROM s_ahc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_ahc_t.* = g_ahc[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i701_bcl USING g_ahb.ahb01,g_ahb.ahb02,g_ahb.ahb00,g_ahb.ahb000,g_ahc_t.ahc03
            IF STATUS THEN
               CALL cl_err("OPEN i701_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
 
            FETCH i701_bcl INTO g_ahc[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ahc_t.ahc03,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ahc[l_ac].* TO NULL      #900423
         LET g_ahc_t.* = g_ahc[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ahc03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO ahc_file(ahc00,ahc000,ahc01,ahc02,ahc03,ahc04,ahclegal) #FUN-980003 add legal
              VALUES(g_ahb.ahb00,g_ahb.ahb000,g_ahb.ahb01,g_ahb.ahb02,
                     g_ahc[l_ac].ahc03,g_ahc[l_ac].ahc04,g_legal)  #FUN-980003 add legal
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ahc[l_ac].ahc03,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","ahc_file",g_ahb.ahb01,g_ahb.ahb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD ahc03                        #default 序號
         IF cl_null(g_ahc[l_ac].ahc03) OR g_ahc[l_ac].ahc03 = 0 THEN
            SELECT max(ahc03)+1
              INTO g_ahc[l_ac].ahc03
              FROM ahc_file
             WHERE ahc01 = g_ahb.ahb01
               AND ahc02 = g_ahb.ahb02
               AND ahc00 = g_ahb.ahb00
               AND ahc000 = g_ahb.ahb000
            IF g_ahc[l_ac].ahc03 IS NULL THEN
               LET g_ahc[l_ac].ahc03 = 1
            END IF
         END IF
 
      AFTER FIELD ahc03                        #check 序號是否重複
         IF NOT cl_null(g_ahc[l_ac].ahc03) THEN
            IF g_ahc[l_ac].ahc03 != g_ahc_t.ahc03 OR cl_null(g_ahc_t.ahc03) THEN
               SELECT count(*)
                 INTO l_n
                 FROM ahc_file
                WHERE ahc01 = g_ahb.ahb01
                  AND ahc02 = g_ahb.ahb02
                  AND ahc03 = g_ahc[l_ac].ahc03
                  AND ahc00 = g_ahb.ahb00
                  AND ahc000 = g_ahb.ahb000
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ahc[l_ac].ahc03 = g_ahc_t.ahc03
                  NEXT FIELD ahc03
               END IF
            END IF
            LET g_cnt = g_cnt + 1
            DISPLAY l_ac TO FORMONLY.cn3
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ahc_t.ahc03 > 0 AND g_ahc_t.ahc03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            #No.FUN-730070  --Begin
            DELETE FROM ahc_file
             WHERE ahc01 = g_ahb.ahb01
               AND ahc00 = g_ahb.ahb00
               AND ahc000= g_ahb.ahb000
               AND ahc02 = g_ahb.ahb02
               AND ahc03 = g_ahc_t.ahc03
            #No.FUN-730070  --End  
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahc_t.ahc03,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","ahc_file",g_ahb.ahb01,g_ahc_t.ahc03,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ahc[l_ac].* = g_ahc_t.*
            CLOSE i701_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ahc[l_ac].ahc03,-263,1)
            LET g_ahc[l_ac].* = g_ahc_t.*
         ELSE
            UPDATE ahc_file SET ahc03 = g_ahc[l_ac].ahc03,
                                ahc04 = g_ahc[l_ac].ahc04
             WHERE ahc01 = g_ahb.ahb01
               AND ahc02 = g_ahb.ahb02
               AND ahc00 = g_ahb.ahb00
               AND ahc000= g_ahb.ahb000
               AND ahc03 = g_ahc_t.ahc03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ahc[l_ac].ahc03,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","ahc_file",g_ahb.ahb01,g_ahb.ahb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_ahc[l_ac].* = g_ahc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ahc[l_ac].* = g_ahc_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_ahc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i701_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add
         CLOSE i701_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ahc03) AND l_ac > 1 THEN
            LET g_ahc[l_ac].* = g_ahc[l_ac-1].*
            LET g_ahc[l_ac].ahc03 = NULL   #TQC-620018
            NEXT FIELD ahc03
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
#No.FUN-6B0029--begin
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0029--end
 
   END INPUT
 
   CLOSE i701_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i701_b_askkey()
#DEFINE l_wc2       VARCHAR(200)
DEFINE l_wc2        STRING        #TQC-630166
 
   CONSTRUCT l_wc2 ON ahc03,ahc04 FROM s_ahc[1].ahc03,s_ahc[1].ahc04
 
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
 
   CALL i701_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i701_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2      VARCHAR(200),
DEFINE p_wc2           STRING,        #TQC-630166
       l_flag          LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   LET g_sql = "SELECT ahc03,ahc04 ",
               " FROM ahc_file",
               " WHERE ahc00 = '",g_ahb.ahb00,"'",
               " AND ahc000 = '",g_ahb.ahb000,"'",
               " AND ahc01 ='",g_ahb.ahb01,"' AND ",  #單頭-1
               " ahc02 = ",g_ahb.ahb02," AND ",
               p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i701_pb FROM g_sql
   DECLARE ahc_cs CURSOR FOR i701_pb
 
   CALL g_ahc.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH ahc_cs INTO g_ahc[g_cnt].*   #單身 ARRAY 填充
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
 
   CALL g_ahc.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i701_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ahc TO s_ahc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i701_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i701_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i701_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i701_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i701_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i701_copy()
DEFINE l_ahb02 LIKE ahb_file.ahb02,
       l_newno0,l_oldno0 LIKE ahb_file.ahb00,#己存在,欲copy單身的原始編號  #No.FUN-730070
       l_newno,l_oldno   LIKE ahb_file.ahb01,#己存在,欲copy單身的原始編號
       l_newno1,l_oldno1 LIKE ahb_file.ahb02,#己存在欲copy單身的原始編號項次
       l_newno2,l_oldno2 LIKE ahb_file.ahb000 #己存在欲copy單身的原始編號性質
 
   IF s_aglshut(0) THEN RETURN END IF                #檢查權限
 
   IF g_ahb.ahb01 IS NULL OR g_ahb.ahb00 IS NULL THEN  #No.FUN-730070
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INPUT l_newno0,l_newno,l_newno1,l_newno2 FROM ahc00,ahc01,ahc02,ahc000  #No.FUN-730070
 
      #No.FUN-730070  --Begin
      AFTER FIELD ahc00
         IF l_newno0 IS NULL THEN                # No.TQC-750022
             NEXT FIELD ahc00
         END IF
      #No.FUN-730070  --End  
 
      AFTER FIELD ahc01
         IF l_newno IS NULL THEN
             NEXT FIELD ahc01
         END IF
 
      AFTER FIELD ahc02
         IF l_newno1 IS NULL THEN
             NEXT FIELD ahc02
         END IF
 
      AFTER FIELD ahc000
         IF l_newno2 IS NULL THEN
            NEXT FIELD ahc000
         END IF
 
         IF l_newno1 = 0 THEN
            SELECT count(*) INTO g_cnt
              FROM aha_file
             WHERE aha01 = l_newno
               AND aha00 = l_newno0  #No.FUN-730070
               AND aha000 = l_newno2
         ELSE
            SELECT count(*) INTO g_cnt
              FROM ahb_file
             WHERE ahb01 = l_newno
               AND ahb00 = l_newno0  #No.FUN-730070
               AND ahb000 = l_newno2
               AND ahb02 = l_newno1
         END IF
 
         IF g_cnt = 0 THEN
            CALL cl_err(l_newno,'agl-110',0)
            NEXT FIELD ahc00  #No.FUN-730070
         END IF
 
         SELECT count(*) INTO g_cnt FROM ahc_file #檢查是否己有單身資料
          WHERE ahc01 = l_newno
            AND ahc02 = l_newno1
            AND ahc000 =l_newno2
            AND ahc00 = l_newno0  #No.FUN-730070
 
         IF g_cnt > 0 THEN
            CALL cl_err('','agl-111',1)
            NEXT FIELD ahc00   #No.FUN-730070
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
 
      #-----MOD-780286---------
      #DISPLAY BY NAME g_ahb.ahb01
      #DISPLAY BY NAME g_ahb.ahb02
      #DISPLAY BY NAME g_ahb.ahb00   #No.FUN-730070
      #DISPLAY BY NAME g_ahb.ahb000  #No.FUN-730070
      DISPLAY g_ahb.ahb01 TO ahc01
      DISPLAY g_ahb.ahb02 TO ahc02
      DISPLAY g_ahb.ahb00 TO ahc00
      DISPLAY g_ahb.ahb000 TO ahc000
      #-----END MOD-780286-----
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ahc_file         #單身複製
    WHERE ahc01 = g_ahb.ahb01
      AND ahc02 = g_ahb.ahb02
      AND ahc00 = g_ahb.ahb00  #No.FUN-730070
      AND ahc000 = g_ahb.ahb000
     INTO TEMP x
 
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_ahb.ahb01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","x",g_ahb.ahb01,g_ahb.ahb02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      RETURN
   END IF
 
   UPDATE x SET ahc01 = l_newno,
                ahc00 = l_newno0,  #No.FUN-730070
                ahc02 = l_newno1,
                ahc000 = l_newno2
 
   INSERT INTO ahc_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_ahb.ahb01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","ahc_file",l_newno,l_newno1,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   #No.FUN-730070  --Begin
   LET l_oldno0= g_ahb.ahb00
   LET l_oldno = g_ahb.ahb01
   LET l_oldno1= g_ahb.ahb02
   LET l_oldno2= g_ahb.ahb000
 
   SELECT UNIQUE ahc00,ahc01,ahc02,ahc000
     INTO g_ahb.ahb00,g_ahb.ahb01,g_ahb.ahb02,g_ahb.ahb000
     FROM ahc_file
    WHERE ahc01 = l_newno
      AND ahc00 = l_newno0
      AND ahc02 = l_newno1
      AND ahc000 = l_newno2
 
   #-----MOD-780286---------
   #DISPLAY BY NAME g_ahb.ahb00
   #DISPLAY BY NAME g_ahb.ahb01
   #DISPLAY BY NAME g_ahb.ahb02
   #DISPLAY BY NAME g_ahb.ahb000
   DISPLAY g_ahb.ahb00 TO ahc00
   DISPLAY g_ahb.ahb01 TO ahc01
   DISPLAY g_ahb.ahb02 TO ahc02
   DISPLAY g_ahb.ahb000 TO ahc000
   #-----END MOD-780286-----
 
   CALL i701_b()
   #FUN-C30027---begin
   #LET g_ahb.ahb00=l_oldno0
   #LET g_ahb.ahb01=l_oldno
   #LET g_ahb.ahb02=l_oldno1
   #LET g_ahb.ahb000=l_oldno2
   #
   #SELECT UNIQUE ahc00,ahc01,ahc02,ahc000
   #  INTO g_ahb.ahb00,g_ahb.ahb01,g_ahb.ahb02,g_ahb.ahb000
   #  FROM ahc_file
   # WHERE ahc01 = l_oldno
   #   AND ahc00 = l_oldno0
   #   AND ahc02 = l_oldno1
   #   AND ahc000 = l_oldno2
   #FUN-C30027---end
   #No.FUN-730070  --End  
 
   CALL i701_show()
 
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION i701_out()
#DEFINE l_i             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
#      sr              RECORD
#          ahb00       LIKE ahb_file.ahb00,   #No.FUN-730070
#          ahb01       LIKE ahb_file.ahb01,   #簽核等級
#          ahb02       LIKE ahb_file.ahb02,
#          ahc03       LIKE ahc_file.ahc03,   #行序號
#          ahc04       LIKE ahc_file.ahc04,   #摘要
#          ahc000      LIKE ahc_file.ahc000   #
#                      END RECORD,
#      l_name          LIKE type_file.chr20         #No.FUN-680098  VARCHAR(20)
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-820002                                                                  
   IF cl_null(g_wc) AND NOT cl_null(g_ahb.ahb00) AND NOT cl_null(g_ahb.ahb000)                                                      
                    AND NOT cl_null(g_ahb.ahb01) AND NOT cl_null(g_ahb.ahb02)                                                       
      THEN LET g_wc = " ahb01 = '",g_ahb.ahb01,"' AND ahb02 = '",g_ahb.ahb02,"'                                                     
                        AND ahb00 = '",g_ahb.ahb00,"' AND ahb000 = '",g_ahb.ahb000,"'"                                              
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
   LET l_cmd = 'p_query "agli701" "',g_wc CLIPPED,'"'                                                                               
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN   
#  IF g_wc IS NULL THEN
#     CALL cl_err('','9057',0)
#     RETURN
#  END IF
 
#  CALL cl_wait()
#  CALL cl_outnam('agli701') RETURNING l_name
#No.TQC-5C0037 start
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#  #SELECT aaf03 INTO g_company FROM aaf_file
#  # WHERE aaf01 = g_bookno
#  #   AND aaf02 = g_lang
#No.TQC-5C0037 end
#  LET g_sql="SELECT ahc00,ahc01,ahc02,ahc03,ahc04,ahc000",  #No.FUN-730070
#            "  FROM ahc_file ",
#            " WHERE ",g_wc CLIPPED
#  PREPARE i701_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i701_co CURSOR FOR i701_p1
 
#  CALL cl_outnam('agli701') RETURNING l_name
#  START REPORT i701_rep TO l_name
 
#  FOREACH i701_co INTO sr.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
 
#     OUTPUT TO REPORT i701_rep(sr.*)
 
#  END FOREACH
 
#  FINISH REPORT i701_rep
 
#  CLOSE i701_co
#  ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT i701_rep(sr)
#DEFINE l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
#      l_i             LIKE type_file.num5,          #No.FUN-680098 SMALLINT
#      sr              RECORD
#          ahc00       LIKE ahb_file.ahb00,   #No.FUN-730070
#          ahc01       LIKE ahb_file.ahb01,   #簽核等級
#          ahc02       LIKE ahb_file.ahb02,   #簽核說明
#          ahc03       LIKE ahc_file.ahc03,
#          ahc04       LIKE ahc_file.ahc04,
#          ahc000      LIKE ahc_file.ahc000
#                      END RECORD
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.ahc00,sr.ahc000,sr.ahc01,sr.ahc02,sr.ahc03  #No.FUN-730070
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]  #No.FUN-730070
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     #No.FUN-730070  --Begin
#     BEFORE GROUP OF sr.ahc00
#        PRINT COLUMN g_c[31],sr.ahc00 CLIPPED;
 
#     BEFORE GROUP OF sr.ahc000
#        PRINT COLUMN g_c[32],sr.ahc000 CLIPPED;
 
#     BEFORE GROUP OF sr.ahc01
#        PRINT COLUMN g_c[33],sr.ahc01 CLIPPED;
 
#     BEFORE GROUP OF sr.ahc02
#        PRINT COLUMN g_c[34],sr.ahc02 USING "###&";  #No.TQC-5C0037 #FUN-590118
 
#     BEFORE GROUP OF sr.ahc03
#        PRINT COLUMN g_c[35],sr.ahc03 USING "###&";  #No.TQC-5C0037 #FUN-590118
 
#     ON EVERY ROW
#        PRINT COLUMN g_c[36],sr.ahc04 CLIPPED
#     #No.FUN-730070  --End
 
#     ON LAST ROW
#        PRINT g_dash[1,g_len]
#        IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
#           #TQC-630166
#           #IF g_wc[001,080] > ' ' THEN
#           #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#           #         COLUMN g_c[32],g_wc[001,070] CLIPPED
#           #END IF
#           #IF g_wc[071,140] > ' ' THEN
#           #   PRINT COLUMN g_c[32],g_wc[071,140] CLIPPED
#           #END IF
#           #IF g_wc[141,210] > ' ' THEN
#           #   PRINT COLUMN g_c[32],g_wc[141,210] CLIPPED
#           #END IF
#           CALL cl_prt_pos_wc(g_wc)
#           PRINT g_dash[1,g_len]
#        END IF
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-820002--end--
