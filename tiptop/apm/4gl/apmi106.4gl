# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: apmi106.4gl
# Descriptions...: 廠商分類代碼維護作業
# Date & Author..: 2002/07/24 By Mandy
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改
# Modify.........: No.FUN-570200 05/07/28 By Rosayu  程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表結束定位點修改
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.TQC-6A0090 06/11/07 By baogui 表頭多行空白
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_pmy           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmy01       LIKE pmy_file.pmy01,   
        pmy02       LIKE pmy_file.pmy02,  
        pmyacti     LIKE pmy_file.pmyacti      #No.FUN-680136 VARCHAR(1)
                    END RECORD,
    g_pmy_t         RECORD                     #程式變數 (舊值)
        pmy01       LIKE pmy_file.pmy01,   
        pmy02       LIKE pmy_file.pmy02,  
        pmyacti     LIKE pmy_file.pmyacti      #No.FUN-680136 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,       #單身筆數               #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
    p_row,p_col     LIKE type_file.num5        #No.FUN-680136 SMALLINT 
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680136 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose    #No.FUN-680136 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570109             #No.FUN-680136 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 4 LET p_col = 9
    OPEN WINDOW i106_w AT p_row,p_col WITH FORM "apm/42f/apmi106"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i106_b_fill(g_wc2)
    CALL i106_menu()
    CLOSE WINDOW i106_w                 #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i106_menu()
 
   WHILE TRUE
      CALL i106_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i106_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i106_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i106_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470518
            IF cl_chk_act_auth() AND l_ac != 0 THEN   # FUN-570200
               IF g_pmy[l_ac].pmy01 IS NOT NULL THEN
                  LET g_doc.column1 = "pmy01"
                  LET g_doc.value1 = g_pmy[l_ac].pmy01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmy),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i106_q()
   CALL i106_b_askkey()
END FUNCTION
 
FUNCTION i106_b()
DEFINE
    l_ac_t          LIKE type_file.num5,             #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,             #檢查重複用         #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,             #單身鎖住否         #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,             #處理狀態           #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,             #可新增否           #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5              #可刪除否           #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pmy01,pmy02,pmyacti FROM pmy_file WHERE pmy01= ?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i106_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_pmy WITHOUT DEFAULTS FROM s_pmy.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_pmy_t.* = g_pmy[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET  g_before_input_done = FALSE                                                                                     
               CALL i106_set_entry(p_cmd)                                                                                           
               CALL i106_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end--   
               BEGIN WORK
               OPEN i106_bcl USING g_pmy_t.pmy01
               IF STATUS THEN
                  CALL cl_err("OPEN i106_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i106_bcl INTO g_pmy[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pmy_t.pmy01,SQLCA.sqlcode,1)
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
            INSERT INTO pmy_file(pmy01,pmy02,pmyacti,
                                 pmyuser,pmydate,pmyoriu,pmyorig)
            VALUES(g_pmy[l_ac].pmy01,g_pmy[l_ac].pmy02,
                   g_pmy[l_ac].pmyacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_pmy[l_ac].pmy01,SQLCA.sqlcode,0)   #No.FUN-660129
                CALL cl_err3("ins","pmy_file",g_pmy[l_ac].pmy01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET  g_before_input_done = FALSE                                                                                        
            CALL i106_set_entry(p_cmd)                                                                                              
            CALL i106_set_no_entry(p_cmd)                                                                                           
            LET  g_before_input_done = TRUE                                                                                         
#No.FUN-570109 --end--  
            INITIALIZE g_pmy[l_ac].* TO NULL      #900423
            LET g_pmy_t.* = g_pmy[l_ac].*         #新輸入資料
            LET g_pmy[l_ac].pmyacti='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pmy01
 
        AFTER FIELD pmy01                        #check 編號是否重複
            IF g_pmy[l_ac].pmy01 IS NOT NULL THEN
            IF g_pmy[l_ac].pmy01 != g_pmy_t.pmy01 OR
               (g_pmy[l_ac].pmy01 IS NOT NULL AND g_pmy_t.pmy01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM pmy_file
                    WHERE pmy01 = g_pmy[l_ac].pmy01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pmy[l_ac].pmy01 = g_pmy_t.pmy01
                    NEXT FIELD pmy01
                END IF
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmy_t.pmy01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "pmy01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_pmy[l_ac].pmy01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM pmy_file WHERE pmy01 = g_pmy_t.pmy01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pmy_t.pmy01,SQLCA.sqlcode,0)
                   CALL cl_err3("del","pmy_file",g_pmy[l_ac].pmy01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i106_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmy[l_ac].* = g_pmy_t.*
               CLOSE i106_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pmy[l_ac].pmy01,-263,1)
               LET g_pmy[l_ac].* = g_pmy_t.*
            ELSE
                UPDATE pmy_file SET
                       pmy01  = g_pmy[l_ac].pmy01,
                       pmy02  = g_pmy[l_ac].pmy02,
                       pmyacti= g_pmy[l_ac].pmyacti,
                       pmymodu= g_user,
                       pmydate= g_today
                WHERE pmy01= g_pmy_t.pmy01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pmy[l_ac].pmy01,SQLCA.sqlcode,0)   #No.FUN-660129
                   CALL cl_err3("upd","pmy_file",g_pmy_t.pmy01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   LET g_pmy[l_ac].* = g_pmy_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i106_bcl
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac          #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_pmy[l_ac].* = g_pmy_t.*
               #FUN-D30034---add---str---
               ELSE
                  CALL g_pmy.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034---add---end---
               END IF 
               CLOSE i106_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac          #FUN-D30034 add
            CLOSE i106_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i106_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmy01) AND l_ac > 1 THEN
                LET g_pmy[l_ac].* = g_pmy[l_ac-1].*
                NEXT FIELD pmy01
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
 
    CLOSE i106_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i106_b_askkey()
    CLEAR FORM
    CALL g_pmy.clear()
    CONSTRUCT g_wc2 ON pmy01,pmy02,pmyacti
            FROM s_pmy[1].pmy01,s_pmy[1].pmy02,s_pmy[1].pmyacti 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pmyuser', 'pmygrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i106_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i106_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql =
        "SELECT pmy01,pmy02,pmyacti",
        " FROM pmy_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i106_pb FROM g_sql
    DECLARE pmy_curs CURSOR FOR i106_pb
 
    CALL g_pmy.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pmy_curs INTO g_pmy[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmy.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    DISPLAY g_cnt   TO FORMONLY.cn3  
END FUNCTION
 
FUNCTION i106_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmy TO s_pmy.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
    ON ACTION related_document  #No.MOD-470518
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i106_out()
   DEFINE
       l_i             LIKE type_file.num5,        #No.FUN-680136 SMALLINT
       l_name          LIKE type_file.chr20,       # External(Disk) file name   #No.FUN-680136 VARCHAR(20)
       l_pmy           RECORD LIKE pmy_file.*,
       l_za05          LIKE za_file.za05,          #No.FUN-680136 VARCHAR(40)
       l_chr           LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
   DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002 
 
   #FUN-4C0095
#No.TQC-710076 -- begin --
#    IF cl_null(g_wc2) THEN
#        LET g_wc2=" pmy01='",g_pmy[l_ac].pmy01,"'" 
#    END IF
  IF cl_null(g_wc2) THEN
     CALL cl_err('','9057',0)
     LET g_wc2=" pmy01='",g_pmy[l_ac].pmy01,"'"
     RETURN
  END IF
##No.TQC-710076 -- end --
 
#No.FUN-820002--start--                                                                                                             
    #報表轉為使用 p_query                                                                                                           
    LET l_cmd = 'p_query "apmi106" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN                                                                                                                          
 
#   CALL cl_wait()
#   CALL cl_outnam('apmi106') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM pmy_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i106_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i106_co CURSOR FOR i106_p1
 
#   START REPORT i106_rep TO l_name
 
#   FOREACH i106_co INTO l_pmy.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#          END IF
#       OUTPUT TO REPORT i106_rep(l_pmy.*)
#   END FOREACH
 
#   FINISH REPORT i106_rep
 
#   CLOSE i106_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i106_rep(sr)
#   DEFINE
#       l_print         LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
#       l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
#       sr              RECORD LIKE pmy_file.*,
#       l_chr           LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pmy01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
# #         PRINT                      #TQC-6A0090
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           IF sr.pmyacti = 'N' THEN 
#              LET l_print = '*' 
#           ELSE
#              LET l_print = NULL
#           END IF
#           PRINT COLUMN g_c[31],l_print,
#                 COLUMN g_c[32],sr.pmy01,
#                 COLUMN g_c[33],sr.pmy02 
 
#       ON LAST ROW
#           IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#              CALL cl_wcchp(g_wc2,'pmy01,pmy02,pmyacti')
#                   RETURNING g_sql
#              PRINT g_dash
 
#           #TQC-630166
#           {
#              IF g_sql[001,080] > ' ' THEN
#       	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#              IF g_sql[071,140] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#              IF g_sql[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#           }
#             CALL cl_prt_pos_wc(g_sql)
#           #END TQC-630166
#           END IF
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#           #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED #TQB-5B0037 mark
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-8, g_x[7] CLIPPED  #TQC-5B0037 add
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED #TQC-5B0037 mark
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #TQC-5B0037 add
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
#No.FUN-570109 --start--                                                                                                            
FUNCTION i106_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                              #No.FUN-680136 VARCHAR(1)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("pmy01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i106_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1                              #No.FUN-680136 VARCHAR(1)
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("pmy01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--        
