# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: p_replang.4gl
# Descriptions...: 轉換GRW作業上語言代碼作業
# Date & Author..: 10/04/02 by Jay
# Param : arg_val(1):gdm01
#         arg_val(2):0 | 1  是否開啟詢問從其他樣版參考欄位的視窗
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.TQC-B70055 11/07/07 By jacklai 修正GR報表多語言維護作業第一次整批新增時,只會產生目前語言別的資料的問題 
# Modify.........: No.FUN-C10044 12/01/13 By jacklai 表頭的公司地址等欄位說明寬度調整時，欄位值的定位點應跟隨調整 
# Modify.........: No.TQC-C20436 12/02/23 By janethuang 修改GR報表p_grw設定的長寬，抓寬:gdo03、長:gdo04
# Modify.........: No.FUN-C20112 12/02/24 By jacklai 上傳4rp改表格式比對
# Modify.........: No.FUN-C30008 12/03/03 By jacklai 可上傳語言別4rp,增加欄位及欄位說明對齊
# Modify.........: No.FUN-C30288 12/03/29 By jacklai 防止GR報表結構不合規則的單頭單身欄位進行行序的更改
# Modify.........: No:FUN-C40040 12/04/11 By LeoChang 客製路徑
# Modify.........: No:FUN-C40034 12/04/17 By janet 增加gdm26、gdm27兩個欄位
# Modify.........: No.FUN-C50015 12/05/03 By janet  修改路徑
# Modify.........: No.FUN-C50024 12/05/09 By downheal 匯出改為分散模式,增加匯出選項XLSX, RTF
# Modify.........: No.FUN-C40048 12/05/22 By odyliao 增加 $WINGREPORT 環境變數
# Modify.........: No:FUN-C50046 12/06/08 By janet 增加ACTION chkgrrule，呼叫gr檢查機制
# Modify.........: No:FUN-C90073 12/06/08 By janet 修改reportview function的路徑
# Modify.........: No.FUN-CB0063 12/11/15 by stellar 將GR檢查機制移到s_gr_upload內
# Modify.........: No.FUN-CC0005 12/12/10 by janet p_replang_resize_paper_size加一畫面的方向變數
# Modify.........: No.FUN-CC0092 12/12/13 by janet 報表預覽時，4rp的語系有誤，畫面一開啟是灰階'讀crip判斷空白、tab鍵
# Modify.........: No.FUN-D30026 13/04/11 by odyliao 紙張修改邏輯調整，彈窗詢問讓使用者選取建議值或輸入值


IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

#No.FUN-B40095
TYPE    gdm_sr_type RECORD
        gdm02       LIKE gdm_file.gdm02,  #序號
        gdm04       LIKE gdm_file.gdm04,  #報表欄位代碼
        gdm23       LIKE gdm_file.gdm23,  #報表欄位說明
        gdm05       LIKE gdm_file.gdm05,  #類別
        gdm06       LIKE gdm_file.gdm06,  #欄位屬性
        gdm07       LIKE gdm_file.gdm07,  #定位點
        gdm08       LIKE gdm_file.gdm08,  #欄位寬度
        gdm09       LIKE gdm_file.gdm09,  #行序
        gdm10       LIKE gdm_file.gdm10,  #欄位順序
        gdm11       LIKE gdm_file.gdm11,  #字型
        gdm12       LIKE gdm_file.gdm12,  #字型大小
        gdm13       LIKE gdm_file.gdm13,  #粗體否
        gdm14       LIKE gdm_file.gdm14,  #顏色
        gdm15       LIKE gdm_file.gdm15,  #欄位說明寬度
        gdm16       LIKE gdm_file.gdm16,  #欄位說明字型
        gdm17       LIKE gdm_file.gdm17,  #欄位說明字型大小
        gdm18       LIKE gdm_file.gdm18,  #欄位說明粗體否
        gdm19       LIKE gdm_file.gdm19,  #欄位說明顏色
        gdm20       LIKE gdm_file.gdm20,  #折行
        gdm21       LIKE gdm_file.gdm21,  #隱藏
        gdm22       LIKE gdm_file.gdm22,  #欄位說明隱藏
        gdm24       LIKE gdm_file.gdm24,  #欄位水平對齊     #FUN-C30008
        gdm25       LIKE gdm_file.gdm25,   #欄位說明水平對齊   #FUN-C30008
        gdm26       LIKE gdm_file.gdm26,   #控制欄位隱藏公式   #FUN-C40034 ADD
        gdm27       LIKE gdm_file.gdm27    #欄位說明隱藏公式   #FUN-C40034 ADD
        END RECORD

TYPE    gdw_sr_type RECORD
        gdw01       LIKE gdw_file.gdw01,  #程式代號
        gdw02       LIKE gdw_file.gdw02,  #樣板代號
        gdw05       LIKE gdw_file.gdw05,  #使用者
        gdw04       LIKE gdw_file.gdw04,  #權限類別
        gdw06       LIKE gdw_file.gdw06,  #行業別
        gdw03       LIKE gdw_file.gdw03,  #客製
        gdw09       LIKE gdw_file.gdw09   #樣版名稱(4rp檔名)
        END RECORD

DEFINE g_gdw08      LIKE gdw_file.gdw08,            # 報表樣板ID
       g_gdw        gdw_sr_type,                    # 單頭變數
       g_gdw_t      gdw_sr_type,                    # 單頭變數舊值
       g_gdm        DYNAMIC ARRAY OF gdm_sr_type,   # 程式變數
       g_gdm_t      gdm_sr_type,                    # 變數舊值
       g_wc         STRING,
       g_wc2        STRING,
       g_sql        STRING,
       #g_ss        LIKE type_file.chr1,            # 決定後續步驟
       g_rec_b      LIKE type_file.num5,            # 單身筆數     SMALLINT
       l_ac         LIKE type_file.num5             # 目前處理的ARRAY CNT  SMALLINT
DEFINE g_gdm03              LIKE gdm_file.gdm03
DEFINE g_gaz03              LIKE gaz_file.gaz03
DEFINE g_zx02               LIKE zx_file.zx02
DEFINE g_zw02               LIKE zw_file.zw02
DEFINE g_cnt                LIKE type_file.num10    # INTEGER
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_forupd_sql         STRING
DEFINE g_before_input_done  LIKE type_file.num5     # SMALLINT
DEFINE g_argv1              LIKE gdm_file.gdm01
DEFINE g_argv2              STRING
DEFINE g_curs_index         LIKE type_file.num10    # INTEGER
DEFINE g_row_count          LIKE type_file.num10    # INTEGER
DEFINE g_jump               LIKE type_file.num10    # INTEGER
DEFINE g_no_ask             LIKE type_file.num5     # SMALLINT
DEFINE g_std_id             LIKE smb_file.smb01
DEFINE g_db_type            LIKE type_file.chr3
DEFINE g_4rpdir             STRING
DEFINE g_label_rmargin      LIKE type_file.num15_3
DEFINE g_max_master_lines   LIKE type_file.num5
DEFINE g_max_detail_lines   LIKE type_file.num5
DEFINE g_sel_row            INTEGER
DEFINE g_master_max_width   LIKE type_file.num15_3
DEFINE g_detail_max_width   LIKE type_file.num15_3
DEFINE g_hgap               LIKE type_file.num15_3
DEFINE g_update_flag        LIKE type_file.num5
DEFINE g_paper_size         LIKE gdo_file.gdo02
DEFINE g_orientation        LIKE type_file.chr1
DEFINE g_chk_err_msg        STRING  #FUN-C10044 #檢查報表命名規則的錯誤訊息
#DEFINE g_paper_width        LIKE gdo_file.gdo03  #TQC-C20436 add 紙張寬度
#DEFINE g_paper_length        LIKE gdo_file.gdo03  #TQC-C20436 add 紙張長度
DEFINE g_paper_size_input   LIKE gdo_file.gdo02  #FUN-D30026
DEFINE g_orientation_input  LIKE type_file.chr1  #FUN-D30026



MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵,由程式處理

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_gdw_t.* TO NULL

   #一般行業別代碼
   LET g_std_id = "std"

   OPEN WINDOW p_replang_w WITH FORM "azz/42f/p_replang"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)

   CALL cl_ui_init()

   #初始化設定值
   LET g_label_rmargin = 0.100

   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gdm03")

   # 行業別選項
   CALL cl_set_combo_industry("gdw06")
   LET g_db_type = cl_db_get_database_type()

   LET g_forupd_sql =  "SELECT gdm02,gdm04,gdm23,gdm05,gdm06,",
                       "       gdm07,gdm08,gdm09,gdm10,gdm11,",
                       "       gdm12,gdm13,gdm14,gdm15,gdm16,",
                       "       gdm17,gdm18,gdm19,gdm20,gdm21,",
                       "       gdm22,gdm24,gdm25,gdm26,gdm27", #FUN-C30008 add gdm24,gdm25 #FUN-C40043 ADD gdm26,gdm27
                       " FROM gdm_file ",
                       " WHERE gdm01=? AND gdm02=? AND gdm03=?",
                       " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_replang_lock_u CURSOR FROM g_forupd_sql

   IF NOT cl_null(g_argv1) THEN
      CALL cl_set_comp_entry("gdw01,gdw02,gdw05,gdw04,gdw06,gdw09,gdw03",FALSE)
      CALL p_replang_q()
      CALL cl_set_action_active("query",FALSE)
      CALL cl_set_act_visible("query",FALSE)
      #FUN-C30008 --start--
      #命令列參數2改成全部重新掃描4rp
      IF NOT cl_null(g_argv2) THEN
         IF g_argv2 = "1" THEN
            CALL p_replang_rescanall()   #詢問並抓取 4rp內的待轉換資料 #FUN-C30008 mark
         END IF
      END IF
      #FUN-C30008 --end--
   ELSE
      #FUN-CC0092 mark -(s)
      #CALL cl_set_comp_entry("gdw01,gdw02,gdw05,gdw04,gdw06,gdw09,gdw03",TRUE)
      #CALL cl_set_action_active("query",TRUE)
      #CALL cl_set_act_visible("query",TRUE)
      #FUN-CC0092 mark-(e)
   END IF

   CALL p_replang_menu()

   CLOSE WINDOW p_replang_w                       # 結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p_replang_curs()                         # QBE 查詢資料
   CLEAR FORM                                     # 清除畫面
   CALL g_gdm.clear()
   LET g_gdm03 = NULL

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gdw08 = '",g_argv1 CLIPPED,"' "
      LET g_wc2 = " 1=1"
   ELSE
      CALL cl_set_head_visible("","YES")
      LET g_wc = NULL
      LET g_wc2 = NULL
      DIALOG ATTRIBUTE(UNBUFFERED)
         CONSTRUCT g_wc ON gdw01,gdw02,gdw05,gdw04,gdw06,gdw03,gdw09,gay01
                      FROM s_gdw.gdw01,s_gdw.gdw02,s_gdw.gdw05,s_gdw.gdw04,
                           s_gdw.gdw06,s_gdw.gdw03,s_gdw.gdw09,gdm03
            ON ACTION controlp
               CASE
                  WHEN INFIELD(gdw01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaz"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_lang
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gdw01
                     CALL p_replang_gdwdesc("gdw01",g_gdw.gdw01)
                     NEXT FIELD gdw01
                  WHEN INFIELD(gdw05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zx"
                     LET g_qryparam.default1 = g_gdw.gdw05
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gdw05
                     CALL p_replang_gdwdesc("gdw05",g_gdw.gdw05)
                     NEXT FIELD gdw05
                  WHEN INFIELD(gdw04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zw"
                     LET g_qryparam.default1 = g_gdw.gdw04
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gdw04
                     CALL p_replang_gdwdesc("gdw04",g_gdw.gdw04)
                     NEXT FIELD gdw04
                  OTHERWISE
                     EXIT CASE
               END CASE
         END CONSTRUCT

         CONSTRUCT g_wc2 ON gdm02,gdm04,gdm23,gdm05,gdm06,gdm07,gdm08,
                            gdm09,gdm10,gdm11,gdm12,gdm13,gdm14,gdm15,gdm16,
                            gdm17,gdm18,gdm19,gdm20,gdm21,gdm22,
                            gdm24,gdm25,gdm26,gdm27   #FUN-C30008 add gdm24,gdm25 #FUN-C40034 add gdm27,gdm27
                       FROM s_gdm[1].gdm02,s_gdm[1].gdm04,s_gdm[1].gdm23,
                            s_gdm[1].gdm05,s_gdm[1].gdm06,s_gdm[1].gdm07,
                            s_gdm[1].gdm08,s_gdm[1].gdm09,s_gdm[1].gdm10,
                            s_gdm[1].gdm11,s_gdm[1].gdm12,s_gdm[1].gdm13,
                            s_gdm[1].gdm14,s_gdm[1].gdm15,s_gdm[1].gdm16,
                            s_gdm[1].gdm17,s_gdm[1].gdm18,s_gdm[1].gdm19,
                            s_gdm[1].gdm20,s_gdm[1].gdm21,s_gdm[1].gdm22,
                            #FUN-C30008 add gdm24,gdm25
                            s_gdm[1].gdm24,s_gdm[1].gdm25,
                            #FUN-C40034 add gdm26,gdm27
                            s_gdm[1].gdm26,s_gdm[1].gdm27                           
         END CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION HELP
            CALL cl_show_help()
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION about
            CALL cl_about()
         ON ACTION ACCEPT
            LET g_gdm03 = GET_FLDBUF(gdm03)
            EXIT DIALOG
         ON ACTION CANCEL
            CLEAR FORM
            LET INT_FLAG = 1
            EXIT DIALOG
      END DIALOG

      IF INT_FLAG THEN RETURN END IF
   END IF

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null,null) #FUN-980030

   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                  "                gdw03,gdw09,gdw08,gay01",
                  " FROM gdw_file LEFT JOIN (SELECT gay01 FROM gay_file) B ON 1=1",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY gdw01,gdw02,gdw03,gdw09,gay01"
   ELSE
      LET g_sql = "SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                  "                gdw03,gdw09,gdw08,gay01",
                  " FROM gdw_file JOIN gdm_file ON gdw08=gdm01",
                  "   LEFT JOIN (SELECT gay01 FROM gay_file) B ON gdm03=gay01",
                  " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  " ORDER BY gdw01,gdw02,gdw03,gdw09,gay01"
   END IF

   DECLARE p_replang_b_curs SCROLL CURSOR WITH HOLD FROM g_sql # 宣告成可捲動的

   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT COUNT(*) FROM",
                  "(SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                  "                gdw03,gdw09,gdw08,gay01",
                  " FROM gdw_file LEFT JOIN (SELECT gay01 FROM gay_file) B ON 1=1",
                  " WHERE ",g_wc CLIPPED,")"
   ELSE
      LET g_sql = "SELECT COUNT(*) FROM",
                  "(SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                  "                gdw03,gdw09,gdw08,gay01",
                  " FROM gdw_file JOIN gdm_file ON gdw08=gdm01",
                  "   LEFT JOIN (SELECT gay01 FROM gay_file) B ON gdm03=gay01",
                  " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,")"
   END IF
   DECLARE p_replang_count_cs CURSOR FROM g_sql
END FUNCTION

 # 選出筆數直接寫入 g_row_count
FUNCTION p_replang_count()
   OPEN p_replang_count_cs
   FETCH p_replang_count_cs INTO g_row_count
   DISPLAY g_row_count TO formonly.cnt
END FUNCTION

FUNCTION p_replang_menu()

   WHILE TRUE
      CALL p_replang_bp("G")
     #FUN-D30026 ---start---
      LET g_orientation_input = NULL
      LET g_paper_size_input = NULL
     #FUN-D30026 ---end---

      CASE g_action_choice
#         WHEN "insert"                          # A.輸入
#            IF cl_chk_act_auth() THEN
#               CALL p_replang_a()
#            END IF
#         WHEN "modify"                          # U.修改
#            IF cl_chk_act_auth() THEN
#               CALL p_replang_u()
#            END IF
#         WHEN "reproduce"                       # C.複製
#            IF cl_chk_act_auth() THEN
#               CALL p_replang_copy()
#            END IF
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_replang_r()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_replang_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_replang_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "rescan"
            IF cl_chk_act_auth() THEN
              CALL p_replang_rescan()
              #FUN-C30008 移除regen4rp段
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdm),'','')
            END IF

         WHEN "showlog"
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("p_replang")
            END IF

         WHEN "reportviewer"
            IF cl_chk_act_auth() THEN
               CALL p_replang_preview()
            END IF
         WHEN "changepapersize"
            IF cl_chk_act_auth() THEN
               #CALL p_replang_calc_paper_width() #TQC-C20436 ADD 重新計算紙張 #FUN-CC0005 mark
               CALL p_replang_change_paper_size()
               CALL p_replang_calc_paper_width() #TQC-C20436 ADD 重新計算紙張 #FUN-CC0005 add
            END IF
         #FUN-C30008 --start--
         WHEN "uploadlang4rp"
            IF cl_chk_act_auth() THEN
               CALL p_replang_uploadlang4rp()
            END IF
         #FUN-C30008 --end--
         #FUN-C50046--start---
         WHEN "chkgr"
            IF cl_chk_act_auth() THEN
               CALL p_replang_chkgr()
            END IF    
        #FUN-C50046--end ---     
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_replang_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index,g_row_count )
   CLEAR FORM
   CALL g_gdm.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_replang_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_replang_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gdw.* TO NULL
   ELSE
      CALL p_replang_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_replang_fetch('F')                 #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION p_replang_fetch(p_flag)                #處理資料的讀取
   DEFINE  p_flag  LIKE type_file.chr1          #處理方式

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_replang_b_curs INTO g_gdw.*,g_gdw08,g_gdm03
      WHEN 'P' FETCH PREVIOUS p_replang_b_curs INTO g_gdw.*,g_gdw08,g_gdm03
      WHEN 'F' FETCH FIRST    p_replang_b_curs INTO g_gdw.*,g_gdw08,g_gdm03
      WHEN 'L' FETCH LAST     p_replang_b_curs INTO g_gdw.*,g_gdw08,g_gdm03
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0

            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION controlp
                  CALL cl_cmdask()
               ON ACTION HELP
                  CALL cl_show_help()
               ON ACTION about
                  CALL cl_about()
            END PROMPT

            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_replang_b_curs INTO g_gdw.*,g_gdw08
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gdw.gdw01,SQLCA.sqlcode,0)
      INITIALIZE g_gdw.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF

   CALL p_replang_get4rpdir()
   CALL p_replang_show()
END FUNCTION


FUNCTION p_replang_show()                         # 將資料顯示在畫面上
   DEFINE ls_temp    STRING

   DISPLAY BY NAME g_gdw.*
   DISPLAY g_gdm03 TO gdm03
   CALL p_replang_gdwdesc("gdw01",g_gdw.gdw01)
   CALL p_replang_gdwdesc("gdw05",g_gdw.gdw05)
   CALL p_replang_gdwdesc("gdw04",g_gdw.gdw04)

   LET ls_temp = g_gdw.gdw09
   IF ls_temp.getIndexOf("sub" ,1) > 1 THEN
      CALL cl_set_act_visible("reportviewer",FALSE)
   ELSE
      CALL cl_set_act_visible("reportviewer",TRUE)
   END IF

   CALL p_replang_show_paper_size()
   CALL p_replang_b_fill(g_wc2)                    # 單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION p_replang_r()        # 取消整筆 (所有合乎單頭的資料)

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gdw08) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gdm_file WHERE gdm01 = g_gdw08 AND gdm03 = g_gdm03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdm_file",g_gdw08,g_gdm03,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CALL g_gdm.clear()
         OPEN p_replang_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_replang_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL p_replang_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

FUNCTION p_replang_b()                              # 單身
   DEFINE l_ac_t           LIKE type_file.num5,   # 未取消的ARRAY CNT SMALLINT
          l_n              LIKE type_file.num5,   # 檢查重複用 SMALLINT
          l_gau01          LIKE type_file.num5,   # 檢查重複用 SMALLINT
          l_lock_sw        LIKE type_file.chr1,   # 單身鎖住否
          p_cmd            LIKE type_file.chr1,   # 處理狀態
          l_allow_insert   LIKE type_file.num5,   # SMALLINT
          l_allow_delete   LIKE type_file.num5,   # SMALLINT
          ls_msg_o         STRING,
          ls_msg_n         STRING

   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gdw08) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_opmsg('b')

   #LET l_allow_insert = cl_detail_input_auth("insert")
   #LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_allow_insert = FALSE  #不允許新增一筆單身資料,需用Genenro Studio新增4rp上的欄位
   LET l_allow_delete = FALSE  #不允許刪除一筆單身資料,需用Genenro Studio移除4rp上的欄位

   LET g_forupd_sql =  "SELECT gdm02,gdm04,gdm23,gdm05,gdm06,",
                       "       gdm07,gdm08,gdm09,gdm10,gdm11,",
                       "       gdm12,gdm13,gdm14,gdm15,gdm16,",
                       "       gdm17,gdm18,gdm19,gdm20,gdm21,",
                       "       gdm22,gdm24,gdm25,gdm26,gdm27", #FUN-C30008 add gdm24,gdm25 #FUN-C40034 add gdm26,gdm27
                       " FROM gdm_file",
                       " WHERE gdm01=? AND gdm02=? AND gdm03=?",
                       " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_replang_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET g_update_flag = FALSE

   CALL p_replang_get4rp_max_lines()
   INPUT ARRAY g_gdm WITHOUT DEFAULTS FROM s_gdm.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gdm_t.* = g_gdm[l_ac].*    #BACKUP
            OPEN p_replang_bcl USING g_gdw08,g_gdm_t.gdm02,g_gdm03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_replang_bcl:",STATUS,1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_replang_bcl INTO g_gdm[l_ac].*
                # FUN-C40034 ADD -START
                  IF  g_gdm[l_ac].gdm26 CLIPPED ="Boolean.TRUE" OR  g_gdm[l_ac].gdm26 CLIPPED ="Boolean.FALSE" THEN
                      LET g_gdm[l_ac].gdm26 ="" #跟內定值一樣 所以不用存入
                  END IF 
                  IF  g_gdm[l_ac].gdm27 CLIPPED ="Boolean.TRUE" OR  g_gdm[l_ac].gdm27 CLIPPED ="Boolean.FALSE" THEN
                      LET g_gdm[l_ac].gdm27  ="" #跟內定值一樣 所以不用存入
                  END IF
               # FUN-C40034 ADD -END 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_replang_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
         CALL p_replang_set_entry(l_ac)

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gdm[l_ac].* TO NULL
         LET g_gdm_t.* = g_gdm[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD gdm02

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         INSERT INTO gdm_file VALUES
            (g_gdw08,g_gdm[l_ac].gdm02,g_gdm03,
             g_gdm[l_ac].gdm04,g_gdm[l_ac].gdm05,g_gdm[l_ac].gdm06,
             g_gdm[l_ac].gdm07,g_gdm[l_ac].gdm08,g_gdm[l_ac].gdm09,
             g_gdm[l_ac].gdm10,g_gdm[l_ac].gdm11,g_gdm[l_ac].gdm12,
             g_gdm[l_ac].gdm13,g_gdm[l_ac].gdm14,g_gdm[l_ac].gdm15,
             g_gdm[l_ac].gdm16,g_gdm[l_ac].gdm17,g_gdm[l_ac].gdm18,
             g_gdm[l_ac].gdm19,g_gdm[l_ac].gdm20,g_gdm[l_ac].gdm21,
             g_gdm[l_ac].gdm22,g_gdm[l_ac].gdm23,
             g_gdm[l_ac].gdm24,g_gdm[l_ac].gdm25, #FUN-C30008 add gdm24, gdm25
             g_gdm[l_ac].gdm26,g_gdm[l_ac].gdm27) #FUN-C30008 add gdm26, gdm27

         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gdm_file",g_gdw08,g_gdm[l_ac].gdm02,SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gdm_t.gdm02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("",-263,1)
               CANCEL DELETE
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err(g_gdm[l_ac].gdm02,"azz-082",1)
            END IF
            DELETE FROM gdm_file WHERE gdm01 = g_gdw08
                                 AND gdm02 = g_gdm[l_ac].gdm02
                                 AND gdm03 = g_gdm03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdm_file",g_gdw08,g_gdm_t.gdm02,SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gdm[l_ac].* = g_gdm_t.*
            CLOSE p_replang_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
            IF l_gau01 > 0 THEN
               CALL cl_err("g_gdm[l_ac].gdm02","azz-083",1)
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gdm[l_ac].gdm02,-263,1)
               LET g_gdm[l_ac].* = g_gdm_t.*
            ELSE

               # FUN-C40034 ADD -START
                  IF  g_gdm[l_ac].gdm26 CLIPPED ="Boolean.TRUE" OR  g_gdm[l_ac].gdm26 CLIPPED ="Boolean.FALSE" THEN
                      LET g_gdm[l_ac].gdm26 ="" #跟內定值一樣 所以不用存入
                  END IF 
                  IF  g_gdm[l_ac].gdm27 CLIPPED ="Boolean.TRUE" OR  g_gdm[l_ac].gdm27 CLIPPED ="Boolean.FALSE" THEN
                      LET g_gdm[l_ac].gdm27  ="" #跟內定值一樣 所以不用存入
                  END IF
               # FUN-C40034 ADD -END 

            
               UPDATE gdm_file SET
                  gdm04 = g_gdm[l_ac].gdm04,
                  gdm05 = g_gdm[l_ac].gdm05,
                  gdm06 = g_gdm[l_ac].gdm06,
                  gdm07 = g_gdm[l_ac].gdm07,
                  gdm08 = g_gdm[l_ac].gdm08,
                  gdm09 = g_gdm[l_ac].gdm09,
                  gdm10 = g_gdm[l_ac].gdm10,
                  gdm11 = g_gdm[l_ac].gdm11,
                  gdm12 = g_gdm[l_ac].gdm12,
                  gdm13 = g_gdm[l_ac].gdm13,
                  gdm14 = g_gdm[l_ac].gdm14,
                  gdm15 = g_gdm[l_ac].gdm15,
                  gdm16 = g_gdm[l_ac].gdm16,
                  gdm17 = g_gdm[l_ac].gdm17,
                  gdm18 = g_gdm[l_ac].gdm18,
                  gdm19 = g_gdm[l_ac].gdm19,
                  gdm20 = g_gdm[l_ac].gdm20,
                  gdm21 = g_gdm[l_ac].gdm21,
                  gdm22 = g_gdm[l_ac].gdm22,
                  gdm23 = g_gdm[l_ac].gdm23,
                  #FUN-C30008 add gdm24, gdm25
                  gdm24 = g_gdm[l_ac].gdm24,
                  gdm25 = g_gdm[l_ac].gdm25,
                  #FUN-C40034 add gdm26, gdm27
                  gdm26 = g_gdm[l_ac].gdm26,
                  gdm27 = g_gdm[l_ac].gdm27                  
               WHERE gdm01 = g_gdw08 
                  AND gdm02 = g_gdm_t.gdm02 
                  AND gdm03 = g_gdm03

               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","gdm_file",g_gdw08,g_gdm_t.gdm02,SQLCA.sqlcode,"","",0)
                  LET g_gdm[l_ac].* = g_gdm_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  LET ls_msg_n = g_gdw08 CLIPPED,"",
                                 g_gdm[l_ac].gdm02 CLIPPED,"",
                                 g_gdm03 CLIPPED,"",
                                 g_gdm[l_ac].gdm04 CLIPPED,"",
                                 g_gdm[l_ac].gdm05 CLIPPED,"",
                                 g_gdm[l_ac].gdm06 CLIPPED,"",
                                 g_gdm[l_ac].gdm07 CLIPPED,"",
                                 g_gdm[l_ac].gdm08 CLIPPED,"",
                                 g_gdm[l_ac].gdm09 CLIPPED,"",
                                 g_gdm[l_ac].gdm10 CLIPPED,"",
                                 g_gdm[l_ac].gdm11 CLIPPED,"",
                                 g_gdm[l_ac].gdm12 CLIPPED,"",
                                 g_gdm[l_ac].gdm13 CLIPPED,"",
                                 g_gdm[l_ac].gdm14 CLIPPED,"",
                                 g_gdm[l_ac].gdm15 CLIPPED,"",
                                 g_gdm[l_ac].gdm16 CLIPPED,"",
                                 g_gdm[l_ac].gdm17 CLIPPED,"",
                                 g_gdm[l_ac].gdm18 CLIPPED,"",
                                 g_gdm[l_ac].gdm19 CLIPPED,"",
                                 g_gdm[l_ac].gdm20 CLIPPED,"",
                                 g_gdm[l_ac].gdm21 CLIPPED,"",
                                 g_gdm[l_ac].gdm22 CLIPPED,"",
                                 g_gdm[l_ac].gdm24 CLIPPED,"",   #FUN-C30008 add
                                 g_gdm[l_ac].gdm25 CLIPPED,"",    #FUN-C30008 add
                                 g_gdm[l_ac].gdm26 CLIPPED,"",   #FUN-C40034 add
                                 g_gdm[l_ac].gdm27 CLIPPED,""    #FUN-C40034 add   
                                 
                  LET ls_msg_o = g_gdw08 CLIPPED,"",
                                 g_gdm_t.gdm02 CLIPPED,"",
                                 g_gdm03 CLIPPED,"",
                                 g_gdm_t.gdm04 CLIPPED,"",
                                 g_gdm_t.gdm05 CLIPPED,"",
                                 g_gdm_t.gdm06 CLIPPED,"",
                                 g_gdm_t.gdm07 CLIPPED,"",
                                 g_gdm_t.gdm08 CLIPPED,"",
                                 g_gdm_t.gdm09 CLIPPED,"",
                                 g_gdm_t.gdm10 CLIPPED,"",
                                 g_gdm_t.gdm11 CLIPPED,"",
                                 g_gdm_t.gdm12 CLIPPED,"",
                                 g_gdm_t.gdm13 CLIPPED,"",
                                 g_gdm_t.gdm14 CLIPPED,"",
                                 g_gdm_t.gdm15 CLIPPED,"",
                                 g_gdm_t.gdm16 CLIPPED,"",
                                 g_gdm_t.gdm17 CLIPPED,"",
                                 g_gdm_t.gdm18 CLIPPED,"",
                                 g_gdm_t.gdm19 CLIPPED,"",
                                 g_gdm_t.gdm20 CLIPPED,"",
                                 g_gdm_t.gdm21 CLIPPED,"",
                                 g_gdm_t.gdm22 CLIPPED,"",
                                 g_gdm_t.gdm24 CLIPPED,"",    #FUN-C30008
                                 g_gdm_t.gdm25 CLIPPED,"",    #FUN-C30008
                                 g_gdm_t.gdm26 CLIPPED,"",    #FUN-C40034
                                 g_gdm_t.gdm27 CLIPPED,""     #FUN-C40034                                 
                CALL cl_log("p_replang","U",ls_msg_n,ls_msg_o)
                 LET g_update_flag = TRUE
               END IF
            END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gdm[l_ac].* = g_gdm_t.*
            END IF
            CLOSE p_replang_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_replang_bcl
         COMMIT WORK

      AFTER FIELD gdm09
         MESSAGE ''
         CASE g_gdm[l_ac].gdm05
            WHEN "1"
               #DISPLAY "1:",g_max_master_lines
               IF g_gdm[l_ac].gdm09 > g_max_master_lines THEN
                  MESSAGE "gdm09 must <= "||g_max_master_lines||"!"
                  NEXT FIELD gdm09
               END IF
               #FUN-C30288 --start--
               IF s_gr_chkrule_field(p_replang_4rplangpath(),g_gdm[l_ac].gdm04, g_gdm_t.gdm09, g_gdm[l_ac].gdm09) THEN
                  MESSAGE "Not allow to change line sequence."
                  NEXT FIELD gdm09
               END IF
               #FUN-C30288 --end--
            WHEN "2"
               #DISPLAY "2:",g_max_detail_lines
               IF g_gdm[l_ac].gdm09 > g_max_detail_lines THEN
                  MESSAGE "gdm09 must <= "||g_max_detail_lines||"!"
                  NEXT FIELD gdm09
               END IF
               #FUN-C30288 --start--
               IF s_gr_chkrule_field(p_replang_4rplangpath(),g_gdm[l_ac].gdm04, g_gdm_t.gdm09, g_gdm[l_ac].gdm09) THEN
                  MESSAGE "Not allow to change line sequence."
                  NEXT FIELD gdm09
               END IF
               #FUN-C30288 --end--
         END CASE

      AFTER FIELD gdm10
         IF g_gdm_t.gdm10 > 0 THEN  #FUN-C30288 add
            CALL p_replang_seq("u")
            DISPLAY BY NAME g_gdm[l_ac].gdm10
         END IF                     #FUN-C30288 add

      ON ACTION controlp
         CASE
            WHEN INFIELD(gdm14)
               CALL s_color(g_gdm[l_ac].gdm14) RETURNING g_gdm[l_ac].gdm14
               NEXT FIELD gdm15
            WHEN INFIELD(gdm19)
               CALL s_color(g_gdm[l_ac].gdm19) RETURNING g_gdm[l_ac].gdm19
               NEXT FIELD gdm20
         END CASE

      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gdm02) AND l_ac > 1 THEN
            LET g_gdm[l_ac].* = g_gdm[l_ac-1].*
            NEXT FIELD gdm02
         END IF

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION about
         CALL cl_about()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END INPUT

   CLOSE p_replang_bcl
   COMMIT WORK

   # 詢問是否自動產生 42s
   IF g_update_flag AND cl_confirm("azz1078") THEN
      CALL p_replang_regen4rp()
      CALL p_replang_calc_paper_width()
   END IF
END FUNCTION

FUNCTION p_replang_b_fill(p_wc2)               #BODY FILL UP
   DEFINE  p_wc2    STRING

   LET g_sql = "SELECT gdm02,gdm04,gdm23,gdm05,gdm06,",
               "       gdm07,gdm08,gdm09,gdm10,gdm11,",
               "       gdm12,gdm13,gdm14,gdm15,gdm16,",
               "       gdm17,gdm18,gdm19,gdm20,gdm21,",
               "       gdm22,gdm24,gdm25,gdm26,gdm27", #FUN-C30008 add gdm24,gdm25 #FUN-C40034 add gdm26,gdm27
               " FROM gdm_file",
               " WHERE gdm01=? AND gdm03=?",
               " AND ",p_wc2 CLIPPED,
               " ORDER BY gdm02"

   DECLARE p_replang_b_fill_curs CURSOR FROM g_sql

   CALL g_gdm.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH p_replang_b_fill_curs USING g_gdw08,g_gdm03 INTO g_gdm[g_cnt].*       #單身 ARRAY 填充
    # FUN-C40034 ADD -START
       IF  g_gdm[g_cnt].gdm26 CLIPPED ="Boolean.TRUE" OR  g_gdm[g_cnt].gdm26 CLIPPED ="Boolean.FALSE" THEN
           LET g_gdm[g_cnt].gdm26 ="" #跟內定值一樣 所以不用存入
       END IF 
       IF  g_gdm[g_cnt].gdm27 CLIPPED ="Boolean.TRUE" OR  g_gdm[g_cnt].gdm27 CLIPPED ="Boolean.FALSE" THEN
           LET g_gdm[g_cnt].gdm27  ="" #跟內定值一樣 所以不用存入
       END IF
    # FUN-C40034 ADD -END   
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gdm.deleteElement(g_cnt)

   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION p_replang_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel",FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gdm TO s_gdm.* ATTRIBUTE(UNBUFFERED)

      BEFORE DISPLAY
         IF g_sel_row > 0 THEN
            CALL DIALOG.setCurrentRow("s_gdm",g_sel_row)
         END IF
         CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      #ON ACTION insert                           # A.輸入
      #    LET g_action_choice='insert'
      #    EXIT DISPLAY

      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY

      #ON ACTION modify                           # Q.修改
      #    LET g_action_choice='modify'
      #    EXIT DISPLAY

      #ON ACTION reproduce                        # C.複製
      #    LET g_action_choice='reproduce'
      #    EXIT DISPLAY

      ON ACTION delete                           # R.取消
         LET g_action_choice='delete'
         EXIT DISPLAY

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first                            # 第一筆
         CALL p_replang_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous                         # P.上筆
         CALL p_replang_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump                             # 指定筆
         CALL p_replang_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next                             # N.下筆
         CALL p_replang_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last                             # 最終筆
         CALL p_replang_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION help                             # H.說明
         LET g_action_choice='help'
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY

      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION CLOSE
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION rescan
         LET g_action_choice = 'rescan'
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION showlog
         LET g_action_choice = "showlog"
         EXIT DISPLAY

      ON ACTION reportviewer
         LET g_action_choice = 'reportviewer'
         EXIT DISPLAY

      ON ACTION changepapersize
         LET g_action_choice = 'changepapersize'
         EXIT DISPLAY

      #FUN-C30008 --start--
      ON ACTION uploadlang4rp
         LET g_action_choice = 'uploadlang4rp'
         EXIT DISPLAY
      #FUN-C30008 --end--

      #FUN-C50046 --start--
      ON ACTION chkgr
         LET g_action_choice = 'chkgr'
         EXIT DISPLAY
      #FUN-C50046 --end--
      
      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

#根據欄位屬性(1.單頭 2.單身)設定[定位點]與[欄位順序]是否可輸入
FUNCTION p_replang_set_entry(p_idx)
   DEFINE p_idx    LIKE type_file.num10
   CASE g_gdm[p_idx].gdm05
      WHEN "1"    # 1.單頭
         CALL cl_set_comp_entry("gdm07",TRUE)
         CALL cl_set_comp_entry("gdm10",FALSE)
      WHEN "2"    # 1.單身
         CALL cl_set_comp_entry("gdm07",FALSE)
         IF g_gdm[p_idx].gdm10 > 0 THEN            #FUN-C30288 add
            CALL cl_set_comp_entry("gdm09",TRUE)   #FUN-C30288 add
            CALL cl_set_comp_entry("gdm10",TRUE)
         #FUN-C30288 --start-- add
         ELSE
            CALL cl_set_comp_entry("gdm09",FALSE)
            CALL cl_set_comp_entry("gdm10",FALSE)
         END IF
         #FUN-C30288 --end--
      OTHERWISE
         CALL cl_set_comp_entry("gdm07",TRUE)
         CALL cl_set_comp_entry("gdm10",FALSE)
   END CASE
END FUNCTION

#改變單身欄位順序
FUNCTION p_replang_seq(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1
   DEFINE l_i      LIKE type_file.num10
   DEFINE l_dstidx LIKE type_file.num5
   DEFINE l_val    LIKE type_file.chr1
   DEFINE l_window ui.Window

   LET l_dstidx = -1
   FOR l_i = 1 TO g_gdm.getLength()
     IF l_i != l_ac AND g_gdm[l_i].gdm05="2"
         AND g_gdm[l_i].gdm09=g_gdm[l_ac].gdm09
     THEN
         IF g_gdm[l_i].gdm10=g_gdm[l_ac].gdm10 THEN
             LET l_dstidx = l_i
             EXIT FOR
         END If
     END IF
   END FOR

   IF l_dstidx > 0 THEN
     #DISPLAY "g_gdm["||l_dstidx||"].gdm10=",g_gdm[l_dstidx].gdm10,"|","g_gdm["||l_ac||"].gdm10=",g_gdm[l_ac].gdm10,"|",g_gdm_t.gdm10

     OPEN WINDOW p_zaa_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
         ATTRIBUTE (STYLE = g_win_style)
     CALL cl_ui_locale("p_zaa_1")

     LET l_window = ui.Window.getCurrent()
     CALL l_window.setText("p_replang_seq")

     LET l_val = 1

     INPUT l_val WITHOUT DEFAULTS FROM a
         ON ACTION CANCEL
             LET l_val=0
             EXIT INPUT
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     CLOSE WINDOW p_zaa_1

     BEGIN WORK
     CASE l_val
         WHEN 1  #欄位順序調換
             IF p_cmd = "u" THEN
                 LET g_gdm[l_dstidx].gdm10 = g_gdm_t.gdm10
                 UPDATE gdm_file SET gdm10 = g_gdm[l_dstidx].gdm10
                 WHERE gdm01=g_gdw08 AND gdm03=g_gdm03
                 AND gdm02 = g_gdm[l_dstidx].gdm02

                 UPDATE gdm_file SET gdm10 = g_gdm[l_ac].gdm10
                 WHERE gdm01=g_gdw08 AND gdm03=g_gdm03
                 AND gdm02 = g_gdm[l_ac].gdm02

                 LET g_gdm_t.gdm10 = g_gdm[l_ac].gdm10
             END IF
         WHEN 2  # 自動遞增
             IF p_cmd = "u" THEN
                 FOR l_i = 1 TO g_gdm.getLength()
                     IF l_i != l_ac AND g_gdm[l_i].gdm05="2"
                         AND g_gdm[l_i].gdm09=g_gdm[l_ac].gdm09
                         AND g_gdm[l_i].gdm10 >= g_gdm[l_ac].gdm10
                     THEN
                         LET g_gdm[l_i].gdm10 = g_gdm[l_i].gdm10 + 1
                         UPDATE gdm_file SET gdm10 = g_gdm[l_i].gdm10
                         WHERE gdm01=g_gdw08 AND gdm03=g_gdm03
                         AND gdm02=g_gdm[l_i].gdm02
                     END IF
                 END FOR

                 UPDATE gdm_file SET gdm10 = g_gdm[l_ac].gdm10
                 WHERE gdm01=g_gdw08 AND gdm03=g_gdm03
                 AND gdm02 = g_gdm[l_ac].gdm02

                 LET g_gdm_t.gdm10 = g_gdm[l_ac].gdm10
             END IF
     END CASE
     COMMIT WORK
   END IF
END FUNCTION

#FUN-C30008 --start--
#重新掃描4rp檔
FUNCTION p_replang_rescanall()
    DEFINE l_gdm03      LIKE gdm_file.gdm03
    DEFINE l_sql        STRING
    DEFINE l_4rpfile    STRING
    DEFINE l_src4rp     STRING
    DEFINE l_langdir    STRING                     #語言別目錄

    LET l_src4rp = os.Path.join(os.Path.join(g_4rpdir.trim(),"src"),g_gdw.gdw09 CLIPPED||".4rp")

    DECLARE p_replang_gay_curs CURSOR FOR SELECT gay01 FROM gay_file ORDER BY gay01

    LET l_sql = "SELECT * FROM gdm_file",
                " WHERE gdm01=? AND gdm03=? ORDER BY gdm02,gdm04"
    DECLARE p_replang_gdm2_cur CURSOR FROM l_sql
    LET g_sel_row = 0
    FOREACH p_replang_gay_curs INTO l_gdm03
        #語言別目錄不存在時自動建立
        LET l_langdir = os.Path.join(g_4rpdir.trim(),l_gdm03 CLIPPED)
        LET l_langdir = l_langdir.trim()
        IF NOT os.Path.exists(l_langdir) THEN
            IF os.Path.mkdir(l_langdir) THEN
                IF os.Path.chrwx(l_langdir,511) THEN END IF
            END IF
        END IF
        LET l_4rpfile = os.Path.join(l_langdir,g_gdw.gdw09 CLIPPED||".4rp")

        IF NOT os.Path.exists(l_4rpfile) THEN
            IF os.Path.copy(l_src4rp,l_4rpfile) THEN END IF
        END IF

        #FUN-C30008 --start--
        #移除程式段
        CALL p_replang_rescan4rp(l_4rpfile,g_gdw08,l_gdm03)
        #FUN-C30008 --end--
    END FOREACH
    #開啟從其他樣版參考欄位資料的詢問視窗
    #IF g_argv2 IS NOT NULL AND g_argv2 == "1" THEN
    #CALL s_gr_diff_rep_upd_gdm23(g_gdw08)
    #END IF
END FUNCTION

#重新掃描4rp檔
FUNCTION p_replang_rescan()

   #檢查報表樣板ID與語言別是否有效
   IF g_gdw08 < 1 AND cl_null(g_argv1) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   #先詢問
   IF cl_confirm("azz1202") THEN
      LET g_chk_err_msg = NULL
      CALL p_replang_rescan4rp(p_replang_get4rppath(),g_gdw08,g_gdm03)    
      CALL p_replang_show()
   END IF
END FUNCTION
#FUN-C30008 --end--

#FUN-C50046 -start----
#檢查4rp範規
FUNCTION p_replang_chkgr()
   DEFINE l_chk_err_msg        STRING     
   DEFINE l_strong_err         INTEGER   

   #檢查報表樣板ID與語言別是否有效
   IF g_gdw08 < 1 AND cl_null(g_argv1) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

      LET g_chk_err_msg = NULL
       DISPLAY "p_replang_get4rppath()",p_replang_get4rppath()
       CALL p_replang_chk_grule(p_replang_get4rppath(),g_gdw08,g_lang) RETURNING l_strong_err,l_chk_err_msg #GR檢查機制
      # IF l_strong_err>0 THEN 
        #顯示檢查命名規則的錯誤訊息
        IF l_chk_err_msg IS NOT NULL THEN
           CALL cl_err(l_chk_err_msg,"!",-1)
           
        END IF     
      # END IF  
      
      CALL p_replang_show()

END FUNCTION
#FUN-C50046 -start----

FUNCTION p_replang_gdwdesc(l_column,l_value)
    DEFINE  l_column    STRING,
            l_value     LIKE type_file.chr10

    CASE l_column
        WHEN "gdw01"
            SELECT gaz03 INTO g_gaz03 FROM gaz_file
             WHERE gaz01 = l_value AND gaz02 = g_lang
            IF SQLCA.SQLCODE THEN
                LET g_gaz03 = ""
            END IF
            DISPLAY g_gaz03 TO gaz03
        WHEN "gdw04"
            SELECT zw02 INTO g_zw02 FROM zw_file
             WHERE zw01 = l_value
            IF SQLCA.SQLCODE THEN
                LET g_zw02 = ""
            END IF
            IF l_value = "default" THEN
                LET g_zw02 = "default"
            END IF
            DISPLAY g_zw02 TO zw02
        WHEN "gdw05"
            SELECT zx02 INTO g_zx02 FROM zx_file
             WHERE zx01 = l_value
            IF SQLCA.SQLCODE THEN
                LET g_zx02 = ""
            END IF
            IF l_value = "default" THEN
                LET g_zx02 = "default"
            END IF
            DISPLAY g_zx02 TO zx02
   END CASE
END FUNCTION

FUNCTION p_replang_get4rp_max_lines()
    DEFINE l_4rpfile    STRING
    DEFINE l_doc        om.DomDocument
    DEFINE l_rootnode   om.DomNode
    DEFINE l_nodes      om.NodeList
    DEFINE l_curnode    om.DomNode

    LET l_4rpfile = p_replang_get4rppath()
    #DISPLAY "p_replang_get4rp_max_lines:",l_4rpfile
    LET l_doc = om.DomDocument.createFromXmlFile(l_4rpfile)
    LET l_rootnode = l_doc.getDocumentElement()

    LET l_nodes = l_rootnode.selectByPath("//LAYOUTNODE[@name=\"Masters\"]")
    IF l_nodes.getLength() > 0 THEN
        LET l_curnode = l_nodes.item(1)
        LET g_max_master_lines = l_curnode.getChildCount()
    END IF

    LET l_nodes = l_rootnode.selectByPath("//LAYOUTNODE[@name=\"Details\"]")
    IF l_nodes.getLength() > 0 THEN
        LET l_curnode = l_nodes.item(1)
        LET g_max_detail_lines = l_curnode.getChildCount()
    END IF
    
    #FUN-C10044 --start--
    #單身最大列數i<=0時取單身欄位說明最大列數
    IF g_max_detail_lines <= 0 THEN
        LET l_nodes = l_rootnode.selectByPath("//LAYOUTNODE[@name=\"DetailHeaders\"]")
        IF l_nodes.getLength() > 0 THEN
            LET l_curnode = l_nodes.item(1)
            LET g_max_detail_lines = l_curnode.getChildCount()
        END IF
    END IF
    #FUN-C10044 --end--
END FUNCTION

#FUN-C30008 移除p_replang_read4rp()

#FUN-C20112 --start--
# 將 p_replang_readnodes(), p_replang_has_label(), p_replang_get_category(),
#    p_replang_getcolname() 搬到 s_p_replang.4gl
#FUN-C20112 --end--

#根據程式代號取得4RP目錄路徑
FUNCTION p_replang_get4rpdir()
    #DEFINE l_zz011  LIKE zz_file.zz011
    DEFINE l_prog   STRING
    DEFINE l_mdir   STRING
    DEFINE l_tmpstr STRING
    DEFINE l_sys    STRING                #FUN-C40040
    DEFINE l_sql    STRING                #FUN-C40040
    DEFINE l_zz01   LIKE zz_file.zz01     #FUN-C40040
    DEFINE l_zz011  LIKE zz_file.zz011    #FUN-C40040
    DEFINE l_cnt    LIKE type_file.num5   #FUN-C40040
    
    IF g_gdw.gdw01 IS NOT NULL THEN
        LET l_prog = g_gdw.gdw01
        #FUN-C40040 mark --start--
        #IF g_gdw.gdw03 = "Y" THEN
        #    IF l_prog.getIndexOf("p_",1) >= 1 THEN
        #        LET l_mdir = "czz"
        #    ELSE
        #        LET l_tmpstr = l_prog.subString(1,3)
        #        IF l_tmpstr.getCharAt(1) = "g" THEN
        #            LET l_mdir = "c",l_tmpstr
        #        ELSE
        #            LET l_mdir = "c",l_tmpstr.subString(2,3)
        #        END IF
        #    END IF
        #ELSE
        #    IF l_prog.getIndexOf("p_",1) >= 1 THEN
        #        LET l_mdir = "azz"
        #    ELSE
        #        LET l_mdir = l_prog.subString(1,3)
        #    END IF
        #END IF
        ##FUN-C40040 mark ---end---        
        #FUN-C40040--strat--  
        #抓取系統別    
        LET l_zz01 = l_prog
        LET l_sql = "SELECT zz011 FROM ",s_dbstring("ds") CLIPPED,"zz_file WHERE zz01=?"
        PREPARE p_replang_pre FROM l_sql
        EXECUTE p_replang_pre USING l_zz01 INTO l_zz011
        FREE p_replang_pre
        LET l_sys = l_zz011
        LET l_sys = l_sys.toLowerCase()
        IF g_gdw.gdw03 = "Y" THEN
            IF l_sys.getCharAt(1) = "a" THEN
                CALL cl_err_msg("",'azz1206',l_prog,1)
                LET l_sys = 'c',l_sys.subString(2,l_sys.getLength()) CLIPPED
                LET l_mdir = l_sys
            ELSE
                LET l_mdir = l_sys
            END IF
        ELSE
            IF l_sys.getCharAt(1) = "c" THEN
                LET l_sys = l_sys.subString(2,l_sys.getLength())
                LET l_sql = "SELECT count(gao01) FROM ",s_dbstring("ds") CLIPPED,"gao_file WHERE gao01=?"
                PREPARE p_replang_pre1 FROM l_sql
                EXECUTE p_replang_pre1 USING l_zz011 INTO l_cnt
                FREE p_replang_pre1
                IF l_cnt=0 THEN 
                    LET l_sys='a',l_sys
                ELSE 
                    LET l_mdir = l_sys
                END IF 
            ELSE 
                LET l_mdir = l_sys                
            END IF 
        END IF
        #FUN-C40040---end---

        LET g_4rpdir = os.Path.join(FGL_GETENV(UPSHIFT(l_mdir)),"4rp")
    END IF
END FUNCTION

#根據程式代號與樣板名稱取得4rp檔案完整路徑
FUNCTION p_replang_get4rppath()
    DEFINE l_path       STRING
    DEFINE l_src_path   STRING
    DEFINE l_langdir    STRING  #語言別目錄

    IF g_4rpdir IS NULL THEN
        CALL p_replang_get4rpdir()
    END IF
    LET l_langdir = os.Path.join(g_4rpdir.trim(),g_gdm03 CLIPPED)
    IF NOT os.Path.exists(l_langdir) THEN
        IF os.Path.mkdir(l_langdir) THEN
            IF os.Path.chrwx(l_langdir,511) THEN END IF
        END IF
    END IF
    LET l_path = os.Path.join(l_langdir,g_gdw.gdw09 CLIPPED||".4rp")
    LET l_src_path = os.Path.join(os.Path.join(g_4rpdir.trim(),"src"),g_gdw.gdw09 CLIPPED||".4rp")
    IF NOT os.Path.exists(l_path) THEN
        IF os.Path.copy(l_src_path,l_path) THEN END IF
    END IF
    RETURN l_path
END FUNCTION

#根據變動資料重新產生4rp
FUNCTION p_replang_regen4rp()
    DEFINE l_cmd        STRING
    #DEFINE l_code       LIKE type_file.num10   #FUN-C10044 mark
    
    LET l_cmd = "p_replang_regen '",g_gdw08 CLIPPED,"' '",g_gdm03 CLIPPED,"' '",g_4rpdir.trim(),"' '",g_gdw.gdw09 CLIPPED,"'"
    CALL cl_cmdrun(l_cmd)
    DISPLAY l_cmd
END FUNCTION

FUNCTION p_replang_preview()
   DEFINE handler om.SaxDocumentHandler,
       load_settings  INTEGER,
       ls_report_name STRING,
       ls_path        STRING,
       ls_data_file   STRING,
       output_format  STRING,
       ls_output      STRING,
       ls_path_win    STRING,   #FUN-C50024 CR主機4rp路徑
       ls_host        STRING    #FUN-C50024 CR主機IP

   DEFINE t1             DATETIME MINUTE TO FRACTION(5)
   DEFINE t2             DATETIME MINUTE TO FRACTION(5)
   DEFINE interval_time  INTERVAL MINUTE TO FRACTION(5)
   DEFINE l_port      STRING   #FUN-C40048
   DEFINE l_mid_dir      STRING  #FUN-C90073 add

   LET ls_report_name = p_replang_get4rppath()
   IF NOT os.Path.exists(ls_report_name) THEN
      CALL cl_err( '' , 'azz-912' ,1 )
      RETURN
   END IF

   #FUN-C50024 變為分散模式需要設定參數 --START--
   #設定CR主機的4rp路徑
   LET ls_path_win = cl_gre_get_4rpdir(g_gdw.gdw01,g_gdw.gdw03,"W")
   #LET ls_path_win = os.Path.join(ls_path_win.trim(),g_lang CLIPPED) #FUN-CC0092 mark
   LET ls_path_win = os.Path.join(ls_path_win.trim(),g_gdm03 CLIPPED) #FUN-CC0092 add
   LET ls_path_win = os.Path.join(ls_path_win.trim(), g_gdw.gdw09)
   #FUN-C90073 add (s)--------
    IF g_gdw.gdw03="Y" THEN #客製
       LET l_mid_dir=os.Path.basename( FGL_GETENV("CUST"))
    ELSE 
       LET l_mid_dir="tiptop"         
    END IF
    LET ls_path_win = os.Path.join(FGL_GETENV("TEMPLATEDRIVE"),l_mid_dir), ls_path_win,".4rp"
   #FUN-C90073 add (e)---------   
   #LET ls_path_win = FGL_GETENV("TEMPLATEDRIVE"), ls_path_win, ".4rp"  #FUN-C90073 mark
   #抓取CR主機的IP
   CALL p_replang_getCRIP() RETURNING ls_host
   #FUN-C50024 變為分散模式需要設定參數 -- END --
   
   #設定42s路徑
   LET ls_path = os.Path.join(g_4rpdir ,g_lang CLIPPED)
   LET ls_path = FGL_GETENV("DBPATH"),os.Path.pathseparator(),ls_path
   CALL FGL_SETENV("FGLRESOURCEPATH",ls_path)

   OPEN WINDOW p_reportview WITH FORM "azz/42f/p_reportview"
        ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_locale("p_reportview")

   LET output_format = "1"
   #LET ls_dir = p_replang_get4rpdir(g_gdw.gdw01)
   #FUN-C50024 原g_gdw.gdw01改為g_gdw.gdw02(樣板代號)
   LET ls_data_file = os.Path.join(os.Path.join(g_4rpdir, "sampledata") ,g_gdw.gdw02) , ".sampledata"

   WHILE TRUE
      INPUT BY NAME output_format WITHOUT DEFAULTS
      ATTRIBUTES(UNBUFFERED)

         ON ACTION ACCEPT
           LET load_settings = fgl_report_loadCurrentSettings(ls_report_name)
           CASE output_format
              WHEN "1"
                 LET ls_output = "SVG"
              WHEN "2"
                 LET ls_output = "PDF"
              WHEN "3" #合併one page
                 LET ls_output = "XLS"
                 CALL fgl_report_configureXLSDevice(1,100000, true,true,true,true,TRUE)
              WHEN "4" #分成多頁
                 LET ls_output = "XLS"
              #FUN-C50024 新增XLSX以及RTF類 --START--
              WHEN "5"
                 LET ls_output = "XLSX"
                 CALL fgl_report_configureXLSXDevice(1,100000, true,true,true,true,TRUE)
              WHEN "6"
                 LET ls_output = "XLSX"
              WHEN "7"
                 LET ls_output = "RTF"
              #FUN-C50024 新增XLSX以及RTF類 -- END --
              WHEN "8"    #將HTML從5移到8
                 LET ls_output = "HTML"
           END CASE

           #FUN-C50024 新增GRE分散模式 --START--
           CALL fgl_report_configureRemoteLocations(ls_path_win,FGL_GETENV("WINFGLPROFILE"),FGL_GETENV("WINFGLDIR"),FGL_GETENV("WINGREDIR"))
           LET l_port = FGL_GETENV("WINGREPORT")
           #CALL fgl_report_configureDistributedProcessing(ls_host,"6405")
           CALL fgl_report_configureDistributedProcessing(ls_host,l_port)  #FUN-C40048
           #FUN-C50024 新增GRE分散模式 -- END --
           CALL fgl_report_selectDevice(ls_output)
           CALL fgl_report_selectPreview(TRUE)
           LET handler= fgl_report_commitCurrentSettings()
    LET t1 = CURRENT
           LET load_settings = fgl_report_runReportFromProcessLevelDataFile(handler, ls_data_file)
    LET t2 = CURRENT
    LET interval_time = t2 -t1
    DISPLAY "INTERVAL:" ,interval_time
           EXIT INPUT

         ON ACTION CANCEL
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
  END WHILE

  CLOSE WINDOW p_reportview
END FUNCTION

#重新計算紙張寬度
FUNCTION p_replang_calc_paper_width()
    DEFINE l_i                  LIKE type_file.num5
    DEFINE l_j                  LIKE type_file.num5
    DEFINE l_didx               LIKE type_file.num5     #找到的單身行號
    DEFINE l_master_cur_width   LIKE type_file.num15_3
    DEFINE l_detail_width       DYNAMIC ARRAY OF RECORD #紀錄單身每行寬度
           dlineno              LIKE type_file.num5,
           width                LIKE type_file.num15_3
           END RECORD
    DEFINE l_max_width          LIKE type_file.num15_3
    DEFINE l_gdo02              LIKE gdo_file.gdo02
    DEFINE l_gdo03              LIKE gdo_file.gdo03
    DEFINE l_gdo04              LIKE gdo_file.gdo04

    LET g_hgap = 0.100
    LET g_master_max_width = 0
    LET g_detail_max_width = 0

    FOR l_i = 1 TO g_gdm.getLength()
        CASE g_gdm[l_i].gdm05
            WHEN 1  #單頭
                LET l_master_cur_width = g_gdm[l_i].gdm07 + g_gdm[l_i].gdm08
                IF g_gdm[l_i].gdm15 IS NOT NULL THEN
                    LET l_master_cur_width = l_master_cur_width + g_gdm[l_i].gdm15 + g_hgap
                END IF
                IF g_master_max_width < l_master_cur_width THEN
                    LET g_master_max_width = l_master_cur_width
                END IF
            WHEN 2  #單身
                LET l_didx = 0
                FOR l_j = 1 TO l_detail_width.getLength()
                    IF l_detail_width[l_j].dlineno = g_gdm[l_i].gdm09 THEN
                        LET l_didx = l_j
                        EXIT FOR
                    END IF
                END FOR
                IF l_didx = 0 THEN
                    CALL l_detail_width.appendElement()
                    LET l_didx = l_detail_width.getLength()
                    LET l_detail_width[l_didx].dlineno = g_gdm[l_i].gdm09
                    LET l_detail_width[l_didx].width = 0
                END IF
                LET l_detail_width[l_didx].width = l_detail_width[l_didx].width + g_gdm[l_i].gdm08 + g_hgap
        END CASE
    END FOR

    #找出單身最大寬度
    FOR l_j = 1 TO l_detail_width.getLength()
        IF g_detail_max_width < l_detail_width[l_j].width THEN
            LET g_detail_max_width = l_detail_width[l_j].width
        END IF
    END FOR

    IF g_detail_max_width > g_master_max_width THEN
        LET l_max_width = g_detail_max_width
    ELSE
        LET l_max_width = g_master_max_width
    END IF

    #超過A3橫向寬度時,均使用橫向紙張大小
    IF l_max_width > 42 THEN
        SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
        FROM gdo_file WHERE gdo04=(SELECT MIN(gdo04)
        FROM gdo_file WHERE gdo04 >= l_max_width)
    ELSE
        SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
        FROM gdo_file WHERE gdo03=(SELECT MIN(gdo03)
        FROM gdo_file WHERE gdo03 >= l_max_width)
    END IF

    #CALL p_replang_resize_paper_size(l_gdo02,l_gdo03,l_gdo04)  #FUN-CC0005 mark
    CALL p_replang_resize_paper_size(l_gdo02,l_gdo03,l_gdo04,g_orientation) #FUN-CC0005 add g_orientation
END FUNCTION

#更改主報表及子報表4rp紙張大小
#FUNCTION p_replang_resize_paper_size(p_paper_size,p_width,p_height) #FUN-CC0005 mark
FUNCTION p_replang_resize_paper_size(p_paper_size,p_width,p_height,p_orientation)   #FUN-CC0005 add g_orientation
    DEFINE p_paper_size     STRING
    DEFINE p_width          LIKE type_file.num15_3
    DEFINE p_height         LIKE type_file.num15_3
    DEFINE l_4rpfile        STRING
    DEFINE l_doc            om.DomDocument
    DEFINE l_doc_root       om.DomNode
    DEFINE l_gdw09          DYNAMIC ARRAY OF LIKE gdw_file.gdw09
    DEFINE l_template       STRING
    DEFINE l_tmp1           STRING
    DEFINE l_tmp2           STRING
    DEFINE l_node_list      om.NodeList
    DEFINE l_cur_node       om.DomNode
    DEFINE l_src_width      STRING
    DEFINE l_src_length     STRING
    DEFINE l_dst_width      STRING
    DEFINE l_dst_length     STRING
    DEFINE l_pos            LIKE type_file.num10
    DEFINE l_gdo02          LIKE gdo_file.gdo02
    DEFINE l_gdo03          LIKE gdo_file.gdo03
    DEFINE l_gdo04          LIKE gdo_file.gdo04
    DEFINE l_gdo05          LIKE gdo_file.gdo05
    DEFINE l_gdo02_1        LIKE gdo_file.gdo02
    DEFINE l_gdo02_2        LIKE gdo_file.gdo02
    DEFINE l_max_gdo03      LIKE gdo_file.gdo03
    DEFINE l_max_gdo04      LIKE gdo_file.gdo04
    DEFINE l_cur_gdo02      LIKE gdo_file.gdo02
    DEFINE l_orientation    STRING
    DEFINE l_max_paper_size STRING
    DEFINE l_i              LIKE type_file.num5
    DEFINE l_pwd            STRING
    DEFINE l_lang_dir       STRING
    DEFINE l_param          STRING
    DEFINE l_msg            STRING
    DEFINE l_result         STRING
    DEFINE l_gdo02_cnt      INTEGER  #FUN-CC0005 add
    DEFINE l_src_w,l_src_l  FLOAT    #FUN-CC0005 add
    DEFINE p_orientation    LIKE type_file.chr1  #FUN-CC0005 add
  #FUN-D30026 add-----start---
    DEFINE l_paper_sel      RECORD
                               chk1     LIKE type_file.chr1,
                               chk2     LIKE type_file.chr1,
                               type1    LIKE type_file.chr1,
                               type2    LIKE type_file.chr1,
                               paper1   LIKE gdo_file.gdo02,
                               paper2   LIKE gdo_file.gdo02,
                               orient1  LIKE type_file.chr1,
                               orient2  LIKE type_file.chr1,
                               width1   LIKE type_file.chr100,
                               width2   LIKE type_file.chr100,
                               length1  LIKE type_file.chr100,
                               length2  LIKE type_file.chr100,
                               unit1    LIKE type_file.chr1,
                               unit2    LIKE type_file.chr1
                            END RECORD
    DEFINE l_length         LIKE gdo_file.gdo03
    DEFINE l_width          LIKE gdo_file.gdo03
    DEFINE l_max_paper_size_ori STRING
    DEFINE l_str            STRING
    DEFINE l_unit           LIKE type_file.chr1
  #FUN-D30026 add-----end---

    LET l_max_gdo03 = p_width
    LET l_max_gdo04 = p_height
    LET l_max_paper_size = p_paper_size
    LET l_gdo05 = ""

    IF cl_null(p_orientation) THEN LET p_orientation = 'P' END IF #FUN-D30026

    #紀錄當前目錄,並切換到4rp語言別目錄
    LET l_pwd = os.Path.pwd()
    IF g_4rpdir IS NULL THEN
        CALL p_replang_get4rpdir()
    END IF
    LET l_lang_dir = os.Path.join(g_4rpdir,g_gdm03 CLIPPED)
    IF os.Path.chdir(l_lang_dir) THEN END IF
    DECLARE p_replang_resize_curs CURSOR FOR SELECT gdw09 FROM gdw_file WHERE gdw02=g_gdw.gdw02 ORDER BY gdw09
    LET l_i = 1
    FOREACH p_replang_resize_curs INTO l_gdw09[l_i]
        #檢查報表樣板檔名稱
        LET l_template = l_gdw09[l_i] CLIPPED
        LET l_tmp1 = g_gdw.gdw02 CLIPPED
        LET l_tmp2 = g_gdw.gdw02 CLIPPED||"_sub"
        IF l_template.getIndexOf(l_tmp1,1) > 0 OR l_template.getIndexOf(l_tmp2,1) > 0 THEN
            LET l_4rpfile = l_template||".4rp"
            LET l_doc = om.DomDocument.createFromXmlFile(l_4rpfile)
            LET l_doc_root = l_doc.getDocumentElement()

            LET l_node_list = l_doc_root.selectByTagName("report:Settings")
            IF l_node_list.getLength() >= 1 THEN
                LET l_cur_node = l_node_list.item(1)
                LET l_src_width = l_cur_node.getAttribute("RWPageWidth")
                LET l_src_length = l_cur_node.getAttribute("RWPageLength")

                LET l_pos = l_src_width.getIndexOf("width",1)
                IF l_pos >= 1 THEN
                    LET l_gdo02 = l_src_width.subString(1,l_pos-1)
                    LET l_orientation = "P"
                ELSE
                    LET l_pos = l_src_width.getIndexOf("length",1)
                    IF l_pos >= 1 THEN
                        LET l_gdo02 = l_src_width.subString(1,l_pos-1)
                        LET l_orientation = "L"
                    ELSE
                        LET l_pos = l_src_width.getIndexOf("cm",1)
                        IF l_pos >= 1 THEN
                            LET l_gdo03 = l_src_width.subString(1,l_pos-1)
                            LET l_gdo05 = "C"
                        ELSE
                            LET l_pos = l_src_width.getIndexOf("in",1)
                            IF l_pos >= 1 THEN
                                LET l_gdo03 = l_src_width.subString(1,l_pos-1)
                                LET l_gdo05 = "I"
                            END IF
                        END IF
                    END IF
                END IF

                IF l_gdo05 = "C" THEN
                    LET l_pos = l_src_length.getIndexOf("cm",1)
                    IF l_pos >= 1 THEN
                        LET l_gdo04 = l_src_length.subString(1,l_pos-1)
                    END IF
                END IF

                IF l_gdo05 = "I" THEN
                    LET l_pos = l_src_length.getIndexOf("in",1)
                    IF l_pos >= 1 THEN
                        LET l_gdo04 = l_src_length.subString(1,l_pos-1)
                    END IF
                END IF

                IF l_gdo05 = "C" OR l_gdo05 = "I" THEN
                    LET l_gdo02 = NULL #FUN-CC0005 add 
                    SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
                    FROM gdo_file WHERE gdo03=l_gdo03 AND gdo04=l_gdo04
                    AND gdo05=l_gdo05
                    #IF NOTFOUND THEN #FUN-CC0005 mark
                    IF l_gdo02 IS NULL THEN  #FUN-CC0005 add
                        SELECT gdo02,gdo03,gdo04 INTO l_gdo02,l_gdo03,l_gdo04
                        FROM gdo_file WHERE gdo03=l_gdo04 AND gdo04=l_gdo03
                        AND gdo05=l_gdo05
                        #FUN-CC0005 ADD---(S)
                        #IF NOTFOUND THEN  #FUN-CC0005 mark
                        IF l_gdo02 IS NULL THEN  #FUN-CC0005 add
                           LET l_orientation = NULL 
                        ELSE 
                           LET l_orientation = "L"
                        END IF 

                    ELSE
                       LET l_orientation = "P"
                       #FUN-CC0005 ADD---(E)                        
                    END IF
                ELSE
                    LET l_gdo02 = l_gdo02 CLIPPED
                    LET l_gdo02_1 = UPSHIFT(l_gdo02) CLIPPED
                    LET l_gdo02_2 = DOWNSHIFT(l_gdo02) CLIPPED
                END IF

                #抓取目前樣版名稱
                IF l_gdw09[l_i] = g_gdw.gdw09 THEN
                    LET l_cur_gdo02 = l_gdo02
                END IF

                SELECT gdo03,gdo04 INTO l_gdo03,l_gdo04 FROM gdo_file
                WHERE gdo02=l_gdo02_1 OR gdo02=l_gdo02_2

                
                
                #當寬度大於A3橫向時
                IF p_width > 42 THEN
                    IF l_max_gdo03 < l_gdo04 AND l_max_gdo04 < l_gdo03 THEN
                        LET l_max_gdo03 = l_gdo04
                        LET l_max_gdo04 = l_gdo03
                        LET l_max_paper_size = l_gdo02
                    END IF
                ELSE
                    CASE l_orientation
                        WHEN "P"
                            IF l_max_gdo03 < l_gdo03 AND l_max_gdo04 < l_gdo04 THEN
                                LET l_max_gdo03 = l_gdo03
                                LET l_max_gdo04 = l_gdo04
                                LET l_max_paper_size = l_gdo02
                            END IF
                        WHEN "L"
                            IF l_max_gdo03 < l_gdo04 AND l_max_gdo04 < l_gdo03 THEN
                                LET l_max_gdo03 = l_gdo04
                                LET l_max_gdo04 = l_gdo03
                                LET l_max_paper_size = l_gdo02
                            END IF
                    END CASE
                END IF

                #DISPLAY "l_gdo02=",l_gdo02,"; l_gdo03=",l_gdo03,"; l_gdo04=",l_gdo04,"; l_max_paper_size=",l_max_paper_size
            END IF
        END IF
        LET l_i = l_i + 1
    END FOREACH
    CALL l_gdw09.deleteElement(l_i)

    LET l_max_paper_size_ori = l_max_paper_size
    LET l_max_paper_size = DOWNSHIFT(l_max_paper_size)
    LET l_cur_gdo02 = DOWNSHIFT(l_cur_gdo02)

    #計算後的紙張大小與原本紙張大小相同時,離開函式
   #FUN-D30026 ---start
   #IF l_max_paper_size = l_cur_gdo02 THEN RETURN END IF
   #IF (l_max_paper_size_ori = g_paper_size_input) AND (p_orientation = g_orientation_input) THEN
   #   RETURN
   #END IF
   #FUN-D30026 ---end

    #FUN-CC0005 ADD  --(S)
    IF p_orientation="P" THEN  #直 
       LET l_src_w=cl_replace_str(l_src_width,"cm","")
       LET l_src_l=cl_replace_str(l_src_length,"cm","")
    ELSE #橫
       LET l_src_w=cl_replace_str(l_src_length,"cm","")
       LET l_src_l=cl_replace_str(l_src_width,"cm","") 
    END IF 
 
  #FUN-D30026 --mark---start
   #SELECT COUNT(gdo02) INTO l_gdo02_cnt FROM gdo_file 
   #       WHERE gdo03 = l_src_w AND gdo04 = l_src_l
   #IF l_gdo02_cnt >0 THEN 
   #   LET l_dst_width=l_src_w
   #   LET l_dst_length =l_src_l
   #ELSE 
  #FUN-D30026 --mark---start

   #FUN-D30026 -----start
      IF cl_null(g_paper_size_input) AND cl_null(g_orientation_input) THEN  #FUN-D30026
    #FUN-CC0005 ADD  --(e)
       #LET l_param = l_max_paper_size
       #LET l_msg = cl_getmsg_parm("azz1082", g_lang, l_param)
       #LET l_result = FGL_WINQUESTION("",l_msg,"yes","yes|no","question",0)
       #IF l_result = "no" THEN RETURN END IF
      ELSE
        IF NOT cl_null(g_paper_size_input) AND ((g_paper_size_input <> l_max_paper_size_ori) OR (g_orientation_input <> p_orientation)) THEN
           INITIALIZE l_paper_sel.* TO NULL
           LET l_paper_sel.chk1 = 'N'
           LET l_paper_sel.chk2 = 'Y'
           LET l_paper_sel.type1= '1'
           LET l_paper_sel.type2= '2'
           LET l_paper_sel.paper1 = l_max_paper_size_ori
           LET l_paper_sel.paper2 = g_paper_size_input
           LET l_paper_sel.orient1= p_orientation
           LET l_paper_sel.orient2= g_orientation_input
           CALL p_replang_get_length_width(l_max_paper_size_ori,p_orientation) RETURNING l_paper_sel.width1,l_paper_sel.length1,l_paper_sel.unit1
           CALL p_replang_get_length_width(g_paper_size_input,g_orientation_input) RETURNING l_paper_sel.width2,l_paper_sel.length2,l_paper_sel.unit2

           OPEN WINDOW p_paper_sel WITH FORM "azz/42f/p_replang_paper"
               ATTRIBUTE (STYLE = g_win_style)
           CALL cl_ui_locale("p_replang_paper")

           INPUT BY NAME l_paper_sel.*  WITHOUT DEFAULTS

                ON CHANGE chk1
                   IF l_paper_sel.chk1 = "Y" THEN
                      LET l_paper_sel.chk2 = "N"
                   END IF
                   DISPLAY BY NAME l_paper_sel.chk1
                   DISPLAY BY NAME l_paper_sel.chk2
                AFTER FIELD chk1
                   IF l_paper_sel.chk1 = "Y" THEN
                      LET l_paper_sel.chk2 = "N"
                   END IF
                   DISPLAY BY NAME l_paper_sel.chk1
                   DISPLAY BY NAME l_paper_sel.chk2
                ON CHANGE chk2
                   IF l_paper_sel.chk2 = "Y" THEN
                      LET l_paper_sel.chk1 = "N"
                   END IF
                   DISPLAY BY NAME l_paper_sel.chk1
                   DISPLAY BY NAME l_paper_sel.chk2
                AFTER FIELD chk2
                   IF l_paper_sel.chk2 = "Y" THEN
                      LET l_paper_sel.chk1 = "N"
                   END IF
                   DISPLAY BY NAME l_paper_sel.chk1
                   DISPLAY BY NAME l_paper_sel.chk2

                ON ACTION CONTROLG
                   CALL cl_cmdask()
               
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE INPUT
               
                ON ACTION about
                   CALL cl_about()
               
                ON ACTION help
                   CALL cl_show_help()

                AFTER INPUT
                   IF INT_FLAG THEN
                      EXIT INPUT  
                   ELSE
                      IF l_paper_sel.chk1="N" AND l_paper_sel.chk2="N" THEN
                         LET INT_FLAG=TRUE
                         EXIT INPUT
                      END IF
                      IF l_paper_sel.chk1 = "Y" THEN
                         LET g_paper_size = l_paper_sel.paper1
                         LET g_orientation = l_paper_sel.orient1
                         LET l_dst_width = l_paper_sel.width1
                         LET l_dst_length = l_paper_sel.length1
                         LET l_unit = l_paper_sel.unit1
                      END IF
                      IF l_paper_sel.chk2 = "Y" THEN
                         LET g_paper_size = l_paper_sel.paper2
                         LET g_orientation = l_paper_sel.orient2
                         LET l_dst_width = l_paper_sel.width2
                         LET l_dst_length = l_paper_sel.length2
                         LET l_unit = l_paper_sel.unit2
                      END IF
                   END IF

           END INPUT
           IF INT_FLAG THEN
              CLOSE WINDOW p_paper_sel
              LET INT_FLAG=FALSE
              RETURN
           END IF
           CLOSE WINDOW p_paper_sel
        END IF
      END IF
      #FUN-D30026 -----end
    #END IF  #FUN-CC0005 ADD  #FUN-D30026 mark

      IF cl_null(l_unit) THEN LET l_unit = 'C' END IF #FUN-D30026

      #TQC-C20436 ADD-START
      SELECT gdo03,gdo04 INTO l_gdo03,l_gdo04 FROM gdo_file WHERE gdo02=g_paper_size
#FUN-D30026---start
     #LET l_dst_width = l_gdo03||"cm"
     #LET l_dst_length = l_gdo04||"cm"
      IF l_unit = "I" THEN
         LET l_dst_width = l_gdo03||"in"
         LET l_dst_length = l_gdo04||"in"
      ELSE
         LET l_dst_width = l_gdo03||"cm"
         LET l_dst_length = l_gdo04||"cm"
      END IF
#FUN-D30026---start
      #TQC-C20436 ADD-END

   #FUN-D30026 -----start
      IF g_orientation = "L" THEN
         LET l_str = l_dst_width
         LET l_dst_width = l_dst_length
         LET l_dst_length = l_str
      END IF
   #FUN-D30026 -----end
    
      
      #TQC-C20436 MARK-START
    
    #IF l_max_paper_size = "s0" OR l_max_paper_size = "s1" OR l_max_paper_size = "x0" THEN
        #LET l_dst_width = l_max_gdo03||"cm"
        #LET l_dst_length = l_max_gdo04||"cm"
    #ELSE
        #IF l_max_paper_size = "a0" OR l_max_paper_size = "a1" OR l_max_paper_size = "a2" THEN
            #LET l_dst_width = downshift(l_max_paper_size)||"length"
            #LET l_dst_length = downshift(l_max_paper_size)||"width"
        #ELSE
            #CASE l_orientation
                #WHEN "P"
                    #LET l_dst_width = downshift(l_max_paper_size)||"width"
                    #LET l_dst_length = downshift(l_max_paper_size)||"length"
                #WHEN "L"
                    #LET l_dst_width = downshift(l_max_paper_size)||"length"
                    #LET l_dst_length = downshift(l_max_paper_size)||"width"
            #END CASE
        #END IF
    #END IF
    #TQC-C20436 MARK-END
    FOR l_i = 1 TO l_gdw09.getLength()
        LET l_4rpfile = l_gdw09[l_i] CLIPPED||".4rp"
        LET l_doc = om.DomDocument.createFromXmlFile(l_4rpfile)
        LET l_doc_root = l_doc.getDocumentElement()
        LET l_node_list = l_doc_root.selectByTagName("report:Settings")
        IF l_node_list.getLength() >= 1 THEN
            LET l_cur_node = l_node_list.item(1)
            CALL l_cur_node.removeAttribute("RWPageWidth")
            CALL l_cur_node.setAttribute("RWPageWidth",l_dst_width)
            CALL l_cur_node.removeAttribute("RWPageLength")
            CALL l_cur_node.setAttribute("RWPageLength",l_dst_length)
            CALL l_doc_root.writeXml(l_4rpfile)
        END IF
    END FOR

    LET g_orientation_input = NULL #FUN-D30026
    LET g_paper_size_input = NULL  #FUN-D30026

    #回到執行前目錄
    IF os.Path.chdir(l_pwd) THEN END IF

    #將紙張變更更新到畫面上
    CALL p_replang_show_paper_size()
END FUNCTION

FUNCTION p_replang_change_paper_size()
    DEFINE ls_filename      STRING
    DEFINE l_doc            om.DomDocument
    DEFINE l_doc_root       om.DomNode
    DEFINE l_node_list      om.NodeList
    DEFINE l_cur_node       om.DomNode
    DEFINE l_gdo03          LIKE gdo_file.gdo03
    DEFINE l_gdo04          LIKE gdo_file.gdo04
    DEFINE l_dst_width      STRING
    DEFINE l_dst_length     STRING
    DEFINE l_msg            STRING
    DEFINE l_paper_uc       LIKE gdo_file.gdo02
    DEFINE l_paper_lc       LIKE gdo_file.gdo02
    DEFINE l_cnt            LIKE type_file.num10

    IF cl_null(g_gdw08) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF g_4rpdir IS NULL THEN
        CALL p_replang_get4rpdir()
    END IF
    LET ls_filename = os.Path.join(os.Path.join(g_4rpdir,g_gdm03 CLIPPED),g_gdw.gdw09||".4rp")

    IF NOT os.Path.exists(ls_filename) THEN
        LET l_msg = cl_getmsg("-16314",g_lang)
        MESSAGE l_msg
        RETURN
    END IF

    INPUT g_paper_size,g_orientation WITHOUT DEFAULTS FROM papersize,orientation
        ON ACTION controlp
            CASE WHEN INFIELD(papersize)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_grwp"
                LET g_qryparam.state = "i"
                LET g_qryparam.default1 = g_paper_size
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                LET g_paper_size = g_qryparam.multiret
                DISPLAY g_paper_size TO formonly.papersize
                
                CALL p_replang_set_entry2()                
            END CASE

        AFTER INPUT
            IF INT_FLAG THEN                            # 使用者不玩了
                EXIT INPUT
            END IF

           #FUN-D30026 -----start
            LET g_paper_size_input = g_paper_size
            LET g_orientation_input = g_orientation
           #FUN-D30026 -----end
            #TQC-C20436 ADD-START
            SELECT gdo03,gdo04 INTO l_gdo03,l_gdo04 FROM gdo_file WHERE gdo02=g_paper_size
            LET l_dst_width = l_gdo03||"cm"
            LET l_dst_length = l_gdo04||"cm"
            #TQC-C20436 ADD-END
            
            #TQC-C20436 MARK-START
            #IF g_paper_size = "s0" OR g_paper_size = "s1" OR g_paper_size = "x0" THEN
                #SELECT gdo03,gdo04 INTO l_gdo03,l_gdo04 FROM gdo_file WHERE gdo02=g_paper_size
                #IF SQLCA.sqlcode THEN
                    #CALL cl_err('',SQLCA.sqlcode,0)
                #ELSE
                    #LET l_dst_width = l_gdo03||"cm"
                    #LET l_dst_length = l_gdo04||"cm"
                #END IF
            #ELSE
                #IF g_paper_size = "a0" OR g_paper_size = "a1" OR g_paper_size = "a2"
                    #OR g_paper_size = "A0" OR g_paper_size = "A1" OR g_paper_size = "A2"
                #THEN
                    #LET l_dst_width = downshift(g_paper_size)||"length"
                    #LET l_dst_length = downshift(g_paper_size)||"width"
                #ELSE
                    #CASE g_orientation
                        #WHEN "P"
                            #LET l_dst_width = downshift(g_paper_size)||"width"
                            #LET l_dst_length = downshift(g_paper_size)||"length"
                        #WHEN "L"
                            #LET l_dst_width = downshift(g_paper_size)||"length"
                            #LET l_dst_length = downshift(g_paper_size)||"width"
                    #END CASE
                #END IF
            #END IF
            #TQC-C20436 MARK-END

          #FUN-D30026 mark------start
          #
          # LET l_doc = om.DomDocument.createFromXmlFile(ls_filename)
          # LET l_doc_root = l_doc.getDocumentElement()
          # LET l_node_list = l_doc_root.selectByTagName("report:Settings")
          # IF l_node_list.getLength() >= 1 THEN
          #     LET l_cur_node = l_node_list.item(1)
          #     CALL l_cur_node.removeAttribute("RWPageWidth")
          #     CALL l_cur_node.setAttribute("RWPageWidth",l_dst_width)
          #     CALL l_cur_node.removeAttribute("RWPageLength")
          #     CALL l_cur_node.setAttribute("RWPageLength",l_dst_length)
          #     CALL l_doc_root.writeXml(ls_filename)
          #     DISPLAY "update file: ",ls_filename
          # END IF
          #FUN-D30026 mark------end

        AFTER FIELD papersize
            LET l_paper_uc = UPSHIFT(g_paper_size)
            LET l_paper_lc = DOWNSHIFT(g_paper_size)
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM gdo_file WHERE gdo02=l_paper_uc OR gdo02=l_paper_lc
                OR gdo02 = g_paper_size  #FUN-D30026 add
            IF l_cnt <= 0 THEN
                CALL cl_err('','azz1072',0)
                NEXT FIELD papersize
            ELSE
                CALL p_replang_set_entry2()
            END IF

    END INPUT

    CALL p_replang_show_paper_size()
END FUNCTION

FUNCTION p_replang_set_entry2()
    IF g_paper_size = "s0" OR g_paper_size = "s1" OR g_paper_size = "x0"
        OR g_paper_size = "a0" OR g_paper_size = "a1" OR g_paper_size = "a2"
        OR g_paper_size = "A0" OR g_paper_size = "A1" OR g_paper_size = "A2"
    THEN
        LET g_orientation = "L"
        DISPLAY g_orientation TO formonly.orientation
        CALL cl_set_comp_entry("orientation",FALSE)
    ELSE
        CALL cl_set_comp_entry("orientation",TRUE)
    END IF
END FUNCTION

FUNCTION p_replang_show_paper_size()
    DEFINE ls_filename      STRING
    DEFINE l_doc            om.DomDocument
    DEFINE l_doc_root       om.DomNode
    DEFINE l_msg            STRING

    IF g_4rpdir IS NULL THEN
        CALL p_replang_get4rpdir()
    END IF
    LET ls_filename = os.Path.join(os.Path.join(g_4rpdir,g_gdm03 CLIPPED),g_gdw.gdw09||".4rp")
    IF NOT os.Path.exists(ls_filename) THEN
        LET l_msg = cl_getmsg("-16314",g_lang)
        MESSAGE l_msg
        RETURN
    ELSE
        MESSAGE ""
    END IF

    LET l_doc = om.DomDocument.createFromXmlFile(ls_filename)
    LET l_doc_root = l_doc.getDocumentElement()
    CALL cl_gr_get_4rp_paper_size(l_doc_root)
    RETURNING g_paper_size,g_orientation

    DISPLAY g_paper_size TO formonly.papersize
    DISPLAY g_orientation TO formonly.orientation
END FUNCTION

#FUN-C30008 --start--
#上傳4rp
FUNCTION p_replang_uploadlang4rp()
   DEFINE l_gdw            RECORD
          gdw01            LIKE gdw_file.gdw01,
          gdw02            LIKE gdw_file.gdw02,
          gdw03            LIKE gdw_file.gdw03,
          gdw04            LIKE gdw_file.gdw04,
          gdw05            LIKE gdw_file.gdw05,
          gdw06            LIKE gdw_file.gdw06,
          gdw09            LIKE gdw_file.gdw09
          END RECORD
   DEFINE l_gaz03          LIKE gaz_file.gaz03
   DEFINE l_zw02           LIKE zw_file.zw02
   DEFINE l_zx02           LIKE zx_file.zx02
   DEFINE ls_upload        STRING
   DEFINE lc_zz011         LIKE zz_file.zz011
   DEFINE ls_path          STRING 
   DEFINE ls_doc_path      STRING
   DEFINE ls_upload_file   STRING
   DEFINE ls_dir           STRING
   DEFINE l_upname         STRING
   DEFINE l_sql            STRING
   DEFINE l_rep                 LIKE type_file.chr1 #FUN-C50046
   DEFINE l_chk_err_msg        STRING   #FUN-C50046 #錯誤或警告訊息  
   DEFINE l_strong_err         INTEGER  #FUN-C50046 #強制錯誤訊息數 
   
   #檢查報表樣板ID與語言別是否有效
   IF cl_null(g_gdw08) OR cl_null(g_gdm03) OR g_gdw08 <= 0 THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   
   OPEN WINDOW p_grw_upload WITH FORM "azz/42f/p_grw_upload"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)

   CALL cl_ui_locale("p_grw_upload")

   #顯示上傳檔案視窗的單頭資料
   LET l_sql = "SELECT gdw01,gdw02,gdw03,gdw04,gdw05,",
               "       gdw06,gdw09",
               " FROM gdw_file",
               " WHERE gdw08 = ?"

   DECLARE p_replang_uploadlang4rp_curs CURSOR FROM l_sql
   OPEN p_replang_uploadlang4rp_curs USING g_gdw08
   FETCH p_replang_uploadlang4rp_curs INTO l_gdw.*
   CLOSE p_replang_uploadlang4rp_curs

   DISPLAY BY NAME l_gdw.gdw01, l_gdw.gdw02, l_gdw.gdw05, l_gdw.gdw04,
                   l_gdw.gdw06, l_gdw.gdw03, l_gdw.gdw09

   SELECT gaz03 INTO l_gaz03 FROM gaz_file
      WHERE gaz01 = l_gdw.gdw01 AND gaz02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET l_gaz03 = ""
   END IF
   DISPLAY l_gaz03 TO gaz03
     
   SELECT zw02 INTO l_zw02 FROM zw_file
      WHERE zw01 = l_gdw.gdw04
   IF SQLCA.SQLCODE THEN
      LET l_zw02 = ""
   END IF
   IF l_gdw.gdw04 = "default" THEN
      LET l_zw02 = "default"
   END IF
   DISPLAY l_zw02 TO zw02
   
   SELECT zx02 INTO l_zx02 FROM zx_file
      WHERE zx01 = l_gdw.gdw05
   IF SQLCA.SQLCODE THEN
      LET l_zx02 = ""
   END IF
   IF l_gdw.gdw05 = "default" THEN
      LET l_zx02 = "default"
   END IF
   DISPLAY l_zx02 TO zx02

   CALL cl_set_combo_industry("gdw06")
    LET l_rep=1 #FUN-C50046 add   
   INPUT ls_upload,l_rep WITHOUT DEFAULTS FROM upload,rep  #FUN-C50046 add l_rep,rep
      ATTRIBUTES(UNBUFFERED=TRUE)

        #FUN-C50046 add-s
       ON CHANGE rep
          DISPLAY "rep:",l_rep
          IF cl_null(l_rep) OR  l_rep NOT MATCHES '[12]' THEN
             NEXT FIELD rep
          END IF 
       #FUN-C50046 add-e
      ON ACTION file_browse
         CALL cl_browse_file() RETURNING ls_doc_path
         IF ls_doc_path.getIndexOf(".4rp",2) > 0 THEN
            SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01 = l_gdw.gdw01
            LET ls_upload_file = l_gdw.gdw09 CLIPPED,".4rp"
         ELSE
            CALL cl_err("Info:上傳檔案不是.4rp","!",1)
         END IF

         # LET ls_dir  = os.Path.join(os.Path.join(FGL_GETENV(lc_zz011),"4rp"),g_gdm03) #FUN-C50015 MARK
         #CALL p_replang_get4rpdir()  #FUN-C50015 add
         LET ls_dir  = os.Path.join(g_4rpdir,g_gdm03)  # FUN-C50015 janet add

         
         IF NOT os.Path.exists(ls_dir) THEN
            IF os.Path.mkdir(ls_dir) THEN     #make dir
               DISPLAY "make dir:",ls_dir
            END IF
         END IF
         
         LET ls_path = os.Path.join(ls_dir,ls_upload_file.trim())
         LET ls_upload = ls_doc_path

      ON ACTION file_upload
         IF cl_null(ls_upload) THEN CONTINUE INPUT END IF
         DISPLAY ls_upload
         #去掉檔案目錄
         LET l_upname = os.Path.basename(ls_upload)
         #取得主檔名
         LET l_upname = os.Path.rootname(l_upname)
         
         #舊檔路徑
         LET ls_path = os.Path.join(ls_dir, os.Path.basename(ls_upload))
         DISPLAY "old ls_path:",ls_path
         CALL s_gr_upload(ls_dir, ls_upload, g_gdw08, g_gdm03, l_rep)  #FUN-CB0063 121115 by stellar 參數多傳l_rep
              #FUN-CB0063 121115 by stellar ----(S)
              #將GR檢查部分移到s_gr_upload內
              # #FUN-C50046 -add---start
              #IF l_rep ="1" THEN  #標準報表才檢查
              #   DISPLAY "ls_path:",ls_path
              #   DISPLAY "g_gdw08:",g_gdw08
              #   DISPLAY "g_gdm03:",g_gdm03
              #   CALL p_replang_chk_grule(ls_path,g_gdw08,g_gdm03) RETURNING l_strong_err,l_chk_err_msg #GR檢查機制
              #    IF l_strong_err>0 THEN 
              #     #顯示檢查命名規則的錯誤訊息
              #     IF l_chk_err_msg IS NOT NULL THEN
              #        CALL cl_err(l_chk_err_msg,"!",-1)
              #        EXIT INPUT   
              #     END IF     
              #   END IF
              #END IF 
              ##FUN-C50046 -add---end          
              #FUN-CB0063 121115 by stellar ----(E)
         EXIT INPUT

          
      ON ACTION cancel
         EXIT INPUT
   END INPUT
   CLOSE WINDOW p_grw_upload
END FUNCTION
#FUN-C30008 --end--

#FUN-C30288 --start--
#取得現在語言別的4rp檔案路徑
FUNCTION p_replang_4rplangpath()
   DEFINE ls_dir  STRING
   DEFINE ls_path STRING

   CALL p_replang_get4rpdir()
   
   LET ls_dir = os.Path.join(g_4rpdir, g_gdm03)
   LET ls_path = g_gdw.gdw09,".4rp"
   LET ls_path = os.Path.join(ls_dir, ls_path)
   RETURN ls_path
END FUNCTION
#FUN-C30288 --end--

#FUN-C50024 抓取CR主機的IP --START--
FUNCTION p_replang_getCRIP()
   DEFINE l_crip_temp STRING
   DEFINE l_cmd       STRING
   DEFINE lc_chin     base.Channel
   DEFINE l_set       LIKE type_file.num5
   DEFINE l_read_str  STRING
   DEFINE l_host      STRING   #CR主機IP


   LET l_crip_temp=""
   LET l_crip_temp=fgl_getenv('CRIP')
   DISPLAY "crip_temp:" , l_crip_temp
   LET l_crip_temp=cl_replace_str(l_crip_temp,"http://","")
   LET l_set=l_crip_temp.getIndexOf("/",1)           #抓出/位置                              
   LET l_crip_temp=l_crip_temp.subString(1,l_set-1)  #抓出ip
   LET l_cmd = "/etc/hosts"
   LET lc_chin = base.Channel.create()               #create new 物件  
   CALL lc_chin.openFile(l_cmd,"r")                  #開啟檔案

   WHILE TRUE
      LET l_read_str =lc_chin.readLine()             #整行讀入
      IF l_read_str.getIndexOf(l_crip_temp,1)>0 THEN #找到此ip
         LET l_host=l_read_str.substring(l_crip_temp.getLength()+1,l_read_str.getLength() )
         LET l_host=cl_replace_str(l_host," ","") #FUN-CC0092 add
         LET l_host=cl_replace_str(l_host,"\t","") #FUN-CC0092 add

         LET l_host=l_host.trim()
         EXIT WHILE
      END IF
      IF lc_chin.isEof() THEN EXIT WHILE END IF      #判斷是否為最後         
   END WHILE  
   
   CALL lc_chin.close() 
   RETURN l_host
END FUNCTION
#FUN-C50024 抓取CR主機的IP -- END --

#FUN-D30026 依紙張與方向取得高度寬度
FUNCTION p_replang_get_length_width(p_paper_size,p_orientation) 
DEFINE p_paper_size   LIKE gdo_file.gdo02
DEFINE p_orientation  LIKE type_file.chr1
DEFINE l_gdo03        LIKE gdo_file.gdo03
DEFINE l_gdo04        LIKE gdo_file.gdo04
DEFINE l_gdo05        LIKE gdo_file.gdo05
DEFINE l_num          LIKE gdo_file.gdo03
DEFINE l_width,l_length LIKE type_file.chr100
DEFINE l_upper        LIKE type_file.chr100

    LET l_upper = UPSHIFT(p_paper_size)
    DECLARE p_replang_length_width_cs CURSOR FOR
    SELECT gdo03,gdo04,gdo05
      FROM gdo_file
     WHERE UPPER(gdo02) = l_upper
    FOREACH p_replang_length_width_cs INTO l_gdo03,l_gdo04,l_gdo05
        EXIT FOREACH
    END FOREACH

    IF p_orientation = "L" THEN
       LET l_num   = l_gdo03
       LET l_gdo03 = l_gdo04
       LET l_gdo04 = l_num
    END IF
    LET l_width = l_gdo03
    LET l_length= l_gdo04

    RETURN l_width,l_length,l_gdo05

END FUNCTION
