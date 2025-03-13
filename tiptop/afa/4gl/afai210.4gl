# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: afai210.4gl
# Descriptions...: 校定項目維護作業
# Date & Author..: 00/03/17 By Iceman 
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-570199 05/08/03 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.TQC-650018 06/05/09 By Smapmin 修改報表名稱
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-770005 07/07/03 By hongmei 報表格式修改為Crystal Report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_fgd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fgd01       LIKE fgd_file.fgd01,       #校定代號 
        fgd02       LIKE fgd_file.fgd02,       #項目名稱
        fgdacti     LIKE fgd_file.fgdacti      #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_fgd_t         RECORD                     #程式變數 (舊值)
        fgd01       LIKE fgd_file.fgd01,       #校定代號 
        fgd02       LIKE fgd_file.fgd02,       #項目名稱
        fgdacti     LIKE fgd_file.fgdacti      #No.FUN-680070 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql     STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數                      #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT           #No.FUN-680070 SMALLINT
 
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680070 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose   #No.FUN-680070 SMALLINT
DEFINE g_before_input_done    LIKE type_file.num5     #No.FUN-570108          #No.FUN-680070 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0069
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time                  #No.FUN-6A0069
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i210_w AT p_row,p_col WITH FORM "afa/42f/afai210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i210_b_fill(g_wc2)
    CALL i210_menu()
    CLOSE WINDOW i210_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time                  #No.FUN-6A0069
END MAIN
 
FUNCTION i210_menu()
 
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
               CALL i210_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_fgd[l_ac].fgd01 IS NOT NULL THEN
                  LET g_doc.column1 = "fgd01"
                  LET g_doc.value1 = g_fgd[l_ac].fgd01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fgd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i210_q()
   CALL i210_b_askkey()
END FUNCTION
 
FUNCTION i210_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #可新增否          #No.FUN-680070 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                  #可刪除否          #No.FUN-680070 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')     
    LET l_allow_delete = cl_detail_input_auth('delete')     
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fgd.clear() END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fgd01,fgd02,fgdacti FROM fgd_file WHERE fgd01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_fgd
            WITHOUT DEFAULTS
            FROM s_fgd.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)        
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_fgd_t.* = g_fgd[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_fgd_t.fgd01 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fgd_t.* = g_fgd[l_ac].*  #BACKUP
#No.FUN-570108 --start--                                                        
                LET g_before_input_done = FALSE                                 
                CALL i210_set_entry(p_cmd)                                      
                CALL i210_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end--           
 
                BEGIN WORK
                OPEN i210_bcl USING g_fgd_t.fgd01
                IF STATUS THEN
                   CALL cl_err("OPEN i210_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"  
                ELSE
                   FETCH i210_bcl INTO g_fgd[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fgd_t.fgd01,SQLCA.sqlcode,0)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
        #   NEXT FIELD fgd01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start--                                                        
            LET g_before_input_done = FALSE                                     
            CALL i210_set_entry(p_cmd)                                          
            CALL i210_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end--                   
                INITIALIZE g_fgd[l_ac].* TO NULL      #900423
                LET g_fgd[l_ac].fgdacti = 'Y'         #Body default
            LET g_fgd_t.* = g_fgd[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fgd01
 
        AFTER INSERT  
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fgd[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fgd[l_ac].* TO s_fgd.*
              CALL g_fgd.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO fgd_file(fgd01,fgd02,fgdacti,fgduser,fgddate,fgdoriu,fgdorig)
                   VALUES(g_fgd[l_ac].fgd01,g_fgd[l_ac].fgd02,
			  g_fgd[l_ac].fgdacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fgd[l_ac].fgd01,SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fgd_file",g_fgd[l_ac].fgd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
              #LET g_fgd[l_ac].* = g_fgd_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE FIELD fgd02                       
            IF g_fgd[l_ac].fgd01 != g_fgd_t.fgd01 OR  #check 編號是否重複
               (g_fgd[l_ac].fgd01 IS NOT NULL AND g_fgd_t.fgd01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM fgd_file
                    WHERE fgd01 = g_fgd[l_ac].fgd01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fgd[l_ac].fgd01 = g_fgd_t.fgd01
                    NEXT FIELD fgd01
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fgd_t.fgd01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "fgd01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_fgd[l_ac].fgd01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
{ckp#1}         DELETE FROM fgd_file WHERE fgd01 = g_fgd_t.fgd01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fgd_t.fgd01,SQLCA.sqlcode,0)     #No.FUN-660136
                   CALL cl_err3("del","fgd_file",g_fgd_t.fgd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"      
                CLOSE i210_bcl          
                COMMIT WORK
            END IF
 
        ON ROW CHANGE   
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_fgd[l_ac].* = g_fgd_t.*
              CLOSE i210_bcl     
              ROLLBACK WORK       
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN        
              CALL cl_err(g_fgd[l_ac].fgd01,-263,1)    
              LET g_fgd[l_ac].* = g_fgd_t.*                                      
           ELSE     
               UPDATE fgd_file SET
                      fgd01=g_fgd[l_ac].fgd01,fgd02=g_fgd[l_ac].fgd02,
                      fgdacti=g_fgd[l_ac].fgdacti,fgdmodu=g_user,
                      fgddate=g_today
                WHERE fgd01=g_fgd_t.fgd01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fgd[l_ac].fgd01,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","fgd_file",g_fgd_t.fgd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                LET g_fgd[l_ac].* = g_fgd_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i210_bcl
                COMMIT WORK
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR() 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_fgd[l_ac].* = g_fgd_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_fgd.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE i210_bcl                                                   
              ROLLBACK WORK                                                    
              EXIT INPUT
           END IF
         # LET g_fgd_t.* = g_fgd[l_ac].*  
           LET l_ac_t = l_ac                                                   
           CLOSE i210_bcl                                                      
           COMMIT WORK                  
           #CKP2
           CALL g_fgd.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLN
            CALL i210_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fgd01) AND l_ac > 1 THEN
                LET g_fgd[l_ac].* = g_fgd[l_ac-1].*
                LET g_fgd[l_ac].fgd01 = '    '            
                LET g_fgd[l_ac].fgdacti = 'Y'               
                NEXT FIELD fgd01
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
 
FUNCTION i210_b_askkey()
    CLEAR FORM
   CALL g_fgd.clear()
    CONSTRUCT g_wc2 ON fgd01,fgd02,fgdacti
            FROM s_fgd[1].fgd01,s_fgd[1].fgd02,
				 s_fgd[1].fgdacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('fgduser', 'fgdgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i210_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i210_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fgd01,fgd02,fgdacti",
        " FROM fgd_file",
        " WHERE ", p_wc2 CLIPPED,     #單身
        " ORDER BY 1"
    PREPARE i210_pb FROM g_sql
    DECLARE fgd_curs CURSOR FOR i210_pb
 
    FOR g_cnt = 1 TO g_fgd.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_fgd[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH fgd_curs INTO g_fgd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    MESSAGE ""
    CALL g_fgd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fgd TO s_fgd.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
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
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
   
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i210_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,               #       #No.FUN-680070 VARCHAR(40)
        sr    RECORD LIKE fgd_file.*
   
    IF g_wc2 IS NULL THEN 
 #     CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('afai210') RETURNING l_name   #TQC-650018
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * ",   #組合出 SQL 指令
              "  FROM fgd_file ",        
              " WHERE ",g_wc2 CLIPPED
#No.FUN-770005------Begin 
#   PREPARE i210_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i210_co                         # SCROLL CURSOR
#        CURSOR FOR i210_p1
 
#   START REPORT i210_rep TO l_name
 
#   FOREACH i210_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,0)  
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i210_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i210_rep
 
#   CLOSE i210_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc2,'fgd01,fgd02,fgdacti')                                 
       RETURNING g_wc2                                                          
    END IF
    CALL cl_prt_cs1('afai210','afai210',g_sql,g_wc2)
#No.FUN-770005------End
END FUNCTION
 
#No.FUN-770005------Begin
{
REPORT i210_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        sr   RECORD LIKE fgd_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fgd01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.fgdacti = 'N' THEN PRINT COLUMN g_c[31],'*' END IF
            PRINT COLUMN g_c[31],sr.fgd01,
                  COLUMN g_c[32],sr.fgd02
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-15), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-15), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-770005------End
 
#No.FUN-570108 --start--                                                        
FUNCTION i210_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("fgd01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i210_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                                #No.FUN-680070 VARCHAR(01)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("fgd01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--              
