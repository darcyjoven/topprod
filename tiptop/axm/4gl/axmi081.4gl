# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: axmi081.4gl
# Descriptions...: 客訴原因維護作業
# Date & Author..: 92/12/26 By Apple 
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.TQC-5B0212 05/12/27 By kevin 結束位置調整
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740135 07/04/19 By arman  增加‘有效否‘一列
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ock           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ock01       LIKE ock_file.ock01,   
        ock02       LIKE ock_file.ock02,  
        ockacti     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
                    END RECORD,
    g_ock_t         RECORD                 #程式變數 (舊值)
        ock01       LIKE ock_file.ock01,   
        ock02       LIKE ock_file.ock02,  
        ockacti     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
                    END RECORD,
    #g_wc2,g_sql    LIKE type_file.chr1000,  #TQC-630166        #No.FUN-680137
    g_wc2,g_sql     LIKE type_file.chr1000,  #TQC-630166        #No.FUN-680137
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql LIKE type_file.chr1000  #SELECT ... FOR UPDATE SQL         #No.FUN-680137
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109          #No.FUN-680137 SMALLINT
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
    LET p_row = 4 LET p_col = 2 
    OPEN WINDOW i081_w AT p_row,p_col WITH FORM "axm/42f/axmi081"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i081_b_fill(g_wc2)
    CALL i081_menu()
    CLOSE WINDOW i081_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i081_menu()
   WHILE TRUE
      CALL i081_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i081_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i081_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i081_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ock),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i081_q()
   CALL i081_b_askkey()
END FUNCTION
 
FUNCTION i081_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ock01,ock02,ockacti FROM ock_file WHERE ock01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i081_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ock WITHOUT DEFAULTS FROM s_ock.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ock_t.* = g_ock[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i081_set_entry_b(p_cmd)                                                                                         
               CALL i081_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--   
 
               BEGIN WORK
 
               OPEN i081_bcl USING g_ock_t.ock01
               IF STATUS THEN
                  CALL cl_err("OPEN i081_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i081_bcl INTO g_ock[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ock_t.ock01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD ock01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ock_file(ock01,ock02,ockacti,ockuser,ockdate,ockoriu,ockorig)
                          VALUES(g_ock[l_ac].ock01,g_ock[l_ac].ock02,
                                 g_ock[l_ac].ockacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ock[l_ac].ock01,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","ock_file",g_ock[l_ac].ock01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
            LET g_before_input_done = FALSE                                                                                      
            CALL i081_set_entry_b(p_cmd)                                                                                         
            CALL i081_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--   
            INITIALIZE g_ock[l_ac].* TO NULL      #900423
            LET g_ock_t.* = g_ock[l_ac].*         #新輸入資料
            LET g_ock[l_ac].ockacti='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ock01
 
        AFTER FIELD ock01                        #check 編號是否重複
            IF NOT cl_null(g_ock[l_ac].ock01) THEN
               IF g_ock[l_ac].ock01 != g_ock_t.ock01 OR
                  (g_ock[l_ac].ock01 IS NOT NULL AND g_ock_t.ock01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM ock_file
                       WHERE ock01 = g_ock[l_ac].ock01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ock[l_ac].ock01 = g_ock_t.ock01
                       NEXT FIELD ock01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ock_t.ock01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM ock_file WHERE ock01 = g_ock_t.ock01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ock_t.ock01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","ock_file",g_ock_t.ock01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                MESSAGE "Delete OK"
                CLOSE i081_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ock[l_ac].* = g_ock_t.*
               CLOSE i081_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ock[l_ac].ock01,-263,1)
               LET g_ock[l_ac].* = g_ock_t.*
            ELSE
               UPDATE ock_file SET
                      ock01  = g_ock[l_ac].ock01,
                      ock02  = g_ock[l_ac].ock02,
                      ockacti= g_ock[l_ac].ockacti,
                      ockmodu= g_user,
                      ockdate= g_today
                WHERE ock01 = g_ock_t.ock01 
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ock[l_ac].ock01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","ock_file",g_ock_t.ock01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_ock[l_ac].* = g_ock_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i081_bcl
                   COMMIT WORK
               END IF
            #--Move original UPDATE block from AFTER ROW to here
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ock[l_ac].* = g_ock_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_ock.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i081_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i081_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i081_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ock01) AND l_ac > 1 THEN
                LET g_ock[l_ac].* = g_ock[l_ac-1].*
                NEXT FIELD ock01
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
 
    CLOSE i081_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i081_b_askkey()
    CLEAR FORM
    CALL g_ock.clear()
    CONSTRUCT g_wc2 ON ock01,ock02,ockacti
            FROM s_ock[1].ock01,s_ock[1].ock02,s_ock[1].ockacti 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ockuser', 'ockgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i081_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i081_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#    p_wc2           VARCHAR(200)   #TQC-630166
    p_wc2            STRING   #TQC-630166
 
    LET g_sql =
        "SELECT ock01,ock02,ockacti",
        " FROM ock_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i081_pb FROM g_sql
    DECLARE ock_curs CURSOR FOR i081_pb
 
    CALL g_ock.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ock_curs INTO g_ock[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_ock.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i081_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ock TO s_ock.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 FUNCTION i081_out()
     DEFINE
         l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
         l_ock   RECORD LIKE ock_file.*,
         l_za05          LIKE type_file.chr1000,               #        #No.FUN-680137 VARCHAR(40)
         l_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
     DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                
                                                                                                                                    
     IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF                                                                   
     LET l_cmd = 'p_query "axmi081" "',g_wc2 CLIPPED,'"'                                                                            
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN 
#    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#
#    LET g_sql="SELECT * FROM ock_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i081_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i081_co CURSOR FOR i081_p1
#
#    LET g_rlang = g_lang                               #FUN-4C0096 add
#    CALL cl_outnam('axmi081') RETURNING l_name
#   START REPORT i081_rep TO l_name
#
#    FOREACH i081_co INTO l_ock.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#        OUTPUT TO REPORT i081_rep(l_ock.*)
#    END FOREACH
#
#    FINISH REPORT i081_rep
#
#    CLOSE i081_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i081_rep(sr)
#    DEFINE
#        l_trailer_sw   LIKE type_file.chr1,         #No.FUN-680137  VARCHAR(1)
#        sr RECORD LIKE ock_file.*,
#        l_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.ock01
#
##FUN-4C0096 modify
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED, pageno_total
#            PRINT ''
#            PRINT g_dash[1,g_len]
#            PRINT g_x[33],               #NO.TQC-740135
#                  g_x[31],
#                  g_x[32] 
#            PRINT g_dash1                                
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            IF sr.ockacti = 'N' THEN 
#                 PRINT '*';
#            ELSE                        #NO.TQC-740135
#                 PRINT ' ';             #NO.TQC-740135
#            END IF
#            PRINT COLUMN g_c[31],sr.ock01,
#                  COLUMN g_c[32],sr.ock02 
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc2,'ock01,ock02,ockacti')
#                    RETURNING g_sql
#               #TQC-630166
#               #IF g_sql[001,080] > ' ' THEN
#	       #	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               #IF g_sql[071,140] > ' ' THEN
#	       #	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               #IF g_sql[141,210] > ' ' THEN
#	       #	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#               PRINT g_dash[1,g_len]
#               CALL cl_prt_pos_wc(g_sql)
#               #END TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4] CLIPPED, COLUMN (g_len-7),g_x[7] CLIPPED #No.TQC-5B0212
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-5B0212
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-7C0043--end--
#No.FUN-570109 --start--                                                                                                            
FUNCTION i081_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                    #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ock01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i081_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                   #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ock01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--    
