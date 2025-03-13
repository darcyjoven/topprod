# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: p_openin.4gl
# Descriptions...: 開帳資料匯入作業
# Input parameter:
# Date & Author..: FUN-810012 08/03/13 By ice 作業新增
# Modify.........: No.FUN-890131 08/09/30 By Nicola 日期抓取碼數修改
# Modify.........: No.TQC-8A0003 08/10/01 By ching  Debug
# Modify.........: No.FUN-8A0021 08/10/07 By douzh 欄位/字段若型態為日期,
#                  且資料類型為1.預設值,則自動給資料預設值為當天日期
#                  08/11/12 By douzh  第二單身新增'選擇'欄位
# Modify.........: No.FUN-8A0050 08/10/09 By Nicola 改用csv的方式匯入資料
#                                09/01/07 By Nicola 改用unicode 文字檔匯入資料
# Modify.........: No.FUN-910030 09/01/13 By douzh 加上運行前開啟aoos901和選擇資料庫功能
# Modify.........: No.MOD-960087 09/06/22 By liuxqa 如果導入的資料的KEY值為空格時，應該可以導入。
# Modify.........: No.FUN-980014 09/08/04 By rainy GP5.2 新增抓取 g_legal 值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-9B0066 09/11/10 By douzh  轉換日期格式建議使用 Genero operator
# Modify.........: No.FUN-9C0147 09/12/24 By mike 调整to_date()写法 
# Modify.........: No.TQC-A10010 10/01/06 By Dido 調整 \n 因轉出 excel 時會變成 , 導致誤解語法有誤 
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No.FUN-A40042 10/04/26 By chenmoyan 單身的資料要對應到單頭
# Modify.........: No.MOD-AB0095 10/11/10 By sabrina 將不是DISPLAY到畫面上的DISPLAY mark掉
# Modify.........: No.FUN-A90024 10/12/02 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B30219 11/04/13 By chenmoyan 去除DUAL
# Modify.........: No:CHI-B50010 11/05/19 By JoHung 統一由shell撰寫iconv由UNICODE轉UTF-8語法
# Modify.........: No.FUN-B80037 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No:MOD-B80338 11/09/03 By johung 單身二加上勾選時「本次匯入檔名」必填
#                                                   單身二控卡aaz-540前先判斷是否勾選
# Modify.........: No.FUN-B90041 11/09/05 By minpp 程序撰写规范修改
# Modify.........: No:TQC-C50193 12/06/19 By Elise show SQLCA.SQLERRD[2]部分改show SQLCA.SQLCODE
# Modify.........: No:MOD-C70294 12/07/30 By suncx 日期字段預設sysdate時，取值錯誤
# Modify.........: No:FUN-9B0110 12/07/30 By Sakura 改為從第9行開始抓值
# Modify.........: No:MOD-C80086 12/08/13 By Smapmin 無法新增記錄檔,因為zod02序號為空
# Modify.........: No:MOD-CA0006 12/10/12 By Elise 修改ls_value1為null判斷
# Modify.........: No:MOD-D10024 13/01/31 By jt_chen 資料匯入都須輸入匯入序號

IMPORT os    #FUN-A30038
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_zoa           DYNAMIC ARRAY OF RECORD 
        zoa01       LIKE zoa_file.zoa01,   #資料型態
        zoa03       LIKE zoa_file.zoa03,   #資料代碼
        gaz03       LIKE gaz_file.gaz03,   #資料內容
        zoa05       LIKE zoa_file.zoa05,   #最後匯入日期
        zoa06       LIKE zoa_file.zoa06    #最後匯入者
                    END RECORD,
    g_zoa_t         RECORD                 #程式變數 (舊值)
        zoa01       LIKE zoa_file.zoa01,   #資料型態
        zoa03       LIKE zoa_file.zoa03,   #資料代碼
        gaz03       LIKE gaz_file.gaz03,   #資料內容
        zoa05       LIKE zoa_file.zoa05,   #最後匯入日期
        zoa06       LIKE zoa_file.zoa06    #最後匯入者
                    END RECORD,
    g_zoa_1         DYNAMIC ARRAY OF RECORD 
        zoa03       LIKE zoa_file.zoa03,   #資料代碼
        gaz03       LIKE gaz_file.gaz03,   #資料內容
        zoc02       LIKE zoc_file.zoc02,   #檔案代碼
        gat01       LIKE gat_file.gat01,   #資料判斷檔案
        sum_01      LIKE type_file.num5    #目前筆數
                    END RECORD,
    g_zoa_1_t       RECORD 
        zoa03       LIKE zoa_file.zoa03,   #資料代碼
        gaz03       LIKE gaz_file.gaz03,   #資料內容
        zoc02       LIKE zoc_file.zoc02,   #檔案代碼
        gat01       LIKE gat_file.gat01,   #資料判斷檔案
        sum_01      LIKE type_file.num5    #目前筆數
                    END RECORD,
    g_zob           DYNAMIC ARRAY OF RECORD 
        c           LIKE type_file.chr1,   #選擇
        zob02       LIKE zob_file.zob02,   #檔案代碼
        gat03       LIKE gat_file.gat03,   #檔案名稱
        count       LIKE type_file.num10,  #檔案筆數
        f_name      LIKE type_file.chr50   #本次匯入檔名
                    END RECORD,
    g_zob_t         RECORD                 #程式變數 (舊值)
        c           LIKE type_file.chr1,   #選擇
        zob02       LIKE zob_file.zob02,   #檔案代碼
        gat03       LIKE gat_file.gat03,   #檔案名稱
        count       LIKE type_file.num10,  #檔案筆數
        f_name      LIKE type_file.chr50   #本次匯入檔名
                    END RECORD,
    g_ss            LIKE type_file.chr1,
    g_wc,g_sql      STRING,
    g_wc2           STRING,
    g_rec_b         LIKE type_file.num5,   #單身筆數
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT
    l_ac_t          LIKE type_file.num5,   #目前處理的ARRAY CNT
    l_ac_o          LIKE type_file.num5,   #目前處理的舊值
    g_rec_b2        LIKE type_file.num5,   #單身筆數
    l_ac2           LIKE type_file.num5,   #目前處理的ARRAY CNT
    l_ac_3          LIKE type_file.num5,   #目前處理的ARRAY CNT 基本資料狀態
    l_ac_3_t        LIKE type_file.num5    #目前處理的ARRAY CNT 基本資料狀態
 
#主程式開始
DEFINE g_forupd_sql         STRING
DEFINE g_sql_tmp            STRING
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_cnt1               LIKE type_file.num10  # 單身1的筆數
DEFINE g_i                  LIKE type_file.num5
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_str                STRING            
DEFINE g_total_row        LIKE type_file.num10   #No.FUN-8A0050 
DEFINE lr_err       DYNAMIC ARRAY OF RECORD
               line         STRING,
               key1         STRING,
               err          STRING
                        END RECORD
DEFINE li_k                 LIKE type_file.num10
DEFINE g_no                 LIKE zod_file.zod02
DEFINE l_err_cnt            LIKE type_file.num5
DEFINE l_no_b               LIKE pmw_file.pmw01   #起始單號
DEFINE l_no_e               LIKE pmw_file.pmw01   #截止單號
DEFINE l_old_no             LIKE type_file.chr50  #舊系統單號
DEFINE l_old_no_b           LIKE type_file.chr50  #舊系統單號 __起
DEFINE l_old_no_e           LIKE type_file.chr50  #舊系統單號 __訖
DEFINE ls_sql1              STRING  #導入的Excle的欄位組成的字符串
DEFINE ls_sql2              STRING  #導入的Excle的欄位值組成的字符串
DEFINE ls_sql3              STRING  #表中非導入的Excle的欄位組成的字符串
DEFINE ls_sql4              STRING  #表中非導入的Excle的欄位值組成的字符串
DEFINE g_db_type            LIKE type_file.chr3   #No.FUN-910030
DEFINE g_pid                STRING                #No.FUN-910030
DEFINE g_tcp_servername     LIKE type_file.chr30  #No.FUN-910030
 
MAIN
   DEFINE p_row,p_col     LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_db_type = cl_db_get_database_type()        #No.FUN-910030
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pid= FGL_GETPID()                        #No.FUN-910030
   LET p_row = 4 LET p_col = 30
 
   OPEN WINDOW p_open_w AT p_row,p_col
        WITH FORM "azz/42f/p_openin"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p_openin_select_db("close")      #No.FUN-910030
 
   CALL p_openin_q()                     #No.FUN-910030
 
   CALL p_openin_menu()
 
   CLOSE WINDOW p_open_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION p_openin_curs()
 
   CLEAR FORM                             #清除畫面
   CALL g_zoa.clear()
   CALL g_zob.clear()
 
   CONSTRUCT g_wc ON zoa01,zoa03,zoa05,zoa06
                FROM s_zoa[1].zoa01,s_zoa[1].zoa03,
                     s_zoa[1].zoa05,s_zoa[1].zoa06
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
        CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   #No.FUN-910030--begin
   CONSTRUCT g_wc2 ON zob02 
        FROM s_zob[1].zob02
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   #No.FUN-910030--end
 
   IF INT_FLAG THEN RETURN END IF
 
   IF cl_null(g_wc2) THEN LET g_wc2= " 1=1" END IF    #No.FUN-910030
   CALL p_openin_b_fill(g_wc,g_wc2)                   #No.FUN-910030
   LET l_ac = 1                                       #No.FUN-910030
   CALL p_openin_b_fill2(" 1=1")                      #No.FUN-910030
 
   LET l_ac_o = 0
 
END FUNCTION
 
FUNCTION p_openin_menu()
 
   WHILE TRUE
      CALL p_openin_bp("G")
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_openin_q()
            END IF
 
#No.FUN-910030--begin
        WHEN "select_db"
           IF cl_chk_act_auth() THEN
              CALL p_openin_select_db("continue") 
              CALL p_openin_q()
           END IF
#No.FUN-910030--end
 
         WHEN "detail_2"
            IF cl_chk_act_auth() THEN
               CALL p_openin_b2()
            END IF
 
         WHEN "base_info"
            IF cl_chk_act_auth() THEN
               CALL p_openin_base_info()
            END IF   
 
         WHEN "getfromexcel"
            IF cl_chk_act_auth() THEN
               CALL p_openin_getfromexcel()
            END IF   
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zoa),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION p_openin_q()
 
   CALL p_openin_curs()                          #取得查詢條件
 
END FUNCTION
 
#FUNCTION p_openin_b_fill(p_wc)                   #BODY FILL UP   #No.FUN-910030
FUNCTION p_openin_b_fill(p_wc,p_wc2)              #BODY FILL UP   #No.FUN-910030
   DEFINE p_wc     STRING
   DEFINE p_wc2    STRING                         #No.FUN-910030
   DEFINE l_i      LIKE type_file.num10           #No.FUN-910030
 
   IF p_wc2 = " 1=1" THEN                         #No.FUN-910030
      LET g_sql ="SELECT zoa01,zoa03,'',zoa05,zoa06 ",
                 "  FROM zoa_file ",
                 " WHERE ",p_wc CLIPPED,
                 " ORDER BY zoa01,zoa03"
#No.FUN-910030--begin
   ELSE
      LET g_sql ="SELECT zoa01,zoa03,'',zoa05,zoa06 ",
                 "  FROM zoa_file,zob_file ",
                 "   WHERE zob01=zoa03",
                 "   AND ",p_wc2 CLIPPED,
                 " ORDER BY zoa01,zoa03"
   END IF
#No.FUN-910030--end
 
   PREPARE p_openin_p2 FROM g_sql      #預備一下
   DECLARE zoa_curs CURSOR FOR p_openin_p2
 
   CALL g_zoa.clear()
 
   LET g_cnt1 = 1
   FOREACH zoa_curs INTO g_zoa[g_cnt1].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p_openin_zoa03('d',g_cnt1)
      
      LET g_cnt1 = g_cnt1 + 1 
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_zoa.deleteElement(g_cnt1)
   LET g_rec_b = g_cnt1 - 1
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_openin_zoa03(p_cmd,p_ac)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gaz03   LIKE gaz_file.gaz03   
   DEFINE p_ac      LIKE type_file.num5
 
   IF cl_null(p_ac) OR p_ac < 1 THEN
      RETURN
   END IF
 
   LET g_errno = ' '
   SELECT gaz03 INTO l_gaz03
     FROM gaz_file 
    WHERE gaz01 = g_zoa[p_ac].zoa03
      AND gaz02 = g_lang   
 
   CASE
       WHEN STATUS=100      LET g_errno = 100
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   IF NOT cl_null(g_errno) THEN 
      LET l_gaz03 = NULL
      LET g_zoa[p_ac].gaz03 = NULL
   END IF
   IF p_cmd = 'd' OR g_errno IS NULL THEN
      LET g_zoa[p_ac].gaz03 = l_gaz03
   END IF
   DISPLAY BY NAME g_zoa[p_ac].gaz03
 
END FUNCTION
 
FUNCTION p_openin_b_fill2(p_wc2)              #BODY FILL UP
   DEFINE p_wc2     STRING
   DEFINE l_sql     STRING
 
   CALL g_zob.clear()
 
   IF g_zoa[l_ac].zoa03 IS NULL THEN
      RETURN
   END IF
 
   LET g_sql ="SELECT 'N',zob02,'','','' ",  #No.FUN-8A0021 #新增選擇匯入的欄位 
              "  FROM zob_file ",
              " WHERE zob01 = '",g_zoa[l_ac].zoa03,"'",
              "   AND ",p_wc2 CLIPPED,
              " ORDER BY zob02"
 
   PREPARE p_openin_pb2 FROM g_sql      #預備一下
   DECLARE zob_curs CURSOR FOR p_openin_pb2
 
   LET g_cnt = 1
   FOREACH zob_curs INTO g_zob[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL p_openin_zob02('d',g_cnt)
 
      LET l_sql = "SELECT COUNT(*) FROM ",g_zob[g_cnt].zob02
      PREPARE count_zob02 FROM l_sql
      EXECUTE count_zob02 INTO g_zob[g_cnt].count
 
      IF cl_null(g_zob[g_cnt].count) THEN
         LET g_zob[g_cnt].count = 0
      END IF
 
      LET g_cnt = g_cnt + 1 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zob.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn4
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_openin_zob02(p_cmd,p_ac)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gat03   LIKE gat_file.gat03   
   DEFINE p_ac      LIKE type_file.num5
 
   IF cl_null(p_ac) OR p_ac < 1 THEN
      RETURN
   END IF
 
   LET g_errno = ' '
   SELECT gat03 INTO l_gat03
     FROM gat_file 
    WHERE gat01 = g_zob[p_ac].zob02
      AND gat02 = g_lang   
 
   CASE
       WHEN STATUS=100      LET g_errno = 100
       OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   IF NOT cl_null(g_errno) THEN 
      LET l_gat03 = NULL
      LET g_zob[p_ac].gat03 = NULL
   END IF
   IF p_cmd = 'd' OR g_errno IS NULL THEN
      LET g_zob[p_ac].gat03 = l_gat03
   END IF
   DISPLAY BY NAME g_zob[p_ac].gat03
END FUNCTION
 
FUNCTION p_openin_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zoa TO s_zoa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         IF cl_null(l_ac_o) OR l_ac_o <> l_ac THEN
            CALL p_openin_b_fill2(" 1=1")
            CALL p_openin_bp2_refresh()
            LET l_ac_o = l_ac
         END IF
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
#No.FUN-910030--begin
       ON ACTION select_db
          LET g_action_choice="select_db"
          EXIT DISPLAY
#No.FUN-910030--end
 
      ON ACTION detail_2
         LET g_action_choice="detail_2"
         LET l_ac_t = l_ac
         EXIT DISPLAY
 
      ON ACTION base_info
         LET g_action_choice = 'base_info'
         EXIT DISPLAY
 
      ON ACTION getfromexcel
         LET g_action_choice = 'getfromexcel'
         EXIT DISPLAY
 
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_openin_bp2_refresh()
 
   DISPLAY ARRAY g_zob TO s_zob.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
END FUNCTION
 
#單身二
FUNCTION p_openin_b2()
   DEFINE l_ac2_t         LIKE type_file.num5            #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5            #檢查重復用       
   DEFINE l_lock_sw       LIKE type_file.chr1            #單身鎖住否       
   DEFINE p_cmd           LIKE type_file.chr1            #處理狀態         
   DEFINE l_allow_insert  LIKE type_file.num5            #可新增否         
   DEFINE l_allow_delete  LIKE type_file.num5            #可刪除否         
   DEFINE l_zoa03         LIKE zoa_file.zoa03
 
   LET g_action_choice = ""
 
   IF l_ac > 0 THEN
      LET l_zoa03 = g_zoa[l_ac].zoa03
   ELSE
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_ac2_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_zob WITHOUT DEFAULTS FROM s_zob.*
       ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b2!=0 THEN
             CALL fgl_set_arr_curr(l_ac2)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac2 = ARR_CURR()
          LET l_lock_sw = 'N'   
          LET l_n  = ARR_COUNT()
          IF g_zob[l_ac2].c = 'N' THEN
             CALL cl_set_comp_entry("f_name",FALSE)  
          ELSE
             CALL cl_set_comp_entry("f_name",TRUE)  
          END IF
 
         #SELECT COUNT(*) INTO g_zob[l_ac2].count
         #  FROM g_zob[l_ac2].zob02
         #
         #IF cl_null(g_zob[l_ac2].count) THEN
         #   LET g_zob[l_ac2].count = 0
         #END IF
 
          IF g_rec_b2 >= l_ac2 THEN
             LET p_cmd='u'
             LET g_zob_t.* = g_zob[l_ac2].*  #BACKUP
          END IF
 
#No.FUN-8A0021--begin
      #AFTER FIELD c
       ON CHANGE c   #No.FUN-8A0050
          IF cl_null(g_zob[l_ac2].c) THEN
             LET g_zob[l_ac2].c='N'
             DISPLAY g_zob[l_ac2].c TO FORMONLY.c
          ELSE
             IF g_zob[l_ac2].c = 'N' THEN
                CALL cl_set_comp_entry("f_name",FALSE)  
             ELSE
                CALL cl_set_comp_entry("f_name",TRUE)  
             END IF
          END IF
#No.FUN-8A0021--end
 
       AFTER FIELD f_name
          IF cl_null(g_zob[l_ac2].f_name) THEN
#No.FUN-8A0021--begin
             IF g_zob[l_ac2].c = 'Y' THEN
                CALL cl_err(g_zob[l_ac2].f_name,'azz-527',0)
                LET g_zob[l_ac2].f_name = g_zob_t.f_name
                NEXT FIELD f_name
             END IF
#No.FUN-8A0021--end
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_zob[l_ac2].* = g_zob_t.*
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_zob[l_ac2].zob02,-263,1)
             LET g_zob[l_ac2].* = g_zob_t.*
          ELSE
          END IF
 
       AFTER ROW
          LET l_ac2 = ARR_CURR()
          LET l_ac2_t = l_ac2
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_zob[l_ac2].* = g_zob_t.*
             END IF
             EXIT INPUT
          END IF
#MOD-B80338 -- begin --
          IF l_ac2 <= g_zob.getLength() THEN
             IF cl_null(g_zob[l_ac2].f_name) THEN
                IF g_zob[l_ac2].c = 'Y' THEN
                   CALL cl_err(g_zob[l_ac2].f_name,'azz-527',0)
                   LET g_zob[l_ac2].f_name = g_zob_t.f_name
                   NEXT FIELD f_name
                END IF
             END IF
          END IF
#MOD-B80338 -- end --
 
       #-----No.FUN-8A0050-----
       ON ACTION CONTROLP
          IF INFIELD(f_name) THEN
             CALL p_openin_load(g_zob[l_ac2].zob02) RETURNING g_zob[l_ac2].f_name
             DISPLAY BY NAME g_zob[l_ac2].f_name
          END IF
       #-----No.FUN-8A0050 END-----
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
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
   
END FUNCTION
 
FUNCTION p_openin_getfromexcel()
   DEFINE l_zoa03   LIKE zoa_file.zoa03
   DEFINE l_zob02   LIKE zob_file.zob02
   DEFINE l_zob02_1 LIKE zob_file.zob02
   DEFINE l_fname   LIKE type_file.chr50  #本次匯入檔名
   DEFINE li_i      LIKE type_file.num5
   DEFINE li_i_sum  LIKE type_file.num5
   DEFINE li_n      LIKE type_file.num5   #讀入資料筆數
   DEFINE l_str     STRING
   DEFINE l_err     LIKE type_file.chr50
   DEFINE l_n       LIKE type_file.num5            #檢查重復用       
   DEFINE l_zoa07   LIKE zoa_file.zoa07
   DEFINE l_choice  LIKE type_file.chr50  #本次是否匯入選擇  #No.FUN-8A0021
 
   CALL fgl_set_arr_curr(l_ac)
 
   IF l_ac = 0 THEN
      LET l_ac = 1
   END IF
 
   LET l_zoa03 = g_zoa[l_ac].zoa03
 
   BEGIN WORK
 
#  CALL cl_progress_bar(g_zob.getLength())   #No.FUN-8A0050 Mark
 
   CALL lr_err.clear()   #No.FUN-8A0050
 
   LET g_total_row = 0   #No.FUN-8A0050 
 
   LET g_success = 'Y'
 
   LET li_i_sum = 0
 
   LET li_k = 1
 
   FOR li_i = 1 TO g_zob.getLength()
      LET l_choice= g_zob[li_i].c
      LET l_zob02 = g_zob[li_i].zob02
      LET l_fname = g_zob[li_i].f_name
 
#MOD-B80338 -- begin --
      IF l_choice = 'N' THEN
         CONTINUE FOR
      END IF
#MOD-B80338 -- end --
      #-----No.FUN-8A0050-----
      #沒有定義"匯入序號"存放欄位不可匯入
      SELECT COUNT(*) INTO l_n FROM zoc_file
       WHERE zoc01 = l_zob02
         AND zoc05 = '6'
      IF l_n = 0 THEN
         IF NOT cl_confirm("azz-540") THEN
          # CALL cl_err(l_zob02,'azz-521',1)
          # CONTINUE FOR
            EXIT FOR
         END IF
      END IF
      #-----No.FUN-8A0050 END-----
 
      #判斷是否是zob_file資料的第一筆
      CALL p_openin_first_zob(l_zoa03)
         RETURNING l_zob02_1
     #IF cl_null(g_no) THEN   #MOD-C80086   #MOD-D10024 mark
     #IF li_i = 1 THEN   #MOD-C80086
     #IF l_zob02_1 = l_zob02 THEN
 
         #獲取‘匯入序號’
         CALL p_openin_getno(l_zoa03,l_zob02)
 
         IF g_success = 'N' THEN
            EXIT FOR
         END IF
 
         IF cl_null(g_no) THEN
            CALL p_openin_getmax_no(l_zoa03,l_zob02)
         END IF
     #END IF   #MOD-D10024 mark
 
#MOD-B80338 -- mark begin --
#搬到azz-540控卡前
      #No.FUN-8A0021--begin
#     IF l_choice = 'N' THEN
#        CONTINUE FOR
#     END IF
      #No.FUN-8A0021--end
#MOD-B80338 -- mark end --
 
      IF cl_null(l_fname) THEN
         LET g_success = 'N'
         CALL cl_err(l_zoa03,'azz-504',1)
         EXIT FOR
      END IF
 
     #DISPLAY "begin time:",TIME          #No.FUN-910030         #MOD-AB0095 mark
      CALL p_openin_excel_bring(l_zoa03,l_zob02,l_fname)
         RETURNING li_n
     #DISPLAY "end time:",TIME            #No.FUN-910030         #MOD-AB0095 mark       
 
      LET li_i_sum = li_i_sum + li_n
 
      IF g_success = 'N' THEN
         EXIT FOR
      END IF
 
      LET l_str = "Loading ... ",l_zob02 CLIPPED
 
#     CALL cl_progressing(l_str)   #No.FUN-8A0050 Mark
 
   END FOR
 
   #-----No.FUN-8A0050-----
   #回寫zoa_file資料
   SELECT zoa07 INTO l_zoa07
     FROM zoa_file
    WHERE zoa03 = l_zoa03
   IF cl_null(l_zoa07) THEN LET l_zoa07 = 0 END IF
 
   LET l_zoa07 = l_zoa07 + g_total_row
 
   UPDATE zoa_file SET zoa05 = g_today,
                       zoa06 = g_user,
                       zoa07 = l_zoa07
                 WHERE zoa03 = l_zoa03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","zoa_file",l_zoa03,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
   #-----No.FUN-8A0050 END-----
 
 # IF g_success = 'Y' THEN
      IF lr_err.getLength() > 0 THEN
         CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"Line|Key1|Error")
        #IF lr_err.getLength() = li_i_sum THEN  #全部記錄都失敗
        #   LET g_success = 'N'
        #ELSE
            IF NOT cl_confirm('azz-505') THEN
            ELSE
               LET g_success = 'N'
            END IF
        #END IF
      END IF
 # END IF
 
   IF g_success = 'Y' THEN
      #強行關閉execl.exe
     #CALL p_openin_close_excel()   #No.FUN-8A0050 Mark
      IF li_i_sum = 0 THEN
         LET l_err = cl_getmsg('anm-973',g_lang)
         LET l_err = l_err CLIPPED,li_i_sum
         CALL cl_err(l_err,'!',1)
         LET g_success = 'N'
      END IF
   ELSE
#     CALL cl_close_progress_bar()   #No.FUN-8A0050 Mark
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err(l_zoa03,'azz-503',1)
      CALL p_openin_bp2_refresh()
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL p_openin_b_fill(g_wc,g_wc2)  
   CALL p_openin_b_fill2(" 1=1")  
   CALL p_openin_bp2_refresh()
 
   CALL fgl_set_arr_curr(l_ac)
 
END FUNCTION
 
 
FUNCTION p_openin_excel_bring(p_zoa03,p_zob02,p_fname)
   DEFINE p_zoa03   LIKE zoa_file.zoa03    #資料代號
   DEFINE p_zob02   LIKE zob_file.zob02    #檔案代號
   DEFINE p_fname   STRING                 #本次匯入檔名
   DEFINE l_zob05   LIKE zob_file.zob05    #僅匯出人工輸入字段
   DEFINE l_zob06   LIKE zob_file.zob06
   DEFINE l_channel base.Channel
  #DEFINE l_string  LIKE type_file.chr1000
  #DEFINE unix_path LIKE type_file.chr1000
  #DEFINE window_path LIKE type_file.chr1000
  #DEFINE l_cmd     LIKE type_file.chr50  
  #DEFINE li_result LIKE type_file.chr1 
  #DEFINE l_column  DYNAMIC ARRAY of RECORD 
  #         col1    LIKE gaq_file.gaq01,
  #         col2    LIKE gaq_file.gaq03
  #                 END RECORD
  #DEFINE l_cnt3    LIKE type_file.num5
  #DEFINE li_i      LIKE type_file.num5
  #DEFINE li_n      LIKE type_file.num5
  #DEFINE ls_cell   STRING
  #DEFINE ls_cell_r STRING
  #DEFINE li_i_r    LIKE type_file.num5
  #DEFINE ls_cell_c STRING
  #DEFINE ls_value  STRING
  #DEFINE ls_value_o  STRING
  #DEFINE li_flag   LIKE type_file.chr1  #讀入完成否 Y:完成 N:未完成
  #DEFINE lr_data_tmp   DYNAMIC ARRAY OF RECORD
  #          data01 STRING
  #                 END RECORD
  #DEFINE ls_sql    STRING   #最終組成的字符串
  #DEFINE l_fname   STRING   #本次匯入檔名
  #DEFINE l_column_name LIKE zta_file.zta01
  #DEFINE l_data_type LIKE ztb_file.ztb04
  #DEFINE l_nullable  LIKE ztb_file.ztb05
  #DEFINE l_flag_1  LIKE type_file.chr1  #目前資料是否異常 N:無異常 Y:異常
  #DEFINE l_zoc03   LIKE zoc_file.zoc03  #資料型態
  #DEFINE l_zoc05   LIKE zoc_file.zoc05  #資料類型    #No.FUN-8A0021
  #DEFINE l_date    LIKE type_file.dat
  #DEFINE l_chr     LIKE type_file.chr10
   #-----No.FUN-8A0050-----
   DEFINE l_chr            LIKE type_file.chr10
   DEFINE l_date           LIKE type_file.dat
   DEFINE l_nullable       LIKE ztb_file.ztb05
   DEFINE l_channel_co     base.Channel
   DEFINE l_channel_er     base.Channel
   DEFINE l_flag_1         LIKE type_file.chr1  #目前資料是否異常 N:無異常 Y:異常
   DEFINE l_tmp            LIKE type_file.chr100 
   DEFINE l_cmd            LIKE type_file.chr100 
   DEFINE l_cmd1           LIKE type_file.chr100 
   DEFINE l_field          LIKE gaq_file.gaq01
   DEFINE l_ins_row        LIKE type_file.num10
   DEFINE l_row_cnt        LIKE type_file.num10
   DEFINE l_col_row        LIKE type_file.num10
   DEFINE l_sum_row        LIKE type_file.num10
   DEFINE l_field_cnt      LIKE type_file.num10
   DEFINE l_str            STRING
   DEFINE l_err            STRING
   DEFINE l_err1           STRING
   DEFINE tok              base.StringTokenizer
   DEFINE tok1             base.StringTokenizer
   DEFINE ls_value         STRING
   DEFINE l_zoc05          LIKE zoc_file.zoc05
   DEFINE l_zoc04          LIKE zoc_file.zoc04  #資料長度
   DEFINE l_zoc03          LIKE zoc_file.zoc03  #資料型態
   DEFINE l_column         DYNAMIC ARRAY of RECORD 
                              zoc02   LIKE zoc_file.zoc02,
                              zoc03   LIKE zoc_file.zoc03,
                              zoc04   LIKE zoc_file.zoc04,
                              notnull LIKE type_file.chr1
                           END RECORD
   DEFINE l_msg            STRING
   DEFINE l_msg1           STRING
   DEFINE l_length         LIKE type_file.num5
   DEFINE l_zoc04_length   LIKE type_file.num5
   DEFINE l_zoc04_integer  STRING
   DEFINE l_zoc04_decimal  STRING
   DEFINE ls_value_integer STRING
   DEFINE ls_value_decimal STRING
   DEFINE l_openinsn       LIKE zoc_file.zoc02
   DEFINE l_sql            STRING
   DEFINE l_c              LIKE type_file.num5
   DEFINE i                LIKE type_file.num5
   DEFINE l_ind_key        STRING
   DEFINE l_err_key        STRING
   DEFINE l_ztd            DYNAMIC ARRAY OF RECORD
                              colname LIKE zoc_file.zoc02,
                              data    STRING
                           END RECORD
   DEFINE l_chr200         LIKE type_file.chr200
   DEFINE l_key2           STRING
   DEFINE l_zoc            RECORD LIKE zoc_file.*
   DEFINE l_ind_val        LIKE type_file.chr1000
   DEFINE l_status         LIKE type_file.num10
   DEFINE ls_value1        LIKE type_file.chr1000
   DEFINE l_date_type      LIKE type_file.chr10
   #-----No.FUN-8A0050 END-----
  
  #FUN-9C0147   ---start
   DEFINE l_year           LIKE type_file.chr4
   DEFINE l_month          LIKE type_file.chr2
   DEFINE l_day            LIKE type_file.chr2
   DEFINE l_chr1,l_chr2,l_chr3  STRING 
  #FUN-9C0147   ---end
   DEFINE b_zoc02          LIKE zoc_file.zoc02    #FUN-A40042
   DEFINE g_ozoc02         LIKE zoc_file.zoc02    #FUN-A40042
   DEFINE g_mzoc02         LIKE zoc_file.zoc02    #FUN-A40042
   DEFINE b_zoc07          LIKE zoc_file.zoc07    #FUN-A40042
   DEFINE b_zoc08          LIKE zoc_file.zoc08    #FUN-A40042
   DEFINE l_oldvalue       LIKE type_file.chr1000 #FUN-A40042
   DEFINE b_oldvalue       LIKE type_file.chr1000 #FUN-A40042
 
   SELECT zob05,zob06 INTO l_zob05,l_zob06
     FROM zob_file
    WHERE zob01 = p_zoa03
      AND zob02 = p_zob02
 
   IF cl_null(l_zob05) THEN LET l_zob05 = 'N' END IF
   IF cl_null(l_zob06) THEN LET l_zob06 = 0 END IF
 
   #-----No.FUN-8A0050-----
   #檔案路徑
   LET l_tmp = FGL_GETENV("TEMPDIR") 
  #LET l_cmd = l_tmp CLIPPED,"/",p_fname CLIPPED,".csv"
   LET l_cmd = l_tmp CLIPPED,"/",p_fname CLIPPED,".txt"
 
   #判斷檔案是否存在 
   LET l_cmd1 = "ls ", l_cmd CLIPPED, " >/dev/null 2>/dev/null"
   RUN l_cmd1 RETURNING l_status
   IF l_status > 0 THEN
      CALL cl_err(l_cmd,'aoo-042',1)
      RETURN 0
   END IF
 
   #抓總數
   LET l_cmd1 = "unset LANG; wc -l ", l_cmd CLIPPED, " | awk ' { print $1 }'"
   LET l_channel_co = base.Channel.create()
   CALL l_channel_co.openPipe(l_cmd1, "r")
   WHILE l_channel_co.read(l_sum_row)
   END WHILE
   CALL l_channel_co.close()
 
   #筆數為0表無資料或無權限
   IF l_sum_row = 0 THEN
      CALL cl_err(l_cmd,'azz-537',1)
      LET g_success = "N" 
      RETURN 0
   END IF
 
   CALL cl_progress_bar(l_sum_row)
 
   #抓檔案資料-行
   LET l_channel = base.Channel.create()
   CALL l_channel.openFile(l_cmd CLIPPED, "r")
   CALL l_channel.setDelimiter("")
 
   LET l_row_cnt = 0
   LET l_ins_row = 0
   LET ls_sql1 = NULL
  
  #DISPLAY "while 循環讀數據開始",TIME         #No.FUN-910030  #MOD-AB0095 mark
   WHILE l_channel.read(l_str)
 
      IF l_zob06 > 0 THEN
         IF l_zob06 < li_k THEN
            CALL cl_err('','azz-541',1)
            LET g_success = "N" 
            CALL cl_close_progress_bar()
            RETURN 0
         END IF
      END IF
 
      CALL cl_progressing("")
 
      LET l_row_cnt = l_row_cnt + 1 
      LET ls_sql2 = NULL
      LET ls_sql3 = NULL
 
      IF l_row_cnt = 1 OR l_row_cnt = 3 OR l_row_cnt = 4 OR l_row_cnt = 5 
     #OR l_row_cnt = 6 OR l_row_cnt = 7 THEN                  #FUN-9B0110 mark
      OR l_row_cnt = 6 OR l_row_cnt = 7 OR l_row_cnt = 8 THEN #FUN-9B0110 add #改為從第9行開始抓
         CONTINUE WHILE
      END IF
 
      #抓欄位
#     DISPLAY "抓欄位",TIME         #No.FUN-910030
      IF l_row_cnt = 2 THEN
        #LET tok = base.StringTokenizer.create(l_str,"|")
         LET tok = base.StringTokenizer.create(l_str,ASCII 9)
 
         LET l_field_cnt = 0
 
         WHILE tok.hasMoreTokens()
            LET l_field_cnt = l_field_cnt + 1 
            LET ls_value = tok.nextToken()
            LET l_field = ls_value
 
            SELECT zoc03,zoc04,zoc05 INTO l_zoc03,l_zoc04,l_zoc05 FROM zoc_file
             WHERE zoc02 = l_field 
 
            IF l_field = "END" THEN
               LET l_column[l_field_cnt].zoc02=l_field
               LET l_column[l_field_cnt].zoc03="X"
              #CONTINUE WHILE
               EXIT WHILE
            END IF
 
            IF l_zoc05 <> "0" AND l_zoc05 <> "5" THEN
               LET l_column[l_field_cnt].zoc02=l_field
               LET l_column[l_field_cnt].zoc03="X"
               CONTINUE WHILE
            ELSE
               LET l_column[l_field_cnt].zoc02=l_field
               LET l_column[l_field_cnt].zoc03=l_zoc03
               LET l_column[l_field_cnt].zoc04=l_zoc04
               #---FUN-A90024---start-----
               #改用cl_get_column_notnull() lib
               #LET g_sql = "SELECT nullable ",
               #            "  FROM all_tab_columns ",
               #            " WHERE LOWER(table_name) = '",p_zob02 CLIPPED,"'",
               #           #"   AND owner = UPPER('",g_dbs CLIPPED,"') ",
               #            "   AND owner = 'DS' ",
               #            "   AND LOWER(column_name)= '",l_field CLIPPED,"' " 
               #PREPARE p_openin_prepare32 FROM g_sql
               #DECLARE p_openin_curs32 CURSOR FOR p_openin_prepare32
               #OPEN p_openin_curs32
               #FETCH p_openin_curs32 INTO l_column[l_field_cnt].notnull
               LET l_column[l_field_cnt].notnull = cl_get_column_notnull(p_zob02 CLIPPED, l_field CLIPPED)
               IF l_column[l_field_cnt].notnull = 'Y' THEN
                  LET l_column[l_field_cnt].notnull = 'N'
               ELSE
                  LET l_column[l_field_cnt].notnull = 'Y'
               END IF
               #---FUN-A90024---end-------
               
               #如果欄位不存在
               IF STATUS = 100 THEN
                  CALL cl_getmsg('azz-523',g_lang) RETURNING l_msg
                  LET l_msg = l_field,l_msg,p_zob02
                  CALL cl_err(l_msg,'azz-542',1)
                  LET g_success = "N" 
                  CALL cl_close_progress_bar()
                  RETURN 0
               END IF
            END IF
 
            IF cl_null(ls_sql1) THEN
               LET ls_sql1 = l_field CLIPPED
            ELSE
               LET ls_sql1 = ls_sql1 CLIPPED,",",l_field CLIPPED
            END IF
 
         END WHILE
         CONTINUE WHILE
      END IF
#     DISPLAY "抓欄位結束",TIME         #No.FUN-910030
 
      #抓資料
#     DISPLAY "抓資料開始",TIME         #No.FUN-910030
     #LET tok = base.StringTokenizer.createExt(l_str,"|","",TRUE)
      LET tok = base.StringTokenizer.createExt(l_str,ASCII 9,"",TRUE)
 
      LET ls_sql3 = ls_sql1 CLIPPED
 
      LET l_field_cnt = 0
 
      #人工輸入部份
      WHILE tok.hasMoreTokens()
         LET l_field_cnt = l_field_cnt + 1 
         LET ls_value = tok.nextToken()
 
         LET l_field = l_column[l_field_cnt].zoc02
         LET l_zoc03 = l_column[l_field_cnt].zoc03
         LET l_zoc04 = l_column[l_field_cnt].zoc04
         LET l_nullable = l_column[l_field_cnt].notnull
 
         IF l_field = "END" THEN
            EXIT WHILE
         END IF
 
         IF l_zoc03="X" THEN
            CONTINUE WHILE
         END IF
 
         #資料
         CASE 
           #WHEN l_zoc03 MATCHES 'DATE' #FUN-9C0147
            WHEN (l_zoc03 MATCHES 'DATE'  OR l_zoc03 MATCHES 'date') #FUN-9C0147 
               IF cl_null(ls_value) THEN
                  #是否為not null欄位
                  IF l_nullable='N' THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,'99/12/31'
                     LET li_k = li_k + 1                                                    
                     LET l_err_cnt = l_err_cnt + 1
                   # LET l_date= g_today
                     LET l_date= 0
                  ELSE
                     LET l_date= ''
                    #LET l_date= 0 
                  END IF
               ELSE
                  #日期格式使用環境變數的設定
                  LET l_date_type = FGL_GETENV("NLS_DATE_FORMAT")
                  LET l_chr  = ls_value.subString(1,ls_value.getLength())
                  #大陸簡體日期格式
                  IF ls_value.subString(5,5) = '-' THEN
                    #FUN-9C0147   ---start
                     LET tok1 = base.StringTokenizer.create(l_chr,"-")
                     LET i=1
                     WHILE tok1.hasMoreTokens()
                        IF i=1 THEN
                           LET l_chr1 = tok1.nextToken()
                        END IF 
                        IF i=2 THEN
                           LET l_chr2 = tok1.nextToken()
                        END IF 
                        IF i=3 THEN
                           LET l_chr3 = tok1.nextToken()
                        END IF 
                        LET i=i+1  
                     END WHILE
                     IF l_chr1.getlength() > 2  THEN 
                        LET l_year=l_chr1.subString(1,4)
                        LET l_month=l_chr2.subString(1,l_chr2.getLength())
                        LET l_day=l_chr3.subString(1,l_chr3.getLength())
                     END IF
                     IF l_chr3.getlength()>2 THEN
                        LET l_month=l_chr1.subString(1,l_chr1.getLength())
                        LET l_day=l_chr2.subString(1,l_chr2.getLength())
                        LET l_year=l_chr3.subString(1,4)
                     END IF
                     LET l_date = MDY(l_month,l_day,l_year)    
                    #SELECT TO_DATE(l_chr,l_date_type) INTO l_date FROM dual 
                    #IF SQLCA.SQLCODE THEN
                    #   SELECT TO_DATE(l_chr,'YYYY-MM-DD') INTO l_date FROM dual 
                    #   IF SQLCA.SQLCODE THEN
                    #      SELECT TO_DATE(l_chr,'YYYY-MM-D') INTO l_date FROM dual 
                    #      IF SQLCA.SQLCODE THEN 
                    #         SELECT TO_DATE(l_chr,'YYYY-M-DD') INTO l_date FROM dual 
                    #         IF SQLCA.SQLCODE THEN 
                    #            SELECT TO_DATE(l_chr,'YYYY-M-D') INTO l_date FROM dual 
                    #            IF SQLCA.SQLCODE THEN 
                    #               SELECT TO_DATE(l_chr,'MM-DD-YYYY') INTO l_date FROM dual 
                    #            END IF
                    #         END IF
                    #      END IF
                    #   END IF
                    #END IF
                    #FUN-9C0147   ---end
                  ELSE
                     #台灣繁體日期格式
                    #FUN-9C0147   ---start
                     LET tok1 = base.StringTokenizer.create(l_chr,"/")
                     LET i=1
                     WHILE tok1.hasMoreTokens()
                        IF i=1 THEN
                           LET l_chr1 = tok1.nextToken()
                        END IF
                        IF i=2 THEN
                           LET l_chr2 = tok1.nextToken()
                        END IF
                        IF i=3 THEN
                           LET l_chr3 = tok1.nextToken()
                        END IF
                        LET i=i+1
                     END WHILE
                     IF l_chr1.getlength() > 2  THEN
                        LET l_year=l_chr1.subString(1,4)
                        LET l_month=l_chr2.subString(1,l_chr2.getLength())
                        LET l_day=l_chr3.subString(1,l_chr3.getLength())
                     END IF
                     IF l_chr3.getlength()>2 THEN
                        LET l_month=l_chr1.subString(1,l_chr1.getLength())
                        LET l_day=l_chr2.subString(1,l_chr2.getLength())
                        LET l_year=l_chr3.subString(1,4)
                     END IF

                     LET l_date = MDY(l_month,l_day,l_year) 
                    #SELECT TO_DATE(l_chr,l_date_type) INTO l_date FROM dual 
                    #IF SQLCA.SQLCODE THEN
                    #   SELECT TO_DATE(l_chr,'YYYY/MM/DD') INTO l_date FROM dual
                    #   IF SQLCA.SQLCODE THEN
                    #      SELECT TO_DATE(l_chr,'YYYY/MM/D') INTO l_date FROM dual
                    #      IF SQLCA.SQLCODE THEN 
                    #         SELECT TO_DATE(l_chr,'YYYY/M/DD') INTO l_date FROM dual 
                    #         IF SQLCA.SQLCODE THEN 
                    #            SELECT TO_DATE(l_chr,'YYYY/M/D') INTO l_date FROM dual 
                    #            IF SQLCA.SQLCODE THEN 
                    #               SELECT TO_DATE(l_chr,'MM/DD/YYYY') INTO l_date FROM dual 
                    #            END IF
                    #         END IF
                    #      END IF
                    #   END IF
                    #END IF
                    #FUN-9C0147   ---end
                  END IF
               END IF
#              IF l_field_cnt = 1 THEN    #FUN-A40042                                      
               IF cl_null(ls_sql2) THEN   #FUN-A40042
                  IF cl_null(l_date) THEN                                       
                     LET ls_sql2 = "''"                                         
                  ELSE                                                          
                     LET ls_sql2 = "'",l_date CLIPPED,"'"                       
                  END IF                                                        
               ELSE                                                             
                  IF cl_null(l_date) THEN                                       
                     LET ls_sql2 = ls_sql2 CLIPPED,",''"                        
                  ELSE                                                          
                     LET ls_sql2 = ls_sql2 CLIPPED,",'",l_date CLIPPED,"'"      
                  END IF                                                        
               END IF                
           #WHEN l_zoc03 MATCHES 'NUMBER' #FUN-9C0147
            WHEN (l_zoc03 MATCHES 'NUMBER' OR l_zoc03 MATCHES 'number') #FUN-9C0147
               IF cl_null(ls_value) THEN
                  #是否為not null欄位
                  IF l_nullable='N' THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,'0'
                     LET li_k = li_k + 1        
                     LET l_err_cnt = l_err_cnt + 1
                     LET ls_value = 0
                  ELSE
                     LET ls_value = 0 
                  END IF
               END IF
 
               #將,拿掉 
               LET ls_value=cl_replace_str(ls_value,",","")
 
               #資料長度是否過長
               CASE
                  WHEN l_zoc04 ="5"
                     IF ls_value > 32767 OR ls_value < -32767 THEN
                        LET lr_err[li_k].line = l_row_cnt
                        LET lr_err[li_k].key1 = l_field
                        CALL cl_getmsg('azz-531',g_lang) RETURNING l_msg
                        LET lr_err[li_k].err  = l_msg,'0'
                        LET li_k = li_k + 1        
                        LET l_err_cnt = l_err_cnt + 1
                        LET ls_value = 0 
                     END IF
                  WHEN l_zoc04 ="10"    
                     IF ls_value > 2147483647 OR ls_value < -2147483647 THEN
                        LET lr_err[li_k].line = l_row_cnt
                        LET lr_err[li_k].key1 = l_field
                        CALL cl_getmsg('azz-531',g_lang) RETURNING l_msg
                        LET lr_err[li_k].err  = l_msg,'0'
                        LET li_k = li_k + 1        
                        LET l_err_cnt = l_err_cnt + 1
                        LET ls_value = 0 
                     END IF
                  OTHERWISE
                     #欄位型態整數(l_zoc04_integer)及小數位數(l_zoc04_decimal)
                     LET tok1 = base.StringTokenizer.create(l_zoc04,",")
                     WHILE tok1.hasMoreTokens()
                        LET l_zoc04_length = tok1.nextToken()
                        LET l_zoc04_decimal = tok1.nextToken()
                     END WHILE
                     LET l_zoc04_integer = l_zoc04_length - l_zoc04_decimal
                     
                     #資料之整數(l_zoc04_integer)及小數(l_zoc04_decimal)
                     LET tok1 = base.StringTokenizer.create(ls_value,".")
                     WHILE tok1.hasMoreTokens()
                        LET ls_value_integer = tok1.nextToken()
                        LET ls_value_decimal = tok1.nextToken()
                     END WHILE
 
                     #資料之整數位數>欄位型態整數位數 OR 資料之小數位數>欄位型態小數位數
                     IF ls_value_integer.getLength()>l_zoc04_integer
                     OR ls_value_decimal.getLength()>l_zoc04_decimal THEN
                        LET lr_err[li_k].line = l_row_cnt
                        LET lr_err[li_k].key1 = l_field
                        CALL cl_getmsg('azz-531',g_lang) RETURNING l_msg
                        LET lr_err[li_k].err  = l_msg,'0'
                        LET li_k = li_k + 1
                        LET l_err_cnt = l_err_cnt + 1
                        LET ls_value = 0
                    END IF
               END CASE
               
#              IF l_field_cnt = 1 THEN    #FUN-A40042
               IF cl_null(ls_sql2) THEN   #FUN-A40042
                  LET ls_sql2 = ls_value 
               ELSE
                  LET ls_sql2 = ls_sql2 ,",",ls_value 
               END IF
            OTHERWISE
               LET ls_value1 = ls_value
 
            IF ls_value1 != '' THEN      #No.MOD-960087 add
               #將'轉成''
               LET ls_value1=cl_replace_str(ls_value1,"'","~!@#")
               LET ls_value1=cl_replace_str(ls_value1,"~!@#","''")
#FUN-B30219 --Begin mark
#              SELECT replace(ls_value1,'\"\"','~!@#') INTO ls_value1 FROM dual
#              SELECT replace(ls_value1,'\"','') INTO ls_value1 FROM dual
#              SELECT replace(ls_value1,'~!@#','\"') INTO ls_value1 FROM dual
#FUN-B30219 --End mark
#FUN-B30219 --Begin
               LET ls_value1 = cl_replace_str(ls_value1,'\"\"','~!@#')
               LET ls_value1 = cl_replace_str(ls_value1,'\"','')
               LET ls_value1 = cl_replace_str(ls_value1,'~!@#','\"')
#FUN-B30219 --End
            END IF                       #No.MOD-960087 add
 
               #資料長度是否過長
               LET l_length = 0
               LET l_length = length(ls_value1)
               IF l_length > l_zoc04 THEN
                  LET lr_err[li_k].line = l_row_cnt
                  LET lr_err[li_k].key1 = l_field
                  CALL cl_getmsg('azz-528',g_lang) RETURNING l_msg
                  CALL cl_getmsg('azz-529',g_lang) RETURNING l_msg1
                  LET lr_err[li_k].err  = l_msg,l_zoc04,l_msg1
                  LET li_k = li_k + 1        
                  LET l_err_cnt = l_err_cnt + 1
                  LET ls_value1  = ls_value1[1,l_zoc04]
               END IF
#              IF l_field_cnt = 1 THEN    #FUN-A40042
               IF cl_null(ls_sql2) THEN   #FUN-A40042
                  IF (ls_value1='' OR ls_value1 IS NULL) AND l_nullable = "N" THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,"' '"
                     LET li_k = li_k + 1        
                     LET l_err_cnt = l_err_cnt + 1
                     LET ls_sql2 = ' '
                  ELSE
                     LET ls_sql2 = "'",ls_value1,"'"
                  END IF
               ELSE
                  #是否為not null欄位
                  IF (ls_value1='' OR ls_value1 IS NULL) AND l_nullable = "N" THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,"' '"
                     LET li_k = li_k + 1        
                     LET l_err_cnt = l_err_cnt + 1
                     LET ls_sql2 = ls_sql2,",' '"
                  ELSE
                    #LET ls_sql2 = ls_sql2,",'",ls_value1,"'"   #MOD-CA0006 mark
                    #MOD-CA0006---S---
                     IF ls_value1 IS NULL THEN
                        LET ls_sql2 = ls_sql2,",''"
                     ELSE
                        LET ls_sql2 = ls_sql2,",'",ls_value1,"'"
                     END IF
                    #MOD-CA0006---E---
                  END IF
               END IF
         END CASE 
      END WHILE
#     DISPLAY "抓資料開始",TIME         #No.FUN-910030
 
      #自動給值部份
#     DISPLAY "自動給值開始",TIME         #No.FUN-910030
      LET g_sql = "SELECT zoc02 ",
                  "  FROM zoc_file ",
                  " WHERE zoc01 = '",p_zob02 CLIPPED,"' ",
                  "   AND zoc05 !='0' ",   #人工輸入
                  "   AND zoc05 !='4' ",   #計算條件
                  "   AND zoc05 !='5' "    #舊系統單號
 
      PREPARE p_openin_prepare2 FROM g_sql 
     
      DECLARE p_openin_curs2 CURSOR FOR p_openin_prepare2
     
      FOREACH p_openin_curs2 INTO l_field
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         #---FUN-A90024---start-----
         #改用cl_get_column_notnull() lib
         #LET g_sql = "SELECT nullable ",
         #            "  FROM all_tab_columns ",
         #            " WHERE LOWER(table_name) = '",p_zob02 CLIPPED,"'",
         #          # "   AND owner = UPPER('",g_dbs CLIPPED,"') ",
         #            "   AND owner = 'DS' ",
         #            "   AND LOWER(column_name)= '",l_field CLIPPED,"' " 
         #PREPARE p_openin_prepare31 FROM g_sql
         #DECLARE p_openin_curs31 CURSOR FOR p_openin_prepare31
         #OPEN p_openin_curs31
         #FETCH p_openin_curs31 INTO l_nullable
         LET l_nullable = cl_get_column_notnull(p_zob02 CLIPPED, l_field CLIPPED)
         IF l_nullable = 'Y' THEN
            LET l_nullable = 'N'
         ELSE
            LET l_nullable = 'Y'
         END IF
         #---FUN-A90024---end-------
               
         #p_opentb設定影響考慮
                            #資料代碼,檔案代號,欄位名稱,欄位值,筆數,檔名,序號
         CALL p_openin_check(p_zoa03,p_zob02,l_field,"",l_row_cnt,p_fname,g_no) 
                   RETURNING l_flag_1,ls_value,l_zoc03,l_zoc04,l_zoc05
 
         IF l_flag_1 = 'Y' THEN
            CONTINUE FOREACH
         END IF
     
         #欄位
         LET ls_sql3 = ls_sql3 CLIPPED,",",l_field CLIPPED
 
         #資料
         CASE 
           #WHEN l_zoc03 MATCHES 'DATE' #FUN-9C0147
            WHEN (l_zoc03 MATCHES 'DATE' OR l_zoc03 MATCHES 'date') #FUN-9C0147 
               IF cl_null(ls_value) THEN
                  #是否為not null欄位
                  IF l_nullable='N' THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,'99/12/31'
                     LET li_k = li_k + 1                                                    
                     LET l_err_cnt = l_err_cnt + 1
                    #LET l_date= g_today
                     LET l_date= 0
                  ELSE
                     LET l_date= ''
                    #LET l_date= 0
                  END IF
               ELSE
                  #日期格式使用環境變數的設定
                  LET l_date_type = FGL_GETENV("NLS_DATE_FORMAT")
                  LET l_chr  = ls_value.subString(1,ls_value.getLength()) 
                  #大陸簡體日期格式
                  IF ls_value.subString(5,5) = '-' THEN
                    #FUN-9C0147   ---start
                    LET tok1 = base.StringTokenizer.create(l_chr,"-")
                     LET i=1
                     WHILE tok1.hasMoreTokens()
                        IF i=1 THEN
                           LET l_chr1 = tok1.nextToken()
                        END IF
                        IF i=2 THEN
                           LET l_chr2 = tok1.nextToken()
                        END IF
                        IF i=3 THEN
                           LET l_chr3 = tok1.nextToken()
                        END IF
                        LET i=i+1
                     END WHILE
                     IF l_chr1.getlength() > 2  THEN
                        LET l_year=l_chr1.subString(1,4)
                        LET l_month=l_chr2.subString(1,l_chr2.getLength())
                        LET l_day=l_chr3.subString(1,l_chr3.getLength())
                     END IF
                     IF l_chr3.getlength()>2 THEN
                        LET l_month=l_chr1.subString(1,l_chr1.getLength())
                        LET l_day=l_chr2.subString(1,l_chr2.getLength())
                        LET l_year=l_chr3.subString(1,4)
                     END IF

                     LET l_date = MDY(l_month,l_day,l_year)
                    #SELECT TO_DATE(l_chr,l_date_type) INTO l_date FROM dual 
                    #IF SQLCA.SQLCODE THEN
                    #   SELECT TO_DATE(l_chr,'YYYY-MM-DD') INTO l_date FROM dual 
                    #   IF SQLCA.SQLCODE THEN
                    #      SELECT TO_DATE(l_chr,'YYYY-MM-D') INTO l_date FROM dual 
                    #      IF SQLCA.SQLCODE THEN 
                    #         SELECT TO_DATE(l_chr,'YYYY-M-DD') INTO l_date FROM dual 
                    #         IF SQLCA.SQLCODE THEN 
                    #            SELECT TO_DATE(l_chr,'YYYY-M-D') INTO l_date FROM dual 
                    #            IF SQLCA.SQLCODE THEN 
                    #               SELECT TO_DATE(l_chr,'MM-DD-YYYY') INTO l_date FROM dual 
                    #            END IF
                    #         END IF
                    #      END IF
                    #   END IF
                    #END IF
                    #FUN-9C0147   ---end 
                  ELSE
                     #台灣繁體日期格式
                    #FUN-9C0147   ---start
                     LET tok1 = base.StringTokenizer.create(l_chr,"/")
                     LET i=1
                     WHILE tok1.hasMoreTokens()
                        IF i=1 THEN
                           LET l_chr1 = tok1.nextToken()
                        END IF
                        IF i=2 THEN
                           LET l_chr2 = tok1.nextToken()
                        END IF
                        IF i=3 THEN
                           LET l_chr3 = tok1.nextToken()
                        END IF
                        LET i=i+1
                     END WHILE
                     IF l_chr1.getlength() > 2  THEN
                        LET l_year=l_chr1.subString(1,4)
                        LET l_month=l_chr2.subString(1,l_chr2.getLength())
                        LET l_day=l_chr3.subString(1,l_chr3.getLength())
                     END IF
                     IF l_chr3.getlength()>2 THEN
                        LET l_month=l_chr1.subString(1,l_chr1.getLength())
                        LET l_day=l_chr2.subString(1,l_chr2.getLength())
                        LET l_year=l_chr3.subString(1,4)
                     END IF

                     LET l_date = MDY(l_month,l_day,l_year)
                    #SELECT TO_DATE(l_chr,l_date_type) INTO l_date FROM dual 
                    #IF SQLCA.SQLCODE THEN
                    #   SELECT TO_DATE(l_chr,'YYYY/MM/DD') INTO l_date FROM dual 
                    #   IF SQLCA.SQLCODE THEN
                    #      SELECT TO_DATE(l_chr,'YYYY/MM/D') INTO l_date FROM dual 
                    #      IF SQLCA.SQLCODE THEN 
                    #         SELECT TO_DATE(l_chr,'YYYY/M/DD') INTO l_date FROM dual 
                    #         IF SQLCA.SQLCODE THEN 
                    #            SELECT TO_DATE(l_chr,'YYYY/M/D') INTO l_date FROM dual 
                    #            IF SQLCA.SQLCODE THEN 
                    #               SELECT TO_DATE(l_chr,'MM/DD/YYYY') INTO l_date FROM dual 
                    #            END IF
                    #         END IF
                    #      END IF
                    #   END IF
                    #END IF
                    #FUN-9C0147   ---end
                  END IF
               END IF
#              IF l_field_cnt = 1 THEN    #FUN-A40042                                          
               IF cl_null(ls_sql2) THEN   #FUN-A40042
                  IF cl_null(l_date) THEN                                       
                     LET ls_sql2 = "''"                                         
                  ELSE                                                          
                     LET ls_sql2 = "'",l_date CLIPPED,"'"                       
                  END IF                                                        
               ELSE                                                             
                  IF cl_null(l_date) THEN                                       
                     LET ls_sql2 = ls_sql2 CLIPPED,",''"                        
                  ELSE                                                          
                     LET ls_sql2 = ls_sql2 CLIPPED,",'",l_date CLIPPED,"'"      
                  END IF                                                        
               END IF                
           #WHEN l_zoc03 MATCHES 'NUMBER' #FUN-9C0147
            WHEN (l_zoc03 MATCHES 'NUMBER'  OR l_zoc03 MATCHES 'number') #FUN-9C0147
               IF cl_null(ls_value) THEN
                  #是否為not null欄位
                  IF l_nullable='N' THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,'0'
                     LET li_k = li_k + 1        
                     LET l_err_cnt = l_err_cnt + 1
                     LET ls_value = 0
                  ELSE
                     LET ls_value = 0
                  END IF
               END IF
 
               #將,拿掉 
               LET ls_value=cl_replace_str(ls_value,",","")
 
               #資料長度是否過長
               CASE
                  WHEN l_zoc04 ="5"
                     IF ls_value > 32767 OR ls_value < -32767 THEN
                        LET lr_err[li_k].line = l_row_cnt
                        LET lr_err[li_k].key1 = l_field
                        CALL cl_getmsg('azz-531',g_lang) RETURNING l_msg
                        LET lr_err[li_k].err  = l_msg,'0'
                        LET li_k = li_k + 1
                        LET l_err_cnt = l_err_cnt + 1
                        LET ls_value = 0
                     END IF
                  WHEN l_zoc04 ="10"    
                     IF ls_value > 2147483647 OR ls_value < -2147483647 THEN
                        LET lr_err[li_k].line = l_row_cnt
                        LET lr_err[li_k].key1 = l_field
                        CALL cl_getmsg('azz-531',g_lang) RETURNING l_msg
                        LET lr_err[li_k].err  = l_msg,'0'
                        LET li_k = li_k + 1        
                        LET l_err_cnt = l_err_cnt + 1
                        LET ls_value = 0 
                     END IF
                  OTHERWISE
                     #欄位型態整數(l_zoc04_integer)及小數位數(l_zoc04_decimal)
                     LET tok1 = base.StringTokenizer.create(l_zoc04,",")
                     WHILE tok1.hasMoreTokens()
                        LET l_zoc04_length = tok1.nextToken()
                        LET l_zoc04_decimal = tok1.nextToken()
                     END WHILE
                     LET l_zoc04_integer = l_zoc04_length - l_zoc04_decimal
                     
                     #資料之整數(l_zoc04_integer)及小數(l_zoc04_decimal)
                     LET tok1 = base.StringTokenizer.create(ls_value,".")
                     WHILE tok1.hasMoreTokens()
                        LET ls_value_integer = tok1.nextToken()
                        LET ls_value_decimal = tok1.nextToken()
                     END WHILE
 
                     #資料之整數位數>欄位型態整數位數 OR 資料之小數位數>欄位型態小數位數
                     IF ls_value_integer.getLength()>l_zoc04_integer
                     OR ls_value_decimal.getLength()>l_zoc04_decimal THEN
                        LET lr_err[li_k].line = l_row_cnt
                        LET lr_err[li_k].key1 = l_field
                        CALL cl_getmsg('azz-531',g_lang) RETURNING l_msg
                        LET lr_err[li_k].err  = l_msg,'0'
                        LET li_k = li_k + 1
                        LET l_err_cnt = l_err_cnt + 1
                        LET ls_value = 0
                    END IF
               END CASE
               
#              IF l_field_cnt = 1 THEN    #FUN-A40042
               IF cl_null(ls_sql2) THEN   #FUN-A40042
                  LET ls_sql2 = ls_value
               ELSE
                  LET ls_sql2 = ls_sql2 ,",",ls_value
               END IF
            OTHERWISE
               LET ls_value1 = ls_value
 
            IF ls_value1 !='' THEN      #No.MOD-960087 add
               #將'轉成''
               LET ls_value1=cl_replace_str(ls_value1,"'","~!@#")
               LET ls_value1=cl_replace_str(ls_value1,"~!@#","''")
#FUN-B30219 --Begin mark
               SELECT replace(ls_value1,'\"\"','~!@#') INTO ls_value1 FROM dual
               SELECT replace(ls_value1,'\"','') INTO ls_value1 FROM dual
               SELECT replace(ls_value1,'~!@#','\"') INTO ls_value1 FROM dual
#FUN-B30219 --End mark
#FUN-B30219 --Begin
               LET ls_value1 = cl_replace_str(ls_value1,'\"\"','~!@#')
               LET ls_value1 = cl_replace_str(ls_value1,'\"','')
               LET ls_value1 = cl_replace_str(ls_value1,'~!@#','\"')
#FUN-B30219 --End
            END IF                      #No.MOD-960087 add 
 
               #資料長度是否過長
               LET l_length = 0
               LET l_length = length(ls_value1)
               IF l_length > l_zoc04 THEN
                  LET lr_err[li_k].line = l_row_cnt
                  LET lr_err[li_k].key1 = l_field
                  CALL cl_getmsg('azz-528',g_lang) RETURNING l_msg
                  CALL cl_getmsg('azz-529',g_lang) RETURNING l_msg1
                  LET lr_err[li_k].err  = l_msg,l_zoc04,l_msg1
                  LET li_k = li_k + 1
                  LET l_err_cnt = l_err_cnt + 1
                  LET ls_value1  = ls_value1[1,l_zoc04]
               END IF
#              IF l_field_cnt = 1 THEN    #FUN-A40042
               IF cl_null(ls_sql2) THEN   #FUN-A40042
                  IF (ls_value1='' OR ls_value1 IS NULL) AND l_nullable = "N" THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,"' '"
                     LET li_k = li_k + 1        
                     LET l_err_cnt = l_err_cnt + 1
                     LET ls_sql2 = ' '
                  ELSE
                     LET ls_sql2 = "'",ls_value1,"'"
                  END IF
               ELSE
                  #是否為not null欄位
                  IF (ls_value1='' OR ls_value1 IS NULL) AND l_nullable = "N" THEN
                     LET lr_err[li_k].line = l_row_cnt
                     LET lr_err[li_k].key1 = l_field
                     CALL cl_getmsg('azz-527',g_lang) RETURNING l_msg
                     LET lr_err[li_k].err  = l_msg,"' '"
                     LET li_k = li_k + 1        
                     LET l_err_cnt = l_err_cnt + 1
                     LET ls_sql2 = ls_sql2 ,",' '"
                  ELSE
                     LET ls_sql2 = ls_sql2 ,",'",ls_value1 ,"'"
                  END IF
               END IF
         END CASE
 
      END FOREACH
#     DISPLAY "自動給值結束",TIME         #No.FUN-910030
 
      #INSERT進DataBase
#     DISPLAY "INSERT進DataBase開始",TIME         #No.FUN-910030
     #LET g_sql = "INSERT INTO ",p_zob02," (",ls_sql3,") \n VALUES (",ls_sql2,")" #TQC-A10010 mark
      LET g_sql = "INSERT INTO ",p_zob02," (",ls_sql3,")  VALUES (",ls_sql2,")"   #TQC-A10010 
 
      PREPARE execute_sql FROM g_sql
      EXECUTE execute_sql
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         LET lr_err[li_k].line = l_row_cnt
         LET lr_err[li_k].key1 = g_sql
        #TQC-C50193 str mark----- 
        #LET l_err = "oerr ora ",SQLCA.SQLERRD[2]*-1," > /tmp/err.txt"
        #RUN l_err
        #LET l_cmd1 ="/tmp/err.txt"
        #LET l_channel_er = base.Channel.create()
        #LET l_channel_er = base.Channel.create()
        #CALL l_channel_er.openFile(l_cmd1 CLIPPED, "r")
        #CALL l_channel_er.setDelimiter("")
        #WHILE l_channel_er.read(l_err1)
        #   EXIT WHILE
        #END WHILE
        #CALL l_channel_er.close()
        #LET lr_err[li_k].err  = SQLCA.sqlerrd[2],":",l_err1
        #TQC-C50193 end mark-----
        #TQC-C50193 str add------
         LET l_err = SQLCA.SQLCODE
         CALL cl_getmsg(SQLCA.SQLCODE,g_lang) RETURNING l_err1
         LET lr_err[li_k].err  = l_err,":",l_err1 
        #TQC-C50193 end add------
         LET li_k = li_k + 1
         LET l_err_cnt = l_err_cnt + 1
      ELSE
         LET g_total_row = g_total_row + 1
         LET l_ins_row = l_ins_row + 1
      END IF
#     DISPLAY "INSERT進DataBase開始",TIME         #No.FUN-910030
 
   END WHILE
  #DISPLAY "while 循環讀數據結束",TIME         #No.FUN-910030   #MOD-AB0095 mark
 
   CALL l_channel.close()
 
   #判斷筆數是否相同
   IF l_sum_row > 0 THEN
      IF l_row_cnt <> l_sum_row THEN
         LET l_msg = l_cmd CLIPPED,"  LINE:",l_row_cnt+1
         CALL cl_err(l_msg,'azz-536',1)
         LET g_success = "N" 
         CALL cl_close_progress_bar()
         RETURN 0
      END IF
   END IF
 
   #欄位使用"計算條件"之資料處理
#No.FUN-910030--begin-取消'計算條件'考慮依匯入序號
#  SELECT zoc02 INTO l_openinsn FROM zoc_file   #匯入序號
#   WHERE zoc01 = p_zob02
#     AND zoc05 ='6'
 
#  IF cl_null(l_openinsn) THEN
##    CALL cl_err(p_zob02,'azz-507',1)               #記錄TP單號的字段不能為空
#  END IF 
#No.FUN-910030--end
 
   #ORA-抓取table的primary key欄位
  #DISPLAY "ORA-抓取table的primary key欄位開始",TIME         #No.FUN-910030   #MOD-AB0095 mark
   LET l_sql =" SELECT LOWER(COLUMN_NAME) FROM ALL_CONS_COLUMNS ",
              "  WHERE LOWER(OWNER)='ds'  ",
              "    AND LOWER(TABLE_NAME) ='",p_zob02 CLIPPED,"'  ",
              "    AND LOWER(CONSTRAINT_NAME) LIKE '%_pk' ", 
              "  ORDER BY POSITION  " 
 
   PREPARE ztd_pre FROM l_sql
 
   DECLARE ztd_cur CURSOR FOR ztd_pre
 
   LET l_c = 1
 
   LET l_err_key = ""
   LET l_ind_key = ""
 
   FOREACH ztd_cur INTO l_ztd[l_c].colname
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH ztd:',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
 
      IF cl_null(l_err_key) THEN
         LET l_err_key = l_ztd[l_c].colname CLIPPED 
         LET l_ind_key = l_ztd[l_c].colname CLIPPED 
      ELSE  
         LET l_err_key = l_err_key CLIPPED,",",l_ztd[l_c].colname CLIPPED 
         LET l_ind_key = l_err_key CLIPPED,"||','||",l_ztd[l_c].colname CLIPPED 
      END IF
 
      LET l_c = l_c + 1
 
   END FOREACH
  #DISPLAY "ORA-抓取table的primary key欄位結束",TIME        #No.FUN-910030   #MOD-AB0095 mark
 
   LET l_c = l_c - 1
 
   #抓取KEY值資料
  #DISPLAY "抓取key值資料開始",TIME         #No.FUN-910030   #MOD-AB0095 mark
   LET l_sql =" SELECT ",l_ind_key ," FROM ",p_zob02 
#             "  WHERE ",l_openinsn,"='",g_no,"'"           #No.FUN-910030--取消'計算條件'考慮依匯入序號
 
#  PREPARE rowid_pre FROM l_sql                             #FUN-9B0066 mark
   PREPARE l_ind_key_pre FROM l_sql                         #FUN-9B0066
 
#  DECLARE rowid_cur CURSOR FOR rowid_pre                   #FUN-9B0066 mark
   DECLARE l_ind_key_cur CURSOR FOR l_ind_key_pre           #FUN-9B0066
 
#  FOREACH rowid_cur INTO l_ind_val                         #FUN-9B0066 mark
   FOREACH l_ind_key_cur INTO l_ind_val                     #FUN-9B0066
      IF SQLCA.sqlcode THEN
#        CALL cl_err('FOREACH rowid:',SQLCA.sqlcode,1)      #FUN-9B0066 mark
         CALL cl_err('FOREACH l_ind_key:',SQLCA.sqlcode,1)  #FUN-9B0066
         CONTINUE FOREACH
      END IF
 
      LET l_str = l_ind_val CLIPPED
 
      LET l_key2 =" 1=1"
 
      LET i = 0
 
      LET tok = base.StringTokenizer.create(l_str,",")
 
      WHILE tok.hasMoreTokens()
         LET ls_value = tok.nextToken()
         LET i = i +1
 
         SELECT zoc03 INTO l_zoc03 FROM zoc_file
          WHERE zoc02 = l_ztd[i].colname
 
        #IF l_zoc03 = "NUMBER" THEN #FUN-9C0147
         IF (l_zoc03 = "NUMBER" OR l_zoc03 = 'number') THEN #FUN-9C0147
            LET l_key2 = l_key2 CLIPPED," AND ",l_ztd[i].colname,"=",ls_value 
         ELSE
            LET l_key2 = l_key2 CLIPPED," AND ",l_ztd[i].colname,"='",ls_value,"'" 
         END IF
 
      END WHILE
#     DISPLAY "抓取key值資料結束",TIME         #No.FUN-910030
 
#     DISPLAY "抓取計算條件之資料開始",TIME         #No.FUN-910030
      #抓取計算條件之資料
      LET l_sql =" SELECT zoc02,zoc06 FROM zoc_file ",
                 "  WHERE zoc01 ='",p_zob02,"'",
                 "    AND zoc05 = '4'"
 
      PREPARE zoc_pre FROM l_sql
 
      DECLARE zoc_cur CURSOR FOR zoc_pre
 
      FOREACH zoc_cur INTO l_zoc.zoc02,l_zoc.zoc06
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH zoc:',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
 
         IF cl_null(l_zoc.zoc06) THEN
            CONTINUE FOREACH
         END IF
 
         #抓取要判斷的資料
         LET l_sql = "SELECT ",l_zoc.zoc06 CLIPPED,
                     "  FROM ",p_zob02 CLIPPED,
                     " WHERE ",l_key2
 
         PREPARE value_pre FROM l_sql
 
         DECLARE value_cur CURSOR FOR value_pre
 
         OPEN value_cur
 
         FETCH value_cur INTO l_chr200
            
         IF cl_null(l_chr200) THEN
            LET l_chr200 = 0
         END IF
 
         #寫入
         LET l_sql = "UPDATE ",p_zob02 CLIPPED,
                     "   SET ",l_zoc.zoc02,"=",l_chr200,
                     " WHERE ",l_key2
 
         PREPARE upd_pre FROM l_sql
         EXECUTE upd_pre
 
         IF STATUS THEN
            LET lr_err[li_k].line = ''
            LET lr_err[li_k].key1 = l_err_key CLIPPED,",",l_zoc.zoc02 CLIPPED,":",l_str CLIPPED,"/",l_chr200 CLIPPED 
            CALL cl_getmsg('azz-532',g_lang) RETURNING l_msg
            LET lr_err[li_k].err  = l_zoc.zoc06,l_msg
            LET li_k = li_k + 1
            LET l_err_cnt = l_err_cnt + 1
         END IF
 
      END FOREACH
#     DISPLAY "抓取計算條件之資料結束",TIME         #No.FUN-910030
 
   END FOREACH
   #欄位使用"計算條件"之資料處理 END
#FUN-A40042 --Begin
   SELECT zoc02,zoc07,zoc08 INTO b_zoc02,b_zoc07,b_zoc08 FROM zoc_file
    WHERE zoc01=p_zob02 AND zoc05='7'
   IF STATUS=0 THEN
                                                                                                                                    
      SELECT zoc02 INTO g_ozoc02 FROM zoc_file
       WHERE zoc01=p_zob02 AND zoc05='5'

      SELECT zoc02 INTO g_mzoc02 FROM zoc_file
       WHERE zoc01=b_zoc07 AND zoc05='5'

      LET l_sql = " SELECT UNIQUE ",g_ozoc02 ,
                  "   FROM ",p_zob02,
                  "  WHERE ",b_zoc02," LIKE 'new-no%'"
      PREPARE p_openin_pre4 FROM l_sql
      DECLARE p_openin_cs4 CURSOR FOR p_openin_pre4
      FOREACH p_openin_cs4 INTO b_oldvalue
         LET l_sql = " SELECT ",b_zoc08,
                     "   FROM ",b_zoc07,
                     "  WHERE ",g_mzoc02 ,"='", b_oldvalue, "'"
         PREPARE p_openin_pre5 FROM l_sql
         EXECUTE p_openin_pre5 INTO l_oldvalue
         IF STATUS THEN
            LET lr_err[li_k].line = ''
            LET lr_err[li_k].key1 = l_err_key CLIPPED,",",l_zoc.zoc02 CLIPPED,":",b_oldvalue CLIPPED,"/",l_chr200 CLIPPED
            CALL cl_getmsg('azz-997',g_lang) RETURNING l_msg
            LET lr_err[li_k].err  = l_zoc.zoc06,l_msg
            LET li_k = li_k + 1
            LET l_err_cnt = l_err_cnt + 1
         ELSE
            LET l_sql = " UPDATE ",p_zob02," SET ",b_zoc02,"='",l_oldvalue,"'",
                        "  WHERE ",g_ozoc02,"='",b_oldvalue,"'"
            PREPARE p_openin_pre6 FROM l_sql
            EXECUTE p_openin_pre6
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET lr_err[li_k].line = ''
               LET lr_err[li_k].key1 = l_err_key CLIPPED,",",l_zoc.zoc02 CLIPPED,":",b_oldvalue CLIPPED,"/",l_chr200 CLIPPED
               CALL cl_getmsg('azz-996',g_lang) RETURNING l_msg
               LET lr_err[li_k].err  = l_zoc.zoc06,l_msg
               LET li_k = li_k + 1
               LET l_err_cnt = l_err_cnt + 1
            END IF
         END IF
      END FOREACH
   END IF
#FUN-A40042 --End
 
   IF l_row_cnt != l_sum_row OR l_sum_row = 0  THEN
      CALL cl_close_progress_bar()
   END IF
 
  #LET l_row_cnt = l_row_cnt-5
 
  #IF l_row_cnt < 0 THEN 
  #   LET l_row_cnt = 0 
  #END IF
 
   #每個檔案完成後，寫入開帳資料匯入檔(zod_file)
  #DISPLAY "寫入開帳資料匯入檔開始",TIME         #No.FUN-910030        #MOD-AB0095 mark
   CALL p_openin_ins_zod(p_zoa03,p_zob02,p_fname,l_ins_row)
  #DISPLAY "寫入開帳資料匯入檔結束",TIME         #No.FUN-910030        #MOD-AB0095 mark  
 
   RETURN l_ins_row
 
 
   #-----No.FUN-8A0050 END-----
 
  ##-----No.FUN-8A0050 Mark-----
  #IF l_zob05 = 'Y' THEN
  ##僅匯入人工輸入字段
  #   LET g_sql = "SELECT zoc02 ",
  #               "  FROM zoc_file ",
  #               " WHERE zoc01 = '",p_zob02 CLIPPED,"' ",
  #               "   AND zoc05 IN ('0','5') ",   #'0'表示其為人工輸入欄位 '5'表示其為舊系統單號
  #               " ORDER BY ROWID"
  #ELSE
  ##匯入所有字段
  #   LET g_sql = "SELECT LOWER(column_name) ",
  #               "  FROM all_tab_columns ",
  #               " WHERE LOWER(table_name) = '",p_zob02 CLIPPED,"'",
  #               "   AND owner = UPPER('",g_dbs CLIPPED,"') ",
  #               " ORDER BY column_id "
  #END IF
 
  #LET l_cnt3 = 1
  #PREPARE p_openin_prepare2 FROM g_sql 
  #DECLARE p_openin_curs2 CURSOR FOR p_openin_prepare2
 
  #LET ls_sql1 = NULL
  #CALL l_column.clear()
  #FOREACH p_openin_curs2 INTO l_column[l_cnt3].col1
  #   IF SQLCA.sqlcode THEN EXIT FOREACH END IF
 
  #   LET ls_sql1 = ls_sql1 CLIPPED,",",l_column[l_cnt3].col1 CLIPPED
 
  #   SELECT gaq03 INTO l_column[l_cnt3].col2
  #     FROM gaq_file
  #    WHERE gaq01 = l_column[l_cnt3].col1
  #      AND gaq02 = g_lang
 
  #   LET l_cnt3 = l_cnt3 + 1
 
  #END FOREACH
  #CALL l_column.deleteElement(l_cnt3)
  #LET l_cnt3 = l_cnt3 - 1
  #LET ls_sql1 = ls_sql1.subString(2,ls_sql1.getLength())
  #LET li_n = l_column.getLength()
  #CALL l_column.clear()
 
  ##Excel
  #LET l_fname = p_fname CLIPPED,".xls"
  #LET l_cmd = "C:/TIPTOP/",l_fname
  #CALL ui.Interface.frontCall("standard","shellexec",[l_cmd] ,li_result)
  #CALL openin_checkError(li_result,"Open File")
  #CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",l_fname],[li_result])
  #CALL openin_checkError(li_result,"Connect File")
  #CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
  #CALL openin_checkError(li_result,"Connect SHeet1")
  #MESSAGE p_fname," File Analyze..."
 
  #LET li_flag = 'N'
  #LET li_i_r = 4  #Excel第一行/第二行/第三行預留給表頭
  #LET l_err_cnt = 0
  #LET l_no_b = NULL
  #LET l_no_e = NULL
  #LET l_old_no_b = NULL
  #LET l_old_no_e = NULL
  #LET l_cnt3 = 1
  #LET ls_sql1 = NULL
 
  #WHILE TRUE 
 
     #FOR li_i = 1 TO li_n
     #   IF li_i_r = 4 THEN
     #      #考慮到excel的列順序可能被打亂，故欄位值也要重新抓取(不過強烈不建議重抓)
     #      LET ls_cell_r = "R2"
     #      LET ls_cell_c = "C" || li_i CLIPPED
     #      LET ls_cell = ls_cell_r || ls_cell_c
     #      CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",l_fname,ls_cell],[li_result,ls_value])
     #      CALL openin_checkError(li_result,"Peek Cells")
     #      LET ls_value = ls_value.trim()
     #      LET l_column[l_cnt3].col1 = ls_value
     #      LET ls_sql1 = ls_sql1 CLIPPED,",",l_column[l_cnt3].col1 CLIPPED
     #      SELECT gaq03 INTO l_column[l_cnt3].col2
     #        FROM gaq_file
     #       WHERE gaq01 = l_column[l_cnt3].col1
     #         AND gaq02 = g_lang
     #      LET l_cnt3 = l_cnt3 + 1
     #   END IF
 
     #   LET ls_cell_r = "R" || li_i_r CLIPPED
     #   LET ls_cell_c = "C" || li_i CLIPPED
     #   LET ls_cell = ls_cell_r || ls_cell_c
     #   CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",l_fname,ls_cell],
     #                               [li_result,ls_value])
     #   CALL openin_checkError(li_result,"Peek Cells")
     #   LET ls_value = ls_value.trim()
 
     #   IF li_i = 1 THEN
     #      IF NOT cl_null(ls_value) THEN
     #        #表示讀到值了
     #        #保留舊值
     #        LET ls_value_o = ls_value
     #      ELSE
     #         #此行沒值，不應該繼續讀入，直接退出
     #         LET li_flag = 'Y'
     #         EXIT FOR
     #      END IF
     #   END IF
 
#    #   #轉碼
#    #   CALL p_openin_convert(ls_value)
#    #      RETURNING ls_value
 
     #   LET ls_value=cl_replace_str(ls_value,"'","~!@#")
     #   LET ls_value=cl_replace_str(ls_value,"~!@#","''")
     #   LET ls_value=cl_replace_str(ls_value,"\"\"","~!@#")
     #   LET ls_value=cl_replace_str(ls_value,"\"","")
     #   LET ls_value=cl_replace_str(ls_value,"~!@#","\"")
 
     #   #p_opentb設定影響考慮
     #                      #資料代碼 #檔案代號 #欄位名稱          #欄位值
     #   CALL p_openin_check(p_zoa03,p_zob02,l_column[li_i].col1,ls_value,li_i_r,p_fname,g_no) 
     #      RETURNING l_flag_1,ls_value,l_zoc03,l_zoc05            #No.FUN-8A0021 add zoc05
     #   IF l_flag_1 = 'Y' THEN
     #      EXIT FOR
     #   END IF
 
     #   #TQC-8A0003
     #   LET l_nullable='Y'
     #   LET g_sql = "SELECT nullable ",
     #               "  FROM all_tab_columns ",
     #               " WHERE LOWER(table_name) = '",p_zob02 CLIPPED,"'",
     #               "   AND owner = UPPER('",g_dbs CLIPPED,"') ",
     #               "   AND LOWER(column_name)= '",l_column[li_i].col1,"' ",
     #               " ORDER BY column_id "
     #   PREPARE p_openin_prepare31 FROM g_sql 
     #   DECLARE p_openin_curs31 CURSOR FOR p_openin_prepare31
     #   FOREACH p_openin_curs31 INTO l_nullable
     #     #DISPLAY l_nullable
     #   END FOREACH
     #   IF l_column[li_i].col1='bmadate' THEN
     #     #DISPLAY ls_value
     #   END IF
     #   #--
 
     #   CASE 
     #      WHEN l_zoc03 MATCHES 'DATE' 
     #         IF cl_null(ls_value) THEN
     #           #SELECT TO_DATE('1999/12/31','YYYY/MM/DD') INTO l_date FROM dual 
     #            LET l_date='' #TQC-8A0003
     #         ELSE
     #            #No.FUN-8A0021--begin
     #            IF l_zoc05='1' THEN
     #               IF ls_value = 'sysdate' THEN
     #                  LET l_date = g_today
     #               ELSE
     #                  LET l_date = ls_value
     #               END IF
     #            ELSE
     #            #No.FUN-8A0021--end
     #               #大陸簡體日期格式
     #               LET l_chr  = ls_value.subString(1,ls_value.getLength())   #No.FUN-890131
     #               IF ls_value.subString(5,5) = '-' THEN
     #                  SELECT TO_DATE(l_chr,'YYYY-MM-DD') INTO l_date FROM dual 
     #                  IF SQLCA.SQLCODE THEN
     #                     SELECT TO_DATE(l_chr,'YYYY-MM-D') INTO l_date FROM dual
     #                     IF SQLCA.SQLCODE THEN 
     #                        SELECT TO_DATE(l_chr,'YYYY-M-DD') INTO l_date FROM dual
     #                        IF SQLCA.SQLCODE THEN 
     #                           SELECT TO_DATE(l_chr,'YYYY-M-D') INTO l_date FROM dual
     #                           IF SQLCA.SQLCODE THEN 
     #                              SELECT TO_DATE(l_chr,'MM-DD-YYYY') INTO l_date FROM dual
     #                           END IF
     #                        END IF
     #                     END IF
     #                  END IF
     #               ELSE
     #                  #台灣繁體日期格式
     #                  SELECT TO_DATE(l_chr,'YYYY/MM/DD') INTO l_date FROM dual
     #                  IF SQLCA.SQLCODE THEN
     #                     SELECT TO_DATE(l_chr,'YYYY/MM/D') INTO l_date FROM dual
     #                     IF SQLCA.SQLCODE THEN 
     #                        SELECT TO_DATE(l_chr,'YYYY/M/DD') INTO l_date FROM dual
     #                        IF SQLCA.SQLCODE THEN 
     #                           SELECT TO_DATE(l_chr,'YYYY/M/D') INTO l_date FROM dual
     #                           IF SQLCA.SQLCODE THEN 
     #                              SELECT TO_DATE(l_chr,'MM/DD/YYYY') INTO l_date FROM dual 
     #                           END IF
     #                        END IF
     #                     END IF
     #                  END IF
     #               END IF
     #            END IF            #No.FUN-8A0021
     #         END IF
     #         #TQC-8A0003
     #        #LET ls_sql2 = ls_sql2 CLIPPED,",'",l_date CLIPPED,"'"
     #         IF cl_null(l_date) THEN
     #            LET ls_sql2 = ls_sql2 CLIPPED,",'' "
     #         ELSE
     #            LET ls_sql2 = ls_sql2 CLIPPED,",'",l_date CLIPPED,"'"
     #         END IF
     #         #--
 
     #      WHEN l_zoc03 MATCHES 'NUMBER'
     #         IF cl_null(ls_value) THEN LET ls_value = 0 END IF
     #         LET ls_sql2 = ls_sql2 CLIPPED,",",ls_value CLIPPED
     #      OTHERWISE
     #         #TQC-8A0003
     #        #LET ls_sql2 = ls_sql2 CLIPPED,",'",ls_value CLIPPED,"'"
     #         IF cl_null(ls_value) AND l_nullable='N' THEN
     #            LET ls_sql2 = ls_sql2 CLIPPED,",' '"
     #         ELSE
     #            LET ls_sql2 = ls_sql2 CLIPPED,",'",ls_value CLIPPED,"' "
     #         END IF
     #         #--
 
     #   END CASE
     #END FOR
 
     #IF li_flag = 'Y' THEN
     #   EXIT WHILE
     #END IF
 
     #IF l_flag_1 = 'Y' THEN
     #   LET li_i_r = li_i_r + 1
     #   CONTINUE WHILE
     #END IF
 
     #IF li_i_r = 4 THEN
     #   CALL l_column.deleteElement(l_cnt3)
     #   LET l_cnt3 = l_cnt3 - 1
     #   LET ls_sql1 = ls_sql1.subString(2,ls_sql1.getLength())
     #END IF
     #LET ls_sql2 = ls_sql2.subString(2,ls_sql2.getLength())
 
     ##插入資料
     #IF l_zob05 = 'Y' THEN
     #   LET ls_sql3 = NULL
     #   LET ls_sql4 = NULL
     #   LET ls_value = NULL
 
     #   LET g_sql = "SELECT LOWER(column_name),LOWER(data_type),nullable ",
     #               "  FROM all_tab_columns ",
     #               " WHERE LOWER(table_name) = '",p_zob02 CLIPPED,"'",
     #               "   AND owner = UPPER('",g_dbs CLIPPED,"') ",
     #               "   AND LOWER(column_name) NOT IN ( ",
     #               "SELECT zoc02 ",
     #               "  FROM zoc_file ",
     #               " WHERE zoc01 = '",p_zob02 CLIPPED,"' ",
     #               "   AND zoc05 IN ('0','5')) ",   #'0'表示其為人工輸入欄位 '5'表示其為舊系統單號
     #               " ORDER BY column_id "
     #   PREPARE p_openin_prepare3 FROM g_sql 
     #   DECLARE p_openin_curs3 CURSOR FOR p_openin_prepare3
     #   FOREACH p_openin_curs3 INTO l_column_name,l_data_type,l_nullable
     #      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
 
     #      #p_opentb設定影響考慮
     #                         #資料代碼 #檔案代號 #欄位名稱          #欄位值
     #      CALL p_openin_check(p_zoa03,p_zob02,l_column_name,ls_value,li_i_r,p_fname,g_no)  
     #         RETURNING l_flag_1,ls_value,l_zoc03,l_zoc05            #No.FUN-8A0021 add zoc05
     #      IF l_flag_1 = 'Y' THEN
     #         EXIT FOREACH
     #      END IF
 
     #      IF l_nullable = 'N' AND cl_null(ls_value) THEN
     #         LET ls_sql4 = ls_sql4 CLIPPED,",'0'"
     #      ELSE
     #         CASE 
     #            WHEN l_zoc03 MATCHES 'DATE' 
     #               IF cl_null(ls_value) THEN
     #                  SELECT TO_DATE('1999/12/31','YYYY/MM/DD') INTO l_date FROM dual 
     #               ELSE
     #                  #No.FUN-8A0021--begin
     #                  IF l_zoc05='1' THEN
     #                     IF ls_value = 'sysdate' THEN
     #                        LET l_date = g_today
     #                     ELSE
     #                        LET l_date = ls_value
     #                     END IF
     #                  ELSE
     #                  #No.FUN-8A0021--end
     #                     #大陸簡體日期格式
     #                     LET l_chr  = ls_value.subString(1,10)
     #                     IF ls_value.subString(5,5) = '-' THEN
     #                        SELECT TO_DATE(l_chr,'YYYY-MM-DD') INTO l_date FROM dual 
     #                        IF SQLCA.SQLCODE THEN
     #                           SELECT TO_DATE(l_chr,'YYYY-MM-D') INTO l_date FROM dual
     #                           IF SQLCA.SQLCODE THEN 
     #                              SELECT TO_DATE(l_chr,'YYYY-M-DD') INTO l_date FROM dual
     #                              IF SQLCA.SQLCODE THEN 
     #                                 SELECT TO_DATE(l_chr,'YYYY-M-D') INTO l_date FROM dual
     #                                 IF SQLCA.SQLCODE THEN 
     #                                    SELECT TO_DATE(l_chr,'MM-DD-YYYY') INTO l_date FROM dual
     #                                 END IF
     #                              END IF
     #                           END IF
     #                        END IF
     #                     ELSE
     #                        #台灣繁體日期格式
     #                        SELECT TO_DATE(l_chr,'YYYY/MM/DD') INTO l_date FROM dual
     #                        IF SQLCA.SQLCODE THEN
     #                           SELECT TO_DATE(l_chr,'YYYY/MM/D') INTO l_date FROM dual
     #                           IF SQLCA.SQLCODE THEN 
     #                              SELECT TO_DATE(l_chr,'YYYY/M/DD') INTO l_date FROM dual
     #                              IF SQLCA.SQLCODE THEN 
     #                                 SELECT TO_DATE(l_chr,'YYYY/M/D') INTO l_date FROM dual
     #                                 IF SQLCA.SQLCODE THEN 
     #                                    SELECT TO_DATE(l_chr,'MM/DD/YYYY') INTO l_date FROM dual 
     #                                 END IF
     #                              END IF
     #                           END IF
     #                        END IF
     #                     END IF
     #                  END IF             #No.FUN-8A0021
     #               END IF
     #               LET ls_sql4 = ls_sql4 CLIPPED,",'",l_date CLIPPED,"'"
     #            WHEN l_zoc03 MATCHES 'NUMBER'
     #               IF cl_null(ls_value) THEN LET ls_value = 0 END IF
     #               LET ls_sql4 = ls_sql4 CLIPPED,",",ls_value CLIPPED
     #            OTHERWISE
     #               LET ls_sql4 = ls_sql4 CLIPPED,",'",ls_value CLIPPED,"'"
     #         END CASE
     #      END IF
 
     #      LET ls_sql3 = ls_sql3 CLIPPED,",",l_column_name CLIPPED
     #      LET ls_value = NULL
     #   END FOREACH
     #   IF l_flag_1 = 'Y' THEN
     #      LET li_i_r = li_i_r + 1
     #      CONTINUE WHILE
     #   END IF
     #   LET ls_sql3 = ls_sql3.subString(2,ls_sql3.getLength())
     #   LET ls_sql4 = ls_sql4.subString(2,ls_sql4.getLength())
     #   IF cl_null(ls_sql3) AND cl_null(ls_sql4) THEN
     #      LET g_sql = "INSERT INTO ",p_zob02," (",ls_sql1,") VALUES (",ls_sql2,")" 
     #   ELSE
     #      LET g_sql = "INSERT INTO ",p_zob02," (",ls_sql1,",",ls_sql3,") VALUES (",ls_sql2,",",ls_sql4,")" 
     #   END IF
     #ELSE
     #   LET g_sql = "INSERT INTO ",p_zob02," (",ls_sql1,") VALUES (",ls_sql2,")" 
     #END IF
 
     #PREPARE execute_sql FROM g_sql
     #EXECUTE execute_sql
     #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #   LET lr_err[li_k].line = li_i_r
#    #   LET lr_err[li_k].key1 = ls_value_o
     #   LET lr_err[li_k].key1 = g_sql
     #   LET lr_err[li_k].err  = SQLCA.sqlcode
     #   LET li_k = li_k + 1
     #   LET l_err_cnt = l_err_cnt + 1
     #END IF
 
     #LET li_i_r = li_i_r + 1
  #END WHILE
  #CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result])
  #CALL openin_checkError(li_result,"Finish")
  #CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL",l_fname],[li_result])
  #CALL openin_checkError(li_result,"Finish")
  #
  #LET li_i_r = li_i_r - 1
  #LET li_i_r = li_i_r - 3   #減去三行抬頭
 
  ##每個檔案完成後，寫入開帳資料匯入檔(zod_file)
  #CALL p_openin_ins_zod(p_zoa03,p_zob02,p_fname,(li_i_r-l_err_cnt))
 
  #RETURN li_i_r
  ##-----No.FUN-8A0050 Mark END-----
END FUNCTION
 
FUNCTION openin_checkError(p_result,p_msg)
   DEFINE   p_result   SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  SMALLINT
 
   IF p_result THEN
      RETURN
   END IF
  #DISPLAY p_msg," DDE ERROR:"     #MOD-AB0095 mark
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
  #DISPLAY ls_msg                  #MOD-AB0095 mark
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
  #IF NOT li_result THEN                  #MOD-AB0095 mark
  #   DISPLAY "Exit with DDE Error."      #MOD-AB0095 mark
  #END IF                                 #MOD-AB0095 mark
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  # FUN-B80037--add--
   EXIT PROGRAM
END FUNCTION
 
#暫時Mark
#FUNCTION p_openin_convert(ps_value)
#   DEFINE ps_value    STRING
#   DEFINE ls_value    STRING
#   DEFINE ls_sys_lang STRING
#   DEFINE ms_b5_gb    STRING
#   DEFINE l_cmd       STRING
#   DEFINE l_channel   base.Channel
#   DEFINE l_name1     LIKE type_file.chr50
#   DEFINE l_dir1      LIKE type_file.chr50
#   DEFINE l_name2     LIKE type_file.chr50
#   DEFINE l_dir2      LIKE type_file.chr50
#   DEFINE l_string    STRING
#  
#   LET l_name1 = g_user CLIPPED,'from.txt'
#   LET l_name2 = g_user CLIPPED,'to.txt'
#   LET l_dir1 = FGL_GETENV("TEMPDIR") CLIPPED,'\/',l_name1 CLIPPED
#   LET l_dir2 = FGL_GETENV("TEMPDIR") CLIPPED,'\/',l_name2 CLIPPED
#
#   LET l_channel = base.Channel.create()
#   CALL l_channel.openFile(l_dir1 CLIPPED,"w")
#   LET l_string = ps_value
#   CALL l_channel.writeLine(l_string)
#   CALL l_channel.close()
#   
#   LET ls_sys_lang = FGL_GETENV("LANG")
#   IF ls_sys_lang.getIndexOF("big5",1) THEN
#      LET l_cmd = "iconv -f utf8 -t big5 < ",l_dir1," > ",l_dir2
#   ELSE
#      LET l_cmd = "iconv -f utf8 -t gb2312 < ",l_dir1," > ",l_dir2
#   END IF
#   RUN l_cmd
#
#   LET l_channel = base.Channel.create()
#   CALL l_channel.openFile(l_dir2 CLIPPED,"r")
#   LET ls_value = l_channel.readLine()
#   CALL l_channel.close()
#   
#   LET l_cmd = "rm ",l_dir1
#   RUN l_cmd
#
#   LET l_cmd = "rm ",l_dir2
#   RUN l_cmd
#
#   RETURN ls_value
#END FUNCTION
 
FUNCTION p_openin_getno(p_zoa03,p_zob02)
   DEFINE p_zoa03   LIKE zoa_file.zoa03
   DEFINE p_zob02   LIKE zob_file.zob02
   DEFINE l_cnt4    LIKE type_file.num5
 
   #開窗請使用者輸入‘匯入序號’,check 不可已存在zod_file中
   LET g_success = 'Y'
   OPEN WINDOW openin_1_w AT 3,3 WITH FORM "azz/42f/p_openin_1"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("p_openin_1")
 
   INPUT g_no FROM no01
 
      BEFORE INPUT
         CALL p_openin_getmax_no(p_zoa03,p_zob02)
 
      AFTER FIELD no01
         IF NOT cl_null(g_no) THEN
            SELECT COUNT(*) INTO l_cnt4 FROM zod_file WHERE zod02 = g_no
            IF l_cnt4 > 0 THEN
               CALL cl_err(g_no,'afa-132',1)
               NEXT FIELD no01
            END IF
         END IF
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
   END IF
 
   CLOSE WINDOW openin_1_w
END FUNCTION
 
FUNCTION p_openin_getmax_no(p_zoa03,p_zob02)
   DEFINE p_zoa03   LIKE zoa_file.zoa03
   DEFINE p_zob02   LIKE zob_file.zob02
   DEFINE l_chr2    LIKE type_file.chr2
   DEFINE l_zod02   LIKE zod_file.zod02
 
   LET g_sql = "SELECT MAX(zod02) ",
               "  FROM zod_file ",
        #      " WHERE zod01 LIKE '",p_zob02 CLIPPED,"%' "
               " WHERE zod02 LIKE '",p_zoa03 CLIPPED,"%' " 
   PREPARE zod_pre1 FROM g_sql
   EXECUTE zod_pre1 INTO l_zod02
   IF SQLCA.sqlcode OR cl_null(l_zod02) THEN 
      LET g_no = p_zoa03 CLIPPED,"_01" 
   ELSE
      LET l_chr2 = l_zod02[FGL_WIDTH(p_zoa03)+2,FGL_WIDTH(l_zod02)] + 1
      IF l_chr2 < 10 THEN
         LET g_no = l_zod02[1,FGL_WIDTH(p_zoa03)],"_0",l_chr2
      ELSE
         LET g_no = l_zod02[1,FGL_WIDTH(p_zoa03)],"_",l_chr2
      END IF
   END IF
END FUNCTION
 
FUNCTION p_openin_ins_zod(p_zoa03,p_zob02,p_fname,p_cnt)
   DEFINE p_zoa03 LIKE zoa_file.zoa03
   DEFINE p_zob02 LIKE zob_file.zob02
   DEFINE l_zob02 LIKE zob_file.zob02
   DEFINE p_fname LIKE type_file.chr50
   DEFINE p_cnt   LIKE type_file.num10
   DEFINE l_zod   RECORD LIKE zod_file.*
   DEFINE l_zoa07 LIKE zoa_file.zoa07
   DEFINE l_zoc02_5 LIKE zoc_file.zoc02   #No.FUN-8A0050
   DEFINE l_zoc02_6 LIKE zoc_file.zoc02   #No.FUN-8A0050
 
   LET g_success = 'Y'
   INITIALIZE l_zod.* TO NULL
 
   SELECT zoc02 INTO l_zoc02_5 FROM zoc_file
    WHERE zoc01 = p_zob02
      AND zoc05 ='5'
 
   SELECT zoc02 INTO l_zoc02_6 FROM zoc_file
    WHERE zoc01 = p_zob02
      AND zoc05 ='6'
 
   IF NOT cl_null(l_zoc02_5) THEN
      #舊系統唯一值最大值
      LET g_sql =" SELECT MAX(",l_zoc02_5 CLIPPED,")",
                 "   FROM ",p_zob02,
                 "  WHERE ",l_zoc02_6,"='",g_no,"'"
      
      PREPARE no_e_pre FROM g_sql
      
      DECLARE no_e_cur CURSOR FOR no_e_pre
      
      OPEN no_e_cur 
      
      FETCH no_e_cur INTO l_old_no_e
      
      #舊系統唯一值最小值
      LET g_sql =" SELECT MIN(",l_zoc02_5 CLIPPED,")",
                 "   FROM ",p_zob02,
                 "  WHERE ",l_zoc02_6,"='",g_no,"'"
      
      PREPARE no_b_pre FROM g_sql
      
      DECLARE no_b_cur CURSOR FOR no_e_pre
      
      OPEN no_b_cur 
      
      FETCH no_b_cur INTO l_old_no_b
   END IF
 
   LET l_zod.zod00 = p_zoa03    #資料代號
   LET l_zod.zod01 = p_zob02    #檔案代號
   LET l_zod.zod02 = g_no       #匯入序號
   LET l_zod.zod03 = p_fname    #匯入檔名
   LET l_zod.zod04 = g_today    #匯入日期
   LET l_zod.zod05 = g_user     #匯入者
   LET l_zod.zod06 = p_cnt      #匯入筆數
   LET l_zod.zod07 = l_old_no_b #舊系統起始單號
   LET l_zod.zod08 = l_old_no_e #舊系統截止單號
   LET l_zod.zod09 = l_no_b     #TP起始單號
   LET l_zod.zod10 = l_no_e     #TP截止單號
   LET l_zod.zod11 = 'N'        #已刪除否
   LET l_zod.zod12 = 'N'        #已檢核否
 
   INSERT INTO zod_file VALUES (l_zod.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","zod_file",l_zod.zod01,l_zod.zod02,SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
 
  ##回寫zoa_file資料
  ##只考慮主檔資料
  ##判斷是否是zob_file資料的第一筆
  #CALL p_openin_first_zob(p_zoa03)
  #   RETURNING l_zob02
 
  #IF l_zob02 = p_zob02 THEN
  #   SELECT zoa07 INTO l_zoa07
  #     FROM zoa_file
  #    WHERE zoa03 = l_zod.zod00
  #   IF cl_null(l_zoa07) THEN LET l_zoa07 = 0 END IF
 
  #   LET l_zoa07 = l_zoa07 + l_zod.zod06
  #   UPDATE zoa_file SET zoa05 = l_zod.zod04,
  #                       zoa06 = l_zod.zod05,
  #                       zoa07 = l_zoa07
  #                 WHERE zoa03 = l_zod.zod00
  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #      CALL cl_err3("upd","zoa_file",l_zod.zod00,"",SQLCA.sqlcode,"","",1)
  #      LET g_success = 'N'
  #   END IF
  #END IF
END FUNCTION
 
#基本資料狀況
FUNCTION p_openin_base_info()
   DEFINE l_zoa03   LIKE zoa_file.zoa03
 
   CALL fgl_set_arr_curr(l_ac)
 
   IF l_ac > 0 THEN
      LET l_zoa03 = g_zoa[l_ac].zoa03
   ELSE
      RETURN
   END IF
 
   IF l_ac = 0 THEN
      LET l_ac = 1
   END IF
   LET l_zoa03 = g_zoa[l_ac].zoa03
 
   OPEN WINDOW openin_2_w AT 3,3 WITH FORM "azz/42f/p_openin_2"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("p_openin_2")
   
   LET g_sql ="SELECT zoa03,'',zoc02,zoc07,'' ",
              "  FROM zoa_file,zob_file,zoc_file ",
              " WHERE zoa01 = '",g_zoa[l_ac].zoa01,"'",
              "   AND zoa03 = '",l_zoa03,"'",
              "   AND zoa03 = zob01 ",
              "   AND zob02 = zoc01 ",
              " ORDER BY zoa03"
   PREPARE p_openin_p3 FROM g_sql      #預備一下
   DECLARE zoa_curs_3 CURSOR FOR p_openin_p3
 
   CALL g_zoa_1.clear()
   LET l_ac_3 = 1
   FOREACH zoa_curs_3 INTO g_zoa_1[l_ac_3].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    
      SELECT gaz03 INTO g_zoa_1[l_ac_3].gaz03
        FROM gaz_file 
       WHERE gaz01 = g_zoa_1[l_ac_3].zoa03
         AND gaz02 = g_lang   
 
      IF l_ac_3 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      LET l_ac_3 = l_ac_3 + 1
   END FOREACH
   CALL g_zoa_1.deleteElement(l_ac_3)
   CALL p_openin_bp_2_refresh()
 
   CLOSE WINDOW openin_2_w
END FUNCTION
 
FUNCTION p_openin_bp_2_refresh()
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zoa_1 TO s_zoa_1.* ATTRIBUTE(COUNT=l_ac_3,UNBUFFERED)
 
      ON ACTION exit
         EXIT DISPLAY
 
      ON ACTION cancel
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#p_opentb設定影響考慮
FUNCTION p_openin_check(p_zoa03,p_zob02,p_gaq01,p_value,p_n,p_fname,p_no)  
   DEFINE p_zoa03   LIKE zoa_file.zoa03  #資料代碼
   DEFINE p_zob02   LIKE zob_file.zob02  #檔案代碼
   DEFINE p_gaq01   LIKE gaq_file.gaq01  #欄位代碼
   DEFINE p_value   STRING
   DEFINE p_n       LIKE type_file.num5  #目前資料所在行數
   DEFINE p_fname   STRING               #本次匯入檔名
   DEFINE p_no      LIKE zod_file.zod02  #本次匯入序號   add by douzh
   DEFINE l_zoa04   LIKE zoa_file.zoa03  #單別
   DEFINE l_zoc03   LIKE zoc_file.zoc03  #資料型態
   DEFINE l_zoc04   LIKE zoc_file.zoc04  #資料長度
   DEFINE l_zoc05   LIKE zoc_file.zoc05  #資料類型
   DEFINE l_zoc06   LIKE zoc_file.zoc06  #資料預設值
   DEFINE l_zoc07   LIKE zoc_file.zoc07  #資料判斷檔案
   DEFINE l_zoc08   LIKE zoc_file.zoc08  #資料判斷欄位
   DEFINE l_zoc09   LIKE zoc_file.zoc09  #關聯keyi值
   DEFINE l_zob02   LIKE zob_file.zob02  #檔案代碼
   DEFINE l_zoc02   LIKE zoc_file.zoc02  #欄位代碼
   DEFINE l_zoc02_1 LIKE zoc_file.zoc02  #欄位代碼
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_flag_1  LIKE type_file.chr1  #目前資料是否異常 N:無異常 Y:異常
   DEFINE l_sys     LIKE zz_file.zz011   #系統別
   DEFINE li_result LIKE type_file.chr1 
   DEFINE l_no      LIKE type_file.chr50 #系統單號
 
   LET l_flag_1 = 'N' 
 
   IF cl_null(p_zob02) OR cl_null(p_gaq01) THEN
      RETURN l_flag_1,p_value,l_zoc03
   END IF
 
   #判斷是否是zob_file資料的第一筆
   CALL p_openin_first_zob(p_zoa03)
      RETURNING l_zob02
 
   SELECT zoc03,zoc04,zoc05,zoc06,zoc07,zoc08,zoc09
     INTO l_zoc03,l_zoc04,l_zoc05,l_zoc06,l_zoc07,l_zoc08,l_zoc09
     FROM zoc_file
    WHERE zoc01 = p_zob02
      AND zoc02 = p_gaq01
    
   CASE l_zoc05
      #讀入excle資料
      WHEN "1"   #預設值
#No.FUN-8A0021--begin
        #IF l_zoc03='DATE' THEN #FUN-9C0147
         IF (l_zoc03='DATE' OR l_zoc03='date') THEN #FUN-9C0147
            #-----No.FUN-8A0050-----
            IF l_zoc06 = "sysdate" THEN
              #LET p_value = g_today   #MOD-C70294 mark
               LET p_value = g_today USING "YYYY/MM/DD"  #MOD-C70294
            ELSE 
              #LET p_value = l_zoc06   #MOD-C70294 mark
               LET p_value = l_zoc06 USING "YYYY/MM/DD"  #MOD-C70294
            END IF
            #-----No.FUN-8A0050 END-----
         ELSE
            LET p_value = l_zoc06
         END IF
#No.FUN-8A0021--end
      WHEN "2"   #單據編號
         IF l_zob02 = p_zob02 THEN
            SELECT zoa04 INTO l_zoa04
              FROM zoa_file
             WHERE zoa03 = p_zoa03
            IF cl_null(l_zoa04) THEN
               LET lr_err[li_k].line = p_n
               LET lr_err[li_k].key1 = p_zoa03 CLIPPED,",",p_zob02 CLIPPED,",",p_gaq01
               LET lr_err[li_k].err  = 'azz-515'
               LET li_k = li_k + 1
               LET l_err_cnt = l_err_cnt + 1
               LET l_flag_1 = 'Y' 
               EXIT CASE
            END IF
            LET p_value = l_zoa04
            SELECT zz011 INTO l_sys FROM zz_file WHERE zz01=p_zoa03
            CALL s_auto_assign_no(l_sys,p_value,g_today,"",p_zob02,p_gaq01,"","","")
               RETURNING li_result,p_value
            IF (NOT li_result) THEN
               LET lr_err[li_k].line = p_n
               LET lr_err[li_k].key1 = p_zoa03 CLIPPED,",",p_zob02 CLIPPED,",",p_gaq01
               LET lr_err[li_k].err  = 'mfg3326'
               LET li_k = li_k + 1
               LET l_err_cnt = l_err_cnt + 1
               LET l_flag_1 = 'Y' 
               EXIT CASE
            END IF
            IF cl_null(l_no_b) THEN
               LET l_no_b = p_value
            END IF
            LET l_no_e = p_value
         ELSE
            #找到主表資料的自動編碼字段
            SELECT zoc02 INTO l_zoc02
              FROM zoc_file
             WHERE zoc01 = l_zob02
               AND zoc05 = '2'
               AND ROWNUM = 1
            IF SQLCA.sqlcode THEN
               LET lr_err[li_k].line = p_n
               LET lr_err[li_k].key1 = p_zoa03 CLIPPED,",",p_zob02 CLIPPED,",",p_gaq01
               LET lr_err[li_k].err  = 'azz-510'
               LET li_k = li_k + 1
               LET l_err_cnt = l_err_cnt + 1
               LET l_flag_1 = 'Y' 
               EXIT CASE
            END IF
            SELECT zoc02 INTO l_zoc02_1
              FROM zoc_file
             WHERE zoc01 = l_zob02
               AND zoc05 = '5'
               AND ROWNUM = 1
            IF SQLCA.sqlcode THEN
               LET lr_err[li_k].line = p_n
               LET lr_err[li_k].key1 = p_zoa03 CLIPPED,",",p_zob02 CLIPPED,",",p_gaq01
               LET lr_err[li_k].err  = 'azz-516'
               LET li_k = li_k + 1
               LET l_err_cnt = l_err_cnt + 1
               LET l_flag_1 = 'Y' 
               EXIT CASE
            END IF
            LET g_sql = "SELECT ",l_zoc02,
                        "  FROM ",l_zob02,
                        " WHERE ",l_zoc02_1," = '",l_old_no,"' "
            PREPARE get_auto_01 FROM g_sql
            EXECUTE get_auto_01 INTO l_no
            LET p_value = l_no
            IF cl_null(l_no_b) THEN
               LET l_no_b = p_value
            END IF
            IF cl_null(l_no_e) THEN
               LET l_no_e = p_value
            END IF
            IF l_no_b > p_value THEN
               LET l_no_b = p_value
            END IF
            IF l_no_e < p_value THEN
               LET l_no_e = p_value
            END IF
         END IF
      WHEN "3"   #預設關聯
      #1.關聯來源于資料判斷檔案(zoc07)/資料判斷欄位(zoc08)/關聯key值(zoc09)
      #2.          實際存在的table     存在于zoc07(table)的欄位  當前table中的欄位
         CALL p_openin_associate_return(l_zoc07,l_zoc08,l_zoc09)
            RETURNING p_value
     #-----No.FUN-8A0050 Mark-----
     ##讀入excle資料
     #WHEN "5"   #舊系統單號(唯一值)
     #   IF cl_null(l_old_no_b) THEN
     #      LET l_old_no_b = p_value
     #   END IF
     #   IF cl_null(l_old_no_e) THEN
     #      LET l_old_no_e = p_value
     #   END IF
     #   IF l_old_no_b > p_value THEN
     #      LET l_old_no_b = p_value
     #   END IF
     #   IF l_old_no_e < p_value THEN
     #      LET l_old_no_e = p_value
     #   END IF
     #   IF l_zob02 = p_zob02 THEN
     #   ELSE
     #      #找到此表資料的自動編碼字段
     #      SELECT zoc02 INTO l_zoc02
     #        FROM zoc_file
     #       WHERE zoc01 = p_zob02
     #         AND zoc05 = '2'
     #         AND ROWNUM = 1
     #      IF SQLCA.sqlcode THEN
     #         LET lr_err[li_k].line = p_n
     #         LET lr_err[li_k].key1 = p_zoa03 CLIPPED,",",p_zob02 CLIPPED,",",p_gaq01
     #         LET lr_err[li_k].err  = 'azz-517'
     #         LET li_k = li_k + 1
     #         LET l_err_cnt = l_err_cnt + 1
     #         LET l_flag_1 = 'Y' 
     #         EXIT CASE
     #      END IF
     #      LET l_old_no = p_value
     #   END IF
     #-----No.FUN-8A0050 Mark END-----
      #對規格有疑問，暫不處理
      WHEN "6"   #存放匯入序號
#        LET p_value = p_fname.subString(1,10)    #匯入檔名
         LET p_value = p_no                       #匯入序號寫入
#FUN-A40042 --Begin
      WHEN "7"
         LET p_value = 'new-no',p_n
#FUN-A40042 --End
   END CASE
   IF l_flag_1 = 'Y' THEN
      RETURN l_flag_1,p_value,l_zoc03,l_zoc04,l_zoc05
   END IF
#  #一.zoc07/zoc08有值
#  IF cl_null(l_zoc07) OR cl_null(l_zoc08) THEN
#  ELSE
#     LET g_sql = "SELECT COUNT(*) FROM ",l_zoc07,
#                 " WHERE ",l_zoc08,"=",p_value
#     PREPARE check_zoc08 FROM g_sql
#     EXECUTE check_zoc08 INTO l_n
#     IF SQLCA.sqlcode THEN
#     END IF
#     IF l_n = 0 THEN
#        LET lr_err[li_k].line = p_n
#        LET lr_err[li_k].key1 = p_zoa03 CLIPPED,",",p_zob02 CLIPPED,",",p_gaq01,",",p_value
#        LET lr_err[li_k].err  = 'mfg3382'
#        LET li_k = li_k + 1
#        LET l_err_cnt = l_err_cnt + 1
#        LET l_flag_1 = 'Y' 
#        RETURN l_flag_1,p_value,l_zoc03
#     END IF
#  END IF
 
   RETURN l_flag_1,p_value,l_zoc03,l_zoc04,l_zoc05
END FUNCTION
 
#回寫zoa_file資料
#只考慮主檔資料
#判斷是否是zob_file資料的第一筆
FUNCTION p_openin_first_zob(p_zoa03)
   DEFINE p_zoa03 LIKE zoa_file.zoa03
   DEFINE l_zob02 LIKE zob_file.zob02
 
   SELECT zob02 INTO l_zob02
     FROM zob_file
    WHERE zob01 = p_zoa03
      AND ROWNUM = 1
    ORDER BY zob02          #FUN-9B0066
#   ORDER BY ROWID          #FUN-9B0066 mark
 
   RETURN l_zob02
END FUNCTION
 
FUNCTION p_openin_close_excel()
   DEFINE li_result LIKE type_file.chr1 
 
   CALL ui.interface.FrontCall('standard','shellexec',["ntsd -c q -pn excel.exe"],li_result)
END FUNCTION
 
#1.關聯來源于資料判斷檔案(zoc07)/資料判斷欄位(zoc08)/關聯key值(zoc09)
#2.          實際存在的table     存在于zoc07(table)的欄位  當前table中的欄位
FUNCTION p_openin_associate_return(p_zoc07,p_zoc08,p_zoc09)
   DEFINE p_zoc07     LIKE zoc_file.zoc07
   DEFINE p_zoc08     LIKE zoc_file.zoc08
   DEFINE p_zoc09     LIKE zoc_file.zoc09
   DEFINE l_zoc08     STRING
   DEFINE l_buf       base.StringBuffer
   DEFINE l_tok       base.StringTokenizer
   DEFINE ls_tok      STRING
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_chr50     LIKE type_file.chr50
   DEFINE li_return   STRING
   DEFINE l_zoc09_va  STRING
 
   IF cl_null(p_zoc07) OR cl_null(p_zoc08) OR cl_null(p_zoc09) THEN
      RETURN
   END IF
   
   LET li_return = NULL
   LET l_i = 0
   LET l_n = 0
   LET l_tok = base.StringTokenizer.createExt(ls_sql1 CLIPPED,",",'',TRUE)
   WHILE l_tok.hasMoreTokens()
      LET ls_tok = l_tok.nextToken()
      IF ls_tok = p_zoc09 THEN
         LET l_n = l_i + 1
         EXIT WHILE
      END IF
      LET l_i = l_i + 1
   END WHILE
   IF l_n > 0 THEN
      LET l_i = 0
      LET l_tok = base.StringTokenizer.createExt(ls_sql2 CLIPPED,",",'',TRUE)
      WHILE l_tok.hasMoreTokens()
         LET ls_tok = l_tok.nextToken()
         LET l_i = l_i + 1
         IF l_i = l_n THEN
            LET l_zoc09_va = ls_tok
            EXIT WHILE
         END IF
      END WHILE
   END IF
 
   IF l_n = 0 THEN
      LET l_i = 0
      LET l_tok = base.StringTokenizer.createExt(ls_sql3 CLIPPED,",",'',TRUE)
      WHILE l_tok.hasMoreTokens()
         LET ls_tok = l_tok.nextToken()
         IF ls_tok = p_zoc09 THEN
            LET l_n = l_i + 1
            EXIT WHILE
         END IF
         LET l_i = l_i + 1
      END WHILE
      IF l_n > 0 THEN
         LET l_i = 0
         LET l_tok = base.StringTokenizer.createExt(ls_sql4 CLIPPED,",",'',TRUE)
         WHILE l_tok.hasMoreTokens()
            LET ls_tok = l_tok.nextToken()
            LET l_i = l_i + 1
            IF l_i = l_n THEN
               LET l_zoc09_va = ls_tok
               EXIT WHILE
            END IF
         END WHILE
      END IF
   END IF
 
   LET l_zoc08 = p_zoc07
   LET l_buf = base.StringBuffer.create()
   CALL l_buf.append(l_zoc08)
   CALL l_buf.replace("_file","01",0)
   LET l_zoc08 = l_buf.toString()
   LET g_sql = "SELECT ",p_zoc08 CLIPPED,
               "  FROM ",p_zoc07 CLIPPED,
               " WHERE ",l_zoc08 CLIPPED," = ",l_zoc09_va CLIPPED
   PREPARE get_from_zoc08 FROM g_sql
   EXECUTE get_from_zoc08 INTO l_chr50
   LET li_return = l_chr50
 
   IF SQLCA.sqlcode THEN
   END IF
   RETURN li_return
END FUNCTION
#No.FUN-810012
 
FUNCTION p_openin_load(p_zob02)
   DEFINE p_zob02        LIKE zob_file.zob02
   DEFINE l_locale       LIKE type_file.chr1000
   DEFINE l_file         LIKE type_file.chr100
   DEFINE l_file1        LIKE type_file.chr100
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_status      LIKE type_file.num10
   DEFINE tok            base.StringTokenizer
   DEFINE tok1           base.StringTokenizer
   DEFINE l_loc          String
   DEFINE l_tmp          String
   DEFINE ms_codeset     String
   DEFINE l_zob02        LIKE zob_file.zob02 
   DEFINE l_str          String              
   DEFINE l_ret          LIKE type_file.num5 
 
   INITIALIZE li_status TO NULL
 
   #取得檔案代號
   LET tok1 = base.StringTokenizer.create(p_zob02,"_")
 
   WHILE tok1.hasMoreTokens()
      LET l_zob02 = tok1.nextToken()
      EXIT WHILE
   END WHILE
 
   LET l_str = '*',l_zob02,'*.txt' CLIPPED
 
   #開窗選取檔案
   LET l_locale = p_openin_browse_txt_file(l_str)
#  LET l_locale = cl_browse_file()
   IF cl_null(l_locale) THEN
      CALL cl_msgany(10,10,'give up!')
      RETURN ""
   END IF
   
   #取得檔名
   LET tok = base.StringTokenizer.create(l_locale,"/")
   WHILE tok.hasMoreTokens()
      LET l_loc = tok.nextToken()
   END WHILE
   
   #上傳至主機
   LET l_tmp = FGL_GETENV("TEMPDIR")
   LET l_file = l_tmp CLIPPED,"/",l_loc
   CALL cl_upload_file(l_locale, l_file) RETURNING li_status
   IF NOT li_status THEN
      CALL cl_msgany(10,10,'upload fail!')
      RETURN ""
   END IF
   
   #取得環境
   LET ms_codeset = cl_get_codeset()
 
  ##如為unicode環境，進行轉碼
  #IF ms_codeset = "UTF-8" THEN
  #   LET l_file1 = l_tmp CLIPPED,"/u_",l_loc
  #   LET l_cmd = "iconv -f big5 -t UTF-8 ",l_file," > ",l_file1
  #   RUN l_cmd
  #   LET l_loc = "u_",l_loc
  #   LET l_file = l_file1
  #END IF
 
   #將unicode 文字檔轉碼同系統環境設定
   CASE ms_codeset
      WHEN "UTF-8"
         LET l_file1 = l_tmp CLIPPED,"/u_",l_loc
         IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
#            LET l_cmd = "iconv -f UNICODE -t UTF-8 ",l_file," > ",l_file1      #CHI-B50010 mark
         #FUN-A30038--add--str--FOR WINDOWS
            #CHI-B50010 -- begin --
            LET l_cmd = "cp ",l_file," ",l_file1
            RUN l_cmd
            LET l_cmd = "ule2utf8 ",l_file1
            #CHI-B50010 -- end --
         ELSE
            LET l_cmd = "java -cp zhcode.jar zhcode -u8 ",l_file," > ",l_file1
         END IF
         #FUN-A30038--add--end
         RUN l_cmd
         LET l_loc = "u_",l_loc
         LET l_file = l_file1
      WHEN "BIG5"
         LET l_file1 = l_tmp CLIPPED,"/b_",l_loc
         IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
            LET l_cmd = "iconv -f UNICODE -t BIG5 ",l_file," > ",l_file1
         #FUN-A30038--add--str--FOR WINDOWS
         ELSE
            LET l_cmd = "java -cp zhcode.jar zhcode -ub ",l_file," > ",l_file1
         END IF
         #FUN-A30038--add--end
         RUN l_cmd
         LET l_loc = "b_",l_loc
         LET l_file = l_file1
      WHEN "GB2312"
         LET l_file1 = l_tmp CLIPPED,"/g_",l_loc
         IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
            LET l_cmd = "iconv -f UNICODE -t GB2312 ",l_file," > ",l_file1
         #FUN-A30038--add--str--FOR WINDOWS
         ELSE
            LET l_cmd = "java -cp zhcode.jar zhcode -ug ",l_file," > ",l_file1
         END IF
         #FUN-A30038--add--end
         RUN l_cmd
         LET l_loc = "g_",l_loc
         LET l_file = l_file1
   END CASE
 
   #killcr
   LET l_cmd = "killcr ",l_file
   RUN l_cmd
 
   #移除檔名之.txt字眼
   LET l_loc=cl_replace_str(l_loc,".txt","")
 
   RETURN l_loc
 
END FUNCTION
 
FUNCTION p_openin_browse_txt_file(p_name)
   DEFINE ls_file   STRING
   DEFINE p_name    STRING
 
   CALL ui.Interface.frontCall("standard",
                               "openfile",
                              #["C:", "分隔符號檔", "*.txt", "檔案瀏覽"],
                               ["C:", "分隔符號檔",p_name, "檔案瀏覽"],
                               [ls_file])
 
   IF STATUS THEN
      RETURN NULL
   END IF
 
   RETURN ls_file
 
END FUNCTION
 
#No.FUN-910030--begin
FUNCTION p_openin_select_db(ps_str)       
DEFINE l_dbs          LIKE type_file.chr50   
DEFINE l_ch           base.Channel
DEFINE l_aoos901_cmd  STRING
DEFINE ps_str         STRING                
 
 
################ for informix synonym ##############
    IF g_db_type="IFX" THEN
DISCONNECT ALL
DATABASE g_dbs
#CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
    END IF
####################################################
 
    IF g_action_choice = "create_synonym" THEN 
       IF g_db_type="ORA" THEN
 #        CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
         CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
         CLOSE DATABASE
         DATABASE g_dbs
 #        CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
         CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
       END IF
    ELSE
       LET l_aoos901_cmd="aoos901 '",ps_str,"' '",g_pid CLIPPED,"'"         
      #display "l_aoos901_cmd:",l_aoos901_cmd      #MOD-AB0095 mark
       CALL cl_cmdrun_wait("aoos901 '"||ps_str||"' '"||g_pid CLIPPED||"'") 
       CALL p_openin_set_win_title()
    END IF
 
    IF g_db_type="IFX" THEN
       LET l_ch = base.Channel.create()
       CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERALIASES|awk '{ print $2 }'","r")
      #WHILE l_ch.read(g_tcp_servername)                     #MOD-AB0095 mark
      #      DISPLAY "tcp_servername:",g_tcp_servername      #MOD-AB0095 mark
      #END WHILE                                             #MOD-AB0095 mark
       LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
       CALL l_ch.close()   #FUN-B90041
CONNECT TO l_dbs AS "MAIN"
       IF status THEN
          CALL l_ch.openPipe("cat $INFORMIXDIR/etc/$ONCONFIG|grep DBSERVERNAME|awk '{ print $2 }'","r")
         #WHILE l_ch.read(g_tcp_servername)                    #MOD-AB0095 mark
         #      DISPLAY "tcp_servername:",g_tcp_servername     #MOD-AB0095 mark
         #END WHILE                                            #MOD-AB0095 mark
          LET l_dbs=g_dbs CLIPPED,"@",g_tcp_servername CLIPPED
          CALL l_ch.close()   #FUN-B90041
CONNECT TO l_dbs AS "MAIN"
       END IF
    END IF
 
    CALL p_openin_b_fill(g_wc,g_wc2)  
    LET l_ac = 1
    CALL p_openin_b_fill2(" 1=1")   
 
    IF g_db_type="IFX" THEN
 
       CREATE TEMP TABLE tempidx(
              idxname LIKE type_file.chr1000,
              tabid   LIKE type_file.num10, 
              idxtype LIKE type_file.chr1,  
              part1   LIKE type_file.num5,  
              part2   LIKE type_file.num5,  
              part3   LIKE type_file.num5,  
              part4   LIKE type_file.num5,  
              part5   LIKE type_file.num5,  
              part6   LIKE type_file.num5,  
              part7   LIKE type_file.num5,  
              part8   LIKE type_file.num5,  
              part9   LIKE type_file.num5,  
              part10  LIKE type_file.num5,  
              part11  LIKE type_file.num5,  
              part12  LIKE type_file.num5,  
              part13  LIKE type_file.num5,  
              part14  LIKE type_file.num5,  
              part15  LIKE type_file.num5,  
              part16  LIKE type_file.num5,  
              dbname  LIKE type_file.chr20)
       
       CREATE TEMP TABLE tempidx2(
              idxname LIKE type_file.chr1000,
              tabid   LIKE type_file.num10, 
              idxtype LIKE type_file.chr1,  
              part1   LIKE type_file.num5,  
              part2   LIKE type_file.num5,  
              part3   LIKE type_file.num5,  
              part4   LIKE type_file.num5,  
              part5   LIKE type_file.num5,  
              part6   LIKE type_file.num5,  
              part7   LIKE type_file.num5,  
              part8   LIKE type_file.num5,  
              part9   LIKE type_file.num5,  
              part10  LIKE type_file.num5,  
              part11  LIKE type_file.num5,  
              part12  LIKE type_file.num5,  
              part13  LIKE type_file.num5,  
              part14  LIKE type_file.num5,  
              part15  LIKE type_file.num5,  
              part16  LIKE type_file.num5,  
              dbname  LIKE type_file.chr20)
    END IF
 
END FUNCTION
 
FUNCTION p_openin_set_win_title()
   DEFINE   lc_zo02     LIKE zo_file.zo02,
            lc_zx02     LIKE zx_file.zx02,
            lc_zz02     LIKE zz_file.zz02,
            ls_ze031    LIKE type_file.chr1000,
            ls_ze032    LIKE type_file.chr1000, 
            ls_msg      STRING,
            lwin_curr   ui.Window,
            l_sql       STRING,
            l_ch        base.channel
 
 
   # 選擇  使用者名稱(zx_file.zx02)
   LET l_sql="SELECT zx02,zx08 FROM zx_file WHERE zx01='",
             g_user CLIPPED,"'"
   PREPARE p_openin_set_win_tit_pre1 FROM l_sql
   EXECUTE p_openin_set_win_tit_pre1 INTO lc_zx02,g_plant
   IF (SQLCA.SQLCODE) THEN
      LET lc_zx02 = g_user
   END IF
   FREE p_openin_set_win_tit_pre1
   
   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant   #FUN-980014 add (抓出該營運中心所屬法人)
 
   LET l_ch=base.Channel.create()
   CALL l_ch.openPipe("cat $TEMPDIR/aoos901."||g_pid,"r")
   WHILE l_ch.read(g_plant)
   END WHILE
   CALL l_ch.close()   #FUN-B90041
 
   LET l_sql="SELECT azp03 FROM azp_file WHERE azp01='",
             g_plant CLIPPED,"'"
   PREPARE p_openin_set_win_tit_pre2 FROM l_sql
   EXECUTE p_openin_set_win_tit_pre2 INTO g_dbs
   IF (SQLCA.SQLCODE) THEN
      CALL cl_err3("sel","azp_file",g_plant,"",SQLCA.sqlcode,"","azp_file get error", 2)  #No.FUN-660081)   #No.FUN-660081
   END IF
   FREE p_openin_set_win_tit_pre2
 
#   CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
   CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
   CLOSE DATABASE
   DATABASE g_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
   CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
   IF (SQLCA.SQLCODE) THEN
      RETURN FALSE
   END IF
 
   # 選擇  程式名稱(gaz_file.gaz03)
   LET l_sql="SELECT gaz03 FROM gaz_file WHERE gaz01='",
             g_prog CLIPPED,"' AND gaz02='",g_lang CLIPPED,"'"
   PREPARE p_openin_set_win_tit_pre3 FROM l_sql
   EXECUTE p_openin_set_win_tit_pre3 INTO lc_zz02
   FREE p_openin_set_win_tit_pre3
 
   # 選擇  公司對內全名(zo_file.zo02)
   LET l_sql="SELECT zo02 FROM zo_file WHERE zo01='",
             g_lang CLIPPED,"'"
   PREPARE p_openin_set_win_tit_pre4 FROM l_sql
   EXECUTE p_openin_set_win_tit_pre4 INTO lc_zo02
   IF (SQLCA.SQLCODE) THEN
      LET lc_zo02 = "Empty"
   END IF
   FREE p_openin_set_win_tit_pre4
 
   LET l_sql="SELECT ze03 FROM ze_file WHERE ze01 = 'lib-035' AND ze02 = '",g_lang CLIPPED,"'"
   PREPARE p_openin_set_win_tit_pre5 FROM l_sql
   EXECUTE p_openin_set_win_tit_pre5 INTO ls_ze031
   FREE p_openin_set_win_tit_pre5
   LET l_sql="SELECT ze03 FROM ze_file WHERE ze01 = 'lib-036' AND ze02 = '",g_lang CLIPPED,"'"
   PREPARE p_openin_set_win_tit_pre6 FROM l_sql
   EXECUTE p_openin_set_win_tit_pre6 INTO ls_ze032
   FREE p_openin_set_win_tit_pre6
 
   LET ls_msg = lc_zz02 CLIPPED, "(", g_prog CLIPPED, ")  [", lc_zo02 CLIPPED, "]", "(", g_dbs CLIPPED, ")"
   LET ls_msg = ls_msg, "  ", ls_ze031 CLIPPED, ":", g_today, "  ", ls_ze032 CLIPPED, ":", lc_zx02 CLIPPED
 
   LET lwin_curr = ui.Window.getCurrent()
   CALL lwin_curr.setText(ls_msg)
END FUNCTION
#No.FUN-910030--end
