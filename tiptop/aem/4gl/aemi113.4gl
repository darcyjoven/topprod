# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aemi113.4gl
# Descriptions...: 設備類型維護作業
# Date & Author..: 04/07/13 by marsong 
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法 
# Modify.........: 
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/23 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/09 By Carrier 打印字段后加CLIPPED
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_fje           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fje01       LIKE fje_file.fje01,   
        fje02       LIKE fje_file.fje02,  
        fje03       LIKE fje_file.fje03 
                    END RECORD,
    g_fje_t         RECORD                 #程式變數 (舊值)
        fje01       LIKE fje_file.fje01,   
        fje02       LIKE fje_file.fje02,  
        fje03       LIKE fje_file.fje03
                    END RECORD,
    #g_wc2,g_sql    VARCHAR(300),   #TQC-630166
    g_wc2,g_sql     STRING,      #TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680072 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
    p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680072 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110         #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
    LET p_row = 4 LET p_col = 2 
    OPEN WINDOW i113_w AT p_row,p_col WITH FORM "aem/42f/aemi113"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i113_b_fill(g_wc2)
    CALL i113_menu()
    CLOSE WINDOW i113_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
FUNCTION i113_menu()
 
   WHILE TRUE
      CALL i113_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i113_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN                                               
                  CALL g_fje.deleteElement(1)                                   
               END IF     
               CALL i113_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
            #No.FUN-780037---Begin            
            #  CALL i113_out() 
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
               LET l_cmd = 'p_query "aemi113" "',g_wc2 CLIPPED,'"' 
               CALL cl_cmdrun(l_cmd)   
            #No.FUN-780037---End    
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i113_q()
   CALL i113_b_askkey()
END FUNCTION
 
FUNCTION i113_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680072 SMALLINT
    l_lfje_sw       LIKE type_file.chr1,                      #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fje01,fje02,fje03 FROM fje_file WHERE fje01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i113_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_fje WITHOUT DEFAULTS FROM s_fje.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lfje_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_fje_t.* = g_fje[l_ac].*  #BACKUP
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i113_set_entry_b(p_cmd)                                                                                         
               CALL i113_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--    
               BEGIN WORK
 
               OPEN i113_bcl USING g_fje_t.fje01
               IF STATUS THEN
                  CALL cl_err("OPEN i113_bcl:", STATUS, 1)
                  LET l_lfje_sw = "Y"
               ELSE  
                  FETCH i113_bcl INTO g_fje[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fje_t.fje01,SQLCA.sqlcode,1)
                     LET l_lfje_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT              
            LET l_n = ARR_COUNT()                                               
            LET p_cmd='a'                                                       
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i113_set_entry_b(p_cmd)                                                                                         
            CALL i113_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--    
            INITIALIZE g_fje[l_ac].* TO NULL      #900423                       
            LET g_fje_t.* = g_fje[l_ac].*         #新輸入資料                   
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fje01       
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fje_file(fje01,fje02,fje03)
                          VALUES(g_fje[l_ac].fje01,g_fje[l_ac].fje02,
                                 g_fje[l_ac].fje03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fje[l_ac].fje01,SQLCA.sqlcode,0)   #No.FUN-660092
               CALL cl_err3("ins","fje_file",g_fje[l_ac].fje01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
        
 
 
         AFTER FIELD fje01                        #check 編號是否重複
            IF NOT cl_null(g_fje[l_ac].fje01) THEN
               IF g_fje[l_ac].fje01 != g_fje_t.fje01 OR
                  g_fje_t.fje01 IS NULL THEN
 
                  SELECT count(*) INTO l_n FROM fje_file
                       WHERE fje01 = g_fje[l_ac].fje01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fje[l_ac].fje01 = g_fje_t.fje01
                       NEXT FIELD fje01
                   END IF
               END IF
            END IF
     
        BEFORE DELETE                            #是否取消單身
            IF g_fje_t.fje01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lfje_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM fje_file 
                      WHERE fje01 = g_fje_t.fje01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fje_t.fje01,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("del","fje_file",g_fje_t.fje01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1      
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fje[l_ac].* = g_fje_t.*
               CLOSE i113_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lfje_sw = 'Y' THEN
               CALL cl_err(g_fje[l_ac].fje01,-263,1)
               LET g_fje[l_ac].* = g_fje_t.*
            ELSE
               UPDATE fje_file SET
                      fje01  = g_fje[l_ac].fje01,
                      fje02  = g_fje[l_ac].fje02,
                      fje03  = g_fje[l_ac].fje03
                WHERE fje01 = g_fje_t.fje01 
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fje[l_ac].fje01,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("upd","fje_file",g_fje[l_ac].fje01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   LET g_fje[l_ac].* = g_fje_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW blfje
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fje[l_ac].* = g_fje_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fje.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i113_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i113_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i113_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fje01) AND l_ac > 1 THEN
                LET g_fje[l_ac].* = g_fje[l_ac-1].*
                NEXT FIELD fje01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
 #No.MOD-540141--begin 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913                  
 #No.MOD-540141--end  
 
        ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i113_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i113_b_askkey()
    CLEAR FORM
    CALL g_fje.clear()
    CONSTRUCT g_wc2 ON fje01,fje02,fje03
            FROM s_fje[1].fje01,s_fje[1].fje02,s_fje[1].fje03 
 
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
    CALL i113_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i113_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    #p_wc2           VARCHAR(200)#TQC-630166
     p_wc2           STRING   #TQC-630166
 
    LET g_sql =
        "SELECT fje01,fje02,fje03",
        " FROM fje_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY fje01"
    PREPARE i113_pb FROM g_sql
    DECLARE fje_curs CURSOR FOR i113_pb
 
    CALL g_fje.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH fje_curs INTO g_fje[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_fje.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i113_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fje TO s_fje.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION close                                                           
         LET g_action_choice="exit"                                             
         EXIT DISPLAY   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780037---Begin
{FUNCTION i113_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680072 VARCHAR(20)
        l_fje           RECORD LIKE fje_file.*,
        l_za05          LIKE type_file.chr1000,  #No.FUN-680072 VARCHAR(40)
        l_chr           LIKE type_file.chr1      #No.FUN-680072 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('aemi113') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM fje_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i113_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i113_co CURSOR FOR i113_p1
 
    START REPORT i113_rep TO l_name
 
    FOREACH i113_co INTO l_fje.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
           END IF
        OUTPUT TO REPORT i113_rep(l_fje.*)
    END FOREACH
 
    FINISH REPORT i113_rep
 
    CLOSE i113_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i113_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680072CHAR(1)
        sr RECORD LIKE fje_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fje01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED             
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<', "/pageno"                    
            PRINT g_head CLIPPED, pageno_total                                  
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1, g_x[1] CLIPPED  #No.TQC-6A0093
            PRINT g_dash[1,g_len]                                               
            PRINT g_x[31], g_x[32], g_x[33]                                     
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
    #       IF sr.fje03 = '1'  THEN PRINT 'Maintain' CLIPPED; END IF
    #       IF sr.fje03 = '2'  THEN PRINT 'Repair' CLIPPED; END IF
            PRINT COLUMN g_c[31],sr.fje01,
                  COLUMN g_c[32], sr.fje02,
                  COLUMN g_c[33], sr.fje03 
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'fje01,fje02,fje03')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
	       #	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_sql)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6A0093
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6A0093
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780037---End
#No.FUN-570110 --start--                                                                                                            
FUNCTION i113_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                  #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("fje01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i113_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                  #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("fje01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--  
