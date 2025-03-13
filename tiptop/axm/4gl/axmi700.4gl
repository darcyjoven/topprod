# Prog. Version..: '5.30.06-13.04.22(00009)'     #
# 
# Pattern name...: axmi700.4gl
# Descriptions...: 潛在客戶來源資料維護作業
# Date & Author..: 02/11/07 By Windy
#
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.TQC-650082 06/06/14 By alexstar (下一頁)(結尾)靠右
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/31 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740317 07/04/26 By bnlent 打印時加一個有效標志位
# Modify.........: No.TQC-750041 07/05/16 By arman     打印時,無效資料無特殊標記 
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
 #  g_ofquser       LIKE apm_file.apm08,    #No.FUN-680137   VARCHAR(10) #No.TQC-6A0079                                       
    g_ofqgrup       LIKE aab_file.aab02,    #No.FUN-680137   VARCHAR(6)                                         
 #  g_ofqmodu       LIKE apm_file.apm08,    #No.FUN-680137   VARCHAR(10) #No.TQC-6A0079                                        
    g_ofqdate       LIKE type_file.dat,     #No.FUN-680137   DATE
    g_ofq           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        ofq01       LIKE ofq_file.ofq01,  
        ofq02       LIKE ofq_file.ofq02,
        ofqacti     LIKE type_file.chr1     #No.FUN-680137   VARCHAR(1)
                    END RECORD,
    g_ofq_t          RECORD                 #程式變數 (舊值)
        ofq01       LIKE ofq_file.ofq01,  
        ofq02       LIKE ofq_file.ofq02,
        ofqacti     LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,    #單身筆數            #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING      #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109       #No.FUN-680137 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 3 LET p_col = 15 
    OPEN WINDOW i700_w AT p_row,p_col 
         WITH FORM "axm/42f/axmi700" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1'
    CALL i700_b_fill(g_wc2)
    CALL i700_menu()
    CLOSE WINDOW i700_w                      #結束畫面
      CALL  cl_used(g_prog,g_time,2)         #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i700_menu()
   WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i700_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN 
               CALL i700_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ofq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i700_q()
   CALL i700_b_askkey()
END FUNCTION
 
FUNCTION i700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ofq01,ofq02,ofqacti FROM ofq_file WHERE ofq01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ofq   WITHOUT DEFAULTS FROM s_ofq.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ofq_t.* = g_ofq[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i700_set_entry_b(p_cmd)                                                                                         
               CALL i700_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--    
               BEGIN WORK
 
               OPEN i700_bcl USING g_ofq_t.ofq01
               IF STATUS THEN
                  CALL cl_err("OPEN i700_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i700_bcl INTO g_ofq[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ofq_t.ofq01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ofq_file(ofq01,ofq02,ofqacti,ofquser,
                                 ofqgrup,ofqdate,ofqoriu,ofqorig)
                      VALUES(g_ofq[l_ac].ofq01,g_ofq[l_ac].ofq02,
                             g_ofq[l_ac].ofqacti,g_user,g_grup,
                             g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ofq[l_ac].ofq01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","ofq_file",g_ofq[l_ac].ofq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cnt2 
            END IF
            #--Move original INSERT block from AFTER ROW to here
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i700_set_entry_b(p_cmd)                                                                                         
            CALL i700_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--    
            INITIALIZE g_ofq[l_ac].* TO NULL      #900423
            LET g_ofq_t.* = g_ofq[l_ac].*         #新輸入資料
            LET g_ofq[l_ac].ofqacti = 'Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ofq01
 
        AFTER FIELD ofq01                        #check 編號是否重複
            IF g_ofq[l_ac].ofq01 IS NOT NULL THEN 
            IF g_ofq[l_ac].ofq01 != g_ofq_t.ofq01 OR
               (g_ofq[l_ac].ofq01 IS NOT NULL AND g_ofq_t.ofq01 IS NULL) THEN
                SELECT COUNT(*) INTO l_n FROM ofq_file
                 WHERE ofq01 = g_ofq[l_ac].ofq01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ofq[l_ac].ofq01 = g_ofq_t.ofq01
                  NEXT FIELD ofq01
               END IF
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ofq_t.ofq01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               
                DELETE FROM ofq_file WHERE ofq01 = g_ofq_t.ofq01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ofq_t.ofq01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","ofq_file",g_ofq_t.ofq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cnt2  
                MESSAGE "Delete OK"
                CLOSE i700_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ofq[l_ac].* = g_ofq_t.*
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ofq[l_ac].ofq01,-263,1)
               LET g_ofq[l_ac].* = g_ofq_t.*
            ELSE
               UPDATE ofq_file SET ofq01=g_ofq[l_ac].ofq01,
                                   ofq02=g_ofq[l_ac].ofq02,              
                                   ofqacti=g_ofq[l_ac].ofqacti,
                                   ofqmodu=g_user,              
                                   ofqdate=g_today              
                WHERE ofq01 = g_ofq_t.ofq01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ofq[l_ac].ofq01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","ofq_file",g_ofq_t.ofq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_ofq[l_ac].* = g_ofq_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i700_bcl
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ofq[l_ac].* = g_ofq_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_ofq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i700_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i700_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ofq01) AND l_ac > 1 THEN
                LET g_ofq[l_ac].* = g_ofq[l_ac-1].*
                NEXT FIELD ofq01
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
 
    CLOSE i700_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i700_b_askkey()
    CLEAR FORM
    CALL g_ofq.clear()
    CONSTRUCT g_wc2 ON ofq01,ofq02,ofqacti
                  FROM s_ofq[1].ofq01,s_ofq[1].ofq02,s_ofq[1].ofqacti 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ofquser', 'ofqgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i700_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i700_b_fill(g_wc2)              #BODY FILL UP
DEFINE
     g_wc2     STRING   #No.FUN-580092 HCN  
 
    LET g_sql =
        "SELECT ofq01,ofq02,ofqacti",
        "  FROM ofq_file",
        " WHERE ", g_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i700_pb FROM g_sql
    DECLARE ofq_curs CURSOR FOR i700_pb
 
    CALL g_ofq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ofq_curs INTO g_ofq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_ofq.deleteElement(g_cnt)
 
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ofq TO s_ofq.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
ON ACTION exporttoexcel       #FUN-4B0038
   LET g_action_choice = 'exporttoexcel'
   EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start--
FUNCTION i700_out()
    DEFINE
        sr              RECORD LIKE ofq_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
                                                                                                                                    
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN END IF                                                                                       
    LET l_cmd = 'p_query "axmi700" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN           
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM ofq_file ",    # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i700_p1 FROM g_sql              # RUNTIME 編譯
#   DECLARE i700_co                         # CURSOR
#       CURSOR FOR i700_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi700') RETURNING l_name
#   START REPORT i700_rep TO l_name
 
#   FOREACH i700_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i700_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i700_rep
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT i700_rep(sr)
#   DEFINE
#       l_trailer_sw   LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1) 
#       sr RECORD LIKE ofq_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
#   ORDER BY sr.ofq01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''    #No.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33]                             #No.TQC-740317
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.ofq01,
#                 COLUMN g_c[32],sr.ofq02; 
#           #No.TQC-740317  --Begin
#           IF sr.ofqacti = 'Y' THEN
#           PRINT COLUMN g_c[33],g_x[9]               
#           ELSE  
#            PRINT COLUMN g_c[33],''                #NO.TQC-750041
#            PRINT COLUMN g_c[33],g_x[34]           #NO.TQC-750041
#           END IF
#           #No.TQC-740317  --End
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #TQC-650082
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-650082
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--  
#No.FUN-570109 --start--                                                                                                            
FUNCTION i700_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ofq01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i700_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ofq01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--     
