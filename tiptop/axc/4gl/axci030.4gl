# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: axci030.4gl
# Descriptions...: 成本項目維護作業
# Date & Author..: 01/11/05 DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
#
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/18 By Sunyanchun    老報表改成p_query 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_cab_pacabo    LIKE type_file.num5,           #No.FUN-680122 SMALLINT             #頁數
    g_cab           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cab01       LIKE cab_file.cab01,   #成本中心
        cab02       LIKE cab_file.cab02    #成本中心說明
                    END RECORD,
    g_cab_t         RECORD                 #程式變數 (舊值)
        cab01       LIKE cab_file.cab01,   #成本中心
        cab02       LIKE cab_file.cab02    #成本中心說明
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_cmd          LIKE type_file.chr1000,                                          #No.FUN-680122 VARCHAR(80),
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done    LIKE type_file.num5            #No.FUN-570110       #No.FUN-680122 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10                                       #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680122 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5                                            #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i030_w AT p_row,p_col WITH FORM "axc/42f/axci030"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i030_b_fill(g_wc2)
    LET g_cab_pacabo = 0                   #現在單身頁次
    #No:A088
    CALL i030_menu()
    ##
    CLOSE WINDOW i030_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i030_menu()
   WHILE TRUE
      CALL i030_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i030_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i030_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0015
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cab),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
#No:A088
##
FUNCTION i030_q()
   CALL i030_b_askkey()
   LET g_cab_pacabo = 0
END FUNCTION
 
FUNCTION i030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                                   #No.FUN-680122 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                                    #No.FUN-680122 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = "SELECT cab01,cab02 FROM cab_file WHERE cab01= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_cab WITHOUT DEFAULTS FROM s_cab.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
               LET g_cab_t.* = g_cab[l_ac].*  #BACKUP
#No.FUN-570110--begin                                                           
                LET g_before_input_done = FALSE                                 
                CALL i030_set_entry_b(p_cmd)                                    
                CALL i030_set_no_entry_b(p_cmd)                                 
                LET g_before_input_done = TRUE                                  
#No.FUN-570110--end     
               BEGIN WORK
 
               OPEN i030_bcl USING g_cab_t.cab01
               IF STATUS THEN
                  CALL cl_err("OPEN i030_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i030_bcl INTO g_cab[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_cab_t.cab01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL i030_set_entry_b(p_cmd)                                        
            CALL i030_set_no_entry_b(p_cmd)                                     
            LET g_before_input_done = TRUE                                      
#No.FUN-570110--end  
            INITIALIZE g_cab[l_ac].* TO NULL      #900423
            LET g_cab_t.* = g_cab[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cab01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
#           CALL g_cab.deleteElement(l_ac)   # 重要
#           IF g_rec_b != 0 THEN
#             LET g_action_choice = "detail"
#           END IF
#           EXIT INPUT
         END IF
         INSERT INTO cab_file(cab01,cab02)
                VALUES(g_cab[l_ac].cab01,g_cab[l_ac].cab02)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_cab[l_ac].cab01,SQLCA.sqlcode,0)   #No.FUN-660127
             CALL cl_err3("ins","cab_file",g_cab[l_ac].cab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2 
         END IF
 
        AFTER FIELD cab01                        #check 編號是否重複
            IF g_cab[l_ac].cab01 IS NOT NULL THEN
               IF g_cab[l_ac].cab01 != g_cab_t.cab01 OR
                 (g_cab[l_ac].cab01 IS NOT NULL AND g_cab_t.cab01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM cab_file
                   WHERE cab01 = g_cab[l_ac].cab01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_cab[l_ac].cab01 = g_cab_t.cab01
                     NEXT FIELD cab01
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_cab_t.cab01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM cab_file WHERE cab01 = g_cab_t.cab01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cab_t.cab01,SQLCA.sqlcode,0)   #No.FUN-660127
                   CALL cl_err3("del","cab_file",g_cab_t.cab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                MESSAGE "Delete OK" 
                CLOSE i030_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_cab[l_ac].* = g_cab_t.*
              CLOSE i030_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_cab[l_ac].cab01,-263,1)
              LET g_cab[l_ac].* = g_cab_t.*
           ELSE
              UPDATE cab_file SET cab01= g_cab[l_ac].cab01,
                                  cab02= g_cab[l_ac].cab02
               WHERE CURRENT OF i030_bcl
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_cab[l_ac].cab01,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","cab_file",g_cab[l_ac].cab01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
                  LET g_cab[l_ac].* = g_cab_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i030_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                  LET g_cab[l_ac].* = g_cab_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_cab.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---                                    
               END IF
               CLOSE i030_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i030_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cab01) AND l_ac > 1 THEN
                LET g_cab[l_ac].* = g_cab[l_ac-1].*
                NEXT FIELD cab01
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
 
    CLOSE i030_bcl
    COMMIT WORK
	END FUNCTION
 
FUNCTION i030_b_askkey()
    CLEAR FORM
    CALL g_cab.clear()
    CONSTRUCT g_wc2 ON cab01,cab02
            FROM s_cab[1].cab01,s_cab[1].cab02
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    LET g_cab_pacabo = 1
    CALL i030_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i030_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
        "SELECT cab01,cab02",
        " FROM cab_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i030_pb FROM g_sql
    DECLARE cab_curs CURSOR FOR i030_pb
 
    CALL g_cab.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH cab_curs INTO g_cab[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    MESSAGE ""
    CALL g_cab.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cab TO s_cab.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-7C0043--BEGIN
FUNCTION i030_out()
#   DEFINE
#       l_cab           RECORD LIKE cab_file.*,
#       l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#       l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),            # External(Disk) file name
#       sr    RECORD 
#                cab01 LIKE cab_file.cab01,
#                cab02 LIKE cab_file.cab02
#               END RECORD,
#       l_za05          LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(40)            
    DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc2) THEN                                                                                                          
       CALL cl_err("","9057",0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axci030" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN 
#       LET g_wc2=" cab01='",g_cab[l_ac].cab01,"'"   
#    END IF
#  IF cl_null(g_wc2) THEN
#     CALL cl_err("","9057",0)
#     RETURN
#  END IF
#No.TQC-710076 -- end --
#   CALL cl_wait()
#   CALL cl_outnam('axci030') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT cab01,cab02 FROM cab_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i030_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i030_co                         # SCROLL CURSOR
#       SCROLL CURSOR FOR i030_p1
 
#   START REPORT i030_rep TO l_name
 
#   FOREACH i030_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i030_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i030_rep
 
#   CLOSE i030_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i030_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
#       sr    RECORD
#              cab01 LIKE cab_file.cab01,
#              cab02 LIKE cab_file.cab02
#              END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.cab01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32]
#           PRINT g_dash1
 
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#          PRINT COLUMN g_c[31],sr.cab01 CLIPPED,
#                COLUMN g_c[32],sr.cab02 CLIPPED
 
#       ON LAST ROW
#           PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[32], g_x[7] CLIPPED  #No.TQC-6A0102
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6A0102
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[32], g_x[6] CLIPPED   #No.TQC-6A0102
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6A0102
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043---END
#No.FUN-570110--begin                                                           
FUNCTION i030_set_entry_b(p_cmd)                                                
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("cab01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i030_set_no_entry_b(p_cmd)                                             
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("cab01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570110--end         
