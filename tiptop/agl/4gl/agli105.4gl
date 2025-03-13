# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: agli105.4gl
# Descriptions...: 常用摘要建立作業
# Date & Author..: 91/06/21 By Lee
 # Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/25 By Nicola 報表架構修改
# Modify.........: NO.FUN-570108 05/07/13 By Trisy key值可更改
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
#
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740332 07/04/28 By bnlent  更改無效資料打印顯示方式
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30032 13/04/01 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_aad           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aad01       LIKE aad_file.aad01,   #摘要編號
        aad02       LIKE aad_file.aad02,   #摘要
        aadacti     LIKE aad_file.aadacti  #No.FUN-680098   VARCHAR(1)
                    END RECORD,
    g_aad_t         RECORD                 #程式變數 (舊值)
        aad01       LIKE aad_file.aad01,   #摘要編號
        aad02       LIKE aad_file.aad02,   #摘要
        aadacti     LIKE aad_file.aadacti  #No.FUN-680098   VARCHAR(1)
                    END RECORD,
    g_wc,g_sql    STRING,  #No.FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680098 SMALLINT
    l_ac            LIKE type_file.num5          #No.FUN-680098   SMALLINT
 
DEFINE g_forupd_sql STRING       
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570108        #No.FUN-680098  SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5                  #No.FUN-680098  SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW i105_w AT p_row,p_col
     WITH FORM "agl/42f/agli105"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_wc = '1=1'
 
   CALL i105_b_fill(g_wc)
 
   CALL i105_menu()
 
   CLOSE WINDOW i105_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i105_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i105_bp("G")
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i105_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i105_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()                                                   
               THEN CALL i105_out()                                            
            END IF                                                                 
 
         WHEN "help"     CALL cl_show_help()
         WHEN "exit"     EXIT WHILE
         WHEN "controlg" CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN  # FUN-570200
               IF g_aad[l_ac].aad01 IS NOT NULL THEN
                  LET g_doc.column1 = "aad01"
                  LET g_doc.value1 = g_aad[l_ac].aad01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aad),'','')
            END IF
 
      END CASE
 
   END WHILE
 
END FUNCTION
 
FUNCTION i105_q()
 
   CALL i105_b_askkey()
 
END FUNCTION
 
FUNCTION i105_b()
DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
       l_n             LIKE type_file.num5,      #檢查重複用       #No.FUN-680098   SMALLINT
       l_lock_sw       LIKE type_file.chr1,      #單身鎖住否       #No.FUN-680098   VARCHAR(1)
       p_cmd           LIKE type_file.chr1,      #處理狀態         #No.FUN-680098   VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,      #可新增否         #No.FUN-680098   VARCHAR(1)
       l_allow_delete  LIKE type_file.chr1       #可刪除否         #No.FUN-680098   VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT aad01,aad02,aadacti FROM aad_file ",
                      "WHERE aad01= ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i105_bcl CURSOR FROM g_forupd_sql
 
   LET l_ac_t = 0
   INPUT ARRAY g_aad WITHOUT DEFAULTS FROM s_aad.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
#No.FUN-570108 --start--
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL i105_set_entry(p_cmd)
            CALL i105_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
            BEGIN WORK
            LET p_cmd='u'
            LET g_aad_t.* = g_aad[l_ac].*  #BACKUP
            OPEN i105_bcl USING g_aad_t.aad01
            IF STATUS THEN
               CALL cl_err("OPEN i105_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i105_bcl INTO g_aad[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aad_t.aad01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570108 --start--
         LET  g_before_input_done = FALSE
         CALL i105_set_entry(p_cmd)
         CALL i105_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
#No.FUN-570108 --end--
         INITIALIZE g_aad[l_ac].* TO NULL
         LET g_aad[l_ac].aadacti = 'Y'         #Body default
         LET g_aad_t.* = g_aad[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD aad01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i105_bcl
         END IF
         INSERT INTO aad_file(aad01,aad02,aadacti,aaduser,aaddate,aadoriu,aadorig)
                       VALUES(g_aad[l_ac].aad01,g_aad[l_ac].aad02,
                              g_aad[l_ac].aadacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aad[l_ac].aad01,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","aad_file",g_aad[l_ac].aad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD aad01                        #check 編號是否重複
         IF NOT cl_null(g_aad[l_ac].aad01) THEN
            IF g_aad[l_ac].aad01 != g_aad_t.aad01 OR g_aad_t.aad01 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM aad_file
                WHERE aad01 = g_aad[l_ac].aad01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_aad[l_ac].aad01 = g_aad_t.aad01
                  NEXT FIELD aad01
               END IF
            END IF
         END IF
 
      AFTER FIELD aadacti
         IF NOT cl_null(g_aad[l_ac].aadacti) THEN
            IF g_aad[l_ac].aadacti NOT MATCHES '[YN]' THEN
               LET g_aad[l_ac].aadacti = g_aad_t.aadacti
               NEXT FIELD aadacti
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_aad_t.aad01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "aad01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_aad[l_ac].aad01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM aad_file WHERE aad01 = g_aad_t.aad01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aad_t.aad01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","aad_file",g_aad_t.aad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_aad[l_ac].* = g_aad_t.*
            CLOSE i105_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_aad[l_ac].aad01,SQLCA.sqlcode,0)
            LET g_aad[l_ac].* = g_aad_t.*
         ELSE
            UPDATE aad_file SET aad01 = g_aad[l_ac].aad01,
                                aad02 = g_aad[l_ac].aad02,
                                aadacti = g_aad[l_ac].aadacti,
                                aadmodu = g_user,
                                aaddate = g_today
             WHERE aad01 = g_aad_t.aad01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aad[l_ac].aad01,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","aad_file",g_aad_t.aad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_aad[l_ac].* = g_aad_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()         # 新增
        #LET l_ac_t = l_ac     #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_aad[l_ac].* = g_aad_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_aad.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i105_bcl            # 新增
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 add
         CLOSE i105_bcl  #FUN-D30032 add
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(aad01) AND l_ac > 1 THEN
            LET g_aad[l_ac].* = g_aad[l_ac-1].*
            NEXT FIELD aad01
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
 
   CLOSE i105_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i105_b_askkey()
 
   CLEAR FORM
   CALL g_aad.clear()
   CONSTRUCT g_wc ON aad01,aad02,aadacti FROM s_aad[1].aad01,s_aad[1].aad02,s_aad[1].aadacti
 
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
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND aaduser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND aadgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND aadgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aaduser', 'aadgrup')
   #End:FUN-980030
 
 
   CALL i105_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i105_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(200)
 
   LET g_sql = "SELECT aad01,aad02,aadacti",
               " FROM aad_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i105_pb FROM g_sql
   DECLARE aad_curs CURSOR FOR i105_pb
 
   CALL g_aad.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!"
   FOREACH aad_curs INTO g_aad[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_aad.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i105_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aad TO s_aad.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
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
 
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION i105_out()
   DEFINE l_aad           RECORD LIKE aad_file.*,
          l_i             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
          l_name          LIKE type_file.chr20          #No.FUN-680098  VARCHAR(20)
 DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-820002                                                                   
                                                                                                                                    
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
   LET l_cmd = 'p_query "agli105" "',g_wc CLIPPED,'"'                                                                                
   CALL cl_cmdrun(l_cmd)                                                                                                             
   RETURN
#  CALL cl_wait()
#  CALL cl_outnam('agli105') RETURNING l_name
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#  LET g_sql="SELECT * FROM aad_file ",          # 組合出 SQL 指令
#            " WHERE ",g_wc CLIPPED
#  PREPARE i105_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i105_co CURSOR FOR i105_p1
 
#  START REPORT i105_rep TO l_name
 
#  FOREACH i105_co INTO l_aad.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
 
#     OUTPUT TO REPORT i105_rep(l_aad.*)
 
#  END FOREACH
 
#  FINISH REPORT i105_rep
 
#  CLOSE i105_co
#  CALL cl_prt(l_name,' ','1',g_len)
#  MESSAGE ""
 
END FUNCTION
 
#REPORT i105_rep(sr)
#   DEFINE l_trailer_sw     LIKE type_file.chr1,        #No.FUN-680098    VARCHAR(1)
#          sr RECORD        LIKE aad_file.*
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.aad01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33]   #No.TQC-740332
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     ON EVERY ROW
#        #No.TQC-740332  --begin
#        IF sr.aadacti = 'N' THEN
#           #LET sr.aad01 = '*',sr.aad01  
#           PRINT COLUMN g_c[31],'*';
#        END IF
#        PRINT COLUMN g_c[32],sr.aad01,  
#              COLUMN g_c[33],sr.aad02
#        #No.TQC-740332  --End
 
#     ON LAST ROW
#        PRINT g_dash[1,g_len]
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
 
#No.FUN-570108 --start--
 
FUNCTION i105_set_entry(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aad01",TRUE)
   END IF
END FUNCTION
 
 
FUNCTION i105_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("aad01",FALSE)
   END IF
END FUNCTION
 
#No.FUN-570108 --end--
