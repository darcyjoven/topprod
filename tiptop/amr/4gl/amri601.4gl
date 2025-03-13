# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amri601.4gl
# Descriptions...: 多工廠MRP模擬匯總明細維護作業
# Date & Author..: 05/11/09 By wujie
# Modify.........: No.FUN-590083 06/03/15 By Alexstar 增加多語言資料功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650087 06/06/01 By Rayven mss_g_file和mst_g_file命名
#                  不規範，mss_g_file現使用msu_file，mst_g_file現使用msv_file，
#                  相關欄位做相應更改：mss_gv改為msu000，mss_g06_fz改為msu066，
#                  mst_gv改為msv000，mst_gplant改為msv031，mst_gplantv改為msv032，
#                  mst_g06_fz改為msv066
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.MOD-6A0162 06/11/17 By pengu FOR UPDATE的SQL語法錯誤
# Modify.........: No.FUN-6B0041 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/22 By bnlent  單頭折疊功能修改
	# Modify.........: No.MOD-6A0120 06/12/13 By pengu 壓確認鍵出現'OPEN i601_cl':發生語法錯誤訊息
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740016 07/04/05 By Judy 匯出Excel出錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770031 07/07/05 By chenl   增加查詢下對狀態頁簽欄位的輸入。
# Modify.........: No.MOD-930255 09/03/27 By Smapmin 查詢時未依供需日期排序
#                                                    單身下條件時無法查詢
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改

# Modify.........: No.TQC-AC0062 10/12/07 By liweie 查詢不給任何條件按確定，筆數會計算錯誤 
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_msu           RECORD LIKE msu_file.*,
    g_msu_t         RECORD LIKE msu_file.*,
    g_msu_o         RECORD LIKE msu_file.*,
    g_msu000_t      LIKE msu_file.msu000,
    g_msu01_t       LIKE msu_file.msu01,
    g_msu02_t       LIKE msu_file.msu02,
    g_msu03_t       LIKE msu_file.msu03,
    g_wc,g_wc2,g_sql,g_sql_tmp LIKE type_file.chr1000,  #No.FUN-680082 VARCHAR(1000)
    g_msv         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        msv00         LIKE msv_file.msv00,
        msv031        LIKE msv_file.msv031,  
        azp02         LIKE azp_file.azp02,    
        msv032        LIKE msv_file.msv032,   
        msv041        LIKE msv_file.msv041,
        msv043        LIKE msv_file.msv043,
        msv044        LIKE msv_file.msv044,
        msv051        LIKE msv_file.msv051,
        msv052        LIKE msv_file.msv052,
        msv053        LIKE msv_file.msv053,
        msv061        LIKE msv_file.msv061,
        msv062        LIKE msv_file.msv062,
        msv063        LIKE msv_file.msv063,
        msv064        LIKE msv_file.msv064,
        msv065        LIKE msv_file.msv065,
        msv066        LIKE msv_file.msv066,  
        msv070        LIKE msv_file.msv070,
        msv08         LIKE msv_file.msv08,
        msv12         LIKE msv_file.msv12,
        msv13         LIKE msv_file.msv13,
        msv14         LIKE msv_file.msv14,
        msv16         LIKE msv_file.msv16 
                    END RECORD,
    g_msv_t       RECORD                 #程式變數 (舊值)
        msv00         LIKE msv_file.msv00,
        msv031        LIKE msv_file.msv031,  
        azp02         LIKE azp_file.azp02,    
        msv032        LIKE msv_file.msv032,
        msv041        LIKE msv_file.msv041,
        msv043        LIKE msv_file.msv043,
        msv044        LIKE msv_file.msv044,
        msv051        LIKE msv_file.msv051,
        msv052        LIKE msv_file.msv052,
        msv053        LIKE msv_file.msv053,
        msv061        LIKE msv_file.msv061,
        msv062        LIKE msv_file.msv062,
        msv063        LIKE msv_file.msv063,
        msv064        LIKE msv_file.msv064,
        msv065        LIKE msv_file.msv065,
        msv066        LIKE msv_file.msv066,  
        msv070        LIKE msv_file.msv070,
        msv08         LIKE msv_file.msv08,
        msv12         LIKE msv_file.msv12,
        msv13         LIKE msv_file.msv13,
        msv14         LIKE msv_file.msv14,
        msv16         LIKE msv_file.msv16 
                    END RECORD,
    g_msv_o       RECORD                 #程式變數 (舊值)
        msv00         LIKE msv_file.msv00,
        msv031        LIKE msv_file.msv031,
        azp02         LIKE azp_file.azp02,    
        msv032        LIKE msv_file.msv032,
        msv041        LIKE msv_file.msv041,
        msv043        LIKE msv_file.msv043,
        msv044        LIKE msv_file.msv044,
        msv051        LIKE msv_file.msv051,
        msv052        LIKE msv_file.msv052,
        msv053        LIKE msv_file.msv053,
        msv061        LIKE msv_file.msv061,
        msv062        LIKE msv_file.msv062,
        msv063        LIKE msv_file.msv063,
        msv064        LIKE msv_file.msv064,
        msv065        LIKE msv_file.msv065,
        msv066        LIKE msv_file.msv066,  
        msv070        LIKE msv_file.msv070,
        msv08         LIKE msv_file.msv08,
        msv12         LIKE msv_file.msv12,
        msv13         LIKE msv_file.msv13,
        msv14         LIKE msv_file.msv14,
        msv16         LIKE msv_file.msv16 
                    END RECORD,
    g_buf           LIKE type_file.chr1000,   #No.FUN-680082 VARCHAR(78)
  # g_argv1         VARCHAR(10), 
    g_argv1         LIKE type_file.chr20,     #No.FUN-680082 VARCHAR(10)
  # l_sfb09         INTEGER,
    l_sfb09         LIKE type_file.num10,     #No.FUN-680082 INTEGER
    g_rec_b         LIKE type_file.num5,      #單身筆數            #No.FUN-680082 SMALLINT
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT #No.FUN-680082 SMALLINT
  # l_sl            SMALLINT                  #目前處理的SCREEN LINE
    l_sl            LIKE type_file.num5       #No.FUN-680082 SMALLINT
 
DEFINE g_forupd_sql         STRING                 #SELECT ... FOR UPDATE  SQL 
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680082 SMALLINT
DEFINE g_chr                LIKE type_file.chr1    #No.FUN-680082 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE g_i                  LIKE type_file.num5    #count/index for any purpose  #No.FUN-680082 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000 #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE g_curs_index         LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE g_jump               LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5    #No.FUN-680082 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0076
    DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AMR")) THEN
       EXIT PROGRAM
    END IF
 
 
    LET g_argv1=ARG_VAL(1)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    LET p_row = 1 LET p_col = 2
    OPEN WINDOW i601_w AT p_row,p_col
        WITH FORM "amr/42f/amri601" 
        ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
 
    CALL i601()
    CLOSE WINDOW i601_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i601()
    INITIALIZE g_msu.* TO NULL
    INITIALIZE g_msu_t.* TO NULL
    INITIALIZE g_msu_o.* TO NULL
    CALL i601_lock_cur()
    CALL i601_menu()
END FUNCTION
 
FUNCTION i601_lock_cur()
 
   #------------------------No.MOD-6A0162 modify
   #LET g_forupd_sql = "SELECT * FROM msu_file WHERE msu000 = ? AND msu01 = ? AND msu02 = ? AND msu03 = ?  FOR UPDATE  "
    LET g_forupd_sql = "SELECT * FROM msu_file WHERE msu000 = ? AND msu01 = ? AND msu02 = ? AND msu03 = ?  FOR UPDATE"
   #------------------------No.MOD-6A0162 end
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION i601_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_msv.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0030
   INITIALIZE g_msu.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
               msu000, msu01, msu02, msu00, msu03,msu11,msu09, 
               msu12,msu041, msu043, msu044,                                                                                               
               msu051, msu052, msu053,                                                                                               
               msu061, msu062, msu063, msu064, msu065, msu066,                                                                       
               msu071, msu072, msu08,
               msuuser,msugrup,msumodu,msudate,msuacti     #No.TQC-770031
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('msuuser', 'msugrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON msv00,msv031,msv032,msv041,msv043,
                       msv044,msv051,msv052,msv053,msv061,
                       msv062,msv063,msv064,msv065,msv066,  
                       msv070,msv08,
                       msv12,msv13,msv14,msv16
            FROM s_msv[1].msv00,s_msv[1].msv031,s_msv[1].msv032,
                 s_msv[1].msv041,s_msv[1].msv043,s_msv[1].msv044,
                 s_msv[1].msv051,s_msv[1].msv052,s_msv[1].msv053,
                 s_msv[1].msv061,s_msv[1].msv062,s_msv[1].msv063,
                 s_msv[1].msv064,s_msv[1].msv065,s_msv[1].msv066,
                 s_msv[1].msv070,
                 s_msv[1].msv08,
                 s_msv[1].msv12,s_msv[1].msv13,
                 s_msv[1].msv14,s_msv[1].msv16
 
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
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND msuuser = '",g_user,"'"
    #    END IF
    IF g_wc2=' 1=1' THEN  
       LET g_sql="SELECT msu000,msu01,",
                 "             msu02,msu03",
                 "  FROM msu_file ",
                 " WHERE ",g_wc CLIPPED, 
                 #" ORDER BY msu01"   #MOD-930255
                 " ORDER BY msu000,msu01,msu02,msu03"   #MOD-930255
    ELSE 
       #LET g_sql="SELECT msu000,msu01,",   #MOD-930255
       LET g_sql="SELECT distinct msu000,msu01,",   #MOD-930255
                 "             msu02,msu03",
                 #"  FROM msu_file ",    #MOD-930255
                 "  FROM msu_file,msv_file ",    #MOD-930255
                 " WHERE msu01= msv01",
                 "   AND msu02= msv02",
                 "   AND msu03= msv03",
                 "   AND msu000 = msv000",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY msu000,msu01,msu02,msu03"
    END IF
    PREPARE i601_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i601_cs SCROLL CURSOR WITH HOLD FOR i601_prepare
    #-----MOD-930255---------
    #LET g_sql= "SELECT COUNT(*) FROM msu_file WHERE ",g_wc CLIPPED
    IF g_wc2=' 1=1' THEN   
    #------TQC-AC0062--------
    #  LET g_sql_tmp= "SELECT COUNT(*) FROM msu_file WHERE ",g_wc CLIPPED,
       LET g_sql_tmp= "SELECT * FROM msu_file WHERE ",g_wc CLIPPED,
       "                 INTO TEMP x "
    #------TQC-AC0062--END----
    ELSE 
       LET g_sql_tmp= "SELECT distinct msu000,msu01,msu02,msu03 FROM msu_file,msv_file ",   
                      " WHERE msu01= msv01",
                      "   AND msu02= msv02",
                      "   AND msu03= msv03",
                      "   AND msu000 = msv000",
"                         AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
"                         INTO TEMP x "
    END IF
    #-----END MOD-930255-----
DROP TABLE x
PREPARE i601_precount_x FROM g_sql_tmp
EXECUTE i601_precount_x
LET g_sql = "SELECT COUNT(*) FROM x"
PREPARE i601_precount FROM g_sql
    DECLARE i601_count CURSOR FOR i601_precount
END FUNCTION
 
FUNCTION i601_menu()
 
   WHILE TRUE
      CALL i601_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i601_q()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ')
               THEN CALL i601_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() AND (g_argv1 IS NULL OR g_argv1=' ') THEN 
               CALL i601_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
#               (ui.Interface.getRootNode(),base.TypeInfo.create(g_msu),'','') #TQC-740016 mark
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msv),'','') #TQC-740016
             END IF
 
         WHEN "Undo_Confirm" 
            IF cl_chk_act_auth() THEN 
               CALL i601_x()
            END IF
            CALL i601_show()
         WHEN "Confirm" 
            IF cl_chk_act_auth() THEN 
               CALL i601_y()
            CALL i601_show()
            END IF
 
         #No.FUN-6B0041-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_msu.msu000 IS NOT NULL THEN
                LET g_doc.column1 = "msu000"
                LET g_doc.column2 = "msu01"
                LET g_doc.column3 = "msu02"
                LET g_doc.column4 = "msu03" 
                LET g_doc.value1 = g_msu.msu000
                LET g_doc.value2 = g_msu.msu01
                LET g_doc.value3 = g_msu.msu02
                LET g_doc.value4 = g_msu.msu03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0041-------add--------end----
      END CASE
   END WHILE
      CLOSE i601_cs
END FUNCTION
 
   
FUNCTION i601_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680082 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-680082 SMALLINT
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0030
    INPUT BY NAME
           g_msu.msu01,g_msu.msu02,g_msu.msu09
        WITHOUT DEFAULTS
 
      BEFORE INPUT                                                                                                                  
         LET g_before_input_done = FALSE                                                                                            
         CALL i601_set_entry(p_cmd)                                                                                                 
         CALL i601_set_no_entry(p_cmd)                                                                                              
         LET g_before_input_done = TRUE   
 
 
        AFTER FIELD msu01
               #FUN-AA0059 ----------------add start-----------
               IF NOT cl_null(g_msu.msu01) THEN
                  IF NOT s_chk_item_no(g_msu.msu01,'') THEN
                     CALL cl_err('',g_errno,1)
                     NEXT FIELD msu01
                  END IF
               END IF
               #FUN-AA0059 ---------------add end-----------
               CALL msu01('d')
 
        AFTER FIELD msu02
               CALL msu02('d')
 
 
        AFTER FIELD msu09
               IF cl_null(g_msu.msu09) THEN
                  LET g_msu.msu09 = 0
                  NEXT FIELD msu09
               END IF
               IF g_msu.msu09< 0 THEN
                  LET g_msu.msu09 = 0
                  NEXT FIELD msu09
               END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,并要求重新輸入
           LET g_msu.msuuser = s_get_data_owner("msu_file") #FUN-C10039
           LET g_msu.msugrup = s_get_data_group("msu_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
        
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(msu01) THEN
        #        LET g_msu.* = g_msu_t.*
        #        CALL i601_show()
        #        NEXT FIELD msu01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
 
FUNCTION msu02(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1      #No.FUN-680082 VARCHAR(01)
DEFINE l_pmc03 LIKE pmc_file.pmc03
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
        WHERE pmc01 = g_msu.msu02
       IF NOT cl_null(SQLCA.sqlcode) THEN
         DISPLAY l_pmc03 TO FORMONLY.pmc03
       ELSE
         DISPLAY '  ' TO FORMONLY.pmc03
       END IF
END FUNCTION
 
FUNCTION msu01(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1      #No.FUN-680082 VARCHAR(01)
DEFINE l_ima02 LIKE ima_file.ima02
       SELECT ima02 INTO l_ima02 FROM ima_file
        WHERE ima01 = g_msu.msu01
       IF NOT cl_null(SQLCA.sqlcode) THEN
         DISPLAY l_ima02 TO FORMONLY.ima02
       ELSE
         DISPLAY '  ' TO FORMONLY.ima02
       END IF
END FUNCTION
 
FUNCTION i601_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msu.* TO NULL              #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i601_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_msv.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! " 
   
#TQC-AC0062----start-----
#   OPEN i601_count
#   FETCH i601_count INTO g_row_count
#   DISPLAY g_row_count TO FORMONLY.cnt
#TQC-AC0062----end-------

    OPEN i601_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
        INITIALIZE g_msu.* TO NULL
    ELSE

#TQC-AC0062----add-------
        OPEN i601_count
        FETCH i601_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
#TQC-AC0062----add-------

        CALL i601_fetch('F')                # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i601_fetch(p_flmsu)
    DEFINE
      # p_flmsu          VARCHAR(1),
        p_flmsu          LIKE type_file.chr1,      #No.FUN-680082 VARCHAR(1) 
        l_abso           LIKE type_file.num10      #No.FUN-680082 INTEGER
 
    CASE p_flmsu
        WHEN 'N' FETCH NEXT     i601_cs INTO g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
        WHEN 'P' FETCH PREVIOUS i601_cs INTO g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
        WHEN 'F' FETCH FIRST    i601_cs INTO g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
        WHEN 'L' FETCH LAST     i601_cs INTO g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt mod
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i601_cs INTO g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
        INITIALIZE g_msu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmsu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_msu.* FROM msu_file       # 重讀DB,因TEMP有不被更新特性
       WHERE msu000=g_msu.msu000 AND msu01=g_msu.msu01 AND msu02=g_msu.msu02 AND msu03=g_msu.msu03
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
    ELSE                                      #FUN-4C0042權限控管
        LET g_data_owner=g_msu.msuuser
       # LET g_data_group=g_msu.msugrup
        CALL i601_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i601_show()
    LET g_msu_t.* = g_msu.*
    DISPLAY BY NAME
               g_msu.msu000, g_msu.msu01, g_msu.msu02, g_msu.msu00, g_msu.msu03,g_msu.msu11,g_msu.msu09, 
               g_msu.msu12,g_msu.msu041, g_msu.msu043, g_msu.msu044,                                                                                               
               g_msu.msu051, g_msu.msu052, g_msu.msu053,                                                                                               
               g_msu.msu061, g_msu.msu062, g_msu.msu063, g_msu.msu064, g_msu.msu065, g_msu.msu066,                                                                     
               g_msu.msu071, g_msu.msu072, g_msu.msu08,  
               g_msu.msuuser, g_msu.msudate, g_msu.msumodu, g_msu.msugrup,g_msu.msuacti
 
    CALL msu01('d')
    CALL msu02('d')
    CALL cl_set_field_pic(g_msu.msu12,"","","","",g_msu.msuacti)
    #CALL i601_b_fill(' 1=1')   #MOD-930255
    CALL i601_b_fill(g_wc2)   #MOD-930255
    CALL cl_show_fld_cont()               #No.FUN-590083
END FUNCTION
 
FUNCTION i601_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_msu.msu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #-->已審核不可修改
    IF g_msu.msu12 = 'Y' THEN CALL cl_err('','aap-005',1) RETURN END IF
    #-->無效不可修改
    IF g_msu.msuacti != 'Y' THEN CALL cl_err('','aap-127',1) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i601_cl USING g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
    IF STATUS THEN
       CALL cl_err("OPEN i601_cl:", STATUS, 1)
       CLOSE i601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i601_cl INTO g_msu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        CLOSE i601_cl
        RETURN
    END IF
    LET g_msu01_t = g_msu.msu01
    LET g_msu02_t = g_msu.msu02
    LET g_msu03_t = g_msu.msu03
    LET g_msu000_t = g_msu.msu000
    LET g_msu_o.*=g_msu.*
    LET g_msu.msumodu = g_user
    LET g_msu.msudate = g_today                  #修改日期
    CALL i601_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i601_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_msu.*=g_msu_t.*
            CALL i601_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE msu_file SET msu_file.msu09 = g_msu.msu09    # 更新DB
            WHERE msu000=g_msu.msu000 AND msu01=g_msu.msu01 AND msu02=g_msu.msu02 AND msu03=g_msu.msu03             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i601_cl
    COMMIT WORK
END FUNCTION
 
   
FUNCTION i601_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_msu.msu12 = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
   IF g_msu.msuacti = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'
 
   OPEN i601_cl USING g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
   IF STATUS THEN
      CALL cl_err("OPEN i601_cl:", STATUS, 1)
      CLOSE i601_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i601_cl INTO g_msu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i601_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_msu.msu01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_confirm('aim-304')  THEN
            LET g_msu.msu12 ='N' 
            LET g_msu.msudate=g_today
            LET g_msu.msumodu=g_user 
        UPDATE msu_file                
            SET msu12=g_msu.msu12,
                msumodu=g_user,
                msudate=g_today
            WHERE msu01  =g_msu.msu01
              AND msu02  =g_msu.msu02
              AND msu03  =g_msu.msu03
              AND msu000 =g_msu.msu000
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
            LET g_msu.msu12='Y'  
        END IF
        CALL i601_show()
   END IF 
    CLOSE i601_cl  
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i601_y()
   IF cl_null(g_msu.msu01) THEN RETURN END IF   #No.MOD-6A0120 add
   IF s_shut(0) THEN RETURN END IF
   IF g_msu.msu12 = 'Y' THEN RETURN END IF
   IF g_msu.msuacti = 'N' THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'
 
   OPEN i601_cl USING g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
   IF STATUS THEN
      CALL cl_err("OPEN i601_cl:", STATUS, 1)
      CLOSE i601_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i601_cl INTO g_msu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i601_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_msu.msu01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_confirm('aap-017')   THEN
            LET g_msu.msu12 ='Y'
            LET g_msu.msudate=g_today
            LET g_msu.msumodu=g_user 
        UPDATE msu_file                
            SET msu12=g_msu.msu12,
                msumodu=g_user,
                msudate=g_today
            WHERE msu01  =g_msu.msu01
              AND msu02  =g_msu.msu02
              AND msu03  =g_msu.msu03
              AND msu000 =g_msu.msu000
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
            LET g_msu.msu12='N'  
        END IF
        CALL i601_show()
   END IF 
    CLOSE i601_cl  
    COMMIT WORK
END FUNCTION
 
FUNCTION i601_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680082 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重復用        #No.FUN-680082 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680082 VARCHAR(1)
  # l_sfb38         DATE,
    l_sfb38         LIKE type_file.dat,     #No.FUN-680082 DATE
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680082 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680082 SMALLINT
 
    LET g_action_choice = ""
    LET l_allow_insert = 'N'
    LET l_allow_delete = 'N'
    IF s_shut(0) THEN RETURN END IF
    IF g_msu.msu01 IS NULL THEN RETURN END IF
    #-->已審核不可修改
    IF g_msu.msu12 = 'Y' THEN CALL cl_err('','aap-005',1) RETURN END IF
    #-->無效不可修改
    IF g_msu.msuacti != 'Y' THEN CALL cl_err('','aap-127',1) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT msv00,msv031,'',msv032,msv041,",
                       "        msv043,msv044,msv051,msv052,msv053,msv061,",
                       "        msv062,msv063,msv064,msv065,msv066,",
                       "        msv070,msv08,",
                       "        msv12,msv13,msv14,msv16",
                       " FROM msv_file ",
                       " WHERE msv01=? ",
                       "   AND msv00=? ",
                       "   AND msv02=? ",
                       "   AND msv03=? ",
                       "   AND msv000=? ",
                      #--No.MOD-6A0162 modify
                      #" FOR UPDATE "
                       " FOR UPDATE "
                      #--No.MOD-6A0162 end
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_msv WITHOUT DEFAULTS FROM s_msv.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE)  
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn2  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
        BEGIN WORK
 
        OPEN i601_cl USING g_msu.msu000,g_msu.msu01,g_msu.msu02,g_msu.msu03
        IF STATUS THEN
           CALL cl_err("OPEN i601_cl:", STATUS, 1)
           CLOSE i601_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH i601_cl INTO g_msu.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_msu.msu01,SQLCA.sqlcode,0)
            ROLLBACK WORK
            CLOSE i601_cl
            RETURN
        END IF
 
        IF g_rec_b>=l_ac THEN
        LET p_cmd='u'
        LET g_msv_t.* = g_msv[l_ac].*  #BACKUP
        OPEN i601_bcl USING g_msu.msu01,g_msv_t.msv00,g_msu.msu02,g_msu.msu03,g_msu.msu000
        IF STATUS THEN
           CALL cl_err("OPEN i601_bcl:", STATUS, 1)
           CLOSE i601_bcl
           ROLLBACK WORK
           RETURN
        ELSE
           FETCH i601_bcl INTO g_msv[l_ac].*
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_msv[l_ac].msv00,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
           END IF
           CALL i601_msv031('d') 
        END IF
           CALL cl_show_fld_cont()               #No.FUN-590083
        END IF
 
           
 
        AFTER FIELD msv12
           IF cl_null(g_msv[l_ac].msv12) THEN
              LET g_msv[l_ac].msv12 = 0
           END IF
           IF g_msv[l_ac].msv12 < 0 THEN
              LET g_msv[l_ac].msv12 = NULL
              NEXT FIELD msv12
           END IF
 
        AFTER FIELD msv13
           IF cl_null(g_msv[l_ac].msv13) THEN
              LET g_msv[l_ac].msv13 = 0
           END IF
           IF g_msv[l_ac].msv13 < 0 THEN
              LET g_msv[l_ac].msv13 = NULL
              NEXT FIELD msv13
           END IF
 
 
        AFTER FIELD msv14
           IF cl_null(g_msv[l_ac].msv14) THEN
              LET g_msv[l_ac].msv14 = 0
           END IF
 
        AFTER FIELD msv16
           IF cl_null(g_msv[l_ac].msv16) THEN
              LET g_msv[l_ac].msv16 = 0
           END IF
           IF g_msv[l_ac].msv16 < 0 THEN
              LET g_msv[l_ac].msv16 = NULL
              NEXT FIELD msv16
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_msv[l_ac].* = g_msv_t.*
               CLOSE i601_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_msv[l_ac].msv00,-263,1)
               LET g_msv[l_ac].* = g_msv_t.*
            ELSE
               UPDATE msv_file SET
                     msv12=g_msv[l_ac].msv12,
                     msv13=g_msv[l_ac].msv13,
                     msv14=g_msv[l_ac].msv14,
                     msv16=g_msv[l_ac].msv16 
               WHERE msv01=g_msu.msu01
                 AND msv02=g_msu.msu02
                 AND msv03=g_msu.msu03
                 AND msv000=g_msu.msu000
                 AND msv031=g_msv[l_ac].msv031
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err(g_msv[l_ac].msv00,SQLCA.sqlcode,0)
                   LET g_msv[l_ac].* = g_msv_t.*
                   DISPLAY g_msv[l_ac].* TO s_msv[l_sl].*
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
                  LET g_msv[l_ac].* = g_msv_t.*
               END IF
               CLOSE i601_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i601_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(msv00) AND l_ac > 1 THEN
                LET g_msv[l_ac].* = g_msv[l_ac-1].*
                LET g_msv[l_ac].msv00 = 0
                NEXT FIELD msv00
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
#NO.FUN-6B0030--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0030--END 
        
        END INPUT
 
        CLOSE i601_bcl
        COMMIT WORK
END FUNCTION
 
FUNCTION i601_msv031(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)
       l_azp02     LIKE azp_file.azp02
 
   LET g_errno = ''
   SELECT azp02
     INTO l_azp02
     FROM azp_file
    WHERE azp01=g_msv[l_ac].msv031
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'   #MOD-480039
                                  LET g_msv[l_ac].azp02 ='' 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN 
       LET g_msv[l_ac].azp02 = l_azp02
       DISPLAY BY NAME g_msv[l_ac].azp02
    ELSE
       DISPLAY '  ' TO g_msv[l_ac].azp02
    END IF
END FUNCTION
 
FUNCTION i601_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(1000)
 
    CONSTRUCT g_wc2 ON msv00,msv031,msv032,msv041,msv043,
                       msv044,msv051,msv052,msv053,msv061,msv062,
                       msv063,msv064,msv065,msv066,msv070,
                       msv08,msv12,msv13,msv14,msv16 
            FROM s_msv[1].msv00,s_msv[1].msv031,s_msv[1].msv032,
                 s_msv[1].msv041,s_msv[1].msv043,s_msv[1].msv044,
                 s_msv[1].msv051,s_msv[1].msv052,s_msv[1].msv053,
                 s_msv[1].msv061,s_msv[1].msv062,s_msv[1].msv063,
                 s_msv[1].msv064,s_msv[1].msv065,s_msv[1].msv066,
                 s_msv[1].msv070,
                 s_msv[1].msv08,
                 s_msv[1].msv12,s_msv[1].msv13,
                 s_msv[1].msv14,s_msv[1].msv16
       ON IDLE g_idle_seconds
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    CALL i601_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i601_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680082 VARCHAR(200)
 
    LET g_sql = " SELECT msv00,msv031,'',msv032,msv041,",
                "        msv043,msv044,msv051,msv052,msv053,msv061,",
                "        msv062,msv063,msv064,msv065,msv066,",
                "        msv070,msv08,",
                "        msv12,msv13,msv14,msv16",
                " FROM msv_file",
                " WHERE msv01= '",g_msu.msu01,"'",
                "   AND msv02='",g_msu.msu02,"'",
                "   AND msv03= '",g_msu.msu03,"'",
                "   AND msv000= '",g_msu.msu000,"'",
                "   AND ",p_wc2 CLIPPED,   #MOD-930255
                " ORDER BY 1"
    PREPARE i601_pb FROM g_sql
    DECLARE msv_curs CURSOR FOR i601_pb
 
    CALL g_msv.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH msv_curs INTO g_msv[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET l_ac = g_cnt
        CALL i601_msv031('d') 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    CALL g_msv.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2  
END FUNCTION
 
FUNCTION i601_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680082 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msv TO s_msv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()               #No.FUN-590083
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION Confirm
         LET g_action_choice="Confirm"
         EXIT DISPLAY
      ON ACTION Undo_Confirm
         LET g_action_choice="Undo_Confirm"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i601_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY               #No.FUN-590083
                              
 
      ON ACTION previous
         CALL i601_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY               #No.FUN-590083
 
      ON ACTION jump 
         CALL i601_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY               #No.FUN-590083
                              
 
      ON ACTION next
         CALL i601_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY               #No.FUN-590083
                              
 
      ON ACTION last 
         CALL i601_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY               #No.FUN-590083
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               #No.FUN-590083
         #圖形顯示
         CALL cl_set_field_pic("","","",g_msu.msu03,"","")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6B0041  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
#NO.FUN-6B0030--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0030--END
      # No.FUN-590083 --start--   
      AFTER DISPLAY   
        CONTINUE DISPLAY
      # No.FUN-590083 ---end---
    
       
END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i601_bp_refresh()
   DISPLAY ARRAY g_msv TO s_msv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
#NO.FUN-6B0030--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0030--END      
   
   END DISPLAY
END FUNCTION
 
FUNCTION i601_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                             
      CALL cl_set_comp_entry("msu01,msu02",TRUE)                                                                                          
    END IF                                                                                                                          
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i601_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                                  #No.FUN-680082
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN                                                           
       CALL cl_set_comp_entry("msu01,msu02",FALSE)                                                                                        
    END IF                                                                                                                          
END FUNCTION  

