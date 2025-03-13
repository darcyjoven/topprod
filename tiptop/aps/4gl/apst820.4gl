# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apst820.4gl
# Descriptions...: APS工單建議調整維護作業
# Date & Author..: 08/04/29 By rainy  #FUN-840156
# Modify.........: No.FUN-840209 08/05/22 By Mandy g_dbs =>g_plant
# Modify.........: No.FUN-840209 08/06/10 By Duke 
# Modify.........: No.FUN-860060 08/06/18 BY duke
# Modify.........: No.FUN-870099 08/07/21 BY duke  add vod39 是否有用製程,加入單身QBE
# Modify.........: No.FUN-870153 08/07/30 BY duke  修正資料筆數重覆
# Modify.........: No.FUN-880023 08/08/05 BY duke  單身新增註記"建議委外否",來源為voo_file
# Modify.........: No.TQC-880021 08/08/14 BY DUKE  LOCK 單身是否委外及有無製程欄位
# Modify.........: No.TQC-890023 08/09/18 BY DUKE  無資料時，按下工單維護action 畫面會被關掉
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0187 09/11/04 BY xiaofeizhu 標準SQL修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-840156
#模組變數(Module Variables)
DEFINE
    g_vod01         LIKE vod_file.vod01,
    g_vod02         LIKE vod_file.vod01,
    g_vod          DYNAMIC ARRAY OF RECORD 
        vod37            LIKE vod_file.vod37,   #變更否
        sfb04            LIKE sfb_file.sfb04,   #狀態(f.status):  A:工單調整  B:工單變更 C:不可調整
        voh07            LIKE voh_file.voh07,   #APS變更碼(voh07):    0：無變更；1：廠內工單轉外包；2：外包工單轉廠內工單；3：委外工單供應商變更；4：工單作業轉外包作業；5：委外作業轉廠內作業；6：委外作業供應商變更；7：工單製程變更；8：作業編號變更
        isoutsource      LIKE type_file.chr1,        #建議委外否 #FUN-880023
        vod05            LIKE vod_file.vod05,   #工單號碼
        vod09            LIKE vod_file.vod09,   #料號
        ima02            LIKE ima_file.ima02,   #品名
        chang            LIKE type_file.chr1,   #來源己異動  #FUN-860060
        vod06            LIKE vod_file.vod06,   #原完工期    #FUN-860060
        vod10            LIKE vod_file.vod10,   #APS建議完工期
        vod04            LIKE vod_file.vod04,   #原生產量    #FUN-860060
        vod35            LIKE vod_file.vod35,   #APS生產量
        qty              LIKE vod_file.vod35,   #建議調整數量 #FUN-860060
        vod03            LIKE vod_file.vod03,    #序號
        vod39            LIKE vod_file.vod39    #是否使用製程
                    END RECORD,
 
        tm  RECORD  #FUN-870099
            #wc      LIKE type_file.chr1000,
            #wc2     LIKE type_file.chr1000
            wc          STRING,     #NO.FUN-910082 
        	  wc2         STRING     #NO.FUN-910082  
            END RECORD,
    g_rec_b         LIKE type_file.num5,            #單身筆數   
    g_sql           STRING, 
    g_cmd           LIKE type_file.chr1000,       
    g_t1            LIKE type_file.chr5,          
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT      
 
#主程式開始
DEFINE  p_row,p_col         LIKE type_file.num5          
DEFINE  l_action_flag        STRING
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5         
DEFINE  g_cnt           LIKE type_file.num10         
DEFINE  g_msg           LIKE ze_file.ze03        
DEFINE  lc_qbe_sn          LIKE gbm_file.gbm01      #FUN-870099
DEFINE  g_row_count    LIKE type_file.num10         
DEFINE  g_curs_index   LIKE type_file.num10         
DEFINE  g_jump         LIKE type_file.num10         
DEFINE  mi_no_ask      LIKE type_file.num5          
DEFINE  g_argv1        LIKE vod_file.vod01,
        g_argv2        LIKE vod_file.vod02
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_argv2      = ARG_VAL(2)          # 參數值(2)
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW t820_w AT 2,2 WITH FORM "aps/42f/apst820"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    CALL t820_default()
 
    IF NOT cl_null(g_argv1) THEN
       CALL t820_q()
    END IF
    #TQC-880021  lock 是否委外,有無製程
    CALL cl_set_comp_entry("isoutsource,vod39",FALSE)
    CALL t820_menu()
 
    CLOSE WINDOW t820_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION t820_default()
  CALL cl_set_comp_visible("vod03",FALSE)
 
END FUNCTION
 
#QBE 查詢資料
FUNCTION t820_cs()
 
 DEFINE  l_type          LIKE type_file.chr2        
 
   CLEAR FORM                             #清除畫面
   CALL g_vod.clear()
 
   INITIALIZE g_vod01 TO NULL   
   INITIALIZE g_vod02 TO NULL   
 
   IF NOT cl_null(g_argv1) THEN
     LET tm.wc = " vod01 = '",g_argv1,"'"
     IF NOT cl_null(g_argv2) THEN
       LET tm.wc = tm.wc, " AND vod02 ='",g_argv2,"'"
     END IF
     #FUN-870099  add ---begin---
     LET tm.wc2=" 1=1 "
#     LET g_sql  = "SELECT UNIQUE vod01,vod02 ",
#                  " FROM vod_file ",
#                  " WHERE ", tm.wc CLIPPED,
#                  "   AND ", tm.wc2 CLIPPED,
#                  " ORDER BY vod01,vod02"
 
    LET g_sql = "SELECT UNIQUE vod01,vod02 ",
                 "  FROM vod_file,voh_file,sfb_file ",
                 " WHERE vod00 ='",g_plant,"'", #FUN-840209
                 #"   AND vod01 ='",g_vod01,"'",
                 #"   AND vod02 ='",g_vod02,"'",
                 #"   AND ",p_wc1 CLIPPED,
                 "   AND vod01=voh01 AND vod02=voh02 AND vod03=voh03 ",
                 "   AND vod05=sfb01",
                 "   AND vod08='0' ",
                 "   AND (voh04<>'0' or voh05<>'0' or voh07<>'0') ", #FUN-86006
                 "   AND ",tm.wc CLIPPED, #FUN-870099
                 "   AND ",tm.wc2 CLIPPED, #FUN-870099
                 " ORDER BY vod01,vod02"
 
     #FUN-870099   add---end---
 
   ELSE
     CONSTRUCT BY NAME tm.wc ON vod01,vod02
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(vod01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_vod01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO vod01
              NEXT FIELD vod01
           OTHERWISE EXIT CASE
        END CASE
 
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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)
     END CONSTRUCT
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF INT_FLAG THEN 
          RETURN 
     END IF
     #FUN-870099  add ----begin----
     CALL cl_set_head_visible("","YES")
     CALL q820_b_askkey()
     IF INT_FLAG THEN
        RETURN
     END IF
     #fun-870099  add  ----end----
   END IF
 
#   LET g_sql  = "SELECT UNIQUE vod01,vod02 ",
#                " FROM vod_file ",
#                " WHERE ", tm.wc CLIPPED,
#                "   AND ", tm.wc2 CLIPPED,
#                " ORDER BY vod01,vod02"
 
  LET g_sql = "SELECT UNIQUE vod01,vod02 ",
              " FROM vod_file,voh_file,sfb_file",
              " WHERE vod00 ='",g_plant,"'", #FUN-840209
             #"  AND  vod01 ='",g_vod01,"'",
             #"  AND  vod02 ='",g_vod02,"'",
             #"  AND          ",p_wc1 CLIPPED,
              "  AND  vod01 =voh01 AND vod02=voh02 AND vod03=voh03 ",
              "   AND vod05=sfb01",
              "   AND vod08='0' ",
              "   AND (voh04<>'0' or voh05<>'0' or voh07<>'0') ", #FUN-86006
              "   AND ",tm.wc CLIPPED, #FUN-870099
              "   AND ",tm.wc2 CLIPPED, #FUN-870099
              " ORDER BY vod01,vod02"
 
   PREPARE t820_prepare FROM g_sql
   DECLARE t820_cs SCROLL CURSOR WITH HOLD FOR t820_prepare
 
   #LET g_sql  = "SELECT COUNT(UNIQUE vod01) ",
   #             " FROM vod_file ",
   #             " WHERE ", tm.wc CLIPPED
 
   #FUN-870153
    LET g_sql = " SELECT COUNT(UNIQUE vod01) ",
                " FROM vod_file,voh_file,sfb_file",
                " WHERE vod00 ='",g_plant,"'", #FUN-840209
                "  AND  vod01 =voh01 AND vod02=voh02 AND vod03=voh03 ",
                "   AND vod05=sfb01",
                "   AND vod08='0' ",
                "   AND (voh04<>'0' or voh05<>'0' or voh07<>'0') ", #FUN-86006
                "   AND ",tm.wc CLIPPED, #FUN-870099
                "   AND ",tm.wc2 CLIPPED, #FUN-870099
                " ORDER BY vod01,vod02"
 
 
 
   PREPARE t820_precount FROM g_sql
   DECLARE t820_count CURSOR FOR t820_precount
END FUNCTION
 
#FUN-870099
FUNCTION q820_b_askkey()
  CONSTRUCT tm.wc2 ON vod37,voh07,vod05,vod09,ima02,vod06,vod10,vod04,vod35
       FROM s_vod[1].vod37,s_vod[1].voh07,
            s_vod[1].vod05,s_vod[1].vod09,
            s_vod[1].ima02,s_vod[1].vod06,
            s_vod[1].vod10,s_vod[1].vod04,
            s_vod[1].vod35
 
     BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
 
     ON IDLE g_idle_seconds
     CALL cl_on_idle()
          CONTINUE CONSTRUCT
     ON ACTION about
        CALL cl_about()
     ON ACTION help
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(vod09)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_ima"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO vod09
              NEXT FIELD vod09
           OTHERWISE EXIT CASE
        END CASE
 
     ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION
 
 
 
FUNCTION t820_menu()
 
   WHILE TRUE
      CALL t820_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t820_q()
            END IF
 
         WHEN "view_aps_wo"      #APS建議工單檢視
            IF cl_chk_act_auth() THEN
               IF g_rec_b > 0 AND l_ac > 0 THEN
                 LET g_msg = " apsq821 '", g_vod[l_ac].vod05,"'  '", g_vod01,"' '", g_vod02,"'"
                 CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            END IF
         WHEN "maint_w_o"  #工單維護
            IF cl_chk_act_auth() THEN
               LET g_msg = " asfi301 '", g_vod[l_ac].vod05,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "change_wo"   #開立工單變更單
            IF cl_chk_act_auth() THEN
               LET g_msg = " asft803 "
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
 
         WHEN "detail"
            CALL t820_b()
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION t820_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_vod01 TO NULL   
   INITIALIZE g_vod02 TO NULL   
   CALL g_vod.clear()
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t820_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t820_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      INITIALIZE g_vod01 TO NULL   
      INITIALIZE g_vod02 TO NULL   
      CALL g_vod.clear()
   ELSE
      OPEN t820_count
      FETCH t820_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t820_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
 
#處理資料的讀取
FUNCTION t820_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t820_cs INTO g_vod01,g_vod02
      WHEN 'P' FETCH PREVIOUS t820_cs INTO g_vod01,g_vod02
      WHEN 'F' FETCH FIRST    t820_cs INTO g_vod01,g_vod02
      WHEN 'L' FETCH LAST     t820_cs INTO g_vod01,g_vod02
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION about         
                  CALL cl_about()      
               ON ACTION help          
                  CALL cl_show_help()  
               ON ACTION controlg      
                  CALL cl_cmdask()     
            END PROMPT
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t820_cs INTO g_vod01,g_vod02 
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vod01,SQLCA.sqlcode,0)
      INITIALIZE g_vod01 TO NULL  
      INITIALIZE g_vod02 TO NULL  
      CLEAR FORM
      CALL g_vod.clear()
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
   SELECT UNIQUE vod01,vod02 INTO g_vod01,g_vod02 FROM vod_file WHERE vod01 = g_vod01 AND vod02 = g_vod02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","vod_file",g_vod01,g_vod02,SQLCA.sqlcode,"","",1)  
      INITIALIZE g_vod01 TO NULL  
      INITIALIZE g_vod02 TO NULL  
      CALL g_vod.clear()
      RETURN
   END IF
   CALL t820_show()
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION t820_show()
   DISPLAY g_vod01 TO vod01
   DISPLAY g_vod02 TO vod02
 
   CALL t820_b_fill("1=1")    #單身 
   CALL cl_show_fld_cont()               
END FUNCTION
 
 
FUNCTION t820_b()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_vod37t        LIKE vod_file.vod37
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_vod01) OR cl_null(g_vod02) THEN RETURN END IF
 
   IF g_rec_b = 0 THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * ",
                      " FROM vod_file",
                      " WHERE vod00=? AND vod01=? AND vod02=? and vod03=?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t820_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_vod WITHOUT DEFAULTS FROM s_vod.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
     BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
 
        BEGIN WORK
        IF g_rec_b >= l_ac THEN
           LET p_cmd='u'
           OPEN t820_b_cl USING g_plant,g_vod01,g_vod02,g_vod[l_ac].vod03 #FUN-840209
           IF STATUS THEN
              CALL cl_err("OPEN t820_b_cl:", STATUS, 1)
              LET l_lock_sw = "Y"
           END IF
           LET l_vod37t = g_vod[l_ac].vod37
        END IF
 
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_vod[l_ac].vod37 = l_vod37t
             CLOSE t820_b_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_vod[l_ac].vod03,-263,1)
          ELSE
             UPDATE vod_file SET vod37 = g_vod[l_ac].vod37
              WHERE vod00=g_plant #FUN-840209
                AND vod01=g_vod01 
                AND vod02=g_vod02
                AND vod03=g_vod[l_ac].vod03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","vod_file",g_vod01,g_vod02,SQLCA.sqlcode,"","",1)  
                LET g_vod[l_ac].vod37 = l_vod37t
                CLOSE t820_b_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_vod[l_ac].vod37 = l_vod37t
             END IF
             CLOSE t820_b_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t820_b_cl
          COMMIT WORK
 
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT
 
   CLOSE t820_b_cl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION t820_b_fill(p_wc1)
DEFINE
#    p_wc1           LIKE type_file.chr1000,
    p_wc1           STRING  ,     #NO.FUN-910082
    l_sfb04         LIKE sfb_file.sfb04,
    l_sfb081        LIKE sfb_file.sfb081,     
    l_vod04         LIKE vod_file.vod04,  #FUN-860060    
    l_vod06         LIKE vod_file.vod06,  #FUN-860060
    l_vod23         LIKE vod_file.vod23,  #FUN-860060
    l_vod25         LIKE vod_file.vod25,  #FUN-860060
    l_sfb08         LIKE sfb_file.sfb08,  #FUN-860060
    l_sfb15         LIKE sfb_file.sfb15,  #FUN-860060
    l_sfb09         LIKE sfb_file.sfb09,  #FUN-860060
    l_sfb12         LIKE sfb_file.sfb12  #FUN-860060
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
 
    #FUN-880023  add voo_file
    LET g_sql = "SELECT case when vod37 is null then 'N' else vod37 end vod37,'',voh07, ",
                  "     case when voo03 is null then 'N' else 'Y' end isoutsource, vod05,vod09,'',", #FUN-840209
                  "     '',vod06,vod10,vod04,vod35,vod35-vod04, ",
                  "     vod03,vod39 ", #FUN-870099 add vod39
#TQC-9A0187-Mark-Begin
#                 "  FROM vod_file,voh_file,sfb_file,voo_file ",
#                 " WHERE vod00 ='",g_plant,"'", #FUN-840209
#                 "   AND vod01 ='",g_vod01,"'",
#                 "   AND vod02 ='",g_vod02,"'",
#                 "   AND vod00=voo00(+) and vod01=voo01(+) and vod02=voo02(+) and vod03=voo03(+) ", 
#TQC-9A0187-Mark-End
#TQC-9A0187-Add-Begin
                  "  FROM vod_file LEFT OUTER JOIN voo_file ON vod00=voo00 AND vod01=voo01 AND vod02=voo02 AND vod03=voo03",
                  "       ,voh_file,sfb_file ", 
                  " WHERE vod00 ='",g_plant,"'", #FUN-840209
                  "   AND vod01 ='",g_vod01,"'",
                  "   AND vod02 ='",g_vod02,"'",
#TQC-9A0187-Add-End
                  #"   AND ",p_wc1 CLIPPED,
                  "   AND vod01=voh01 AND vod02=voh02 AND vod03=voh03 ",
                  "   AND vod05=sfb01",
                  "   AND vod08='0' ",
                  "   AND (voh04<>'0' or voh05<>'0' or voh07<>'0') ", #FUN-860060
                  "   AND ",tm.wc CLIPPED, #FUN-870099
                  "   AND ",tm.wc2 CLIPPED, #FUN-870099
                  " ORDER BY vod01,vod02"
    PREPARE t820_pb1 FROM g_sql
    DECLARE vod_curs1 CURSOR FOR t820_pb1
 
    CALL g_vod.clear()
    LET g_cnt= 1
    FOREACH vod_curs1 INTO g_vod[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       IF g_vod[g_cnt].voh07 MATCHES '[123456]' THEN
         LET g_vod[g_cnt].sfb04 = 'A'
       ELSE
         SELECT sfb04,sfb081 INTO l_sfb04,l_sfb081
           FROM sfb_file
          WHERE sfb01 = g_vod[g_cnt].vod05
         IF l_sfb04 = '1' THEN
           LET g_vod[g_cnt].sfb04 = 'A'
         ELSE
           IF l_sfb04 = '8' THEN   #if sfb04='8' then 工單建議狀態為 C:不可調整	
             LET g_vod[g_cnt].sfb04 = 'C'
           ELSE
             IF l_sfb081 <= g_vod[g_cnt].vod35 THEN
                LET g_vod[g_cnt].sfb04 = 'B'
             ELSE
                LET g_vod[g_cnt].sfb04 = 'C'
             END IF
           END IF
         END IF
       END IF
       SELECT ima02 INTO g_vod[g_cnt].ima02  
         FROM ima_file WHERE ima01 = g_vod[g_cnt].vod09
       IF SQLCA.sqlcode THEN LET g_vod[g_cnt].ima02 = '' END IF
 
       #FUN-860060 add------begin------------ 
       SELECT  vod04,vod06,vod23,vod25 into l_vod04,l_vod06,l_vod23,l_vod25
         FROM  vod_file
        WHERE  vod05=g_vod[g_cnt].vod05 and vod09=g_vod[g_cnt].vod09
       SELECT sfb08,sfb15,sfb09,sfb12 into l_sfb08,l_sfb15,l_sfb09,l_sfb12
         FROM sfb_file
        where sfb01=g_vod[g_cnt].vod05
       IF (l_sfb08<>l_vod04) or (l_sfb15<>l_vod06) or (l_sfb09<>l_vod23) or
          (l_sfb12<>l_vod25) then
          LET  g_vod[g_cnt].chang='Y'
       ELSE
          LET  g_vod[g_cnt].chang='N'
       END IF  
       #FUN-860060 add-------end-------------
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_vod.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION t820_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_vod TO s_vod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION view_aps_wo      #APS建議工單檢視
         LET g_action_choice = "view_aps_wo"
         EXIT DISPLAY
 
      ON ACTION maint_w_o   #工單維護
         #TQC-890023
         IF cl_null(g_rec_b) or g_rec_b=0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice = "maint_w_o"
         END IF 
         EXIT DISPLAY
 
      ON ACTION change_wo   #開立工單變更單
         LET g_action_choice = "change_wo"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t820_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL t820_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t820_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t820_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t820_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
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
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
