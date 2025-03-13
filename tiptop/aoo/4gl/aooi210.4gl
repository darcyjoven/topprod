# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aooi210.4gl
# Descriptions...: 報表抬頭資料維謢作業
# Date & Author..: 93/06/21 By  Felicity  Tseng
# Modify.........: No.MOD-480236 04/08/10 By Nicola 把列印程式段Remark
# Modify.........: No.MOD-470515 04/10/06 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制 
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-740021 07/04/05 By chenl 修正刪除單身最后一筆資料后，報無此筆資料的錯誤。
# Modify.........: No.FUN-780056 07/06/29 By mike 報表格式修改為p_query
# Modify.........: No.TQC-920045 09/02/17 By liuxqa 增加顯示單身筆數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_azh           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        azh01       LIKE azh_file.azh01,   
        azh02       LIKE azh_file.azh02
                    END RECORD,
    g_azh_t         RECORD                 #程式變數 (舊值)
        azh01       LIKE azh_file.azh01,  
        azh02       LIKE azh_file.azh02
                    END RECORD,
     g_wc,g_sql      STRING,  #No.FUN-580092 HCN  
    g_rec_b         LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110          #No.FUN-680102 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
 
MAIN
    OPTIONS                      
        INPUT NO WRAP
    DEFER INTERRUPT               
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
 
   OPEN WINDOW i210_w WITH FORM "aoo/42f/aooi210"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   LET g_wc = '1=1'  
   CALL i210_b_fill(g_wc)
   CALL i210_menu()
   CLOSE WINDOW i210_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
 
FUNCTION i210_menu()
 DEFINE l_cmd  LIKE type_file.chr1000                         #No.FUN-780056
   WHILE TRUE
      CALL i210_bp("G")
      CASE g_action_choice
         WHEN "query"    
            IF cl_chk_act_auth() THEN
               CALL i210_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i210_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"   
            IF cl_chk_act_auth() THEN
               #CALL i210_out()                                     #No.FUN-780056
               IF cl_null(g_wc) THEN LET g_wc='1=1' END IF          #No.FUN-780056
               LET  l_cmd='p_query "aooi210" "',g_wc CLIPPED,'"'    #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                                #No.FUN-780056
            END IF
         WHEN "help"     CALL cl_show_help()
         WHEN "exit"     EXIT WHILE
         WHEN "controlg" CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_azh[l_ac].azh01 IS NOT NULL THEN
                  LET g_doc.column1 = "azh01"
                  LET g_doc.value1 = g_azh[l_ac].azh01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i210_q()
    CLEAR FORM                             #清除畫面
   CALL g_azh.clear()
    CONSTRUCT g_wc ON azh01,azh02
        FROM s_azh[1].azh01,s_azh[1].azh02 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i210_b_fill(g_wc)             
END FUNCTION
 
 
FUNCTION i210_b_askkey()
    CLEAR FORM                             #清除畫面
   CALL g_azh.clear()
    CONSTRUCT g_wc ON azh01,azh02
        FROM s_azh[1].azh01,s_azh[1].azh02
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i210_b_fill(g_wc)
END FUNCTION
 
FUNCTION i210_b()
  DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102    VARCHAR(1)       #可新增否
    l_allow_delete  LIKE type_file.chr1            #No.FUN-680102    VARCHAR(1)            #可刪除否
 
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    LET g_action_choice = ""
 
 
    LET g_forupd_sql = " SELECT azh01,azh02 ",
                       "   FROM azh_file ",
                       "  WHERE azh01 = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_azh WITHOUT DEFAULTS FROM s_azh.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
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
                CALL i210_set_entry(p_cmd)                                      
                CALL i210_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570110 --end       
                LET g_azh_t.* = g_azh[l_ac].*  #BACKUP
 
                OPEN i210_bcl USING g_azh_t.azh01
                IF STATUS THEN
                    CALL cl_err("OPEN i210_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i210_bcl INTO g_azh[l_ac].* 
                    IF STATUS THEN
                        CALL cl_err(g_azh_t.azh01,status,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                IF l_lock_sw = "Y" THEN      # 新增此段
                   CLOSE i210_bcl
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
            INITIALIZE g_azh[l_ac].* TO NULL      #900423
#No.FUN-570110 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i210_set_entry(p_cmd)                                          
            CALL i210_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570110 --end              
            LET g_azh_t.* = g_azh[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD azh01
 
        AFTER FIELD azh01                        #check 序號是否重複
         IF g_azh[l_ac].azh01 IS NOT NULL THEN
            IF g_azh[l_ac].azh01 != g_azh_t.azh01 OR
               g_azh_t.azh01 IS NULL THEN
                SELECT count(*)
                  INTO l_n
                  FROM azh_file
                 WHERE azh01 = g_azh[l_ac].azh01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_azh[l_ac].azh01 = g_azh_t.azh01
                   NEXT FIELD azh01
                END IF
            END IF
         END IF
        BEFORE DELETE                            #是否取消單身
            IF g_azh_t.azh01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "azh01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_azh[l_ac].azh01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM azh_file 
                 WHERE azh01 = g_azh_t.azh01
                   AND azh02 = g_azh_t.azh02
                IF SQLCA.SQLERRD[3]=0 OR SQLCA.SQLCODE THEN
#                   CALL cl_err(g_azh_t.azh01,STATUS,0)   #No.FUN-660131
                    CALL cl_err3("del","azh_file",g_azh_t.azh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1   #No.TQC-740021
                DISPLAY g_rec_b TO FORMONLY.cn2     #No.TQC-920045 add by liuxqa 
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_azh[l_ac].* = g_azh_t.*
              CLOSE i210_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           UPDATE azh_file 
              SET azh01 = g_azh[l_ac].azh01,
                  azh02 = g_azh[l_ac].azh02
            WHERE azh01 = g_azh_t.azh01
           IF STATUS THEN
#              CALL cl_err(g_azh[l_ac].azh01,STATUS,0)   #No.FUN-660131
               CALL cl_err3("upd","azh_file",g_azh_t.azh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_azh[l_ac].* = g_azh_t.*
               ROLLBACK WORK
           ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_azh[l_ac].* = g_azh_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_azh.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i210_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           COMMIT WORK
 
        AFTER INSERT
            IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CLOSE i210_bcl
                CANCEL INSERT
            END IF
            INSERT INTO azh_file(azh01,azh02)
               VALUES(g_azh[l_ac].azh01,g_azh[l_ac].azh02)
            IF STATUS THEN
#               CALL cl_err(g_azh[l_ac].azh01,STATUS,0)   #No.FUN-660131
                CALL cl_err3("ins","azh_file",g_azh[l_ac].azh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                CANCEL INSERT
                ROLLBACK WORK
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ACTION CONTROLN
            CALL i210_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(azh01) AND l_ac > 1 THEN
                LET g_azh[l_ac].* = g_azh[l_ac-1].*
                DISPLAY g_azh[l_ac].* TO s_azh[l_ac].*
                NEXT FIELD azh01
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
 
    CLOSE i210_bcl
    COMMIT WORK 
END FUNCTION
   
FUNCTION i210_b_fill(p_wc2)  
DEFINE
    p_wc2           LIKE type_file.chr1000                  #No.FUN-680102CHAR(200)
    LET g_sql= "SELECT azh01,azh02 ",
               "  FROM azh_file ",
               "  WHERE ", p_wc2 CLIPPED,
               "  ORDER BY azh01"
    PREPARE i210_prepare FROM g_sql  
    DECLARE i210_curs               
        CURSOR FOR i210_prepare
 
    CALL g_azh.clear()
    LET g_cnt = 1
    FOREACH i210_curs INTO g_azh[g_cnt].*  #單身 ARRAY 填充
        IF STATUS THEN
            CALL cl_err('FOREACH:',STATUS,1)    
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_azh.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('FOREACH:',STATUS,1) END IF
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2   #No.TQC-920045 add by liuxqa
    LET g_cnt=0                       #No.TQC-920045 add by liuxqa 
END FUNCTION
 
FUNCTION i210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azh TO s_azh.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
#No.FUN-780056 --str
{ 
FUNCTION i210_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    sr              RECORD
        azh01       LIKE azh_file.azh01,   #目錄序號
        azh02       LIKE azh_file.azh02    #程式代號
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680102 VARCHAR(20)
    l_za05          LIKE za_file.za05                   #No.FUN-680102 VARCHAR(40)
 
    IF g_wc IS NULL THEN
     #  CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    LET l_name = 'i210.out'
    CALL cl_outnam('aooi210') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT azh01,azh02",
              " FROM azh_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE i210_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i210_curo                         # SCROLL CURSOR
         CURSOR FOR i210_p1
 
    START REPORT i210_rep TO l_name
 
    FOREACH i210_curo INTO sr.*
        IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)    
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i210_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i210_rep
 
    CLOSE i210_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i210_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
    sr              RECORD
        azh01       LIKE azh_file.azh01,   #目錄序號
        azh02       LIKE azh_file.azh02    #程式代號
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.azh01
 
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
            PRINT COLUMN g_c[31],sr.azh01,
                  COLUMN g_c[32],sr.azh02
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 -end
 
#No.FUN-570110 --start                                                          
FUNCTION i210_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("azh01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i210_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("azh01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end                   
