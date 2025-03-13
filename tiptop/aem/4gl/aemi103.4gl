# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aemi103.4gl
# Descriptions...: 設備類型維護作業
# Date & Author..: 04/07/08 by day 
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: 
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/09 By Carrier 打印字段后加CLIPPED
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760085 07/07/09 By sherry  報表改由Crystal Rrport輸出
# Modify.........: No.FUN-890129 08/12/30 By lilingyu mark cl_outname()
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_fic           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fic01       LIKE fic_file.fic01,   
        fic02       LIKE fic_file.fic02,  
        fic03       LIKE fic_file.fic03 
                    END RECORD,
    g_fic_t         RECORD                 #程式變數 (舊值)
        fic01       LIKE fic_file.fic01,   
        fic02       LIKE fic_file.fic02,  
        fic03       LIKE fic_file.fic03
                    END RECORD,
    #g_wc2,g_sql    VARCHAR(300),#TQC-630166
    g_wc2,g_sql     STRING,   #TQC-630166
    g_str           STRING,   #No.FUN-760085  
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680072 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
    p_row,p_col     LIKE type_file.num5                                             #No.FUN-680072 SMALLINT
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680072 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110         #No.FUN-680072 SMALLINT
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
    OPEN WINDOW i103_w AT p_row,p_col WITH FORM "aem/42f/aemi103"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i103_b_fill(g_wc2)
    CALL i103_menu()
    CLOSE WINDOW i103_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN                                               
                  CALL g_fic.deleteElement(1)                                   
               END IF     
               CALL i103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i103_out() 
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
 
FUNCTION i103_q()
   CALL i103_b_askkey()
END FUNCTION
 
FUNCTION i103_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用          #No.FUN-680072 SMALLINT
    l_lfic_sw       LIKE type_file.chr1,                          #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態            #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否            #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否            #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fic01,fic02,fic03 FROM fic_file WHERE fic01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_fic WITHOUT DEFAULTS FROM s_fic.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lfic_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_fic_t.* = g_fic[l_ac].*  #BACKUP
 
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i103_set_entry_b(p_cmd)                                                                                         
               CALL i103_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--  
               BEGIN WORK
 
               OPEN i103_bcl USING g_fic_t.fic01
               IF STATUS THEN
                  CALL cl_err("OPEN i103_bcl:", STATUS, 1)
                  LET l_lfic_sw = "Y"
               ELSE  
                  FETCH i103_bcl INTO g_fic[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fic_t.fic01,SQLCA.sqlcode,1)
                     LET l_lfic_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT              
            LET l_n = ARR_COUNT()                                               
            LET p_cmd='a'                                                       
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i103_set_entry_b(p_cmd)                                                                                         
            CALL i103_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--  
            INITIALIZE g_fic[l_ac].* TO NULL      #900423                       
            LET g_fic_t.* = g_fic[l_ac].*         #新輸入資料                   
            LET g_fic[l_ac].fic03='Y'                                           
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fic01       
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fic_file(fic01,fic02,fic03)
                          VALUES(g_fic[l_ac].fic01,g_fic[l_ac].fic02,
                                 g_fic[l_ac].fic03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fic[l_ac].fic01,SQLCA.sqlcode,0)   #No.FUN-660092
               CALL cl_err3("ins","fic_file",g_fic[l_ac].fic01,g_fic[l_ac].fic02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
        
 
 
        AFTER FIELD fic01                        #check 編號是否重複
            IF NOT cl_null(g_fic[l_ac].fic01) THEN
               IF g_fic[l_ac].fic01 != g_fic_t.fic01 OR
                  g_fic_t.fic01 IS NULL THEN
 
                   SELECT count(*) INTO l_n FROM fic_file
                       WHERE fic01 = g_fic[l_ac].fic01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fic[l_ac].fic01 = g_fic_t.fic01
                       NEXT FIELD fic01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fic_t.fic01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lfic_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM fic_file 
                      WHERE fic01 = g_fic_t.fic01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fic_t.fic01,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("del","fic_file",g_fic_t.fic01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
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
               LET g_fic[l_ac].* = g_fic_t.*
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lfic_sw = 'Y' THEN
               CALL cl_err(g_fic[l_ac].fic01,-263,1)
               LET g_fic[l_ac].* = g_fic_t.*
            ELSE
               UPDATE fic_file SET
                      fic01  = g_fic[l_ac].fic01,
                      fic02  = g_fic[l_ac].fic02,
                      fic03  = g_fic[l_ac].fic03
                WHERE fic01 = g_fic_t.fic01 
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fic[l_ac].fic01,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("upd","fic_file",g_fic_t.fic01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   LET g_fic[l_ac].* = g_fic_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW blfic
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fic[l_ac].* = g_fic_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fic.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i103_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i103_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fic01) AND l_ac > 1 THEN
                LET g_fic[l_ac].* = g_fic[l_ac-1].*
                NEXT FIELD fic01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913               
        
 
        ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i103_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_b_askkey()
    CLEAR FORM
    CALL g_fic.clear()
    CONSTRUCT g_wc2 ON fic01,fic02,fic03
            FROM s_fic[1].fic01,s_fic[1].fic02,s_fic[1].fic03 
 
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
    CALL i103_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    #p_wc2            VARCHAR(200)   #TQC-630166   
    p_wc2            STRING   #TQC-630166      
 
    LET g_sql =
        "SELECT fic01,fic02,fic03",
        " FROM fic_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY fic01"
    PREPARE i103_pb FROM g_sql
    DECLARE fic_curs CURSOR FOR i103_pb
 
    CALL g_fic.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH fic_curs INTO g_fic[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_fic.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fic TO s_fic.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i103_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680072 VARCHAR(20)
        l_fic           RECORD LIKE fic_file.*,
        l_za05          LIKE type_file.chr1000,       #No.FUN-680072 VARCHAR(40)
        l_chr           LIKE type_file.chr1           #No.FUN-680072 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#    CALL cl_outnam('aemi103') RETURNING l_name  #FUN-890129
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-760085---Begin
    LET g_sql="SELECT * FROM fic_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
#   PREPARE i103_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i103_co CURSOR FOR i103_p1
 
#   START REPORT i103_rep TO l_name
 
#   FOREACH i103_co INTO l_fic.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#          EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i103_rep(l_fic.*)
#   END FOREACH
 
#   FINISH REPORT i103_rep
 
#   CLOSE i103_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
 
    IF g_zz05 = 'Y' THEN     
       CALL cl_wcchp(g_wc2,'fic01,fic02,fic03')                         
       RETURNING g_wc2      
       #LET g_str = g_str CLIPPED,";", g_wc2 
    END IF 
    LET g_str =  g_wc2 
    CALL cl_prt_cs1('aemi103','aemi103',g_sql,g_str)                            
#No.FUN-760085---End                                       
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i103_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680072 VARCHAR(1)
        sr              RECORD LIKE fic_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fic01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED             
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<', "/pageno"                    
            PRINT g_head CLIPPED, pageno_total                                  
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1, g_x[1] CLIPPED  #No.TQC-6A0093
            PRINT
            PRINT g_dash[1,g_len]    
            PRINT g_x[31], g_x[32], g_x[33]                                              
            PRINT g_dash1
            LET l_trailer_sw = 'y'
  
        ON EVERY ROW
            IF sr.fic03 = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN g_c[31],sr.fic01,
                  COLUMN g_c[32], sr.fic02,
                  COLUMN g_c[33], sr.fic03 
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'fic01,fic02,fic03')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
	       #	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
	       #               PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_sql)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.TQC-6A0093
          PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   #No.TQC-6A0093
            ELSE
                SKIP 2 LINE
            END IF
 
END REPORT
}
#No.FUN-760085---End
#No.FUN-570110 --start--                                                                                                            
FUNCTION i103_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                                     #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("fic01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i103_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                                     #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("fic01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--   
