# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aooi160.4gl
# Descriptions...: 交運方式維護作業
# Date & Author..: 96/05/30 By Kitty (新增程式)
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-51002705/01/14 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/06/29 By mike 報表格式修改為p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ged           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ged01       LIKE ged_file.ged01,  
        ged02       LIKE ged_file.ged02 
                    END RECORD,
    g_ged_t         RECORD                 #程式變數 (舊值)
        ged01       LIKE ged_file.ged01,  
        ged02       LIKE ged_file.ged02 
                    END RECORD,
#    g_wc2,g_sql    VARCHAR(300),  #NO.TQC-630166 MARK 
    g_wc2,g_sql     STRING,   #NO.TQC-630166        
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110          #No.FUN-680102 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 4 LET p_col = 32
    OPEN WINDOW i160_w AT p_row,p_col WITH FORM "aoo/42f/aooi160"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i160_b_fill(g_wc2)
    CALL i160_menu()
    CLOSE WINDOW i160_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
END MAIN
 
FUNCTION i160_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                         #No.FUN-780056  
 
   WHILE TRUE
      CALL i160_bp("G")
 
      CASE g_action_choice
           WHEN "query"     
              IF cl_chk_act_auth() THEN
                 CALL i160_q() 
              END IF
           WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL i160_b() 
             ELSE
                LET g_action_choice = NULL
             END IF
           WHEN "output"    
              IF cl_chk_act_auth() THEN
                 #CALL i160_out()                                              #No.FUN-780056 
                 IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF                 #No.FUN-780056
                 LET l_cmd='p_query "aooi160" "',g_wc2 CLIPPED,'"'             #No.FUN-780056  
                 CALL cl_cmdrun(l_cmd)                                        #No.FUN-780056  
              END IF
           WHEN "help"      CALL cl_show_help()
           WHEN "exit"      EXIT WHILE
           WHEN "controlg"  CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_ged[l_ac].ged01 IS NOT NULL THEN
                  LET g_doc.column1 = "ged01"
                  LET g_doc.value1 = g_ged[l_ac].ged01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ged),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
 
FUNCTION i160_q()
   CALL i160_b_askkey()
END FUNCTION
 
FUNCTION i160_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102     VARCHAR(1)          #可新增否
    l_allow_delete  LIKE type_file.chr1            #No.FUN-680102      VARCHAR(1)         #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ged01,ged02 FROM ged_file WHERE ged01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i160_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
   #TQC-630106-begin
   #INPUT ARRAY g_ged WITHOUT DEFAULTS FROM s_ged.*
    INPUT ARRAY g_ged WITHOUT DEFAULTS FROM s_ged.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED)
   #TQC-630106-end
            
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd='' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
#No.FUN-570110 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i160_set_entry(p_cmd)                                      
                CALL i160_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570110 --end     
                LET g_ged_t.* = g_ged[l_ac].*  #BACKUP
                OPEN i160_bcl USING g_ged_t.ged01
                IF STATUS THEN
                   CALL cl_err("OPEN i160_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i160_bcl INTO g_ged[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ged_t.ged01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF 
                IF l_lock_sw = 'Y' THEN     # 新增此段
                   CLOSE i160_bcl
                   ROLLBACK WORK
                   IF l_ac = 1 THEN
                      CALL FGL_SET_ARR_CURR(2)
                   ELSE
                      CALL FGL_SET_ARR_CURR(l_ac_t)
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i160_set_entry(p_cmd)                                          
            CALL i160_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570110 --end         
            INITIALIZE g_ged[l_ac].* TO NULL      #900423
            LET g_ged_t.* = g_ged[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ged01
 
        AFTER INSERT
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE i160_bcl
               CANCEL INSERT
            END IF
            INSERT INTO ged_file(ged01,ged02)
                          VALUES(g_ged[l_ac].ged01,g_ged[l_ac].ged02)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ged[l_ac].ged01,SQLCA.sqlcode,0)   #No.FUN-660131
               CALL cl_err3("ins","ged_file",g_ged[l_ac].ged01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD ged01                        #check 編號是否重複
            IF NOT cl_null(g_ged[l_ac].ged01) THEN
               IF g_ged[l_ac].ged01 != g_ged_t.ged01 OR
                  g_ged_t.ged01 IS NULL THEN
                  SELECT count(*) INTO l_n FROM ged_file
                   WHERE ged01 = g_ged[l_ac].ged01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_ged[l_ac].ged01 = g_ged_t.ged01
                     NEXT FIELD ged01
                  END IF
               END IF 
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ged_t.ged01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "ged01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_ged[l_ac].ged01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ged_file WHERE ged01 = g_ged_t.ged01
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ged_t.ged01,SQLCA.sqlcode,0)   #No.FUN-660131
                    CALL cl_err3("del","ged_file",g_ged_t.ged01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    LET l_ac_t = l_ac
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
              LET g_ged[l_ac].* = g_ged_t.*
              CLOSE i160_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ged[l_ac].ged01,-263,1)
              LET g_ged[l_ac].* = g_ged_t.*
           ELSE
              UPDATE ged_file SET ged01=g_ged[l_ac].ged01,
                                  ged02=g_ged[l_ac].ged02
               WHERE ged01 = g_ged_t.ged01
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ged[l_ac].ged01,SQLCA.sqlcode,0)   #No.FUN-660131
                  CALL cl_err3("upd","ged_file",g_ged_t.ged01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  LET g_ged[l_ac].* = g_ged_t.*
                  ROLLBACK WORK
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()         # 新增
           #LET l_ac_t = l_ac             #FUN-D40030 Mark
 
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_ged[l_ac].* = g_ged_t.*
                #FUN-D40030--add--str--
                ELSE
                   CALL g_ged.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D40030--add--end--
                END IF
                CLOSE i160_bcl
                ROLLBACK WORK 
                EXIT INPUT
            END IF
            LET l_ac_t = l_ac             #FUN-D40030 Add
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i160_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ged01) AND l_ac > 1 THEN
               LET g_ged[l_ac].* = g_ged[l_ac-1].*
               NEXT FIELD ged01
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
 
    CLOSE i160_bcl
    COMMIT WORK
 
 
END FUNCTION
 
FUNCTION i160_b_askkey()
 
    CLEAR FORM
   CALL g_ged.clear()
 
    CONSTRUCT g_wc2 ON ged01,ged02
         FROM s_ged[1].ged01,s_ged[1].ged02
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
 
    CALL i160_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i160_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT ged01,ged02  FROM ged_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i160_pb FROM g_sql
    DECLARE ged_curs CURSOR FOR i160_pb
 
    CALL g_ged.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ged_curs INTO g_ged[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ged.deleteElement(g_cnt)
 
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i160_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ged TO s_ged.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i160_out()
    DEFINE
        l_ged           RECORD LIKE ged_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE za_file.za05             #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
#   LET l_name = 'aooi160.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ged_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i160_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i160_co                         # SCROLL CURSOR
         CURSOR FOR i160_p1
 
    CALL cl_outnam('aooi160') RETURNING l_name
    START REPORT i160_rep TO l_name
 
    FOREACH i160_co INTO l_ged.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i160_rep(l_ged.*)
    END FOREACH
 
    FINISH REPORT i160_rep
 
    CLOSE i160_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i160_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
        sr RECORD LIKE ged_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ged01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.ged01,
                  COLUMN g_c[32],sr.ged02
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
#NO.TQC-630166 start--
#                    IF g_wc2[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_wc2[001,070] CLIPPED END IF
#                 #  IF g_wc[071,140] > ' ' THEN
#		 #     PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                 #  IF g_wc[141,210] > ' ' THEN
#		 #     PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                 CALL cl_prt_pos_wc(g_wc2)
#NO.TQC-630166 end--
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056-end
 
#No.FUN-570110 --start                                                          
FUNCTION i160_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("ged01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i160_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("ged01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end                                                            
                        
