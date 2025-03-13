# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: amri504.4gl
# Descriptions...: 指定廠牌維護作業
# Date & Author..: 96/06/13 By Roger
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型修改 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/16 By cheunl 報表格式修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modfiy.........: No.FUN-7C0043 07/12/27 By Cockroach 報表改為p_query實現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By xumm 修改FUN-D40030遗留问题
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_mse           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        mse01       LIKE mse_file.mse01,  
        mse02       LIKE mse_file.mse02  
                    END RECORD,
    g_mse_t         RECORD                 #程式變數 (舊值)
        mse01       LIKE mse_file.mse01,  
        mse02       LIKE mse_file.mse02  
                    END RECORD,
     g_wc2,g_sql    STRING,                #No.FUN-580092 HCN    
    g_rec_b         LIKE type_file.num5,   #單身筆數              #No.FUN-680082 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT   #No.FUN-680082 SMALLINT
  # l_sl            SMALLINT               #目前處理的SCREEN LINE
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE #No.FUN-680082 SMALLINT
 
DEFINE g_forupd_sql          STRING                  #SELECT ... FOR UPDATE SQL   
DEFINE g_cnt                 LIKE type_file.num10    #No.FUN-680082 INTEGER 
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose #No.FUN-680082 SMALLINT
DEFINE g_before_input_done   STRING                  #No.FUN-570110
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0076
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680082 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET p_row = 3 LET p_col = 16
    OPEN WINDOW i504_w AT p_row,p_col WITH FORM "amr/42f/amri504"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i504_b_fill(g_wc2)
    CALL i504_menu()
    CLOSE WINDOW i504_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
 
FUNCTION i504_menu()
   WHILE TRUE
      CALL i504_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i504_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i504_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i504_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_mse),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i504_q()
   CALL i504_b_askkey()
END FUNCTION
 
FUNCTION i504_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680082 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680082 SMALLINT 
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680082 VARCHAR(1)
  # l_allow_insert  VARCHAR(01),                #可新增否
    l_allow_insert  LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
  # l_allow_delete  VARCHAR(01)                 #可刪除否
    l_allow_delete  LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
   
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT mse01,mse02 FROM mse_file  ",
                       " WHERE mse01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i504_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_mse WITHOUT DEFAULTS FROM s_mse.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
            #IF g_mse_t.mse01 IS NOT NULL THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_mse_t.* = g_mse[l_ac].*  #BACKUP
#No.FUN-570110  --start                                                                                                             
                LET g_before_input_done = FALSE                                                                                     
                CALL i504_set_entry(p_cmd)                                                                                          
                CALL i504_set_no_entry(p_cmd)                                                                                       
                LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110  --end                  
           OPEN i504_bcl USING g_mse_t.mse01
                IF STATUS THEN
                   CALL cl_err("OPEN i504_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i504_bcl INTO g_mse[l_ac].* 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_mse_t.mse01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110  --start                                                                                                             
            LET g_before_input_done = FALSE                                                                                     
            CALL i504_set_entry(p_cmd)                                                                                          
            CALL i504_set_no_entry(p_cmd)                                                                                       
            LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110  --end                  
            INITIALIZE g_mse[l_ac].* TO NULL      #900423
            LET g_mse_t.* = g_mse[l_ac].*         #新輸入資料
            DISPLAY g_mse[l_ac].* TO s_mse[l_sl].* 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD mse01
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
              CLOSE i504_bcl
#              CALL g_mse.deleteElement(l_ac)
#             IF g_rec_b != 0 THEN
#                LET g_action_choice = "detail"
#                LET l_ac = l_ac_t
#             END IF
#             EXIT INPUT
           END IF
           INSERT INTO mse_file(mse01,mse02)
           VALUES(g_mse[l_ac].mse01,g_mse[l_ac].mse02)
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_mse[l_ac].mse01,SQLCA.sqlcode,0) #No.FUN-660107
               CALL cl_err3("ins","mse_file",g_mse[l_ac].mse01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD mse01                        #check 編號是否重複
            IF g_mse[l_ac].mse01 != g_mse_t.mse01 OR
               (g_mse[l_ac].mse01 IS NOT NULL AND g_mse_t.mse01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM mse_file
                    WHERE mse01 = g_mse[l_ac].mse01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_mse[l_ac].mse01 = g_mse_t.mse01
                    NEXT FIELD mse01
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_mse_t.mse01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM mse_file WHERE mse01 = g_mse_t.mse01
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_mse_t.mse01,SQLCA.sqlcode,0) #No.FUN-660107
                     CALL cl_err3("del","mse_file",g_mse_t.mse01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i504_bcl
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mse[l_ac].* = g_mse_t.*
            CLOSE i504_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mse[l_ac].mse01,-263,1)
            LET g_mse[l_ac].* = g_mse_t.*
         ELSE
            UPDATE mse_file SET mse01=g_mse[l_ac].mse01,
                                mse02=g_mse[l_ac].mse02
             WHERE CURRENT OF i504_bcl
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_mse[l_ac].mse01,SQLCA.sqlcode,0) #No.FUN-660107
                CALL cl_err3("upd","mse_file",g_mse[l_ac].mse01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
               LET g_mse[l_ac].* = g_mse_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i504_bcl
               COMMIT WORK
            END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_mse[l_ac].* = g_mse_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_mse.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i504_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i504_bcl
            COMMIT WORK
 
 
#       ON ACTION CONTROLN
#           CALL i504_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mse01) AND l_ac > 1 THEN
                LET g_mse[l_ac].* = g_mse[l_ac-1].*
                DISPLAY g_mse[l_ac].* TO s_mse[l_sl].* 
                NEXT FIELD mse01
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
 
    CLOSE i504_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i504_b_askkey()
    CLEAR FORM
    CALL g_mse.clear()
 
    CONSTRUCT g_wc2 ON mse01,mse02
            FROM s_mse[1].mse01,s_mse[1].mse02 
 
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
    CALL i504_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i504_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000    #No.FUN-680082 VARCHAR(200) 
 
    LET g_sql =
        "SELECT mse01,mse02,''",
        " FROM mse_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i504_pb FROM g_sql
    DECLARE mse_curs CURSOR FOR i504_pb
 
    FOR g_cnt = 1 TO g_mse.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_mse[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH mse_curs INTO g_mse[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    MESSAGE ""
    CALL g_mse.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i504_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680082 VARCHAR(1)
 
 
  #IF p_ud <> "G" THEN   #TQC-D40025 Mark
   IF p_ud <> "G" OR g_action_choice ="detail" THEN   #TQC-D40025 Add
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mse TO s_mse.*
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_sl = SCR_LINE()
 
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
 
 
      #FUN-4B0013
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
 
#NO.FUN-7C0043 --BEGIN MARK--
FUNCTION i504_out()
#   DEFINE
#       l_mse           RECORD LIKE mse_file.*,
#       l_i             LIKE type_file.num5,     #No.FUN-680082 SMALLINT
#     # l_name          VARCHAR(20),                # External(Disk) file name
#       l_name          LIKE type_file.chr20,    #No.FUN-680082  VARCHAR(20) 
#     # l_za05          VARCHAR(40)                 #
#       l_za05          LIKE type_file.chr1000   #No.FUN-680082  VARCHAR(40) 
 DEFINE   l_cmd      LIKE type_file.chr1000   #NO.FUN-7C0043                                                                        
   #NO.FUN-7C0043 --BEGIN-- 
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN END IF                                                                                       
    LET l_cmd = 'p_query "amri504" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN                                                                                                                          
   #NO.FUN-7C0043 --END--                         
#   IF g_wc2 IS NULL THEN
##      CALL cl_err('',-400,0) RETURN END IF
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   #LET l_name = 'amri504.out'
#   CALL cl_outnam('amri504') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM mse_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i504_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i504_co                         # SCROLL CURSOR
#       CURSOR FOR i504_p1
 
#   START REPORT i504_rep TO l_name
 
#   FOREACH i504_co INTO l_mse.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i504_rep(l_mse.*)
#   END FOREACH
 
#   FINISH REPORT i504_rep
 
#   CLOSE i504_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#
#REPORT i504_rep(sr)
#   DEFINE
#     # l_trailer_sw    VARCHAR(1),
#       l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)  
#       sr RECORD LIKE mse_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.mse01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED     #No.TQC-6A0080
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED     #No.TQC-6A0080 
##           PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company         #No.TQC-6A0080 
##           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                #No.TQC-6A0080 
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.mse01,
#                 COLUMN g_c[32],sr.mse02 
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043 --END MARK--
 
#No.FUN-570110   --start                                                                                                            
FUNCTION i504_set_entry(p_cmd)                                                                                                      
DEFINE   p_cmd   LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' and (NOT g_before_input_done) THEN                                                                                
     CALL cl_set_comp_entry("mse01",TRUE)                                                                                           
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i504_set_no_entry(p_cmd)                                                                                                   
DEFINE   p_cmd   LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("mse01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570110   --end    
